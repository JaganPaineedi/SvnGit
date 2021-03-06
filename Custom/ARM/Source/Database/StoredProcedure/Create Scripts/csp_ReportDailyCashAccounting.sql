/****** Object:  StoredProcedure [dbo].[csp_ReportDailyCashAccounting]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDailyCashAccounting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDailyCashAccounting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDailyCashAccounting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--csp_ReportDailyCashAccounting ''7/3/2012'', ''7/3/2012''

create procedure [dbo].[csp_ReportDailyCashAccounting]
	@startDate datetime, 
	@endDate datetime
as

select p.PaymentId, 
	c.LastName + '', '' + c.FirstName + '' ('' + CAST(c.ClientId as varchar) + '')'' as ClientName,
	s.DateOfService, 
	ISNULL(cp.DisplayAs, ISNULL(pyr.PayerName, ''Self-Pay'')) as Payer,
	gcMethod.CodeName as PaymentMethod,
	gcSource.CodeName as PaymentSource,
	p.ReferenceNumber,
	ap.Description as AccountingPeriod,
	ar.CreatedBy,
	ar.Amount
from dbo.ARLedger as ar
join dbo.Payments as p on p.PaymentId = ar.PaymentId
join dbo.AccountingPeriods as ap on ap.AccountingPeriodId = ar.AccountingPeriodId
join dbo.Charges as chg on chg.ChargeId = ar.ChargeId
join dbo.Services as s on s.ServiceId = chg.ServiceId
join dbo.ProcedureCodes as pc on pc.ProcedureCodeId = s.ProcedureCodeId
join dbo.Clients as c on c.ClientId = s.ClientId
LEFT outer join dbo.GlobalCodes as gcSource on gcSource.GlobalCodeId = p.PaymentSource
LEFT outer join dbo.GlobalCodes as gcMethod on gcMethod.GlobalCodeId = p.PaymentMethod
LEFT outer join dbo.Payers as pyr on pyr.PayerId = p.PayerId
LEFT outer join dbo.CoveragePlans as cp on cp.CoveragePlanId = p.CoveragePlanId
where ap.EndDate >= @startDate
and ap.StartDate <= @endDate
--and p.Amount <> 0.0		-- This designates a refund for Harbor
and ISNULL(ar.RecordDeleted, ''N'') <> ''Y''
order by ap.Description, ClientName, c.ClientId

' 
END
GO
