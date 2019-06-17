
/****** Object:  StoredProcedure [dbo].[ssp_SCValidateDocument]    Script Date: 10/01/2015 19:32:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCValidateDocument]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCValidateDocument]    Script Date: 10/01/2015 19:32:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE  PROCEDURE [dbo].[ssp_SCValidateDocument]
    @CurrentUserId INT ,
    @DocumentId INT ,
    @CustomValidationStoreProcedureName VARCHAR(100) ,
    @BatchSignDocument CHAR(1) = NULL
AS /*******************************************************************************************************************/                                  
/* This stored procedure is used for custom validations of the documents within SmartCare.  A stored procedure     */                                  
/* should be created using the naming convention "csp_validateTableName" where TableName is                        */                                  
/* the name of the custom document table.            */                                                             
/* The stored procedure should insert the following 3 fields into #validationReturnTable:      */                                  
/* Field1 TableName - the name of the document table          */                                  
/* Field2 ColumnName - the name of the column being validated         */                                  
/* Field3 ErrorMessage - the message to return to the user         */                                  
/* To validate a document, create a new entry for the specific documentCodeId        */                                  
/* example:                */                                  
/* --Validate TableName               */                                  
/* If @documentCodeId = 1              */                                  
/* exec csp_validateTableName @documentId, @documentCodeId */            
-- Date        Author         Purpose                                
-- August.05.2011  Rakesh      Created.      
-- Now as scsp_SCValidateDocument will not be called direclty from application. This will be called from  ssp_SCValidateDocument      
--  we have copied all contents from scsp_SCValidateDocument to sp "ssp_SCValidateDocument" Ref to task 2324 in Care Management                                            
-- Sep 29 2011 Ryan Noble  Removed custom components and added to applicable customer's scsp_SCValidateDocument procedure.  
--20th Oct 2011 As code for calling custom csp was commented. This was uncommented by Priyanka Ref to task 82 in Threshold bugs/Features 
-- 13Sept2011(merged on 14Nov2011)  Shifali      Modified(Replaced CurrentDocumentVersionId with InProgressDocumentVersionId ref task# 11(To Be Reviewed Status)
--20 Dec 2012 AmitSr TasK#2432,Service Note - End Time Validation,Thresholds - Bugs/Features (Offshore)
--24 Dec 2012 Varinder
--What: Added ELSE 
--Why: Two Validations Query executing at same time. Ref Task #2434 Thresholds - Bugs/Features (Offshore)
--Revert changes made for Task #2434 Thresholds - Bugs/Features (Offshore) 
--11-Feb-2013   Rakesh Garg    Add core level Validation prevents users from  signing & completing a services when Service Unit = 0 w.rf to task 152 in 3.5x Issues  
--07-NOV-2013   Gautam         Added input parameter @BatchSignDocument char(1)=Null to insert data in #validationReturnTable
--							   for BatchSignature screen for task 202 - Enhancement - SC: Multiple Signature Interface -- Venture Region Support.
--								Why : This SP returns two result set with different no. of fields.	
-- 25 Aug 2015  Bernardin      To display validation if the billing diagnosis don't have ICD 10 Diagnosis values	      
-- 16 Sep 2015  RQuigley	   Replace 104 conversions with 101.  US Dates are always MM-DD-YYYY, not DD-MM-YYYY
-- 01 OCT 2015  Bernardin      Changed the validation for BillingDiagnosisStartDate for Service to compare against the Date 
--							   of Service
-- 17 DEC 2015  Akwinass       What: Modified the DSM 5 Diagnosis validation for the service note which has diagnosis tab (Task #272 in Engineering Improvement Initiatives- NBL(I))
--                             Why:  If the service note has a diagnosis tab within the note then the diagnosis will pull from clinical diagnosis linked to the service note.
-- 17 Aug 2016	Prateek		   What : Added condition to check if 'NoDiagnosis' is Y and to not display validation in this scenario Why : Riverwood-Support #1193
-- 19 oct 2016  jwheeler       Added validation for ICD10 Diagnoses codes with respect to fiscal year.  Philhaven-Support #72.
-- 28 Dec 2016	TRemisoski		What: Always call the custom validation stored procedure even when core validations encountered
--								Why: Woods #223.  All custom valiation errors should be displayed to the user during signing
-- 3 JAN 2017  Pabitra         What: Added condition to check for the ProcedureCode need diagnosis or not
--                             Why:Camino Support Go Live #201
-- 23 JAN 2017  Pabitra        What: Reverted Tom's Changes as this is creating(Woods#223) 
--                             Why:Camino Support Go Live #201 
-- 03 MAY 2017  Lakshmi        What: Added go to statement because it will display two select statement and								   causing the issue 
--							   Why:  Philhaven Support #147
-- 5/30/2017   Hemant          What:Included the existence check for Fiscal Year validation.
--                                  Moved the scsp_SCValidateDocument call at the end of the sp.
--                                  This change is required to display the core validations at the top then custom.
--                             Why:The GOTO EndStatment; breaks ALL validations for any DSM Diagnosis Document.
--							   Project:Thresholds - Support# 962
-- 6/5/2017    TRemisoski      What: Removed check for existence of issue before INSERT.  Removed all GOTO statements and the label.
--                             Why:The GOTO EndStatment; breaks ALL validations for any DSM Diagnosis Document.  Also need to remove ALL goto statements as resolved in previous core discussions with Javed.
--							   Project:Thresholds - Support# 962
-- 30-Aug-2017  Sachin         What : Changed the Validation, Service Duration can not be zero to Service -Please Enter Duration and Service Duration can not be zero.
--							   Why : Harbor - Support #1456

-- 11/22/2017  Hemant         What?Put the scsp in correct place to fix the custom validation issue.
--                            Why?Van Buren - Support #652					  
-- 12-MAR-2018  Akwinass      Added code to skip the custom validations when "NoteReplacement" value is "Y" (Task #589.1 in Engineering Improvement Initiatives- NBL(I))
-- 09/27/2018	Msood		  What: Added the code not to display the ICD9 validation for Progress Note (DocumentCodeId = 300)
--							  Why: 	AHN-Support Go Live Task #394
/*******************************************************************************************/                             
                         
--RJN 1/13/07                                  
    CREATE TABLE #validationReturnTable
        (
          TableName VARCHAR(200) ,
          ColumnName VARCHAR(200) ,                                  
--Added by vishant to implement message code functionality                                  
--ErrorMessage    varchar(max),                                  
          ErrorMessage NVARCHAR(MAX) ,
          PageIndex INT ,
          TabOrder INT ,
          ValidationOrder INT
        )                                  
      
--varailbes declared by Rakesh Ref to task 2324 in Care Management Support  for checking primary tables row exists or not then only user will be able to sign documents      
    DECLARE @PrimaryTableName VARCHAR(100) ,
        @SQLString NVARCHAR(500) ,
        @count INT ,
        @parmDef NVARCHAR(200) ,
        @DocumentCodeId INT ,
        @TablistList AS VARCHAR(1000)      
--varaible declaration ends here       
    DECLARE @documentVersionId INT ,
        @ServiceId INT ,
        @DateOfService DATETIME    
    ,   @EffectiveDate DATETIME 
        
        
   --#############################################################################
    -- Enforcement of ICD10 code availability of Fiscal Year (table: ICD10FiscalYearAvailability)
    --############################################################################# 
    DECLARE @EnforceICD10FiscalYearValidation CHAR(1) = 'Y'

    /*
    INSERT INTO [SystemConfigurationKeys]
            ( [CreatedBy]
            ,[CreateDate]
            ,[ModifiedBy]
            ,[ModifiedDate]
            ,[Key]
            ,[Value]
            ,[Description]
            ,[AcceptedValues]
            ,[ShowKeyForViewingAndEditing]
            ,[Comments] )
            SELECT 'sa'
                ,   GETDATE()
                ,   'sa'
                ,   GETDATE()
                ,   'EnforceICD10FiscalYearValidation'
                ,   'Y'
                ,   'Ensure the ICD10 code is valid for the Fiscal Year of the Service / Document / Claimline'
                ,   'Y,N'
                ,   'Y'
                ,   'Default behavior is ''Yes'''
                WHERE NOT EXISTS ( SELECT 1
                                    FROM SystemConfigurationKeys SCK
                                    WHERE [Key] = 'EnforceICD10FiscalYearValidation' )

                                    */
    SELECT @EnforceICD10FiscalYearValidation = Value
        FROM SystemConfigurationKeys SCK
        WHERE [Key] = 'EnforceICD10FiscalYearValidation'
            AND ISNULL(RecordDeleted, 'N') = 'N'
    
    --#############################################################################
    -- end EnforceICD10FiscalYearValidation init
    --############################################################################# 
                              
    SELECT  @documentVersionId = InProgressDocumentVersionId ,
            @ServiceId = S.ServiceId ,
            @DocumentCodeId = Documents.DocumentCodeId ,       -- added by Rakesh to get @DocumentCodeId      
           @EffectiveDate = Documents.EffectiveDate ,
            @TablistList = TableList,       --  added by Rakesh to get @TablistList 
            @DateOfService = S.DateOfService     
    FROM    Documents
            JOIN DocumentCodes ON Documents.DocumentCodeId = DocumentCodes.DocumentCodeId
            LEFT JOIN Services  S ON S.ServiceId =  Documents.ServiceId
    WHERE   DocumentId = @DocumentId
    
    DECLARE @NoteReplacement CHAR(1)
	DECLARE @AllowAttachmentsToService CHAR(1)

	SELECT TOP 1 @NoteReplacement = S.NoteReplacement
		,@AllowAttachmentsToService = PC.AllowAttachmentsToService
	FROM Documents D
	JOIN Services S ON D.ServiceId = S.ServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' 
	JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId AND ISNULL(PC.RecordDeleted, 'N') = 'N'
	WHERE D.DocumentId = @DocumentId
		AND ISNULL(D.RecordDeleted, 'N') = 'N'		
	SET @NoteReplacement = ISNULL(@NoteReplacement, 'N')
	IF ISNULL(@AllowAttachmentsToService, 'N') = 'N'
		SET @NoteReplacement = 'N'        
      
--Check row exist in Primary  table of tablist mentioned in DocumentCodes or not Based on DocumentVersionId (Changes Start here)      
--Ref to task 2324 in Care Management Support Get Primary table from table list using function [fnSplit]      
    SET @count = 0;      
    SET @PrimaryTableName = ''      
    IF ( @TablistList <> ''
         OR @TablistList IS NOT NULL
       ) 
        BEGIN      
            SET @PrimaryTableName = ( SELECT TOP 1
                                                *
                                      FROM      dbo.[fnSplit](@TablistList,
                                                              ',')
                                    )      
-- Execute Dyanminc SQL Statment & Get @count as output parameter to check row exists in primary table or not      
        END      
      
      
    IF ( @PrimaryTableName <> '' ) 
        BEGIN      
            SET @SQLString = N'SELECT @outputCount = Count(*)       
FROM ' + @PrimaryTableName + ' where DocumentVersionId=@docVersionId';      
            SET @parmDef = N'@docVersionId int, @outputCount int Output';      
      
            EXECUTE sp_executesql @SQLString, @parmDef,
                @docVersionId = @documentVersionId,
                @outputCount = @count OUTPUT;       
      
        END

/*Added By Amit Kumar Srivastava
Added Date: 20 Dec 2012
 Purpose : TasK#2432,Service Note - End Time Validation,Thresholds - Bugs/Features (Offshore),Javed and I discussed this issue tonight.  We need to update the core stored procedure to ensure that we have a validaiton for "End Time" on Signature.  Currently we can sign a document without an "end time"
if you have any questions please follow up with Javed*/
    IF EXISTS ( SELECT TOP 1
                        1
                FROM    services s
                        INNER JOIN documents d ON s.serviceid = d.serviceid
                                                  AND d.documentid = @DocumentId
                                                  AND ISNULL(d.recorddeleted,
                                                             'N') = 'N'
                                                  AND ISNULL(s.recorddeleted,
                                                             'N') = 'N'
                                                  AND EndDateOfService IS NULL ) 
        BEGIN
            INSERT  INTO #validationReturnTable
                    ( TableName ,
                      ColumnName ,
                      ErrorMessage 
                    )
                    SELECT  'Services' ,
                            'End Time' ,
                            'Service - End time can not be blank.' 
        END

--Below Valudation Added by Rakesh w.rf to task 152 in 3.5x Issues Service - Core Validation Needed
    IF EXISTS ( SELECT  1
                FROM    [Services]
                WHERE   ServiceId = @ServiceId
                        AND ISNULL(Recorddeleted, 'N') = 'N'
                        AND ISNULL(Unit, 0.00) = 0.00 ) 
        BEGIN
            INSERT  INTO #validationReturnTable
                    ( TableName ,
                      ColumnName ,
                      ErrorMessage 
                    )
                    SELECT  'Services' ,
                            'End Time' ,
                            'Service -Please Enter Duration and Service Duration can not be zero.'  -- Sachin
        END

    --#############################################################################
    -- Diagnosis Documents independant of services jwheeler
    --############################################################################# 
    IF EXISTS ( SELECT 1
                    FROM Documents D
                        JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
                    WHERE D.DocumentId = @DocumentId
                        AND ISNULL(D.RecordDeleted, 'N') = 'N'
                        AND ISNULL(DC.RecordDeleted, 'N') = 'N'
                        AND ISNULL(DC.DiagnosisDocument, 'N') = 'Y' )
        BEGIN
            --#############################################################################
            -- Check ICD10 validity with respect to Fiscal Year
            --############################################################################# 
            IF @EnforceICD10FiscalYearValidation = 'Y'
                AND @EffectiveDate >= '10/1/2015' -- FY16
                BEGIN
                    -- CMS Fiscal year begins 92 days before end of current calendar year
                    DECLARE @FiscalYear INTEGER 
                    SELECT @FiscalYear = YEAR(DATEADD(dd, 92, @EffectiveDate))

 					INSERT INTO #validationReturnTable (
						TableName
						,ColumnName
						,ErrorMessage
						)
					SELECT 'DocumentDiagnosisCodes'
						,'DSMVCodeId'
						,'A Billable ICD10 Code ''' + DDC.ICD10Code + ''' is not valid for FY' + CAST(@FiscalYear AS VARCHAR)
					FROM DocumentDiagnosisCodes DDC
					WHERE DDC.DocumentVersionId = @documentVersionId
						AND ISNULL(DDC.RecordDeleted, 'N') = 'N'
						AND DDC.Billable = 'Y'
						AND NOT EXISTS (
							SELECT 1
							FROM ICD10FiscalYearAvailability IFYA
							WHERE DDC.ICD10Code = IFYA.ICD10Code
								AND IFYA.CMSFiscalYear = @FiscalYear
								AND ISNULL(IFYA.RecordDeleted, 'N') = 'N'
							)

			END
       
		END
        --#############################################################################
        -- End ICD0 validity with respect to fiscal year
        --############################################################################# 
	

 --Changes End Here
--Start--
--Added by Pabitra 3-JAN-2017 
DECLARE @IsDiagnosisRequired CHAR(1)='Y'
IF EXISTS(SELECT 1 From ProcedureCodes  PC Inner Join Services S on
PC.ProcedureCodeId=S.ProcedureCodeId AND S.ServiceId=@ServiceId AND 
PC.DoesNotRequireBillingDiagnosis='Y')
BEGIN
SET @IsDiagnosisRequired='N'
END
--End-

-- Added by Bernardin w.rf to Diagnosis Changes (ICD10) Task# 33
-- Modified by 19-DEC-2015 Akwinass (Engineering Improvement Initiatives- NBL(I) 272)
	IF EXISTS(SELECT 1 FROM Documents D JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId WHERE D.DocumentId = @DocumentId AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(DC.RecordDeleted, 'N') = 'N' AND ISNULL(DC.DiagnosisDocument, 'N') = 'Y' AND ISNULL(DC.ServiceNote, 'N') = 'Y' AND D.ServiceId IS NOT NULL AND ISNULL(@NoteReplacement,'N') <> 'Y')
	BEGIN
		DECLARE @DiagnosisValidation INT = 0
		IF EXISTS (SELECT * FROM dbo.fnSplit(@TablistList, ',') WHERE item = 'DocumentDiagnosisCodes')					
		BEGIN
			--  Below condition modified by Prateek on 17 Aug 2016 w.r.t Riverwood Support #1193
			IF NOT EXISTS(SELECT 1 FROM DocumentDiagnosis WHERE DocumentVersionId = @documentVersionId AND ISNULL(RecordDeleted, 'N') = 'N' AND ISNULL(NoDiagnosis, 'N') = 'Y' ) AND NOT EXISTS (SELECT 1 FROM DocumentDiagnosisCodes D JOIN DiagnosisICD10Codes DD ON D.ICD10CodeId = DD.ICD10CodeId AND D.ICD10Code = DD.ICD10Code WHERE DocumentVersionId = @documentVersionId AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(D.DiagnosisOrder, 0) <= 8)
			BEGIN
				SET @DiagnosisValidation = 1
			END
		END
		ELSE IF EXISTS (SELECT * FROM dbo.fnSplit(@TablistList, ',') WHERE item = 'DiagnosesIAndII')
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM DiagnosesIAndII D JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode AND DD.DSMNumber = D.DSMNumber WHERE DocumentVersionId = @documentVersionId AND ISNULL(D.RecordDeleted, 'N') = 'N' AND ISNULL(D.DiagnosisOrder, 0) <= 8)
			BEGIN
				SET @DiagnosisValidation = 1
			END
		END
		
		IF (ISNULL(@DiagnosisValidation,0) = 1 AND @IsDiagnosisRequired='Y')
		BEGIN
			IF EXISTS(SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DISABLEBILLINGDXIFSERVICENOTEISDX' AND ISNULL(RecordDeleted,'N') = 'N' AND ISNULL(Value,'N') = 'Y')
			BEGIN
				INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage)
				SELECT 'DocumentDiagnosisCodes','DSMVCodeId','Note - Dx - Diagnosis List is required'
			END
			ELSE
			BEGIN
				INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage)
				SELECT 'DocumentDiagnosisCodes','DSMVCodeId','Note - Dx - Diagnosis List is required. Once entered diagnosis, return to the Billing Dx tab and refresh diagnosis.'
			END
		END
	END
	ELSE
	BEGIN			
		DECLARE @DateValue DATETIME

		SET @DateValue = ( SELECT   CONVERT(DATE, Value, 101)
						   FROM     SystemConfigurationKeys
						   WHERE    [Key] = 'BillingDiagnosisStartDate'
						 )
		-- Msood 09/27/2018
		IF EXISTS ( SELECT 1
                    FROM Documents D                         
                    WHERE D.DocumentId = @DocumentId and D.DocumentCodeId <> 300 -- (Progress Note DocumentCodeID = 300)
                        AND ISNULL(D.RecordDeleted, 'N') = 'N')
			Begin
					
				IF CONVERT(DATE, @DateOfService, 101) >= CONVERT(DATE, CONVERT(CHAR(10), @DateValue, 101)) 
					BEGIN
						IF EXISTS ( SELECT  1
									FROM    Services s
									WHERE   s.serviceid = @Serviceid
											AND Billable = 'Y' )
							AND NOT EXISTS ( SELECT 1
											 FROM   [ServiceDiagnosis]
											 WHERE  ServiceId = @ServiceId
													AND ISNULL(Recorddeleted, 'N') = 'N'
													AND DSMVCodeId IS NOT NULL ) AND @IsDiagnosisRequired='Y'
							BEGIN
								INSERT  INTO #validationReturnTable
										( TableName ,
										  ColumnName ,
										  ErrorMessage 
										)
										SELECT  'ServiceDiagnosis' ,
												'DSMVCodeId' ,
												'Billing Diagnosis - Billing Dx is ICD9. Date of service is '
												+ CONVERT(VARCHAR(24), @DateValue, 101)
												+ ' or later. Client must have completed DSM 5 Diagnosis document. Once DSM 5 Diagnosis document has been completed, return to the Service Note and Refresh the Billing Dx.' 
							END
						End
				END
    END
--Changes End Here  
--Added by vishant to implement message code functionality 
    DECLARE @ErrorMessage NVARCHAR(MAX)
    SELECT  @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,
                                                           'MUSTCOMPLETENOTE_SSP',
                                                           'You must first complete the note before you can sign.')     
--If not return error      
    IF ( @count = 0 AND ISNULL(@NoteReplacement,'N') <> 'Y') 
        BEGIN      
            INSERT  INTO #validationReturnTable
                    ( TableName ,
                      ColumnName ,
                      ErrorMessage 
                    )              
--Added by vishant to implement message code functionality 
                    SELECT  @PrimaryTableName ,
                            '' ,
                            @ErrorMessage      
             
--SELECT @PrimaryTableName, '', 'You must first complete the note before you can sign.'  
        END
        
      IF ISNULL(@NoteReplacement,'N') = 'Y' AND NOT EXISTS(SELECT 1 FROM ImageRecords WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N')
      BEGIN
		 INSERT  INTO #validationReturnTable(TableName,ColumnName,ErrorMessage) 
         SELECT  @PrimaryTableName,'','Attachment(s) - Please scan/upload document(s) or deselect checkbox'   
      END      
--Changes End here      
    	-- customer validations across all documents
      EXEC scsp_SCValidateDocument 
        @CurrentUserId
       ,@DocumentId
       ,@CustomValidationStoreProcedureName                   
      
-- Below code by Gautam for task #202, Venture region support to insert validation in #ValidationReturnTableBatch table
-- If this SP is called from BatchDocumentSignature screen.                   
    IF ( @CustomValidationStoreProcedureName <> '' AND ISNULL(@NoteReplacement,'N') <> 'Y') 
        BEGIN
            IF @BatchSignDocument = 'Y' 
                BEGIN  
                    IF OBJECT_ID('tempdb..#ValidationReturnTableBatch') IS NOT NULL 
                        BEGIN
                            INSERT  INTO #ValidationReturnTableBatch
                                    ( TableName ,
                                      ColumnName ,
                                      ErrorMessage ,
                                      TabOrder ,
                                      ValidationOrder
                                    )
                                    EXEC @CustomValidationStoreProcedureName @documentVersionId  
                        END
                END
            ELSE 
                BEGIN
			/* Following Changes by Sonia as now ValidationStoreProcedure name is passed to this Store Procedure as argument*/
			-- Below code umcommented by Priyanka (Ref to task 262 in SC web phase II bugs/Features validate document flow) 
                    EXEC @CustomValidationStoreProcedureName @documentVersionId  
                END                             
        END         

    IF @BatchSignDocument = 'Y' 
        BEGIN     
            IF OBJECT_ID('tempdb..#ValidationReturnTableBatch') IS NOT NULL 
                BEGIN
                    INSERT  INTO #ValidationReturnTableBatch
                            ( TableName ,
                              ColumnName ,
                              ErrorMessage ,
                              PageIndex
                            )
                            SELECT  TableName ,
                                    ColumnName ,
                                    ErrorMessage ,
                                    PageIndex
                            FROM    #validationReturnTable
                            ORDER BY TabOrder ,
                                    ValidationOrder ,
                                    PageIndex ,
                                    ErrorMessage
                END
        END
    ELSE 
        BEGIN
            SELECT  TableName ,
                    ColumnName ,
                    ErrorMessage ,
                    PageIndex
            FROM    #validationReturnTable
            ORDER BY TabOrder ,
                    ValidationOrder ,
                    PageIndex ,
                    ErrorMessage
        END                                
        
                         
      RETURN                                  
            
    error:                                  
                                  
     RAISERROR ('ssp_SCValidateDocument failed.  Contact your system administrator.' ,16,1)                                  
                                  
    RETURN 

GO


