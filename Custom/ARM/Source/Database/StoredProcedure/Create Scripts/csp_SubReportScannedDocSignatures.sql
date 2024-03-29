/****** Object:  StoredProcedure [dbo].[csp_SubReportScannedDocSignatures]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportScannedDocSignatures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportScannedDocSignatures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportScannedDocSignatures]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create PROCEDURE  [dbo].[csp_SubReportScannedDocSignatures]
-- used to display signatures at the bottom of the psych testing review and other uploaded/signed documents
(                                    
@DocumentId int
)                                    
As   
   
    

select	d.DocumentId, 
		ds.SignatureId,
		dv.Version,
		ds.SignerName,
		ds.PhysicalSignature,
		ds.SignatureDate
from Documents as d
join documentSignatures as ds on ds.DocumentId = d.DocumentId
join (
	select top 1 [Version], DocumentId
	from dbo.DocumentVersions as v
	where v.DocumentId = @DocumentId
	and ISNULL(v.RecordDeleted, ''N'') <> ''Y''
	order by [Version] desc
) as dv on dv.DocumentId = d.DocumentId
where d.DocumentId = @DocumentId 
and ds.SignatureDate is not null
Order by ds.SignatureOrder
' 
END
GO
