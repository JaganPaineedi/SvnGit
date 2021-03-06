/****** Object:  StoredProcedure [dbo].[csp_ReportProcedureCodeStaff]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureCodeStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportProcedureCodeStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportProcedureCodeStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ReportProcedureCodeStaff]
	@ProcedureCodeId INT
AS

SELECT s.LastName + '', '' + s.FirstName AS StaffName
FROM dbo.StaffProcedures AS sp
JOIN Staff AS s ON s.StaffId = sp.StaffId
AND ISNULL(sp.RecordDeleted, ''N'') <> ''Y''
AND sp.ProcedureCodeId = @ProcedureCodeId

' 
END
GO
