IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulUseList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulUseList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulUseList] @StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@MeasureType INT
	,@MeasureSubType INT
	,@ProblemList VARCHAR(50)
	,@Option CHAR(1)
	,@Stage VARCHAR(10) = NULL
	/********************************************************************************                                
-- Stored Procedure: dbo.ssp_RDLMeaningfulUseList                                  
--                               
-- Copyright: Streamline Healthcate Solutions                             
--                                
-- Updates:                                                                                       
-- Date			Author   Purpose                                
-- 23-may-2014  Revathi  What:RDLMeaningfulUseList.                                      
--						Why:task #26 MeaningFul Use        
-- 11-Jan-2016  Gautam   What : Change the code for Stage 9373 'Stage2 - Modified' requirement
						 why : Meaningful Use, Task	#66 - Stage 2 - Modified  
-- 29-Sep-2016     Gautam           What : Changed for ResponseDate criteria with Startdate and enddate in SureScriptsEligibilityResponse table
									why : KCMHSAS - Support# 625                      
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
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
			AND MFP.StaffId IS NOT NULL

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

		IF @MeasureType = 8680
		BEGIN
			CREATE TABLE #Medication (
				ClientId INT
				,ClientName VARCHAR(250)
				,PrescribedDate DATETIME
				,MedicationName VARCHAR(MAX)
				,ProviderName VARCHAR(250)
				,DateOfService DATETIME
				,ProcedureCodeName VARCHAR(250)
				)

			/*  8680--(CPOE)*/
			IF @MeaningfulUseStageLevel = 8766
			BEGIN
				IF @MeasureSubType = 6177
				BEGIN
					CREATE TABLE #ClientService (
						ClientId INT
						,ClientName VARCHAR(250)
						,PrescribedDate DATETIME
						,MedicationName VARCHAR(MAX)
						,ProviderName VARCHAR(250)
						,DateOfService DATETIME
						,ProcedureCodeName VARCHAR(250)
						,NextDateOfService DATETIME
						)

					IF @Option = 'D'
					BEGIN
							;

						WITH TempProblemList
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
										AND PE.MeasureType = 8680
										AND PE.MeasureSubType = 6177
										AND CAST(S.DateOfService AS DATE) = PE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE S.ClinicianId = SE.StaffId
										AND SE.MeasureType = 8680
										AND SE.MeasureSubType = 6177
										AND CAST(S.DateOfService AS DATE) = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CAST(S.DateOfService AS DATE) = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6177
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
								AND S.DateOfService >= CAST(@StartDate AS DATE)
								AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
							)
						INSERT INTO #ClientService (
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
						FROM TempProblemList T
						LEFT JOIN TempProblemList NT ON NT.ClientId = T.ClientId
							AND NT.row = T.row + 1

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							)
						SELECT C.ClientId
							,C.ClientName
							,CM.MedicationStartDate
							,MD.MedicationName
							,C.ProviderName
							,C.DateOfService
							,C.ProcedureCodeName
						FROM #ClientService C
						INNER JOIN ClientMedications CM ON C.ClientId = CM.ClientId
						INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
							AND cast(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
							AND (
								(
									cast(CM.MedicationStartDate AS DATE) >= cast(C.DateOfService AS DATE)
									AND (
										C.NextDateOfService IS NULL
										OR cast(CM.MedicationStartDate AS DATE) < cast(C.NextDateOfService AS DATE)
										)
									)
								OR (
									cast(CM.MedicationStartDate AS DATE) < cast(C.DateOfService AS DATE)
									AND NOT EXISTS (
										SELECT 1
										FROM ClientMedications MM1
										WHERE MM1.ClientId = CM.ClientId
											AND cast(CM.MedicationStartDate AS DATE) < cast(MM1.MedicationStartDate AS DATE)
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #ClientService Med1
										WHERE Med1.ClientId = C.ClientId
											AND cast(C.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)
										)
									)
								)
							AND ISNULL(CM.RecordDeleted, 'N') = 'N'
							AND ISNULL(MD.RecordDeleted, 'N') = 'N'
					END

					IF (
							@Option = 'N'
							OR @Option = 'A'
							)
					BEGIN
						INSERT INTO #Medication (
							ClientId
							,ClientName
							,ProviderName
							,PrescribedDate
							,MedicationName
							)
						SELECT DISTINCT CM.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName
							,CM.MedicationStartDate
							,MD.MedicationName
						FROM ClientMedications CM
						INNER JOIN Clients C ON C.ClientId = CM.ClientId
						INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
						WHERE isnull(CM.RecordDeleted, 'N') = 'N'
							AND CM.PrescriberId = @StaffId
							AND CM.Ordered = 'Y'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND isnull(MD.RecordDeleted, 'N') = 'N'
							AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)
							AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CM.PrescriberId = SE.StaffId
									AND SE.MeasureType = 8680
									AND SE.MeasureSubType = 6177
									AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8680
									AND OE.MeasureSubType = 6177
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							)
						SELECT DISTINCT M.ClientId
							,M.ClientName
							,M.PrescribedDate
							,M.MedicationName
							,M.ProviderName
							,M.DateOfService
							,M.ProcedureCodeName
						FROM #Medication M
						WHERE (
								NOT EXISTS (
									SELECT 1
									FROM #Medication M1
									WHERE M.PrescribedDate < M1.PrescribedDate
										AND M1.ClientId = M.ClientId
									)
								)
					END
				END

				IF @MeasureSubType = 3
				BEGIN
					/*  8680--(CPOE)*/
					IF @Option = 'D'
					BEGIN
						INSERT INTO #Medication (
							ClientId
							,ClientName
							,ProviderName
							,PrescribedDate
							,MedicationName
							)
						SELECT DISTINCT CM.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName
							,CM.MedicationStartDate
							,MD.MedicationName
						FROM ClientMedications CM
						INNER JOIN Clients C ON C.ClientId = CM.ClientId
						INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
						WHERE isnull(CM.RecordDeleted, 'N') = 'N'
							AND CM.PrescriberId = @StaffId
							AND CM.Ordered = 'Y'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND isnull(MD.RecordDeleted, 'N') = 'N'
							AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)
							AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CM.PrescriberId = SE.StaffId
									AND SE.MeasureType = 8680
									AND SE.MeasureSubType = 6177
									AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8680
									AND OE.MeasureSubType = 6177
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #Medication (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,ProcedureCodeName
							)
						SELECT DISTINCT C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,IR.EffectiveDate AS PrescribedDate
							,IR.RecordDescription
							,@ProviderName AS ProviderName
							,'' --as PProcedureCodeName                              
						FROM Clients C
						INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId
						WHERE ISNULL(IR.RecordDeleted, 'N') = 'N'
							AND ISNULL(C.RecordDeleted, 'N') = 'N'
							AND IR.CreatedBy = @UserCode
							AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                      
							AND CAST(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
							AND CAST(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8680
									AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							)
						SELECT M.ClientId
							,M.ClientName
							,M.PrescribedDate
							,M.MedicationName
							,M.ProviderName
							,M.DateOfService
							,M.ProcedureCodeName
						FROM #Medication M
						WHERE (
								NOT EXISTS (
									SELECT 1
									FROM #Medication M1
									WHERE M.PrescribedDate < M1.PrescribedDate
										AND M1.ClientId = M.ClientId
									)
								)
					END

					IF (
							@Option = 'N'
							OR @Option = 'A'
							)
					BEGIN
						INSERT INTO #Medication (
							ClientId
							,ClientName
							,ProviderName
							,PrescribedDate
							,MedicationName
							)
						SELECT DISTINCT CM.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName
							,CM.MedicationStartDate
							,MD.MedicationName
						FROM ClientMedications CM
						INNER JOIN Clients C ON C.ClientId = CM.ClientId
						INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
						WHERE isnull(CM.RecordDeleted, 'N') = 'N'
							AND CM.PrescriberId = @StaffId
							AND CM.Ordered = 'Y'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND isnull(MD.RecordDeleted, 'N') = 'N'
							AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)
							AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CM.PrescriberId = SE.StaffId
									AND SE.MeasureType = 8680
									AND SE.MeasureSubType = 6177
									AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8680
									AND OE.MeasureSubType = 6177
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							)
						SELECT M.ClientId
							,M.ClientName
							,M.PrescribedDate
							,M.MedicationName
							,M.ProviderName
							,M.DateOfService
							,M.ProcedureCodeName
						FROM #Medication M
						WHERE (
								NOT EXISTS (
									SELECT 1
									FROM #Medication M1
									WHERE M.PrescribedDate < M1.PrescribedDate
										AND M1.ClientId = M.ClientId
									)
								)
					END
				END
			END

			/*  8680--(CPOE)*/
			IF @MeaningfulUseStageLevel = 8767
			-- 11-Jan-2016  Gautam 
				OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'
			BEGIN
				IF @Option = 'D'
				BEGIN
					INSERT INTO #Medication (
						ClientId
						,ClientName
						,ProviderName
						,PrescribedDate
						,MedicationName
						)
					SELECT DISTINCT CM.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName
						,CM.MedicationStartDate
						,MD.MedicationName
					FROM ClientMedications CM
					INNER JOIN Clients C ON C.ClientId = CM.ClientId
					INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
					WHERE isnull(CM.RecordDeleted, 'N') = 'N'
						AND CM.PrescriberId = @StaffId
						AND CM.Ordered = 'Y'
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND isnull(MD.RecordDeleted, 'N') = 'N'
						AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)
						AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE CM.PrescriberId = SE.StaffId
								AND SE.MeasureType = 8680
								AND SE.MeasureSubType = 6177
								AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8680
								AND OE.MeasureSubType = 6177
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)

					INSERT INTO #Medication (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,ProcedureCodeName
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,IR.EffectiveDate AS PrescribedDate
						,IR.RecordDescription
						,@ProviderName AS ProviderName
						,'' --as PProcedureCodeName                              
					FROM Clients C
					INNER JOIN ImageRecords IR ON C.ClientId = IR.ClientId
					WHERE ISNULL(IR.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND IR.CreatedBy = @UserCode
						AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                      
						AND CAST(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
						AND CAST(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(IR.EffectiveDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8680
								AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
							)

					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						)
					SELECT M.ClientId
						,M.ClientName
						,M.PrescribedDate
						,M.MedicationName
						,M.ProviderName
						,M.DateOfService
						,M.ProcedureCodeName
					FROM #Medication M
					WHERE (
							NOT EXISTS (
								SELECT 1
								FROM #Medication M1
								WHERE M.PrescribedDate < M1.PrescribedDate
									AND M1.ClientId = M.ClientId
								)
							)
				END

				IF (
						@Option = 'N'
						OR @Option = 'A'
						)
				BEGIN
					INSERT INTO #Medication (
						ClientId
						,ClientName
						,ProviderName
						,PrescribedDate
						,MedicationName
						)
					SELECT DISTINCT CM.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName
						,CM.MedicationStartDate
						,MD.MedicationName
					FROM ClientMedications CM
					INNER JOIN Clients C ON C.ClientId = CM.ClientId
					INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
					WHERE isnull(CM.RecordDeleted, 'N') = 'N'
						AND CM.PrescriberId = @StaffId
						AND CM.Ordered = 'Y'
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND isnull(MD.RecordDeleted, 'N') = 'N'
						AND CAST(CM.MedicationStartDate AS DATE) >= CAST(@StartDate AS DATE)
						AND CAST(CM.MedicationStartDate AS DATE) <= CAST(@EndDate AS DATE)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE CM.PrescriberId = SE.StaffId
								AND SE.MeasureType = 8680
								AND SE.MeasureSubType = 6177
								AND CAST(CM.MedicationStartDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(CM.MedicationStartDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8680
								AND OE.MeasureSubType = 6177
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)

					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						)
					SELECT M.ClientId
						,M.ClientName
						,M.PrescribedDate
						,M.MedicationName
						,M.ProviderName
						,M.DateOfService
						,M.ProcedureCodeName
					FROM #Medication M
					WHERE ISNULL(M.MedicationName, '') <> ''
						AND (
							NOT EXISTS (
								SELECT 1
								FROM #Medication M1
								WHERE M.PrescribedDate < M1.PrescribedDate
									AND M1.ClientId = M.ClientId
								)
							)
				END
			END
		END
		ELSE
			IF @MeasureType = 8683
			BEGIN
				CREATE TABLE #EPrescriping (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(MAX)
					,ProviderName VARCHAR(250)
					,DateOfService DATETIME
					,ProcedureCodeName VARCHAR(250)
					,ETransmitted VARCHAR(20)
					,ClientMedicationScriptId INT
					,ClientOrderId INT
					)

				/*  8683--(e-Prescribing)*/
				IF @MeasureSubType = 3
					AND @MeaningfulUseStageLevel = 8766
				BEGIN
					IF @Option = 'D'
					BEGIN
						INSERT INTO #EPrescriping (
							ClientMedicationScriptId
							,ClientId
							,ClientName
							,ProviderName
							,ProcedureCodeName
							,DateOfService
							,PrescribedDate
							,MedicationName
							,ETransmitted
							)
						SELECT cmsd.ClientMedicationScriptId
							,C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName)
							,@ProviderName
							,NULL
							,NULL
							,cms.OrderDate
							,MD.MedicationName
							,CASE 
								WHEN cmsa.Method = 'E'
									THEN 'Yes'
								ELSE 'No'
								END
						FROM dbo.ClientMedicationScriptActivities AS cmsa
						INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
							AND isnull(cmsd.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
							AND isnull(cmi.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
							AND isnull(cms.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId
							AND isnull(c.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
							AND isnull(mm.RecordDeleted, 'N') = 'N'
						INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId
						WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
							AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(cmsa.RecordDeleted, 'N') = 'N'
							AND cms.OrderingPrescriberId = @StaffId
							AND EXISTS (
								SELECT 1
								FROM dbo.MDDrugs md
								WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
									AND isnull(md.RecordDeleted, 'N') = 'N'
									AND md.DEACode = 0
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE cms.OrderingPrescriberId = SE.StaffId
									AND SE.MeasureType = 8683
									AND CAST(cms.OrderDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(cms.OrderDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8683
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #EPrescriping (
							ClientOrderId
							,ClientId
							,ClientName
							,ProviderName
							,ProcedureCodeName
							,DateOfService
							,PrescribedDate
							,MedicationName
							,ETransmitted
							)
						SELECT DISTINCT CO.ClientOrderId
							,C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName)
							,@ProviderName
							,NULL
							,NULL
							,CO.OrderStartDateTime
							,MDM.MedicationName
							,'No'
						FROM dbo.ClientOrders AS CO
						INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
							AND ISNULL(O.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId
							AND isnull(c.RecordDeleted, 'N') = 'N'
						INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
							AND ISNULL(OS.RecordDeleted, 'N') = 'N'
						INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId
							AND ISNULL(MM.RecordDeleted, 'N') = 'N'
						INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId
						WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(CO.RecordDeleted, 'N') = 'N'
							AND CO.OrderingPhysician = @StaffId
							AND EXISTS (
								SELECT 1
								FROM dbo.MDDrugs md
								WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
									AND isnull(md.RecordDeleted, 'N') = 'N'
									AND md.DEACode = 0
								)
							AND O.OrderType = 8501 -- Medication Order                 
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CO.OrderingPhysician = SE.StaffId
									AND SE.MeasureType = 8683
									AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates
									AND OE.MeasureType = 8683
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
							)
						SELECT ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
						FROM #EPrescriping
					END

					IF (
							@Option = 'A'
							OR @Option = 'N'
							)
					BEGIN
						INSERT INTO #EPrescriping (
							ClientMedicationScriptId
							,ClientId
							,ClientName
							,ProviderName
							,ProcedureCodeName
							,DateOfService
							,PrescribedDate
							,MedicationName
							,ETransmitted
							)
						SELECT cmsd.ClientMedicationScriptId
							,C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName)
							,@ProviderName
							,NULL
							,NULL
							,cms.OrderDate
							,MD.MedicationName
							,CASE 
								WHEN cmsa.Method = 'E'
									THEN 'Yes'
								ELSE 'No'
								END
						FROM dbo.ClientMedicationScriptActivities AS cmsa
						INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
							AND isnull(cmsd.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
							AND isnull(cmi.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
							AND isnull(cms.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId
							AND isnull(c.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
							AND isnull(mm.RecordDeleted, 'N') = 'N'
						INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId
						WHERE cmsa.Method = 'E'
							AND cms.OrderDate >= CAST(@StartDate AS DATE)
							AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(cmsa.RecordDeleted, 'N') = 'N'
							AND cms.OrderingPrescriberId = @StaffId
							AND EXISTS (
								SELECT 1
								FROM dbo.MDDrugs md
								WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
									AND isnull(md.RecordDeleted, 'N') = 'N'
									AND md.DEACode = 0
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE cms.OrderingPrescriberId = SE.StaffId
									AND SE.MeasureType = 8683
									AND CAST(cms.OrderDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(cms.OrderDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8683
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
							)
						SELECT ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
						FROM #EPrescriping E
						WHERE ISNULL(E.MedicationName, '') <> ''
							AND (
								NOT EXISTS (
									SELECT 1
									FROM #EPrescriping M1
									WHERE E.PrescribedDate < M1.PrescribedDate
										AND M1.ClientId = E.ClientId
									)
								)
					END
				END

				IF @MeasureSubType = 3
					AND (
						@MeaningfulUseStageLevel = 8767
						-- 11-Jan-2016  Gautam 
						OR @MeaningfulUseStageLevel = 9373
						) --  Stage2  or  'Stage2 - Modified'
				BEGIN
					IF @Option = 'D'
					BEGIN
						INSERT INTO #EPrescriping (
							ClientMedicationScriptId
							,ClientId
							,ClientName
							,ProviderName
							,ProcedureCodeName
							,DateOfService
							,PrescribedDate
							,MedicationName
							,ETransmitted
							)
						SELECT cmsd.ClientMedicationScriptId
							,C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName)
							,@ProviderName
							,NULL
							,NULL
							,cms.OrderDate
							,MD.MedicationName
							,CASE 
								WHEN cmsa.Method = 'E'
									THEN 'Yes'
								ELSE 'No'
								END
						FROM dbo.ClientMedicationScriptActivities AS cmsa
						INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
							AND isnull(cmsd.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
							AND isnull(cmi.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
							AND isnull(cms.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId
							AND isnull(c.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
							AND isnull(mm.RecordDeleted, 'N') = 'N'
						INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId
						WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
							AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(cmsa.RecordDeleted, 'N') = 'N'
							AND cms.OrderingPrescriberId = @StaffId
							AND EXISTS (
								SELECT 1
								FROM dbo.MDDrugs md
								WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
									AND isnull(md.RecordDeleted, 'N') = 'N'
									AND md.DEACode = 0
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE cms.OrderingPrescriberId = SE.StaffId
									AND SE.MeasureType = 8683
									AND CAST(cms.OrderDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(cms.OrderDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8683
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #EPrescriping (
							ClientOrderId
							,ClientId
							,ClientName
							,ProviderName
							,ProcedureCodeName
							,DateOfService
							,PrescribedDate
							,MedicationName
							,ETransmitted
							)
						SELECT DISTINCT CO.ClientOrderId
							,C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName)
							,@ProviderName
							,NULL
							,NULL
							,CO.OrderStartDateTime
							,MDM.MedicationName
							,'No'
						FROM dbo.ClientOrders AS CO
						INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
							AND ISNULL(O.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Clients c ON CO.ClientId = c.ClientId
							AND isnull(c.RecordDeleted, 'N') = 'N'
						INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
							AND ISNULL(OS.RecordDeleted, 'N') = 'N'
						INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId
							AND ISNULL(MM.RecordDeleted, 'N') = 'N'
						INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId
						WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(CO.RecordDeleted, 'N') = 'N'
							AND CO.OrderingPhysician = @StaffId
							AND EXISTS (
								SELECT 1
								FROM dbo.MDDrugs md
								WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
									AND isnull(md.RecordDeleted, 'N') = 'N'
									AND md.DEACode = 0
								)
							AND O.OrderType = 8501 -- Medication Order                 
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CO.OrderingPhysician = SE.StaffId
									AND SE.MeasureType = 8683
									AND cast(CO.OrderStartDateTime AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE cast(CO.OrderStartDateTime AS DATE) = OE.Dates
									AND OE.MeasureType = 8683
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
							)
						SELECT ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
						FROM #EPrescriping
					END

					IF (
							@Option = 'A'
							OR @Option = 'N'
							)
					BEGIN
						INSERT INTO #EPrescriping (
							ClientMedicationScriptId
							,ClientId
							,ClientName
							,ProviderName
							,ProcedureCodeName
							,DateOfService
							,PrescribedDate
							,MedicationName
							,ETransmitted
							)
						SELECT cmsd.ClientMedicationScriptId
							,C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName)
							,@ProviderName
							,NULL
							,NULL
							,cms.OrderDate
							,MD.MedicationName
							,CASE 
								WHEN cmsa.Method = 'E'
									THEN 'Yes'
								ELSE 'No'
								END
						FROM dbo.ClientMedicationScriptActivities AS cmsa
						INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
							AND isnull(cmsd.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
							AND isnull(cmi.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
							AND isnull(cms.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Clients c ON cms.ClientId = c.ClientId
							AND isnull(c.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
							AND isnull(mm.RecordDeleted, 'N') = 'N'
						INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId
						WHERE cmsa.Method = 'E'
							AND cms.OrderDate >= CAST(@StartDate AS DATE)
							AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(cmsa.RecordDeleted, 'N') = 'N'
							AND cms.OrderingPrescriberId = @StaffId
							AND EXISTS (
								SELECT 1
								FROM dbo.MDDrugs md
								WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
									AND isnull(md.RecordDeleted, 'N') = 'N'
									AND md.DEACode = 0
								)
							AND EXISTS (
								SELECT 1
								FROM SureScriptsEligibilityResponse SSER
								WHERE SSER.ClientId = CMS.ClientId
									--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())
									AND (	
										SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
										AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
										) 
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE cms.OrderingPrescriberId = SE.StaffId
									AND SE.MeasureType = 8683
									AND CAST(cms.OrderDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(cms.OrderDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8683
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)

						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
							)
						SELECT ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
							,ETransmitted
						FROM #EPrescriping E
						WHERE ISNULL(E.MedicationName, '') <> ''
							--AND (
							--	NOT EXISTS (
							--		SELECT 1
							--		FROM #EPrescriping M1
							--		WHERE E.PrescribedDate < M1.PrescribedDate
							--			AND M1.ClientId = E.ClientId
							--		)
							--	)
					END
				END

				IF @MeasureSubType = 4
					AND (
						@MeaningfulUseStageLevel = 8767
						-- 11-Jan-2016  Gautam 
						OR @MeaningfulUseStageLevel = 9373
						) --  Stage2  or  'Stage2 - Modified'
				BEGIN
					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,ETransmitted
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,cms.OrderDate AS PrescribedDate
						,MD.MedicationName
						,@ProviderName AS ProviderName
						,'' AS DateOfService
						,cmsd.ClientMedicationScriptId AS ProcedureCodeName
						,CASE 
							WHEN cmsa.Method = 'E'
								THEN 'Yes'
							ELSE 'No'
							END
					FROM dbo.ClientMedicationScriptActivities AS cmsa
					INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
						AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
					--INNER JOIN ClientMedicationScriptDrugStrengths CMSDS ON cmsd.ClientMedicationScriptId = CMSDS.ClientMedicationScriptId                    
					-- AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                    
					--AND CMSDS.CreatedDate >= CAST(@StartDate AS DATE)                                  
					--AND cast(CMSDS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
					INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
						AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
						AND ISNULL(cms.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
						AND ISNULL(mm.RecordDeleted, 'N') = 'N' --INNER JOIN dbo.MDDrugs AS mds ON mds.ClinicalFormulationId = mm.ClinicalFormulationId                    
						-- AND ISNULL(mds.RecordDeleted, 'N') = 'N'                    
						--INNER JOIN ClientMedications CM ON CM.ClientMedicationId = cmi.ClientMedicationId                    
						-- AND ISNULL(CM.RecordDeleted, 'N') = 'N'                    
					INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId
					INNER JOIN Clients C ON C.ClientId = cms.ClientId
					WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
						AND cms.OrderingPrescriberId = @StaffId
						AND ISNULL(CMSA.RecordDeleted, 'N') = 'N'
						AND CAST(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE cms.OrderingPrescriberId = SE.StaffId
								AND SE.MeasureType = 8683
								AND CAST(cms.OrderDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(cms.OrderDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8683
								AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND EXISTS (
							SELECT 1
							FROM dbo.MDDrugs AS mds
							WHERE mds.ClinicalFormulationId = mm.ClinicalFormulationId
								AND ISNULL(mds.RecordDeleted, 'N') = 'N'
								AND mds.DEACode = 0
							)
						AND @Option = 'D'

					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,ETransmitted
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,CO.OrderStartDateTime AS PrescribedDate
						,MDM.MedicationName
						,@ProviderName AS ProviderName
						,'' AS DateOfService
						,'' AS ProcedureCodeName
						,'Yes'
					FROM dbo.ClientOrders AS CO
					INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
						AND ISNULL(O.RecordDeleted, 'N') = 'N'
					INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
						AND ISNULL(OS.RecordDeleted, 'N') = 'N'
					INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId
						AND ISNULL(MM.RecordDeleted, 'N') = 'N'
					--INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                    
					-- AND ISNULL(md.RecordDeleted, 'N') = 'N'                    
					INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId
					INNER JOIN Clients C ON C.ClientId = CO.ClientId
					WHERE CAST(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
						AND CAST(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
						AND ISNULL(CO.RecordDeleted, 'N') = 'N'
						AND CO.OrderingPhysician = @StaffId
						AND O.OrderType = 8501 -- Medication Order                                   
						AND EXISTS (
							SELECT 1
							FROM dbo.MDDrugs AS md
							WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
								AND isnull(md.RecordDeleted, 'N') = 'N'
								AND md.DEACode = 0
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE CO.OrderingPhysician = SE.StaffId
								AND SE.MeasureType = 8683
								AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates
								AND OE.MeasureType = 8683
								AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
							)
						--AND md.DEACode = 0                    
						AND (@Option = 'D')

					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,ETransmitted
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,CO.OrderStartDateTime AS PrescribedDate
						,MDM.MedicationName
						,@ProviderName AS ProviderName
						,'' AS DateOfService
						,'' AS ProcedureCodeName
						,'Yes'
					FROM dbo.ClientOrders AS CO
					INNER JOIN Orders AS O ON CO.OrderId = O.OrderId
						AND ISNULL(O.RecordDeleted, 'N') = 'N'
					INNER JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
						AND ISNULL(OS.RecordDeleted, 'N') = 'N'
					INNER JOIN MdMedications MM ON MM.medicationId = OS.medicationId
						AND ISNULL(MM.RecordDeleted, 'N') = 'N'
					--INNER JOIN dbo.MDDrugs AS md ON md.ClinicalFormulationId = mm.ClinicalFormulationId                    
					-- AND ISNULL(md.RecordDeleted, 'N') = 'N'                    
					INNER JOIN MDMedicationNames MDM ON MM.MedicationNameId = MDM.MedicationNameId
					INNER JOIN Clients C ON C.ClientId = CO.ClientId
					WHERE CAST(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
						AND CAST(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
						AND ISNULL(CO.RecordDeleted, 'N') = 'N'
						AND CO.OrderingPhysician = @StaffId
						AND O.OrderType = 8501 -- Medication Order                                 
						AND EXISTS (
							SELECT 1
							FROM SureScriptsEligibilityResponse SSER
							WHERE SSER.ClientId = CO.ClientId
								--AND SSER.ResponseDate > DATEADD(dd, - 3, GETDATE())
								AND (	
									SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
									AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
									) 
							)
						AND EXISTS (
							SELECT 1
							FROM dbo.MDDrugs AS md
							WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
								AND isnull(md.RecordDeleted, 'N') = 'N'
								AND md.DEACode = 0
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE CO.OrderingPhysician = SE.StaffId
								AND SE.MeasureType = 8683
								AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates
								AND OE.MeasureType = 8683
								AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
							)
						--AND md.DEACode = 0                    
						AND (
							@Option = 'N'
							OR @Option = 'A'
							)

					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,PrescribedDate
						,MedicationName
						,ProviderName
						,DateOfService
						,ProcedureCodeName
						,ETransmitted
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,cms.OrderDate AS PrescribedDate
						,MD.MedicationName
						,@ProviderName AS ProviderName
						,'' AS DateOfService
						,cmsd.ClientMedicationScriptId AS ProcedureCodeName
						,CASE 
							WHEN cmsa.Method = 'E'
								THEN 'Yes'
							ELSE 'No'
							END
					FROM dbo.ClientMedicationScriptActivities AS cmsa
					INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
						AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
					--INNER JOIN ClientMedicationScriptDrugStrengths CMSDS ON cmsd.ClientMedicationScriptId = CMSDS.ClientMedicationScriptId                    
					-- AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'                    
					--AND CMSDS.CreatedDate >= CAST(@StartDate AS DATE)                                  
					--AND cast(CMSDS.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                  
					INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
						AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
						AND ISNULL(cms.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
						AND ISNULL(mm.RecordDeleted, 'N') = 'N'
					--INNER JOIN dbo.MDDrugs AS mds ON mds.ClinicalFormulationId = mm.ClinicalFormulationId                    
					-- AND ISNULL(mds.RecordDeleted, 'N') = 'N'                    
					--INNER JOIN ClientMedications CM ON CM.ClientMedicationId = cmi.ClientMedicationId                    
					-- AND ISNULL(CM.RecordDeleted, 'N') = 'N'                    
					INNER JOIN MDMedicationNames MD ON MM.MedicationNameId = MD.MedicationNameId
					INNER JOIN Clients C ON C.ClientId = cms.ClientId
					WHERE cmsa.Method IN ('E')
						AND cms.OrderDate >= CAST(@StartDate AS DATE)
						AND cms.OrderingPrescriberId = @StaffId
						AND EXISTS (
							SELECT 1
							FROM SureScriptsEligibilityResponse SSER
							WHERE SSER.ClientId = CMS.ClientId
							--	AND SSER.ResponseDate > DATEADD(dd, - 3, GETDATE())
								AND (	
									SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
									AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
									) 
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE cms.OrderingPrescriberId = SE.StaffId
								AND SE.MeasureType = 8683
								AND CAST(cms.OrderDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(cms.OrderDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8683
								AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND CAST(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
						AND ISNULL(cmsa.RecordDeleted, 'N') = 'N'
						AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
						AND ISNULL(cmi.RecordDeleted, 'N') = 'N'
						AND EXISTS (
							SELECT 1
							FROM dbo.MDDrugs AS mds
							WHERE mds.ClinicalFormulationId = mm.ClinicalFormulationId
								AND ISNULL(mds.RecordDeleted, 'N') = 'N'
								AND mds.DEACode = 0
							)
						AND (
							@Option = 'N'
							OR @Option = 'A'
							)
				END
						/*  8683--(e-Prescribing)*/
			END
			ELSE
				IF @MeasureType = 8684 --Medication
				BEGIN
					CREATE TABLE #MEDRESULT (
						ClientId INT
						,ClientName VARCHAR(250)
						,PrescribedDate DATETIME
						,MedicationName VARCHAR(MAX)
						,ProviderName VARCHAR(250)
						,DateOfService DATETIME
						,ProcedureCodeName VARCHAR(250)
						,ETransmitted VARCHAR(20)
						,NextDateOfService DATETIME
						)

					CREATE TABLE #MEDRESULT1 (
						ClientId INT
						,PrescribedDate DATETIME
						,MedicationName VARCHAR(MAX)
						);

					WITH TempMedicationList
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
									AND PE.MeasureType = 8684
									AND CAST(S.DateOfService AS DATE) = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8684
									AND CAST(S.DateOfService AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(S.DateOfService AS DATE) = OE.Dates
									AND OE.MeasureType = 8684
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfService >= CAST(@StartDate AS DATE)
							AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
						)
					INSERT INTO #MEDRESULT (
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
					FROM TempMedicationList T
					LEFT JOIN TempMedicationList NT ON NT.ClientId = T.ClientId
						AND NT.row = T.row + 1

					INSERT INTO #MEDRESULT1 (
						ClientId
						,PrescribedDate
						,MedicationName
						)
					SELECT DISTINCT C.ClientId
						,@EndDate
						,'No Active Medications' AS MedicationName
					FROM Clients C
					INNER JOIN #MEDRESULT M ON M.ClientId = C.ClientId
					WHERE ISNULL(C.HasNoMedications, 'N') = 'Y'
						AND ISNULL(C.RecordDeleted, 'N') = 'N'

					INSERT INTO #MEDRESULT1 (
						ClientId
						,PrescribedDate
						,MedicationName
						)
					SELECT DISTINCT C.ClientId
						,CASE CM.Ordered
							WHEN 'Y'
								THEN CM.MedicationStartDate
							ELSE CM.CreatedDate
							END AS PrescribedDate
						,MD.MedicationName
					FROM #MEDRESULT C
					INNER JOIN ClientMedications CM ON CM.ClientId = C.ClientId
					INNER JOIN MDMedicationNames MD ON CM.MedicationNameId = MD.MedicationNameId
						AND ISNULL(CM.MedicationStartDate, CM.CreatedDate) <= CAST(@EndDate AS DATE)
					WHERE NOT EXISTS (
							SELECT 1
							FROM #MEDRESULT1 M
							WHERE C.ClientId = M.ClientId
							)
						AND ISNULL(CM.RecordDeleted, 'N') = 'N'
						AND ISNULL(MD.RecordDeleted, 'N') = 'N'

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
						SELECT DISTINCT M.ClientId
							,M.ClientName
							,M1.PrescribedDate
							,M1.MedicationName
							,M.ProviderName
							,M.DateOfService
							,M.ProcedureCodeName
						FROM #MEDRESULT M
						LEFT JOIN #MEDRESULT1 M1 ON M.ClientId = M1.ClientId
							AND cast(M1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)
							AND (
								(
									cast(M1.PrescribedDate AS DATE) >= cast(M.DateOfService AS DATE)
									AND (
										M.NextDateOfService IS NULL
										OR cast(M1.PrescribedDate AS DATE) < cast(M.NextDateOfService AS DATE)
										)
									)
								OR (
									cast(M1.PrescribedDate AS DATE) < cast(M.DateOfService AS DATE)
									AND NOT EXISTS (
										SELECT 1
										FROM #MEDRESULT1 MM1
										WHERE MM1.ClientId = M1.ClientId
											AND cast(M1.PrescribedDate AS DATE) < cast(MM1.PrescribedDate AS DATE)
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #MEDRESULT Med1
										WHERE Med1.ClientId = M.ClientId
											AND cast(M.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)
										)
									)
								)
					END

					IF (
							@Option = 'N'
							OR @Option = 'A'
							)
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
						SELECT DISTINCT ClientId
							,ClientName
							,PrescribedDate
							,MedicationName
							,ProviderName
							,DateOfService
							,ProcedureCodeName
						FROM (
							SELECT DISTINCT M.ClientId
								,M.ClientName
								,M1.MedicationName
								,M.DateOfService
								,M1.PrescribedDate
								,M.ProviderName
								,M.ProcedureCodeName
							FROM #MEDRESULT M
							LEFT JOIN #MEDRESULT1 M1 ON M.ClientId = M1.ClientId
								AND cast(M1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)
								AND (
									(
										cast(M1.PrescribedDate AS DATE) >= cast(M.DateOfService AS DATE)
										AND (
											M.NextDateOfService IS NULL
											OR cast(M1.PrescribedDate AS DATE) < cast(M.NextDateOfService AS DATE)
											)
										)
									OR (
										cast(M1.PrescribedDate AS DATE) < cast(M.DateOfService AS DATE)
										AND NOT EXISTS (
											SELECT 1
											FROM #MEDRESULT1 MM1
											WHERE MM1.ClientId = M1.ClientId
												AND cast(M1.PrescribedDate AS DATE) < cast(MM1.PrescribedDate AS DATE)
											)
										AND NOT EXISTS (
											SELECT 1
											FROM #MEDRESULT Med1
											WHERE Med1.ClientId = M.ClientId
												AND cast(M.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)
											)
										)
									)
							) AS Result
						WHERE ISNULL(Result.MedicationName, '') <> ''
							AND (
								NOT EXISTS (
									SELECT 1
									FROM #MEDRESULT M1
									WHERE Result.DateOfService < M1.DateOfService
										AND M1.ClientId = Result.ClientId
									)
								)
					END
							/*  8684--(MedicationList)*/
				END
				ELSE
					IF @MeasureType = 8685 --Allergylist
					BEGIN
						CREATE TABLE #Allergy (
							ClientId INT
							,ClientName VARCHAR(250)
							,PrescribedDate VARCHAR(max)
							,MedicationName VARCHAR(max)
							,ProviderName VARCHAR(250)
							,CreatedDate DATETIME
							,DateOfService DATETIME
							,ProcedureCodeName VARCHAR(max)
							,NextDateOfService DATETIME
							)

						CREATE TABLE #Allergy1 (
							ClientId INT
							,PrescribedDate VARCHAR(max)
							,MedicationName VARCHAR(max)
							);

						WITH TempAllergyList
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
										AND PE.MeasureType = 8685
										AND CAST(S.DateOfService AS DATE) = PE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE S.ClinicianId = SE.StaffId
										AND SE.MeasureType = 8685
										AND CAST(S.DateOfService AS DATE) = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CAST(S.DateOfService AS DATE) = OE.Dates
										AND OE.MeasureType = 8685
										AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
									)
								AND S.DateOfService >= CAST(@StartDate AS DATE)
								AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
							)
						INSERT INTO #Allergy (
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
						FROM TempAllergyList T
						LEFT JOIN TempAllergyList NT ON NT.ClientId = T.ClientId
							AND NT.row = T.row + 1

						INSERT INTO #Allergy1 (
							ClientId
							,PrescribedDate
							,MedicationName
							)
						SELECT DISTINCT C.ClientId
							,@EndDate
							,'Not Known' AS MedicationName
						FROM Clients C
						INNER JOIN #Allergy A ON A.ClientId = C.ClientId
						WHERE ISNULL(C.NoKnownAllergies, 'N') = 'Y'
							AND ISNULL(C.RecordDeleted, 'N') = 'N'

						INSERT INTO #Allergy1 (
							ClientId
							,PrescribedDate
							,MedicationName
							)
						SELECT DISTINCT C.ClientId
							,CA.CreatedDate
							,MDA.ConceptDescription
						FROM #Allergy C
						INNER JOIN ClientAllergies CA ON CA.ClientId = C.ClientId
						INNER JOIN MDAllergenConcepts MDA ON CA.AllergenConceptId = MDA.AllergenConceptId
						WHERE NOT EXISTS (
								SELECT 1
								FROM #Allergy1 M
								WHERE C.ClientId = M.ClientId
								)
							AND ISNULL(CA.Active, 'Y') = 'Y'
							AND ISNULL(CA.RecordDeleted, 'N') = 'N'
							AND ISNULL(MDA.RecordDeleted, 'N') = 'N'

						IF @Option = 'D'
						BEGIN
							/*  8685--(AllergyList)*/
							INSERT INTO #RESULT (
								ClientId
								,ClientName
								,PrescribedDate
								,MedicationName
								,ProviderName
								,DateOfService
								,ProcedureCodeName
								)
							SELECT A.ClientId
								,A.ClientName
								,A1.PrescribedDate
								,A1.MedicationName
								,A.ProviderName
								,A.DateOfService
								,A.ProcedureCodeName
							FROM #Allergy A
							LEFT JOIN #Allergy1 A1 ON A.ClientId = A1.ClientId
								AND cast(A1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)
								AND (
									(
										cast(A1.PrescribedDate AS DATE) >= cast(A.DateOfService AS DATE)
										AND (
											A.NextDateOfService IS NULL
											OR cast(A1.PrescribedDate AS DATE) < cast(A.NextDateOfService AS DATE)
											)
										)
									OR (
										cast(A1.PrescribedDate AS DATE) < cast(A.DateOfService AS DATE)
										AND NOT EXISTS (
											SELECT 1
											FROM #Allergy1 MM1
											WHERE MM1.ClientId = A1.ClientId
												AND cast(A1.PrescribedDate AS DATE) < cast(MM1.PrescribedDate AS DATE)
											)
										AND NOT EXISTS (
											SELECT 1
											FROM #Allergy Med1
											WHERE Med1.ClientId = A.ClientId
												AND cast(A.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)
											)
										)
									)
						END

						IF (
								@Option = 'N'
								OR @Option = 'A'
								)
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
							SELECT DISTINCT ClientId
								,ClientName
								,PrescribedDate
								,MedicationName
								,ProviderName
								,DateOfService
								,ProcedureCodeName
							FROM (
								SELECT A.ClientId
									,A.ClientName
									,A1.PrescribedDate
									,A1.MedicationName
									,A.ProviderName
									,A.DateOfService
									,A.ProcedureCodeName
								FROM #Allergy A
								LEFT JOIN #Allergy1 A1 ON A.ClientId = A1.ClientId
									AND cast(A1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)
									AND (
										(
											cast(A1.PrescribedDate AS DATE) >= cast(A.DateOfService AS DATE)
											AND (
												A.NextDateOfService IS NULL
												OR cast(A1.PrescribedDate AS DATE) < cast(A.NextDateOfService AS DATE)
												)
											)
										OR (
											cast(A1.PrescribedDate AS DATE) < cast(A.DateOfService AS DATE)
											AND NOT EXISTS (
												SELECT 1
												FROM #Allergy1 MM1
												WHERE MM1.ClientId = A1.ClientId
													AND cast(A1.PrescribedDate AS DATE) < cast(MM1.PrescribedDate AS DATE)
												)
											AND NOT EXISTS (
												SELECT 1
												FROM #Allergy Med1
												WHERE Med1.ClientId = A.ClientId
													AND cast(A.DateOfService AS DATE) < cast(Med1.DateOfService AS DATE)
												)
											)
										)
								) AS Result
							WHERE ISNULL(Result.MedicationName, '') <> ''
								AND (
									NOT EXISTS (
										SELECT 1
										FROM #Allergy M1
										WHERE Result.DateOfService < M1.DateOfService
											AND M1.ClientId = Result.ClientId
										)
									)
						END
								/*  8685--(AllergyList)*/
					END
					ELSE
						IF @MeasureType = 8682
						BEGIN
							CREATE TABLE #ProblemList (
								ClientId INT
								,ClientName VARCHAR(250)
								,PrescribedDate VARCHAR(max)
								,MedicationName VARCHAR(max)
								,ProviderName VARCHAR(250)
								,DateOfService DATETIME
								,ProcedureCodeName VARCHAR(max)
								,NextDateOfService DATETIME
								);

							WITH TempProblemList
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
											AND PE.MeasureType = 8682
											AND CAST(S.DateOfService AS DATE) = PE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #StaffExclusionDates SE
										WHERE S.ClinicianId = SE.StaffId
											AND SE.MeasureType = 8682
											AND CAST(S.DateOfService AS DATE) = SE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #OrgExclusionDates OE
										WHERE CAST(S.DateOfService AS DATE) = OE.Dates
											AND OE.MeasureType = 8682
											AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
										)
									AND S.DateOfService >= CAST(@StartDate AS DATE)
									AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
								)
							INSERT INTO #ProblemList (
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
							FROM TempProblemList T
							LEFT JOIN TempProblemList NT ON NT.ClientId = T.ClientId
								AND NT.row = T.row + 1

							CREATE TABLE #Diagnosis (
								ClientId INT
								,Diagnosis VARCHAR(MAX)
								,EffectiveDate DATETIME
								)

							INSERT INTO #Diagnosis
							SELECT DISTINCT ClientId
								,Diagnosis
								,EffectiveDate
							FROM (
								SELECT DISTINCT C.ClientId AS ClientId
									,DD.DSMCode + ' ' + DD.DSMDescription AS Diagnosis
									,D.EffectiveDate AS EffectiveDate
								FROM Clients C
								INNER JOIN Services S ON C.ClientId = S.ClientId
								INNER JOIN documents d ON d.ClientId = s.ClientId
									AND D.DocumentCodeId IN (
										5
										,1601
										)
								INNER JOIN DiagnosesIAndII DI ON DI.DocumentVersionId = d.InProgressDocumentVersionId
									AND ISNULL(DI.RecordDeleted, 'N') = 'N'
								INNER JOIN DiagnosisDSMDescriptions DD ON dd.DSMCode = DI.DSMCode
									AND dd.DSMNumber = di.DSMNumber
								WHERE S.STATUS IN (
										71
										,75
										) -- 71 (Show), 75(complete)                                    
									AND D.STATUS = 22
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND ISNULL(D.RecordDeleted, 'N') = 'N'
									AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)
									AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
									AND S.ClinicianId = @StaffId
									AND @ProblemList = 'Behaviour'
								
								UNION
								
								SELECT DISTINCT C.ClientId AS ClientId
									,DIIICod.ICDCode + ' ' + DICD.ICDDescription AS Diagnosis
									,D.EffectiveDate AS EffectiveDate
								FROM Clients C
								INNER JOIN Services S ON C.ClientId = S.ClientId
								INNER JOIN documents d ON d.ClientId = s.ClientId
									AND D.DocumentCodeId IN (
										5
										,1601
										)
								INNER JOIN DiagnosesIIICodes AS DIIICod ON DIIICod.DocumentVersionId = d.InProgressDocumentVersionId
									AND (ISNULL(DIIICod.RecordDeleted, 'N') = 'N')
								INNER JOIN DiagnosisICDCodes AS DICD ON DIIICod.ICDCode = DICD.ICDCode
								WHERE S.STATUS IN (
										71
										,75
										) -- 71 (Show), 75(complete)                                    
									AND D.STATUS = 22
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND ISNULL(D.RecordDeleted, 'N') = 'N'
									AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)
									AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
									AND S.ClinicianId = @StaffId
									AND @ProblemList = 'Behaviour'
								
								UNION
								
								SELECT DISTINCT C.ClientId AS ClientId
									,ISNULL(DDM.ICD10Code + ' ' + DDM.ICDDescription, 'Not Known') AS Diagnosis
									,D.EffectiveDate AS EffectiveDate
								FROM Clients C
								INNER JOIN Services S ON C.ClientId = S.ClientId
								INNER JOIN documents d ON d.ClientId = s.ClientId
									AND D.DocumentCodeId IN (
										5
										,1601
										)
								LEFT JOIN DocumentDiagnosisCodes AS DDC ON DDC.DocumentVersionId = d.InProgressDocumentVersionId
									AND (ISNULL(DDC.RecordDeleted, 'N') = 'N')
								LEFT JOIN dbo.DiagnosisICD10Codes AS DDM ON DDM.ICD10Code = DDC.ICD10Code
								WHERE S.STATUS IN (
										71
										,75
										) -- 71 (Show), 75(complete)                                   
									AND D.STATUS = 22
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND ISNULL(D.RecordDeleted, 'N') = 'N'
									AND CAST(S.DateOfService AS DATE) >= CAST(@StartDate AS DATE)
									AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
									AND S.ClinicianId = @StaffId
									AND @ProblemList = 'Behaviour'
								) AS t
							WHERE EXISTS (
									SELECT 1
									FROM Documents D1
									WHERE D1.ClientId = t.ClientId
										AND D1.DocumentCodeId IN (
											5
											,1601
											)
										AND D1.STATUS = 22
										AND ISNULL(D1.RecordDeleted, 'N') = 'N'
									)

							IF @Option = 'D'
							BEGIN
								/*  8682 (Problem list) */
								INSERT INTO #RESULT (
									ClientId
									,ClientName
									,PrescribedDate
									,MedicationName
									,ProviderName
									,DateOfService
									,ProcedureCodeName
									)
								SELECT DISTINCT P.ClientId
									,P.ClientName
									,P.PrescribedDate
									,STUFF((
											SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Diagnosis, '')))
											FROM #Diagnosis DI1
											WHERE D.ClientId = DI1.ClientId
												AND cast(D.EffectiveDate AS DATE) = cast(DI1.EffectiveDate AS DATE)
											FOR XML PATH('')
												,TYPE
											).value('.', 'nvarchar(max)'), 1, 2, '') AS diagnosis
									,P.ProviderName
									,P.DateOfService
									,P.ProcedureCodeName
								FROM #ProblemList P
								LEFT JOIN #Diagnosis D ON D.ClientId = P.ClientId
									AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
									AND (
										(
											cast(D.EffectiveDate AS DATE) >= cast(P.DateOfService AS DATE)
											AND (
												P.NextDateOfService IS NULL
												OR cast(D.EffectiveDate AS DATE) < cast(P.NextDateOfService AS DATE)
												)
											)
										OR (
											cast(D.EffectiveDate AS DATE) < cast(P.DateOfService AS DATE)
											AND NOT EXISTS (
												SELECT 1
												FROM #Diagnosis D1
												WHERE D1.ClientId = D.ClientId
													AND cast(D.EffectiveDate AS DATE) < cast(D1.EffectiveDate AS DATE)
												)
											AND NOT EXISTS (
												SELECT 1
												FROM #ProblemList P1
												WHERE P1.ClientId = P.ClientId
													AND cast(P.DateOfService AS DATE) < cast(P1.DateOfService AS DATE)
												)
											)
										)
							END

							IF (
									@Option = 'N'
									OR @Option = 'A'
									)
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
								SELECT DISTINCT ClientId
									,ClientName
									,PrescribedDate
									,MedicationName
									,ProviderName
									,DateOfService
									,ProcedureCodeName
								FROM (
									SELECT DISTINCT P.ClientId
										,P.ClientName
										,P.PrescribedDate
										,STUFF((
												SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Diagnosis, '')))
												FROM #Diagnosis DI1
												WHERE D.ClientId = DI1.ClientId
													AND cast(D.EffectiveDate AS DATE) = cast(DI1.EffectiveDate AS DATE)
												FOR XML PATH('')
													,TYPE
												).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName
										,P.ProviderName
										,P.DateOfService
										,P.ProcedureCodeName
									FROM #ProblemList P
									LEFT JOIN #Diagnosis D ON D.ClientId = P.ClientId
										AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
										AND (
											(
												cast(D.EffectiveDate AS DATE) >= cast(P.DateOfService AS DATE)
												AND (
													P.NextDateOfService IS NULL
													OR cast(D.EffectiveDate AS DATE) < cast(P.NextDateOfService AS DATE)
													)
												)
											OR (
												cast(D.EffectiveDate AS DATE) < cast(P.DateOfService AS DATE)
												AND NOT EXISTS (
													SELECT 1
													FROM #Diagnosis D1
													WHERE D1.ClientId = D.ClientId
														AND cast(D.EffectiveDate AS DATE) < cast(D1.EffectiveDate AS DATE)
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #ProblemList P1
													WHERE P1.ClientId = P.ClientId
														AND cast(P.DateOfService AS DATE) < cast(P1.DateOfService AS DATE)
													)
												)
											)
									) AS Result
								WHERE ISNULL(MedicationName, '') <> ''
									AND (
										NOT EXISTS (
											SELECT 1
											FROM #ProblemList P1
											WHERE Result.DateOfService < P1.DateOfService
												AND P1.ClientId = Result.ClientId
											)
										)
									--AND (
									--NOT EXISTS (
									--	SELECT 1
									--	FROM #Diagnosis P1
									--	WHERE Result.PrescribedDate < P1.EffectiveDate
									--		AND P1.ClientId = Result.ClientId
									--	)
									--)
							END

							/*  8682 (Problem list) */
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
								,Diagnosis
								,ProviderName
								,DateOfService
								,ProcedureCodeName
							FROM (
								SELECT DISTINCT C.ClientId
									,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
									,'' AS PrescribedDate
									,DIC.ICDCode + ' ' + DIC.ICDDescription AS Diagnosis
									,@ProviderName AS ProviderName
									,S.DateOfService
									,P.ProcedureCodeName
								FROM Clients C
								INNER JOIN Services S ON C.ClientId = S.ClientId
								INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId
								INNER JOIN documents d ON d.ClientId = s.ClientId
									AND D.DocumentCodeId = 300
									AND d.ServiceId = S.ServiceId
								LEFT JOIN ClientProblems cp ON cp.ClientId = c.ClientId
									AND cp.StartDate >= CAST(@StartDate AS DATE)
									AND CAST(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)
								LEFT JOIN DiagnosisICDCodes DIC ON cp.DSMCode = DIC.ICDCode
								WHERE S.STATUS IN (
										71
										,75
										) -- 71 (Show), 75(complete)                                  
									AND d.STATUS = 22
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND ISNULL(D.RecordDeleted, 'N') = 'N'
									AND S.ClinicianId = @StaffId
									AND NOT EXISTS (
										SELECT 1
										FROM #ProcedureExclusionDates PE
										WHERE S.ProcedureCodeId = PE.ProcedureId
											AND PE.MeasureType = 8682
											AND CAST(S.DateOfService AS DATE) = PE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #StaffExclusionDates SE
										WHERE S.ClinicianId = SE.StaffId
											AND SE.MeasureType = 8682
											AND CAST(S.DateOfService AS DATE) = SE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #OrgExclusionDates OE
										WHERE CAST(S.DateOfService AS DATE) = OE.Dates
											AND OE.MeasureType = 8682
											AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
										)
									AND S.DateOfService >= CAST(@StartDate AS DATE)
									AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
									AND @Option = 'D'
									AND @ProblemList = 'Primary'
								) AS t

							INSERT INTO #RESULT (
								ClientId
								,ClientName
								,PrescribedDate
								,MedicationName
								,ProviderName
								,DateOfService
								,ProcedureCodeName
								)
							SELECT DISTINCT C2.ClientId
								,ClientName
								,PrescribedDate
								,MedicationName
								,ProviderName
								,DateOfService
								,ProcedureCodeName
							FROM (
								SELECT DISTINCT C.ClientId
									,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
									,'' AS PrescribedDate
									,DIC.ICDCode + ' ' + DIC.ICDDescription AS MedicationName
									,@ProviderName AS ProviderName
									,S.DateOfService
									,P.ProcedureCodeName
								FROM Clients C
								INNER JOIN Services S ON C.ClientId = S.ClientId
								INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId
								INNER JOIN documents d ON d.ClientId = s.ClientId
									AND D.DocumentCodeId = 300
									AND d.ServiceId = S.ServiceId
								INNER JOIN ClientProblems cp ON cp.ClientId = c.ClientId
									AND cp.StartDate >= CAST(@StartDate AS DATE)
									AND CAST(cp.StartDate AS DATE) <= CAST(@EndDate AS DATE)
									AND ISNULL(cp.RecordDeleted, 'N') = 'N'
								LEFT JOIN DiagnosisICDCodes DIC ON cp.DSMCode = DIC.ICDCode
								WHERE S.STATUS IN (
										71
										,75
										) -- 71 (Show), 75(complete)                                      
									AND ISNULL(S.RecordDeleted, 'N') = 'N'
									AND ISNULL(D.RecordDeleted, 'N') = 'N'
									-- AND d.STATUS = 22                                  
									AND S.ClinicianId = @StaffId
									AND NOT EXISTS (
										SELECT 1
										FROM #ProcedureExclusionDates PE
										WHERE S.ProcedureCodeId = PE.ProcedureId
											AND PE.MeasureType = 8682
											AND CAST(S.DateOfService AS DATE) = PE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #StaffExclusionDates SE
										WHERE S.ClinicianId = SE.StaffId
											AND SE.MeasureType = 8682
											AND CAST(S.DateOfService AS DATE) = SE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #OrgExclusionDates OE
										WHERE CAST(S.DateOfService AS DATE) = OE.Dates
											AND OE.MeasureType = 8682
											AND ISNULL(OE.OrganizationExclusion, 'N') = 'Y'
										)
									AND S.DateOfService >= CAST(@StartDate AS DATE)
									AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
								) AS C2
							WHERE (
									@Option = 'N'
									OR @Option = 'A'
									)
								AND @ProblemList = 'Primary'
								/*  8682 (Problem list) */
						END
						ELSE
							IF @MeasureType = 8686
							BEGIN
								CREATE TABLE #DemoService (
									ClientId INT
									,ClientName VARCHAR(250)
									,Demo VARCHAR(MAX)
									,PrescribedDate DATETIME
									,ProviderName VARCHAR(250)
									,DateOfService DATETIME
									,ProcedureCodeName VARCHAR(MAX)
									,NextDateOfService DATETIME
									)

								CREATE TABLE #Demo (
									ClientId INT
									,Demo VARCHAR(MAX)
									,PrescribedDate DATETIME
									);

								WITH TempDemo
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
												AND PE.MeasureType = 8686
												AND CAST(S.DateOfService AS DATE) = PE.Dates
											)
										AND NOT EXISTS (
											SELECT 1
											FROM #StaffExclusionDates SE
											WHERE S.ClinicianId = SE.StaffId
												AND SE.MeasureType = 8686
												AND CAST(S.DateOfService AS DATE) = SE.Dates
											)
										AND NOT EXISTS (
											SELECT 1
											FROM #OrgExclusionDates OE
											WHERE CAST(S.DateOfService AS DATE) = OE.Dates
												AND OE.MeasureType = 8686
												AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
											)
										AND S.DateOfService >= CAST(@StartDate AS DATE)
										AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
									)
								INSERT INTO #DemoService (
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
								FROM TempDemo T
								LEFT JOIN TempDemo NT ON NT.ClientId = T.ClientId
									AND NT.row = T.row + 1

								INSERT INTO #Demo (
									ClientId
									,PrescribedDate
									,Demo
									)
								SELECT DISTINCT S.ClientId
									,C.MODIFIEDDATE
									,(
										'Race:' + CASE 
											WHEN ISNULL((
														SELECT CDI.ClientDemographicsId
														FROM ClientDemographicInformationDeclines CDI
														WHERE CDI.ClientId = S.ClientId
															AND ISNULL(CDI.RecordDeleted, 'N') = 'N'
															AND CDI.ClientDemographicsId = 6048
														), 0) <> 6048
												THEN REPLACE((
															SELECT dbo.csf_GetGlobalCodeNameById(CR.RaceId)
															FROM ClientRaces CR
															WHERE CR.ClientId = S.ClientId
																AND ISNULL(CR.RecordDeleted, 'N') = 'N'
															FOR XML PATH('')
															), ' ', ',')
											ELSE 'decline to provide'
											END + ',' + '#' + 'Prefered Language:' + CASE 
											WHEN ISNULL((
														SELECT CDI.ClientDemographicsId
														FROM ClientDemographicInformationDeclines CDI
														WHERE CDI.ClientId = C.ClientId
															AND ISNULL(CDI.RecordDeleted, 'N') = 'N'
															AND CDI.ClientDemographicsId = 6049
														), 0) <> 6049
												THEN CASE 
														WHEN ISNULL(C.PrimaryLanguage, 0) = 0
															THEN NULL
														ELSE dbo.csf_GetGlobalCodeNameById(c.PrimaryLanguage)
														END
											ELSE 'decline to provide' -- GC2.CodeName                                  
											END + ',' + '#' + 'Hispanic Origin:' + CASE 
											WHEN ISNULL((
														SELECT CDI.ClientDemographicsId
														FROM ClientDemographicInformationDeclines CDI
														WHERE CDI.ClientId = C.ClientId
															AND ISNULL(CDI.RecordDeleted, 'N') = 'N'
															AND CDI.ClientDemographicsId = 6050
														), 0) <> 6050
												THEN CASE 
														WHEN ISNULL(C.HispanicOrigin, 0) = 0
															THEN NULL
														ELSE dbo.csf_GetGlobalCodeNameById(C.HispanicOrigin)
														END
											ELSE 'decline to provide' -- GC1.CodeName                                  
											END + ',' + '#' + 'Date of Birth:' + CASE 
											WHEN ISNULL((
														SELECT CDI.ClientDemographicsId
														FROM ClientDemographicInformationDeclines CDI
														WHERE CDI.ClientId = C.ClientId
															AND ISNULL(CDI.RecordDeleted, 'N') = 'N'
															AND CDI.ClientDemographicsId = 6051
														), 0) <> 6051
												THEN CASE 
														WHEN ISNULL(C.DOB, '') = ''
															THEN ('')
														ELSE CONVERT(VARCHAR, C.DOB, 101)
														END
											ELSE 'decline to provide' -- convert(VARCHAR, C.DOB, 101)                              
											END + ',' + '#' + CASE 
											WHEN @MeaningfulUseStageLevel = 8766
												THEN 'Gender:'
											ELSE 'Sex:'
											END + CASE 
											WHEN ISNULL((
														SELECT CDI.ClientDemographicsId
														FROM ClientDemographicInformationDeclines CDI
														WHERE CDI.ClientId = C.ClientId
															AND ISNULL(CDI.RecordDeleted, 'N') = 'N'
															AND CDI.ClientDemographicsId = 6047
														), 0) <> 6047
												THEN CASE 
														WHEN ISNULL(C.Sex, '') = ''
															THEN ('')
														ELSE C.Sex
														END
											ELSE 'decline to provide' --C.Sex                           
											END
										)
								FROM Clients C
								INNER JOIN #DemoService S ON C.ClientId = S.ClientId
								WHERE (
										Isnull(C.PrimaryLanguage, 0) > 0
										OR EXISTS (
											SELECT 1
											FROM ClientDemographicInformationDeclines CDI
											WHERE CDI.ClientId = S.ClientId
												AND CDI.ClientDemographicsId = 6049
												AND isnull(CDI.RecordDeleted, 'N') = 'N'
											)
										)
									AND (
										Isnull(C.HispanicOrigin, 0) > 0
										OR EXISTS (
											SELECT 1
											FROM ClientDemographicInformationDeclines CD2
											WHERE CD2.ClientId = S.ClientId
												AND CD2.ClientDemographicsId = 6050
												AND isnull(CD2.RecordDeleted, 'N') = 'N'
											)
										)
									AND (Isnull(C.DOB, '') <> '')
									AND (Isnull(C.Sex, '') <> '')
									AND (
										EXISTS (
											SELECT 1
											FROM ClientRaces CA
											WHERE CA.ClientId = S.ClientId
												AND isnull(CA.RecordDeleted, 'N') = 'N'
											)
										OR EXISTS (
											SELECT 1
											FROM ClientDemographicInformationDeclines CD5
											WHERE CD5.ClientId = S.ClientId
												AND CD5.ClientDemographicsId = 6048
												AND isnull(CD5.RecordDeleted, 'N') = 'N'
											)
										)
									AND ISNULL(C.RecordDeleted, 'N') = 'N'

								/* 8686-Demographics */
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
									SELECT D.ClientId
										,D.ClientName
										,D1.PrescribedDate
										,D1.Demo
										,D.ProviderName
										,D.DateOfService
										,D.ProcedureCodeName
									FROM #DemoService D
									LEFT JOIN #Demo D1 ON D.ClientId = D1.ClientId
										AND (
											(
												cast(D1.PrescribedDate AS DATE) >= cast(D.DateOfService AS DATE)
												AND (
													D.NextDateOfService IS NULL
													OR cast(D.PrescribedDate AS DATE) < cast(D.NextDateOfService AS DATE)
													)
												)
											OR (
												cast(D1.PrescribedDate AS DATE) < cast(D.DateOfService AS DATE)
												AND cast(D1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)
												AND NOT EXISTS (
													SELECT 1
													FROM #Demo Dem1
													WHERE Dem1.ClientId = D1.ClientId
														AND cast(D1.PrescribedDate AS DATE) < cast(Dem1.PrescribedDate AS DATE)
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #DemoService De1
													WHERE De1.ClientId = D.ClientId
														AND cast(D.DateOfService AS DATE) < cast(De1.DateOfService AS DATE)
													)
												)
											)
								END

								IF (
										@Option = 'N'
										OR @Option = 'A'
										)
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
									SELECT ClientId
										,ClientName
										,PrescribedDate
										,MedicationName
										,ProviderName
										,DateOfService
										,ProcedureCodeName
									FROM (
										SELECT D.ClientId
											,D.ClientName
											,D1.PrescribedDate
											,D1.Demo AS MedicationName
											,D.ProviderName
											,D.DateOfService
											,D.ProcedureCodeName
										FROM #DemoService D
										LEFT JOIN #Demo D1 ON D.ClientId = D1.ClientId
											AND (
												(
													cast(D1.PrescribedDate AS DATE) >= cast(D.DateOfService AS DATE)
													AND (
														D.NextDateOfService IS NULL
														OR cast(D.PrescribedDate AS DATE) < cast(D.NextDateOfService AS DATE)
														)
													)
												OR (
													cast(D1.PrescribedDate AS DATE) < cast(D.DateOfService AS DATE)
													AND cast(D1.PrescribedDate AS DATE) <= CAST(@EndDate AS DATE)
													AND NOT EXISTS (
														SELECT 1
														FROM #Demo Dem1
														WHERE Dem1.ClientId = D1.ClientId
															AND cast(D1.PrescribedDate AS DATE) < cast(Dem1.PrescribedDate AS DATE)
														)
													AND NOT EXISTS (
														SELECT 1
														FROM #DemoService De1
														WHERE De1.ClientId = D.ClientId
															AND cast(D.DateOfService AS DATE) < cast(De1.DateOfService AS DATE)
														)
													)
												)
										) AS Result
									WHERE ISNULL(Result.MedicationName, '') <> ''
										AND (
											NOT EXISTS (
												SELECT 1
												FROM #DemoService D1
												WHERE Result.DateOfService < D1.DateOfService
													AND D1.ClientId = Result.ClientId
												)
											)
								END
										/* 8686-Demographics */
							END
							ELSE
								IF @MeasureType = 8687
								BEGIN
									CREATE TABLE #VitalService (
										ClientId INT
										,ClientName VARCHAR(250)
										,PrescribedDate VARCHAR(max)
										,MedicationName VARCHAR(max)
										,ProviderName VARCHAR(250)
										,DateOfService DATETIME
										,ProcedureCodeName VARCHAR(max)
										,NextDateOfService DATETIME
										)

									CREATE TABLE #TempVitals (
										ClientId INT
										,ClientName VARCHAR(MAX)
										,vitals VARCHAR(MAX)
										,ProviderName VARCHAR(MAX)
										,PrescribedDate VARCHAR(10)
										,DateOfService DATETIME
										,ProcedureCodeId INT
										,ProcedureCodeName VARCHAR(MAX)
										,HealthDataTemplateId INT
										,HealthdataSubtemplateId INT
										,HealthdataAttributeid INT
										,HealthRecordDate DATETIME
										,ClientHealthdataAttributeId INT
										,OrderInFlowSheet INT
										,EntryDisplayOrder INT
										,ServiceCreatedDate DATETIME
										)

									IF @MeasureSubType = 3
										AND (
											@MeaningfulUseStageLevel = 8766
											OR @MeaningfulUseStageLevel = 8767
											-- 11-Jan-2016  Gautam
											OR @MeaningfulUseStageLevel = 9373
											)
									BEGIN
											;

										WITH TempVital
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
														AND PE.MeasureType = 8687
														AND CAST(S.DateOfService AS DATE) = PE.Dates
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #StaffExclusionDates SE
													WHERE S.ClinicianId = SE.StaffId
														AND SE.MeasureType = 8687
														AND CAST(S.DateOfService AS DATE) = SE.Dates
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #OrgExclusionDates OE
													WHERE CAST(S.DateOfService AS DATE) = OE.Dates
														AND OE.MeasureType = 8687
														AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
													)
												AND S.DateOfService >= CAST(@StartDate AS DATE)
												AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
											)
										INSERT INTO #VitalService (
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
										FROM TempVital T
										LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId
											AND NT.row = T.row + 1

										INSERT INTO #TempVitals (
											ClientId
											,Vitals
											,HealthRecordDate
											)
										SELECT DISTINCT C.ClientId
											,a.NAME + '-' + chd.Value
											,chd.HealthRecordDate AS DATE
										FROM #VitalService S1
										INNER JOIN Clients C ON C.ClientId = S1.ClientId
										INNER JOIN ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId
										INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId
										INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ON a.HealthDataAttributeId = IntegerCodeId
											AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
											AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
										WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
											AND ISNULL(chd.RecordDeleted, 'N') = 'N'
											AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3
											AND (
												SELECT count(*)
												FROM dbo.ClientHealthDataAttributes CDI
												INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
												INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSALL') ss ON SS.IntegerCodeId = HDA.HealthDataAttributeId
												WHERE CDI.ClientId = Chd.ClientId
													AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
													AND isnull(CDI.RecordDeleted, 'N') = 'N'
												) >= 4

										INSERT INTO #TempVitals (
											ClientId
											,Vitals
											,HealthRecordDate
											)
										SELECT DISTINCT C.ClientId
											,a.NAME + '-' + chd.Value
											,chd.HealthRecordDate
										FROM #VitalService S1
										INNER JOIN Clients C ON C.ClientId = S1.ClientId
										INNER JOIN ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId
										INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId
										INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ON a.HealthDataAttributeId = IntegerCodeId
											AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
											AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
										WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
											AND ISNULL(chd.RecordDeleted, 'N') = 'N'
											AND (dbo.[GetAge](C.DOB, GETDATE())) < 3
											AND (
												SELECT count(*)
												FROM dbo.ClientHealthDataAttributes CDI
												INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
												INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId = a.HealthDataAttributeId
												WHERE CDI.ClientId = Chd.ClientId
													AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
													AND isnull(CDI.RecordDeleted, 'N') = 'N'
												) >= 2

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
												,cast(T.HealthRecordDate AS DATE)
												,STUFF((
														SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))
														FROM #TempVitals DI1
														WHERE V.ClientId = DI1.ClientId
															AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)
														FOR XML PATH('')
															,TYPE
														).value('.', 'nvarchar(max)'), 1, 2, '') AS vital
												,V.ProviderName
												,V.DateOfService
												,V.ProcedureCodeName
											FROM #VitalService V
											LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId
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
															FROM #TempVitals T1
															WHERE T1.ClientId = T.ClientId
																AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
															)
														AND NOT EXISTS (
															SELECT 1
															FROM #VitalService V1
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
												,PrescribedDate
												,MedicationName
												,ProviderName
												,DateOfService
												,ProcedureCodeName
											FROM (
												SELECT DISTINCT V.ClientId
													,V.ClientName
													,cast(T.HealthRecordDate AS DATE) AS PrescribedDate
													,STUFF((
															SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))
															FROM #TempVitals DI1
															WHERE V.ClientId = DI1.ClientId
																AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)
															FOR XML PATH('')
																,TYPE
															).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName
													,V.ProviderName
													,V.DateOfService
													,V.ProcedureCodeName
												FROM #VitalService V
												LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId
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
																FROM #TempVitals T1
																WHERE T1.ClientId = T.ClientId
																	AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
																)
															AND NOT EXISTS (
																SELECT 1
																FROM #VitalService V1
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
										END
									END

									IF @MeasureSubType = 4
										AND (
											@MeaningfulUseStageLevel = 8766
											OR @MeaningfulUseStageLevel = 8767
											OR @MeaningfulUseStageLevel = 9373
											)
									BEGIN
											;

										WITH TempVital
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
														AND PE.MeasureType = 8687
														AND CAST(S.DateOfService AS DATE) = PE.Dates
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #StaffExclusionDates SE
													WHERE S.ClinicianId = SE.StaffId
														AND SE.MeasureType = 8687
														AND CAST(S.DateOfService AS DATE) = SE.Dates
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #OrgExclusionDates OE
													WHERE CAST(S.DateOfService AS DATE) = OE.Dates
														AND OE.MeasureType = 8687
														AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
													)
												AND S.DateOfService >= CAST(@StartDate AS DATE)
												AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
											)
										INSERT INTO #VitalService (
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
										FROM TempVital T
										LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId
											AND NT.row = T.row + 1

										INSERT INTO #TempVitals (
											ClientId
											,Vitals
											,HealthRecordDate
											)
										SELECT DISTINCT C.ClientId
											,a.NAME + '-' + chd.Value
											,chd.HealthRecordDate
										FROM #VitalService S1
										INNER JOIN Clients C ON C.ClientId = S1.ClientId
										INNER JOIN ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId
										INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId
										INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ON a.HealthDataAttributeId = IntegerCodeId
											AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
											AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
										WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
											AND ISNULL(chd.RecordDeleted, 'N') = 'N'
											AND (
												SELECT count(*)
												FROM dbo.ClientHealthDataAttributes CDI
												INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
												INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSHW') ss ON SS.IntegerCodeId = a.HealthDataAttributeId
												WHERE CDI.ClientId = Chd.ClientId
													AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
													AND isnull(CDI.RecordDeleted, 'N') = 'N'
												) >= 2

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
												,cast(T.HealthRecordDate AS DATE)
												,STUFF((
														SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))
														FROM #TempVitals DI1
														WHERE V.ClientId = DI1.ClientId
															AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)
														FOR XML PATH('')
															,TYPE
														).value('.', 'nvarchar(max)'), 1, 2, '') AS vital
												,V.ProviderName
												,V.DateOfService
												,V.ProcedureCodeName
											FROM #VitalService V
											LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId
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
															FROM #TempVitals T1
															WHERE T1.ClientId = T.ClientId
																AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
															)
														AND NOT EXISTS (
															SELECT 1
															FROM #VitalService V1
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
												,PrescribedDate
												,MedicationName
												,ProviderName
												,DateOfService
												,ProcedureCodeName
											FROM (
												SELECT DISTINCT V.ClientId
													,V.ClientName
													,cast(T.HealthRecordDate AS DATE) AS PrescribedDate
													,STUFF((
															SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))
															FROM #TempVitals DI1
															WHERE V.ClientId = DI1.ClientId
																AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)
															FOR XML PATH('')
																,TYPE
															).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName
													,V.ProviderName
													,V.DateOfService
													,V.ProcedureCodeName
												FROM #VitalService V
												LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId
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
																FROM #TempVitals T1
																WHERE T1.ClientId = T.ClientId
																	AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
																)
															AND NOT EXISTS (
																SELECT 1
																FROM #VitalService V1
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
										END
									END

									IF @MeasureSubType = 5
										AND (
											@MeaningfulUseStageLevel = 8766
											OR @MeaningfulUseStageLevel = 8767
											OR @MeaningfulUseStageLevel = 9373
											)
									BEGIN
											;

										WITH TempVital
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
														AND PE.MeasureType = 8687
														AND CAST(S.DateOfService AS DATE) = PE.Dates
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #StaffExclusionDates SE
													WHERE S.ClinicianId = SE.StaffId
														AND SE.MeasureType = 8687
														AND CAST(S.DateOfService AS DATE) = SE.Dates
													)
												AND NOT EXISTS (
													SELECT 1
													FROM #OrgExclusionDates OE
													WHERE CAST(S.DateOfService AS DATE) = OE.Dates
														AND OE.MeasureType = 8687
														AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
													)
												AND S.DateOfService >= CAST(@StartDate AS DATE)
												AND CAST(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
												AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3
											)
										INSERT INTO #VitalService (
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
										FROM TempVital T
										LEFT JOIN TempVital NT ON NT.ClientId = T.ClientId
											AND NT.row = T.row + 1

										INSERT INTO #TempVitals (
											ClientId
											,Vitals
											,HealthRecordDate
											)
										SELECT DISTINCT C.ClientId
											,a.NAME + '-' + chd.Value
											,chd.HealthRecordDate
										FROM #VitalService S1
										INNER JOIN Clients C ON C.ClientId = S1.ClientId
										INNER JOIN ClientHealthDataAttributes chd ON C.ClientId = chd.ClientId
										INNER JOIN HealthDataAttributes a ON a.HealthDataAttributeId = chd.HealthDataAttributeId
										INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSBP') ON a.HealthDataAttributeId = IntegerCodeId
											AND cast(chd.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
											AND cast(chd.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
										WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
											AND ISNULL(chd.RecordDeleted, 'N') = 'N'
											AND (dbo.[GetAge](C.DOB, GETDATE())) >= 3
											AND (
												SELECT count(*)
												FROM dbo.ClientHealthDataAttributes CDI
												INNER JOIN dbo.HealthDataAttributes HDA ON CDI.HealthDataAttributeId = HDA.HealthDataAttributeId
												INNER JOIN dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALSBP') ss ON SS.IntegerCodeId = a.HealthDataAttributeId
												WHERE CDI.ClientId = Chd.ClientId
													AND cast(chd.HealthRecordDate AS DATE) = CAST(CDI.HealthRecordDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) >= CAST(@StartDate AS DATE)
													AND cast(CDI.HealthRecordDate AS DATE) <= CAST(@EndDate AS DATE)
													AND isnull(CDI.RecordDeleted, 'N') = 'N'
												) >= 2

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
												,cast(T.HealthRecordDate AS DATE)
												,STUFF((
														SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))
														FROM #TempVitals DI1
														WHERE V.ClientId = DI1.ClientId
															AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)
														FOR XML PATH('')
															,TYPE
														).value('.', 'nvarchar(max)'), 1, 2, '') AS vital
												,V.ProviderName
												,V.DateOfService
												,V.ProcedureCodeName
											FROM #VitalService V
											LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId
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
															FROM #TempVitals T1
															WHERE T1.ClientId = T.ClientId
																AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
															)
														AND NOT EXISTS (
															SELECT 1
															FROM #VitalService V1
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
												,PrescribedDate
												,MedicationName
												,ProviderName
												,DateOfService
												,ProcedureCodeName
											FROM (
												SELECT DISTINCT V.ClientId
													,V.ClientName
													,T.HealthRecordDate AS PrescribedDate
													,STUFF((
															SELECT '# ' + RTRIM(LTRIM(ISNULL(DI1.Vitals, '')))
															FROM #TempVitals DI1
															WHERE V.ClientId = DI1.ClientId
																AND cast(T.HealthRecordDate AS DATE) = cast(DI1.HealthRecordDate AS DATE)
															FOR XML PATH('')
																,TYPE
															).value('.', 'nvarchar(max)'), 1, 2, '') AS MedicationName
													,V.ProviderName
													,V.DateOfService
													,V.ProcedureCodeName
												FROM #VitalService V
												LEFT JOIN #TempVitals T ON T.ClientId = V.ClientId
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
																FROM #TempVitals T1
																WHERE T1.ClientId = T.ClientId
																	AND cast(T.HealthRecordDate AS DATE) < cast(T1.HealthRecordDate AS DATE)
																)
															AND NOT EXISTS (
																SELECT 1
																FROM #VitalService V1
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
										END
												/*8687(Vitals) */
									END
								END
								ELSE
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
												--	NOT EXISTS (
												--		SELECT 1
												--		FROM #SmokingData T1
												--		WHERE (Result.DateOfService < T1.DateOfService OR Result.HealthRecordDate < T1.HealthRecordDate)
												--			AND T1.ClientId = Result.ClientId
												--			--AND ISNULL(Result.MedicationName, '') = ''
												--		)
												--	)
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

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulUseList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


