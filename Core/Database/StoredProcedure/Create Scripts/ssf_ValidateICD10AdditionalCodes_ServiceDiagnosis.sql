
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create function [dbo].ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis 
	(@ServiceId int)
	
	returns @Results table (ErrorMessage varchar(400))

as

/*-------------------------------------------------------------------------------------------------
  Function: ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis
  Created:	09/25/2015 gsanborn
  Purpose:	Return an error message for two ICD10Code values if they are related as ConditionCode 
			and AdditionalCode in DiagnosisICD10CodeAdditionalCodes and do not exist on the same 
			ServiceDiagnosis set (@ServiceId).
			
  Call syntax:
	  select ErrorMessage from  dbo.ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis (3017)
	  
  In DocumentValidations:
	  set DocumentValidations.ErrorMessage = ' + ErrorMessage + '	-- fool the generated quote-delimiters 
	  set DocumentValidations.ValidationLogic = 
		'from dbo.ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis (@ServiceId)'
		
  In hardcoded validation stored procs:
	 select <fields>, ErrorMessage, <fields> 
	   from dbo.ssf_ValidateICD10AdditionalCodes_ServiceDiagnosis (@ServiceId)  
	   
  Revision History
  Date		By					Description
  ---------	-------------------	-------------------------------------------------------------------
  09/25/15	gsanborn			Created. Vallely CATI # 198. 
  10/01/15  Gautam              Added like condition for ICD10Code to do partial matches. Task #44,Diagnosis Changes (ICD10),
								ICD10 - Condition/Additional Codes 
  10/06/15	gsanborn			Changed "Select top 1" to "select distinct" to accommodate multiple
								specific Note values. This will return multiple validation messages.
  21-Dec-15 Gautam              Added check for SystemConfigurationKeys REQUIREDIAGNOSISCONDITIONVALIDATION to invoke validation
								when set to 'Y' only. Why : Diagnosis Changes (ICD10) > Tasks#44 > ICD10 - Condition/Additional Codes		
  15-Jun-17 MJensen				Moved config key check outside query for performance improvement.
								Thresholds Support Task #977						
    ------------------------------------------------------------------------------------------------- */



BEGIN
	IF EXISTS (
			SELECT 1
			FROM SystemConfigurationKeys
			WHERE [key] = 'REQUIREDIAGNOSISCONDITIONVALIDATION'
				AND ISNULL([Value], 'N') = 'Y'
				AND isnull(RecordDeleted, 'N') = 'N'
			)
	BEGIN
		INSERT @Results (ErrorMessage)
		SELECT DISTINCT 'ICD10Code ' + adx.ConditionCode + ' requires Additional Code: ' + adx.Note
		FROM ServiceDiagnosis AS sd
		JOIN DiagnosisICD10CodeAdditionalCodes AS adx ON sd.ICD10Code LIKE (adx.ConditionCode + '%')
		WHERE sd.ServiceId = @ServiceId
			AND isnull(sd.RecordDeleted, 'N') = 'N'
			AND NOT EXISTS (
				SELECT *
				FROM ServiceDiagnosis AS sd1
				JOIN DiagnosisICD10CodeAdditionalCodes AS adx1 ON adx1.AdditionalCode = sd1.ICD10Code
				WHERE sd1.ServiceId = sd.ServiceId
					AND adx1.ConditionCode = adx.ConditionCode
					AND isnull(sd1.RecordDeleted, 'N') = 'N'
				)
	END

	RETURN
END
GO

