
IF EXISTS (SELECT   * FROM  sys.objects WHERE   object_id = OBJECT_ID(N'csp_RDLClientsWithoutActiveTxPlan') AND type IN ( N'P', N'PC' ))
    DROP PROCEDURE csp_RDLClientsWithoutActiveTxPlan
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.csp_RDLClientsWithoutActiveTxPlan
    @ExecutedByStaffId          INTEGER      = NULL
  , @FromDate                   DATE
  , @ToDate                     DATE         = NULL
  , @Programs                   VARCHAR(MAX) = NULL
  , @ProcedureCodes             VARCHAR(MAX) = NULL
  , @Clinicians                 VARCHAR(MAX) = NULL -- -1 indicates no primary clinician
  , @ServiceStatus              VARCHAR(MAX) = NULL
  , @TxPlanExpiresAfterN        INTEGER      = 11
  , @TxPlanExpiresTimeUnit      VARCHAR(MAX) = 'Month'
  , @IncludeNotBillableServices CHAR(1)      = 'Y'
AS
/************************************************************************************************
Stored Procedure: csp_RDLClientsWithoutActiveTxPlan                      

Created By: Jay                                                                                    
Purpose:                        

Test Calls:
	Exec csp_RDLClientsWithoutActiveTxPlan @FromDate = '1/1/18', @txPlanExpiresTimeUnit = 'Frogs'	--should cause exception
	Exec csp_RDLClientsWithoutActiveTxPlan @FromDate = '1/1/18', @txPlanExpiresTimeUnit = 'Month'
	Exec csp_RDLClientsWithoutActiveTxPlan @FromDate = '1/1/18', @txPlanExpiresTimeUnit = 'day'

Change Log:                                                                                                
Date		Author			Purpose
2018-10-08	jwheeler		Created ; New Directions Enhancements 12

****************************************************************************************************/
BEGIN

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


		DECLARE @ParmFromDate DATE = @FromDate
		DECLARE @ParmToDate DATE = @ToDate



		--  DECLARE @TxPlanExpiresTimeUnit VARCHAR(MAX) = 'month' , @ExecutedByStaffId INTEGER = NULL , @ParmFromDate DATE= '1/1/18' , @ParmToDate DATE = NULL , @Programs VARCHAR(MAX) = NULL , @ProcedureCodes VARCHAR(MAX) = NULL , @Clinicians VARCHAR(MAX) = NULL , @ServiceStatus VARCHAR(MAX) = NULL , @TxPlanExpiresAfterN INTEGER = 11 ,  @IncludeNotBillableServices CHAR(1) = 'Y'


		DECLARE @TerminateOnNoExcludedPrograms CHAR(1) = 'Y'
		DECLARE @CRLF CHAR(2) = CHAR(13) + CHAR(10)
		DECLARE @CleanTxPlanTimeUnit VARCHAR(MAX)
		DECLARE @ErrorMessage VARCHAR(MAX) = @CRLF
		DECLARE @Bookmark VARCHAR(MAX) = 'Init' --#EH!INFO!ADD!@Bookmark!
		DECLARE @SaveTranCount INTEGER = @@Trancount
		DECLARE @ThisProc VARCHAR(MAX) = ISNULL(OBJECT_NAME(@@PROCID), 'Testin')
		DECLARE @CreatedBy VARCHAR(30) = CASE
												WHEN LEN(@ThisProc) >= 30 THEN SUBSTRING(@ThisProc, 1, 13) + '...' + SUBSTRING(@ThisProc, LEN(@ThisProc) - 13, 13)
												ELSE @ThisProc
											END
		--#############################################################################
		-- NOTE:  Due to speed, I'm not using these recodes with respect to time.
		--        I'm just just getrecodevaluescurrent.
		--############################################################################# 
		DECLARE @RecodeCategoryForTxPlanDocumentCodeIds VARCHAR(MAX) = 'XReportClientsWithActiveTxPlanQualifyingDocumentCodes'
		DECLARE @RecodeCategoryForExcludedPrograms VARCHAR(MAX) = 'XReportClientsWithActiveTxPlanExcludeProgramIds'
		DECLARE @DebugDocumentCodes VARCHAR(MAX) --#EH!INFO!ADD!@DebugDocumentCodes!
		DECLARE @DebugExcludedPrograms VARCHAR(MAX) --#EH!INFO!ADD!@DebugExcludedPrograms!
		DECLARE @ParmFromDateForDocuments DATE --#EH!INFO!ADD!@ParmFromDateForDocuments!

		----Test Code
		--DECLARE @Stopwatch StopWatchTable

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'init'




		DECLARE @TxPlanGoodForNMonths INTEGER = 11
		DECLARE @OnlyActiveClients CHAR(1) = 'Y'

		IF OBJECT_ID('tempdb..#output') IS NOT NULL
			DROP TABLE #output

		CREATE TABLE #Output (
			Id                              INTEGER     IDENTITY(1, 1) PRIMARY KEY
			, ClientId                        INTEGER     NOT NULL
			, ClientName                      VARCHAR(MAX)
			, ServiceId                       INTEGER
			, ProgramId                       INTEGER
			, ProcedureId                     INTEGER
			, Program                         VARCHAR(MAX)
			, [Procedure]                     VARCHAR(MAX)
			, Status                          VARCHAR(MAX)
			, DOS                             DATETIME
			, StatusId                        INTEGER
			, PrimaryClinician                VARCHAR(MAX)
			, CostofService                   MONEY
			, PrecedingSignedTxPlanDocumentId INTEGER
			, PrecedingSignedTxPlanDate       DATE
			, LastSignedTxPlanDocumentId      INTEGER
			, LastSignedTxPlanDate            DATE
			, LastSigendTxPlanActive          CHAR(1)
				DEFAULT 'N'
			, ItsaOne Integer DEFAULT 1

		)

		--   select * from #Output O Return

		SELECT  @ParmToDate = GETDATE() WHERE   @ParmToDate IS NULL

		SELECT  @CleanTxPlanTimeUnit = @TxPlanExpiresTimeUnit
		SELECT  @CleanTxPlanTimeUnit = STUFF(@CleanTxPlanTimeUnit, LEN(@CleanTxPlanTimeUnit), 1, '')
			WHERE SUBSTRING(@CleanTxPlanTimeUnit, LEN(@CleanTxPlanTimeUnit), 1) = 'S'

		--#############################################################################
		-- Validate input
		--############################################################################# 
		DECLARE @ValidTxPlanExpiresTimeUnits TABLE(Unit VARCHAR(MAX))
		INSERT INTO @ValidTxPlanExpiresTimeUnits(Unit)VALUES('Year'), ('Month'), ('Week'), ('Day')

		--#############################################################################
		-- Create Dates Table
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Create Dates'

		IF OBJECT_ID('tempdb..#Dates') IS NOT NULL
			DROP TABLE #Dates

		CREATE TABLE #Dates (
			DateId INTEGER IDENTITY(1, 1) PRIMARY KEY
			, aDate  DATE)
		INSERT INTO #Dates(aDate)VALUES(@ParmFromDate)
			--SQL Prompt formatting off
		;WITH lv0 AS (SELECT 0 g UNION ALL SELECT 0)
			,lv1 AS (SELECT 0 g FROM lv0 a CROSS JOIN lv0 b) -- 4
			,lv2 AS (SELECT 0 g FROM lv1 a CROSS JOIN lv1 b) -- 16
			,lv3 AS (SELECT 0 g FROM lv2 a CROSS JOIN lv2 b) -- 256
			,lv4 AS (SELECT 0 g FROM lv3 a CROSS JOIN lv3 b) -- 65,536
			,Tally (n) AS (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM lv4) --SQL Prompt Formatting On
		INSERT INTO #Dates(aDate)SELECT DATEADD(dd, n, @ParmFromDate) FROM  Tally WHERE n < DATEDIFF(dd, @ParmFromDate, @ParmToDate) ORDER BY n;

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Dates Created'

		--#############################################################################
		-- Check for recode Categories
		--############################################################################# 
		IF NOT EXISTS (SELECT   1 FROM  RecodeCategories RC WHERE   RC.CategoryName = @RecodeCategoryForTxPlanDocumentCodeIds)
			BEGIN
				SELECT  @ErrorMessage = 'Unable to find Recode Category for Qualifying DocumentCodeIds:  ' + ISNULL(@RecodeCategoryForTxPlanDocumentCodeIds, 'Its Null')
				RAISERROR('%s', 16, 1, @ErrorMessage)
			END

		IF NOT EXISTS (SELECT   1 FROM  RecodeCategories RC WHERE   RC.CategoryName = @RecodeCategoryForExcludedPrograms)
			BEGIN
				SELECT  @ErrorMessage = 'Unable to find Recode Category for Excluded Programs:  ' + ISNULL(@RecodeCategoryForExcludedPrograms, 'Its Null')
				RAISERROR('%s', 16, 1, @ErrorMessage)
			END

		--#############################################################################
		-- Make Sure RC Categories are populated
		--############################################################################# 

		DECLARE @QualifyingDocumentCodeIds TABLE(DocumentCodeId INTEGER)

		INSERT INTO @QualifyingDocumentCodeIds(DocumentCodeId)SELECT    IntegerCodeId FROM  dbo.ssf_RecodeValuesCurrent(@RecodeCategoryForTxPlanDocumentCodeIds)

		IF NOT EXISTS (SELECT   1 FROM  @QualifyingDocumentCodeIds QDCI)
			BEGIN
				SELECT  @ErrorMessage = 'No Recodes found for qualifying document codes in recode Category :' + ISNULL(@RecodeCategoryForTxPlanDocumentCodeIds, 'Its Null')
				RAISERROR('%s', 16, 1, @ErrorMessage)
			END

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'past init'

		--#############################################################################
		-- Programs may be optional
		--############################################################################# 
		DECLARE @ExcludedPrograms TABLE(ProgramId INTEGER)

		INSERT INTO @ExcludedPrograms(ProgramId)SELECT  IntegerCodeId FROM  dbo.ssf_RecodeValuesCurrent(@RecodeCategoryForExcludedPrograms)

		IF NOT EXISTS (SELECT   1 FROM  @ExcludedPrograms QDCI)
			AND  @TerminateOnNoExcludedPrograms = 'Y'
			BEGIN
				SELECT  @ErrorMessage = 'No Recodes found for Excluded ProgramIds in recode Category :' + ISNULL(@RecodeCategoryForExcludedPrograms, 'Its Null')
				RAISERROR('%s', 16, 1, @ErrorMessage)
			END

		IF NOT EXISTS (SELECT   1 FROM  @ValidTxPlanExpiresTimeUnits V WHERE V.Unit = @CleanTxPlanTimeUnit)
			BEGIN
				SELECT  @ErrorMessage =
					'The parameter "@TxPlanExpiresTimeUnit" Must be one of the following ('
					+ (SELECT   STUFF((SELECT   ', ' + Unit FROM    @ValidTxPlanExpiresTimeUnits VTPETU FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, LEN(', '), '')) + ')'

				RAISERROR('%s', 16, 1, @ErrorMessage)
			END

		--#############################################################################
		-- for debugging...
		--############################################################################# 
		SELECT  @DebugDocumentCodes =
			STUFF((SELECT   ',' + CAST(QDCI.DocumentCodeId AS VARCHAR(MAX))FROM @QualifyingDocumentCodeIds QDCI FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 1, '')
		SELECT  @DebugExcludedPrograms = STUFF((SELECT  ',' + CAST(EP.ProgramId AS VARCHAR(MAX))FROM    @ExcludedPrograms EP FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 1, '')


		--#############################################################################
		-- We'll need documents N months older than the most recent service to check
		--#############################################################################
		SELECT  @ParmFromDateForDocuments = CASE
												WHEN @CleanTxPlanTimeUnit = 'Year' THEN DATEADD(yy, -@TxPlanExpiresAfterN, @ParmFromDate)
												WHEN @CleanTxPlanTimeUnit = 'Month' THEN DATEADD(mm, -@TxPlanExpiresAfterN, @ParmFromDate)
												WHEN @CleanTxPlanTimeUnit = 'Week' THEN DATEADD(wk, -@TxPlanExpiresAfterN, @ParmFromDate)
												WHEN @CleanTxPlanTimeUnit = 'Day' THEN DATEADD(dd, -@TxPlanExpiresAfterN, @ParmFromDate)
											END

		--#############################################################################
		-- This block is really just for testing but if null is passed in for a parm 
		--   it means any value
		--############################################################################# 
		IF(@Programs + @ProcedureCodes + @Clinicians + @ServiceStatus) IS NULL
			BEGIN
				IF OBJECT_ID('tempdb..#DropDownInfo') IS NOT NULL
					DROP TABLE #DropDownInfo

				CREATE TABLE #DropDownInfo (
					Type  VARCHAR(MAX)
					, Value VARCHAR(MAX)
					, Label VARCHAR(MAX))
				INSERT INTO #DropDownInfo(Type, Value, Label)EXEC csp_RDLClientsWithoutActiveTxPlanDataLists

				SELECT  @Programs =
					STUFF((SELECT   ',' + CAST(DDI.Value AS VARCHAR(MAX))FROM   #DropDownInfo DDI WHERE DDI.Type = 'Programs' FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 1, '')
					WHERE @Programs IS NULL

				SELECT  @ServiceStatus =
					STUFF((SELECT   ',' + CAST(DDI.Value AS VARCHAR(MAX))FROM   #DropDownInfo DDI WHERE DDI.Type = 'Programs' FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 1, '')
					WHERE @ServiceStatus IS NULL


				SELECT  @ProcedureCodes =
					STUFF((SELECT   ',' + CAST(DDI.Value AS VARCHAR(MAX))FROM   #DropDownInfo DDI WHERE DDI.Type = 'Procedures' FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 1, '')
					WHERE @ProcedureCodes IS NULL

				SELECT  @Clinicians =
					STUFF((SELECT   ',' + CAST(DDI.Value AS VARCHAR(MAX))FROM   #DropDownInfo DDI WHERE DDI.Type = 'Clinicians' FOR XML PATH(''), TYPE).value('.', 'varchar(max)'), 1, 1, '')
					WHERE @Clinicians IS NULL

				DROP TABLE #DropDownInfo

			END

		--1.	This should apply for active clients. (Active box on Client Information Screen checked)
		--2.	We need to provide a total number of clients that don’t active treatment plan, as well as a total number of services that were completed outside of a non-active treatment plan
		--3.	We need to provide a total cost of those uncovered services outside of the non-active treatment plan range
		--4.	Displays a list of active clients that do not have an active treatment plan. What constitutes as an active treatment plan is one that is signed and completed no more than 11 months for that client
		--5.	 Based on above, we need to include the number of services provided for that client that was outside of an active treatment plan. 
		--6.	Eliminate any service associated with a DD program or Crisis Program in the result. They are not required to have a treatment plan for those services. We should not count these.
		--        a.	We can distinguish this by looking at the programs. Any of the programs (around 10 of them) that have a DD- at the beginning, stand for the DD programs. Any programs that have BHW-Crisis, are considered Crisis Programs.

		--  select * from Clients WHERE Active = 'y' AND PrimaryClinicianId IS null


		IF OBJECT_ID('tempdb..#Clients') IS NOT NULL
			DROP TABLE #Clients

		CREATE TABLE #Clients (
			Clientid         INTEGER PRIMARY KEY
			, PrimaryClinician INTEGER)
		IF OBJECT_ID('tempdb..#Documents') IS NOT NULL
			DROP TABLE #Documents

		CREATE TABLE #Documents (
			Documentid     INTEGER PRIMARY KEY
			, DocumentCodeId INTEGER
			, EffectiveDate  DATE
			, ClientId       INTEGER)
		IF OBJECT_ID('tempdb..#Services') IS NOT NULL
			DROP TABLE #Services

		CREATE TABLE #Services (
			Serviceid       INTEGER PRIMARY KEY
			, ProcedureCodeId INTEGER
			, ProgramId       INTEGER
			, DOS             DATETIME
			, StatusId        INTEGER
			, ClientId        INTEGER)

		IF OBJECT_ID('tempdb..#Programs') IS NOT NULL
			DROP TABLE #Programs

		CREATE TABLE #Programs (Programid INTEGER PRIMARY KEY)

		--#############################################################################
		-- Gather Client Population.  Active Clients Only
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'insert clients'

		INSERT INTO #Clients(Clientid
							, PrimaryClinician)
			SELECT    c.ClientId
					, ISNULL(c.PrimaryClinicianId, -1)
			FROM  Clients c
				JOIN dbo.fnSplit(@Clinicians, ',') x ON x.item = ISNULL(c.PrimaryClinicianId, -1)

			WHERE (c.Active = 'Y'
					OR @OnlyActiveClients = 'N')
				AND ISNULL(c.RecordDeleted, 'N') = 'N'

		--#############################################################################
		-- Gather Document Population
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'insert documents'

		INSERT INTO #Documents(Documentid
								, DocumentCodeId
								, EffectiveDate
								, ClientId)

			SELECT    D.DocumentId
					, D.DocumentCodeId
					, D.EffectiveDate
					, D.ClientId
			FROM  Documents D
				JOIN #Clients C ON C.Clientid = D.ClientId
				JOIN @QualifyingDocumentCodeIds QDCI ON QDCI.DocumentCodeId = D.DocumentCodeId
			WHERE ISNULL(D.RecordDeleted, 'N') = 'N'
				AND CAST(D.EffectiveDate AS DATE)
				BETWEEN @ParmFromDateForDocuments AND @ParmToDate
				AND D.Status = 22

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Documents Populated'

		--#############################################################################
		-- Remove Clients that have no gaps
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'populate ClientDatesWithNoPlan'

		IF OBJECT_ID('tempdb..#ClientDatesWithNoPlan') IS NOT NULL
			DROP TABLE #ClientDatesWithNoPlan

		CREATE TABLE #ClientDatesWithNoPlan (
			Id       INTEGER IDENTITY(1, 1)
			, ClientId INTEGER
			, DateId   INTEGER)

		--         DECLARE  @CleanTxPlanTimeUnit VARCHAR (MAX) = 'Month', @TxPlanExpiresAfterN INTEGER = 11
		;WITH DocumentCoversDates AS
			(   SELECT DISTINCT
					D.ClientId
					, Dt.DateId
					FROM  #Documents D
						CROSS JOIN #Dates Dt
					WHERE Dt.aDate
					BETWEEN D.EffectiveDate AND CASE
													WHEN @CleanTxPlanTimeUnit = 'Year' THEN DATEADD(yy, @TxPlanExpiresAfterN, D.EffectiveDate)
													WHEN @CleanTxPlanTimeUnit = 'Month' THEN DATEADD(mm, @TxPlanExpiresAfterN, D.EffectiveDate)
													WHEN @CleanTxPlanTimeUnit = 'Week' THEN DATEADD(wk, @TxPlanExpiresAfterN, D.EffectiveDate)
													WHEN @CleanTxPlanTimeUnit = 'Day' THEN DATEADD(dd, @TxPlanExpiresAfterN, D.EffectiveDate)
												END)
			, ClientDates AS
			(

				SELECT  C.Clientid, Dt.DateId FROM  #Clients C CROSS JOIN #Dates Dt)
			, ClientDatesWithNoPlan
			(ClientId, DateId) AS
			(   SELECT  CDT.Clientid
						, CDT.DateId
					FROM  ClientDates CDT
						LEFT JOIN DocumentCoversDates dd ON dd.DateId = CDT.DateId
															AND   dd.ClientId = CDT.Clientid
					WHERE dd.ClientId IS NULL)
		INSERT INTO #ClientDatesWithNoPlan(ClientId, DateId)SELECT  c.ClientId, c.DateId FROM   ClientDatesWithNoPlan c


		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'ClientDatesWithNoPlan done'

		--#############################################################################
		-- Kill Those that have full coverage of dates
		--############################################################################# 
		DELETE C FROM   #Clients C WHERE NOT EXISTS (SELECT 1 FROM  #ClientDatesWithNoPlan CDWNP WHERE  CDWNP.ClientId = C.Clientid)
		--#############################################################################
		-- Services
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'insert possbile Services'

		;
		WITH ValidServicePrograms AS
			(   SELECT  p.ProgramId
					FROM  Programs p
						JOIN dbo.fnSplit(@Programs, ',') x ON x.item = p.ProgramId
						LEFT JOIN @ExcludedPrograms EP ON EP.ProgramId = p.ProgramId
					WHERE EP.ProgramId IS NULL
						AND ISNULL(p.RecordDeleted, 'N') = 'N')
			, PossibleServices AS
			(   SELECT  S.ServiceId
					FROM  Services S
						JOIN #Clients C ON C.Clientid = S.ClientId
						JOIN ValidServicePrograms VP ON VP.ProgramId = S.ProgramId
					WHERE (S.DateOfService >= @ParmFromDate
							AND S.DateOfService < DATEADD(dd, 1, @ParmToDate)
							AND ISNULL(S.RecordDeleted, 'N') = 'N'))
		SELECT  * INTO  #PossibleServices FROM  PossibleServices

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'PossibleServices Generated' --

		;WITH ServiceLimitter AS
			(   SELECT  s.ServiceId
						, s.ClientId
						, s.ProgramId
						, s.ProcedureCodeId
						, CAST(s.DateOfService AS DATE) AS DOSDay
						, s.DateOfService               AS DOS
						, s.Status
					FROM  Services s
						JOIN #PossibleServices PS ON PS.ServiceId = s.ServiceId
						JOIN dbo.fnSplit(@ServiceStatus, ',') x ON x.item = s.Status
						JOIN dbo.fnSplit(@ProcedureCodes, ',') PC ON PC.item = s.ProcedureCodeId

					WHERE ISNULL(s.RecordDeleted, 'N') = 'N'
						AND (s.Billable = 'Y'
								OR @IncludeNotBillableServices = 'Y'))

		INSERT INTO #Services(Serviceid
							, ClientId
							, ProgramId
							, DOS
							, ProcedureCodeId
							, StatusId)
			SELECT    SL.ServiceId
					, SL.ClientId
					, SL.ProgramId
					, SL.DOS
					, SL.ProcedureCodeId
					, SL.Status
			FROM  ServiceLimitter SL
				JOIN #ClientDatesWithNoPlan CNP ON CNP.ClientId = SL.ClientId
				JOIN #Dates Dt ON Dt.DateId = CNP.DateId
			WHERE SL.DOSDay = Dt.aDate


		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'services populated'


		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Populating Output'

		INSERT INTO #Output(ClientId
							--   ,ClientName
							, ServiceId
							, ProgramId
							, ProcedureId
							, DOS
							, StatusId
							--, CostofService
		--, PrecedingSignedTxPlanDate
		)
			SELECT    C.Clientid, S.Serviceid, S.ProgramId, S.ProcedureCodeId, S.DOS, S.StatusId FROM #Clients C LEFT JOIN #Services S ON C.Clientid = S.ClientId

		--#############################################################################
		-- assign cost of service
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Updating Cost of Service'

		;WITH CostOfService AS
			(   SELECT  S.ServiceId
						, SUM(AL.Amount) AS cost
					FROM  ARLedger AL
						JOIN Charges C ON C.ChargeId = AL.ChargeId
						JOIN Services S ON S.ServiceId = C.ServiceId
					WHERE AL.LedgerType = 4201
					GROUP BY S.ServiceId)
		UPDATE  O SET   O.CostofService = c.cost FROM   #Output O JOIN CostOfService c ON c.ServiceId = O.ServiceId

		--#############################################################################
		-- Assign Last TxPlan Date
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Updating most recent tx plan'

		UPDATE  o
			SET   o.PrecedingSignedTxPlanDate = x.EffectiveDate
				, PrecedingSignedTxPlanDocumentId = x.Documentid
			FROM  #Output o
				CROSS APPLY
				(   SELECT TOP(1)
						D.Documentid
						, D.EffectiveDate
						FROM  #Documents D
						WHERE   D.ClientId = o.ClientId
								AND D.EffectiveDate <= ISNULL(o.DOS, GETDATE())
						ORDER BY ROW_NUMBER() OVER (ORDER BY D.EffectiveDate DESC))x

		DELETE #Output WHERE ServiceId IS NULL AND  PrecedingSignedTxPlanDate IS NOT NULL
		--#############################################################################
		-- Update Last Signed TX Plan
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'Adding most recent tx plan evah'

		;WITH GoodDocs AS
			(

				SELECT  D.ClientId
						, D.DocumentId
						, D.EffectiveDate
						, ROW_NUMBER() OVER (PARTITION BY D.ClientId
											ORDER BY D.EffectiveDate DESC
													, DV.DocumentVersionId DESC) AS rn
					FROM  Documents D
						JOIN #Clients C ON C.Clientid = D.ClientId
						JOIN @QualifyingDocumentCodeIds QDCI ON QDCI.DocumentCodeId = D.DocumentCodeId
						JOIN DocumentVersions DV ON D.CurrentDocumentVersionId = DV.DocumentVersionId

					WHERE D.Status = 22
						AND ISNULL(D.RecordDeleted, 'N') = 'N'
						AND ISNULL(DV.RecordDeleted, 'N') = 'N'

		)

		UPDATE  O
			SET   O.LastSignedTxPlanDocumentId = GD.DocumentId
				, O.LastSignedTxPlanDate = GD.EffectiveDate
			FROM  #Output O
				JOIN GoodDocs GD ON GD.ClientId = O.ClientId
			WHERE GD.rn = 1

		DECLARE @oldestValidPlanDate DATE
		SELECT  @oldestValidPlanDate = CASE
											WHEN @CleanTxPlanTimeUnit = 'Year' THEN DATEADD(yy, -@TxPlanExpiresAfterN, GETDATE())
											WHEN @CleanTxPlanTimeUnit = 'Month' THEN DATEADD(mm, -@TxPlanExpiresAfterN, GETDATE())
											WHEN @CleanTxPlanTimeUnit = 'Week' THEN DATEADD(wk, -@TxPlanExpiresAfterN, GETDATE())
											WHEN @CleanTxPlanTimeUnit = 'Day' THEN DATEADD(dd, -@TxPlanExpiresAfterN, GETDATE())
										END

		UPDATE O
		SET O.LastSigendTxPlanActive = 'Y'
		FROM #Output O
		WHERE ISNULL(O.LastSignedTxPlanDate, '8/8/1839') >= @oldestValidPlanDate

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'done finding most recent tx evah'

		--#############################################################################
		--  Update Names
		--############################################################################# 

		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'updating Names'

		UPDATE  O
			SET   O.ClientName = C.LastName + ', ' + C.FirstName + ISNULL(' ' + SUBSTRING(C.MiddleName, 1, 1) + '.', '') + ' (' + CAST(C.ClientId AS VARCHAR) + ')'
				, O.PrimaryClinician = ISNULL(s.DisplayAs, 'None Assigend')
			FROM  #Output O
				JOIN Clients C ON C.ClientId = O.ClientId
				LEFT JOIN Staff s ON s.StaffId = C.PrimaryClinicianId
									AND  ISNULL(s.RecordDeleted, 'N') = 'N'


		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'updating attribs'


		UPDATE  O
			SET   O.Program = P.ProgramName
				, O.[Procedure] = PC.ProcedureCodeName
				, O.Status = GC.CodeName
			FROM  #Output O
				LEFT JOIN Programs P ON P.ProgramId = O.ProgramId
				LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = O.ProcedureId
				LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = O.StatusId

		SELECT  * FROM  #Output O


		----Test Code
		--INSERT INTO @Stopwatch(strDesc)SELECT   'fin'

		----Test Code
		--PRINT dbo.ssf_StopWatchSummary(@Stopwatch)



	END TRY

	----Test Code
	--Exec csp_RDLClientsWithoutActiveTxPlan @FromDate = '6/1/18'
        
BEGIN CATCH  --SQL Prompt Formatting Off
	--IF @@Trancount > @SaveTranCount
	--ROLLBACK TRAN
                 
	DECLARE @ErrorBlockLineLen INTEGER = 0
	DECLARE @ErrorBlockGotTheFormat BIT = 0
	DECLARE @ErrorFormatIndent Integer = 3
	DECLARE @ErrorBlockBeenThrough INTEGER = NULL -- must be set to null
	DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
	DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName))
                  
	WHILE @ErrorBlockGotTheFormat = 0
	BEGIN
		IF @ErrorBlockBeenThrough IS NOT NULL
			SELECT @ErrorBlockGotTheFormat = 1
		SET @errormessage = Space(isnull(@ErrorFormatIndent,0)) + @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + Char(13) + char(10)
		SET @errormessage += Char(13) + char(10) + Space(isnull(@ErrorFormatIndent,0)) +'-------->' + ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') + '<--------' + Char(13) + char(10) --
			+ Space(isnull(@ErrorFormatIndent,0)) + REPLICATE('=', @ErrorBlockLineLen) + Char(13) + char(10) --
			+ Space(isnull(@ErrorFormatIndent,0)) + UPPER(@ThisProcedureName + ' Variable dump:') + Char(13) + char(10) --
			+ Space(isnull(@ErrorFormatIndent,0)) + REPLICATE('=', @ErrorBlockLineLen) + Char(13) + char(10) --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@ExecutedByStaffId:..............<' + ISNULL(CAST(@ExecutedByStaffId               AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@FromDate:.......................<' + ISNULL(CAST(@FromDate                        AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@ToDate:.........................<' + ISNULL(CAST(@ToDate                          AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@Programs:.......................<' + ISNULL(CAST(@Programs                        AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@ProcedureCodes:.................<' + ISNULL(CAST(@ProcedureCodes                  AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@Clinicians:.....................<' + ISNULL(CAST(@Clinicians                      AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@ServiceStatus:..................<' + ISNULL(CAST(@ServiceStatus                   AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@TxPlanExpiresAfterN:............<' + ISNULL(CAST(@TxPlanExpiresAfterN             AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@TxPlanExpiresTimeUnit:..........<' + ISNULL(CAST(@TxPlanExpiresTimeUnit           AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@IncludeNotBillableServices:.....<' + ISNULL(CAST(@IncludeNotBillableServices      AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@Bookmark:.......................<' + ISNULL(CAST(@Bookmark                        AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@DebugDocumentCodes:.............<' + ISNULL(CAST(@DebugDocumentCodes              AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@DebugExcludedPrograms:..........<' + ISNULL(CAST(@DebugExcludedPrograms           AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
			+ Space(isnull(@ErrorFormatIndent,0)) + '@ParmFromDateForDocuments:.......<' + ISNULL(CAST(@ParmFromDateForDocuments        AS VARCHAR(125)), 'Null') + '>' + Char(13) + char(10)  --
		SELECT @ErrorBlockLineLen = MAX(LEN(RTRIM(item)))  
			FROM dbo.fnSplit(@errormessage, Char(13) + char(10))
		SELECT @ErrorBlockBeenThrough= 1
	END
	RAISERROR('%s',16,1,@errormessage)   --SQL Prompt Formatting On
END CATCH
    
END

GO

