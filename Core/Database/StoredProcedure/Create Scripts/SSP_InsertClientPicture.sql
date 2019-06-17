/****** Object:  StoredProcedure [dbo].[SSP_InsertClientPicture]    Script Date: 04/29/2015 14:51:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_InsertClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_InsertClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_InsertClientPicture]    Script Date: 04/29/2015 14:51:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_InsertClientPicture] @clientId INT
	,@uploadedOn DATETIME
	,@uploadedBy INT
	,@PictureFileName VARCHAR(100)
	,@picture IMAGE
	,@active CHAR(1)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Apr 29, 2015      
-- Description:   Updates all the Active Client Pictures to Inactive and Insert Client Picture
/*      
 Author			Modified Date			Reason      
   
      
*/
-- ============================================= 
BEGIN TRY
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM ClientPictures
				WHERE ClientId = @clientId AND Active='Y'
				)
			UPDATE ClientPictures
			SET Active = 'N'
			WHERE ClientId = @clientId AND Active='Y' 

		INSERT INTO ClientPictures (
			ClientId
			,UploadedOn
			,UploadedBy
			,PictureFileName
			,Picture
			,Active
			)
		VALUES (
			@clientId
			,@uploadedOn
			,@uploadedBy
			,@PictureFileName
			,@picture
			,@active
			);

		SELECT @@IDENTITY
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_InsertClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

