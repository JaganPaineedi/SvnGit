/****** Object:  StoredProcedure [dbo].[csp_Report_intake_processing]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_intake_processing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_intake_processing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_intake_processing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_intake_processing]
		@IntakeStaffID		Int
		--,@IntakeStaffLastName varchar(30),
		--@IntakeStaffFirstName varchar(20)

AS
--*/

/*
DECLARE	
		@IntakeStaffID		Int
		--,@IntakeStaffLastName varchar(30),
		--@IntakeStaffFirstName varchar(20)

SELECT	
		@IntakeStaffID = 0	-- All Intake Staff
						--979		-- Karen Kolar
						--530		-- Terri Smith
		--,@IntakeStaffLastName =	''%'',
		--@IntakeStaffFirstName =	''%''
--*/



/****************************************************************/
/* Stored Procedure: csp_Report_intake_processing				*/
/* Creation Date:    05/11/2010									*/
/* Copyright:    Harbor											*/
/*																*/
/* Purpose: Verification Reports								*/
/*																*/
/* Called By: Intake Processing.rpt								*/
/*																*/
/* Updates:														*/
/* Date			Author		Purpose								*/
/* 05/11/2010	Jess		Created -  WO 14300					*/
/* 08/04/2010	Jess		Modified - WO 15341					*/
/* 09/28/2010	Jess		Modified - WO 15719					*/
/* 03/29/2011	Jess		Modified - WO 17325					*/
/* 03/23/2012	Jess		Modified - WO 21077					*/
/* 07/07/2012	Jess		Converted from Psych Consult		*/
/* 03/07/2013	Jess		Modified - WO 27551					*/
/* 03/12/2013	Jess		Modified per Lynn					*/
/****************************************************************/

DECLARE @TempStaff TABLE
(
	StaffID		Int,
	StaffName	Varchar(50)
)

IF @IntakeStaffID = 0 BEGIN
INSERT INTO @TempStaff 
SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
FROM dbo.Staff s
WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
AND s.Active = ''Y''
END
ELSE BEGIN
INSERT INTO @TempStaff 
SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
FROM dbo.Staff s
WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
AND s.StaffId = @IntakeStaffID 
AND s.Active = ''Y''
END

DECLARE	@Results TABLE
(
	Section				int,
	ClientId			int,
	Client				varchar(100),
	RegistrationDate	datetime,
	IntakeStaff			varchar(100),
	DateOfService		datetime,
	Location			varchar(100),
	ProcedureCode		varchar(50),
	Reason				int,
	Comment				text,
	ClientServices		char(1),
	ConsentToTreat		char(1),
	AdmissionRecord		char(1),
	HealthAssessment	char(1),
	ContactNoteStatus	int	-- added by Jess 3/7/13
)

INSERT	INTO	@Results
SELECT	DISTINCT
		1,
		C.ClientId,
		C.LastName + '', '' + C.FirstName,
		CE.RegistrationDate,
--		ST.LastName + '', '' + ST.FirstName,
		CASE	WHEN	CE.IntakeStaff IS NULL
				THEN	NULL
				ELSE	ST.StaffName
		END,
		S.DateOfService,
		L.LocationName,
		PC.DisplayAs,
		CCN.ContactReason,
		CCN.ContactDetails,
		null,
		null,
		null,
		null,
		CCN.ContactStatus
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
	AND	CCN.ContactType in	(	24422,	-- Intake
								24424	-- Update
							)
--	AND	CCN.ContactStatus = 24414 -- Scheduled	-- Removed by Jess 3/7/13

--  Added by Jess 3/7/13
	AND	CCN.ContactReason in	(	24429,	-- Enrollment
									24430,	-- Enrollment update
									24431,	-- Enrollment: DA Needed
									24435	-- Non-Enrolled
								)

	AND	ISNULL(CCN.RecordDeleted, ''N'') = ''N''
/*
LEFT	JOIN	Staff ST
--	ON	CE.CreatedBy = ST.UserCode
	ON	CE.IntakeStaff = ST.StaffId
	AND	ISNULL(ST.RecordDeleted, ''N'') = ''N''
*/
JOIN	@TempStaff ST
	ON	(	CE.IntakeStaff = ST.StaffId
		OR	CE.IntakeStaff IS NULL
		)
JOIN	Programs P
	ON	S.ProgramId = P.ProgramId
	AND	ISNULL(P.RecordDeleted, ''N'') = ''N''
WHERE	

--~~~ This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
P.ServiceAreaId NOT IN (''5'', ''2'', ''4'') -- VOC, EAP Primary Care
AND		PC.DisplayAs NOT IN	(	''EDUC_CLASS'',
								''COURT_CLNT'',	-- added by Jess 3/29/11
								''WELL_COACH'',	-- added by Jess 3/29/11
								''MES_LEV1ME'',	-- added by Jess 3/29/11
								''MES_LEV2ME'',	-- added by Jess 3/29/11
								''PAYMENT'',		-- added by Jess 3/29/11
								''NSF_CHARGE'',	-- added by Jess 3/29/11
								''PREV_EDUC'',	-- added by Jess 3/23/12
								''ROI_NONCOM'',	-- added by Jess 3/23/12
								''ROI_BENCOM'',	-- added by Jess 3/23/12
								''ROI_LEGCOM'',	-- added by Jess 3/23/12
								''ROI_MEDCOM'',	-- added by Jess 3/23/12
								''PRC_NEW_MD'',	-- added by Jess 3/23/12
								''V_CAREERCN''	-- added by Jess 3/23/12
							)
*/
	S.ProcedureCodeId IN	(	24,		-- ASSESSMENT
								485,	-- PSYCH_TEST
								486,	-- 96101 (Psychological Testing, private clients)
								329,	-- INDIV_CN
								318,	-- ASSMT_HOSP
								26		-- ASSMT_UPD
							)
--~~~ END OF This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


AND		S.Status in (''71'', ''75'') -- Show, Complete
AND		CE.RegistrationDate >= ''7/9/12''	-- Added by Jess 3/7/13
AND		S.DateOfService >= CE.RegistrationDate	-- Added by Jess 3/7/13
AND		S.DateOfService =	(	SELECT	MIN(S2.DateOfService)
								FROM	Services S2
								JOIN	Programs P2
									ON	S2.ProgramId = P2.ProgramId
									AND	ISNULL(P2.RecordDeleted, ''N'') = ''N''
								JOIN	ProcedureCodes PC2
									ON	S2.ProcedureCodeId = PC2.ProcedureCodeId
									AND	ISNULL(PC2.RecordDeleted, ''N'') = ''N''
								WHERE	S.ClientId = S2.ClientId
								AND		S2.Status in (''71'', ''75'') -- Show, Complete
--~~~ This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
								AND		S2.ProcedureCodeId <> 272 -- EDUC_CLASS
								AND		P2.ServiceAreaId NOT IN (''5'', ''2'', ''4'') -- VOC, EAP Primary Care
								AND		PC2.DisplayAs NOT IN	(	''EDUC_CLASS'',
																	''COURT_CLNT'',	-- added by Jess 3/29/11
																	''WELL_COACH'',	-- added by Jess 3/29/11
																	''MES_LEV1ME'',	-- added by Jess 3/29/11
																	''MES_LEV2ME'',	-- added by Jess 3/29/11
																	''PAYMENT'',		-- added by Jess 3/29/11
																	''NSF_CHARGE'',	-- added by Jess 3/29/11
																	''PREV_EDUC'',	-- added by Jess 3/23/12
																	''ROI_NONCOM'',	-- added by Jess 3/23/12
																	''ROI_BENCOM'',	-- added by Jess 3/23/12
																	''ROI_LEGCOM'',	-- added by Jess 3/23/12
																	''ROI_MEDCOM'',	-- added by Jess 3/23/12
																	''PRC_NEW_MD'',	-- added by Jess 3/23/12
																	''V_CAREERCN''	-- added by Jess 3/23/12
																)
*/
								AND		S2.ProcedureCodeId IN	(	24,		-- ASSESSMENT
																	485,	-- PSYCH_TEST
																	486,	-- 96101 (Psychological Testing, private clients)
																	329,	-- INDIV_CN
																	318,	-- ASSMT_HOSP
																	26		-- ASSMT_UPD
																)
--~~~ END OF This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

								AND		ISNULL(S2.RecordDeleted, ''N'') = ''N''
								AND		S2.DateOfService >= ''7/9/12''	-- Added by Jess 3/7/13
								AND		S2.DateOfService >= CE.RegistrationDate	-- Added by Jess 3/7/13
							)
/*
AND		(	ST.LastName IS NULL
		OR	ST.LastName like @IntakeStaffLastName
		AND	ST.FirstName like @IntakeStaffFirstName
		)
AND		ISNULL(C.RecordDeleted, ''N'') = ''N''
*/

INSERT	INTO	@Results
SELECT	DISTINCT
		2,
		C.ClientId,
		C.LastName + '', '' + C.FirstName,
		CE.RegistrationDate,
--		ST.LastName + '', '' + ST.FirstName as ''Intake Staff'',
		CASE	WHEN	CE.IntakeStaff IS NULL
				THEN	NULL
				ELSE	ST.StaffName
		END,
		S.DateOfService,
		L.LocationName,
		PC.DisplayAs,
		null,
		null,
		null,
		null,
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
/*
LEFT	JOIN	Staff ST
	ON	CE.IntakeStaff = ST.StaffId
	AND	ISNULL(ST.RecordDeleted, ''N'') = ''N''
*/
JOIN	@TempStaff ST
	ON	(	CE.IntakeStaff = ST.StaffId
		OR	CE.IntakeStaff IS NULL
		)
WHERE	NOT	EXISTS	(	SELECT	*
						FROM	ClientContactNotes CCN
						WHERE	C.ClientId = CCN.ClientId
						AND		CCN.ContactType in (''24422'', ''24424'') -- Intake, Update
--						AND		CCN.ContactStatus in (''24414'', ''24416'') -- Scheduled, Completed  -- Removed by Jess 3/7/13

					--  Added by Jess 3/7/13
						AND	CCN.ContactReason in	(	24429,	-- Enrollment
														24430,	-- Enrollment update
														24431,	-- Enrollment: DA Needed
														24435	-- Non-Enrolled
													)

						AND		ISNULL(CCN.RecordDeleted, ''N'') = ''N''
					)
--~~~ This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
AND		P.ServiceAreaId NOT IN (''5'', ''2'', ''4'') -- VOC, EAP Primary Care
AND		PC.DisplayAs NOT IN	(	''EDUC_CLASS'',
								''COURT_CLNT'',	-- added by Jess 3/29/11
								''WELL_COACH'',	-- added by Jess 3/29/11
								''MES_LEV1ME'',	-- added by Jess 3/29/11
								''MES_LEV2ME'',	-- added by Jess 3/29/11
								''PAYMENT'',		-- added by Jess 3/29/11
								''NSF_CHARGE'',	-- added by Jess 3/29/11
								''PREV_EDUC'',	-- added by Jess 3/23/12
								''ROI_NONCOM'',	-- added by Jess 3/23/12
								''ROI_BENCOM'',	-- added by Jess 3/23/12
								''ROI_LEGCOM'',	-- added by Jess 3/23/12
								''ROI_MEDCOM'',	-- added by Jess 3/23/12
								''PRC_NEW_MD'',	-- added by Jess 3/23/12
								''V_CAREERCN''	-- added by Jess 3/23/12
							)

*/
AND	S.ProcedureCodeId IN	(	24,		-- ASSESSMENT
								485,	-- PSYCH_TEST
								486,	-- 96101 (Psychological Testing, private clients)
								329,	-- INDIV_CN
								318,	-- ASSMT_HOSP
								26		-- ASSMT_UPD
							)
--~~~ END OF This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AND		S.Status in (''71'', ''75'') -- Show, Complete
--AND		S.DateOfService >= ''5/24/10''	-- Removed by Jess 3/7/13
AND		CE.RegistrationDate >= ''7/9/12''	-- Added by Jess 3/7/13
AND		S.DateOfService >= CE.RegistrationDate	-- Added by Jess 3/7/13
AND	NOT	EXISTS	(	SELECT	S2.ServiceId
					FROM	Services S2
					JOIN	Programs P2
						ON	S2.ProgramId = P2.ProgramId
						AND	ISNULL(P2.RecordDeleted, ''N'') = ''N''
					JOIN	ProcedureCodes PC2
						ON	S2.ProcedureCodeId = PC2.ProcedureCodeId
						AND	ISNULL(PC2.RecordDeleted, ''N'') = ''N''
					WHERE	S.ClientId = S2.ClientId
					AND		S2.Status in (''71'', ''75'') -- Show, Complete
--~~~ This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*
					AND		P2.ServiceAreaId NOT IN (''5'', ''2'', ''4'') -- VOC, EAP Primary Care
					AND		PC2.DisplayAs NOT IN	(	''EDUC_CLASS'',
														''COURT_CLNT'',	-- added by Jess 3/29/11
														''WELL_COACH'',	-- added by Jess 3/29/11
														''MES_LEV1ME'',	-- added by Jess 3/29/11
														''MES_LEV2ME'',	-- added by Jess 3/29/11
														''PAYMENT'',		-- added by Jess 3/29/11
														''NSF_CHARGE'',	-- added by Jess 3/29/11
														''PREV_EDUC'',	-- added by Jess 3/23/12
														''ROI_NONCOM'',	-- added by Jess 3/23/12
														''ROI_BENCOM'',	-- added by Jess 3/23/12
														''ROI_LEGCOM'',	-- added by Jess 3/23/12
														''ROI_MEDCOM'',	-- added by Jess 3/23/12
														''PRC_NEW_MD'',	-- added by Jess 3/23/12
														''V_CAREERCN''	-- added by Jess 3/23/12
													)
*/
								AND		PC2.ProcedureCodeId IN	(	24,		-- ASSESSMENT
																	485,	-- PSYCH_TEST
																	486,	-- 96101 (Psychological Testing, private clients)
																	329,	-- INDIV_CN
																	318,	-- ASSMT_HOSP
																	26		-- ASSMT_UPD
																)
--~~~ END OF This Section Modified By Jess 3/7/13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

					AND		S2.Status in (''71'', ''75'') -- Show, Complete
					AND		S2.DateOfService < S.DateOfService
					AND		S2.DateOfService >= ''7/9/12''	-- Added by Jess 3/7/13
					AND		S2.DateOfService >= CE.RegistrationDate	-- Added by Jess 3/7/13
					AND		ISNULL(S2.RecordDeleted, ''N'') = ''N''
				)
/*
AND	(	ST.LastName is null
	OR	(	ST.LastName like @IntakeStaffLastName
		AND	ST.FirstName like @IntakeStaffFirstName
		)
	)
*/
AND		ISNULL(C.RecordDeleted, ''N'') = ''N''




UPDATE	@Results
SET		ClientServices = ''X''
FROM	@Results r
WHERE	NOT EXISTS	(	SELECT	D.DocumentId
						FROM	Documents D
						WHERE	R.ClientId = D.ClientId
						AND		D.DocumentCodeId in (	1000099,	-- Client Service Agreement - Inserted
														1000100,	-- Client Service Agreement
														1000101,	-- Client Service Agreement
														1000241,	-- Client Services Agreement
														1000315,	-- Con:C; Service Agreement	-- Added by Jess 3/7/13
														1000316		-- Con:C; Service Agreement-Inserted	-- Added by Jess 3/7/13
													)
						AND		D.Status = 22 -- Signed
						AND		D.EffectiveDate >= R.RegistrationDate	-- Added by Jess 3/7/13
						AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
					)

UPDATE	@Results
SET		ConsentToTreat = ''X''
FROM	@Results r
WHERE	NOT EXISTS	(	SELECT	D.DocumentId
						FROM	Documents D
						WHERE	R.ClientId = D.ClientId
						AND		D.DocumentCodeId in (	1000096,	-- Client Consent for Tx Agreement - Insert
														1000097,	-- Client Consent for Treatment Agreement
														1000240,	-- Client Consent for Treatment
														1000310,	-- Con:C; Consent for Treatment Agreement	-- Added by Jess 3/7/13
														1000311		-- Con:C; Consent for Trt Agree-Insert	-- Added by Jess 3/7/13
													)
						AND		D.Status = 22 -- Signed
						AND		D.EffectiveDate >= R.RegistrationDate	-- Added by Jess 3/7/13
						AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
					)

UPDATE	@Results
SET		AdmissionRecord = ''X''
FROM	@Results r
WHERE	NOT EXISTS	(	SELECT	D.DocumentId
						FROM	Documents D
						WHERE	R.ClientId = D.ClientId
						AND		D.DocumentCodeId in (	20014,		-- EAP Admission
														1000044,	-- ADMISSION RECORD
														1000059,	-- EAP Admission
														1000266,	-- Admission Record	-- Added by Jess 3/7/13
														1000281,	-- CFPC; EAP Admission	-- Added by Jess 3/7/13
														1000283,	-- CFPC; Intake Report / Admission Record	-- Added by Jess 3/7/13
														1000045,	-- Intake Report	-- Added by Jess 3/7/13
														1000088		-- Intake Report	-- Added by Jess 3/7/13
													)	
--						AND		D.Status = 22 -- Signed	-- REPLACED by the lines below by Jess 3/12/13 per Lynn
						AND		D.Status in	(	21,	-- In Progress
												22	-- Signed
											)
						AND		D.EffectiveDate >= R.RegistrationDate	-- Added by Jess 3/7/13
						AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
					)

-- Added by Jess 3/7/13
UPDATE	@Results
SET		HealthAssessment = ''X''
FROM	@Results r
WHERE	NOT EXISTS	(	SELECT	D.DocumentId
						FROM	Documents D
						WHERE	R.ClientId = D.ClientId
						AND		D.DocumentCodeId in (	--1000114,	-- Health Assessment  -- Old Psych Consult Document
														1000335		-- HA; Health Assessment
													)	
						AND		D.Status in	(	21,	-- In Progress
												22	-- Signed
											)
						AND		D.EffectiveDate >= R.RegistrationDate	-- Added by Jess 3/7/13
						AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
					)

--	select * from @Results

--	Added by Jess 3/7/13
DELETE
FROM	@Results
WHERE	ContactNoteStatus = 24416 -- Complete
AND		ClientServices is null
AND		ConsentToTreat is null
AND		AdmissionRecord is null
AND		HealthAssessment is null


--	select * from @Results

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
		ISNULL(R.ClientServices, ''_'') AS ''ClientServices'',
		ISNULL(R.ConsentToTreat, ''_'') AS ''ConsentToTreat'',
		ISNULL(R.AdmissionRecord, ''_'') AS ''AdmissionRecord'',
		ISNULL(R.HealthAssessment, ''_'') AS ''HealthAssessment''	-- Added by Jess 3/7/13
FROM	@Results R
ORDER	BY
		R.Section,
		''IntakeStaff'',
		R.Client
' 
END
GO
