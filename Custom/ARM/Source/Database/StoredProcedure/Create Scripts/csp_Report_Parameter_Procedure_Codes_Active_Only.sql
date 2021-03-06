/****** Object:  StoredProcedure [dbo].[csp_Report_Parameter_Procedure_Codes_Active_Only]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameter_Procedure_Codes_Active_Only]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Parameter_Procedure_Codes_Active_Only]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameter_Procedure_Codes_Active_Only]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_Report_Parameter_Procedure_Codes_Active_Only]
AS

SELECT	''ALL PROCEDURES'' AS ''DisplayAs'',
		''%'' AS ''ProcedureCodeId'',
		''1'' AS ''SortOrder''

UNION ALL

SELECT	DISTINCT
		PC.DisplayAs,
		CONVERT(varchar, PC.ProcedureCodeId) AS ''ProcedureCodeId'',
		''2'' AS ''SortOrder''
FROM	ProcedureCodes PC
WHERE	PC.Active = ''Y''
AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
ORDER	BY
		''SortOrder'',
		DisplayAs
' 
END
GO
