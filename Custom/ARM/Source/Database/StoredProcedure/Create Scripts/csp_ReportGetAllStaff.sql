/****** Object:  StoredProcedure [dbo].[csp_ReportGetAllStaff]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetAllStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetAllStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetAllStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   procedure [dbo].[csp_ReportGetAllStaff]
AS


Select Distinct 
case when s.Active = ''Y'' then 1 else 2 end as Active,
s.StaffId, 
s.lastname +'', ''+ s.firstname + case when active = ''Y'' then '' (Active)'' when active = ''N'' then '' (Inactive)'' end as StaffName
From Staff s 
Where isnull(s.RecordDeleted, ''N'') =''N'' 


Union 
select 1, NULL, ''<All Staff>'' 

Order By  1, s.lastname +'', ''+ s.firstname + case when active = ''Y'' then '' (Active)'' when active = ''N'' then '' (Inactive)'' end
' 
END
GO
