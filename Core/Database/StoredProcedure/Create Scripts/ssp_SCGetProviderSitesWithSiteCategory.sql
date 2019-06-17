IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetProviderSitesWithSiteCategory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetProviderSitesWithSiteCategory]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[ssp_SCGetProviderSitesWithSiteCategory] 
		@LoggedInStaff INT
		,@SiteCategory INT
AS
----------------------------------------------------------------------  
-- Stored Procedure: ssp_SCGetProviderSitesWithSiteCategory
-- Copyright: 2017  Streamline Healthcare Solutions  
--  
-- Purpose: Retuns a list of Providers / Sites  filtered by a disposition
--  
-- History  
-- Date			Author      Purpose  
-- 16/02/2017	Schaefer	created for Network 180 Support Go Live #48
-- 13/06/2017	Schaefer	modified for change in data model to use SitesCategory
-- 06-Feb-2018  Arjun K R   Modified to return "All Sites" if a provider have more than one site. Task #3 SWMBH Enhancement.
-- 25-July-2018  K.Soujanya    Modified Sp to return "All Sites" if provider has more than one site when system configuration key value = Yes. Task #3 SWMBH Enhancement.                                             
----------------------------------------------------------------------  
BEGIN
	BEGIN TRY
	-- START 25-July-2018  K.Soujanya.
	DECLARE @AllSitesConfigurationKey VARCHAR(10)
    SELECT @AllSitesConfigurationKey = Value from SystemConfigurationKeys where [Key]='ShowAllSitesOptionInSitesDropDown'
    -- END 25-July-2018  K.Soujanya .
		CREATE TABLE #ProviderSites
		(
			ProviderId INT
			,ProviderIdSiteId VARCHAR(30)
			,ProviderName VARCHAR(MAX)
		)

		INSERT INTO #ProviderSites EXEC ssp_SCGetProviderSites @LoggedInStaff

		--SELECT * FROM #ProviderSites

		DECLARE @SitesInCategory TABLE
		(
			SiteId INT
		)
		INSERT INTO @SitesInCategory
		SELECT CAST(RIGHT(PS.ProviderIdSiteId, LEN(PS.ProviderIdSiteId) - CHARINDEX('_', PS.ProviderIdSiteId)) AS INT)
		FROM #ProviderSites PS
			LEFT JOIN SiteCategories SC ON SC.SiteId = CAST(RIGHT(PS.ProviderIdSiteId, LEN(PS.ProviderIdSiteId) - CHARINDEX('_', PS.ProviderIdSiteId)) AS INT)
		WHERE ISNULL(SC.RecordDeleted, 'N') = 'N'
			AND (SC.CategoryId = @SiteCategory
				OR @SiteCategory = -1)

		--SELECT * FROM @SitesInCategory

		-- markm: added DISTINCT below 2017-08-03
		SELECT DISTINCT PS.*
		FROM #ProviderSites PS
			INNER JOIN @SitesInCategory SIC ON SIC.SiteId = CAST(RIGHT(PS.ProviderIdSiteId, LEN(PS.ProviderIdSiteId) - CHARINDEX('_', PS.ProviderIdSiteId)) AS INT)
		
		---- 06-Feb-2018  Arjun K R.
		UNION 
			 SELECT DISTINCT PS1.*
			  FROM #ProviderSites PS1
			  WHERE PS1.ProviderIdSiteId=LEFT(PS1.ProviderIdSiteId,CHARINDEX('_',PS1.ProviderIdSiteId)-1) +'_0'
			  AND @AllSitesConfigurationKey = 'Yes'
			  AND (SELECT COUNT(PS.ProviderId)
			  FROM #ProviderSites PS
			   INNER JOIN @SitesInCategory SIC ON SIC.SiteId = CAST(RIGHT(PS.ProviderIdSiteId, LEN(PS.ProviderIdSiteId) - CHARINDEX('_', PS.ProviderIdSiteId)) AS INT)
			   WHERE PS.ProviderId=PS1.ProviderId
			   )>1
		
		ORDER BY PS.ProviderName
		
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetProviderSitesWithSiteCategory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
GO