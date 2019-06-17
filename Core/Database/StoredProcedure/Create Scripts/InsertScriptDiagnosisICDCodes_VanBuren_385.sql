-- Insert script for Missing ICD9code but available in DiagnosisICD10ICD9Mapping table
-- Van Buren - Support: #385
Create Table #ICD9Details
(ICD9Code varchar(13),
 ICDDescription varchar(1000))
 
 Insert into #ICD9Details(ICD9Code)
 select distinct ICD9Code  from DiagnosisICD10ICD9Mapping
where ICD9Code not in (select ICDCode from DiagnosisICDCodes)

Update IC
set IC.ICDDescription = DI.ICDDescription
From #ICD9Details IC Join DiagnosisICD10ICD9Mapping MA on IC.ICD9Code= MA.ICD9Code
  join DiagnosisICD10Codes DI on MA.ICD10CodeId= DI.ICD10CodeId

Insert into DiagnosisICDCodes(ICDCode,ICDDescription,IncludeInSearch)
select distinct ICD9Code,ICDDescription,'Y'  from #ICD9Details
where ICD9Code not in (select ICDCode from DiagnosisICDCodes)

--select * from #ICD9Details
drop table #ICD9Details