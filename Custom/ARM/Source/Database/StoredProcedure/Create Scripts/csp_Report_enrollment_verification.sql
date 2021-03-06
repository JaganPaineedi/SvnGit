/****** Object:  StoredProcedure [dbo].[csp_Report_enrollment_verification]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_enrollment_verification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_enrollment_verification]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_enrollment_verification]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_enrollment_verification]

	@IntakeStaffLastName	varchar(30),
	@IntakeStaffFirstName	varchar(20)

AS
--*/

/*
DECLARE	@IntakeStaffLastName	varchar(30),
		@IntakeStaffFirstName	varchar(20)

SELECT	@IntakeStaffLastName =	''%'',
		@IntakeStaffFirstName =	''%''
--*/



/****************************************************************/
/* Stored Procedure: csp_Report_enrollment_verification			*/
/* Creation Date:    05/11/2010									*/
/* Copyright:    Harbor											*/
/*																*/
/* Purpose: Verification Reports								*/
/*																*/
/* Called By: Enrollment Verification.rpt						*/
/*																*/
/* Updates:														*/
/* Date			Author		Purpose								*/
/* 05/11/2010	Jess		Created - WO 14300					*/
/* 08/04/2010	Jess		Modified - WO 15341					*/
/* 06/24/2011	Jess		Modified - WO 17993					*/
/* 07/05/2012	Jess		Converted From Psych Consult		*/
/****************************************************************/


DECLARE	@Results TABLE
(
	Section				int,
	ClientId			int,
	Client				varchar(50),
	RegistrationDate	datetime,
	IntakeStaff			varchar(50),
	DateOfService		datetime,
	Location			varchar(50),
	ProcedureCode		varchar(50),
	Reason				int,
	Comment				text,
	Coverage			char(1)
)

INSERT	INTO	@Results
SELECT	DISTINCT
		1,
		C.ClientId,
		C.LastName + '', '' + C.FirstName,
		CE.RegistrationDate,
		ST.LastName + '', '' + ST.FirstName,
		S.DateOfService,
		L.LocationName,
		PC.DisplayAs,
		CCN.ContactReason,
		CCN.ContactDetails,
		null
FROM	Clients C
JOIN	ClientEpisodes CE
	ON	C.ClientId = CE.ClientId
	AND	C.CurrentEpisodeNumber = CE.EpisodeNumber
JOIN	Services S
	ON	C.ClientId = S.ClientId
	AND	ISNULL(S.RecordDeleted, ''N'') = ''N''
JOIN	Locations L
	ON	S.LocationId = L.LocationId
	AND	ISNULL(L.RecordDeleted, ''N'') = ''N''
JOIN	ProcedureCodes PC
	ON	S.ProcedureCodeId = PC.ProcedureCodeId
	AND	ISNULL(PC.RecordDeleted, ''N'') = ''N''
JOIN	ClientContactNotes CCN
	ON	C.ClientId = CCN.ClientId
	AND	CCN.ContactType in (''24422'', ''24424'') -- Intake, Update
	AND	CCN.ContactStatus = 24414 -- Scheduled
	AND	ISNULL(CCN.RecordDeleted, ''N'') = ''N''
LEFT	JOIN	Staff ST
--	ON	CE.CreatedBy = ST.UserCode
	ON	CE.IntakeStaff = ST.StaffId
	AND	ISNULL(ST.RecordDeleted, ''N'') = ''N''
JOIN	Programs P
	ON	S.ProgramId = P.ProgramId
	AND	ISNULL(P.RecordDeleted, ''N'') = ''N''
WHERE	P.ServiceAreaId <> 5 -- VOC
AND		(	P.ServiceAreaId <> 2 -- EAP
		OR	S.ProcedureCodeId = 258 -- EAP_ASSESS
		)
AND		S.ProcedureCodeId <> 272 -- EDUC_CLASS
AND		S.Status in (''71'', ''75'') -- Show, Complete
AND		S.DateOfService =	(	SELECT	MIN(S2.DateOfService)
								FROM	Services S2
								JOIN	Programs P2
									ON	S2.ProgramId = P2.ProgramId
									AND	ISNULL(P2.RecordDeleted, ''N'') = ''N''
								WHERE	S.ClientId = S2.ClientId
								AND		S2.Status in (''71'', ''75'') -- Show, Complete
								AND		P2.ServiceAreaId <> 5 -- VOC
								AND		(	P2.ServiceAreaId <> 2 -- EAP
										OR	S2.ProcedureCodeId = 258 -- EAP_ASSESS
										)
								AND		S2.ProcedureCodeId <> 272 -- EDUC_CLASS
								AND		ISNULL(S2.RecordDeleted, ''N'') = ''N''
							)
AND		(	ST.LastName IS NULL
		OR	ST.LastName like @IntakeStaffLastName
		AND	ST.FirstName like @IntakeStaffFirstName
		)
AND		ISNULL(C.RecordDeleted, ''N'') = ''N''


INSERT	INTO	@results
SELECT	DISTINCT
		2,
		C.ClientId,
		C.LastName + '', '' + C.FirstName,
		CE.RegistrationDate,
		ST.LastName + '', '' + ST.FirstName as ''Intake Staff'',
		S.DateOfService,
		L.LocationName,
		PC.DisplayAs,
		null,
		null,
		null
FROM	Clients C
JOIN	Services S
	ON	C.ClientId = S.ClientId
	AND	ISNULL(S.RecordDeleted, ''N'') = ''N''
JOIN	Programs P
	ON	S.ProgramId = P.ProgramId
	AND	ISNULL(P.RecordDeleted, ''N'') = ''N''
JOIN	Locations L
	ON	S.LocationId = L.LocationId
	AND	ISNULL(L.RecordDeleted, ''N'') = ''N''
JOIN	ProcedureCodes PC
	ON	S.ProcedureCodeId = PC.ProcedureCodeId
	AND	ISNULL(PC.RecordDeleted, ''N'') = ''N''
JOIN	ClientEpisodes CE
	ON	C.ClientId = CE.ClientId
	AND	C.CurrentEpisodeNumber = CE.EpisodeNumber
	AND	ISNULL(CE.RecordDeleted, ''N'') = ''N''
LEFT	JOIN	Staff ST
	ON	CE.IntakeStaff = ST.StaffId
	AND	ISNULL(ST.RecordDeleted, ''N'') = ''N''
WHERE	NOT	EXISTS	(	SELECT	*
						FROM	ClientContactNotes CCN
						WHERE	C.ClientId = CCN.ClientId
						AND		CCN.ContactType in (''24422'', ''24424'') -- Intake, Update
						AND		CCN.ContactStatus in (''24414'', ''24416'') -- Scheduled, Completed
						AND		ISNULL(CCN.RecordDeleted, ''N'') = ''N''
					)
AND		P.ServiceAreaId <> 5 -- VOC
AND		(	P.ServiceAreaId <> 2 -- EAP
		OR	S.ProcedureCodeId = 258 -- EAP_ASSESS
		)
AND		S.ProcedureCodeId <> 272 -- EDUC_CLASS
AND		S.Status in (''71'', ''75'') -- Show, Complete
AND		S.DateOfService >= ''5/24/10''
--/*
AND	NOT	EXISTS	(	SELECT	S2.ServiceId
					FROM	Services S2
					JOIN	Programs P2
						ON	S2.ProgramId = P2.ProgramId
						AND	ISNULL(P2.RecordDeleted, ''N'') = ''N''
					WHERE	S.ClientId = S2.ClientId
					AND		S2.Status in (''71'', ''75'') -- Show, Complete
					AND		P2.ServiceAreaId <> 5 -- VOC
					AND		(	P2.ServiceAreaId <> 2 -- EAP
							OR	S2.ProcedureCodeId = 258 -- EAP_ASSESS
							)
					AND		S2.ProcedureCodeId <> 272 -- EDUC_CLASS
					AND		S2.Status in (''71'', ''75'') -- Show, Complete
					AND		S2.DateOfService < S.DateOfService
					AND		ISNULL(S2.RecordDeleted, ''N'') = ''N''
				)
--*/
/*
AND	S.DateOfService =	(	SELECT	MIN(S2.DateOfService)
							FROM	Services S2
							JOIN	Programs P2
								ON	S2.ProgramId = P2.ProgramId
								AND	ISNULL(P2.RecordDeleted, ''N'') = ''N''
							WHERE	S.ClientId = S2.ClientId
							AND		S2.Status in (''71'', ''75'') -- Show, Complete
							AND		P2.ServiceAreaId <> 5 -- VOC
							AND		(	P2.ServiceAreaId <> 2 -- EAP
									OR	S2.ProcedureCodeId = 258 -- EAP_ASSESS
									)
							AND		S2.ProcedureCodeId <> 272 -- EDUC_CLASS
							AND		S2.Status in (''71'', ''75'') -- Show, Complete
							AND		ISNULL(S2.RecordDeleted, ''N'') = ''N''
					)
--*/
AND	(	ST.LastName is null
	OR	(	ST.LastName like @IntakeStaffLastName
		AND	ST.FirstName like @IntakeStaffFirstName
		)
	)
AND		ISNULL(C.RecordDeleted, ''N'') = ''N''



UPDATE	@results
SET		coverage = ''X''
FROM	@results R
WHERE	NOT EXISTS	(	SELECT	CCP.ClientCoveragePlanId
						FROM	ClientCoveragePlans CCP
						WHERE	R.ClientId = CCP.ClientId
						AND		ISNULL(CCP.RecordDeleted, ''N'') = ''N''
					)

SELECT	R.Section,
		R.ClientId,
		R.Client,
		ISNULL(CONVERT(varchar, R.RegistrationDate, 101), ''_'') AS ''RegistrationDate'',
		CASE	WHEN	R.Section = 1
				THEN	R.IntakeStaff
				WHEN	R.Section = 2
				THEN	R.Client
		END	AS	''SortableField'',
		ISNULL(R.IntakeStaff, ''**NO INTAKE STAFF**'') AS	''IntakeStaff'',
		R.DateOfService,
		R.Location,
		R.ProcedureCode,
		dbo.csf_GetGlobalCodeNameById(R.Reason) AS ''Reason'',
		R.Comment,
		ISNULL(R.Coverage, ''_'') AS ''Coverage''
FROM	@Results R
WHERE	ClientId <> 114865  -- Fulton Achivement, Program  -- Added by Jess 6/24/11
ORDER	BY
		R.Section,
		R.Location,
		''IntakeStaff'',
		R.Client

' 
END
GO
