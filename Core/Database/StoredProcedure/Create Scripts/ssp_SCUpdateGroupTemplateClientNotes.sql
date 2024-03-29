/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateGroupTemplateClientNotes]    Script Date: 07/24/2015 12:27:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateGroupTemplateClientNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateGroupTemplateClientNotes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateGroupTemplateClientNotes]    Script Date: 07/24/2015 12:27:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateGroupTemplateClientNotes] @ClientIds VARCHAR(MAX)
,@GroupId INT
,@GroupTemplateId INT
,@StaffId INT
AS
/**************************************************************  
Created By   : Akwinass
Created Date : 13-APRIL-2016 
Description  : Used to Update Client Notes
Called From  : Group Template Screens
/*  Date			  Author				  Description */
/*  13-APRIL-2016	  Akwinass				  Created    */
**************************************************************/
BEGIN
	BEGIN TRY	
	
		DECLARE @CopyStoredProcedureName VARCHAR(100)

		SELECT @CopyStoredProcedureName = GNDC.CopyStoredProcedureName
		FROM Groups G
		INNER JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
		WHERE ISNULL(G.RecordDeleted, 'n') = 'n'
			AND ISNULL(GNDC.RecordDeleted, 'n') = 'n'
			AND G.GroupId = @GroupId

		IF (ISNULL(@CopyStoredProcedureName, '') <> '')
		BEGIN			
			EXEC csp_SCGroupTemplateUpdateClientNotes @GroupTemplateId,@GroupId,@ClientIds,@StaffId
		END
	
		SELECT GT.GroupTemplateId
			,GT.CreatedBy
			,GT.CreatedDate
			,GT.ModifiedBy
			,GT.ModifiedDate
			,GT.RecordDeleted
			,GT.DeletedBy
			,GT.DeletedDate
			,GT.GroupId
			,GT.StaffId
			,GT.DocumentId
			,GT.StartDate
			,GT.EndDate			
		FROM GroupTemplates GT
		WHERE GT.GroupTemplateId = @GroupTemplateId
			AND ISNULL(GT.RecordDeleted, 'N') = 'N'	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[ssp_SCUpdateGroupTemplateClientNotes]') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


