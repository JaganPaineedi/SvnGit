if object_id('dbo.ssp_CMRevertClaimLine') is not null
  drop procedure dbo.ssp_CMRevertClaimLine
go

create procedure dbo.ssp_CMRevertClaimLine
  @ClaimLineId int,
  @UserId int,
  @UserCode varchar(30),
  @DenialReason type_GlobalCode,
  @DenyReasonText varchar(250)    
/*********************************************************************            
-- Stored Procedure: dbo.ssp_CMRevertClaimLine  
-- Copyright: Streamline Healthcare Solutions
--
-- Purpose: reverts a claim line  
--                                                                                    
--                                                      
-- Modified Date    Modified By       Purpose  
-- 02.02.2006       Raman Behl        Created.  
-- 05.29.2008       SFarber           Redesigned.  
-- 10.20.2009       SFarber           Added code to execute ssp_CMAdjudicateClaimLineDenials  
-- 02.25.2010       SFarber           Modified to reset the NeedsToBeWorked flag.  
-- 05.14.2012       Sourabh           Modified to delete AdjudicationDenialPendedReasons and ClaimLinesReallocations.  
-- 20.OCT.2014		Rohith Uppin	  Table name renamed from ClaimLinePlans to ClaimLineCoveragePlans.Task#25 CM to SC.
-- 21.OCT.2014		Rohith Uppin	  Column name modified from PlanId to CoveragePlanId
-- 18 Dec 2015		RQuigley		  Correct auth status update to only change if status was closed.
-- 04.22.2016       SFarber           Modified to support claim bundles.
-- 07.08.2016       SFarber           Modified to support coverage plan claim budget caps.
-- 03.23.2017       Kkumar            Modified to round off  ClaimsApprovedAndPaid to 2 decimals.
-- 06.30.2017       Pranay            Added  @DenialReason and  @DenyReasonText SWMHA Task#557.
-- 08.18.2017       SFarber           Modified to update LastAdjudicationId and LastAdjudicationDate
-- 10.26.2017       SFarber           Modified to revert corresponding Add-On claim lines
-- 03.08.2018       SFarber           Fixed auth status update logic.
-- 03.28.2018		MD				  Added the missing default value for @AuthorizationPartiallyApproved variable which is used to update Provider Authorization status w.r.t KCMHSAS - Support #1011
-- 09.07.2018       SFarber           Modified to update OverridePendedReason
-- 01.09.2019       SFarber           Modified claim bundling logic.
****************************************************************************/
as
declare @Approved int
declare @PartiallyApproved int
declare @Paid int
declare @EntryComplete int
declare @Void int
declare @Reversal int
declare @StatusIn int
declare @AuthorizationApproved int
declare @AuthorizationPartiallyApproved int
declare @AuthorizationClosed int
declare @AdjudicationId int
declare @NewAdjudicationId int  
declare @EntryInComplete int
declare @ClaimLineIdDenial int
 
create table #ClaimLines (ClaimLineId int,
                          StatusIn int,
                          AdjudicationId int,
                          DenialReason int)

create table #NewAdjudications (AdjudicationId int,
                                ClaimLineId int,
                                CreatedDate datetime)

create table #CoveragePlanClaimBudgets (CoveragePlanClaimBudgetId int,
                                        PaidAmount money)
  
set @Approved = 2023  
set @PartiallyApproved = 2025  
set @Paid = 2026  
set @EntryComplete = 2022  
set @EntryInComplete = 2021  
set @Void = 2028  
set @Reversal = 2004  
set @AuthorizationApproved = 2042  
set @AuthorizationClosed = 2044  
set @AuthorizationPartiallyApproved = 2048 -- Added by MD on 3/28/2018

begin try
  
  select top 1
          @AdjudicationId = cl.LastAdjudicationId
  from    ClaimLines cl
  where   ClaimLineId = @ClaimLineId
 
  insert  into #ClaimLines
          (ClaimLineId,
           StatusIn,
           AdjudicationId,
           DenialReason)
  -- Claim line that is being processed
  select  cl.ClaimLineId,
          cl.Status,
          @AdjudicationId,
          @DenialReason
  from    ClaimLines cl
  where   cl.ClaimLineId = @ClaimLineId
          and cl.Status not in (@Void, @EntryComplete, @EntryInComplete)
          and isnull(cl.RecordDeleted, 'N') = 'N'
  union 
  -- All claim lines associated with the bundle when @ClaimLineId = bundle claim line ID
  select  cl.ClaimLineId,
          cl.Status,
          a.AdjudicationId,
          @DenialReason
  from    Adjudications a
          join ClaimLines cl on cl.ClaimLineId = a.ClaimLineId
  where   a.BundleAdjudicationId = @AdjudicationId
          and cl.ClaimLineId <> @ClaimLineId
		  and cl.Status not in (@Void, @EntryComplete, @EntryInComplete)
          and isnull(cl.RecordDeleted, 'N') = 'N'
  union
  -- All claim lines associated with the bundle when @ClaimLineId = activity claim line ID
  select  ab.ClaimLineId,
          cl.Status,
          ab.AdjudicationId,
          @DenialReason
  from    Adjudications a
          join Adjudications ab on ab.BundleAdjudicationId = a.BundleAdjudicationId
          join ClaimLines cl on cl.ClaimLineId = ab.ClaimLineId
  where   a.AdjudicationId = @AdjudicationId
          and a.BundleClaimType = 'A'
          and cl.ClaimLineId <> @ClaimLineId
          and cl.Status not in (@Void, @EntryComplete, @EntryInComplete)
          and isnull(cl.RecordDeleted, 'N') = 'N'
  union
  -- Add-On codes
  select  cla.ClaimLineId,
          cl.Status,
          cl.LastAdjudicationId,
          @DenialReason
  from    dbo.ssf_GetAddOnClaimLines(@ClaimLineId) cla
          join ClaimLines cl on cl.ClaimLineId = cla.ClaimLineId
          join Claims c on c.ClaimId = cl.ClaimId
  where   cl.Status not in (@Void, @EntryComplete, @EntryInComplete)
          and exists ( select *
                       from   AdjudicationRules ar
                       where  ar.RuleTypeId in (2586, 2587)
                              and ar.Active = 'Y'
                              and (ar.StartDate <= getdate()
                                   or ar.StartDate is null)
                              and (dateadd(dd, 1, ar.EndDate) > getdate()
                                   or ar.EndDate is null)
                              and isnull(ar.RecordDeleted, 'N') = 'N'
                              and (ar.AllInsurers = 'Y'
                                   or exists ( select *
                                               from   AdjudicationRuleInsurers ari
                                               where  ari.AdjudicationRuleId = ar.AdjudicationRuleId
                                                      and ari.InsurerId = c.InsurerId
                                                      and isnull(ari.RecordDeleted, 'N') = 'N' )) )

		    

  -- Check if there is any claim line to revert
  if not exists ( select  *
                  from    #ClaimLines )
    begin          
      goto final 
    end  
   
  
  update  cl
  set     Status = @EntryComplete,
          PayableAmount = case isnull(PaidAmount, 0)
                            when 0 then null
                            else -PaidAmount
                          end,
          NeedsToBeWorked = 'N',
		  OverridePendedReason = 'N'
  from    #ClaimLines rcl
          join ClaimLines cl on cl.ClaimLineId = rcl.ClaimLineId
  
 
  insert  into Adjudications
          (ClaimLineId,
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
           ContractId,
           ContractRateId,
           BundleAdjudicationId,
           BundleClaimType,
		   ClaimBundleId,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  output  inserted.AdjudicationId,
          inserted.ClaimLineId,
          inserted.CreatedDate
          into #NewAdjudications (AdjudicationId, ClaimLineId, CreatedDate)
  select  a.ClaimLineId,
          @EntryComplete,
          a.ClaimedAmount,
          a.UnitsClaimed,
          -a.ApprovedAmount,
          -a.UnitsApproved,
          -a.DeniedAmount,
          a.DenialReason,
          a.UnitsDenied,
          a.UnitsPended,
          a.PendedAmount,
          a.ContractId,
          a.ContractRateId,
          a.BundleAdjudicationId,
          a.BundleClaimType,
          a.ClaimBundleId,
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
          join Adjudications a on a.AdjudicationId = cl.AdjudicationId
 
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
          @Reversal,
          na.CreatedDate,
          @EntryComplete,
          @UserId,
          na.AdjudicationId,
          @DenyReasonText,
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #NewAdjudications na
  
  
  -- Revert Claim Line Coverage Plans  
  insert  into ClaimLineCoveragePlans
          (ClaimLineId,
           CoveragePlanId,
           PaidAmount,
           SentToGL,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  select  clcp.ClaimLineId,
          clcp.CoveragePlanId,
          -sum(clcp.PaidAmount),
          'N',
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
          join ClaimLineCoveragePlans clcp on clcp.ClaimLineId = cl.ClaimLineId
  where   cl.StatusIn in (@Approved, @PartiallyApproved, @Paid)
          and isnull(clcp.RecordDeleted, 'N') = 'N'
  group by clcp.ClaimLineId,
          clcp.CoveragePlanId
  having  sum(clcp.PaidAmount) <> 0  
 
  -- Record delete claim line coverage plans for $0 claim lines since there is nothing to revert 
  update  clcp
  set     RecordDeleted = 'Y',
          DeletedDate = getdate(),
          DeletedBy = @UserCode
  from    #ClaimLines cl
          join ClaimLineCoveragePlans clcp on clcp.ClaimLineId = cl.ClaimLineId
  where   cl.StatusIn in (@Approved, @PartiallyApproved, @Paid)
          and clcp.PaidAmount = 0
          and isnull(clcp.RecordDeleted, 'N') = 'N'
        
  -- Revert Contracts and Contract Rules  
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
  select  na.AdjudicationId,
          ac.ContractId,
          ac.ContractRateId,
          ac.ContractRuleId,
          -ac.ApprovedAmount,
          -ac.UnitsApproved,
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
          join AdjudicationContracts ac on ac.AdjudicationId = cl.AdjudicationId
          join #NewAdjudications na on na.ClaimLineId = cl.ClaimLineId
  where   cl.StatusIn in (@Approved, @PartiallyApproved, @Paid)
          and isnull(ac.RecordDeleted, 'N') = 'N'  
  
    
  update  cr
  set     TotalAmountUsed = isnull(cr.TotalAmountUsed, 0) - aa.ApprovedAmount,
          ModifiedBy = @UserCode,
          ModifiedDate = getdate()
  from    ContractRules cr
          join (select  ac.ContractRuleId,
                        sum(ac.ApprovedAmount) as ApprovedAmount
                from    #ClaimLines cl
                        join AdjudicationContracts ac on ac.AdjudicationId = cl.AdjudicationId
                where   ac.ContractRuleId is not null
                group by ac.ContractRuleId) aa on aa.ContractRuleId = cr.ContractRuleId  
  
  
  update  c
  set     ClaimsApprovedAndPaid = round((isnull(c.ClaimsApprovedAndPaid, 0) - aa.ApprovedAmount), 2)
  from    Contracts c
          join (select  ac.ContractId,
                        sum(ac.ApprovedAmount) as ApprovedAmount
                from    #ClaimLines cl
                        join AdjudicationContracts ac on ac.AdjudicationId = cl.AdjudicationId
                group by ac.ContractId) aa on aa.ContractId = c.ContractId  
  
  
  -- Revert authorizations  
  insert  into ProviderAuthorizationsHistory
          (ProviderAuthorizationId,
           InsurerId,
           ClientId,
           ProviderId,
           SiteId,
           BillingCodeId,
           AuthorizationNumber,
           Status,
           StartDate,
           EndDate,
           UnitsApproved,
           UnitsUsed,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  select  pa.ProviderAuthorizationId,
          pa.InsurerId,
          pa.ClientId,
          pa.ProviderId,
          pa.SiteId,
          pa.BillingCodeId,
          pa.AuthorizationNumber,
          pa.Status,
          pa.StartDate,
          pa.EndDate,
          pa.UnitsApproved,
          pa.UnitsUsed,
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
          join dbo.ClaimLineAuthorizations cla on cla.ClaimLineId = cl.ClaimLineId
          join ProviderAuthorizations pa on pa.ProviderAuthorizationId = cla.ProviderAuthorizationId
  where   pa.Status = @AuthorizationClosed
          and isnull(cla.RecordDeleted, 'N') = 'N'
          and isnull(pa.RecordDeleted, 'N') = 'N';
				   
  with  CTE_ClaimLineAuthorizations
          as (select  cla.ProviderAuthorizationId,
                      sum(cla.UnitsUsed) as UnitsUsed
              from    #ClaimLines cl
                      join ClaimLineAuthorizations cla on cla.ClaimLineId = cl.ClaimLineId
              where   isnull(cla.RecordDeleted, 'N') = 'N'
              group by cla.ProviderAuthorizationId)
    update  pa
    set     Status = case when pa.Status = @AuthorizationClosed then case when pa.TotalUnitsRequested > pa.TotalUnitsApproved then @AuthorizationPartiallyApproved
                                                                          else @AuthorizationApproved
                                                                     end
                          else pa.Status
                     end,
            UnitsUsed = pa.UnitsUsed - cla.UnitsUsed
    from    CTE_ClaimLineAuthorizations cla
            join ProviderAuthorizations pa on pa.ProviderAuthorizationId = cla.ProviderAuthorizationId
    where   isnull(pa.RecordDeleted, 'N') = 'N'

  update  cla
  set     RecordDeleted = 'Y',
          DeletedBy = @UserCode,
          DeletedDate = getdate()
  from    #ClaimLines cl
          join ClaimLineAuthorizations cla on cla.ClaimLineId = cl.ClaimLineId
  where   isnull(RecordDeleted, 'N') = 'N'  
 
  -- Rever claim line coverage plan claim budget paid amounts
  insert  into dbo.ClaimLineCoveragePlanClaimBudgets
          (CoveragePlanClaimBudgetId,
           ClaimLineId,
           PaidAmount,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  output  inserted.CoveragePlanClaimBudgetId,
          inserted.PaidAmount
          into #CoveragePlanClaimBudgets (CoveragePlanClaimBudgetId, PaidAmount)
  select  cb.CoveragePlanClaimBudgetId,
          cb.ClaimLineId,
          -sum(PaidAmount),
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    ClaimLineCoveragePlanClaimBudgets cb
          join #ClaimLines cl on cl.ClaimLineId = cb.ClaimLineId
  where   isnull(cb.RecordDeleted, 'N') = 'N'
  group by cb.CoveragePlanClaimBudgetId,
          cb.ClaimLineId
  having  sum(cb.PaidAmount) <> 0;
   
  with  CTE_CoveragePlanClaimBudgets
          as (select  CoveragePlanClaimBudgetId,
                      sum(PaidAmount) as PaidAmount
              from    #CoveragePlanClaimBudgets
              group by CoveragePlanClaimBudgetId)
    update  cpcb
    set     PaidAmount = isnull(cpcb.PaidAmount, 0) + cb.PaidAmount
    from    CTE_CoveragePlanClaimBudgets cb
            join CoveragePlanClaimBudgets cpcb on cpcb.CoveragePlanClaimBudgetId = cb.CoveragePlanClaimBudgetId

  -- Open claims
  insert  into OpenClaims
          (ClaimLineId,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  select  cl.ClaimLineId,
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
  where   not exists ( select *
                       from   OpenClaims oc
                       where  oc.ClaimLineId = cl.ClaimLineId )
  

  -- Handle claim line denials  
  declare cur_ClaimLineDenials cursor
  for
  select  ClaimLineId
  from    #ClaimLines 

  open cur_ClaimLineDenials 
  fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

  while @@fetch_status = 0
    begin

      exec ssp_CMAdjudicateClaimLineDenials @ClaimLineId = @ClaimLineIdDenial, @UserCode = @UserCode

      fetch cur_ClaimLineDenials into @ClaimLineIdDenial 

    end 
  
  close cur_ClaimLineDenials
  deallocate cur_ClaimLineDenials

  final:  
  
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