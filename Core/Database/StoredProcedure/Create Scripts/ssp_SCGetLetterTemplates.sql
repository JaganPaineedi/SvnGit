/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterTemplates]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLetterTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLetterTemplates]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterTemplates]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetLetterTemplates] @LetterCategory INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetLetterTemplates]               */
/* Creation Date:  27/AUG/2015                                    */
/* Purpose: To Get Letter Templates */
/* Input Parameters:   @LetterCategory*/
/*********************************************************************/
BEGIN
	BEGIN TRY			
		SELECT [LetterTemplateId]
			,[TemplateName]
		FROM [LetterTemplates]
		WHERE LetterCategory = @LetterCategory
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetLetterTemplates]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


