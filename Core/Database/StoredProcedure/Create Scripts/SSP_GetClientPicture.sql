/****** Object:  StoredProcedure [dbo].[SSP_GetClientPicture]    Script Date: 04/29/2015 14:48:23 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetClientPicture]    Script Date: 04/29/2015 14:48:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetClientPicture] @ClientId INT
	,@GetPicture CHAR(1)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Apr 29, 2015      
-- Description:   Get the Client Picture data.
/*      
 Author			Modified Date			Reason      
 Himmat	        17-11-2015              Formatted UploadedByText by LastName, FirstName
      
*/
-- ============================================= 
BEGIN TRY
	BEGIN
		SELECT CP.[ClientPictureId]
			,CP.[CreatedBy]
			,CP.[CreatedDate]
			,CP.[ModifiedBy]
			,CP.[ModifiedDate]
			,CP.[RecordDeleted]
			,CP.[DeletedBy]
			,CP.[DeletedDate]
			,CP.[ClientId]
			,CP.[UploadedOn]
			,CP.[UploadedBy]
			,CP.[PictureFileName]
			,CASE @GetPicture
				WHEN 'Y'
					THEN CP.[Picture]
				ELSE NULL
				END AS Picture
			,CP.[Active]
			,CONVERT(VARCHAR(10), CP.[UploadedOn], 101) AS UploadedOnText
			,(S.LastName  + ', ' + S.FirstName ) AS UploadedByText
		FROM ClientPictures CP
		INNER JOIN Staff S ON S.StaffId = CP.UploadedBy
		WHERE ClientId = @ClientId
			AND CP.Active = 'Y'
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

