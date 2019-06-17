/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentationDueDates]    Script Date: 04/18/2013 09:54:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentationDueDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentationDueDates]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentationDueDates]    Script Date: 04/18/2013 09:54:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportDocumentationDueDates]  
 @Team   int ,  
 @Clinician int ,  
 @Overdue int  
AS  

/*  
Modified by  Modified Date Reason  
avoss   11/29/2010  Correct logic for Client Primary Program for teams  
  
  --select * from staff where lastname like 'aa%' order by createddate desc
exec   csp_ReportDocumentationDueDates null, 167, 0
*/  
  
CREATE TABLE #DueDates  
(ClientOrder varchar(200) null,  
 ClientName varchar(200) null,  
 ClientId int null,  
 TeamName varchar(100) null,  
 Clinician varchar(200) null,  
 Assessment varchar(150) null,  
 AssessmentDocumentId int null,  
 AssessmentCurrentVersion int null,  
 TxPlan varchar(150) null,  
 TxPlanNextPeriodic varchar(50) null,  
 TxPlanDocumentId int null,  
 TxPlanCurrentVersion int null,   
 PeriodicReview varchar(150) null,  
 LastPeriodicReview varchar(150) null,  
 LastPeriodicDueDate varchar(150) null,  
 PeriodicDocumentId int null,  
 PeriodicCurrentVersion int null,  
 LastSeen datetime null,   
 LastService varchar(150) null,   
 NextSeen datetime null,  
 NextService varchar(150) null,  
 NextSeenBy varchar(150) null,  
 Next3803Due varchar(50) null)  
   
   
Insert Into #DueDates  
(ClientOrder,  
 ClientName,  
 ClientId,   
 TeamName,  
 Clinician  
  
-- Assessment,  
-- TxPlan,  
-- PeriodicReview,  
  
 )  
  
Select c.LastName + ', ' + c.FirstName, '(' + convert(varchar(15), c.clientid) + ') ' + c.LastName + ', ' + c.FirstName,  
c.ClientId,  
isnull(gc1.CodeName, 'Unknown'), isnull(s.LastName + ', ' + s.FirstName, 'Unknown')  
From Clients c WITH(NOLOCK)  
Left Join ClientPrograms cp WITH(NOLOCK) on cp.ClientId = c.ClientId and cp.Status not in (5) and PrimaryAssignment = 'Y' and isnull(cp.RecordDeleted, 'N') = 'N'  
Left Join Staff s WITH(NOLOCK) on s.StaffId = c.PrimaryClinicianId and isnull(s.RecordDeleted, 'N') = 'N'  
Left Join Programs p WITH(NOLOCK) on p.ProgramId = cp.ProgramId  
--Left Join Programs p WITH(NOLOCK) on p.ProgramId = s.PrimaryProgramId  
Left Join GlobalCodes gc1 WITH(NOLOCK) on gc1.GlobalCodeId = p.ProgramType and isnull(gc1.RecordDeleted, 'N') = 'N'  
where c.Active = 'Y'  
and isnull(c.RecordDeleted, 'N') = 'N'  
--and p.programid = 12  
--and s.staffid = 92  
and (@Team is null  
     Or  
     (@Team is not null  
     AND p.ProgramType = @Team))  
and (@Clinician is null  
     Or   
     (@Clinician is not null  
     AND @Clinician = s.StaffId))  
and Not exists (   
 select *   
 from ClientPrograms cp2 WITH(NOLOCK)   
 where cp2.ClientId = c.ClientId   
 and cp2.Status not in (5)   
 and cp2.PrimaryAssignment = 'Y'   
 and isnull(cp2.RecordDeleted, 'N') = 'N'  
 and cp2.ClientProgramId > cp.ClientProgramId  
 )  
  
-- Find Last Service Date  
Update #DueDates  
set LastSeen = s1.DateOfService,  
LastService = cp1.DisplayAs  
From #DueDates dd  
Join Services s1 WITH(NOLOCK) on isnull(s1.RecordDeleted, 'N') = 'N'  
   and s1.Status in (71, 75)  
   and s1.ClientId = dd.ClientId  
Join ProcedureCodes cp1 WITH(NOLOCK) on cp1.ProcedureCodeId = s1.ProcedureCodeId and isnull(cp1.RecordDeleted, 'N') = 'N'  
Where not exists (select top 1 serviceid from Services s1a WITH(NOLOCK)  
     where s1a.Status in (71, 75)  
     and s1a.ClientId = s1.ClientID  
     and s1a.DateOfService > s1.DateOfService  
     and isnull(s1a.RecordDeleted, 'N') = 'N')  
  
  
-- Find Next Service Date  
Update #DueDates  
set  NextSeen = s2.DateOfService,  
 NextService = cp2.DisplayAs,  
 NextSeenBy = st.LastName + ', ' + st.FirstName  
From #DueDates dd  
Join Services s2 WITH(NOLOCK) on isnull(s2.RecordDeleted, 'N') = 'N'  
   and s2.Status in (70)  
   and s2.ClientId = dd.ClientId  
   and not exists (select s2a.ServiceId from Services s2a WITH(NOLOCK)  
     where s2a.Status in (70)  
     and s2a.ClientId = s2.ClientID  
     and s2a.DateOfService < s2.DateOfService  
     and isnull(s2a.RecordDeleted, 'N') = 'N')  
Join ProcedureCodes cp2 WITH(NOLOCK) on cp2.ProcedureCodeId = s2.ProcedureCodeId and isnull(cp2.RecordDeleted, 'N') = 'N'  
Join Staff st WITH(NOLOCK) on st.StaffId = s2.ClinicianId and isnull(st.RecordDeleted, 'N') = 'N'  
  
  
  
-- Find Assessment Date  
Update #DueDates  
set Assessment = convert(varchar(20), dateadd(yy, 1, d.effectivedate), 101),  
AssessmentDocumentId = d.DocumentId,  
AssessmentCurrentVersion = dv.Version  
From #DueDates dd   
Join Documents d WITH(NOLOCK) on dd.ClientId = d.ClientID  
Join DocumentVersions dv with(nolock) on dv.DocumentVersionId=d.CurrentDocumentVersionId  
and (d.documentcodeid = 101   
  or  
 (d.documentcodeid in (349,1469) and exists (select 1 from CustomHRMAssessments a WITH(NOLOCK)  
          where a.DocumentVersionId = d.CurrentDocumentVersionId   
          and isnull(a.recorddeleted, 'N')= 'N'  
          and isnull(a.AssessmentType, 'X') in ('I', 'A'))  
  )  
  )  
and d.Status = 22  
and not exists (select 1 from documents d2 WITH(NOLOCK)  
  left join CustomHRMAssessments a2 WITH(NOLOCK) on a2.DocumentVersionId = d2.CurrentDocumentVersionId and isnull(a2.recorddeleted, 'N')= 'N'  
  where d2.ClientId = d.ClientId  
  and (d2.DocumentCodeId in (101) or  (d2.documentcodeid in (349,1469) and isnull(a2.AssessmentType, 'X') in ('I', 'A')))  --Old Assessment, HRM Assessment  
  and d2.Status = 22  
  and d2.EffectiveDate > d.EffectiveDate  
  and isnull(d2.RecordDeleted, 'N') = 'N')  
and isnull(d.RecordDeleted, 'N') = 'N'  
  
-- Find Treatment Plan Date  
Update #DueDates  
set TxPlan = convert(varchar(50), dateadd(yy, 1, d.effectivedate),101),  
TxPlanDocumentId = d.DocumentId,  
TxPlanCurrentVersion = dv.Version,  
TxPlanNextPeriodic = convert(varchar(50), case when PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = 'Month(s)'  
           then dateadd(mm, tpg.PeriodicReviewFrequencyNumber, d.effectivedate )   
           when PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = 'Week(s)'  
           then dateadd(wk, tpg.PeriodicReviewFrequencyNumber, d.effectivedate )   
          else PeriodicReviewDueDate  end, 101)  
From #DueDates dd  
Join Documents d WITH(NOLOCK) on dd.ClientId = d.ClientID   
 and d.DocumentCodeId in (2, 350)  
 and d.Status = 22 and isnull(d.RecordDeleted, 'N') = 'N'  
Join DocumentVersions dv with(nolock) on dv.DocumentVersionId=d.CurrentDocumentVersionId  
--and d.documentid in (select tpg.documentid from tpGeneral tpg WITH(NOLOCK)  
--   where  tpg.PlanOrAddendum = 'T'  
--   and tpg.DocumentId = d.DocumentId  
--   and tpg.Version = d.CurrentVersion  
--   and isnull(tpg.RecordDeleted, 'N') = 'N')  
Join TpGeneral tpg WITH(NOLOCK) on tpg.DocumentVersionId = d.CurrentDocumentVersionId and tpg.PlanOrAddendum = 'T'  
 and isnull(tpg.RecordDeleted, 'N') = 'N'  
Where not exists (select 1 from documents d2 WITH(NOLOCK)  
  join TPGeneral tpg2 WITH(NOLOCK) on tpg2.DocumentVersionId = d2.CurrentDocumentVersionId  
  where d2.ClientId = d.ClientId  
  and tpg2.PlanOrAddendum = 'T'  
  and d2.DocumentCodeId in (2, 350)  
  and d2.Status = 22  
  and d2.EffectiveDate > d.EffectiveDate  
  and isnull(d2.RecordDeleted, 'N') = 'N'  
  and isnull(tpg2.RecordDeleted, 'N') = 'N')  
  
  
  
-- Find Last Periodic Review Date  
Update #DueDates  
set LastPeriodicReview = convert(varchar(50), d.effectivedate, 101),  
LastPeriodicDueDate =  convert(varchar(50), case when pr.NextReviewDate is null and len(isnull(Pr.NextPeriodicReviewYear, 0)) = 4 then  
     convert(varchar(20), convert(varchar(2),NextPeriodicReviewMonth) + '/'+ convert(varchar(20),  case when NextPeriodicReviewMonth in (2) and datepart(d, d.effectivedate) >28 then '28'  
                              when NextPeriodicReviewMonth in (4, 6, 9, 11) and datepart(d, d.effectivedate) >30 then '30'  
                              else convert(varchar(20), datepart(d, d.effectivedate)) end)  
               + '/' + isnull(convert(varchar(4), Pr.NextPeriodicReviewYear) , ''))  
      else pr.NextReviewDate end ,101),  
PeriodicDocumentId = d.DocumentId,  
PeriodicCurrentVersion = dv.Version  
From #DueDates dd  
Join Documents d WITH(NOLOCK) on dd.ClientId = d.ClientID and d.DocumentCodeId in (3,352)  
and d.Status = 22 and isnull(d.RecordDeleted, 'N') = 'N'  
and not exists (select 1 from documents d2 WITH(NOLOCK)  
  where d2.ClientId = d.ClientId  
  and d2.DocumentCodeId in (3, 352)  
  and d2.Status = 22  
  and d2.EffectiveDate > d.EffectiveDate  
  and isnull(d2.RecordDeleted, 'N') = 'N')  
Join DocumentVersions dv with(nolock) on dv.DocumentVersionId=d.CurrentDocumentVersionId  
Join PeriodicReviews pr WITH(NOLOCK) on pr.DocumentVersionId = d.CurrentDocumentVersionId  
 and isnull(pr.RecordDeleted, 'N') = 'N'  
  
  
  
Update #DueDates  
set PeriodicReview = case when --isnull(convert(datetime, TxPlanNextPeriodic, 101), '01/01/1900') > isnull(convert(datetime, LastPeriodicDueDate, 101), '01/01/1900')   
        isnull(dateadd(yy, -1, convert(datetime, TxPlan, 101)), '01/01/1900') > isnull(convert(datetime, LastPeriodicReview, 101), '01/01/1900')   
        then convert(varchar(50),TxPlanNextPeriodic,101)  
  
                 --when isnull(convert(datetime, TxPlanNextPeriodic, 101), '01/01/1900') <= isnull(convert(datetime, LastPeriodicDueDate, 101), '01/01/1900')   
        when isnull(dateadd(yy, -1, convert(datetime, TxPlan, 101)), '01/01/1900') < isnull(convert(datetime, LastPeriodicReview, 101), '01/01/1900')   
          
   then (  
        case when (isnull(convert(datetime, LastPeriodicDueDate, 101), '01/01/1900') >= dateadd(mm, -1, isnull(convert(datetime, TxPlan, 101), '01/01/1900'))) then NULL  
            else convert(varchar(50), LastPeriodicDueDate, 101) end )  
        else null end  
  
  
  
  
-- Find Next 3803  
/*  
Update #DueDates  
set Next3803Due = convert(varchar(20), dt.DocumentationNext3803DueOn, 101)  
From #DueDates dd  
Left Join Documents d WITH(NOLOCK) on dd.ClientId = d.ClientID  
 and d.DocumentCodeId = 112  
 and d.Status = 22  
 and not exists (select * from documents d2 WITH(NOLOCK)  
  where d2.ClientId = d.ClientId  
  and d2.DocumentCodeId = 112  
  and d2.Status = 22  
  and d2.EffectiveDate > d.EffectiveDate  
  and isnull(d2.RecordDeleted, 'N') = 'N')  
 and isnull(d.RecordDeleted, 'N') = 'N'  
Left Join CustomDateTracking dt WITH(NOLOCK) on dt.DocumentId = d.DocumentId and dt.Version = d.CurrentVersion   
 and isnull(dt.RecordDeleted, 'N') = 'N'  
 
Update #DueDates  
set Next3803Due = convert(varchar(20), cfd.ColumnDateTime3, 101)  
From #DueDates dd  
join customfieldsdata cfd WITH(NOLOCK) on cfd.PrimaryKey1 = dd.ClientId  
where cfd.documenttype = 4941   
and cfd.ColumnDateTime3 is not null  
 --and isnull(cfd.ColumnDateTime3, '1/1/1900') <> '1/1/1900'  
    and isnull(cfd.RecordDeleted, 'N')= 'N'  
*/   
  
  
declare @DueIn int  

 set @DueIn = case when @Overdue = 1 then 0  
     when @Overdue = 2 then 30  
     when @Overdue = 3 then 60  
     when @Overdue = 4 then 90  
   else 0 end  
   
  
  
  
  
select ClientName, TeamName, Clinician, isnull(Assessment, 'Need Assmt.') as Assessment, isnull(TxPlan, 'Need TxPlan') as TxPlan, isnull(PeriodicReview, '< See TxPlan') as PeriodicReview, isnull(Next3803Due, NULL) as Next3803, LastSeen, LastService, NextSeen, NextService, NextSeenBy  
 from #DueDates  
where @OverDue = 0  
or (@OverDue <> 0  
 and (convert(datetime, TxPlan, 101) <= dateadd(dd,  @DueIn,getdate())  
 Or convert(datetime, Assessment, 101) <= dateadd(dd,  @DueIn, getdate())  
 or convert(datetime, PeriodicReview, 101) <= dateadd(dd, @DueIn, getdate()))  
        Or Assessment is null  
 Or TxPlan is null  
 )  
  
order by Clinician, ClientOrder  
  
  
drop table #duedates  
GO

