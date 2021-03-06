/****** Object:  StoredProcedure [dbo].[csp_ReportGLProgramDropDownList]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLProgramDropDownList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLProgramDropDownList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLProgramDropDownList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGLProgramDropDownList] (@ServiceAreaId int) 
as

select ProgramId, ProgramName
from dbo.Programs
where Active = ''Y''
and ServiceAreaId = @ServiceAreaId
and ISNULL(RecordDeleted, ''N'') <> ''Y''
union
select null as ProgramId, '' None Selected'' as ProgramName
order by ProgramName


' 
END
GO
