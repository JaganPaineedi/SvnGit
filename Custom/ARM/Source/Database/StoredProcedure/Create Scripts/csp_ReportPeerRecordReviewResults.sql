/****** Object:  StoredProcedure [dbo].[csp_ReportPeerRecordReviewResults]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPeerRecordReviewResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPeerRecordReviewResults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPeerRecordReviewResults]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportPeerRecordReviewResults]
	@TemplateId int,
	@FromAssignedDate datetime,
	@ToAssignedDate datetime
as

select  t.RecordReviewTemplateName,
		rs.LastName + '', '' + rs.FirstName as ReviewingStaff,
        cr.LastName + '', '' + cr.FirstName as ClinicianReviewed,
        r.RecordReviewId,
        --r.ReviewingStaff,
        --r.ClinicianReviewed,
        r.ClientId,
        c.LastName + '', '' + c.FirstName as ClientName,
        gcStatus.CodeName as [Status],
        r.AssignedDate,
        r.CompletedDate,
        r.ReviewComments,
        r.Results,
        r.RequestQIReview,
        ti.Section,
        ti.Prompt,
        ri.Answer as ReviewerAnswer
from    dbo.CustomRecordReviews as r
join    dbo.CustomRecordReviewItems as ri on ri.RecordReviewId = r.RecordReviewId
join    dbo.CustomRecordReviewTemplateItems as ti on ti.RecordReviewTemplateItemId = ri.RecordReviewTemplateItemId
join    dbo.CustomRecordReviewTemplates as t on t.RecordReviewTemplateId = r.RecordReviewTemplateId
left join dbo.Staff as rs on rs.StaffId = r.ReviewingStaff
left join dbo.Staff as cr on cr.StaffId = r.ClinicianReviewed
LEFT join dbo.Clients as c on c.ClientId = r.ClientId
LEFT join dbo.GlobalCodes as gcStatus on gcStatus.GlobalCodeId = r.Status
where   t.RecordReviewTemplateId = @TemplateId
        and ISNULL(r.RecordDeleted, ''N'') <> ''Y''
        and ISNULL(ri.RecordDeleted, ''N'') <> ''Y''
        and ISNULL(ti.RecordDeleted, ''N'') <> ''Y''
        and ISNULL(t.RecordDeleted, ''N'') <> ''Y''
        and not exists (
			select *
			from dbo.CustomRecordReviewItems as ri2
			join dbo.CustomRecordReviewTemplateItems as ti2 on ti2.RecordReviewTemplateItemId = ri2.RecordReviewTemplateItemId
			where ri2.RecordReviewId = ri.RecordReviewId
			and ri2.RecordReviewTemplateItemId = ri.RecordReviewTemplateItemId
			and ri2.RecordReviewItemId > ri.RecordReviewItemId
		)
		and DATEDIFF(DAY, r.AssignedDate, @FromAssignedDate) <= 0
		and DATEDIFF(DAY, r.AssignedDate, @ToAssignedDate) >= 0
order by r.RecordReviewId,
        ti.ItemNumber,
        ri.RecordReviewItemId
' 
END
GO
