/****** Object:  StoredProcedure [dbo].[csp_ReportPrintSpenddown]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintSpenddown]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintSpenddown]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintSpenddown]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[csp_ReportPrintSpenddown] (
	@StartDate smalldatetime,
	@EndDate smalldatetime)
AS
BEGIN

SET @StartDate = COALESCE(@StartDate, CAST(DATEPART(yy,GETDATE()) as char(4)) + RIGHT(RTRIM(''0''+CAST(DATEPART(mm,GETDATE()) as char(2))),2) + ''01'')
SET @EndDate = COALESCE(@EndDate,GETDATE())

SELECT 
	StartDate = Convert(varchar(11),@StartDate,110),
	EndDate = Convert(varchar(11),@EndDate,110),
	PatientName = pat.LastName+'', ''+pat.FirstName+Coalesce('' ''+LEFT(pat.MiddleName,1)+''.'',''''),
	PatientId = pat.ClientId,
	EpisodeId = NULL,
	ProcedureDateTime = Convert(varchar(11),s.DateofService,110)+CHAR(13)+CHAR(10)+
		LEFT(RIGHT(CONVERT(VARCHAR, s.DateofService, 100),7),5) +'' ''+RIGHT(CONVERT(VARCHAR, s.DateofService, 100),2),
	ProcedureCode = pc.DisplayAs,
	ProcedureDuration = s.Unit,
	l.LocationName,
	StaffName = sta.LastName+'', ''+sta.FirstName+Coalesce('' ''+LEFT(sta.MiddleName,1)+''.'',''''),
	BillingAmount = CASE WHEN s.Charge = 0 THEN NULL ELSE s.Charge END
FROM Services s
JOIN Clients pat ON pat.ClientId = s.ClientId
JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
JOIN Locations l ON l.LocationId = s.LocationId
JOIN Staff sta ON sta.StaffId = s.ClinicianId
WHERE s.DateofService BETWEEN @StartDate and @EndDate
AND s.ClientId IN (
	select Distinct ClientId 
	from clientcoverageplans ccp
	join customcoverageplans ccp2 on ccp2.ClientCoveragePlanId = ccp.ClientCoveragePlanId
	WHERE SpendDown = ''Y'')
--AND COALESCE(s.Charge,0) > 0
and s.Status in (71,75)	-- show only
AND IsNull(s.RecordDeleted,''N'') <> ''Y''
AND IsNull(pat.RecordDeleted,''N'') <> ''Y''
AND IsNull(pc.RecordDeleted,''N'') <> ''Y''
AND IsNull(l.RecordDeleted,''N'') <> ''Y''
AND IsNull(sta.RecordDeleted,''N'') <> ''Y''
ORDER BY PatientName, ProcedureDateTime

END
' 
END
GO
