/****** Object:  StoredProcedure [dbo].[csp_ReportSpendDown]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportSpendDown]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportSpendDown]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportSpendDown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE           procedure [dbo].[csp_ReportSpendDown]
	@Month 	int,
	@Year	int
AS


select distinct 
Case when deductibleMet = ''N'' then 3
	when DeductibleMet = ''Y'' then 2
	else 1
End as OrderBy, c.clientid, c.LastName +'', '' + c.Firstname as ClientName, c.Active as ClientActive, cp.displayas, ccp.InsuredId,
cmd.deductibleMonth, cmd.DeductibleYear, 
Case when deductibleMet = ''N'' then ''Never''
	when DeductibleMet = ''Y'' then ''Yes''
	else ''Unknown''
End as DeductibleMet, DateMet

from clients c
join clientcoverageplans ccp on ccp.clientid = c.clientid
join clientcoveragehistory ch on ch.clientcoverageplanid = ccp.clientcoverageplanid
join coverageplans cp on cp.coverageplanid = ccp.coverageplanid
left join clientmonthlydeductibles cmd on cmd.clientcoverageplanid = ccp.clientCoveragePlanId 
					and cmd.DeductibleYear = @Year
					and cmd.DeductibleMonth = @Month
					and isnull(cmd.Recorddeleted, ''N'') = ''N''
where clientHasMonthlyDeductible = ''Y''
and datepart(mm, ch.startdate) <= @Month
and datepart(yy, ch.startdate) <= @Year
and (enddate is null or (datepart(yy, ch.enddate) >= @Year
			and
			 datepart(mm, ch.enddate) >= @Month
			)
	)
and isnull(c.recorddeleted, ''N'') = ''N''
and isnull(ccp.recorddeleted, ''N'') = ''N''
and isnull(ch.recorddeleted, ''N'') = ''N''
and isnull(cp.recorddeleted, ''N'') = ''N''
order by 
Case when deductibleMet = ''N'' then 3
	when DeductibleMet = ''Y'' then 2
	else 1
End,  c.LastName +'', '' + c.Firstname, cp.displayas, c.active, ccp.insuredid, 
cmd.deductiblemonth, cmd.deductibleyear, datemet
' 
END
GO
