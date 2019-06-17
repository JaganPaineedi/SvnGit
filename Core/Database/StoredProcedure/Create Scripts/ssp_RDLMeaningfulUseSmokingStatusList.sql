IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseSmokingStatusList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseSmokingStatusList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseSmokingStatusList] @StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@MeasureType INT
	,@MeasureSubType INT
	,@ProblemList VARCHAR(50)
	,@Option CHAR(1)
	,@Stage VARCHAR(10) = NULL
	,@InPatient INT = 0
	/********************************************************************************                                  
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseSmokingStatusList                                    
--                                 
-- Copyright: Streamline Healthcate Solutions                               
--                                  
-- Updates:                                                                                         
-- Date   Author   Purpose                                       
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement  
       why : Meaningful Use, Task #66 - Stage 2 - Modified                        
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF @MeasureType <> 8688
			OR @InPatient <> 0
		BEGIN
			RETURN
		END

		SET @ProblemList = CASE 
				WHEN @ProblemList = '0'
					OR @ProblemList IS NULL
					THEN 'Behaviour'
				ELSE @ProblemList
				END

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

		SELECT TOP 1 @ProviderName = (ISNULL(LastName, '') + ', ' + ISNULL(FirstName, ''))
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
			ID INT IDENTITY(1, 1)
			,MeasureType INT
			,MeasureSubType INT
			,StartDate DATE
			,EndDate DATE
			,StaffId INT
			)

		CREATE TABLE #OrgExclusionDateRange (
			ID INT IDENTITY(1, 1)
			,MeasureType INT
			,MeasureSubType INT
			,StartDate DATE
			,EndDate DATE
			,OrganizationExclusion CHAR(1)
			)

		CREATE TABLE #ProcedureExclusionDateRange (
			ID INT IDENTITY(1, 1)
			,MeasureType INT
			,MeasureSubType INT
			,StartDate DATE
			,EndDate DATE
			,ProcedureId INT
			)

		INSERT INTO #StaffExclusionDateRange
		SELECT MFU.MeasureType
			,MFU.MeasureSubType
			,CAST(MFP.ProviderExclusionFromDate AS DATE)
			,CASE 
				WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)
					THEN CAST(@EndDate AS DATE)
				ELSE CAST(MFP.ProviderExclusionToDate AS DATE)
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
			,CAST(MFP.ProviderExclusionFromDate AS DATE)
			,CASE 
				WHEN CAST(MFP.ProviderExclusionToDate AS DATE) > CAST(@EndDate AS DATE)
					THEN CAST(@EndDate AS DATE)
				ELSE CAST(MFP.ProviderExclusionToDate AS DATE)
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
			,CAST(MFE.ProcedureExclusionFromDate AS DATE)
			,CASE 
				WHEN CAST(MFE.ProcedureExclusionToDate AS DATE) > CAST(@EndDate AS DATE)
					THEN CAST(@EndDate AS DATE)
				ELSE CAST(MFE.ProcedureExclusionToDate AS DATE)
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
				,CAST(dt.[Date] AS DATE)
				,tp.StaffId
			FROM #StaffExclusionDateRange tp
			INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate
				AND dt.[Date] <= tp.EndDate
			WHERE tp.ID = @RecordCounter
				AND dt.[Date] <= cast(@EndDate AS DATE)
				AND NOT EXISTS (
					SELECT 1
					FROM #StaffExclusionDates S
					WHERE S.Dates = CAST(dt.[Date] AS DATE)
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
				,CAST(dt.[Date] AS DATE)
				,tp.OrganizationExclusion
			FROM #OrgExclusionDateRange tp
			INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate
				AND dt.[Date] <= tp.EndDate
			WHERE tp.ID = @RecordCounter
				AND dt.[Date] <= cast(@EndDate AS DATE)
				AND NOT EXISTS (
					SELECT 1
					FROM #OrgExclusionDates S
					WHERE S.Dates = CAST(dt.[Date] AS DATE)
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
				,CAST(dt.[Date] AS DATE)
				,tp.ProcedureId
			FROM #ProcedureExclusionDateRange tp
			INNER JOIN Dates AS dt ON dt.[Date] >= tp.StartDate
				AND dt.[Date] <= tp.EndDate
			WHERE tp.ID = @RecordCounter
				AND dt.[Date] <= cast(@EndDate AS DATE)
				AND NOT EXISTS (
					SELECT 1
					FROM #ProcedureExclusionDates S
					WHERE S.Dates = CAST(dt.[Date] AS DATE)
						AND S.ProcedureId = tp.ProcedureId
						AND s.MeasureType = tp.MeasureType
						AND s.MeasureSubType = tp.MeasureSubType
					)

			SET @RecordCounter = @RecordCounter + 1
		END

		CREATE TABLE #RESULT (
			ClientId INT
			,ClientName VARCHAR(250)
			,PrescribedDate DATETIME
			,MedicationName VARCHAR(MAX)
			,ProviderName VARCHAR(250)
			,DateOfService DATETIME
			,ProcedureCodeName VARCHAR(250)
			,ETransmitted VARCHAR(20)
			)

		CREATE TABLE #RESULT1 (
			ClientId INT
			,ClientName VARCHAR(250)
			,PrescribedDate DATETIME
			,MedicationName VARCHAR(MAX)
			,ProviderName VARCHAR(250)
			,DateOfService DATETIME
			,ProcedureCodeName VARCHAR(250)
			,ETransmitted VARCHAR(20)
			)

		DECLARE @UserCode VARCHAR(500)

		SELECT TOP 1 @UserCode = UserCode
		FROM Staff
		WHERE StaffId = @StaffId

		IF @MeasureType = 8688
		BEGIN
			/* 8688(SmokingStatus)*/
			CREATE TABLE #Smoking (
				ClientId INT
				,ClientName VARCHAR(MAX)
				,PrescribedDate DATETIME
				,MedicationName VARCHAR(MAX)
				,DateOfService DATETIME
				,ProcedureCodeName VARCHAR(MAX)
				,ProviderName VARCHAR(250)
				,NextDateOfService DATETIME
				)

			CREATE TABLE #SmokingData (
				ClientId INT
				,HealthRecordDate DATETIME
				,MedicationName VARCHAR(MAX)
				,DateOfService DATETIME
				);

			WITH TempSmoking
			AS (
				SELECT ROW_NUMBER() OVER (
						PARTITION BY S.ClientId ORDER BY S.ClientId
							,s.DateOfservice
						) AS row
					,S.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,NULL AS PrescribedDate
					,@ProviderName AS ProviderName
					,S.DateOfService
					,P.ProcedureCodeName
				FROM Clients C
				INNER JOIN Services S ON C.ClientId = S.ClientId
				INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId
				WHERE S.STATUS IN (
						71
						,75
						) -- 71 (Show), 75(complete)                                        
					AND ISNULL(S.RecordDeleted, 'N') = 'N'
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND ISNULL(P.RecordDeleted, 'N') = 'N'
					AND S.ClinicianId = @StaffId
					AND NOT EXISTS (
						SELECT 1
						FROM #ProcedureExclusionDates PE
						WHERE S.ProcedureCodeId = PE.ProcedureId
							AND PE.MeasureType = 8688
							AND CAST(S.DateOfService AS DATE) = PE.Dates
						)
					AND NOT EXISTS (
						SELECT 1
						FROM #StaffExclusionDates SE
						WHERE S.ClinicianId = SE.StaffId
							AND SE.MeasureType = 8688
							AND CAST(S.DateOfService AS DATE) = SE.Dates
						)
					AND NOT EXISTS (
						SELECT 1
						FROM #OrgExclusionDates OE
						WHERE CAST(S.DateOfService AS DATE) = OE.Dates
							AND OE.MeasureType = 8688
							AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
						)
					AND S.DateOfService >= CAST(@StartDate AS DATE)
					AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
					AND (dbo.[GetAge](C.DOB, GETDATE())) >= 13
				)
			INSERT INTO #Smoking (
				ClientId
				,ClientName
				,PrescribedDate
				,ProviderName
				,DateOfService
				,ProcedureCodeName
				,NextDateOfService
				)
			SELECT T.ClientId
				,T.ClientName
				,T.PrescribedDate
				,T.ProviderName
				,T.DateOfService
				,T.ProcedureCodeName
				,NT.DateOfService AS NextDateOfService
			FROM TempSmoking T
			LEFT JOIN TempSmoking NT ON NT.ClientId = T.ClientId
				AND NT.row = T.row + 1

			INSERT INTO #SmokingData (
				ClientId
				,MedicationName
				,HealthRecordDate
				,DateOfService
				)
			SELECT CDI.ClientId
				,CASE 
					WHEN HDA.NAME = 'Smoking Status'
						THEN dbo.GetGlobalCodeName(CDI.Value)
					ELSE NULL
					END
				,CDI.HealthRecordDate
				,V.DateOfService
			FROM #Smoking V
			INNER JOIN dbo.ClientHealthDataAttributes CDI ON CDI.ClientId = V.ClientId
			INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
				--AND HDA.HealthDataAttributeId = 123  
				AND HDA.NAME = 'Smoking Status'
				--AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)  
				AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
				AND ISNULL(CDI.RecordDeleted, 'N') = 'N'
				AND ISNULL(HDA.RecordDeleted, 'N') = 'N'

			IF @Option = 'D'
			BEGIN
				INSERT INTO #RESULT (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,DateOfService
					,ProcedureCodeName
					)
				SELECT DISTINCT V.ClientId
					,V.ClientName
					,T.HealthRecordDate
					,T.MedicationName
					,V.ProviderName
					,V.DateOfService
					,V.ProcedureCodeName
				FROM #Smoking V
				LEFT JOIN #SmokingData T ON T.ClientId = V.ClientId
					--AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)  
					AND (
						(
							cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)
							AND (
								V.NextDateOfService IS NULL
								OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)
								)
							)
						OR (
							cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #SmokingData T1
								WHERE T1.ClientId = T.ClientId
									AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #Smoking V1
								WHERE V1.ClientId = V.ClientId
									AND (
										cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)
										OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)
										)
								)
							)
						)
			END

			IF (
					@Option = 'N'
					OR @Option = 'A'
					)
			BEGIN
				INSERT INTO #RESULT1 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,DateOfService
					,ProcedureCodeName
					)
				SELECT ClientId
					,ClientName
					,HealthRecordDate
					,MedicationName
					,ProviderName
					,DateOfService
					,ProcedureCodeName
				FROM (
					SELECT DISTINCT V.ClientId
						,V.ClientName
						,T.HealthRecordDate
						,T.MedicationName
						,V.ProviderName
						,V.DateOfService
						,V.ProcedureCodeName
					FROM #Smoking V
					LEFT JOIN #SmokingData T ON T.ClientId = V.ClientId
						AND (
							(
								cast(T.HealthRecordDate AS DATE) >= cast(V.DateOfService AS DATE)
								AND (
									V.NextDateOfService IS NULL
									OR cast(T.HealthRecordDate AS DATE) < cast(V.NextDateOfService AS DATE)
									)
								)
							OR (
								cast(T.HealthRecordDate AS DATE) < cast(V.DateOfService AS DATE)
								AND cast(T.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #SmokingData T1
									WHERE T1.ClientId = T.ClientId
										AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #Smoking V1
									WHERE V1.ClientId = V.ClientId
										AND (
											cast(V.DateOfService AS DATE) < cast(V1.DateOfService AS DATE)
											OR cast(T.HealthRecordDate AS DATE) >= cast(V1.DateOfService AS DATE)
											)
									)
								)
							)
					) AS Result
				WHERE ISNULL(Result.MedicationName, '') <> ''

				INSERT INTO #RESULT (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,DateOfService
					,ProcedureCodeName
					)
				SELECT ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,DateOfService
					,ProcedureCodeName
				FROM #RESULT1
				WHERE (
						NOT EXISTS (
							SELECT 1
							FROM #RESULT1 T1
							WHERE (
									#RESULT1.DateOfService < T1.DateOfService
									OR #RESULT1.PrescribedDate < T1.PrescribedDate
									)
								AND T1.ClientId = #RESULT1.ClientId
							)
						)
					--AND (  
					-- NOT EXISTS (  
					--  SELECT 1  
					--  FROM #SmokingData T1  
					--  WHERE (Result.DateOfService < T1.DateOfService OR Result.HealthRecordDate < T1.HealthRecordDate)  
					--   AND T1.ClientId = Result.ClientId  
					--   --AND ISNULL(Result.MedicationName, '') = ''  
					--  )  
					-- )  
			END
					/* 8688(SmokingStatus)*/
		END

		SELECT R.ClientId
			,R.ClientName
			,CONVERT(VARCHAR, R.PrescribedDate, 101) AS PrescribedDate
			,R.MedicationName
			,R.ProviderName
			,CONVERT(VARCHAR, R.DateOfService, 101) AS DateOfService
			,R.ProcedureCodeName
			,R.ETransmitted
		FROM #RESULT R
		ORDER BY R.ClientId ASC
			,R.DateOfService DESC
			,R.PrescribedDate DESC
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseSmokingStatusList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.                                  
				16
				,-- Severity.                                  
				1 -- State.                                  
				);
	END CATCH
END
