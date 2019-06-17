if object_id('dbo.TriggerDiagnosisAllCodes_SNOMEDCTCodes') is not null 
  drop trigger dbo.TriggerDiagnosisAllCodes_SNOMEDCTCodes
go

create trigger dbo.TriggerDiagnosisAllCodes_SNOMEDCTCodes on dbo.SNOMEDCTCodes
  for insert, update, delete
/*********************************************************************
-- Trigger: TriggerDiagnosisAllCodes_SNOMEDCTCodes
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
        select  i.SNOMEDCTCode
        from    inserted i
        union
        select  d.SNOMEDCTCode
        from    deleted d

delete  dackw
from    #DiagnosisCodes dc
        join DiagnosisAllCodes dac on dac.DiagnosisCode = dc.DiagnosisCode
                                      and dac.CodeType = 'SNOMED'
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
                                      and dac.CodeType = 'SNOMED'

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
        select  smed.SNOMEDCTCode,
                'SNOMED',
                smed.SNOMEDCTDescription,
                'Y'
        from    #DiagnosisCodes dc
                join dbo.SNOMEDCTCodes smed on smed.SNOMEDCTCode = dc.DiagnosisCode

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

