if object_id('dbo.ssv_ClaimLineBundles') is not null 
  drop view dbo.ssv_ClaimLineBundles
go

create view dbo.ssv_ClaimLineBundles
/********************************************************************************  
-- View: dbo.ssv_ClaimLineBundles
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: returns activity and claim line bundles.
--  
--	Updates:                                                         
--	Date        Author    Purpose  
--	05.01.2016  Suhail    Created.  
--  10.09.2016  SFarber   Modified to use CTEs instead of functions for validations.
--  10.19.2016  SFarber   Modified to handle the case rate model in case of All Clients.
--  10.20.2016  SFarber   Fixed CTE_Units logic.
--  10.26.2016  SFarber   Modified not to use BillingCodeModifiers table for bundle claim lines.
--  11.05.2016  SFarber   Modified to limit activity claim lines to individual clients only.
--  01.22.2017  SFarber   Modified to left join BillingCodeModifiers in CTE_ActivityClaimLineDetails
--  01.22.2017  SFarber   Modified to exclude duplicate denied claims from CTE_BundleClaimLines
*********************************************************************************/
as
with  CTE_ClaimBundles
        as (select  cb.ClaimBundleId,
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
                    end as BundleClientId
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
            group by cb.ClaimBundleId,
                    case when cb.ClientSameAsAbove = 'Y' then case when cb.AllClients = 'Y' then -1
                                                                   else cbc.ClientId
                                                              end
                         else cb.ClientId
                    end,
                    case when cb.AllBillingCodes = 'Y' then -1
                         else cbbcg.ClaimBundleBillingCodeGroupId
                    end),
      CTE_ActivityClaimLineDetails
        as (select  cb.ClaimBundleId,
                    case when cb.BundleClientId = -1 then c.ClientId
                         else cb.BundleClientId
                    end as BundleClientId,
                    cl.ClaimLineId,
                    ClaimType = 'Activity',
                    max(cb.ClaimBundleBillingCodeGroupId) as ClaimBundleBillingCodeGroupId,
                    max(cl.FromDate) as FromDate,
                    max(cl.Units) as Units,
                    max(cb.Period) as Period,
                    datepart(week, max(cl.FromDate)) as PeriodWeek,
                    datepart(month, max(cl.FromDate)) as PeriodMonth,
                    datepart(quarter, max(cl.FromDate)) as PeriodQuarter,
                    datepart(year, max(cl.FromDate)) as PeriodYear
            from    CTE_ClaimBundles cb
                    join Claims c on c.InsurerId = cb.InsurerId
                    join ClaimLines cl on cl.ClaimId = c.ClaimId
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
            where   (cl.Status in (2022, 2023, 2025, 2026)
			         -- 2550 - Bundle claim line does not have the correct associated claim lines to bill
					 -- 2549 - Activity claim line cannot be adjudicated without an associated bundle claim line
                     or (cl.Status = 2024
                         and cl.DenialReason in (2549, 2550))
                     or (cl.Status = 2027
                         and cl.PendedReason in (2549, 2550)))
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    and isnull(cl.RecordDeleted, 'N') = 'N'
                    and (cb.StartDate <= cl.FromDate
                         or cb.StartDate is null)
                    and (cb.EndDate >= cl.FromDate
                         or cb.EndDate is null)
                    and (cb.AllClients = 'Y'
                         or exists ( select *
                                     from   ClaimBundleClients cbc
                                     where  cbc.ClaimBundleId = cb.ClaimBundleId
                                            and cbc.ClientId = c.ClientId ))
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
                    cl.ClaimLineId),
      CTE_BundleClaimLines
        as (select  cb.ClaimBundleId,
                    case when cb.BundleClientId = -1 then c.ClientId
                         else cb.BundleClientId
                    end as BundleClientId,
                    cl.ClaimLineId,
                    ClaimType = 'Bundle',
                    cl.FromDate,
                    cl.Units,
                    cb.Period,
                    datepart(week, cl.FromDate) as PeriodWeek,
                    datepart(month, cl.FromDate) as PeriodMonth,
                    datepart(quarter, cl.FromDate) as PeriodQuarter,
                    datepart(year, cl.FromDate) as PeriodYear,
                    row_number() over (partition by cb.ClaimBundleId, case when cb.BundleClientId = -1 then c.ClientId
                                                                           else cb.BundleClientId
                                                                      end, case cb.Period
                                                                             when 9361 then 'Daily' + convert(char(10), cl.FromDate, 112)
                                                                             when 9362 then 'Weekly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(week, cl.FromDate)), 2)
                                                                             when 9363 then 'Monthly' + convert(char(4), datepart(year, cl.FromDate)) + right('0' + convert(varchar(2), datepart(month, cl.FromDate)), 2)
                                                                             when 9364 then 'Quarterly' + convert(char(4), datepart(year, cl.FromDate)) + convert(char(1), datepart(quarter, cl.FromDate))
                                                                             when 9365 then 'Yearly' + convert(char(4), datepart(year, cl.FromDate))
                                                                           end order by cl.FromDate desc, cl.ClaimLineId) as Ranking
            from    CTE_ClaimBundles cb
                    join Claims c on c.InsurerId = cb.InsurerId
                    join ClaimLines cl on cl.ClaimId = c.ClaimId
                    join Sites s on s.SiteId = c.SiteId
            where   (cl.Status not in (2021, 2028)
			        -- 2542 - duplicate claim line
                     or (cl.Status = 2024
                         and cl.DenialReason = 2542))
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    and isnull(cl.RecordDeleted, 'N') = 'N'
                    and (cb.StartDate <= cl.FromDate
                         or cb.StartDate is null)
                    and (cb.EndDate >= cl.FromDate
                         or cb.EndDate is null)
                    and case when cb.BundleClientId = -1 then c.ClientId
                             else cb.BundleClientId
                        end = c.ClientId
                    and cb.BundleBillingCodeId = cl.BillingCodeId
                    and isnull(cb.BundleModifier1, '') = isnull(cl.Modifier1, '')
                    and isnull(cb.BundleModifier2, '') = isnull(cl.Modifier2, '')
                    and isnull(cb.BundleModifier3, '') = isnull(cl.Modifier3, '')
                    and isnull(cb.BundleModifier4, '') = isnull(cl.Modifier4, '')
                    and cb.BundleSiteId = c.SiteId),
      CTE_ActivityClaimLines
        as (select  acl.ClaimLineId as ActivityClaimLineId,
                    acl.ClaimBundleId,
                    acl.ClaimType,
                    acl.BundleClientId,
                    bcl.ClaimLineId as BundleClaimLineId,
                    acl.ClaimBundleBillingCodeGroupId,
                    acl.Units,
                    case when bcl.ClaimLineId is null then 'Invalid'
                         else 'Valid'
                    end IsValid,
                    case when bcl.ClaimLineId is null then 'Bundle claim line not found'
                         else null
                    end as InvalidReason
            from    CTE_ActivityClaimLineDetails acl
                    left join CTE_BundleClaimLines bcl on bcl.ClaimBundleId = acl.ClaimBundleId
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
                    join ClaimLines cl on cl.ClaimLineid = acl.ClaimLineId
            where   (acl.ClaimLineId <> bcl.ClaimLineId
                     or bcl.ClaimLineId is null)),
      CTE_Units
        as (select  cb.ClaimBundleId,
                    acl.BundleClientId,
                    cb.ClaimBundleBillingCodeGroupId,
                    acl.BundleClaimLineId,
                    max(case when cb.AllBillingCodes = 'Y' then cb.AllBillingCodesMinimumUnitsPerPeriod
                             else cb.MinimumUnitsPerPeriod
                        end) as MinimumUnitsPerPeriodRequired,
                    isnull(sum(acl.Units), 0) as Units
            from    CTE_ClaimBundles cb
                    join CTE_ActivityClaimLines acl on acl.ClaimBundleId = cb.ClaimBundleId
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
            from    CTE_BundleClaimLines bcl
                    join ClaimLines cl on cl.ClaimLineId = bcl.ClaimLineId
                    join ClaimBundles cb on cb.ClaimBundleId = bcl.ClaimBundleId
            where   bcl.Ranking = 1)
  select  acl.ActivityClaimLineId,
          acl.ClaimBundleId,
          acl.ClaimType,
          acl.BundleClaimLineId,
          acl.IsValid,
          acl.InvalidReason
  from    CTE_ActivityClaimLines acl
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
  from    CTE_BundleClaimLines bcl
          join ClaimLines cl on cl.ClaimLineId = bcl.ClaimLineId
          left join CTE_BundleClaimLineValidation v on v.BundleClaimLineId = bcl.ClaimLineId
  where   bcl.Ranking = 1
 
 go
 