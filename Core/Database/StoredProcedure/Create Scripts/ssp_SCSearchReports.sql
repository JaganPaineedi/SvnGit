/****** Object:  StoredProcedure [dbo].[ssp_SCSearchReports]    Script Date: 10/12/2017 14:57:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSearchReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSearchReports]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSearchReports]    Script Date: 10/12/2017 14:57:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[ssp_SCSearchReports]	
	@StaffId INT	
	/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCSearchReports                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by 'Go' box.                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 27.JUNE.2017	 Akwinass        Copied ssp_ListPageReports and Modified for Search(Engineering Improvement Initiatives- NBL(I) #536).
-- 12.OCT.2017	 Akwinass        Modified code to get favorites (Engineering Improvement Initiatives- NBL(I) #554). 
-- 18.JAN.2018	 Akwinass        Modified code to get report favorites (Engineering Improvement Initiatives- NBL(I) #554.1).
-- 02-04-2018    Vkumar	         Modified code to include the template from StaffPermissionExceptions table based on the Permission template type and permission which is allowed .
								Removed join condition with template and checking for template exist condition added .As part of 	Philhaven-Support -325 .
-- 08.MAY.2018	 Akwinass        Included Order & Order Set Query (Engineering Improvement Initiatives- NBL(I) #650).
-- 12.Jul.2018	 Chethan N		What : Retrieving LocationId.
								Why : Engineering Improvement Initiatives- NBL(I)  task #667.   
-- 31-October 2018 Ponnin		What : SET @BannerId as NULL before setting the new BannerId to the @BannerId variable and deleting the records from temp table #ResultSet only if ScreenId is null. Why: Proviso - Support #105
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#StaffBanners') IS NOT NULL
			DROP TABLE #StaffBanners
			
		IF OBJECT_ID('tempdb..#PermittedBanners') IS NOT NULL
			DROP TABLE #PermittedBanners
			
		IF OBJECT_ID('tempdb..#Templates') IS NOT NULL
			DROP TABLE #Templates
			
		IF OBJECT_ID('tempdb..#ResultSet') IS NOT NULL
			DROP TABLE #ResultSet
			
		CREATE TABLE #PermittedBanners (BannerId INT)
		CREATE TABLE #StaffBanners (BannerOrder INT identity NOT NULL,BannerId INT,BannerName VARCHAR(100),DisplayAs VARCHAR(100),TabId INT,ParentBannerId INT,ScreenId INT,ScreenType INT,Custom CHAR(1),ScreenParameters VARCHAR(max))
		CREATE TABLE #Templates (TemplateName VARCHAR(250))

		INSERT INTO #PermittedBanners (BannerId)
		SELECT vsp.PermissionItemId
		FROM ViewStaffPermissions vsp
		WHERE vsp.StaffId = @StaffId
			AND vsp.PermissionTemplateType = 5703

		
		INSERT INTO #StaffBanners (
			BannerId
			,BannerName
			,DisplayAs
			,TabId
			,ParentBannerId
			,ScreenId
			,ScreenType
			,Custom
			,ScreenParameters
			)
		SELECT b.BannerId
			,b.BannerName
			,b.DisplayAs
			,b.TabId
			,b.ParentBannerId
			,b.ScreenId
			,s.ScreenType
			,b.Custom
			,b.ScreenParameters
		FROM Banners AS b
		JOIN #PermittedBanners pb ON pb.BannerId = b.BannerId
		LEFT JOIN Screens s ON s.ScreenId = b.ScreenId
		LEFT JOIN DocumentCodes dc ON dc.DocumentCodeId = s.DocumentCodeId
		WHERE b.Active = 'Y'
			AND (dc.Active = 'Y' OR dc.DocumentCodeId IS NULL)
			AND isnull(b.RecordDeleted, 'N') = 'N'
			AND (dc.DocumentCodeId IS NULL OR EXISTS (SELECT 1 FROM ViewStaffPermissions pd WHERE pd.StaffId = @StaffId AND pd.PermissionItemId = dc.DocumentCodeId AND pd.PermissionTemplateType IN (5702,5924) AND pd.PermissionItemId IS NOT NULL))
		ORDER BY b.TabId
			,b.ParentBannerId
			,b.DefaultOrder
			,b.DisplayAs
		
		INSERT INTO #Templates(TemplateName)
		SELECT DISTINCT GC1.Code
		FROM PermissionTemplates pt 
		JOIN PermissionTemplateItems pti ON pti.PermissionTemplateId = pt.PermissionTemplateId
		JOIN GlobalCodes GC1 ON pti.PermissionItemId = GC1.GlobalCodeId AND GC1.Category = 'ACTIONTEMPLATES'
		WHERE isnull(pt.RecordDeleted, 'N') = 'N'
			AND isnull(pti.RecordDeleted, 'N') = 'N'
			AND pt.PermissionTemplateType = 5927
			AND EXISTS(SELECT 1 FROM StaffRoles SR WHERE SR.RoleId = pt.RoleId AND SR.StaffId = @StaffId AND ISNULL(RecordDeleted,'N') = 'N')
	
--Vkumar Changes 	Philhaven-Support-325
		INSERT INTO #Templates(TemplateName)	
		SELECT GC1.Code
		FROM StaffPermissionExceptions SPE
		JOIN GlobalCodes GC1 ON SPE.PermissionItemId = GC1.GlobalCodeId
			AND GC1.Category = 'ACTIONTEMPLATES'
		WHERE SPE.PermissionTemplateType = 5927
			AND SPE.StaffId = @StaffId
			AND SPE.Allow = 'Y'
			AND ISNULL(SPE.RecordDeleted,'N') = 'N'
			AND ISNULL(GC1.RecordDeleted,'N') = 'N'
			AND NOT EXISTS(SELECT 1 FROM #Templates T WHERE T.TemplateName = GC1.Code)

		DELETE
		FROM #Templates
		WHERE TemplateName IN (
				SELECT GC1.Code
				FROM StaffPermissionExceptions SPE
				JOIN GlobalCodes GC1 ON SPE.PermissionItemId = GC1.GlobalCodeId
					AND GC1.Category = 'ACTIONTEMPLATES'
				WHERE SPE.PermissionTemplateType = 5927
					AND SPE.StaffId = @StaffId
					AND SPE.Allow = 'N'
					AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
					AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
				)
		--------- 
		DECLARE @AssociatedWith INT
		DECLARE @DetailScreenId INT
		DECLARE @BannerId INT		
		
		CREATE TABLE #ResultSet (
			BannerId INT NOT NULL IDENTITY (-1, -1)
			,BannerName VARCHAR(max)
			,DisplayAs VARCHAR(max)
			,TabId INT
			,ParentBannerId INT
			,ScreenId INT
			,ScreenType INT
			,Custom CHAR(1)
			,ScreenParameters VARCHAR(max)
			,ReportId INT
			,ReportServerId INT
			,DetailScreenId INT
			,ReportName VARCHAR(max)
			,ReportServerPath VARCHAR(max)
			,QuickScreenType INT
			,QuickScreenId INT
			,QuickScreenName VARCHAR(max)
			,QuickTabId INT
			,BannerScreen VARCHAR(max)
			,SortOrder INT
			,DefaultFilters VARCHAR(MAX)
			,PageAction VARCHAR(20)
			,ScreenTabIndex INT
			,SearchType CHAR(1)
			)

		CREATE TABLE #Reports (
			ParentFolderId INT
			,ParentFolderName VARCHAR(max)
			,ParentFolderIDs VARCHAR(max)
			,ReportId INT
			,ReportName VARCHAR(260)
			)
			-- Get report item catalog    
			;

		WITH ReportCatalog (
			ParentFolderId
			,ParentFolderName
			,ParentFolderIDs
			,ReportId
			,ReportName
			)
		AS (
			-- Anchor definition    
			SELECT r.ParentFolderId AS ParentFolderId
				,CONVERT(VARCHAR(max), '') AS ParentFolderName
				,CONVERT(VARCHAR(max), '.0.') AS ParentFolderIDs
				,r.ReportId AS ReportId
				,r.NAME AS ReportName
			FROM Reports r
			WHERE r.ParentFolderId IS NULL
				AND ISNULL(r.RecordDeleted, 'N') = 'N'
			
			UNION ALL
			
			-- Recursive definition    
			SELECT r.ParentFolderId
				,rc.ParentFolderName + CASE 
					WHEN LEN(rc.ParentFolderName) > 0
						THEN '\'
					ELSE ''
					END + rc.ReportName
				,rc.ParentFolderIDs + ISNULL(CONVERT(VARCHAR, rc.ReportId), '') + '.'
				,r.ReportId
				,r.NAME
			FROM Reports r
			JOIN ReportCatalog rc ON rc.ReportId = r.ParentFolderId
			WHERE ISNULL(r.RecordDeleted, 'N') = 'N'
			)
		INSERT INTO #Reports (
			ParentFolderId
			,ParentFolderName
			,ParentFolderIDs
			,ReportId
			,ReportName
			)
		SELECT rc.ParentFolderId
			,rc.ParentFolderName
			,ParentFolderIDs
			,rc.ReportId
			,rc.ReportName + CASE WHEN r.IsFolder = 'Y' THEN ' (Folder)' ELSE '' END AS ReportName
		FROM ReportCatalog rc
		JOIN Reports r ON r.ReportId = rc.ReportId

		
		SET @AssociatedWith = 0
		SET @DetailScreenId = 130
		SELECT TOP 1 @BannerId = BannerId
		FROM Banners
		WHERE ScreenId = 107
			AND ISNULL(Active, 'N') = 'Y'
			AND ISNULL(RecordDeleted, 'N') = 'N'
	
		INSERT INTO #ResultSet (
			ReportId
			,ReportServerId
			,DetailScreenId
			,ReportName			
			,ReportServerPath
			,SearchType
			)
		SELECT r.ReportId
			,ISNULL(r.ReportServerId, 0)
			,@DetailScreenId AS DetailScreenId
			,rc.ReportName			
			,r.ReportServerPath
			,'R'
		FROM Reports r
		JOIN #Reports rc ON rc.ReportId = r.ReportId
		WHERE (@DetailScreenId = 108 OR EXISTS (SELECT * FROM ViewStaffPermissions vsp WHERE vsp.StaffId = @StaffId AND vsp.PermissionItemId = r.ReportId AND vsp.PermissionTemplateType = 5907))
			AND (@DetailScreenId = 108 OR ISNULL(r.IsFolder, 'N') = 'N')
			AND ((ISNULL(@AssociatedWith, 0) = 0 OR r.AssociatedWith = @AssociatedWith))
			
		UPDATE TmpRr
		SET TmpRr.BannerName = b.BannerName
			,TmpRr.DisplayAs = b.DisplayAs
			,TmpRr.TabId = b.TabId
			,TmpRr.ParentBannerId = b.ParentBannerId
			,TmpRr.ScreenId = b.ScreenId
			,TmpRr.ScreenType = s.ScreenType
			,TmpRr.Custom = b.Custom
			,TmpRr.ScreenParameters = b.ScreenParameters
		FROM #ResultSet TmpRr
		LEFT JOIN Banners AS b ON B.BannerId = @BannerId
		LEFT JOIN Screens s ON s.ScreenId = b.ScreenId
		WHERE TmpRr.DetailScreenId = 130
	
	
	
		SET @AssociatedWith = 5831
		SET @DetailScreenId = 111
	
	    -- SET @BannerId as NULL before setting the new BannerId to the @BannerId variable.
		SET @BannerId = NULL

		SELECT TOP 1   @BannerId =	BannerId
		FROM Banners
		WHERE ScreenId = 109
			AND ISNULL(Active, 'N') = 'Y'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		INSERT INTO #ResultSet (
			ReportId
			,ReportServerId
			,DetailScreenId
			,ReportName			
			,ReportServerPath
			,SearchType
			)
		SELECT r.ReportId
			,ISNULL(r.ReportServerId, 0)
			,@DetailScreenId AS DetailScreenId
			,rc.ReportName			
			,r.ReportServerPath
			,'R'
		FROM Reports r
		JOIN #Reports rc ON rc.ReportId = r.ReportId
		WHERE (@DetailScreenId = 108 OR EXISTS (SELECT * FROM ViewStaffPermissions vsp WHERE vsp.StaffId = @StaffId AND vsp.PermissionItemId = r.ReportId AND vsp.PermissionTemplateType = 5907))
			AND (@DetailScreenId = 108 OR ISNULL(r.IsFolder, 'N') = 'N')
			AND ((ISNULL(@AssociatedWith, 0) = 0 OR r.AssociatedWith = @AssociatedWith))
			
		UPDATE TmpRr
		SET TmpRr.BannerName = b.BannerName
			,TmpRr.DisplayAs = b.DisplayAs
			,TmpRr.TabId = b.TabId
			,TmpRr.ParentBannerId = b.ParentBannerId
			,TmpRr.ScreenId = b.ScreenId
			,TmpRr.ScreenType = s.ScreenType
			,TmpRr.Custom = b.Custom
			,TmpRr.ScreenParameters = b.ScreenParameters
		FROM #ResultSet TmpRr
		LEFT JOIN Banners AS b ON B.BannerId = @BannerId
		LEFT JOIN Screens s ON s.ScreenId = b.ScreenId
		WHERE TmpRr.DetailScreenId = 111

		-- Deleting the records from temp table #ResultSet only if ScreenId is null
		DELETE from #ResultSet where ScreenId is null
		
		INSERT INTO #ResultSet(QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,SortOrder,SearchType)
		SELECT DISTINCT s.ScreenType,SQ.ScreenId,S.ScreenName,B.TabId,(T.DisplayAs + ' - ' +  S.ScreenName),SQ.SortOrder,'S'
		FROM StaffQuickActions SQ
		INNER JOIN Screens S ON S.ScreenId = SQ.ScreenId
		INNER JOIN Banners B ON S.ScreenId = B.ScreenId
		INNER JOIN Tabs T ON B.TabId = T.TabId
		WHERE SQ.StaffID = @StaffId
			AND ISNULL(SQ.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(B.RecordDeleted, 'N') = 'N'
			AND ISNULL(T.RecordDeleted, 'N') = 'N'
			AND B.TabId <> 2
		
		INSERT INTO #ResultSet(DisplayAs,TabId,QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,DefaultFilters,SearchType,PageAction)	
		SELECT DISTINCT SCFF.FilterName,S.TabId,s.ScreenType,SCFF.ScreenId,SCFF.FilterName,S.TabId,SCFF.FilterName,'ScreenFilterFavorites=Y^StaffScreenFilterFavoriteId=' + CAST(SCFF.StaffScreenFilterFavoriteId AS VARCHAR(250)),'F','new'
		FROM StaffScreenFilterFavorites SCFF
		INNER JOIN Screens S ON SCFF.ScreenId = S.ScreenId
		LEFT JOIN Clients C ON SCFF.ClientId = C.ClientId
		WHERE SCFF.StaffID = @StaffId
			AND ISNULL(SCFF.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND (S.ScreenType = 5763 OR S.ScreenType = 5761)
			
		INSERT INTO #ResultSet(DisplayAs,TabId,QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,DefaultFilters,SearchType,PageAction)	
		SELECT DISTINCT SCFF.FilterName,S.TabId,s.ScreenType,SCFF.ScreenId,SCFF.FilterName,S.TabId,SCFF.FilterName,'filterValues=' + CAST(FiltersXML AS VARCHAR(MAX)),'F',NULL
		FROM StaffScreenFilterFavorites SCFF
		INNER JOIN Screens S ON SCFF.ScreenId = S.ScreenId
		LEFT JOIN Clients C ON SCFF.ClientId = C.ClientId
		WHERE SCFF.StaffID = @StaffId
			AND ISNULL(SCFF.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND S.ScreenType <> 5763 AND S.ScreenType <> 5761
			AND EXISTS(SELECT 1 FROM #StaffBanners SB WHERE SB.ScreenId = S.ScreenId)
			
		IF OBJECT_ID('tempdb..#ReportFavorites') IS NOT NULL
			DROP TABLE #ReportFavorites	
		CREATE TABLE #ReportFavorites (BannerId INT NOT NULL IDENTITY (-1, -1),BannerName VARCHAR(max),DisplayAs VARCHAR(max),TabId INT,ParentBannerId INT,ScreenId INT,ScreenType INT,Custom CHAR(1),ScreenParameters VARCHAR(max),ReportId INT,ReportServerId INT,DetailScreenId INT,ReportName VARCHAR(max),ReportServerPath VARCHAR(max),QuickScreenType INT,QuickScreenId INT,QuickScreenName VARCHAR(max),QuickTabId INT,BannerScreen VARCHAR(max),SortOrder INT,DefaultFilters VARCHAR(MAX),PageAction VARCHAR(20),ScreenTabIndex INT,SearchType CHAR(1))
			
		INSERT INTO #ReportFavorites(BannerName,DisplayAs,TabId,ParentBannerId,ScreenId,ScreenType,Custom,ScreenParameters,ReportId,ReportServerId,DetailScreenId,ReportName,ReportServerPath,QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,SortOrder,DefaultFilters,PageAction,ScreenTabIndex,SearchType)
		SELECT DISTINCT rc.BannerName,SCFF.FilterName,rc.TabId,rc.ParentBannerId,rc.ScreenId,rc.ScreenType,rc.Custom,rc.ScreenParameters,rc.ReportId,rc.ReportServerId,rc.DetailScreenId,rc.ReportName,rc.ReportServerPath,rc.ScreenType,rc.ScreenId,SCFF.FilterName,rc.TabId,SCFF.FilterName,rc.SortOrder,'reportFilterValues=' + CAST(SCFF.FiltersXML AS VARCHAR(MAX)),NULL,rc.ScreenTabIndex,'F'
		FROM StaffScreenFilterFavorites SCFF
		LEFT JOIN #ResultSet rc ON SCFF.ReportId = rc.ReportId
		WHERE ISNULL(SCFF.RecordDeleted, 'N') = 'N' AND SCFF.ReportId IS NOT NULL
		
		INSERT INTO #ResultSet(BannerName,DisplayAs,TabId,ParentBannerId,ScreenId,ScreenType,Custom,ScreenParameters,ReportId,ReportServerId,DetailScreenId,ReportName,ReportServerPath,QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,SortOrder,DefaultFilters,PageAction,ScreenTabIndex,SearchType)
		SELECT DISTINCT BannerName,DisplayAs,TabId,ParentBannerId,ScreenId,ScreenType,Custom,ScreenParameters,ReportId,ReportServerId,DetailScreenId,ReportName,ReportServerPath,QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,SortOrder,DefaultFilters,PageAction,ScreenTabIndex,SearchType FROM #ReportFavorites
			
		;WITH cteActions
		AS (
			SELECT DISTINCT S.ScreenName
				,@StaffId AS StaffId
				,S.ScreenId
				,s.ScreenType
				,S.TabId
				,S.CreatedBy
				,S.CreatedDate
				,S.ModifiedBy
				,S.ModifiedDate
				,S.RecordDeleted
				,S.DeletedDate
				,S.DeletedBy
				,PATI.ItemName AS DisplayAs
				,PATI.DefaultFilters
				,PATI.PageAction
				,PATI.ScreenTabIndex
				,PATI.SortOrder
				,ROW_NUMBER() OVER (PARTITION BY PATI.ItemName ORDER BY PATI.PreferredActionTemplateItemId) AS RowNumber
			FROM PreferredActionTemplateItems PATI						
			JOIN PreferredActionTemplates PAT ON PATI.PreferredActionTemplateId = PAT.PreferredActionTemplateId	
			--JOIN #Templates Tem ON PAT.TemplateName = Tem.TemplateName
			JOIN Screens S ON PATI.AssociatedScreenId = S.ScreenId	
			WHERE ISNULL(PATI.RecordDeleted, 'N') = 'N'				
				AND ISNULL(PAT.RecordDeleted, 'N') = 'N'				
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(PATI.AssociatedScreenId, 0) > 0	
				AND (EXISTS(SELECT 1 FROM #Templates Tem WHERE Tem.TemplateName = PAT.TemplateName) )--Vkumar changes 	Philhaven-Support 325			
				AND (EXISTS(SELECT 1 FROM #StaffBanners SB WHERE SB.ScreenId = PATI.ListPageScreenId) OR EXISTS(SELECT 1 FROM #StaffBanners SB WHERE SB.ScreenId = PATI.AssociatedScreenId))
			)
		INSERT INTO #ResultSet (QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,SortOrder,DefaultFilters,PageAction,SearchType,ScreenTabIndex)
		SELECT ScreenType,ScreenId,DisplayAs,TabId,ScreenName,SortOrder,DefaultFilters,PageAction,'A',ScreenTabIndex
		FROM cteActions
		WHERE RowNumber = 1
		ORDER BY DisplayAs ASC
		
		-- 08.MAY.2018	 Akwinass 
		IF EXISTS (
				SELECT b.BannerId
				FROM Banners AS b
				JOIN #PermittedBanners pb ON pb.BannerId = b.BannerId
				JOIN Screens s ON s.ScreenId = b.ScreenId
				JOIN DocumentCodes dc ON dc.DocumentCodeId = s.DocumentCodeId
				WHERE b.Active = 'Y'
					AND (dc.Active = 'Y')
					AND s.ScreenId = 1333
					AND isnull(b.RecordDeleted, 'N') = 'N'
					AND (EXISTS (
							SELECT 1
							FROM ViewStaffPermissions pd
							WHERE pd.StaffId = @StaffId
								AND pd.PermissionItemId = dc.DocumentCodeId
								AND pd.PermissionTemplateType IN (5702,5924)
								AND pd.PermissionItemId IS NOT NULL
							)
						)
				)
		BEGIN
			INSERT INTO #ResultSet (DisplayAs,TabId,QuickScreenType,QuickScreenId,QuickScreenName,QuickTabId,BannerScreen,SortOrder,DefaultFilters,PageAction,SearchType,ScreenTabIndex)
			SELECT  O.OrderName,S.TabId,S.ScreenType,S.ScreenId,O.OrderName,S.TabId,O.OrderName,0,'OrderFilter='+ (Cast(O.OrderId AS VARCHAR(10)) + '$' + CAST(O.OrderType AS VARCHAR(10)) + '$N$' + CAST(ISNULL(O.LocationId, - 1) AS VARCHAR(10))),NULL,'O',NULL
			FROM Orders O
			LEFT OUTER JOIN Screens S ON isnull(S.RecordDeleted, 'N') = 'N' AND S.ScreenId = 1333
			WHERE ISNULL(O.RecordDeleted, 'N') = 'N'
				AND O.EMNoteOrder = 'Y'
			UNION
			SELECT DISTINCT OS.DisplayName + ' (Order Set)',S.TabId,S.ScreenType,S.ScreenId,OS.DisplayName + ' (Order Set)',S.TabId,OS.DisplayName + ' (Order Set)',0,'OrderFilter='+ (Cast(OS.OrderSetId AS VARCHAR(10)) + '$0000$Y'),NULL,'O',NULL
			FROM OrderSets OS
			JOIN OrderSetAttributes OSA ON OSA.OrderSetId = OS.OrderSetId
				AND ISNULL(OS.RecordDeleted, 'N') = 'N'
				AND ISNULL(OSA.RecordDeleted, 'N') = 'N'
			JOIN Orders O ON O.OrderId = OSA.OrderId
			LEFT OUTER JOIN Screens S ON isnull(S.RecordDeleted, 'N') = 'N' AND S.ScreenId = 1333
			WHERE ISNULL(OS.RecordDeleted, 'N') = 'N'
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
				AND O.EMNoteOrder = 'Y'  
		END
		--
		
		
		;WITH cteBanners
		AS (
			SELECT DISTINCT B.DisplayAs
				,PCBI.BannerId
				,ROW_NUMBER() OVER (PARTITION BY B.DisplayAs ORDER BY PCBI.PreferredClientBannerItemId) AS RowNumber
			FROM PreferredClientBannerItems PCBI						
			JOIN PreferredActionTemplates PAT ON PCBI.PreferredActionTemplateId = PAT.PreferredActionTemplateId				
			--JOIN #Templates Tem ON PAT.TemplateName = Tem.TemplateName
			JOIN Banners B ON B.BannerId = PCBI.BannerId
			WHERE ISNULL(PCBI.RecordDeleted, 'N') = 'N'				
				AND ISNULL(PAT.RecordDeleted, 'N') = 'N'	
				AND (EXISTS(SELECT 1 FROM #Templates Tem WHERE Tem.TemplateName = PAT.TemplateName))--Vkumar changes 	Philhaven-Support 325		
				AND EXISTS(SELECT 1 FROM #StaffBanners SB WHERE SB.BannerId = PCBI.BannerId)			
			)
		SELECT TOP 10 BannerId
		FROM cteBanners
		WHERE RowNumber = 1
		ORDER BY DisplayAs
		
		SELECT DISTINCT BannerId
			,BannerName
			,DisplayAs
			,TabId
			,ParentBannerId
			,ScreenId
			,ScreenType
			,Custom
			,ScreenParameters
			,ReportId
			,ReportServerId
			,DetailScreenId AS ReportScreenId
			,ReportName
			,ReportServerPath
			,QuickScreenType
			,QuickScreenId
			,QuickScreenName
			,QuickTabId
			,SearchType
			,BannerScreen
			,SortOrder
			,DefaultFilters
			,ScreenTabIndex
			,PageAction			
		FROM #ResultSet
		
		SELECT [ClientPopUpConfirmationId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[StaffId]
		FROM [ClientPopUpConfirmations]
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND StaffId = @StaffId
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCSearchReports') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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


