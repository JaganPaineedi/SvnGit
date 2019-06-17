/****** Object:  StoredProcedure [dbo].[csp_ReportClientUnpostedPaymentsToApplyAgainst]    Script Date: 03/08/2012 16:34:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientUnpostedPaymentsToApplyAgainst]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[csp_ReportClientUnpostedPaymentsToApplyAgainst]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportClientUnpostedPaymentsToApplyAgainst]    Script Date: 03/08/2012 16:34:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ReportClientUnpostedPaymentsToApplyAgainst]
AS

select s.clientid as 'ClientID', 
	   c1.lastname + ', ' + c1.firstname as 'ClientName', 
       sum(ar.amount) as 'UnpaidAmount' 
from services s
join clients c1 on c1.clientid = s.clientid
join charges ch on s.serviceid = ch.serviceid
join arledger ar on ar.chargeid = ch.chargeid
where s.clientid in (select c.clientid from clients c
					 join payments p on c.clientid = p.clientid
					 and p.unpostedamount <> 0
					 and isnull(c.recorddeleted, 'N') = 'N'
					 and isnull(p.recorddeleted, 'N') = 'N')
and ch.priority = 0
and isnull(s.recorddeleted, 'N') = 'N'
and isnull(ar.recorddeleted, 'N') = 'N'
and isnull(ch.recorddeleted, 'N') = 'N'
group by s.clientid,  c1.lastname + ', ' + c1.firstname
having sum(ar.amount) <> 0
order by c1.lastname + ', ' + c1.firstname

GO


