if object_id('dbo.ssp_CMUpdateClaimLineCoveragePlans') is not null 
  drop procedure dbo.ssp_CMUpdateClaimLineCoveragePlans
go
    
create procedure dbo.ssp_CMUpdateClaimLineCoveragePlans (
  @ClaimLineId int,
  @CoveragePlanId int,
  @PaidAmount float,
  @UserCode varchar(30))

/************************************************************************                
-- Stored Procedure: dbo.SSP_CMUpdateClaimLineCoveragePlans	
-- Creation Date:  15 OCT 2014	
-- Author:	Rohith Uppin	
--					
-- Data Modifications:
--						
-- Updates:			
--  Date          Author       Purpose	
-- 05.13.2016     SFarber      Added support for claim bundle  
-- 07.08.2016     SFarber      Added coverage plan claim budget logic.
-- 01.09.2019     SFarber      Modified to use ssf_CMClaimLineBundles
************************************************************************/
as 
create table #CoveragePlanClaimBudgets (
CoveragePlanClaimBudgetId int)

begin try

  insert  into ClaimlineCoveragePlans
          (ClaimLineId,
           CoveragePlanId,
           PaidAmount,
           SentToGL,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
          select  @ClaimLineId,
                  @CoveragePlanId,
                  @PaidAmount,
                  'N',
                  @UserCode,
                  getdate(),
                  @UserCode,
                  getdate()
          union all
		  -- Bundle activity claim lines
          select  cl.ClaimLineId,
                  @CoveragePlanId,
                  0,
                  'N',
                  @UserCode,
                  getdate(),
                  @UserCode,
                  getdate()
          from    dbo.ssf_CMClaimLineBundles(@ClaimLineId, 'Bundle') clb
                  join ClaimLines cl on cl.ClaimLineId = clb.ActivityClaimLineId
          where   clb.BundleClaimLineId = @ClaimLineId
                  and clb.ClaimType = 'Activity'

  -- Coverage plan claim budgets
  insert  into ClaimLineCoveragePlanClaimBudgets
          (CoveragePlanClaimBudgetId,
           ClaimLineId,
           PaidAmount,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  output  inserted.CoveragePlanClaimBudgetId
          into #CoveragePlanClaimBudgets (CoveragePlanClaimBudgetId)
          select  cpcb.CoveragePlanClaimBudgetId,
                  cl.ClaimLineId,
                  @PaidAmount,
                  @UserCode,
                  getdate(),
                  @UserCode,
                  getdate()
          from    ClaimLines cl
                  join Claims cm on cm.ClaimId = cl.ClaimId
                  join Sites s on s.SiteId = cm.SiteId
                  join BillingCodeModifiers clbcm on clbcm.BillingCodeId = cl.BillingCodeId
                  join CoveragePlanClaimBudgets cpcb on cpcb.CoveragePlanId = @CoveragePlanId
                  left join CoveragePlanClaimBudgetClients c on c.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                                                and isnull(c.RecordDeleted, 'N') = 'N'
          where   cl.ClaimLineId = @ClaimLineId
                  and isnull(clbcm.RecordDeleted, 'N') = 'N'
                  and isnull(cpcb.RecordDeleted, 'N') = 'N'
                  and isnull(clbcm.Modifier1, '') = isnull(cl.Modifier1, '')
                  and isnull(clbcm.Modifier2, '') = isnull(cl.Modifier2, '')
                  and isnull(clbcm.Modifier3, '') = isnull(cl.Modifier3, '')
                  and isnull(clbcm.Modifier4, '') = isnull(cl.Modifier4, '')
                  and cpcb.Active = 'Y'
                  and (cl.FromDate between cpcb.StartDate and cpcb.EndDate
                       or cl.ToDate between cpcb.StartDate and cpcb.EndDate)
                  and (c.ClientId is null
                       or c.ClientId = cm.ClientId)
                  and (cpcb.ProviderSiteGroupName is null
                       or exists ( select *
                                   from   CoveragePlanClaimBudgetProviderSites ps
                                   where  ps.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                          and ((ps.ProviderId = s.ProviderId
                                                and ps.SiteId = null)
                                               or ps.SiteId = s.SiteId)
                                          and isnull(ps.RecordDeleted, 'N') = 'N' ))
                  and (cpcb.BillingCodeGroupName is null
                       or exists ( select *
                                   from   CoveragePlanClaimBudgetBillingCodes bc
                                          join BillingCodeModifiers bcm on bcm.BillingCodeModifierId = bc.BillingCodeModifierId
                                   where  bc.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                          and isnull(bc.RecordDeleted, 'N') = 'N'
                                          and isnull(bcm.RecordDeleted, 'N') = 'N'
                                          and ((bcm.BillingCodeId = cl.BillingCodeId
                                                and bc.ApplyToAllModifiers = 'Y')
                                               or (bc.BillingCodeModifierId = clbcm.BillingCodeModifierId)) ))
                  and (cpcb.InsurerGroupName is null
                       or exists ( select *
                                   from   CoveragePlanClaimBudgetInsurers i
                                   where  i.CoveragePlanClaimBudgetId = cpcb.CoveragePlanClaimBudgetId
                                          and i.InsurerId = cm.InsurerId
                                          and isnull(i.RecordDeleted, 'N') = 'N' ))	
										  
  update  cpcb
  set     PaidAmount = isnull(cpcb.PaidAmount, 0) + @PaidAmount
  from    #CoveragePlanClaimBudgets cpcbt
          join CoveragePlanClaimBudgets cpcb on cpcb.CoveragePlanClaimBudgetId = cpcbt.CoveragePlanClaimBudgetId
 										  			 		
  
end try
	
begin catch
  declare @Error varchar(8000) 

  set @Error = convert(varchar, error_number()) + '*****' + convert(varchar(4000), error_message()) + '*****' + isnull(convert(varchar, error_procedure()), '[SSP_CMUpdateClaimLineCoveragePlans]') + '*****' + convert(varchar, error_line()) + '*****' + convert(varchar, error_severity()) + '*****' + convert(varchar, error_state()) 

  raiserror (@Error,16,1); 
end catch

go
