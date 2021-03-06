/****** Object:  StoredProcedure [dbo].[csp_CustomReportUnitsofServiceManagement_GetNewCategories]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsofServiceManagement_GetNewCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomReportUnitsofServiceManagement_GetNewCategories]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportUnitsofServiceManagement_GetNewCategories]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_CustomReportUnitsofServiceManagement_GetNewCategories] (
	@Action int
	)
AS
BEGIN TRAN

IF @Action IN (1,5,6)
	SELECT CategoryID = GlobalCodeId,
		CategoryName = CodeName
	FROM GlobalCodes g
	WHERE Category = ''XUNITSOFSERVICECAT'' 
		AND ISNULL(g.RecordDeleted,''N'') = CASE WHEN @Action = 2 THEN ''Y'' ELSE ''N'' END
	--UNION
	--SELECT -1,'' None''
	ORDER BY CategoryName, CategoryId

ELSE 
	SELECT CategoryId = -1,CategoryName = ''N/A''

IF @@error = 0 COMMIT TRAN
ELSE ROLLBACK


' 
END
GO
