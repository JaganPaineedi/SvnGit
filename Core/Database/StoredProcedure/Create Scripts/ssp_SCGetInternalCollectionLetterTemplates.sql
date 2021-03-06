/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionLetterTemplates]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetInternalCollectionLetterTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetInternalCollectionLetterTemplates]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetInternalCollectionLetterTemplates]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetInternalCollectionLetterTemplates]
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_SCGetInternalCollectionLetterTemplates           */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    13/AUG/2015                                         */
/*                                                                   */
/* Purpose:  Used to Get Internal Collections Letter Templates  */
/*                                                                   */
/* Input Parameters:None   */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @LetterCategory INT
		
		SELECT TOP 1 @LetterCategory = GlobalCodeId
		FROM GlobalCodes
		WHERE ISNULL(Category, '') = 'LETTERTEMPLATE'
			AND ISNULL(Code, '') = 'ICL'
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND ISNULL(Active, 'N') = 'Y'
			
		SELECT @LetterCategory AS LetterCategory
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCGetInternalCollectionLetterTemplates]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


