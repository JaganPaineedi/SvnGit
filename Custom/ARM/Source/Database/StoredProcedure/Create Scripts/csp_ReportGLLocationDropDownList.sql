/****** Object:  StoredProcedure [dbo].[csp_ReportGLLocationDropDownList]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLLocationDropDownList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGLLocationDropDownList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGLLocationDropDownList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportGLLocationDropDownList] as
select LocationId, LocationName
from dbo.Locations
where Active = ''Y''
and ISNULL(RecordDeleted, ''N'') <> ''Y''
union
select null, '' ALL''
order by 2

' 
END
GO
