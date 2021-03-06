/****** Object:  StoredProcedure [dbo].[csp_AutoPaymentApplyPayment]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPaymentApplyPayment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AutoPaymentApplyPayment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AutoPaymentApplyPayment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  proc [dbo].[csp_AutoPaymentApplyPayment] 
as
/*********************************************************************/
/* Stored Procedure: dbo.csp_AutoPaymentApplyPayment                         */
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
/* 11/08/06   JHB	  Created                                    */
/*********************************************************************/
-- Apply payments to transactions
declare @ARLedgerId int, @ChargeId int
declare @PaymentId int, @ClientId int
declare @CoveragePlanId int, @DateOfService  datetime
declare @Amount money
declare @PostedDate datetime
declare @CurrentAccountingPeriodId int
declare @FinancialActivityId int
declare @FinancialActivityLineId int

select @PostedDate = getdate()

select @CurrentAccountingPeriodId = AccountingPeriodId   
from AccountingPeriods  
where StartDate <= getdate()  
and dateadd(dd, 1, EndDate) > getdate()  
  
if @@error <> 0 goto error  

declare cur_PostPayment insensitive cursor for
select a.PaymentId, a.ChargeId, a.FinancialActivityId, c.ClientId, d.CoveragePlanId,
c.DateOfService, -a.Amount
from CustomAutoPaymentCharges a
JOIN Charges b ON (a.ChargeId = b.ChargeId)
JOIN Services c ON (b.ServiceId = c.ServiceId)
JOIN ClientCoveragePlans d ON (b.ClientCoveragePlanId = d.ClientCoveragePlanId)
order by a.PaymentId, a.Amount 

if @@error <> 0 goto error

open cur_PostPayment

if @@error <> 0 goto error

fetch cur_PostPayment into @PaymentId, @ChargeId, @FinancialActivityId, @ClientId, @CoveragePlanId,
@DateOfService, @Amount

if @@error <> 0 goto error

while @@fetch_status = 0
begin

if @Amount <> 0
begin	
	begin tran

	INSERT INTO FinancialActivityLines
	(FinancialActivityId, CurrentVersion, ChargeId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	values (@FinancialActivityId, 1, @ChargeId, ''AUTOPAYMENT'',getdate(),''AUTOPAYMENT'',getdate())

	set @FinancialActivityLineId = @@Identity

	if @@error <> 0 goto rollback_tran

	if @FinancialActivityLineId <= 0
	begin
		rollback transaction
		raiserror 30001 ''Invalid Financial Activity Line Id''
		goto error
	end

	INSERT INTO ARLedger 
	(ChargeId, FinancialActivityLineId, FinancialActivityVersion, LedgerType,
	Amount, PaymentId, AccountingPeriodId, PostedDate, ClientId, CoveragePlanId, 
	DateOfService, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	values
	(@ChargeId, @FinancialActivityLineId, 1, 4202,
	@Amount, @PaymentId, @CurrentAccountingPeriodId, @PostedDate,
	@ClientId, @CoveragePlanId, 
	@DateOfService, ''AUTOPAYMENT'', getdate(), ''AUTOPAYMENT'', getdate())

	if @@error <> 0 goto rollback_tran

	if exists (select * from OpenCharges where ChargeId = @ChargeId 
			and Balance = -@Amount)
	begin
		delete from OpenCharges where ChargeId = @ChargeId

		if @@error <> 0 goto rollback_tran
	end
	else if exists (select * from OpenCharges where ChargeId = @ChargeId)
	begin
		update OpenCharges 
		set Balance  = Balance + @Amount, ModifiedBy = ''AUTOPAYMENT'', ModifiedDate = getdate()
		where ChargeId = @ChargeId

		if @@error <> 0 goto rollback_tran
	end
	else
	begin
		insert into OpenCharges
		(ChargeId, Balance, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
		values (@ChargeId, @Amount, ''AUTOPAYMENT'', getdate(), ''AUTOPAYMENT'', getdate())
		
		if @@error <> 0 goto rollback_tran
	end

	update Payments
	set UnpostedAmount = UnpostedAmount + @Amount, ModifiedBy = ''AUTOPAYMENT'', ModifiedDate = getdate()
	where PaymentId = @PaymentId

	if @@error <> 0 goto rollback_tran

	delete from CustomAutoPaymentCharges
	where PaymentId = @PaymentId
	and ChargeId = @ChargeId

	if @@error <> 0 goto rollback_tran

	commit tran

	if @@error <> 0 goto rollback_tran

end -- if @@Amount <> 0

fetch cur_PostPayment into @PaymentId, @ChargeId, @FinancialActivityId, @ClientId, @CoveragePlanId,
@DateOfService, @Amount

end

close cur_PostPayment

if @@error <> 0 goto error

deallocate cur_PostPayment

if @@error <> 0 goto error

delete from CustomAutoPaymentCharges
where Amount = 0

if @@error <> 0 goto error

return

rollback_tran:

rollback transaction

return

error:
' 
END
GO
