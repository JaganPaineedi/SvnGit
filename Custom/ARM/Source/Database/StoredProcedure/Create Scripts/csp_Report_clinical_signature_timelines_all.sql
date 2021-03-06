/****** Object:  StoredProcedure [dbo].[csp_Report_clinical_signature_timelines_all]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_clinical_signature_timelines_all]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_clinical_signature_timelines_all]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_clinical_signature_timelines_all]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_clinical_signature_timelines_all]
		@StartDate1	datetime,
		@EndDate1	datetime,
		@StartDate2	datetime,
		@EndDate2	datetime

AS
--*/

/*	
DECLARE	@StartDate1	datetime,
		@EndDate1	datetime,
		@StartDate2	datetime,
		@EndDate2	datetime

SELECT	@StartDate1 =	''1/1/12'',
		@EndDate1 =		''8/1/12'',
		@StartDate2 =	''8/1/12'',
		@EndDate2 =		''9/1/12''
--*/


/********************************************************************/
/* Stored Procedure:	csp_Report_clinical_signature_timelines_all	*/
/* Creation Date:	01/30/2008										*/
/*																	*/
/* Updates:															*/
/*	Date		Author	Purpose 									*/
/*  01/30/2008	Jess	Created - WO 9102							*/
/*  08/11/2008	Jess	Modified - Added proc codes to the list		*/
/*  07/07/2012	Jess	Converted From Psych Consult				*/
/********************************************************************/


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ Jess''s All Staff By VP Module ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECLARE	@Staff TABLE
(
	StaffId				int,
	DirectSupervisorId	int,
	TopSupervisorId		int
)

DECLARE	@Loop int
SELECT @Loop = 0

INSERT	INTO	@Staff
SELECT	S.StaffId,
		S.StaffId,
		S.StaffId
FROM	Staff S
WHERE	Active = ''Y''
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''

UPDATE	@Staff
SET		DirectSupervisorId = SS.SupervisorId,
		TopSupervisorId = SS.SupervisorId
FROM	@Staff S
JOIN	StaffSupervisors SS
ON		S.DirectSupervisorId = SS.StaffId
WHERE	ISNULL(SS.RecordDeleted, ''N'') <> ''Y''

WHILE	@Loop < 10
BEGIN
	UPDATE	@Staff
	SET		TopSupervisorId = SS.SupervisorId
	FROM	@Staff S
	JOIN	StaffSupervisors SS
	ON		S.TopSupervisorId = SS.StaffId
	WHERE	ISNULL(SS.RecordDeleted, ''N'') <> ''Y''

	SET	@Loop = @Loop + 1
END

--	select * from @Staff

/*	To Display All The Names
SELECT	S1.FirstName + '' '' + S1.LastName AS ''Staff'',
		S2.FirstName + '' '' + S2.LastName AS ''Direct Supervisor'',
		S3.FirstName + '' '' + S3.LastName AS ''Top Level Supervisor''
FROM	@Staff S
JOIN	Staff S1
ON		S.StaffId = S1.StaffId
JOIN	Staff S2
ON		S.DirectSupervisorId = S2.StaffId
JOIN	Staff S3
ON		S.TopSupervisorId = S3.StaffId
ORDER	BY
		''Top Level Supervisor'',
		''Direct Supervisor'',
		''Staff''
*/
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF Jess''s All Staff By VP Module ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DECLARE	@Documents TABLE
	(
	StaffId	int,
	DocumentCodeId int,
	DocumentType varchar(50),
	HoursToSign int
	)

DECLARE	@InitialResults TABLE
	(
	StaffId int,
	DocumentType varchar(50),
	AverageHoursToSign float,
	ErrorFlag char(1)
	)

DECLARE	@MissingDAs TABLE
	(
	StaffId int,
	DocumentType varchar(50),
	Count int
	)

DECLARE	@MissingNotes TABLE
	(
	StaffId int,
	DocumentType varchar(50),
	Count int
	)

DECLARE	@DateRange1Results TABLE
	(
	StaffId int,
	DocumentType varchar(50),
	AverageHoursToSign float,
	ErrorFlag char(1),
	Missing int
	)

DECLARE	@DateRange2Results TABLE
	(
	StaffId int,
	DocumentType varchar(50),
	AverageHoursToSign float,
	ErrorFlag char(1),
	Missing int
	)
	
DECLARE	@Results TABLE
(	StaffId int,
	DocumentType varchar(50),
	AverageHoursToSign1 float,
	ErrorFlag1 char(1),
	Missing1 int,
	AverageHoursToSign2 float,
	ErrorFlag2 char(1),
	Missing2 int
)


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ This Section Gathers all of the Date Range 1 Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INSERT	INTO	@Documents
SELECT	S.ClinicianId,
		D.DocumentCodeId,
		CASE	WHEN	DocumentCodeId  in	(	''10005'',	-- Diagnostic Assessment
												''1486''		-- Diagnostic Assessment
											)
				THEN	''DAs''
				WHEN	DocumentCodeId in	(	''10004'',	-- Clinical Progress Note
												''10014'',	-- Counseling Note
												''10015'',	-- CPST Note
												''10017''		-- Partial Hospital/ Day Treatment Note
											)
				THEN	''Counseling/CPST/PartialHosp Notes''
		END, -- Document Type
		CONVERT(varchar, DATEDIFF(HH, S.DateOfService, MIN(DS.SignatureDate)))
FROM	Documents D
JOIN	Services S
ON		D.ServiceId = S.ServiceId
AND		S.Status IN	(''71'', ''75'') -- Show, Complete
JOIN	DocumentSignatures DS
ON		D.DocumentId = DS.DocumentId
AND		D.CurrentDocumentVersionId = DS.SignedDocumentVersionId
AND		S.ClinicianId = DS.StaffId
JOIN	@Staff ST
ON		S.ClinicianId = ST.StaffId
WHERE	D.DocumentCodeId in	(	''10004'',	-- Clinical Progress Note
								''10014'',	-- Counseling Note
								''10015'',	-- CPST Note
								''10017'',	-- Partial Hospital/ Day Treatment Note
								''10005'',	-- Diagnostic Assessment
								''1486''		-- Diagnostic Assessment
							)
AND		S.DateOfService >= @StartDate1
AND		S.DateOfService < DATEADD(DD, 1, @EndDate1)
AND		S.ProcedureCodeId <> 85 -- ''CSP_UND8''	-- added by Jess 8/11/08
AND		D.Status = 22 -- Signed
/*
AND	(	pct.proc_code in (''ASSESSMENT'', ''GROUP_CN'', ''INDIV_CN'', ''FAMILY_CN'', ''PSYCH_TEST'', ''EAP_ASSESS'', ''EAP_MD_AST'', ''CRISIS_INT'', ''NB_PHOSP+N'')  -- EAP_ASSESS, EAP_MD_AST, EAP_COUN, CRISIS_INT added by Jess 8/11/08  -- NB_PHOSP+N added by Jess 8/12/08
	OR	pct.proc_code like ''CSP%''
	OR	(	pct.proc_code = ''PART_HOSP''
		AND	pct.proc_chron >= ''8/28/07''
		)
	)
*/
GROUP	BY
		S.ClinicianId,
		D.DocumentCodeId,
		S.DateOfService
ORDER	BY
		S.ClinicianId


INSERT	INTO	@InitialResults
SELECT	StaffId,
		DocumentType,
		CONVERT(float, SUM(HoursToSign)) / CONVERT(float, COUNT(StaffId)), -- ''Average Hours To Sign''
		CASE	WHEN	(	DocumentType = ''DAs''
						AND	CONVERT(float, SUM(HoursToSign)) / CONVERT(float, COUNT(StaffId)) > 72
						)
				THEN	''Y''
				WHEN	(	DocumentType = ''Counseling/CPST/PartialHosp Notes''
						AND	CONVERT(float, SUM(HoursToSign)) / CONVERT(float, COUNT(StaffId)) > 24
						)
				THEN	''Y''				
				ELSE	''N''
		END	-- ''Late Flag''
FROM	@Documents
GROUP	BY
		StaffId,
		DocumentType





/*
INSERT	INTO	@missing_da
SELECT	pct.clinician_id,
	''DIAG_SUMM'',
	COUNT(pct.clinical_transaction_no)
FROM	patient_clin_tran pct with (nolock)
WHERE	pct.proc_chron between @start_date1 and dateadd(dd, 1, @end_date1)
AND	pct.clinician_id in	(
				SELECT	Staff_id
				FROM	@Staff
				)
AND	pct.proc_code in (''ASSESSMENT'')
AND	pct.status in (''SH'', ''CO'')

/*
AND	NOT	EXISTS	(
			SELECT	de.doc_session_no
			FROM	doc_entity de
			WHERE	pct.clinical_transaction_no = de.entity_type_id
			AND	de.doc_code in (''DIAG_SUMM'', ''SA_ASSESS'')
			AND	de.status in (''SN'', ''SA'')
			)
*/



AND	(	(
		pct.patient_id not in	(
					SELECT	de.patient_id
					FROM	doc_entity de with (nolock)
					WHERE	pct.clinical_transaction_no = de.clinical_transaction_no
					AND	de.doc_code in (''diagassess'', ''sa_assess'', ''da_update'', ''diag_summ'')
					AND	de.status = ''SA''
					)
		)

--	CASE 2:	There must be either a diag_summ, diagassess or sa_assess for every Assessment visit in Episode 001. (DA Updates are not allowed for Episode 001).
	OR	(	pct.episode_id = ''001''
		AND	pct.patient_id not in	(
						SELECT	de.patient_id
						FROM	doc_entity de with (nolock)
						WHERE	pct.clinical_transaction_no = de.clinical_transaction_no
						AND	de.doc_code in (''diagassess'', ''sa_assess'', ''diag_summ'')
						AND	de.status = ''SA''
						)
		)

--	CASE 3:	There must be either a diag_summ, diagassess or sa_assess for every Assessment visit where the previous episode was closed over a year ago. (DA Updates are not allowed when previous episode was closed > 1 year ago).
	OR	(	pct.episode_id > 001
		AND	pct.patient_id not in	(
						SELECT	de.patient_id
						FROM	doc_entity de with (nolock)
						WHERE	pct.clinical_transaction_no = de.clinical_transaction_no
						AND	de.doc_code in (''diagassess'', ''sa_assess'', ''diag_summ'')
						AND	de.status = ''SA''
						)
		AND	datediff	(dd,	(	SELECT	p.episode_close_date
							FROM	patient p with (nolock)
							WHERE	pct.patient_id = p.patient_id
							AND	pct.episode_id = (p.episode_id + 1)
						), getdate()
					) > 365
		)
	)
GROUP	BY
	pct.clinician_id
ORDER	BY
	pct.clinician_id

INSERT	INTO	@missing_prognote
SELECT	pct.clinician_id,
	''PROGNOTE'',
	COUNT(pct.clinical_transaction_no)
FROM	patient_clin_tran pct with (nolock)
WHERE	pct.proc_chron between @start_date1 and dateadd(dd, 1, @end_date1)
AND	pct.clinician_id in	(
				SELECT	Staff_id
				FROM	@Staff
				)
AND	(	pct.proc_code in (''INDIV_CN'', ''GROUP_CN'', ''FAMILY_CN'', ''PSYCH_TEST'', ''CRISIS_INT'', ''NB_PHOSP+N'')	-- CRISIS_INT and NB_PHOSP+N added by Jess 8/13/08
	OR	pct.proc_code like ''CSP%''
	OR	(	pct.proc_code = ''PART_HOSP''
		AND	pct.proc_chron >= ''8/28/07''
		)
	)
AND	pct.status in (''SH'', ''CO'')
AND	NOT	EXISTS	(
			SELECT	de.doc_session_no
			FROM	doc_entity de
			WHERE	pct.clinical_transaction_no = de.entity_type_id
			AND	de.doc_code in (''PROGNOTE'', ''DA_UPDATE'')
			AND	de.status in (''SA'')
			)
GROUP	BY
	pct.clinician_id
ORDER	BY
	pct.clinician_id
*/
/*
SELECT	*	FROM	@initial_results
SELECT	*	FROM	@missing_da
SELECT	*	FROM	@missing_prognote
*/

INSERT	INTO	@DateRange1Results
SELECT	IR.StaffId,
		IR.DocumentType,
		IR.AverageHoursToSign,
		IR.ErrorFlag,
		CASE	WHEN	(	IR.DocumentType = ''DAs''
							AND	MD.Count IS NULL
						)
				THEN	0
				WHEN	(	IR.DocumentType = ''Counseling/CPST/PartialHosp Notes''
							AND	MN.Count IS NULL
						)
				THEN	0
				WHEN	(	IR.DocumentType = ''DAs''
							AND	MD.Count IS NOT NULL
						)
				THEN	MD.Count
				WHEN	(	IR.DocumentType = ''Counseling/CPST/PartialHosp Notes''
							AND	MN.Count IS NOT NULL
						)
				THEN	MN.Count
		END	AS	''Missing''
FROM	@InitialResults IR
LEFT	JOIN	@MissingDAs MD
ON		IR.StaffId = MD.StaffId
LEFT	JOIN	@MissingNotes MN
ON		IR.StaffId = MN.StaffId


INSERT	INTO	@DateRange1Results
SELECT	MD.StaffId,
		MD.DocumentType,
		0,
		''N'',
		MD.Count
FROM	@MissingDAs MD
WHERE	MD.Count IS NOT NULL
AND		NOT EXISTS	(	SELECT	IR.StaffId
						FROM	@InitialResults IR
						WHERE	IR.StaffId = MD.StaffId
						AND		IR.DocumentType = ''DAs''
					)

INSERT	INTO	@DateRange1Results
SELECT	MN.StaffId,
		MN.DocumentType,
		0,
		''N'',
		MN.Count
FROM	@MissingNotes MN
WHERE	MN.Count IS NOT NULL
AND		NOT EXISTS	(	SELECT	IR.StaffId
						FROM	@InitialResults IR
						WHERE	IR.StaffId = MN.StaffId
						AND		IR.DocumentType = ''DAs''
					)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF This Section Gathers all of the Date Range 1 Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
select * from @documents
select * from @InitialResults
select * from @DateRange1Results
*/

DELETE	FROM	@Documents
DELETE	FROM	@InitialResults
DELETE	FROM	@MissingDAs
DELETE	FROM	@MissingNotes

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ This Section Gathers all of the Date Range 2 Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INSERT	INTO	@Documents
SELECT	S.ClinicianId,
		D.DocumentCodeId,
		CASE	WHEN	DocumentCodeId  in	(	''10005'',	-- Diagnostic Assessment
												''1486''		-- Diagnostic Assessment
											)
				THEN	''DAs''
				WHEN	DocumentCodeId in	(	''10004'',	-- Clinical Progress Note
												''10014'',	-- Counseling Note
												''10015'',	-- CPST Note
												''10017''		-- Partial Hospital/ Day Treatment Note
											)
				THEN	''Counseling/CPST/PartialHosp Notes''
		END, -- Document Type
		CONVERT(varchar, DATEDIFF(HH, S.DateOfService, MIN(DS.SignatureDate)))
FROM	Documents D
JOIN	Services S
ON		D.ServiceId = S.ServiceId
AND		S.Status IN	(''71'', ''75'') -- Show, Complete
JOIN	DocumentSignatures DS
ON		D.DocumentId = DS.DocumentId
AND		D.CurrentDocumentVersionId = DS.SignedDocumentVersionId
AND		S.ClinicianId = DS.StaffId
JOIN	@Staff ST
ON		S.ClinicianId = ST.StaffId
WHERE	D.DocumentCodeId in	(	''10004'',	-- Clinical Progress Note
								''10014'',	-- Counseling Note
								''10015'',	-- CPST Note
								''10017'',	-- Partial Hospital/ Day Treatment Note
								''10005'',	-- Diagnostic Assessment
								''1486''		-- Diagnostic Assessment
							)
AND		S.DateOfService >= @StartDate2
AND		S.DateOfService < DATEADD(DD, 1, @EndDate2)
AND		S.ProcedureCodeId <> 85 -- ''CSP_UND8''	-- added by Jess 8/11/08
AND		D.Status = 22 -- Signed
/*
AND	(	pct.proc_code in (''ASSESSMENT'', ''GROUP_CN'', ''INDIV_CN'', ''FAMILY_CN'', ''PSYCH_TEST'', ''EAP_ASSESS'', ''EAP_MD_AST'', ''CRISIS_INT'', ''NB_PHOSP+N'')  -- EAP_ASSESS, EAP_MD_AST, EAP_COUN, CRISIS_INT added by Jess 8/11/08  -- NB_PHOSP+N added by Jess 8/12/08
	OR	pct.proc_code like ''CSP%''
	OR	(	pct.proc_code = ''PART_HOSP''
		AND	pct.proc_chron >= ''8/28/07''
		)
	)
*/
GROUP	BY
		S.ClinicianId,
		D.DocumentCodeId,
		S.DateOfService
ORDER	BY
		S.ClinicianId


INSERT	INTO	@InitialResults
SELECT	StaffId,
		DocumentType,
		CONVERT(float, SUM(HoursToSign)) / CONVERT(float, COUNT(StaffId)), -- ''Average Hours To Sign''
		CASE	WHEN	(	DocumentType = ''DAs''
						AND	CONVERT(float, SUM(HoursToSign)) / CONVERT(float, COUNT(StaffId)) > 72
						)
				THEN	''Y''
				WHEN	(	DocumentType = ''Counseling/CPST/PartialHosp Notes''
						AND	CONVERT(float, SUM(HoursToSign)) / CONVERT(float, COUNT(StaffId)) > 24
						)
				THEN	''Y''				
				ELSE	''N''
		END	-- ''Late Flag''
FROM	@Documents
GROUP	BY
		StaffId,
		DocumentType





/*
INSERT	INTO	@missing_da
SELECT	pct.clinician_id,
	''DIAG_SUMM'',
	COUNT(pct.clinical_transaction_no)
FROM	patient_clin_tran pct with (nolock)
WHERE	pct.proc_chron between @start_date1 and dateadd(dd, 1, @end_date1)
AND	pct.clinician_id in	(
				SELECT	Staff_id
				FROM	@Staff
				)
AND	pct.proc_code in (''ASSESSMENT'')
AND	pct.status in (''SH'', ''CO'')

/*
AND	NOT	EXISTS	(
			SELECT	de.doc_session_no
			FROM	doc_entity de
			WHERE	pct.clinical_transaction_no = de.entity_type_id
			AND	de.doc_code in (''DIAG_SUMM'', ''SA_ASSESS'')
			AND	de.status in (''SN'', ''SA'')
			)
*/



AND	(	(
		pct.patient_id not in	(
					SELECT	de.patient_id
					FROM	doc_entity de with (nolock)
					WHERE	pct.clinical_transaction_no = de.clinical_transaction_no
					AND	de.doc_code in (''diagassess'', ''sa_assess'', ''da_update'', ''diag_summ'')
					AND	de.status = ''SA''
					)
		)

--	CASE 2:	There must be either a diag_summ, diagassess or sa_assess for every Assessment visit in Episode 001. (DA Updates are not allowed for Episode 001).
	OR	(	pct.episode_id = ''001''
		AND	pct.patient_id not in	(
						SELECT	de.patient_id
						FROM	doc_entity de with (nolock)
						WHERE	pct.clinical_transaction_no = de.clinical_transaction_no
						AND	de.doc_code in (''diagassess'', ''sa_assess'', ''diag_summ'')
						AND	de.status = ''SA''
						)
		)

--	CASE 3:	There must be either a diag_summ, diagassess or sa_assess for every Assessment visit where the previous episode was closed over a year ago. (DA Updates are not allowed when previous episode was closed > 1 year ago).
	OR	(	pct.episode_id > 001
		AND	pct.patient_id not in	(
						SELECT	de.patient_id
						FROM	doc_entity de with (nolock)
						WHERE	pct.clinical_transaction_no = de.clinical_transaction_no
						AND	de.doc_code in (''diagassess'', ''sa_assess'', ''diag_summ'')
						AND	de.status = ''SA''
						)
		AND	datediff	(dd,	(	SELECT	p.episode_close_date
							FROM	patient p with (nolock)
							WHERE	pct.patient_id = p.patient_id
							AND	pct.episode_id = (p.episode_id + 1)
						), getdate()
					) > 365
		)
	)
GROUP	BY
	pct.clinician_id
ORDER	BY
	pct.clinician_id

INSERT	INTO	@missing_prognote
SELECT	pct.clinician_id,
	''PROGNOTE'',
	COUNT(pct.clinical_transaction_no)
FROM	patient_clin_tran pct with (nolock)
WHERE	pct.proc_chron between @start_date1 and dateadd(dd, 1, @end_date1)
AND	pct.clinician_id in	(
				SELECT	Staff_id
				FROM	@Staff
				)
AND	(	pct.proc_code in (''INDIV_CN'', ''GROUP_CN'', ''FAMILY_CN'', ''PSYCH_TEST'', ''CRISIS_INT'', ''NB_PHOSP+N'')	-- CRISIS_INT and NB_PHOSP+N added by Jess 8/13/08
	OR	pct.proc_code like ''CSP%''
	OR	(	pct.proc_code = ''PART_HOSP''
		AND	pct.proc_chron >= ''8/28/07''
		)
	)
AND	pct.status in (''SH'', ''CO'')
AND	NOT	EXISTS	(
			SELECT	de.doc_session_no
			FROM	doc_entity de
			WHERE	pct.clinical_transaction_no = de.entity_type_id
			AND	de.doc_code in (''PROGNOTE'', ''DA_UPDATE'')
			AND	de.status in (''SA'')
			)
GROUP	BY
	pct.clinician_id
ORDER	BY
	pct.clinician_id
*/
/*
SELECT	*	FROM	@initial_results
SELECT	*	FROM	@missing_da
SELECT	*	FROM	@missing_prognote
*/

INSERT	INTO	@DateRange2Results
SELECT	IR.StaffId,
		IR.DocumentType,
		IR.AverageHoursToSign,
		IR.ErrorFlag,
		CASE	WHEN	(	IR.DocumentType = ''DAs''
							AND	MD.Count IS NULL
						)
				THEN	0
				WHEN	(	IR.DocumentType = ''Counseling/CPST/PartialHosp Notes''
							AND	MN.Count IS NULL
						)
				THEN	0
				WHEN	(	IR.DocumentType = ''DAs''
							AND	MD.Count IS NOT NULL
						)
				THEN	MD.Count
				WHEN	(	IR.DocumentType = ''Counseling/CPST/PartialHosp Notes''
							AND	MN.Count IS NOT NULL
						)
				THEN	MN.Count
		END	AS	''Missing''
FROM	@InitialResults IR
LEFT	JOIN	@MissingDAs MD
ON		IR.StaffId = MD.StaffId
LEFT	JOIN	@MissingNotes MN
ON		IR.StaffId = MN.StaffId


INSERT	INTO	@DateRange2Results
SELECT	MD.StaffId,
		MD.DocumentType,
		0,
		''N'',
		MD.Count
FROM	@MissingDAs MD
WHERE	MD.Count IS NOT NULL
AND		NOT EXISTS	(	SELECT	IR.StaffId
						FROM	@InitialResults IR
						WHERE	IR.StaffId = MD.StaffId
						AND		IR.DocumentType = ''DAs''
					)

INSERT	INTO	@DateRange2Results
SELECT	MN.StaffId,
		MN.DocumentType,
		0,
		''N'',
		MN.Count
FROM	@MissingNotes MN
WHERE	MN.Count IS NOT NULL
AND		NOT EXISTS	(	SELECT	IR.StaffId
						FROM	@InitialResults IR
						WHERE	IR.StaffId = MN.StaffId
						AND		IR.DocumentType = ''DAs''
					)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF This Section Gathers all of the Date Range 2 Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


INSERT	INTO	@Results
SELECT	DR1.StaffId,
		DR1.DocumentType,
		DR1.AverageHoursToSign,
		DR1.ErrorFlag,
		DR1.Missing,
		NULL,
		NULL,
		NULL
FROM	@DateRange1Results DR1

UPDATE	@Results
SET		AverageHoursToSign2 = DR2.AverageHoursToSign,
		ErrorFlag2 = DR2.ErrorFlag,
		Missing2 = DR2.Missing
FROM	@Results R, @DateRange2Results DR2
WHERE	R.StaffId = DR2.StaffId
AND		R.DocumentType = DR2.DocumentType

INSERT	INTO	@Results
SELECT	DR2.StaffId,
		DR2.DocumentType,
		NULL,
		NULL,
		NULL,
		DR2.AverageHoursToSign,
		DR2.ErrorFlag,
		DR2.Missing
FROM	@DateRange2Results DR2
WHERE	NOT	EXISTS	(	SELECT	R.StaffId
						FROM	@Results R
						WHERE	R.StaffId = DR2.StaffId
						AND		R.DocumentType = DR2.DocumentType
					)
/*
SELECT * FROM @DateRange1Results
SELECT * FROM @DateRange2Results
*/

SELECT	S3.LastName + '', '' + S3.FirstName AS ''TopLevelSupervisor'',
		S2.LastName + '', '' + S2.FirstName AS ''DirectSupervisor'',
		S1.LastName + '', '' + S1.FirstName AS ''Clinician'',
		R.DocumentType,
		(R.AverageHoursToSign1 / 24) AS ''AverageDaysToSign1'',
		CASE	WHEN	R.ErrorFlag1 = ''Y''
				THEN	''Y''
				ELSE	''N''
		END		AS	''ErrorFlag1'',
		R.Missing1,
		(R.AverageHoursToSign2 / 24) AS ''AverageDaysToSign2'',
		CASE	WHEN	R.ErrorFlag2 = ''Y''
				THEN	''Y''
				ELSE	''N''
		END		AS	''ErrorFlag2'',
		R.Missing2
FROM	@Results R
JOIN	@Staff ST
ON		R.StaffId = ST.StaffId
JOIN	Staff S1
ON		ST.StaffId = S1.StaffId
JOIN	Staff S2
ON		ST.DirectSupervisorId = S2.StaffId
JOIN	Staff S3
ON		ST.TopSupervisorId = S3.StaffId
ORDER	BY
		''TopLevelSupervisor'',
		''DirectSupervisor'',
		''Clinician'',
		R.DocumentType
		

' 
END
GO
