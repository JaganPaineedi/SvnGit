/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentValidationTabNames]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidationTabNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentValidationTabNames]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidationTabNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     Procedure [dbo].[csp_ReportDocumentValidationTabNames]  
		( @DocumentCodeId int, @DocumentType varchar(10) )

AS  


SELECT Distinct TabOrder, TabName
From DocumentValidations with(nolock)
Where DocumentCodeId = @DocumentCodeId
and ( (DocumentType = @DocumentType or DocumentType is null) or @DocumentType is null )
and TabName is not null

UNION ALL

SELECT NULL, ''<All Tabs>''
Order by TabOrder, TabName
' 
END
GO
