/****** Object:  StoredProcedure [dbo].[csp_conv_Documents]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Documents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Documents]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Documents]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_conv_Documents]
as

declare @activity	varchar(200)
declare	@start		int
declare	@stop		int

select 	@start = 1,	@stop = 2

/*
insert into Cstm_Conv_Map_DocumentCodes (DocumentCodeId, Doc_Code)
select dc.DocumentCodeId, d.doc_code
  from DocumentCodes dc
       join Psych..Document d on d.doc_code = dc.ExternalReferenceId  
 where not exists(select *
                    from Cstm_Conv_Map_DocumentCodes dcm
                   where dcm.Doc_Code = d.doc_code)       

if @@error <> 0 goto error
*/

insert into Cstm_Conv_Map_Documents (
       Doc_Session_No)
select d.Doc_session_no
  from Psych..Doc_Entity d
       join Cstm_Conv_Map_Clients cm on cm.patient_id = d.patient_id
       join Cstm_Conv_Map_DocumentCodes dc on dc.Doc_Code = d.doc_code
 where d.Status in (''SN'', ''SA'', ''CO'')  --!!!! do we need In Progress
   and not exists(select *
                    from Cstm_Conv_Map_Documents dm
                   where dm.Doc_Session_no = d.doc_session_no)                           
 order by d.Doc_Session_No
 
if @@error <> 0 goto error

set identity_insert Documents on

insert into Documents (
       DocumentId, 
       ClientId, 
       ServiceId, 
       DocumentCodeId, 
       EffectiveDate, 
       DueDate, 
       Status, 
       AuthorId, 
       CurrentDocumentVersionId,
       DocumentShared,
       SignedByAuthor,
       SignedByAll,
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate, 
       RecordDeleted, 
       DeletedDate, 
       DeletedBy)
select dm.DocumentId, 
       cm.ClientId, 
       null, --sm.ServiceId, 
       dcm.DocumentCodeId, 
       isnull(d.Effective_Date, d.orig_entry_chron),
       NULL,        case when d.Status in (''NS'',''IP'') then 21
	        when d.Status in (''SA'', ''SN'', ''CO'') then 22 
	        when d.Status = ''ER'' then 23 
       end,
       stm.StaffId, --AuthorId
       null, --CurrentDocumentVersionId
       case when d.Status in (''SA'', ''SN'', ''CO'') then ''Y'' else ''N'' end,
       case when d.status in (''SN'', ''SA'') then ''Y'' else ''N'' end,
       case when d.status in (''SA'') then ''Y'' else ''N'' end,
       d.orig_user_id, 
       d.orig_entry_chron, 
       isnull(d.user_id, d.orig_user_id),        isnull(d.entry_chron, d.orig_entry_chron),
       NULL, 
       NULL, 
       NULL
  from Psych..Doc_entity d
       join Cstm_Conv_Map_Documents dm on dm.doc_session_no = d.Doc_session_no
       join Cstm_Conv_Map_DocumentCodes dcm on dcm.doc_code = d.Doc_code
       join Cstm_Conv_Map_Clients cm on cm.patient_id = d.patient_id
       --left join Cstm_Conv_Map_Services sm on sm.clinical_transaction_no = d.clinical_transaction_no
       left join Cstm_Conv_Map_Staff stm on stm.staff_id = d.Author_Id
 where not exists(select *
                    from Documents d2
                   where d2.DocumentId = dm.DocumentId)
                                       
if @@error <> 0 goto error

set identity_insert Documents off

insert into Cstm_Conv_Map_DocumentVersions (
       DocumentId,
       doc_session_no,
       version_no)
select dv.DocumentId,
       dv.doc_session_no,
       dv.version_no
  from (              
select dm.DocumentId,
       dev.doc_session_no,
       dev.version_no,
       dev.orig_entry_chron
  from Psych..Doc_Entity_Version dev
       join Cstm_Conv_Map_Documents dm on dm.doc_session_no = dev.doc_session_no
union
select dm.DocumentId,
       de.doc_session_no,
       de.current_version_no,
       de.orig_entry_chron
  from Psych..Doc_Entity de
       join Cstm_Conv_Map_Documents dm on dm.doc_session_no = de.doc_session_no
 where not exists(select *
                    from Psych..Doc_Entity_Version dev
                   where dev.doc_session_no = de.doc_session_no
                     and dev.version_no = de.current_version_no)) as dv                          
 where not exists(select *
                    from Cstm_Conv_Map_DocumentVersions dvm
                   where dvm.doc_session_no = dv.doc_session_no
                     and dvm.version_no = dv.version_no)
 order by dv.orig_entry_chron, dv.doc_session_no, dv.version_no       

if @@error <> 0 goto error

set identity_insert DocumentVersions on
       
insert into DocumentVersions (
       DocumentVersionId,
       DocumentId,
       Version, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select dvm.DocumentVersionId,
       dvm.DocumentId, 
       dvm.version_no,
       isnull(dev.orig_user_id, de.orig_user_id),
       isnull(dev.orig_entry_chron, de.orig_entry_chron),
       isnull(dev.user_id, isnull(de.user_id, de.orig_user_id)),
       isnull(dev.entry_chron, isnull(de.entry_chron, de.orig_entry_chron))
  from Cstm_Conv_Map_DocumentVersions dvm
       left join Psych..Doc_Entity_Version dev on dev.doc_session_no = dvm.doc_session_no and dev.version_no = dvm.version_no
       left join Psych..Doc_Entity de on de.doc_session_no = dvm.doc_session_no and de.current_version_no = dvm.version_no
 where not exists(select *
                    from DocumentVersions dv
                   where dv.DocumentVersionId = dvm.DocumentVersionId)
                          
if @@error <> 0 goto error

set identity_insert DocumentVersions off
       
update d
   set CurrentDocumentVersionId = dvm.DocumentVersionId,
       InprogressDocumentVersionid = dvm.DocumentVersionId
  from Documents d
       join Cstm_Conv_Map_Documents dm on dm.DocumentId = d.DocumentId
       join Psych..Doc_Entity de on de.doc_session_no = dm.Doc_Session_no
       join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = de.doc_session_no and dvm.version_no = de.current_version_no
             
if @@error <> 0 goto error

-- Document signatures

insert into DocumentSignatures (
       DocumentId, 
       SignedDocumentVersionId,
       StaffId, 
       ClientId, 
       IsClient, 
       SignerName, 
       SignatureOrder, 
       SignatureDate, 
       VerificationMode, 
       PhysicalSignature, 
       DeclinedSignature, 
       ClientSignedPaper,
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select dvm.DocumentId, 
       dvm.DocumentVersionid,
       sm.StaffId, 
       cm.ClientId, 
       NULL, 
       isnull(s.FirstName,''Unknown'') + '' '' +isnull(s.LastName,''Unknown'') +isnull(s.SigningSuffix,''''), 
       ds.Sign_Sequence_No, 
       ds.Sign_date, 
       NULL, 
       NULL, 
       NULL, 
       NULL,
       ds.orig_user_id, 
       ds.orig_entry_chron, 
       ds.user_id, 
       ds.entry_chron
  from Psych..doc_signature ds
       join Psych..Doc_Entity de on de.doc_session_no = ds.doc_session_no
       join Cstm_Conv_Map_Documents dm on dm.doc_session_no = de.doc_session_no
       join Cstm_Conv_Map_DocumentVersions dvm on dvm.doc_session_no = ds.doc_session_no and dvm.version_no = isnull(ds.version_no, 1)
       left join Cstm_Conv_Map_Staff sm on sm.staff_id = ds.Staff_Id
       left join Cstm_Conv_Map_Clients cm on cm.patient_id = de.patient_id
       left join Staff s on sm.staffId = s.StaffId
 where not exists(select * from DocumentSignatures ds2 where ds2.SignedDocumentVersionId = dvm.DocumentVersionid)
 order by ds.orig_entry_chron, ds.Sign_Sequence_No, dvm.DocumentVersionid

if @@error <> 0 goto error

-- Convert Diagnoses
if not exists(select * from DiagnosesIAndII d join Cstm_Conv_Map_DocumentVersions dv on dv.DocumentVersionId = d.DocumentVersionId)
begin
  select @activity = ''exec csp_conv_Document_Diagnosis''
  exec csp_conversionTimeline @activity, @start
  exec csp_conv_Document_Diagnoses
  if @@error <> 0 goto error
  exec csp_conversionTimeline @activity, @stop
end

-- Convert Custom Documents
select @activity = ''exec csp_conv_Document_CustomDocuments''
exec csp_conversionTimeline @activity, @start
exec csp_conv_Document_CustomDocuments
if @@error <> 0 goto error
exec csp_conversionTimeline @activity, @stop






return 

error:

raiserror 50060 ''csp_conv_Documents Failed''

' 
END
GO
