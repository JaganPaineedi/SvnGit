/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateGroupTemplate]    Script Date: 12/12/2014 10:30:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateGroupTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateGroupTemplate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateGroupTemplate]    Script Date: 12/12/2014 10:30:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_PostUpdateGroupTemplate] @ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PostUpdateGroupTemplate                 */
/* Creation Date:    13/APRIL/2016                                   */
/*                                                                   */
/* Input Parameters:                                                 */
/* @ScreenKeyId, @StaffId, @CurrentUser, @CustomParameters           */
/* Called By: Group Template Details Page                            */
/* Updates:                                                          */
/* Date                   Author        Purpose                      */
/* 13/APRIL/2016          Akwinass      Created.                     */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @DocumentCodeId INT
		SELECT TOP 1 @DocumentCodeId = DocumentCodeId
		FROM Documents
		WHERE DocumentId = @ScreenKeyId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		DECLARE @PostUpdateStoredProcedure VARCHAR(100)	
		SELECT TOP 1 @PostUpdateStoredProcedure = PostUpdateStoredProcedure
		FROM Screens
		WHERE DocumentCodeId = @DocumentCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			
		IF ISNULL(@PostUpdateStoredProcedure,'') <> ''
		BEGIN			
			EXEC @PostUpdateStoredProcedure @ScreenKeyId,@StaffId,@CurrentUser,@CustomParameters
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateGroupTemplate') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


