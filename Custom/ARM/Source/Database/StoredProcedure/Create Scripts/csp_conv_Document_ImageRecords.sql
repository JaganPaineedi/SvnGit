/****** Object:  StoredProcedure [dbo].[csp_conv_Document_ImageRecords]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_ImageRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_ImageRecords]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_ImageRecords]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_conv_Document_ImageRecords]
as

declare @reseed int

select @reseed = max(DocumentId) + 1000 from Documents

DBCC CHECKIDENT (Cstm_Conv_Map_Document_ImageRecords, reseed, @reseed) WITH NO_INFOMSGS

if @@error <> 0 goto error

insert into Cstm_Conv_Map_Document_ImageRecords (OldDocumentId)
select d.DocumentId 
  from HarborStreamline..ImageRecords i
       join HarborStreamline..DocumentVersions dv on dv.DocumentVersionid = i.DocumentVersionId
       join HarborStreamline..Documents d on d.DocumentId = dv.DocumentId
       
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
       d.ClientId, 
       null, --sm.ServiceId, 
       dc.NewDocumentCodeId, --DocumentCodeId
       d.EffectiveDate,
       NULL,        22,
       39, --AuthorId
       null, --CurrentDocumentVersionId
       ''Y'',
       ''Y'',
       ''Y'',
       d.CreatedBy, 
       d.CreatedDate, 
       d.ModifiedBy,        d.ModifiedDate,
       d.RecordDeleted, 
       d.DeletedDate, 
       d.DeletedBy
  from HarborStreamline..ImageRecords i
       join HarborStreamline..DocumentVersions dv on dv.DocumentVersionid = i.DocumentVersionId
       join HarborStreamline..Documents d on d.DocumentId = dv.DocumentId
       join Cstm_Conv_Map_Document_ImageRecords dm on dm.OldDocumentId = d.DocumentId
       join CustomScannedDocumentsMap dc on dc.OldDocumentCodeId = d.DocumentCodeId
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
       ModifiedDate,
       RecordDeleted, 
       DeletedDate, 
       DeletedBy)
select dm.DocumentId, 
       1,
       d.CreatedBy,
       d.CreatedDate,
       d.ModifiedBy,
       d.CreatedDate,
       d.RecordDeleted, 
       d.DeletedDate, 
       d.DeletedBy
  from Cstm_Conv_Map_Document_ImageRecords dm
       join Documents d on d.DocumentId = dm.DocumentId
 where not exists(select *
                    from DocumentVersions dv
                   where dv.DocumentId = dm.DocumentId)
                          
if @@error <> 0 goto error

update d
   set CurrentDocumentVersionId = dv.DocumentVersionId,
       InprogressDocumentVersionid = dv.DocumentVersionId
  from Documents d
       join Cstm_Conv_Map_Document_ImageRecords dm on dm.DocumentId = d.DocumentId
       join DocumentVersions dv on dv.DocumentId = d.DocumentId
       
if @@error <> 0 goto error

set identity_insert ImageRecords on

insert into ImageRecords (
       ImageRecordId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,RecordDeleted
      ,DeletedDate
      ,DeletedBy
      ,ScannedOrUploaded
      ,DocumentVersionId
      ,ImageServerId
      ,ClientId
      ,AssociatedId
      ,AssociatedWith
      ,RecordDescription
      ,EffectiveDate
      ,NumberOfItems
      ,AssociatedWithDocumentId
      ,AppealId
      ,StaffId
      ,EventId
      ,ProviderId
      ,TaskId
      ,AuthorizationDocumentId
      ,ScannedBy
      ,CoveragePlanId
      ,ClientDisclosureId)
select i.ImageRecordId
      ,i.CreatedBy
      ,i.CreatedDate
      ,i.ModifiedBy
      ,i.ModifiedDate
      ,i.RecordDeleted
      ,i.DeletedDate
      ,i.DeletedBy
      ,i.ScannedOrUploaded
      ,nd.CurrentDocumentVersionId
      ,i.ImageServerId
      ,i.ClientId
      ,i.AssociatedId
      ,i.AssociatedWith
      ,i.RecordDescription
      ,i.EffectiveDate
      ,i.NumberOfItems
      ,i.AssociatedWithDocumentId
      ,i.AppealId
      ,i.StaffId
      ,i.EventId
      ,i.ProviderId
      ,i.TaskId
      ,null --AuthorizationDocumentId
      ,39 --ScannedBy
      ,null --CoveragePlanId
      ,null --ClientDisclosureId
  from HarborStreamline..ImageRecords i
       join HarborStreamline..DocumentVersions dv on dv.DocumentVersionid = i.DocumentVersionId
       join HarborStreamline..Documents d on d.DocumentId = dv.DocumentId
       join Cstm_Conv_Map_Document_ImageRecords dm on dm.OldDocumentId = d.DocumentId
       join Documents nd on nd.DocumentId = dm.DocumentId
       
if @@error <> 0 goto error

insert into ImageRecords (
       ImageRecordId
      ,CreatedBy
      ,CreatedDate
      ,ModifiedBy
      ,ModifiedDate
      ,RecordDeleted
      ,DeletedDate
      ,DeletedBy
      ,ScannedOrUploaded
      ,DocumentVersionId
      ,ImageServerId
      ,ClientId
      ,AssociatedId
      ,AssociatedWith
      ,RecordDescription
      ,EffectiveDate
      ,NumberOfItems
      ,AssociatedWithDocumentId
      ,AppealId
      ,StaffId
      ,EventId
      ,ProviderId
      ,TaskId
      ,AuthorizationDocumentId
      ,ScannedBy
      ,CoveragePlanId
      ,ClientDisclosureId)
select i.ImageRecordId
      ,i.CreatedBy
      ,i.CreatedDate
      ,i.ModifiedBy
      ,i.ModifiedDate
      ,i.RecordDeleted
      ,i.DeletedDate
      ,i.DeletedBy
      ,i.ScannedOrUploaded
      ,null --DocumentVersionId
      ,i.ImageServerId
      ,i.ClientId
      ,i.AssociatedId
      ,i.AssociatedWith
      ,i.RecordDescription
      ,i.EffectiveDate
      ,i.NumberOfItems
      ,i.AssociatedWithDocumentId
      ,i.AppealId
      ,i.StaffId
      ,i.EventId
      ,i.ProviderId
      ,i.TaskId
      ,null --AuthorizationDocumentId
      ,39 --ScannedBy
      ,null --CoveragePlanId
      ,null --ClientDisclosureId
  from HarborStreamline..ImageRecords i
 where i.DocumentVersionId is null 
   and not exists(select *
                    from ImageRecords i2
                   where i2.ImageRecordId = i.ImageRecordId)
                      
if @@error <> 0 goto error

set identity_insert ImageRecords off


return 

error:

raiserror 50060 ''csp_conv_Document_TxPlans Failed''

' 
END
GO
