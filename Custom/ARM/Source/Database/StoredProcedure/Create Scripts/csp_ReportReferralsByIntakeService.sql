/****** Object:  StoredProcedure [dbo].[csp_ReportReferralsByIntakeService]    Script Date: 04/18/2013 11:42:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReferralsByIntakeService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportReferralsByIntakeService]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportReferralsByIntakeService]    Script Date: 04/18/2013 11:42:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE    procedure [dbo].[csp_ReportReferralsByIntakeService]
@StartDate datetime,
@EndDate datetime
AS


Create table #Report
(ClientId int,
 EpisodeNumber int,
 Active char(1),
 ClientName varchar(300),
 ReferralType varchar(150),
 ReferralSource varchar(150),
 PrimaryClinician varchar(200),
 PrimaryCoveragePlan varchar(100),
  ProcedureCode varchar(150),
 Program varchar(150),
 DateOfService datetime,
 Status varchar(100),
 CreatedDate datetime,
 CreatedBy varchar(100))

Insert into #Report
(ClientId ,
 EpisodeNumber ,
 Active, 
 ClientName ,
 ReferralType ,
 ReferralSource ,
 PrimaryClinician,
 ProcedureCode,
 Program,
 DateOfService,
 Status,
 CreatedDate,
 CreatedBy
  )

select c.clientid, ce.episodeNumber, c.active, c.lastname + ',' + c.firstname,
isnull(gc2.codename, 'Unknown'), gc.codename , st.LastName + ', ' + st.firstname,
pc.displayas,p.programcode, s.dateofservice,gc3.codename as status, 
  s.createddate, s.createdby
 from services s
join programs p on p.programid = s.programid
join clients c on c.clientid = s.clientid
join procedurecodes pc on pc.procedurecodeid = s.procedurecodeid
left join clientepisodes ce on ce.clientid = c.clientid and ce.episodenumber = c.currentepisodenumber
left join staff st on st.staffid = c.primaryclinicianid
left join globalcodes gc on gc.globalcodeid = ce.referralsource
left join globalcodes gc2 on gc2.globalcodeid = ce.referraltype
left join globalcodes gc3 on gc3.globalcodeid = s.status
where pc.category1 in (10509)
and s.dateofservice >= @StartDate
and s.dateofservice <= @EndDate
and s.status in (71, 75, 72, 73)
and isnull(s.recorddeleted, 'N')= 'N'
order by p.programcode,isnull(gc2.codename, 'Unknown'), c.lastname + ',' + c.firstname, gc.codename, s.dateofservice


update r
set r.PrimaryCoveragePlan = cp.displayas
from #Report r
join ClientCoveragePlans ccp on ccp.ClientId = r.ClientID
join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
where cch.StartDate <= convert(varchar(100), getdate(), 101)
and (cch.EndDate is null or cch.EndDate >= convert(varchar(100), getdate(), 101))
and cch.COBOrder = 1
and isnull(cp.RecordDeleted, 'N')= 'N'
and isnull(ccp.RecordDeleted, 'N')= 'N'
and isnull(cch.RecordDeleted, 'N')= 'N'

Select ReferralType, ReferralSource, ClientId, EpisodeNumber,  ClientName, Active, PrimaryClinician, PrimaryCoveragePlan, 
 ProcedureCode,
 Program,
 DateOfService,
 Status,
 CreatedDate,
 CreatedBy
 from #Report
order by 1,2, 5
--drop table #Report

GO

