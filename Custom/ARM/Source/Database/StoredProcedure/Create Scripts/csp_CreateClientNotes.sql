/****** Object:  StoredProcedure [dbo].[csp_CreateClientNotes]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateClientNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateClientNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateClientNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_CreateClientNotes]
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportClientInformation  
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: creates client notes
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 06.09.2007  SFarber     Created.  
-- 09.13.2007  avoss	   Modified for client gaurdian notes and started crisis plan and adv. dir.
-- 07.01.2009  avoss	   modified client gaurdian to check
-- 05.19.2010  dharvey     Added null check on SubType to prevent duplicate notes if note is already created manually-- 06.09.2012  tremisoski  Harbor Client Note Rules
exec csp_CreateClientNotes
*********************************************************************************/
as
set transaction isolation level read uncommitted
set nocount on

declare @ClientNoteTypeNotSpeakEnglish int = 1000093

declare @NoteLevelInformation int = 4501
declare @NoteLevelWarning int = 4502
declare @NoteLevelUrgent int = 4503


declare @Notes table (
ClientId     int          null,
CoveragePlan varchar(20)  null,
InsuredId    varchar(30)  null,
StartDate    datetime     null,
EndDate      datetime     null,
NoteType     int          null,
NoteLevel	 int		  null,
Notesubtype  int          null, -- in case if there is more than one note of the same type in the future
Minor		 char(1)	  null,
Note		 varchar(100) null,
NoteComment	 varchar(MAX) null)--For First Time Clients


--
-- Client Does Not Speak English
--


insert into @Notes 
        (
         ClientId,
         StartDate,
         EndDate,
         NoteType,
         NoteLevel,
         Note,
         NoteComment
        )
select ClientId, 
CreatedDate, 
null,
@ClientNoteTypeNotSpeakEnglish,
@NoteLevelInformation,
''Tranlation request'',
''Tranlation request''
from dbo.Clients as c
where DoesNotSpeakEnglish = ''Y''
and not exists (
	select *
	from dbo.ClientNotes as cn
	where cn.ClientId = c.ClientId
	and cn.NoteType = @ClientNoteTypeNotSpeakEnglish
	and ISNULL(cn.RecordDeleted, ''N'') <> ''Y''
)
--First Time Clients av
Union
select DISTINCT 
       c.ClientId,
       min(s.DateOfService),
	   null,
	   4186, --First Time Clients
	   1,
	   ''First time client'',
	   null
  from Clients c
		JOIN clientEpisodes ce ON ce.ClientId = c.ClientId AND ce.EpisodeNumber = c.CurrentEpisodeNumber AND ISNULL(c.RecordDeleted,''N'') <> ''Y''
       join Services s on s.ClientId = c.ClientId 
       join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId AND pc.NotBillable <>''Y''
 where s.Status = 70 -- Scheduled
   AND s.DateOfService >= ISNULL(ce.RegistrationDate,ce.InitialRequestDate)
   and s.DateOfService >= GetDate()
   and datediff(dd, GetDate(), s.DateOfService) between 0 and 30
   --and pc.ProcedureCodeId in (70,27) -- Assessment
   and isnull(s.RecordDeleted, ''N'') = ''N''
   and not exists(select 1
                    from Services s2 
						JOIN clients c2 ON c2.ClientId = s2.ClientId
                    
						JOIN clientEpisodes ce2 ON ce2.ClientId = c2.ClientId AND ce2.EpisodeNumber = c2.CurrentEpisodeNumber AND ISNULL(c2.RecordDeleted,''N'') <> ''Y''
                         join ProcedureCodes pc2 on pc2.ProcedureCodeId = s2.ProcedureCodeId AND pc2.NotBillable <>''Y''
                     where s2.ClientId = c.ClientId
                     and s2.Status in (71, 75) -- Show, Completed
                     and s2.DateOfService < GetDate()
                     AND s2.DateOfService >= ISNULL(ce2.RegistrationDate,ce2.InitialRequestDate)
                     --and datediff(dd, s.DateOfService, GetDate()) between 0 and 90
                     --and s.ProcedureCodeId not in (70,27)  -- Assessment, Crisis
                     and isnull(s2.RecordDeleted, ''N'') = ''N''
                     AND s2.DateOfService < s.DateOfService
                     )
    and not exists (
	select 1
	from dbo.ClientNotes as cn
	where cn.ClientId = c.ClientId
	and cn.NoteType = 4186
	and ISNULL(cn.RecordDeleted, ''N'') <> ''Y''
	)
 group by c.ClientId, pc.DisplayAs,pc.procedureCodeID


insert into dbo.ClientNotes 
        (
         ClientId,
         NoteType,
         NoteSubtype,
         NoteLevel,
         Note,
         Active,
         StartDate,
         EndDate,
         Comment
        )
select ClientId, NoteType, Notesubtype, NoteLevel, Note, ''Y'', StartDate, EndDate, NoteComment
from @Notes

-----------------------------------------------------------------------------------
-- Everything below this line is legacy venture code left
-- as an example of how to implement different client notes.
-----------------------------------------------------------------------------------

--declare @PsychProgram int
--  set @PsychProgram = 11

--insert into @Notes (
--       ClientId, 
--       CoveragePlan, 
--       InsuredId,
--       StartDate,
--       EndDate,
--       NoteType,
--       Notesubtype,
--	   Minor)

---- ATP Due Note
--select c.ClientId,
--       co.DisplayAs, 
--       ccp.InsuredId,
--       cp.StartDate, 
--       cp.EndDate,
--       4181, -- Finance notes
--       1,
--	   NULL
--  from Clients c
--       join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
--       join ClientCopayments cp on cp.ClientCoveragePlanId = ccp.ClientCoveragePlanId
--       join CoveragePlans co on co.CoveragePlanId = ccp.CoveragePlanId
-- where ce.Status <> 102 -- not discharged
--   and cp.StartDate <= GetDate()
--   and (dateadd(dd, 1, cp.EndDate) > GetDate() or cp.EndDate is null)
--   and datediff(dd, cp.StartDate, GetDate()) > 365
--   and not exists(select 1
--                    from ClientCopayments cp2
--                   where cp2.ClientCoveragePlanId = cp.ClientCoveragePlanId
--                     and cp2.StartDate > cp.StartDate
--                     and isnull(cp2.RecordDeleted, ''N'') = ''N'')
--   and isnull(c.RecordDeleted, ''N'') = ''N'' 
--   and isnull(ce.RecordDeleted, ''N'') = ''N'' 
--   and isnull(ccp.RecordDeleted, ''N'') = ''N'' 
--   and isnull(cp.RecordDeleted, ''N'') = ''N'' 
--union
---- Medicaid not verified in past 30 days
--select c.ClientId,
--       cp.DisplayAs as CoveragePlan,
--       ccp.InsuredId, 
--       cch.StartDate, 
--       cch.EndDate,
--       4184, -- Verify Coverage 
--       1,
--	   NULL
--  from Clients c
--       join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
--       join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId 
--       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
-- where ce.Status <> 102 -- not discharged
--   and ccp.CoveragePlanId = 105 -- Medicaid
--   and cch.StartDate <= GetDate()
--   and (dateadd(dd, 1, cch.EndDate) > GetDate() or cch.EndDate is null)
--   and datediff(dd, isnull(ccp.LastVerified, ''1/1/1900''), GetDate()) > 30
--   and isnull(c.RecordDeleted, ''N'') = ''N'' 
--   and isnull(ce.RecordDeleted, ''N'') = ''N'' 
--   and isnull(ccp.RecordDeleted, ''N'') = ''N'' 
--   and isnull(cch.RecordDeleted, ''N'') = ''N'' 
--/*
---- If a Crisis Plan Exists
--union
--select c.ClientId,
--       NULL, --CoveragePlan,
--       NULL, --insuredId
--       d.EffectiveDate, --start date
--       NULL, --end date
--       10494, -- (Note Id)--Crisis Plan
--       1, --note subtype
--	   NULL
--  from Clients c
--	   join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--	   join Documents d on d.ClientId = c.ClientId
--	   join CustomAssessments a on a.DocumentId = d.DocumentId
-- where ce.Status <> 102 -- not discharged
--	 and (isnull(a.CrisisPlanClientDesire,''N'')<> ''N'' or a.CrisisPlan is not null)  --a.ExistingAdvanceDirective
--   and isnull(c.RecordDeleted, ''N'') = ''N''
--   and isnull(ce.RecordDeleted, ''N'') = ''N''
--   and isnull(d.RecordDeleted, ''N'') = ''N''
--   and isnull(a.RecordDeleted, ''N'') = ''N''
-- */
-- -- If an Advance Directive Exists
-- union
-- select c.ClientId,
--      NULL, --CoveragePlan,
--      NULL, --insuredId
--      d.EffectiveDate, --start date
--      NULL, --end date
--      10495, -- (Note Id)--Advance Directive
--      1, --note subtype
--	  NULL
--  from Clients c
-- 	   join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
-- 	   join Documents d on d.ClientId = c.ClientId
-- 	   join CustomAssessments a on a.DocumentVersionId = d.CurrentDocumentVersionId
-- where ce.Status <> 102 -- not discharged
--    and isnull(a.ExistingAdvanceDirective,''N'')<>''N''
--    and isnull(c.RecordDeleted, ''N'') = ''N''
--    and isnull(ce.RecordDeleted, ''N'') = ''N''
--    and isnull(d.RecordDeleted, ''N'') = ''N''
--    and isnull(a.RecordDeleted, ''N'') = ''N''
---- If a Client Gaurdian Exists
--union
--select c.ClientId,
--     NULL, --CoveragePlan,
--     NULL, --insuredId
--     cc.CreatedDate, --start date
--     NULL, --end date
--     10493, --Client Gaurdian
--     1, --note subtype
--     NULL
--  from Clients c
--  	   join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--	   join ClientContacts cc on cc.ClientId = c.ClientId 
--			and (isnull(cc.Guardian,''N'')<>''N'' OR cc.Relationship in (10070,10071,10276))
--  where ce.Status <> 102 -- not discharged
--  	and not exists
--  		(select 1 from ClientContacts as cc2
--		 where cc2.ClientId = c.ClientId
--		 and cc2.ClientContactId > cc.ClientContactId
--		 and isnull(cc2.RecordDeleted, ''N'') <> ''Y''
--		 and (isnull(cc.Guardian,''N'')= isnull(cc2.Guardian,''N'') OR cc2.Relationship =cc.RelationShip )
--	)
--    and isnull(c.RecordDeleted, ''N'') = ''N'' 
--    and isnull(ce.RecordDeleted, ''N'') = ''N''
--    and isnull(cc.RecordDeleted, ''N'') = ''N''



----First Time Clients av
--Union
--select c.ClientId,
--       NULL,
--	   NULL,
--       min(s.DateOfService),
--	   null,
--	   4186, --First Time Clients
--	   1,
--	   max(case when dbo.GetAge(c.DOB, GetDate()) < 18 then ''Y'' else ''N'' end)
--  from Clients c
--       join Services s on s.ClientId = c.ClientId 
--       join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
-- where s.Status = 70 -- Scheduled
--   and s.DateOfService >= GetDate()
--   and datediff(dd, GetDate(), s.DateOfService) between 0 and 7
--   and pc.ProcedureCodeId in (70,27) -- Assessment
--   and isnull(s.RecordDeleted, ''N'') = ''N''
--   and not exists(select 1
--                    from Services s 
--                         --join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeId
--                     where s.ClientId = c.ClientId
--                     and s.Status in (71, 75) -- Show, Completed
--                     and s.DateOfService < GetDate()
--                     and datediff(dd, s.DateOfService, GetDate()) between 0 and 90
--                     and s.ProcedureCodeId not in (70,27)  -- Assessment, Crisis
--                     and isnull(s.RecordDeleted, ''N'') = ''N'')
-- group by c.ClientId, pc.DisplayAs,pc.procedureCodeID

-----End First Time Client

----Meds only Tx Plan Needed
--/*
--Union
--select c.ClientId,
--       NULL,
--	   NULL,
--       isnull(cp2.RequestedDate,isnull(cp2.EnrolledDate,dbo.Removetimestamp(c.CreatedDate))),
--	   null,
--	   10806, --Meds only 
--	   1,
--	   null
--  from clients c
--  left join clientPrograms cp2 on cp2.ClientProgramId = c.PrimaryProgramId
--	and isnull(cp2.RecordDeleted,''N'')<>''Y''
--	and cp2.ClientId = c.ClientId
--	and cp2.ProgramId = @PsychProgram
--	and cp2.Status <> 5
--	and cp2.PrimaryAssignment = ''Y''
--  where exists ( select * from documents d 
--	where d.ClientId = c.ClientId 
--	and d.DocumentCodeId = 270 and d.Status=22
--	and isnull(d.RecordDeleted,''N'')<>''Y''
--	and not exists ( select 1 from documents d2 
--		where d2.ClientId = c.ClientId 
--		and d2.DocumentCodeId in ( 350, 503 )  
--		and d2.Status=22
--		and isnull(d2.RecordDeleted,''N'')<>''Y''
--		)
--	)
--  and c.active=''Y''
--  and ( exists ( select 1 from clientPrograms cp 
--	where isnull(cp.RecordDeleted,''N'')<>''Y''
--	and cp.ClientId = c.ClientId
--	and cp.ProgramId = @PsychProgram
--	and cp.Status <> 5
--	and cp.PrimaryAssignment = ''Y'' ) 
--	OR
--	cp2.ClientProgramId is not null 
--	)
--*/
----end meds only tx plan needed

---- Delete old notes
--delete cn
--  from ClientNotes cn
-- where cn.NoteType in (4181, 4184, 4186, 10493, 10494, 10495)--,10806)
--   and cn.NoteSubtype = 1
--   and not exists(select 1
--                    from @Notes n
--                   where n.ClientId = cn.ClientId
--                     and n.NoteType = cn.NoteType
--                     and n.NoteSubtype = cn.NoteSubtype)


---- Create new notes
--insert into ClientNotes (
--       ClientId,
--       NoteType,
--       NoteSubtype)
--select n.ClientId,
--       n.NoteType,
--       n.NoteSubtype
--  from @Notes n
-- where not exists(select 1
--                    from ClientNotes cn
--                   where cn.ClientId = n.ClientId
--                     and cn.NoteType = n.NoteType
--					 and Case When cn.NoteType = 10493 --Guardian Note
--							Then Case When (cn.Notesubtype = n.Notesubtype or cn.Notesubtype is null) Then 1 Else 0 End
--							Else Case When cn.Notesubtype = n.Notesubtype Then 1 Else 0 End
--						 End=1
----					 and cn.Notesubtype = n.Notesubtype
----                   and (cn.Notesubtype = n.Notesubtype or cn.Notesubtype is null) --DJH 5/19/10 - prevent duplicate notes
--                     and isnull(cn.RecordDeleted, ''N'') = ''N'')

--update cn
--   set NoteLevel =  4501, -- Information
--       Note = case n.NoteType
--                   when 4181 then ''ATP for '' + rtrim(n.CoveragePlan) + '' is over 1 year old''
--                   when 4184 then rtrim(n.CoveragePlan) + '' has not been verified in past 30 days''
--                   when 4186 then ''First Time Client'' + case when n.Minor = ''Y'' then '' (CAFAS required)'' else '''' end
--				   when 10493 then ''Client has guardian''
--                   --when 10494 then ''Crisis plan exists''
--                   when 10495 then ''Advanced directive exists''
--				  -- when 10806 then ''Meds Tx Plan Needed for Client''
--                   else ''''
--              end,
--       Active = ''Y'',
--       StartDate = n.StartDate,
--       EndDate = n.EndDate
--  from ClientNotes cn
--       join @Notes n on n.ClientId = cn.ClientId and 
--                        n.NoteType = cn.NoteType and
--                        n.Notesubtype = cn.Notesubtype
 

----return


---------------------------------------------------------
----New Flags Added 10/10/2010 per P.Filstrup
---------------------------------------------------------
----GlobalCodeId	CodeName
----10727			Assessment Needed
----10728			Treatment Plan Needed
----10729			Periodic Review Needed

--declare @StartDate datetime
--set @StartDate = dbo.RemoveTimestamp(Getdate())

----  
---- Assessment Needed
---- 


--create table #Assessment  (
--NoteId       int identity not null,
--ClientId     int          null,
--LastAssessmentDate datetime)

--insert into #Assessment (
--       ClientId,
--       LastAssessmentDate)
--select c.ClientId,
--       d.EffectiveDate
--from Clients c 
--        join ClientEpisodes ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--    left join ClientPrograms cp on cp.ClientId = c.ClientId 
--									and cp.primaryAssignment = ''Y''
--									and cp.status <> 5
--									AND isnull(cp.RequestedDate, cp.EnrolledDate) <= getdate() 
--									AND isnull(cp.RecordDeleted, ''N'') = ''N''

--	left join Documents d on d.ClientId = c.ClientId and (d.documentcodeid = 101 
--															or
--														(d.documentcodeid in (349,1469) and exists (select 1 from CustomHRMAssessments a
--																							where a.DocumentVersionId = d.CurrentDocumentVersionId 
--																							and isnull(a.recorddeleted, ''N'')= ''N''
--																							and isnull(a.AssessmentType, ''X'') in (''I'', ''A''))
--														)
--														) AND d.Status = 22
--  	Where 
--	c.Active = ''Y''
--	AND datediff(ww, isnull(effectivedate, ''01/01/1900''), getdate()) >= 48
--	AND ce.Status <> 102 -- not discharged
--	and NOT EXISTS (select 1 From CustomCreateClientNoteExceptions cne
--			where cne.DocumentCodeId in (101, 349, 1469)  --Old Assessment, HRM Assessment
--			and ( cne.ClientPrimaryProgramId = cp.ProgramId
--				OR cne.ClinicianId = d.AuthorId
--				OR cne.ClientId = c.ClientId )
--			and (cne.BeginDate <= @StartDate or isnull(cne.NoBeginDate, ''N'') = ''Y'')
--			and (cne.EndDate >= @StartDate or isnull(cne.NoEndDate, ''N'') = ''Y'')
--			and isnull(cne.RecordDeleted, ''N'') = ''N'')

--	AND Not Exists (Select d2.DocumentId from Documents d2	
--			left join CustomHRMAssessments a2 on a2.DocumentVersionId = d2.CurrentDocumentVersionId and isnull(a2.recorddeleted, ''N'')= ''N''
--			where d2.clientId = d.ClientId
--			and d2.Status = 22
--			and (d2.DocumentCodeId in (101) or  (d2.documentcodeid in (349,1469) and isnull(a2.AssessmentType, ''X'') in (''I'', ''A'')))  --Old Assessment, HRM Assessment
--			and d2.EffectiveDate > d.EffectiveDate
--			and isnull(d2.RecordDeleted, ''N'') = ''N'')
--	AND isnull(d.RecordDeleted, ''N'') = ''N''	
--	AND isnull(c.RecordDeleted, ''N'') = ''N''	
--	AND isnull(ce.RecordDeleted, ''N'') = ''N''


---- Only one note per client
--delete A
--from #Assessment A
--where exists (select 1 from #Assessment A2 where A2.ClientId = A.ClientId and A2.NoteId < A.NoteId )	

---- Delete old notes
--delete cn
--  from ClientNotes cn
-- where cn.NoteType = 10727 -- Assessment Needed (Riverwood)
--   and not exists(select 1
--                    from #Assessment A
--                   where A.ClientId = cn.ClientId)

---- Create new notes
--insert into ClientNotes (
--       ClientId,
--       NoteType)
--select A.ClientId,
--       10727
--  from #Assessment A
-- where not exists(select 1
--                    from ClientNotes cn
--                   where cn.ClientId = A.ClientId
--                     and cn.NoteType = 10727
--                     and isnull(cn.RecordDeleted, ''N'') = ''N'')

---- Update note information
--update cn
--   set Note =  case when LastAssessmentDate is null then ''Assessment Needed.'' else  ''Assessment Needed. Last Intake/Annual Assess done '' + convert(varchar(20), LastAssessmentDate, 101)+ ''.'' end,
--       NoteLevel = 4501, -- Information
--       Active = ''Y'',
--       StartDate = getdate(),
--       EndDate = null
--  from ClientNotes cn
--       join #Assessment A on A.ClientId = cn.ClientId
-- where cn.NoteType = 10727


----
---- Treatment Plan Needed
----

--create table #TreatmentPlan  (
--NoteId       int identity not null,
--ClientId     int          null,
--LastTreatmentPlanDate datetime,
--PeriodicReviewDueDate datetime)

--insert into #TreatmentPlan (
--	ClientId,
--	LastTreatmentPlanDate,
--	PeriodicReviewDueDate)
--select c.ClientId,
--	d.EffectiveDate,
--	--isnull(tp.PeriodicReviewDueDate, dateadd(month, 3, d.EffectiveDate)) --changed for new HRM docs
--	convert( varchar(50), 
--		case when tp.PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = ''Month(s)''
--			then dateadd( mm, tp.PeriodicReviewFrequencyNumber, d.effectivedate ) 
--		when tp.PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = ''Week(s)''
--			then dateadd( wk, tp.PeriodicReviewFrequencyNumber, d.effectivedate ) 
--		else isnull(tp.PeriodicReviewDueDate, dateadd(month, 3, d.EffectiveDate)) 	end ,
--	101 )

--from Clients c 
--join ClientEpisodes as ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--left join ClientPrograms as cp on cp.ClientId = c.ClientId 
--								and cp.primaryAssignment = ''Y'' 
--								and isnull(cp.RecordDeleted, ''N'')= ''N''
--								and cp.status <> 5
--								AND (cp.DischargedDate is null or cp.DischargedDate >= getdate())
--								AND isnull(cp.RecordDeleted, ''N'') = ''N''
--left join Documents as d on d.ClientId = c.ClientId AND d.Status = 22
--join TPGeneral as tp on tp.DocumentVersionId = d.CurrentDocumentVersionId and tp.PlanOrAddendum = ''T''
--Where 
-- d.DocumentCodeId in ( 2, 350 ) 
--AND c.Active = ''Y'' 
--AND datediff(ww, isnull(effectivedate, ''01/01/1900''), getdate()) >= 48
--AND ce.Status <> 102 -- not discharged
--and NOT EXISTS (select 1 From CustomCreateClientNoteExceptions as cne
--	where cne.DocumentCodeId in ( 2, 350 ) 
--	and ( cne.ClientPrimaryProgramId = cp.ProgramId OR cne.ClinicianId = d.AuthorId 
--		OR cne.ClientId = c.ClientId )
--	and (cne.BeginDate <= @StartDate or isnull(cne.NoBeginDate, ''N'') = ''Y'')
--	and (cne.EndDate >= @StartDate or isnull(cne.NoEndDate, ''N'') = ''Y'')
--	and isnull(cne.RecordDeleted, ''N'') = ''N''
--	)
--AND Not Exists (Select d2.DocumentId 
--	from Documents as d2	
--	join TPGeneral as tp2 on tp2.DocumentVersionId = d2.CurrentDocumentVersionId
--		and tp2.PlanOrAddendum = ''T''
--		and isnull(tp2.RecordDeleted,''N'') = ''N''
--	where d2.clientId = d.ClientId 
--	and d2.DocumentCodeId in ( 2, 350 ) 
--	and d2.Status = 22 
--	and (d2.EffectiveDate > d.EffectiveDate
--		or (d2.EffectiveDate = d.EffectiveDate
--		and d2.DocumentId > d.DocumentId ) )
--	and isnull(d2.RecordDeleted, ''N'') = ''N'' 
--	)
--AND isnull(d.RecordDeleted, ''N'') = ''N''	
--AND isnull(c.RecordDeleted, ''N'') = ''N''	
--AND isnull(ce.RecordDeleted, ''N'') = ''N'' 
--AND isnull(tp.RecordDeleted, ''N'') = ''N''
	
---- Only one note per client
--delete A
--from #TreatmentPlan A
--where exists (select 1 from #TreatmentPlan A2 where A2.ClientId = A.ClientId and A2.NoteId < A.NoteId )

---- Delete old notes
--delete cn
--  from ClientNotes cn
-- where cn.NoteType = 10728 -- TP Needed (Riverwood)
--   and not exists(select 1
--                    from #TreatmentPlan A
--                   where A.ClientId = cn.ClientId)

---- Create new notes
--insert into ClientNotes (
--       ClientId,
--       NoteType)
--select A.ClientId,
--       10728
--  from #TreatmentPlan A
-- where not exists(select 1
--                    from ClientNotes cn
--                   where cn.ClientId = A.ClientId
--                     and cn.NoteType = 10728
--                     and isnull(cn.RecordDeleted, ''N'') = ''N'')

---- Update note information
--update cn
--   set Note = case when LastTreatmentPlanDate is null then ''Treatment Plan Needed.'' else ''Treatment Plan Needed. Last Treatment Plan done '' + convert(varchar(20), LastTreatmentPlanDate, 101) + ''.'' end,
--       NoteLevel = 4501, -- Information
--       Active = ''Y'',
--       StartDate = getdate(),
--       EndDate = null
--  from ClientNotes cn
--       join #TreatmentPlan A on A.ClientId = cn.ClientId
-- where cn.NoteType = 10728


----
---- Periodic Review Needed
----
--CREATE TABLE #DueDates
--(ClientId int null,
-- TxPlan varchar(150) null,
-- TxPlanNextPeriodic varchar(50) null,
-- TxPlanDocumentVersionId int null,
-- PeriodicReview varchar(150) null,
-- LastPeriodicReview varchar(150) null,
-- LastPeriodicDueDate varchar(150) null,
-- PeriodicDocumentVersionId int null)
 
 
--Insert Into #DueDates
--( ClientId  )

--Select 
--c.ClientId
--From Clients c
----Left Join ClientPrograms cp on cp.ClientId = c.ClientId and cp.Status not in (5) and PrimaryAssignment = ''Y'' and isnull(cp.RecordDeleted, ''N'') = ''N''
--Left Join Staff s on s.StaffId = c.PrimaryClinicianId and isnull(s.RecordDeleted, ''N'') = ''N''
--Left Join Programs p on p.ProgramId = s.PrimaryProgramId
--Left Join GlobalCodes gc1 on gc1.GlobalCodeId = p.ProgramType and isnull(gc1.RecordDeleted, ''N'') = ''N''
--where c.Active = ''Y''
--and isnull(c.RecordDeleted, ''N'') = ''N''

----START HRM Update from Documentation due dates logic
---- Find Treatment Plan Date
--Update #DueDates
--set TxPlan = convert(varchar(50), dateadd(yy, 1, d.effectivedate),101),
--TxPlanDocumentVersionId = d.CurrentDocumentVersionId,
--TxPlanNextPeriodic = convert( varchar(50), 
--	case when tp.PeriodicReviewDueDate is null and tp.PeriodicReviewFrequencyUnitType = ''Month(s)''
--		then dateadd( mm, tp.PeriodicReviewFrequencyNumber, d.effectivedate ) 
--	when PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = ''Week(s)''
--		then dateadd( wk, tp.PeriodicReviewFrequencyNumber, d.effectivedate ) 
--	else isnull( tp.PeriodicReviewDueDate, dateadd(month, 3, d.EffectiveDate) ) 	end, 
--	101 )
--From #DueDates dd
--Left Join Documents d on dd.ClientId = d.ClientID 
--	and d.DocumentCodeId in (2, 350)
--	and d.Status = 22 and isnull(d.RecordDeleted, ''N'') = ''N''
--	and d.CurrentdocumentVersionid in ( select tpg.documentVersionid from tpGeneral tpg
--		where  tpg.PlanOrAddendum = ''T''
--		and tpg.DocumentVersionId = d.CurrentDocumentVersionId
--		and isnull(tpg.RecordDeleted, ''N'') = ''N''
--		)
--	and not exists ( select 1 from documents d2
--	join TPGeneral tpg2 on tpg2.DocumentVersionId = d2.CurrentDocumentVersionId
--	where d2.ClientId = d.ClientId
--	and tpg2.PlanOrAddendum = ''T'' and d2.DocumentCodeId in (2, 350)
--	and d2.Status = 22 and d2.EffectiveDate > d.EffectiveDate
--	and isnull(d2.RecordDeleted, ''N'') = ''N''
--)
--left join TpGeneral tp on tp.DocumentVersionId = d.CurrentDocumentVersionId 


---- Find Last Periodic Review Date
--Update #DueDates
--set LastPeriodicReview = convert(varchar(50), d.effectivedate, 101),
--LastPeriodicDueDate = convert(varchar(50), case when pr.NextReviewDate is null and len(isnull(Pr.NextPeriodicReviewYear, 0)) = 4 then
--					convert(varchar(20), convert(varchar(2),NextPeriodicReviewMonth) + ''/''+ convert(varchar(20),  case when NextPeriodicReviewMonth in (2) and datepart(d, d.effectivedate) >28 then ''28''
--																													 when NextPeriodicReviewMonth in (4, 6, 9, 11) and datepart(d, d.effectivedate) >30 then ''30''
--																													 else convert(varchar(20), datepart(d, d.effectivedate)) end)
--															+ ''/'' + isnull(convert(varchar(4), Pr.NextPeriodicReviewYear) , ''''))
--						else pr.NextReviewDate end ,101),
--PeriodicDocumentVersionId = d.CurrentDocumentVersionId
--From #DueDates dd
--Left Join Documents d on dd.ClientId = d.ClientID and d.DocumentCodeId in (3,352)
--and d.Status = 22 and isnull(d.RecordDeleted, ''N'') = ''N''
--and not exists (select 1 from documents d2
--		where d2.ClientId = d.ClientId
--		and d2.DocumentCodeId in (3, 352)
--		and d2.Status = 22
--		and d2.EffectiveDate > d.EffectiveDate
--		and isnull(d2.RecordDeleted, ''N'') = ''N'')
--Left Join PeriodicReviews pr on pr.DocumentVersionId = d.CurrentDocumentVersionId 
								



--Update #DueDates
--set PeriodicReview = case when --isnull(convert(datetime, TxPlanNextPeriodic, 101), ''01/01/1900'') > isnull(convert(datetime, LastPeriodicDueDate, 101), ''01/01/1900'') 
--		      isnull(dateadd(yy, -1, convert(datetime, TxPlan, 101)), ''01/01/1900'') > isnull(convert(datetime, LastPeriodicReview, 101), ''01/01/1900'') 
--		      then convert(varchar(50),TxPlanNextPeriodic,101)

--          	      --when isnull(convert(datetime, TxPlanNextPeriodic, 101), ''01/01/1900'') <= isnull(convert(datetime, LastPeriodicDueDate, 101), ''01/01/1900'') 
--		      when isnull(dateadd(yy, -1, convert(datetime, TxPlan, 101)), ''01/01/1900'') < isnull(convert(datetime, LastPeriodicReview, 101), ''01/01/1900'') 
		      
--			then (
--		      case when (isnull(convert(datetime, LastPeriodicDueDate, 101), ''01/01/1900'') >= dateadd(mm, -1, isnull(convert(datetime, TxPlan, 101), ''01/01/1900''))) then NULL
--    		      else convert(varchar(50), LastPeriodicDueDate, 101) end )
--		      else null end

----End HRM Update from Documentation due dates logic


----Insert from due dates the periodic review 
--create table #PeriodicReviews  (
--NoteId       int identity not null,
--ClientId     int          null,
--LastPeriodicReview datetime,
--PeriodicReviewDueDate datetime)

--insert into #PeriodicReviews (
--       ClientId,
--       LastPeriodicReview,
--	   PeriodicReviewDueDate)
--select	dd.ClientId, 
--		null,
--		convert( datetime, dd.PeriodicReview, 101 )
--from #DueDates dd
--join Clients as c on c.ClientId = dd.ClientId
--join ClientEpisodes as ce on ce.ClientId = c.ClientId and ce.EpisodeNumber = c.CurrentEpisodeNumber
--left join ClientPrograms as cp on cp.ClientId = c.ClientId and cp.primaryAssignment = ''Y'' 
--								and cp.status <> 5 --av moved status to join and left joined
--								and isnull(cp.RequestedDate, cp.EnrolledDate) <= getdate() 
--								and (cp.DischargedDate is null or cp.DischargedDate >= getdate())
--								and isnull(cp.RecordDeleted, ''N'') = ''N''
--where convert(datetime, PeriodicReview, 101) <= dateadd( mm, 1, getdate() )
--and TxPlan is not null
--and convert(datetime, TxPlan, 101) >= dateadd( mm, 1, getdate() )
----av moved to join
--and ce.Status <> 102 -- not discharged
--and NOT EXISTS (select 1 From CustomCreateClientNoteExceptions as cne
--	where cne.DocumentCodeId in ( 3, 352 ) 
--	and ( cne.ClientPrimaryProgramId = cp.ProgramId 
--		OR cne.ClientId = c.ClientId )
--	and (cne.BeginDate <= @StartDate or isnull(cne.NoBeginDate, ''N'') = ''Y'')
--	and (cne.EndDate >= @StartDate or isnull(cne.NoEndDate, ''N'') = ''Y'')
--	and isnull(cne.RecordDeleted, ''N'') = ''N''  )
--and isnull(c.RecordDeleted, ''N'') = ''N''	
--and isnull(ce.RecordDeleted, ''N'') = ''N''
--order by dd.ClientId

---- Delete old notes
--delete cn
--  from ClientNotes cn
-- where cn.NoteType = 10729 -- PR Needed (Riverwood)
--   and not exists(select 1 from #PeriodicReviews A where A.ClientId = cn.ClientId)

---- Create new notes
--insert into ClientNotes (
--       ClientId,
--       NoteType)
--select A.ClientId,
--       10729
--from #PeriodicReviews A
--where not exists(select 1 from ClientNotes cn where cn.ClientId = A.ClientId 
--	and cn.NoteType = 10729 and isnull(cn.RecordDeleted, ''N'') = ''N'')

---- Update note information
--update cn
--   set Note = case when PeriodicReviewDueDate is null then ''Periodic Review Needed.'' else ''Periodic Review due '' + convert(varchar(20), PeriodicReviewDueDate, 101) + ''.'' end,
--       NoteLevel = 4501, -- Information
--       Active = ''Y'',
--       StartDate = getdate(),
--       EndDate = null
--  from ClientNotes cn
--       join #PeriodicReviews A on A.ClientId = cn.ClientId
-- where cn.NoteType = 10729



return

' 
END
GO
