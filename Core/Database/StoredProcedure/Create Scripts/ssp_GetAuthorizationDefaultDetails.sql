/****** Object:  StoredProcedure [dbo].[ssp_GetAuthorizationDefaultDetails]    Script Date: 08/09/2015 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAuthorizationDefaultDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAuthorizationDefaultDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[ssp_GetAuthorizationDefaultDetails]   
(    
@ProviderId INT,    
@SiteId INT ,  
@BillingCodeId INT ,  
@AuthorizationCodeId INT,  
@InsurerId INT      =0, 
@SiteCategory INT =-1
)   
/****** Object:  StoredProcedure [dbo].[ssp_GetAuthorizationDefaultDetails]    Script Date: 08/09/2015 
-- Created:           
-- Date			Author				Purpose 
  
  9-Sept-2015   Ravichander			Created this ssp to set Defaults depends on ProviderSites and BillingCodes and AuthorizationCodes in Authorization Detail Pages
									Network 180 - Customizations #602
 9-Sept-2015   SuryaBalan			Changed DateFormat for StartDate and EndDate	
 11-Sept-2015  SuryaBalan			Changed INNER JOIN to LEFTJOIN whhich is making issue when Duration Entry is NULL
 27-Nov-2015   SuryaBalan           Network 180 Environment Issues Tracking #602.2 
									Fixed Issue: The Frequency didn’t pull into the CM Authorization Details or the Authorization Details  from the Authorization Default Details. 
                                    For either the ‘Set Defaults by Code’ or the ‘Set Defaults by Code and Total Units’	
 29-June-2016  Arjun KR             Select statement is added to get the BillingCodeModifiers to bind the billingcode dropdown. Task #214 Network180 Environment Issues Tracking.									
 6 -July-2016  Arjun KR             In BillingCodeModifiers select statement, ContractRateSites table is joined. Task #214 Network180 Environment Issues Tracking.
 5-August-2016 Arjun KR             In BillingCodeModifiers select statement, Query is changed to return distinct billingcodemodifiers.Task #214 Network180 Environment Issues Tracking. 								
 5-Sept -2016  Veena S Mani         What:Added AllSites conditions in ContractRates and ContractRateSites made it as left join Why:Arc - SGL #27
 29-Nove-2016  Hemant               What:Modified the code ISNULL(CR.AllSites,'N')='Y') to ISNULL(CR.AllSites,'Y')='Y') to fix the data Migration issue.Moved RecordDeleted check from Where to Left join for ContractRateSites table.CEI - Support Go Live 417
 27-Dec-2016   Alok Kumar			What: Added InsurerId checked in where clause for task #87 AspenPointe - Support Go Live.
 11-Jan-2017   Shivanand		    What: selecting 'UnitType'Column from BillingCodeModifiers Table for task #1018 Network180 Support Go Live.
 07/07/2017    Lakshmi				What: Added units coloumn to the Billingmodifiers select query.
									Why:  CEI - Support Go Live #682
 08/10/2017    Hemant               Included the InsurerId check for -1.Allegan - Support#1085
 DEC/18/2018  Arjun K R             What : Added StartDate,EndDate and Active new columns to BillingCodeModifiers table.
								    Why : Task #900.77 KCCHSAS Enhancement.
  
 									*********************************************************************************/     
AS                                   
 BEGIN    
   
  BEGIN TRY   
   
 IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetAuthorizationDefaultDetails]') AND type in (N'P', N'PC'))
 BEGIN
  	 exec scsp_GetAuthorizationDefaultDetails @providerId, @SiteId, @BillingCodeId, @AuthorizationCodeId, @InsurerId, @SiteCategory
 END  
   
   
 ELSE 
 BEGIN
 IF ISNULL(@AuthorizationCodeId,0)<> 0  
 BEGIN  
     SELECT PAD.ProviderAuthorizationDefaultId,  
        PAD.CreatedBy,  
        PAD.CreatedDate,  
        PAD.ModifiedBy,  
        PAD.ModifiedDate,  
        PAD.RecordDeleted,  
        PAD.DeletedBy,  
        PAD.DeletedDate,  
        CONVERT(NVARCHAR(10), PAD.StartDate, 101) as StartDate, 
        CONVERT(NVARCHAR(10),  PAD.EndDate, 101) as EndDate,        
        PAD.InternalExternal,  
        PAD.Active,  
        PAD.DefaultByCodeAndTotalUnits,  
        GC.CodeName,  
        PAD.Duration,  
        GC1.CodeName,  
        PAD.Units,  
        PAD.TotalUnits,  
        PAD.AllProviderSites,  
        PAD.AllBillingCodes,  
        PAD.AllAuthorizationCodes,
        PAD.Frequency  
     FROM ProviderAuthorizationDefaults PAD  
     LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=PAD.Frequency AND ISNULL(GC.RecordDeleted,'N')='N'  
     LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId=PAD.DurationEntry AND ISNULL(GC1.RecordDeleted,'N')='N'  
     WHERE cast(PAD.StartDate as date) <= cast(getdate() as date) and (PAD.EndDate is null or cast(PAD.EndDate as date) >= cast(getdate() as date) ) And ISNULL(PAD.RecordDeleted,'N')='N'  
     AND PAD.InternalExternal= 'I'  
     AND (ISNULL(PAD.AllAuthorizationCodes,'N')='Y'   
     OR EXISTS (SELECT 1 FROM ProviderAuthorizationDefaultAuthorizationCodes PADA WHERE  PADA.ProviderAuthorizationDefaultId=PAD.ProviderAuthorizationDefaultId  
     AND PADA.AuthorizationCodeId=@AuthorizationCodeId  
     AND ISNULL(PADA.RecordDeleted,'N')='N'))  
       
       
 END   
 ELSE  
 BEGIN  
  SELECT PAD.ProviderAuthorizationDefaultId,  
        PAD.CreatedBy,  
        PAD.CreatedDate,  
        PAD.ModifiedBy,  
        PAD.ModifiedDate,  
        PAD.RecordDeleted,  
        PAD.DeletedBy,  
        PAD.DeletedDate,  
        CONVERT(NVARCHAR(10), PAD.StartDate, 101) as StartDate, 
        CONVERT(NVARCHAR(10),  PAD.EndDate, 101) as EndDate, 
        PAD.InternalExternal,  
        PAD.Active,  
        PAD.DefaultByCodeAndTotalUnits,  
        GC.CodeName,  
        PAD.Duration,  
        GC1.CodeName,  
        PAD.Units,  
        PAD.TotalUnits,  
        PAD.AllProviderSites,  
        PAD.AllBillingCodes,  
        PAD.AllAuthorizationCodes, 
        PAD.Frequency   
     FROM ProviderAuthorizationDefaults PAD  
     LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=PAD.Frequency AND ISNULL(GC.RecordDeleted,'N')='N'  
     LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId=PAD.DurationEntry AND ISNULL(GC1.RecordDeleted,'N')='N'  
     WHERE cast(PAD.StartDate as date) <= cast(getdate() as date) and (PAD.EndDate is null or cast(PAD.EndDate as date) >= cast(getdate() as date) ) And  ISNULL(PAD.RecordDeleted,'N')='N'  
     AND PAD.InternalExternal= 'E'  
     AND( ISNULL(PAD.AllProviderSites,'N')='Y'   
     OR EXISTS (SELECT 1 FROM ProviderAuthorizationDefaultProviderSites PAP WHERE  PAP.ProviderAuthorizationDefaultId=PAD.ProviderAuthorizationDefaultId  
       AND ISNULL(PAP.RecordDeleted,'N')='N' AND PAP.ProviderId=@ProviderId ))  
     AND( ISNULL(PAD.AllProviderSites,'N')='Y'   
     OR EXISTS (SELECT 1 FROM ProviderAuthorizationDefaultProviderSites PAS WHERE  PAS.ProviderAuthorizationDefaultId=PAD.ProviderAuthorizationDefaultId  
       AND ISNULL(PAS.RecordDeleted,'N')='N' AND PAS.SiteId=@SiteId )  
       )  
     AND( ISNULL(PAD.AllBillingCodes,'N')='Y'   
     OR EXISTS (SELECT 1 FROM ProviderAuthorizationDefaultBillingCodes PAB WHERE PAB.ProviderAuthorizationDefaultId=PAD.ProviderAuthorizationDefaultId  
       AND ISNULL(PAB.RecordDeleted,'N')='N' AND PAB.BillingCodeModifierId=@BillingCodeId ))  
   
 END  
   
   --29-June-2016  Arjun KR
   --6-July-2016  Arjun KR  
   
   SELECT BCM.[BillingCodeModifierId]  
      ,BCM.[CreatedBy]    
      ,BCM.[CreatedDate]    
      ,BCM.[ModifiedBy]    
      ,BCM.[ModifiedDate]    
      ,BCM.[RecordDeleted]    
      ,BCM.[DeletedDate]    
      ,BCM.[DeletedBy]    
      ,BCM.[BillingCodeId]   
      ,BC.[BillingCode]  
      ,BC.[CodeName]  
      ,BCM.[Modifier1]    
      ,BCM.[Modifier2]    
      ,BCM.[Modifier3]    
      ,BCM.[Modifier4]    
      ,BCM.[Description]    
 ,BC.[BillingCode]+ ':' +BCM.[Modifier1]+ ' ' +BCM.[Modifier2]+ ' ' +BCM.[Modifier3]+ ' ' +BCM.[Modifier4] as BillingCodeAndModifier  
 ,GC3.CodeName as UnitType 
 ,BC.Units
 ,BCM.StartDate --DEC 18 2018          Arjun K R
 ,BCM.EndDate
 ,BCM.Active
  FROM [BillingCodeModifiers] BCM  
  JOIN BillingCodes BC ON BCM.BillingCodeId = BC.BillingCodeId   
  LEFT JOIN GlobalCodes GC3 ON GC3.GlobalCodeId=BC.UnitType AND ISNULL(GC3.RecordDeleted,'N')='N'   
  --JOIN ContractRates CR ON CR.BillingCodeId=BC.BillingCodeId
  --JOIN ContractRateSites CRS ON CRS.ContractRateId=CR.ContractRateId
  WHERE BC.Active='Y' AND ISNULL(BCM.RecordDeleted,'N')='N' AND ISNULL(BC.RecordDeleted,'N')='N' and BCM.[Description] is not null
  --AND ISNULL(CR.RecordDeleted,'N')='N'
  --AND ISNULL(CRS.RecordDeleted,'N')='N'
  --AND (CR.[SiteId]= @SiteId  OR CRS.SiteId =@SiteId)
  AND ISNULL(BCM.Active,'Y')='Y' 
  AND EXISTS(SELECT 1
                     FROM ContractRates CR
                     Join Contracts CTS on CTS.ContractId = cr.ContractId 
                     LEFT JOIN ContractRateSites CRS ON CR.ContractRateId=CRS.ContractRateId AND ISNULL(CRS.RecordDeleted,'N')='N' -- 29-Nove-2016  Hemant   
                     WHERE  CR.BillingCodeId = BCM.BillingCodeId
							AND(@InsurerId = 0 OR ( CTS.ProviderId = @ProviderId AND CTS.InsurerId = @InsurerId))	--27-Dec-2016   Alok Kumar
                            AND  ISNULL(CR.RecordDeleted,'N')='N' AND CR.Active='Y' 
                            AND (CR.[SiteId]= @SiteId  OR CRS.SiteId =@SiteId OR ISNULL(CR.AllSites,'Y')='Y') ) -- 29-Nove-2016  Hemant        
  order by bcm.Description         
END
END TRY  
BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetAuthorizationDefaultDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.      
    16  
    ,-- Severity.      
    1 -- State.      
    );  
 END CATCH  
END  
   
   
   
				
		