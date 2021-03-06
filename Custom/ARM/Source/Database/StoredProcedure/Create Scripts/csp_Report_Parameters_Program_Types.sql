/****** Object:  StoredProcedure [dbo].[csp_Report_Parameters_Program_Types]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameters_Program_Types]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Parameters_Program_Types]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameters_Program_Types]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_Report_Parameters_Program_Types]
AS

SELECT	''ALL PROGRAM TYPES'' AS ''ServiceAreaName'',
		''%'' AS ''ServiceAreaId'',
		''1'' AS ''SortOrder''

UNION ALL

SELECT	DISTINCT
		SA.ServiceAreaName,
		CONVERT(varchar, SA.ServiceAreaId) AS ''ServiceAreaId'',
		''2'' AS ''SortOrder''
FROM	ServiceAreas SA
WHERE	ISNULL(SA.RecordDeleted, ''N'') <> ''Y''
ORDER	BY
		''SortOrder'',
		ServiceAreaName

' 
END
GO
