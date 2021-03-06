/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentValidationDocumentNames]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidationDocumentNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentValidationDocumentNames]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidationDocumentNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    Procedure [dbo].[csp_ReportDocumentValidationDocumentNames]  
		

AS  


SELECT Distinct dc.DocumentCodeId, dc.DocumentName
From DocumentValidations dv with(nolock)
Join DocumentCodes dc with(nolock) on dc.DocumentCodeId=dv.DocumentCodeId

UNION ALL

SELECT NULL, ''<All Documents>''
Order by DocumentName
' 
END
GO
