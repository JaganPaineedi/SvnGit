/****** Object:  StoredProcedure [dbo].[csp_HarborTreatmentPlanMissingAlerts]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborTreatmentPlanMissingAlerts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HarborTreatmentPlanMissingAlerts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborTreatmentPlanMissingAlerts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_HarborTreatmentPlanMissingAlerts] as
-- Change log:
--		2012.08.02 - T. Remisoski - Created.

declare @tabMissingPlans table (
	ClientId int,
	ClientEpisodeId int,
	PrimaryClinicianId int
)

declare @tabMissingMedsOnlyPlans table (
	ClientId int,
	PrimaryClinicianId int
)

declare @tabMedsPlansCreated table (
	ClientId int,
	DocumentId int
)

insert into @tabMissingPlans (ClientId, ClientEpisodeId, PrimaryClinicianId)
select c.ClientId, ce.ClientEpisodeId, c.PrimaryClinicianId
from dbo.Clients as c
join (
	select ce.ClientId, ce.ClientEpisodeId, ce.RegistrationDate
	from dbo.ClientEpisodes as ce
	where ce.Status = 101
	and not exists (
		select *
		from dbo.ClientEpisodes as ce2
		where ce2.ClientId = ce.ClientId
		and ce2.EpisodeNumber > ce.EpisodeNumber
		and ISNULL(ce2.RecordDeleted, ''N'') <> ''Y''
	)
	and ISNULL(ce.RecordDeleted, ''N'') <> ''Y''
) as ce on ce.ClientId = c.ClientId
where c.Active = ''Y''
and c.PrimaryClinicianId is not null
-- has had at least one mental health service that was not an assessment
and exists (
	select *
	from dbo.Services as s
	join dbo.Programs as pg on pg.ProgramId = s.ProgramId
	where s.ClientId = c.ClientId
	and s.Status in (71,75)		-- show, complete
	and pg.ServiceAreaId = 3	-- Mental Health
	and s.ProcedureCodeId not in (
		24,								-- assessment, 
		484, 653,						-- psych eval, 
		482, 485,						-- psych testing, 
		90	 							-- or DP Consult
	)
	and DATEDIFF(DAY, DateOfService, ce.RegistrationDate) <= 0
	and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
)
and not exists (
	select *
	from dbo.Documents as d
	where d.ClientId = c.ClientId
	and d.DocumentCodeId in (2, 1483, 1484, 1485)
	--and d.Status = 22
	and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
)
and ISNULL(c.RecordDeleted, ''N'') <> ''Y''
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
	and al.Subject like ''Treatment Plan Missing%''
	and al.ToStaffId = c.PrimaryClinicianId
	and DATEDIFF(DAY, al.DateReceived, GETDATE()) < 14
	and ISNULL(al.RecordDeleted, ''N'') <> ''Y''
)

insert into @tabMissingMedsOnlyPlans (ClientId, PrimaryClinicianId)
select c.ClientId, c.PrimaryClinicianid
from @tabMissingPlans as c
join dbo.Staff as st on st.StaffId = c.PrimaryClinicianId
join dbo.ClientEpisodes as ce on ce.ClientEpisodeId = c.ClientEpisodeId
where st.Degree in (
20948,
20918,
20919,
20952
)



--select * from @tabMissingMedsOnlyPlans order by ClientId
--select COUNT(*) from @tabMissingPlans

delete from a
from @tabMissingPlans as a
where exists (
	select *
	from @tabMissingMedsOnlyPlans as b
	where b.ClientId = a.ClientId
)

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
c.PrimaryClinicianId,
c.ClientId,
81,
''Y'',
GETDATE(),
''Treatment Plan Missing - '' + ISNULL(cl.LastName, '''') + '', '' + ISNULL(cl.FirstName, '''') + '' ('' + cast(c.ClientId as varchar) + '')'',
''A treatment plan could not be found for '' + ISNULL(SUBSTRING(cl.LastName, 1, 1), '''') + ''., '' + ISNULL(SUBSTRING(cl.FirstName, 1, 1), '''') + '' ('' + cast(c.ClientId as varchar) + '').  The''
+ '' client is active and has had at least one non-assessment service in the mental health service area after the most recent episode registration date.''
from @tabMissingPlans as c
join dbo.Clients as cl on cl.ClientId = c.ClientId

declare @medPlanClientId int, @medPlanAuthorId int, @effDate datetime

set @effDate = dbo.RemoveTimeStamp(GETDATE())

declare cMedPlans cursor for
select 
	ClientId,
	PrimaryClinicianId
from @tabMissingMedsOnlyPlans

open cMedPlans

fetch cMedPlans into @medPlanClientId, @medPlanAuthorId

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
		@AnnualReview = ''N''

	fetch cMedPlans into @medPlanClientId, @medPlanAuthorId

end

close cMedPlans

deallocate cMedPlans

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
select a.PrimaryClinicianId,
	a.ClientId,
	81,
	''Y'',
	GETDATE(),
	''Treatment Plan Missing - '' + ISNULL(cl.LastName, '''') + '', '' + ISNULL(cl.FirstName, '''') + '' ('' + cast(cl.ClientId as varchar) + '')'',
	''A treatment plan could not be found for '' + ISNULL(SUBSTRING(cl.LastName, 1, 1), '''') + ''., '' + ISNULL(SUBSTRING(cl.FirstName, 1, 1), '''') + '' ('' + cast(cl.ClientId as varchar) + '').''
	+ ''  You are designated as the primary clinician.  A plan has been created as in-progress with you as the author.  Please open, review and sign the document to make the treatment plan effective.''
	+ ''  This document is also available in your "in-progress" documents list.'',
	null,
	b.DocumentId,
	b.DocumentId,
	b.DocumentId,
	null
from @tabMissingMedsOnlyPlans as a
join @tabMedsPlansCreated as b on b.ClientId = a.ClientId
join dbo.Clients as cl on cl.ClientId = a.ClientId


' 
END
GO
