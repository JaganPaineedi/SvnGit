if object_id('dbo.ssp_CMReallocateClaimLineCoveragePlans') is not null
  drop procedure dbo.ssp_CMReallocateClaimLineCoveragePlans
go  

create procedure dbo.ssp_CMReallocateClaimLineCoveragePlans
  @StartDate date = null,
  @EndDate date = null,
  @InsurerId int = null,
  @ClientId int = null,
  @ClaimLineId int = null,
  @CoveragePlanId int = null,
  @UserCode varchar(30) = null
/*********************************************************************                              
-- Stored Procedure: dbo.ssp_CMReallocateClaimLineCoveragePlans
-- Creation Date: 06.05.2015                             
--                               
-- Purpose: Reallocates claim line coverage plans based on current client's coverage
--                              
-- Modifications:                              
--   Date       Author   Purpose                              
--  06.05.2015  SFarber  Created.
--  07.15.2017  SFarber  Modified to stop reallocation if original coverage specific rate was used for adjudication.
*********************************************************************/
as

set nocount on

create table #ClaimLines (ClaimLineId int,
                          ClientId int,
                          InsurerId int,
                          ProviderId int,
                          SiteId int,
                          ServiceAreaId int,
                          InsurerValidAllCoveragePlans char(1),
                          BillingCodeId int,
                          BillingCodeValidAllCoveragePlans char(1),
                          BillingCodeModifierId int,
                          Modifier1 varchar(10),
                          Modifier2 varchar(10),
                          Modifier3 varchar(10),
                          Modifier4 varchar(10),
                          PaidAmount money,
                          FromDate datetime,
                          ToDate datetime,
                          OldCoveragePlanId int,
                          OldCoveragePlanRateUsed char(1) default 'N',
                          NewCoveragePlanId int,
                          NewCoveragePlanHasMonthlyDeductible char(1) default 'N',
                          NewCoveragePlanMonthlyDeductibleMet char(1),
                          Status varchar(max))

create table #ClaimLineMonths (ClaimLineId int,
                               ClaimLineMonth int,
                               ClaimLineYear int,
                               ClientId int,
                               DateMonthlyDeductibleNeedsToBeMet date)

create table #ClaimLineCoveragePlans (ClaimLineId int,
                                      ClientCoveragePlanId int,
                                      CoveragePlanId int,
                                      COBOrder int,
                                      HasMonthlyDeductible char(1) default 'N',
                                      MonthlyDeductibleMet char(1))

begin try

  if @StartDate is null
    and @ClaimLineId is null
    set @StartDate = dateadd(dd, -365, getdate())  

  if @UserCode is null
    set @UserCode = 'REALLOCATECLAIMLINEPLAN'

  -- Select all claim lines based on passed in criteria
  insert  into #ClaimLines
          (ClaimLineId,
           ClientId,
           InsurerId,
           ProviderId,
           SiteId,
           ServiceAreaId,
           InsurerValidAllCoveragePlans,
           BillingCodeId,
           BillingCodeValidAllCoveragePlans,
           Modifier1,
           Modifier2,
           Modifier3,
           Modifier4,
           PaidAmount,
           FromDate,
           ToDate,
           OldCoveragePlanId)
  select  cl.ClaimLineId,
          max(c.ClientId),
          max(c.InsurerId),
          max(s.ProviderId),
          max(c.SiteId),
          max(i.ServiceAreaId),
          max(i.ValidAllCoveragePlans),
          max(bc.BillingCodeId),
          max(bc.ValidAllPlans),
          max(cl.Modifier1),
          max(cl.Modifier2),
          max(cl.Modifier3),
          max(cl.Modifier4),
          sum(clp.PaidAmount),
          max(cl.FromDate),
          max(cl.ToDate),
          clp.CoveragePlanId
  from    ClaimLines cl
          join Claims c on c.ClaimId = cl.ClaimId
          join ClaimLineCoveragePlans clp on clp.ClaimLineId = cl.ClaimLineId
          join BillingCodes bc on bc.BillingCodeId = cl.BillingCodeId
          join Insurers i on i.InsurerId = c.InsurerId
          join Sites s on s.SiteId = c.SiteId
  where   (cl.FromDate >= @StartDate
           or @StartDate is null)
          and (cl.FromDate < dateadd(day, 1, @EndDate)
               or @EndDate is null)
          and (cl.ClaimLineId = @ClaimLineId
               or @ClaimLineId is null)
          and (c.ClientId = @ClientId
               or @ClientId is null)
          and (c.InsurerId = @InsurerId
               or @InsurerId is null)
          and (clp.CoveragePlanId = @CoveragePlanId
               or @CoveragePlanId is null)
          and cl.Status in (2023, 2025, 2026)
          and isnull(cl.NeedsToBeWorked, 'N') = 'N'
          and isnull(cl.RecordDeleted, 'N') = 'N'
          and isnull(c.RecordDeleted, 'N') = 'N'
          and isnull(clp.RecordDeleted, 'N') = 'N'
  group by cl.ClaimLineId,
          clp.CoveragePlanId
  having  ((sum(clp.PaidAmount) > 0
            and sum(cl.ClaimedAmount) > 0)
           or (sum(clp.PaidAmount) = 0
               and sum(cl.ClaimedAmount) = 0))
 
  create index XIE1_#ClaimLines on #ClaimLines(ClaimLineId)

  update  cl
  set     BillingCodeModifierId = bcm.BillingCodeModifierId
  from    #ClaimLines cl
          join dbo.BillingCodeModifiers bcm on bcm.BillingCodeId = cl.BillingCodeId
                                               and bcm.Modifier1 = cl.Modifier1
                                               and bcm.Modifier2 = cl.Modifier2
                                               and bcm.Modifier3 = cl.Modifier3
                                               and bcm.Modifier4 = cl.Modifier4
  where   isnull(bcm.RecordDeleted, 'N') = 'N'


  -- Compile a table of all months for each claim line
  insert  into #ClaimLineMonths
          (ClaimLineId,
           ClaimLineMonth,
           ClaimLineYear,
           ClientId,
           DateMonthlyDeductibleNeedsToBeMet)
  select  cl.ClaimLineId,
          datepart(month, cl.FromDate),
          datepart(year, cl.FromDate),
          cl.ClientId,
          cl.FromDate
  from    #ClaimLines cl
  where   datediff(month, cl.FromDate, cl.ToDate) = 0;


  with  ClaimLineMonths(ClaimLineId, ClaimLineMonth, ClaimLineYear, MonthStartDate, ClientId, DateMonthlyDeductibleNeedsToBeMet)
          as (  
               -- Anchor definition  
              select  cl.ClaimLineId,
                      datepart(month, cl.FromDate),
                      datepart(year, cl.FromDate),
                      convert(date, convert(varchar(6), cl.FromDate, 112) + '01'),
                      cl.ClientId,
                      convert(date, cl.FromDate)
              from    #ClaimLines cl
              where   datediff(month, cl.FromDate, cl.ToDate) > 0
              union all  
              -- Recursive definition  
              select  cl.ClaimLineId,
                      datepart(month, dateadd(month, 1, clm.MonthStartDate)),
                      datepart(year, dateadd(month, 1, clm.MonthStartDate)),
                      dateadd(month, 1, clm.MonthStartDate),
                      cl.ClientId,
                      dateadd(month, 1, clm.MonthStartDate)
              from    #ClaimLines cl
                      join ClaimLineMonths clm on clm.ClaimLineId = cl.ClaimLineId
              where   dateadd(month, 1, clm.MonthStartDate) <= cl.ToDate)
    insert  into #ClaimLineMonths
            (ClaimLineId,
             ClaimLineMonth,
             ClaimLineYear,
             ClientId,
             DateMonthlyDeductibleNeedsToBeMet)
    select  ClaimLineId,
            ClaimLineMonth,
            ClaimLineYear,
            ClientId,
            DateMonthlyDeductibleNeedsToBeMet
    from    ClaimLineMonths clm

  create index XIE1_#ClaimLineMonths on #ClaimLineMonths(ClaimLineId)

  insert  into #ClaimLineCoveragePlans
          (ClaimLineId,
           ClientCoveragePlanId,
           CoveragePlanId,
           COBOrder)
  select  cl.ClaimLineId,
          ccp.ClientCoveragePlanId,
          cp.CoveragePlanId,
          cch.COBOrder
  from    #ClaimLines cl
          join ClientCoveragePlans ccp on ccp.ClientId = cl.ClientId
          join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                            and cch.ServiceAreaId = cl.ServiceAreaId
          join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
  where   isnull(cp.ThirdPartyPlan, 'N') = 'N'
          and cch.StartDate <= cl.FromDate
          and (dateadd(dd, 1, cch.EndDate) > cl.ToDate
               or cch.EndDate is null)
          and (cl.InsurerValidAllCoveragePlans = 'Y'
               or exists ( select '*'
                           from   InsurerValidCoveragePlans ivcp
                           where  ivcp.InsurerId = cl.InsurerId
                                  and ivcp.CoveragePlanId = cp.CoveragePlanId
                                  and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
          and (cl.BillingCodeValidAllCoveragePlans = 'Y'
               or exists ( select '*'
                           from   BillingCodeValidCoveragePlans bcvcp
                           where  bcvcp.BillingCodeId = cl.BillingCodeId
                                  and bcvcp.CoveragePlanId = cp.CoveragePlanId
                                  and isnull(bcvcp.RecordDeleted, 'N') = 'N' ))
          and isnull(cch.RecordDeleted, 'N') = 'N'
          and isnull(ccp.RecordDeleted, 'N') = 'N'

  update  clcp
  set     HasMonthlyDeductible = 'Y',
          MonthlyDeductibleMet = 'N'
  from    #ClaimLineCoveragePlans clcp
  where   exists ( select '*'
                   from   dbo.ClientMonthlyDeductibles cmd
                          join #ClaimLineMonths clm on clm.ClaimLineId = clcp.ClaimLineId
                   where  cmd.ClientCoveragePlanId = clcp.ClientCoveragePlanId
                          and cmd.DeductibleMonth = clm.ClaimLineMonth
                          and cmd.DeductibleYear = clm.ClaimLineYear
                          and isnull(cmd.RecordDeleted, 'N') = 'N' )                   

  update  clcp
  set     MonthlyDeductibleMet = 'U'
  from    #ClaimLineCoveragePlans clcp
  where   clcp.HasMonthlyDeductible = 'Y'
          and exists ( select '*'
                       from   dbo.ClientMonthlyDeductibles cmd
                              join #ClaimLineMonths clm on clm.ClaimLineId = clcp.ClaimLineId
                       where  cmd.ClientCoveragePlanId = clcp.ClientCoveragePlanId
                              and cmd.DeductibleMonth = clm.ClaimLineMonth
                              and cmd.DeductibleYear = clm.ClaimLineYear
                              and cmd.DeductibleMet = 'U'
                              and isnull(cmd.RecordDeleted, 'N') = 'N' )                   

  update  clcp
  set     MonthlyDeductibleMet = 'Y'
  from    #ClaimLineCoveragePlans clcp
  where   clcp.HasMonthlyDeductible = 'Y'
          and clcp.MonthlyDeductibleMet = 'N'
          and exists ( select '*'
                       from   dbo.ClientMonthlyDeductibles cmd
                              join #ClaimLineMonths clm on clm.ClaimLineId = clcp.ClaimLineId
                       where  cmd.ClientCoveragePlanId = clcp.ClientCoveragePlanId
                              and cmd.DeductibleMonth = clm.ClaimLineMonth
                              and cmd.DeductibleYear = clm.ClaimLineYear
                              and cmd.DeductibleMet = 'Y'
                              and clm.DateMonthlyDeductibleNeedsToBeMet >= cmd.DateMet
                              and isnull(cmd.RecordDeleted, 'N') = 'N' );


  with  CTE_ClaimLineCoveragePlans
          as (select  clcp.ClaimLineId,
                      clcp.CoveragePlanId,
                      clcp.HasMonthlyDeductible,
                      clcp.MonthlyDeductibleMet,
                      row_number() over (partition by clcp.ClaimLineId order by case when (clcp.HasMonthlyDeductible = 'N'
                                                                                           or (clcp.HasMonthlyDeductible = 'Y'
                                                                                               and clcp.MonthlyDeductibleMet in ('Y', 'U'))) then 1
                                                                                     else 2
                                                                                end, COBOrder) as COBOrder
              from    #ClaimLineCoveragePlans clcp)
    update  cl
    set     NewCoveragePlanId = clcp.CoveragePlanId,
            NewCoveragePlanHasMonthlyDeductible = clcp.HasMonthlyDeductible,
            NewCoveragePlanMonthlyDeductibleMet = clcp.MonthlyDeductibleMet
    from    #ClaimLines cl
            join CTE_ClaimLineCoveragePlans clcp on clcp.ClaimLineId = cl.ClaimLineId
    where   clcp.COBOrder = 1       

  begin tran

  -- Delete errors from previous run
  update rc
     set RecordDeleted = 'Y',
	     DeletedBy = @UserCode,
		 DeletedDate = getdate()
    from #ClaimLines cl
	     join ReallocatedClaimLines rc on rc.ClaimLineId = cl.ClaimLineId
   where rc.Status <> 'Reallocated'
     and isnull(rc.RecordDeleted, 'N') = 'N'
       
  -- Nothing to reallocate if a new plan matches the old one 
  delete  cl
  from    #ClaimLines cl
  where   cl.NewCoveragePlanId = cl.OldCoveragePlanId
          and (cl.NewCoveragePlanHasMonthlyDeductible = 'N'
               or (cl.NewCoveragePlanHasMonthlyDeductible = 'Y'
                   and cl.NewCoveragePlanMonthlyDeductibleMet = 'Y'))


  -- Determine if coverage plan specific rate was used to adjudicate a claim line
  update  cl
  set     OldCoveragePlanRateUsed = 'Y'
  from    #ClaimLines cl
          join Adjudications a on a.ClaimLineId = cl.ClaimLineId
  where   cl.NewCoveragePlanId is not null
          and cl.OldCoveragePlanId <> cl.NewCoveragePlanId
          and isnull(a.RecordDeleted, 'N') = 'N'
          and not exists ( select *
                           from   Adjudications a2
                           where  a2.ClaimLineId = cl.ClaimLineId
                                  and isnull(a2.RecordDeleted, 'N') = 'N'
                                  and a2.AdjudicationId > a.AdjudicationId )
          and exists ( select *
                       from   AdjudicationContracts ac
                              join ContractRates cr on cr.ContractRateId = ac.ContractRateId
                       where  ac.AdjudicationId = a.AdjudicationId
                              and cr.CoveragePlanGroupName is not null
                              and isnull(ac.RecordDeleted, 'N') = 'N' )

  -- Calculate reallocation status
  update  cl
  set     Status = case when cl.NewCoveragePlanId is null then 'Unable to reallocate. Original plan is no longer valid. New plan is not found.'
                        when cl.OldCoveragePlanRateUsed = 'Y' then 'Unable to reallocate. Original plan''s contract rate was used for adjudication.'
                        when cl.NewCoveragePlanHasMonthlyDeductible = 'Y'
                             and cl.NewCoveragePlanMonthlyDeductibleMet in ('N', 'U') then case when cl.NewCoveragePlanId = cl.OldCoveragePlanId then 'Original plan has monthly deductible.'
                                                                                                else 'Unable to reallocate. Potential plan has monthly deductible.'
                                                                                           end + ' Deductible status is ' + case when cl.NewCoveragePlanMonthlyDeductibleMet = 'U' then 'Unknown'
                                                                                                                                 else 'Not Met'
                                                                                                                            end + '.'
                        else 'Reallocated'
                   end
  from    #ClaimLines cl




  -- If claimed amount is $0, record delete old claim line plans before inserting new plans with $0 amounts.
  -- It is necessary so the system understands what plan the claim line was adjudicated to
  -- since the amounts are $0.
  update  clp
  set     RecordDeleted = 'Y',
          DeletedBy = @UserCode,
          DeletedDate = getdate()
  from    #ClaimLines cl
          join ClaimLineCoveragePlans clp on clp.ClaimLineId = cl.ClaimLineId
  where   cl.PaidAmount = 0
          and cl.Status = 'Reallocated'

   
  -- Bring old plans to $0
  insert  into ClaimLineCoveragePlans
          (ClaimLineId,
           CoveragePlanId,
           PaidAmount,
           SentToGL,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  select  cl.ClaimLineId,
          cl.OldCoveragePlanId,
          -cl.PaidAmount,
          'N',
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
  where   cl.Status = 'Reallocated'
    and   cl.PaidAmount > 0

  -- Insert new plans
  insert  into ClaimLineCoveragePlans
          (ClaimLineId,
           CoveragePlanId,
           PaidAmount,
           SentToGL,
           CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate)
  select  cl.ClaimLineId,
          cl.NewCoveragePlanId,
          cl.PaidAmount,
          'N',
          @UserCode,
          getdate(),
          @UserCode,
          getdate()
  from    #ClaimLines cl
  where   cl.PaidAmount >= 0
          and cl.Status = 'Reallocated'


  insert  into ReallocatedClaimLines
          (CreatedBy,
           CreatedDate,
           ModifiedBy,
           ModifiedDate,
           ClaimLineId,
           OrignalPlanId,
           NewPlanId,
           PaidAmount,
           Status)
  select  @UserCode,
          getdate(),
          @UserCode,
          getdate(),
          cl.ClaimLineId as ClaimLineId,
          cl.OldCoveragePlanId,
          cl.NewCoveragePlanId,
          cl.PaidAmount,
          cl.Status
  from    #ClaimLines cl

        
  commit tran

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


  if @@trancount > 0
    rollback tran

  raiserror(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

end catch

go
