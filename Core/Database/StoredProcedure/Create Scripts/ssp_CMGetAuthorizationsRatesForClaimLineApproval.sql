if object_id('dbo.ssp_CMGetAuthorizationsRatesForClaimLineApproval') is not null
  drop procedure dbo.ssp_CMGetAuthorizationsRatesForClaimLineApproval
go

create procedure dbo.ssp_CMGetAuthorizationsRatesForClaimLineApproval
  @ClaimLineId int,
  @ClientId int = null,
  @SiteId int = null,
  @InsurerId int = null,
  @FromDate datetime = null,
  @ToDate datetime = null,
  @BillingCodeId int = null,
  @Units decimal(10, 2) = null,
  @Modifier1 varchar(10) = null,
  @Modifier2 varchar(10) = null,
  @Modifier3 varchar(10) = null,
  @Modifier4 varchar(10) = null,
  @RenderingProviderId int = null,
  @SupervisingProviderId int = null,
  @PlaceOfService int = null,
  @IncludePendedAuthorizations char(1) = 'N'
/*********************************************************************          
-- Stored Procedure: dbo.ssp_CMGetAuthorizationsRatesForClaimLineApproval
-- Copyright: 2008 Streamline Healthcare Solutions
-- Creation Date:  5/07/2008                      
--                                                 
-- Purpose: finds all athorizations and rates that can be used for claim line approval
--                                                                                  
-- Modified Date    Modified By   Purpose
-- 05.07.2008       SFarber       Created.
-- 11.20.2008       SFarber       Modified to use only exact match on modifiers for MH claims when looking for authorizations.
-- 12.15.2008       SFarber       Modified so @UnitsNeeded never exceed @TotalUnitsNeeded
-- 02.12.2009       SFarber       Modified to group exchange codes by billing code
-- 04.28.2009       SFarber       Modified to accept more arguments besides @ClaimLneId
-- 09.08.2011       SFarber       Modified contract rate logic to handle rendering provider
-- 03.12.2012		RNoble		  Modified to limit cursor select to only authorizations applicable to the provider population.
-- 11.12.2014       SFarber       Added support for Partially Approved and Partially Denied authorizations.
-- 01.30.2015       SFarber       Modified to always use ProviderAuthorizations.TotalUnitsApproved instead of UnitsApproved 
-- 21.10.2015       SuryaBalan    Added join with ContractRateSites, since we are not going use SiteId of COntractRates table, as per task #618 N180 Customizations
--                                Before it was Single selection of Sites in Contract Rates Detail Page, now it is multiple selection, 
--                                so whereever we are using ContractRates-SiteId, we need to join with ContractRateSites-SiteId
-- 04.01.2016       SFarber       Modified to use ssv_BillingCodeExchangeCombinations
-- 05.09.2016       SFarber       Defaulted conversion rate to 1 since it is not used anymore.
-- 05.23.2016       SFarber       Modified to search for contract rates based on ContractRateExactMatchOnModifiers config setting.
-- 11.03.2016       Kiran Kumar   Modified to handle Contract Rate Start date is null and Contract rate End Date having a value senario.
-- 11.04.2016       SFarber       Modified to remove redundant combinations from @BillingCodes
-- 03.22.2017       SFarber       Modified logic for billing code exchanges
-- 03.28.2017       SFarber       Modified contract rate logic to support Place Of Service and Licensing Group.
-- 07.03.2017       SFarber       Modified contract rate logic to support licensing group for supervising provider
-- 07.13.2017       SFarber       Modified logic that calculates authorization units used in this process.
-- 07.19.2017       SFarber       Modified contract rate logic to support Coverage Plan.
-- 08.22.2017       SFarber       Modified to look for pended authorizations based on @IncludePendedAuthorizations
-- 01.08.2018       SFarber       Modified to apply RequiresAffilatedProvider logic to suppervising provider
-- 04.16.2018		Ravi		  What: Modified contract rate logic to	support Place Of Service and Licensing Group. 
								  Why:Heartland East - Customizations > Tasks #26 > Contracted Rates: List Page and Details Page Modifications 
-- 05.01.2018       SFarber       Modified license type logic for contract rate.
-- 11.16.2018       SFarber       Modified license type logic for contract rate to use SUPERVISINGPROVIDERRATEBILLINGCODE recode
-- 11.16.2018       SFarber       Removed SA providers specific logic for finding authorizations.
-- 01.24.2019       SFarber       Fixed ContractRatePlaceOfServices issue.
****************************************************************************/
as 
declare @ProviderAuthorizationId int
declare @AuthorizationApproved int
declare @AuthorizationPartiallyApproved int
declare @AuthorizationPartiallyDenied int
declare @AuthorizationPended int
declare @ProviderId int
declare @Day int
declare @Days int
declare @TotalUnitsApproved decimal(10, 2)
declare @UnitsApproved decimal(10, 2)
declare @TotalUnitsNeeded decimal(10, 2)
declare @UnitsPerDay decimal(10, 2)
declare @UnitsNeeded decimal(10, 2)
declare @AuthorizationUnitsUsed decimal(10, 2)
declare @AuthorizationUnitsAvailable decimal(10, 2)
declare @ConversionRate decimal(10, 2)
declare @ContractId int
declare @ContractRateId int
declare @ContractRate money
declare @Ranking int
declare @ContractRateExactMatchOnModifiers char(1) = 'Y'
declare @BillingCodeValidAllPlans char(1)
declare @CoveragePlanId int
declare @BillingCode varchar(20)
declare @AffilatedProviderId int

declare @Authorizations table (
  ProviderAuthorizationId int,
  AuthorizationUnitsUsed decimal(10, 2),
  ClaimLineUnitsApproved decimal(10, 2),
  ClaimLineUnits decimal(10, 2),
  Date datetime)

declare @BillingCodes table (
  BillingCodeId int,
  GroupId int,
  AuthorizationAppliesToAllModifiers char(1),
  AuthorizationModifier1 varchar(20),
  AuthorizationModifier2 varchar(20),
  AuthorizationModifier3 varchar(20),
  AuthorizationModifier4 varchar(20),
  ClaimAppliesToAllModifiers char(1),
  ClaimModifier1 varchar(20),
  ClaimModifier2 varchar(20),
  ClaimModifier3 varchar(20),
  ClaimModifier4 varchar(20)
  )

declare @DayContractRates table (
  ContractId int,
  ContractRateId int,
  ContractRate money,
  Ranking int)

declare @ContractRates table (
  ContractId int,
  ContractRateId int,
  ContractRate money,
  ContractRuleId int,
  Date datetime)

declare @Date table (Date datetime)

declare @LicenseTypes table (LicenseTypeId int) 

select @ContractRateExactMatchOnModifiers = isnull(sck.Value, 'Y')
  from SystemConfigurationKeys sck
 where sck.[Key] = 'ContractRateExactMatchOnModifiers'

if @ClaimLineId is not null 
  begin
    select  @InsurerId = c.InsurerId,
            @ClientId = c.ClientId,
            @FromDate = cl.FromDate,
            @ToDate = cl.ToDate,
            @BillingCodeId = cl.BillingCodeId,
            @Units = cl.Units,
            @SiteId = c.SiteId,
            @ProviderId = s.ProviderId,
            @Modifier1 = cl.Modifier1,
            @Modifier2 = cl.Modifier2,
            @Modifier3 = cl.Modifier3,
            @Modifier4 = cl.Modifier4,
            @RenderingProviderId = isnull(cl.RenderingProviderId, c.RenderingProviderId),
			@SupervisingProviderId  = isnull(cl.SupervisingProviderId, c.SupervisingProviderId),
			@PlaceOfService = cl.PlaceOfService
    from    ClaimLines cl
            join Claims c on c.ClaimId = cl.ClaimId
            join Sites s on s.SiteId = c.SiteId
            join Providers p on p.ProviderId = s.ProviderId
    where   cl.ClaimLineId = @ClaimLineId
  end
else 
  begin
    select  @ProviderId = p.ProviderId
    from    Sites s
            join Providers p on p.ProviderId = s.ProviderId
    where   s.SiteId = @SiteId
  end

 select @BillingCodeValidAllPlans = ValidAllPlans,
        @BillingCode = BillingCode
 from   BillingCodes
 where  BillingCodeId = @BillingCodeId  


select  @UnitsPerDay = ceiling(@Units / (datediff(dd, @FromDate, @ToDate) + 1)),
        @TotalUnitsApproved = 0,
        @TotalUnitsNeeded = @Units,
        @Day = 1,
        @Days = datediff(dd, @FromDate, @ToDate) + 1,
        @AuthorizationApproved = 2042,
		@AuthorizationPartiallyApproved = 2048,
        @AuthorizationPartiallyDenied = 2049,
		@AuthorizationPended = 2045,
        @Modifier1 = isnull(@Modifier1, ''),
        @Modifier2 = isnull(@Modifier2, ''),
        @Modifier3 = isnull(@Modifier3, ''),
        @Modifier4 = isnull(@Modifier4, '')


insert  into @BillingCodes
        (BillingCodeId,
         GroupId,
         AuthorizationAppliesToAllModifiers,
         AuthorizationModifier1,
         AuthorizationModifier2,
         AuthorizationModifier3,
         AuthorizationModifier4,
         ClaimAppliesToAllModifiers,
         ClaimModifier1,
         ClaimModifier2,
         ClaimModifier3,
         ClaimModifier4)
        select  @BillingCodeId,
                1,
                'N',
                @Modifier1,
                @Modifier2,
                @Modifier3,
                @Modifier4,
                'N',
                @Modifier1,
                @Modifier2,
                @Modifier3,
                @Modifier4
        union
        select  e.AuthorizationBillingCodeId,
                2,
                isnull(e.AuthorizationAppliesToAllModifiers, 'N'),
                isnull(e.AuthorizationModifier1, ''),
                isnull(e.AuthorizationModifier2, ''),
                isnull(e.AuthorizationModifier3, ''),
                isnull(e.AuthorizationModifier4, ''),
                isnull(e.ClaimAppliesToAllModifiers, 'N'),
                isnull(e.ClaimModifier1, ''),
                isnull(e.ClaimModifier2, ''),
                isnull(e.ClaimModifier3, ''),
                isnull(e.ClaimModifier4, '')
        from    ssv_BillingCodeExchangeCombinations e
        where   e.ClaimBillingCodeId = @BillingCodeId
                and (e.InsurerId is null
                     or e.InsurerId = @InsurerId)
                and (e.ProviderId is null
                     or e.ProviderId = @ProviderId)
                and (e.SiteId is null
                     or e.SiteId = @SiteId)
                and (e.ClaimAppliesToAllModifiers = 'Y'
                     or (isnull(e.ClaimAppliesToAllModifiers, 'N') = 'N'
                         and isnull(e.ClaimModifier1, '') = @Modifier1
                         and isnull(e.ClaimModifier2, '') = @Modifier2
                         and isnull(e.ClaimModifier3, '') = @Modifier3
                         and isnull(e.ClaimModifier4, '') = @Modifier4))

delete  bc
from    @BillingCodes bc
where   (bc.AuthorizationAppliesToAllModifiers = 'N'
         or bc.ClaimAppliesToAllModifiers = 'N')
        and exists ( select *
                     from   @BillingCodes bc2
                     where  bc2.BillingCodeId = bc.BillingCodeId
                            and bc2.AuthorizationAppliesToAllModifiers = 'Y'
                            and bc2.ClaimAppliesToAllModifiers = 'Y' )

declare Authorizations_Cursor cursor
for
select  a.ProviderAuthorizationId,
        a.AuthorizationUnitsAvailable,
        1 as ConversionRate,
        a.Ranking
from    (select pa.ProviderAuthorizationId,
                case when pa.Status = @AuthorizationPended then isnull(pa.TotalUnitsApproved, pa.TotalUnitsRequested)
                          else pa.TotalUnitsApproved
                     end - isnull(pa.UnitsUsed, 0)  as AuthorizationUnitsAvailable,
                row_number() over (order by 
				       case when pa.Status = @AuthorizationPended then 2 else 1 end asc,
					   case when pa.SiteId = @SiteId then 1 else 2 end asc,
	                   case when nullif(pa.Modifier1, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end +
	                   case when nullif(pa.Modifier2, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end +
	                   case when nullif(pa.Modifier3, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end +
	                   case when nullif(pa.Modifier4, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end Desc,
                       case nullif(@Modifier1, '') when pa.Modifier1 then 1 when pa.Modifier2 then 2 when pa.Modifier3 then 3 when pa.Modifier4 then 4 else 5 end asc,
                       case nullif(@Modifier2, '') when pa.Modifier1 then 1 when pa.Modifier2 then 2 when pa.Modifier3 then 3 when pa.Modifier4 then 4 else 5 end asc,
                       case nullif(@Modifier3, '') when pa.Modifier1 then 1 when pa.Modifier2 then 2 when pa.Modifier3 then 3 when pa.Modifier4 then 4 else 5 end asc,
                       case nullif(@Modifier4, '') when pa.Modifier1 then 1 when pa.Modifier2 then 2 when pa.Modifier3 then 3 when pa.Modifier4 then 4 else 5 end asc,
					   case when isnull(pa.Modifier1, '') = '' and isnull(pa.Modifier2, '') = '' and isnull(pa.Modifier3, '') = '' and isnull(pa.Modifier4, '') = '' then 1 else 2 end asc, 
					   bc.GroupId asc,
					   pa.ProviderAuthorizationId asc) as Ranking
         from   ProviderAuthorizations pa
                join @BillingCodes bc on bc.BillingCodeId = pa.BillingCodeId
                cross join @Date d
         where  (pa.Status in (@AuthorizationApproved, @AuthorizationPartiallyApproved, @AuthorizationPartiallyDenied)
                 or (@IncludePendedAuthorizations = 'Y'
                     and pa.Status = @AuthorizationPended))
                and pa.ClientId = @ClientId
                and pa.ProviderId = @ProviderId
                and pa.InsurerId = @InsurerId
                and case when pa.Status = @AuthorizationPended then isnull(pa.StartDate, pa.StartDateRequested)
                         else pa.StartDate
                    end <= d.Date
                and case when pa.Status = @AuthorizationPended then isnull(pa.EndDate, pa.EndDateRequested)
                         else pa.EndDate
                    end >= d.Date
                and (pa.SiteId = @SiteId
                     or pa.SiteId is null)
                and isnull(pa.RecordDeleted, 'N') = 'N'
                and pa.Active = 'Y'
                and (case when pa.Status = @AuthorizationPended then isnull(pa.TotalUnitsApproved, pa.TotalUnitsRequested)
                          else pa.TotalUnitsApproved
                     end - isnull(pa.UnitsUsed, 0) > 0)
                and ((bc.AuthorizationAppliesToAllModifiers = 'Y'
                           or (isnull(pa.Modifier1, '') = bc.AuthorizationModifier1
                               and isnull(pa.Modifier2, '') = bc.AuthorizationModifier2
                               and isnull(pa.Modifier3, '') = bc.AuthorizationModifier3
                               and isnull(pa.Modifier4, '') = bc.AuthorizationModifier4))
                      and (bc.ClaimAppliesToAllModifiers = 'Y'
                           or (bc.ClaimModifier1 = @Modifier1
                               and bc.ClaimModifier2 = @Modifier2
                               and bc.ClaimModifier3 = @Modifier3
                               and bc.ClaimModifier4 = @Modifier4)))
                     ) as a
order by a.Ranking
  
insert  into @Date
        (Date)
values  (null)

while @Day <= @Days
  and @TotalUnitsNeeded > 0
  and @TotalUnitsApproved < @Units 
  begin
    update  @Date
    set     Date = dateadd(dd, @Day - 1, @FromDate)

    --
    -- Find authorizations
    --

    set @UnitsNeeded = @UnitsPerDay

    if @UnitsNeeded > @TotalUnitsNeeded 
      set @UnitsNeeded = @TotalUnitsNeeded

    open Authorizations_Cursor
    fetch from Authorizations_Cursor into @ProviderAuthorizationId, @AuthorizationUnitsAvailable, @ConversionRate, @Ranking

    while @@fetch_status = 0
      and @UnitsNeeded > 0
      begin

        -- Adjust units available by units already used in this process
        set @AuthorizationUnitsAvailable = @AuthorizationUnitsAvailable - isnull((select sum(AuthorizationUnitsUsed) from @Authorizations where ProviderAuthorizationId = @ProviderAuthorizationId), 0)
        
        if @AuthorizationUnitsAvailable <= 0
           goto next_auth

        set @AuthorizationUnitsUsed = case when @AuthorizationUnitsAvailable > (@UnitsNeeded * @ConversionRate) then (@UnitsNeeded * @ConversionRate)
                                           else @AuthorizationUnitsAvailable
                                      end

        set @UnitsApproved = @AuthorizationUnitsUsed / @ConversionRate

        insert  into @Authorizations
                (ProviderAuthorizationId,
                 AuthorizationUnitsUsed,
                 ClaimLineUnitsApproved,
                 ClaimLineUnits,
                 Date)
                select  @ProviderAuthorizationId,
                        @AuthorizationUnitsUsed,
                        @UnitsApproved,
                        @UnitsApproved,
                        Date
                from    @Date

        set @UnitsNeeded = @UnitsNeeded - @UnitsApproved
        set @TotalUnitsApproved = @TotalUnitsApproved + @UnitsApproved

		next_auth:
    
        fetch from Authorizations_Cursor into @ProviderAuthorizationId, @AuthorizationUnitsAvailable, @ConversionRate, @Ranking
      end

    close Authorizations_Cursor

    if @UnitsNeeded > 0 
      insert  into @Authorizations
              (ProviderAuthorizationId,
               AuthorizationUnitsUsed,
               ClaimLineUnitsApproved,
               ClaimLineUnits,
               Date)
              select  null,
                      null,
                      null,
                      @UnitsNeeded,
                      Date
              from    @Date


    set @TotalUnitsNeeded = @TotalUnitsNeeded - @UnitsPerDay


    --
    -- Find contract rates
    --

    delete  from @DayContractRates 
    delete  from @LicenseTypes

    select  @ContractId = null,
            @ContractRateId = null,
            @ContractRate = null,
            @CoveragePlanId = null

    -- Determine if supervising provider should be used for finding a rate
    if (not exists ( select *
                     from   dbo.ssf_RecodeValuesAsOfDate('SUPERVISINGPROVIDERRATEBILLINGCODE', @FromDate) ) -- always if no billing code specified
        or exists ( select  *
                    from    dbo.ssf_RecodeValuesAsOfDate('SUPERVISINGPROVIDERRATEBILLINGCODE', @FromDate)
                    where   CharacterCodeId = @BillingCode ) -- only for certain billing codes
        or exists ( select  *
                    from    BillingCodes bc
                            join dbo.BillingCodeAddOnCodes bcaoc on bcaoc.BillingCodeId = bc.BillingCodeId
                            join dbo.ssf_RecodeValuesAsOfDate('SUPERVISINGPROVIDERRATEBILLINGCODE', @FromDate) rc on rc.CharacterCodeId = bc.BillingCode
                    where   isnull(bc.AddOnCodeGroupName, '') <> ''
                            and bcaoc.AddOnBillingCodeId = @BillingCodeId
                            and isnull(bc.RecordDeleted, 'N') = 'N'
                            and isnull(bcaoc.RecordDeleted, 'N') = 'N' )) -- only for certain billing codes and their associated add-on codes
      set @AffilatedProviderId = @SupervisingProviderId

    -- Always use rendering if supervising provider is not specified or should not be used
    if @AffilatedProviderId is null
	  set @AffilatedProviderId = @RenderingProviderId

    insert  into @LicenseTypes
            (LicenseTypeId)
    select  cl.LicenseType
    from    Credentialing c
            join dbo.CredentialingLicense cl on cl.CredentialingId = c.CredentialingId
            cross join @Date d
    where   c.ProviderId = @AffilatedProviderId
            and (c.PerformedBy = @InsurerId
                 or c.Share = 'Y')
            and c.Status = 2642 -- Completed
            and (cl.LicenseExpirationDate >= d.Date
                 or cl.LicenseExpirationDate is null)
            and (c.EffectiveFrom <= d.Date
                 or c.EffectiveFrom is null)
            and (c.ExpirationDate >= d.Date
                 or c.ExpirationDate is null)
            and isnull(c.RecordDeleted, 'N') = 'N'
            and isnull(cl.RecordDeleted, 'N') = 'N';

    with CTE_CoveragePlan
          as (select  cp.CoveragePlanId,
                      row_number() over (order by cch.COBOrder) as COBOrder
              from    ClientCoveragePlans ccp
                      join dbo.ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                      join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                      join dbo.Insurers i on i.ServiceAreaId = cch.ServiceAreaId
                      left join (select bcvcp.CoveragePlanId
                                 from   BillingCodeValidCoveragePlans bcvcp
                                 where  bcvcp.BillingCodeId = @BillingCodeId
                                        and isnull(bcvcp.RecordDeleted, 'N') = 'N') as bp on bp.CoveragePlanId = cp.CoveragePlanId
                      cross join @Date d
              where   ccp.ClientId = @ClientId
                      and i.InsurerId = @InsurerId
                      and isnull(cp.ThirdPartyPlan, 'N') = 'N'
                      and cch.StartDate <= d.Date
                      and (cch.EndDate >= d.Date
                           or cch.EndDate is null)
                      and (i.ValidAllCoveragePlans = 'Y'
                           or exists ( select *
                                       from   InsurerValidCoveragePlans ivcp
                                       where  ivcp.InsurerId = i.InsurerId
                                              and ivcp.CoveragePlanId = cp.CoveragePlanId
                                              and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
                      and (@BillingCodeValidAllPlans = 'Y'
                           or bp.CoveragePlanId is not null)
                      and isnull(cch.RecordDeleted, 'N') = 'N'
                      and isnull(ccp.RecordDeleted, 'N') = 'N'
                      and isnull(i.RecordDeleted, 'N') = 'N')
    select  @CoveragePlanId = cp.CoveragePlanId
    from    CTE_CoveragePlan cp
    where   cp.COBOrder = 1

    insert  into @DayContractRates
            (ContractId,
             ContractRateId,
             ContractRate,
             Ranking)
    select  c.ContractId,
            cr.ContractRateId,
            cr.ContractRate,
            row_number() over (order by
                           case when cr.RequiresAffilatedProvider = 'Y' then 1 else 2 end asc,             
						   case when cr.ClientId is not null then 100000 else 0 end +
						   case when crs.SiteId is not null then 10000 else 0 end +
						   case when cr.PlaceOfServiceGroupName is not null  then 1000 else 0 end + 
						   case when cr.LicenseTypeGroupName is not null then 100 else 0 end +
						   case when cr.CoveragePlanGroupName is not null then 10 else 0 end desc,
	                       case when nullif(cr.Modifier1, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end +
	                       case when nullif(cr.Modifier2, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end +
	                       case when nullif(cr.Modifier3, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end +
	                       case when nullif(cr.Modifier4, '') in (@Modifier1, @Modifier2, @Modifier3, @Modifier4) then 1 else 0 end desc,
                           case nullif(@Modifier1, '') when cr.Modifier1 then 1 when cr.Modifier2 then 2 when cr.Modifier3 then 3 when cr.Modifier4 then 4 else 5 end asc,
                           case nullif(@Modifier2, '') when cr.Modifier1 then 1 when cr.Modifier2 then 2 when cr.Modifier3 then 3 when cr.Modifier4 then 4 else 5 end asc,
                           case nullif(@Modifier3, '') when cr.Modifier1 then 1 when cr.Modifier2 then 2 when cr.Modifier3 then 3 when cr.Modifier4 then 4 else 5 end asc,
                           case nullif(@Modifier4, '') when cr.Modifier1 then 1 when cr.Modifier2 then 2 when cr.Modifier3 then 3 when cr.Modifier4 then 4 else 5 end asc,
	   					   case when isnull(cr.Modifier1, '') = '' and isnull(cr.Modifier2, '') = '' and isnull(cr.Modifier3, '') = '' and isnull(cr.Modifier4, '') = '' then 1 else 2 end asc, 
						   cr.ContractRate asc,
						   cr.ContractRateId desc) as Ranking
    from    Contracts c
            join ContractRates cr on cr.ContractId = c.ContractId
            left join ContractRateSites crs on crs.ContractRateId = cr.ContractRateId
                                               and isnull(crs.RecordDeleted, 'N') = 'N'
            cross join @Date d
    where   c.ProviderId = @ProviderId
            and c.InsurerId = @InsurerId
            and c.Status = 'A'
            and c.StartDate <= d.Date
            and c.EndDate >= d.Date
            and cr.BillingCodeId = @BillingCodeId
            and (isnull(cr.RequiresAffilatedProvider, 'N') = 'N'
                 or (cr.RequiresAffilatedProvider = 'Y'
                     and @AffilatedProviderId is not null
                     and (cr.AllAffiliatedProviders = 'Y'
                          or exists ( select  *
                                      from    ContractRateAffiliates cra
                                      where   cra.ContractRateId = cr.ContractRateId
                                              and cra.ProviderId = @AffilatedProviderId
                                              and isnull(cra.RecordDeleted, 'N') = 'N' ))))
            and (crs.SiteId = @SiteId
                 or crs.SiteId is null)
            and (cr.ClientId = @ClientId
                 or cr.ClientId is null)
            and (cr.PlaceOfServiceGroupName is null
                 or exists ( select *
                             from   ContractRatePlaceOfServices crps
                             where  crps.ContractRateId = cr.ContractRateId
                                    and crps.PlaceOfServiceId = @PlaceOfService
                                    and isnull(crps.RecordDeleted, 'N') = 'N' ))
            and (cr.LicenseTypeGroupName is null
                 or exists ( select *
                             from   ContractRateLicenseTypes crlt
							        join @LicenseTypes lt on lt.LicenseTypeId = crlt.LicenseTypeId
                             where  crlt.ContractRateId = cr.ContractRateId
                                    and isnull(crlt.RecordDeleted, 'N') = 'N' ))
            and (cr.CoveragePlanGroupName is null
			     or exists ( select *
				             from   ContractRateCoveragePlans crcp
							 where  crcp.ContractRateId = cr.ContractRateId
							        and crcp.CoveragePlanId = @CoveragePlanId
									and isnull(crcp.RecordDeleted, 'N') = 'N'))
            and ((cr.StartDate <= d.Date
                  or cr.StartDate is null)
                 and (cr.EndDate >= d.Date
                      or cr.EndDate is null))
            and ((@ContractRateExactMatchOnModifiers = 'N'
                  and (nullif(cr.Modifier1, '') is null
                       or cr.Modifier1 in (@Modifier1, @Modifier2, @Modifier3, @Modifier4))
                  and (nullif(cr.Modifier2, '') is null
                       or cr.Modifier2 in (@Modifier1, @Modifier2, @Modifier3, @Modifier4))
                  and (nullif(cr.Modifier3, '') is null
                       or cr.Modifier3 in (@Modifier1, @Modifier2, @Modifier3, @Modifier4))
                  and (nullif(cr.Modifier4, '') is null
                       or cr.Modifier4 in (@Modifier1, @Modifier2, @Modifier3, @Modifier4)))
                 or (@ContractRateExactMatchOnModifiers = 'Y'
                     and (isnull(cr.Modifier1, '') = @Modifier1
                          and isnull(cr.Modifier2, '') = @Modifier2
                          and isnull(cr.Modifier3, '') = @Modifier3
                          and isnull(cr.Modifier4, '') = @Modifier4))
                 or (isnull(cr.Modifier1, '') = ''
                     and isnull(cr.Modifier2, '') = ''
                     and isnull(cr.Modifier3, '') = ''
                     and isnull(cr.Modifier4, '') = ''))
            and isnull(c.RecordDeleted, 'N') = 'N'
            and isnull(cr.RecordDeleted, 'N') = 'N'


    if @@rowcount = 0 
      begin
        -- Check if there is at least a contract
        select  @ContractId = ContractId
        from    Contracts c
                cross join @Date d
        where   c.ProviderId = @ProviderId
                and c.InsurerId = @InsurerId
                and c.Status = 'A'
                and c.StartDate <= d.Date
                and c.EndDate >= d.Date
                and isnull(c.RecordDeleted, 'N') = 'N'
      end
    else 
      begin
        select top 1
                @ContractId = ContractId,
                @ContractRateId = ContractRateId,
                @ContractRate = ContractRate
        from    @DayContractRates dcr
        where   dcr.Ranking = 1
      end

    insert  into @ContractRates
            (ContractId,
             ContractRateId,
             ContractRate,
             Date)
            select  @ContractId,
                    @ContractRateId,
                    @ContractRate,
                    Date
            from    @Date

    set @Day = @Day + 1

  end 

deallocate Authorizations_Cursor

-- Get contract rule IDs
update  cr
set     ContractRuleId = cru.ContractRuleId
from    @ContractRates cr
        join ContractRules cru on cru.ContractId = cr.ContractId
where   cru.BillingCodeId = @BillingCodeId
        and isnull(cru.RecordDeleted, 'N') = 'N'


-- Final result set
select  a.Date,
        a.ProviderAuthorizationId,
        a.AuthorizationUnitsUsed,
        a.ClaimLineUnitsApproved,
        a.ClaimLineUnits,
        cr.ContractId,
        cr.ContractRateId,
        cr.ContractRate,
        cr.ContractRuleId
from    @Authorizations a
        join @ContractRates cr on cr.Date = a.Date
order by a.Date

go
