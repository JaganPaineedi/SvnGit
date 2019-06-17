IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetModularDefinitionNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetModularDefinitionNames]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCGetModularDefinitionNames                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by 'Manage Roles & Modules' Details.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 21.SEP.2017	 Akwinass        Created(Engineering Improvement Initiatives- NBL(I) #561 .       
*********************************************************************************/
CREATE PROCEDURE [dbo].[ssp_SCGetModularDefinitionNames] @ManageModuleScreenIds VARCHAR(MAX)
	,@RoleId INT
	,@Mode VARCHAR(20) = NULL
AS
BEGIN
	BEGIN TRY
		DECLARE @AllSelected CHAR(1) = 'N'
		IF OBJECT_ID('tempdb..#ManageModuleScreens') IS NOT NULL
			DROP TABLE #ManageModuleScreens			
		CREATE TABLE #ManageModuleScreens(ManageModuleScreenId INT)
		IF OBJECT_ID('tempdb..#ManageModuleScreenDetails') IS NOT NULL
			DROP TABLE #ManageModuleScreenDetails			
		CREATE TABLE #ManageModuleScreenDetails(ManageModuleScreenId INT,ScreenId INT, BannerId INT)
		
		IF EXISTS (
					SELECT item
					FROM dbo.fnSplit(@ManageModuleScreenIds, ',')
					WHERE item = 'allselected'
					)
		BEGIN
			SET @AllSelected = 'Y'
		END
		ELSE
		BEGIN
			INSERT INTO #ManageModuleScreens (ManageModuleScreenId)
			SELECT CAST(item AS INT)
			FROM dbo.fnSplit(@ManageModuleScreenIds, ',')
			WHERE ISNULL(item, '') <> ''
		END
		
		INSERT INTO #ManageModuleScreenDetails(ManageModuleScreenId,ScreenId, BannerId)
		SELECT MSD.ManageModuleScreenId
			,MSD.ScreenId
			,B.BannerId
		FROM ManageModuleScreens MS
		JOIN ManageModuleScreenDetails MSD ON MS.ManageModuleScreenId = MSD.ManageModuleScreenId
			AND ISNULL(MS.RecordDeleted, 'N') = 'N'
			AND ISNULL(MSD.RecordDeleted, 'N') = 'N'
		JOIN Screens S ON MSD.ScreenId = S.ScreenId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		LEFT JOIN Banners B ON B.ScreenId = MSD.ScreenId
			AND ISNULL(B.RecordDeleted, 'N') = 'N'
			AND ISNULL(B.Active, 'N') = 'Y'
		WHERE EXISTS(SELECT 1 FROM #ManageModuleScreens TMS WHERE TMS.ManageModuleScreenId = MS.ManageModuleScreenId) OR @AllSelected = 'Y'
		ORDER BY MS.ModuleScreenName ASC
		
		--;WITH Banners_cte (BannerId,ParentBannerId,ManageModuleScreenId,ScreenId)
		--AS (
		--	SELECT B.BannerId
		--		,B.ParentBannerId
		--		,MSD.ManageModuleScreenId
		--		,MSD.ScreenId
		--	FROM Banners AS B
		--	JOIN #ManageModuleScreenDetails MSD ON MSD.BannerId = B.BannerId
			
		--	UNION ALL
			
		--	SELECT BA.BannerId
		--		,BA.ParentBannerId
		--		,BA1.ManageModuleScreenId
		--		,BA1.ScreenId
		--	FROM Banners AS BA
		--	INNER JOIN Banners_cte AS BA1 ON BA1.ParentBannerId = BA.BannerId
		--	WHERE (ISNULL(BA.RecordDeleted, 'N') = 'N' AND ISNULL(BA.Active, 'Y') = 'Y')
		--	)
		--INSERT INTO #ManageModuleScreenDetails(ManageModuleScreenId,ScreenId, BannerId)
		--SELECT CTE.ManageModuleScreenId,CTE.ScreenId, CTE.BannerId
		--FROM Banners_cte CTE
		--WHERE NOT EXISTS(SELECT 1 FROM #ManageModuleScreenDetails MSD WHERE MSD.BannerId = CTE.BannerId)
		
		IF @Mode = 'MODULENAMES'
		BEGIN
			SELECT MS.ManageModuleScreenId
				,MS.CreatedBy
				,MS.CreatedDate
				,MS.ModifiedBy
				,MS.ModifiedDate
				,MS.RecordDeleted
				,MS.DeletedBy
				,MS.DeletedDate
				,MS.ModuleScreenName
			FROM ManageModuleScreens MS
			WHERE ISNULL(MS.RecordDeleted, 'N') = 'N'
			AND (EXISTS(SELECT 1 FROM #ManageModuleScreens TMS WHERE TMS.ManageModuleScreenId = MS.ManageModuleScreenId) OR @AllSelected = 'Y')
			
			SELECT ManageModuleScreenId,ScreenId, BannerId FROM #ManageModuleScreenDetails
		END
		ELSE IF @Mode = 'MODULEDETAILS'
		BEGIN
			SELECT MSD.ScreenId
				,S.ScreenName
				,S.TabId AS ScreenTabId
				,B.BannerId
				,MSD.ManageModuleScreenId
			FROM ManageModuleScreens MS
			JOIN ManageModuleScreenDetails MSD ON MS.ManageModuleScreenId = MSD.ManageModuleScreenId
				AND ISNULL(MS.RecordDeleted, 'N') = 'N'
				AND ISNULL(MSD.RecordDeleted, 'N') = 'N'
			JOIN Screens S ON MSD.ScreenId = S.ScreenId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			LEFT JOIN Banners B ON B.ScreenId = MSD.ScreenId
				AND ISNULL(B.RecordDeleted, 'N') = 'N'
				AND ISNULL(B.Active, 'N') = 'Y'
			WHERE EXISTS(SELECT 1 FROM #ManageModuleScreens TMS WHERE TMS.ManageModuleScreenId = MS.ManageModuleScreenId)
			ORDER BY MS.ModuleScreenName ASC

			SELECT TabId
				,TabName
				,DisplayAs
				,[Dynamic]
				,TabOrder
				,DefaultScreenId
			FROM Tabs
			WHERE ISNULL(RecordDeleted, 'N') = 'N'
		END

		
		IF OBJECT_ID('tempdb..#ModularPermissionItems') IS NOT NULL
			DROP TABLE #ModularPermissionItems

		CREATE TABLE #ModularPermissionItems (
			PermissionTemplateType INT
			,PermissionTemplateTypeName VARCHAR(500)
			,PermissionItemId INT
			,PermissionItemName VARCHAR(500)
			,ParentId INT
			,ParentName VARCHAR(500)
			,Denied CHAR(1)
			,Granted CHAR(1)
			,PermissionTemplateItemId INT
			,PermissionTemplateId INT
			,				
			)
	
		INSERT INTO #ModularPermissionItems 
		(PermissionTemplateType
		,PermissionTemplateTypeName
		,PermissionItemId
		,PermissionItemName
		,ParentId
		,ParentName			
		)
		SELECT gc.GlobalCodeId
			,REPLACE(gc.CodeName,'&','') AS PermissionTemplateTypeName
			,s.ScreenId
			,REPLACE(s.ScreenName,'&','')  AS PermissionItemName
			,t.TabId
			,REPLACE(t.TabName,'&','') AS ParentName
		FROM Screens s
		INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5921
		INNER JOIN Tabs t ON t.TabId = s.TabId AND S.ScreenType <> 5763
		WHERE isnull(S.RecordDeleted, 'N') = 'N'
			AND isnull(t.RecordDeleted, 'N') = 'N'
			AND NOT EXISTS (SELECT ScreenId FROM Banners b WHERE isnull(b.RecordDeleted, 'N') = 'N' AND b.ScreenId = s.ScreenId)
			AND EXISTS(SELECT 1 FROM #ManageModuleScreenDetails TMSD WHERE TMSD.ScreenId = s.ScreenId)				
		UNION ALL			
		SELECT gc.GlobalCodeId AS PermissionTemplateType
			,REPLACE(gc.CodeName,'&','') AS PermissionTemplateTypeName
			,spc.ScreenPermissionControlId AS PermissionItemId
			,REPLACE(spc.DisplayAs,'&','') AS PermissionItemName
			,s.ScreenId AS ParentId
			,REPLACE(s.ScreenName,'&','') AS ParentName
		FROM ScreenPermissionControls spc
		INNER JOIN Screens s ON s.ScreenId = spc.ScreenId
		INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5701
		WHERE isnull(s.RecordDeleted, 'N') = 'N'
			AND isnull(spc.RecordDeleted, 'N') = 'N'
			AND EXISTS(SELECT 1 FROM #ManageModuleScreenDetails TMSD WHERE TMSD.ScreenId = s.ScreenId)
		UNION ALL		
		SELECT gc.GlobalCodeId AS PermissionTemplateType
			,REPLACE(gc.CodeName,'&','') AS PermissionTemplateTypeName
			,spc.ScreenPermissionControlId AS PermissionItemId
			,REPLACE(spc.DisplayAs,'&','') AS PermissionItemName
			,s.ScreenId AS ParentId
			,REPLACE(s.ScreenName,'&','') AS ParentName
		FROM ScreenPermissionControls spc
		INNER JOIN Screens s ON s.ScreenId = spc.ScreenId
		INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5920
		WHERE isnull(s.RecordDeleted, 'N') = 'N'
			AND isnull(spc.RecordDeleted, 'N') = 'N'
			AND EXISTS(SELECT 1 FROM #ManageModuleScreenDetails TMSD WHERE TMSD.ScreenId = s.ScreenId)
		UNION ALL
		SELECT gc.GlobalCodeId  AS PermissionTemplateType
			,REPLACE(gc.CodeName,'&','')  AS PermissionTemplateTypeName
			,b.BannerId  AS PermissionItemId
			,CASE WHEN b.BannerName = b.DisplayAs THEN REPLACE(b.BannerName,'&','') ELSE REPLACE(b.BannerName,'&','') + ' (' + REPLACE(b.DisplayAs,'&','') + ')' END  AS ParentName
			,t.TabId  AS ParentId
			,REPLACE(t.TabName,'&','') AS ParentName
		FROM Banners b
		INNER JOIN Tabs t ON t.TabId = b.TabId
		INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = 5703
		WHERE ISNULL(b.Active,'N') = 'Y'
			AND isnull(b.RecordDeleted, 'N') = 'N'
			AND isnull(t.RecordDeleted, 'N') = 'N'
			AND EXISTS(SELECT 1 FROM #ManageModuleScreenDetails TMSD WHERE TMSD.BannerId = b.BannerId)
			
			
		UPDATE #ModularPermissionItems
		SET Granted = 'N', Denied = 'Y'		
		
		UPDATE pit
		SET Granted = 'Y'
			,Denied = 'N'
			,PermissionTemplateItemId = pti.PermissionTemplateItemId
			,PermissionTemplateId = pt.PermissionTemplateId
		FROM #ModularPermissionItems pit
		JOIN PermissionTemplates pt ON pt.PermissionTemplateType = pit.PermissionTemplateType
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
			AND pti.PermissionItemId = pit.PermissionItemId
		WHERE pt.RoleId = @RoleId
			AND isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'N'
			
		UPDATE pit
		SET PermissionTemplateId = pt.PermissionTemplateId
		FROM #ModularPermissionItems pit
		JOIN PermissionTemplates pt ON pt.PermissionTemplateType = pit.PermissionTemplateType
		WHERE pt.RoleId = @RoleId
			AND pit.PermissionTemplateId IS NULL
			AND isnull(pt.RecordDeleted, 'N') = 'N'	
			
		SELECT PermissionTemplateType
			,PermissionTemplateTypeName
			,PermissionItemId
			,PermissionItemName
			,ParentId
			,ParentName
			,Denied
			,Granted
			,PermissionTemplateItemId
			,PermissionTemplateId
		FROM #ModularPermissionItems
		WHERE PermissionTemplateType = 5921
		
		SELECT PermissionTemplateType
			,PermissionTemplateTypeName
			,PermissionItemId
			,PermissionItemName
			,ParentId
			,ParentName
			,Denied
			,Granted
			,PermissionTemplateItemId
			,PermissionTemplateId
		FROM #ModularPermissionItems
		WHERE PermissionTemplateType = 5701
		
		SELECT PermissionTemplateType
			,PermissionTemplateTypeName
			,PermissionItemId
			,PermissionItemName
			,ParentId
			,ParentName
			,Denied
			,Granted
			,PermissionTemplateItemId
			,PermissionTemplateId
		FROM #ModularPermissionItems
		WHERE PermissionTemplateType = 5920
		
		SELECT PermissionTemplateType
			,PermissionTemplateTypeName
			,PermissionItemId
			,PermissionItemName
			,ParentId
			,ParentName
			,Denied
			,Granted
			,PermissionTemplateItemId
			,PermissionTemplateId
		FROM #ModularPermissionItems
		WHERE PermissionTemplateType = 5703
		
		IF @Mode = 'MODULEDETAILS'
		BEGIN
			IF OBJECT_ID('tempdb..#ModularBanners') IS NOT NULL
				DROP TABLE #ModularBanners	
			CREATE TABLE #ModularBanners(ScreenId INT,DisplayAs VARCHAR(100), BannerId INT,ScreenName VARCHAR(100),TabName VARCHAR(30),ScreenTabId INT,BannerTabId INT,ManageModuleScreenId INT,ParentBannerId INT)
			
			INSERT INTO #ModularBanners(ScreenId,DisplayAs,BannerId,ScreenName,TabName,ScreenTabId,BannerTabId,ManageModuleScreenId,ParentBannerId)
			SELECT MSD.ScreenId
				,B.DisplayAs
				,B.BannerId
				,S.ScreenName
				,T.DisplayAs AS TabName
				,S.TabId AS ScreenTabId
				,B.TabId AS BannerTabId
				,MSD.ManageModuleScreenId
				,B.ParentBannerId
			FROM ManageModuleScreens MS
			JOIN ManageModuleScreenDetails MSD ON MS.ManageModuleScreenId = MSD.ManageModuleScreenId
				AND ISNULL(MS.RecordDeleted, 'N') = 'N'
				AND ISNULL(MSD.RecordDeleted, 'N') = 'N'
			JOIN Screens S ON MSD.ScreenId = S.ScreenId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			JOIN Banners B ON B.ScreenId = S.ScreenId
				AND ISNULL(B.RecordDeleted, 'N') = 'N'
				AND ISNULL(B.Active, 'N') = 'Y'
			JOIN Tabs T ON T.TabId = B.TabId
				AND ISNULL(T.RecordDeleted, 'N') = 'N'
			WHERE EXISTS (SELECT 1 FROM #ManageModuleScreens TMS WHERE TMS.ManageModuleScreenId = MS.ManageModuleScreenId)
			ORDER BY B.DisplayAs ASC
			
			--;WITH ModularBanners_cte (
			--	ScreenId
			--	,DisplayAs
			--	,BannerId
			--	,ScreenName
			--	,TabName
			--	,ScreenTabId
			--	,BannerTabId
			--	,ManageModuleScreenId
			--	,ParentBannerId
			--	)
			--AS (
			--	SELECT ScreenId
			--		,DisplayAs
			--		,BannerId
			--		,ScreenName
			--		,TabName
			--		,ScreenTabId
			--		,BannerTabId
			--		,ManageModuleScreenId
			--		,ParentBannerId
			--	FROM #ModularBanners
				
			--	UNION ALL
				
			--	SELECT BA.ScreenId
			--		,BA.DisplayAs
			--		,BA.BannerId
			--		,NULL AS ScreenName
			--		,NULL AS TabName
			--		,NULL AS ScreenTabId
			--		,BA.TabId AS BannerTabId
			--		,BA1.ManageModuleScreenId
			--		,BA.ParentBannerId
			--	FROM Banners AS BA
			--	INNER JOIN ModularBanners_cte AS BA1 ON BA1.ParentBannerId = BA.BannerId				
			--	WHERE (ISNULL(BA.RecordDeleted, 'N') = 'N' AND ISNULL(BA.Active, 'Y') = 'Y')
			--	)			
			SELECT CTE.ScreenId
				,CTE.DisplayAs
				,CTE.BannerId
				,ISNULL(CTE.ScreenName,S.ScreenName) AS ScreenName
				,ISNULL(CTE.TabName,T1.TabName) AS TabName
				,ISNULL(CTE.ScreenTabId,S.TabId) AS ScreenTabId
				,CTE.BannerTabId
				,CTE.ManageModuleScreenId
				,CTE.ParentBannerId
			FROM #ModularBanners CTE
			LEFT JOIN Screens S ON S.ScreenId = CTE.ScreenId
			LEFT JOIN Tabs T1 ON T1.TabId = CTE.BannerTabId AND ISNULL(T1.RecordDeleted, 'N') = 'N'
		END
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCGetModularDefinitionNames') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO


