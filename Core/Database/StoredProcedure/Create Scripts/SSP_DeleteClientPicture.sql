/****** Object:  StoredProcedure [dbo].[SSP_DeleteClientPicture]    Script Date: 04/29/2015 14:44:47 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_DeleteClientPicture]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_DeleteClientPicture]
GO

/****** Object:  StoredProcedure [dbo].[SSP_DeleteClientPicture]    Script Date: 04/29/2015 14:44:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_DeleteClientPicture] @clientId INT
	,@active CHAR(1)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Apr 29, 2015      
-- Description:   Marks the Active ClientPicture to Inactive
/*      
 Author			Modified Date			Reason      
   
      
*/
-- ============================================= 
BEGIN TRY
	BEGIN
		UPDATE ClientPictures
		SET Active = @active
		WHERE ClientId = @clientId
			AND Active = 'Y'
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_DeleteClientPicture') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

