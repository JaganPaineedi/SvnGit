/****** Object:  StoredProcedure [dbo].[ssp_CMGetContractRates]    Script Date: 08/14/2014 17:50:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetContractRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetContractRates]
GO
/****** Object:  StoredProcedure [dbo].[ssp_CMGetContractRates]    Script Date: 08/14/2014 17:50:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


        
/*********************************************************************/       
CREATE PROCEDURE [dbo].[ssp_CMGetContractRates] 
(  
@ContractId int,  
@ContractRateId int 


)    
AS  
/*****************************************************************************************************
 Data Modifications:               
                                                                                    
	Updates:                                                                              
 Date			Author               Purpose                                                        
 23.Dec.2014	Rohith				 Selecting Code Modifier changed based on NULL or Empty. Task#285 CM to SC issues tracking.
 -- 21.10.2015       SuryaBalan    Added join with ContractRateSites, since we are not going use SiteId of COntractRates table, as per task #618 N180 Customizations
--                                Before it was Single selection of Sites in COntract Rates Detail Page, now it is multiple selection, 
                                  so whereever we are using ContractRates-SiteId, we need to join with ContractRateSites-SiteId    
  /*  21 Oct 2015		Revathi	what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 								why:task #609, Network180 Customization  */        
05.April.2016   Himmat           What : When firtName and LastName is blank then it DIsplay comma so changed code to display blank inseted of comma
                                 Why  : SWMBH  - Support #922
*****************************************************************************************************/   

IF (@ContractRateId = 0)
BEGIN
	SET @ContractRateId= null
END


begin  
 BEGIN TRY  
SELECT     dbo.Contracts.InsurerId AS InsurerId, 
dbo.Contracts.ContractType AS [ContractType],      
                      dbo.Contracts.ContractId, 
                      dbo.Contracts.ProviderId,
                     ( SELECT InsurerName from Insurers where InsurerId=dbo.Contracts.InsurerId )as InsurerName, 
                      dbo.Contracts.Status, 
                      dbo.Contracts.ContractName,     
                      dbo.Contracts.StartDate, 
                      dbo.Contracts.EndDate, 
                      dbo.Contracts.ContractType,
                      dbo.Contracts.PaymentTerms,
                      dbo.Contracts.ClaimsReceivedDays,     
                      dbo.Contracts.DelayedClaimsAction,
                      dbo.Contracts.TotalAmountCap, 
                      dbo.Contracts.ClaimsApprovedAndPaid, 
                      dbo.Contracts.Notes,     
                      dbo.Contracts.ProviderSiteCredentialed,
                      dbo.Contracts.CredentialedRenderingProvider,
                      dbo.Contracts.RowIdentifier, 
                      dbo.Contracts.CreatedBy, 
                      dbo.Contracts.CreatedDate, 
                      dbo.Contracts.ModifiedBy,     
                      dbo.Contracts.ModifiedDate, 
                      dbo.Contracts.RecordDeleted, 
                      dbo.Contracts.DeletedDate, 
                      dbo.Contracts.DeletedBy    
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
CRS.SiteId,
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
Ltrim(Rtrim(BC.BillingCode))  +   
Case WHEN CR.[Modifier1] is not NULL AND LTRIM(RTRIM(CR.[Modifier1])) <> '' then ':'+ Ltrim(RTrim(Isnull(CR.[Modifier1],''))) ELSE '' END +  
Case WHEN CR.[Modifier2] is not NULL AND LTRIM(RTRIM(CR.[Modifier2])) <> '' then ':'+ Ltrim(RTrim(Isnull(CR.[Modifier2],''))) ELSE '' END +    
Case WHEN CR.[Modifier3] is not NULL AND LTRIM(RTRIM(CR.[Modifier3])) <> '' then ':'+ Ltrim(RTrim(Isnull(CR.[Modifier3],''))) ELSE '' END +   
Case WHEN CR.[Modifier4] is not NULL AND LTRIM(RTRIM(CR.[Modifier4])) <> '' then ':'+ Ltrim(RTrim(Isnull(CR.[Modifier4],''))) ELSE '' END     
 as CodeandModifiers,
BC.CodeName as BillingCodeName,
--Added by Himmat 05.April.2016 
CASE WHEN ISNULL (C.ClientId,0) <> 0 then CASE       
     WHEN ISNULL(C.ClientType, 'I') = 'I'      
      THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')      
     ELSE ISNULL(C.OrganizationName, '')      
     END ELSE '' END AS ClientIdText,
--Added by Revathi  21.oct.2015 
--case when  ISNULL(C.ClientType,'I')='I' then
--     ISNULL(C.LastName,'') + ' ,' + ISNULL(c.FirstName,'')
--     else ISNULL(C.OrganizationName,'') end as ClientIdText,
--C.lastname + ' ,' + c.FirstName as ClientIdText,
S.SiteName as SiteIdText,
'$'+ convert(varchar,cast(CR.ContractRate as money),10)  as ContractRate1,
Convert(varchar,BM.BillingCodeId)+'_'+convert(varchar,BM.BillingCodeModifierId) as BillingCodeModifierId,
convert(char(10), cr.startdate, 101) as StartDate1,
convert(char(10), cr.EndDate, 101) as EndDate1,
CASE WHEN CR.RequiresAffilatedProvider='Y' THEN 'Yes' WHEN CR.RequiresAffilatedProvider='N' THEN 'No' ElSE 'No' END AS RequiresAffilatedProviderDummy
from 
  
  ContractRates CR  
   Left Join ContractRateSites CRS ON CR.ContractRateId=CRS.ContractRateId AND ISNULL(CRS.RecordDeleted,'N')='N'
   left join clients c on cr.ClientId = c.ClientId
   left join Sites S on S.SiteId = CRS.SiteId
   left join BillingCodes BC on BC.BillingCodeId = CR.BillingCodeId
   left join BillingCodeModifiers BM on BC.BillingCodeId = BM.BillingCodeId and  
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
  
where  (ISNULL(CR.RecordDeleted, 'N') = 'N')  and 
((@ContractRateId is not null and CR.ContractRateId =@ContractRateId )
or (@ContractRateId is null and CR.ContractId=@ContractID))
and(ISNULL(GC.RecordDeleted, 'N') = 'N');
 
 
   --Checking For Errors     
--If (@@error!=0)  Begin  RAISERROR  20006  'ssp_CMGetContractDetail: An Error Occured'     Return  End    
          
-- end
END TRY
BEGIN CATCH  
    DECLARE @error varchar(8000)  
  
    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
    + CONVERT(varchar(4000), ERROR_MESSAGE())  
    + '*****'  
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
    'ssp_CMGetContractRates')  
    + '*****' + CONVERT(varchar, ERROR_LINE())  
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())  
    + '*****' + CONVERT(varchar, ERROR_STATE())  
  
    RAISERROR (@error,-- Message text.  
    16,-- Severity.  
    1 -- State.  
    );  
  END CATCH 
End
GO


