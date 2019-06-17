 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAuthorizationDefaults]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetAuthorizationDefaults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 CREATE  Procedure [dbo].[ssp_GetAuthorizationDefaults]            
(                    
@ProviderAuthorizationDefaultId int                    
)                    
As   
 Begin   
 Begin TRY     
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_GetAuthorizationDefaults]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author				Purpose 
  17-Aug-2015   SuryaBalan				What:Used in Authorizations Default Detail Page
									Why:task Network 180 - Customizations #602 - Authorization process - ability to set defaults based on auth code  
  9-Sept-2015   SuryaBalan			Added New Column BillingCodeModifierId in ProviderAuthorizationDefaultBillingCodes Table
									Network 180 - Customizations #602 
  27-Oct-2015   SuryaBalan			ADDED ISNULL( B.Active, 'Y') = 'Y', it should take null values of Active column also
									Network 180 Environment Issues Tracking #602.2
  			
 									
*********************************************************************************/                    
SELECT ProviderAuthorizationDefaultId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		StartDate,
		EndDate,
		InternalExternal,
		Active,
		DefaultByCodeAndTotalUnits,
		Units,
		Frequency,
		Duration,
		DurationEntry,
		TotalUnits,
		AllProviderSites,
		AllBillingCodes,
		AllAuthorizationCodes
FROM  ProviderAuthorizationDefaults B   
 
WHERE B.ProviderAuthorizationDefaultId=@ProviderAuthorizationDefaultId          
AND   ISNULL(B.RecordDeleted, 'N') = 'N'  

SELECT  
    ADPS.ProviderAuthorizationDefaultProviderSiteId
	,ADPS.CreatedBy
	,ADPS.CreatedDate
	,ADPS.ModifiedBy
	,ADPS.ModifiedDate
	,ADPS.RecordDeleted
	,ADPS.DeletedBy
	,ADPS.DeletedDate
	,ADPS.ProviderAuthorizationDefaultId
	,ADPS.ProviderId
	,ADPS.SiteId 
	,STUFF(COALESCE('- ' + RTRIM(P.ProviderName), '') + COALESCE(' - ' + RTRIM(S.SiteName), ''), 1, 2, '') AS ProviderName
	,S.SiteName
	,S.TaxID
    
 FROM  
  ProviderAuthorizationDefaultProviderSites ADPS
   Left JOIN Providers P ON ADPS.ProviderId= P.ProviderId AND ISNULL(P.RecordDeleted, 'N') = 'N'   
  left JOIN Sites S ON ADPS.SiteId= S.SiteId AND ISNULL(S.RecordDeleted, 'N') = 'N'   
 WHERE  
  ADPS.ProviderAuthorizationDefaultId = @ProviderAuthorizationDefaultId AND  
  ISNULL(ADPS.RecordDeleted, 'N') = 'N' --AND
  
  
  SELECT  
     ADBC.ProviderAuthorizationDefaultBillingCodeId
	,ADBC.CreatedBy
	,ADBC.CreatedDate
	,ADBC.ModifiedBy
	,ADBC.ModifiedDate
	,ADBC.RecordDeleted
	,ADBC.DeletedBy
	,ADBC.DeletedDate
	,ADBC.ProviderAuthorizationDefaultId
	,ADBC.BillingCodeId
	,B.BillingCode
	,BCM.BillingCodeModifierId
	--,B.[BillingCode]+ ':' +BCM.[Modifier1]+ ' ' +BCM.[Modifier2]+ ' ' +BCM.[Modifier3]+ ' ' +BCM.[Modifier4] as BillingCodeAndModifier
	,BCM.[Description] as BillingCodeAndModifier  
 
    
 FROM  
  ProviderAuthorizationDefaultBillingCodes ADBC 
  LEFT JOIN BillingCodes B ON ADBC.BillingCodeId= B.BillingCodeId 
  LEFT JOIN BillingCodeModifiers BCM on ADBC.BillingCodeModifierId=BCM.BillingCodeModifierId
  
 WHERE  
  ADBC.ProviderAuthorizationDefaultId = @ProviderAuthorizationDefaultId AND  
  ISNULL(ADBC.RecordDeleted, 'N') = 'N' AND  
  ISNULL(B.RecordDeleted, 'N') = 'N'  AND ISNULL( B.Active, 'Y') = 'Y' AND
  ISNULL(BCM.RecordDeleted, 'N') = 'N'  and BCM.[Description] is not null
  
  SELECT  
      ADAC.ProviderAuthorizationDefaultAuthorizationCodeId
		,ADAC.CreatedBy
		,ADAC.CreatedDate
		,ADAC.ModifiedBy
		,ADAC.ModifiedDate
		,ADAC.RecordDeleted
		,ADAC.DeletedBy
		,ADAC.DeletedDate
		,ADAC.ProviderAuthorizationDefaultId
		,ADAC.AuthorizationCodeId
		,A.AuthorizationCodeName
		,A.DisplayAs
    
 FROM  
  ProviderAuthorizationDefaultAuthorizationCodes ADAC 
  LEFT JOIN AuthorizationCodes A ON ADAC.AuthorizationCodeId= A.AuthorizationCodeId  
  
 WHERE  
  ADAC.ProviderAuthorizationDefaultId = @ProviderAuthorizationDefaultId AND  
  ISNULL(ADAC.RecordDeleted, 'N') = 'N' AND  
  ISNULL(A.RecordDeleted, 'N') = 'N'  
  

        
           
--Checking For Errors            
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetAuthorizationDefaults')                                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                                                                           
 (                                                                             
  @Error, -- Message text.                                                                                                          
  16, -- Severity.                                                                                                          
  1 -- State.                                                                                                          
 );                                                                                                        
END CATCH                                                       
END   