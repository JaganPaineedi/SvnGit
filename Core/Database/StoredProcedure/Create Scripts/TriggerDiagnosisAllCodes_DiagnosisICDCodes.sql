if object_id('dbo.TriggerDiagnosisAllCodes_DiagnosisICDCodes') is not null 
  drop trigger dbo.TriggerDiagnosisAllCodes_DiagnosisICDCodes
go

create trigger dbo.TriggerDiagnosisAllCodes_DiagnosisICDCodes on dbo.DiagnosisICDCodes
  for insert, update, delete
/*********************************************************************
-- Trigger: TriggerDiagnosisAllCodes_DiagnosisICDCodes
--
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: maintains DiagnosisAllCodes and DiagnosisAllCodeKeywords tables
--
-- Updates: 
--  Date         Author       Purpose
--  08.04.2015   SFarber      Created.
--
**********************************************************************/
as
create table #DiagnosisCodes (
DiagnosisCode varchar(25))

create table #DiagnosisAllCodes (
DiagnosisAllCodeId int)

declare @ErrorNumber int
declare @ErrorMessage varchar(255)

insert  into #DiagnosisCodes
        (DiagnosisCode)
        select  i.ICDCode
        from    inserted i
        union
        select  d.ICDCode
        from    deleted d

delete  dackw
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'ICD9'
        join DiagnosisAllCodeKeywords dackw on dackw.DiagnosisAllCodeId = dac.DiagnosisAllCodeId

if @@error <> 0 
  begin
    select  @ErrorNumber = 50010,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodeKeywords'
    goto error
  end 

delete  dac
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'ICD9'

if @@error <> 0 
  begin
    select  @ErrorNumber = 50020,
            @ErrorMessage = 'Failed to delete from DiagnosisAllCodes'
    goto error
  end 

insert  into DiagnosisAllCodes
        (DiagnosisCode,
         CodeType,
         DiagnosisDescription,
         IncludeInSearch)
output  inserted.DiagnosisAllCodeId
        into #DiagnosisAllCodes (DiagnosisAllCodeId)
        select  icd.ICDCode,
                'ICD9',
                icd.ICDDescription,
                icd.IncludeInSearch
        from    #DiagnosisCodes dc
                join dbo.DiagnosisICDCodes icd on icd.ICDCode = dc.DiagnosisCode

if @@error <> 0 
  begin
    select  @ErrorNumber = 50030,
            @ErrorMessage = 'Failed to insert into DiagnosisAllCodes'
    goto error
  end 

exec ssp_PopulateDiagnosisAllCodeKeywordsTable 

if @@error <> 0 
  begin
    select  @ErrorNumber = 50040,
            @ErrorMessage = 'Failed to execute ssp_PopulateDiagnosisAllCodeKeywordsTable'
    goto error
  end 

return

error:
raiserror @ErrorNumber @ErrorMessage
rollback transaction

go

