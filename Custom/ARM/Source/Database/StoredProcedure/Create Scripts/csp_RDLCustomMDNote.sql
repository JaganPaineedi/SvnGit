/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMDNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMDNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMDNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMDNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_RDLCustomMDNote]
(
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
AS
Begin
/************************************************************************/
/* Stored Procedure: csp_RDLCustomMDNote								*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Jun 12, 2008											*/
/*																		*/
/* Purpose: Gets Data for MD Note										*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/* Author: Rupali Patil													*/
/************************************************************************/


SELECT	Documents.ClientID
		--,CMD.[DocumentId]
		--,CMD.[Version]
		,CMD.DocumentVersionId  --Modified by Anuj Dated 03-May-2010
		,(Select OrganizationName from SystemConfigurations)
		,[NoteData]
		,[NoteSignatureLine]
		,[TranscriptionDate]		
FROM DocumentVersions as dv
Join Documents on Documents.DocumentId = dv.DocumentId
left outer join CustomMDNotes as CMD on CMD.DocumentVersionId = dv.DocumentVersionId and isnull(CMD.RecordDeleted, ''N'') <> ''Y''
where dv.DocumentVersionId= @DocumentVersionId


If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomMDNote : An Error Occured''
		Return
	End
End
' 
END
GO
