/****** Object:  StoredProcedure [dbo].[csp_ReportNonCompletedBillableByTeam]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNonCompletedBillableByTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportNonCompletedBillableByTeam]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNonCompletedBillableByTeam]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE          procedure [dbo].[csp_ReportNonCompletedBillableByTeam]
	@StartDate	smalldatetime,
	@EndDate	smalldatetime,
	@Capitated	char(1)
AS
select isnull(gc.codename, ''Unknown'') as Team, ps.lastname + '', '' + ps.firstname as PrimaryName, p.programcode, s.dateofService, 
s.clientid, c.lastname + '', '' + c.firstname as ClientName, pc.displayas, case when s.status = 71 then ''Show'' else NULL End as Status,
st.lastname + '', '' + st.firstname as StaffName, s.charge, isnull(cp.displayas, ''Client'') as PrimaryCoverage,
case when billingcodeunittype = ''P'' then convert(int, unit/billingcodeunits * billingcodeclaimunits)
            when billingcodeunittype = ''A'' then convert(int, billingcodeclaimunits) end as units 

 from services s
join programs p on p.programid = s.programid
join staff st on st.staffid = s.clinicianid
join clients c on c.clientid = s.clientid
left join staff ps on ps.staffid = c.primaryclinicianid
join procedurecodes pc on pc.procedurecodeid = s.procedurecodeid
left join globalcodes gc on gc.globalcodeid = p.programtype
LEFT OUTER JOIN ClientCoveragePlans csp on csp.ClientId = s.ClientId
		AND exists (select clientcoverageplanid from  ClientCoverageHistory cch 
       	        where cch.ClientCoveragePlanId = csp.ClientCoveragePlanId
                AND cch.StartDate <= s.DateOfService
                AND (cch.EndDate >= s.DateOfService OR cch.EndDate is NULL)
                AND COBOrder = 1
		AND isnull(cch.RecordDeleted, ''N'') = ''N''
			AND Not EXists (Select * from ClientCoveragePlans csp2
					Join ClientCoverageHistory cch2 on cch2.ClientCoveragePlanId = csp2.ClientCoveragePlanId
					where csp2.ClientId = csp.ClientId
					--and cch.ClientCoveragePlanId = csp.ClientCoveragePlanId
                			AND cch2.StartDate <= s.DateOfService
                			AND (cch2.EndDate >= s.DateOfService OR cch2.EndDate is NULL)
                			AND cch2.COBOrder = 1
					AND csp.ClientCoveragePlanId > csp2.ClientCoveragePlanId
					AND isnull(cch.RecordDeleted, ''N'') = ''N''))

LEFT OUTER JOIN CoveragePlans cp on cp.CoveragePlanId = csp.CoveragePlanId
left join procedurerates pr on pr.procedurerateid = s.procedurerateid
			and PR.FromDate <= s.DateOfService
			and (dateadd(dd, 1, PR.ToDate) > s.DateOfService or PR.ToDate is null)
			and (PR.ChargeType <> ''P'' or s.Unit >= PR.FromUnit)
			and (PR.ChargeType <> ''E'' or PR.FromUnit = s.Unit)
			and (PR.ChargeType <> ''R'' or (s.unit >= PR.FromUnit and s.Unit <= PR.ToUnit))
where s.status in (71)
--and billable = ''Y''
and s.DateOfService >= @StartDate
and s.DateOfService <= dateadd(dd, 1, @EndDate)
and (@Capitated = 0 --All
	OR
     @Capitated = 1 --Capitated
     and isnull(cp.Capitated, ''N'') = ''Y''
	OR
     @Capitated = 2 --NonCapitated
     and isnull(cp.Capitated, ''N'') = ''N''
    )
and exists (select serviceid from serviceerrors se
	      where se.serviceid = s.serviceid
	      and isnull(se.recorddeleted, ''N'') = ''N'')
and isnull(s.recorddeleted, ''N'') = ''N''
and isnull(p.recorddeleted, ''N'') = ''N''
and isnull(st.recorddeleted, ''N'') = ''N''
and isnull(c.recorddeleted, ''N'') = ''N''
and isnull(ps.recorddeleted, ''N'') = ''N''
and isnull(pc.recorddeleted, ''N'') = ''N''
and isnull(gc.recorddeleted, ''N'') = ''N''
order by gc.codename, p.programcode, st.lastname + '', '' + st.firstname, 
c.lastname + '', '' + c.firstname, s.dateofservice
' 
END
GO
