/****** Object:  StoredProcedure [dbo].[csp_Report_Parameters_Programs_Active_Only]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameters_Programs_Active_Only]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Parameters_Programs_Active_Only]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameters_Programs_Active_Only]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_Report_Parameters_Programs_Active_Only]
AS

SELECT	''ALL PROGRAMS'' AS ''ProgramName'',
		''%'' AS ''ProgramId'',
		''1'' AS ''SortOrder''

UNION ALL

SELECT	P.ProgramName,
		CONVERT(varchar, P.ProgramId) AS ''ProgramId'',
		''2'' AS ''SortOrder''
FROM	Programs P
WHERE	P.Active = ''Y''
AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
ORDER	BY
		''SortOrder'',
		ProgramName' 
END
GO
