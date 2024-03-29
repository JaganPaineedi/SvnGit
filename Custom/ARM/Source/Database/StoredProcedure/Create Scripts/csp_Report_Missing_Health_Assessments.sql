/****** Object:  StoredProcedure [dbo].[csp_Report_Missing_Health_Assessments]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Missing_Health_Assessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Missing_Health_Assessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Missing_Health_Assessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE Procedure [dbo].[csp_Report_Missing_Health_Assessments] 
	@start_date	datetime,
	@end_date	datetime,
	@location	varchar(10)
AS
--*/

/*
DECLARE	@start_date	datetime,
	@end_date	datetime,
	@location	varchar(10)

SELECT	@start_date =	''4/1/12'',
	@end_date =	''4/15/12'',
	@location =	''Secor''
--*/

SET NOCOUNT ON;  	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/********************************************************/
/* Stored Procedure: csp_missing_health_assessments		*/
/* Creation Date:    05/05/2010							*/
/* Copyright:    Harbor Behavioral Healthcare			*/
/*														*/
/* Purpose: Verification Reports						*/
/*														*/
/* Called By: Missing Health Assessments.rpt			*/
/*														*/
/* Updates:												*/
/* Date		Author		Purpose							*/
/* 05/05/2010	Jess		Created - WO 14300			*/
/* 06/11/2012  Brian M	Converted from Psychconsult     */
/********************************************************/

SELECT	C.ClientId,
		C.CurrentEpisodeNumber,	
		C.LastName + '', '' + C.FirstName AS ''Client'',
		L.LocationCode,
		S.DateOfService,
--		PC.ProcedureCodeName AS ''ProcedureCodeDescription'',
		PC.DisplayAs AS ''ProcedureCode''

FROM Clients C
	JOIN ClientEpisodes CE
		ON (C.ClientId = CE.ClientId
		AND	CE.DischargeDate IS NULL
		AND ISNULL(CE.RecordDeleted,''N'')<>''Y'')	
	JOIN Services S 
		ON	(C.Clientid = S.ClientId
		AND S.DateOfService between @start_date and dateadd(dd, 1, @end_date)
		AND	S.status IN (70,75)			--(''SH'', ''CO'')
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
	JOIN Programs PG
		ON (PG.ProgramId = S.ProgramId
		AND (S.ProcedureCodeId = ''258''	   -- ''EAP ASSESSMENT''
		OR	PG.ServiceAreaId NOT IN (''2'')) -- Employer - Employee Assistance
		AND	PG.ServiceAreaId NOT IN (''5'')	-- Vocational
		AND ISNULL(PG.RecordDeleted,''N'')<>''Y'')			
	JOIN Locations L
		ON (L.LocationId = S.LocationId
		AND	L.LocationCode LIKE @location
		AND ISNULL(L.RecordDeleted,''N'')<>''Y'')
	JOIN ProcedureCodes PC
		ON (PC.ProcedureCodeId = S.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
	
WHERE	C.Active = ''Y''
		AND	NOT	EXISTS (SELECT D.DocumentId
						FROM Documents D
						WHERE C.ClientId = D.ClientId
						AND	D.Status <> ''23''  --''ER''  No Error code exist "Cancelled"
						AND D.DocumentCodeId = ''1000114'' -- ''Health Assessment''						
						AND ISNULL(D.RecordDeleted,''N'')<>''Y'')
		AND	S.DateOfService = ( SELECT MIN(S2.DateOfService)
								FROM	Services S2 
									JOIN Programs PG2
										ON (PG2.ProgramId = S2.ProgramId
										AND ISNULL(PG2.RecordDeleted,''N'')<>''Y'')
								WHERE	S.ClientId = S2.ClientId
									AND (S2.ProcedureCodeId = ''258''			-- ''EAP ASSESSMENT''
									OR	PG2.ServiceAreaId NOT IN (''2'')) -- Employer - Employee Assistance
									AND	PG2.ServiceAreaId NOT IN (''5'')	-- Vocational
									AND	S2.Status IN (70,75)				--(''SH'', ''CO'')
									AND ISNULL(S2.RecordDeleted,''N'')<>''Y'') 
ORDER BY
	S.DateOfService,
	''Client''
	' 
END
GO
