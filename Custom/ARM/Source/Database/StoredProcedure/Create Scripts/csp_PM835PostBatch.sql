/****** Object:  StoredProcedure [dbo].[csp_PM835PostBatch]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PM835PostBatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PM835PostBatch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PM835PostBatch]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_PM835PostBatch] @ERBatchId int,@PaymentIdNew INT
AS
/*********************************************************************/
/* Stored Procedure: csp_835_post_batch                   */
/* Creation Date:    8/07/01                                         */
/*                                                                   */
/* Purpose:          		     */
/*                                                                   *//* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:        SQL Server task scheduler			     */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date		Author      Purpose                                    */
/*  8/07/01		JHB			Created                                    */
/*  1/16/04		JHB			Modified to post refunds from current Payment */
/*  8/15/06		TER			Added Adjustment posting logic.			*/
/*  03/28/12	MSuma		Fixed to correct incorrect FinancialActivityLines in Ledgers	*/

/*********************************************************************/


declare @ClaimLineItemId int
declare @PayerClaimNumber varchar(30)
declare @CheckNumber varchar(30)
declare @CheckDate datetime
declare @Amount decimal(10,2)
declare @TotalExpected decimal(10,2)
declare @TotalClaimPayments decimal(10,2)
declare @PaymentAmount decimal(10,2)
declare @PostedAmount decimal(10,2)
declare @ExpectedSoFar decimal(10,2)
declare @ErrorNo int
declare @ErrorMessage varchar(250)
declare @PayorId char(10)
declare @CoveragePlanId char(10)
--declare @hosp_status_code char(2)
declare @ChargeId char(10)
declare @ARLedgerId char(10)
declare @Status char(10)
declare @PaymentId int
declare @OriginalPaymentId int
declare @ClientId char(10)
declare @EpisodeNumber char(3)
declare @LastClaimLineItemId int
declare @LastPaymentId int
declare @LastClaimItemOk char(1)
declare @PaidAmount decimal(10,2)
declare @ClientIdentifier char(10)
declare @ServiceFromDate datetime
declare @ChargeAmount decimal(10,2)
declare @DateCreated datetime
declare @FailedCount int
declare @TotalImport int
declare @ExpectedPayment decimal(10,2)
declare @ClaimLineItemBalance decimal(10,2)
declare @TransferAmount decimal(10,2)
declare @AdjustmentAmount decimal(10,2)
declare @StandardBillingTransactionNo char(10)
declare @BLType char(2)
declare @CheckNo varchar(30)
declare @RefundId int
declare @CurrentDate datetime
declare @DenialCode char(10) 
declare @BeginOldErrorRecords int
declare @EndOldErrorRecords int
declare @Result varchar(1000)
declare @OldErrorRecords int 
declare @NewRecords int 
declare @NewErrorRecords int 
declare @CheckNumber2 varchar(30)
declare @PaymentId2 int
declare @CheckDate2 datetime
declare @FinancialActivityId int
declare @FinancialActivityLineId int
declare @DateOfService datetime
declare @UserCode varchar(max)
declare @AdjustmentCode varchar(max)
declare @ERClaimLineItemId int
declare @ApplyAdjustments char(1)
declare @ApplyTransfers char(1)
declare @ServiceId int
declare @ProcedureCodeId int
declare @ClinicianId int
declare @ClientCoveragePlanId int
declare @TransferTo int
declare @Transfer1 money
declare @TransferCode1 int
Declare @MinERClaimLineAdjustmentId int
Declare @MaxERClaimLineAdjustmentId int
Declare @CurrentERClaimLineAdjustmentId int


Set @UserCode = 1  --srf ?? FIx


set @ApplyAdjustments = isnull((Select a.ApplyAdjustments
								From ERFiles a
								Join ERBatches b on a.ERFileId = b.ERFileId
								Where b.ERBatchId = @ERBatchId
								and isnull(a.RecordDeleted, ''N'')= ''N''
								and isnull(b.RecordDeleted, ''N'') =''N''
								)
								, ''N'')
								
set @ApplyTransfers = isnull((Select a.ApplyTransfers
								From ERFiles a
								Join ERBatches b on a.ERFileId = b.ERFileId
								Where b.ERBatchId = @ERBatchId
								and isnull(a.RecordDeleted, ''N'')= ''N''
								and isnull(b.RecordDeleted, ''N'') =''N''
								)
								, ''N'')


create table #LineItemBalance
(ClaimLineItemId int not null,
BalanceAmount decimal(10,2) not null,
MaxBalanceChargeId char(10) null)

create table #LineItemPaid
(ClaimLineItemId int not null,
PaidAmount decimal(10,2) not null,
BalanceAmount decimal(10,2) null,
PaidBalanceDifference decimal(10,2) null)

create table #LineItemAdjustment
(ClaimLineItemId int not null,
AdjustmentAmount decimal(10,2) not null,
BalanceAmount decimal(10,2) null,
PaidAdjustmentDifference decimal(10,2) null)


create table #LineItemTransfer
(ClaimLineItemId int not null,
TransferAmount decimal(10,2) not null
)


create table #LineItemTempBalance
(ClaimLineItemId int not null,
BalanceAmount decimal(10,2) not null)

create table #LineItemChargeAmount
(ClaimLineItemId int not null,
PayerClaimNumber varchar(30) null,
ChargeId char(10) not null,
BalanceAmount decimal(10,2) not null,
TransactionCount int not null,
Payment decimal(10,2) null,
Transfer decimal(10,2) null,
Adjustment decimal(10,2) null,
PaymentId int null,
StandardChargeId char(10) null,
OriginalPaymentId int null,
DenialCode char(10) null)

-- Insert Payments
begin tran

if @@error <> 0 goto error

-- Calculate the paid amount for each line item
-- As they could be paid across multiple checks
insert into #LineItemPaid
(ClaimLineItemId, PaidAmount)
select a.ClaimLineItemId, isnull(sum(a.PaidAmount), 0.0)
from ERClaimLineItems a
where a.ERBatchId = @ERBatchId
group by a.ClaimLineItemId

if @@error <> 0 goto rollback_tran

-- Calculate the contractual Adjustments
insert into #LineItemAdjustment
(ClaimLineItemId, AdjustmentAmount)
select
a.ClaimLineItemId,isnull(sum(
	case when a.AdjustmentGroupCode11 <> ''CO'' then 0.0 else
		isnull(a.AdjustmentAmount11, 0.0) + isnull(a.AdjustmentAmount12, 0.0) + isnull(a.AdjustmentAmount13, 0.0) + isnull(a.AdjustmentAmount14, 0.0)
	end +
	case when a.AdjustmentGroupCode21 <> ''CO'' then 0.0 else
		isnull(a.AdjustmentAmount21, 0.0) + isnull(a.AdjustmentAmount22, 0.0) + isnull(a.AdjustmentAmount23, 0.0) + isnull(a.AdjustmentAmount24, 0.0)
	end +
	case when a.AdjustmentGroupCode31 <> ''CO'' then 0.0 else
		isnull(a.AdjustmentAmount31, 0.0) + isnull(a.AdjustmentAmount32, 0.0) + isnull(a.AdjustmentAmount33, 0.0) + isnull(a.AdjustmentAmount34, 0.0)
	end +
	case when a.AdjustmentGroupCode41 <> ''CO'' then 0.0 else
		isnull(a.AdjustmentAmount41, 0.0) + isnull(a.AdjustmentAmount42, 0.0) + isnull(a.AdjustmentAmount43, 0.0) + isnull(a.AdjustmentAmount44, 0.0)
	end), 0.0)

from ERClaimLineItems a
where a.ERBatchId = @ERBatchId
group by a.ClaimLineItemId

if @@error <> 0 goto rollback_tran


-- Calculate the Patient Responsibility Transfers
insert into #LineItemTransfer
(ClaimLineItemId, TransferAmount)
select
a.ClaimLineItemId,isnull(sum(
	case when a.AdjustmentGroupCode11 <> ''PR'' then 0.0 else
		isnull(a.AdjustmentAmount11, 0.0) + isnull(a.AdjustmentAmount12, 0.0) + isnull(a.AdjustmentAmount13, 0.0) + isnull(a.AdjustmentAmount14, 0.0)
	end +
	case when a.AdjustmentGroupCode21 <> ''PR'' then 0.0 else
		isnull(a.AdjustmentAmount21, 0.0) + isnull(a.AdjustmentAmount22, 0.0) + isnull(a.AdjustmentAmount23, 0.0) + isnull(a.AdjustmentAmount24, 0.0)
	end +
	case when a.AdjustmentGroupCode31 <> ''PR'' then 0.0 else
		isnull(a.AdjustmentAmount31, 0.0) + isnull(a.AdjustmentAmount32, 0.0) + isnull(a.AdjustmentAmount33, 0.0) + isnull(a.AdjustmentAmount34, 0.0)
	end +
	case when a.AdjustmentGroupCode41 <> ''PR'' then 0.0 else
		isnull(a.AdjustmentAmount41, 0.0) + isnull(a.AdjustmentAmount42, 0.0) + isnull(a.AdjustmentAmount43, 0.0) + isnull(a.AdjustmentAmount44, 0.0)
	end), 0.0)

from ERClaimLineItems a
where a.ERBatchId = @ERBatchId
group by a.ClaimLineItemId

if @@error <> 0 goto rollback_tran
		
-- Calculate the balance for each billing transaction for each line item
insert into #LineItemChargeAmount
(ClaimLineItemId , PayerClaimNumber, ChargeId ,BalanceAmount, TransactionCount)
select a.ClaimLineItemId, a.PayerClaimNumber, c.ChargeId, 
sum(c.amount), count(distinct b.ChargeId)
from ERClaimLineItems a
JOIN ClaimLineItemCharges b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN ARLedger c ON (c.ChargeId = b.ChargeId)
JOIN Charges d ON (b.ChargeId = d.ChargeId)
JOIN Services e ON (d.ServiceId = e.ServiceId)
where e.status <> 76
and a.ERBatchId = @ERBatchId
and not exists
(select * from ERClaimLineItems z
where a.ClaimLineItemId = z.ClaimLineItemId
and a.ERBatchId = z.ERBatchId
and z.ERClaimLineItemId < a.ERClaimLineItemId)
group by a.ClaimLineItemId, a.PayerClaimNumber, c.ChargeId

if @@error <> 0 goto error

-- Compute the expected Payments for each line item
insert into #LineItemBalance
(ClaimLineItemId, BalanceAmount)
select a.ClaimLineItemId, isnull(sum(a.BalanceAmount), 0.0)
from #LineItemChargeAmount a
group by a.ClaimLineItemId

if @@error <> 0 goto rollback_tran

-- Insert into Error table claims where "sum" of paid amount 
-- is greater than the expected Payment
insert into ERClaimLineItemLog
(ERClaimLineItemId , ErrorFlag, ERMessageType, ERMessage)

select ERClaimLineItemId, ''Y'', 1, ''Total Paid amount is greater than expected Payment''
from ERClaimLineItems a
JOIN #LineItemBalance b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN #LineItemPaid z ON (b.ClaimLineItemId = z.ClaimLineItemId)
where a.ERBatchId = @ERBatchId
and z.PaidAmount > b.BalanceAmount
and z.PaidAmount > 0

if @@error <> 0 goto rollback_tran

/*
LOOK INTO
insert into ERClaimLineItemLog_BT
(ERBatchId, ClaimLineItemId , SequenceNumber, ChargeId , PaidAmount , error_no, remark ,
ClientId , episode_id , proc_code, hosp_status_code, proc_duration,
duration_type, proc_chron)
select a.ERBatchId, a.ClaimLineItemId, a.ERClaimLineItemId, c.ChargeId, a.PaidAmount, 120, 
''Paid amount is greater than expected Payment'', e.ClientId, e.episode_id,
f.proc_code, e.hosp_status_code, f.proc_duration, f.duration_type, f.proc_chron
from ERClaimLineItems a
JOIN #LineItemBalance b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN #LineItemPaid z ON (b.ClaimLineItemId = z.ClaimLineItemId)
JOIN ClaimLineItemCharges c ON (a.ClaimLineItemId = c.ClaimLineItemId)
JOIN Charges d ON (c.ChargeId = d.ChargeId)
JOIN Services e ON (d.ServiceId = e.ServiceId)
JOIN Group_Clin_Tran f ON (e.group_clin_tran_no = f.group_clin_tran_no)
where a.ERBatchId = @ERBatchId
and z.PaidAmount > b.BalanceAmount
and z.PaidAmount > 0
*/


if @@error <> 0 goto rollback_tran

-- Insert into Error table claims where "sum" of paid amount 
-- is less than the expected Payment
insert into ERClaimLineItemLog
(ERClaimLineItemId , ErrorFlag, ERMessageType, ERMessage)

select ERClaimLineItemId, ''Y'', 1, ''Total Paid amount is less than expected Payment''
from ERClaimLineItems a
JOIN #LineItemBalance b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN #LineItemPaid z ON (b.ClaimLineItemId = z.ClaimLineItemId)
where a.ERBatchId = @ERBatchId
and z.PaidAmount < b.BalanceAmount

if @@error <> 0 goto rollback_tran

/*
LOOK INTO
insert into ERClaimLineItemLog_BT
(ERBatchId, ClaimLineItemId , SequenceNumber, ChargeId , PaidAmount , error_no, remark ,
ClientId , episode_id , proc_code, hosp_status_code, proc_duration,
duration_type, proc_chron)
select a.ERBatchId, a.ClaimLineItemId, a.ERClaimLineItemId, c.ChargeId, a.PaidAmount, 120, 
''Paid amount is less than expected Payment'', e.ClientId, e.episode_id,
f.proc_code, e.hosp_status_code, f.proc_duration, f.duration_type, f.proc_chron
from ERClaimLineItems a
JOIN ClaimLineItemCharges c ON (a.ClaimLineItemId = c.ClaimLineItemId)
JOIN Charges d ON (c.ChargeId = d.ChargeId)
JOIN Services e ON (d.ServiceId = e.ServiceId)
JOIN Group_Clin_Tran f ON (e.group_clin_tran_no = f.group_clin_tran_no)
JOIN #LineItemBalance b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN #LineItemPaid z ON (b.ClaimLineItemId = z.ClaimLineItemId)
where a.ERBatchId = @ERBatchId
and z.PaidAmount < b.BalanceAmount
*/

commit tran -- balance amount different from paid amount

if @@error <> 0 goto rollback_tran

delete a
from #LineItemPaid a
where not exists 
(select * from ERClaimLineItems b
where a.ClaimLineItemId = b.ClaimLineItemId
and b.ERBatchId = @ERBatchId)

if @@error <> 0 goto error

-- Compute the balance amount for each line item
-- and the difference between the paid amount and the balance amount
update a
set BalanceAmount = b.BalanceAmount,
PaidBalanceDifference = a.PaidAmount - b.BalanceAmount
from #LineItemPaid a
JOIN #LineItemBalance b ON (a.ClaimLineItemId = b.ClaimLineItemId)

if @@error <> 0 goto error

-- For each billing transaction compute the amount Payment, Payment id 
-- The amount of Payment is equal to the balance of the billing transaction
update a
set Payment = a.BalanceAmount
from #LineItemChargeAmount a
JOIN #LineItemPaid b ON (a.ClaimLineItemId = b.ClaimLineItemId)

if @@error <> 0 goto error

update a
set PaymentId = c.PaymentId
from #LineItemChargeAmount a
JOIN #LineItemPaid b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN CustomERLineItemPaymentsTemp c ON (a.ClaimLineItemId = c.ClaimLineItemId)
where c.ERBatchId = @ERBatchId

if @@error <> 0 goto error

-- In case of overPayment or under Payment add the difference to the first
-- billing transaction linked to the line item
update a
set MaxBalanceChargeId = b.ChargeId
from #LineItemBalance a
JOIN #LineItemChargeAmount b ON (a.ClaimLineItemId = b.ClaimLineItemId)
where not exists
(select * from #LineItemChargeAmount c 
where a.ClaimLineItemId = c.ClaimLineItemId
and c.BalanceAmount > b.BalanceAmount)

if @@error <> 0 goto error

update a
set Payment = a.Payment + b.PaidBalanceDifference
from #LineItemChargeAmount a
JOIN #LineItemPaid b ON (a.ClaimLineItemId = b.ClaimLineItemId)
JOIN #LineItemBalance c ON (a.ClaimLineItemId = c.ClaimLineItemId
and a.ChargeId = c.MaxBalanceChargeId)

if @@error <> 0 goto error

--
-- Apply Adjustments to BT''s proportionately
--
update a set
	Adjustment = l.AdjustmentAmount * ( (a.BalanceAmount - a.Payment )/ lb.BalanceAmount)
from #LineItemChargeAmount as a
join #LineItemAdjustment as l on (l.ClaimLineItemId = a.ClaimLineItemId)
join #LineItemBalance as lb on (lb.ClaimLineItemId = l.ClaimLineItemId)
where
	lb.BalanceAmount <> 0

if @@error <> 0 goto error

--
-- Set Transfer Amount
--
update a set
	[Transfer] = isnull(l.TransferAmount, 0.0)
from #LineItemChargeAmount as a
join #LineItemTransfer as l on (l.ClaimLineItemId = a.ClaimLineItemId)



--
-- If line item balance is zero, copy the Adjustment to the max billing trans
--
update a set
	Adjustment = l.AdjustmentAmount
from #LineItemChargeAmount as a
join #LineItemAdjustment as l on (l.ClaimLineItemId = a.ClaimLineItemId)
JOIN #LineItemBalance c ON (a.ClaimLineItemId = c.ClaimLineItemId
and a.ChargeId = c.MaxBalanceChargeId)
where
	c.BalanceAmount = 0

if @@error <> 0 goto error

--
-- Handle possible rounding issues
--
create table #AdjustmentSplit
(
	ClaimLineItemId int,
	SumAdjustment money
)

if @@error <> 0 goto error

insert into #AdjustmentSplit
select ClaimLineItemId, isnull(sum(Adjustment), 0.0)
from #LineItemChargeAmount
group by ClaimLineItemId

update a
set Adjustment = a.Adjustment + (l.AdjustmentAmount - s.SumAdjustment)
from #LineItemChargeAmount a
JOIN #LineItemAdjustment l ON (a.ClaimLineItemId = l.ClaimLineItemId)
join #AdjustmentSplit as s on (s.ClaimLineItemId = a.ClaimLineItemId)
JOIN #LineItemBalance c ON (a.ClaimLineItemId = c.ClaimLineItemId
and a.ChargeId = c.MaxBalanceChargeId)

if @@error <> 0 goto error

-- if anything is left over after rounding, apply the remainder to the max
-- billing transaction

-- Post Payments and Adjustments
-- Post Payments a check at a time
select @LastPaymentId = -1

/*
declare cur_Payment INSENSITIVE cursor for
select distinct a.PaymentId, b.CheckNumber
from CustomERLineItemPaymentsTemp a
JOIN Payment b ON (a.PaymentId = b.PaymentId)
where a.ERBatchId = @ERBatchId

if @@error <> 0  goto error

open cur_Payment

if @@error <> 0  goto error

fetch next from cur_Payment into @PaymentId, @CheckNo

if @@error <> 0  goto error

while @@fetch_status = 0
begin
*/

--select * from charges
-- Read data from Import, Claim and Claim Billing Transaction table
--Added by MSuma to close cursor when a transaction fails inbetween
	  If Cursor_Status(''global'',''cur_import'')>=-1 BEGIN
		CLOSE cur_import
		DEALLOCATE cur_import
	 END
declare cur_import INSENSITIVE cursor for
select  a.ClaimLineItemId, a.PayerClaimNumber, isnull(a.Payment, 0.0), a.ChargeId, 
f.ClientId, --f.episode_id, srf
 g.CoveragePlanId, --e.hosp_status_code, srf,
 g.ClientCoveragePlanId,
 isnull(a.Adjustment, 0.0), isnull(a.Transfer, 0.0),
isnull(x.PaymentId, 0), x.ReferenceNumber
from #LineItemChargeAmount a
JOIN Payments x ON (a.PaymentId = x.PaymentId)
JOIN Charges e ON (a.ChargeId = e.ChargeId)
JOIN Services f ON (e.ServiceId = f.ServiceId)
Join ClientCoveragePlans g on g.ClientCoveragePlanId = e.ClientCoveragePlanId
order by isnull(x.PaymentId, 0), a.Payment, a.ClaimLineItemId


if @@error <> 0  goto error

open cur_import

if @@error <> 0 goto error

fetch next from cur_import
into @ClaimLineItemId, @PayerClaimNumber, @PaidAmount, @ChargeId, @ClientId, 
--@EpisodeNumber,
	@CoveragePlanId, @ClientCoveragePlanId,
--@hosp_status_code, 
@AdjustmentAmount, @TransferAmount, @PaymentId, @CheckNo

if @@error <> 0 goto error

while @@fetch_status = 0
begin 

if @LastPaymentId <> @PaymentId

select @LastClaimLineItemId = -1, @LastClaimItemOk = ''Y'', 
	@CurrentDate = convert(varchar,getdate(),101)

if @@error <> 0  goto error

--select @ClaimLineItemId, @LastClaimLineItemId

set @FinancialActivityId = null
set @FinancialActivityLineId = null
set @ARLedgerId = null
set @DateOfService = null

--select * from financialactivitylines
--select * from financialactivities

--Find DateOfService
	Set @DateOfService = (Select top 1 s.DateOfService From Services S Join Charges ch on ch.ServiceId = s.ServiceId where ChargeId= @ChargeId and isnull(ch.RecordDeleted, ''N'')= ''N'' and isnull(s.RecordDeleted, ''N'')= ''N'')

	Set @FinancialActivityId = (Select top 1 FinancialActivityId 
								From Payments a
								Join ERBatches b on b.PaymentId = a.PaymentId
								Join ERClaimLineItems  c on b.ERBatchId = c.ERBatchId	
								Where  
								c.ClaimLineItemId = @ClaimLineItemId
								--Added by MSuma to correct incorrect FinancialActivityLines in Ledgers
								AND b.ERBatchId = @ERBatchId
								And isnull(a.REcordDeleted, ''N'')= ''N''
								and isnull(b.RecordDeleted, ''N'')= ''N''
								and isnull(c.RecordDeleted, ''N'') = ''N'')
--select @FinancialActivityId
-- check if processing a new claim 
if @ClaimLineItemId <> @LastClaimLineItemId
begin 
	-- commit transaction for the last claim
	if @LastClaimLineItemId <> -1 and @LastClaimItemOk = ''Y''
	begin

/*
LOOK INTO
		update Cstm_Claim_Line_Item
		set status = ''PAID'',
		date_paid = getdate()
		where ClaimLineItemId = @LastClaimLineItemId
		
		if @@error <> 0 goto rollback_tran

		insert into ERClaimLineItems_Archive
		(ERBatchId ,ClaimLineItemId , SequenceNumber, patient_lname , patient_fname , ClientIdentifier ,
		PayerClaimNumber ,cpt_code , date_of_service, charge_amount ,PaidAmount ,
		AdjustmentGroupCode1, 
		AdjustmentReason11 , AdjustmentAmount11 , AdjustmentQuantity11 ,
		AdjustmentReason12 , AdjustmentAmount12 , AdjustmentQuantity12 ,
		AdjustmentReason13 , AdjustmentAmount13 , AdjustmentQuantity13 ,
		AdjustmentReason14 , AdjustmentAmount14 , AdjustmentQuantity14 ,
		AdjustmentGroupCode2, 
		AdjustmentReason21 , AdjustmentAmount21 , AdjustmentQuantity21 ,
		AdjustmentReason22 , AdjustmentAmount22 , AdjustmentQuantity22 ,
		AdjustmentReason23 , AdjustmentAmount23 , AdjustmentQuantity23 ,
		AdjustmentReason24 , AdjustmentAmount24 , AdjustmentQuantity24 ,
		AdjustmentGroupCode3, 
		AdjustmentReason31 , AdjustmentAmount31 , AdjustmentQuantity31 ,
		AdjustmentReason32 , AdjustmentAmount32 , AdjustmentQuantity32 ,
		AdjustmentReason33 , AdjustmentAmount33 , AdjustmentQuantity33 ,
		AdjustmentReason34 , AdjustmentAmount34 , AdjustmentQuantity34 ,
		AdjustmentGroupCode4, 
		AdjustmentReason41 , AdjustmentAmount41 , AdjustmentQuantity41 ,
		AdjustmentReason42 , AdjustmentAmount42 , AdjustmentQuantity42 ,
		AdjustmentReason43 , AdjustmentAmount43 , AdjustmentQuantity43 ,
		AdjustmentReason44 , AdjustmentAmount44 , AdjustmentQuantity44 ,
		AdjustmentGroupCode5, 
		AdjustmentReason51 , AdjustmentAmount51 , AdjustmentQuantity51 ,
		AdjustmentReason52 , AdjustmentAmount52 , AdjustmentQuantity52 ,
		AdjustmentReason53 , AdjustmentAmount53 , AdjustmentQuantity53 ,
		AdjustmentReason54 , AdjustmentAmount54 , AdjustmentQuantity54 ,
		date_processed)
		select ERBatchId ,ClaimLineItemId , ERClaimLineItemId, patient_lname , patient_fname , ClientIdentifier ,
		PayerClaimNumber ,cpt_code , date_of_service, charge_amount ,PaidAmount ,
		AdjustmentGroupCode1, 
		AdjustmentReason11 , AdjustmentAmount11 , AdjustmentQuantity11 ,
		AdjustmentReason12 , AdjustmentAmount12 , AdjustmentQuantity12 ,
		AdjustmentReason13 , AdjustmentAmount13 , AdjustmentQuantity13 ,
		AdjustmentReason14 , AdjustmentAmount14 , AdjustmentQuantity14 ,
		AdjustmentGroupCode2, 
		AdjustmentReason21 , AdjustmentAmount21 , AdjustmentQuantity21 ,
		AdjustmentReason22 , AdjustmentAmount22 , AdjustmentQuantity22 ,
		AdjustmentReason23 , AdjustmentAmount23 , AdjustmentQuantity23 ,
		AdjustmentReason24 , AdjustmentAmount24 , AdjustmentQuantity24 ,
		AdjustmentGroupCode3, 
		AdjustmentReason31 , AdjustmentAmount31 , AdjustmentQuantity31 ,
		AdjustmentReason32 , AdjustmentAmount32 , AdjustmentQuantity32 ,
		AdjustmentReason33 , AdjustmentAmount33 , AdjustmentQuantity33 ,
		AdjustmentReason34 , AdjustmentAmount34 , AdjustmentQuantity34 ,
		AdjustmentGroupCode4, 
		AdjustmentReason41 , AdjustmentAmount41 , AdjustmentQuantity41 ,
		AdjustmentReason42 , AdjustmentAmount42 , AdjustmentQuantity42 ,
		AdjustmentReason43 , AdjustmentAmount43 , AdjustmentQuantity43 ,
		AdjustmentReason44 , AdjustmentAmount44 , AdjustmentQuantity44 ,
		AdjustmentGroupCode5, 
		AdjustmentReason51 , AdjustmentAmount51 , AdjustmentQuantity51 ,
		AdjustmentReason52 , AdjustmentAmount52 , AdjustmentQuantity52 ,
		AdjustmentReason53 , AdjustmentAmount53 , AdjustmentQuantity53 ,
		AdjustmentReason54 , AdjustmentAmount54 , AdjustmentQuantity54 ,
		getdate()
		from ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId

		if @@error <> 0 goto rollback_tran

*/
/*
LOOK INTO
		delete ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId
*/
--instead of deleting, mark the erclaimlineitem to processed
		Update ERClaimLineItems
		set Processed = ''Y'',
		ProcessedDate = getdate()
		From ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId

		if @@error <> 0 goto rollback_tran


		insert into CustomERLineItemPayments
		(ClaimLineItemId, SequenceNumber, PaymentId, ERBatchId)
		select ClaimLineItemId, SequenceNumber, PaymentId, ERBatchId
		from CustomERLineItemPaymentsTemp
		where ClaimLineItemId = @LastClaimLineItemId
		and PaymentId = @LastPaymentId
		
		if @@error <> 0 goto rollback_tran

		delete from CustomERLineItemPaymentsTemp
		where ClaimLineItemId = @LastClaimLineItemId
		and PaymentId = @LastPaymentId

		if @@error <> 0 goto rollback_tran

		commit transaction

		if @@error <> 0 goto rollback_tran
	end --@LastClaimLineItemId <> -1 and @LastClaimItemOk = ''Y''
	else if @LastClaimItemOk = ''N''
	begin
/*
LOOK INTO
		delete ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId
*/
--instead of deleting, mark the erclaimlineitem to processed
		Update ERClaimLineItems
		set Processed = ''Y'',
		ProcessedDate = getdate()
		From ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId

		if @@error <> 0 goto rollback_tran

		commit transaction

		if @@error <> 0 goto rollback_tran
	end --else if @LastClaimItemOk = ''N''
	-- begin a new transaction for the current claim
	begin transaction

	if @@error <> 0 goto error

	select @LastClaimItemOk = ''Y''

end


if @LastClaimItemOk = ''N''
	goto fetch_next

if @PaidAmount <> 0
begin	

/*
LOOK INTO
	if @PaidAmount > 0
		select @BLType = ''CR''
	else 
		select @BLType = ''DB''

	if @@error <> 0 goto rollback_tran

--	exec csp_next_ARLedger_no @ARLedgerId = @ARLedgerId output

	if @@error <> 0 goto rollback_tran

	if convert(int,@ARLedgerId) <=0
	begin
		rollback transaction
		raiserror 30002 ''Invalid Billing Ledger Number''
		goto error
	end
*/

--select * from arledger

	
	
/*
	Insert Into FinancialActivities 
	(PayerId, CoveragePlanId, ClientId, ActivityType, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	Values
	(NULL, @CoveragePlanId, NULL, 4323, @UserCode, getdate(), @UserCode, getdate())

	Set @FinancialActivityId = @@Identity
*/

	Insert Into FinancialActivityLines
	(FinancialActivityId, ChargeId, CurrentVersion, Flagged, Comment, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	Values
	(@FinancialActivityId, @ChargeId, 1, NULL, NULL, @UserCode, getdate(), @UserCode, getdate())

	Set @FinancialActivityLineId = @@Identity

	Insert Into ARLedger
	(ChargeId, FinancialActivityLineId, FinancialActivityVersion, LedgerType, Amount, PaymentId, AdjustmentCode,
	AccountingPeriodId, PostedDate, ClientId, CoveragePlanId, DateOfService, MarkedAsError, ErrorCorrection,
	CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	Values
	(@ChargeId, @FinancialActivityLineId, 1, 4202, -@PaidAmount, @PaymentId, NULL,
	 25, --srf need to fix  find financial activity period
		getdate(), @ClientId, @CoveragePlanId, @DateOfService, ''N'', ''N'',
	@UserCode, getdate(), @UserCode, getdate())


	if @@error <> 0 goto rollback_tran

end -- @PaidAmount <> 0

if @AdjustmentAmount <> 0 and @ApplyAdjustments = ''Y''
begin	
/* 
LOOK INTO
	if @AdjustmentAmount > 0
		select @BLType = ''CR''
	else 
		select @BLType = ''DB''

	if @@error <> 0 goto rollback_tran

	exec csp_next_ARLedger_no @ARLedgerId = @ARLedgerId output

	if @@error <> 0 goto rollback_tran

	if convert(int,@ARLedgerId) <=0
	begin
		rollback transaction
		raiserror 30002 ''Invalid Billing Ledger Number''
		goto error
	end
*/



IF NOT Exists (Select * from FinancialActivityLines a
				Where a.FinancialActivityLineId = @FinancialActivityLineId
				and isnull(a.RecordDeleted, ''N'')= ''N''
				)
BEGIN
				
	Insert Into FinancialActivityLines
	(FinancialActivityId, ChargeId, CurrentVersion, Flagged, Comment, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
	Values
	(@FinancialActivityId, @ChargeId, 1, NULL, NULL, @UserCode, getdate(), @UserCode, getdate())

	Set @FinancialActivityLineId = @@Identity
END

set @DateOfService = null

--Find DateOfService
	Set @DateOfService = (Select top 1 s.DateOfService From Services S Join Charges ch on ch.ServiceId = s.ServiceId where ChargeId= @ChargeId and isnull(ch.RecordDeleted, ''N'')= ''N'' and isnull(s.RecordDeleted, ''N'')= ''N'')

	Insert Into ARLedger
	(ChargeId, FinancialActivityLineId, FinancialActivityVersion, LedgerType, Amount, PaymentId, AdjustmentCode,
	AccountingPeriodId, PostedDate, ClientId, CoveragePlanId, DateOfService, MarkedAsError, ErrorCorrection,
	CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)

	
	Select 
	@ChargeId, @FinancialActivityLineId, 1, 4203, -a.AdjustmentAmount, NULL, gc1.GlobalCodeId,
	 25, --srf need to fix  find financial activity period
		getdate(), @ClientId, @CoveragePlanId, @DateOfService, ''N'', ''N'',
	@UserCode, getdate(), @UserCode, getdate()
	From ERClaimLineItemAdjustments a
	Join ERClaimLineItems b on a.ERClaimLineItemId = b.ERClaimLineItemId
	Join GlobalCodes gc1 on gc1.Category = ''ADJUSTMENTCODE'' and ExternalCode2 = a.AdjustmentGroupCode and ExternalCode1 = a.AdjustmentReason
	Where b.ClaimLineItemId = @ClaimLineItemId
	and isnull(a.AdjustmentGroupCode, '''') = ''CO''
	and isnull(a.RecordDeleted, ''N'')= ''N''
	and isnull(b.RecordDeleted, ''N'')= ''N''
	and isnull(gc1.RecordDeleted, ''N'')= ''N''


/*
LOOK INTO
	INSERT INTO ARLedger 
	(ARLedger_no, ChargeId, ClientId, episode_id,
	CoveragePlanId, hosp_status_code, posted_date, accounting_date, type, subtype,
	amount, orig_user_id, orig_entry_chron, posted_by, entry_chron, DenialCode, remark)
	values
	(@ARLedgerId, @ChargeId, @ClientId, @EpisodeNumber,
	@CoveragePlanId, @hosp_status_code, getdate(),getdate(),@BLType,''CD'',
	-@AdjustmentAmount,''835PROC'',getdate(),''835PROC'',getdate(), @DenialCode, @PayerClaimNumber)
*/
	if @@error <> 0 goto rollback_tran

end -- @AdjustmentAmount <> 0 and @ApplyAdjustments = ''Y''


if @TransferAmount > 0 and @ApplyTransfers = ''Y''
begin



Select @ClientId = s.ClientId,
@ServiceId = s.ServiceId,
@ProcedureCodeId = s.ProcedureCodeId,
@DateOfService = s.DateOfService,
@ClinicianId = s.ClinicianId
From Services s
Join Charges ch on ch.ServiceId = s.ServiceId
Where ch.ChargeId = @ChargeId
and isnull(s.RecordDeleted, ''N'')= ''N''
and isnull(ch.RecordDeleted, ''N'')= ''N''




exec ssp_PMGetNextBillablePayer @ClientId = @ClientId, @ServiceId = @ServiceId,
	@DateOfService = @DateOfService, @ProcedureCodeId = @ProcedureCodeId,
	@ClinicianId = @ClinicianId, @ClientCoveragePlanId = @ClientCoveragePlanId,
	@NextClientCoveragePlanId = @TransferTo output





set  @MinERClaimLineAdjustmentId = (Select top 1 ERClaimLineItemAdjustmentId
									From ERClaimLineItemAdjustments a
									Join ERClaimLineItems b on a.ERClaimLineItemId = b.ERClaimLineItemId
									Join GlobalCodes gc1 on gc1.Category = ''ADJUSTMENTCODE'' and ExternalCode2 = a.AdjustmentGroupCode and ExternalCode1 = a.AdjustmentReason
									Where b.ClaimLineItemId = @ClaimLineItemId
									and isnull(a.AdjustmentGroupCode, '''') = ''PR''
									and isnull(a.RecordDeleted, ''N'')= ''N''
									and isnull(b.RecordDeleted, ''N'')= ''N''
									and isnull(gc1.RecordDeleted, ''N'')= ''N'' 
									Order by a.ERClaimLineItemAdjustmentId
									)


set  @MaxERClaimLineAdjustmentId = (Select top 1 ERClaimLineItemAdjustmentId
									From ERClaimLineItemAdjustments a
									Join ERClaimLineItems b on a.ERClaimLineItemId = b.ERClaimLineItemId
									Join GlobalCodes gc1 on gc1.Category = ''ADJUSTMENTCODE'' and ExternalCode2 = a.AdjustmentGroupCode and ExternalCode1 = a.AdjustmentReason
									Where b.ClaimLineItemId = @ClaimLineItemId
									and isnull(a.AdjustmentGroupCode, '''') = ''PR''
									and isnull(a.RecordDeleted, ''N'')= ''N''
									and isnull(b.RecordDeleted, ''N'')= ''N''
									and isnull(gc1.RecordDeleted, ''N'')= ''N'' 
									Order by a.ERClaimLineItemAdjustmentId desc
									)
									
set @CurrentERClaimLineAdjustmentId = @MinERClaimLineAdjustmentId


While @CurrentERClaimLineAdjustmentId <=	 @MaxERClaimLineAdjustmentId

Begin

	Select @Transfer1 = a.AdjustmentAmount,
	@TransferCode1 = gc1.GlobalCodeId
	From ERClaimLineItemAdjustments a
	Join ERClaimLineItems b on a.ERClaimLineItemId = b.ERClaimLineItemId
	Join GlobalCodes gc1 on gc1.Category = ''ADJUSTMENTCODE'' and ExternalCode2 = a.AdjustmentGroupCode and ExternalCode1 = a.AdjustmentReason
	Where b.ClaimLineItemId = @ClaimLineItemId
	and a.ERClaimLineItemAdjustmentId = @CurrentERClaimLineAdjustmentId
	and isnull(a.AdjustmentGroupCode, '''') = ''PR''
	and isnull(a.RecordDeleted, ''N'')= ''N''
	and isnull(b.RecordDeleted, ''N'')= ''N''
	and isnull(gc1.RecordDeleted, ''N'')= ''N''


exec ssp_PMPaymentAdjustmentPost @UserCode = @UserCode, @FinancialActivityId = @FinancialActivityId,
	@PaymentId = null, @FinancialActivityLineId = @FinancialActivityLineId, @ChargeId = @ChargeId, 
	@ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId,
	@CoveragePlanId = @CoveragePlanId, @Transfer1 = @Transfer1, 
	@TransferTo1 = @TransferTo, @TransferCode1 = @TransferCode1,
	@ERTransferPosting = ''Y''


Set @CurrentERClaimLineAdjustmentId = isnull((Select top 1 ERClaimLineItemAdjustmentId
									From ERClaimLineItemAdjustments a
									Join ERClaimLineItems b on a.ERClaimLineItemId = b.ERClaimLineItemId
									Join GlobalCodes gc1 on gc1.Category = ''ADJUSTMENTCODE'' and ExternalCode2 = a.AdjustmentGroupCode and ExternalCode1 = a.AdjustmentReason
									Where b.ClaimLineItemId = @ClaimLineItemId
									and isnull(a.AdjustmentGroupCode, '''') = ''PR''
									and isnull(a.RecordDeleted, ''N'')= ''N''
									and isnull(b.RecordDeleted, ''N'')= ''N''
									and isnull(gc1.RecordDeleted, ''N'')= ''N'' 
									and a.ERClaimLineItemAdjustmentId > @CurrentERClaimLineAdjustmentId
									Order by a.ERClaimLineItemAdjustmentId 
									), @CurrentERClaimLineAdjustmentId + 1)
	
									

End --While loop
 


End -- @ApplyTransfer

goto fetch_next

error_record:

select @LastClaimItemOk = ''N''

if @@error <> 0 goto rollback_tran

-- Get the next record

fetch_next:

select @LastClaimLineItemId = @ClaimLineItemId, @LastPaymentId = @PaymentId


fetch next from cur_import
into @ClaimLineItemId, @PayerClaimNumber, @PaidAmount, @ChargeId, @ClientId, 
--@EpisodeNumber,
	@CoveragePlanId, @ClientCoveragePlanId,
--@hosp_status_code, 
@AdjustmentAmount, @TransferAmount, @PaymentId, @CheckNo

if @@error <> 0 goto rollback_tran

end -- @@fetch_status = 0 for cur_import

if @LastClaimItemOk = ''Y'' and @LastClaimLineItemId <> -1
begin



	-- commit transaction for the last invoice
	if @LastClaimLineItemId <> -1 and @LastClaimItemOk = ''Y''
	begin
/*
LOOK INTO		update Cstm_Claim_Line_Item
		set status = ''PAID'',
		date_paid = getdate()
		where ClaimLineItemId = @LastClaimLineItemId

		if @@error <> 0 goto rollback_tran


		insert into ERClaimLineItems_Archive
		(ERBatchId ,ClaimLineItemId , SequenceNumber, patient_lname , patient_fname , ClientIdentifier ,
		PayerClaimNumber ,cpt_code , date_of_service, charge_amount ,PaidAmount ,
		AdjustmentGroupCode1, 
		AdjustmentReason11 , AdjustmentAmount11 , AdjustmentQuantity11 ,
		AdjustmentReason12 , AdjustmentAmount12 , AdjustmentQuantity12 ,
		AdjustmentReason13 , AdjustmentAmount13 , AdjustmentQuantity13 ,
		AdjustmentReason14 , AdjustmentAmount14 , AdjustmentQuantity14 ,
		AdjustmentGroupCode2, 
		AdjustmentReason21 , AdjustmentAmount21 , AdjustmentQuantity21 ,
		AdjustmentReason22 , AdjustmentAmount22 , AdjustmentQuantity22 ,
		AdjustmentReason23 , AdjustmentAmount23 , AdjustmentQuantity23 ,
		AdjustmentReason24 , AdjustmentAmount24 , AdjustmentQuantity24 ,
		AdjustmentGroupCode3, 
		AdjustmentReason31 , AdjustmentAmount31 , AdjustmentQuantity31 ,
		AdjustmentReason32 , AdjustmentAmount32 , AdjustmentQuantity32 ,
		AdjustmentReason33 , AdjustmentAmount33 , AdjustmentQuantity33 ,
		AdjustmentReason34 , AdjustmentAmount34 , AdjustmentQuantity34 ,
		AdjustmentGroupCode4, 
		AdjustmentReason41 , AdjustmentAmount41 , AdjustmentQuantity41 ,
		AdjustmentReason42 , AdjustmentAmount42 , AdjustmentQuantity42 ,
		AdjustmentReason43 , AdjustmentAmount43 , AdjustmentQuantity43 ,
		AdjustmentReason44 , AdjustmentAmount44 , AdjustmentQuantity44 ,
		AdjustmentGroupCode5, 
		AdjustmentReason51 , AdjustmentAmount51 , AdjustmentQuantity51 ,
		AdjustmentReason52 , AdjustmentAmount52 , AdjustmentQuantity52 ,
		AdjustmentReason53 , AdjustmentAmount53 , AdjustmentQuantity53 ,
		AdjustmentReason54 , AdjustmentAmount54 , AdjustmentQuantity54, 
		date_processed)
		select ERBatchId ,ClaimLineItemId , ERClaimLineItemId, patient_lname , patient_fname , ClientIdentifier ,
		PayerClaimNumber ,cpt_code , date_of_service, charge_amount ,PaidAmount ,
		AdjustmentGroupCode1, 
		AdjustmentReason11 , AdjustmentAmount11 , AdjustmentQuantity11 ,
		AdjustmentReason12 , AdjustmentAmount12 , AdjustmentQuantity12 ,
		AdjustmentReason13 , AdjustmentAmount13 , AdjustmentQuantity13 ,
		AdjustmentReason14 , AdjustmentAmount14 , AdjustmentQuantity14 ,
		AdjustmentGroupCode2, 
		AdjustmentReason21 , AdjustmentAmount21 , AdjustmentQuantity21 ,
		AdjustmentReason22 , AdjustmentAmount22 , AdjustmentQuantity22 ,
		AdjustmentReason23 , AdjustmentAmount23 , AdjustmentQuantity23 ,
		AdjustmentReason24 , AdjustmentAmount24 , AdjustmentQuantity24 ,
		AdjustmentGroupCode3, 
		AdjustmentReason31 , AdjustmentAmount31 , AdjustmentQuantity31 ,
		AdjustmentReason32 , AdjustmentAmount32 , AdjustmentQuantity32 ,
		AdjustmentReason33 , AdjustmentAmount33 , AdjustmentQuantity33 ,
		AdjustmentReason34 , AdjustmentAmount34 , AdjustmentQuantity34 ,
		AdjustmentGroupCode4, 
		AdjustmentReason41 , AdjustmentAmount41 , AdjustmentQuantity41 ,
		AdjustmentReason42 , AdjustmentAmount42 , AdjustmentQuantity42 ,
		AdjustmentReason43 , AdjustmentAmount43 , AdjustmentQuantity43 ,
		AdjustmentReason44 , AdjustmentAmount44 , AdjustmentQuantity44 ,
		AdjustmentGroupCode5, 
		AdjustmentReason51 , AdjustmentAmount51 , AdjustmentQuantity51 ,
		AdjustmentReason52 , AdjustmentAmount52 , AdjustmentQuantity52 ,
		AdjustmentReason53 , AdjustmentAmount53 , AdjustmentQuantity53 ,
		AdjustmentReason54 , AdjustmentAmount54 , AdjustmentQuantity54 ,
		getdate()
		from ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId
*/		
		if @@error <> 0 goto rollback_tran

/*
LOOK INTO
		delete ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId
*/
--instead of deleting, mark the erclaimlineitem to processed
		Update ERClaimLineItems
		set Processed = ''Y'',
		ProcessedDate = getdate()
		From ERClaimLineItems
		where ClaimLineItemId = @LastClaimLineItemId
		and ERBatchId = @ERBatchId


		if @@error <> 0 goto rollback_tran

		insert into CustomERLineItemPayments
		(ClaimLineItemId, SequenceNumber, PaymentId, ERBatchId)
		select ClaimLineItemId, SequenceNumber, PaymentId, ERBatchId
		from CustomERLineItemPaymentsTemp
		where ClaimLineItemId = @LastClaimLineItemId
		and PaymentId = @LastPaymentId

		if @@error <> 0 goto rollback_tran

		delete from CustomERLineItemPaymentsTemp
		where ClaimLineItemId = @LastClaimLineItemId
		and PaymentId = @LastPaymentId

		if @@error <> 0 goto rollback_tran

		commit transaction

		if @@error <> 0 goto rollback_tran

	end
end
else if @LastClaimItemOk = ''N''
begin
	delete ERClaimLineItems
	where ClaimLineItemId = @LastClaimLineItemId
	and ERBatchId = @ERBatchId

	if @@error <> 0 goto rollback_tran

	commit transaction

	if @@error <> 0 goto rollback_tran

end

close cur_import

if @@error <> 0 goto error

deallocate cur_import

if @@error <> 0 goto error

-- get next check

/*fetch next from cur_Payment into @PaymentId, @CheckNo

if @@error <> 0 goto error

end -- @@fetch_status cur_Payment

close cur_Payment

if @@error <> 0 goto error

deallocate cur_Payment

if @@error <> 0 goto error
*/

return

rollback_tran:

rollback tran

error:

raiserror @ErrorNo @ErrorMessage

return


' 
END
GO
