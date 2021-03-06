/****** Object:  StoredProcedure [dbo].[csp_SQL_Job_Create_HH_PMPM_Services]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SQL_Job_Create_HH_PMPM_Services]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SQL_Job_Create_HH_PMPM_Services]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SQL_Job_Create_HH_PMPM_Services]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE	[dbo].[csp_SQL_Job_Create_HH_PMPM_Services]
AS

/****************************************************************/
/* Stored Procedure: csp_SQL_Job_Create_HH_PMPM_Services		*/
/* Copyright Harbor												*/
/* Creation Date:    01/23/2013									*/
/*																*/
/* Purpose: SQL Server Agent Nightly Job						*/
/*																*/
/* Called By: Nightly Job: Create HH_PMPM Services				*/
/*																*/
/* Updates:														*/
/* Date			Author		Purpose								*/
/* 01/12/2013	Jess		Created - WO 26715					*/
/* 02/08/2013	Jess		Modified - WO 27166					*/
/* 03/21/2013	Jess		Modified - WO 27962					*/
/* 03/22/2013	Jess		Modified - WO 27962					*/
/****************************************************************/




--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ PART 1 - Get Service & Program info ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECLARE	@Services TABLE
(
	ClientId int,
	DOS datetime
)

DECLARE	@Programs table
(
	ClientId int,
	ProgramId int
)

DECLARE	@Totals TABLE
(
	ClientId int,
	DOS datetime,
	ProgramId int
)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ Gather First HH_Service of the month for each client to base HH_PMPM off of  ~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INSERT	@Services
SELECT	DISTINCT
		S.ClientId,
--		S.DateOfService,
		CONVERT(datetime, CONVERT(varchar, S.DateOfService, 101) + '' 21:00:00'') as ''Date''
--		DATEADD(DAY, -1, (DATEADD(MONTH, 1, (CONVERT(varchar, DATEPART(MONTH, S.DateOfService)) + ''/1/'' + CONVERT(varchar, DATEPART(YEAR, S.DateOfService))))))
FROM	Services S
/*
JOIN	ClientPrograms CP
ON		S.ClientId = CP.ClientId
AND		S.ProgramId = CP.ProgramId
AND		CP.DischargedDate IS NULL
AND		ISNULL(CP.RecordDeleted, ''N'') <> ''Y''
*/
WHERE	--S.ProgramId NOT in (445, 444)	-- 6 HH Medicaid SED, 6 HH Medicaid SPMI
--AND		
S.ProcedureCodeId IN	(	696, -- HH_Service
							725	-- HH_INTCAREPLAN	-- Added by Jess 2/8/13
						)
AND		S.Status = 75 -- Complete
AND		NOT	EXISTS	(	SELECT	S2.ServiceId
						FROM	Services S2
						WHERE	S.ClientId = S2.ClientId
						AND		S2.ProcedureCodeId = 697 -- HH_PMPM
						AND		S2.Status in (70, 71, 75) -- Scheduled, Show, or Complete status
						AND		DATEPART(MONTH, S.DateOfService) = DATEPART(MONTH, S2.DateOfService)
						AND		DATEPART(YEAR, S.DateOfService) = DATEPART(YEAR, S2.DateOfService)
						AND		ISNULL(S2.RecordDeleted, ''N'') <> ''Y''
					)
AND		S.DateOfService =	(	SELECT	MIN(S3.DateOfService)
								FROM	Services S3
								WHERE	S.ClientId = S3.ClientId
								AND		S3.ProcedureCodeId IN	(	696,	-- HH_Service
																	725,	-- HH_INTCAREPLAN		-- Added by Jess 2/8/13
																	728,	-- HH_COMPHLTHEVAL		-- Added by Jess 3/21/13
																	729,	-- HH_COMMUNCATIONPLAN	-- Added by Jess 3/21/13
																	730,	-- HH_TRANSITIONPLAN	-- Added by Jess 3/21/13
																	731		-- HH_CRISISPLAN		-- Added by Jess 3/22/13
																)
								AND		S3.Status = 75 -- Complete status
								AND		DATEPART(MONTH, S.DateOfService) = DATEPART(MONTH, S3.DateOfService)
								AND		DATEPART(YEAR, S.DateOfService) = DATEPART(YEAR, S3.DateOfService)
								AND		ISNULL(S3.RecordDeleted, ''N'') <> ''Y''
							)
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
--AND		S.DateOfService < ''1/1/13''
ORDER	BY	''Date''

--SELECT	* FROM	@Services order by ClientId
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF Gather First HH_Service of the month for each client to base HH_PMPM off of  ~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


/*

-- temporary for testing
declare @rowcount int

select @rowcount = (select COUNT(clientid) from @Services) - 25
--select @rowcount

set rowcount @rowcount
delete from @Services
set rowcount 0

--SELECT	* FROM	@Services order by ClientId
*/



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ Gather HH Program for each client.  Can''t use Program of service yet as there are ~~~~~~~~~~~~~
--~~~~~ currently HH services with non-HH Programs attached. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
INSERT	@Programs
SELECT	DISTINCT
		S.ClientId,
		cp.ProgramId
FROM	@Services S
JOIN	ClientPrograms CP
ON		S.ClientId = CP.ClientId
AND		ISNULL(CP.RecordDeleted, ''N'') <> ''Y''
JOIN	ClientProgramHistory CPH
ON		CP.ClientProgramId = CPH.ClientProgramId
AND		ISNULL(CPH.RecordDeleted, ''N'') <> ''Y''
WHERE	CP.ProgramId in (444, 445)	-- 6 HH Medicaid SPMI, 6 HH Medicaid SED
AND		CPH.EnrolledDate =	(	SELECT	MAX(CPH2.enrolleddate)
								FROM	ClientProgramHistory CPH2
								JOIN	ClientPrograms CP2
								ON		CPH2.ClientProgramId = CP2.ClientProgramId
								WHERE	CP.ClientId = CP2.ClientId
								AND		CP2.ProgramId in (444, 445)
								AND		ISNULL(CPH2.RecordDeleted, ''N'') <> ''Y''
								AND		ISNULL(CP2.RecordDeleted, ''N'') <> ''Y''
							)

--select * from @programs
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF Gather HH Program for each client.  Can''t use Program of service yet as there are ~~~~~~
--~~~~~ currently HH services with non-HH Programs attached. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




INSERT		@Totals
SELECT		DISTINCT
			S.*,
			P.ProgramId
FROM		@Services S
LEFT JOIN	@programs P
ON			S.ClientId = P.ClientId
ORDER	BY	S.ClientId

--select * from @Totals where ProgramId is not null
--select * from @Totals where ProgramId is null  -- Clients for Billing/Data Admin to review for having improper HH services 

DELETE	FROM @Totals WHERE ProgramId IS NULL

select * from @Totals 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF PART 1 - Get Service & Program info ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ PART 2 - Create the HH_PMPM Service ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECLARE	@CurrentDate datetime,
		@Script varchar(25),
		@ClientId int

SELECT	@CurrentDate = GETDATE(),
		@Script = ''Script26715''

/*
WHILE	(SELECT TOP 1 ClientId FROM @Totals) IS NOT NULL
BEGIN
		SELECT	@ClientId = (SELECT TOP 1 ClientId FROM @Totals)
*/
		INSERT	Services	(	ClientId,
								ProcedureCodeId,
								DateOfService,
								EndDateOfService,
								Unit,
								UnitType,
								Status,
								ClinicianId,
								ProgramId,
								LocationId,
								Billable,
								ClientWasPresent,
								Comment,
								CreatedBy,
								CreatedDate,
								ModifiedBy,
								ModifiedDate
							)
		SELECT	T.ClientId,
				697, -- ProcedureCodeId for HH_PMPM,
				T.DOS,
				T.DOS,
				1,
				113, -- Units
				71, -- Show status
				CASE	T.ProgramId
						WHEN	444 -- 6 HH Medicaid SPMI
						THEN	1869 -- Health Home	SPMI Team Leader.  Prod (Live) = 1869, TestUpgrade (Training) = 1853 
						WHEN	445 -- 6 HH Medicaid SED
						THEN	1870 --	Health Home	SED Team Leader.   Prod (Live) = 1870, TestUpgrade (Training) = 1854
				END,	-- ClinicianID,
				T.ProgramId,
				8,	-- LocationID for Central,
				''Y'',
				''N'',
				null,
				@Script,
				@CurrentDate,
				@Script,
				@CurrentDate
		FROM	@Totals T

/*
		SET ROWCOUNT 1
		DELETE FROM @Totals
		SET ROWCOUNT 0
END
*/
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF PART 2 - Create the HH_PMPM Service ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ PART 3 - Update the Diagnosis on the Service to correct HH diagnosis ~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECLARE	@ServiceDx TABLE
(	ClientId int,
	ServiceId int,
	DiagnosisCode1 varchar(25),
	DiagnosisNumber1 int,
	NewDiagnosisCode1 varchar(25),
	NewDiagnosisNumber1 int
)

INSERT	@ServiceDx 
SELECT	S.ClientId,
		S.ServiceId,
		S.DiagnosisCode1,
		S.DiagnosisNumber1,
		NULL,
		NULL
FROM	Services S
WHERE	S.ProcedureCodeId = 697 -- HH_PMPM
AND		S.CreatedDate = @CurrentDate
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
AND		(	S.DiagnosisCode1 IS NULL
		OR	S.DiagnosisCode1 NOT IN (SELECT DSMCode FROM Custom_Health_Home_SPMI_SED_Diagnosis)
		)
		
--	SELECT * FROM @ServiceDx order by ClientId


DECLARE	@DiagDocument TABLE
(	ClientId int,
	DocumentVersionId int
)

INSERT	@DiagDocument
SELECT	D.ClientId,
		D.CurrentDocumentVersionId
FROM	Documents D
JOIN	@ServiceDx S
ON		D.ClientId = S.ClientId
WHERE	D.DocumentCodeId = 5
AND		D.Status = 22
AND		D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
								FROM	Documents D2
								WHERE	D.ClientId = D2.ClientId
								AND		D2.Status = 22
								AND		D2.DocumentCodeId = 5
							)
AND		D.CreatedDate =	(	SELECT	MAX(D3.CreatedDate)
							FROM	Documents D3
							WHERE	D.ClientId = D3.ClientId
							AND		D3.Status = 22
							AND		D3.DocumentCodeId = 5
							AND		D.EffectiveDate = D3.EffectiveDate
						)
AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
ORDER	BY
		D.ClientId

--	SELECT * FROM @DiagDocument

UPDATE	@ServiceDx
SET		NewDiagnosisCode1 = Dx.DSMCode,
		NewDiagnosisNumber1 = Dx.DSMNumber
FROM	@ServiceDx S
JOIN	@DiagDocument D
ON		S.ClientId = D.ClientId
JOIN	DiagnosesIAndII Dx
ON		D.DocumentVersionId = Dx.DocumentVersionId
JOIN	Custom_Health_Home_SPMI_SED_Diagnosis C
ON		(	Dx.DSMCode = C.DSMCode
		OR	Dx.DSMCode = ''312.80''
		)
WHERE	ISNULL(Dx.RecordDeleted, ''N'') <> ''Y''
AND		Dx.DiagnosisOrder =	(	SELECT	MIN(Dx2.DiagnosisOrder)
								FROM	DiagnosesIAndII Dx2
								JOIN	Custom_Health_Home_SPMI_SED_Diagnosis C2
								ON		(	Dx2.DSMCode = C.DSMCode
										OR	Dx2.DSMCode = ''312.80''
										)
								WHERE	Dx.DocumentVersionId = Dx2.DocumentVersionId
								AND		ISNULL(Dx2.RecordDeleted, ''N'') <> ''Y''
							)

UPDATE	@ServiceDx
SET		NewDiagnosisCode1 = ''312.8''
WHERE	NewDiagnosisCode1 = ''312.80''

/*
SELECT	*
FROM	@ServiceDx
WHERE	NewDiagnosisCode1 IS NULL
ORDER	BY
		ClientId
--*/

BEGIN TRAN
UPDATE	Services
SET		DiagnosisCode1 = SS.NewDiagnosisCode1,
		DiagnosisNumber1 = SS.NewDiagnosisNumber1,
		ModifiedBy = @Script,
		ModifiedDate = @CurrentDate
FROM	Services S
JOIN	@ServiceDx SS
ON		S.ServiceId = SS.ServiceId
AND		S.ClientId = SS.ClientId
--AND		S.DiagnosisCode1 = SS.DiagnosisCode1
--AND		S.DiagnosisNumber1 = SS.DiagnosisNumber1

--	rollback tran

	commit tran
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF PART 3 - Update the Diagnosis on the Service to correct HH diagnosis ~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ PART 4 - Set service to Scheduled if no diagnosis exists ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BEGIN TRAN
UPDATE	Services
SET		Status = 70 -- Scheduled
WHERE	ProcedureCodeId = 697 -- HH_PMPM
AND		Status = 71 -- Show
AND		DiagnosisCode1 IS NULL
AND		ISNULL(RecordDeleted, ''N'') <> ''Y''
--	rollback tran

	commit tran
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF PART 4 - Set service to Scheduled if no diagnosis exists ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' 
END
GO
