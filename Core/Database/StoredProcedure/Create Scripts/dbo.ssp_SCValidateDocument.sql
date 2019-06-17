IF EXISTS ( SELECT  1
            FROM    sys.procedures
            WHERE   name = 'ssp_SCValidateDocument' ) 
    BEGIN
        DROP PROCEDURE dbo.ssp_SCValidateDocument
    END
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
-- 14 OCT 2015	RQuigley	   Enforce Diagnosis entry on DocumentCodes marked as DxDocuments
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
        
        
                              
    SELECT  @documentVersionId = InProgressDocumentVersionId ,
            @ServiceId = S.ServiceId ,
            @DocumentCodeId = Documents.DocumentCodeId ,       -- added by Rakesh to get @DocumentCodeId      
            @TablistList = TableList ,       --  added by Rakesh to get @TablistList 
            @DateOfService = S.DateOfService
    FROM    Documents
            JOIN DocumentCodes ON Documents.DocumentCodeId = DocumentCodes.DocumentCodeId
            LEFT JOIN Services S ON S.ServiceId = Documents.ServiceId
    WHERE   DocumentId = @DocumentId        
      
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
            GOTO EndStatment; 
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
                            'Service - Service Duration can not be zero.' 
            GOTO EndStatment;
        END 
--Changes End Here

-- Added by Bernardin w.rf to Diagnosis Changes (ICD10) Task# 33
    DECLARE @DateValue DATETIME

    SET @DateValue = ( SELECT   CONVERT(DATE, Value, 101)
                       FROM     SystemConfigurationKeys
                       WHERE    [Key] = 'BillingDiagnosisStartDate'
                     )
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
                                        AND DSMVCodeId IS NOT NULL ) 
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
                    GOTO EndStatment;
                END
        END
--Changes End Here  
--Added by vishant to implement message code functionality 
    DECLARE @ErrorMessage NVARCHAR(MAX)
    SELECT  @ErrorMessage = dbo.Ssf_GetMesageByMessageCode(29,
                                                           'MUSTCOMPLETENOTE_SSP',
                                                           'You must first complete the note before you can sign.')     
--If not return error      
    IF ( @count = 0 ) 
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
            GOTO EndStatment;      
        END      
--Changes End here      
           
	/*
	*	If RequireDiagnosisOnDxDocuments is set, we must verify that diagnosis information
	*	was entered or that the clinician purposefully is leaving out a diagnosis.
	*/		   
    IF EXISTS ( SELECT  1
                FROM    dbo.SystemConfigurationKeys
                WHERE   [key] = 'RequireDiagnosisOnDxDocuments'
                        AND ISNULL(Value, 'N') = 'Y' )
        AND EXISTS ( SELECT 1
                     FROM   DocumentCodes dc
                            JOIN Documents d ON d.DocumentCodeId = dc.DocumentCodeId
                     WHERE  d.CurrentDocumentVersionId = @DocumentVersionId
                            AND ( ISNULL(dc.DiagnosisDocument, 'N') = 'Y'
                                  OR ISNULL(dc.DSMV, 'N') = 'Y'
                                )
                            AND ( NOT EXISTS ( SELECT   1
                                               FROM     dbo.DocumentDiagnosisCodes ddc
                                               WHERE    DDC.DocumentVersionId = @DocumentVersionId
                                                        AND ISNULL(ddc.RecordDeleted,
                                                              'N') = 'N' )
                                )
                            AND EXISTS ( SELECT 1
                                         FROM   dbo.DocumentDiagnosis dd
                                         WHERE  dd.DocumentVersionId = @DocumentVersionId
                                                AND ISNULL(dd.NoDiagnosis, 'N') = 'N'
                                                AND ISNULL(dd.RecordDeleted,
                                                           'N') = 'N' ) ) 
        BEGIN
            INSERT  INTO #ValidationReturnTable
                    ( TableName ,
                      ColumnName ,
                      ErrorMessage 
                    )
                    SELECT  'Diagnosis' ,
                            '' ,
                            'Document requires at least one diagnosis or that the No Diagnosis box is checked.'
        END  
      
-- Below code by Gautam for task #202, Venture region support to insert validation in #ValidationReturnTableBatch table
-- If this SP is called from BatchDocumentSignature screen.                   
    IF ( @CustomValidationStoreProcedureName <> '' ) 
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
--      
-- Validation rules which apply for all documents      
--      
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AllStandardSignatureValidations]') AND type in (N'P', N'PC'))      
 --BEGIN      
  --EXEC csp_AllStandardSignatureValidations @DocumentVersionId, @ServiceId      
 --END      
 --ELSE  --Added ELSE By Varinder 
 -- calling scsp_SCValidateDocument here This will be custom      
    EXEC scsp_SCValidateDocument @CurrentUserId, @DocumentId,
        @CustomValidationStoreProcedureName      
                           
    EndStatment:    
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
                                  
    RAISERROR 50000 'ssp_SCValidateDocument failed.  Contact your system administrator.'                                  
                                  
    RETURN 


GO
