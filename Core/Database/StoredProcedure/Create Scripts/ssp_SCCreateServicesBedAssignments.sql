IF EXISTS 
(
	SELECT 	1
	FROM 	sys.objects o
	WHERE 	NAME = 'ssp_SCCreateServicesBedAssignments'
)
	DROP PROCEDURE ssp_SCCreateServicesBedAssignments
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCreateServicesBedAssignments]
@FromDate datetime = '01/01/2000'
AS
/***********************************************************************************************************************
	Stored Procedure:	dbo.ssp_SCCreateServicesBedAssignments
	Purpose:			To create services as a nightly job for bed assignments
========================================================================================================================
	Modification Log
========================================================================================================================
	[Date]			[Author]		[Purpose]
	-------------	--------------	----------------------------------------------------------------
	8/7/2014		NJain			Created
	4/28/2015		NJain			Updated to use ServiceDiagnosis Table
	5/27/2015		NJain			Fixed bugs related to Service Creation
									Updated NotBillable flag in BedAssignments to look for a "Y", to account for the 
									discrepanct reported in core bugs #1805
	6/23/2015		NJain			Updated to log Errors in InpatientServiceErrorLog table		
	7/6/2015		NJain			Updated to fix the issue where Services are created without Attendance		
	7/16/2015		NJain			Updated NonBillable flag to always look at N		
	08/04/2015		NJain			Updated to use the SystemConfigurationKey
									Defaulted Unit to 1 for Services created by this process
									Updated to use the SystemConfigurationKey for Clinician
	8/24/2015		NJain			Updated to not create service for the last day					
	10/27/2015		NJain			Updated diagnosis logic to use the core billing diagnosis ssp	
	10/28/2015		NJain			Added scsp for custom logic	
	01/21/2016		Seema			What : Replaced Client.PrimaryPhysicianId with ClientInpatientVisits.PhysicianId
									Why : Philheaven Development #369
	6/6/2016		NJain			Added record deleted check when inserting into BedAttendances
	03/05/2018		Ting-Yu Mu		What: Modified the logic when assigning the value to @BusinessDate to be the date
									when the job executes so that the job will create the bed assignment services for 
									those bed census taken on the previous day
									Why: CHC - Support Go Live # 190
	05/21/2018      Pradeep T       What: Added condidion to check if Program associated with Bedassignments
	                                having CreateServiceForDischargeDate='Y' then Create Service for discharged date when both Admit and Discharged date are same" only.
	                                Why: As per customization task Comprehensive-Customizations-#632	
	10/25/2018		MD				Added @FromDate parameter with default value '01/01/2000' w.r.t Comprehensive-Support Go Live #69                               					
***********************************************************************************************************************/
DECLARE @BusinessDate DATE
DECLARE @ManageBedAttendance CHAR(1)

-- Assuming that this job is always run for the business day at night and any job runs between 12AM - 12PM will 
-- calculate services for the presious day
-- ==== TMU modified on 03/05/2018 =================================================================
--SELECT	@BusinessDate = CASE 
--			WHEN RIGHT(CONVERT(CHAR(20), GETDATE(), 22), 2) = 'PM'
--				THEN CAST(GETDATE() AS DATE)
--			WHEN RIGHT(CONVERT(CHAR(20), GETDATE(), 22), 2) = 'AM'
--				THEN DATEADD(dd, - 1, CAST(GETDATE() AS DATE))
--			END
SELECT @BusinessDate = CAST(GETDATE() AS DATE)
-- ==== End of TMU modification ====================================================================

CREATE TABLE #BedAssignmentDates
(
	BedAssignmentId INT ,
    ProcedureCodeId INT ,
    StartDate DATE ,
    DateOfService DATE ,
    EndDate DATE ,
    ManageBedAttendance CHAR(1)
)

CREATE TABLE #newServiceId (ServiceId INT)

--CREATE TABLE #BillingDiagnoses
--    (
--      ClientId INT ,
--      DSMCode VARCHAR(10) ,
--      DSMNumber INT ,
--      ICDCode VARCHAR(10) ,
--      SortOrder INT
--    )
CREATE TABLE #TempDiagnoses 
(
	DSMCode CHAR(6),
	DSMNumber INT,
	SortOrder INT,
	Version CHAR(10),
	DiagnosisOrder INT,
	DSMVCodeId INT,
	ICD10Code CHAR(10),
	ICD9Code CHAR(6),
	DESCRIPTION VARCHAR(MAX),
	[Order] INT
)

INSERT  INTO #BedAssignmentDates
( 
	BedAssignmentId ,
    ProcedureCodeId ,
    StartDate ,
    EndDate ,
    DateOfService ,
    ManageBedAttendance
)
SELECT	DISTINCT a.BedAssignmentId,
		a.ProcedureCodeId,
		CAST(a.StartDate AS DATE),
		CAST(ISNULL(EndDate, @BusinessDate) AS DATE),
		CAST(b.DATE AS DATE),
		ISNULL(c.AutomaticAttendanceForBedAssignment, 'N')
FROM	dbo.BedAssignments a
CROSS APPLY dbo.Dates b
JOIN	dbo.Programs c ON c.ProgramId = a.ProgramId
WHERE	ISNULL(a.RecordDeleted, 'N') = 'N'
	AND ISNULL(c.RecordDeleted, 'N') = 'N'
	AND ISNULL(a.NotBillable, 'N') = 'N'
	AND CAST(b.DATE AS DATE) >= CAST(a.StartDate AS DATE)
	-- Added by MD on 10/25/2018
	AND CAST(b.DATE AS DATE) >= CAST(@FromDate AS DATE) 
	---Pradeep T on 21 May 2018  
	AND (
                          (ISNULL(C.CreateServiceForDischargeDate,'N') = 'Y' AND 
                          a.Disposition=5205 AND a.EndDate is not null 
                          AND  CAST(A.StartDate AS DATE)=CAST(A.EndDate AS DATE)  
                          AND CAST(b.Date AS DATE) = CAST(a.EndDate AS DATE) )
                           OR
                          (CAST(b.Date AS DATE) < CAST(ISNULL(a.EndDate, @BusinessDate) AS DATE) )
        )
	
	AND NOT EXISTS 
	(
		SELECT	*
		FROM	dbo.BedAttendances ba
		WHERE	ISNULL(ba.RecordDeleted, 'N') = 'N'
			AND CAST(ba.AttendanceDate AS DATE) = CAST(b.DATE AS DATE)
			AND ba.BedAssignmentId = a.BedAssignmentId
			AND ba.ServiceId IS NOT NULL
	)
	AND DATEDIFF(dd, b.DATE, GETDATE()) >= 
	(
		SELECT	Value
		FROM	dbo.SystemConfigurationKeys
		WHERE	[Key] = 'BEDCENSUSSERVICECREATIONLAGDAYS'
	)

DECLARE @ClientId INT
DECLARE @ProgramId INT
DECLARE @I INT = 0
DECLARE @J INT = 0

SELECT	@I = MIN(BedAssignmentId)
FROM	#BedAssignmentDates

WHILE @I <= 
(
	SELECT	MAX(BedAssignmentId)
	FROM	#BedAssignmentDates
)
BEGIN
	-- Step 1. Get the @ManageBedAttendance flag for the Bed Assignment
	SELECT	@ManageBedAttendance = CASE 
				WHEN p.AutomaticAttendanceForBedAssignment = 'Y'
					THEN 'Y'
					ELSE 'N'
				END
	FROM	Programs p
	JOIN	dbo.BedAssignments ba ON ba.ProgramId = p.ProgramId
	WHERE	ba.BedAssignmentId = @I

	-- Step 2. Check if the Date exists in Bed Attendances and if it needs to be created based on the flag
	IF @ManageBedAttendance = 'Y'
	BEGIN
		INSERT INTO BedAttendances 
		(
			BedAssignmentId,
			Present,
			AttendanceDate,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
		SELECT ba.BedAssignmentId
			,CASE 
				WHEN STATUS = 5006
					THEN 'N'
				ELSE 'Y'
				END
			,CAST(DateOfService AS DATE)
			,'BEDASSIGNMENTSERVICESJOB'
			,GETDATE()
			,'BEDASSIGNMENTSERVICESJOB'
			,GETDATE()
		FROM #BedAssignmentDates bad
		JOIN BedAssignments ba ON bad.BedAssignmentId = ba.BedAssignmentId
		WHERE ba.BedAssignmentId = @I
			AND NOT EXISTS (
				SELECT *
				FROM BedAttendances ba2
				WHERE ba2.BedAssignmentId = ba.BedAssignmentId
					AND ba.BedAssignmentId = @I
					AND ISNULL(ba2.RecordDeleted, 'N') = 'N'
					AND CAST(ba2.AttendanceDate AS DATE) = CAST(bad.DateOfService AS DATE)
				)
	END

	-- Step 3. Create Service for every Date in the Bed Assignments table, if not already created
	DECLARE @DateOfService DATE

	SELECT	@DateOfService = MIN(DateOfService)
	FROM	#BedAssignmentDates
	WHERE	BedAssignmentId = @I

	WHILE @DateOfService <= 
	(
		SELECT	MAX(DateOfService)
		FROM	#BedAssignmentDates
		WHERE	BedAssignmentId = @I
	)
	BEGIN
		DELETE
		FROM	dbo.InpatientServiceErrorLog
		WHERE	BedAssignmentId = @I
			AND CAST(BedAttendanceDate AS DATE) = CAST(@DateOfService AS DATE)

		BEGIN TRAN

		DECLARE @NewServiceId INT

		INSERT INTO Services 
		(
			DateOfService ,
			--EndDateOfService ,
            ProcedureCodeId ,
            ProgramId ,
            LocationId ,
            Billable ,
            ClientId ,
            ClientWasPresent ,
            Status ,
            Unit ,
            UnitType ,
            ClinicianId ,
            AttendingId ,
            CreatedBy ,
            CreatedDate ,
            ModifiedBy ,
            ModifiedDate
		)
		OUTPUT INSERTED.ServiceId
		INTO #newServiceId(ServiceId)
		SELECT CAST(@DateOfService AS DATE)
			,bad.ProcedureCodeId
			,ba.ProgramId
			,ba.LocationId
			,CASE 
				WHEN pc.NotBillable = 'Y'
					THEN 'N'
				ELSE 'Y'
				END
			,civ.ClientId
			,CASE 
				WHEN ba.STATUS = 5006
					THEN 'N'
				ELSE 'Y'
				END
			,71
			,1
			,pc.EnteredAs
			,(
				SELECT Value
				FROM dbo.SystemConfigurationKeys
				WHERE [Key] = 'ClinicianForBedServices'
				)
			,
			--c.PrimaryPhysicianId , Seema 01/21/2016
			civ.PhysicianId
			,'BEDASSIGNMENTSERVICESJOB'
			,GETDATE()
			,'BEDASSIGNMENTSERVICESJOB'
			,GETDATE()
		FROM #BedAssignmentDates bad
		JOIN dbo.BedAssignments ba ON ba.BedAssignmentId = bad.BedAssignmentId
			AND ISNULL(ba.RecordDeleted, 'N') = 'N'
			AND CAST(bad.DateOfService AS DATE) = CAST(@DateOfService AS DATE)
			AND ba.BedAssignmentId = @I
			AND NOT EXISTS (
				SELECT *
				FROM Services s
				JOIN dbo.BedAttendances bat ON bat.ServiceId = s.ServiceId
				WHERE ba.ProcedureCodeId = s.ProcedureCodeId
					AND CAST(@DateofService AS DATE) = CAST(s.DateOfService AS DATE)
					AND bat.BedAssignmentId = ba.BedAssignmentId
					AND ISNULL(s.RecordDeleted, 'N') = 'N'
					AND ISNULL(bat.RecordDeleted, 'N') = 'N'
				)
		JOIN dbo.ClientInpatientVisits civ ON civ.ClientInpatientVisitId = ba.ClientInpatientVisitId
			AND ba.BedAssignmentId = @I
			AND ISNULL(civ.RecordDeleted, 'N') = 'N'
		JOIN dbo.BedAttendances bat ON bat.BedAssignmentId = ba.BedAssignmentId
			AND CAST(bat.AttendanceDate AS DATE) = CAST(@DateOfService AS DATE)
			AND ISNULL(bat.RecordDeleted, 'N') = 'N'
		/* Seema 01/21/2016 */
		--LEFT JOIN dbo.Clients c ON c.ClientId = civ.ClientId
		--                           AND ISNULL(c.RecordDeleted, 'N') = 'N'
		LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = ba.ProcedureCodeId
			AND ISNULL(pc.RecordDeleted, 'N') = 'N'
		WHERE DATEDIFF(DAY, @DateOfService, GETDATE()) >= (
				SELECT Value
				FROM dbo.SystemConfigurationKeys
				WHERE [Key] = 'BEDCENSUSSERVICECREATIONLAGDAYS'
				)

		SELECT @NewServiceId = @@IDENTITY

		IF EXISTS (
				SELECT *
				FROM dbo.Services a
				JOIN #newServiceId b ON b.ServiceId = a.ServiceId
				WHERE a.ServiceId = @NewServiceId
					AND (
						a.ProgramId IS NULL
						OR a.ClinicianId IS NULL
						OR a.ProcedureCodeId IS NULL
						OR a.LocationId IS NULL
						)
				)
		BEGIN
			ROLLBACK TRAN

			INSERT INTO InpatientServiceErrorLog (
				BedAssignmentId
				,BedAttendanceDate
				,ErrorMessage
				,ClientId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				)
			SELECT DISTINCT @I
				,@DateOfService
				,'Insufficient data to create Service.'
				,ClientId
				,'BEDASSIGNMENTSERVICESJOB'
				,GETDATE()
				,'BEDASSIGNMENTSERVICESJOB'
				,GETDATE()
			FROM dbo.BedAssignments a
			JOIN dbo.ClientInpatientVisits b ON b.ClientInpatientVisitId = a.ClientInpatientVisitId
			JOIN dbo.BedAttendances c ON c.BedAssignmentId = a.BedAssignmentId
			WHERE a.BedAssignmentId = @I
				AND CAST(c.AttendanceDate AS DATE) = CAST(@DateOfService AS DATE)
				AND ISNULL(a.RecordDeleted, 'N') = 'N'
				AND ISNULL(b.RecordDeleted, 'N') = 'N'
				AND ISNULL(c.RecordDeleted, 'N') = 'N'

			GOTO NextDateOfService
		END
		ELSE
		BEGIN
			COMMIT TRAN
		END

		-- Get Diagnosis Codes
		SELECT @ClientId = ClientId
			,@ProgramId = ProgramId
			,@DateOfService = DateOfService
		FROM dbo.Services
		WHERE ServiceId = @NewServiceId

		INSERT INTO #TempDiagnoses
		EXEC SSP_SCBillingDiagnosiServiceNote @varClientId = @ClientId
			,@varDate = @DateOfService
			,@varProgramId = @ProgramId

		INSERT INTO ServiceDiagnosis (
			ServiceId
			,DSMCode
			,[Order]
			,DSMNumber
			,DSMVCodeId
			,ICD10Code
			,ICD9Code
			,CreatedBy
			,ModifiedBy
			)
		SELECT @NewServiceId
			,DSMCode
			,ISNULL([Order], DiagnosisOrder)
			,DSMNumber
			,DSMVCodeId
			,ICD10Code
			,ICD9Code
			,'BEDASSIGNMENTSERVICESJOB'
			,'BEDASSIGNMENTSERVICESJOB'
		FROM #TempDiagnoses

		-- Update BedAttendances with the ServiceId							
		UPDATE	ba
		SET		ba.ServiceId = s.ServiceId
		FROM	dbo.BedAttendances ba
		JOIN	Services s ON CAST(ba.AttendanceDate AS DATE) = CAST(s.DateOfService AS DATE)
		JOIN	#newServiceId ns ON ns.ServiceId = s.ServiceId
		WHERE	ba.BedAssignmentId = @I

		-- Custom Logic ========================================================
		IF EXISTS 
		(
			SELECT	*
			FROM	sys.procedures
			WHERE	NAME = 'scsp_SCCreateServicesBedAssignments'
		)
		BEGIN
			EXEC scsp_SCCreateServicesBedAssignments @ServiceId = @NewServiceId
		END

		NextDateOfService:

		SELECT @DateOfService = DATEADD(dd, 1, @DateOfService)

		TRUNCATE TABLE #TempDiagnoses

		TRUNCATE TABLE #newServiceId

		SELECT	@ClientId = NULL,
				@ProgramId = NULL,
				@NewServiceId = NULL
	END

	SELECT	@J = @I

	SELECT	@I = MIN(BedAssignmentId)
	FROM	BedAssignments
	WHERE	ISNULL(RecordDeleted, 'N') = 'N'
		AND BedAssignmentId > @J
		AND ISNULL(NotBillable, 'N') = 'N'

	TRUNCATE TABLE #newServiceId

	TRUNCATE TABLE #TempDiagnoses
END
