/****** Object:  StoredProcedure [dbo].[csp_ReportEAPUtilizationSymptoms]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportEAPUtilizationSymptoms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportEAPUtilizationSymptoms]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportEAPUtilizationSymptoms]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportEAPUtilizationSymptoms]
--
-- Called from the EAP Utilization Report to support a pie-chart of symptoms
-- for a company.
-- History:
--	2012.07.22 - T. Remisoski - created/installed.
--
	@ProgramId int,
	@StartDate datetime,
	@EndDate datetime
as

declare @ClientsServed table (
	ClientId int
)

insert into @ClientsServed (ClientId)
select distinct ClientId
from     dbo.Services as s
where   s.ProgramId = @ProgramId
	and (s.Status in (71, 72, 75))
	and ISNULL(s.RecordDeleted, ''N'') <> ''Y''
	and DATEDIFF(DAY, s.DateOfService, @StartDate) <= 0
	and DATEDIFF(DAY, s.DateOfService, @EndDate) >= 0


select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom01
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom02
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom03
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom04
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom05
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom06
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom07
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom08
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom09
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom10
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom11
join @ClientsServed as cs on cs.ClientId = cc.ClientId
union all
select gc.CodeName
from dbo.CustomClients as cc
join dbo.GlobalCodes as gc on gc.GlobalCodeId = cc.Symptom12
join @ClientsServed as cs on cs.ClientId = cc.ClientId

' 
END
GO
