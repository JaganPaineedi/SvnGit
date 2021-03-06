/****** Object:  StoredProcedure [dbo].[csp_ReportGetStaff]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   procedure [dbo].[csp_ReportGetStaff]
AS


Select Distinct s.StaffId, s.lastname +'', ''+ s.firstname as StaffName
From Staff s 
Where isnull(s.RecordDeleted, ''N'') =''N'' and isnull(clinician, ''N'')= ''Y''


Union 
select NULL, ''All Staff'' 

Order By s.lastname +'', ''+ s.firstname
' 
END
GO
