/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportSignatureImages]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSignatureImages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportSignatureImages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportSignatureImages]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLSubReportSignatureImages]    
(                                    
@DocumentVersionId int                                 
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
where dv.DocumentVersionId = @DocumentVersionId
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.Status=22
Order by ds.SignatureOrder
' 
END
GO
