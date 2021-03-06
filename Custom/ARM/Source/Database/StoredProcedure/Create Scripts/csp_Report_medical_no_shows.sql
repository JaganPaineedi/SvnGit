/****** Object:  StoredProcedure [dbo].[csp_Report_medical_no_shows]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_medical_no_shows]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_medical_no_shows]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_medical_no_shows]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE [dbo].[csp_Report_medical_no_shows]
	@start_date	datetime,
	@end_date	datetime,
	@location	varchar(55)
AS
--*/

/*
DECLARE	@start_date	datetime,
	@end_date	datetime,
	@location	varchar(55)

SELECT	@start_date =	''1/1/12'',
	@end_date =	''1/15/12'',
	@location =	''%''
--*/

SET NOCOUNT ON; -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/***********************************************/
/* Stored Procedure: csp_medical_no_shows		*/
/* Creation Date:    03/17/2011					*/
/*												*/
/* Purpose: Clinical Reports					*/
/*												*/
/* Called By: Medical No Shows.rpt				*/
/*												*/
/* Updates:										*/
/* Date		Author		Purpose					*/
/* 03/17/2011	Jess	Created - WO 17123		*/
/* 06/13/2012	Brian M	Coverted to Psychconsult*/
/************************************************/

DECLARE	@clients TABLE
(
	patient_id	int,
	proc_chron	datetime,
	proc_code	varchar(55),
	clinician_id	int,
	location	varchar(55)
)
DECLARE	@last_dos TABLE
(
	patient_id	char(10),
	last_dos	datetime
)	
INSERT INTO @clients
SELECT	S.ClientId,
	MAX(S.DateOfService),
	PC.DisplayAs, -- Procedure Code
	S.ClinicianId,
	L.LocationCode 
	FROM Services S 
		JOIN Locations L
			ON (L.LocationId = S.LocationId
			AND ISNULL(L.RecordDeleted,''N'')<>''Y'')		
		JOIN ProcedureCodes PC
			ON (PC.ProcedureCodeId = S.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
	WHERE S.status = ''72''	--''NS''
		AND	S.DateOfService >= @start_date
		AND	S.DateOfService < DATEADD(dd, 1, @end_date)
		AND	L.LocationCode LIKE @location
		AND	PC.DisplayAs IN (''PSYCH_EVAL'', ''MED_IND'', ''MED_YOUTH'', ''PED_ESTPT'', ''PED_CONS'')
		AND ISNULL(S.RecordDeleted,''N'')<>''Y''
GROUP BY
	S.ClientId,
	PC.DisplayAs,
	S.ClinicianId,
	L.LocationCode

INSERT INTO	@last_dos
SELECT	c.patient_id,
	MAX(S.DateOfService)
	FROM	@clients c
		JOIN Services S
			ON	(c.patient_id = S.ClientId
			AND	S.Status = ''75''  --''CO''
			AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
		JOIN Locations L
			ON (L.LocationId = S.LocationId
			AND ISNULL(L.RecordDeleted,''N'')<>''Y'')
		JOIN ProcedureCodes PC
			ON (PC.ProcedureCodeId = S.ProcedureCodeId
		AND	PC.DisplayAs IN (''PSYCH_EVAL'', ''MED_IND'', ''MED_YOUTH'', ''PED_ESTPT'', ''PED_CONS'')
		AND	L.LocationCode LIKE @location
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
GROUP BY
	c.patient_id

SELECT	DISTINCT
	CS.LastName + '', '' + CS.FirstName as ''Client'',
	c.patient_id,
	CONVERT	(varchar, c.proc_chron, 101) + '' '' +
		CASE WHEN	substring(convert(varchar, c.proc_chron, 108), 1, 2) = 00
			THEN	convert(varchar(2), 12) + substring(convert(varchar, c.proc_chron, 108), 3, 3) + ''AM''
			WHEN	substring(convert(varchar, c.proc_chron, 108), 1, 2) < 12
			THEN	substring(convert(varchar, c.proc_chron, 108), 1, 5) + ''AM''
			WHEN	substring(convert(varchar, c.proc_chron, 108), 1, 2) = 12
			THEN	substring(convert(varchar, c.proc_chron, 108), 1, 5) + ''PM''
			WHEN	convert(varchar(2), substring(convert(varchar, c.proc_chron, 108), 1, 2) - 12) < 10
			THEN	''0'' + convert(varchar(2), substring(convert(varchar, c.proc_chron, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, c.proc_chron, 108), 3, 3)) + ''PM''
			ELSE	convert(varchar(2), substring(convert(varchar, c.proc_chron, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, c.proc_chron, 108), 3, 3)) + ''PM''
		END	AS	''No Show'',
	c.proc_code,
	S.LastName + '', '' + S.FirstName as ''Clinician'',
	c.location,
	CONVERT	(varchar, l.last_dos, 101) + '' '' +
		CASE	WHEN	substring(convert(varchar, l.last_dos, 108), 1, 2) = 00
			THEN	convert(varchar(2), 12) + substring(convert(varchar, l.last_dos, 108), 3, 3) + ''AM''
			WHEN	substring(convert(varchar, l.last_dos, 108), 1, 2) < 12
			THEN	substring(convert(varchar, l.last_dos, 108), 1, 5) + ''AM''
			WHEN	substring(convert(varchar, l.last_dos, 108), 1, 2) = 12
			THEN	substring(convert(varchar, l.last_dos, 108), 1, 5) + ''PM''
			WHEN	convert(varchar(2), substring(convert(varchar, l.last_dos, 108), 1, 2) - 12) < 10
			THEN	''0'' + convert(varchar(2), substring(convert(varchar, l.last_dos, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, l.last_dos, 108), 3, 3)) + ''PM''
			ELSE	convert(varchar(2), substring(convert(varchar, l.last_dos, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, l.last_dos, 108), 3, 3)) + ''PM''
		END	AS	''Last Completed DOS'',
	PC.DisplayAs AS ''Previous Proc Code'',
	CONVERT	(varchar, SS.DateOfService, 101) + '' '' +
		CASE	WHEN	substring(convert(varchar, SS.DateOfService, 108), 1, 2) = 00
			THEN	convert(varchar(2), 12) + substring(convert(varchar, SS.DateOfService, 108), 3, 3) + ''AM''
			WHEN	substring(convert(varchar, SS.DateOfService, 108), 1, 2) < 12
			THEN	substring(convert(varchar, SS.DateOfService, 108), 1, 5) + ''AM''
			WHEN	substring(convert(varchar, SS.DateOfService, 108), 1, 2) = 12
			THEN	substring(convert(varchar, SS.DateOfService, 108), 1, 5) + ''PM''
			WHEN	convert(varchar(2), substring(convert(varchar,SS.DateOfService, 108), 1, 2) - 12) < 10
			THEN	''0'' + convert(varchar(2), substring(convert(varchar, SS.DateOfService, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, SS.DateOfService, 108), 3, 3)) + ''PM''
			ELSE	convert(varchar(2), substring(convert(varchar, SS.DateOfService, 108), 1, 2) - 12) +
				convert(varchar(3), substring(convert(varchar, SS.DateOfService, 108), 3, 3)) + ''PM''
		END	AS	''Previous No Show'',
	c.proc_chron,
	SS.DateOfService,
	CASE WHEN EXISTS	(	SELECT	ClientId
					FROM	Documents D
					WHERE	CS.ClientId = D.ClientId
							AND	D.DocumentCodeId IN (''1000121'',''1000090'',''1000091'',''1000119'',''1000120'',''1000121'')
							/*''Transferred to Med Clinic'',
							''Caution Letter - Child'',
							''Caution Letter - Adult'',
							''Close to Medical Only - Adult'',
							''Close to Medical Only - Child''*/
							AND ISNULL(D.RecordDeleted,''N'')<>''Y'')
						--	AND	de.is_locked = ''Y''        Is Locking a feature in smartcare
			
		THEN	''X''
		ELSE	''''
	END	AS	''Document''

FROM	@clients c
	JOIN Clients CS
		ON	(c.patient_id = CS.ClientId
		AND ISNULL(CS.RecordDeleted,''N'')<>''Y'')
	JOIN Staff S 
		ON (c.clinician_id = S.StaffId
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
	LEFT JOIN @last_dos l
		ON	c.patient_id = l.patient_id
	LEFT JOIN	Services SS  
		ON	(c.patient_id = SS.ClientId
		AND	SS.Status =  ''72'' --''NS''
		AND SS.ProcedureCodeId in (''484'', ''391'', ''390'', ''91'', ''90'') --(''PSYCH_EVAL'', ''MED_IND'', ''MED_YOUTH'', ''PED_ESTPT'', ''PED_CONS'')
		AND	SS.DateOfService >= dateadd(mm, -6, @start_date)
		AND	SS.DateOfService < c.proc_chron
		AND ISNULL(SS.RecordDeleted,''N'')<>''Y'')
	LEFT JOIN ProcedureCodes PC	
		ON (PC.ProcedureCodeId = SS.ProcedureCodeId
		AND ISNULL(PC.RecordDeleted,''N'')<>''Y'')
ORDER	BY
	c.location,
	''Clinician'',
	c.proc_chron,
	''Client'',
	SS.DateOfService DESC






' 
END
GO
