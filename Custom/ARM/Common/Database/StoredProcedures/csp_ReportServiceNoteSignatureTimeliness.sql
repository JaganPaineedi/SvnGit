IF EXISTS 
(
	SELECT	*
	FROM	sys.objects
	WHERE	OBJECT_ID = OBJECT_ID(N'[dbo].[csp_ReportServiceNoteSignatureTimeliness]')
		AND type IN (N'P', N'PC')
)
	DROP PROCEDURE [dbo].[csp_ReportServiceNoteSignatureTimeliness]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [dbo].[csp_ReportServiceNoteSignatureTimeliness]
(
	@StaffId INT,
	@StaffType VARCHAR(30),
	@FromDate DATETIME,
	@ToDate DATETIME = NULL
)
AS
/***********************************************************************************************************************
	Stored Procedure:	csp_ReportServiceNoteSignatureTimeliness
	Created Date:		08/14/2017
	Author:				Ting-Yu Mu
	Purpose:			Created for the service note signature timeliness reporting. As per ARM - Enhancement # 654 
						Customer has requested a report that shows documentation signature time frames, so they can see 
						on average how long it is taking for staff to sign their notes.
========================================================================================================================
	Modification Log
========================================================================================================================
	Date			Author			Description
	-------------	--------------	----------------------------------------------------------------
	08/14/2017		Ting-Yu Mu		Created
	10/02/2017		Ting-Yu Mu		What: Modified the report logic to include the services with procedure code
									"Diagnostic Assesment"
									Why: ARM-Enhancement # 654.1
***********************************************************************************************************************/
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		-- ==== Local variables declaration ====================================
		DECLARE @ClinicianId INT 
		DECLARE	@ClinicianType VARCHAR(30)
		DECLARE @StartDate DATETIME
		DECLARE @EndDate DATETIME

		DECLARE @Title VARCHAR(MAX)
		DECLARE @SubTitle VARCHAR(MAX)
		DECLARE @SystemMessage VARCHAR(MAX) = NULL
		DECLARE @StoredProcedure VARCHAR(300) = NULL

		DECLARE @DAProcedureCodeId INT = 289
		DECLARE @DADocumentCodeId INT = 1486

		-- ==== Uses local variables to take in the passed in parameters, to avoid parameter sniffing
		SET	@ClinicianId = @StaffId
		SET	@ClinicianType = @StaffType
		SET	@StartDate = @FromDate
		SET	@EndDate = ISNULL(@ToDate, GETDATE())

		SET	@Title = 'A Renewed Mind - Staff Productivity - Length to Sign Notes'
		SET	@SubTitle = 'Service notes conducted from ' + CONVERT(VARCHAR, @StartDate, 101) + ' to ' + CONVERT(VARCHAR, @EndDate, 101)
		SET @StoredProcedure = OBJECT_NAME(@@PROCID)

		-- ==== Updates the custom report parts table ==========================
		IF (@StoredProcedure IS NOT NULL) AND NOT EXISTS
		(
			SELECT	1
			FROM	dbo.CustomReportParts
			WHERE	StoredProcedure = @StoredProcedure
		)
		BEGIN
			INSERT INTO CustomReportParts 
			(
				StoredProcedure,
				ReportName,
				Title,
				SubTitle,
				Comment
			)
			SELECT	@StoredProcedure,
					@Title,
					@Title,
					@SubTitle,
					@SystemMessage
		END
		ELSE 
		BEGIN
			UPDATE	dbo.CustomReportParts
			SET		ReportName = @Title,
					Title = @Title,
					SubTitle = @SubTitle,
					Comment = @SystemMessage,
					ModifiedBy = CURRENT_USER,
					ModifiedDate = GETDATE()
			WHERE	StoredProcedure = @StoredProcedure
		END
		-- =====================================================================

		-- ==== Processes staff based on the staff hierarchy ===========================================================
		IF OBJECT_ID('tempdb..#StaffInfo') IS NOT NULL
			DROP TABLE #StaffInfo
		CREATE TABLE #StaffInfo
		(
			StaffId INT,
			StaffName VARCHAR(200)
		)

		-- All staff is selected
		IF @ClinicianId = 0
		BEGIN
			INSERT INTO #StaffInfo ( StaffId, StaffName )
			SELECT	StaffId,
					StaffName
			FROM	dbo.fn_Staff_Full_Name()
		END

		-- If Direct Supervisor is the input then grab all staff 1 level below input staff (directly supervised) =======
		IF @ClinicianType = 'Direct Supervisor' AND @ClinicianId <> 0
		BEGIN
			INSERT INTO #StaffInfo ( StaffId, StaffName )
			SELECT	StaffId, StaffName
			FROM	dbo.fn_Supervisor_List(1, @ClinicianId)
		END

		-- If Indirect Supervisor is the input then grab all staff with the same program as the provided staff =========
		IF @ClinicianType = 'Indirect Supervisor' AND @ClinicianId <> 0
		BEGIN
			INSERT INTO #StaffInfo ( StaffId, StaffName )
			SELECT	DISTINCT SS.StaffId,
					SS.StaffName
			FROM	dbo.fn_Supervisor_List(10, @ClinicianId) SS
			JOIN	dbo.StaffPrograms SP1 ON SS.StaffId = SP1.StaffId
				AND	ISNULL(SP1.RecordDeleted, 'N') = 'N'
			WHERE	SP1.ProgramId IN
			(
				SELECT	ProgramId
				FROM	dbo.StaffPrograms SP2
				WHERE	ISNULL(SP2.RecordDeleted, 'N') = 'N'
					AND SP2.StaffId = @ClinicianId
			)
		END

		-- If VP is the input then grab all staff up to 10 levels below input staff ====================================
		IF @ClinicianType = 'VP' AND @ClinicianId <> 0
		BEGIN
			INSERT INTO #StaffInfo ( StaffId, StaffName )
			SELECT	StaffId, StaffName
			FROM	dbo.fn_Supervisor_List(10, @ClinicianId)	
		END

		-- If individual staff is the input then grab that staff only ==================================================
		IF @ClinicianType = 'Staff' AND @ClinicianId <> 0
		BEGIN
			INSERT INTO #StaffInfo ( StaffId )
			VALUES (@ClinicianId)

			UPDATE	#StaffInfo
			SET	StaffName = 
			(
				SELECT	S.DisplayAs
				FROM	#StaffInfo TS
				JOIN	dbo.Staff S ON TS.StaffId = S.StaffId
				WHERE	ISNULL(S.RecordDeleted, 'N') = 'N'
			)
		END

		-- #########################################################################################
		-- Get all valid service note document codes
		-- #########################################################################################
		IF OBJECT_ID('tempdb..#ValidDocumentCodes') IS NOT NULL
			DROP TABLE #ValidDocumentCodes
		CREATE	TABLE #ValidDocumentCodes
		(
			DocumentCodeId INT NOT NULL,
			DocumentName VARCHAR(150) NULL
		)
		INSERT INTO #ValidDocumentCodes
		(	
			DocumentCodeId, 
			DocumentName 
		)
		SELECT	DocumentCodeId,
				DocumentName
		FROM	dbo.DocumentCodes
		WHERE	ServiceNote = 'Y'
			AND Active = 'Y'
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
			AND	DocumentType = 10
			AND RequiresSignature = 'Y'
		--UNION
		--SELECT	DocumentCodeId,
		--		DocumentName
		--FROM	dbo.DocumentCodes
		--WHERE	DocumentCodeId = @DADocumentCodeId

		-- #########################################################################################
		-- Get the valid "Diagnostic Assesment" services based on the specified date range
		-- #########################################################################################
		IF OBJECT_ID('tempdb..#DxServices') IS NOT NULL
			DROP TABLE #DxServices
		CREATE TABLE #DxServices
		(
			DocumentId INT NOT NULL,
			ServiceId INT NOT NULL,
			Clinician VARCHAR(100) NULL,
			ServiceCreatedDate DATETIME NULL,
			DateOfService DATETIME,
			ServiceProgram VARCHAR(250) NULL,
			ServiceProcCode VARCHAR(250) NULL,
			ServiceCompleteTime DATETIME NULL,
			ClientId INT NOT NULL,
			DocumentCodeId INT NOT NULL,
			CurrentDocumentVersionId INT NULL,
			AuthorId INT NULL,
			EffectiveDate DATETIME NULL,
			SignatureDate DATETIME NULL,
			SignerName VARCHAR(100) NULL,
			ServiceMsg VARCHAR(MAX)
		)

		INSERT INTO #DxServices
		(
			DocumentId ,
			ServiceId ,
			Clinician,
			ServiceCreatedDate,
			DateOfService,
			ServiceProgram,
			ServiceProcCode,
			ServiceCompleteTime,
			ClientId ,
			DocumentCodeId ,
			CurrentDocumentVersionId ,
			AuthorId ,
			EffectiveDate ,
			SignatureDate ,
			SignerName
		)
		SELECT	D.DocumentId,
				S.ServiceId,
				ST.StaffName,
				S.CreatedDate,
				S.DateOfService,
				P.ProgramCode,
				PC.DisplayAs,
				CASE 
					WHEN S.ModifiedBy = 'SERVICECOMPLETE'
						THEN S.ModifiedDate
					ELSE NULL
				END AS ServiceCompleteTime,
				S.ClientId,
				D.DocumentCodeId,
				D.CurrentDocumentVersionId,
				D.AuthorId,
				D.EffectiveDate,
				DS.SignatureDate,
				DS.SignerName
		FROM	dbo.Documents D
		JOIN	dbo.DocumentSignatures DS ON D.DocumentId = DS.DocumentId
			AND	ISNULL(DS.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN	Services S ON S.ClientId = D.ClientId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		JOIN	dbo.Programs P ON S.ProgramId = P.ProgramId
			AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.#StaffInfo ST ON S.ClinicianId = ST.StaffId
		WHERE	D.Status = 22 -- signed
			AND D.DocumentCodeId = @DADocumentCodeId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND S.ProcedureCodeId = @DAProcedureCodeId
			AND S.Status IN (71, 75)
			AND CAST(S.DateOfService AS DATE) = CAST(D.EffectiveDate AS DATE)
			AND S.DateOfService BETWEEN @StartDate AND @EndDate
			AND	DS.SignatureOrder = 1
			AND DS.StaffId = D.AuthorId
			AND P.Active = 'Y'
			AND PC.Active = 'Y'

		UPDATE	#DxServices
		SET		ServiceMsg = 'No DA service found for the DA document with the effective date as ' + EffectiveDate
		WHERE	ServiceId IS NULL
			
		-- #########################################################################################
		-- Get the signed documents information based on the valid document codes
		-- #########################################################################################
		IF OBJECT_ID('tempdb..#ServiceNotesInfo') IS NOT NULL
			DROP TABLE #ServiceNotesInfo
		CREATE	TABLE #ServiceNotesInfo
		(
			DocumentId INT NOT NULL,
			ServiceId INT NOT NULL,
			Clinician VARCHAR(100) NULL,
			ServiceCreatedDate DATETIME NULL,
			--ServiceDate DATE NULL,
			--ServiceTime TIME NULL,
			DateOfService DATETIME,
			ServiceProgram VARCHAR(250) NULL,
			ServiceProcCode VARCHAR(250) NULL,
			ServiceCompleteTime DATETIME NULL,
			ClientId INT NOT NULL,
			DocumentCodeId INT NOT NULL,
			CurrentDocumentVersionId INT NULL,
			AuthorId INT NULL,
			EffectiveDate DATETIME NULL,
			SignatureDate DATETIME NULL,
			SignerName VARCHAR(100) NULL,
			ServiceMsg VARCHAR(MAX)
		)

		INSERT INTO #ServiceNotesInfo
		(
			DocumentId ,
			ServiceId ,
			Clinician,
			ServiceCreatedDate,
			DateOfService,
			ServiceProgram,
			ServiceProcCode,
			ServiceCompleteTime,
			ClientId ,
			DocumentCodeId ,
			CurrentDocumentVersionId ,
			AuthorId ,
			EffectiveDate ,
			SignatureDate ,
			SignerName
		)
		SELECT	D.DocumentId,
				D.ServiceId,
				ST.StaffName,
				S.CreatedDate,
				--CONVERT(DATE, S.DateOfService) AS ServiceDate,
				--CONVERT(TIME, S.DateOfService) AS ServiceTime,
				S.DateOfService,
				P.ProgramCode,
				PC.DisplayAs,
				CASE 
					WHEN S.ModifiedBy = 'SERVICECOMPLETE'
						THEN S.ModifiedDate
					ELSE NULL
				END AS ServiceCompleteTime,
				S.ClientId,
				D.DocumentCodeId,
				D.CurrentDocumentVersionId,
				D.AuthorId,
				D.EffectiveDate,
				DS.SignatureDate,
				DS.SignerName
		FROM	dbo.Documents D
		JOIN	dbo.DocumentSignatures DS ON D.DocumentId = DS.DocumentId
			AND	ISNULL(DS.RecordDeleted, 'N') <> 'Y'
		JOIN	#ValidDocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId
			AND	ISNULL(D.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.Services S ON D.ServiceId = S.ServiceId
			AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.Programs P ON S.ProgramId = P.ProgramId
			AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.#StaffInfo ST ON S.ClinicianId = ST.StaffId
			--AND	ISNULL(ST.RecordDeleted, 'N') <> 'Y'
		WHERE	D.Status = 22 -- Signed
			AND	DS.SignatureOrder = 1
			AND DS.StaffId = D.AuthorId
			AND D.ServiceId IS NOT NULL
			AND	S.Status = 75 -- Complete
			AND P.Active = 'Y'
			AND PC.Active = 'Y'
			AND S.DateOfService BETWEEN @StartDate AND @EndDate

		-- #########################################################################################
		-- ==== Report content selection =======================================
		-- #########################################################################################
		IF OBJECT_ID('tempdb..#Report') IS NOT NULL
			DROP TABLE #Report
		CREATE	TABLE #Report
		(
			Clinician VARCHAR(100),
			ClientId INT ,
			ServiceProgram VARCHAR(250),
			ServiceProcCode VARCHAR(250),
			ServiceCreatedDate DATETIME,
			DateOfService DATETIME,
			SignatureDate DATETIME,
			ServiceCompleteTime DATETIME,
			ServiceMsg VARCHAR(MAX),
			Title VARCHAR(MAX),
			SubTitle VARCHAR(MAX),
			SystemMessage VARCHAR(MAX)
		)

		INSERT INTO #Report
		(
			Clinician,
			ClientId,
			ServiceProgram,
			ServiceProcCode,
			ServiceCreatedDate,
			DateOfService,
			SignatureDate,
			ServiceCompleteTime,
			ServiceMsg,
			Title,
			SubTitle,
			SystemMessage
		)
		SELECT	Clinician,
				ClientId,
				ServiceProgram,
				ServiceProcCode,
				ServiceCreatedDate,
				DateOfService,
				SignatureDate,
				ServiceCompleteTime,
				ServiceMsg,
				@Title AS Title,
				@SubTitle AS SubTitle,
				@SystemMessage AS SystemMessage
		FROM	#ServiceNotesInfo	
		UNION
		SELECT	Clinician,
				ClientId,
				ServiceProgram,
				ServiceProcCode,
				ServiceCreatedDate,
				DateOfService,
				SignatureDate,
				ServiceCompleteTime,
				ServiceMsg,
				@Title AS Title,
				@SubTitle AS SubTitle,
				@SystemMessage AS SystemMessage
		FROM	#DxServices

		IF NOT EXISTS(SELECT 1 FROM #Report)
		BEGIN
			SET	@SystemMessage = 'Insufficient data to generate report, please revise your report filter options.'
			INSERT INTO #Report
			(
				Title,
				SubTitle,
				SystemMessage
			)
			VALUES
			(
				@Title,
				@SubTitle,
				@SystemMessage
			)
		END

		SELECT	Clinician,
				ClientId,
				ServiceProgram,
				ServiceProcCode,
				ServiceCreatedDate,
				DateOfService,
				SignatureDate,
				ServiceCompleteTime,
				ServiceMsg,
				Title,
				SubTitle,
				SystemMessage
		FROM	dbo.#Report
		ORDER BY Clinician, DateOfService


		DROP TABLE #ValidDocumentCodes
		DROP TABLE #ServiceNotesInfo
		DROP TABLE #DxServices

		SET NOCOUNT OFF
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	END TRY
	-- =============================================================================================
	BEGIN CATCH
		SET NOCOUNT OFF
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED

		DECLARE @ErrorMsg VARCHAR(MAX)
		SET @ErrorMsg = ERROR_MESSAGE()

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END