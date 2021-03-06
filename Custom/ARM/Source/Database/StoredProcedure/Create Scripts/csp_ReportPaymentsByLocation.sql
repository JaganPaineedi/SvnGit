/****** Object:  StoredProcedure [dbo].[csp_ReportPaymentsByLocation]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPaymentsByLocation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPaymentsByLocation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPaymentsByLocation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE       procedure [dbo].[csp_ReportPaymentsByLocation]
	@startDate	smalldatetime,
	@endDate	smalldatetime
AS
select DateReceived, gc2.CodeName as LocationId, 
--case when gc3.CodeName as PaymentSource, 
case when p.PaymentMethod in (4363, 10379) then ''Credit Card''  else ''Cash'' end as Instrument,  
sum(p.amount) as amount
from payments p
left join globalcodes gc on gc.GlobalCodeId = p.PaymentMethod
left join globalcodes gc2 on gc2.GlobalCodeId = p.LocationId
--left join globalcodes gc3 on gc3.GlobalCodeId = p.PaymentSource
where DateReceived >=  @StartDate
AND DateReceived <= @EndDate
AND isnull(p.RecordDeleted, ''N'') = ''N''
AND isnull(gc.RecordDeleted, ''N'') = ''N''
AND isnull(gc2.RecordDeleted, ''N'') = ''N''
group by DateReceived, gc2.Codename, case when p.PaymentMethod in (4363, 10379) then ''Credit Card'' else ''Cash'' end
having sum(p.amount) <> 0
order by 1, case when gc2.Codename like ''%auto%'' then ''aa'' else gc2.codename end
' 
END
GO
