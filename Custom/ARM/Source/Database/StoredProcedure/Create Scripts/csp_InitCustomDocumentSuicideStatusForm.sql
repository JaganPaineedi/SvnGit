/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentSuicideStatusForm]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentSuicideStatusForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentSuicideStatusForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentSuicideStatusForm]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_InitCustomDocumentSuicideStatusForm]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
AS

SELECT	TOP 1 ''CustomDocumentSuicideStatusForm'' AS TableName,
		-1 AS ''DocumentVersionId'',
		'''' as CreatedBy,
		getdate() as CreatedDate,
		'''' as ModifiedBy,
		getdate() as ModifiedDate
' 
END
GO
