/****** Object:  StoredProcedure [dbo].[csp_ReportGetScannedDocumentNames]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetScannedDocumentNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetScannedDocumentNames]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetScannedDocumentNames]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'









CREATE   procedure [dbo].[csp_ReportGetScannedDocumentNames]
AS
      
select dc.DocumentCodeId, Case when dc.Active = ''Y'' then ''(Active)'' else ''(Inactive)'' end + '' '' + dc.DocumentName as DocumentName
From documentCodes dc
Where Documenttype = 17 --Scanned Form
and isnull(dc.RecordDeleted, ''N'')= ''N''
order by 2



' 
END
GO
