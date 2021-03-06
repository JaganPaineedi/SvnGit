/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentSharedCoachingAssessment]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentSharedCoachingAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentSharedCoachingAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentSharedCoachingAssessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE	PROCEDURE  [dbo].[csp_InitCustomDocumentSharedCoachingAssessment]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
AS

SELECT	TOP 1 ''CustomDocumentSharedCoachingAssessment'' AS TableName,
		-1 AS ''DocumentVersionId'',
		'''' as CreatedBy,
		getdate() as CreatedDate,
		'''' as ModifiedBy,
		getdate() as ModifiedDate

' 
END
GO
