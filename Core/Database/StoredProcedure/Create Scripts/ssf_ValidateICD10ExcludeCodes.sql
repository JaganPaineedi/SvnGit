
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_ValidateICD10ExcludeCodes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_ValidateICD10ExcludeCodes]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create function [dbo].ssf_ValidateICD10ExcludeCodes 
	(@DocumentVersionId int)
	
	returns @Results table (ErrorMessage varchar(400))

as

/*-------------------------------------------------------------------------------------------------
  Function: ssf_ValidateICD10ExcludeCodes
  Created:	09/25/2015 gsanborn
  Purpose:	Return an error message for two ICD10Code values if they exist on the same ServiceDiagnosis
			set (@ServiceId) and are related as ConditionCode and ExcludeCode in table 
			DiagnosisICD10CodeExcludeCodes.
			
  Call syntax:
	  select ErrorMessage  from dbo.ssf_ValidateICD10ExcludeCodes (707069)

  In DocumentValidations:
	  set DocumentValidations.ErrorMessage = ' + ErrorMessage + '	-- extra + and quote marks to fool the generated quote-delimiters 
	  set DocumentValidations.ValidationLogic = 
		'from dbo.ssf_ValidateICD10ExcludeCodes (@ServiceId)'
		
  In hardcoded validation stored procs:
	 select <fields>, ErrorMessage, <fields> 
	   from dbo.ssf_ValidateICD10ExcludeCodes (@ServiceId)  
	   
  Revision History
  Date		By					Description
  ---------	-------------------	-------------------------------------------------------------------
  09/25/15	gsanborn			Created. Vallely CATI # 198. 
  21-Dec-15 Gautam              Added check for SystemConfigurationKeys REQUIREDIAGNOSISCONDITIONVALIDATION to invoke validation
								when set to 'Y' only. Why : Diagnosis Changes (ICD10) > Tasks#44 > ICD10 - Condition/Additional Codes								
  ------------------------------------------------------------------------------------------------- */

begin
	insert @Results (ErrorMessage) 
	select top 1 'ICD10Code ' + edx.ExcludeCode + ' is Excluded (not permitted) with ICD10Code ' + edx.ConditionCode
	  from DocumentDiagnosis as dd
	  join DocumentDiagnosisCodes as ddc on ddc.documentVersionId = dd.DocumentVersionId
	  join DiagnosisICD10CodeExcludeCodes as edx on ddc.ICD10Code like (edx.ConditionCode + '%') 
	  join DocumentDiagnosisCodes as ddc1 on ddc1.DocumentVersionId = dd.DocumentVersionId and ddc1.ICD10Code = edx.ExcludeCode
	 where dd.DocumentVersionId = @DocumentVersionId
		--21-Dec-15 Gautam 
	   and exists(Select 1 from SystemConfigurationKeys WHERE [key] = 'REQUIREDIAGNOSISCONDITIONVALIDATION' 
				and ISNULL([Value],'N')='Y'  and isnull(RecordDeleted, 'N') = 'N' )
	   and isnull(dd.RecordDeleted, 'N') = 'N' 
	   and isnull(ddc.RecordDeleted, 'N') = 'N' 
	   and isnull(ddc1.RecordDeleted, 'N') = 'N' 
	   
	return 

end
go