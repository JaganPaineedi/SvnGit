

/****** Object:  StoredProcedure [dbo].[ssp_CMGetContractRatesDetail]    Script Date: 09/27/2016 16:07:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetContractRatesDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetContractRatesDetail]
GO



/****** Object:  StoredProcedure [dbo].[ssp_CMGetContractRatesDetail]    Script Date: 09/27/2016 16:07:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_CMGetContractRatesDetail] (@ContractRateId INT)  
AS  
-- 15.June.2016 Himmat     Added extra comma in between sitetext Swmbh Task No.1002 
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
/* 29-Sept-2015* SuryaBalan To Get Provider Rates #618*/  
/* 13-Oct-2015* SuryaBalan To get multiple site names I added condition #618*/  
/*   20 Oct 2015 Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */   
/*          why:task #609, Network180 Customization  */   
/* 20/02/2016      Bernardin    NULL check added to avoid display comma (,) in client name*/  
/* 27/09/2016  Pradeep Kumar Yadav Modified the Stored Procedure for getting InsurerId For Task #1072 SWMBH-Support */
/* 10/11/2016	Chethan N		 What : Changed BillingCodes and BillingCodeModifiers to Join from left join and removed 'and' condition to get all BillingCodeModifiers without checking for Modifiers column.
								 Why: SWMBH-Support Task #893 */
/* 18/11/2016	Chethan N		 What : Get BillingCodeModifiers.Description instead BillingCodes.CodeName.
								 Why: SWMBH-Support Task #893 */
/* 15/12/2016	Chethan N		 What : Mapping ContractRate Modifiers with Billing Code Modifiers to get Associated Billing Codes Modifiers only.
								 Why: SWMBH-Support Task #1108 */
/* 02/22/2017	Munish Sood		 What: Added ISNULL conditions to check the NULL records 
								 Why: SWMBH - Support Task#1167	*/			
/* 02-March-2017 Nandita S		 What : Mapping License group id and text with contract rate id and mapping place of service id with global code id fpr place of service
								 Why: Heartland east task #6800*/	
/* 06-Sep-2017   K.Soujanya		 What : Added BillingCodeModifiers table
								 Why: Network180-Enhancements #219*/			
-- 29-Dec-2017	jcarlson		 Heartland EIT 70 - init DummyBillingCodeModifierName for searchable textbox
/* 16-feb-2018   neethu		     What :Get BillingCodeModifiers.CodeName instead BillingCodes.Description.
								 Why: SWMBH - Enhancements Task #1162 */ 
--07 Mar 2018   Vijay		     Why: LicenseTypeIdText,LicenseTypeGroupName,PlaceOfServiceIdText,PlaceOfServiceGroupName columns are added
--									  And also ContractRateLicenseTypes,ContractRatePlaceOfServices tables are added
--								 What: Heartland East - Customizations - Task#26	
-- 14 Sep 2018 Bernardin         What: Modified the BillingCodeModifier check as per List page logic. Why: There is difference between List page and Details page ssp. So the selected records are mismatching while redirecting to details page. Allegan - Support# 1457 	
-- 26 Feb 2019 Rajeshwari S      What: Added logic to get the temporary recods. Why: SWMBH - Support# 1509 		 						 
/*********************************************************************/   
BEGIN  
  
   BEGIN TRY   
   
SELECT DISTINCT CR.ContractRateId  
  ,CR.ContractId  
  ,CR.BillingCodeId  
  ,CR.Modifier1  
  ,CR.Modifier2  
  ,CR.Modifier3  
  ,CR.Modifier4  
  ,CR.SiteId  
  ,CR.ClientId  
  ,CR.StartDate  
  ,CR.EndDate  
  ,CR.ContractRate  
  ,CR.Active  
  ,CR.RequiresAffilatedProvider  
  ,CR.AllAffiliatedProviders  
  ,CR.AllSites  
  ,CR.RowIdentifier  
  ,CR.CreatedBy  
  ,CR.CreatedDate  
  ,CR.ModifiedBy  
  ,CR.ModifiedDate  
  ,CR.RecordDeleted  
  ,CR.DeletedDate  
  ,CR.DeletedBy
  ,CT.InsurerId
  ,CR.CoveragePlanGroupName  --Pranay
  ,CR.LicenseTypeGroupName 
  ,CR.PlaceOfServiceGroupName 
  ,cast(BC.Units AS CHAR(18)) + Gc.CodeName AS RateUnit  
  ,Ltrim(Rtrim(BC.BillingCode)) + CASE   
   WHEN len(ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier1], ' '))), ' ') + ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2], ' '))), ' ') + ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier3], ' '))), ' ') + ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier4], ' '))), ' ')) = 0  
    THEN ''  
   ELSE ':'  
   END + CASE   
   WHEN ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier1], ''))), '') = ''  
    THEN ' '  
   ELSE Ltrim(RTrim(Isnull(CR.[Modifier1], ' '))) + ':'  
   END + CASE   
   WHEN ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2], ''))), '') = ''  
    THEN ' '  
   ELSE Ltrim(RTrim(Isnull(CR.[Modifier2], ''))) + ':'  
   END + CASE   
   WHEN ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2], ''))), '') = ''  
    THEN ' '  
   ELSE Ltrim(RTrim(Isnull(CR.[Modifier3], ''))) + ':'  
   END + CASE   
   WHEN ISNULL(Ltrim(RTrim(Isnull(CR.[Modifier2], ''))), '') = ''  
    THEN ' '  
   ELSE Ltrim(RTrim(Isnull(CR.[Modifier4], '')))  
   END AS CodeandModifiers  
  ,Ltrim(RTrim(Isnull(BC.Codename,''))) AS BillingCodeName  --Neethu 16-feb-2018
  
  ,CASE WHEN ISNULL (cr.ClientId,0) <> 0 THEN  
        CASE WHEN ISNULL(C.ClientType, 'I') = 'I' THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')        
                   ELSE ISNULL(C.OrganizationName, '')        
                            END ELSE '' END AS 'ClientIdText'    
     
   , (SELECT STUFF((  
    SELECT ', ' + S.SiteName FROM Sites S   
     INNER JOIN ContractRateSites CRS ON S.SiteId = CRS.SiteId   
     WHERE ISNULL(S.RecordDeleted, 'N') = 'N' AND CRS.ContractRateId = CR.ContractRateId AND ISNULL(CRS.RecordDeleted, 'N') = 'N'     
    FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') )  as SiteIdText  
    
  ,'$' + convert(VARCHAR, cast(CR.ContractRate AS MONEY), 10) AS ContractRate1  
  ,Convert(VARCHAR, BM.BillingCodeId) + '_' + convert(VARCHAR, BM.BillingCodeModifierId) AS BillingCodeModifierId  
  ,convert(CHAR(10), cr.startdate, 101) AS StartDate1  
  ,convert(CHAR(10), cr.EndDate, 101) AS EndDate1 
  
 
  ,(SELECT STUFF((  
	SELECT ', ' + GC.CodeName FROM GlobalCodes GC   
	 INNER JOIN ContractRateLicenseTypes CRLT ON  GC.GlobalCodeId = CRLT.LicenseTypeId
	 WHERE ISNULL(GC.RecordDeleted, 'N') = 'N' AND CRLT.ContractRateId = CR.ContractRateId AND ISNULL(CRLT.RecordDeleted, 'N') = 'N'     
	FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') )as LicenseTypeIdText
   
  ,(SELECT STUFF((  
	SELECT ', ' + GC.CodeName FROM GlobalCodes GC   
	 INNER JOIN ContractRatePlaceOfServices CRPS ON  GC.GlobalCodeId = CRPS.PlaceOfServiceId   
	 WHERE ISNULL(GC.RecordDeleted, 'N') = 'N' AND CRPS.ContractRateId = CR.ContractRateId AND ISNULL(CRPS.RecordDeleted, 'N') = 'N'     
	FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as PlaceOfServiceIdText
    
  ,CASE WHEN  ISNULL(BM.Modifier1,'') = '' AND ISNULL(BM.Modifier2,'') = '' AND ISNULL(BM.Modifier3,'') = '' AND ISNULL(BM.Modifier4,'') = '' 
		THEN Ltrim(Rtrim(BC.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BC.CodeName,'-', ' '))) 
	WHEN ISNULL(BM.Modifier2,'') = '' AND ISNULL(BM.Modifier3,'') = '' AND ISNULL(BM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BC.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BC.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BM.Modifier1,'')))
	WHEN ISNULL(BM.Modifier3,'') = '' AND ISNULL(BM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BC.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BC.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BM.Modifier1,''))) + ' :' + Ltrim(RTrim(Isnull(BM.Modifier2,'')))
	WHEN ISNULL(BM.Modifier4,'') = ''
		THEN Ltrim(Rtrim(BC.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BC.CodeName,'-', ' '))) + ' :' + Ltrim(RTrim(Isnull(BM.Modifier1,''))) + ' :' + Ltrim(RTrim(Isnull(BM.Modifier2,''))) + ' :' + Ltrim(RTrim(Isnull(BM.Modifier3,'')))
	ELSE
		Ltrim(Rtrim(BC.BillingCode)) + ' - ' + Ltrim(Rtrim(REPLACE(BC.CodeName,'-', ' '))) + 
		+ ' :' + Ltrim(RTrim(Isnull(BM.Modifier1,''))) + ':' + Ltrim(RTrim(Isnull(BM.Modifier2,''))) + ':' + Ltrim(RTrim(Isnull(BM.Modifier3,''))) + ':' + Ltrim(RTrim(Isnull(BM.Modifier4,'')))
	END as DummyBillingCodeModifierName
 FROM ContractRates CR  
 Inner Join Contracts CT on CR.ContractId=CT.ContractId
 LEFT JOIN clients c ON cr.ClientId = c.ClientId  
 LEFT JOIN ContractRateSites CRS ON CRS.ContractRateId = CR.ContractRateId  
 LEFT JOIN Sites S ON S.SiteId = CRS.SiteId  
  AND (ISNULL(S.RecordDeleted, 'N') = 'N')  
 --LEFT JOIN Sites S ON S.SiteId = CR.SiteId    
 LEFT JOIN BillingCodes BC ON BC.BillingCodeId = CR.BillingCodeId  
 LEFT JOIN BillingCodeModifiers BM ON BC.BillingCodeId = BM.BillingCodeId 
 -- Chethan N changes 15/12/2016
 -- Munish Sood 02/22/2017
 -- Modified By Bernardin 09/14/2018
 AND (ISNULL(CR.Modifier1, '') = ISNULL(BM.Modifier1 , '') 
 AND  ISNULL(CR.Modifier2, '') = ISNULL(BM.Modifier2 , '')
 AND  ISNULL(CR.Modifier3, '') = ISNULL(BM.Modifier3 , '')  
 AND  ISNULL(CR.Modifier4, '') = ISNULL(BM.Modifier4 , ''))   
 -- Chethan N changes 15/12/2016 end here
 AND (ISNULL(BM.RecordDeleted, 'N') = 'N') 
   
  -- Chethan N changes 10/11/2016
  -- Chethan N changes 10/11/2016 end here
 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = BC.UnitType
 --LEFT JOIN GlobalCodes GCPS ON GCPS.GlobalCodeId = CR.PlaceOfServiceId AND  GCPS.Category='PCMPLACEOFSERVICE' and ISNULL(GCPS.RecordDeleted,'N')<>'Y' and GCPS.Active='Y'  
 --LEFT JOIN LicenseAndDegreeGroups LDG ON CR.LicenseAndDegreeGroupId = LDG.LicenseAndDegreeGroupId  AND (ISNULL(LDG.RecordDeleted, 'N') = 'N')  
 WHERE (ISNULL(CR.RecordDeleted, 'N') = 'N')  
  AND CR.ContractRateId = @ContractRateId  
  AND (ISNULL(GC.RecordDeleted, 'N') = 'N')  
  
 SELECT CRA.ContractRateAffiliateId  
  ,CRA.ProviderId  
  ,CRA.ContractRateId  
  ,CRA.RowIdentifier  
  ,CRA.CreatedBy  
  ,CRA.CreatedDate  
  ,CRA.ModifiedBy  
  ,CRA.ModifiedDate  
  ,CRA.RecordDeleted  
  ,CRA.DeletedDate  
  ,CRA.DeletedBy  
 FROM ContractRateAffiliates CRA  
 INNER JOIN ContractRates CR ON CRA.ContractRateId = CR.ContractRateId  
 WHERE CRA.ContractRateId = @ContractRateId  
  AND (ISNULL(CRA.RecordDeleted, 'N') = 'N')  
  AND (ISNULL(CR.RecordDeleted, 'N') = 'N')  
  
 SELECT CRS.ContractRateSiteId  
  ,CRS.CreatedBy  
  ,CRS.CreatedDate  
  ,CRS.ModifiedBy  
  ,CRS.ModifiedDate  
  ,CRS.RecordDeleted  
  ,CRS.DeletedBy  
  ,CRS.DeletedDate  
  ,CRS.ContractRateId  
  ,CRS.SiteId  
 FROM ContractRateSites CRS  
 INNER JOIN ContractRates CR ON CRS.ContractRateId = CR.ContractRateId  
 WHERE CRS.ContractRateId = @ContractRateId  
  AND (ISNULL(CRS.RecordDeleted, 'N') = 'N')  
  AND (ISNULL(CR.RecordDeleted, 'N') = 'N')  
    
-- Pranay
SELECT CRCP.ContractRateCoveragePlanId
,CRCP.CreatedBy
,CRCP.CreatedDate
,CRCP.ModifiedBy
,CRCP.ModifiedDate
,CRCP.RecordDeleted
,CRCP.DeletedBy
,CRCP.DeletedDate
,CRCP.ContractRateId
,CRCP.CoveragePlanId
FROM dbo.ContractRateCoveragePlans CRCP INNER JOIN dbo.ContractRates CR ON CRCP.ContractRateId=CR.ContractRateId
WHERE CRCP.ContractRateId=@ContractRateId
AND (ISNULL(CRCP.RecordDeleted, 'N') = 'N')  
 AND (ISNULL(CR.RecordDeleted, 'N') = 'N')  
 --K.Soujanya 09-06-2017    
	SELECT BillingCodeModifierId
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,BillingCodeId
		,Modifier1
		,Modifier2
		,Modifier3
		,Modifier4
		,[Description]
		,AllowMultipleClaimsPerDay
		,ProcedureCodeId
	from BillingCodeModifiers where 1=2
 --K.Soujanya 09-06-2017 end 
 
 --Added By Vijay
	 SELECT CRLT.ContractRateLicenseTypeId
	,CRLT.CreatedBy
	,CRLT.CreatedDate
	,CRLT.ModifiedBy
	,CRLT.ModifiedDate
	,CRLT.RecordDeleted
	,CRLT.DeletedBy
	,CRLT.DeletedDate
	,CRLT.ContractRateId
	,CRLT.LicenseTypeId
	FROM dbo.ContractRateLicenseTypes CRLT INNER JOIN dbo.ContractRates CR ON CRLT.ContractRateId=CR.ContractRateId
	WHERE CRLT.ContractRateId=@ContractRateId
	AND (ISNULL(CRLT.RecordDeleted, 'N') = 'N')  
	AND (ISNULL(CR.RecordDeleted, 'N') = 'N')  
 
 --Added By Vijay
	 SELECT CRLPS.ContractRatePlaceOfServiceId
	,CRLPS.CreatedBy
	,CRLPS.CreatedDate
	,CRLPS.ModifiedBy
	,CRLPS.ModifiedDate
	,CRLPS.RecordDeleted
	,CRLPS.DeletedBy
	,CRLPS.DeletedDate
	,CRLPS.ContractRateId
	,CRLPS.PlaceOfServiceId
	FROM dbo.ContractRatePlaceOfServices CRLPS INNER JOIN dbo.ContractRates CR ON CRLPS.ContractRateId=CR.ContractRateId
	WHERE CRLPS.ContractRateId=@ContractRateId
	AND (ISNULL(CRLPS.RecordDeleted, 'N') = 'N')  
	AND (ISNULL(CR.RecordDeleted, 'N') = 'N')
	
-----------------------------------------    
 SELECT CRCP.ContractRateCoveragePlanId      
,CRCP.CreatedBy      
,CRCP.CreatedDate      
,CRCP.ModifiedBy      
,CRCP.ModifiedDate      
,CRCP.RecordDeleted      
,CRCP.DeletedBy      
,CRCP.DeletedDate      
,CRCP.ContractRateId      
,CRCP.CoveragePlanId      
FROM dbo.ContractRateCoveragePlans CRCP INNER JOIN dbo.ContractRates CR ON CRCP.ContractRateId=CR.ContractRateId      
WHERE CRCP.ContractRateId=@ContractRateId      
AND (ISNULL(CRCP.RecordDeleted, 'N') = 'N')        
 AND (ISNULL(CR.RecordDeleted, 'N') = 'N')     
     
 SELECT CRLT.ContractRateLicenseTypeId      
 ,CRLT.CreatedBy      
 ,CRLT.CreatedDate      
 ,CRLT.ModifiedBy      
 ,CRLT.ModifiedDate      
 ,CRLT.RecordDeleted      
 ,CRLT.DeletedBy      
 ,CRLT.DeletedDate      
 ,CRLT.ContractRateId      
 ,CRLT.LicenseTypeId      
 FROM dbo.ContractRateLicenseTypes CRLT INNER JOIN dbo.ContractRates CR ON CRLT.ContractRateId=CR.ContractRateId      
 WHERE CRLT.ContractRateId=@ContractRateId      
 AND (ISNULL(CRLT.RecordDeleted, 'N') = 'N')        
 AND (ISNULL(CR.RecordDeleted, 'N') = 'N')    
     
 SELECT CRLPS.ContractRatePlaceOfServiceId      
 ,CRLPS.CreatedBy      
 ,CRLPS.CreatedDate      
 ,CRLPS.ModifiedBy      
 ,CRLPS.ModifiedDate      
 ,CRLPS.RecordDeleted      
 ,CRLPS.DeletedBy      
 ,CRLPS.DeletedDate      
 ,CRLPS.ContractRateId      
 ,CRLPS.PlaceOfServiceId      
 FROM dbo.ContractRatePlaceOfServices CRLPS INNER JOIN dbo.ContractRates CR ON CRLPS.ContractRateId=CR.ContractRateId      
 WHERE CRLPS.ContractRateId=@ContractRateId      
 AND (ISNULL(CRLPS.RecordDeleted, 'N') = 'N')        
 AND (ISNULL(CR.RecordDeleted, 'N') = 'N')     
     
 SELECT CRS.ContractRateSiteId        
  ,CRS.CreatedBy        
  ,CRS.CreatedDate        
  ,CRS.ModifiedBy        
  ,CRS.ModifiedDate        
  ,CRS.RecordDeleted        
  ,CRS.DeletedBy        
  ,CRS.DeletedDate        
  ,CRS.ContractRateId        
  ,CRS.SiteId        
 FROM ContractRateSites CRS        
 INNER JOIN ContractRates CR ON CRS.ContractRateId = CR.ContractRateId        
 WHERE CRS.ContractRateId = @ContractRateId        
  AND (ISNULL(CRS.RecordDeleted, 'N') = 'N')        
  AND (ISNULL(CR.RecordDeleted, 'N') = 'N')    
    
  SELECT CRA.ContractRateAffiliateId        
  ,CRA.ProviderId        
  ,CRA.ContractRateId        
  ,CRA.RowIdentifier        
  ,CRA.CreatedBy        
  ,CRA.CreatedDate        
  ,CRA.ModifiedBy        
  ,CRA.ModifiedDate        
  ,CRA.RecordDeleted        
  ,CRA.DeletedDate        
  ,CRA.DeletedBy        
 FROM ContractRateAffiliates CRA        
 INNER JOIN ContractRates CR ON CRA.ContractRateId = CR.ContractRateId        
 WHERE CRA.ContractRateId = @ContractRateId        
  AND (ISNULL(CRA.RecordDeleted, 'N') = 'N')        
  AND (ISNULL(CR.RecordDeleted, 'N') = 'N')     
      
         
 ---------------------------------------------------    
	
 END TRY   
   
 --Checking For Errors     
 BEGIN CATCH    
          DECLARE @error VARCHAR(8000)    
    
          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'    
                      + CONVERT(VARCHAR(4000), Error_message())    
                      + '*****'    
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),    
                      ' ssp_CMGetContractRatesDetail ')    
                      + '*****' + CONVERT(VARCHAR, Error_line())    
                      + '*****' + CONVERT(VARCHAR, Error_severity())    
                      + '*****' + CONVERT(VARCHAR, Error_state())    
    
          RAISERROR (@error,-- Message text.    
                     16,-- Severity.    
                     1 -- State.    
          );    
      END CATCH    
  
END
GO


