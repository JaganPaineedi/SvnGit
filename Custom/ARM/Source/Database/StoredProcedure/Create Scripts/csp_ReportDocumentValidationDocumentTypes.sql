/****** Object:  StoredProcedure [dbo].[csp_ReportDocumentValidationDocumentTypes]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidationDocumentTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDocumentValidationDocumentTypes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDocumentValidationDocumentTypes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     Procedure [dbo].[csp_ReportDocumentValidationDocumentTypes]  
		( @DocumentCodeId int )

AS  


SELECT Distinct DocumentType
, Case DocumentType
	When ''DD'' Then ''DD''
	When ''DDA'' Then ''DD - Annual''
	When ''MHSAA'' Then ''MI/SA Adult''
	When ''MHSAC'' Then ''MI/SA Child''
	When ''MHSAAA'' Then ''MI/SA Adult - Annual''
	When ''MHSACA'' Then ''MI/SA Child - Annual''
	Else DocumentType
	End as DocumentLabel
From DocumentValidations with(nolock)
Where DocumentCodeId = @DocumentCodeId
and DocumentType is not null

UNION ALL

SELECT NULL, ''<All Document Types>''
Order by DocumentLabel, DocumentType
' 
END
GO
