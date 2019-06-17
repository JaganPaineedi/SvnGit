if object_id('dbo.ssv_BillingCodeExchangeCombinations') is not null 
  drop view dbo.ssv_BillingCodeExchangeCombinations
go

create view dbo.ssv_BillingCodeExchangeCombinations
/********************************************************************************  
-- View: dbo.ssv_BillingCodeExchangeCombinations
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: returns billing code exchanges that can be used for authorizations
--  
--	Updates:                                                         
--	Date        Author     Purpose  
--	03.30.2016  Suhail     Created.        
--	05.09.2016  SFarber    Added check for validsite.SiteId is not null.  
*********************************************************************************/  
as
select  AuthorizationBillingCodeId = bcm.BillingCodeId,
        AuthorizationModifier1 = bcm.Modifier1,
        AuthorizationModifier2 = bcm.Modifier2,
        AuthorizationModifier3 = bcm.Modifier3,
        AuthorizationModifier4 = bcm.Modifier4,
        AuthorizationAppliesToAllModifiers = bce.ApplyToAllModifiers,
        ClaimBillingCodeId = bcmexch.BillingCodeId,
        ClaimModifier1 = bcmexch.Modifier1,
        ClaimModifier2 = bcmexch.Modifier2,
        ClaimModifier3 = bcmexch.Modifier3,
        ClaimModifier4 = bcmexch.Modifier4,
        ClaimAppliesToAllModifiers = exchbilling.ApplyToAllModifiers,
        ProviderId = validsite.ProviderId,
        SiteId = validsite.SiteId,
        InsurerId = validinsurer.InsurerId
from    AuthorizationClaimsBillingCodeExchanges bce
        inner join BillingCodeModifiers bcm on bce.BillingCodeModifierId = bcm.BillingCodeModifierId
                                               and isnull(bce.RecordDeleted, 'N') = 'N'
        inner join AuthorizationClaimsBillingCodeExchangeBillingCodes exchbilling on bce.AuthorizationClaimsBillingCodeExchangeId = exchbilling.AuthorizationClaimsBillingCodeExchangeId
                                                                                     and isnull(exchbilling.RecordDeleted, 'N') = 'N'
        inner join BillingCodeModifiers bcmexch on exchbilling.BillingCodeModifierId = bcmexch.BillingCodeModifierId
                                                   and isnull(bcmexch.RecordDeleted, 'N') = 'N'
        left outer join AuthorizationClaimsBillingCodeExchangeInsurers validinsurer on validinsurer.AuthorizationClaimsBillingCodeExchangeId = bce.AuthorizationClaimsBillingCodeExchangeId
                                                                                       and isnull(validinsurer.RecordDeleted, 'N') = 'N'
        left outer join AuthorizationClaimsBillingCodeExchangeProviderSites validsite on validsite.AuthorizationClaimsBillingCodeExchangeId = bce.AuthorizationClaimsBillingCodeExchangeId
                                                                                         and isnull(validsite.RecordDeleted, 'N') = 'N'
where   (bce.InsurerGroupName is null
         or validinsurer.InsurerId is not null)
        and (bce.ProviderSitesGroupName is null
             or validsite.ProviderId is not null or validsite.SiteId is not null)
union all
/* Interchangeable - If this flag is check then the claim billing code can be used for authorization billing code*/
select  AuthorizationBillingCodeId = bcmexch.BillingCodeId,
        AuthorizationModifier1 = bcmexch.Modifier1,
        AuthorizationModifier2 = bcmexch.Modifier2,
        AuthorizationModifier3 = bcmexch.Modifier3,
        AuthorizationModifier4 = bcmexch.Modifier4,
        AuthorizationAppliesToAllModifiers = exchbilling.ApplyToAllModifiers,
        ClaimBillingCodeId = bcm.BillingCodeId,
        ClaimModifier1 = bcm.Modifier1,
        ClaimModifier2 = bcm.Modifier2,
        ClaimModifier3 = bcm.Modifier3,
        ClaimModifier4 = bcm.Modifier4,
        ClaimAppliesToAllModifiers = bce.ApplyToAllModifiers,
        ProviderId = validsite.ProviderId,
        SiteId = validsite.SiteId,
        InsurerId = validinsurer.InsurerId
from    AuthorizationClaimsBillingCodeExchanges bce
        inner join BillingCodeModifiers bcm on bce.BillingCodeModifierId = bcm.BillingCodeModifierId
                                               and isnull(bce.RecordDeleted, 'N') = 'N'
        inner join AuthorizationClaimsBillingCodeExchangeBillingCodes exchbilling on bce.AuthorizationClaimsBillingCodeExchangeId = exchbilling.AuthorizationClaimsBillingCodeExchangeId
                                                                                     and isnull(exchbilling.RecordDeleted, 'N') = 'N'
        inner join BillingCodeModifiers bcmexch on exchbilling.BillingCodeModifierId = bcmexch.BillingCodeModifierId
                                                   and isnull(bcmexch.RecordDeleted, 'N') = 'N'
        left outer join AuthorizationClaimsBillingCodeExchangeInsurers validinsurer on validinsurer.AuthorizationClaimsBillingCodeExchangeId = bce.AuthorizationClaimsBillingCodeExchangeId
                                                                                       and isnull(validinsurer.RecordDeleted, 'N') = 'N'
        left outer join AuthorizationClaimsBillingCodeExchangeProviderSites validsite on validsite.AuthorizationClaimsBillingCodeExchangeId = bce.AuthorizationClaimsBillingCodeExchangeId
                                                                                         and isnull(validsite.RecordDeleted, 'N') = 'N'
where   (bce.InsurerGroupName is null
         or validinsurer.InsurerId is not null)
        and (bce.ProviderSitesGroupName is null
             or validsite.ProviderId is not null or validsite.SiteId is not null)
        and bce.Interchangeable = 'Y'



GO


