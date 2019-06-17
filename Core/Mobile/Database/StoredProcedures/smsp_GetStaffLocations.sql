/****** Object:  StoredProcedure [dbo].[smsp_GetStaffLocations]    Script Date: 8/30/2016 5:06:21 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetStaffLocations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_GetStaffLocations]
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetStaffLocations]    Script Date: 8/30/2016 5:06:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_GetStaffLocations] @StaffId INT
AS -- =============================================      
-- Author:  Pradeep      
-- Create date: 14-06-2016
-- Description: Get StaffProcedureCodes
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		SELECT SL.LocationId
			,L.LocationName
		FROM dbo.StaffLocations SL
		JOIN dbo.Locations L ON SL.LocationId = L.LocationId
		WHERE L.Active = 'Y'
			AND L.Mobile = 'Y'
			AND ISNULL(SL.RecordDeleted, 'N') = 'N'
			AND ISNULL(L.RecordDeleted, 'N') = 'N'
			AND SL.StaffId = @StaffId;
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_GetStaffLocations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH;
END;
GO


