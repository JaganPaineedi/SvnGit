/****** Object:  StoredProcedure [dbo].[csp_ReportProcedureCodeList]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureCodeList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportProcedureCodeList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureCodeList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_ReportProcedureCodeList]
	@IncludeInactiveCodes CHAR(1),
	@ProcedureCodeId INT
AS

SELECT ProcedureCodeId, DisplayAs, ProcedureCodeName, pc.Active, gc.CodeName AS EnteredAs, NotBillable,
dc.DocumentName
FROM dbo.ProcedureCodes AS pc
LEFT JOIN GlobalCodes AS gc ON gc.GlobalCodeId = pc.EnteredAs
LEFT JOIN dbo.DocumentCodes AS dc ON dc.DocumentCodeId = pc.AssociatedNoteId
WHERE ((pc.Active = ''Y'') OR (@IncludeInactiveCodes = ''Y''))
AND ISNULL(pc.RecordDeleted, ''N'') <> ''Y''
--AND pc.ProcedureCodeId = @ProcedureCodeId
ORDER BY DisplayAs

' 
END
GO
