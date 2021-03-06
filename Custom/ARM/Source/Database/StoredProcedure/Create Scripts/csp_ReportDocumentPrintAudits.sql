/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentPrintAudits]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentPrintAudits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentPrintAudits]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentPrintAudits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReportDocumentPrintAudits]
(@StartDate datetime, @EndDate datetime, @StaffId int)
as
/*
modified by	modified date	reason
avoss		7/1/2009		created

declare @StartDate datetime, @EndDate datetime, @StaffId int
select @StartDate = dbo.RemoveTimestamp(getdate()) ,@EndDate=null ,@StaffId= null
*/

select 
	s.lastname +'', ''+ s.Firstname as printedBy, 
	dc.DocumentName,
	d.EffectiveDate,
	d.ClientId, 
	c.lastname +'', ''+ c.Firstname as ClientName,
	d.DocumentId, 
	dv.Version,
	a.CreatedBy,
	a.CreatedDate
	--,a.* 
from documentPrintAudits a
join staff s on s.staffid=a.printedby
left join DocumentVersions dv on dv.DocumentVersionId = a.DocumentVersionId
left join documents d on d.DOcumentId=dv.DocumentId
left join documentCodes dc on dc.DocumentCodeId = d.DocumentCodeId
left join clients c on c.ClientId=d.ClientId
where a.createddate >= @StartDate
and (a.CreatedDate < @EndDate or @EndDate is null)
and (a.PrintedBy=@StaffId or @StaffId is null)
' 
END
GO
