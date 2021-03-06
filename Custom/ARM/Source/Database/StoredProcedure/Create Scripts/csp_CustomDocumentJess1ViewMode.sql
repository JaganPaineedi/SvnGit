/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentJess1ViewMode]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentJess1ViewMode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentJess1ViewMode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentJess1ViewMode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_CustomDocumentJess1ViewMode]
-- View document mode for Jess'' test document
	@DocumentVersionId int
AS

SELECT a.Narrative, s.LastName + '', '' + s.FirstName AS StaffName
FROM dbo.CustomDocumentJessTest1 AS a
JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = a.DocumentVersionId
JOIN dbo.Documents AS d ON d.DocumentId = dv.DocumentId
JOIN Staff AS s ON s.StaffId = d.AuthorId
WHERE a.DocumentVersionId = @DocumentVersionId

' 
END
GO
