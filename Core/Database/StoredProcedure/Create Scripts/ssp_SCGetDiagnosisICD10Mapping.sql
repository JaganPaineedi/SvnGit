IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDiagnosisICD10Mapping]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDiagnosisICD10Mapping]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetDiagnosisICD10Mapping]        
/********************************************************************************        
-- Stored Procedure: dbo.ssp_SCGetDiagnosisICD10Mapping          
-- Created By	: Bernardin
-- Created Date	: 22 May 2014	       
-- Copyright: Streamline Healthcate Solutions    
-- Purpose: Gets Diagnosis ICD10 Mapping values

** Update Info
**	Date		Author				Purpose
********************************************************************************/
AS 

BEGIN
	BEGIN TRY
	-- DiagnosisICD10Codes
	SELECT ICD10CodeId,ICD10Code,ICDDescription,IncludeInSearch FROM  DiagnosisICD10Codes
	-- DiagnosisDSMVCodes
	SELECT DSMVCodeId,DSMDescription,ICD10Code FROM DiagnosisDSMVCodes
	-- DiagnosisDSMVICD9Mappings
	SELECT DSMVIC9MappingId,DSMVCodeId,ICD9Code FROM DiagnosisDSMVICD9Mapping
	-- DiagnosisICD10ICD9
	SELECT Distinct DDI9M.DSMVCodeId,DDSMVC.ICD10Code,DDI9M.ICD9Code,DDSMVC.DSMDescription,DICD10C.IncludeInSearch
           FROM DiagnosisDSMVICD9Mapping AS DDI9M INNER JOIN
                      DiagnosisDSMVCodes AS DDSMVC ON DDI9M.DSMVCodeId = DDSMVC.DSMVCodeId INNER JOIN
                      DiagnosisICD10Codes DICD10C ON DDSMVC.ICD10Code = DICD10C.ICD10Code                   
 END TRY

	BEGIN CATCH 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCGetDiagnosisICD10Mapping' ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.              
                      16,-- Severity.              
                      1 -- State.              
          ); 
      END CATCH
END
