/****** Object:  StoredProcedure [dbo].[csp_ReportPaymentsByPayer]    Script Date: 04/18/2013 11:29:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPaymentsByPayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPaymentsByPayer]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportPaymentsByPayer]    Script Date: 04/18/2013 11:29:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportPaymentsByPayer]
	@startDate	smalldatetime,
	@endDate	smalldatetime,
	@EntryType	int
AS
select
sc.OrganizationName,
Isnull(gc.CodeName, 'Client') as 'Payer' , sum(p.amount) as Payments
from payments p
left join coveragePlans d on isnull(d.CoveragePlanId,0) = isnull(p.CoveragePlanId,0)
left join payers e on e.PayerId = isnull(d.PayerId,p.PayerId)
left join globalCodes gc on gc.globalCodeId = e.PayerType
cross join SystemConfigurations sc
where
(	(@EntryType = 0 --DateOfService
	AND p.DateReceived >= @StartDate
	AND p.DateReceived <= @EndDate)
	OR
	(@EntryType = 1 --PostedDate
	AND p.CreatedDate >= @StartDate
	AND p.CreatedDate <= dateadd(dd,1, @EndDate)
	OR
	(@EntryType = 2 --ReceivedDate
	AND p.DateReceived >= @StartDate
	AND p.DateReceived <= @EndDate) )
)
AND isnull(p.RecordDeleted, 'N') = 'N'
AND isnull(d.RecordDeleted, 'N') = 'N'
AND isnull(e.RecordDeleted, 'N') = 'N'
AND isnull(gc.RecordDeleted, 'N') = 'N'
group by gc.CodeName,sc.OrganizationName
order by 1









GO

