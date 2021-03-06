/****** Object:  StoredProcedure [dbo].[csp_HarborTreatmentPlanReviewDueAlerts]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborTreatmentPlanReviewDueAlerts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HarborTreatmentPlanReviewDueAlerts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborTreatmentPlanReviewDueAlerts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_HarborTreatmentPlanReviewDueAlerts]
	@daysUntilDue int = 30	-- number of days to warn on due date
-- Change log:
--		2012.08.02 - T. Remisoski - Created.
--		2012.10.24 - W. Butt	  - Modified : Added alert for annual client rights review
as

declare @tabMissingReviews table (
	ClientId int,
	ClientEpisodeId int,
	PrimaryClinicianId int,
	EffectiveDate datetime,
	DueDate datetime
)

declare @tabMissingMedsOnlyReviews table (
	ClientId int,
	PrimaryClinicianId int,
	EffectiveDate datetime,
	DueDate datetime
)

declare @tabMedsPlansCreated table (
	ClientId int,
	DocumentId int
)


insert into @tabMissingReviews (
	ClientId,
	ClientEpisodeId,
	PrimaryClinicianId,
	EffectiveDate,
	DueDate
)
select dDue.ClientId, null, ISNULL(c.PrimaryClinicianId, dDue.AuthorId), ddue.EffectiveDate, dDue.DueDate
from (
	select d.ClientId, d.EffectiveDate, DATEADD(YEAR, 1, d.EffectiveDate) as DueDate, d.AuthorId
	from dbo.Documents as d
	where d.DocumentCodeId in (2, 1483)
	and d.Status = 22
	and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
	-- and there is no annual review document
	and not exists (
		select *
		from dbo.Documents as d2
		where d2.ClientId = d.ClientId
		and d2.DocumentCodeId in (1485)
		and d2.Status = 22
		and DATEDIFF(DAY, d2.EffectiveDate, d.EffectiveDate) <= 0
		and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
	)
	and not exists (
		select *
		from dbo.Documents as d3
		where d3.ClientId = d.ClientId
		and d3.DocumentCodeId in (2, 1483)
		and d3.EffectiveDate > d.EffectiveDate
		and d3.Status = 22
		and ISNULL(d3.RecordDeleted, ''N'') <> ''Y''
	)union
	-- if there is an annual update, find the most recent one and then determine the next due date based on it''s relationship to the update
	select d.ClientId, d.EffectiveDate, 
	case when cast(
		cast(DATEPART(MONTH, d.EffectiveDate) as varchar)
		+ ''/''
		+ cast(DATEPART(DAY, d.EffectiveDate) as varchar) 
		+ ''/''
		+ cast(DATEPART(YEAR, d2.EffectiveDate) as varchar)
		as datetime) < d2.EffectiveDate then
		DATEADD(YEAR, 1, cast(
		cast(DATEPART(MONTH, d.EffectiveDate) as varchar)
		+ ''/''
		+ cast(DATEPART(DAY, d.EffectiveDate) as varchar) 
		+ ''/''
		+ cast(DATEPART(YEAR, d2.EffectiveDate) as varchar)
		as datetime)) else cast(
		cast(DATEPART(MONTH, d.EffectiveDate) as varchar)
		+ ''/''
		+ cast(DATEPART(DAY, d.EffectiveDate) as varchar) 
		+ ''/''
		+ cast(DATEPART(YEAR, d2.EffectiveDate) as varchar)
		as datetime) end as DueDate, d.AuthorId
	from dbo.Documents as d
	join dbo.Documents as d2 on d2.ClientId = d.ClientId
	where d.DocumentCodeId in (2, 1483)
	and d2.DocumentCodeId = 1485
	and d.Status = 22
	and d2.Status = 22
	and DATEDIFF(DAY, d2.EffectiveDate, d.EffectiveDate) <= 0
	and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
	and not exists (
		select *
		from dbo.Documents as d3
		where d3.ClientId = d2.ClientId
		and d3.DocumentCodeId = d2.DocumentCodeId
		and d3.EffectiveDate > d2.EffectiveDate
		and d3.Status = 22
		and ISNULL(d3.RecordDeleted, ''N'') <> ''Y''
	)
) as dDue
join dbo.Clients as c on c.ClientId = dDue.ClientId
join dbo.Staff as st on st.StaffId = ISNULL(c.PrimaryClinicianId, dDue.AuthorId)
where c.Active = ''Y''
and DATEDIFF(DAY, dDue.DueDate, GETDATE()) >= -(@daysUntilDue)
and not exists (
	select *
	from dbo.Documents as d
	where d.ClientId = c.ClientId
	and d.DocumentCodeId = 1485
	and d.Status = 22
	and d.EffectiveDate between dDue.EffectiveDate and dDue.DueDate
	and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
)
--
-- and has received a "mental health service"
and exists (
	select *
	from dbo.Services as s
	join dbo.Programs as pg on pg.ProgramId = s.ProgramId
	where s.ClientId = c.ClientId
	and pg.ServiceAreaId = 3
	and s.Status in (71,75)
	and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
)
-- currently enrolled in a mental health program
and exists (
	select *
	from dbo.ClientPrograms as cp
	join dbo.Programs as pg on pg.ProgramId = cp.ProgramId
	where cp.ClientId = c.ClientId
	and cp.Status = 4	-- enrolled
	and pg.ServiceAreaId = 3
	and ISNULL(cp.RecordDeleted, ''N'') <> ''Y''
	and ISNULL(pg.RecordDeleted, ''N'') <> ''Y''
)
-- Episode is active
and exists (
	select *
	from dbo.ClientEpisodes as ce
	where ce.ClientId = c.ClientId
	and ce.Status = 101
	and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''
)
-- do not send if an existing alert already exists
and not exists (
	select *
	from dbo.Alerts as al
	where al.ClientId = c.ClientId
	and al.Subject like ''Annual Treatment Plan Review Due%''
	and al.ToStaffId = ISNULL(c.PrimaryClinicianId, dDue.AuthorId)
	and DATEDIFF(DAY, al.DateReceived, GETDATE()) < 14
	and ISNULL(al.RecordDeleted, ''N'') <> ''Y''
)
--order by 1

insert into @tabMissingMedsOnlyReviews (ClientId, PrimaryClinicianId, EffectiveDate, DueDate)
select c.ClientId, c.PrimaryClinicianid, EffectiveDate, DueDate
from @tabMissingReviews as c
join dbo.Staff as st on st.StaffId = c.PrimaryClinicianId
where st.Degree in (
20948,
20918,
20919,
20952
)

delete from a
from @tabMissingReviews as a
where exists (
	select *
	from @tabMissingMedsOnlyReviews as b
	where b.ClientId = a.ClientId
)

--Alert for annual treatment plan review
insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message
        )
select --c.ClientId, dDue.EffectiveDate, dDue.DueDate, ISNULL(c.PrimaryClinicianId, dDue.AuthorId) as PrimaryClinician
t.PrimaryClinicianId,
t.ClientId,
81,
''Y'',
GETDATE(),
''Annual Treatment Plan Review Due - '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'',
''The annual treatment plan review for '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'' + '' is due within '' 
--''The annual treatment plan review for '' + ISNULL(SUBSTRING(c.LastName, 1, 1), '''') + '', '' + ISNULL(SUBSTRING(c.FirstName, 1, 1), '''') + ''. ('' + cast(c.ClientId as varchar) + '')'' + '' is due within '' 
+ CAST(@daysUntilDue as varchar) + '' days or overdue.'' 
+ CHAR(13) + CHAR(10)
+ ''Original plan date: '' + CONVERT(varchar, t.EffectiveDate, 101)
+ CHAR(13) + CHAR(10)
+ ''Review due date: '' + CONVERT(varchar, t.DueDate, 101)
+ case when c.PrimaryClinicianId is null then
	CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
	+ ''* This client has no primary clinician assignment.  You were the author of the original treatment plan so you were selected for this alert.''
  else '''' end
from @tabMissingReviews as t
join dbo.Clients as c on c.ClientId = t.ClientId

--Alert for annual client rights review
insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message
        )
select --c.ClientId, dDue.EffectiveDate, dDue.DueDate, ISNULL(c.PrimaryClinicianId, dDue.AuthorId) as PrimaryClinician
t.PrimaryClinicianId,
t.ClientId,
81,
''Y'',
GETDATE(),
''Annual Client Rights Review Due - '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'',
''In conjunction with the annual treatment plan review, the annual client rights review is due for '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + ''). '' 
+ ''Please document client rights review by creating a Client Rights Review Document in the documents / general documents / client letters banner. ''
from @tabMissingReviews as t
join dbo.Clients as c on c.ClientId = t.ClientId

declare @medPlanClientId int, @medPlanAuthorId int, @effDate datetime

declare cMedPlans cursor for
select 
	ClientId,
	PrimaryClinicianId,
	DueDate
from @tabMissingMedsOnlyReviews

open cMedPlans

fetch cMedPlans into @medPlanClientId, @medPlanAuthorId, @effDate

while @@FETCH_STATUS = 0
begin
	--print ''client: '' + CAST(@medPlanClientId as varchar)
	insert into @tabMedsPlansCreated 
	        (ClientId, DocumentId)
	exec [csp_CreateMedsOnlyTreatmentPlan]
		@ClientId = @medPlanClientId,
		@AuthorId = @medPlanAuthorId,
		@EffectiveDate = @effDate,
		@DocumentStatus = 21,	-- default to in-progress
		@AnnualReview = ''Y''	-- default to in-progress

	fetch cMedPlans into @medPlanClientId, @medPlanAuthorId, @effDate

end

close cMedPlans

deallocate cMedPlans

--Alert for annual treatment plan rights review
insert into dbo.Alerts 
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message,
         FollowUp,
         Reference,
         ReferenceLink,
         DocumentId,
         TabId
        )
select --c.ClientId, dDue.EffectiveDate, dDue.DueDate, ISNULL(c.PrimaryClinicianId, dDue.AuthorId) as PrimaryClinician
a.PrimaryClinicianId,
a.ClientId,
81,
''Y'',
GETDATE(),
''Annual Treatment Plan Review Due - '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'',
''The annual treatment plan review for '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'' + '' is due within '' 
--''The annual treatment plan review for '' + ISNULL(SUBSTRING(c.LastName, 1, 1), '''') + '', '' + ISNULL(SUBSTRING(c.FirstName, 1, 1), '''') + ''. ('' + cast(c.ClientId as varchar) + '')'' + '' is due within '' 
+ CAST(@daysUntilDue as varchar) + '' days or overdue.'' 
+ CHAR(13) + CHAR(10)
+ ''Original plan date: '' + CONVERT(varchar, a.EffectiveDate, 101)
+ CHAR(13) + CHAR(10)
+ ''Review due date: '' + CONVERT(varchar, a.DueDate, 101)
+	CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
	+ ''  You are designated as the primary clinician.  A plan has been created as in-progress with you as the author.  Please open, review and sign the document to make the treatment plan effective.''
	+ ''  This document is also available in your "in-progress" documents list.'',
  null,
  b.DocumentId,
  b.DocumentId,
  b.DocumentId,
  null
from @tabMissingMedsOnlyReviews as a
join @tabMedsPlansCreated as b on b.ClientId = a.ClientId
join dbo.Clients as c on c.ClientId = a.ClientId

--Alert for annual client rights review
insert into dbo.Alerts
        (
         ToStaffId,
         ClientId,
         AlertType,
         Unread,
         DateReceived,
         Subject,
         Message
        )
select --c.ClientId, dDue.EffectiveDate, dDue.DueDate, ISNULL(c.PrimaryClinicianId, dDue.AuthorId) as PrimaryClinician
a.PrimaryClinicianId,
a.ClientId,
81,
''Y'',
GETDATE(),
''Annual Client Rights Review Due - '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'',
''In conjunction with the annual treatment plan review, the annual client rights review is due for '' + ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + ''). ''
+ ''Please document client rights review by creating a Client Rights Review Document in the documents / general documents / client letters banner. '' 
from @tabMissingMedsOnlyReviews as a
join @tabMedsPlansCreated as b on b.ClientId = a.ClientId
join dbo.Clients as c on c.ClientId = a.ClientId

' 
END
GO
