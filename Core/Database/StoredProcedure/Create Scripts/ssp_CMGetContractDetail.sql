IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMGetContractDetail]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMGetContractDetail] 

GO
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_GetContract            */                  
/* Copyright: 2005 Provider Claim Management System             */                  
/* Creation Date:  May 22/2014                                */                  
/*                                                                   */                  
/* Purpose: it will get all Contract Detail             */                 
/*                                                                   */                
/* Input Parameters: @Active          */                
/*                                                                   */                  
/* Output Parameters:                                */                  
/*                                                                   */                  
/* Return:Plan Records based on the applied filer  */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/*                                                                   */                  
/* Updates:                                                          */                  
/* Date            Author      Purpose                                */                  
/* May  22/2014    Shruthi.S   Created                                */       
/* June 13/2014    Shruthi.S   Modified to include modifier combination from contract rates without fetching duplicate records. */   
/* Oct 6/2014      Shruthi.S   Modified to display empty modifiers if all the modifiers are null.Care Management to SmartCare Env. Issues Tracking #20*/
/* Feb 2/2015      SuryBalan   Modified to display ContractRateAffiliates on clicking Specified Associated Prov.Care Management to SmartCare Env. Issues Tracking #463*/
/* Aug 21/2015      Vamsi N   Added Record deleted check for BillingCodeModifiers for Valley Client Acceptance Testing Issues #340*/
/* oct 12/2015      SuryaBalan  rounded off ClaimsApprovedAndPaid for Task 618 Network180*/
/*  21 Oct 2015		Revathi		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 								why:task #609, Network180 Customization  */  
/*  21 Oct 2015		Basudev		what:Changed code to display Clients LastName and FirstName and removed null check when ClientType=''I'' else  OrganizationName.  */ 
/* 								why:task #609, Network180 Customization  */
--  20.May.2016		Rohith Uppin	Removed rounded off ClaimsApprovedAndPaid. Task#955 SWMBH Support
/*********************************************************************/       
/*********************************************************************/       
CREATE  PROCEDURE [dbo].[ssp_CMGetContractDetail]     
(    
@ContractId int   
)    
AS  

begin   
SELECT     dbo.Contracts.InsurerId AS InsurerId, dbo.Contracts.ContractType AS [ContractType],      
                      dbo.Contracts.ContractId, dbo.Contracts.ProviderId, dbo.Contracts.InsurerId, dbo.Contracts.Status, dbo.Contracts.ContractName,     
                      dbo.Contracts.StartDate, dbo.Contracts.EndDate, dbo.Contracts.ContractType, dbo.Contracts.PaymentTerms, dbo.Contracts.ClaimsReceivedDays,     
                      dbo.Contracts.DelayedClaimsAction, dbo.Contracts.TotalAmountCap, dbo.Contracts.ClaimsApprovedAndPaid, dbo.Contracts.Notes,     
                      dbo.Contracts.ProviderSiteCredentialed,dbo.Contracts.CredentialedRenderingProvider, dbo.Contracts.RowIdentifier, dbo.Contracts.CreatedBy, dbo.Contracts.CreatedDate, dbo.Contracts.ModifiedBy,     
                      dbo.Contracts.ModifiedDate, dbo.Contracts.RecordDeleted, dbo.Contracts.DeletedDate, dbo.Contracts.DeletedBy    
FROM         dbo.Contracts 
WHERE     (ISNULL(dbo.Contracts.RecordDeleted, 'N') = 'N')     
          AND (dbo.Contracts.ContractId = @ContractId)    
  Order By  dbo.Contracts.EndDate Asc,dbo.Contracts.StartDate Desc   
  
  select 
 distinct CR.ContractRateId,
CR.ContractId,
CR.BillingCodeId,
CR.Modifier1,
CR.Modifier2,
CR.Modifier3,
CR.Modifier4,
CR.SiteId,
CR.ClientId,
CR.StartDate,
CR.EndDate,
CR.ContractRate,
CR.Active,
CR.RequiresAffilatedProvider,
CR.AllAffiliatedProviders,
CR.RowIdentifier,
CR.CreatedBy,
CR.CreatedDate,
CR.ModifiedBy,
CR.ModifiedDate,
CR.RecordDeleted,
CR.DeletedDate,
CR.DeletedBy,
cast(BC.Units as CHAR(18)) + Gc.CodeName as RateUnit,
Ltrim(Rtrim(BC.BillingCode))  + Case when len(ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier1],' '))),' ')+ ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2],' '))),' ')+ ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier3],' '))),' ')+ ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier4],' '))),' ') )= 0 then '' else ':' end + 
Case when ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier1],''))),'')='' 
then ' ' else
Ltrim(RTrim(Isnull(CR.[Modifier1],' '))) + ':' end + 
Case when ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2],''))),'')='' 
then ' ' else 
Ltrim(RTrim(Isnull(CR.[Modifier2],''))) + ':' end + 
Case when ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2],''))),'')='' 
then ' ' else 
Ltrim(RTrim(Isnull(CR.[Modifier3],''))) + ':' end + 
Case when ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2],''))),'')='' 
then ' ' else
Ltrim(RTrim(Isnull(CR.[Modifier4],''))) end     as CodeandModifiers,   
BC.CodeName as BillingCodeName,
--Added by Revathi   21 Oct 2015
case when  ISNULL(C.ClientType,'I')='I' then
     C.lastname + ', ' + c.FirstName
     else ISNULL(C.OrganizationName,'') end  as ClientIdText,
--C.lastname + ' ,' + c.FirstName as ClientIdText,
S.SiteName as SiteIdText,
'$'+ convert(varchar,cast(CR.ContractRate as money),10)  as ContractRate1,
Convert(varchar,BM.BillingCodeId)+'_'+convert(varchar,BM.BillingCodeModifierId) as BillingCodeModifierId,
convert(char(10), cr.startdate, 101) as StartDate1,
convert(char(10), cr.EndDate, 101) as EndDate1,AllSites
from 
  
  ContractRates CR  
   left join clients c on cr.ClientId=c.ClientId
   left join Sites S on S.SiteId=CR.SiteId
   left join BillingCodes BC on BC.BillingCodeId = CR.BillingCodeId
   left join BillingCodeModifiers BM on BC.BillingCodeId = BM.BillingCodeId and (ISNULL(BM.RecordDeleted, 'N') = 'N') and  
   --((rtrim(ltrim(BM.Modifier1))+rtrim(ltrim(BM.Modifier2))+rtrim(ltrim(BM.Modifier3))+rtrim(ltrim(BM.Modifier4)) = rtrim(ltrim(CR.Modifier1))+rtrim(ltrim(CR.Modifier2))+rtrim(ltrim(CR.Modifier3))+rtrim(ltrim(CR.Modifier4))) or (isnull(BM.Modifier1,'') = '' and isnull(BM.Modifier2,'') = '' and isnull(BM.Modifier3,'') = '' and isnull(BM.Modifier4,'') = ''))
      case  when len(((rtrim(ltrim(BM.Modifier1))))) = 0 or rtrim(ltrim(BM.Modifier1)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier1)) end +
  case  when len(((rtrim(ltrim(BM.Modifier2))))) = 0 or rtrim(ltrim(BM.Modifier2)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier2)) end +
  case  when len(((rtrim(ltrim(BM.Modifier3))))) = 0 or rtrim(ltrim(BM.Modifier3)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier3)) end +
  case  when len(((rtrim(ltrim(BM.Modifier4))))) = 0 or rtrim(ltrim(BM.Modifier4)) IS NULL then '$' else 
        rtrim(ltrim(BM.Modifier4)) end      
         = 
case  when len(((rtrim(ltrim(CR.Modifier1))))) = 0 or rtrim(ltrim(CR.Modifier1)) IS NULL then '$' else 
        rtrim(ltrim(CR.Modifier1)) end +      
case  when len(((rtrim(ltrim(CR.Modifier2))))) = 0 or rtrim(ltrim(CR.Modifier2)) IS NULL then '$' else 
        rtrim(ltrim(CR.Modifier2)) end +  
case  when len(((rtrim(ltrim(CR.Modifier3))))) = 0 or rtrim(ltrim(CR.Modifier3)) IS NULL then '$' else 
        rtrim(ltrim(CR.Modifier3)) end +  
case  when len(((rtrim(ltrim(CR.Modifier4))))) = 0 or rtrim(ltrim(CR.Modifier4)) IS NULL then '$' else 
        rtrim(ltrim(CR.Modifier4)) end 
         or (isnull(BM.Modifier1,'') = '
' and isnull(BM.Modifier2,'') = '' and isnull(BM.Modifier3,'') = '' and isnull(BM.Modifier4,'') = '')
   left join GlobalCodes GC on GC.GlobalCodeId = BC.UnitType
  
where  (ISNULL(CR.RecordDeleted, 'N') = 'N')  and CR.ContractId =@ContractId and
(ISNULL(GC.RecordDeleted, 'N') = 'N')
  
 
  
  select 
distinct CRU.ContractRuleId,
CRU.ContractId,
CRU.BillingCodeId,
CRU.UnlimitedDailyUnits,
CRU.DailyUnits,
CRU.UnlimitedWeeklyUnits,
CRU.WeeklyUnits,
CRU.UnlimitedMonthlyUnits,
CRU.MonthlyUnits,
CRU.UnlimitedYearlyUnits,
CRU.YearlyUnits,
CRU.AmountCap,
CRU.TotalAmountUsed,
CRU.ExceedLimitAction,
CRU.AuthorizationRequired,
CRU.RowIdentifier,
CRU.CreatedBy,
CRU.CreatedDate,
CRU.ModifiedBy,
CRU.ModifiedDate,
CRU.RecordDeleted,
CRU.DeletedDate,
CRU.DeletedBy,
PreviousPayerEOBRequired,
BC.BillingCode as CodeandModifiers,   
BC.CodeName as BillingCodeName,
'$'+ convert(varchar,cast(CRU.AmountCap as money),10)  as AmountCap1
  from 
  ContractRules CRU
  left join BillingCodes BC on BC.BillingCodeId = CRU.BillingCodeId
 -- left join BillingCodeModifiers BM on BC.BillingCodeId = BM.BillingCodeId
  left join GlobalCodes GC on GC.GlobalCodeId = BC.UnitType
  where (ISNULL(CRU.RecordDeleted, 'N') = 'N')  and CRU.ContractId =@ContractId
  
  
   select CRA.ContractRateAffiliateId,
  CRA.ProviderId,
  CRA.ContractRateId,
  CRA.RowIdentifier,
  CRA.CreatedBy,
  CRA.CreatedDate,
  CRA.ModifiedBy,
  CRA.ModifiedDate,
  CRA.RecordDeleted,
  CRA.DeletedDate,
  CRA.DeletedBy from ContractRateAffiliates CRA 
  inner join ContractRates CR on CRA.ContractRateId=CR.ContractRateId and CR.ContractId =@ContractId 
   where (ISNULL(CRA.RecordDeleted, 'N') = 'N')
     and (ISNULL(CR.RecordDeleted, 'N') = 'N')
  

  --Checking For Errors    
If (@@error!=0)  Begin  RAISERROR  20006  'ssp_CMGetContractDetail: An Error Occured'     Return  End    
          
 end