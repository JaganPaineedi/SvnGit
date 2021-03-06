/****** Object:  StoredProcedure [dbo].[csp_SubReportTpSignaturePage]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportTpSignaturePage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SubReportTpSignaturePage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SubReportTpSignaturePage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SubReportTpSignaturePage]    
(                                    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                                    
)
/*
Created Date: 3/18/2008
Created By: avoss

Purpose: Dataset used for Treatment Plan Signature Page RDL
*/
                                    
As             

select d.DocumentId, dv.Version
from Documents as d
--join documentVersions as dv on dv.DocumentId = d.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
join documentVersions as dv on dv.DocumentVersionId = d.CurrentDocumentVersionId and isnull(dv.RecordDeleted,''N'')<>''Y''  --Modified by Anuj Dated 03-May-2010
--where d.DocumentId = @DocumentId 
--and dv.Version = @Version
where d.CurrentDocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
and isnull(d.RecordDeleted,''N'')<>''Y''
' 
END
GO
