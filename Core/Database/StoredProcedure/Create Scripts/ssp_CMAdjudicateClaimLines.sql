if object_id('dbo.ssp_CMAdjudicateClaimLines') is not null
  drop procedure dbo.ssp_CMAdjudicateClaimLines
go

create procedure dbo.ssp_CMAdjudicateClaimLines
  @ProgressCode uniqueidentifier,
  @UserId int,
  @UserCode varchar(30),
  @BatchId int  
/*********************************************************************            
-- Stored Procedure: dbo.ssp_CMAdjudicateClaimLines  
--                                                   
-- Purpose: adjudicate claim lines 
--                                                      
-- Modified Date    Modified By      Purpose  
-- 12.12.2005       Sukhbir Singh    Created.  
-- 12.12.2007       SFarber          Modified to deny a claim line if the primary diagnosis is invalid.  
-- 04.16.2008       SFarber          Modified to use ProviderAuthorizations.TotalUnitsApproved instead of UnitsApproved for PA.  
-- 05.29.2008       SFarber          Redesigned.  
-- 09.02.2008       Sonia Dhamija    Modified with reference to Task #1534 as in case claimline is denied record needs to be inserted into ClaimLineDenials      
-- 10.16.2008       SFarber          Moved code related to claim line denials to the ssp_CMAdjudicateClaimLineDenials.  
-- 02.04.2010       SFarber          Modified to pend claim lines if dates of service not fully covered by contract(s).  
-- 04.20.2010       SFarber          Added call to scsp_CMAdjudicateClaimLines  
-- 06.14.2010       AVoss            Added check for Claim Diagnosis1, Diagnosis2, Diagnosis3 to be in DiagnosisDSMCodes   
-- 07.14.2010       AVoss            Changed @IsDiagnosis3 selection to correctly select cl.Diagnosis3. previously it was selecting cl.Diagnosis2  
-- 09.09.2010       SFarber          Modified to check if billing code ID is valid.  
-- 10.13.2010       SFarber          Modified to validate all diagnosis.  
-- 09.20.2011       SFarber          Modified to use IsProviderCredentialed function
-- 10.07.2011       SFarber          Modified to check if any record exists in @AuthorizationRates.
-- 03.14.2012		Pralyankar		 Modified for showing multiple reason to deny claim.
-- 05.18.2012		Sanjay Bhardwaj	 Task#21 Modified for showing multiple reason to deny claim.
-- 11.01.2012		Sanjay Bhardwaj	 Project Name : CareManagement Support, Summary : #2656 - CM: Status of Partially Approved set to Approved.
-- 11.05.2012		dharvey			 Modified logic for task #2656 to prevent incorrectly setting Partially Approved to Approved.
									 Maintained Sanjay's changes regarding task #2655 to set output status to Denied if Denial and Pended
-- 11.06.2012		dharvey			 Revised Inserts into AdjudicationDenialPendedReasons to prevent PendedReasons if any DenialReasons exist
-- 04.07.2013		RQuigley		 Fixed denial for contract logic per Slavik Farber.  Logic was incorrect since the change to multiple
--									 denial reasons.
-- 05.10.2013		RQuigley		 Fixed denial logic re: rendering providers to not throw all reasons when RenderingProvider is required
									 but not provided in the claimline.
-- 05.20.2013		RQuigley		 Fixed so that Reason in ClaimlineHistory will "prefer" Denial reasons over pended reasons.
-- 07.12.2013		dharvey			 Added PIHP UM Determination to Approved Auth status rules
-- 10.30.2013		RQuigley		 Prevent claims from adjudicating that are in the future.
-- 10.21.2014       SFarber          Added adjudication rules logic.
-- 10.23.2014       SFarber          Added PreviousPayerEOBRequired contract rule logic.
-- 11.12.2014       SFarber          Made changes to Claim Includes Discharge Day rule.
-- 11.12.2014       SFarber          Added support for Partially Denied authorizations.
-- 01.30.2015       SFarber          Modified to always use ProviderAuthorizations.TotalUnitsApproved instead of UnitsApproved 
-- 01.31.2015       SFarber          Added check for InsurerValidCoveragePlans
-- 03.04.2015       SFarber          Modified spenddown logic.
-- 04.08.2015       SFarber          Modified to only consider claim lines with units > 0 when calculating billing rule caps.
-- 04.14.2015       SFarber          Modified to handle multiple authorizations per day of service.
-- 06.23.2015       SFarber          Modified to use ssp_CMValidateClaimLineDiagnosisCodes.
-- 11.17.2015		Rohith Uppin	 Modifiedby condition added to Check for claim line status while Adjudicating same Claimline. Task#717 SWMBH Support.
-- 02.10.2016       SFarber          Reverted Rohith's change from 11/17/2015
-- 03.23.2016       SFarber          Modified to make sure calculated approved amount is never less than $0.
-- 03.28.2016       SFarber          Added claim denial overrides logic
-- 05.01.2016       SFarber          Added claim bundle logic.
-- 07.08.2016       SFarber          Added coverage plan claim budget logic.
-- 09.16.2016       SFarber          Modified claim denial override logic to continue with claim line approval.
-- 09.30.2016       SFarber          Modified to approve an activity claim line if the corresponding bundle claim lines has been already approved.
-- 11.07.2016		jcarlson		  modified coverage plan selection logic to take into account COB order. N180 EIT 452
-- 11.23.2016		Govind			 Added Checks on StartTime and EndTime for "Same ClaimLine Exists" Denial Reason. ARC Support Go Live Task #94
-- 03.14.2017       SFarber          Modified logic for StartTime and EndTime checks.
-- 03.15.2017       SFarber          Modified to set $0 claim lines to Approved status instead of Paid when approved.
-- 03.23.2017       Kkumar           Modified to round off  ClaimsApprovedAndPaid to 2 decimals.
-- 05.11.2017       SFarber          Modified logic for setting $0 claim lines to Approved status.
-- 05.16.2017       Sfarber          Modified to check the AllowMultipleClaimsPerDay setting at the modifier level only if it is set to N at the billing code level
-- 05.17.2017       SFarber          Added member copay logic.
-- 05.18.2017       SFarber          Added coverage fully responsible logic.
-- 07.07.2017       SFarber          Modified coverage plan claim budget logic to not cascade if a coverage specific rate was used.
-- 07.28.2017       SFarber          Replaced @Diagnoses with #Diagnoses.
-- 08.15.2017       SFarber          Added Adjudicate Spend-Down logic
-- 08.18.2017       SFarber          Modified to update claim lines LastAdjudicationId and LastAdjudicationDate
-- 08.22.2017       SFarber          Modified to support 'Authorization for this claim is pended' rule
-- 10.19.2017       SFarber          Fixed denial reason issue for approved claim lines.
-- 12.06.2017       SFarber          Fixed OverrideRuleClaimLineStatus logic.
-- 12.10.2017       SFarber          Modified to support 'Claim line is identified for review and manual approval' rule.
-- 12.21.2017       SFarber          Modified to support Add-On code rules.
-- 01.09.2018       SFarber          Modified rendering provider rule #2529 to consider supervising provider.
-- 07.24.2018       Kkumar           Considering Place of Service and Rendering Provider when determining duplicate claimline
-- 09.06.2018       SFarber          Reversed rendering provider rule #2529 to only consider rendering provider and not supervising
-- 09.06.2018       SFarber          Modified to support adjudication rules based on date of service
-- 09.06.2018       SFarber          Added logic for claim line Override Pended Reason flag
-- 20.Nov.2018      K.Soujanya       Added condtion to exclude the Adjudication process if the claim line is under Review.Why: SWMBH - Enhancements#591
-- 12.03.2018       SFarber          Modified logic for contract billing code rules to consider provider (#2533).  Added logic for new rule #2552.
-- 01.09.2019       SFarber          Modified to use ssf_CMClaimLineBundles function. Improved bundling logic.
-- 01.11.2019       SFarber          Added logic for Critical System Error
****************************************************************************/
as 

set nocount on

create table #Diagnoses (
  DiagnosisCode varchar(20),
  IsValid char(1),
  LevelOfImportance char(1),
  ValidationType varchar(10))
	  
create table #AuthorizationsRates (
Date datetime,
ProviderAuthorizationId int,
AuthorizationUnitsUsed decimal(18, 2),
ClaimLineUnitsApproved decimal(18, 2),
ClaimLineUnits decimal(18, 2),
ContractId int,
ContractRateId int,
ContractRate money,
ContractRuleId int,
AuthorizationRequired char(1),
Status int)  
	  
declare @TimePeriods table (
  TimePeriod char(1),
  FromDate datetime,
  ToDate datetime,
  UnitLimit int,
  StandardUnitLimit int,
  ClaimLineUnits decimal(18, 2),
  OtherClaimLineUnits decimal(18, 2),
  StandardOtherClaimLineUnits decimal(18, 2),
  CheckContractRule char(1),
  CheckStandardRule char(1))

create table #DenialReasons (
DenialReasonId int identity
                   not null,
ReasonId int,
ReasonSpecifier varchar(max),
OverrideRuleClaimLineStatus char(1),
DeniedAmount money)

create table #AdjudicationRules (
AdjudicationRuleId int,
RuleTypeId int,
AllInsurers char(1),
InsurerId int,
ClaimLineStatusIfBroken char(1),
MarkClaimLineToBeWorked char(1),
RuleName varchar(250))

create table #NewAdjudications (
AdjudicationId int,
ClaimLineId int,
Status int,
ApprovedAmount money,
ClaimBundleId int,
CreatedDate datetime)

create table #CoveragePlans (
CoveragePlanId int,
CoveragePlanName varchar(100),
ClientCoveragePlanId int,
PlanIsBillable char(1),
MonthlyDeductibleMetAfterDateOfService char(1) default 'N',
MonthlyDeductibleNotMetForDateOfService char(1) default 'N',
COBOrder int)

create table #CoveragePlanClaimBudgets (
CoveragePlanId int,
BudgetName varchar(100),
CoveragePlanClaimBudgetId int,
CascadeToNextPlanWhenOverBudget char(1),
BudgetAmount money,
PaidAmount money,
CanBeUsed char(1))

declare @i int,
  @n int,
  @FiscalMonth int,
  @Fiscalyear datetime,
  @EntryComplete int,
  @EntryInComplete int,
  @Denied int,
  @Pended int,
  @Approved int,
  @PartiallyApproved int,
  @Void int,
  @Paid int,
  @Activity int,
  @ProfessionalClaim int,
  @InstitutionalClaim int,
  @AuthorizationClosed int,
  @AuthorizationApproved int,
  @TotalApprovedAmount money,
  @TotalPendedAmount money,
  @TotalDeniedAmount money,
  @ContractApprovedAmount money,
  @TotalClaimLines int,
  @TotalLinesApproved int,
  @TotalLinesPartiallyApproved int,
  @TotalLinesPended int,
  @TotalLinesDenied int,
  @ClaimType int,
  @ClaimLineId int,
  @RevenueCode varchar(25),
  @HCPCSCode varchar(25),
  @BillingCodeId int,
  @Modifier1 varchar(10),
  @Modifier2 varchar(10),
  @Modifier3 varchar(10),
  @Modifier4 varchar(10),
  @DOSFrom datetime,
  @DOSTo datetime,
  @StatusIn int,
  @StatusOut int,
  @Reason varchar(250),
  @DenialReason int,
  @PendedReason int,
  @NeedsToBeWorked char(1),
  @ClaimLineRate money,
  @ContractRate money,
  @ContractRateId int,
  @ContractRuleId int,
  @UnlimitedDailyUnits char(1),
  @DailyUnits decimal(18, 2),
  @UnlimitedWeeklyUnits char(1),
  @WeeklyUnits decimal(18, 2),
  @UnlimitedMonthlyUnits char(1),
  @MonthlyUnits decimal(18, 2),
  @UnlimitedYearlyUnits char(1),
  @YearlyUnits decimal(18, 2),
  @StandardUnlimitedDailyUnits char(1),
  @StandardDailyUnits decimal(18, 2),
  @StandardUnlimitedWeeklyUnits char(1),
  @StandardWeeklyUnits decimal(18, 2),
  @StandardUnlimitedMonthlyUnits char(1),
  @StandardMonthlyUnits decimal(18, 2),
  @StandardUnlimitedYearlyUnits char(1),
  @StandardYearlyUnits decimal(18, 2),
  @StandardExceedLimitAction char(1),
  @UnitsClaimed decimal(18, 2),
  @UnitsApproved decimal(18, 2),
  @UnitsDenied decimal(18, 2),
  @UnitsPended decimal(18, 2),
  @ClaimedAmount money,
  @PayableAmount money,
  @ApprovedAmount money,
  @DeniedAmount money,
  @PendedAmount money,
  @RenderingProviderId int,
  @SupervisingProviderId int,
  @ClientId int,
  @SiteId int,
  @SiteName varchar(100),
  @ProviderId int,
  @ProviderName varchar(100),
  @ClaimId int,
  @ClaimReceivedDate datetime,
  @InsurerId int,
  @ContractId int,
  @ClaimReceivedDays int,
  @ExceedLimitAction char(1),
  @TotalAmountCap money,
  @AmountCap money,
  @BalanceContractCap money,
  @BalanceAmountCapForBillingCode money,
  @AuthorizationRequired char(1),
  @ProviderAuthorizationId int,
  @AuthorizationUnitsUsed int,
  @CoveragePlanId int,
  @PlanName varchar(100),
  @PlanIsPended char(1),
  @RowCount int,
  @EOBReceived char(1),
  @DuplicateClaimLineId int,
  @IsDiagnosis1 char(1),
  @IsDiagnosis2 char(1),
  @IsDiagnosis3 char(1),
  @Diagnosis1 varchar(10),
  @Diagnosis2 varchar(10),
  @Diagnosis3 varchar(10),
  @DiagnosisAdmission varchar(10),
  @DiagnosisPrincipal varchar(10),
  @ContractDOSFrom datetime,
  @ContractDOSTo datetime,
  @ContractClaimLineUnitsPerDay decimal(18, 2),
  @ContractClaimLineUnits decimal(18, 2),
  @ErrorMsgId int,
  @ClaimLineUnitsApproved decimal(18, 2),
  @AdjudicationId int,
  @ExcludeDischargeDay char(1),
  @ValidAllPlans char(1),
  @PlanIsBillable char(1),
  @AuthorizationPartiallyApproved int,
  @AuthorizationPartiallyDenied int,
  @AuthorizationPended int,
  @ClientCoveragePlanId int,
  @COBPaidAmount money,
  @AllowMultipleClaimsPerDay char(1),
  @PreviousPayerEOBRequired char(1),
  @ClaimLineIdDenial int,
  @ClaimBundleId int,
  @BillingCodeModifierId int,
  @COBOrder int,
  @OriginalCOBOrder int,
  @ClaimDenialOverrideId int,
  @ClaimDenialOverrideRateNotFound char(1),
  @ClaimDenialOverrideRatePerUnit money,
  @BundleAdjudicationId int,
  @BundleClaimLineId int,
  @BundleClaimType char(1),
  @BundleIsValid varchar(10),
  @BundleInvalidReason varchar(100),
  @StartTime datetime,
  @EndTime datetime,
  @CopayAmount money,
  @ClientAge int,
  @PlaceOfService int,
  @MonthlyDeductibleMetAfterDateOfService char(1),
  @MonthlyDeductibleNotMetForDateOfService char(1),
  @AdjudicateSpendDown char(1),
  @IncludePendedAuthorizations char(1),
  @AddOnCode char(1),
  @BaseClaimLineId int,
  @BaseClaimLineStatus int,
  @ClaimApprovalOverrideId int,
  @ClaimApprovalOverrideReason varchar(250),
  @OverridePendedReason char(1),
  @LastAdjudicationId int,
  @ContractRuleIsBroken char(1)




begin try
	  
  set @TotalClaimLines = 0  
  set @TotalApprovedAmount = 0  
  set @TotalPendedAmount = 0  
  set @TotalDeniedAmount = 0  
  set @TotalLinesApproved = 0  
  set @TotalLinesPartiallyApproved = 0  
  set @TotalLinesPended = 0  
  set @TotalLinesDenied = 0  
		  
  set @EntryInComplete = 2021  
  set @EntryComplete = 2022  
  set @Approved = 2023  
  set @Denied = 2024  
  set @PartiallyApproved = 2025  
  set @Pended = 2027  
  set @Void = 2028  
  set @Paid = 2026  
		  
  set @Activity = 2002  
		  
  set @ProfessionalClaim = 2221  
  set @InstitutionalClaim = 2222  
		  
  set @AuthorizationApproved = 2042  
  set @AuthorizationClosed = 2044
  set @AuthorizationPartiallyApproved = 2048
  set @AuthorizationPartiallyDenied = 2049
  set @AuthorizationPended = 2045
  

 		  
  select  @FiscalMonth = isnull(max(FiscalMonth), 1)
  from    SystemConfigurations  

		   
  select  @AdjudicateSpendDown = sck.Value
  from    SystemConfigurationKeys sck
  where   sck.[Key] = 'AdjudicateSpendDown'
          and sck.Value in ('Y', 'N')

  if @AdjudicateSpendDown is null
    set @AdjudicateSpendDown = 'N'

	  
  -- For scroll bar update in GUI  
  insert  into AdjudicationProcessStatus
          (StaffId,
           ScrollId,
           ScrollValue,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  values  (@UserId,
           @ProgressCode,
           0,
           @UserCode,
           getdate(),
           @UserCode,
           getdate())  

		  
  -- Cursor for claimlines which are to be adjudicated  
  declare ClaimLines cursor
  for
  select  a.ClaimLineId
  from    AdjudicationProcessClaimLines a
          join ClaimLines cl on cl.ClaimLineId = a.ClaimLineId
          left join BillingCodes bc on bc.BillingCodeId = cl.BillingCodeId
  where   a.StaffId = @UserId
          and a.ScrollId = @ProgressCode
          AND ISNULL(CL.ClaimLineUnderReview,'N') <>'Y' -- Added by K.Soujanya on 20/Nov/2018
  order by cl.ClaimId,
          case when bc.AddOnCode = 'Y' then 2 -- Make sure add-on claim lines get adjudicated after primary claim lines
               else 1
          end,
          case when isnull(bc.AddOnCodeGroupName, '') <> '' then 1 -- In case if add-on code has add-on codes
               else 2
          end,
          a.ClaimLineId
	  
	  
  open ClaimLines  
  fetch next from ClaimLines into @ClaimLineId  
	  
  while @@fetch_status = 0 
    begin   
	  --Initializing variables and tables for next claim line  
      delete  from @TimePeriods  
      truncate table #Diagnoses  
      truncate table #DenialReasons
	  truncate table #AuthorizationsRates  
      truncate table #CoveragePlans 
      truncate table #CoveragePlanClaimBudgets
      truncate table #NewAdjudications
	  truncate table #AdjudicationRules

      select  @StatusOut = null,
              @Reason = '',
              @DenialReason = null,
              @PendedReason = null,
              @UnitsApproved = 0,
              @UnitsDenied = 0,
              @ApprovedAmount = 0,
              @ContractApprovedAmount = 0,
              @COBPaidAmount = 0,
              @DeniedAmount = 0,
              @PendedAmount = 0,
              @ClaimReceivedDays = 0,
              @DuplicateClaimLineId = null,
              @RowCount = 0,
              @BillingCodeModifierId = null,
              @ClaimDenialOverrideId = null,
			  @ClaimBundleId = null,
			  @BundleAdjudicationId = null,
			  @BundleClaimLineId = null,
			  @BundleClaimType = null,
              @BundleIsValid = null,
			  @BundleInvalidReason = null,
			  @CopayAmount = 0,
			  @BaseClaimLineId = null,
			  @ClaimApprovalOverrideId = null,
			  @IncludePendedAuthorizations = 'N'
			  
      begin transaction  
	  
	  -- Update table for scroll  
      update  AdjudicationProcessStatus
      set     ScrollValue = ScrollValue + 1
      where   ScrollId = @ProgressCode  
	   
 
	  -- Checking for claim line status  
      if exists ( select  *
                  from    ClaimLines
                  where   ClaimLineId = @ClaimLineId
                          and Status in (@Approved, @PartiallyApproved, @Paid) ) 
        begin   
          --raiserror ('Claim line has been adjudicated by another user', 16, 1);  
          goto NextClaimLine
        end  
	   
      if exists ( select  ClaimLineId
                  from    ClaimLines
                  where   ClaimLineId = @ClaimLineId
                          and (Status = @Void
                               or RecordDeleted = 'Y') ) 
        begin 
          --raiserror ('Claim line has been voided or deleted by another user', 16, 1);  
          goto NextClaimLine
        end           
	  
      if exists ( select  ClaimLineId
                  from    ClaimLines
                  where   ClaimLineId = @ClaimLineId
                          and Status = @EntryInComplete ) 
        begin 
          --raiserror ('Claim line has been changed to Entry Incomplete', 16, 1);  
          goto NextClaimLine
        end           
	  
      if exists ( select  ClaimLineId
                  from    ClaimLines
                  where   ClaimLineId = @ClaimLineId
                          and Status not in (@EntryComplete, @Denied, @Pended) ) 
        begin  
          --raiserror ('Claim line has to be in Entry Complete, Denied or Pended status to be adjudicated', 16, 1);  
          goto NextClaimLine
        end           
	  
	   
	  --Setting Claim Line Properties  
      select  @ClaimId = c.ClaimId,
              @RevenueCode = cl.RevenueCode,
              @HCPCSCode = cl.ProcedureCode,
              @BillingCodeId = cl.BillingCodeId,
              @Modifier1 = isnull(cl.Modifier1, ''),
              @Modifier2 = isnull(cl.Modifier2, ''),
              @Modifier3 = isnull(cl.Modifier3, ''),
              @Modifier4 = isnull(cl.Modifier4, ''),
              @DOSFrom = cl.FromDate,
              @DOSTo = cl.ToDate,
              @StartTime = convert(datetime, convert(char(8), cl.FromDate, 101) + ' ' + isnull(convert(char(5), cl.StartTime, 108), '00:00')),
              @EndTime = convert(datetime, convert(char(8), cl.ToDate, 101) + ' ' + isnull(convert(char(5), cl.EndTime, 108), '00:00')),
              @StatusIn = cl.Status,
              @ClaimLineRate = case when cl.Units > 0 then cl.Charge / cl.Units
                                    else 0
                               end,
              @ClaimedAmount = cl.ClaimedAmount,
              @PayableAmount = cl.PayableAmount,
              @UnitsClaimed = cl.Units,
              @RenderingProviderId = isnull(cl.RenderingProviderId, c.RenderingProviderId),
              @SupervisingProviderId = isnull(cl.SupervisingProviderId, c.SupervisingProviderId),
              @NeedsToBeWorked = isnull(cl.NeedsToBeWorked, 'N'),
              @EOBReceived = isnull(cl.EOBReceived, 'N'),
              @IsDiagnosis1 = isnull(cl.Diagnosis1, 'N'),
              @IsDiagnosis2 = isnull(cl.Diagnosis2, 'N'),
              @IsDiagnosis3 = isnull(cl.Diagnosis3, 'N'),
              @ClaimType = c.ClaimType,
              @ClaimReceivedDate = c.ReceivedDate,
              @Diagnosis1 = c.Diagnosis1,
              @Diagnosis2 = c.Diagnosis2,
              @Diagnosis3 = c.Diagnosis3,
              @DiagnosisAdmission = DiagnosisAdmission,
              @DiagnosisPrincipal = DiagnosisPrincipal,
              @ClientId = c.ClientId,
              @SiteId = c.SiteId,
              @InsurerId = c.InsurerId,
              @ProviderId = s.ProviderId,
              @SiteName = s.SiteName,
              @ProviderName = case p.ProviderType
                                when 'I' then p.ProviderName + ', ' + p.FirstName
                                else p.ProviderName
                              end,
              @PlaceOfService = cl.PlaceOfService,
              @ClientAge = dbo.GetAge(ct.DOB, cl.FromDate),
			  @OverridePendedReason = isnull(cl.OverridePendedReason, 'N'),
			  @LastAdjudicationId = cl.LastAdjudicationId
      from    ClaimLines cl
              join Claims c on c.ClaimId = cl.ClaimId
              join Sites s on s.SiteId = c.SiteId
              join Providers p on p.ProviderId = s.ProviderId
              join Clients ct on ct.ClientId = c.ClientId
      where   ClaimLineId = @ClaimLineId;   
	  
	  
      -- Rules to adjudicate
      with  CTE_AdjudicationRules
              as (select  ar.AdjudicationRuleId,
                          ar.RuleTypeId,
                          ar.AllInsurers,
                          ari.InsurerId,
                          ar.ClaimLineStatusIfBroken,
                          ar.MarkClaimLineToBeWorked,
                          ar.RuleName,
                          row_number() over (partition by ar.RuleTypeId order by case when ar.SystemRequiredRule = 'Y' then 1
                                                                                      else 2
                                                                                 end, case when ari.InsurerId is not null then 1
                                                                                           else 2
                                                                                      end, case when ar.ClaimLineStatusIfBroken = 'D' then 1
                                                                                                else 2
                                                                                           end, case when ar.MarkClaimLineToBeWorked = 'Y' then 1
                                                                                                     else 2
                                                                                                end, ar.AdjudicationRuleId desc) as Ranking
                  from    dbo.AdjudicationRules ar
                          left join dbo.AdjudicationRuleInsurers ari on ari.AdjudicationRuleId = ar.AdjudicationRuleId
                                                                        and isnull(ari.RecordDeleted, 'N') = 'N'
                  where   ar.Active = 'Y'
                          and (ar.AllInsurers = 'Y'
                               or ari.InsurerId = @InsurerId)
                          and (ar.StartDate <= case when ar.RuleBasedOnEffectiveDate = 'C' then @DOSFrom
                                                    else getdate()
                                               end
                               or ar.StartDate is null)
                          and (dateadd(dd, 1, ar.EndDate) > case when ar.RuleBasedOnEffectiveDate = 'C' then @DOSFrom
                                                                 else getdate()
                                                            end
                               or ar.EndDate is null)
                          and isnull(ar.RecordDeleted, 'N') = 'N')
        insert  into #AdjudicationRules
                (AdjudicationRuleId,
                 RuleTypeId,
                 AllInsurers,
                 InsurerId,
                 ClaimLineStatusIfBroken,
                 MarkClaimLineToBeWorked,
                 RuleName)
        select  ar.AdjudicationRuleId,
                ar.RuleTypeId,
                ar.AllInsurers,
                ar.InsurerId,
                ar.ClaimLineStatusIfBroken,
                ar.MarkClaimLineToBeWorked,
                ar.RuleName
        from    CTE_AdjudicationRules ar
        where   ar.Ranking = 1
        union all
        select  -1,
                2588,
                'Y',
                @InsurerId,
                'D',
                'Y',
                'Critical System Error'

      -- Determine if pended authorizations shoould be considered
      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = 2582 -- Authorization for this claim is pended
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        begin
          set @IncludePendedAuthorizations = 'Y'
        end

      -- Determine if bundling is enabled:
	  --   2549 - Activity claim line cannot be adjudicated without an associated bundle claim line
	  --   2550 - Bundle claim line does not have the correct associated claim lines to bill
      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId in (2549, 2550)
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        begin

		  -- Check if the claim line is the activity claim line
          select top 1
                  @ClaimBundleId = clb.ClaimBundleId,
                  @BundleClaimLineId = clb.BundleClaimLineId,
                  @BundleAdjudicationId = case when cl.Status in (2023, 2025, 2026) then cl.LastAdjudicationId
                                               else null
                                          end,
                  @BundleClaimType = 'A'
          from    dbo.ssf_CMClaimLineBundles(@ClaimLineId, 'Activity') clb
                  join ClaimLines cl on cl.ClaimLineId = clb.BundleClaimLineId
          where   clb.ActivityClaimLineId = @ClaimLineId
                  and clb.ClaimType = 'Activity'

          -- Check if the claim line is the bundle claim line
          if @ClaimBundleId is null
            begin
              select top 1
                      @ClaimBundleId = clb.ClaimBundleId,
                      @BundleClaimLineId = clb.BundleClaimLineId,
                      @BundleAdjudicationId = case when cl.Status in (2023, 2025, 2026) then cl.LastAdjudicationId
                                                   else null
                                              end,
                      @BundleClaimType = 'B',
					  @BundleIsValid = clb.IsValid,
					  @BundleInvalidReason = clb.InvalidReason
              from    dbo.ssf_CMClaimLineBundles(@ClaimLineId, 'Bundle') clb
                      join ClaimLines cl on cl.ClaimLineId = clb.BundleClaimLineId
              where   clb.ActivityClaimLineId = @ClaimLineId
                      and clb.ClaimType = 'Bundle'
            end

        end

	  -- Activity claim line cannot be adjudicated without an associated bundle claim line
      set @DenialReason = 2549
 
      if @ClaimBundleId is not null and @BundleClaimType = 'A' 
        begin
		  -- If the bundle claim line was already approved, approve this activity claim line
          if @BundleClaimLineId is not null and @BundleAdjudicationId is not null
            begin
              set @ApprovedAmount = 0
              set @ClaimedAmount = 0
              set @PayableAmount = 0
              set @UnitsApproved = @UnitsClaimed

            end 
          else
            begin	        
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end	
				       
          goto ValidationEnd
        end     

	  -- Make sure that billing code ID is valid  
      if @BillingCodeId is not null
        and len(@HCPCSCode) > 0 
        if not exists ( select  *
                        from    BillingCodes
                        where   BillingCodeId = @BillingCodeId
                                and BillingCode = @HCPCSCode
                                and Active = 'Y'
                                and isnull(RecordDeleted, 'N') = 'N' ) 
          set @BillingCodeId = null  
	  
      if @BillingCodeId is not null
        and len(@RevenueCode) > 0
        and isnull(@HCPCSCode, '') = '' 
        if not exists ( select  *
                        from    BillingCodes
                        where   BillingCodeId = @BillingCodeId
                                and BillingCode = @RevenueCode
                                and Active = 'Y'
                                and isnull(RecordDeleted, 'N') = 'N' ) 
          set @BillingCodeId = null  
	  
	  -- Find billing code ID  
      if @BillingCodeId is null
        and len(@HCPCSCode) > 0 
        select  @BillingCodeId = BillingCodeId
        from    BillingCodes
        where   BillingCode = @HCPCSCode
                and Active = 'Y'
                and isnull(RecordDeleted, 'N') = 'N'  
	   
      if @BillingCodeId is null
        and len(@RevenueCode) > 0 
        select  @BillingCodeId = BillingCodeId
        from    BillingCodes
        where   BillingCode = @RevenueCode
                and Active = 'Y'
                and isnull(RecordDeleted, 'N') = 'N'  
	  
      update  ClaimLines
      set     BillingCodeId = @BillingCodeId
      where   ClaimLineId = @ClaimLineId
              and isnull(BillingCodeId, '') <> isnull(@BillingCodeId, '')  
	  
      select top 1
              @BillingCodeModifierId = bcm.BillingCodeModifierId
      from    BillingCodeModifiers bcm
      where   bcm.BillingCodeId = @BillingCodeId
              and isnull(bcm.Modifier1, '') = @Modifier1
              and isnull(bcm.Modifier2, '') = @Modifier2
              and isnull(bcm.Modifier3, '') = @Modifier3
              and isnull(bcm.Modifier4, '') = @Modifier4
              and isnull(bcm.RecordDeleted, 'N') = 'N'

      -- Invalid Billing Code
      set @DenialReason = 2521  
 
      if @BillingCodeId is null
        and exists ( select '*'
                     from   #AdjudicationRules ar
                     where  ar.RuleTypeId = @DenialReason
                            and (ar.AllInsurers = 'Y'
                                 or ar.InsurerId = @InsurerId) ) 
        begin  
          insert  into #DenialReasons
                  (ReasonId,
                   ReasonSpecifier)
          values  (@DenialReason,
                   case when len(@HCPCSCode) > 0 then ': ' + @HCPCSCode
                        when len(@RevenueCode) > 0 then ': ' + @RevenueCode
                        else null
                   end)
          -- If there is no billing, move to the next claim line
          goto ValidationEnd
        end  
	  
	  -- Invalid date(s) of service or number of units
      set @DenialReason = 2546

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if @DOSFrom > getdate()
            or @DOSTo > getdate()
            or @DOSFrom > @DOSTo
            or isnull(@UnitsClaimed, 0) <= 0 
            begin
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)

			  -- If claim line dates or number of units are invalid, move to the next claim line
              goto ValidationEnd
            end
        end      

      -- Get billing code properties  
      select  @ExcludeDischargeDay = ExcludeDischargeDay,
              @ValidAllPlans = ValidAllPlans,
              @AllowMultipleClaimsPerDay = AllowMultipleClaimsPerDay,
			  @AddOnCode = AddOnCode
      from    BillingCodes
      where   BillingCodeId = @BillingCodeId  

	  -- Same (duplicate) Claim Line Exists
      set @DenialReason = 2542

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin	
		  -- Check the AllowMultipleClaimsPerDay setting at the modifier level only if it is set to N at the billing code level
          if isnull(@AllowMultipleClaimsPerDay, 'N') = 'N'
           begin
              select top 1
                      @AllowMultipleClaimsPerDay = AllowMultipleClaimsPerDay
              from    BillingCodeModifiers
              where   BillingCodeId = @BillingCodeId
                      and isnull(Modifier1, '') = @Modifier1
                      and isnull(Modifier2, '') = @Modifier2
                      and isnull(Modifier3, '') = @Modifier3
                      and isnull(Modifier4, '') = @Modifier4
                      and isnull(RecordDeleted, 'N') = 'N'
            end
          
          select  @DuplicateClaimLineId = max(cl.ClaimLineId)
          from    Claimlines cl
                  join Claims c on cl.ClaimId = c.ClaimId
          where   cl.ClaimLineId <> @ClaimLineId
                  and c.Clientid = @ClientId
                  and c.InsurerId = @InsurerId
                  and c.Siteid = @SiteId
                  and cl.FromDate = @DOSFrom
                  and cl.ToDate = @DOSTo
                  and ((@StartTime between convert(datetime, convert(char(8), cl.FromDate, 101) + ' ' + isnull(convert(char(5), cl.StartTime, 108), '00:00'))
                                   and     dateadd(second, -1, convert(datetime, convert(char(8), cl.ToDate, 101) + ' ' + isnull(convert(char(5), cl.EndTime, 108), '00:00'))))
                       or (@EndTime between dateadd(second, 1, convert(datetime, convert(char(8), cl.FromDate, 101) + ' ' + isnull(convert(char(5), cl.StartTime, 108), '00:00')))
                                    and     convert(datetime, convert(char(8), cl.ToDate, 101) + ' ' + isnull(convert(char(5), cl.EndTime, 108), '00:00')))
                       or (@StartTime = convert(datetime, convert(char(8), cl.FromDate, 101) + ' ' + isnull(convert(char(5), cl.StartTime, 108), '00:00'))
                           and @EndTime = convert(datetime, convert(char(8), cl.ToDate, 101) + ' ' + isnull(convert(char(5), cl.EndTime, 108), '00:00')))) 
                  and cl.BillingCodeId = @BillingCodeId
                  and isnull(Modifier1, '') = @Modifier1
                  and isnull(Modifier2, '') = @Modifier2
                  and isnull(Modifier3, '') = @Modifier3
                  and isnull(Modifier4, '') = @Modifier4
                  and isnull(c.RecordDeleted, 'N') = 'N'
                  and isnull(cl.RecordDeleted, 'N') = 'N'
                  and cl.Status in (@Approved, @PartiallyApproved, @Paid)  
				  and cl.PlaceOfService = @PlaceOfService
				  and isnull(isnull(cl.RenderingProviderId, c.RenderingProviderId), -1) = isnull(@RenderingProviderId, -1)
				  

          if @DuplicateClaimLineId > 0
            and isnull(@AllowMultipleClaimsPerDay, 'N') = 'N' 
            begin  
              insert  into #DenialReasons
                      (ReasonId,
                       ReasonSpecifier)
              values  (@DenialReason,
                       ': #' + cast(@DuplicateClaimLineId as varchar))
              
            end  
        end    
		           	  
	  -- Validate diagnosis codes
      insert  into #Diagnoses
              (DiagnosisCode,
               IsValid,
               LevelOfImportance,
               ValidationType)
              exec dbo.ssp_CMValidateClaimLineDiagnosisCodes 
                @InsurerId = @InsurerId,
                @FromDate = @DOSFrom,
                @ClaimType = @ClaimType,
                @DiagnosisPrincipal = @DiagnosisPrincipal,
                @DiagnosisAdmission = @DiagnosisAdmission,
                @Diagnosis1 = @Diagnosis1,
                @Diagnosis2 = @Diagnosis2,
                @Diagnosis3 = @Diagnosis3,
                @IsDiagnosis1 = @IsDiagnosis1,
                @IsDiagnosis2 = @IsDiagnosis2,
                @IsDiagnosis3 = @IsDiagnosis3


	  -- Invalid diagnosis code 
      set @DenialReason = 2543  

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if exists ( select  *
                      from    #Diagnoses
                      where   IsValid = 'N' ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end  
        end
  
 	  -- Diagnosis not entered on claim 
      set @DenialReason = 2545
  
      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if not exists ( select  *
                          from    #Diagnoses ) 
            begin
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end     
        end
 
     
 	  -- Get authorizations and rates  
      insert  into #AuthorizationsRates
              (Date,
               ProviderAuthorizationId,
               AuthorizationUnitsUsed,
               ClaimLineUnitsApproved,
               ClaimLineUnits,
               ContractId,
               ContractRateId,
               ContractRate,
               ContractRuleId)
              exec ssp_CMGetAuthorizationsRatesForClaimLineApproval @ClaimLineId = @ClaimLineId, @IncludePendedAuthorizations = @IncludePendedAuthorizations
	  
	  update ar
	     set ar.Status = pa.Status
	    from #AuthorizationsRates ar
		     join ProviderAuthorizations pa on pa.ProviderAuthorizationId = ar.ProviderAuthorizationId

	  -- If there is no record in #AuthorizationsRates, there is something wrong with either From and To dates or units.
	  -- Deny this claim line with 'Invalid date(s) of service or number of units' reason.
      if not exists ( select  *
                      from    #AuthorizationsRates ) 
        begin
          set @DenialReason = 2546  

          insert  into #DenialReasons
                  (ReasonId)
          values  (@DenialReason)

          goto ValidationEnd
        end
	  
	  -- Claim includes discharge day  
      set @DenialReason = 2538

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin							
		  -- If an authorization found, but it does not cover the last day of claim line,
		  -- we assume that the last day is a discharge day
          if @ExcludeDischargeDay = 'Y'
            and exists ( select *
                         from   #AuthorizationsRates
                         where  ClaimLineUnitsApproved > 0 )
            and exists ( select *
                         from   #AuthorizationsRates
                         where  Date = @DOSTo
                                and isnull(ClaimLineUnitsApproved, 0) = 0 ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end 
        end 
	  
	  -- Dates of service not fully covered by contracts  
      set @DenialReason = 2573

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin	
          if exists ( select  *
                      from    #AuthorizationsRates
                      where   ContractId is null )
            and exists ( select *
                         from   #AuthorizationsRates
                         where  ContractId is not null ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end  
        end
        
	  -- No contract exists for any claimed date of service 
      set @DenialReason = 2522

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin	
          if exists ( select  *
                      from    #AuthorizationsRates
                      where   ContractId is null )
            and not exists ( select *
                             from   #AuthorizationsRates
                             where  ContractId is not null ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end  
        end
      
	  -- No rate can be found for this claim line  
      set @DenialReason = 2541

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin	
          if exists ( select  *
                      from    #AuthorizationsRates
                      where   ContractRateId is null ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end  
        end
      
	  -- Rendering Provider is required for this service  
      set @DenialReason = 2529

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin	
          if exists ( select  *
                      from    #AuthorizationsRates ar 
					          join ContractRates cr on cr.ContractRateId = ar.ContractRateId
                      where   cr.RequiresAffilatedProvider = 'Y') 
            begin  
              if @RenderingProviderId is null
                begin  
                  insert  into #DenialReasons
                          (ReasonId)
                  values  (@DenialReason)
                end  
	    
			  -- Specified Rendering Provider is not associated with the Contract  
              set @DenialReason = 2530

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) ) 
                begin
                  if exists ( select  *
                              from    #AuthorizationsRates ar
							          join ContractRates cr on cr.ContractRateId = ar.ContractRateId
                              where   cr.RequiresAffilatedProvider = 'Y'
                                      and isnull(cr.AllAffiliatedProviders, 'N') <> 'Y'
                                      and @RenderingProviderId is not null
                                      and not exists ( select *
                                                       from   ContractRateAffiliates cra
                                                       where  cra.ContractRateId = cr.ContractRateId
                                                              and cra.ProviderId = @RenderingProviderId
                                                              and isnull(cra.RecordDeleted, 'N') = 'N' ) ) 
                    begin  
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)
                    end  
                end
	  
			  -- Specified Rendering Provider is not associated with the Provider  
              set @DenialReason = 2531
			            
              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) ) 
                begin
                  if @RenderingProviderId is not null
                    and not exists ( select *
                                     from   ProviderAffiliates pa
                                     where  pa.ProviderId = @ProviderId
                                            and pa.AffiliateProviderId = @RenderingProviderId
                                            and isnull(pa.RecordDeleted, 'N') = 'N' ) 
                    begin  
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)
                    end  
                end
      
			  -- Rendering Provider is not Credentialed  
              set @DenialReason = 2532

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin
                  if @RenderingProviderId is not null
                    and exists ( select *
                                 from   Contracts c
                                 where  c.CredentialedRenderingProvider = 'Y'
                                        and dbo.sf_IsProviderCredentialed(@InsurerId, @RenderingProviderId, null, @DOSFrom, @DOSTo, @BillingCodeId, @Modifier1, @Modifier2, @Modifier3, @Modifier4) <> 'Y'
                                        and exists ( select *
                                                     from   #AuthorizationsRates ar
                                                     where  ar.ContractId = c.ContractId ) )
                    begin  
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)
                    end  
                end
            end  
        end  

	  -- Provider not Credentialed  
      set @DenialReason = 2561

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if exists ( select  *
                      from    Contracts c
                      where   c.ProviderSiteCredentialed = 'Y'
                              and dbo.sf_IsProviderCredentialed(@InsurerId, @ProviderId, @SiteId, @DOSFrom, @DOSTo, @BillingCodeId, @Modifier1, @Modifier2, @Modifier3, @Modifier4) <> 'Y'
                              and exists ( select *
                                           from   #AuthorizationsRates ar
                                           where  ar.ContractId = c.ContractId ) ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end  
        end	  

	  -- Claim was received after the period mentioned in the Contract  
      set @DenialReason = 2523

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if exists ( select  *
                      from    Contracts c
                      where   c.ClaimsReceivedDays < datediff(day, @DOSTo, @ClaimReceivedDate)
                              and c.ClaimsReceivedDays > 0
                              and c.DelayedClaimsAction = 'D'
                              and exists ( select *
                                           from   #AuthorizationsRates ar
                                           where  ar.ContractId = c.ContractId ) ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId,
                       OverrideRuleClaimLineStatus)
              values  (@DenialReason,
                       'D')
            end  
	  
          if exists ( select  *
                      from    Contracts c
                      where   c.ClaimsReceivedDays < datediff(day, @DOSTo, @ClaimReceivedDate)
                              and c.ClaimsReceivedDays > 0
                              and c.DelayedClaimsAction = 'P'
                              and exists ( select *
                                           from   #AuthorizationsRates ar
                                           where  ar.ContractId = c.ContractId ) ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId,
                       OverrideRuleClaimLineStatus)
              values  (@DenialReason,
                       'P')
            end  
        end  

      -- Member is not eligible for any Plan  
      set @DenialReason = 2540

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if not exists ( select  *
                          from    ClientCoveragePlans ccp
                                  join dbo.ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                  join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                                  join dbo.Insurers i on i.ServiceAreaId = cch.ServiceAreaId
                          where   ccp.ClientId = @ClientId
                                  and i.InsurerId = @InsurerId
                                  and isnull(cp.ThirdPartyPlan, 'N') = 'N'
                                  and cch.StartDate <= @DOSFrom
                                  and (dateadd(dd, 1, cch.EndDate) > @DOSTo
                                       or cch.EndDate is null)
                                  and (i.ValidAllCoveragePlans = 'Y'
                                       or exists ( select *
                                                   from   InsurerValidCoveragePlans ivcp
                                                   where  ivcp.InsurerId = i.InsurerId
                                                          and ivcp.CoveragePlanId = cp.CoveragePlanId
                                                          and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
                                  and isnull(cch.RecordDeleted, 'N') = 'N'
                                  and isnull(ccp.RecordDeleted, 'N') = 'N'
                                  and isnull(i.RecordDeleted, 'N') = 'N' ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)

              goto ValidationEnd  
            end  
        end	  

	  -- Third party plan
      if @EOBReceived = 'Y'
        and exists ( select *
                     from   dbo.ClaimLineCOBPaymentAdjustments  -- At least one row needs to be entered to consider it EOB Received
                     where  ClaimLineId = @ClaimLineId
                            and isnull(RecordDeleted, 'N') = 'N' ) 
        set @DenialReason = 2578 -- Claim line has to be approved manually after Third Party EOB received  
      else 
        set @DenialReason = 2574 -- Waiting for Third Party EOB

      set @PreviousPayerEOBRequired = 'Y'

      select  @PreviousPayerEOBRequired = max(isnull(cr.PreviousPayerEOBRequired, 'Y'))
      from    #AuthorizationsRates ar
              join ContractRules cr on cr.ContractRuleId = ar.ContractRuleId

      if isnull(@PreviousPayerEOBRequired, 'Y') = 'Y'
        and exists ( select '*'
                     from   #AdjudicationRules ar
                     where  ar.RuleTypeId = @DenialReason
                            and (ar.AllInsurers = 'Y'
                                 or ar.InsurerId = @InsurerId) ) 
        begin
          if exists ( select  *
                      from    ClientCoveragePlans ccp
                              join dbo.ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                              join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                              join dbo.Insurers i on i.ServiceAreaId = cch.ServiceAreaId
                      where   ccp.ClientId = @ClientId
                              and i.InsurerId = @InsurerId
                              and cp.ThirdPartyPlan = 'Y'
                              and ((cch.StartDate <= @DOSFrom
                                    and (dateadd(dd, 1, cch.EndDate) > @DOSFrom
                                         or cch.EndDate is null))
                                   or (cch.StartDate >= @DOSFrom
                                       and cch.StartDate <= @DOSTo))
                              and (i.ValidAllCoveragePlans = 'Y'
                                   or exists ( select *
                                               from   InsurerValidCoveragePlans ivcp
                                               where  ivcp.InsurerId = i.InsurerId
                                                      and ivcp.CoveragePlanId = cp.CoveragePlanId
                                                      and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
                              and isnull(cch.RecordDeleted, 'N') = 'N'
                              and isnull(ccp.RecordDeleted, 'N') = 'N'
                              and isnull(i.RecordDeleted, 'N') = 'N'
                              and (@ValidAllPlans = 'Y'
                                   or exists ( select *
                                               from   BillingCodeValidCoveragePlans vp
                                               where  vp.BillingCodeId = @BillingCodeId
                                                      and vp.CoveragePlanId = cp.CoveragePlanId
                                                      and isnull(vp.RecordDeleted, 'N') = 'N' )) ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end
        end  

		
	  -- Third party plan is fully responsible
      set @DenialReason = 2551 

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        begin
          if exists ( select  *
                      from    ClientCoveragePlans ccp
                              join dbo.ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                              join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                              join dbo.Insurers i on i.ServiceAreaId = cch.ServiceAreaId
                      where   ccp.ClientId = @ClientId
                              and i.InsurerId = @InsurerId
                              and cp.ThirdPartyPlan = 'R' -- Fully responsible plan
                              and ((cch.StartDate <= @DOSFrom
                                    and (dateadd(dd, 1, cch.EndDate) > @DOSFrom
                                         or cch.EndDate is null))
                                   or (cch.StartDate >= @DOSFrom
                                       and cch.StartDate <= @DOSTo))
                              and (i.ValidAllCoveragePlans = 'Y'
                                   or exists ( select *
                                               from   InsurerValidCoveragePlans ivcp
                                               where  ivcp.InsurerId = i.InsurerId
                                                      and ivcp.CoveragePlanId = cp.CoveragePlanId
                                                      and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
                              and isnull(cch.RecordDeleted, 'N') = 'N'
                              and isnull(ccp.RecordDeleted, 'N') = 'N'
                              and isnull(i.RecordDeleted, 'N') = 'N'
                              and (@ValidAllPlans = 'Y'
                                   or exists ( select *
                                               from   BillingCodeValidCoveragePlans vp
                                               where  vp.BillingCodeId = @BillingCodeId
                                                      and vp.CoveragePlanId = cp.CoveragePlanId
                                                      and isnull(vp.RecordDeleted, 'N') = 'N' ))
                              and not exists ( select *
                                               from   dbo.CoveragePlanFullyResponsibleOverrides o
                                               where  isnull(o.RecordDeleted, 'N') = 'N'
                                                      and o.CoveragePlanId = cp.CoveragePlanId
                                                      and o.Active = 'Y'
                                                      and (o.StartDate <= @DOSFrom
                                                           or o.StartDate is null)
                                                      and (o.EndDate >= @DOSFrom
                                                           or o.EndDate is null)
                                                      and (o.ClientStartAge <= @ClientAge
                                                           or o.ClientStartAge is null)
                                                      and (o.ClientEndAge >= @ClientAge
                                                           or o.ClientEndAge is null)
                                                      and (o.AllClients = 'Y'
                                                           or exists ( select *
                                                                       from   dbo.CoveragePlanFullyResponsibleOverrideClients oc
                                                                       where  oc.CoveragePlanFullyResponsibleOverrideId = o.CoveragePlanFullyResponsibleOverrideId
                                                                              and oc.ClientId = @ClientId
                                                                              and isnull(oc.RecordDeleted, 'N') = 'N' ))
                                                      and (o.InsurerGroupName is null
                                                           or exists ( select *
                                                                       from   dbo.CoveragePlanFullyResponsibleOverrideInsurers opi
                                                                       where  opi.CoveragePlanFullyResponsibleOverrideId = o.CoveragePlanFullyResponsibleOverrideId
                                                                              and opi.InsurerId = @InsurerId
                                                                              and isnull(opi.RecordDeleted, 'N') = 'N' ))
                                                      and (o.ProviderSiteGroupName is null
                                                           or exists ( select *
                                                                       from   dbo.CoveragePlanFullyResponsibleOverrideProviderSites ops
                                                                       where  ops.CoveragePlanFullyResponsibleOverrideId = o.CoveragePlanFullyResponsibleOverrideId
                                                                              and ((ops.ProviderId = @ProviderId
                                                                                    and ops.SiteId is null)
                                                                                   or (ops.SiteId = @SiteId))
                                                                              and isnull(ops.RecordDeleted, 'N') = 'N' ))
                                                      and (o.BillingCodeGroupName is null
                                                           or exists ( select *
                                                                       from   dbo.CoveragePlanFullyResponsibleOverrideBillingCodes opbc
                                                                              join dbo.BillingCodeModifiers bcm on bcm.BillingCodeModifierId = opbc.BillingCodeModifierId
                                                                       where  opbc.CoveragePlanFullyResponsibleOverrideId = o.CoveragePlanFullyResponsibleOverrideId
                                                                              and ((opbc.ApplyToAllModifiers = 'Y'
                                                                                    and bcm.BillingCodeId = @BillingCodeId)
                                                                                   or (opbc.BillingCodeModifierId = @BillingCodeModifierId))
                                                                              and isnull(opbc.RecordDeleted, 'N') = 'N'
                                                                              and isnull(bcm.RecordDeleted, 'N') = 'N' ))
                                                      and (o.PlaceOfServiceGroupName is null
                                                           or exists ( select *
                                                                       from   dbo.CoveragePlanFullyResponsibleOverridePlaceOfServices opos
                                                                       where  opos.CoveragePlanFullyResponsibleOverrideId = o.CoveragePlanFullyResponsibleOverrideId
                                                                              and opos.PlaceOfService = @PlaceOfService
                                                                              and isnull(opos.RecordDeleted, 'N') = 'N' ))
                                                      and (o.DiagnosisCodeCategoryGroupName is null
                                                           or exists ( select *
                                                                       from   dbo.CoveragePlanFullyResponsibleOverrideDiagnosisCodeCategories odcc
                                                                              join DiagnosisDSMVCodeCategories dcc on dcc.DiagnosisDSMVCodeCategoryId = odcc.DiagnosisDSMVCodeCategoryId
                                                                              join #Diagnoses d on d.DiagnosisCode = dcc.ICD10Code
                                                                       where  odcc.CoveragePlanFullyResponsibleOverrideId = o.CoveragePlanFullyResponsibleOverrideId
                                                                              and isnull(odcc.RecordDeleted, 'N') = 'N'
                                                                              and isnull(dcc.RecordDeleted, 'N') = 'N' )) ) )
            begin
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)

            end
        end 

	  -- Get coverage plan   
      insert  into #CoveragePlans
              (CoveragePlanId,
               CoveragePlanName,
               ClientCoveragePlanId,
               PlanIsBillable,
               COBOrder)
      select  cp.CoveragePlanId,
              cp.CoveragePlanName,
              ccp.ClientCoveragePlanId,
              case when @ValidAllPlans = 'Y'
                        or bp.PlanIsBillable = 'Y' then 'Y'
                   else 'N'
              end,
              row_number() over (order by case when @ValidAllPlans = 'Y'
                                                    or bp.PlanIsBillable = 'Y' then 1
                                               else 2
                                          end, cch.COBOrder)
      from    ClientCoveragePlans ccp
              join dbo.ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
              join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
              join dbo.Insurers i on i.ServiceAreaId = cch.ServiceAreaId
              left join (select bcvcp.CoveragePlanId,
                                'Y' as PlanIsBillable
                         from   BillingCodeValidCoveragePlans bcvcp
                         where  bcvcp.BillingCodeId = @BillingCodeId
                                and isnull(bcvcp.RecordDeleted, 'N') = 'N') as bp on bp.CoveragePlanId = cp.CoveragePlanId
      where   ccp.ClientId = @ClientId
              and i.InsurerId = @InsurerId
              and isnull(cp.ThirdPartyPlan, 'N') = 'N'
              and cch.StartDate <= @DOSFrom
              and (dateadd(dd, 1, cch.EndDate) > @DOSTo
                   or cch.EndDate is null)
              and (i.ValidAllCoveragePlans = 'Y'
                   or exists ( select *
                               from   InsurerValidCoveragePlans ivcp
                               where  ivcp.InsurerId = i.InsurerId
                                      and ivcp.CoveragePlanId = cp.CoveragePlanId
                                      and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
              and isnull(cch.RecordDeleted, 'N') = 'N'
              and isnull(ccp.RecordDeleted, 'N') = 'N'
              and isnull(i.RecordDeleted, 'N') = 'N'

      -- The date of service occurred before the date the monthly deductible was met  
      update  cp
      set     MonthlyDeductibleMetAfterDateOfService = 'Y'
      from    #CoveragePlans cp
      where   cp.PlanIsBillable = 'Y'
              and exists ( select '*'
                           from   ClientMonthlyDeductibles cmd
                                  cross join #AuthorizationsRates ar
                           where  cmd.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                  and cmd.DeductibleYear = datepart(yy, ar.Date)
                                  and cmd.DeductibleMonth = datepart(mm, ar.Date)
                                  and isnull(cmd.RecordDeleted, 'N') = 'N' )
              and exists ( select '*'
                           from   dbo.ClientMonthlyDeductibles cmd
                                  cross join #AuthorizationsRates ar
                           where  cmd.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                  and cmd.DeductibleMet = 'Y'
                                  and cmd.DeductibleMonth = datepart(month, ar.Date)
                                  and cmd.DeductibleYear = datepart(year, ar.Date)
                                  and ar.Date < cmd.DateMet
                                  and isnull(cmd.RecordDeleted, 'N') = 'N' ) 

      -- Monthly deductible not met for period covering date of service 
      update  cp
      set     MonthlyDeductibleNotMetForDateOfService = 'Y'
      from    #CoveragePlans cp
      where   cp.PlanIsBillable = 'Y'
              and exists ( select '*'
                           from   ClientMonthlyDeductibles cmd
                                  cross join #AuthorizationsRates ar
                           where  cmd.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                  and cmd.DeductibleYear = datepart(yy, ar.Date)
                                  and cmd.DeductibleMonth = datepart(mm, ar.Date)
                                  and isnull(cmd.RecordDeleted, 'N') = 'N' )
              and not exists ( select '*'
                               from   (select count(distinct ar.Date) as Days
                                       from   dbo.ClientMonthlyDeductibles cmd
                                              cross join #AuthorizationsRates ar
                                       where  cmd.ClientCoveragePlanId = cp.ClientCoveragePlanId
                                              and cmd.DeductibleMet = 'Y'
                                              and cmd.DeductibleMonth = datepart(month, ar.Date)
                                              and cmd.DeductibleYear = datepart(year, ar.Date)
                                              and ar.Date >= cmd.DateMet
                                              and isnull(cmd.RecordDeleted, 'N') = 'N') cmd
                                      join (select  count(distinct ar.Date) as Days
                                            from    #AuthorizationsRates ar) d on d.Days = cmd.Days ) 
 

      select  @CoveragePlanId = cp.CoveragePlanId,
              @PlanName = cp.CoveragePlanName,
              @ClientCoveragePlanId = cp.ClientCoveragePlanId,
              @PlanIsBillable = cp.PlanIsBillable,
              @COBOrder = cp.COBOrder,
              @MonthlyDeductibleMetAfterDateOfService = cp.MonthlyDeductibleMetAfterDateOfService,
              @MonthlyDeductibleNotMetForDateOfService = cp.MonthlyDeductibleNotMetForDateOfService
      from    #CoveragePlans cp
      where   cp.COBOrder = 1
		                               
	  -- Billing code not associated with the Member's Plan 
      set @DenialReason = 2564

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        and isnull(@PlanIsBillable, 'N') = 'N'
        begin
          
          insert  into #DenialReasons
                  (ReasonId)
          values  (@DenialReason)
        end
      
	  -- Associated plan is pending  
      set @DenialReason = 2575

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        and @PlanIsPended = 'Y'
        begin
          insert  into #DenialReasons
                  (ReasonId)
          values  (@DenialReason)
        end   
	  

	  -- The date of service occurred before the date the monthly deductible was met  
      set @DenialReason = 2577

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        and @MonthlyDeductibleMetAfterDateOfService = 'Y'
        begin
          insert  into #DenialReasons
                  (ReasonId)
          values  (@DenialReason)
        end
      
	  -- Monthly deductible not met for period covering date of service  
      set @DenialReason = 2565

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        and @MonthlyDeductibleNotMetForDateOfService = 'Y'
        begin
          insert  into #DenialReasons
                  (ReasonId)
          values  (@DenialReason)

        end

      -- Check if the next plan in COB order should be used in case of the monthly deductitable denial reasons
      if exists ( select  *
                  from    #DenialReasons
                  where   ReasonId in (2577, 2565) )
        and @AdjudicateSpendDown = 'Y'
        begin
          if exists ( select  *
                      from    #CoveragePlans cp
                      where   cp.PlanIsBillable = 'Y'
                              and cp.MonthlyDeductibleMetAfterDateOfService = 'N'
                              and cp.MonthlyDeductibleNotMetForDateOfService = 'N'
                              and cp.COBOrder > @COBOrder )
            begin
              delete  #DenialReasons
              where   ReasonId in (2577, 2565) 

              select top 1
                      @CoveragePlanId = cp.CoveragePlanId,
                      @PlanName = cp.CoveragePlanName,
                      @ClientCoveragePlanId = cp.ClientCoveragePlanId,
                      @PlanIsBillable = cp.PlanIsBillable,
                      @COBOrder = cp.COBOrder,
                      @MonthlyDeductibleMetAfterDateOfService = cp.MonthlyDeductibleMetAfterDateOfService,
                      @MonthlyDeductibleNotMetForDateOfService = cp.MonthlyDeductibleNotMetForDateOfService
              from    #CoveragePlans cp
              where   cp.PlanIsBillable = 'Y'
                      and cp.MonthlyDeductibleMetAfterDateOfService = 'N'
                      and cp.MonthlyDeductibleNotMetForDateOfService = 'N'
                      and cp.COBOrder > @COBOrder
            end
        end

	  -- Check billing rules   
      declare Contracts_Cursor cursor
      for
      select  ar.ContractId,
              max(ar.ContractRuleId),
              min(ar.Date),
              max(ar.Date),
              max(ar.ClaimLineUnits),
              sum(ar.ClaimLineUnits)
      from    (select ContractId,
                      Date,
                      sum(ClaimLineUnits) as ClaimLineUnits,
                      max(ContractRuleId) as ContractRuleId
               from   #AuthorizationsRates
               group by ContractId,
                      Date) ar
      group by ar.ContractId  
	  
	  set @ContractRuleIsBroken = 'N'

      open Contracts_Cursor  
      fetch from Contracts_Cursor into @ContractId, @ContractRuleId, @ContractDOSFrom, @ContractDOSTo, @ContractClaimLineUnitsPerDay, @ContractClaimLineUnits  
	  
      while @@fetch_status = 0
        begin  
		  -- Standard rule information
          select  @StandardUnlimitedDailyUnits = isnull(UnlimitedDailyUnits, 'N'),
                  @StandardDailyUnits = DailyUnits,
                  @StandardUnlimitedWeeklyUnits = isnull(UnlimitedWeeklyUnits, 'N'),
                  @StandardWeeklyUnits = WeeklyUnits,
                  @StandardUnlimitedMonthlyUnits = isnull(UnlimitedMonthlyUnits, 'N'),
                  @StandardMonthlyUnits = MonthlyUnits,
                  @StandardUnlimitedYearlyUnits = isnull(UnlimitedYearlyUnits, 'N'),
                  @StandardYearlyUnits = YearlyUnits,
                  @StandardExceedLimitAction = isnull(ExceedLimitAction, 'D')
          from    BillingCodes
          where   BillingCodeId = @BillingCodeId   

		  -- Contract rule information  
          if @ContractRuleId is not null
            select  @UnlimitedDailyUnits = isnull(UnlimitedDailyUnits, 'N'),
                    @DailyUnits = DailyUnits,
                    @UnlimitedWeeklyUnits = isnull(UnlimitedWeeklyUnits, 'N'),
                    @WeeklyUnits = WeeklyUnits,
                    @UnlimitedMonthlyUnits = isnull(UnlimitedMonthlyUnits, 'N'),
                    @MonthlyUnits = MonthlyUnits,
                    @UnlimitedYearlyUnits = isnull(UnlimitedYearlyUnits, 'N'),
                    @YearlyUnits = YearlyUnits,
                    @AmountCap = isnull(AmountCap, 0),
                    @BalanceAmountCapForBillingCode = isnull(AmountCap, 0) - isnull(TotalAmountUsed, 0),
                    @AuthorizationRequired = isnull(AuthorizationRequired, 'N'),
                    @ExceedLimitAction = isnull(ExceedLimitAction, 'D')
            from    ContractRules
            where   ContractRuleId = @ContractRuleId  
          else
            select  @UnlimitedDailyUnits = isnull(UnlimitedDailyUnits, 'N'),
                    @DailyUnits = DailyUnits,
                    @UnlimitedWeeklyUnits = isnull(UnlimitedWeeklyUnits, 'N'),
                    @WeeklyUnits = WeeklyUnits,
                    @UnlimitedMonthlyUnits = isnull(UnlimitedMonthlyUnits, 'N'),
                    @MonthlyUnits = MonthlyUnits,
                    @UnlimitedYearlyUnits = isnull(UnlimitedYearlyUnits, 'N'),
                    @YearlyUnits = YearlyUnits,
                    @AmountCap = 0,
                    @BalanceAmountCapForBillingCode = 0,
                    @AuthorizationRequired = isnull(AuthorizationRequired, 'N'),
                    @ExceedLimitAction = isnull(ExceedLimitAction, 'D')
            from    BillingCodes
            where   BillingCodeId = @BillingCodeId   
	  
          update  #AuthorizationsRates
          set     AuthorizationRequired = @AuthorizationRequired
          where   ContractId = @ContractId  
	  
          delete  from @TimePeriods  
	             
          if (@UnlimitedDailyUnits <> 'Y'
              or @StandardUnlimitedDailyUnits <> 'Y')
            begin  
              insert  into @TimePeriods
                      (TimePeriod,
                       FromDate,
                       ToDate,
                       UnitLimit,
                       StandardUnitLimit,
                       CheckContractRule,
                       CheckStandardRule)
              select  'D',
                      ar.Date,
                      ar.Date,
                      @DailyUnits,
                      @StandardDailyUnits,
                      case when @UnlimitedDailyUnits <> 'Y' and @ContractRuleId is not null then 'Y'
                           else 'N'
                      end,
                      case when @StandardUnlimitedDailyUnits <> 'Y' then 'Y'
                           else 'N'
                      end
              from    #AuthorizationsRates ar
              where   ar.ContractId = @ContractId
              group by ar.ContractId,
                      ar.Date  
            end  
	      
          if (@UnlimitedWeeklyUnits <> 'Y'
              or @StandardUnlimitedWeeklyUnits <> 'Y')
            begin  
              select  @i = 1,
                      @n = datediff(week, @ContractDOSFrom, @ContractDOSTo) + 1  
	  
              while @i <= @n
                begin  
                  insert  into @TimePeriods
                          (TimePeriod,
                           FromDate,
                           UnitLimit,
                           StandardUnitLimit,
                           CheckContractRule,
                           CheckStandardRule)
                  select  'W',
                          dateadd(dd, (7 * (@i - 1)) + (1 - datepart(weekday, @ContractDOSFrom)), @ContractDOSFrom),
                          @WeeklyUnits,
                          @StandardWeeklyUnits,
                          case when @UnlimitedWeeklyUnits <> 'Y' and @ContractRuleId is not null then 'Y'
                               else 'N'
                          end,
                          case when @StandardUnlimitedWeeklyUnits <> 'Y' then 'Y'
                               else 'N'
                          end

                  set @i = @i + 1  
                end   

              update  @TimePeriods
              set     ToDate = dateadd(dd, 6, FromDate)
              where   TimePeriod = 'W'  
            end  

          if (@UnlimitedMonthlyUnits <> 'Y'
              or @StandardUnlimitedMonthlyUnits <> 'Y')
            begin  
              select  @i = 1,
                      @n = datediff(month, @ContractDOSFrom, @ContractDOSTo) + 1  
	  
              while @i <= @n
                begin  
                  insert  into @TimePeriods
                          (TimePeriod,
                           FromDate,
                           UnitLimit,
                           StandardUnitLimit,
                           CheckContractRule,
                           CheckStandardRule)
                  select  'M',
                          dateadd(mm, @i - 1, dateadd(dd, 1 - datepart(day, @ContractDOSFrom), @ContractDOSFrom)),
                          @MonthlyUnits,
                          @StandardMonthlyUnits,
                          case when @UnlimitedMonthlyUnits <> 'Y' and @ContractRuleId is not null then 'Y'
                               else 'N'
                          end,
                          case when @StandardUnlimitedMonthlyUnits <> 'Y' then 'Y'
                               else 'N'
                          end  
                  set @i = @i + 1  
                end   

              update  @TimePeriods
              set     ToDate = dateadd(dd, -1, dateadd(mm, 1, FromDate))
              where   TimePeriod = 'M'  
            end  
	  
          if (@UnlimitedYearlyUnits <> 'Y'
              or @StandardUnlimitedYearlyUnits <> 'Y')
            begin  
              select  @FiscalYear = convert(varchar, @FiscalMonth) + '/01/' + convert(varchar, datepart(year, @DOSFrom))  
	  
              if datepart(month, @DOSFrom) < @FiscalMonth
                set @FiscalYear = dateadd(yy, -1, @FiscalYear)  
	  
              select  @i = 1,
                      @n = (datediff(mm, @FiscalYear, @DOSTo) / 12) + 1  
	  
              while @i <= @n
                begin  
                  insert  into @TimePeriods
                          (TimePeriod,
                           FromDate,
                           UnitLimit,
                           StandardUnitLimit,
                           CheckContractRule,
                           CheckStandardRule)
                  select  'Y',
                          dateadd(yy, @i - 1, @FiscalYear),
                          @YearlyUnits,
                          @StandardYearlyUnits,
                          case when @UnlimitedYearlyUnits <> 'Y' and @ContractRuleId is not null then 'Y'
                               else 'N'
                          end,
                          case when @StandardUnlimitedYearlyUnits <> 'Y' then 'Y'
                               else 'N'
                          end    
                  set @i = @i + 1  
                end  
				 
              update  @TimePeriods
              set     ToDate = dateadd(dd, -1, dateadd(yy, 1, FromDate))
              where   TimePeriod = 'Y'   
            end  
	  
          update  @TimePeriods
          set     ClaimLineUnits = @ContractClaimLineUnitsPerDay * (datediff(dd, case when FromDate < @ContractDOSFrom then @ContractDOSFrom
                                                                                      else FromDate
                                                                                 end, case when ToDate > @ContractDOSTo then @ContractDOSTo
                                                                                           else ToDate
                                                                                      end) + 1)  
	  
          update  tp
          set     OtherClaimLineUnits = ocu.OtherClaimLineUnits,
                  StandardOtherClaimLineUnits = ocu.StandardOtherClaimLineUnits
          from    @TimePeriods tp
                  join (select  tp.TimePeriod,
                                tp.FromDate,
                                tp.ToDate,
                                sum(case when cl.ProviderId = @ProviderId
                                              and tp.CheckContractRule = 'Y' then cl.UnitsPerDay * (datediff(dd, case when tp.FromDate < cl.FromDate then cl.FromDate
                                                                                                                      else tp.FromDate
                                                                                                                 end, case when tp.ToDate > cl.ToDate then cl.ToDate
                                                                                                                           else tp.ToDate
                                                                                                                      end) + 1)
                                         else 0
                                    end) as OtherClaimLineUnits,
                                sum(case when tp.CheckStandardRule = 'Y' then cl.UnitsPerDay * (datediff(dd, case when tp.FromDate < cl.FromDate then cl.FromDate
                                                                                                                  else tp.FromDate
                                                                                                             end, case when tp.ToDate > cl.ToDate then cl.ToDate
                                                                                                                       else tp.ToDate
                                                                                                                  end) + 1)
                                         else 0
                                    end) as StandardOtherClaimLineUnits
                        from    (select ceiling(cl.Units / (datediff(dd, cl.FromDate, cl.ToDate) + 1)) as UnitsPerDay,
                                        cl.FromDate,
                                        dateadd(dd, cl.Units / (ceiling(cl.Units / (datediff(dd, cl.FromDate, cl.ToDate) + 1))) - 1, cl.FromDate) as ToDate,
                                        s.ProviderId
                                 from   ClaimLines cl
                                        join Claims c on c.ClaimId = cl.ClaimId
                                        join Sites s on s.SiteId = c.SiteId
                                 where  c.ClientId = @ClientId
                                        and cl.BillingCodeId = @BillingCodeId
                                        and cl.Status in (@Paid, @Approved, @PartiallyApproved)
                                        and cl.Units > 0
                                        and isnull(cl.RecordDeleted, 'N') = 'N'
                                        and isnull(c.RecordDeleted, 'N') = 'N') cl
                                join @TimePeriods tp on ((tp.FromDate >= cl.FromDate
                                                          and tp.FromDate <= cl.ToDate)
                                                         or (cl.FromDate >= tp.FromDate
                                                             and cl.FromDate <= tp.ToDate))
                        group by tp.TimePeriod,
                                tp.FromDate,
                                tp.ToDate) as ocu on ocu.TimePeriod = tp.TimePeriod
                                                     and ocu.FromDate = tp.FromDate
                                                     and ocu.ToDate = tp.ToDate  

		  -- Billing Code Unit Frequency exceeds Contract Rules
          set @DenialReason = 2533

          if exists ( select  '*'
                      from    #AdjudicationRules ar
                      where   ar.RuleTypeId = @DenialReason
                              and (ar.AllInsurers = 'Y'
                                   or ar.InsurerId = @InsurerId) )
            begin			  
              if exists ( select  *
                          from    @TimePeriods tp
                          where   tp.ClaimLineUnits + isnull(tp.OtherClaimLineUnits, 0) > tp.UnitLimit
						          and tp.CheckContractRule = 'Y' )
                begin  
                  insert  into #DenialReasons
                          (ReasonId,
                           OverrideRuleClaimLineStatus)
                  values  (@DenialReason,
                           @ExceedLimitAction)	   
                  
				  set @ContractRuleIsBroken = 'Y'  
                end     
            end  

		  -- Multiple Providers exceed the Billing Code Standard Allowed Units
          set @DenialReason = 2552

          if exists ( select  '*'
                      from    #AdjudicationRules ar
                      where   ar.RuleTypeId = @DenialReason
                              and (ar.AllInsurers = 'Y'
                                   or ar.InsurerId = @InsurerId) )
            begin			  
              if exists ( select  *
                          from    @TimePeriods tp
                          where   tp.ClaimLineUnits + isnull(tp.StandardOtherClaimLineUnits, 0) > tp.StandardUnitLimit
								  and tp.CheckStandardRule = 'Y'
								  and tp.CheckContractRule = 'N')
                begin  
                  insert  into #DenialReasons
                          (ReasonId,
                           OverrideRuleClaimLineStatus)
                  values  (@DenialReason,
                           @StandardExceedLimitAction)	   

				  set @ContractRuleIsBroken = 'Y'  
                end     
            end  
	  
		  -- Contract rule amount cap  
          if @AmountCap > 0
            begin  
			  -- Contract Billing Code amount cap has been reached  
              set @DenialReason = 2534

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin			  
                  if @BalanceAmountCapForBillingCode <= 0
                    begin  
                      insert  into #DenialReasons
                              (ReasonId,
                               OverrideRuleClaimLineStatus)
                      values  (@DenialReason,
                               @ExceedLimitAction)	 
                  
  				      set @ContractRuleIsBroken = 'Y'  
                    end 
                end 
	      
			  -- Claimed amount exceeds remaining Contact Billing Code amount cap  
              set @DenialReason = 2535

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin			  
                  if @BalanceAmountCapForBillingCode < @ClaimedAmount
                    begin  
                      insert  into #DenialReasons
                              (ReasonId,
                               OverrideRuleClaimLineStatus)
                      values  (@DenialReason,
                               @ExceedLimitAction)	 
                  
                      set @ContractRuleIsBroken = 'Y'  
                    end 
                end  
            end   
	  
		  -- Contract amount cap  
	  
          select  @TotalAmountCap = isnull(TotalAmountCap, 0),
                  @BalanceContractCap = isnull(TotalAmountCap, 0) - isnull(ClaimsApprovedandPaid, 0)
          from    Contracts
          where   ContractId = @ContractId  
	     
          if @TotalAmountCap > 0
            begin  
		      -- Contract amount cap has been reached  
              set @DenialReason = 2536

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin			
                  if @BalanceContractCap <= 0
                    begin  
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)

                      set @ContractRuleIsBroken = 'Y'  
                    end  
                end
	   
			  -- Claimed amount exceeds remaining Contact amount cap  
              set @DenialReason = 2537

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin		
                  if @BalanceContractCap < @ClaimedAmount
                    begin  
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)

                      set @ContractRuleIsBroken = 'Y'  
                    end  
                end
            end  
	  
          if @AuthorizationRequired = 'Y'
            begin  
			  -- Billing code requires Authorization but one does not exist  
              set @DenialReason = 2526

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin			
                  if not exists ( select  *
                                  from    #AuthorizationsRates
                                  where   ProviderAuthorizationId is not null
                                          and ContractId = @ContractId )
                    begin   
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)

                      set @ContractRuleIsBroken = 'Y'  
                    end  
                end

			  -- Authorization for this claim is pended 
              set @DenialReason = 2582

              if exists ( select  '*'
                          from    #AdjudicationRules ar
                          where   ar.RuleTypeId = @DenialReason
                                  and (ar.AllInsurers = 'Y'
                                       or ar.InsurerId = @InsurerId) )
                begin			
                  if exists ( select  *
                              from    #AuthorizationsRates
                              where   ProviderAuthorizationId is not null
                                      and ContractId = @ContractId
                                      and Status = @AuthorizationPended )
                    begin   
                      insert  into #DenialReasons
                              (ReasonId)
                      values  (@DenialReason)

                      set @ContractRuleIsBroken = 'Y'  
                    end  
                end
            end  
	  
	      if @ContractRuleIsBroken = 'Y'
		    break

          fetch from Contracts_Cursor into @ContractId, @ContractRuleId, @ContractDOSFrom, @ContractDOSTo, @ContractClaimLineUnitsPerDay, @ContractClaimLineUnits  
        end  
	  
      close Contracts_Cursor  
      deallocate Contracts_Cursor  
	  
	  -- Multiple rates for claim date span  
	  -- If there is more than one contract rate, but approved units do no match claim line units,  
	  -- pend the claim line because it is impossible to allocate claim line amount between the contract rates  
      set @DenialReason = 2580

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin		
          if exists ( select  '*'
                      from    #AuthorizationsRates
                      having  count(distinct ContractRateId) > 1 )
            and exists ( select '*'
                         from   #AuthorizationsRates
                         having sum(case when AuthorizationRequired = 'Y' then isnull(ClaimLineUnitsApproved, 0)
                                         else ClaimLineUnits
                                    end) <> sum(ClaimLineUnits) ) 
            begin  
              insert  into #DenialReasons
                      (ReasonId)
              values  (@DenialReason)
            end  
        end 

	  -- Bundle claim line does not have the correct associated claim lines to bill
      set @DenialReason = 2550 

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) ) 
        begin
          if @ClaimBundleId is not null and @BundleClaimType = 'B' and @BundleIsValid = 'Invalid'
		    begin
              insert  into #DenialReasons
                      (ReasonId,
                       ReasonSpecifier)
                      select  @DenialReason,
                              ': ' + @BundleInvalidReason
            end    
        end 

		  
	  -- Calculate COB paid amount
      select  @COBPaidAmount = sum(clp.PaidAmount)
      from    dbo.ClaimLineCOBPaymentAdjustments clp
      where   clp.ClaimLineId = @ClaimLineId
              and isnull(clp.RecordDeleted, 'N') = 'N'

	  -- Calculate approved amount and units  
      select  @ContractApprovedAmount = sum(case when AuthorizationRequired = 'Y' then isnull(ClaimLineUnitsApproved, 0)
                                                 else ClaimLineUnits
                                            end * ContractRate),
              @UnitsApproved = sum(case when AuthorizationRequired = 'Y' then isnull(ClaimLineUnitsApproved, 0)
                                        else ClaimLineUnits
                                   end)
      from    #AuthorizationsRates  

	  -- Approved amount can never be > claimed amount  
	  -- Use only part of claimed amount in calculation if units approved < units claimed  
      if (@ContractApprovedAmount - isnull(@COBPaidAmount, 0)) > (@ClaimedAmount * @UnitsApproved / @UnitsClaimed) 
        set @ApprovedAmount = round(@ClaimedAmount * @UnitsApproved / @UnitsClaimed, 2)
      else 
        set @ApprovedAmount = round(@ContractApprovedAmount - isnull(@COBPaidAmount, 0), 2)

      if @ApprovedAmount < 0 
        set @ApprovedAmount = 0
	  
	  -- Check for critical error  
      if (@UnitsApproved > @UnitsClaimed
          or @ApprovedAmount > @ClaimedAmount)
        begin  
          insert  into #DenialReasons
                  (ReasonId,
                   ReasonSpecifier)
          select  2588, -- Critical System Error
                  ': ' + 'Units Approved or Amount Approved are greater than claimed'
 
          --raiserror ('Critical Error - Units Approved or Amount Approved are greater than claimed', 16, 1);
          goto ValidationEnd
        end  

      -- Coverage plan claim budget
      set @DenialReason = 2583 

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        and not exists ( select *
                         from   #DenialReasons
                         where  ReasonId in (2577, 2565, 2564, 2575) ) -- no coverage plan related denial reason
        begin

          insert  into #CoveragePlanClaimBudgets
                  (CoveragePlanId,
                   BudgetName,
                   CoveragePlanClaimBudgetId,
                   CascadeToNextPlanWhenOverBudget,
                   BudgetAmount,
                   PaidAmount,
                   CanBeUsed)
          select  cp.CoveragePlanId,
                  cpcb.BudgetName,
                  cpcb.CoveragePlanClaimBudgetId,
                  cpcb.CascadeToNextPlanWhenOverBudget,
                  cpcb.BudgetAmount,
                  cpcb.PaidAmount,
                  case when isnull(cpcb.BudgetAmount, 0) >= isnull(cpcb.PaidAmount, 0) + @ApprovedAmount then 'Y'
                       else 'N'
                  end
          from    #CoveragePlans cp
                  join CoveragePlanClaimBudgets cpcb on cpcb.CoveragePlanId = cp.CoveragePlanId
                  left join dbo.CoveragePlanClaimBudgetClients c on c.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                                                    and isnull(c.RecordDeleted, 'N') = 'N'
          where   isnull(cpcb.RecordDeleted, 'N') = 'N'
                  and cp.PlanIsBillable = 'Y'
                  and cpcb.Active = 'Y'
                  and (@DOSFrom between cpcb.StartDate and cpcb.EndDate
                       or @DOSTo between cpcb.StartDate and cpcb.EndDate)
                  and (c.ClientId is null
                       or c.ClientId = @ClientId)
                  and (cpcb.ProviderSiteGroupName is null
                       or exists ( select *
                                   from   CoveragePlanClaimBudgetProviderSites ps
                                   where  ps.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                          and ((ps.ProviderId = @ProviderId
                                                and ps.SiteId = null)
                                               or ps.SiteId = @SiteId)
                                          and isnull(ps.RecordDeleted, 'N') = 'N' ))
                  and (cpcb.BillingCodeGroupName is null
                       or exists ( select *
                                   from   CoveragePlanClaimBudgetBillingCodes bc
                                          join BillingCodeModifiers bcm on bcm.BillingCodeModifierId = bc.BillingCodeModifierId
                                   where  bc.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                          and isnull(bc.RecordDeleted, 'N') = 'N'
                                          and isnull(bcm.RecordDeleted, 'N') = 'N'
                                          and ((bcm.BillingCodeId = @BillingCodeId
                                                and bc.ApplyToAllModifiers = 'Y')
                                               or (bc.BillingCodeModifierId = @BillingCodeModifierId)) ))
                  and (cpcb.InsurerGroupName is null
                       or exists ( select *
                                   from   CoveragePlanClaimBudgetInsurers i
                                   where  i.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                          and i.InsurerId = @InsurerId
                                          and isnull(i.RecordDeleted, 'N') = 'N' ))				 					   
      
          set @OriginalCOBOrder = @COBOrder

          while exists ( select *
                         from   #CoveragePlanClaimBudgets
                         where  CoveragePlanId = @CoveragePlanId
                                and CanBeUsed = 'N' )
            begin
              if exists ( select  *
                          from    #CoveragePlanClaimBudgets
                          where   CoveragePlanId = @CoveragePlanId
                                  and CanBeUsed = 'N'
                                  and CascadeToNextPlanWhenOverBudget = 'N' )
                begin
		          -- Error
                  insert  into #DenialReasons
                          (ReasonId,
                           ReasonSpecifier)
                  select  @DenialReason,
                          ': ' + BudgetName
                  from    #CoveragePlanClaimBudgets
                  where   CoveragePlanId = @CoveragePlanId
                          and CanBeUsed = 'N'
                          and CascadeToNextPlanWhenOverBudget = 'N'

                  break

                end 
              else -- Cascade to the next plan
                begin 
                  if exists ( select  *
                              from    #AuthorizationsRates r
                                      join ContractRates cr on cr.ContractRateId = r.ContractRateId
                              where   cr.CoveragePlanGroupName is not null )
                    begin
			  		  -- Error
                      insert  into #DenialReasons
                              (ReasonId,
                               ReasonSpecifier)
                      select  @DenialReason,
                              ': ' + BudgetName + '. Cannot cascade to next plan due to ' + @PlanName + ' specific contract rate.'
                      from    #CoveragePlanClaimBudgets
                      where   CoveragePlanId = @CoveragePlanId
                              and CanBeUsed = 'N'

                      break
                    end             

                  select top 1
                          @CoveragePlanId = cp.CoveragePlanId,
                          @PlanName = cp.CoveragePlanName,
                          @ClientCoveragePlanId = cp.ClientCoveragePlanId,
                          @PlanIsBillable = cp.PlanIsBillable,
                          @COBOrder = cp.COBOrder,
                          @MonthlyDeductibleMetAfterDateOfService = cp.MonthlyDeductibleMetAfterDateOfService,
                          @MonthlyDeductibleNotMetForDateOfService = cp.MonthlyDeductibleNotMetForDateOfService
                  from    #CoveragePlans cp
                  where   cp.COBOrder > @COBOrder
                          and cp.PlanIsBillable = 'Y'
                          and cp.MonthlyDeductibleMetAfterDateOfService = 'N'
                          and cp.MonthlyDeductibleNotMetForDateOfService = 'N'
                  order by cp.COBOrder 

                  if @@rowcount = 0
                    begin
                      select  @CoveragePlanId = cp.CoveragePlanId,
                              @PlanName = cp.CoveragePlanName,
                              @ClientCoveragePlanId = cp.ClientCoveragePlanId,
                              @PlanIsBillable = cp.PlanIsBillable,
                              @COBOrder = cp.COBOrder,
                              @MonthlyDeductibleMetAfterDateOfService = cp.MonthlyDeductibleMetAfterDateOfService,
                              @MonthlyDeductibleNotMetForDateOfService = cp.MonthlyDeductibleNotMetForDateOfService
                      from    #CoveragePlans cp
                      where   cp.COBOrder = @OriginalCOBOrder
              
			  		  -- Error
                      insert  into #DenialReasons
                              (ReasonId,
                               ReasonSpecifier)
                      select  @DenialReason,
                              ': ' + BudgetName
                      from    #CoveragePlanClaimBudgets
                      where   CoveragePlanId = @CoveragePlanId
                              and CanBeUsed = 'N'
                      break
              
                    end             
                end      
            end    
        end
  
    if @AddOnCode = 'Y'
      begin
	    -- Find base claim line for the add-on: same claim, DOS, place of service and rendering provider 
        select top 1
                @BaseClaimLineId = cl.ClaimLineId,
                @BaseClaimLineStatus = cl.Status
        from    Claims c
                join ClaimLines cl on cl.ClaimId = c.ClaimId
                join BillingCodes bc on bc.BillingCodeId = cl.BillingCodeId
                join BillingCodeAddOnCodes bcaoc on bcaoc.BillingCodeId = bc.BillingCodeId
        where   c.ClaimId = @ClaimId
		        and isnull(bc.AddOnCodeGroupName, '') <> ''
                and bcaoc.AddOnBillingCodeId = @BillingCodeId
			    and cl.FromDate = @DOSFrom
                and cl.PlaceOfService = @PlaceOfService
                and isnull(isnull(cl.RenderingProviderId, c.RenderingProviderId), -1) = isnull(@RenderingProviderId, -1)
                and isnull(cl.RecordDeleted, 'N') = 'N'
                and isnull(bcaoc.RecordDeleted, 'N') = 'N'


       -- Add-On Code: no corresponding base claim line found
        set @DenialReason = 2586

        if exists ( select  '*'
                    from    #AdjudicationRules ar
                    where   ar.RuleTypeId = @DenialReason
                            and (ar.AllInsurers = 'Y'
                                 or ar.InsurerId = @InsurerId) )
          and @BaseClaimLineId is null
          begin

            insert  into #DenialReasons
                    (ReasonId)
            values  (@DenialReason)
          end

	   -- Add-On Code: corresponding base claim line has not been approved
        set @DenialReason = 2587

        if exists ( select  '*'
                    from    #AdjudicationRules ar
                    where   ar.RuleTypeId = @DenialReason
                            and (ar.AllInsurers = 'Y'
                                 or ar.InsurerId = @InsurerId) )
          and @BaseClaimLineId is not null
          and @BaseClaimLineStatus not in (@Approved, @PartiallyApproved, @Paid)
          begin

            insert  into #DenialReasons
                    (ReasonId,
                     OverrideRuleClaimLineStatus)
            values  (@DenialReason,
                     case @BaseClaimLineStatus
                       when @Denied then 'D'
                       when @Pended then 'P'
                       else null
                     end)
          end
      end

      -- Claim line is identified for review and manual approval.
      set @DenialReason = 2585

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        begin
          select top 1
                  @ClaimApprovalOverrideId = o.ClaimApprovalOverrideId,
                  @ClaimApprovalOverrideReason = isnull(gcor.CodeName, 'Unspecified')
          from    dbo.ClaimApprovalOverrides o
                  left join GlobalCodes gcor on gcor.GlobalCodeId = o.Reason
          where   isnull(o.RecordDeleted, 'N') = 'N'
                  and o.Active = 'Y'
                  and (o.StartDate <= @DOSFrom
                       or o.StartDate is null)
                  and (o.EndDate >= @DOSFrom
                       or o.EndDate is null)
                  and (o.ClientStartAge <= @ClientAge
                       or o.ClientStartAge is null)
                  and (o.ClientEndAge >= @ClientAge
                       or o.ClientEndAge is null)
                  and (o.AllClients = 'Y'
                       or exists ( select *
                                   from   dbo.ClaimApprovalOverrideClients oc
                                   where  oc.ClaimApprovalOverrideId = o.ClaimApprovalOverrideId
                                          and oc.ClientId = @ClientId
                                          and isnull(oc.RecordDeleted, 'N') = 'N' ))
                  and (o.InsurerGroupName is null
                       or exists ( select *
                                   from   dbo.ClaimApprovalOverrideInsurers opi
                                   where  opi.ClaimApprovalOverrideId = o.ClaimApprovalOverrideId
                                          and opi.InsurerId = @InsurerId
                                          and isnull(opi.RecordDeleted, 'N') = 'N' ))
                  and (o.ProviderSiteGroupName is null
                       or exists ( select *
                                   from   dbo.ClaimApprovalOverrideProviderSites ops
                                   where  ops.ClaimApprovalOverrideId = o.ClaimApprovalOverrideId
                                          and ((ops.ProviderId = @ProviderId
                                                and ops.SiteId is null)
                                               or (ops.SiteId = @SiteId))
                                          and isnull(ops.RecordDeleted, 'N') = 'N' ))
                  and (o.BillingCodeGroupName is null
                       or exists ( select *
                                   from   dbo.ClaimApprovalOverrideBillingCodes opbc
                                          join dbo.BillingCodeModifiers bcm on bcm.BillingCodeModifierId = opbc.BillingCodeModifierId
                                   where  opbc.ClaimApprovalOverrideId = o.ClaimApprovalOverrideId
                                          and ((opbc.ApplyToAllModifiers = 'Y'
                                                and bcm.BillingCodeId = @BillingCodeId)
                                               or (opbc.BillingCodeModifierId = @BillingCodeModifierId))
                                          and isnull(opbc.RecordDeleted, 'N') = 'N'
                                          and isnull(bcm.RecordDeleted, 'N') = 'N' ))
                  and (o.PlaceOfServiceGroupName is null
                       or exists ( select *
                                   from   dbo.ClaimApprovalOverridePlaceOfServices opos
                                   where  opos.ClaimApprovalOverrideId = o.ClaimApprovalOverrideId
                                          and opos.PlaceOfService = @PlaceOfService
                                          and isnull(opos.RecordDeleted, 'N') = 'N' ))
													   

          if @ClaimApprovalOverrideId is not null
            begin

              insert  into #DenialReasons
                      (ReasonId,
                       ReasonSpecifier)
              values  (@DenialReason,
                       ':' + @ClaimApprovalOverrideReason)
            end 
        end 
      
	  --  
	  -- Execute custom logic  
	  --  
      if object_id('dbo.scsp_CMAdjudicateClaimLines', 'P') is not null 
        begin    
          exec scsp_CMAdjudicateClaimLines 
            @ClaimLineId = @ClaimLineId,
            @InsurerId = @InsurerId,
            @BillingCodeId = @BillingCodeId,
            @CoveragePlanId = @CoveragePlanId
        end

      -- Check for claim denial overrides
      if exists ( select  *
                  from    #DenialReasons )
        and @CoveragePlanId is not null 
        begin    
          select top 1
                  @ClaimDenialOverrideId = cdo.ClaimDenialOverrideId,
                  @ClaimDenialOverrideRateNotFound = cdo.RateNotFound, -- S - Standard, C - Claimed Amount, R - Custom Rate
                  @ClaimDenialOverrideRatePerUnit = cdo.RatePerUnit
          from    ClaimDenialOverrides cdo
                  left join ClaimDenialOverrideProviderSites cdops on cdops.ClaimDenialOverrideId = cdo.ClaimDenialOverrideId
                                                                      and isnull(cdops.RecordDeleted, 'N') = 'N'
                  left join ClaimDenialOverrideInsurers cdoi on cdoi.ClaimDenialOverrideId = cdo.ClaimDenialOverrideId
                                                                and isnull(cdoi.RecordDeleted, 'N') = 'N'
                  left join ClaimDenialOverrideBillingCodes cdobc on cdobc.ClaimDenialOverrideId = cdo.ClaimDenialOverrideId
                                                                     and isnull(cdobc.RecordDeleted, 'N') = 'N'
                  left join ClaimDenialOverrideClients cdoc on cdoc.ClaimDenialOverrideId = cdo.ClaimDenialOverrideId
                                                               and isnull(cdoc.RecordDeleted, 'N') = 'N'
          where   cdo.Active = 'Y'
                  and isnull(cdo.RecordDeleted, 'N') = 'N'
                  and (cdo.StartDate <= @DOSFrom
                       or cdo.StartDate is null)
                  and (cdo.EndDate >= @DOSFrom
                       or cdo.EndDate is null)
                  and exists ( select *
                               from   ClaimDenialOverrideDenialReasons cdodr
                                      join #DenialReasons dr on dr.ReasonId = cdodr.DenialReasonId
                               where  cdodr.ClaimDenialOverrideId = cdo.ClaimDenialOverrideId
                                      and isnull(cdodr.RecordDeleted, 'N') = 'N' )
                  and not exists ( select *
                                   from   #DenialReasons dr
                                   where  not exists ( select *
                                                       from   ClaimDenialOverrideDenialReasons cdodr
                                                       where  cdodr.ClaimDenialOverrideId = cdo.ClaimDenialOverrideId
                                                              and dr.ReasonId = cdodr.DenialReasonId
                                                              and isnull(cdodr.RecordDeleted, 'N') = 'N' ) )
                  and (cdo.ProviderSiteGroupName is null
                       or (cdops.ClaimDenialOverrideId is not null
                           and (cdops.ProviderId is null
                                or cdops.ProviderId = @ProviderId)
                           and (cdops.SiteId is null
                                or cdops.SiteId = @SiteId)))
                  and (cdo.InsurerGroupName is null
                       or cdoi.InsurerId = @InsurerId)
                  and (cdo.BillingCodeGroupName is null
                       or cdobc.BillingCodeId = @BillingCodeId)
                  and (cdoc.ClaimDenialOverrideId is null
                       or cdoc.ClientId = @ClientId)
                  and (cdobc.BillingCodeId = @BillingCodeId
                       or cdoc.ClientId = @ClientId)
          order by case when cdoc.ClientId = @ClientId
                             and cdobc.BillingCodeId = @BillingCodeId then 1
                        else 2
                   end,
                  case when cdoc.ClientId = @ClientId then 1
                       else 2
                  end,
                  case when cdobc.BillingCodeId = @BillingCodeId then 1
                       else 2
                  end,
                  case when cdoi.InsurerId = @InsurerId then 1
                       else 2
                  end,
                  case when cdops.SiteId = @SiteId then 1
                       else 2
                  end,
                  case when cdops.ProviderId = @ProviderId then 1
                       else 2
                  end,
                  cdo.ClaimDenialOverrideId

          if @ClaimDenialOverrideId is not null
            and @ApprovedAmount = 0 and @ClaimedAmount > 0
            begin
              select  @ContractApprovedAmount = sum(case when AuthorizationRequired = 'Y' then isnull(ClaimLineUnitsApproved, ClaimLineUnits)
                                                         else ClaimLineUnits
                                                    end * ContractRate),
                      @UnitsApproved = sum(case when AuthorizationRequired = 'Y' then isnull(ClaimLineUnitsApproved, ClaimLineUnits)
                                                else ClaimLineUnits
                                           end)
              from    #AuthorizationsRates  
      
              if @ContractApprovedAmount = 0 
                begin
                  if @ClaimDenialOverrideRateNotFound = 'C' -- Use claimed amount
                    begin
                      set @ContractApprovedAmount = @ClaimedAmount
                    end       
                  else 
                    if @ClaimDenialOverrideRateNotFound = 'R' -- Use custom rate
                      begin
                        set @ContractApprovedAmount = isnull(@ClaimDenialOverrideRatePerUnit, 0) * @UnitsApproved
                      end 
                    else 
                      if @ClaimDenialOverrideRateNotFound = 'S' -- Use standard billing code rate
                        begin
                          set @ClaimDenialOverrideRatePerUnit = null
		         
                          select  @ClaimDenialOverrideRatePerUnit = bcr.Rate
                          from    dbo.BillingCodeRates bcr
                          where   bcr.BillingCodeId = @BillingCodeId
                                  and bcr.BillingCodeModifiersId = @BillingCodeModifierId
                                  and bcr.EffectiveFrom <= @DOSFrom
                                  and (bcr.EffectiveTo >= @DOSFrom
                                       or bcr.EffectiveTo is null)
                                  and bcr.Rate >= 0
                                  and isnull(bcr.RecordDeleted, 'N') = 'N'
		
                          set @ContractApprovedAmount = isnull(@ClaimDenialOverrideRatePerUnit, 0) * @UnitsApproved 
                        end      

	              -- Approved amount can never be > claimed amount  
	              -- Use only part of claimed amount in calculation if units approved < units claimed  
                  if (@ContractApprovedAmount - isnull(@COBPaidAmount, 0)) > (@ClaimedAmount * @UnitsApproved / @UnitsClaimed) 
                    set @ApprovedAmount = round(@ClaimedAmount * @UnitsApproved / @UnitsClaimed, 2)
                  else 
                    set @ApprovedAmount = round(@ContractApprovedAmount - isnull(@COBPaidAmount, 0), 2)

                  -- If approved amount is still $0 then ignore claim denial override
                  if @ApprovedAmount <= 0
				  begin 
					set @ClaimDenialOverrideId = null
                  end 
                end 
            end       
        end

      ValidationEnd:

      if exists ( select  *
                  from    #DenialReasons )
        and @ClaimDenialOverrideId is null
        begin
          if (exists ( select *
                       from   #DenialReasons
                       where  OverrideRuleClaimLineStatus = 'D' )
              or exists ( select  *
                          from    #DenialReasons dr
                                  join #AdjudicationRules ar on ar.RuleTypeId = dr.ReasonId
                          where   ar.ClaimLineStatusIfBroken = 'D'
                                  and isnull(dr.OverrideRuleClaimLineStatus, '') <> 'P' ))
            begin
              set @StatusOut = @Denied
            end
          else
            begin
              set @StatusOut = @Pended
            end

          -- Check if pended reasons should be overridden
          if @StatusOut = @Pended
            and @OverridePendedReason = 'Y'
            and @ApprovedAmount >= 0
            and @CoveragePlanId > 0
			and @LastAdjudicationId > 0
            begin
	          -- Override only if the pended reasons are exactly the same as in previous adjudication
              if not exists ( select  *
                              from    #DenialReasons dr
                                      left join dbo.AdjudicationDenialPendedReasons adpr on adpr.AdjudicationId = @LastAdjudicationId
                                                                                            and adpr.PendedReason = dr.ReasonId
                                                                                            and isnull(adpr.RecordDeleted, 'N') = 'N'
                              where   adpr.AdjudicationDenialPendedReasonId is null )
                begin
                  update  #DenialReasons
                  set     ReasonSpecifier = ': Overridden by Override Pended Reason flag'

                  goto ApproveClaimLine
                end
            end
        

          goto ClaimLineFinal
        end




--  
-- At this ppoint we are ready to approve the claim line  
--  
      ApproveClaimLine:

      set @StatusOut = @Approved  
      set @DenialReason = null
      
	  -- Process authorizations  
      declare Authorizations_Cursor cursor
      for
      select  ProviderAuthorizationId,
              sum(AuthorizationUnitsUsed),
              sum(ClaimLineUnitsApproved)
      from    #AuthorizationsRates
      where   ProviderAuthorizationId is not null
              and AuthorizationRequired = 'Y'
      group by ProviderAuthorizationId  
	  
      open Authorizations_Cursor  
      fetch from Authorizations_Cursor into @ProviderAuthorizationId, @AuthorizationUnitsUsed, @ClaimLineUnitsApproved  
	  
      while @@fetch_status = 0 
        begin  
          insert  into ClaimLineAuthorizations
                  (ClaimLineId,
                   ProviderAuthorizationId,
                   UnitsUsed,
                   CreatedBy,
                   CreatedDate,
                   ModifiedBy,
                   ModifiedDate)
          values  (@ClaimLineId,
                   @ProviderAuthorizationId,
                   @AuthorizationUnitsUsed,
                   @UserCode,
                   getdate(),
                   @UserCode,
                   getdate())  
	      
          update  pa
          set     UnitsUsed = isnull(pa.UnitsUsed, 0) + @AuthorizationUnitsUsed,
                  Status = case when pa.TotalUnitsApproved <= (isnull(pa.UnitsUsed, 0) + @AuthorizationUnitsUsed) then @AuthorizationClosed
                                else Status
                           end,
                  ModifiedBy = @UserCode,
                  ModifiedDate = getdate()
          from    ProviderAuthorizations pa
          where   pa.ProviderAuthorizationId = @ProviderAuthorizationId
                  and pa.Status in (@AuthorizationApproved, @AuthorizationPartiallyApproved, @AuthorizationPartiallyDenied)
                  and (pa.TotalUnitsApproved - isnull(pa.UnitsUsed, 0)) >= @AuthorizationUnitsUsed
                  and pa.Active = 'Y'
                  and isnull(pa.RecordDeleted, 'N') = 'N'
   
          if @@rowcount = 0
            begin  
              insert  into #DenialReasons
                      (ReasonId,
                       ReasonSpecifier)
              select  2588, -- Critical System Error
                      ': ' + 'Found authorization has been used by another user'
 
              --raiserror('Found authorization has been used by another user', 16, 1);
              goto ValidationEnd
            end   
	  
          if exists ( select  *
                      from    ProviderAuthorizations
                      where   ProviderAuthorizationId = @ProviderAuthorizationId
                              and Status = @AuthorizationClosed ) 
            begin  
              insert  into ProviderAuthorizationsHistory
                      (InsurerId,
                       ClientId,
                       ProviderAuthorizationId,
                       ProviderId,
                       SiteId,
                       BillingCodeId,
                       Modifier1,
                       Modifier2,
                       Modifier3,
                       Modifier4,
                       AuthorizationNumber,
                       Status,
                       Reason,
                       StartDate,
                       EndDate,
                       StartDateRequested,
                       EndDateRequested,
                       RequestedBillingCodeId,
                       UnitsRequested,
                       FrequencyTypeRequested,
                       TotalUnitsRequested,
                       UnitsApproved,
                       FrequencyTypeApproved,
                       TotalUnitsApproved,
                       UnitsUsed,
                       Comment,
                       Modified,
                       DeniedDate,
                       CreatedBy,
                       CreatedDate,
                       ModifiedBy,
                       ModifiedDate)
                      select  InsurerId,
                              ClientId,
                              ProviderAuthorizationId,
                              ProviderId,
                              SiteId,
                              BillingCodeId,
                              Modifier1,
                              Modifier2,
                              Modifier3,
                              Modifier4,
                              AuthorizationNumber,
                              @AuthorizationApproved,
                              Reason,
                              StartDate,
                              EndDate,
                              StartDateRequested,
                              EndDateRequested,
                              RequestedBillingCodeId,
                              UnitsRequested,
                              FrequencyTypeRequested,
                              TotalUnitsRequested,
                              UnitsApproved,
                              FrequencyTypeApproved,
                              TotalUnitsApproved,
                              UnitsUsed - @AuthorizationUnitsUsed,
                              Comment,
                              Modified,
                              DeniedDate,
                              CreatedBy,
                              CreatedDate,
                              ModifiedBy,
                              ModifiedDate
                      from    ProviderAuthorizations
                      where   ProviderAuthorizationId = @ProviderAuthorizationId  
            end  
	  
          fetch from Authorizations_Cursor into @ProviderAuthorizationId, @AuthorizationUnitsUsed, @ClaimLineUnitsApproved  
        end  
	  
      close Authorizations_Cursor  
      deallocate Authorizations_Cursor  
	  
  
      if (@UnitsApproved < @UnitsClaimed
          or @ApprovedAmount < @ClaimedAmount) 
        begin
	  
          if @UnitsApproved < @UnitsClaimed 
            begin  
              set @StatusOut = @PartiallyApproved  
		  
              if exists ( select  *
                          from    #AuthorizationsRates
                          where   ProviderAuthorizationId is null
                                  and AuthorizationRequired = 'Y' ) 
                begin
				  -- Authorization cannot be found for some date(s) of service                                
                  set @DenialReason = 2544   
                end
              else 
                begin
				  -- Claim line exceeds units remaining on Authorization  
                  set @DenialReason = 2528  
                end
              
              insert  into #DenialReasons
                      (ReasonId,
                       DeniedAmount)
              values  (@DenialReason,
                       @ClaimedAmount - @ApprovedAmount)
            end  
		  	  
		  -- Billing Code rate in contract is less than claimed amount  
          if @ApprovedAmount < @ClaimedAmount 
            begin  
              set @StatusOut = @PartiallyApproved
              set @DenialReason = 2539

              insert  into #DenialReasons
                      (ReasonId,
                       DeniedAmount)
              values  (@DenialReason,
                       @ClaimedAmount - @ApprovedAmount)
            end;  
        end;

      -- Member copay
      set @DenialReason = 2584

      if exists ( select  '*'
                  from    #AdjudicationRules ar
                  where   ar.RuleTypeId = @DenialReason
                          and (ar.AllInsurers = 'Y'
                               or ar.InsurerId = @InsurerId) )
        begin
          set @CopayAmount = isnull(dbo.ssf_CMCalculateClientCopay(@ClaimLineId, @ApprovedAmount), 0)

          if @CopayAmount > 0
            begin
              set @ApprovedAmount = @ApprovedAmount - @CopayAmount
              set @StatusOut = @PartiallyApproved;  

              insert  into #DenialReasons
                      (ReasonId,
                       DeniedAmount,
                       ReasonSpecifier)
              values  (@DenialReason,
                       @CopayAmount,
                       ': $' + convert(varchar, @CopayAmount))
            end 
        end 


      ClaimLineFinal:  

	  set @DenialReason = null
	  set @Reason = null

      select top 1
              @DenialReason = dr.ReasonId,
              @Reason = ar.RuleName + coalesce(dr.ReasonSpecifier, '')
      from    #DenialReasons dr
              join #AdjudicationRules ar on ar.RuleTypeId = dr.ReasonId
      order by dr.DenialReasonId
			 		     
      set @TotalClaimLines = @TotalClaimLines + 1  

      if (exists ( select *
                   from   #DenialReasons dr
                          join #AdjudicationRules ar on ar.RuleTypeId = dr.ReasonId
                   where  ar.MarkClaimLineToBeWorked = 'Y' )
          or (@StatusOut = @Denied
              and exists ( select *
                           from   #DenialReasons dr
                           where  dr.ReasonId in (2549, 2550) ))) -- Keep denied claim lines due to bundling issues in OpenClaims
        begin
          set @NeedsToBeWorked = 'Y'
        end
      else
        begin
          set @NeedsToBeWorked = 'N'
        end

      if @StatusOut = @Denied 
        begin  
          set @TotalDeniedAmount = @TotalDeniedAmount + @ClaimedAmount  
          set @TotalLinesDenied = @TotalLinesDenied + 1  
          set @DeniedAmount = @ClaimedAmount   
          set @UnitsDenied = @UnitsClaimed
		  set @ApprovedAmount = null
		  set @UnitsApproved = null   
        end  
      else 
        if @StatusOut = @Pended 
          begin  
            set @TotalPendedAmount = @TotalPendedAmount + @ClaimedAmount  
            set @TotalLinesPended = @TotalLinesPended + 1   
            set @PendedAmount = @ClaimedAmount   
            set @UnitsPended = @UnitsClaimed   
            set @PendedReason = @DenialReason
            set @DenialReason = null
		    set @ApprovedAmount = null
		    set @UnitsApproved = null   
          end  
        else 
          if @StatusOut = @PartiallyApproved 
            begin  
              set @TotalApprovedAmount = @TotalApprovedAmount + @ApprovedAmount  
              set @TotalLinesPartiallyApproved = @TotalLinesPartiallyApproved + 1    
              set @DeniedAmount = @ClaimedAmount - @ApprovedAmount   
              set @UnitsDenied = @UnitsClaimed - @UnitsApproved   
              set @TotalDeniedAmount = @TotalDeniedAmount + @DeniedAmount   
              set @PayableAmount = isnull(@PayableAmount, 0) + @ApprovedAmount               
            end  
          else -- Approved  
            begin  
              set @TotalApprovedAmount = @TotalApprovedAmount + @ApprovedAmount  
              set @TotalLinesApproved = @TotalLinesApproved + 1   
              set @PayableAmount = isnull(@PayableAmount, 0) + @ApprovedAmount               
            end  
	  
      if (@PayableAmount < 0
          or (@PayableAmount = 0
              and @ApprovedAmount > 0))
        and @StatusOut in (@Approved, @PartiallyApproved)
        begin  
          set @StatusOut = @Paid  
          set @NeedsToBeWorked = 'N'  
        end  
	  
      if @PayableAmount = 0 
	    and @ApprovedAmount = 0
        and @StatusOut in (@Approved, @PartiallyApproved)
        and exists ( select *
                     from   Checks c
                            join dbo.ClaimLinePayments clp on clp.CheckId = c.CheckId
                     where  clp.ClaimLineId = @ClaimLineId
					        and clp.Amount = 0
                            and isnull(c.Voided, 'N') <> 'Y'
                            and isnull(c.RecordDeleted, 'N') = 'N'
                            and isnull(clp.RecordDeleted, 'N') = 'N' )
        begin  
          set @StatusOut = @Paid  
          set @NeedsToBeWorked = 'N'  
        end  


      update  ClaimLines
      set     Status = @StatusOut,
              PayableAmount = @PayableAmount,
              DenialReason = @DenialReason,
              PendedReason = @PendedReason,
              ToReadjudicate = 'N',
              NeedsToBeWorked = @NeedsToBeWorked,
			  OverridePendedReason = 'N',
              ModifiedBy = @UserCode,
              ModifiedDate = getdate()
      where   ClaimLineId = @ClaimLineId  
	  
      if @StatusOut in (@Approved, @PartiallyApproved, @Paid) 
        select top 1
                @ContractId = ContractId,
                @ContractRateId = ContractRateId
        from    #AuthorizationsRates  
      else 
        select  @ContractId = null,
                @ContractRateId = null  
	
      insert  into Adjudications
              (BatchId,
               ClaimLineId,
               Status,
               ClaimedAmount,
               UnitsClaimed,
               ApprovedAmount,
               UnitsApproved,
               DeniedAmount,
               DenialReason,
               UnitsDenied,
               UnitsPended,
               PendedAmount,
               PendedReason,
               ContractId,
               ContractRateId,
               ClaimBundleId,
			   BundleAdjudicationId,
			   BundleClaimType,
			   ClaimDenialOverrideId,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               ModifiedDate)
      output  inserted.AdjudicationId,
              inserted.ClaimLineId,
              inserted.Status,
              inserted.ApprovedAmount,
              inserted.ClaimBundleId,
			  inserted.CreatedDate
              into #NewAdjudications (AdjudicationId, ClaimLineId, Status, ApprovedAmount, ClaimBundleId, CreatedDate)
              select  @BatchId,
                      @ClaimLineId,
                      @StatusOut,
                      @ClaimedAmount,
                      @UnitsClaimed,
                      @ApprovedAmount,
                      @UnitsApproved,
                      nullif(@DeniedAmount, 0),
                      @DenialReason,
                      @UnitsDenied,
                      @UnitsPended,
                      nullif(@PendedAmount, 0),
                      @PendedReason,
                      nullif(@ContractId, 0),
                      nullif(@ContractRateId, 0),
                      @ClaimBundleId,
					  @BundleAdjudicationId,
					  @BundleClaimType,
					  @ClaimDenialOverrideId,
                      @UserCode,
                      getdate(),
                      @UserCode,
                      getdate()
              union all
              -- Add all activity claim lines if the claim line is a bundle     
              select  @BatchId,
                      cl.ClaimLineId,
                      case when @StatusOut in (@Approved, @PartiallyApproved) then @Approved
                           else @StatusOut
                      end,
                      cl.ClaimedAmount,
                      cl.Units,
                      0,
                      cl.Units,
                      case when @StatusOut = @Denied then cl.ClaimedAmount
                           else null
                      end,
                      case when @StatusOut = @Denied then @DenialReason
                           else null
                      end,
                      case when @StatusOut = @Denied then cl.Units
                           else null
                      end,
                      case when @StatusOut = @Pended then cl.Units
                           else null
                      end,
                      case when @StatusOut = @Pended then cl.ClaimedAmount
                           else null
                      end,
                      case when @StatusOut = @Pended then @PendedReason
                           else null
                      end,
                      null,
                      null,
                      @ClaimBundleId,
					  @BundleAdjudicationId,
					  'A' as BunldeClaimType,
					  @ClaimDenialOverrideId,
                      @UserCode,
                      getdate(),
                      @UserCode,
                      getdate()
              from    dbo.ssf_CMClaimLineBundles (@ClaimLineId, 'Bundle') clb
                      join ClaimLines cl on cl.ClaimLineId = clb.ActivityClaimLineId
              where   @BundleClaimLineId = @ClaimLineId
			          and clb.ClaimBundleId = @ClaimBundleId
                      and clb.BundleClaimLineId = @ClaimLineId
                      and clb.ClaimType = 'Activity'
					  and cl.Status in (2022, 2024, 2027)
					  and @StatusOut in (@Approved, @PartiallyApproved, @Paid)

      select  @AdjudicationId = na.AdjudicationId
      from    #NewAdjudications na
      where   na.ClaimLineId = @ClaimLineId

      if @ClaimBundleId is not null
        and @BundleClaimType = 'B'
        and @BundleAdjudicationId is null
		and @StatusOut in (@Approved, @PartiallyApproved, @Paid)
        begin
          set @BundleAdjudicationId = @AdjudicationId
		    
          update  a
          set     BundleAdjudicationId = @BundleAdjudicationId
          from    #NewAdjudications na
                  join Adjudications a on a.AdjudicationId = na.AdjudicationId
      
        end
	    
	  -- Update status of bundle activity claim lines
      update  cl
      set     Status = na.Status,
	          DenialReason = @DenialReason,
              PendedReason = @PendedReason,
			  ToReadjudicate = 'N',
			  NeedsToBeWorked = @NeedsToBeWorked,
			  OverridePendedReason = 'N',
			  PayableAmount = 0
      from    ClaimLines cl
              join #NewAdjudications na on na.ClaimLineId = cl.ClaimLineId
      where   na.ClaimLineId <> @ClaimLineId

      update  cl
      set     LastAdjudicationId = na.AdjudicationId,
			  LastAdjudicationDate = na.CreatedDate
      from    ClaimLines cl
              join #NewAdjudications na on na.ClaimLineId = cl.ClaimLineId

      insert  into ClaimLineHistory
              (ClaimLineId,
               Activity,
               ActivityDate,
               Status,
               ActivityStaffId,
               AdjudicationId,
               Reason,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               ModifiedDate)
              select  na.ClaimLineId,
                      @Activity,
                      na.CreatedDate,
                      na.Status,
                      @UserId,
                      na.AdjudicationId,
                      nullif(@Reason, ''),
                      @UserCode,
                      getdate(),
                      @UserCode,
                      getdate()
              from    #NewAdjudications na
	      
      if @StatusOut in (@Approved, @PartiallyApproved, @Paid) 
        begin  
          insert  into AdjudicationContracts
                  (AdjudicationId,
                   ContractId,
                   ContractRateId,
                   ContractRuleId,
                   ApprovedAmount,
                   UnitsApproved,
                   CreatedBy,
                   CreatedDate,
                   ModifiedBy,
                   ModifiedDate)
                  select  @AdjudicationId,
                          a.ContractId,
                          a.ContractRateId,
                          a.ContractRuleId,
                          sum(case when a.AuthorizationRequired = 'Y' then isnull(a.ClaimLineUnitsApproved, 0)
                                   else a.ClaimLineUnits
                              end * a.ContractRate),
                          sum(case when a.AuthorizationRequired = 'Y' then isnull(a.ClaimLineUnitsApproved, 0)
                                   else a.ClaimLineUnits
                              end),
                          @UserCode,
                          getdate(),
                          @UserCode,
                          getdate()
                  from    #AuthorizationsRates a
				  where a.ContractId is not null
                  group by a.ContractRateId,
                          a.ContractId,
                          a.ContractRuleId  
	  
		  -- Adjust approved amount for each contract   
          if @ContractApprovedAmount > @ApprovedAmount 
            begin  
              update  AdjudicationContracts
              set     ApprovedAmount = ApprovedAmount - ((ApprovedAmount / @ContractApprovedAmount) * (@ContractApprovedAmount - @ApprovedAmount))
              where   AdjudicationId = @AdjudicationId  
	  
            end   
	  
          update  cr
          set     TotalAmountUsed = isnull(cr.TotalAmountUsed, 0) + aa.ApprovedAmount,
                  ModifiedBy = @UserCode,
                  ModifiedDate = getdate()
          from    ContractRules cr
                  join (select  ContractRuleId,
                                sum(ApprovedAmount) as ApprovedAmount
                        from    AdjudicationContracts
                        where   AdjudicationId = @AdjudicationId
                                and ContractRuleId is not null
                        group by ContractRuleId) aa on aa.ContractRuleId = cr.ContractRuleId  
	  

          Update  c
          set     ClaimsApprovedAndPaid = round(( isnull(ClaimsApprovedAndPaid, 0) + aa.ApprovedAmount), 2),
                  ModifiedBy = @UserCode,
                  ModifiedDate = getdate()
          from    Contracts c
                  join (select  ContractId,
                                sum(ApprovedAmount) as ApprovedAmount
                        from    AdjudicationContracts
                        where   AdjudicationId = @AdjudicationId
                        group by ContractId) aa on aa.ContractId = c.ContractId  
	  
          insert  into ClaimLineCoveragePlans
                  (ClaimLineId,
                   CoveragePlanId,
                   PaidAmount,
                   SentToGL,
                   CreatedBy,
                   CreatedDate,
                   ModifiedBy,
                   ModifiedDate)
                  select  a.ClaimLineId,
                          @CoveragePlanId,
                          a.ApprovedAmount,
                          'N',
                          @UserCode,
                          getdate(),
                          @UserCode,
                          getdate()
                  from    #NewAdjudications na
                          join Adjudications a on a.AdjudicationId = na.AdjudicationId

          insert  into dbo.ClaimLineCoveragePlanClaimBudgets
                  (ClaimLineId,
                   CoveragePlanClaimBudgetId,
                   PaidAmount,
                   CreatedBy,
                   CreatedDate,
                   ModifiedBy,
                   ModifiedDate)
                  select  @ClaimLineId,
                          CoveragePlanClaimBudgetId,
                          @ApprovedAmount,
                          @UserCode,
                          getdate(),
                          @UserCode,
                          getdate()
                  from    #CoveragePlanClaimBudgets
                  where   CoveragePlanId = @CoveragePlanId

          update  cpcb
          set     PaidAmount = isnull(cpcb.PaidAmount, 0) + @ApprovedAmount
          from    #CoveragePlanClaimBudgets cpcbt
                  join CoveragePlanClaimBudgets cpcb on cpcb.CoveragePlanClaimBudgetId = cpcbt.CoveragePlanClaimBudgetId
          where   cpcbt.CoveragePlanId = @CoveragePlanId

        end  
	  
	  -- Open claims
      delete  oc
      from    OpenClaims oc
              join #NewAdjudications na on na.ClaimLineId = oc.ClaimLineId
              join ClaimLines cl on cl.ClaimLineId = na.ClaimLineId
      where   (cl.Status = @Paid
               or (cl.Status = @Denied
                   and cl.NeedsToBeWorked = 'N')) 

      insert  into OpenClaims
              (Claimlineid,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               ModifiedDate)
              select  cl.ClaimLineId,
                      @UserCode,
                      getdate(),
                      @UserCode,
                      getdate()
              from    #NewAdjudications na
                      join ClaimLines cl on cl.ClaimLineId = na.ClaimLineId
              where   not (cl.Status = @Paid
                           or (cl.Status = @Denied
                               and cl.NeedsToBeWorked = 'N'))
                      and not exists ( select *
                                       from   OpenClaims oc
                                       where  oc.ClaimLineId = cl.ClaimLineId ) 


      -- Handle ClaimLineDenials  
      declare cur_ClaimLineDenials cursor
      for
      select  ClaimLineId
      from    #NewAdjudications 

      open cur_ClaimLineDenials 
      fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

      while @@fetch_status = 0 
        begin

          exec ssp_CMAdjudicateClaimLineDenials 
            @ClaimLineId = @ClaimLineIdDenial,
            @UserCode = @UserCode

          fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

        end 
  
      close cur_ClaimLineDenials
      deallocate cur_ClaimLineDenials
	    	  
        
      -- For Denail Reasons only
      insert  into AdjudicationDenialPendedReasons
              (AdjudicationId,
               DenialReason,
			   DeniedAmount,
               Reason,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               ModifiedDate)
              select  @AdjudicationId,
                      dr.ReasonId,
					  dr.DeniedAmount,
                      ar.RuleName + coalesce(dr.ReasonSpecifier, ''),
                      @UserCode,
                      getdate(),
                      @UserCode,
                      getdate()
              from    #DenialReasons dr
                      join #AdjudicationRules ar on ar.RuleTypeId = dr.ReasonId
              where   (dr.OverrideRuleClaimLineStatus = 'D'
                       or (dr.OverrideRuleClaimLineStatus is null
                           and ar.ClaimLineStatusIfBroken = 'D'))
		
	  -- For Pended Reasons only
      insert  into AdjudicationDenialPendedReasons
              (AdjudicationId,
               PendedReason,
			   PendedAmount,
               Reason,
               CreatedBy,
               CreatedDate,
               ModifiedBy,
               ModifiedDate)
              select  @AdjudicationId,
                      dr.ReasonId,
					  dr.DeniedAmount,
                      ar.RuleName + coalesce(dr.ReasonSpecifier, ''),
                      @UserCode,
                      getdate(),
                      @UserCode,
                      getdate()
              from    #DenialReasons dr
                      join #AdjudicationRules ar on ar.RuleTypeId = dr.ReasonId
              where   (dr.OverrideRuleClaimLineStatus = 'P'
                       or (dr.OverrideRuleClaimLineStatus is null
                           and ar.ClaimLineStatusIfBroken = 'P'))

				
	  -- Update AdjudicationBatches per Batch  
      update  AdjudicationBatches
      set     ApprovedAmount = @TotalApprovedAmount,
              DeniedAmount = @TotalDeniedAmount,
              PendedAmount = @TotalPendedAmount,
              TotalClaimLines = @TotalClaimLines,
              ClaimLinesApproved = @TotalLinesApproved,
              ClaimLinesDenied = @TotalLinesDenied,
              ClaimLinesPended = @TotalLinesPended,
              ClaimLinesPartiallyApproved = @TotalLinesPartiallyApproved,
              ModifiedBy = @UserCode,
              ModifiedDate = getdate()
      where   BatchId = @BatchId  

      NextClaimLine:
      
      commit transaction  

      fetch next from ClaimLines into @ClaimLineId  
    end  
	  
  close ClaimLines  
  deallocate ClaimLines  
	
  
  --Returning ClaimLine Data   
  select  cl.ClaimLineId,
          cl.Status,
          gc.CodeName,
          cl.PayableAmount
  from    ClaimLines cl
          left join GlobalCodes gc on cl.Status = gc.GlobalCodeId
  where   exists ( select *
                   from   AdjudicationProcessClaimLines ap
                   where  ap.ClaimLineId = cl.ClaimLineId
                          and ap.StaffId = @UserId
                          and ap.ScrollId = @ProgressCode )  
	  
	    
  --Returning BatchID   
  select  @BatchId as BatchId,
          @TotalClaimLines as TotalClaimLines  
  
  
  return  
  
end try
begin catch
  declare @ErrorMessage varchar(max)
  declare @ErrorNumber int
  declare @ErrorSeverity int
  declare @ErrorState int
  declare @ErrorLine int
  declare @ErrorProcedure varchar(200)

  select  @ErrorNumber = error_number(),
          @ErrorSeverity = error_severity(),
          @ErrorState = error_state(),
          @ErrorLine = error_line(),
          @ErrorProcedure = isnull(error_procedure(), '-')

  select  @ErrorMessage = 'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + error_message()
 
  if @ClaimLineId is not null 
    set @ErrorMessage = 'Failed to process claim line #' + convert(varchar, @ClaimLineId) + char(13) + char(10) + @ErrorMessage
  
  if @TotalClaimLines is not null 
    set @ErrorMessage = @ErrorMessage + char(13) + char(10) + 'Only ' + convert(varchar, @TotalClaimLines) + ' claim line(s) have been processed successfully in batch #' + convert(varchar, @BatchId)  

  if @@trancount > 0 
    rollback transaction

  if cursor_status('global', 'ClaimLines') >= 0 
    begin
      close ClaimLines
      deallocate ClaimLines
    end 

  if cursor_status('global', 'Contracts_Cursor') >= 0 
    begin
      close Contracts_Cursor
      deallocate Contracts_Cursor
    end 

  if cursor_status('global', 'Authorizations_Cursor') >= 0 
    begin
      close Authorizations_Cursor
      deallocate Authorizations_Cursor
    end 
  
  raiserror(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

end catch  

go
