/****** Object:  StoredProcedure [dbo].[csp_ReportClientPaymentsReceivedByDateToServicesByDate]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientPaymentsReceivedByDateToServicesByDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientPaymentsReceivedByDateToServicesByDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientPaymentsReceivedByDateToServicesByDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportClientPaymentsReceivedByDateToServicesByDate]
/***************************************************************************/
/* PROCEDURE: csp_ReportClientPaymentsReceivedByDateToServicesByDate       */
/*                                                                         */
/* Purpose: Return Client payments received between @startPaymentDate      */
/* and @endPaymentDate that were applied to services that occurred         */
/* between @startDateOfService and @endDateOfService.                      */
/*                                                                         */
/* Required to fulfill requirements of an audit.                           */
/*                                                                         */
/* History:                                                                */
/*    TER - 1/13/2010 - Created                                            */
/***************************************************************************/

   @startDateOfService datetime,
   @endDateOfService datetime,
   @startPaymentDate datetime,
   @endPaymentDate datetime
as
select p.PaymentId, p.ClientId, p.DateReceived,  p.Amount, s.ServiceId, s.DateOfService, sum(ar.Amount) as PostedToService
from payments as p
join arledger as ar on ar.paymentid = p.paymentid
join charges as chg on chg.chargeid = ar.chargeid
join services as s on s.serviceid = chg.serviceid
where 
datediff(day, p.DateReceived, @startPaymentDate) <= 0
and datediff(day, p.DateReceived, @endPaymentDate) >= 0
and p.coverageplanid is null
and p.payerid is null
and datediff(day, s.dateofservice, @startDateOfService) <= 0
and datediff(day, s.dateofservice, @endDateOfService) >= 0
and isnull(p.recorddeleted, ''N'') <> ''Y''
and isnull(ar.recorddeleted, ''N'') <> ''Y''
and isnull(chg.recorddeleted, ''N'') <> ''Y''
and isnull(s.recorddeleted, ''N'') <> ''Y''
group by p.PaymentId, p.ClientId, p.DateReceived, p.Amount, s.ServiceId, s.DateOfService
having sum(ar.amount) <> 0.0
order by 1,2,3
' 
END
GO
