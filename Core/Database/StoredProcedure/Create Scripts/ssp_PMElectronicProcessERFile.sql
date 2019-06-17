
IF OBJECT_ID('ssp_PMElectronicProcessERFile', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[ssp_PMElectronicProcessERFile]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PMElectronicProcessERFile]
    @ERFileId INT ,
    @UserId INT
/*********************************************************************
-- Stored Procedure: dbo.ssp_PMElectronicProcessERFile
-- Creation Date:    11/1/08
--
-- Purpose:
--
-- Updates:
--   Date   Author  Purpose
-- History
03/26/2012   MSuma  Added the correct Process SP including additional validation
03/27/2012   MSuma  Intentionally commented Join in PatientId until we receive valid 835 Files from Javed
04/04/2012   MSuma  Revoked commened lines and modified Parsing Errors
12/04/2012   MSuma  Modified UserId to usercode in ERBatches
11/05/2012   MSuma  Element Delimiter modified from ERSenders
15/06/2012   MSuma  Included validation for Invalid Claims
25/10/2012	 TRemisoski changed from direct insert to a cursor to avoid data conversion error.
27/11/2012	 TRemisoski changed logic to only negate the check amount for "debit" checks when the amount is positive
19/03/2013	 TRemisoski added "isnumeric" check
16/04/2013	 TRemisoski Fixes for Segements that are loaded out of line number order
Remove segments that offset each other before posting.
29/07/2013   TRemisoski Default @MaxSegment to zero for first run
11/08/2013   TRemisoski use CLP segment to find claim line item id when the 835 does not pass it in the ref segment
2/4/2014     PRaorane   BCBS 835 format is slightly different. The segment delimiter is '~/r/n' instead of '~'. Therefore,
the line numbers are odd as every even number row is blank. To make up for this I changed Tom's fix for segments
to use row number instead of Line Number. In this way the query should work for all 835 formats (including BCBS).
11/08/2013   Venkatesh MR Added condition "JOIN @835Batch z ON a.ERBatchId = z.BatchNumber" as per the task 1434 CoreBugs
12/03/2015   Dknewtson  Removing Claim Line Item Id from process if the patient control number is incorrect
12/06/2015   Dknewtson  Modified "Claim Line Missing" Validation to reflect the above change (Removed where Patient Control Number is incorrect)
08/09/2016	 TRemisoski Added ERFIleSegment parsing that was removed from the web application
08/16/2016	 TRemisoski Only get delimeters from file if any one is not defined in the ERSenders table
08/26/2016	 NJain		Added logic to post from Paper Claims 
						Added logic to get LineItemControlNumber when SVC segment is not present in the 835
						(overwritten in previous updates)
						Added check for decimal when converting LineItemControlNumber to ClaimLineItemId (AND LineItemControlNumber NOT LIKE '%.%')
08/30/2016	 NJain		If Segment count > 20, don't error out, continue processing (overwritten in previous updates)
						Added David K's logic for -- Remove the ClaimLineItemId when the patient control number doesn't match	
09/02/2016	 NJain		Added table #835ImportParseClients to get ClientId from #835ImportParse using SmartCare ClaimId
						Added field ServiceDateIdMin & ServiceDateIdMax to #ServiceSegmentLink to store the Date Range returned in the 835. ServiceDateId should only be used to store the actual DOS if returned
						Added custom logic for Service look up: scsp_PMElectronicProcessERFileServiceLookUp
09/08/2016  Dknewtson	Adding SCSP hook to override core functionality when neccesary
09/22/2016	NJain		Added fields to store Payer Name and Identifier in ERBatches table		
10/12/2016	NJain		Updated File Already Processed validation to validate by Check instead. One file can have multuple checks				
11/30/2016  Dknewtson   Adding Paid Units parsing for The ARC Support Go Live #73
02/16/2017   NJain		Added ClaimLineItemGroupId insert to ERClaimLineItems
						Added fields in #ServiceSegmentLink to indicate if its Claim Level Adjustment or Line Level Adjustment
						Added Tom's Changes for ISNULL(b.ServiceDateId, b.ServiceDateIdMin) = g.ERFileSegmentId
						Added Additional Service look up logic using date in DTM 472 and ClaimLineItemGroupId using DTM 232 and 233
12/11/2017	NJain		Updated to look for Payer Name in N1 PR Segment within 10 segments of the check number, instead of within 5 segments. AHN Implementation #23						
12/18/2017	Gautam		Changed code to insert into ERFileSegments table in single select query. Why: Earlier it was inserting in loop. Key Point - Support Go Live > Tasks#1144.1 > ERA process - time out issue 
03/06/2018  dknewtson	Commented out earlier validation to check for file processing since this is handled elsewhere. 
						added code to make sure the duplicate check validation passes through to the end. 
						also including additional recode for 0 dollar payment check numbers (ERNonPaymentCheckNumbers) ARM - Support Go Live 841
04/17/2018	dknewtson	Removing Carriage Returns and Line feeds from file lines being inserted. ARM - Support Go Live 865
						Adding rtrim(ltrim()) of FileLineText to prevent parsing issues when extra space is included in the 835
05/18/2017  Tremisoski	Camino - Support #345 - Parsing error when final element contains trailing spaces.
05/22/2018	MJensen		Add claim level interest to ERClaimLineItems.  Thresholds Enhancements #34  Requires data model version 19.26
05/31/2018  Dknewtson   Removed References to Paid Units - Causes issues with Testing and customer (ARC) no longer needs this. ARC Enhancements 73
09/11/2018	MJensen		Modified to get the service date from the claim level when no service level date is provided.		MFS SGL Task #422
09/21/2018  Dknewtson   Commented out code to remove offset ERClaimLineItems - Harbor - Support Go Live #1012
10/29/2018  Dknewtson   Removing the requirment that ERClaimLineItems need the date of service. We don't need it if we have a mapped ClaimLineItemId anyway. Aspen Pointe #880
1/10/2019	tchen		What: Fixed find logic for REF 6R segments to correctly get ClaimLineItemId
						Why : Comprehensive - Support Go LIve #186
2/12/2019	MJensen		Allow posting file when there is an out of balance batch.	CCC SGL #79 
*********************************************************************/
AS
    SET ANSI_WARNINGS OFF
    
    SET NOCOUNT ON

    DECLARE @ElementSeperator CHAR(1)
    DECLARE @SubElementSeparator CHAR(1)
    DECLARE @MinimumLineNumber INT
    DECLARE @SubmitterId VARCHAR(25)
    DECLARE @SubmitterName VARCHAR(100)
    DECLARE @SenderId INT
    DECLARE @IncomingBatchDate DATETIME
    DECLARE @FirstTimeProcessing CHAR(1)
    DECLARE @ERSenderId VARCHAR(25)
    DECLARE @BatchNumber INT
    DECLARE @UserCode VARCHAR(30)
    DECLARE @ErrorNo INT
    DECLARE @ErrorMessage VARCHAR(1000)
    DECLARE @SegmentTerminator CHAR(1)


    DECLARE @ParseErrors TABLE
        (
          LineNumber INT NULL ,
          ErrorMessage VARCHAR(1000) NULL ,
          LineDataText VARCHAR(1000) NULL,
	      ERFileId INT,
		  ERFileSegmentId INT NULL 
        )

	--DROP TEMP Tables

    SELECT  @ElementSeperator = ers.ElementDelimiter ,
            @SubElementSeparator = SubElementDelimiter ,
            @SegmentTerminator = SegmentDelimiter
    FROM    dbo.ERFiles ef
            JOIN dbo.ERSenders AS ers ON ers.ERSenderId = ef.ERSenderId
    WHERE   ef.ERFileId = @ERFileId

    IF ( @ElementSeperator IS NULL )
        OR ( @SubElementSeparator IS NULL )
        OR ( @SegmentTerminator IS NULL )
        BEGIN -- get it from the file
            SELECT  @ElementSeperator = SUBSTRING(ef.FileText, 4, 1) ,
                    @SubElementSeparator = SUBSTRING(ef.FileText, 105, 1) ,
                    @SegmentTerminator = SUBSTRING(ef.FileText, 106, 1)
            FROM    dbo.ERFiles ef
                    JOIN dbo.ERSenders AS ers ON ers.ERSenderId = ef.ERSenderId
            WHERE   ef.ERFileId = @ERFileId
        END

    IF EXISTS ( SELECT  *
                FROM    ERFiles
                WHERE   ERFileId = @ERFileId
                        AND Processed = 'Y' )
        BEGIN
            SELECT  @ErrorMessage = 'File Already Processed'
            GOTO do_not_process
        END

	--?????
    IF @UserId = 0
        BEGIN
            SET @UserId = 1
        END

    SELECT  @UserCode = UserCode
    FROM    Staff
    WHERE   StaffId = @UserId

	
    IF OBJECT_ID('scsp_PMElectronicProcessERFile') IS NOT NULL
        BEGIN
            DECLARE @ExecuteCoreCode CHAR(1) = 'Y'
            EXEC scsp_PMElectronicProcessERFile @ERFileId, @UserId, @ExecuteCoreCode OUTPUT
            IF @ExecuteCoreCode = 'N'
                RETURN       
        END 
	
	
	--
	--Run Validations to determine it is ok to process
	--

	--insert into dbo.ERFileParsingErrors(ERFileSegmentId,ERFileId, LineNumber, ErrorMessage, LineDataText)
	--select  ERfileSegmentId,@ERFileId, LineNumber, cast(@ERFileId as varchar) + '-Some Error Message ' + cast(LineNumber as varchar), FileLineText
	--from ERFileSegments WHERE ERFileId = @ERFileId


	-- Get an existing payment for the payer
    DECLARE @PaymentId INT
    DECLARE @BatchId INT

	/*
	select top 1 @PaymentId = py.PaymentId
	from ERFiles as f
	join ERSenders as s on s.ERSenderId = f.ERSenderId
	join Payers as p on p.PayerId = s.PayerId
	join Payments as py on py.PayerId = p.PayerId
	and not exists (select * from ERBatches as b where b.PaymentId = py.PaymentId)
	
	if @PaymentId is null
	begin
	
	select top 1 @PaymentId = py.PaymentId
	from ERFiles as f
	join ERSenders as s on s.ERSenderId = f.ERSenderId
	join Payers as p on p.PayerId = s.PayerId
	join CoveragePlans as cp on cp.PayerId = p.PayerId
	join Payments as py on py.CoveragePlanId = cp.CoveragePlanId
	and not exists (select * from ERBatches as b where b.PaymentId = py.PaymentId)
	
	end
	
	if @PaymentId is null
	BEGIN
	SET @ErrorMessage = 'Could not find an appropriate paymentid for this sender'
	goto do_not_process
	END
	*/

    IF EXISTS ( SELECT  *
                FROM    ERFiles a
                WHERE   ISNULL(a.Processing, 'N') = 'Y'
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'
                        AND a.ERFileId = @ERFileId )
        BEGIN
            SET @ErrorMessage = 'Remittance is currently being processed by another user, unable to process.'
            GOTO do_not_process
        END

    IF EXISTS ( SELECT  *
                FROM    ERFiles a
                WHERE   ISNULL(a.DoNotProcess, 'N') = 'Y'
                        AND ISNULL(a.RecordDeleted, 'N') = 'N'
                        AND a.ERFileId = @ERFileId )
        BEGIN
            SET @ErrorMessage = 'Remittance is set to Do Not Process, unable to process.'
            GOTO do_not_process
        END


	--Set Processing Flag for File
    UPDATE  ERFiles
    SET     Processing = 'Y' ,
            ProcessingStartTime = GETDATE()
    WHERE   ERFileId = @ERFileId




	--
	-- Begin Processing
	--
	--12/18/2017	Gautam	
	CREATE TABLE #tmpERFileSegments1 (
	ERFileId INT
	,LineNumber INT NOT NULL
	,DataText VARCHAR(4000) NULL
	,Segment VARCHAR(10) NULL
	,RowIdentifier UNIQUEIDENTIFIER NOT NULL
	,CreatedBy VARCHAR(30) NULL
	,CreatedDate DATETIME NULL
	,ModifiedBy VARCHAR(30) NULL
	,ModifiedDate DATETIME NULL
	)
	
    CREATE TABLE #835ImportParse
        (
          ERFilesegmentId INT NOT NULL
                              PRIMARY KEY ,
          LineNumber INT NOT NULL ,
          DataText VARCHAR(4000) NULL ,
          TempDataText VARCHAR(4000) NULL ,
          Segment VARCHAR(10) NULL ,
          Element1 VARCHAR(1000) NULL ,
          Element2 VARCHAR(1000) NULL ,
          Element3 VARCHAR(1000) NULL ,
          Element4 VARCHAR(1000) NULL ,
          Element5 VARCHAR(1000) NULL ,
          Element6 VARCHAR(1000) NULL ,
          Element7 VARCHAR(1000) NULL ,
          Element8 VARCHAR(1000) NULL ,
          Element9 VARCHAR(1000) NULL ,
          Element10 VARCHAR(1000) NULL ,
          Element11 VARCHAR(1000) NULL ,
          Element12 VARCHAR(1000) NULL ,
          Element13 VARCHAR(1000) NULL ,
          Element14 VARCHAR(1000) NULL ,
          Element15 VARCHAR(1000) NULL ,
          Element16 VARCHAR(1000) NULL ,
          Element17 VARCHAR(1000) NULL ,
          Element18 VARCHAR(1000) NULL ,
          Element19 VARCHAR(1000) NULL ,
          Element20 VARCHAR(1000) NULL ,
          UNIQUE ( Segment, ERFileSegmentId, LineNumber )
        )
	--create index tmp_index#835ImportParse on (Segment
	
    CREATE TABLE #835ImportParseClients
        (
          ERFileSegmentId INT ,
          ClientId INT
        )

	--select @ElementSeperator = '*', @SubElementSeparator = ':', @FirstTimeProcessing = 'Y'

    SELECT  @FirstTimeProcessing = 'Y'

	-- Get Sender Id
    SELECT  @SubmitterId = b.ERSenderId ,
            @SenderId = b.ERSenderId ,
            @SubmitterName = b.SenderName
    FROM    ERFiles a
            JOIN ERSenders b ON ( a.ERSenderId = b.ERSenderId )
    WHERE   a.ERFileId = @ERFileId

    IF @@error <> 0
        RETURN

	-- legacy code should not be required with new upload/parsing protocol
    BEGIN TRAN

    SELECT  *
    INTO    #tmpERFileSegments
    FROM    ERFilesegments
    WHERE   ERFileId = @ERFileId
    IF @@error <> 0
        RETURN

    DECLARE @MaxSeg INT = 0

    DELETE  FROM dbo.ERFileParsingErrors
    WHERE   ERFileId = @ERFileId
    IF @@error <> 0
        RETURN

    DELETE  FROM dbo.ERFileSegments
    WHERE   ERFileId = @ERFileId
    IF @@error <> 0
        RETURN

    SELECT  @MaxSeg = MAX(erfilesegmentid)
    FROM    dbo.ERFileSegments
    IF @@error <> 0
        RETURN

    IF @MaxSeg IS NULL
        SET @MaxSeg = 0

    SET IDENTITY_INSERT dbo.ERFileSegments ON
    IF @@error <> 0
        RETURN

    INSERT  INTO dbo.ERFileSegments
            ( ERFileSegmentId ,
              ERFileId ,
              LineNumber ,
              FileLineText ,
              FileLineParsed ,
              Element1 ,
              Element2 ,
              Element3 ,
              Element4 ,
              Element5 ,
              Element6 ,
              Element7 ,
              Element8 ,
              Element9 ,
              Element10 ,
              Element11 ,
              Element12 ,
              Element13 ,
              Element14 ,
              Element15 ,
              Element16 ,
              Element17 ,
              Element18 ,
              Element19 ,
              Element20 ,
              RowIdentifier ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate ,
              RecordDeleted ,
              DeletedDate ,
              DeletedBy
            )
            SELECT  ( @MaxSeg + ROW_NUMBER() OVER ( ORDER BY LineNumber ) ) , --- change line number to row number. Pooja.
                    ERFileId ,
                    LineNumber ,
                    FileLineText ,
                    FileLineParsed ,
                    Element1 ,
                    Element2 ,
                    Element3 ,
                    Element4 ,
                    Element5 ,
                    Element6 ,
                    Element7 ,
                    Element8 ,
                    Element9 ,
                    Element10 ,
                    Element11 ,
                    Element12 ,
                    Element13 ,
                    Element14 ,
                    Element15 ,
                    Element16 ,
                    Element17 ,
                    Element18 ,
                    Element19 ,
                    Element20 ,
                    RowIdentifier ,
                    CreatedBy ,
                    CreatedDate ,
                    ModifiedBy ,
                    ModifiedDate ,
                    RecordDeleted ,
                    DeletedDate ,
                    DeletedBy
            FROM    #tmpERFileSegments
    IF @@error <> 0
        RETURN

    SET IDENTITY_INSERT dbo.ERFileSegments OFF
    IF @@error <> 0
        RETURN

    COMMIT TRAN

	--
	-- New parsing process starts here
	--
    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.ERFileSegments
                    WHERE   ERFileId = @ERFileId )
        BEGIN

		-- new parsing logic

            DECLARE @pos BIGINT = 0
            DECLARE @npos BIGINT = 1
            DECLARE @LineNo BIGINT = 1

            DECLARE @ReplaceExpr1 VARCHAR(3) ,
                @ReplaceExpr2 VARCHAR(2) ,
                @ReplaceExpr3 VARCHAR(2)
            SELECT  @ReplaceExpr1 = @SegmentTerminator + CHAR(13) + CHAR(10) ,
                    @ReplaceExpr2 = @SegmentTerminator + CHAR(13) ,
                    @ReplaceExpr3 = @SegmentTerminator + CHAR(10)

            DECLARE @FileText VARCHAR(MAX)


            SELECT  @FileText = FileText
            FROM    ERFiles
            WHERE   ERFileId = @ERFileId
		-- remove invalid carriage-return, line-feed sequences from the text (Doing this in the insert statement - DK)

--            IF PATINDEX('%' + @ReplaceExpr1 + '%', @FileText) > 0
--                SET @FileText = REPLACE(@FileText, @ReplaceExpr1, @SegmentTerminator)
--            IF PATINDEX('%' + @ReplaceExpr2 + '%', @FileText) > 0
--                SET @FileText = REPLACE(@FileText, @ReplaceExpr2, @SegmentTerminator)
--            IF PATINDEX('%' + @ReplaceExpr3 + '%', @FileText) > 0
--                SET @FileText = REPLACE(@FileText, @ReplaceExpr3, @SegmentTerminator)

            WHILE @npos > 0
                BEGIN

                    SET @npos = CHARINDEX(@SegmentTerminator, @FileText, @pos + 1)

                    IF @npos > 0
                        BEGIN--12/18/2017	Gautam	
                            INSERT INTO #tmpERFileSegments1 (
								ERFileId
								,LineNumber

								,DataText
								,RowIdentifier
								,CreatedBy
								,CreatedDate
								,ModifiedBy
								,ModifiedDate
								)
							VALUES (
								@ERFileId
								,@LineNo
								,REPLACE(REPLACE(SUBSTRING(@FileText, @pos + 1, @npos - @pos - 1),CHAR(13),''),CHAR(10), '')
								,NEWID()
								,@UserCode
								,GETDATE()
								,@UserCode
								,GETDATE()
								)

                            SET @pos = @npos
                            SET @LineNo = @LineNo + 1

                        END
                END
			
	END

	IF EXISTS (
			SELECT 1
			FROM #tmpERFileSegments1
			)
	BEGIN
		BEGIN TRAN

		SELECT @MaxSeg = MAX(erfilesegmentid)
		FROM dbo.ERFileSegments

		IF @@error <> 0
			GOTO error

		IF @MaxSeg IS NULL
			SET @MaxSeg = 0
		SET IDENTITY_INSERT dbo.ERFileSegments ON

		IF @@error <> 0
			GOTO error

		INSERT INTO dbo.ERFileSegments (
			ERFileSegmentId
			,ERFileId
			,LineNumber
			,FileLineText
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			)
		SELECT (
				@MaxSeg + ROW_NUMBER() OVER (
					ORDER BY LineNumber
					)
				)
			,ERFileId
			,LineNumber
			,DataText
			,RowIdentifier
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
		FROM #tmpERFileSegments1

		IF @@error <> 0
			GOTO error

		SET IDENTITY_INSERT dbo.ERFileSegments OFF

		IF @@error <> 0
			GOTO error

		DELETE
		FROM dbo.ERFileSegments
		WHERE ERFileId = @ERFileId
			AND ISNULL(FileLineText, '') = ''

		COMMIT TRAN
	END
	
	UPDATE ERFileSegments SET FileLineText = RTRIM(LTRIM(FileLineText)) WHERE erfileid = @ERFileId 

    INSERT  INTO #835ImportParse
            ( ERFilesegmentId ,
              LineNumber ,
              DataText ,
              TempDataText
            )
            SELECT  ERFilesegmentId ,
                    LineNumber ,
                    FileLineText ,
                    FileLineText
            FROM    ERFilesegments
            WHERE   ERFileId = @ERFileId
                    AND ISNULL(RecordDeleted, 'N') = 'N'
            ORDER BY LineNumber

    IF @@error <> 0
        RETURN

    DECLARE @ParseCount INT

    SELECT  @ParseCount = 0

	-- Parse the data

    WHILE EXISTS ( SELECT   *
                   FROM     #835ImportParse
                   WHERE    LEN(TempDataText) > 0 )
        BEGIN

            IF @ParseCount > 20
                BEGIN
                    INSERT  INTO @ParseErrors
                            ( ErFileId,
							  LineNumber ,
                              ErrorMessage
                            )
                            SELECT  @ERFileId,
									LineNumber ,
                                    'Number of elements in a Segment is greater than 20, unable to parse.'
                            FROM    #835ImportParse
                            WHERE   LEN(TempDataText) > 0

                    GOTO continueprocessing
                END

            IF @ParseCount = 0
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Segment = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 1
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element1 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element1 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 2
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element2 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'
                    UPDATE  #835ImportParse
                    SET     Element2 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 3
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element3 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element3 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 4
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element4 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element4 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 5
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element5 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element5 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 6
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element6 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element6 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 7
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element7 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element7 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 8
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element8 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element8 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 9
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element9 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element9 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 10
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element10 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element10 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 11
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element11 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element11 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 12
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element12 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element12 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 13
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element13 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element13 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 14
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element14 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element14 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 15
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element15 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element15 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 16
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element16 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element16 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 17
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element17 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element17 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 18
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element18 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element18 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 19
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element19 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element19 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN

            IF @ParseCount = 20
                BEGIN
                    UPDATE  #835ImportParse
                    SET     Element20 = SUBSTRING(TempDataText, 1, CHARINDEX(@ElementSeperator, TempDataText) - 1)
                    WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

                    UPDATE  #835ImportParse
                    SET     Element20 = TempDataText
                    WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                            AND LEN(TempDataText) > 0
                END

            IF @@error <> 0
                RETURN
			
            
				
            UPDATE  #835ImportParse
            SET     TempDataText = NULL
            WHERE   TempDataText NOT LIKE '%' + @ElementSeperator + '%'
                    AND LEN(TempDataText) > 0

            IF @@error <> 0
                RETURN

			-- camino support #345 (trailing spaces in TRN segment caused parsing issues)
            UPDATE  #835ImportParse
            SET     TempDataText = RIGHT(TempDataText, DATALENGTH(TempDataText) - CHARINDEX(@ElementSeperator, TempDataText))
            WHERE   TempDataText LIKE '%' + @ElementSeperator + '%'

            IF @@error <> 0
                RETURN

            SELECT  @ParseCount = @ParseCount + 1

            IF @@error <> 0
                RETURN

        END


	
    continueprocessing:
	

    UPDATE  #835ImportParse
    SET     Element1 = NULL
    WHERE   RTRIM(Element1) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element2 = NULL
    WHERE   RTRIM(Element2) IN ( '', NULL )

    UPDATE  #835ImportParse
    SET     Element3 = NULL
    WHERE   RTRIM(Element3) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element4 = NULL
    WHERE   RTRIM(Element4) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element5 = NULL
    WHERE   RTRIM(Element5) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element6 = NULL
    WHERE   RTRIM(Element6) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element7 = NULL
    WHERE   RTRIM(Element7) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element8 = NULL
    WHERE   RTRIM(Element8) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element9 = NULL
    WHERE   RTRIM(Element9) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element10 = NULL
    WHERE   RTRIM(Element10) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element11 = NULL
    WHERE   RTRIM(Element11) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element12 = NULL
    WHERE   RTRIM(Element12) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element13 = NULL
    WHERE   RTRIM(Element13) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element14 = NULL
    WHERE   RTRIM(Element14) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element15 = NULL
    WHERE   RTRIM(Element15) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element16 = NULL
    WHERE   RTRIM(Element16) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element17 = NULL
    WHERE   RTRIM(Element17) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element18 = NULL
    WHERE   RTRIM(Element18) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element19 = NULL
    WHERE   RTRIM(Element19) IN ( '', NULL )

    IF @@error <> 0
        RETURN

    UPDATE  #835ImportParse
    SET     Element20 = NULL
    WHERE   RTRIM(Element20) IN ( '', NULL )

    IF @@error <> 0
        RETURN

	-- Get first line number for the file
    DECLARE @FirstLine INT

    SELECT  @FirstLine = MIN(LineNumber)
    FROM    #835ImportParse

    IF @@error <> 0
        RETURN

	
	-- Add Clients to #835ImportParse
    INSERT  INTO #835ImportParseClients
            ( ERFileSegmentId ,
              ClientId
            )
            SELECT DISTINCT
                    ERFileSegmentId ,
                    LEFT(a.Element1, CHARINDEX('-', a.Element1) - 1)
            FROM    #835ImportParse a
            WHERE   a.Segment = 'CLP'
                    AND CHARINDEX('-', a.Element1) <> 0
                    AND a.Element1 NOT LIKE '%[a-z]%'


	--Get Check Amount
    DECLARE @835Batch TABLE
        (
          ERFileSegmentId INT NOT NULL ,
          ERFileId INT NULL ,
          HandlingCode CHAR(1) NULL ,
          CheckAmount MONEY NULL ,
          AmountAutoPaid MONEY NULL ,
          CheckDate DATETIME NULL ,
          CheckNumber VARCHAR(30) ,
          BatchStartId INT NULL ,
          BatchEndId INT NULL ,
          BatchNumber INT NULL ,
          PayerName VARCHAR(MAX) NULL ,
          PayerIdentifier VARCHAR(MAX) NULL
        )

    DECLARE @CheckAmount MONEY
    DECLARE @AmountManualPaid MONEY
    DECLARE @AmountAutoPaid MONEY
    DECLARE @CheckDate DATETIME
    DECLARE @CheckNumber VARCHAR(25)

	--select @ERSenderId = Element2
	--from #835ImportParse
	--where segment = 'GS'

    IF @@error <> 0
        RETURN

    INSERT  INTO @835Batch
            ( ERFileSegmentId ,
              HandlingCode ,
              CheckAmount ,
              CheckDate
            )
            SELECT  ERFileSegmentId ,
                    Element1 ,
                    CASE WHEN Element3 = 'C' THEN CONVERT(MONEY, Element2)
                         WHEN Element3 = 'D' THEN CASE WHEN CONVERT(MONEY, Element2) > 0 THEN -CONVERT(MONEY, Element2)
                                                       ELSE CONVERT(MONEY, Element2)
                                                  END
                    END ,
                    CONVERT(DATETIME, SUBSTRING(Element16, 5, 2) + '/' + SUBSTRING(Element16, 7, 2) + '/' + SUBSTRING(Element16, 1, 4))
            FROM    #835ImportParse
            WHERE   segment = 'BPR'

		
		
		
    UPDATE  c
    SET     PayerName = a.Element2 ,
            PayerIdentifier = a.Element4
    FROM    #835ImportParse a
            JOIN #835ImportParse b ON b.ERFileSegmentId < a.ERFileSegmentId
                                      AND a.ERFileSegmentId < b.ERFileSegmentId + 10
            JOIN @835Batch c ON c.ERFileSegmentId = b.ERFileSegmentId
    WHERE   b.segment = 'BPR'
            AND a.segment = 'N1'
            AND a.Element1 = 'PR'  
		
		

		

    IF @@error <> 0
        RETURN

    UPDATE  @835Batch
    SET     HandlingCode = 'I'

    UPDATE  b
    SET     b.ERFileId = s.ERFileId
    FROM    @835Batch b
            JOIN ERFileSegments s ON s.ERFileSegmentId = b.ERFileSegmentId


    UPDATE  a
    SET     CheckNumber = Element2
    FROM    @835Batch a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId = ( a.ERFileSegmentId + 1 ) )
    WHERE   segment = 'TRN'
	
	
	
    IF @@error <> 0
        RETURN

    UPDATE  @835Batch
    SET     BatchStartId = ERFileSegmentId - 1

    IF @@error <> 0
        RETURN


    UPDATE  a
    SET     BatchEndId = b.ERFileSegmentId
    FROM    @835Batch a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ERFileSegmentId )
    WHERE   b.segment = 'SE'
            AND NOT EXISTS ( SELECT *
                             FROM   #835ImportParse c
                             WHERE  c.segment = 'SE'
                                    AND c.ERFileSegmentId > a.ERFileSegmentId
                                    AND c.ERFileSegmentId < b.ERFileSegmentId )

    IF @@error <> 0
        RETURN


	
-- dknewtson - this is handled by a later validation that has been improved		
  --  IF EXISTS ( SELECT  *
  --              FROM    ERBatches a
  --                      JOIN @835Batch b ON ( a.CheckNumber = b.CheckNumber
  --                                            AND a.CheckDate = b.CheckDate
  --                                          )
  --              WHERE   --a.ERSenderId = @ERSenderId  srf ??
		--	--  b.ERFileSegmentId = a.ERBatchId
  --                      ISNULL(a.RecordDeleted, 'N') = 'N' )
  --      BEGIN
  --          SET @ErrorMessage = 'File has already been imported and processed.'

		----Set Processing Flag for File
  --          UPDATE  ERFiles
  --          SET     Processing = 'N'
  --          WHERE   ERFileId = @ERFileId

  --          GOTO do_not_process

  --      END


	-- Link Claim and Service Segments
    CREATE TABLE #ClaimSegmentLink
        (
          BatchERFileSegmentId INT NULL ,
          ClaimId INT NULL ,
          PatientNameId INT NULL ,
          PayorBatchId INT NULL
        )

    CREATE INDEX temp_ClaimSegmentLink1 ON #ClaimSegmentLink(ClaimId)

    CREATE TABLE #ClaimAdjustmentLink
        (
          ClaimId INT NULL ,
          AdjustmentId INT NULL
        )

    CREATE TABLE #ServiceSegmentLink
        (
          ClaimId INT NULL ,
          ServiceId INT NULL ,
          ServiceDateId INT NULL ,
          ServiceDateIdMin INT NULL ,
          ServiceDateIdMax INT NULL ,
          LineItemNoId INT NULL ,
          ClaimLineItemId INT NULL ,
          LineItemControlNumber VARCHAR(30) NULL ,
          AdjustmentId1 INT NULL ,
          AdjustmentId2 INT NULL ,
          AdjustmentId3 INT NULL ,
          AdjustmentId4 INT NULL ,
          AdjustmentId5 INT NULL ,
          ClaimLevelAdjustment1 CHAR(1) NULL ,
          ClaimLevelAdjustment2 CHAR(1) NULL ,
          ClaimLevelAdjustment3 CHAR(1) NULL ,
          ClaimLevelAdjustment4 CHAR(1) NULL ,
          ClaimLevelAdjustment5 CHAR(1) NULL ,
          ClaimLineItemGroupId INT NULL
        )

    CREATE INDEX temp_ServiceSegmentLink1 ON #ServiceSegmentLink(ClaimId)
    CREATE INDEX temp_ServiceSegmentLink2 ON #ServiceSegmentLink(ClaimId,ServiceId)
    CREATE INDEX temp_ServiceSegmentLink3 ON #ServiceSegmentLink(ServiceId,ClaimId)


    CREATE TABLE #ClaimInterestSegment  -- 5/22/18 MJensen
        (
          ClaimId INT NULL ,
          InterestId INT NULL,
		  Element2 VARCHAR(1000) NULL
        )

    CREATE TABLE #ServiceAdjustmentLink
        (
          ClaimId INT NULL ,
          ServiceId INT NULL ,
          AdjustmentId INT NULL
        )

    CREATE TABLE #PLBSegment
        (
          BatchERFileSegmentId INT NULL ,
          PLBId INT NULL ,
          FiscalPeriodDate DATETIME NULL ,
          AdjustmentIdentifier1 VARCHAR(35) NULL ,
          AdjustmentAmount1 MONEY NULL ,
          AdjustmentIdentifier2 VARCHAR(35) NULL ,
          AdjustmentAmount2 MONEY NULL ,
          AdjustmentIdentifier3 VARCHAR(35) NULL ,
          AdjustmentAmount3 MONEY NULL ,
          AdjustmentIdentifier4 VARCHAR(35) NULL ,
          AdjustmentAmount4 MONEY NULL ,
          AdjustmentIdentifier5 VARCHAR(35) NULL ,
          AdjustmentAmount5 MONEY NULL ,
          AdjustmentIdentifier6 VARCHAR(35) NULL ,
          AdjustmentAmount6 MONEY NULL
        )

    CREATE TABLE #ClaimServiceCount
        (
          ClaimId INT NOT NULL ,
          ServiceCount INT NOT NULL ,
          ClaimPaidAmount MONEY NULL ,
          TotalServicePaid MONEY NULL
        )

    CREATE TABLE #ServicePaidAmount
        (
          ClaimId INT NOT NULL ,
          ServiceId INT NULL ,
          ServiceFraction DECIMAL(9, 2) NULL ,
          ChargeAmount MONEY NULL ,
          PaidAmount DECIMAL(10, 2) NULL 
        )

    CREATE TABLE #ClaimServiceSum
        (
          ClaimId INT NOT NULL ,
          ServicePaidSum DECIMAL(10, 2) NULL
        )


    INSERT  INTO #ClaimSegmentLink
            ( ClaimId ,
              BatchERFileSegmentId
            )
            SELECT  a.ERFileSegmentId ,
                    b.ERFileSegmentId
            FROM    #835ImportParse a
                    JOIN @835Batch b ON ( a.ERFileSegmentId > b.ERFileSegmentId )
            WHERE   segment = 'CLP'
                    AND NOT EXISTS ( SELECT *
                                     FROM   @835Batch c
                                     WHERE  a.ERFileSegmentId > c.ERFileSegmentId
                                            AND b.ERFileSegmentId < c.ERFileSegmentId )

    IF @@error <> 0
        RETURN



    UPDATE  a
    SET     PatientNameId = b.ERFileSegmentId
    FROM    #ClaimSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ClaimId
                                        AND b.ERFileSegmentId < ( a.ClaimId + 100 )
                                      )
    WHERE   segment = 'NM1'
            AND Element1 = 'QC'
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimSegmentLink c
                             WHERE  c.ClaimId > a.ClaimId
                                    AND b.ERFileSegmentId > c.ClaimId
                                    AND b.ERFileSegmentId < ( c.ClaimId + 100 ) )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     PayorBatchId = b.ERFileSegmentId
    FROM    #ClaimSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ClaimId
                                        AND b.ERFileSegmentId < ( a.ClaimId + 50 )
                                      )
    WHERE   segment = 'REF'
            AND b.Element1 = 'F8'
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimSegmentLink c
                             WHERE  c.ClaimId > a.ClaimId
                                    AND b.ERFileSegmentId > c.ClaimId
                                    AND b.ERFileSegmentId < ( c.ClaimId + 50 ) )

    IF @@error <> 0
        RETURN

	-- find the claim level interest payments  -- 5/22/18 MJensen 
	INSERT INTO #ClaimInterestSegment (
		ClaimId
		,InterestId
		,Element2
		)
	SELECT csl.ClaimId
		,ip.ERFilesegmentId
		,ip.Element2
	FROM #835ImportParse ip
	JOIN #ClaimSegmentLink csl ON csl.ClaimId < ip.ERFilesegmentId
	WHERE ip.Segment = 'AMT'
		AND ip.Element1 = 'I'
		AND NOT EXISTS (
			SELECT 1
			FROM #ClaimSegmentLink csl2
			WHERE csl2.ClaimId < ip.ERFilesegmentId
				AND csl2.ClaimId > csl.ClaimId
			)

 IF @@error <> 0
        RETURN


    INSERT  INTO #ServiceSegmentLink
            ( ClaimId ,
              ServiceId
            )
            SELECT  a.ClaimId ,
                    b.ERFileSegmentId
            FROM    #ClaimSegmentLink a
                    JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ClaimId
                                                AND b.ERFileSegmentId < ( a.ClaimId + 500 )
                                              )
            WHERE   segment = 'SVC'
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ClaimSegmentLink c
                                     WHERE  c.ClaimId > a.ClaimId
                                            AND b.ERFileSegmentId > c.ClaimId
                                            AND b.ERFileSegmentId < ( c.ClaimId + 500 ) )

    IF @@error <> 0
        RETURN

	-- Add claims that do not have an SVC segment
    INSERT  INTO #ServiceSegmentLink
            ( ClaimId
            )
            SELECT  ClaimId
            FROM    #ClaimSegmentLink a
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   #ServiceSegmentLink b
                                 WHERE  a.ClaimId = b.ClaimId )

    IF @@error <> 0
        RETURN
    UPDATE  a
    SET     ServiceDateId = b.ERFileSegmentId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ServiceId
                                        AND b.ERFileSegmentId < ( a.ServiceId + 5 )
                                      )
    WHERE   segment = 'DTM'
            AND Element1 = '472'
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId > a.ServiceId
                                    AND b.ERFileSegmentId > c.ServiceId
                                    AND b.ERFileSegmentId < ( c.ServiceId + 5 ) )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     ServiceDateIdMin = b.ERFileSegmentId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ServiceId
                                        AND b.ERFileSegmentId < ( a.ServiceId + 5 )
                                      )
    WHERE   a.ServiceDateId IS NULL
            AND segment = 'DTM'
            AND Element1 = '150'
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId > a.ServiceId
                                    AND b.ERFileSegmentId > c.ServiceId
                                    AND b.ERFileSegmentId < ( c.ServiceId + 5 ) )

    IF @@error <> 0
        RETURN
        
        
    UPDATE  a
    SET     ServiceDateIdMax = b.ERFileSegmentId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ServiceId
                                        AND b.ERFileSegmentId < ( a.ServiceId + 5 )
                                      )
    WHERE   a.ServiceDateId IS NULL
            AND segment = 'DTM'
            AND Element1 = '151'
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId > a.ServiceId
                                    AND b.ERFileSegmentId > c.ServiceId
                                    AND b.ERFileSegmentId < ( c.ServiceId + 5 ) )

    IF @@error <> 0
        RETURN
        

	-- For missing SVC segment or no svc dates
    UPDATE  a
    SET     ServiceDateId = b.ERFileSegmentId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ClaimId
                                        AND b.ERFileSegmentId < ( a.ClaimId + 50 )
                                      )
    WHERE   (a.ServiceId IS NULL
				OR (a.ServiceDateId IS NULL AND a.ServiceDateIdMin IS NULL))
            AND segment = 'DTM'
            AND Element1 = '232'
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimSegmentLink c
                             WHERE  c.ClaimId > a.ClaimId
                                    AND b.ERFileSegmentId > c.ClaimId
                                    AND b.ERFileSegmentId < ( c.ClaimId + 50 ) )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     LineItemNoId = b.ERFileSegmentId ,
            LineItemControlNumber = b.Element2
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ServiceId
                                        AND b.ERFileSegmentId < ( a.ServiceId + 12 )
                                      )
    WHERE   b.Segment = 'REF'
            AND b.Element1 = '6R'
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId > a.ServiceId
                                    AND b.ERFileSegmentId > c.ServiceId
                                    AND b.ERFileSegmentId < ( c.ServiceId + 12 ) )

    IF @@error <> 0
        RETURN

	-- TER - 2013.08.11 - get claim line item from CLP segment if not sent as ref*6r
    UPDATE  a
    SET     LineItemNoId = b.ERFileSegmentId ,
            LineItemControlNumber = CASE WHEN CHARINDEX('-', b.Element1) > 0 THEN SUBSTRING(b.Element1, CHARINDEX('-', b.Element1) + 1, 100)
                                         ELSE NULL
                                    END
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( ( b.ERFileSegmentId < a.ServiceId
                                          AND b.ERFileSegmentId > ( a.ServiceId - 10 )
                                          AND a.ServiceId IS NOT NULL
                                        )
                                        OR ( b.ERFileSegmentId < a.ServiceDateId
                                             AND b.ERFileSegmentId > ( a.ServiceDateId - 10 )
                                             AND a.ServiceId IS NULL
                                           )
                                      )
    WHERE   b.Segment = 'CLP'
            AND LineItemControlNumber IS NULL
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId < a.ServiceId
                                    AND b.ERFileSegmentId < c.ServiceId
                                    AND b.ERFileSegmentId > ( c.ServiceId - 10 ) )

    IF @@error <> 0
        RETURN
-- Find match for Paper claims, if only one Line Item is there
    UPDATE  a
    SET     LineItemNoId = b.ERFileSegmentId ,
            LineItemControlNumber = cli.ClaimLineItemId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId < a.ServiceId
                                        AND b.ERFileSegmentId > ( a.ServiceId - 10 )
                                      )
            JOIN dbo.ClaimLineItemGroups clig ON b.Element1 = CONVERT(VARCHAR, clig.ClientId) + CONVERT(VARCHAR, clig.ClaimLineItemGroupId)
            JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
    WHERE   b.Segment = 'CLP'
            AND LineItemControlNumber IS NULL
            AND CHARINDEX('-', b.Element1) = 0
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId < a.ServiceId
                                    AND b.ERFileSegmentId < c.ServiceId
                                    AND b.ERFileSegmentId > ( c.ServiceId - 10 ) )
            AND NOT EXISTS ( SELECT cli2.ClaimLineItemGroupId
                             FROM   dbo.ClaimLineItems cli2
                             WHERE  cli2.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                             GROUP BY cli2.ClaimLineItemGroupId
                             HAVING COUNT(DISTINCT cli2.ClaimLineItemId) > 1 )
            AND NOT EXISTS ( SELECT 1
                             FROM   dbo.ClaimLineItemGroups clig2
                             WHERE  b.Element1 = CONVERT(VARCHAR, clig2.ClientId) + CONVERT(VARCHAR, clig2.ClaimLineItemGroupId)
                                    AND ISNULL(clig2.RecordDeleted, 'N') <> 'Y'
                                    AND clig2.ClaimLineItemGroupId <> clig.ClaimLineItemGroupId )                                
                             
    IF @@error <> 0
        RETURN
        
-- Find match for Paper claims, with multiple line items, one service per line item
    UPDATE  a
    SET     LineItemNoId = b.ERFileSegmentId ,
            LineItemControlNumber = cli.ClaimLineItemId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON ( b.ERFileSegmentId < a.ServiceId
                                        AND b.ERFileSegmentId > ( a.ServiceId - 10 )
                                      )
            JOIN #835ImportParse c ON c.ERFileSegmentId = a.ServiceId -- get billing code
            JOIN #835ImportParse d ON d.ERFileSegmentId = a.ServiceDateId -- get DOS                                      
            JOIN dbo.ClaimLineItemGroups clig ON b.Element1 = CONVERT(VARCHAR, clig.ClientId) + CONVERT(VARCHAR, clig.ClaimLineItemGroupId)
            JOIN dbo.ClaimLineItems cli ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
    WHERE   b.Segment = 'CLP'
            AND LineItemControlNumber IS NULL
            AND CHARINDEX('-', b.Element1) = 0
            AND SUBSTRING(c.Element1, 4, LEN(c.Element1)) = cli.BillingCode + CASE WHEN ISNULL(cli.Modifier1, '') <> '' THEN @SubElementSeparator + cli.Modifier1
                                                                                   ELSE ''
                                                                              END + CASE WHEN ISNULL(cli.Modifier1, '') <> ''
                                                                                              AND ISNULL(cli.Modifier2, '') <> '' THEN @SubElementSeparator + cli.Modifier2
                                                                                         ELSE ''
                                                                                    END + CASE WHEN ISNULL(cli.Modifier1, '') <> ''
                                                                                                    AND ISNULL(cli.Modifier2, '') <> ''
                                                                                                    AND ISNULL(cli.Modifier3, '') <> '' THEN @SubElementSeparator + cli.Modifier3
                                                                                               ELSE ''
                                                                                          END + CASE WHEN ISNULL(cli.Modifier1, '') <> ''
                                                                                                          AND ISNULL(cli.Modifier2, '') <> ''
                                                                                                          AND ISNULL(cli.Modifier3, '') <> ''
                                                                                                          AND ISNULL(cli.Modifier4, '') <> '' THEN @SubElementSeparator + cli.Modifier4
                                                                                                     ELSE ''
                                                                                                END
            AND d.Element2 = REPLACE(cli.DateOfService, '-', '')
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceSegmentLink c
                             WHERE  c.ServiceId < a.ServiceId
                                    AND b.ERFileSegmentId < c.ServiceId
                                    AND b.ERFileSegmentId > ( c.ServiceId - 10 ) )
            AND EXISTS ( SELECT cli2.ClaimLineItemGroupId
                         FROM   dbo.ClaimLineItems cli2
                         WHERE  cli2.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                         GROUP BY cli2.ClaimLineItemGroupId
                         HAVING COUNT(DISTINCT cli2.ClaimLineItemId) > 1 )
            AND NOT EXISTS ( SELECT 1
                             FROM   dbo.ClaimLineItemGroups clig2
                             WHERE  b.Element1 = CONVERT(VARCHAR, clig2.ClientId) + CONVERT(VARCHAR, clig2.ClaimLineItemGroupId)
                                    AND ISNULL(clig2.RecordDeleted, 'N') <> 'Y'
                                    AND clig2.ClaimLineItemGroupId <> clig.ClaimLineItemGroupId )              
            --AND NOT EXISTS ( SELECT clic.ClaimLineItemId
            --                 FROM   dbo.ClaimLineItemCharges clic
            --                 WHERE  clic.ClaimLineItemId = cli.ClaimLineItemId
            --                 GROUP BY clic.ClaimLineItemId
            --                 HAVING COUNT(DISTINCT clic.ChargeId) > 1 )            
            
            
            
    UPDATE  #ServiceSegmentLink
    SET     ClaimLineItemId = CONVERT(INT, LineItemControlNumber)
    WHERE   ISNUMERIC(LineItemControlNumber) = 1
            AND LineItemControlNumber NOT LIKE '%.%'


   -- Claim Id is a SmartCare ClaimId and SVC segment has DOS
    UPDATE  a
    SET     ClaimLineItemId = cli2.ClaimLineItemId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON b.ERFileSegmentId = a.ClaimId
            JOIN #835ImportParseClients b2 ON b2.ERFileSegmentId = b.ERFileSegmentId
            JOIN #835ImportParse c ON c.ERFileSegmentId = a.ServiceId
            JOIN #835ImportParse d ON d.ERFileSegmentId = a.ServiceDateId
            JOIN dbo.ClaimLineItems cli ON CONVERT(VARCHAR, b2.ClientId) + '-' + CONVERT(VARCHAR, cli.ClaimLineItemId) = b.Element1
            JOIN dbo.ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
                                                 AND CONVERT(VARCHAR, b2.ClientId) + '-' + CONVERT(VARCHAR, clig.ClaimLineItemGroupId) <> b.Element1
            JOIN dbo.ClaimLineItems cli2 ON cli2.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                                            AND cli2.DateOfService = d.Element2
                                            AND ISNULL(cli2.BillingCode, '') + ISNULL(cli2.RevenueCode, '') = ISNULL(SUBSTRING(c.Element1, 4, LEN(c.Element1)), '') + ISNULL(c.Element4, '')
    WHERE   b.Segment = 'CLP'
            AND c.Segment = 'SVC'
            AND d.Element1 = '472'
            AND a.ServiceDateId IS NOT NULL
            AND a.ClaimLineItemId IS NULL
            AND CHARINDEX('-', b.Element1) <> 0

	
	
	-- Post using ClaimLineItemGroupId
    UPDATE  a
    SET     ClaimLineItemGroupId = f.ClaimLineItemGroupId ,
            ServiceDateIdMin = c.ERFileSegmentId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON b.ERFileSegmentId = a.ClaimId
            JOIN #835ImportParse c ON c.ERFileSegmentId <= b.ERFileSegmentId + 10
                                      AND c.ERFileSegmentId > b.ERFileSegmentId
            JOIN #835ImportParse d ON d.ERFileSegmentId <= b.ERFileSegmentId + 10
                                      AND d.ERFileSegmentId > b.ERFileSegmentId
            JOIN dbo.ClaimLineItems f ON f.ClaimLineItemId = a.ClaimLineItemId
    WHERE   b.Segment = 'CLP'
            AND c.Segment = 'DTM'
            AND c.Element1 = '232'
            AND d.Segment = 'DTM'
            AND d.Element1 = '233'
            AND ISNULL(c.Element2, '') <> ISNULL(d.Element2, '')
            AND NOT EXISTS ( SELECT *
                             FROM   #835ImportParse e
                             WHERE  e.ERFileSegmentId <= b.ERFileSegmentId + 12
                                    AND e.ERFileSegmentId > b.ERFileSegmentId
                                    AND e.Segment = 'DTM'
                                    AND e.Element1 = '150' )
        
        
        
    UPDATE  a
    SET     ServiceDateIdMin = c.ERFileSegmentId
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON b.ERFileSegmentId = a.ClaimId
            JOIN #835ImportParse c ON c.ERFileSegmentId <= b.ERFileSegmentId + 10
                                      AND c.ERFileSegmentId > b.ERFileSegmentId
            JOIN #835ImportParse d ON d.ERFileSegmentId <= b.ERFileSegmentId + 10
                                      AND d.ERFileSegmentId > b.ERFileSegmentId
            JOIN dbo.ClaimLineItems f ON f.ClaimLineItemId = a.ClaimLineItemId
    WHERE   b.Segment = 'CLP'
            AND c.Segment = 'DTM'
            AND c.Element1 = '232'
            AND d.Segment = 'DTM'
            AND d.Element1 = '233'
            AND a.ServiceDateIdMin IS NULL
            AND a.ClaimLineItemId IS NOT NULL 
        
        
    UPDATE  a
    SET     ClaimLineItemGroupId = NULL
    FROM    #ServiceSegmentLink a
    WHERE   EXISTS ( SELECT *
                     FROM   #ServiceSegmentLink b
                     WHERE  b.ClaimId = a.ClaimId
                            AND b.ClaimLineItemGroupId = a.ClaimLineItemGroupId
                            AND b.ClaimLineItemId <> a.ClaimLineItemId )
        
	
	

    -- Remove the ClaimLineItemId when the patient control number doesn't match
    UPDATE  a
    SET     ClaimLineItemId = NULL
    FROM    #ServiceSegmentLink a
            JOIN #835ImportParse b ON b.ERFileSegmentId = a.ClaimId
    WHERE   b.Segment = 'CLP'
            AND NOT EXISTS ( SELECT 1
                             FROM   dbo.ClaimLineItems cli
                                    JOIN dbo.ClaimLineItemGroups clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                             WHERE  cli.ClaimLineItemId = a.ClaimLineItemId
                                -- Could be ClientId-ClaimLineItemId
                                       --or ClientId-ClaimLineItemGroupId
                                       --or ClientId-SomeOtherClaimLineItemId in the group
                                    AND ( CAST(clig.ClientId AS VARCHAR) + '-' + CAST(a.ClaimLineItemId AS VARCHAR) = b.Element1
                                          OR CAST(clig.ClientId AS VARCHAR) + '-' + CAST(clig.ClaimLineItemGroupId AS VARCHAR) = b.Element1
                                          OR CAST(clig.ClientId AS VARCHAR) + CAST(clig.ClaimLineItemGroupId AS VARCHAR) = b.Element1
                                          OR EXISTS ( SELECT    1
                                                      FROM      dbo.ClaimLineItems cli2
                                                      WHERE     cli2.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                                                                AND CAST(clig.ClientId AS VARCHAR) + '-' + CAST(cli2.ClaimLineItemId AS VARCHAR) = b.Element1 )
                                        ) )

    IF @@error <> 0
        RETURN


-- Custom Logic for Service look up	
    IF EXISTS ( SELECT  *
                FROM    sys.procedures
                WHERE   name = 'scsp_PMElectronicProcessERFileServiceLookUp' )
        BEGIN 
	
            EXEC scsp_PMElectronicProcessERFileServiceLookUp @ERFileId
	
            IF @@error <> 0
                RETURN

        END


	-- Calculate service paid amount
	-- in case of reversals the total of service paid amounts
	-- does not equal claim paid amount

	-- Get Claim Service Count and Payment amount
    INSERT  INTO #ClaimServiceCount
            ( ClaimId ,
              ClaimPaidAmount ,
              ServiceCount ,
              TotalServicePaid
            )
            SELECT  a.ClaimId ,
                    CONVERT(MONEY, b.Element4) ,
                    COUNT(*) ,
                    SUM(ISNULL(CONVERT(MONEY, c.Element3), 0))
            FROM    #ServiceSegmentLink a
                    JOIN #835ImportParse b ON ( a.ClaimId = b.ERFileSegmentId )
                    JOIN #835ImportParse c ON ( a.ServiceId = c.ERFileSegmentId )
            WHERE   a.ServiceId IS NOT NULL
                    AND b.segment = 'CLP'
                    AND ISNUMERIC(c.Element3) = 1
                    AND ISNUMERIC(b.Element4) = 1
            GROUP BY a.ClaimId ,
                    CONVERT(MONEY, b.Element4)

    IF @@error <> 0
        RETURN

	-- Case where SVC is missing
    INSERT  INTO #ClaimServiceCount
            ( ClaimId ,
              ClaimPaidAmount ,
              ServiceCount ,
              TotalServicePaid
            )
            SELECT  a.ClaimId ,
                    CONVERT(MONEY, b.Element4) ,
                    1 ,
                    CONVERT(MONEY, b.Element4)
            FROM    #ServiceSegmentLink a
                    JOIN #835ImportParse b ON ( a.ClaimId = b.ERFileSegmentId )
            WHERE   a.ServiceId IS NULL





    IF @@error <> 0
        RETURN

	--25/10/2012
    DECLARE @el2 VARCHAR(1000) ,
        @el3 VARCHAR(1000) ,
        @el5 VARCHAR(1000) ,
        @cId INT ,
        @sId INT ,
        @sCount INT
    DECLARE c1 CURSOR
    FOR
        SELECT  a.ClaimId ,
                a.ServiceId ,
                b.ServiceCount ,
                c.Element2 ,
                c.Element3 ,
                c.Element5
        FROM    #ServiceSegmentLink a
                JOIN #ClaimServiceCount b ON ( a.ClaimId = b.ClaimId )
                JOIN #835ImportParse c ON ( a.ServiceId = c.ERFileSegmentId )
        WHERE   a.ServiceId IS NOT NULL

    OPEN c1

    FETCH c1 INTO @cId, @sId, @sCount, @el2, @el3, @El5
    WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT  INTO #ServicePaidAmount
                    ( ClaimId ,
                      ServiceId ,
                      ServiceFraction ,
                      ChargeAmount ,
                      PaidAmount
                    )
            VALUES  ( @cId ,
                      @sId ,
                      CONVERT(DECIMAL(9, 2), 1) / CONVERT(DECIMAL(9, 2), @sCount) ,
                      ISNULL(CONVERT(MONEY, @el2), 0) ,
                      ISNULL(CONVERT(MONEY, @el3), 0) 
                    )

            IF @@error <> 0
                RETURN

            FETCH c1 INTO @cId, @sId, @sCount, @el2, @el3, @el5

        END

    CLOSE c1

    DEALLOCATE c1

    IF @@error <> 0
        RETURN


	--insert into #ServicePaidAmount
	--(ClaimId, ServiceId, ServiceFraction, ChargeAmount, PaidAmount)
	--select a.ClaimId, a.ServiceId,
	--convert(decimal(9,2),1)/convert(decimal(9,2),b.ServiceCount),
	----isnull(convert(money, CONVERT(decimal(9,2), c.Element2)),0), isnull(convert(money, CONVERT(decimal(9,2), c.Element3)),0)
	--isnull(convert(money, c.Element2),0), isnull(convert(money, c.Element3),0)
	--from #ServiceSegmentLink a
	--JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)
	--JOIN #835ImportParse c ON (a.ServiceId = c.ERFileSegmentId)
	--where a.ServiceId is not null

	--if @@error <> 0 return

    PRINT 'after2'
    INSERT  INTO #ServicePaidAmount
            ( ClaimId ,
              ServiceId ,
              ServiceFraction ,
              ChargeAmount ,
              PaidAmount
            )
            SELECT  a.ClaimId ,
                    a.ServiceId ,
                    1 ,
                    ISNULL(CONVERT(MONEY, c.Element3), 0) ,
                    b.ClaimPaidAmount
            FROM    #ServiceSegmentLink a
                    JOIN #ClaimServiceCount b ON ( a.ClaimId = b.ClaimId )
                    JOIN #835ImportParse c ON ( a.ClaimId = c.ERFileSegmentId )
            WHERE   a.ServiceId IS NULL
                    AND ISNUMERIC(c.Element3) = 1

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     PaidAmount = b.ClaimPaidAmount * a.ServiceFraction
    FROM    #ServicePaidAmount a
            JOIN #ClaimServiceCount b ON ( a.ClaimId = b.ClaimId )
    WHERE   b.ClaimPaidAmount <> b.TotalServicePaid

    IF @@error <> 0
        RETURN

    INSERT  INTO #ClaimServiceSum
            ( ClaimId ,
              ServicePaidSum
            )
            SELECT  ClaimId ,
                    SUM(PaidAmount)
            FROM    #ServicePaidAmount
            GROUP BY ClaimId

    IF @@error <> 0
        RETURN

	-- The difference between the claim paid amount and the sum of service paid amounts
	-- is applied to the first service for the claim
    UPDATE  a
    SET     PaidAmount = a.PaidAmount + c.ClaimPaidAmount - b.ServicePaidSum
    FROM    #ServicePaidAmount a
            JOIN #ClaimServiceSum b ON ( a.ClaimId = b.ClaimId )
            JOIN #ClaimServiceCount c ON ( a.ClaimId = c.ClaimId )
    WHERE   c.ClaimPaidAmount <> c.TotalServicePaid
            AND NOT EXISTS ( SELECT *
                             FROM   #ServicePaidAmount c
                             WHERE  a.ClaimId = c.ClaimId
                                    AND c.ServiceId < a.ServiceId )

    IF @@error <> 0
        RETURN

	/*
	update a
	set PaidAmount = b.ClaimPaidAmount*a.ServiceFraction
	from #ServicePaidAmount a
	JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)
	where b.ClaimPaidAmount <> b.TotalServicePaid
	*/
	-- Claim Level Adjustments
	-- The claim level adjustment is between the claim record
	-- and the first service record
    INSERT  INTO #ClaimAdjustmentLink
            ( ClaimId ,
              AdjustmentId
            )
            SELECT  a.ClaimId ,
                    b.ERFileSegmentId
            FROM    #ServiceSegmentLink a
                    JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ClaimId --srf ERFileSegments replaced
                                                AND b.ERFileSegmentId < ( a.ClaimId + 10 )
                                                AND b.ERFileSegmentId < a.ServiceId
                                              )
            WHERE   b.segment = 'CAS'
                    AND a.ServiceId IS NOT NULL
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ServiceSegmentLink c
                                     WHERE  a.ClaimId = c.ClaimId
                                            AND c.ServiceId < a.ServiceId )

    IF @@error <> 0
        RETURN

    INSERT  INTO #ClaimAdjustmentLink
            ( ClaimId ,
              AdjustmentId
            )
            SELECT  a.ClaimId ,
                    b.ERFileSegmentId
            FROM    #ServiceSegmentLink a
                    JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ClaimId --srf ERFileSegments replaced
                                                AND b.ERFileSegmentId < ( a.ClaimId + 10 )
                                              )
            WHERE   b.segment = 'CAS'
                    AND a.ServiceId IS NULL
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ServiceSegmentLink c
                                     WHERE  b.ERFileSegmentId > c.ClaimId
                                            AND c.ClaimId > a.ClaimId )

    IF @@error <> 0
        RETURN

	-- Service Level Adjustments
	-- The service level adjustment is service record
	-- and another service record for the same claim
	-- or between the service record and the next claim record
    INSERT  INTO #ServiceAdjustmentLink
            ( ClaimId ,
              ServiceId ,
              AdjustmentId
            )
            SELECT  a.ClaimId ,
                    a.ServiceId ,
                    b.ERFileSegmentId
            FROM    #ServiceSegmentLink a
                    JOIN #835ImportParse b ON ( b.ERFileSegmentId > a.ServiceId --srf replaced ERFileSegments
                                                AND b.ERFileSegmentId < ( a.ServiceId + 10 )
                                              )
            WHERE   b.segment = 'CAS'
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ServiceSegmentLink c
                                     WHERE  a.ClaimId = c.ClaimId
                                            AND c.ServiceId > a.ServiceId
                                            AND b.ERFileSegmentId > c.ServiceId )
                    AND NOT EXISTS ( SELECT *
                                     FROM   #ClaimSegmentLink c
                                     WHERE  c.ClaimId > a.ClaimId
                                            AND b.ERFileSegmentId > c.ClaimId )

    IF @@error <> 0
        RETURN

	-- Update Adjustment ids in #ClaimSegmentLink
	-- These ids can come from claim level adjustments or service level adjustments
    UPDATE  a
    SET     AdjustmentId1 = b.AdjustmentId ,
            ClaimLevelAdjustment1 = 'Y'
    FROM    #ServiceSegmentLink a
            JOIN #ClaimAdjustmentLink b ON ( a.ClaimId = b.ClaimId )
    WHERE   a.AdjustmentId1 IS NULL
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimAdjustmentLink c
                             WHERE  a.ClaimId = c.ClaimId
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId2 = b.AdjustmentId ,
            ClaimLevelAdjustment2 = 'Y'
    FROM    #ServiceSegmentLink a
            JOIN #ClaimAdjustmentLink b ON ( a.ClaimId = b.ClaimId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimAdjustmentLink c
                             WHERE  a.ClaimId = c.ClaimId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId3 = b.AdjustmentId ,
            ClaimLevelAdjustment3 = 'Y'
    FROM    #ServiceSegmentLink a
            JOIN #ClaimAdjustmentLink b ON ( a.ClaimId = b.ClaimId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NOT NULL
            AND a.AdjustmentId3 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND b.AdjustmentId <> a.AdjustmentId2
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimAdjustmentLink c
                             WHERE  a.ClaimId = c.ClaimId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId <> a.AdjustmentId2
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId4 = b.AdjustmentId ,
            ClaimLevelAdjustment4 = 'Y'
    FROM    #ServiceSegmentLink a
            JOIN #ClaimAdjustmentLink b ON ( a.ClaimId = b.ClaimId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NOT NULL
            AND a.AdjustmentId3 IS NOT NULL
            AND a.AdjustmentId4 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND b.AdjustmentId <> a.AdjustmentId2
            AND b.AdjustmentId <> a.AdjustmentId3
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimAdjustmentLink c
                             WHERE  a.ClaimId = c.ClaimId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId <> a.AdjustmentId2
                                    AND c.AdjustmentId <> a.AdjustmentId3
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId5 = b.AdjustmentId ,
            ClaimLevelAdjustment5 = 'Y'
    FROM    #ServiceSegmentLink a
            JOIN #ClaimAdjustmentLink b ON ( a.ClaimId = b.ClaimId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NOT NULL
            AND a.AdjustmentId3 IS NOT NULL
            AND a.AdjustmentId4 IS NOT NULL
            AND a.AdjustmentId5 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND b.AdjustmentId <> a.AdjustmentId2
            AND b.AdjustmentId <> a.AdjustmentId3
            AND b.AdjustmentId <> a.AdjustmentId4
            AND NOT EXISTS ( SELECT *
                             FROM   #ClaimAdjustmentLink c
                             WHERE  a.ClaimId = c.ClaimId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId <> a.AdjustmentId2
                                    AND c.AdjustmentId <> a.AdjustmentId3
                                    AND c.AdjustmentId <> a.AdjustmentId4
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

	-- Service Level
    UPDATE  a
    SET     AdjustmentId1 = b.AdjustmentId ,
            ClaimLevelAdjustment1 = 'N'
    FROM    #ServiceSegmentLink a
            JOIN #ServiceAdjustmentLink b ON ( a.ServiceId = b.ServiceId )
    WHERE   a.AdjustmentId1 IS NULL
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceAdjustmentLink c
                             WHERE  a.ServiceId = c.ServiceId
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId2 = b.AdjustmentId ,
            ClaimLevelAdjustment2 = 'N'
    FROM    #ServiceSegmentLink a
            JOIN #ServiceAdjustmentLink b ON ( a.ServiceId = b.ServiceId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceAdjustmentLink c
                             WHERE  a.ServiceId = c.ServiceId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId3 = b.AdjustmentId ,
            ClaimLevelAdjustment3 = 'N'
    FROM    #ServiceSegmentLink a
            JOIN #ServiceAdjustmentLink b ON ( a.ServiceId = b.ServiceId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NOT NULL
            AND a.AdjustmentId3 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND b.AdjustmentId <> a.AdjustmentId2
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceAdjustmentLink c
                             WHERE  a.ServiceId = c.ServiceId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId <> a.AdjustmentId2
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId4 = b.AdjustmentId ,
            ClaimLevelAdjustment4 = 'N'
    FROM    #ServiceSegmentLink a
            JOIN #ServiceAdjustmentLink b ON ( a.ServiceId = b.ServiceId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NOT NULL
            AND a.AdjustmentId3 IS NOT NULL
            AND a.AdjustmentId4 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND b.AdjustmentId <> a.AdjustmentId2
            AND b.AdjustmentId <> a.AdjustmentId3
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceAdjustmentLink c
                             WHERE  a.ServiceId = c.ServiceId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId <> a.AdjustmentId2
                                    AND c.AdjustmentId <> a.AdjustmentId3
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

    UPDATE  a
    SET     AdjustmentId5 = b.AdjustmentId ,
            ClaimLevelAdjustment5 = 'N'
    FROM    #ServiceSegmentLink a
            JOIN #ServiceAdjustmentLink b ON ( a.ServiceId = b.ServiceId )
    WHERE   a.AdjustmentId1 IS NOT NULL
            AND a.AdjustmentId2 IS NOT NULL
            AND a.AdjustmentId3 IS NOT NULL
            AND a.AdjustmentId4 IS NOT NULL
            AND a.AdjustmentId5 IS NULL
            AND b.AdjustmentId <> a.AdjustmentId1
            AND b.AdjustmentId <> a.AdjustmentId2
            AND b.AdjustmentId <> a.AdjustmentId3
            AND b.AdjustmentId <> a.AdjustmentId4
            AND NOT EXISTS ( SELECT *
                             FROM   #ServiceAdjustmentLink c
                             WHERE  a.ServiceId = c.ServiceId
                                    AND c.AdjustmentId <> a.AdjustmentId1
                                    AND c.AdjustmentId <> a.AdjustmentId2
                                    AND c.AdjustmentId <> a.AdjustmentId3
                                    AND c.AdjustmentId <> a.AdjustmentId4
                                    AND c.AdjustmentId < b.AdjustmentId )

    IF @@error <> 0
        RETURN

	-- Get information from PLB segment
    INSERT  INTO #PLBSegment
            ( BatchERFileSegmentId ,
              PLBId ,
              FiscalPeriodDate ,
              AdjustmentIdentifier1 ,
              AdjustmentAmount1 ,
              AdjustmentIdentifier2 ,
              AdjustmentAmount2 ,
              AdjustmentIdentifier3 ,
              AdjustmentAmount3 ,
              AdjustmentIdentifier4 ,
              AdjustmentAmount4 ,
              AdjustmentIdentifier5 ,
              AdjustmentAmount5 ,
              AdjustmentIdentifier6 ,
              AdjustmentAmount6
            )
            SELECT  b.ERFileSegmentId ,
                    a.ERFileSegmentId ,
                    CONVERT(DATETIME, SUBSTRING(a.Element2, 5, 2) + '/' + SUBSTRING(a.Element2, 7, 2) + '/' + SUBSTRING(a.Element2, 1, 4)) ,
                    a.Element3 ,
                    CONVERT(MONEY, a.Element4) ,
                    a.Element5 ,
                    CONVERT(MONEY, a.Element6) ,
                    a.Element7 ,
                    CONVERT(MONEY, a.Element8) ,
                    a.Element9 ,
                    CONVERT(MONEY, a.Element10) ,
                    a.Element11 ,
                    CONVERT(MONEY, a.Element12) ,
                    a.Element13 ,
                    CONVERT(MONEY, a.Element14)
            FROM    #835ImportParse a
                    JOIN @835Batch b ON ( a.ERFileSegmentId > b.ERFileSegmentId )
            WHERE   segment = 'PLB'
                    AND NOT EXISTS ( SELECT *
                                     FROM   @835Batch c
                                     WHERE  a.ERFileSegmentId > c.ERFileSegmentId
                                            AND c.ERFileSegmentId > b.ERFileSegmentId )

    IF @@error <> 0
        RETURN


	-- Enter data into batch
    BEGIN TRAN

    IF @@error <> 0
        RETURN

	-- Create batch information
    DECLARE @BatchDetailId INT ,
        @BatchStartId INT ,
        @BatchEndId INT
    DECLARE @BatchCount INT ,
        @TotalBatches INT
    DECLARE @HandlingCode CHAR(1)

    SELECT  @BatchCount = 0 ,
            @TotalBatches = COUNT(*)
    FROM    @835Batch

    IF @@error <> 0
        GOTO error
    IF CURSOR_STATUS('global', 'cur_batch') >= -1
        BEGIN
            CLOSE cur_batch
            DEALLOCATE cur_batch
        END
    DECLARE cur_batch CURSOR
    FOR
        SELECT  ERFileSegmentId ,
                BatchStartId ,
                BatchEndId ,
                HandlingCode
        FROM    @835Batch
        ORDER BY ERFileSegmentId

    IF @@error <> 0
        GOTO error

    OPEN cur_batch

    IF @@error <> 0
        BEGIN
            DEALLOCATE cur_batch
            GOTO error
        END

    FETCH cur_batch INTO @BatchDetailId, @BatchStartId, @BatchEndId, @HandlingCode

    IF @@error <> 0
        BEGIN
            CLOSE cur_batch
            DEALLOCATE cur_batch
            GOTO error
        END

    WHILE @@fetch_status = 0
        BEGIN

            SELECT  @BatchCount = @BatchCount + 1

		-- Only handle remittance
            IF @HandlingCode <> 'I'
                GOTO fetch_next

		-- Check if the file was imported before

		--LOOK INTO
            IF EXISTS ( SELECT  *
                        FROM    ERBatches a
                                JOIN @835Batch b ON ( a.CheckNumber = b.CheckNumber
                                                      AND a.CheckDate = b.CheckDate
                                                    )
								LEFT JOIN dbo.ssf_RecodeValuesCurrent('ERNonPaymentCheckNumbers') AS checknums ON checknums.CharacterCodeId = a.CheckNumber
                        WHERE   --a.ERSenderId = @ERSenderId  srf ??
                                b.ERFileSegmentId = @BatchDetailId
                                AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                AND ISNULL(a.CheckNumber, '') <> ''
                                AND ISNULL(b.CheckNumber, '') <> ''
                                AND (ISNULL(a.CheckNumber, '0') <> '0' 
										OR checknums.CharacterCodeId IS NOT NULL
									)

								)
                BEGIN
                    INSERT  INTO @ParseErrors
                            ( ErFileId,
							  LineNumber ,
                              ErrorMessage ,
                              LineDataText
                            )
                            SELECT  DISTINCT
									@ERFileId,
                                    1 ,
                                    'Check: ' + a.CheckNumber + ' has been imported once' ,
                                    NULL
                            FROM    ERBatches a
                                    JOIN @835Batch b ON ( a.CheckNumber = b.CheckNumber
                                                          AND a.CheckDate = b.CheckDate
                                                        )
                            WHERE   b.ERFileSegmentId = @BatchDetailId
                                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(a.CheckNumber, '') <> ''
                                    AND ISNULL(b.CheckNumber, '') <> ''
                                    AND ISNULL(a.CheckNumber, '0') <> '0' 
                    --VALUES  ( 1 ,
                    --          'File has been imported once' ,
                    --          NULL
                    --        ) --?? what do i use for line number?
			-- select @ErrorNo = 30005, @ErrorMessage = 'File has been imported once'
                    
                    
                    GOTO fetch_next
                    
                    --CLOSE cur_batch
                    --DEALLOCATE cur_batch
                    --GOTO error
                END


            INSERT  INTO ERBatches
                    ( ERFileID ,
                      SenderBatchId ,
                      CheckAmount ,
                      CheckDate ,
                      CheckNumber ,
                      ERPayerName ,
                      ERPayerIdentifier ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
                    SELECT  ERFileId ,
                            1 ,
                            CheckAmount ,
                            CheckDate ,
                            CheckNumber ,
                            PayerName ,
                            PayerIdentifier ,
                            @UserCode ,
                            GETDATE() ,
                            @UserCode ,
                            GETDATE()
                    FROM    @835Batch
                    WHERE   ERFileSegmentId = @BatchDetailId

            SELECT  @BatchNumber = @@identity
			

            IF @BatchNumber < 1
                BEGIN
                    INSERT  INTO @ParseErrors
                            ( ERFileId,
							  LineNumber ,
                              ErrorMessage ,
                              LineDataText
                            )
                    VALUES  ( @ERFileId,
							  1 ,
                              'Failure to create batch record' ,
                              NULL
                            )
			-- select @ErrorNo = 30002, @ErrorMessage = 'Failure to create batch record'
                    CLOSE cur_batch
                    DEALLOCATE cur_batch
                    GOTO error
                END

            UPDATE  @835Batch
            SET     BatchNumber = @BatchNumber
            WHERE   ERFileSegmentId = @BatchDetailId

            IF @@error <> 0
                BEGIN
                    CLOSE cur_batch
                    DEALLOCATE cur_batch
                    GOTO error
                END

		/*
		LOOK INTO
		if @BatchCount = 1
		insert into ERBatches_Detail
		(BatchNumber , data_text)
		select @BatchNumber, a.data_text
		from Cstm_835_Import_Temp a
		where a.ERFileSegmentId <= @BatchEndId
		order by a.ERFileSegmentId
		else if @BatchCount = @TotalBatches
		insert into ERBatches_Detail
		(BatchNumber , data_text)
		select @BatchNumber, a.data_text
		from Cstm_835_Import_Temp a
		where a.ERFileSegmentId >= @BatchStartId
		order by a.ERFileSegmentId
		else
		insert into ERBatches_Detail
		(BatchNumber , data_text)
		select @BatchNumber, a.data_text
		from Cstm_835_Import_Temp a
		where a.ERFileSegmentId >= @BatchStartId
		and a.ERFileSegmentId <= @BatchEndId
		order by a.ERFileSegmentId
		
		
		if @@error <> 0
		begin
		close cur_batch
		deallocate cur_batch
		goto error
		end
		*/


            INSERT  INTO ERBatchProviderAdjustments
                    ( ERBatchID ,
                      FiscalPeriodDate ,
                      AdjustmentIdentifier1 ,
                      AdjustmentAmount1 ,
                      AdjustmentIdentifier2 ,
                      AdjustmentAmount2 ,
                      AdjustmentIdentifier3 ,
                      AdjustmentAmount3 ,
                      AdjustmentIdentifier4 ,
                      AdjustmentAmount4 ,
                      AdjustmentIdentifier5 ,
                      AdjustmentAmount5 ,
                      AdjustmentIdentifier6 ,
                      AdjustmentAmount6
                    )
                    SELECT  @BatchNumber ,
                            FiscalPeriodDate ,
                            AdjustmentIdentifier1 ,
                            AdjustmentAmount1 ,
                            AdjustmentIdentifier2 ,
                            AdjustmentAmount2 ,
                            AdjustmentIdentifier3 ,
                            AdjustmentAmount3 ,
                            AdjustmentIdentifier4 ,
                            AdjustmentAmount4 ,
                            AdjustmentIdentifier5 ,
                            AdjustmentAmount5 ,
                            AdjustmentIdentifier6 ,
                            AdjustmentAmount6
                    FROM    #PLBSegment
                    WHERE   BatchERFileSegmentId = @BatchDetailId


            IF @@error <> 0
                BEGIN
                    CLOSE cur_batch
                    DEALLOCATE cur_batch
                    GOTO error
                END


            fetch_next:

            FETCH cur_batch INTO @BatchDetailId, @BatchStartId, @BatchEndId, @HandlingCode

            IF @@error <> 0
                BEGIN
                    CLOSE cur_batch
                    DEALLOCATE cur_batch
                    GOTO error
                END


        END

    CLOSE cur_batch

    IF @@error <> 0
        BEGIN
            DEALLOCATE cur_batch
            GOTO error
        END


    DEALLOCATE cur_batch


    INSERT  INTO ERClaimLineItems
            ( ERBatchId ,
              ClaimLineItemId ,
              LineItemControlNumber ,
              ClaimLineItemGroupId ,
              ClientName ,
              ClientIdentifier ,
              PayerClaimNumber ,
              BillingCode ,
              DateOfService , --srf ??
              ChargeAmount ,
              PaidAmount ,
              AdjustmentGroupCode11 ,
              AdjustmentReason11 ,
              AdjustmentAmount11 ,
              AdjustmentQuantity11 ,
              AdjustmentReason12 ,
              AdjustmentAmount12 ,
              AdjustmentQuantity12 ,
              AdjustmentReason13 ,
              AdjustmentAmount13 ,
              AdjustmentQuantity13 ,
              AdjustmentReason14 ,
              AdjustmentAmount14 ,
              AdjustmentQuantity14 ,
              AdjustmentGroupCode21 ,
              AdjustmentReason21 ,
              AdjustmentAmount21 ,
              AdjustmentQuantity21 ,
              AdjustmentReason22 ,
              AdjustmentAmount22 ,
              AdjustmentQuantity22 ,
              AdjustmentReason23 ,
              AdjustmentAmount23 ,
              AdjustmentQuantity23 ,
              AdjustmentReason24 ,
              AdjustmentAmount24 ,
              AdjustmentQuantity24 ,
              AdjustmentGroupCode31 ,
              AdjustmentReason31 ,
              AdjustmentAmount31 ,
              AdjustmentQuantity31 ,
              AdjustmentReason32 ,
              AdjustmentAmount32 ,
              AdjustmentQuantity32 ,
              AdjustmentReason33 ,
              AdjustmentAmount33 ,
              AdjustmentQuantity33 ,
              AdjustmentReason34 ,
              AdjustmentAmount34 ,
              AdjustmentQuantity34 ,
              AdjustmentGroupCode41 ,
              AdjustmentReason41 ,
              AdjustmentAmount41 ,
              AdjustmentQuantity41 ,
              AdjustmentReason42 ,
              AdjustmentAmount42 ,
              AdjustmentQuantity42 ,
              AdjustmentReason43 ,
              AdjustmentAmount43 ,
              AdjustmentQuantity43 ,
              AdjustmentReason44 ,
              AdjustmentAmount44 ,
              AdjustmentQuantity44 ,
              AdjustmentGroupCode51 ,
              AdjustmentReason51 ,
              AdjustmentAmount51 ,
              AdjustmentQuantity51 ,
              AdjustmentReason52 ,
              AdjustmentAmount52 ,
              AdjustmentQuantity52 ,
              AdjustmentReason53 ,
              AdjustmentAmount53 ,
              AdjustmentQuantity53 ,
              AdjustmentReason54 ,
              AdjustmentAmount54 ,
              AdjustmentQuantity54,
			  ClaimLineInterest   -- 5/22/18 MJensen
            )
            SELECT  z.BatchNumber ,
                    CLI.ClaimLineItemId ,
                    b.LineItemControlNumber ,
                    b.ClaimLineItemGroupId ,
                    d.Element3 + ', ' + d.Element4 ,
                    c.Element1 ,
                    c.Element7 ,
                    RIGHT(f.Element1, LEN(f.Element1) - 3) ,
                    CONVERT(DATETIME, SUBSTRING(g.Element2, 5, 2) + '/' + SUBSTRING(g.Element2, 7, 2) + '/' + SUBSTRING(g.Element2, 1, 4)) ,
                    j.ChargeAmount ,
                    j.PaidAmount , --k.CheckNumber, k.CheckDate,
                    h1.Element1 ,
                    h1.Element2 ,
                    CONVERT(MONEY, h1.Element3) / CASE WHEN ISNULL(b.ClaimLevelAdjustment1, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h1.Element4) ,
                    h1.Element5 ,
                    CONVERT(MONEY, h1.Element6) / CASE WHEN ISNULL(b.ClaimLevelAdjustment1, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h1.Element7) ,
                    h1.Element8 ,
                    CONVERT(MONEY, h1.Element9) / CASE WHEN ISNULL(b.ClaimLevelAdjustment1, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h1.Element10) ,
                    h1.Element11 ,
                    CONVERT(MONEY, h1.Element12) / CASE WHEN ISNULL(b.ClaimLevelAdjustment1, 'N') = 'N' THEN 1
                                                        ELSE l.ServiceCount
                                                   END ,
                    CONVERT(DECIMAL(6, 2), h1.Element13) ,
                    h2.Element1 ,
                    h2.Element2 ,
                    CONVERT(MONEY, h2.Element3) / CASE WHEN ISNULL(b.ClaimLevelAdjustment2, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h2.Element4) ,
                    h2.Element5 ,
                    CONVERT(MONEY, h2.Element6) / CASE WHEN ISNULL(b.ClaimLevelAdjustment2, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h2.Element7) ,
                    h2.Element8 ,
                    CONVERT(MONEY, h2.Element9) / CASE WHEN ISNULL(b.ClaimLevelAdjustment2, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h2.Element10) ,
                    h2.Element11 ,
                    CONVERT(MONEY, h2.Element12) / CASE WHEN ISNULL(b.ClaimLevelAdjustment2, 'N') = 'N' THEN 1
                                                        ELSE l.ServiceCount
                                                   END ,
                    CONVERT(DECIMAL(6, 2), h2.Element13) ,
                    h3.Element1 ,
                    h3.Element2 ,
                    CONVERT(MONEY, h3.Element3) / CASE WHEN ISNULL(b.ClaimLevelAdjustment3, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h3.Element4) ,
                    h3.Element5 ,
                    CONVERT(MONEY, h3.Element6) / CASE WHEN ISNULL(b.ClaimLevelAdjustment3, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h3.Element7) ,
                    h3.Element8 ,
                    CONVERT(MONEY, h3.Element9) / CASE WHEN ISNULL(b.ClaimLevelAdjustment3, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h3.Element10) ,
                    h3.Element11 ,
                    CONVERT(MONEY, h3.Element12) / CASE WHEN ISNULL(b.ClaimLevelAdjustment3, 'N') = 'N' THEN 1
                                                        ELSE l.ServiceCount
                                                   END ,
                    CONVERT(DECIMAL(6, 2), h3.Element13) ,
                    h4.Element1 ,
                    h4.Element2 ,
                    CONVERT(MONEY, h4.Element3) / CASE WHEN ISNULL(b.ClaimLevelAdjustment4, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h4.Element4) ,
                    h4.Element5 ,
                    CONVERT(MONEY, h4.Element6) / CASE WHEN ISNULL(b.ClaimLevelAdjustment4, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h4.Element7) ,
                    h4.Element8 ,
                    CONVERT(MONEY, h4.Element9) / CASE WHEN ISNULL(b.ClaimLevelAdjustment4, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h4.Element10) ,
                    h4.Element11 ,
                    CONVERT(MONEY, h4.Element12) / CASE WHEN ISNULL(b.ClaimLevelAdjustment4, 'N') = 'N' THEN 1
                                                        ELSE l.ServiceCount
                                                   END ,
                    CONVERT(DECIMAL(6, 2), h4.Element13) ,
                    h5.Element1 ,
                    h5.Element2 ,
                    CONVERT(MONEY, h5.Element3) / CASE WHEN ISNULL(b.ClaimLevelAdjustment5, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h5.Element4) ,
                    h5.Element5 ,
                    CONVERT(MONEY, h5.Element6) / CASE WHEN ISNULL(b.ClaimLevelAdjustment5, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h5.Element7) ,
                    h5.Element8 ,
                    CONVERT(MONEY, h5.Element9) / CASE WHEN ISNULL(b.ClaimLevelAdjustment5, 'N') = 'N' THEN 1
                                                       ELSE l.ServiceCount
                                                  END ,
                    CONVERT(DECIMAL(6, 2), h5.Element10) ,
                    h5.Element11 ,
                    CONVERT(MONEY, h5.Element12) / CASE WHEN ISNULL(b.ClaimLevelAdjustment5, 'N') = 'N' THEN 1
                                                        ELSE l.ServiceCount
                                                   END ,
                    CONVERT(DECIMAL(6, 2), h5.Element13),
					CASE WHEN clis.Element2 IS NOT NULL then CAST(clis.Element2 AS MONEY) ELSE clis.Element2 END  -- 5/22/18 MJensen
            FROM    @835Batch z
                    JOIN #ClaimSegmentLink a ON ( a.BatchERFileSegmentId = z.ERFileSegmentId )
                    JOIN #ServiceSegmentLink b ON ( a.ClaimId = b.ClaimId )
                    JOIN #835ImportParse c ON ( a.ClaimId = c.ERFileSegmentId )
                    JOIN #835ImportParse d ON ( a.PatientNameId = d.ERFileSegmentId )
                    LEFT JOIN #835ImportParse e ON ( a.PayorBatchId = e.ERFileSegmentId )
                    LEFT JOIN #835ImportParse f ON ( b.ServiceId = f.ERFileSegmentId )
                    LEFT JOIN #835ImportParse g ON ( ISNULL(b.ServiceDateId, b.ServiceDateIdMin) = g.ERFileSegmentId )
                                              AND g.segment = 'DTM'--srf added so only rows with Service Date are returned
                    LEFT JOIN #835ImportParse h1 ON ( b.AdjustmentId1 = h1.ERFileSegmentId )
                    LEFT JOIN #835ImportParse h2 ON ( b.AdjustmentId2 = h2.ERFileSegmentId )
                    LEFT JOIN #835ImportParse h3 ON ( b.AdjustmentId3 = h3.ERFileSegmentId )
                    LEFT JOIN #835ImportParse h4 ON ( b.AdjustmentId4 = h4.ERFileSegmentId )
                    LEFT JOIN #835ImportParse h5 ON ( b.AdjustmentId5 = h5.ERFileSegmentId )
	--LEFT JOIN ERFilesegments i ON (b.LineItemNoId = i.ERFileSegmentId)
                    JOIN #ServicePaidAmount j ON ( ( b.ServiceId IS NOT NULL
                                                     AND b.ServiceId = j.ServiceId
                                                   )
                                                   OR ( b.ServiceId IS NULL
                                                        AND ( b.ClaimId = j.ClaimId )
                                                      )
                                                 )
                    JOIN ERBatches k ON ( z.BatchNumber = k.ERBatchId )
                    LEFT JOIN #ClaimServiceCount l ON l.ClaimId = a.ClaimId
	--Added by Msuma to avoid Constraint Error
	--LEFT OUTER JOIN ClaimLineItems CLI ON(CLI.ClaimLineItemId = convert(int, substring(c.Element1, charindex('-', c.Element1) + 1 , len(c.Element1))))
                    LEFT OUTER JOIN ClaimLineItems CLI ON ( CLI.ClaimLineItemId = b.ClaimLineItemId )
					LEFT JOIN #ClaimInterestSegment clis ON clis.ClaimId = b.ClaimId  -- 5/22/18 MJensen
            WHERE   --len(substring(c.Element1,10,15)) <= 10  --srf ??
		/*
		len( substring(c.Element1, charindex('-', c.Element1) + 1 , len(c.Element1))) <=10
		--and isnumeric(substring(c.Element1,10,15)) = 1
		and isnumeric( substring(c.Element1, charindex('-', c.Element1) + 1 , len(c.Element1))) =1
		and c.Element1 like '%-%'
		and */      z.HandlingCode = 'I'

	--and b.LineItemNoId is not null --srf added so rows are not duplicated
            ORDER BY a.ClaimId


    IF @@error <> 0
        GOTO error

--SELECT * FROM dbo.ERClaimLineItems


    INSERT  INTO ERClaimLineItemLog
            ( ERClaimLineItemId ,
              ErrorFlag ,
              ERMessageType ,
              ERMessage
            )
            SELECT DISTINCT
                    ERClaimLineItemId ,
                    'Y' ,
                    5233 ,
                    'ClaimLineItem ' + ISNULL(LineItemControlNumber, 'NULL') + ' does not exist in the system or Claim ID ' + ISNULL(a.ClientIdentifier, 'NULL') + ' is incorrect.'
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber -- Added by Venkatesh as per the task 1434
            WHERE   a.ClaimLineItemId IS NULL




    IF @@error <> 0
        GOTO error

    INSERT  INTO ERClaimLineItemAdjustments
            ( ERClaimLineItemId ,
              AdjustmentGroupCode ,
              AdjustmentReason ,
              AdjustmentAmount ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode11 ,
                    AdjustmentReason11 ,
                    AdjustmentAmount11 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason11, '') <> ''
                    AND ISNULL(a.AdjustmentAmount11, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode11 ,
                    AdjustmentReason12 ,
                    AdjustmentAmount12 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason12, '') <> ''
                    AND ISNULL(a.AdjustmentAmount12, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode11 ,
                    AdjustmentReason13 ,
                    AdjustmentAmount13 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason13, '') <> ''
                    AND ISNULL(a.AdjustmentAmount13, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode11 ,
                    AdjustmentReason14 ,
                    AdjustmentAmount14 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason14, '') <> ''
                    AND ISNULL(a.AdjustmentAmount14, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode21 ,
                    AdjustmentReason21 ,
                    AdjustmentAmount21 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason21, '') <> ''
                    AND ISNULL(a.AdjustmentAmount21, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode21 ,
                    AdjustmentReason22 ,
                    AdjustmentAmount22 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason22, '') <> ''
                    AND ISNULL(a.AdjustmentAmount22, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode21 ,
                    AdjustmentReason23 ,
                    AdjustmentAmount23 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason23, '') <> ''
                    AND ISNULL(a.AdjustmentAmount23, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode21 ,
                    AdjustmentReason24 ,
                    AdjustmentAmount24 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason24, '') <> ''
                    AND ISNULL(a.AdjustmentAmount24, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode31 ,
                    AdjustmentReason31 ,
                    AdjustmentAmount31 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason31, '') <> ''
                    AND ISNULL(a.AdjustmentAmount31, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode31 ,
                    AdjustmentReason32 ,
                    AdjustmentAmount32 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason32, '') <> ''
                    AND ISNULL(a.AdjustmentAmount32, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode31 ,
                    AdjustmentReason33 ,
                    AdjustmentAmount33 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason33, '') <> ''
                    AND ISNULL(a.AdjustmentAmount33, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode31 ,
                    AdjustmentReason34 ,
                    AdjustmentAmount34 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason34, '') <> ''
                    AND ISNULL(a.AdjustmentAmount34, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode41 ,
                    AdjustmentReason41 ,
                    AdjustmentAmount41 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason41, '') <> ''
                    AND ISNULL(a.AdjustmentAmount41, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode51 ,
                    AdjustmentReason51 ,
                    AdjustmentAmount51 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason51, '') <> ''
                    AND ISNULL(a.AdjustmentAmount51, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode51 ,
                    AdjustmentReason52 ,
                    AdjustmentAmount52 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason52, '') <> ''
                    AND ISNULL(a.AdjustmentAmount52, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode51 ,
                    AdjustmentReason53 ,
                    AdjustmentAmount53 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason53, '') <> ''
                    AND ISNULL(a.AdjustmentAmount53, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
            UNION
            SELECT  ERClaimLineItemId ,
                    AdjustmentGroupCode51 ,
                    AdjustmentReason54 ,
                    AdjustmentAmount54 ,
                    @UserCode ,
                    GETDATE() ,
                    @UserCode ,
                    GETDATE()
            FROM    ERClaimLineItems a
                    JOIN @835Batch z ON a.ERBatchId = z.BatchNumber
            WHERE   ISNULL(a.AdjustmentReason54, '') <> ''
                    AND ISNULL(a.AdjustmentAmount54, '') <> ''
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'




    IF @@error <> 0
        GOTO error

	-- Verify if the individual paid amounts add up to the total
    CREATE TABLE #BatchAutoPaid
        (
          BatchNumber INT NULL ,
          TotalAutoPaid MONEY NULL
        )

    CREATE TABLE #BatchPLB
        (
          BatchNumber INT NULL ,
          TotalAutoPaid MONEY NULL
        )

	-- Add the line item paid amounts
    INSERT  INTO #BatchAutoPaid
            ( BatchNumber ,
              TotalAutoPaid
            )
            SELECT  a.BatchNumber ,
                    ISNULL(SUM(b.PaidAmount), 0)
            FROM    @835Batch a
                    LEFT JOIN ERClaimLineItems b ON ( a.BatchNumber = b.ERBatchId )
            WHERE   a.HandlingCode = 'I'
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
            GROUP BY a.BatchNumber

    IF @@error <> 0
        GOTO error

	-- Add the provider adjustment paid amounts
    INSERT  INTO #BatchPLB
            ( BatchNumber ,
              TotalAutoPaid
            )
            SELECT  a.BatchNumber ,
                    SUM(ISNULL(b.AdjustmentAmount1, 0) + ISNULL(b.AdjustmentAmount2, 0) + ISNULL(b.AdjustmentAmount3, 0) + ISNULL(b.AdjustmentAmount4, 0) + ISNULL(b.AdjustmentAmount5, 0) + ISNULL(b.AdjustmentAmount6, 0))
            FROM    @835Batch a
                    LEFT JOIN ERBatchProviderAdjustments b ON ( a.BatchNumber = b.ERBatchId )
            WHERE   a.HandlingCode = 'I'
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
            GROUP BY a.BatchNumber

    IF @@error <> 0
        GOTO error

    UPDATE  a
    SET     TotalAutoPaid = a.TotalAutoPaid - b.TotalAutoPaid
    FROM    #BatchAutoPaid a
            JOIN #BatchPLB b ON ( a.BatchNumber = b.BatchNumber )

    IF @@error <> 0
        GOTO error
	
	
	-- Compare the total to the check amount
	IF EXISTS (
			SELECT *
			FROM @835Batch a
			JOIN #BatchAutoPaid b ON (a.BatchNumber = b.BatchNumber)
			WHERE a.HandlingCode = 'I'
				AND ISNULL(a.CheckAmount, 0) <> ISNULL(b.TotalAutoPaid, 0)
			)
	BEGIN
		IF (
				SELECT ISNULL(ers.PostOutOfBalanceBatches, 'N')
				FROM erfiles erf
				JOIN ERSenders ers ON ers.ERSenderId = erf.ERSenderId
				WHERE erf.ERFileId = @ERFileId
				) = 'Y'
		BEGIN
			INSERT INTO ERFileParsingErrors (
				ERFileId
				,ERFilesegmentId
				,LineNumber
				,ErrorMessage
				,LineDataText
				,CreatedBy
				,ModifiedBy
				)
			SELECT @ERFileId
				,a.ERFileSegmentId
				,a.BatchStartId - a.ERFileSegmentId
				,'Error: Computed total paid amount different from value sent in 835 for batch ' + CAST(ISNULL(a.BatchNumber, 0) AS VARCHAR(20))
				,NULL
				,@UserCode
				,@UserCode
			FROM @835Batch a
			JOIN #BatchAutoPaid b ON (a.BatchNumber = b.BatchNumber)
			WHERE a.HandlingCode = 'I'
				AND ISNULL(a.CheckAmount, 0) <> ISNULL(b.TotalAutoPaid, 0)
		END
		ELSE
		BEGIN
			INSERT INTO @ParseErrors (
				ERFileId,
				LineNumber
				,ErrorMessage
				,LineDataText
				)
			VALUES (
				@ERFileId,
				1
				,'Error: Computed total paid amount different from value sent in 835. Please contact system administrator.'
				,NULL
				)

			GOTO error
		END
	END


	-- update provider adjustments in the batch table
    UPDATE  a
    SET     TotalProviderAdjustments = b.TotalAutoPaid
    FROM    ERBatches a
            JOIN #BatchPLB b ON ( a.ERBatchId = b.BatchNumber )
    WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'


    IF @@error <> 0
        GOTO error

	-- Update the correct client id from the ClaimLineItemGroups table
	-- this should actually stay the patient id.


	--update a
	--set ClientIdentifier = c.ClientId
	--from ERClaimLineItems a
	--JOIN ClaimLineItems b ON a.ClaimLineItemId = b.ClaimLineItemId
	--Join ClaimLineItemGroups c on b.ClaimLineItemGroupId = c.ClaimLineItemGroupId
	--where  isnull(a.RecordDeleted, 'N')= 'N'
	--and isnull(b.RecordDeleted, 'N')= 'N'
	--and isnull(c.RecordDeleted, 'N')= 'N'


    IF @@error <> 0
        GOTO error

	--begin tran

	-- identify entries that offset each other exactly and delete them

 --   SELECT  li.ERClaimLineItemId AS ERClaimLineItem1 ,
 --           li2.ERClaimLineItemId AS ERClaimLineItem2
 --   INTO    #ERClaimLineItemOffsets
 --   FROM    ERClaimLineItems AS li
 --           JOIN ERBatches AS b ON b.ERBatchId = li.ERBatchId
 --           JOIN ERBatches AS b2 ON b2.ERFileId = b.ERFileId
 --           JOIN ERClaimLineItems AS li2 ON li2.ERBatchId = b2.ERBatchId
 --   WHERE   b.ERFileId = @ERFileId
 --           AND li.PaidAmount < 0
 --           AND li2.DateOfService = li.DateOfService
 --           AND ABS(li2.ChargeAmount) = ABS(li.ChargeAmount)
 --           AND LTRIM(RTRIM(CASE WHEN CHARINDEX('-', li2.ClientIdentifier) > 1 THEN SUBSTRING(li2.ClientIdentifier, 1, CHARINDEX('-', li2.ClientIdentifier) - 1)
 --                                ELSE li2.ClientIdentifier
 --                           END)) = LTRIM(RTRIM(CASE WHEN CHARINDEX('-', li.ClientIdentifier) > 1 THEN SUBSTRING(li.ClientIdentifier, 1, CHARINDEX('-', li.ClientIdentifier) - 1)
 --                                                    ELSE li.ClientIdentifier
 --                                               END))
 --           AND li2.PaidAmount + li.PaidAmount = 0.0
 --           AND ISNULL(li2.AdjustmentAmount11, 0.0) + ISNULL(li.AdjustmentAmount11, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount12, 0.0) + ISNULL(li.AdjustmentAmount12, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount13, 0.0) + ISNULL(li.AdjustmentAmount13, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount14, 0.0) + ISNULL(li.AdjustmentAmount14, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount21, 0.0) + ISNULL(li.AdjustmentAmount21, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount22, 0.0) + ISNULL(li.AdjustmentAmount22, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount23, 0.0) + ISNULL(li.AdjustmentAmount23, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount24, 0.0) + ISNULL(li.AdjustmentAmount24, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount31, 0.0) + ISNULL(li.AdjustmentAmount31, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount32, 0.0) + ISNULL(li.AdjustmentAmount32, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount33, 0.0) + ISNULL(li.AdjustmentAmount33, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount34, 0.0) + ISNULL(li.AdjustmentAmount34, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount41, 0.0) + ISNULL(li.AdjustmentAmount41, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount42, 0.0) + ISNULL(li.AdjustmentAmount42, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount43, 0.0) + ISNULL(li.AdjustmentAmount43, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount44, 0.0) + ISNULL(li.AdjustmentAmount44, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount51, 0.0) + ISNULL(li.AdjustmentAmount51, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount52, 0.0) + ISNULL(li.AdjustmentAmount52, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount53, 0.0) + ISNULL(li.AdjustmentAmount53, 0.0) = 0.0
 --           AND ISNULL(li2.AdjustmentAmount54, 0.0) + ISNULL(li.AdjustmentAmount54, 0.0) = 0.0

 --   IF @@error <> 0
 --       GOTO error

	---- delete any duplicate allocations
 --   DELETE  FROM a
 --   FROM    #ERClaimLineItemOffsets AS a
 --   WHERE   EXISTS ( SELECT *
 --                    FROM   #ERClaimLineItemOffsets AS b
 --                    WHERE  b.ERClaimLineItem1 = a.ERClaimLineItem1
 --                           AND b.ERClaimLineItem2 < a.ERClaimLineItem2 )
 --   IF @@error <> 0
 --       GOTO error

	---- delete any duplicate allocations
 --   DELETE  FROM a
 --   FROM    #ERClaimLineItemOffsets AS a
 --   WHERE   EXISTS ( SELECT *
 --                    FROM   #ERClaimLineItemOffsets AS b
 --                    WHERE  b.ERClaimLineItem2 = a.ERClaimLineItem2
 --                           AND b.ERClaimLineItem1 < a.ERClaimLineItem1 )
 --   IF @@error <> 0
 --       GOTO error


 --   DELETE  FROM a
 --   FROM    ERClaimLineItemAdjustments AS a
 --           JOIN #ERClaimLineItemOffsets AS b ON b.ERClaimLineItem1 = a.ERClaimLineItemId
 --   IF @@error <> 0
 --       GOTO error

 --   DELETE  FROM a
 --   FROM    ERClaimLineItemLog AS a
 --           JOIN #ERClaimLineItemOffsets AS b ON b.ERClaimLineItem1 = a.ERClaimLineItemId
 --   IF @@error <> 0
 --       GOTO error

 --   DELETE  FROM a
 --   FROM    ERClaimLineItems AS a
 --           JOIN #ERClaimLineItemOffsets AS b ON b.ERClaimLineItem1 = a.ERClaimLineItemId
 --   IF @@error <> 0
 --       GOTO error

 --   DELETE  FROM a
 --   FROM    ERClaimLineItemAdjustments AS a
 --           JOIN #ERClaimLineItemOffsets AS b ON b.ERClaimLineItem2 = a.ERClaimLineItemId
 --   IF @@error <> 0
 --       GOTO error

 --   DELETE  FROM a
 --   FROM    ERClaimLineItemLog AS a
 --           JOIN #ERClaimLineItemOffsets AS b ON b.ERClaimLineItem2 = a.ERClaimLineItemId
 --   IF @@error <> 0
 --       GOTO error

 --   DELETE  FROM a
 --   FROM    ERClaimLineItems AS a
 --           JOIN #ERClaimLineItemOffsets AS b ON b.ERClaimLineItem2 = a.ERClaimLineItemId
 --   IF @@error <> 0
 --       GOTO error

	--


    COMMIT TRAN

    IF @@error <> 0
        GOTO error


    process_payments:

    EXEC ssp_PM835PaymentPosting @UserId, @ERFileId
    --SELECT  'Payment Posting Disabled'
	
	
    IF @@error <> 0
        BEGIN
            INSERT  INTO @ParseErrors
                    ( ERFileId,
					  LineNumber ,
                      ErrorMessage ,
                      LineDataText
                    )
            VALUES  --srf ?? what do i use for line number??
                    ( @ERFileId,
					   1 ,
                      'Error: Payment Posting Process Failed. Please ask system admin to run ssp_835_payment_posting through SQL Query Analyzer' ,
                      NULL
                    )
		--select @ErrorNo = 30006, @ErrorMessage = 'Error: Payment Posting Process Failed. Please ask system admin to run ssp_835_payment_posting through SQL Query Analyzer'
            GOTO error
        END




	--Set File to Process
    UPDATE  ERFiles
    SET     Processed = 'Y'
    WHERE   ERFileId = @ERFileId

	--Set Processing Flag for File
    UPDATE  ERFiles
    SET     Processing = 'N'
    WHERE   ERFileId = @ERFileId
	

	IF EXISTS (SELECT 1 FROM @ParseErrors AS pe)
		GOTO ins_error

    RETURN


    end_process_claims:

    COMMIT


	--Set Processing Flag for File
    UPDATE  ERFiles
    SET     Processing = 'N'
    WHERE   ERFileId = @ERFileId


    RETURN


   

    error:

    IF @@trancount > 0
        ROLLBACK TRANSACTION


	ins_error:


    INSERT  INTO ERFileParsingErrors
            ( ERFileId ,
              ERFilesegmentId ,
              LineNumber ,
              ErrorMessage ,
              LineDataText ,
              CreatedBy ,
              ModifiedBy
            )
            SELECT  @ERFileId ,
                    ERFilesegmentId ,
                    LineNumber ,
                    ErrorMessage ,
                    LineDataText ,
                    @UserCode ,
                    @UserCode
            FROM    @ParseErrors 
                    
	SELECT TOP 1 @ErrorMessage = ErrorMessage 
	FROM @ParseErrors


	--Set Processing Flag for File
    UPDATE  ERFiles
    SET     Processing = 'N'
    WHERE   ERFileId = @ERFileId

	SELECT  @ErrorMessage

    RETURN

    SELECT  @ErrorMessage = 'Processed Sucessfully'
    do_not_process:
    SELECT  @ErrorMessage



    RETURN

GO

