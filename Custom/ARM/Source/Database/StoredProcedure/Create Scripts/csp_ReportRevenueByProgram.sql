/****** Object:  StoredProcedure [dbo].[csp_ReportRevenueByProgram]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenueByProgram]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportRevenueByProgram]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportRevenueByProgram]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        procedure [dbo].[csp_ReportRevenueByProgram]
@StartDate datetime = null,
@EndDate datetime = null
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

create table #results
(OrganizationName	varchar(100),
programName		varchar(100),
payer			varchar(100),
charges			money,
adjustments		money,
payments		money,
visits			int,
totalCharges		money,
totalAdjustments	money,
totalPayments		money,
totalVisits		int
)

insert into #results
(
OrganizationName,
programName,
payer,
charges,
adjustments,
payments,
visits
)
select
sc.OrganizationName,
programname, 
isnull(pay.PayerName,''Client'') as ''Payer'',
sum(case when ar.ledgertype in (4201, 4204) then ar.amount else 0 end) as charges,
sum(case when ar.ledgertype = 4203 then ar.amount else 0 end) as adjustments,
sum(case when ar.ledgertype = 4202 then ar.amount else 0 end) as payments,
count(s.serviceid) as visits
from services s
join charges c on c.serviceid = s.serviceid
join arledger ar on ar.chargeid = c.chargeid
join programs p on p.programid = s.programid 
left outer join coverageplans cp on cp.coverageplanid = ar.coverageplanid
left join payers pay on isnull(pay.PayerId,0) = isnull(cp.PayerId,0)
cross join SystemConfigurations sc
where s.dateofservice >= @StartDate
and s.dateofservice <= dateadd(dd, 1, @EndDate)
and s.billable = ''y''
group by sc.OrganizationName,pay.PayerName,p.programname
order by pay.PayerName,p.programname

update a
set a.totalCharges = b.charges,
a.totalAdjustments = b.adjustments,
a.totalPayments	   = b.payments,
a.totalVisits	   = b.visits 
from #results a,
(select sum(charges) as charges, sum(adjustments) as adjustments, sum(payments) as payments, sum(visits) as visits from #results
) as b

select * from #results
' 
END
GO
