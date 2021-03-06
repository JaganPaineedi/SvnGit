/****** Object:  StoredProcedure [dbo].[csp_ReportGetCoveragePlanTemplates]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetCoveragePlanTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportGetCoveragePlanTemplates]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportGetCoveragePlanTemplates]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   procedure [dbo].[csp_ReportGetCoveragePlanTemplates]
AS


Select Distinct cp.CoveragePlanId, cp.DisplayAs as CoveragePlanName
From CoveragePlans cp
Where isnull(cp.RecordDeleted, ''N'') =''N'' and isnull(cp.Active, ''N'')= ''Y''
and isnull(cp.BillingCodeTemplate, ''X'') = ''T''

Union 
select NULL , ''Standard Rates''  

Order By cp.displayas
' 
END
GO
