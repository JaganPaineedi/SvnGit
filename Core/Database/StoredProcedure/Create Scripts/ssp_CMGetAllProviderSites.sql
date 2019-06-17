IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetAllProviderSites]') AND type IN (N'P',N'PC'))
	DROP PROCEDURE [dbo].[ssp_CMGetAllProviderSites]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[ssp_CMGetAllProviderSites]    
    
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_CMGetAllProviderSites]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			  Author				Purpose 
-- 21-Oct-2015   Arjun K R			Task #604 Network180 Customizations.
*********************************************************************************/                     
AS    
    
SELECT distinct P.ProviderID,
CASE WHEN ISNULL(S.SiteName, '') = '' THEN RTRIM(p.ProviderName)      
 ELSE RTRIM(P.ProviderName) + ' - ' + LTRIM(S.SiteName)      
 END  AS ProviderName,
 S.SiteName, 
S.Taxid,
S.SiteId 
FROM Providers P  Left outer join Sites S ON      
P.providerID = S.ProviderID WHERE  ISNULL(P.RecordDeleted,'N') = 'N' AND ISNULL(S.RecordDeleted,'N') = 'N'  AND P.active = 'Y'    
AND S.Active = 'Y'    
    
    
    
IF @@ERROR <> 0    
BEGIN    
 RAISERROR  50020  'ssp_CMGetAllProviderSites: An Error Occured'      
 RETURN    
END    
    
RETURN 