/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportTpSignatures]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTpSignatures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportTpSignatures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTpSignatures]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLSubReportTpSignatures]    
(                                    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                     
)                                    
As   
   
/* 
select top 100 * from documentSignatures where SignerName is not null order by signatureId desc
select db_name()
*/    
    

select	d.DocumentId, 
		ds.SignatureId,
		dv.Version,
		ds.SignerName,
		ds.PhysicalSignature,
		ds.SignatureDate
from Documents as d
join documentVersions as dv on dv.DocumentId = d.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
join documentSignatures as ds on ds.DocumentId = d.DocumentId and isnull(ds.RecordDeleted,''N'')<>''Y''
--join documentSignatures as ds on ds.SignedDocumentVersionId = dv.DocumentVersionId and isnull(ds.RecordDeleted,''N'')<>''Y''  
--NOT CORRECT
--where d.DocumentId = @DocumentId 
--and dv.Version = @Version
where dv.DocumentVersionId = @DocumentVersionId --NOT CORRECT--d.CurrentDocumentVersionId =  @DocumentVersionId  --Modified by Anuj Dated 03-May-2010      
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.Status=22
Order by ds.SignatureOrder
' 
END
GO
