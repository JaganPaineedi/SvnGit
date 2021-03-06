/****** Object:  StoredProcedure [dbo].[csp_conv_Document_TxPlans]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_TxPlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_TxPlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_TxPlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_conv_Document_TxPlans]
as

declare @reseed int

select @reseed = max(DocumentId) + 1000 from Documents

DBCC CHECKIDENT (Cstm_Conv_Map_Document_TxPlans, reseed, @reseed) WITH NO_INFOMSGS

if @@error <> 0 goto error

insert into Cstm_Conv_Map_Document_TxPlans (
       plan_id)
select d.plan_id
  from Psych..TXP_Master d
       join Cstm_Conv_Map_Clients cm on cm.patient_id = d.patient_id
 where d.Status in (''AC'')  
   and not exists(select *
                    from Cstm_Conv_Map_Document_TxPlans dm
                   where dm.plan_id = d.plan_id)                           
 order by d.plan_id

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
       2, --DocumentCodeId
       isnull(d.Effective_Date, d.orig_entry_chron),
       NULL,        22,
       stm.StaffId, --AuthorId
       null, --CurrentDocumentVersionId
       ''Y'',
       ''Y'',
       ''Y'',
       d.orig_user_id, 
       d.orig_entry_chron, 
       isnull(d.user_id, d.orig_user_id),        isnull(d.entry_chron, d.orig_entry_chron),
       NULL, 
       NULL, 
       NULL
  from Psych..TXP_Master d
       join Cstm_Conv_Map_Document_TxPlans dm on dm.plan_id = d.plan_id
       join Cstm_Conv_Map_Clients cm on cm.patient_id = d.patient_id
       left join Cstm_Conv_Map_Staff stm on stm.staff_id = d.txp_coordinator_id
 where not exists(select *
                    from Documents d2
                   where d2.DocumentId = dm.DocumentId)
                                       
if @@error <> 0 goto error

set identity_insert Documents off

if @@error <> 0 goto error
       
insert into DocumentVersions (
       DocumentId,
       Version, 
       CreatedBy, 
       CreatedDate, 
       ModifiedBy, 
       ModifiedDate)
select dm.DocumentId, 
       1,
       d.CreatedBy,
       d.CreatedDate,
       d.ModifiedBy,
       d.CreatedDate
  from Cstm_Conv_Map_Document_TxPlans dm
       join Documents d on d.DocumentId = dm.DocumentId
 where not exists(select *
                    from DocumentVersions dv
                   where dv.DocumentId = dm.DocumentId)
                          
if @@error <> 0 goto error

update d
   set CurrentDocumentVersionId = dv.DocumentVersionId,
       InprogressDocumentVersionid = dv.DocumentVersionId
  from Documents d
       join Cstm_Conv_Map_Document_TxPlans dm on dm.DocumentId = d.DocumentId
       join DocumentVersions dv on dv.DocumentId = d.DocumentId
       
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
select d.DocumentId, 
       d.CurrentDocumentVersionid,
       d.AuthorId, 
       d.ClientId, 
       ''N'', 
       isnull(s.FirstName,''Unknown'') + '' '' +isnull(s.LastName,''Unknown'') +isnull(s.SigningSuffix,''''), 
       1, 
       isnull(m.entry_chron, m.orig_entry_chron), 
       NULL, 
       NULL, 
       NULL, 
       NULL,
       d.ModifiedBy, 
       d.ModifiedDate, 
       d.ModifiedBy, 
       d.ModifiedDate
  from Cstm_Conv_Map_Document_TxPlans dm
       join Documents d on d.DocumentId = dm.DocumentId
       join Psych..TXP_Master m on m.plan_id = dm.plan_id
       join Staff s on s.StaffId = d.AuthorId
       
if @@error <> 0 goto error

return 

error:

raiserror 50060 ''csp_conv_Document_TxPlans Failed''

' 
END
GO
