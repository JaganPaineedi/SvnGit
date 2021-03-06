if object_id('dbo.ssp_CMValidateDiagnosisInformation') is not null 
  drop procedure dbo.ssp_CMValidateDiagnosisInformation
go
  
create procedure dbo.ssp_CMValidateDiagnosisInformation
@DSMCode varchar(20)
/*********************************************************************          
-- Stored Procedure: ssp_CMValidateDiagnosisInformation
-- Copyright: Streamline Healthcare Solutions
--                                                 
-- Purpose: validates claim diagnosis code
--                                                                                  
-- Modified Date    Modified By       Purpose
-- 11.18.2015       SFarber           Added check against DiagnosisICD10Codes
****************************************************************************/           

as 
if exists ( select  '*'
            from    DiagnosisICD10Codes
            where   ICD10Code = @DSMCode ) 
  begin
    select  1
  end
else 
  if len(@DSMCode) <= 6
    and exists ( select '*'
                 from   DiagnosisDSMDescriptions
                 where  DSMCode = @DSMCode ) 
    begin
      select  1
    end  
  else 
    begin
      select  0
    end
	
return
	
go