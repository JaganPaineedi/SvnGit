IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateDiagnosisNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateDiagnosisNew]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_validateDiagnosisNew]        
@DocumentVersionId Int        
        
as        
/****************************************************************************** 
**  Change History                      
*******************************************************************************                      
**  Date:      Author:  Purpose:      Description:                      
**  ---------  --------  ----------    -------------------------------------------                      
**  22-Nov-2016	Bibhu	What: Calling SCSP_SCValidateDocumentEffectiveDate for Effective Date Validation          
**						Why:task #197 Bradford - Customizations
/*  16-Feb-2017  msood  Added RecordDeleted Check (Task #603 in Ionia - Support)*/ 
/*  15-Dec-2017  Neelima  Modified the select to get @DocumentCodeId , since its has CurrentDocumentVersionId instead of InProgressDocumentVersionId (Task #314 in 	Philhaven-Support)*/ 
*******************************************************************************/        
 BEGIN
 BEGIN TRY 
 DECLARE @DocumentCodeId INT      
 
 SET @DocumentCodeId =(Select DocumentCodeId From Documents as d join DocumentVersions as dv on dv.DocumentId = d.DocumentId where dv.DocumentVersionId=@DocumentVersionId)     -- Modified by Neelima
        
Create Table #DocumentDiagnosisCodes        
(        
 ICD10CodeId Varchar(20) NULL ,        
 ICD10Code Varchar(20) NULL ,        
 ICD9Code Varchar(20) NULL ,        
 DiagnosisType int,        
 RuleOut char(1),        
 Billable char(1),        
 Severity int,       
 DiagnosisOrder int NOT NULL ,        
 Specifier text NULL ,        
 CreatedBy varchar(100),        
 CreatedDate Datetime,        
 ModifiedBy varchar(100),        
 ModifiedDate Datetime,        
 RecordDeleted char(1),        
 DeletedDate datetime NULL ,        
 DeletedBy varchar(100)         
)        
Insert into #DocumentDiagnosisCodes        
(        
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,        
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,        
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,         
RecordDeleted, DeletedDate, DeletedBy )        
        
select        
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,        
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,        
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,         
RecordDeleted, DeletedDate, DeletedBy        
FROM DocumentDiagnosisCodes        
where documentversionId = @documentversionId        
and isnull(RecordDeleted,'N') = 'N'        
       
--        
-- DECLARE VARIABLES        
--        
declare @Variables varchar(max)        
declare @DocumentType varchar(20)        
        
--        
-- DECLARE TABLE SELECT VARIABLES        
--        
set @Variables = 'Declare @DocumentVersionId int, @DocumentCodeId int        
     Set @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId)+' '+        
     'Set @DocumentCodeId = ' + convert(varchar(20),@DocumentCodeId)        
        
set @DocumentCodeId = 1601 --Call Dx Validation script        
set @DocumentType = 10       
   
  ---- 22-Nov-2016	Bibhu
 IF EXISTS ( SELECT  *  
            FROM    sys.objects  
            WHERE   object_id = OBJECT_ID(N'SCSP_SCValidateDocumentEffectiveDate')  
                    AND type IN ( N'P', N'PC' ) ) 
    BEGIN     
 EXEC SCSP_SCValidateDocumentEffectiveDate @DocumentVersionId 
     END    
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables        
        
 END TRY                      
BEGIN CATCH                      
 DECLARE @ERROR VARCHAR(8000)                      
 SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                       
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_validateDiagnosisNew')                       
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                        
    + '*****' + CONVERT(VARCHAR,ERROR_STATE())                      
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16,  -- Severity.                      
  1  -- State.                      
 );                   
END CATCH   

END
GO   
        
        
        
        
        
        
        
        
        
        