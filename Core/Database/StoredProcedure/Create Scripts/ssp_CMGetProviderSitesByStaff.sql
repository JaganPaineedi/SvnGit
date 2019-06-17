/****** Object:  StoredProcedure [dbo].[ssp_CMGetAllProviderSites]    Script Date: 01/22/2016 13:05:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetProviderSitesByStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetProviderSitesByStaff]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetAllProviderSites]    Script Date: 01/22/2016 13:05:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_CMGetProviderSitesByStaff] --550   
( 
	@LoggedInUserId INT  
)
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_CMGetAllProviderSites]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			  Author				Purpose 
-- 22-Jan-2016   Arjun K R			Task #604.11 Network 180 Environment Issues Tracking.
*********************************************************************************/                     
AS    
    
DECLARE @AllProviders CHAR(1)
SET  @AllProviders = (SELECT TOP 1 AllProviders FROM Staff WHERE Staffid=@LoggedInUserId)
    
IF (@AllProviders='Y')
	BEGIN
		SELECT distinct P.ProviderID,
		  CASE WHEN ISNULL(S.SiteName, '') = '' THEN RTRIM(p.ProviderName)      
		  ELSE RTRIM(P.ProviderName) + ' - ' + LTRIM(S.SiteName)      
		  END  AS ProviderName,
		  S.SiteName, 
		  S.Taxid,
		  S.SiteId 
		FROM Providers P  
		Left outer join Sites S ON P.providerID = S.ProviderID 
		WHERE ISNULL(P.RecordDeleted,'N') = 'N' 
		AND ISNULL(S.RecordDeleted,'N') = 'N'  
		AND P.active = 'Y'    
		AND S.Active = 'Y'  	
	END
ELSE
	BEGIN  
		SELECT distinct P.ProviderID,
		  CASE WHEN ISNULL(S.SiteName, '') = '' THEN RTRIM(p.ProviderName)      
		  ELSE RTRIM(P.ProviderName) + ' - ' + LTRIM(S.SiteName)      
		  END  AS ProviderName,
			 S.SiteName, 
			 S.Taxid,
			 S.SiteId 
			FROM Providers P  
			INNER JOIN StaffProviders UP On UP.ProviderId=P.ProviderId    
			Left outer join Sites S ON P.providerID = S.ProviderID 
			WHERE ISNULL(P.RecordDeleted,'N') = 'N' 
			AND ISNULL(S.RecordDeleted,'N') = 'N'  
			AND ISNULL(UP.RecordDeleted,'N')='N'
			AND P.active = 'Y'    
			AND S.Active = 'Y'  
			AND UP.StaffId=@LoggedInUserId  
END
    
    
    
IF @@ERROR <> 0    
BEGIN    
 RAISERROR  50020  'ssp_CMGetProviderSitesByStaff: An Error Occured'      
 RETURN    
END    
    
RETURN 
GO


