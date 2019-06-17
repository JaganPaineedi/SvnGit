if object_id('dbo.ssf_CMClaimLineBundles') is not null
  drop function dbo.ssf_CMClaimLineBundles
go

create function dbo.ssf_CMClaimLineBundles (@ClaimLineId int,
                                            @ClaimType varchar(10))
returns @ClaimLineBundles table (ActivityClaimLineId int,
                                 ClaimBundleId int,
                                 ClaimType varchar(10),
                                 BundleClaimLineId int,
                                 IsValid varchar(10),
                                 InvalidReason varchar(100)) 
/********************************************************************************  
-- Function: dbo.ssf_CMClaimLineBundles
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: returns activity and claim line bundles.
--  
--	Updates:                                                         
--	Date        Author    Purpose  
--  01.30.2019  SFarber   Converted from ssv_ClaimLineBundles
*********************************************************************************/
as
begin

  declare @ClientId int
  declare @InsurerId int
  declare @SiteId int
  declare @ProviderId int
  declare @FromDate date
  declare @ToDate date
  declare @BillingCodeId int
  declare @Modifier1 varchar(10)
  declare @Modifier2 varchar(10)
  declare @Modifier3 varchar(10)
  declare @Modifier4 varchar(10)
  declare @BillingCodeModifierId int 



  declare @ClaimBundles table (ClaimBundleId int,
                               InsurerId int,
                               StartDate date,
                               EndDate date,
                               Period int,
                               AllBillingCodes char(1),
                               AllBillingCodesMinimumUnitsPerPeriod decimal(18, 2),
                               ClaimBundleBillingCodeGroupId int,
                               BillingCodeGroupName varchar(250),
                               MinimumUnitsPerPeriod decimal(18, 2),
                               AllClients char(1),
                               ProviderSiteGroupName varchar(250),
                               BundleProviderId int,
                               BundleSiteId int,
                               BundleBillingCodeId int,
                               BundleModifier1 varchar(10),
                               BundleModifier2 varchar(10),
                               BundleModifier3 varchar(10),
                               BundleModifier4 varchar(10),
                               BundleClientId int,
                               BundleSubmissionFrequency int)

  declare @ActivityClaimLineDetails table (ClaimBundleId int,
                                           BundleClientId int,
                                           ClaimLineId int,
                                           ClaimType varchar(10),
                                           ClaimBundleBillingCodeGroupId int,
                                           FromDate date,
                                           Units decimal(18, 2),
                                           Period int,
                                           PeriodWeek int,
                                           PeriodMonth int,
                                           PeriodQuarter int,
                                           PeriodYear int)


  declare @BundleClaimLines table (BundleClaimLineId int identity
                                                         not null,
                                   ClaimBundleId int,
                                   BundleClientId int,
                                   ClaimLineId int,
                                   ClaimType varchar(10),
                                   FromDate date,
                                   Units decimal(18, 2),
                                   Period int,
                                   PeriodWeek int,
                                   PeriodMonth int,
                                   PeriodQuarter int,
                                   PeriodYear int,
                                   Ranking int,
                                   SubmissionFrequency int)

  declare @ActivityClaimLines table (ActivityClaimLineId int,
                                     ClaimBundleId int,
                                     ClaimType varchar(10),
                                     BundleClientId int,
                                     BundleClaimLineId int,
                                     ClaimBundleBillingCodeGroupId int,
                                     Units decimal(18, 2),
                                     IsValid varchar(10),
                                     InvalidReason varchar(100))

  select  @ClientId = c.ClientId,
          @InsurerId = c.InsurerId,
          @SiteId = s.SiteId,
          @ProviderId = s.ProviderId,
          @FromDate = cl.FromDate,
          @ToDate = cl.ToDate,
          @BillingCodeId = cl.BillingCodeId,
          @Modifier1 = isnull(cl.Modifier1, ''),
          @Modifier2 = isnull(cl.Modifier2, ''),
          @Modifier3 = isnull(cl.Modifier3, ''),
          @Modifier4 = isnull(cl.Modifier4, '')
  from    ClaimLines cl
          join Claims c on c.ClaimId = cl.ClaimId
          join Sites s on s.SiteId = c.SiteId
  where   cl.ClaimLineId = @ClaimLineId


  select top 1
          @BillingCodeModifierId = bcm.BillingCodeModifierId
  from    BillingCodeModifiers bcm
  where   bcm.BillingCodeId = @BillingCodeId
          and isnull(bcm.Modifier1, '') = @Modifier1
          and isnull(bcm.Modifier2, '') = @Modifier2
          and isnull(bcm.Modifier3, '') = @Modifier3
          and isnull(bcm.Modifier4, '') = @Modifier4
          and isnull(bcm.RecordDeleted, 'N') = 'N'


  insert  into @ClaimBundles
          (ClaimBundleId,
           InsurerId,
           StartDate,
           EndDate,
           Period,
           AllBillingCodes,
           AllBillingCodesMinimumUnitsPerPeriod,
           ClaimBundleBillingCodeGroupId,
           BillingCodeGroupName,
           MinimumUnitsPerPeriod,
           AllClients,
           ProviderSiteGroupName,
           BundleProviderId,
           BundleSiteId,
           BundleBillingCodeId,
           BundleModifier1,
           BundleModifier2,
           BundleModifier3,
           BundleModifier4,
           BundleClientId,
           BundleSubmissionFrequency)
  select  cb.ClaimBundleId,
          max(cb.InsurerId) as InsurerId,
          max(cb.StartDate) as StartDate,
          max(cb.EndDate) as EndDate,
          max(cb.Period) as Period,
          max(cb.AllBillingCodes) as AllBillingCodes,
          max(cb.AllBillingCodesMinimumUnitsPerPeriod) as AllBillingCodesMinimumUnitsPerPeriod,
          case when cb.AllBillingCodes = 'Y' then -1
               else cbbcg.ClaimBundleBillingCodeGroupId
          end as ClaimBundleBillingCodeGroupId,
          max(cbbcg.BillingCodeGroupName) as BillingCodeGroupName,
          max(cbbcg.MinimumUnitsPerPeriod) as MinimumUnitsPerPeriod,
          max(cb.AllClients) as AllClients,
          max(cb.ProviderSiteGroupName) as ProviderSiteGroupName,
          max(cb.ProviderId) as BundleProviderId,
          max(cb.ProviderSiteId) as BundleSiteId,
          max(cb.BillingCodeId) as BundleBillingCodeId,
          max(cb.Modifier1) as BundleModifier1,
          max(cb.Modifier2) as BundleModifier2,
          max(cb.Modifier3) as BundleModifier3,
          max(cb.Modifier4) as BundleModifier4,
          case when cb.ClientSameAsAbove = 'Y' then case when cb.AllClients = 'Y' then -1
                                                         else cbc.ClientId
                                                    end
               else cb.ClientId
          end as BundleClientId,
          max(cb.SubmissionFrequency) as BundleSubmissionFrequency
  from    ClaimBundles cb
          left join ClaimBundleClients cbc on cbc.ClaimBundleId = cb.ClaimBundleId
                                              and isnull(cb.AllClients, 'N') = 'N'
                                              and isnull(cbc.RecordDeleted, 'N') = 'N'
          left join ClaimBundleBillingCodeGroups cbbcg on cbbcg.ClaimBundleId = cb.ClaimBundleId
                                                          and isnull(cb.AllBillingCodes, 'N') = 'N'
                                                          and isnull(cbbcg.RecordDeleted, 'N') = 'N'
          left join ClaimBundleBillingCodeGroupBillingCodes cbbcgbc on cbbcgbc.ClaimBundleBillingCodeGroupId = cbbcg.ClaimBundleBillingCodeGroupId
                                                                       and isnull(cbbcgbc.RecordDeleted, 'N') = 'N'
          left join BillingCodeModifiers bcbcm on bcbcm.BillingCodeModifierId = cbbcgbc.BillingCodeModifierId
  where   cb.Active = 'Y'
          and isnull(cb.RecordDeleted, 'N') = 'N'
          and cb.InsurerId = @InsurerId
          and (cb.StartDate <= @FromDate
               or cb.StartDate is null)
          and (cb.EndDate >= @FromDate
               or cb.EndDate is null)
          and ((@ClaimType = 'Activity'
                and (cb.AllClients = 'Y'
                     or cbc.ClientId = @ClientId)
                and (cb.AllBillingCodes = 'Y'
                     or ((cbbcgbc.ApplyToAllModifiers = 'Y'
                          and bcbcm.BillingCodeId = @BillingCodeId)
                         or cbbcgbc.BillingCodeModifierId = @BillingCodeModifierId))
                and (cb.ProviderSiteGroupName is null
                     or (cb.ProviderSiteGroupName is not null
                         and exists ( select  *
                                      from    ClaimBundleSites cbs
                                      where   cbs.ClaimBundleId = cb.ClaimBundleId
                                              and isnull(cbs.RecordDeleted, 'N') = 'N'
                                              and (cbs.ProviderId = @ProviderId
                                                   or cbs.SiteId = @SiteId) ))))
               or (@ClaimType = 'Bundle'
                   and cb.ProviderSiteId = @SiteId
                   and cb.BillingCodeId = @BillingCodeId
                   and isnull(cb.Modifier1, '') = @Modifier1
                   and isnull(cb.Modifier2, '') = @Modifier2
                   and isnull(cb.Modifier3, '') = @Modifier3
                   and isnull(cb.Modifier4, '') = @Modifier4
                   and ((cb.ClientSameAsAbove = 'Y'
                         and (cb.AllClients = 'Y'
                              or cbc.ClientId = @ClientId))
                        or cb.ClientId = @ClientId)))
  group by cb.ClaimBundleId,
          case when cb.ClientSameAsAbove = 'Y' then case when cb.AllClients = 'Y' then -1
                                                         else cbc.ClientId
                                                    end
               else cb.ClientId
          end,
          case when cb.AllBillingCodes = 'Y' then -1
               else cbbcg.ClaimBundleBillingCodeGroupId
          end


  insert  into @ActivityClaimLineDetails
          (ClaimBundleId,
           BundleClientId,
           ClaimLineId,
           ClaimType,
           ClaimBundleBillingCodeGroupId,
           FromDate,
           Units,
           Period,
           PeriodWeek,
           PeriodMonth,
           PeriodQuarter,
           PeriodYear)
  select  cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end as BundleClientId,
          cl.ClaimLineId,
          'Activity' as ClaimType,
          max(cb.ClaimBundleBillingCodeGroupId) as ClaimBundleBillingCodeGroupId,
          max(cl.FromDate) as FromDate,
          max(cl.Units) as Units,
          max(cb.Period) as Period,
          datepart(week, max(cl.FromDate)) as PeriodWeek,
          datepart(month, max(cl.FromDate)) as PeriodMonth,
          datepart(quarter, max(cl.FromDate)) as PeriodQuarter,
          datepart(year, max(cl.FromDate)) as PeriodYear
  from    OpenClaims oc
          join ClaimLines cl with (index (ClaimLines_PK)) on cl.ClaimLineId = oc.ClaimLineId
          join Claims c on c.ClaimId = cl.ClaimId
          join Sites s on s.SiteId = c.SiteId
          join BillingCodes bc on bc.BillingCodeId = cl.BillingCodeId
          left join BillingCodeModifiers bcm on bcm.BillingCodeId = bc.BillingCodeId
                                                and isnull(bcm.Modifier1, '') = isnull(cl.Modifier1, '')
                                                and isnull(bcm.Modifier2, '') = isnull(cl.Modifier2, '')
                                                and isnull(bcm.Modifier3, '') = isnull(cl.Modifier3, '')
                                                and isnull(bcm.Modifier4, '') = isnull(cl.Modifier4, '')
                                                and isnull(bcm.RecordDeleted, 'N') = 'N'
          join Clients ct on ct.ClientId = c.ClientId
                             and ct.ClientType = 'I' -- limit activity claim lines to individual clients only
          join @ClaimBundles cb on cb.InsurerId = c.InsurerId
  where   (cl.Status = 2022
		  -- 2550 - Bundle claim line does not have the correct associated claim lines to bill
		  -- 2549 - Activity claim line cannot be adjudicated without an associated bundle claim line
           or (cl.Status in (2024, 2027)
               and exists ( select  *
                            from    AdjudicationDenialPendedReasons ar
                            where   ar.AdjudicationId = cl.LastAdjudicationId
                                    and (ar.DenialReason in (2549, 2550)
                                         or ar.PendedReason in (2549, 2550)) )))
          and isnull(c.RecordDeleted, 'N') = 'N'
          and isnull(cl.RecordDeleted, 'N') = 'N'
          and case cb.Period
                when 9361 then 'Daily' + convert(char(10), cl.FromDate, 112)
                when 9362 then 'Weekly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(week, cl.FromDate)), 2)
                when 9363 then 'Monthly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(month, cl.FromDate)), 2)
                when 9364 then 'Quarterly' + convert(char(4), datepart(year, cl.FromDate)) + convert(char(1), datepart(quarter, cl.FromDate))
                when 9365 then 'Yearly' + convert(char(4), datepart(year, cl.FromDate))
              end = case cb.Period
                      when 9361 then 'Daily' + convert(char(10), @FromDate, 112)
                      when 9362 then 'Weekly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(week, @FromDate)), 2)
                      when 9363 then 'Monthly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(month, @FromDate)), 2)
                      when 9364 then 'Quarterly' + convert(char(4), datepart(year, @FromDate)) + convert(char(1), datepart(quarter, @FromDate))
                      when 9365 then 'Yearly' + convert(char(4), datepart(year, @FromDate))
                    end
          and (cb.AllClients = 'Y'
               or exists ( select *
                           from   ClaimBundleClients cbc
                           where  cbc.ClaimBundleId = cb.ClaimBundleId
                                  and cbc.ClientId = c.ClientId
                                  and isnull(cbc.RecordDeleted, 'N') = 'N' ))
          and (cb.AllBillingCodes = 'Y'
               or exists ( select *
                           from   ClaimBundleBillingCodeGroupBillingCodes cbbcgbc
                                  join dbo.BillingCodeModifiers cbbcgbcm on cbbcgbcm.BillingCodeModifierId = cbbcgbc.BillingCodeModifierId
                           where  cbbcgbc.ClaimBundleBillingCodeGroupId = cb.ClaimBundleBillingCodeGroupId
                                  and isnull(cbbcgbc.RecordDeleted, 'N') = 'N'
                                  and ((cbbcgbc.ApplyToAllModifiers = 'Y'
                                        and cbbcgbcm.BillingCodeId = cl.BillingCodeId)
                                       or cbbcgbc.BillingCodeModifierId = bcm.BillingCodeModifierId) ))
          and (cb.ProviderSiteGroupName is null
               or (cb.ProviderSiteGroupName is not null
                   and exists ( select  *
                                from    ClaimBundleSites cbs
                                where   cbs.ClaimBundleId = cb.ClaimBundleId
                                        and isnull(cbs.RecordDeleted, 'N') = 'N'
                                        and (cbs.ProviderId = s.ProviderId
                                             or cbs.SiteId = c.SiteId) )))
  group by cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end,
          cl.ClaimLineId
  union all
  select  cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end as BundleClientId,
          cl.ClaimLineId,
          'Activity' as ClaimType,
          max(cb.ClaimBundleBillingCodeGroupId) as ClaimBundleBillingCodeGroupId,
          max(cl.FromDate) as FromDate,
          max(cl.Units) as Units,
          max(cb.Period) as Period,
          datepart(week, max(cl.FromDate)) as PeriodWeek,
          datepart(month, max(cl.FromDate)) as PeriodMonth,
          datepart(quarter, max(cl.FromDate)) as PeriodQuarter,
          datepart(year, max(cl.FromDate)) as PeriodYear
  from    @ClaimBundles cb
          join Adjudications a on a.ClaimBundleId = cb.ClaimBundleId
                                  and a.BundleClaimType = 'A'
          join ClaimLines cl on cl.ClaimLineId = a.ClaimLineId
                                and cl.LastAdjudicationId = a.AdjudicationId
          join Claims c on c.ClaimId = cl.ClaimId
  where   cl.Status in (2023, 2025, 2026)
          and isnull(c.RecordDeleted, 'N') = 'N'
          and isnull(cl.RecordDeleted, 'N') = 'N'
          and case cb.Period
                when 9361 then 'Daily' + convert(char(10), cl.FromDate, 112)
                when 9362 then 'Weekly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(week, cl.FromDate)), 2)
                when 9363 then 'Monthly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(month, cl.FromDate)), 2)
                when 9364 then 'Quarterly' + convert(char(4), datepart(year, cl.FromDate)) + convert(char(1), datepart(quarter, cl.FromDate))
                when 9365 then 'Yearly' + convert(char(4), datepart(year, cl.FromDate))
              end = case cb.Period
                      when 9361 then 'Daily' + convert(char(10), @FromDate, 112)
                      when 9362 then 'Weekly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(week, @FromDate)), 2)
                      when 9363 then 'Monthly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(month, @FromDate)), 2)
                      when 9364 then 'Quarterly' + convert(char(4), datepart(year, @FromDate)) + convert(char(1), datepart(quarter, @FromDate))
                      when 9365 then 'Yearly' + convert(char(4), datepart(year, @FromDate))
                    end
  group by cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end,
          cl.ClaimLineId  

  
  insert  into @BundleClaimLines
          (ClaimBundleId,
           BundleClientId,
           ClaimLineId,
           ClaimType,
           FromDate,
           Units,
           Period,
           PeriodWeek,
           PeriodMonth,
           PeriodQuarter,
           PeriodYear,
           Ranking,
           SubmissionFrequency)
  select  cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end as BundleClientId,
          cl.ClaimLineId,
          'Bundle' as ClaimType,
          max(cl.FromDate),
          max(cl.Units),
          max(cb.Period),
          datepart(week, max(cl.FromDate)) as PeriodWeek,
          datepart(month, max(cl.FromDate)) as PeriodMonth,
          datepart(quarter, max(cl.FromDate)) as PeriodQuarter,
          datepart(year, max(cl.FromDate)) as PeriodYear,
          3 as Ranking,
          max(cb.BundleSubmissionFrequency)
  from    OpenClaims oc
          join ClaimLines cl with (index (ClaimLines_PK)) on cl.ClaimLineId = oc.ClaimLineId
          join Claims c on c.ClaimId = cl.ClaimId
          join Sites s on s.SiteId = c.SiteId
          join @ClaimBundles cb on cb.InsurerId = c.InsurerId
                                   and cb.BundleSiteId = c.SiteId
                                   and cb.BundleBillingCodeId = cl.BillingCodeId
                                   and isnull(cb.BundleModifier1, '') = isnull(cl.Modifier1, '')
                                   and isnull(cb.BundleModifier2, '') = isnull(cl.Modifier2, '')
                                   and isnull(cb.BundleModifier3, '') = isnull(cl.Modifier3, '')
                                   and isnull(cb.BundleModifier4, '') = isnull(cl.Modifier4, '')
                                   and case when cb.BundleClientId = -1 then c.ClientId
                                            else cb.BundleClientId
                                       end = c.ClientId
  where   (cl.Status = 2022
	       -- 2542 - duplicate claim line
           or (cl.Status in (2024, 2027)
               and not exists ( select  *
                                from    AdjudicationDenialPendedReasons ar
                                where   ar.AdjudicationId = cl.LastAdjudicationId
                                        and (ar.DenialReason = 2542
                                             or ar.PendedReason = 2542) )))
          and isnull(c.RecordDeleted, 'N') = 'N'
          and isnull(cl.RecordDeleted, 'N') = 'N'
          and case cb.Period
                when 9361 then 'Daily' + convert(char(10), cl.FromDate, 112)
                when 9362 then 'Weekly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(week, cl.FromDate)), 2)
                when 9363 then 'Monthly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(month, cl.FromDate)), 2)
                when 9364 then 'Quarterly' + convert(char(4), datepart(year, cl.FromDate)) + convert(char(1), datepart(quarter, cl.FromDate))
                when 9365 then 'Yearly' + convert(char(4), datepart(year, cl.FromDate))
              end = case cb.Period
                      when 9361 then 'Daily' + convert(char(10), @FromDate, 112)
                      when 9362 then 'Weekly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(week, @FromDate)), 2)
                      when 9363 then 'Monthly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(month, @FromDate)), 2)
                      when 9364 then 'Quarterly' + convert(char(4), datepart(year, @FromDate)) + convert(char(1), datepart(quarter, @FromDate))
                      when 9365 then 'Yearly' + convert(char(4), datepart(year, @FromDate))
                    end
  group by cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end,
          cl.ClaimLineId
  union all
  select  cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end as BundleClientId,
          cl.ClaimLineId,
          'Bundle' as ClaimType,
          max(cl.FromDate),
          max(cl.Units),
          max(cb.Period),
          datepart(week, max(cl.FromDate)) as PeriodWeek,
          datepart(month, max(cl.FromDate)) as PeriodMonth,
          datepart(quarter, max(cl.FromDate)) as PeriodQuarter,
          datepart(year, max(cl.FromDate)) as PeriodYear,
          max(case when a.BundleAdjudicationId = a.AdjudicationId then 1
                   else 2
              end) as Ranking,
          max(cb.BundleSubmissionFrequency)
  from    @ClaimBundles cb
          join Adjudications a on a.ClaimBundleId = cb.ClaimBundleId
                                  and a.BundleClaimType = 'B'
          join ClaimLines cl on cl.ClaimLineId = a.ClaimLineId
                                and cl.LastAdjudicationId = a.AdjudicationId
          join Claims c on c.ClaimId = cl.ClaimId
  where   cl.Status in (2023, 2025, 2026)
          and isnull(c.RecordDeleted, 'N') = 'N'
          and isnull(cl.RecordDeleted, 'N') = 'N'
          and case cb.Period
                when 9361 then 'Daily' + convert(char(10), cl.FromDate, 112)
                when 9362 then 'Weekly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(week, cl.FromDate)), 2)
                when 9363 then 'Monthly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(month, cl.FromDate)), 2)
                when 9364 then 'Quarterly' + convert(char(4), datepart(year, cl.FromDate)) + convert(char(1), datepart(quarter, cl.FromDate))
                when 9365 then 'Yearly' + convert(char(4), datepart(year, cl.FromDate))
              end = case cb.Period
                      when 9361 then 'Daily' + convert(char(10), @FromDate, 112)
                      when 9362 then 'Weekly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(week, @FromDate)), 2)
                      when 9363 then 'Monthly' + convert(char(4), datepart(year, @FromDate)) + right('0' + convert(varchar(2), datepart(month, @FromDate)), 2)
                      when 9364 then 'Quarterly' + convert(char(4), datepart(year, @FromDate)) + convert(char(1), datepart(quarter, @FromDate))
                      when 9365 then 'Yearly' + convert(char(4), datepart(year, @FromDate))
                    end
  group by cb.ClaimBundleId,
          case when cb.BundleClientId = -1 then c.ClientId
               else cb.BundleClientId
          end,
          cl.ClaimLineId; 


  with  CTE_Ranking
          as (select  BundleClaimLineId,
                      row_number() over (partition by ClaimBundleId, BundleClientId, case Period
                                                                                       when 9361 then 'Daily' + convert(char(10), FromDate, 112)
                                                                                       when 9362 then 'Weekly' + convert(char(4), datepart(year, FromDate)) + right('0' + convert(varchar(2), datepart(week, FromDate)), 2)
                                                                                       when 9363 then 'Monthly' + convert(char(4), datepart(year, FromDate)) + right('0' + convert(varchar(2), datepart(month, FromDate)), 2)
                                                                                       when 9364 then 'Quarterly' + convert(char(4), datepart(year, FromDate)) + convert(char(1), datepart(quarter, FromDate))
                                                                                       when 9365 then 'Yearly' + convert(char(4), datepart(year, FromDate))
                                                                                     end order by Ranking, case when ClaimLineId = @ClaimLineId then 1
                                                                                                                else 2
                                                                                                           end, FromDate, ClaimLineId) as Ranking
              from    @BundleClaimLines)
    update  bc
    set     Ranking = r.Ranking
    from    @BundleClaimLines bc
            join CTE_Ranking r on r.BundleClaimLineId = bc.BundleClaimLineId

  insert  into @ActivityClaimLines
          (ActivityClaimLineId,
           ClaimBundleId,
           ClaimType,
           BundleClientId,
           BundleClaimLineId,
           ClaimBundleBillingCodeGroupId,
           Units,
           IsValid,
           InvalidReason)
  select  acl.ClaimLineId as ActivityClaimLineId,
          acl.ClaimBundleId,
          acl.ClaimType,
          acl.BundleClientId,
          bcl.ClaimLineId as BundleClaimLineId,
          acl.ClaimBundleBillingCodeGroupId,
          acl.Units,
          case when bcl.ClaimLineId is null then 'Invalid'
               else 'Valid'
          end as IsValid,
          case when bcl.ClaimLineId is null then 'Bundle claim line not found'
               else null
          end as InvalidReason
  from    @ActivityClaimLineDetails acl
          left join @BundleClaimLines bcl on bcl.ClaimBundleId = acl.ClaimBundleId
                                             and bcl.BundleClientId = acl.BundleClientId
                                             and bcl.Ranking = 1
                                             and ((acl.Period = 9361
                                                   and acl.FromDate = bcl.FromDate)
                                                  or (acl.Period = 9362
                                                      and acl.PeriodWeek = bcl.PeriodWeek
                                                      and acl.PeriodYear = bcl.PeriodYear)
                                                  or (acl.Period = 9363
                                                      and acl.PeriodMonth = bcl.PeriodMonth
                                                      and acl.PeriodYear = bcl.PeriodYear)
                                                  or (acl.Period = 9364
                                                      and acl.PeriodQuarter = bcl.PeriodQuarter
                                                      and acl.PeriodYear = bcl.PeriodYear)
                                                  or (acl.Period = 9365
                                                      and acl.PeriodYear = bcl.PeriodYear))
          join ClaimLines cl on cl.ClaimLineId = acl.ClaimLineId
  where   (acl.ClaimLineId <> bcl.ClaimLineId
           or bcl.ClaimLineId is null);

  with  CTE_Units
          as (select  cb.ClaimBundleId,
                      acl.BundleClientId,
                      cb.ClaimBundleBillingCodeGroupId,
                      acl.BundleClaimLineId,
                      max(case when cb.AllBillingCodes = 'Y' then cb.AllBillingCodesMinimumUnitsPerPeriod
                               else cb.MinimumUnitsPerPeriod
                          end) as MinimumUnitsPerPeriodRequired,
                      isnull(sum(acl.Units), 0) as Units
              from    @ClaimBundles cb
                      join @ActivityClaimLines acl on acl.ClaimBundleId = cb.ClaimBundleId
                                                      and acl.BundleClientId = case when cb.BundleClientId = -1 then acl.BundleClientId
                                                                                    else cb.BundleClientId
                                                                               end
                                                      and acl.ClaimBundleBillingCodeGroupId = cb.ClaimBundleBillingCodeGroupId
              group by cb.ClaimBundleId,
                      cb.ClaimBundleBillingCodeGroupId,
                      acl.BundleClientId,
                      acl.BundleClaimLineId),
        CTE_BundleClaimLineValidation
          as (select  bcl.ClaimLineId as BundleClaimLineId,
                      case when (exists ( select  *
                                          from    CTE_Units u
                                          where   u.BundleClaimLineId = bcl.ClaimLineId
                                                  and u.MinimumUnitsPerPeriodRequired > u.Units )
                                 or not exists ( select *
                                                 from   CTE_Units u
                                                 where  u.BundleClaimLineId = bcl.ClaimLineId )) then '; Minimum number of units not met'
                           else ''
                      end + case when (isnull(cl.Modifier1, '') <> isnull(cb.Modifier1, '')
                                       or isnull(cl.Modifier2, '') <> isnull(cb.Modifier2, '')
                                       or isnull(cl.Modifier3, '') <> isnull(cb.Modifier3, '')
                                       or isnull(cl.Modifier4, '') <> isnull(cb.Modifier4, '')) then '; Modifier on bundle claim line does not match claim bundle'
                                 else ''
                            end as InvalidReason
              from    @BundleClaimLines bcl
                      join ClaimLines cl on cl.ClaimLineId = bcl.ClaimLineId
                      join ClaimBundles cb on cb.ClaimBundleId = bcl.ClaimBundleId
              where   bcl.Ranking = 1)
    insert  into @ClaimLineBundles
            (ActivityClaimLineId,
             ClaimBundleId,
             ClaimType,
             BundleClaimLineId,
             IsValid,
             InvalidReason)
    select  acl.ActivityClaimLineId,
            acl.ClaimBundleId,
            acl.ClaimType,
            acl.BundleClaimLineId,
            acl.IsValid,
            acl.InvalidReason
    from    @ActivityClaimLines acl
    union all
    select  bcl.ClaimLineId as ActivityClaimLineId,
            bcl.ClaimBundleId,
            bcl.ClaimType,
            bcl.ClaimLineId as BundleClaimLineId,
            case when isnull(v.InvalidReason, '') = '' then 'Valid'
                 else 'Invalid'
            end,
            case when isnull(v.InvalidReason, '') = '' then null
                 else substring(v.InvalidReason, 3, len(v.InvalidReason) - 2)
            end as InvalidReason
    from    @BundleClaimLines bcl
            left join CTE_BundleClaimLineValidation v on v.BundleClaimLineId = bcl.ClaimLineId
    where   bcl.Ranking = 1
    union all
    select  bcla.ClaimLineId as ActivityClaimLineId,
            bcl.ClaimBundleId,
            bcl.ClaimType,
            bcl.ClaimLineId as BundleClaimLineId,
            case when isnull(v.InvalidReason, '') = '' then 'Valid'
                 else 'Invalid'
            end,
            case when isnull(v.InvalidReason, '') = '' then null
                 else substring(v.InvalidReason, 3, len(v.InvalidReason) - 2)
            end as InvalidReason
    from    @BundleClaimLines bcl
            left join CTE_BundleClaimLineValidation v on v.BundleClaimLineId = bcl.ClaimLineId
            join @BundleClaimLines bcla on bcl.ClaimBundleId = bcla.ClaimBundleId
                                           and bcl.BundleClientId = bcla.BundleClientId
                                           and ((bcl.Period = 9361
                                                 and bcla.FromDate = bcl.FromDate)
                                                or (bcl.Period = 9362
                                                    and bcla.PeriodWeek = bcl.PeriodWeek
                                                    and bcla.PeriodYear = bcl.PeriodYear)
                                                or (bcl.Period = 9363
                                                    and bcla.PeriodMonth = bcl.PeriodMonth
                                                    and bcla.PeriodYear = bcl.PeriodYear)
                                                or (bcl.Period = 9364
                                                    and bcla.PeriodQuarter = bcl.PeriodQuarter
                                                    and bcla.PeriodYear = bcl.PeriodYear)
                                                or (bcl.Period = 9365
                                                    and bcla.PeriodYear = bcl.PeriodYear))
    where   bcl.Ranking = 1
            and bcla.Ranking > 1
            and @ClaimType = 'Bundle'
            and bcl.SubmissionFrequency is not null



  return

end

go
 