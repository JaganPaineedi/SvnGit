/****** Object:  StoredProcedure [dbo].[csp_ReportParameterProcedureCode]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportParameterProcedureCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportParameterProcedureCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportParameterProcedureCode]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_ReportParameterProcedureCode] AS
select ProcedureCodeId, DisplayAs from ProcedureCodes where isnull(RecordDeleted, ''N'') <> ''Y''
order by DisplayAs
' 
END
GO
