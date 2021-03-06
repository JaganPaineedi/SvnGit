/****** Object:  StoredProcedure [dbo].[csp_ReportDiagnosisDSMIV_TR]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisDSMIV_TR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDiagnosisDSMIV_TR]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDiagnosisDSMIV_TR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	procedure [dbo].[csp_ReportDiagnosisDSMIV_TR]

/* 
Report to list DSMIV-TR codes

*/

AS


select 
	ddn.DSMCode, 
	ddn.DSMNumber, 
	ddn.Axis, 
	ddn.DSMDescription
from DiagnosisDsmDescriptions_New as ddn
' 
END
GO
