/****** Object:  StoredProcedure [dbo].[csp_JobFixClientBalances]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobFixClientBalances]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobFixClientBalances]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobFixClientBalances]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_JobFixClientBalances]  
  
as  
/*  
 12.27.2012 avoss added  
*/  
  
create table #ARLedger (
ClientId        int     null,
ARLedgerAmount  money   null)

create table #Payments (
ClientId        int     null,
PaymentAmount   money   null,
RefundAmount    money   null)

insert into #ARLedger (
       ClientId,
       ARLedgerAmount)
select ar.ClientId,
       sum(Amount)
  from ARLedger ar
	join charges ch on ch.chargeid = ar.chargeid
	join services s on s.serviceid = ch.serviceid
 where isnull(ar.RecordDeleted, ''N'') = ''N''
   and CoveragePlanId is null
   and LedgerType <> 4202 -- Exclude payments
	and isnull(s.RecordDeleted, ''N'')= ''N''
	and s.status in (75)
 group by ar.ClientId

if @@error <> 0 goto error

insert into #Payments (
       ClientId,
       PaymentAmount)
select ClientId,
       sum(Amount)
  from Payments
 where isnull(RecordDeleted, ''N'') = ''N''
   and ClientId is not null
 group by ClientId

if @@error <> 0 goto error

update pa
   set RefundAmount = rf.RefundAmount
  from #Payments pa
       join (select p.ClientId,
                    sum(r.Amount) as RefundAmount
               from Payments p
                    join Refunds r on r.PaymentId = p.PaymentId
               where isnull(p.RecordDeleted, ''N'') = ''N''
                 and isnull(r.RecordDeleted, ''N'') = ''N''
                 and p.ClientId is not null
               group by p.ClientId) as rf on rf.ClientId = pa.ClientId 

if @@error <> 0 goto error

insert into #ARLedger (
       ClientId,
       ARLedgerAmount)
select ClientId,
       null
  from #Payments p
 where not exists(select * from #ARLedger arl where arl.ClientId = p.ClientId)

if @@error <> 0 goto error

begin tran

update c
   set CurrentBalance = 0,
       ModifiedBy = ''sa'',
       ModifiedDate = GetDate()
  from Clients c
 where not exists(select * 
                    from #ARLedger arl
                   where arl.ClientId = c.ClientId)
   and isnull(c.CurrentBalance, 0) <> 0

if @@error <> 0 goto error

update c
   set CurrentBalance = isnull(arl.ARLedgerAmount, 0) - isnull(p.PaymentAmount, 0) + isnull(p.RefundAmount, 0)
--       ModifiedBy = ''sa'',
--       ModifiedDate = GetDate()
  from Clients c
       join #ARLedger arl on arl.ClientId = c.ClientId
       left join #Payments p on p.ClientId = c.ClientId
 where isnull(arl.ARLedgerAmount, 0) - isnull(p.PaymentAmount, 0) + isnull(p.RefundAmount, 0) <> isnull(c.CurrentBalance, 0)

if @@error <> 0 goto error

/*
select c.ClientId, c.CurrentBalance, 
       isnull(arl.ARLedgerAmount, 0) - isnull(p.PaymentAmount, 0) + isnull(p.RefundAmount, 0),
       arl.ARLedgerAmount, p.PaymentAmount, p.RefundAmount
  from Clients c
       join #ARLedger arl on arl.ClientId = c.ClientId
       left join #Payments p on p.ClientId = c.ClientId
 where isnull(arl.ARLedgerAmount, 0) - isnull(p.PaymentAmount, 0) + isnull(p.RefundAmount, 0) <> isnull(c.CurrentBalance, 0)
*/

commit tran

drop table #ARLedger
drop table #Payments


return

error:

if @@trancount > 1
  rollback tran

' 
END
GO
