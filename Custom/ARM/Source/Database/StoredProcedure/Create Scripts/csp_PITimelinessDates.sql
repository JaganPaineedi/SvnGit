/****** Object:  StoredProcedure [dbo].[csp_PITimelinessDates]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PITimelinessDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PITimelinessDates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PITimelinessDates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_PITimelinessDates]
	@assess_category varchar(128),	-- maps to GlobalCodes.Category
	@assess_codename varchar(128),	-- maps to GlobalCodes.CodeName
	@crisis_category varchar(128),	-- maps to GlobalCodes.Category
	@crisis_codename varchar(128),	-- maps to GlobalCodes.CodeName
	@assessed_on_or_after datetime = ''10/1/2006''
/********************************************************************************
-- Stored Procedure: dbo.csp_PITimelinessDates  
--
-- Copyright: 2006 Streamline Healthcate Solutions
--
-- Purpose: Calculates Initial Request, Assessment and Start of Treatment dates
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 02.07.2007  SFarber     Added logic to calculate the Initial Request date and 
--                         update custom timelines information.
-- 6-9-2008    SFerenz		Added logic to calculated manualdaysassessmenttotreatment
*********************************************************************************/
as

declare @ClientAssessments table
(
	ClientId int,
	EpisodeNumber int,
    InitialRequestDate datetime,
	AssessmentDate datetime,
	AssessmentServiceId	int,
	TxStartDate datetime,
	TxServiceId	int
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

-- calculate the initial request date.  Date when the assessment service was entered into the system.
update ca
   set InitialRequestDate = ird.CreatedDate,
	   AssessmentServiceId = ird.ServiceId
  from @ClientAssessments as ca
       join (select ca.ClientId,
                    ca.EpisodeNumber,
                    sv.CreatedDate as CreatedDate,
					sv.ServiceId as ServiceId
               from @ClientAssessments ca
                    join Services as sv on sv.ClientId = ca.ClientId
                    join ProcedureCodes as pc on pc.ProcedureCodeId = sv.ProcedureCodeId
                    cross join globalcodes as gc
              where gc.Category = @assess_category
	        and gc.codename = @assess_codename
	        and gc.GlobalCodeId in (pc.Category1, pc.Category2, pc.Category3)
	        and isnull(pc.NotBillable, ''N'') <> ''Y''
	        and isnull(sv.RecordDeleted, ''N'') <> ''Y''
	        and sv.Status in (71, 75)
	        and sv.DateofService = ca.AssessmentDate
			and not exists -- Get the maximum ServiceId if there is a tie
				(select * from services sv2
				join ProcedureCodes pc2 on pc2.ProcedureCodeId = sv2.ProcedureCodeId
				cross join globalCodes gc2
				where sv2.ClientId = ca.ClientId
				and gc2.Category = @assess_category
				and gc2.codename = @assess_codename
				and gc2.GlobalCodeId in (pc2.Category1, pc2.Category2, pc2.Category3)
				and isnull(pc2.NotBillable, ''N'') <> ''Y''
				and isnull(sv2.RecordDeleted, ''N'') <> ''Y''
				and sv2.Status in (71, 75)
				and sv2.DateofService = ca.AssessmentDate
				and sv2.ServiceId > sv.ServiceId)
              ) ird on ird.ClientId = ca.ClientId and ird.EpisodeNumber = ca.EpisodeNumber



-- calculate the start of treatment.  First non-crisis/non-assessment encounter on or after same day as intake assessment.
update a set
	TxStartDate = summ.dateofservice,
	TxServiceId = summ.ServiceId
from @clientassessments as a
join
(
	select ca.Clientid, ca.EpisodeNumber, sv.DateOfService, sv.ServiceId
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
				gc2.globalcodeid IN (pc.Category1, pc.Category2, pc.Category3)
		)
		and not exists -- Get the first applicable service after the assessment
		(
			select * from Services sv2
			join procedurecodes as pc2 on (pc2.procedurecodeid = sv2.procedurecodeid)
			where sv2.ClientId = sv.ClientId
			and
			isnull(sv2.recorddeleted, ''N'') <> ''Y''
			and
			sv2.status in (71, 75)
			and
			pc2.facetoface = ''Y''
			and
			isnull(pc2.notbillable, ''N'') <> ''Y''
			and
			datediff(day, sv2.dateofservice, ca.assessmentdate) <= 0
			and not exists
			-- not an intake assessment
			(
				select *
				from globalcodes as gc3
				where
					gc3.category = @assess_category
					and
					gc3.codename = @assess_codename
					and
					gc3.globalcodeid in (pc2.category1, pc2.category2, pc2.category3)
			)
			-- was not a crisis service
			and not exists
			(
				select *
				from globalcodes as gc4
				where
					gc4.category = @crisis_category
					and
					gc4.codename = @crisis_codename
					and
					gc4.globalcodeid IN (pc2.Category1, pc2.Category2, pc2.Category3)
			)
			and 
				( -- Get the earliest service after the Assessment (same service rules apply)
				sv.DateOfService > sv2.DateOfService
				Or
					-- In the case where two services have the same date/time, get the earliest serviceId
					(
						sv.DateOfService = sv2.DateOfService
						and
						sv.ServiceId > sv2.ServiceId
					)
				)
		)
) as summ on (summ.clientid = a.clientid and summ.EpisodeNumber = a.EpisodeNumber)


-- update the clientepisodes table
update a set
	AssessmentDate = ca.AssessmentDate,
	TxStartDate = ca.TxStartDate,
	    ModifiedBy = ''sa'',
        ModifiedDate = GetDate() 
from clientepisodes as a
join @ClientAssessments as ca on (ca.clientid = a.clientid and ca.episodenumber = a.episodenumber)
where
	isnull(a.recorddeleted, ''N'') <> ''Y''
	and
	(
		isnull(ca.AssessmentDate, ''1/1/1900'') <> isnull(a.AssessmentDate, ''1/1/1900'')
		or
		isnull(ca.TxStartDate, ''1/1/1900'') <> isnull(a.TxStartDate, ''1/1/1900'')
	)

-- Update Timeliness information

insert into CustomTimeliness(ClientEpisodeId)
select ce.ClientEpisodeId
  from ClientEpisodes as ce
       join @ClientAssessments as ca on ca.ClientId = ce.ClientId and ca.EpisodeNumber = ce.EpisodeNumber
 where isnull(ce.RecordDeleted, ''N'') <> ''Y''
   and not exists (select * 
                     from CustomTimeliness t
                    where t.ClientEpisodeId = ce.ClientEpisodeId)


update t
   set SystemDateOfInitialRequest = ca.InitialRequestDate,
       SystemDateOfInitialAssessment = ca.AssessmentDate,
       SystemInitialAssessmentServiceId = ca.AssessmentServiceId,
       SystemDaysRequestToAssessment = convert(int, datediff(dd, ca.InitialRequestDate, ca.AssessmentDate)),
       SystemDateOfTreatment = ca.TxStartDate,
	   SystemTreatmentServiceId = ca.TxServiceId,
       SystemDaysAssessmentToTreatment = convert(int, datediff(dd, ca.AssessmentDate, ca.TxStartDate)),
	   -- RJN 10/26/2007: If the manual date of initial request hasn''t been set, check to see if the date from the clientEpisodes is not null, and if it is not, check to see if it is the same as the system determined (created date on service) initial request date.
	   -- If the dates are different, use the client episodes date of initial request as the ''Manual Date of Initial request''.  Otherwise, use whatever exists as the manual date of Initial request.
       ManualDateOfInitialRequest = case when t.ManualDateOfInitialRequest is null and dbo.RemoveTimeStamp(ce.InitialRequestDate) <> dbo.RemoveTimeStamp(ca.InitialRequestDate) and ce.InitialRequestDate is not null then ce.InitialRequestDate else t.ManualDateOfInitialRequest end,
	   ModifiedBy = ''sa'',
       ModifiedDate = GetDate()
  from CustomTimeliness as t
       join ClientEpisodes as ce on ce.ClientEpisodeId = t.ClientEpisodeId
       join @ClientAssessments as ca on ca.ClientId = ce.ClientId and ca.EpisodeNumber = ce.EpisodeNumber
 where isnull(t.SystemDateOfInitialRequest, ''1/1/1900'') <> isnull(ca.InitialRequestDate, ''1/1/1900'')
    or isnull(t.SystemDateOfInitialAssessment, ''1/1/1900'') <> isnull(ca.AssessmentDate, ''1/1/1900'')
    or isnull(t.SystemDateOfTreatment, ''1/1/1900'') <> isnull(ca.TxStartDate, ''1/1/1900'')
	or isnull(t.SystemInitialAssessmentServiceId,0) <> isnull(ca.AssessmentServiceId,0)
	or isnull(t.SystemTreatmentServiceId,0) <> isnull(ca.TxServiceId,0)
	or isnull(t.SystemDateOfInitialRequest, ''1/1/1900'') <> isnull(ce.InitialRequestDate,''1/1/1900'')
	
update customTimeliness
set ManualDaysRequestToAssessment = datediff(day,isnull(manualDateOfInitialRequest,SystemDateOfInitialRequest),isnull(manualDateOfInitialAssessment,systemDateOfInitialAssessment))
	where ManualDateOfInitialRequest is not null or ManualDateOfInitialAssessment is not null

update t
set  manualdaysassessmenttotreatment = datediff(day,isnull(manualDateOfInitialAssessment,systemDateOfInitialAssessment),isnull(manualDateOfTreatment,SystemDateOfTreatment))
from CustomTimeliness t
join ClientEpisodes as ce on ce.ClientEpisodeId = t.ClientEpisodeId
join @ClientAssessments as ca on ca.ClientId = ce.ClientId and ca.EpisodeNumber = ce.EpisodeNumber
where ManualDateOfTreatment is not null 

update t
set  manualdaysassessmenttotreatment = NULL
from CustomTimeliness t
join ClientEpisodes as ce on ce.ClientEpisodeId = t.ClientEpisodeId
join @ClientAssessments as ca on ca.ClientId = ce.ClientId and ca.EpisodeNumber = ce.EpisodeNumber
where ManualDateOfTreatment is null 
and manualdaysassessmenttotreatment is not null
' 
END
GO
