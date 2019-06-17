
/****** Object:  View [dbo].[ViewProviderSearchClaims]    Script Date: 03/09/2016 14:14:31 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewProviderSearchClaims]'))
DROP VIEW [dbo].[ViewProviderSearchClaims]
GO

/****** Object:  View [dbo].[ViewProviderSearchClaims]    Script Date: 03/09/2016 14:14:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


------------------------------------------------------------
--Modified : Shruthi.S
--Date     : 11/11/2014
--Purpose  : Changed SiteId in ViewProviderId field.Ref : #124 Care Management to SmartCare Env. Issues Tracking
------------------------------------------------------------
--	Updates
--	Date		Author			Purpose
------------------------------------------------------------
--	09.Mar.2015	Rohith Uppin	Site active check added.
--  09.Mar.2016 praorane		Moved the record delete checks to join from the where clause. SWMBH - Support 870.
------------------------------------------------------------

CREATE VIEW [dbo].[ViewProviderSearchClaims]
AS
	SELECT TOP 100 PERCENT 'N'                                                                          AS RadioButton
	,                      dbo.providers.ProviderId                                                     AS ID
	,                      Case dbo.providers.ProviderType When 'I' then dbo.providers.ProviderName + ', ' + dbo.providers.FirstName
	                                                       When 'F' then dbo.providers.ProviderName End as ProviderName
	,                      dbo.Sites.SiteName                                                          
	,                      dbo.Sites.TaxID                                                             
	,                      case dbo.Sites.TaxIDType when 'E' then 'EIN'
	                                                when 'S' then 'SSN' end                             as TaxIDType
	,                      dbo.Providers.ProviderId                                                    
	,                      dbo.Sites.PlaceOfService                                                    
	,                      dbo.SiteAddressess.[Address]                                                
	,                      dbo.Sites.SiteId                                                            
	FROM            dbo.Providers     
	INNER JOIN      dbo.Sites          ON dbo.Providers.ProviderId = dbo.Sites.ProviderId
			AND (ISNULL(dbo.Sites.RecordDeleted, 'N') = 'N')
	left OUTER JOIN dbo.SiteAddressess ON dbo.Sites.SiteId = dbo.SiteAddressess.SiteId and IsNull(dbo.SiteAddressess.Billing,'N')='Y'
			AND (ISNULL(dbo.SiteAddressess.RecordDeleted, 'N') = 'N')
	WHERE (dbo.Providers.Active = 'Y')
		AND (dbo.Sites.Active = 'Y')
		AND (ISNULL(dbo.Providers.RecordDeleted, 'N') = 'N')
	ORDER BY dbo.Providers.ProviderName




GO


