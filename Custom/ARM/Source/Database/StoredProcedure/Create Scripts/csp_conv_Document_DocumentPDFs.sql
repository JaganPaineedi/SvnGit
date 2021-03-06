/****** Object:  StoredProcedure [dbo].[csp_conv_Document_DocumentPDFs]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_DocumentPDFs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_DocumentPDFs]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_DocumentPDFs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_conv_Document_DocumentPDFs]
as

alter table DocumentVersionViews..DocumentVersionViews drop constraint DocumentVersionViews_PK

if @@error <> 0 goto error

update dvv
   set DocumentVersionId = dvm.DocumentVersionId
  from DocumentVersionViews..DocumentVersionViews dvv
       join DocumentVersionViews..DocumentVersionViewFileMap dvm on dvm.FinalDocumentVersionId = dvv.DocumentVersionId

if @@error <> 0 goto error

update DocumentVersionViews..DocumentVersionViewFileMap set FinalDocumentVersionId = null

if @@error <> 0 goto error

delete dvv
  from DocumentVersionViews..DocumentVersionViews dvv
 where not exists(select * 
                    from DocumentVersionViews..DocumentVersionViewFileMap dvm 
                   where dvm.DocumentVersionId = dvv.DocumentVersionId)
         
if @@error <> 0 goto error

update dvm
   set FinalDocumentVersionId = dm.DocumentVersionId
  from DocumentVersionViews..DocumentVersionViewFileMap dvm
       join Cstm_Conv_Map_DocumentVersions dm on dm.Doc_Session_no = dvm.doc_session_no and dm.Version_No = dvm.version_no

if @@error <> 0 goto error

update dvv
   set DocumentVersionId = dvm.FinalDocumentVersionId,
       CreatedBy = dv.CreatedBy,
       CreatedDate = dv.CreatedDate,
       ModifiedBy = dv.ModifiedBy,
       ModifiedDate = dv.ModifiedDate
  from DocumentVersionViews..DocumentVersionViewFileMap dvm
       join DocumentVersionViews..DocumentVersionViews dvv on dvv.DocumentVersionId = dvm.DocumentVersionId
       join DocumentVersions dv on dv.DocumentVersionId = dvm.FinalDocumentVersionId

if @@error <> 0 goto error

alter table DocumentVersionViews..DocumentVersionViews add constraint DocumentVersionViews_PK primary key clustered (DocumentVersionId)

if @@error <> 0 goto error

return

error:

raiserror 50110 ''Failed to execute csp_conv_Document_DocumentPDFs''

' 
END
GO
