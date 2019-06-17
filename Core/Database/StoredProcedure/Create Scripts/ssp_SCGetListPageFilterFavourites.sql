IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetListPageFilterFavourites]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetListPageFilterFavourites]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_SCGetListPageFilterFavourites] (
	@ScreenId INT
	,@StaffId INT	
	,@ScreenType INT = NULL
	,@ReportId INT = NULL
	)
AS
/******************************************************************************                                               
  **  File: [ssp_SCGetListPageFilterFavourites]                                           
  **  Name: [ssp_SCGetListPageFilterFavourites]                      
  **  Desc:     
  **  Return values:                                           
  **  Called by:                                                
  **  Parameters:                           
  **  Auth:  Malathi shiva 
  **  Date:  23/Feb/2015                                          
  *******************************************************************************                                               
  **  Change History                                               
  *******************************************************************************                                               
  **  Date:       Author:       Description:                             
  **  12-OCT-2017 Akwinass      What: Modified code to support Details & Documents page.
								Why: Task#554 in Engineering Improvement Initiatives- NBL(I).
  **  18-JAN-2018 Akwinass      What: Added @ReportId and Modified code to get report favorites.
								Why: Task#554.1 in Engineering Improvement Initiatives- NBL(I).
  **  -------------------------------------------------------------------------             
   
  *******************************************************************************/
BEGIN
	BEGIN TRY
		IF ISNULL(@ScreenType,0) = 5763 OR ISNULL(@ScreenType,0) = 5761
		BEGIN
			SELECT SFT.StaffScreenFilterFavoriteId
				,SFT.FilterName
				,SFT.StaffId
				,SFT.ScreenId
				,SFT.ClientId
				,'{"QuickScreenType" : "' + CAST(S.ScreenType AS VARCHAR(250)) + '","QuickScreenId" : "' + CAST(S.ScreenId AS VARCHAR(250)) + '","DefaultFilters" : "' + CASE WHEN SFT.ClientId IS NULL THEN 'ScreenFilterFavorites=Y^StaffScreenFilterFavoriteId=' + CAST(SFT.StaffScreenFilterFavoriteId AS VARCHAR(250)) ELSE 'ScreenFilterFavorites=Y^ClientId='+CAST(SFT.ClientId AS VARCHAR(250))+'^StaffScreenFilterFavoriteId=' + CAST(SFT.StaffScreenFilterFavoriteId AS VARCHAR(250)) END + '","QuickTabId" : "' + CAST(S.TabId AS VARCHAR(250)) + '","ScreenTabIndex" : "","PageAction" : "new"}' AS FiltersXML
				,SFT.CreatedBy
				,SFT.CreatedDate
				,SFT.ModifiedBy
				,SFT.ModifiedDate
				,SFT.RecordDeleted
				,SFT.DeletedDate
				,SFT.DeletedBy
			FROM StaffScreenFilterFavorites SFT
			JOIN Screens S ON SFT.ScreenId = S.ScreenId
			WHERE SFT.ScreenId = @ScreenId
				AND SFT.STaffId = @StaffId				
				AND ISNULL(SFT.RecordDeleted, 'N') = 'N'
			ORDER BY FilterName ASC
		END
		ELSE IF ISNULL(@ReportId,0) > 0
		BEGIN
			SELECT SFT.StaffScreenFilterFavoriteId
				,SFT.FilterName
				,SFT.StaffId
				,SFT.ScreenId
				,SFT.ClientId
				,SFT.FiltersXML
				,SFT.CreatedBy
				,SFT.CreatedDate
				,SFT.ModifiedBy
				,SFT.ModifiedDate
				,SFT.RecordDeleted
				,SFT.DeletedDate
				,SFT.DeletedBy
			FROM StaffScreenFilterFavorites SFT
			WHERE SFT.ReportId = @ReportId
				AND SFT.STaffId = @StaffId
				AND ISNULL(SFT.RecordDeleted, 'N') = 'N'
			ORDER BY FilterName ASC
		END
		ELSE
		BEGIN
			SELECT SFT.StaffScreenFilterFavoriteId
				,SFT.FilterName
				,SFT.StaffId
				,SFT.ScreenId
				,SFT.ClientId
				,SFT.FiltersXML
				,SFT.CreatedBy
				,SFT.CreatedDate
				,SFT.ModifiedBy
				,SFT.ModifiedDate
				,SFT.RecordDeleted
				,SFT.DeletedDate
				,SFT.DeletedBy
			FROM StaffScreenFilterFavorites SFT
			WHERE SFT.ScreenId = @ScreenId
				AND SFT.STaffId = @StaffId
				AND ISNULL(SFT.RecordDeleted, 'N') = 'N'
			ORDER BY FilterName ASC
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetListPageFilterFavourites]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                           
				16
				,
				-- Severity.                                                                                           
				1
				-- State.                                                                                           
				);
	END CATCH
END


GO


