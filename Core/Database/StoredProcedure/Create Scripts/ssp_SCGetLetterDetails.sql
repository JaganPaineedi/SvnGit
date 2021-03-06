/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterDetails]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetLetterDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetLetterDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetLetterDetails]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetLetterDetails] @LetterId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_SCGetLetterDetails]               */
/* Creation By:  Akwinass                                    */
/* Creation Date:  27/AUG/2015                                    */
/* Purpose: To Get Letter Details */
/* Input Parameters:   @LetterId*/
/*********************************************************************/
BEGIN
	BEGIN TRY		
		SELECT [LetterId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[LetterTemplateId]
			,[SentOn]
			,[LetterText]
		FROM [Letters]
		WHERE [LetterId] = @LetterId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetLetterDetails]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


