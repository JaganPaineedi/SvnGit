/****** Object:  StoredProcedure [dbo].[csp_ReportRevenue]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportRevenue]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     procedure [dbo].[csp_ReportRevenue]
@StartDate datetime = null,
@EndDate datetime = null,
@Capitated char(1) = null,
@Clinic char(1) = null
/********************************************************************************
-- Stored Procedure: csp_ReportRevenue               		
--
-- Creation Date:                                            	
--                                                                   		
-- Purpose: 
--										
-- Updates:                     		                                
-- Date        Author      Purpose
--
*********************************************************************************/
as


select programname, 
sum(case when ar.ledgertype in (4201, 4204) then ar.amount else 0 end) as charges,
sum(case when ar.ledgertype = 4203 then ar.amount else 0 end) as adjustments,
sum(case when ar.ledgertype = 4202 then ar.amount else 0 end) as payments,
count(s.serviceid) as visits
from services s
join charges c on c.serviceid = s.serviceid
join arledger ar on ar.chargeid = c.chargeid
join programs p on p.programid = s.programid 
left outer join coverageplans cp on cp.coverageplanid = ar.coverageplanid
where s.dateofservice >= @StartDate
and s.dateofservice <= dateadd(dd, 1, @EndDate)
and s.billable = ''y''
AND (      (@capitated = ''Y'' and cp.capitated = ''Y'')
        or (@capitated = ''N'' and isnull(cp.capitated, ''N'') = ''N'')
        or (@capitated = ''A'' and isnull(cp.capitated, ''N'') in (''Y'', ''N'')))
AND
       ((   @clinic = ''E'' and p.programid = 17)
        or (@clinic = ''A'' and p.programid = p.programid)
        or (@clinic = ''I'' and p.programid <> 17))		     
group by programname
order by programname
' 
END
GO
