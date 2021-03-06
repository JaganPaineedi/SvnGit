/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentServicesDropDown]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentServicesDropDown]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentServicesDropDown]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentServicesDropDown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_CustomDocumentServicesDropDown]

as 
select ''< All >'' as ''Program'', null as ''Value'' 
Union 
select ProgramName as ''Display'',
ProgramId as ''Value'' 
from Programs
where Programs.Active=''Y''
and Programs.ProgramId in (8, 21)
and ISNULL(Programs.recorddeleted, ''N'')<>''Y''
	order by 1 
' 
END
GO
