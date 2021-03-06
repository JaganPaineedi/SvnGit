/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportTpAmendedDates]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTpAmendedDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportTpAmendedDates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportTpAmendedDates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLSubReportTpAmendedDates]    
(                                    
@DocumentVersionId int
--@DocumentId as int,                                    
--@Version as int                                    
)                                    
As   
   
/* 
--sp_who2
select top 100 * from documentSignatures where SignerName is not null order by signatureId desc
*/       
declare @Version int, @DocumentId int
select @Version = dv.Version, @DocumentId = dv.DocumentId  
from DocumentVersions dv where dv.DocumentVersionId=@DocumentVersionId


Select    
	d.DocumentId,  
	dv.Version, 
	case  when @Version > 1 then dv.CreatedDate
		else NULL
	End as AmmendedDate,
	case when @Version > 1 then dv.CreatedBy 
		else ''''
	end as AmmendedBy
from Documents as d
join DocumentVersions as dv on dv.DocumentId = d.DocumentId and isnull(dv.RecordDeleted,''N'')<>''Y''
	and dv.Version <= @Version and dv.Version <> 1
where d.DocumentId = @DocumentId 
and isnull(d.RecordDeleted,''N'')<>''Y''
and d.Status=22
Order by dv.Version
' 
END
GO
