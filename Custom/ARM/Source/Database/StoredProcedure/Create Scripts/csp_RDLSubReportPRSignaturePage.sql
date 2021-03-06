/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportPRSignaturePage]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportPRSignaturePage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportPRSignaturePage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportPRSignaturePage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLSubReportPRSignaturePage]    
(                                    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                    
)                                    


As

declare @DocumentId int

--Select @DocumentId as DocumentId, @Version as Version, ds.SignatureId from documentsignatures ds
--where ds.DocumentId = @DocumentId
Select dv.DocumentVersionId as DocumentVersonId, ds.SignatureId 
from Documents d 
join DocumentVersions dv on dv.DocumentId = d.DocumentId and ISNULL(dv.RecordDeleted,''N'') <> ''Y''
join documentsignatures ds  on ds.DocumentId = d.DocumentId and ISNULL(ds.RecordDeleted,''N'') <> ''Y''
where dv.DocumentVersionId = @DocumentVersionId  --WRONG ---Modified by Anuj Dated 03-May-2010
and ds.SignatureOrder = 1
and ISNULL(d.RecordDeleted,''N'') <> ''Y''
--and ds.version = @Version
' 
END
GO
