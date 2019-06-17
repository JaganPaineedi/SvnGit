/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupTemplateDocumentCode]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupTemplateDocumentCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGroupTemplateDocumentCode]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupTemplateDocumentCode]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetGroupTemplateDocumentCode]
@GroupId INT
AS
/**************************************************************  
Created By   : Akwinass
Created Date : 13-APRIL-2016 
Description  : Used to Get GroupNoteCodeId
Called From  : Group Template Screens
/*  Date			  Author				  Description */
/*  13-APRIL-2016	  Akwinass				  Created    */
**************************************************************/
BEGIN
	BEGIN TRY		
		SELECT TOP 1 GNDC.GroupNoteCodeId,GNDC.GroupNoteName AS TabName
		FROM Groups G
		LEFT JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
		LEFT JOIN ProcedureCodes PC ON G.ProcedureCodeId = PC.ProcedureCodeId
		LEFT JOIN GlobalCodes GC ON PC.EnteredAs = GC.GlobalCodeId
		LEFT JOIN Screens SC ON GNDC.ServiceNoteCodeId = SC.DocumentCodeId
		WHERE G.GroupId = @GroupId
			AND isnull(G.RecordDeleted, 'N') = 'N'
			AND isnull(GNDC.RecordDeleted, 'N') = 'N'
			AND isnull(PC.RecordDeleted, 'N') = 'N'
			AND isnull(GC.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetGroupTemplateDocumentCode: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


