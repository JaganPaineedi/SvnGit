/****** Object:  StoredProcedure [dbo].[csp_Report_Parameters_Staff_Names_Active_Only]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameters_Staff_Names_Active_Only]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Parameters_Staff_Names_Active_Only]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Parameters_Staff_Names_Active_Only]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_Report_Parameters_Staff_Names_Active_Only]
AS

SELECT	''ALL STAFF'' AS ''StaffName'',
		''%'' AS ''StaffId'',
		''1'' AS ''SortOrder''

UNION ALL

SELECT	S.LastName + '', '' + S.FirstName AS ''StaffName'',
		CONVERT(varchar, S.StaffId) AS ''StaffId'',
		2 AS ''SortOrder''
FROM	Staff S
WHERE	S.Active = ''Y''
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
ORDER	BY
		''SortOrder'',
		''StaffName''' 
END
GO
