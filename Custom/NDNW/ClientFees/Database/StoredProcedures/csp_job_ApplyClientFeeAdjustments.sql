/****** Object:  StoredProcedure [dbo].[csp_job_ApplyClientFeeAdjustments]    Script Date: 09/24/2015 14:20:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
if OBJECT_ID('csp_job_ApplyClientFeeAdjustments', 'P') is not null
	drop procedure csp_job_ApplyClientFeeAdjustments
go

create procedure [dbo].[csp_job_ApplyClientFeeAdjustments]
/******************************************************************************
**
**  Name: csp_job_ApplyClientFeeAdjustments
**  Desc:
**  This procedure is used to adjustment the AR based on MACSIS/MITS billing
**
**  Return values:
**
**  Called by:   ServiceDetails.cs
**
**  Parameters:   csp_job_ApplyClientFeeAdjustments @AdjustmentCode = 50049
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 2/11/2013 JHB  Created
** 9/29/2015 TRemisoski Added logic to check for location and program.  Apply rate when specified instead of percentage
** 11/30/2015 TRemisoski Added rounding logic to whole dollars on percentage based fees per NDNW's review/request.
** 11/30/2015 TRemisoski Added RECODE(XCLIENTFEEIGNOREPROCS) to avoid processing client fees for specified procedure codes.
*******************************************************************************/
@AdjustmentCode int
as

BEGIN TRY

Create table #Charges
(ChargeId int not null,
ServiceId int null,
ClientId int null,
DateOfService datetime null,
ServiceUnits decimal(10,2) null,
ChargeAmount money null,
PaymentPercentage decimal(10,2) null,
CurrentBalance money null,
PaymentRate money null)


declare @ChargeAccountingPeriodByDateOfService char(1)
declare @CurrentDate date

set @CurrentDate = GETDATE()

-- Check accounting period configuration
select @ChargeAccountingPeriodByDateOfService = isnull(ChargeAccountingPeriodByDateOfService,'N')
from SystemConfigurations


-- Get a list of Charges for clients that have a fee of < 100%
insert into #Charges
(ChargeId, ServiceId, ClientId, dateOfService, ServiceUnits, ChargeAmount, PaymentPercentage, CurrentBalance, PaymentRate)
select a.ChargeId, e.ServiceId, e.ClientId, e.DateOfService, e.Unit, e.Charge, CMF.StandardRatePercentage, a.Balance, cmf.Rate
from OpenCharges a
JOIN Charges b ON a.ChargeId = b.ChargeId
JOIN Services e ON b.ServiceId = e.ServiceId
join (
	select sv.ServiceId, sv.ClientId, cmf.StandardRatePercentage, cmf.Rate,
	ROW_NUMBER() over(partition by sv.ServiceId ORDER BY case when pgs.Item is not null and pls.Item is not null then 1 when pgs.Item is not null then 2 else 3 end) as FeePriority
	from CustomClientFees cmf
	join Services as sv on sv.ClientId = cmf.ClientId and ((sv.ProgramId in (select CAST(Item as int) from dbo.fnSplit(cmf.[Programs], ','))) or (sv.LocationId in (select CAST(Item as int) from dbo.fnSplit(cmf.[Locations], ','))))
	outer apply dbo.fnSplit(cmf.[Programs], ',') as pgs
	outer apply dbo.fnSplit(cmf.[Locations], ',') as pls
	where CMF.StartDate <= sv.DateOfService
	and (CMF.EndDate is null or dateadd(dd, 1, CMF.EndDate) > sv.DateOfService)
	and ((sv.ProgramId = CAST(pgs.Item as int)) or (sv.LocationId = CAST(pls.Item as int)))
	and (cmf.StandardRatePercentage < 100  or cmf.Rate >= 0)
	and ISNULL(CMF.RecordDeleted,'N') = 'N'
) as cmf on cmf.ServiceId = e.ServiceId and cmf.FeePriority = 1
where b.ClientCoveragePlanId is null
and not exists (
	select *
	from dbo.ssf_RecodeValuesAsOfDate('XCLIENTFEEIGNOREPROCS', e.DateOfService) as rc
	where rc.IntegerCodeId = e.ProcedureCodeId
)

--and e.DateOfService >= '4/1/2013'

-- JHB 3/16/2014
create table #PriorAdjustments
(ChargeId int not null,
AdjustmentAmount decimal(10,2) null)

insert into #PriorAdjustments
(ChargeId, AdjustmentAmount)
select a.ChargeId, sum(b.Amount)
from #Charges a
JOIN ARLedger b ON a.ChargeId = b.ChargeId
where b.LedgerType = 4203
group by a.ChargeId
having sum(b.Amount) < 0

-- Create Adjustments where Current Balance is > Owed Amount
declare @ChargeId int, @Adjustment Decimal(10,2)
declare @CoveragePlanId int, @ClientId int, @DateOfService datetime
declare @FinancialActivityId int, @FinancialActivityLineId int
declare @CurrentAccountingPeriodId int, @ARLedgerId int
declare @ServiceId int


declare cur_Adjustments cursor for
select a.ChargeId
,      null
,      a.ClientId
,      a.ServiceId
,      a.DateOfService
,
-- JHB 3/16/2014 Adjusted logic for handling negative balances
-- Current Balance is negative and there is already a credit adjustment
       case when CurrentBalance < 0 and isnull(b.AdjustmentAmount,0) < 0
-- If current balance is less then the adjustments then
-- reverse the adjustment otherwise reverse the balance amount
            then (case when CurrentBalance < isnull(b.AdjustmentAmount,0) then isnull(b.AdjustmentAmount,0)
	                                                                      else a.CurrentBalance end )
            else
	-- Otherwise create an adjustment based on member fee
	-- give preference to percentage over $$ (rate) entered
	a.CurrentBalance - case when a.PaymentPercentage < 100 then round(a.ChargeAmount*(a.PaymentPercentage/100.0), 0)
	                                                       else a.PaymentRate end end
from      #Charges          a
LEFT JOIN #PriorAdjustments b ON a.ChargeId = b.ChargeId
where ((case when a.PaymentPercentage < 100 then round(a.ChargeAmount*(a.PaymentPercentage/100.0), 0)
	                                        else a.PaymentRate end ) < CurrentBalance)
	or (CurrentBalance < 0 and isnull(b.AdjustmentAmount,0) < 0)
order by a.ChargeId

open cur_Adjustments

fetch cur_Adjustments into @ChargeId, @CoveragePlanId,
@ClientId, @ServiceId, @DateOfService, @Adjustment

while @@FETCH_STATUS = 0
begin

	if @ChargeAccountingPeriodByDateOfService = 'Y'
	begin

	select top 1 @CurrentAccountingPeriodId = AccountingPeriodId
	from AccountingPeriods
	where dateadd(dd, 1, EndDate) > @DateOfService
	and OpenPeriod = 'Y'
	order by StartDate

	end
	else
	begin

	select @CurrentAccountingPeriodId = AccountingPeriodId
	from AccountingPeriods
	where StartDate <= @CurrentDate
	and dateadd(dd, 1, EndDate) > @CurrentDate


	end


  begin tran

  Insert Into FinancialActivities
  (CoveragePlanId, ClientId, ActivityType,
  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
  values (@CoveragePlanId, @ClientId, 4326,
  'ARADJUSTMENT', getdate(), 'ARADJUSTMENT', getdate())

  set @FinancialActivityId = @@identity

  exec ssp_PMPaymentAdjustmentPost @UserCode = 'ARADJUSTMENT', @FinancialActivityId = @FinancialActivityId,
 @PaymentId = NULL, @Adjustment1 = @Adjustment,
 @AdjustmentCode1 = @AdjustmentCode,@PostedAccountingPeriodId=@CurrentAccountingPeriodId,
 @ChargeId = @ChargeId,
 @ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId,
 @CoveragePlanId = @CoveragePlanId, @ERTransferPosting = 'N'  ,@FinancialActivityLineId = null


  select @ARLedgerId = Max(ARledgerId)
  from ARledger
  where ChargeId = @ChargeId

  commit tran


 fetch cur_Adjustments into @ChargeId, @CoveragePlanId,
 @ClientId, @ServiceId, @DateOfService, @Adjustment


end

close cur_Adjustments

deallocate cur_Adjustments



END TRY

BEGIN CATCH

 declare @Error varchar(8000)
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_job_ApplyClientFeeAdjustments')
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())
    + '*****' + Convert(varchar,ERROR_STATE())

 if @@trancount > 1 rollback tran

 RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );

END CATCH

go

