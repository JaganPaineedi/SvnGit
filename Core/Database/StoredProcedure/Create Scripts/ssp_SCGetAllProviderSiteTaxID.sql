 IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllProviderSiteTaxID]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetAllProviderSiteTaxID]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[ssp_SCGetAllProviderSiteTaxID]    
    
/********************************************************************************    
-- Stored Procedure: dbo.[ssp_SCGetAllProviderSiteTaxID]      
--  
-- Copyright: Streamline Healthcate Solutions 
--    
-- Created:           
-- Date			Author				Purpose 
  17-Aug-2015   SuryaBalan				What:Used in Authorizations Default Detail Page
									Why:task Network 180 - Customizations #602 - Authorization process - ability to set defaults based on auth code  
*********************************************************************************/                     
as    
    
select 
P.ProviderID,
Case When Isnull(S.SiteName, '') = '' Then Rtrim(p.ProviderName)      
 Else Rtrim(P.ProviderName) + ' - ' + Ltrim(S.SiteName)      
 End  As ProviderName,
 S.SiteName,
 --P.ProviderName, 
S.Taxid ,
S.SiteId

from Providers P  Left outer join Sites S on      
P.providerID = S.ProviderID where  isNull(P.RecordDeleted,'N') = 'N' and isNull(S.RecordDeleted,'N') = 'N'  and P.active = 'Y'    
and S.Active = 'Y'    
    
    
    
if @@error <> 0    
begin    
 raiserror  50020  'ssp_CMProviderTaxID: An Error Occured'    
 return    
end    
    
    
return 