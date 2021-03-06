/****** Object:  StoredProcedure [dbo].[csp_AutoPaymentPosting]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPaymentPosting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AutoPaymentPosting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPaymentPosting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   proc [dbo].[csp_AutoPaymentPosting] 
as
/*********************************************************************/
/* Stored Procedure: dbo.csp_AutoPaymentPosting                         */
/* Creation Date:    11/08/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */
/* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  11/08/06   JHB	  Created                                    */
/*********************************************************************/
create table #ChargesTemp
(ChargeId char(10) not null,
CoveragePlanId char(10) not null,
Balance money not null)

create table #Charges
(ChargeId int not null,
CoveragePlanId int not null,
Balance money not null)

create table #ChargesPaidAmount
(ChargeId int not null,
PaidAmount money null)

create table #CoveragePlanBalance
(CoveragePlanId int not null,
Balance money not null)

-- If there are unposted billing ledgers post them first
if exists (select * from CustomAutoPaymentCharges)
begin
	exec csp_AutoPaymentApplyPayment
	
	if @@error <> 0 goto error
end

-- Get a list from Billing Transaction Balance for all
-- transactions with a balance 
insert into #Charges
(ChargeId, CoveragePlanId, Balance)
select b.ChargeId, c.CoveragePlanId, a.Balance
from OpenCharges a
JOIN Charges b ON (a.ChargeId = b.ChargeId)
JOIN ClientCoveragePlans c ON (b.ClientCoveragePlanId = c.ClientCoveragePlanId)
JOIN Services d ON (b.ServiceId = d.ServiceId
and d.Status <> 76)
JOIN CoveragePlans e ON (c.CoveragePlanId = e.CoveragePlanId)
where d.DateOfService >= ''10/1/2002''
and b.ReadyToBill = ''Y''
and e.Capitated = ''Y''

if @@error <> 0 goto error

-- Get the current paid amount for Charges
-- where the balance amount is negative
/*
insert into #ChargesPaidAmount
(ChargeId, PaidAmount)
select a.ChargeId, sum(b.Amount)
from #Charges a
JOIN ARLedger b ON (a.ChargeId = b.ChargeId)
where a.Balance < 0
and b.LedgerType = 4202
group by a.ChargeId
*/

-- delete transactions where negative balance 
/*
delete a
from #Charges a
where a.Balance < 0
and not exists
(select * from #ChargesPaidAmount b 
where a.ChargeId = b.ChargeId
and -(b.PaidAmount) >= -(a.Balance))
*/

-- Sum up the balance for each transaction by coverage plan
-- Exclude Coverage Plan if balance < 0
insert into #CoveragePlanBalance
(CoveragePlanId, Balance)
select CoveragePlanId, sum(Balance)
from #Charges
group by CoveragePlanId
--having sum(Balance) > 0

if @@error <> 0 goto error

--delete from #Charges where coverage plan balance <= 0
delete a
from #Charges a
where not exists
(select * from #CoveragePlanBalance b 
where a.CoveragePlanId = b.CoveragePlanId)

if @@error <> 0 goto error

-- Create a payment record for each coverage plan
declare @PaymentId int, @CoveragePlanId int,  @FinancialActivityId int
declare @CheckNumber varchar(30), @CheckDate datetime, @Amount money


begin tran

if @@error <> 0 goto error

declare cur_Payment cursor for 
select CoveragePlanId, Balance
from #CoveragePlanBalance 

if @@error <> 0 goto rollback_tran

open cur_Payment

if @@error <> 0 goto rollback_tran

fetch cur_Payment into @CoveragePlanId, @Amount

if @@error <> 0 goto rollback_tran

while @@fetch_status = 0
begin
	select @CheckNumber = substring(convert(varchar,getdate(),101),7,4) 
	+ substring(convert(varchar,getdate(),101),1,2)
	+ substring(convert(varchar,getdate(),101),4,2), 
	@CheckDate = convert(varchar,getdate(),101)

	if @@error <> 0 goto rollback_tran

	Insert into FinancialActivities
	(CoveragePlanId, ActivityType, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	values (@CoveragePlanId, 4323, ''AUTOPAYMENT'', getdate(), ''AUTOPAYMENT'', getdate())

	set @FinancialActivityId = @@Identity
		
	if @FinancialActivityId <= 0
	begin
		rollback transaction
		raiserror 30001 ''Invalid Financial Activity Id''
		goto error
	end

	INSERT  INTO Payments ( FinancialActivityId, CoveragePlanId, DateReceived, 
	PaymentMethod, ReferenceNumber, Amount, PaymentSource, LocationId, UnpostedAmount,
	ElectronicPayment, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	values (@FinancialActivityId, @CoveragePlanId, @CheckDate, 4362, @CheckNumber,
	@Amount, 10404, 10492, @Amount, ''N'', ''AUTOPAYMENT'', getdate(), ''AUTOPAYMENT'', getdate())


	select @PaymentId = @@identity

	if @PaymentId <=0
	begin
		rollback transaction
		raiserror 30001 ''Invalid Payment ID''
		goto error
	end

	insert into CustomAutoPaymentCharges
	(PaymentId, FinancialActivityId, ChargeId, Amount)
	select @PaymentId, @FinancialActivityId, ChargeId, Balance
	from #Charges
	where CoveragePlanId = @CoveragePlanId

	if @@error <> 0 goto rollback_tran

	fetch cur_Payment into @CoveragePlanId, @Amount

	if @@error <> 0 goto rollback_tran

end

close cur_Payment

if @@error <> 0 goto rollback_tran

deallocate cur_Payment

if @@error <> 0 goto rollback_tran

commit tran

if @@error <> 0 goto rollback_tran

-- Apply payments to transactions
exec csp_AutoPaymentApplyPayment
	
if @@error <> 0 goto error

return

rollback_tran:

rollback transaction

return

error:
' 
END
GO
