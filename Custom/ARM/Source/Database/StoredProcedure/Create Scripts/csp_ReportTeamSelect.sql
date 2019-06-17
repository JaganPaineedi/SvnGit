/****** Object:  StoredProcedure [dbo].[csp_ReportTeamSelect]    Script Date: 04/18/2013 09:51:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportTeamSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportTeamSelect]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportTeamSelect]    Script Date: 04/18/2013 09:51:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO














CREATE  Procedure [dbo].[csp_ReportTeamSelect]
AS

select null as 'dataValue','All' as 'displayValue'
union
select ProgramType as 'dataValue', CodeName as 'displayValue' 
from Programs a
join globalcodes gc on gc.globalcodeid = programtype 
where isnull(a.Active,'N') = 'Y' and isnull(a.RecordDeleted,'N')= 'N'
GO

