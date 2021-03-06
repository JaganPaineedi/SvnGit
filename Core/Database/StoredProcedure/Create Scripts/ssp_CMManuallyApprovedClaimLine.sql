if object_id('dbo.ssp_CMManuallyApprovedClaimLine') is not null 
  drop procedure dbo.ssp_CMManuallyApprovedClaimLine
go


create procedure dbo.ssp_CMManuallyApprovedClaimLine
  @ClaimLineId int,
  @ApproveAmount money,
  @ApproveReason int,
  @PartialDenialReason int,
  @StaffId int,
  @StaffCode varchar(200),
  @ClaimedAmount money,
  @Units int,
  @DenialText varchar(200),
  @UnitsApproved int,
  @UnitsDenied int,
  @AuthId int,
  @Exchanged int
/*********************************************************************          
-- Stored Procedure: dbo.ssp_ManuallyApprovedClaimLine
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC 
-- Creation Date:  5/9/2006                      
--                                                 
-- Purpose: to manually approve a claim line
--                                                                                  
-- Input Parameters:  @ClaimLineId int
--                                                    
-- Modified Date    Modified By       Purpose
-- 05.09.2006       Gursharan         Created.
-- 05.29.2008       SFarber           Redesigned.
-- 10.20.2009       SFarber           Added code to execute ssp_CMAdjudicateClaimLineDenials
-- 01.07.2009       SFarber           Modified code to exclude records with null ContractId
-- 03.21.2013		RQuigley		  Modified to include PartiallyApproved auths
-- 05.08.2015       SFarber           Modified to always use ProviderAuthorizations.TotalUnitsApproved instead of UnitsApproved 
-- 04.29.2016       SFarber           Modified to support claim bundles.
-- 03.23.2017       Kkumar            Modified to round off  ClaimsApprovedAndPaid to 2 decimals.
-- 08.18.2017       SFarber           Modified to update LastAdjudicationId and LastAdjudicationDate
-- 09.07.2018       SFarber           Modified to update OverridePendedReason
-- 01.09.2019       SFarber           Modified to use ssf_CMClaimLineBundles
****************************************************************************/
as 

create table #NewAdjudications (
AdjudicationId int,
ClaimLineId int,
Status int,
ApprovedAmount money,
ClaimBundleId int,
CreatedDate datetime)

create table #AuthorizationsContracts (
Date datetime,
ProviderAuthorizationId int,
AuthorizationUnitsUsed decimal(18, 2),
ClaimLineUnitsApproved decimal(18, 2),
ClaimLineUnits decimal(18, 2),
ContractId int,
ContractRateId int,
ContractRate money,
ContractRuleId int)

create table #Contracts (
ContractId int,
ContractRateId int,
ContractRuleId int,
ApprovedAmount money,
UnitsApproved decimal(18, 2))

declare @RevenueCode varchar(25)
declare @HCPCSCode varchar(25)
declare @BillingCodeId int
declare @ContractId int
declare @ContractRateId int
declare @ContractRuleId int
declare @ProviderAuthorizationId int
declare @AuthorizationApproved int
declare @AuthorizationPartiallyApproved int
declare @AuthorizationPartiallyDenied int
declare @AuthorizationClosed int
declare @AuthorizationUnitsUsed decimal(18, 2)
declare @RowCount int
declare @ErrorMsgId int
declare @Reason varchar(250)
declare @ClaimLineRate money
declare @PayableAmount money
declare @DeniedAmount money
declare @AdjudicationId int
declare @ContractClaimLineAmount money
declare @Approved int
declare @PartiallyApproved int
declare @Paid int
declare @Void int
declare @Approval int
declare @Status int
declare @UnitsLeftToAllocate decimal(18, 2)
declare @ClaimLineUnitsApproved decimal(18, 2)
declare @ContractClaimLineUnits decimal(18, 2)
declare @ClaimLineIdDenial int
declare @ClaimBundleId int
declare @BundleClaimLineId int
declare @BundleAdjudicationId int
declare @BundleClaimType char(1)
        
set @AuthorizationClosed = 2044
set @AuthorizationApproved = 2042
set @AuthorizationPartiallyApproved = 2048
set @AuthorizationPartiallyDenied = 2049
set @Approved = 2023
set @PartiallyApproved = 2025
set @Paid = 2026
set @Void = 2028
set @Approval = 2007

begin try

  -- Checking for claim line status
  if exists ( select  *
              from    ClaimLines
              where   ClaimLineId = @ClaimLineId
                      and Status in (@Approved, @PartiallyApproved, @Paid) ) 
    begin     
      raiserror ('Claim line has been adjudicated by another user', 16, 1);     
    end
	
  --Checking for void or deleted claim line	 
  if exists ( select  ClaimLineId
              from    ClaimLines
              where   ClaimLineId = @ClaimLineId
                      and (Status = @Void
                           or RecordDeleted = 'Y') ) 
    begin    
      raiserror ('Claim line has been voided or deleted by another user', 16, 1);     
    end        

  select  @RevenueCode = RevenueCode,
          @HCPCSCode = ProcedureCode,
          @PayableAmount = isnull(PayableAmount, 0),
          @BillingCodeId = BillingCodeId
  from    ClaimLines
  where   ClaimLineId = @claimlineid
          and isnull(RecordDeleted, 'N') = 'N'

  -- Find billing code ID
  if @BillingCodeId is null
    and len(@HCPCSCode) > 0 
    begin
      select  @BillingCodeId = BillingCodeId
      from    BillingCodes
      where   BillingCode = @HCPCSCode
              and Active = 'Y'
              and isnull(RecordDeleted, 'N') = 'N'
    end
 
  if @BillingCodeId is null
    and len(@RevenueCode) > 0 
    begin
      select  @BillingCodeId = BillingCodeId
      from    BillingCodes
      where   BillingCode = @RevenueCode
              and Active = 'Y'
              and isnull(RecordDeleted, 'N') = 'N'
    end


  if @BillingCodeId is null 
    begin
      select  @Reason = CodeName + case when len(@HCPCSCode) > 0 then ': ' + @HCPCSCode
                                        when len(@RevenueCode) > 0 then ': ' + @RevenueCode
                                        else ''
                                   end
      from    GlobalCodes
      where   GlobalCodeId = 2521 -- Invalid billing code

      raiserror (@Reason, 16, 1);   
    end

  -- Determine if claim line is part of a bundle
  select top 1
          @ClaimBundleId = clb.ClaimBundleId,
          @BundleClaimLineId = clb.BundleClaimLineId,
          @BundleAdjudicationId = case when cl.Status in (2023, 2025, 2026) then cl.LastAdjudicationId
                                       else null
                                  end,
          @BundleClaimType = 'B'
  from    dbo.ssf_CMClaimLineBundles(@ClaimLineId, 'Bundle') clb
          join ClaimLines cl on cl.ClaimLineId = clb.BundleClaimLineId
  where   clb.ActivityClaimLineId = @ClaimLineId
          and clb.ClaimType = 'Bundle'
 
  -- Calculate amounts and status 
  set @DeniedAmount = @ClaimedAmount - @ApproveAmount
  set @ClaimLineRate = @ApproveAmount / @UnitsApproved
  set @PayableAmount = @PayableAmount + @ApproveAmount

  set @Status = case when @PayableAmount <= 0 then @Paid
                     when @ApproveAmount < @ClaimedAmount then @PartiallyApproved
                     else @Approved
                end

  update  ClaimLines
  set     Status = @Status,
          BillingCodeId = @BillingCodeId,
          PayableAmount = @PayableAmount,
          ManualApprovalReason = @ApproveReason,
          DenialReason = @PartialDenialReason,
          ToReadjudicate = 'N',
          NeedsToBeWorked = 'N',
		  OverridePendedReason = 'N',
          Modifiedby = @StaffCode,
          Modifieddate = getdate()
  where   ClaimLineId = @ClaimLineId 

  -- Get authorizations and contracts 
  insert  into #AuthorizationsContracts
          exec ssp_CMGetAuthorizationsRatesForClaimLineApproval 
            @ClaimLineId = @ClaimLineId

  -- Attach authorizations if specified
  if @AuthId > 0 
    begin
      set @UnitsLeftToAllocate = @UnitsApproved

      declare Authorizations_Cursor cursor
      for
      select  ProviderAuthorizationId,
              sum(AuthorizationUnitsUsed),
              sum(ClaimLineUnitsApproved)
      from    #AuthorizationsContracts
      where   ProviderAuthorizationId is not null
      group by ProviderAuthorizationId

      open Authorizations_Cursor
      fetch from Authorizations_Cursor into @ProviderAuthorizationId, @AuthorizationUnitsUsed, @ClaimLineUnitsApproved

      while @@fetch_status = 0
        and @UnitsLeftToAllocate > 0 
        begin
          if @UnitsLeftToAllocate < @ClaimLineUnitsApproved 
            begin
              set @AuthorizationUnitsUsed = (@AuthorizationUnitsUsed * @UnitsLeftToAllocate) / @ClaimLineUnitsApproved
              set @ClaimLineUnitsApproved = @UnitsLeftToAllocate
            end

          set @UnitsLeftToAllocate = @UnitsLeftToAllocate - @ClaimLineUnitsApproved

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
                   @StaffCode,
                   getdate(),
                   @StaffCode,
                   getdate())
    
          update  ProviderAuthorizations
          set     UnitsUsed = isnull(UnitsUsed, 0) + @AuthorizationUnitsUsed,
                  Status = case when TotalUnitsApproved <= (isnull(UnitsUsed, 0) + @AuthorizationUnitsUsed) then @AuthorizationClosed
                                else Status
                           end,
                  ModifiedBy = @StaffCode,
                  ModifiedDate = getdate()
          where   ProviderAuthorizationId = @ProviderAuthorizationId
                  and Status in (@AuthorizationApproved, @AuthorizationPartiallyApproved, @AuthorizationPartiallyDenied)
                  and Active = 'Y'
                  and (TotalUnitsApproved - isnull(UnitsUsed, 0)) >= @AuthorizationUnitsUsed
                  and isnull(RecordDeleted, 'N') = 'N'

          if @@rowcount = 0 
            begin
              raiserror ('Found authorization has been used by another user', 16, 1);     
            end 


          if exists ( select  *
                      from    ProviderAuthorizations
                      where   ProviderAuthorizationId = @ProviderAuthorizationId
                              and Status = @AuthorizationClosed ) 
            begin
              insert  into ProviderAuthorizationsHistory
                      (ProviderAuthorizationId,
                       InsurerId,
                       ClientId,
                       ProviderId,
                       SiteId,
                       BillingCodeId,
                       Modifier1,
                       Modifier2,
                       Modifier3,
                       Modifier4,
                       AuthorizationNumber,
                       Status,
                       StartDate,
                       EndDate,
                       UnitsApproved,
                       TotalUnitsApproved,
                       UnitsUsed,
                       CreatedBy,
                       CreatedDate,
                       ModifiedBy,
                       ModifiedDate)
                      select  ProviderAuthorizationId,
                              InsurerId,
                              ClientId,
                              ProviderId,
                              SiteId,
                              BillingCodeId,
                              Modifier1,
                              Modifier2,
                              Modifier3,
                              Modifier4,
                              AuthorizationNumber,
                              @AuthorizationApproved,
                              StartDate,
                              EndDate,
                              UnitsApproved,
                              TotalUnitsApproved,
                              UnitsUsed - @AuthorizationUnitsUsed,
                              ModifiedBy,
                              ModifiedDate,
                              ModifiedBy,
                              ModifiedDate
                      from    ProviderAuthorizations
                      where   ProviderAuthorizationId = @ProviderAuthorizationId

            end

          fetch from Authorizations_Cursor into @ProviderAuthorizationId, @AuthorizationUnitsUsed, @ClaimLineUnitsApproved
        end

      close Authorizations_Cursor
      deallocate Authorizations_Cursor
    end

  -- Attach contracts 
  set @UnitsLeftToAllocate = @UnitsApproved

  declare Contracts_Cursor cursor
  for
  select  ContractId,
          max(ContractRuleId),
          sum(ClaimLineUnits)
  from    #AuthorizationsContracts
  where   ContractId is not null
  group by ContractId

  open Contracts_Cursor
  fetch from Contracts_Cursor into @ContractId, @ContractRuleId, @ContractClaimLineUnits

  while @@fetch_status = 0
    and @UnitsLeftToAllocate > 0 
    begin
      if @UnitsLeftToAllocate < @ContractClaimLineUnits 
        set @ContractClaimLineUnits = @UnitsLeftToAllocate

      set @ContractClaimLineAmount = (@ApproveAmount * @ContractClaimLineUnits) / @UnitsApproved

      set @UnitsLeftToAllocate = @UnitsLeftToAllocate - @ContractClaimLineUnits

      select  @ContractRateId = min(ContractRateId)
      from    #AuthorizationsContracts
      where   ContractId = @ContractId
              and ContractRate = @ClaimLineRate

      insert  into #Contracts
              (ContractId,
               ContractRuleId,
               ContractRateId,
               ApprovedAmount,
               UnitsApproved)
              select  @ContractId,
                      @ContractRuleId,
                      @ContractRateId,
                      @ContractClaimLineAmount,
                      @ContractClaimLineUnits


      fetch from Contracts_Cursor into @ContractId, @ContractRuleId, @ContractClaimLineUnits
    end

  select top 1
          @ContractId = ContractId,
          @ContractRateId = ContractRateId
  from    #Contracts
  order by case when ContractRateId is not null then 1
                else 2
           end

  if @@rowcount = 0 
    select  @ContractId = null,
            @ContractRateId = null


  insert  into Adjudications
          (ClaimLineId,
           Status,
           ClaimedAmount,
           UnitsClaimed,
           ApprovedAmount,
           UnitsApproved,
           UnitsDenied,
           DeniedAmount,
           DenialReason,
           ContractId,
           ContractRateId,
           ClaimBundleId,
           BundleAdjudicationId,
           BundleClaimType,
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
  select  @ClaimLineId,
          @Status,
          @ClaimedAmount,
          @Units,
          @ApproveAmount,
          @UnitsApproved,
          @UnitsDenied,
          @DeniedAmount,
          @PartialDenialReason,
          @ContractId,
          @ContractRateId,
          @ClaimBundleId,
          @BundleAdjudicationId,
          @BundleClaimType,
          @StaffCode,
          getdate(),
          @StaffCode,
          getdate()
  union
  -- Add activity claim lines that are part of the bundle
  select  cl.ClaimLineId,
          @Status,
          cl.ClaimedAmount,
          cl.Units,
          0 as ApproveAmount,
          cl.Units as UnitsApproved,
          null as UnitsDenied,
          null as DeniedAmount,
          null as PartialDenialReason,
          null as ContractId,
          null as ContractRateId,
          clb.ClaimBundleId,
          @BundleAdjudicationId,
          'A',
          @StaffCode,
          getdate(),
          @StaffCode,
          getdate()
  from    dbo.ssf_CMClaimLineBundles(@ClaimLineId, 'Bundle') clb
          join ClaimLines cl on cl.ClaimLineId = clb.ActivityClaimLineId
  where   clb.BundleClaimLineId = @ClaimLineId
          and clb.ClaimType = 'Activity'
          and cl.Status in (2022, 2024, 2027)

  select  @AdjudicationId = na.AdjudicationId
  from    #NewAdjudications na
  where   na.ClaimLineId = @ClaimLineId

  if @ClaimBundleId is not null and @BundleAdjudicationId is null
    begin

      update  a
      set     BundleAdjudicationId = @AdjudicationId
      from    #NewAdjudications na
              join Adjudications a on a.AdjudicationId = na.AdjudicationId
    end

  -- Update status of bundle activity claim lines
  update  cl
  set     Status = na.Status
  from    ClaimLines cl
          join #NewAdjudications na on na.ClaimLineId = cl.ClaimLineId
  where   na.ClaimLineId <> @ClaimLineId

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
                  ContractId,
                  ContractRateId,
                  ContractRuleId,
                  ApprovedAmount,
                  UnitsApproved,
                  @StaffCode,
                  getdate(),
                  @StaffCode,
                  getdate()
          from    #Contracts

  update  cr
  set     TotalAmountUsed = isnull(cr.TotalAmountUsed, 0) + aa.ApprovedAmount,
          ModifiedBy = @StaffCode,
          ModifiedDate = getdate()
  from    ContractRules cr
          join (select  ContractRuleId,
                        sum(ApprovedAmount) as ApprovedAmount
                from    AdjudicationContracts
                where   AdjudicationId = @AdjudicationId
                        and ContractRuleId is not null
                group by ContractRuleId) aa on aa.ContractRuleId = cr.ContractRuleId

  update  c
  set     ClaimsApprovedAndPaid = round((isnull(ClaimsApprovedAndPaid, 0) + aa.ApprovedAmount), 2)
  from    Contracts c
          join (select  ContractId,
                        sum(ApprovedAmount) as ApprovedAmount
                from    AdjudicationContracts
                where   AdjudicationId = @AdjudicationId
                group by ContractId) aa on aa.ContractId = c.ContractId

  update  cl
  set     LastAdjudicationId = na.AdjudicationId,
          LastAdjudicationDate = na.CreatedDate
  from    ClaimLines cl
          join #NewAdjudications na on na.ClaimLineId = cl.ClaimLineId

  insert  into ClaimLineHistory
          (ClaimLineId,
           AdjudicationId,
           Activity,
           ActivityDate,
           Status,
           Reason,
           ActivityStaffId,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
          select  na.ClaimLineId,
                  na.AdjudicationId,
                  @Approval,
                  na.CreatedDate,
                  na.Status,
                  case when na.ClaimLineId = @ClaimLineId then nullif(@DenialText, '')
                       else null
                  end,
                  @StaffId,
                  @StaffCode,
                  getdate(),
                  @StaffCode,
                  getdate()
          from    #NewAdjudications na

  -- Open claims
  delete  oc
  from    OpenClaims oc
          join #NewAdjudications na on na.ClaimLineId = oc.ClaimLineId
  where   na.Status = @Paid

  insert  into OpenClaims
          (Claimlineid,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
          select  cl.ClaimLineId,
                  @StaffCode,
                  getdate(),
                  @StaffCode,
                  getdate()
          from    ClaimLines cl
          where   cl.ClaimLineId = @ClaimLineId
                  and cl.Status in (@Approved, @PartiallyApproved)
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
        @UserCode = @StaffCode

      fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

    end 
  
  close cur_ClaimLineDenials
  deallocate cur_ClaimLineDenials

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
 
  raiserror(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

end catch

go
