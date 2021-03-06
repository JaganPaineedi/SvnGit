/****** Object:  StoredProcedure [dbo].[csp_Report_psych_testing]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_psych_testing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_psych_testing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_psych_testing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE  [dbo].[csp_Report_psych_testing]
		@start_date datetime,
		@end_date   datetime,
		@location_code varchar(20)
AS
--*/

/*
DECLARE	@start_date datetime,
		@end_date   datetime,
		@location_code varchar(20)

SELECT	@start_date = ''1/7/2006'',
		@end_date = ''1/21/2006'',
		@location_code = ''%''
--*/ 

SET NOCOUNT ON; -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/************************************************************/
/* Stored Procedure: csp_psych_testing						*/
/* Creation Date:    03/29/2006								*/
/* Copyright:    Harbor Behavioral Healthcare				*/
/*															*/
/* Purpose: Clinical Reports								*/
/*															*/
/* Called By: Psych Testing.rpt								*/
/*															*/
/* Input Parameters: @start_date, @end_date, @location_code	*/
/*															*/
/* Updates:													*/
/* Date		Author		Purpose								*/
/* 03/29/2006	Jess		Created (WO #3648)				*/
/* 03/30/2006	Jess		Added # of clients to the report*/
/* 06/12/2012	Brian M		Converted from Psychconsult		*/
/************************************************************/

DECLARE	@transactions TABLE
(
	ClientId int,
	Staff varchar(55),
	DateOfService datetime,
	ProcedurCodeId int,
	Duration float
)

DECLARE	@TotalClients int,
		@TotalCases int,
		@TotalHours float

INSERT	INTO @transactions
SELECT	
--	rtrim(C.LastName + '', '' + C.FirstName),
	C.ClientId,
	S.LastName + '', '' + S.FirstName, 
--	s.title,							Where is staff title stored?
	SS.DateOfService, 
	SS.ProcedureCodeId,
--	convert(varchar, @start_date, 101) AS ''Starting_Date'', 
--	convert(varchar, @end_date, 101) AS ''Ending_Date'', 
--	convert(varchar(20),(convert(float,(DATEDIFF(mi,SS.DateOfService,SS.EndDateOfService))) / 60)) AS ''Varchar Hours'',
	convert(float,(DATEDIFF(mi,SS.DateOfService,SS.EndDateOfService))) / 60 AS ''Float Hours''
--	DATEDIFF(mi,SS.DateOfService,SS.EndDateOfService) AS ''Proc_Duration''

FROM Services SS 
	JOIN Clients C 
		ON (SS.ClientId = C.ClientId
		AND ISNULL(C.RecordDeleted,''N'')<>''Y'')
	JOIN Staff S 
		ON (SS.ClinicianId = S.StaffId
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
	JOIN Locations L
		ON (L.LocationId = SS.LocationId
		AND L.LocationCode LIKE @location_code
		AND ISNULL(L.RecordDeleted,''N'')<>''Y'')
WHERE SS.DateOfService >= @start_date
	AND SS.DateOfService < DATEADD(dd, 1, @end_date)
	AND SS.Status = ''75''  -----''CO''	
	AND	SS.ProcedureCodeId in (''485'', ''486'')	-- PSYCH_TEST, 96101 (Psychological Testing, private clients)
	AND ISNULL(SS.RecordDeleted,''N'')<>''Y''

SELECT	@TotalClients = COUNT(DISTINCT ClientId),
		@TotalCases = COUNT(ClientId),
		@TotalHours = SUM(Duration)
FROM	@transactions

SELECT	t.Staff,
		COUNT(DISTINCT t.ClientId) AS ''Clients'',
		COUNT(t.ClientId) AS ''Cases'',
		SUM(t.Duration) AS ''Hours'',
		@TotalClients AS ''Total Clients'',
		@TotalCases AS ''Total Cases'',
		@TotalHours AS ''Total Hours''
FROM	@transactions t
GROUP	BY
		Staff



' 
END
GO
