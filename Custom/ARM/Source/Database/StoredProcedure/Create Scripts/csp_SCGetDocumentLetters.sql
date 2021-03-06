/****** Object:  StoredProcedure [dbo].[csp_SCGetDocumentLetters]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDocumentLetters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDocumentLetters]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDocumentLetters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCGetDocumentLetters]
	@DocumentVersionId INT
as

SELECT 
	DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedDate,
	DeletedBy,
	TextData
FROM TextDocuments
WHERE DocumentVersionId = @DocumentVersionId

' 
END
GO
