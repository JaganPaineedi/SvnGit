/****** Object:  StoredProcedure [dbo].[csp_conv_document_diagnoses]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_document_diagnoses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_document_diagnoses]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_document_diagnoses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
create procedure [dbo].[csp_conv_document_diagnoses]
as

create table #Specifications (
SpecificationId int identity not null,
DocumentVersionId int null,
Specification varchar(max) null,
Processed char(1) null)

if @@error <> 0 goto error

--
-- Diagnoses I and II
--
  
insert into DiagnosesIAndII(
       DocumentVersionId, 
       Axis, 
       DSMCode, 
       DSMNumber,
       DiagnosisType,
       RuleOut, 
       Billable, 
       Severity, 
       DSMVersion, 
       DiagnosisOrder, 
       Specifier, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select dvm.DocumentVersionId, 
       d.axis_type, 
       d.dsm_code, 
       d.dsm_no, 
       case d.diag_type when ''P'' then 140 when ''A'' then 142 end, 
       d.rule_out, 
       case when d.rule_out = ''Y'' then ''N'' else d.is_billable end as billable,
       case d.severity when 0 then null when 1 then 150 when 2 then 151 when 3 then 152 end,
       d.diagnosis_version, 
       d.sequence_no, 
       d.specifier, 
       d.orig_user_Id, 
       d.orig_entry_chron, 
       d.user_id, 
       d.entry_chron
  from Psych..doc_diag_axis_i_iii d
       join Psych..Doc_Entity de on de.doc_session_no = d.doc_session_no 
       /*left*/ join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.version_no
 where d.axis_type in (1, 2)
   and exists(select * from dbo.DiagnosisDSMDescriptions dd where dd.DSMCode = d.dsm_code and dd.DSMNumber = d.dsm_no) --!!!!!!
 order by d.doc_diag_axis_i_iii_id

if @@error <> 0 goto error

-- Set those diagnoses with nothing but V codes as non-billable
update d
   set d.billable = ''N''
  from DiagnosesIandII d
 where d.DSMCode like ''V%''
   and not exists(select *
                   from DiagnosesIandII d2
                  where d2.DocumentVersionId = d.DocumentVersionId
                    and d2.DiagnosisId <> d.DiagnosisId
                    and d2.DSMCode not like ''V%'')

if @@error <> 0 goto error

-- 
-- Diagnoses III
--

create table #DiagnosesIIIDocuments (
DocumentVersionId int not null, 
doc_session_no int null, 
version_no int null, 
doc_diag_axis_i_iii_id int null)

insert into #DiagnosesIIIDocuments (
       DocumentVersionId, 
       doc_session_no, 
       version_no, 
       doc_diag_axis_i_iii_id)
select dvm.DocumentVersionId,
       d.doc_session_no,
       d.version_no,
       min(d.doc_diag_axis_i_iii_id)
  from Psych..doc_diag_axis_i_iii d
       join Psych..Doc_Entity de on de.doc_session_no = d.doc_session_no 
       /*left*/ join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.version_no
 where d.axis_type = 3
   and d.diagnosis_version <> ''dsmiv''
 group by dvm.DocumentVersionId, d.doc_session_no, d.version_no

if @@error <> 0 goto error

insert into DiagnosesIII (
       DocumentVersionId,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select dd.DocumentVersionId,
       d.orig_user_id,
       d.orig_entry_chron,
       d.user_id,
       d.entry_chron
  from #DiagnosesIIIDocuments dd
       join Psych..doc_diag_axis_i_iii d on d.doc_diag_axis_i_iii_id = dd.doc_diag_axis_i_iii_id

if @@error <> 0 goto error

insert into #Specifications (
       DocumentVersionId, 
       Specification, 
       Processed)
select dd.DocumentVersionId, 
       d.specifier, 
       ''N''
  from #DiagnosesIIIDocuments dd
       join Psych..doc_diag_axis_i_iii d on d.doc_session_no = dd.doc_session_no and d.version_no = dd.version_no
 where len(d.specifier) > 0 
 order by d.doc_diag_axis_i_iii_id

if @@error <> 0 goto error

create index XIE_#Specifications on #Specifications(DocumentVersionId)

if @@error <> 0 goto error

while exists (select * from #Specifications where Processed = ''N'')
begin
  update d
     set Specification = case when d.Specification is null then s.Specification else d.Specification + char(13) + char(10) + s.Specification end
    from DiagnosesIII d
         join #Specifications s on s.DocumentVersionId = d.DocumentVersionId
   where s.Processed = ''N''
     and not exists(select *
                      from #Specifications s2
                     where s2.DocumentVersionId = s.DocumentVersionId
                       and s2.Processed = ''N''
                       and s2.SpecificationId < s.SpecificationId)

  if @@error <> 0 goto error
                       
  update s
     set Processed = ''Y''
    from DiagnosesIII d
         join #Specifications s on s.DocumentVersionId = d.DocumentVersionId
   where s.Processed = ''N''
     and not exists(select *
                      from #Specifications s2
                     where s2.DocumentVersionId = s.DocumentVersionId
                       and s2.Processed = ''N''
                       and s2.SpecificationId < s.SpecificationId)

  if @@error <> 0 goto error
end                       

insert into DiagnosesIIICodes (
       DocumentVersionId,
       ICDCode,
       Billable,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select dd.DocumentVersionid,
       d.dsm_code,
       case when d.rule_out = ''Y'' then ''N'' else d.is_billable end,       
       d.orig_user_Id, 
       d.orig_entry_chron, 
       d.user_id, 
       d.entry_chron
  from #DiagnosesIIIDocuments dd
       join Psych..doc_diag_axis_i_iii d on d.doc_session_no = dd.doc_session_no and d.version_no = dd.version_no
 where exists(select * from dbo.DiagnosisICDCodes i where i.ICDCode = d.dsm_code) --!!!!!
 order by d.doc_diag_axis_i_iii_id                            

if @@error <> 0 goto error

--
-- Diagnoses IV
--

create table #DiagnosesIVDocuments (
DocumentVersionId int not null, 
doc_session_no int null, 
version_no int null, 
category_id int null,
PrimarySupport char(1) null,
SocialEnvironment char(1) null,
Educational char(1) null,
Occupational char(1) null,
Housing char(1) null,
Economic char(1) null,
HealthcareServices char(1) null,
Legal char(1) null,
Other char(1) null)


insert into #DiagnosesIVDocuments (
       DocumentVersionId, 
       doc_session_no, 
       version_no, 
       category_id,
       PrimarySupport,
       SocialEnvironment,
       Educational,
       Occupational,
       Housing,
       Economic,
       HealthcareServices,
       Legal,
       Other)
select dvm.DocumentVersionId,
       d.doc_session_no,
       d.version_no,
       min(d.category_id),
       max(case d.category_id when 1 then ''Y'' else null end) as PrimarySupport,
	   max(case d.category_id when 2 then ''Y'' else null end) as SocialEnvironment,
	   max(case d.category_id when 3 then ''Y'' else null end) as Educational,
	   max(case d.category_id when 4 then ''Y'' else null end) as Occupational,
	   max(case d.category_id when 5 then ''Y'' else null end) as Housing,
	   max(case d.category_id when 6 then ''Y'' else null end) as Economic,
	   max(case d.category_id when 7 then ''Y'' else null end) as HealthcareServices,
	   max(case d.category_id when 8 then ''Y'' else null end) as Legal,
	   max(case d.category_id when 9 then ''Y'' else null end) as Other
  from Psych..doc_diag_axis_iv d
       join Psych..Doc_Entity de on de.doc_session_no = d.doc_session_no 
       /*left*/ join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.version_no
 group by dvm.DocumentVersionId, d.doc_session_no, d.version_no

if @@error <> 0 goto error

insert into DiagnosesIV (
       DocumentVersionId,
       PrimarySupport,
       SocialEnvironment,
       Educational,
       Occupational,
       Housing,
       Economic,
       HealthcareServices,
       Legal,
       Other,
       CreatedBy,
       CreatedDate,
       ModifiedBy,
       ModifiedDate)
select dd.DocumentVersionId,
       dd.PrimarySupport,
       dd.SocialEnvironment,
       dd.Educational,
       dd.Occupational,
       dd.Housing,
       dd.Economic,
       dd.HealthcareServices,
       dd.Legal,
       dd.Other,
       d.orig_user_id,
       d.orig_entry_chron,
       d.user_id,
       d.entry_chron
  from #DiagnosesIVDocuments dd
       join Psych..doc_diag_axis_iv d on d.doc_session_no = dd.doc_session_no and d.version_no = dd.version_no and d.category_id = dd.category_id

if @@error <> 0 goto error

truncate table #Specifications
    
if @@error <> 0 goto error
       
insert into #Specifications (
       DocumentVersionId, 
       Specification, 
       Processed)
select dd.DocumentVersionId, 
       d.specification, 
       ''N''
  from #DiagnosesIVDocuments dd
       join Psych..doc_diag_axis_iv d on d.doc_session_no = dd.doc_session_no and d.version_no = dd.version_no
 where len(d.specification) > 0 
 order by d.doc_session_no, d.version_no, d.category_id
 
if @@error <> 0 goto error
 
while exists (select * from #Specifications where Processed = ''N'')
begin
  update d
     set Specification = case when d.Specification is null then s.Specification else d.Specification + char(13) + char(10) + s.Specification end
    from DiagnosesIV d
         join #Specifications s on s.DocumentVersionId = d.DocumentVersionId
   where s.Processed = ''N''
     and not exists(select *
                      from #Specifications s2
                     where s2.DocumentVersionId = s.DocumentVersionId
                       and s2.Processed = ''N''
                       and s2.SpecificationId < s.SpecificationId)

  if @@error <> 0 goto error
                       
  update s
     set Processed = ''Y''
    from DiagnosesIV d
         join #Specifications s on s.DocumentVersionId = d.DocumentVersionId
   where s.Processed = ''N''
     and not exists(select *
                      from #Specifications s2
                     where s2.DocumentVersionId = s.DocumentVersionId
                       and s2.Processed = ''N''
                       and s2.SpecificationId < s.SpecificationId)

  if @@error <> 0 goto error
end                        
 
--
-- Diagnoses V
--

insert into DiagnosesV(
       DocumentVersionId, 
       AxisV,
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select dvm.DocumentVersionId,
       d.level_no,
       d.orig_user_id, 
       d.orig_entry_chron, 
       d.user_id, 
       d.entry_chron
  from Psych..doc_diag_axis_v d
       join Psych..Doc_Entity de on de.doc_session_no = d.doc_session_no 
       /*left*/ join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = d.doc_session_no and dvm.version_no = d.version_no
 where exists(select * from DiagnosisAxisVLevels dd where dd.LevelNumber = d.level_no) --!!!!!       
   and d.sequence_no = 1 --!!!!!!!! more than one level per document
 order by d.orig_entry_chron, dvm.DocumentVersionId

if @@error <> 0 goto error

return

error:

raiserror 50000 ''csp_conv_document_diagnosis failed''

return

' 
END
GO
