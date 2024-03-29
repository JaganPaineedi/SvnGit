/****** Object:  StoredProcedure [dbo].[csp_Report_treatment_plan_report]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_treatment_plan_report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_treatment_plan_report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_treatment_plan_report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_treatment_plan_report]
	@StaffId int,
	@staff_super_or_vp	varchar(10)

AS
--*/

/*	
DECLARE	@StaffId int,
		@staff_super_or_vp	varchar(10)

SELECT	@StaffId = 700,	-- 
		@staff_super_or_vp = 	''super''
--*/

/********************************************************/
/* Stored Procedure: csp_Report_treatment_plan_report	*/
/*						(formerly csp_tx_plan_report	*/
/* Creation Date:    08/07/2008							*/
/*														*/
/* Purpose: Supervisor Reports							*/
/*														*/
/* Called By: Treatment Plan Report						*/
/*														*/
/* Updates:												*/
/*  Date		Author	Purpose							*/
/*  08/07/2007	Jess	Created - WO 10535.  This is	*/
/*						a consolidation of a few 		*/
/*						existing reports plus new data.	*/
/*  01/05/2009	Jess	Modified - WO 11515				*/
/*  03/18/2009 Jess		Modified - WO 12147				*/
/*  05/11/2009 Jess		Modified - WO 12561				*/
/*  07/16/2009 Jess		Converted from Psych Consult	*/
/********************************************************/



--***************************************************************************
--***** Jess''s Staff / Super / VP Module ************************************
--***************************************************************************
DECLARE	@Staff	TABLE
	(
	StaffId int
	)

DECLARE @vp_loop	int
	
IF	@StaffId = 0
BEGIN
	INSERT	@Staff
	SELECT	StaffId
	FROM	Staff
	WHERE	Active = ''Y''
	AND		ISNULL(RecordDeleted, ''N'') <> ''Y''
END

IF	@StaffId <> 0
BEGIN
	INSERT	@Staff
	SELECT	@StaffId
END

IF	(@StaffId <> 0 AND @staff_super_or_vp = ''Super'')
BEGIN
	INSERT	@Staff
	SELECT	StaffId
	FROM	StaffSupervisors
	WHERE	SupervisorId = @StaffId
	AND		StaffId NOT IN (SELECT StaffId FROM @Staff)
END

IF	(@StaffId <> 0 AND @staff_super_or_vp = ''VP'')
BEGIN
	SELECT	@vp_loop = 0
	
	WHILE	@vp_loop < 10
	BEGIN
		INSERT	@Staff
		SELECT	StaffId
		FROM	StaffSupervisors
		WHERE	SupervisorId IN (SELECT StaffId FROM @Staff)
		AND		StaffId NOT IN (SELECT StaffId FROM @Staff)
		SELECT	@vp_loop = @vp_loop + 1
	END
END
--***************************************************************************
--***** END OF Jess''s Staff / Super / VP Module *****************************
--***************************************************************************

--select * from @Staff


DECLARE	@Clients TABLE
(
	ClientId			int,
	EpisodeStartDate	datetime,
	PrimaryClinicianId	int
)

DECLARE	@Plans TABLE
(
	ClientId			int,
	DocumentVersionId	int,
	CoordinatorId		int,
	SignatureDate		datetime
)

DECLARE	@ClientsAndPlans TABLE
(
	ClientId			int,
	EpisodeStartDate	datetime,
	PrimaryClinicianId	int,
	DocumentVersionId	int,
	CoordinatorId		int,
	SignatureDate		datetime
)

DECLARE	@InitialVisits TABLE
(
	ClientId	int,
	EpisodeStartDate	datetime,
	FirstDOS	datetime
)

DECLARE	@Visits	TABLE
	(
	ClientId	int,
	EpisodeStartDate	datetime,
	Visits		int	
	)

DECLARE	@QualifyingClients	TABLE
	(
	ClientId	int,
	EpisodeStartDate	datetime,
	FirstDOS	datetime,
	Visits		int
	)

DECLARE	@Loop	int

DECLARE	@FifthVisit	TABLE
	(
	ClientId	int,
	EpisodeStartDate	datetime,
	FirstDOS	datetime,
	FifthDOS	datetime
	)

DECLARE	@EarliestTargetDate TABLE
(
	DocumentVersionId		int,
	TargetDate				datetime
)

DECLARE	@Results TABLE
(
	ClientId			int,
	Client				varchar(70),
	PrimaryClinician	varchar(70),
	SignatureDate		varchar(10),
	VisitsSinceInitial	varchar(10),
	DaysSinceInitial	varchar(10),
	FirstDOS			varchar(10),
	FifthDOS			varchar(10),
	OverdueDate			varchar(10),
	ReviewDate			varchar(10),
	EarliestTargetDate	varchar(10)
)

DECLARE	@ProcedureCodesToExclude TABLE
(
	DisplayAs	varchar(20)
)

INSERT	INTO @ProcedureCodesToExclude
SELECT				''ASG_SKCLAS''	-- Added 7/9/09 by Jess
UNION ALL	SELECT	''DVG_EDUC''
UNION ALL	SELECT	''EAP_CLASS1''
UNION ALL	SELECT	''EAP_CLASS2''
UNION ALL	SELECT	''EDUC_CLASS''
UNION ALL	SELECT	''EDUC_NBCLA''
UNION ALL	SELECT	''JSST_CLAS''


INSERT	INTO	@Clients
SELECT	C.ClientId,
		CE.RegistrationDate,
		C.PrimaryClinicianId
FROM	Clients C
JOIN	ClientEpisodes CE
ON		C.ClientID = CE.ClientId
AND		C.CurrentEpisodeNumber = CE.EpisodeNumber
JOIN	@Staff ST
ON		C.PrimaryClinicianId = ST.StaffId
WHERE	C.Active = ''Y''
AND		EXISTS	(	SELECT	S.ServiceId
					FROM	Services S
					JOIN	Programs P
					ON		S.ProgramId = p.ProgramId
					AND		P.ServiceAreaId NOT IN (''2'', ''5'')	--EAP, VOC
					AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
					JOIN	ProcedureCodes PC
					ON		S.ProcedureCodeId = PC.ProcedureCodeId
					AND		PC.DisplayAs NOT IN (SELECT X.DisplayAs FROM @ProcedureCodesToExclude X)
					AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
					WHERE	C.ClientId = S.ClientId
					AND		S.Status = 75 -- Completed
					AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
				)
AND		ISNULL(C.RecordDeleted, ''N'') <> ''Y''

--and c.ClientId = 116379

INSERT	INTO	@Plans
SELECT	C.ClientId,
--		DV.DocumentVersionId,
		D.CurrentDocumentVersionId,
		D.AuthorId,
		DS.SignatureDate
FROM	@Clients C
JOIN	Documents D
ON		C.ClientId = D.ClientId
AND		D.DocumentCodeId in (2, 1483, 1484, 1485)	-- Treatment Plan (from Psych Consult), Initial Treatment Plan, Treatment Plan Update, Treatment Plan Review
AND		D.Status <> 23 -- Cancelled
AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
--JOIN	DocumentVersions DV
--ON		D.CurrentDocumentVersionId = DV.DocumentVersionId
--AND		ISNULL(DV.RecordDeleted, ''N'') <> ''Y''
JOIN	DocumentSignatures DS
ON		D.DocumentId = DS.DocumentId
AND		D.CurrentDocumentVersionId = DS.SignedDocumentVersionId
AND		D.AuthorId = DS.StaffId
AND		ISNULL(DS.RecordDeleted, ''N'') <> ''Y''
AND		DS.SignatureDate IS NOT NULL
WHERE	D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
								FROM	Documents D2
								--JOIN	DocumentVersions DV2
								--ON		D2.CurrentDocumentVersionId = DV2.DocumentVersionId
								--AND		ISNULL(DV2.RecordDeleted, ''N'') <> ''Y''
								JOIN	DocumentSignatures DS2
								ON		D2.DocumentId = DS2.DocumentId
								AND		D2.CurrentDocumentVersionId = DS2.SignedDocumentVersionId
								AND		DS2.StaffId = D2.AuthorId
								AND		DS2.SignatureDate IS NOT NULL
								AND		ISNULL(DS2.RecordDeleted, ''N'') <> ''Y''
								WHERE	D.ClientId = D2.ClientId
								AND		D2.DocumentCodeId in (2, 1483, 1484, 1485)	-- Treatment Plan (from Psych Consult), Initial Treatment Plan, Treatment Plan Update, Treatment Plan Review
								AND		D2.Status <> 23 -- Cancelled
								AND		ISNULL(D2.RecordDeleted, ''N'') <> ''Y''
							)
						
AND		D.CreatedDate =	(	SELECT	MAX(D3.CreatedDate)
							FROM	Documents D3
							JOIN	DocumentSignatures DS3
							ON		D.DocumentId = DS3.DocumentId
							AND		D.CurrentDocumentVersionId = DS3.SignedDocumentVersionId
							AND		D.AuthorId = DS3.StaffId
							AND		DS3.SignatureDate IS NOT NULL
							AND		ISNULL(DS3.RecordDeleted, ''N'') <> ''Y''
							WHERE	D.ClientId = D3.ClientId
							AND		D3.DocumentCodeId in (2, 1483, 1484, 1485)	-- Treatment Plan (from Psych Consult), Initial Treatment Plan, Treatment Plan Update, Treatment Plan Review
							AND		D3.Status <> 23 -- Cancelled
							AND		D.EffectiveDate = D3.EffectiveDate
							AND		ISNULL(D3.RecordDeleted, ''N'') <> ''Y''
						)

/*
 select ''@Clients'', * from @Clients order by ClientId
 select ''@Plans'', * from @Plans order by ClientId
*/

INSERT	INTO	@ClientsAndPlans
SELECT	C.*,
		P.DocumentVersionId,
		P.CoordinatorId,
		P.SignatureDate
FROM	@Clients C
LEFT	JOIN	@Plans P
ON		C.ClientId = P.ClientId
ORDER	BY
		C.ClientId

INSERT	INTO @InitialVisits
SELECT	CAP.ClientId,
		CAP.EpisodeStartDate,
		MIN(S.DateOfService)
FROM	@ClientsAndPlans CAP
JOIN	Services S
ON		CAP.ClientId = S.ClientId
AND		CAP.EpisodeStartDate <= S.DateOfService
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN	Programs P
ON		S.ProgramId = p.ProgramId
AND		P.ServiceAreaId NOT IN (''2'', ''5'')	--EAP, VOC
AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
AND		PC.DisplayAs NOT IN (SELECT X.DisplayAs FROM @ProcedureCodesToExclude X)
AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
WHERE	S.Billable = ''Y''
AND		S.Status in (''71'', ''75'')	-- Show, Complete
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
AND		CAP.SignatureDate IS NULL

GROUP	BY
		CAP.ClientId,
		CAP.EpisodeStartDate
ORDER	BY
		CAP.ClientId

--	select ''CAP'', * From @ClientsAndPlans

INSERT	INTO	@Visits --	This will calculate how many follow up visits the client has had since their "initial" one.
SELECT	IV.ClientId,
		IV.EpisodeStartDate,
		COUNT	(DISTINCT S.ServiceId) - 1 as ''Visits''
FROM	@InitialVisits IV
JOIN	Services S
ON		IV.ClientId = S.ClientId
AND		IV.EpisodeStartDate <= S.DateOfService
AND		S.Status in (''71'', ''75'') -- Show, Complete
AND		S.Billable = ''Y''
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN	Programs P
ON		S.ProgramId = p.ProgramId
AND		P.ServiceAreaId NOT IN (''2'', ''5'')	--EAP, VOC
AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
AND		PC.DisplayAs NOT IN (SELECT X.DisplayAs FROM @ProcedureCodesToExclude X)
AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
GROUP	BY
		IV.ClientId,
		IV.EpisodeStartDate
ORDER	BY
		IV.ClientId

INSERT	INTO	@QualifyingClients	--	These are the clients that qualify as having 30 days and 5 visits since their "initial" visit
SELECT	IV.*,
		V.Visits
FROM	@InitialVisits IV
LEFT	JOIN	@Visits V
ON		IV.ClientId = V.ClientId


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ This section will calculate the date of the 5th visit after the "initial" one ~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INSERT	INTO	@FifthVisit
SELECT	QC.ClientId,
		QC.EpisodeStartDate,
		QC.FirstDOS,
		MIN(S.DateOfService)
FROM	@QualifyingClients QC
JOIN	Services S
ON		QC.ClientId = S.ClientId
AND		QC.EpisodeStartDate <= S.DateOfService
AND		S.DateOfService > QC.FirstDOS
AND		S.Status in (''71'', ''75'') -- Show, Complete
AND		S.Billable = ''Y''
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN	Programs P
ON		S.ProgramId = p.ProgramId
AND		P.ServiceAreaId NOT IN (''2'', ''5'')	--EAP, VOC
AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
AND		PC.DisplayAs NOT IN (SELECT X.DisplayAs FROM @ProcedureCodesToExclude X)
AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
WHERE	QC.Visits >=5
GROUP	BY
		QC.ClientId,
		QC.EpisodeStartDate,
		QC.FirstDOS
SELECT	@Loop = 1

WHILE	@Loop < 5
BEGIN
	UPDATE	@FifthVisit
	SET		FifthDOS = S.DateOfService
	FROM	@FifthVisit FV
	JOIN	Services S
	ON		FV.ClientId = S.ClientId
	AND		FV.EpisodeStartDate <= S.DateOfService
	WHERE	S.DateOfService =	(	SELECT	MIN(S2.DateOfService)
									FROM	Services S2
									JOIN	Programs P2
									ON		S2.ProgramId = P2.ProgramId
									AND		P2.ServiceAreaId NOT IN (''2'', ''5'')	--EAP, VOC
									AND		ISNULL(P2.RecordDeleted, ''N'') <> ''Y''
									JOIN	ProcedureCodes PC2
									ON		S2.ProcedureCodeId = PC2.ProcedureCodeId
									AND		PC2.DisplayAs NOT IN (SELECT X.DisplayAs FROM @ProcedureCodesToExclude X)
									AND		ISNULL(PC2.RecordDeleted, ''N'') <> ''Y''
									WHERE	FV.ClientId= S2.ClientId
									AND		FV.EpisodeStartDate <= S2.DateOfService
									AND		FV.FifthDOS < S2.DateOfService
									AND		S2.Status in (''71'', ''75'')
								)

	SELECT	@Loop = @Loop + 1
END
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF This section will calculate the date of the 5th visit after the "initial" one ~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


INSERT	INTO	@EarliestTargetDate
SELECT	P.DocumentVersionId,
		TG2.TheMin
FROM	@Plans P
INNER	JOIN	(	SELECT	TG.DocumentVersionId,
							Min(TG.TargeDate) AS ''TheMin''
					FROM	(	SELECT	CG.DocumentVersionId,
										CG.TargeDate
								FROM	CustomTPGoals CG

							UNION	ALL
					
								SELECT	CG.DocumentVersionId,
										CO.TargetDate
								FROM	CustomTPGoals CG
								JOIN	CustomTPObjectives CO
								ON		CG.TPGoalId = CO.TPGoalId
							)	AS	TG
					GROUP	BY
							TG.DocumentVersionId
				)	AS	TG2
ON		P.DocumentVersionId = TG2.DocumentVersionId
					
		
INSERT	INTO	@Results
SELECT	CAP.ClientId,
		C.LastName + '', '' + C.FirstName, -- AS ''Client'',
		S.LastName + '', '' + S.FirstName, -- AS ''PrimaryClinician'',
		CASE	WHEN	CAP.SignatureDate IS NULL
				THEN	''No''
				ELSE	''Yes''
		END,	--AS	''SignDate''
		CASE	WHEN	(	CAP.SignatureDate IS NULL
						AND	QC.FirstDOS IS NULL
						)
				THEN	''N/A''
				WHEN	(	CAP.SignatureDate IS NULL
						AND	QC.FirstDOS IS NOT NULL
						AND	V.Visits IS NULL
						)
				THEN	''0''
				WHEN	CAP.SignatureDate IS NOT NULL
				THEN	''N/A''
				ELSE	CONVERT(varchar, V.Visits)
		END,	--AS	''Visits Since Initial''
		CASE	WHEN	(	CAP.SignatureDate IS NULL
						AND	QC.FirstDOS IS NULL
						)
				THEN	''N/A''
				WHEN	CAP.SignatureDate IS NOT NULL
				THEN	''N/A''
				ELSE	CONVERT(varchar, DATEDIFF(dd, QC.FirstDOS, getdate()))
		END,		--AS	''Days Since Initial'',
		CASE	WHEN	(	CAP.SignatureDate IS NULL
						AND	QC.FirstDOS IS NULL
						)
				THEN	''None Yet''	--	''No Qualifying First Visit Yet''
				WHEN	CAP.SignatureDate IS NOT NULL
				THEN	''N/A''
				ELSE	CONVERT(varchar, QC.FirstDOS, 101)
		END,		--AS	''First DOS'',
		CASE	WHEN	(	CAP.SignatureDate IS NULL
						AND	FV.FifthDOS IS NULL
						)
				THEN	''Not 5 Yet''	--	''No Qualifying 5th Visit Yet''
				WHEN	CAP.SignatureDate IS NOT NULL
				THEN	''N/A''
				ELSE	CONVERT(varchar, FV.FifthDOS, 101)
		END,	--AS	''Fifth DOS'',
		CASE	WHEN	FV.FifthDOS IS NULL
				THEN	''N/A''
				WHEN	DATEADD(dd, 30, FV.FirstDOS) >= FV.FifthDOS
				THEN	CONVERT(varchar, DATEADD(dd, 30, FV.FirstDOS), 101)
				ELSE	CONVERT(varchar, FV.FifthDOS, 101)
		END,	--AS	''Overdue Date'',
		CASE	WHEN	CAP.SignatureDate IS NULL
				THEN	''N/A''
				ELSE	CONVERT(varchar, DATEADD (dd, 365, CAP.SignatureDate), 101)
		END,	--AS	''Review Date'',
		CASE	WHEN	ETD.TargetDate IS NULL
				THEN	''N/A''
				ELSE	CONVERT(varchar, ETD.TargetDate, 101)
		END	AS	''Earliest Target Date''

FROM	@ClientsAndPlans CAP
JOIN	Clients C
ON		CAP.ClientId = C.ClientId
JOIN	Staff S
ON		CAP.PrimaryClinicianId = S.StaffId
LEFT	JOIN	@Visits V
ON		CAP.ClientId = V.ClientId
LEFT	JOIN	@QualifyingClients QC
ON		CAP.ClientId = QC.ClientId
LEFT	JOIN	@FifthVisit FV
ON		CAP.ClientId = FV.ClientId
LEFT	JOIN	@EarliestTargetDate ETD
ON		CAP.DocumentVersionId = ETD.DocumentVersionId


/*
select ''@Clients'', * from @Clients
select ''@Plans'', * from @Plans
select ''@ClientsAndPlans'', * from @ClientsAndPlans order by clientid
select ''@Visits'', * from @Visits
select ''@QualifyingClients'', * from @QualifyingClients
select ''@InitialVisits'', * from @InitialVisits
select ''@FifthVisit'', * from @FifthVisit
select ''@EarliestTargetDate'', * from @EarliestTargetDate
select ''@Results'', * from @Results
--*/


SELECT	*,
		CASE	WHEN	SUBSTRING(FirstDOS, 1, 1) in (''0'', ''1'')
				THEN	CONVERT(datetime, FirstDOS)
				ELSE	''12/31/9999''
		END	AS	''FirstDOS_ForSorting'',
		CASE	WHEN	SUBSTRING(FifthDOS, 1, 1) in (''0'', ''1'')
				THEN	CONVERT(datetime, FifthDOS)
				ELSE	''12/31/9999''
		END	AS	''FifthDOS_ForSorting'',
		CASE	WHEN	SUBSTRING(OverdueDate, 1, 1) in (''0'', ''1'')
				THEN	CONVERT(datetime, OverdueDate)
				ELSE	''12/31/9999''
		END	AS	''OverdueDate_ForSorting'',
		CASE	WHEN	SUBSTRING(ReviewDate, 1, 1) in (''0'', ''1'')
				THEN	CONVERT(datetime, ReviewDate)
				ELSE	''12/31/9999''
		END	AS	''ReviewDate_ForSorting'',
		CASE	WHEN	SUBSTRING(EarliestTargetDate, 1, 1) in (''0'', ''1'')
				THEN	CONVERT(datetime, EarliestTargetDate)
				ELSE	''12/31/9999''
		END	AS	''EarliestTargetDate_ForSorting''
FROM	@Results
ORDER	BY
		PrimaryClinician,
		''OverdueDate_ForSorting'',
		''EarliestTargetDate_ForSorting'',
		''ReviewDate_ForSorting'',
		''FirstDOS_ForSorting''
		

' 
END
GO
