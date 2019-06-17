create procedure csp_DSMCodeTransferInsertDrop

as

if not exists (select * from DiagnosisDSMDescriptionCategories)
begin
insert into DiagnosisDSMDescriptionCategories (DiagnosisCategory, DSMCode, DSMNumber)
select DC, cast(DSMCode as varchar), DSMNumber from ztemp
drop table ztemp
end

if not exists (select * from DiagnosisDSMDescriptionCategories)
begin
insert into DiagnosisDSMDescriptionCategories (DiagnosisCategory, DSMCode, DSMNumber)
select DC, cast(DSMCode as varchar), DSMNumber from zztemp
drop table zztemp
end
