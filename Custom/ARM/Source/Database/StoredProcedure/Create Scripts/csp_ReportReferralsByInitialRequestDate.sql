/****** Object:  StoredProcedure [dbo].[csp_ReportReferralsByInitialRequestDate]    Script Date: 04/18/2013 11:45:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReferralsByInitialRequestDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportReferralsByInitialRequestDate]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportReferralsByInitialRequestDate]    Script Date: 04/18/2013 11:45:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportReferralsByInitialRequestDate]
@StartDate datetime,
@EndDate datetime
AS


Create table #Report
(ClientId int,
 EpisodeNumber int,
 Active char(1),
 ClientName varchar(300),
 InitialRequestDate datetime,
 ReferralType varchar(150),
 ReferralSource varchar(150),
 PrimaryClinician varchar(200),
 PrimaryCoveragePlan varchar(100),
 AssessmentDocumentId int,
 AssessmentEffectiveDate datetime,
 AssessmentReferralType varchar(200))

Insert into #Report
(ClientId ,
 EpisodeNumber ,
 Active, 
 ClientName ,
 InitialRequestDate,
 ReferralType ,
 ReferralSource ,
 PrimaryClinician )

select c.clientid, ce.episodenumber, c.Active, c.lastname + ', ' + c.firstname as ClientName, 
	ce.initialrequestdate,
	isnull(gc2.codename, 'Unknown'), gc1.codename,
	st.lastname +', ' + st.firstname as PrimaryClinician
 from clients c with(nolock)
left join staff st with(nolock) on st.staffid = c.primaryclinicianid
join clientepisodes ce with(nolock) on ce.clientid = c.clientid and c.currentepisodenumber = ce.episodenumber
left join globalcodes gc1 with(nolock) on gc1.globalcodeid = ce.referralsource and isnull(gc1.recorddeleted, 'N')= 'N'
left join globalcodes gc2 with(nolock) on gc2.globalcodeid = ce.referraltype and isnull(gc2.recorddeleted, 'N')= 'N'
where ce.initialrequestdate >= @StartDate
and ce.initialrequestdate <= @EndDate
and isnull(c.recorddeleted, 'N')= 'N'
and isnull(ce.recorddeleted, 'N')= 'N'
order by gc2.codename

update r
set r.PrimaryCoveragePlan = cp.displayas
from #Report r
join ClientCoveragePlans ccp with(nolock) on ccp.ClientId = r.ClientID
join ClientCoverageHistory cch with(nolock) on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
join CoveragePlans cp with(nolock) on cp.CoveragePlanId = ccp.CoveragePlanId
where cch.StartDate <= convert(varchar(100), @EndDate, 101)
and (cch.EndDate is null or cch.EndDate >= convert(varchar(100), @StartDate, 101))
and cch.COBOrder = 1
and isnull(cp.RecordDeleted, 'N')= 'N'
and isnull(ccp.RecordDeleted, 'N')= 'N'
and isnull(cch.RecordDeleted, 'N')= 'N'



update r
set r.AssessmentDocumentId = d.DocumentId,
r.AssessmentEffectiveDate = d.EffectiveDate,
r.AssessmentReferralType = gc.CodeName
From #Report r
Join documents d with(nolock) on d.ClientId = r.ClientId
join CustomHRMAssessments a with(nolock) on a.DocumentVersionId = d.CurrentDocumentVersionId
left join globalcodes gc with(nolock) on gc.globalcodeid = a.referraltype
Where d.DocumentCodeId in (349,1469)
and d.status in (22)
and d.EffectiveDate >= r.InitialRequestDate
and d.EffectiveDate <= @EndDate
and not exists (select 1 from documents d2
				where d2.ClientId = d.ClientId
				and d2.DocumentCodeId in (349,1469)
				and d2.Status = 22
				and d2.EffectiveDate >= r.InitialRequestDate
				and d2.EffectiveDate <= @EndDate
				and d2.EffectiveDate > d.EffectiveDate
				and isnull(d2.RecordDeleted, 'N') = 'N')
and isnull(d.RecordDeleted, 'N')= 'N'
and isnull(a.RecordDeleted, 'N')= 'N'
and isnull(gc.RecordDeleted, 'N')= 'N'



Select ReferralType, ReferralSource, ClientId, EpisodeNumber,  ClientName, Active, InitialRequestDate, PrimaryClinician, PrimaryCoveragePlan,
AssessmentDocumentId,AssessmentEffectiveDate, AssessmentReferralType
 
from #Report
order by 1,2, 5,AssessmentReferralType
--drop table #Report


GO

