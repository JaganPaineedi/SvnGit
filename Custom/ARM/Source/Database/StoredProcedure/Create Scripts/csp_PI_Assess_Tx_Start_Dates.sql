/****** Object:  StoredProcedure [dbo].[csp_PI_Assess_Tx_Start_Dates]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PI_Assess_Tx_Start_Dates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PI_Assess_Tx_Start_Dates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PI_Assess_Tx_Start_Dates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_PI_Assess_Tx_Start_Dates]
	@assess_category varchar(128),	-- maps to GlobalCodes.Category
	@assess_codename varchar(128),	-- maps to GlobalCodes.CodeName
	@crisis_category varchar(128),	-- maps to GlobalCodes.Category
	@crisis_codename varchar(128),	-- maps to GlobalCodes.CodeName
	@assessed_on_or_after datetime = ''10/1/2005''
AS

declare @ClientAssessments table
(
	ClientId int,
	EpisodeNumber int,
	AssessmentDate datetime,
	TxStartDate datetime
)


--
-- Find the most recent assessment that occurred where the client has not been seen
-- in 90 days (excluding crisis)
--
insert into @ClientAssessments (clientid, episodenumber, assessmentdate)
select
	sv.ClientId, ce.episodenumber, max(sv.dateofservice)
from Services as sv
join clientepisodes as ce on (ce.clientid = sv.clientid)
join procedurecodes as pc on (pc.procedurecodeid = sv.procedurecodeid)
cross join globalcodes as gc
where
	gc.category = @assess_category
	and
	gc.codename = @assess_codename
	and
	-- is an assessment type
	gc.globalcodeid IN (pc.Category1, pc.Category2, pc.Category3)
	and
	isnull(pc.notbillable, ''N'') <> ''Y''
	and
	isnull(sv.recorddeleted, ''N'') <> ''Y''
	and
	sv.status IN (71, 75)
	and
	datediff(day, isnull(ce.initialrequestdate, ce.registrationdate), sv.dateofservice) >= 0
	and
	isNull(ce.recorddeleted, ''N'') <> ''Y''
	and -- a face to face service did not happen within 90 days of the assessment
	not exists
	(
		select *
		from services as sv2
		join procedurecodes as pc2 on (pc2.procedurecodeid = sv2.procedurecodeid)
		where
			sv2.clientid = sv.clientid
			and
			isNull(sv2.recorddeleted, ''N'') <> ''Y''
			and
			sv2.status IN (71, 75)
			and
			datediff(day, sv2.dateofservice, sv.dateofservice) < 90
			and
			datediff(day, sv2.dateofservice, sv.dateofservice) > 0
			and
			pc2.facetoface = ''Y''
			and
			isnull(pc2.notbillable, ''N'') <> ''Y''
			-- was not a crisis service
			and not exists
			(
				select *
				from globalcodes as gc2
				where
					gc2.category = @crisis_category
					and
					gc2.codename = @crisis_codename
					and
					gc2.globalcodeid IN (pc2.Category1, pc2.Category2, pc2.Category3)
			)
	)
	and -- this is the most recent episode for that assessment
	not exists
	(
		select *
		from clientepisodes as ce2
		where
			isnull(ce2.recorddeleted, ''N'') <> ''Y''
			and
			ce2.clientid = ce.clientid
			and
			isnull(ce2.initialrequestdate, ce2.registrationdate) > isnull(ce.initialrequestdate, ce.registrationdate)
			and
			datediff(day, isnull(ce2.initialrequestdate, ce2.registrationdate), sv.dateofservice) >= 0
	)
group by sv.ClientId, ce.episodenumber, ce.registrationdate, ce.initialrequestdate
-- we''re not interested in changing records for assessments prior to this date
having max(sv.dateofservice) >= @assessed_on_or_after

-- select count(*) from @clientassessments
-- select * from @clientassessments

/*
-- this lists discrepancies with what was imported from psych.
select ce.clientid, ce.episodenumber, ce.registrationdate, ce.initialrequestdate,ce.assessmentdate, c.assessmentdate
from clientepisodes as ce
join @ClientAssessments as c on c.clientid = ce.clientid and c.episodenumber = ce.episodenumber
where
	isnull(ce.recorddeleted, ''N'') <> ''Y''
	and
	datediff(day, ce.assessmentdate, c.assessmentdate) <> 0
*/

-- calculate the start of treatemnt.  First non-crisis/non-assessment encounter on or after same day as intake assessment.
update a set
	TxStartDate = summ.min_dateofservice
from @clientassessments as a
join
(
	select ca.clientid, min(dateofservice) as min_dateofservice
	from @clientassessments as ca
	join services as sv on (sv.clientid = ca.clientid)
	join procedurecodes as pc on (pc.procedurecodeid = sv.procedurecodeid)
	where
		isnull(sv.recorddeleted, ''N'') <> ''Y''
		and
		sv.status in (71, 75)
		and
		pc.facetoface = ''Y''
		and
		isnull(pc.notbillable, ''N'') <> ''Y''
		and
		datediff(day, sv.dateofservice, ca.assessmentdate) <= 0
		and not exists
		-- not an intake assessment
		(
			select *
			from globalcodes as gc
			where
				gc.category = @assess_category
				and
				gc.codename = @assess_codename
				and
				gc.globalcodeid in (pc.category1, pc.category2, pc.category3)
		)
	group by ca.clientid
) as summ on (summ.clientid = a.clientid)

-- this lists discrepancies with what was imported from psych.
/*
select ce.clientid, ce.episodenumber, ce.registrationdate, ce.initialrequestdate,ce.txstartdate, c.txstartdate
from clientepisodes as ce
join @ClientAssessments as c on c.clientid = ce.clientid and c.episodenumber = ce.episodenumber
where
	isnull(ce.recorddeleted, ''N'') <> ''Y''
	and
	datediff(day, ce.txstartdate, c.txstartdate) <> 0
*/

-- update the clientepisodes table
update a set
	AssessmentDate = ca.AssessmentDate,
	TxStartDate = ca.TxStartDate
from clientepisodes as a
join @ClientAssessments as ca on (ca.clientid = a.clientid and ca.episodenumber = a.episodenumber)
where
	isnull(a.recorddeleted, ''N'') <> ''Y''
	and
	(
		datediff(day, ca.AssessmentDate, a.AssessmentDate) <> 0
		or
		datediff(day, ca.TxStartDate, a.TxStartDate) <> 0
	)
' 
END
GO
