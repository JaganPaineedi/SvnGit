/****** Object:  StoredProcedure [dbo].[ssp_RDLMeaningfulPatientPortalFromMUThird]    Script Date: 08/09/2018 17:23:07 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulPatientPortalFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulPatientPortalFromMUThird]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLMeaningfulPatientPortalFromMUThird]    Script Date: 08/09/2018 17:23:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulPatientPortalFromMUThird] @StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@MeasureType INT
	,@MeasureSubType INT
	,@ProblemList VARCHAR(50)
	,@Option CHAR(1)
	,@Stage VARCHAR(10) = NULL
	,@InPatient INT = 0
	,@Tin VARCHAR(150)
	/********************************************************************************                        
-- Stored Procedure: dbo.ssp_RDLMeaningfulPatientPortalFromMUThird                          
--                       
-- Copyright: Streamline Healthcate Solutions                     
--                        
-- Updates:                                                                               
-- Date   Author   Purpose                        
-- 13-Oct-2017  Gautam  What:Get PatientPortal List                        
--      Why:MeaningFul Use Stage3                    
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF @MeasureType <> 8697
			OR @InPatient <> 0
		BEGIN
			RETURN
		END

		CREATE TABLE #RESULT (
			ClientId INT
			,ClientName VARCHAR(250)
			,ProviderName VARCHAR(250)
			,DateOfService DATETIME
			,ProcedureCodeName VARCHAR(250)
			,PortalDate DATETIME
			,UserName VARCHAR(MAX)
			,LastVisit DATETIME
			)

		CREATE TABLE #PatientPortal (
			ClientId INT
			,ClientName VARCHAR(250)
			,ProviderName VARCHAR(250)
			,DateOfService DATETIME
			,ProcedureCodeName VARCHAR(250)
			,PortalDate DATETIME
			,UserName VARCHAR(MAX)
			,LastVisit DATETIME
			,LocationId INT
			)

		CREATE TABLE #PatientPortalService (
			ClientId INT
			,ClientName VARCHAR(250)
			,ProviderName VARCHAR(250)
			,DateOfService DATETIME
			,ProcedureCodeName VARCHAR(250)
			,PortalDate DATETIME
			,UserName VARCHAR(MAX)
			,LastVisit DATETIME
			,NextDateOfService DATETIME
			,ServiceId INT
			,LocationId INT
			)

		CREATE TABLE #PatientPortalNumClient (
			ClientId INT
			,DateOfService DATETIME
			,ClinicianId INT
			)

		IF @MeasureType = 8697
		BEGIN
			DECLARE @MeaningfulUseStageLevel VARCHAR(10)
			DECLARE @RecordCounter INT
			DECLARE @TotalRecords INT

			IF @Stage IS NULL
			BEGIN
				SELECT TOP 1 @MeaningfulUseStageLevel = Value
				FROM SystemConfigurationKeys
				WHERE [key] = 'MeaningfulUseStageLevel'
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
			ELSE
			BEGIN
				SET @MeaningfulUseStageLevel = @Stage
			END

			DECLARE @ProviderName VARCHAR(40)

			SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))
			FROM staff
			WHERE staffId = @StaffId

			SET @RecordCounter = 1

			CREATE TABLE #StaffExclusionDates (
				MeasureType INT
				,MeasureSubType INT
				,Dates DATE
				,StaffId INT
				)

			CREATE TABLE #ProcedureExclusionDates (
				MeasureType INT
				,MeasureSubType INT
				,Dates DATE
				,ProcedureId INT
				)

			CREATE TABLE #OrgExclusionDates (
				MeasureType INT
				,MeasureSubType INT
				,Dates DATE
				,OrganizationExclusion CHAR(1)
				)

			CREATE TABLE #StaffExclusionDateRange (
				ID INT identity(1, 1)
				,MeasureType INT
				,MeasureSubType INT
				,StartDate DATE
				,EndDate DATE
				,StaffId INT
				)

			CREATE TABLE #OrgExclusionDateRange (
				ID INT identity(1, 1)
				,MeasureType INT
				,MeasureSubType INT
				,StartDate DATE
				,EndDate DATE
				,OrganizationExclusion CHAR(1)
				)

			CREATE TABLE #ProcedureExclusionDateRange (
				ID INT identity(1, 1)
				,MeasureType INT
				,MeasureSubType INT
				,StartDate DATE
				,EndDate DATE
				,ProcedureId INT
				)

			INSERT INTO #StaffExclusionDateRange
			SELECT MFU.MeasureType
				,MFU.MeasureSubType
				,cast(MFP.ProviderExclusionFromDate AS DATE)
				,CASE 
					WHEN cast(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)
						THEN CAST(@EndDate AS DATE)
					ELSE cast(MFP.ProviderExclusionToDate AS DATE)
					END
				,MFP.StaffId
			FROM MeaningFulUseProviderExclusions MFP
			INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId
				AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
				AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
			WHERE MFU.Stage = @MeaningfulUseStageLevel
				AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)
				AND MFP.StaffId = @StaffId

			INSERT INTO #OrgExclusionDateRange
			SELECT MFU.MeasureType
				,MFU.MeasureSubType
				,cast(MFP.ProviderExclusionFromDate AS DATE)
				,CASE 
					WHEN cast(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)
						THEN CAST(@EndDate AS DATE)
					ELSE cast(MFP.ProviderExclusionToDate AS DATE)
					END
				,MFP.OrganizationExclusion
			FROM MeaningFulUseProviderExclusions MFP
			INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId
				AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
				AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
			WHERE MFU.Stage = @MeaningfulUseStageLevel
				AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)
				AND MFP.StaffId IS NULL

			INSERT INTO #ProcedureExclusionDateRange
			SELECT MFU.MeasureType
				,MFU.MeasureSubType
				,cast(MFE.ProcedureExclusionFromDate AS DATE)
				,CASE 
					WHEN cast(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)
						THEN CAST(@EndDate AS DATE)
					ELSE cast(MFE.ProcedureExclusionToDate AS DATE)
					END
				,MFP.ProcedureCodeId
			FROM MeaningFulUseProcedureExclusionProcedures MFP
			INNER JOIN MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId
				AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
				AND ISNULL(MFE.RecordDeleted, 'N') = 'N'
			INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId
				AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
			WHERE MFU.Stage = @MeaningfulUseStageLevel
				AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)
				AND MFP.ProcedureCodeId IS NOT NULL

			SELECT @TotalRecords = COUNT(*)
			FROM #StaffExclusionDateRange

			WHILE @RecordCounter <= @TotalRecords
			BEGIN
				INSERT INTO #StaffExclusionDates
				SELECT tp.MeasureType
					,tp.MeasureSubType
					,cast(dt.[Date] AS DATE)
					,tp.StaffId
				FROM #StaffExclusionDateRange tp
				INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate
					AND dt.[Date] <= tp.EndDate
				WHERE tp.ID = @RecordCounter
					AND dt.[Date] <= cast(@EndDate AS DATE)
					AND NOT EXISTS (
						SELECT 1
						FROM #StaffExclusionDates S
						WHERE S.Dates = cast(dt.[Date] AS DATE)
							AND S.StaffId = tp.StaffId
							AND s.MeasureType = tp.MeasureType
							AND S.MeasureSubType = tp.MeasureSubType
						)

				SET @RecordCounter = @RecordCounter + 1
			END

			SET @RecordCounter = 1

			SELECT @TotalRecords = COUNT(*)
			FROM #OrgExclusionDateRange

			WHILE @RecordCounter <= @TotalRecords
			BEGIN
				INSERT INTO #OrgExclusionDates
				SELECT tp.MeasureType
					,tp.MeasureSubType
					,cast(dt.[Date] AS DATE)
					,tp.OrganizationExclusion
				FROM #OrgExclusionDateRange tp
				INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate
					AND dt.[Date] <= tp.EndDate
				WHERE tp.ID = @RecordCounter
					AND dt.[Date] <= cast(@EndDate AS DATE)
					AND NOT EXISTS (
						SELECT 1
						FROM #OrgExclusionDates S
						WHERE S.Dates = cast(dt.[Date] AS DATE)
							AND s.MeasureType = tp.MeasureType
							AND s.MeasureSubType = tp.MeasureSubType
						)

				SET @RecordCounter = @RecordCounter + 1
			END

			SET @RecordCounter = 1

			SELECT @TotalRecords = COUNT(*)
			FROM #ProcedureExclusionDateRange

			WHILE @RecordCounter <= @TotalRecords
			BEGIN
				INSERT INTO #ProcedureExclusionDates
				SELECT tp.MeasureType
					,tp.MeasureSubType
					,cast(dt.[Date] AS DATE)
					,tp.ProcedureId
				FROM #ProcedureExclusionDateRange tp
				INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate
					AND dt.[Date] <= tp.EndDate
				WHERE tp.ID = @RecordCounter
					AND dt.[Date] <= cast(@EndDate AS DATE)
					AND NOT EXISTS (
						SELECT 1
						FROM #ProcedureExclusionDates S
						WHERE S.Dates = cast(dt.[Date] AS DATE)
							AND S.ProcedureId = tp.ProcedureId
							AND s.MeasureType = tp.MeasureType
							AND s.MeasureSubType = tp.MeasureSubType
						)

				SET @RecordCounter = @RecordCounter + 1
			END

			IF @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
				AND @MeasureSubType = 6261
			BEGIN
					;

				WITH TempPortal
				AS (
					SELECT ROW_NUMBER() OVER (
							PARTITION BY S.ClientId ORDER BY S.ClientId
								,s.DateOfservice
							) AS row
						,S.ClientId
						,S.ClientName
						,NULL AS PrescribedDate
						,@ProviderName AS ProviderName
						,S.DateOfService
						,S.ProcedureCodeName
						,S.ServiceId
						,S.LocationId
					FROM ViewMUClientServices S
					WHERE S.ClinicianId = @StaffId
						AND NOT EXISTS (
							SELECT 1
							FROM #ProcedureExclusionDates PE
							WHERE S.ProcedureCodeId = PE.ProcedureId
								AND PE.MeasureType = 8697
								AND PE.MeasureSubType = 6261
								AND CAST(S.DateOfService AS DATE) = PE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE S.ClinicianId = SE.StaffId
								AND SE.MeasureType = 8697
								AND SE.MeasureSubType = 6261
								AND CAST(S.DateOfService AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(S.DateOfService AS DATE) = OE.Dates
								AND OE.MeasureType = 8697
								AND OE.MeasureSubType = 6261
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
						AND S.DateOfService <= CAST(@EndDate AS DATE)
						AND (
							@Tin = 'NA'
							OR S.TaxIdentificationNumber = @Tin
							)
					)
				INSERT INTO #PatientPortalService (
					ClientId
					,ClientName
					,PortalDate
					,ProviderName
					,DateOfService
					,ProcedureCodeName
					,NextDateOfService
					,ServiceId
					)
				SELECT T.ClientId
					,T.ClientName
					,T.PrescribedDate
					,T.ProviderName
					,T.DateOfService
					,T.ProcedureCodeName
					,NT.DateOfService AS NextDateOfService
					,T.ServiceId
				FROM TempPortal T
				LEFT JOIN TempPortal NT ON NT.ClientId = T.ClientId
					AND NT.row = T.row + 1

				INSERT INTO #PatientPortalNumClient
				SELECT S.ClientId
					,max(S.DateOfService)
					,S.ClinicianId
				FROM dbo.ViewMUClientServices S
				WHERE (
						@MeaningfulUseStageLevel = 8768
						OR (
							@MeaningfulUseStageLevel IN (
								9476
								,9477
								,9480
								,9481
								)
							AND S.TaxIdentificationNumber = @Tin
							)
						)
					AND S.ClinicianId = @StaffId
					AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
					AND S.DateOfService <= CAST(@EndDate AS DATE)
				GROUP BY S.ClientId
					,S.ClinicianId

				INSERT INTO #PatientPortal (
					ClientId
					,PortalDate
					,DateOfService
					,UserName
					,LastVisit
					)
				SELECT DISTINCT S.ClientId
					,D.EffectiveDate
					,S.DateOfService
					,ISNULL(ST.UserCode, '')
					,St.LastVisit
				FROM #PatientPortalNumClient S
				INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId
				JOIN DOCUMENTS D ON S.ClientId = D.ClientId
					AND isnull(D.RecordDeleted, 'N') = 'N'
					AND D.DocumentCodeId IN (
						1611
						,1644
						,1645
						,1646
						)
				JOIN TransitionOfCareDocuments TD ON D.InProgressDocumentVersionId = TD.DocumentVersionId
				LEFT JOIN Locations L ON TD.LocationId = L.LocationId
				WHERE isnull(St.RecordDeleted, 'N') = 'N'
					AND (
						Datediff(hh, S.DateOfService, D.EffectiveDate) < 48
						AND Datediff(hh, cast(S.DateOfService AS DATE), cast(D.EffectiveDate AS DATE)) >= 0
						)
					AND isnull(TD.RecordDeleted, 'N') = 'N'
					AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
					AND TD.ProviderId = S.ClinicianId
					--AND TD.LocationId is not null 
					AND (
						ISNULL(TD.LocationId, - 1) = - 1
						OR L.TaxIdentificationNumber = @Tin
						)
					AND Isnull(St.NonStaffUser, 'N') = 'Y' --TransitionOfCareDocuments                                                                              
					AND S.DateOfService >= CAST(@StartDate AS DATE)
					AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)

				IF @Option = 'D'
				BEGIN
					/* 8697(Patient Portal)*/
					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,PortalDate
						,UserName
						,LastVisit
						)
					SELECT DISTINCT PS.ClientId
						,PS.ClientName
						,PS.ProviderName
						,PS.DateOfService
						,PS.ProcedureCodeName
						,P.PortalDate
						,P.UserName
						,P.LastVisit
					FROM #PatientPortalService PS
					LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId
						AND (
							(
								PS.NextDateOfService IS NULL
								OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)
								AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))
								)
							)
				END

				IF (
						@Option = 'N'
						OR @Option = 'A'
						)
				BEGIN
					/* 8697(Patient Portal)*/
					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,PortalDate
						,UserName
						,LastVisit
						)
					SELECT DISTINCT ClientId
						,ClientName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,PortalDate
						,UserName
						,LastVisit
					FROM (
						SELECT DISTINCT PS.ClientId
							,PS.ClientName
							,PS.ProviderName
							,PS.DateOfService
							,PS.ProcedureCodeName
							,P.PortalDate
							,P.UserName
							,P.LastVisit
						FROM #PatientPortalService PS
						LEFT JOIN #PatientPortal P ON PS.ClientId = P.ClientId
							AND (
								(
									PS.NextDateOfService IS NULL
									OR cast(P.PortalDate AS DATE) <= cast(PS.NextDateOfService AS DATE)
									AND (cast(P.PortalDate AS DATE) > cast(PS.DateOfService AS DATE))
									)
								)
						) AS Result
					WHERE Result.PortalDate IS NOT NULL
						AND (
							NOT EXISTS (
								SELECT 1
								FROM #PatientPortal M1
								WHERE (
										Result.DateOfService < M1.DateOfService
										OR Result.PortalDate > M1.PortalDate
										)
									AND M1.ClientId = Result.ClientId
								)
							)
				END
			END
					--   /* 8697(Patient Portal)*/                
		END

		SELECT R.ClientId
			,R.ClientName
			,R.ProviderName
			,convert(VARCHAR, R.DateOfService, 101) AS DateOfService
			,R.ProcedureCodeName
			,convert(VARCHAR, R.PortalDate, 101) AS PortalDate
			,R.UserName
			,convert(VARCHAR, R.LastVisit, 101) AS LastVisit
			,@Tin AS 'Tin'
		FROM #RESULT R
		ORDER BY R.ClientId ASC
			,R.DateOfService DESC
			,R.PortalDate DESC
			,R.LastVisit DESC
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulPatientPortalFromMUThird') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.                
				16
				,-- Severity.                
				1 -- State.                
				);
	END CATCH
END
GO


