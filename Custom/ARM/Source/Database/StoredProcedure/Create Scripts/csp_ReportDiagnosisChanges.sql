/****** Object:  StoredProcedure [dbo].[csp_ReportDiagnosisChanges]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisChanges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDiagnosisChanges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisChanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create	procedure [dbo].[csp_ReportDiagnosisChanges]

/* 
Report to list changes to DSM codes

*/

AS


select
	''Remove'' as DxGroup,
	ddo.DSMCode, 
	ddo.DSMNumber, 
	ddo.Axis, 
	ddo.DSMDescription
from DiagnosisDsmDescriptions_Old as ddo
where ddo.InvalidInDSMIV = ''Y''
union
select
	''Add'' as DxGroup,
	ddn.DSMCode, 
	ddn.DSMNumber, 
	ddn.Axis, 
	ddn.DSMDescription
from DiagnosisDsmDescriptions_New as ddn
where ddn.DSMCode not in (
	select distinct DSMCode from DiagnosisDsmDescriptions as c
)
' 
END
GO
