
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_ValidateICD10AdditionalCodes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT')) 
DROP FUNCTION [dbo].[ssf_ValidateICD10AdditionalCodes]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].ssf_ValidateICD10AdditionalCodes 
	(@DocumentVersionId int)
	
	returns @Results table (ErrorMessage varchar(2000))

as

/*-------------------------------------------------------------------------------------------------
  Function: ssf_ValidateICD10AdditionalCodes
  Created:	09/25/2015 gsanborn
  Purpose:	Return an error message for two ICD10Code values if they are related as ConditionCode 
			and AdditionalCode in DiagnosisICD10CodeAdditionalCodes and do not exist on the same 
			DocumentDiagnosis (DocumentVersionId).
			
  Call syntax:
	select ErrorMessage from dbo.ssf_ValidateICD10AdditionalCodes (707069)
	  
  In DocumentValidations:
	set DocumentValidations.ErrorMessage = ' + ErrorMessage + '	-- fool the generated quote-delimiters 
	set DocumentValidations.ValidationLogic = 
		'from dbo.csf_ValidateICD10AdditionalCodes (@DocumentVersionId)'
		
  In hardcoded validation stored procs:
	 select <fields>, ErrorMessage, <fields> 
	   from dbo.ssf_ValidateICD10AdditionalCodes (@DocumentVersionId)  
	   
  Revision History
  Date		By					Description
  ---------	-------------------	-------------------------------------------------------------------
  09/25/15	gsanborn			Created. Valley CATI # 198. 
  10/05/15	gsanborn			Changed "Select top 1" to "select distinct" to accommodate multiple
								specific Note values. This will return multiple validation messages.
  21-Dec-15 Gautam              Added check for SystemConfigurationKeys REQUIREDIAGNOSISCONDITIONVALIDATION to invoke validation
								when set to 'Y' only. Why : Diagnosis Changes (ICD10) > Tasks#44 > ICD10 - Condition/Additional Codes								
  ------------------------------------------------------------------------------------------------- */
  
begin

	insert @Results (ErrorMessage)
	--select top 1  'ICD10Code ' + adx.ConditionCode + ' requires Additional Code: ' + adx.Note 
	select distinct 'ICD10Code ' + adx.ConditionCode + ' requires Additional Code: ' + adx.Note as ErrorMessage		-- 10/05/15 gs
	  from DocumentDiagnosis as dd
	  join DocumentDiagnosisCodes as ddc on ddc.documentVersionId = dd.DocumentVersionId
	  join DiagnosisICD10CodeAdditionalCodes as adx on ddc.ICD10Code like  (adx.ConditionCode + '%') 
	 where dd.DocumentVersionId = @DocumentVersionId
		--21-Dec-15 Gautam 
	   and exists(Select 1 from SystemConfigurationKeys WHERE [key] = 'REQUIREDIAGNOSISCONDITIONVALIDATION' 
				and ISNULL([Value],'N')='Y'  and isnull(RecordDeleted, 'N') = 'N' )
	   and isnull(dd.RecordDeleted, 'N') = 'N' 
	   and isnull(ddc.RecordDeleted, 'N') = 'N' 
	   and not exists (
				select * 
				  from DocumentDiagnosisCodes as ddc1
				  join DiagnosisICD10CodeAdditionalCodes as adx1 on adx1.AdditionalCode = ddc1.ICD10Code  
				 where ddc1.DocumentVersionId = ddc.DocumentVersionId
				   and adx1.ConditionCode = adx.ConditionCode
				   and isnull(ddc1.RecordDeleted, 'N') = 'N' 
			)
	  order by ErrorMessage
	 
	return 
	
end
go