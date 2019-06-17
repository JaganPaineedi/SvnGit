/****** Object:  StoredProcedure [dbo].[ssp_NoteTagClientOrderControl]    Script Date: 11/30/2017 12:02:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_NoteTagClientOrderControl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_NoteTagClientOrderControl]
GO
/****** Object:  StoredProcedure [dbo].[ssp_NoteTagClientOrderControl]    Script Date: 11/30/2017 12:02:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
CREATE PROCEDURE [dbo].[ssp_NoteTagClientOrderControl]       
@ClientId INT            
 ,@DocumentId INT      
 ,@EffectiveDate DATETIME      
AS       
/****************************************************************************
** Author:		Chethan N
** Create date: Nov, 30 2017
** Description: Tag Calculation SP to open the Client Order Control
**	EXEC ssp_NoteTagClientOrderControl
**	Modifications:
**		Date			Author			Description
**	--------------	------------------	------------------------------------

****************************************************************************/
BEGIN
	BEGIN TRY      
        
        DECLARE @listStr VARCHAR(MAX)      
        
         SET @listStr = '^OpenMode=ClientOrderControl'
            
        SELECT  @listStr      
    END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_NoteTagClientOrderControl') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH
END

