/****** Object:  StoredProcedure [dbo].[csp_AdjustmentExpectedPayments]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AdjustmentExpectedPayments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_AdjustmentExpectedPayments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_AdjustmentExpectedPayments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[csp_AdjustmentExpectedPayments]
/******************************************************************************
**
**  Name: csp_AdjustmentExpectedPayments
**  Desc:
**  This procedure is used to adjustment the AR based on MACSIS/MITS billing
**
**  Return values:
**
**  Called by:   ServiceDetails.cs
**
**  Parameters:   csp_AdjustmentExpectedPayments @AdjustmentCode = 1000254
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 8/1/2012 JHB  Created
*******************************************************************************/
@AdjustmentCode int
as

BEGIN TRY

create table #ClaimLines
(ClaimLineItemId int,
CoveragePlanId int null,
ClientId int,
DateOfService datetime null,
BillingCode varchar(25) null,
Modifier1 varchar(10) null,
Modifier2 varchar(10) null,
Modifier3 varchar(10) null,
Modifier4 varchar(10) null,
ClaimUnits decimal(10,2) null,
ChargeAmount Decimal(10,2) null,
ExpectedPayment Decimal(10,2) null,
CurrentAdjustments Decimal(10,2) null,
PreviousPayerAdjustments decimal(10,2)null,
PreviousPayerPayments decimal(10,2) null,
ClientExpectedPayment decimal(10,2) null,
ClientAdjustments decimal(10,2) null,
MaximumChargeId int null,
MaximumChargeServiceId int null,
AdjustmentCreated char(1) null,
ARLedgerId int null,
ServiceUnits int null,
ProcedureCodeId int null,
)

create table #ClaimLineCharges
(ClaimLineItemId int,
ChargeAmount Decimal(10,2) null,
CurrentAdjustments Decimal(10,2) null,
PreviousPayerAdjustments decimal(10,2)null,
PreviousPayerPayments decimal(10,2) null,
ClientExpectedPayment decimal(10,2) null,
ClientAdjustments decimal(10,2) null,
)

create table #Charges
(ClaimLineItemId int null,
ClientId int null,
ServiceId int null,
CoveragePlanId int  null,
ChargeId int  null,
ChargeAmount Decimal(10,2) null,
ExpectedPayment Decimal(10,2) null,
CurrentAdjustments Decimal(10,2) null,
PreviousPayerAdjustments decimal(10,2)null,
PreviousPayerPayments decimal(10,2) null,
ClientExpectedPayment decimal(10,2) null,
ClientAdjustments decimal(10,2) null,
ServiceUnits int null,
)

create table #ServiceUnits
(ClaimLineItemId int null,
ServiceUnits int null)

-- Create a list of Claims to be processed

insert into #ClaimLines
(ClaimLineItemId, DateOfService, BillingCode, Modifier1, Modifier2, Modifier3, Modifier4,
ClaimUnits, AdjustmentCreated)
select a.ClaimLineItemId, a.DateOfService, a.BillingCode, a.Modifier1, a.Modifier2,
a.Modifier3, a.Modifier4, a.Units, ''N''
from ClaimLineItems a
JOIN ClaimLineItemGroups b ON (a.ClaimLineItemGroupId = b.ClaimLineItemGroupId)
JOIN ClaimBatches c ON (b.ClaimBatchId = c.ClaimBatchId)
where c.ClaimFormatId in (10003, 10008)
and c.Status = 4524
-- If the charge was sent out more than once, only look at the latest claim line item
and Not exists
(Select * from ClaimLineItemCharges clic1
JOIN ClaimLineItemCharges clic2 ON (clic1.ChargeId = clic2.ChargeId)
JOIN ClaimLineItems cli ON (clic2.ClaimLineItemId = cli.ClaimLineItemId)
JOIN ClaimLineItemGroups clig ON (clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId)
JOIN ClaimBatches cb ON (clig.ClaimBatchId = cb.ClaimBatchId)
where clic1.ClaimLineItemId = a.ClaimLineItemId
and cb.Status = 4524
and cb.ClaimBatchId > c.ClaimBatchId)
and Not exists
(Select * from CustomExpectedPaymentAdjustments cepa
where a.ClaimLineItemId = cepa.ClaimLineItemId)

-- Get Charges
insert into #Charges
(ClaimLineItemId, ChargeId, CoveragePlanId, ClientId, ServiceId, ServiceUnits, ChargeAmount, CurrentAdjustments,
PreviousPayerAdjustments, PreviousPayerPayments, ClientExpectedPayment, ClientAdjustments)
select clic.ClaimLineItemId, clic.ChargeId, ccp.CoveragePlanId, s.ClientId, s.ServiceId, s.Unit,
isnull(sum(case when arl2.LedgerType in (4201, 4204)
then arl2.Amount else 0 end),0),
isnull(sum(case when c2.Priority = c.Priority and arl2.LedgerType = 4203
then -arl2.Amount else 0 end),0),
isnull(sum(case when c2.Priority < c.Priority and c2.Priority <> 0 and arl2.LedgerType = 4203
then -arl2.Amount else 0 end),0),
isnull(sum(case when c2.Priority < c.Priority and c2.Priority <> 0 and arl2.LedgerType = 4202
then -arl2.Amount else 0 end),0),
isnull(sum(case when c2.Priority = 0 and arl2.LedgerType in (4201, 4204)
then arl2.Amount else 0 end),0),
isnull(sum(case when c2.Priority = 0 and arl2.LedgerType = 4203
then -arl2.Amount else 0 end),0)
from #ClaimLines cli
JOIN ClaimLineItemCharges clic ON (cli.ClaimLineItemId = clic.ClaimLineItemId)
JOIN Charges c ON (clic.ChargeId = c.ChargeId)
JOIN Services s ON (c.ServiceId = s.ServiceId)
JOIN ClientCoveragePlans ccp ON (c.ClientCoveragePlanId = ccp.ClientCoveragePlanId)
LEFT JOIN Charges c2 ON (c.ServiceId = c2.ServiceId)
LEFT JOIN ARLedger arl2 ON (c2.ChargeId = arl2.ChargeId)
where isnull(s.RecordDeleted,''N'') = ''N''
and s.Status <> 76 -- Exclude Error
-- if there are multiple charges billed for the same service, only use the last billed
and not exists
(select * from #claimlines cl2
JOIN ClaimLineItemCharges clic2 ON cl2.ClaimLineItemId = clic2.ClaimLineItemId
JOIN Charges c2 on clic2.ChargeId = c2.ChargeId
where c2.ServiceId = c.ServiceId
and c2.LastBilledDate > c.LastBilledDate)
group by clic.ClaimLineItemId, clic.ChargeId, ccp.CoveragePlanId, s.ServiceId,  s.Unit, s.ClientId

update a
set CoveragePlanId = b.CoveragePlanId, ClientId = b.ClientId
from #ClaimLines a
JOIN #Charges b ON (a.ClaimLineItemId = b.ClaimLineItemId)

insert into #ClaimLineCharges
(ClaimLineItemId, ChargeAmount, CurrentAdjustments, PreviousPayerAdjustments,
PreviousPayerPayments, ClientExpectedPayment, ClientAdjustments)
select ClaimLineItemId, SUM(ChargeAmount), Sum(CurrentAdjustments), Sum(PreviousPayerAdjustments),
Sum(PreviousPayerPayments), Sum(ClientExpectedPayment), Sum(ClientAdjustments)
from #Charges
group by ClaimLineItemId

update a
set ChargeAmount = b.ChargeAmount, CurrentAdjustments = b.CurrentAdjustments,
PreviousPayerAdjustments = b.PreviousPayerAdjustments,
PreviousPayerPayments = b.PreviousPayerPayments, ClientExpectedPayment = b.ClientExpectedPayment,
ClientAdjustments = b.ClientAdjustments
from #ClaimLines a
JOIN #ClaimLineCharges b ON (a.ClaimLineItemId = b.ClaimLineItemId)

-- Set the ChargeId in #ClaimLines to the one with the maximum charge
-- All Adjustments will be done against this
update a
set MaximumChargeId = b.ChargeId, MaximumChargeServiceId = b.ServiceId
from #ClaimLines a
JOIN #Charges b ON (a.ClaimLineItemId = b.ClaimLineItemId)
where not exists
(select * from #Charges c
where b.ClaimLineItemId = c.ClaimLineItemId
and ((c.ChargeAmount - c.PreviousPayerAdjustments - c.PreviousPayerPayments)
> (b.ChargeAmount - b.PreviousPayerAdjustments - b.PreviousPayerPayments)))

insert into #ServiceUnits
(ClaimLineItemId, ServiceUnits)
select ClaimLineItemId, SUM(ServiceUnits)
from #Charges
group by ClaimLineItemId

update a
set ServiceUnits = b.ServiceUnits
from #ClaimLines a
JOIN #ServiceUnits b ON a.ClaimLineItemId = b.ClaimLineItemId

-- Added logic to recalculate units
exec csp_PMClaims837Rounding

-- Calculate the expected payments
/*
update a
set ExpectedPayment = a.ClaimUnits*b.ChargePerUnit
from #ClaimLines a
JOIN CustomMACSISCPTUnits b
ON a.BillingCode = b.CPTCode
and ( ( a.Modifier1 is null
  and  b.CPTModifier1 is null
  )
 or  ( a.Modifier1 is not null
  and b.CPTModifier1 is not null
  and a.Modifier1 = b.CPTModifier1
  )
 )
and ( ( a.Modifier2 is null
  and  b.CPTModifier2 is null
  )
 or  ( a.Modifier2 is not null
  and b.CPTModifier2 is not null
  and a.Modifier2 = b.CPTModifier2
  )
 )
JOIN CustomMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId)
where b.medicaid = ''Y''
and a.DateOfService >= b.EffectiveFrom
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)

update a
set ExpectedPayment = a.ClaimUnits*b.ChargePerUnit
from #ClaimLines a
JOIN CustomMACSISCPTUnits b
ON a.BillingCode = b.CPTCode
and ( ( a.Modifier1 is null
  and  b.CPTModifier1 is null
  )
 or  ( a.Modifier1 is not null
  and b.CPTModifier1 is not null
  and a.Modifier1 = b.CPTModifier1
  )
 )
and ( ( a.Modifier2 is null
  and  b.CPTModifier2 is null
  )
 or  ( a.Modifier2 is not null
  and b.CPTModifier2 is not null
  and a.Modifier2 = b.CPTModifier2
  )
 )
JOIN CustomNonMedicaidCoveragePlans c ON (a.CoveragePlanId = c.CoveragePlanId      )
where b.medicaid = ''N''
and a.DateOfService >= b.EffectiveFrom
and (a.DateOfService < DATEADD(dd, 1, b.EffectiveTo) or b.EffectiveTo is null)

-- Update Expected Payments for Charges proportional to the charge
update c
set ExpectedPayment = (cl.ExpectedPayment)*(c.ChargeAmount/cl.ChargeAmount)
from #Charges c
JOIN #ClaimLines cl ON (c.ClaimLineItemId = cl.ClaimLineItemId)
where isnull(cl.ChargeAmount,0) <> 0
*/
update a
set ClaimUnits = Case when b.UnitinMinutes = 60 then  convert(decimal(10,1),ClaimUnits)
					else CONVERT(int,ClaimUnits) end
from #ClaimLines a
JOIN CustomMACSISCPTUnits b ON (a.BillingCode = b.CPTCode)

create table #ExpectedPayments
(RecordId int identity not null,
ClaimLineItemId int not null,
ExpectedPayment money null,
ExpectedAdjustment money null)


-- Use ExpectedPayments table
insert into #ExpectedPayments
(ClaimLineItemId, ExpectedPayment)
select CL.ClaimLineItemId,CL.ClaimUnits*EP.Payment
from #ClaimLines CL
JOIN Charges CH ON CL.MaximumChargeId = CH.ChargeId
JOIN ClientCoveragePlans CCP ON (CH.ClientCoveragePlanId = CCP.ClientCoveragePlanId)
JOIN CoveragePlans CP ON (CP.CoveragePlanId = CCP.CoveragePlanId)
JOIN CoveragePlans CP2 ON ((CP.ExpectedPaymentTemplate = ''T'' and CP.CoveragePlanId = CP2.CoveragePlanId)
or (CP.ExpectedPaymentTemplate = ''O'' and CP2.CoveragePlanId = CP.UseExpectedPaymentTemplateId))
JOIN Services S ON CH.ServiceId = S.ServiceId
JOIN Staff ST ON (S.ClinicianId = ST.StaffId)
JOIN ExpectedPayment EP ON (EP.CoveragePlanId = CP2.CoveragePlanId
and CL.BillingCode = EP.BillingCode
and ISNULL(CL.Modifier1,'''') = ISNULL(EP.Modifier1,'''')
and ISNULL(CL.Modifier2,'''') = ISNULL(EP.Modifier2,'''')
and ISNULL(CL.Modifier3,'''') = ISNULL(EP.Modifier3,'''')
and ISNULL(CL.Modifier4,'''') = ISNULL(EP.Modifier4,'''')
)
left outer join ExpectedPaymentPrograms EPP on EP.ExpectedPaymentId=EPP.ExpectedPaymentId
AND isnull(EPP.RecordDeleted,''N'') =''N''
left outer join ExpectedPaymentLocations EPL on EP.ExpectedPaymentId=EPL.ExpectedPaymentId
AND isnull(EPL.RecordDeleted,''N'') =''N''
left outer join ExpectedPaymentDegrees EPD on EP.ExpectedPaymentId=EPD.ExpectedPaymentId
AND isnull(EPD.RecordDeleted,''N'') =''N''
left outer join ExpectedPaymentStaff EPS on EP.ExpectedPaymentId=EPS.ExpectedPaymentId
AND isnull(EPS.RecordDeleted,''N'') =''N''
where  isnull(EP.RecordDeleted,''N'') =''N'' AND
EP.FromDate<= S.DateOfService And
(dateadd(dd, 1, EP.ToDate) > S.DateOfService  or EP.ToDate is NULL) And
(EP.ClientId= S.ClientId or EP.ClientId is NULL)
AND (EPP.programId= S.ProgramId or EP.ProgramGroupName is Null)
AND (EPL.LocationId= S.LocationId or EP.LocationGroupName is NULL)
AND (EPD.Degree= ST.Degree or EP.DegreeGroupName is NULL)
AND (EPS.StaffId= S.ClinicianId or EP.StaffGroupName is NULL)
order by CL.ClaimLineItemId, EP.Priority ASC


update a
set ExpectedPayment = b.ExpectedPayment
from #ClaimLines a
JOIN #ExpectedPayments b ON (a.ClaimLineItemId = b.ClaimLineItemId)
where not exists
(select * from #ExpectedPayments d
where a.ClaimLineItemId = d.ClaimLineItemId
and d.RecordId < b.RecordId)

-- Delete old Errors

delete from CustomExpectedPaymentAdjustmentErrors

-- Mark as error if expected payments cannot be calculated
begin tran

-- Delete where all charges (Services) were marked as error
-- or claims were sent for 2 different charges for the same service
-- in both cases there will be a record in #Charges
insert into CustomExpectedPaymentAdjustments
(ClaimLineItemId, ChargeAmount, ExpectedPayment, PreviousPayerAdjustments,
PreviousPayerPayments, ClientExpectedPayment, AdjustmentCreated)
select ClaimLineItemId,  ChargeAmount, ExpectedPayment, PreviousPayerAdjustments,
PreviousPayerPayments, ClientExpectedPayment, ''N''
from #ClaimLines a
where not exists
(select * from #Charges b where a.ClaimLineItemId = b.ClaimLineItemId)

delete a
from #ClaimLines a
where not exists
(select * from #Charges b where a.ClaimLineItemId = b.ClaimLineItemId)

insert into CustomExpectedPaymentAdjustmentErrors
(ClaimLineItemId, BillingCode, Modifier1, Modifier2, Modifier3, Modifier4, ClaimUnits, ChargeAmount,
ExpectedPayment, PreviousPayerAdjustments, PreviousPayerPayments, ClientExpectedPayment, ErrorMessage)
select ClaimLineItemId,  BillingCode, Modifier1, Modifier2, Modifier3, Modifier4, ClaimUnits,
ChargeAmount, ExpectedPayment, PreviousPayerAdjustments,
PreviousPayerPayments, ClientExpectedPayment, ''Unable to determine expected payment''
from #ClaimLines
where ExpectedPayment is null


delete from #ClaimLines
where ExpectedPayment is null

commit tran


-- Post Adjustments
declare @ClaimLineItemId int, @MaximumChargeId int, @Adjustment Decimal(10,2)
declare @CoveragePlanId int, @ClientId int, @DateOfService datetime
declare @FinancialActivityId int, @FinancialActivityLineId int
declare @CurrentAccountingPeriodId int, @ARLedgerId int, @ServiceAccountingPeriodId int
declare @ServiceId int


select @CurrentAccountingPeriodId = AccountingPeriodId
from AccountingPeriods
where StartDate <= getdate()
and dateadd(dd, 1, EndDate) > getdate()
and OpenPeriod = ''Y''

if @CurrentAccountingPeriodId is null
	select top 1 @CurrentAccountingPeriodId = AccountingPeriodId
	from dbo.AccountingPeriods
	where StartDate >= GETDATE()
	and OpenPeriod = ''Y''
	and ISNULL(RecordDeleted, ''N'') <> ''Y''
	order by StartDate
	
begin tran

declare cur_Adjustments cursor for
select ClaimLineItemId, MaximumChargeId, CoveragePlanId, ClientId, MaximumChargeServiceId, DateOfService,
(ChargeAmount - CurrentAdjustments - PreviousPayerAdjustments - PreviousPayerPayments
- ClientExpectedPayment - ExpectedPayment)
from #ClaimLines
where (ChargeAmount - CurrentAdjustments - PreviousPayerAdjustments - PreviousPayerPayments
- ClientExpectedPayment > ExpectedPayment)

open cur_Adjustments

fetch cur_Adjustments into @ClaimLineItemId, @MaximumChargeId, @CoveragePlanId,
@ClientId, @ServiceId, @DateOfService, @Adjustment

while @@FETCH_STATUS = 0
begin

  Insert Into FinancialActivities
  (CoveragePlanId, ClientId, ActivityType,
  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
  values (@CoveragePlanId, null, 4326,
  ''ARADJUSTMENT'', getdate(), ''ARADJUSTMENT'', getdate())

  set @FinancialActivityId = @@identity

/*
  -- Insert Into FinancialActivityLines table
  Insert Into FinancialActivityLines
  (FinancialActivityId, ChargeId, CurrentVersion,
  CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
  values (@FinancialActivityId, @MaximumChargeId, 1,
  ''ARADJUSTMENT'', getdate(), ''ARADJUSTMENT'', getdate())

  set @FinancialActivityLineId = @@identity

  -- Insert Into ARLedger table
  Insert Into ARLedger
  (FinancialActivityLineId, ChargeId, LedgerType, AdjustmentCode, Amount, AccountingPeriodId, FinancialActivityVersion,
  PostedDate, CoveragePlanId, ClientId, DateOfService, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
  values (@FinancialActivityLineId, @MaximumChargeId, 4203, @AdjustmentCode, @Adjustment, @CurrentAccountingPeriodId,
  1, getdate(), @CoveragePlanId, @ClientId, @DateOfService,
  ''ARADJUSTMENT'', getdate(), ''ARADJUSTMENT'', getdate())
*/
	set @ServiceAccountingPeriodId = null
	
	select top 1 @ServiceAccountingPeriodId = AccountingPeriodId
	from dbo.AccountingPeriods
	where DATEDIFF(DAY, StartDate, @DateOfService) >= 0
	and DATEDIFF(DAY, EndDate, @DateOfService) <= 0
	and OpenPeriod = ''Y''

	if @ServiceAccountingPeriodId is null set @ServiceAccountingPeriodId = @CurrentAccountingPeriodId
	
  exec ssp_PMPaymentAdjustmentPost @UserCode = ''ARADJUSTMENT'', @FinancialActivityId = @FinancialActivityId,
 @PaymentId = NULL, @Adjustment1 = @Adjustment,
 @AdjustmentCode1 = @AdjustmentCode,@PostedAccountingPeriodId=@ServiceAccountingPeriodId,
 @ChargeId = @MaximumChargeId,
 @ServiceId = @ServiceId, @DateOfService = @DateOfService, @ClientId = @ClientId,
 @CoveragePlanId = @CoveragePlanId, @ERTransferPosting = ''N''  ,@FinancialActivityLineId = null


  select @ARLedgerId = Max(ARledgerId)
  from ARledger
  where ChargeId = @MaximumChargeId

   update #ClaimLines
   set ARLedgerId = @ARLedgerId, AdjustmentCreated = ''Y''
   where ClaimLineItemId = @ClaimLineItemId

 fetch cur_Adjustments into @ClaimLineItemId, @MaximumChargeId, @CoveragePlanId,
 @ClientId, @ServiceId, @DateOfService, @Adjustment


end

close cur_Adjustments

deallocate cur_Adjustments

insert into CustomExpectedPaymentAdjustments
(ClaimLineItemId,  ChargeAmount, ExpectedPayment, PreviousPayerAdjustments,
PreviousPayerPayments, ClientExpectedPayment, AdjustmentCreated, ARLedgerId)
select ClaimLineItemId,  ChargeAmount, ExpectedPayment, PreviousPayerAdjustments,
PreviousPayerPayments, ClientExpectedPayment, AdjustmentCreated, ARLedgerId
from #ClaimLines

commit tran



END TRY

BEGIN CATCH

 declare @Error varchar(8000)
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_AdjustmentExpectedPayments'')
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
    + ''*****'' + Convert(varchar,ERROR_STATE())

 if @@trancount > 1 rollback tran

 RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );

END CATCH

-- csp_AdjustmentExpectedPayments @AdjustmentCode = 1000254

' 
END
GO
