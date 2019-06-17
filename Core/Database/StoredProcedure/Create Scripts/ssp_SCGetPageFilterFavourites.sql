IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPageFilterFavourites]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPageFilterFavourites]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetPageFilterFavourites] (
	@StaffScreenFilterFavoriteId INT
	)
AS
/******************************************************************************
  **  Name: [ssp_SCGetPageFilterFavourites]                      
  **  Desc:     
  **  Return values:                                           
  **  Called by:                                                
  **  Parameters:                           
  **  Auth:  Akwinass
  **  Date:  14/July/2017                                          
  *******************************************************************************                                               
  **  Change History                                               
  *******************************************************************************                                               
  **  Date:       Author:       Description:                             
  **   
  **  -------------------------------------------------------------------------             
   
  *******************************************************************************/
BEGIN
	BEGIN TRY
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
		WHERE SFT.StaffScreenFilterFavoriteId = @StaffScreenFilterFavoriteId
			AND ISNULL(SFT.RecordDeleted, 'N') = 'N'
		ORDER BY FilterName ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetPageFilterFavourites]') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


