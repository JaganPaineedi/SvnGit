IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetProviderSites]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetProviderSites] 
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetProviderSites] @LoggedInStaff INT
AS
----------------------------------------------------------------------  
-- Stored Procedure: ssp_SCGetProviderSites  550
-- Copyright: 2010  Streamline Healthcare Solutions  
--  
-- Purpose: Retuns a list of Providers / Sites  
--  
-- History  
-- Date			Author      Purpose  
-- 05-02-2016	Neelima	  Created for Provider/Site Dropdown based on staffid
--						  Core Bugs #2014
-- 04-27-2016   Shankha   Added UNION ALL to support All Providers based on staffid (Core Bugs 2265)
-- 08-30-2016   Kiran     Added AND s.Active = 'Y'  to ingore inactive sites
-- 02-Feb-2018  Arjun K R  Modified to return "All Sites" if a provider have more than one site. Task #3 SWMBH Enhancement.
-- 30-April-2018 Arjun K R Modified to return "All Sites" on top of all other sites.Task #3 SWMBH Enhancement.
----------------------------------------------------------------------  
BEGIN
	BEGIN TRY
	
	CREATE TABLE #ProviderSites(ProviderId int,ProviderIdSiteId varchar(max),ProviderName varchar(max)) --30-April-2018 Arjun K R
	INSERT INTO #ProviderSites(ProviderId,ProviderIdSiteId,ProviderName)   --30-April-2018 Arjun K R
		SELECT p.ProviderId
			,Rtrim(p.ProviderId) + '_0' AS ProviderIdSiteId
			,Rtrim(p.ProviderName) + ' - ' + 'All Sites' AS ProviderName
		FROM Providers p
		INNER JOIN StaffProviders SP ON SP.ProviderId = p.ProviderId
		INNER JOIN Staff ST ON st.StaffId = sp.StaffId
		LEFT JOIN Sites s ON p.ProviderID = s.ProviderID
			AND NOT EXISTS (
				SELECT 1
				FROM Agency a
				WHERE a.TaxId = s.TaxID
				)
			AND s.SiteName IS NOT NULL
			AND s.Active = 'Y'
		WHERE p.Active = 'Y'
			AND Isnull(s.RecordDeleted, 'N') = 'N'
			AND Isnull(p.RecordDeleted, 'N') = 'N'
			AND Isnull(SP.RecordDeleted, 'N') = 'N'
			AND Isnull(ST.RecordDeleted, 'N') = 'N'
			AND ST.StaffId = @LoggedInStaff
			AND (
				SELECT COUNT(*)
				FROM Sites ss
				WHERE p.ProviderID = ss.ProviderID
					AND Isnull(ss.RecordDeleted, 'N') = 'N'
				AND NOT EXISTS (
				SELECT 1
				FROM Agency a
				WHERE a.TaxId = ss.TaxID
				)
			AND ss.SiteName IS NOT NULL
			AND ss.Active = 'Y'	
				) > 1
		
		UNION
		
		SELECT p.ProviderId
			,CASE 
				WHEN Isnull(s.SiteId, '') = ''
					THEN Rtrim(p.ProviderId) + '_0'
				ELSE Rtrim(p.ProviderId) + '_' + Ltrim(s.SiteId)
				END AS ProviderIdSiteId
			,CASE 
				WHEN Isnull(s.SiteName, '') = ''
					THEN Rtrim(p.ProviderName)
				ELSE Rtrim(p.ProviderName) + ' - ' + Ltrim(s.SiteName)
				END + CASE 
				WHEN (
						SELECT Value
						FROM SystemConfigurationKeys
						WHERE [Key] = 'ShowSiteIdAfterSiteName'
						) = 'Y'
					THEN ' (' + ISNULL(CAST(s.SiteId AS VARCHAR(10)), '') + ')'
				ELSE ''
				END AS ProviderName
		FROM Providers p
		INNER JOIN StaffProviders SP ON SP.ProviderId = p.ProviderId
		INNER JOIN Staff ST ON st.StaffId = sp.StaffId
		LEFT JOIN Sites s ON p.ProviderID = s.ProviderID
			AND NOT EXISTS (
				SELECT 1
				FROM Agency a
				WHERE a.TaxId = s.TaxID
				)
			AND s.SiteName IS NOT NULL
			AND s.Active = 'Y'
		WHERE p.Active = 'Y'
			AND Isnull(s.RecordDeleted, 'N') = 'N'
			AND Isnull(p.RecordDeleted, 'N') = 'N'
			AND Isnull(SP.RecordDeleted, 'N') = 'N'
			AND Isnull(ST.RecordDeleted, 'N') = 'N'
			AND ST.StaffId = @LoggedInStaff
		
		UNION
		
		SELECT p.ProviderId
			,Rtrim(p.ProviderId) + '_0' AS ProviderIdSiteId
			,Rtrim(p.ProviderName) + ' - ' + 'All Sites' AS ProviderName
		FROM Providers p
		INNER JOIN Sites s ON p.ProviderID = s.ProviderID
			AND NOT EXISTS (
				SELECT 1
				FROM Agency a
				WHERE a.TaxId = s.TaxID
				)
			AND s.SiteName IS NOT NULL
			AND s.Active = 'Y'
		WHERE p.Active = 'Y'
			AND Isnull(p.RecordDeleted, 'N') = 'N'
			AND Isnull(s.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT 1
				FROM Staff st
				WHERE st.StaffId = @LoggedInStaff
					AND Isnull(st.AllProviders, 'N') = 'Y'
				)
			AND (
				SELECT COUNT(*)
				FROM Sites ss
				WHERE p.ProviderID = ss.ProviderID
					AND Isnull(ss.RecordDeleted, 'N') = 'N'
					AND NOT EXISTS (
				SELECT 1
				FROM Agency a
				WHERE a.TaxId = ss.TaxID
				)
			AND ss.SiteName IS NOT NULL
			AND ss.Active = 'Y'
			AND EXISTS (
				SELECT 1
				FROM Staff st
				WHERE st.StaffId = @LoggedInStaff
					AND Isnull(st.AllProviders, 'N') = 'Y'
				)
				) > 1
		
		UNION
		
		SELECT p.ProviderId
			,CASE 
				WHEN Isnull(s.SiteId, '') = ''
					THEN Rtrim(p.ProviderId) + '_0'
				ELSE Rtrim(p.ProviderId) + '_' + Ltrim(s.SiteId)
				END AS ProviderIdSiteId
			,CASE 
				WHEN Isnull(s.SiteName, '') = ''
					THEN Rtrim(p.ProviderName)
				ELSE Rtrim(p.ProviderName) + ' - ' + Ltrim(s.SiteName)
				END + CASE 
				WHEN (
						SELECT Value
						FROM SystemConfigurationKeys
						WHERE [Key] = 'ShowSiteIdAfterSiteName'
						) = 'Y'
					THEN ' (' + ISNULL(CAST(s.SiteId AS VARCHAR(10)), '') + ')'
				ELSE ''
				END AS ProviderName
		FROM Providers p
		INNER JOIN Sites s ON p.ProviderID = s.ProviderID
			AND NOT EXISTS (
				SELECT 1
				FROM Agency a
				WHERE a.TaxId = s.TaxID
				)
			AND s.SiteName IS NOT NULL
			AND s.Active = 'Y'
		WHERE p.Active = 'Y'
			AND Isnull(p.RecordDeleted, 'N') = 'N'
			AND Isnull(s.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT 1
				FROM Staff st
				WHERE st.StaffId = @LoggedInStaff
					AND Isnull(st.AllProviders, 'N') = 'Y'
		)
		
		--30-April-2018 Arjun K R
		SELECT ProviderId,ProviderIdSiteId,ProviderName FROM #ProviderSites
		ORDER BY REPLACE(ProviderName,'All','AAA')
    END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetProviderSites') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


