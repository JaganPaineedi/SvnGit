/****** Object:  StoredProcedure [dbo].[csp_ReportEAPUtilizationSymptomsTop2]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportEAPUtilizationSymptomsTop2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportEAPUtilizationSymptomsTop2]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportEAPUtilizationSymptomsTop2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportEAPUtilizationSymptomsTop2]
--
-- Called from the EAP Utilization Report to identify top 2 symptoms addressed
-- for a company.
-- History:
--	2012.07.22 - T. Remisoski - created/installed.
--
	@ProgramId int,
	@StartDate datetime,
	@EndDate datetime
as

declare @tabCodeName table (
	CodeName varchar(250)
)
insert into @tabCodeName (CodeName)
exec csp_ReportEAPUtilizationSymptoms @ProgramId, @StartDate, @EndDate

select top 2  ROW_NUMBER() over(order by numOccurrences desc) as SortOrder, z.CodeName
from (
	select CodeName, COUNT(*) as numOccurrences
	from @tabCodeName
	group by CodeName
) as z
order by z.numOccurrences desc

' 
END
GO
