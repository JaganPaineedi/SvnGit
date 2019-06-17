 IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicianTinDetailsFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicianTinDetailsFromMUThird]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicianTinDetailsFromMUThird] (                                                          
 @StaffId VARCHAR(max)                                                          
 ,@StartDate DATETIME                                                          
 ,@EndDate DATETIME                                                          
 ,@MeasureType VARCHAR(max)                                                          
 ,@MeasureSubType VARCHAR(max)                                                          
 ,@Option CHAR(1)                                                          
 ,@InPatient BIT                                                          
 ,@Stage VARCHAR(10) = NULL                                                          
 ,@Tin VARCHAR(max) = NULL                                                          
 )      
 /********************************************************************************                                                                                                      
-- Stored Procedure: dbo.ssp_RDLClinicianProviderDetailsFromMUThird                                                                                                        
--                                                                                                     
-- Copyright: Streamline Healthcate Solutions                                                                                                   
--                                                                                                      
-- Updates:                                                                                                                                                             
-- Date   Author   Purpose                                                                                                      
-- 10-Oct-2017  Gautam  What:ssp for Report to display Multiple Clinician's measures.                                                                                                            
--       Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports   
-- 22-June-2018 Gautam  What: commented the RecordDeleted check from Messages
                        why : As per functionality on UI , User can delete the messages. so it will not count for Numerator.Use - Stage 3 > Tasks #46 > Stage 3 Reports                                                                                                                                                                                                                                                                                                                                                                         
*********************************************************************************/    
AS    
SET NOCOUNT ON;    
    
BEGIN
	BEGIN TRY
		DECLARE @MeaningfulUseStageLevel VARCHAR(10)
		DECLARE @RecordCounter INT
		DECLARE @TotalRecords INT
		DECLARE @ProviderName VARCHAR(40)
		DECLARE @RecordUpdated CHAR(1) = 'N'

		SET @RecordCounter = 1

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

		--If @MeaningfulUseStageLevel <> 8768                                                             
		--  select @MeaningfulUseStageLevel= 8768                                                                                      
		CREATE TABLE #StaffList (StaffId INT)

		INSERT INTO #StaffList
		SELECT item
		FROM [dbo].fnSplit(@StaffId, ',')

		CREATE TABLE #TinList (Tin VARCHAR(50))

		INSERT INTO #TinList
		SELECT item
		FROM [dbo].fnSplit(@Tin, ',')

		CREATE TABLE #MeasureList (Measure VARCHAR(250))

		INSERT INTO #MeasureList
		SELECT item
		FROM [dbo].fnSplit(@MeasureType, ',')

		CREATE TABLE #MeasureSubList (MeasureSubType VARCHAR(250))

		INSERT INTO #MeasureSubList
		SELECT item
		FROM [dbo].fnSplit(@MeasureSubType, ',')

		CREATE TABLE #ResultSet (
			MeasureTypeId VARCHAR(15)
			,Measure VARCHAR(500)
			,MeasureSubTypeId VARCHAR(500)
			,DetailsType VARCHAR(500)
			,[Target] VARCHAR(20)
			,ProviderName VARCHAR(250)
			,Numerator VARCHAR(20)
			,Denominator VARCHAR(20)
			,ActualResult VARCHAR(20)
			,Result VARCHAR(100)
			,DetailsSubType VARCHAR(500)
			,ProblemList VARCHAR(100)
			,SortOrder INT
			,StaffId INT
			,UserCode VARCHAR(250)
			,Exclusions VARCHAR(250)
			,StaffExclusion VARCHAR(500)
			,ProcedureExclusion VARCHAR(500)
			,OrgExclusion VARCHAR(500)
			,Tin VARCHAR(500)
			,TinNumeratorTotal INT
			,TinDenominatorTotal INT
			)

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
			,cast(MFP.ProviderExclusionToDate AS DATE)
			,MFP.StaffId
		FROM dbo.MeaningFulUseProviderExclusions MFP
		INNER JOIN dbo.MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId
			AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
			AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
		WHERE MFU.Stage = @MeaningfulUseStageLevel
			AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)
			--AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)                                                                                                          
			--AND MFP.StaffId IS NOT NULL                                                          
			AND EXISTS (
				SELECT 1
				FROM #StaffList S
				WHERE S.StaffId = MFP.StaffId
				)

		INSERT INTO #OrgExclusionDateRange
		SELECT MFU.MeasureType
			,MFU.MeasureSubType
			,cast(MFP.ProviderExclusionFromDate AS DATE)
			,cast(MFP.ProviderExclusionToDate AS DATE)
			,MFP.OrganizationExclusion
		FROM dbo.MeaningFulUseProviderExclusions MFP
		INNER JOIN dbo.MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId
			AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
			AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
		WHERE MFU.Stage = @MeaningfulUseStageLevel
			AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)
			--AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)                                                                                                          
			AND MFP.StaffId IS NULL

		INSERT INTO #ProcedureExclusionDateRange
		SELECT MFU.MeasureType
			,MFU.MeasureSubType
			,cast(MFE.ProcedureExclusionFromDate AS DATE)
			,cast(MFE.ProcedureExclusionToDate AS DATE)
			,MFP.ProcedureCodeId
		FROM dbo.MeaningFulUseProcedureExclusionProcedures MFP
		INNER JOIN dbo.MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId
			AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
			AND ISNULL(MFE.RecordDeleted, 'N') = 'N'
		INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId
			AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
		WHERE MFU.Stage = @MeaningfulUseStageLevel
			AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)
			--AND MFE.ProcedureExclusionToDate <= CAST(@EndDate AS DATE)                                                                                                          
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

		IF @InPatient = 1
		BEGIN
			CREATE TABLE #MeaningfulMeasurePermissions (GlobalCodeId INT)

			INSERT INTO #MeaningfulMeasurePermissions
			SELECT v.PermissionItemId
			FROM dbo.ViewStaffPermissions v
			CROSS APPLY #StaffList AS TEMP
			WHERE TEMP.StaffId = v.StaffId
				AND v.PermissionItemId IN (
					5732
					,5733
					,5734
					)

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8703'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Secure Messaging'
					,temp1.Measure
					,temp2.measureSubType
					,'Secure Messaging'
					,'25'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8703'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '9478'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Patient Generated Health Data'
					,temp1.Measure
					,temp2.measureSubType
					,'Patient Generated Health Data'
					,'5'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '9478'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '9479'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Receive and Incorporate'
					,temp1.Measure
					,temp2.measureSubType
					,'Receive and Incorporate'
					,'10'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '9479'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8699'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Medication Reconciliation'
					,temp1.Measure
					,temp2.measureSubType
					,0
					,'80'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8699'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8698'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Patient Education'
					,temp1.Measure
					,temp2.measureSubType
					,'Patient Education'
					,'10'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8698'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8683'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6266'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,Tin
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'e-Prescribing'
					,temp1.Measure
					,'6266'
					,'Measure 1(H)'
					,0
					,'60'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.Measure = '8683'
					AND temp2.measureSubType = '6266'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8697'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6261'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Patient Portal'
					,temp1.Measure
					,temp2.measureSubType
					,'Measure 1'
					,0
					,'50'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8697'
					AND temp2.measureSubType = '6261'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8683'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6267'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,Tin
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'e-Prescribing'
					,temp1.Measure
					,'6267'
					,'Measure 2 (H)'
					,0
					,'60'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8683'
					AND temp2.measureSubType = '6267'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8710'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'View, Download, Transmit'
					,temp1.Measure
					,temp2.measureSubType
					,'View, Download, Transmit'
					,'10'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8710'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8700'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6214'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Health Information Exchange'
					,temp1.Measure
					,temp2.measureSubType
					,'Measure 1(H) '
					,0
					,'50'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8700'
					AND temp2.measureSubType = '6214'
			END
		END

		IF @InPatient = 0
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8683'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6266'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,Tin
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'e-Prescribing'
					,temp1.Measure
					,'6266'
					,'Measure 1'
					,0
					,'60'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.Measure = '8683'
					AND temp2.measureSubType = '6266'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8683'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6267'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,Tin
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'e-Prescribing'
					,temp1.Measure
					,'6267'
					,'Measure 2'
					,0
					,'60'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8683'
					AND temp2.measureSubType = '6267'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8680'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6177'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'CPOE'
					,temp1.Measure
					,temp2.measureSubType
					,'Medication'
					,0
					,'60'
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8680'
					AND temp2.measureSubType = '6177'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8680'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6178'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'CPOE'
					,temp1.Measure
					,temp2.measureSubType
					,'Lab'
					,0
					,'60'
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8680'
					AND temp2.measureSubType = '6178'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8680'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6179'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'CPOE'
					,temp1.Measure
					,temp2.measureSubType
					,'Radiology'
					,0
					,'60'
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8680'
					AND temp2.measureSubType = '6179'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8698'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Patient Education'
					,temp1.Measure
					,temp2.measureSubType
					,'Patient Education'
					,'35'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8698'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8697'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6261'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Patient Portal'
					,temp1.Measure
					,temp2.measureSubType
					,'Measure 1'
					,0
					,'80'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8697'
					AND temp2.measureSubType = '6261'
			END

			--      If exists(Select 1 from #MeasureList  where measure='8697') and                                                          
			--          exists(Select 1 from #MeasureSubList  where measureSubType ='6212')                               
			--Begin                                                                                             
			--  INSERT INTO #ResultSet (                                                                                                
			--   ProviderName                                                    
			--   ,StaffId                                                                                                
			--   ,Measure                                                                                                
			--   ,MeasureTypeId                                                                                                
			--   ,MeasureSubTypeId                                                                                                
			--   ,DetailsSubType                                                                                                
			--   ,ActualResult                                                                                                
			--   ,[Target]                                                                               
			--   ,[tin]                                                                                               
			--   )                                                                                                
			--  SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                                                                
			--   ,c.StaffId           
			--   ,'Patient Portal'                                                                                                
			--   ,temp1.Measure                                                      
			--   ,temp2.measureSubType                                                                                                
			--   ,'Measure 2'                                                                      
			--   ,0                                                                                                
			--   ,'35'                                                                                 
			--   ,temp3.Tin                                                                                              
			--  FROM dbo.Staff C                                                                                                
			--  CROSS APPLY #StaffList AS TEMP                                                              
			--  CROSS APPLY #MeasureList AS temp1                                   
			--  CROSS APPLY #MeasureSubList AS temp2                                   
			--  CROSS APPLY #TinList AS temp3                                                                                              
			--  WHERE TEMP.StaffId = c.StaffId                                                                                                
			--   AND temp1.measure ='8697'                                                             
			--   AND temp2.measureSubType ='6212'                                                                                              
			-- end                                                                                 
			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8703'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Secure Messaging'
					,temp1.Measure
					,temp2.measureSubType
					,'Secure Messaging'
					,'25'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8703'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8699'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Medication Reconciliation'
					,temp1.Measure
					,temp2.measureSubType
					,0
					,'80'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8699'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8700'
					)
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE measureSubType = '6213'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,ActualResult
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Health Information Exchange'
					,temp1.Measure
					,temp2.measureSubType
					,'Measure 1'
					,0
					,'50'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8700'
					AND temp2.measureSubType = '6213'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '8710'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'View, Download, Transmit'
					,temp1.Measure
					,temp2.measureSubType
					,'View, Download, Transmit'
					,'10'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '8710'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '9478'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Patient Generated Health Data'
					,temp1.Measure
					,temp2.measureSubType
					,'Patient Generated Health Data'
					,'5'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '9478'
			END

			IF EXISTS (
					SELECT 1
					FROM #MeasureList
					WHERE measure = '9479'
					)
			BEGIN
				INSERT INTO #ResultSet (
					ProviderName
					,StaffId
					,Measure
					,MeasureTypeId
					,MeasureSubTypeId
					,DetailsSubType
					,[Target]
					,[tin]
					)
				SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')
					,c.StaffId
					,'Receive and Incorporate'
					,temp1.Measure
					,temp2.measureSubType
					,'Receive and Incorporate'
					,'40'
					,temp3.Tin
				FROM dbo.Staff C
				CROSS APPLY #StaffList AS TEMP
				CROSS APPLY #MeasureList AS temp1
				CROSS APPLY #MeasureSubList AS temp2
				CROSS APPLY #TinList AS temp3
				WHERE TEMP.StaffId = c.StaffId
					AND temp1.measure = '9479'
			END

			--    UPDATE R                                         
			--SET                                                                         
			----Measure = MU.DisplayWidgetNameAs                                                                                  
			----   ,[Target] = cast(isnull(mu.Target, 0) AS INT)                                                                                  
			----   ,Numerator = NULL                                                                                  
			----   ,Denominator = NULL                                                                                  
			----   ,ActualResult = 0                                                                                  
			----   ,Result = NULL ,                                          
			--   DetailsSubType = CASE                                                                                   
			--    WHEN R.MeasureTypeId = 8704                                                                                  
			--     THEN 'Electronic Notes'                                                                 
			--    WHEN R.MeasureTypeId = 8691                                                                               
			--     THEN 'Disclosures'                                                                                  
			--    ELSE substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE                                                                                   
			--       WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0                                       
			--        THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))                                                                                  
			--       ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2                                                                                  
			--       END)                                                                                  
			--    END                                                                                  
			--  FROM #ResultSet R                                                                                  
			--  LEFT JOIN dbo.MeaningfulUseMeasureTargets MU ON MU.MeasureType = R.MeasureTypeId                                                                                  
			--   AND (                                      
			--    R.MeasureSubTypeId = 0                                                                                  
			--    OR MU.MeasureSubType = R.MeasureSubTypeId                                                                     
			--    )                                                                             
			--   AND ISNULL(MU.RecordDeleted, 'N') = 'N'                       
			--  LEFT JOIN dbo.GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId                                                                                  
			--   AND ISNULL(GC.RecordDeleted, 'N') = 'N'                                                         
			--  LEFT JOIN dbo.GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId                                                                                  
			--   AND ISNULL(GS.RecordDeleted, 'N') = 'N'                                                                                  
			--  WHERE MU.Stage = @MeaningfulUseStageLevel                                                                                  
			-- AND isnull(mu.Target, 0) > 0                                        
			--   AND MU.MeasureType NOT IN (                                                                           
			--    '8687'                                                                              
			--    ,'8682'                                                                                  
			--    ,'8683'                                                                         
			--    )                                                                                  
			-- INSERT INTO #ResultSet (                                                                                              
			-- ProviderName                             
			-- ,StaffId                                                                                             
			-- ,MeasureTypeId                                                                                              
			-- ,MeasureSubTypeId                                                                                     
			-- ,UserCode                                                              
			-- )                                                                                              
			--SELECT DISTINCT IsNull(C.LastName, '') + ', ' + IsNull(C.FirstName, '')                                                              
			-- ,c.StaffId                                                                                              
			-- ,temp1.item                                                                     -- ,CASE                                  
			--  WHEN temp1.item = '8680'                                                                                          
			--   THEN temp2.item                                                                                        
			--  WHEN temp1.item = '8697'                                                                                              
			--   THEN temp2.item                                                                                              
			--  WHEN temp1.item = '8700'                                                                                              
			--   THEN temp2.item                                                                                              
			--  ELSE 0                                                          
			--  END                                                                                              
			-- ,c.UserCode                                                                                              
			--FROM dbo.Staff C                                                                                              
			--CROSS APPLY dbo.fnSplit(@staffId, ',') AS TEMP                                          
			--CROSS APPLY dbo.fnSplit(@MeasureType, ',') AS temp1                                                                                              
			--CROSS APPLY dbo.fnSplit(@MeasureSubType, ',') AS temp2                                                                                              
			--WHERE TEMP.item = c.StaffId                                                                                              
			-- AND temp1.item NOT IN (                                                                         
			--  '8682'                                                                 
			--  ,'8687'                                                                 
			--  ,'8683'                                                            
			--  )                                                                                              
			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8683'
					)
				AND @MeaningfulUseStageLevel = 8768
			BEGIN
				/*  8683--(e-Prescribing)*/
				UPDATE R
				SET R.Denominator = isnull((
							SELECT COUNT(cmsa.ClientMedicationScriptId)
							FROM dbo.ViewMUEPrescribing AS cmsa
							WHERE cmsa.OrderDate >= CAST(@StartDate AS DATE)
								AND cast(cmsa.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
								AND cmsa.OrderingPrescriberId = R.StaffId
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE cmsa.OrderingPrescriberId = SE.StaffId
										AND SE.MeasureType = 8683
										AND CAST(cmsa.OrderDate AS DATE) = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CAST(cmsa.OrderDate AS DATE) = OE.Dates
										AND OE.MeasureType = 8683
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0) + isnull((
							SELECT COUNT(DISTINCT CO.ClientOrderId)
							FROM dbo.ViewMUEPrescribingClientOrders AS CO
							WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
								AND CO.OrderingPhysician = R.StaffId
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
							), 0)
					,R.Numerator = isnull((
							SELECT COUNT(cmsa.ClientMedicationScriptId)
							FROM dbo.ViewMUEPrescribing AS cmsa
							WHERE cmsa.Method = 'E'
								AND cmsa.OrderDate >= CAST(@StartDate AS DATE)
								AND cast(cmsa.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
								AND cmsa.OrderingPrescriberId = R.StaffId
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE cmsa.OrderingPrescriberId = SE.StaffId
										AND SE.MeasureType = 8683
										AND CAST(cmsa.OrderDate AS DATE) = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CAST(cmsa.OrderDate AS DATE) = OE.Dates
										AND OE.MeasureType = 8683
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8683
					AND R.MeasureSubTypeId = 6266
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8683'
					)
				AND @MeaningfulUseStageLevel = 8768 --Satge3                                                                                                          
			BEGIN
				/*  8683--(e-Prescribing)*/
				UPDATE R
				SET R.Denominator = isnull((
							SELECT COUNT(cmsa.ClientMedicationScriptId)
							FROM dbo.ViewMUEPrescribing AS cmsa
							WHERE cmsa.OrderDate >= CAST(@StartDate AS DATE)
								AND cast(cmsa.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
								AND cmsa.OrderingPrescriberId = r.StaffId
								AND EXISTS (
									SELECT 1
									FROM dbo.MDDrugs md
									WHERE md.ClinicalFormulationId = cmsa.ClinicalFormulationId
										AND isnull(md.RecordDeleted, 'N') = 'N'
										AND md.DEACode = 0
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE cmsa.OrderingPrescriberId = SE.StaffId
										AND SE.MeasureType = 8683
										AND CAST(cmsa.OrderDate AS DATE) = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CAST(cmsa.OrderDate AS DATE) = OE.Dates
										AND OE.MeasureType = 8683
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0) + isnull((
							SELECT COUNT(DISTINCT CO.ClientOrderId)
							FROM dbo.ViewMUEPrescribingClientOrders AS CO
							WHERE cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)
								AND CO.OrderingPhysician = r.StaffId
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
							), 0)
					,R.Numerator = isnull((
							SELECT COUNT(cmsa.ClientMedicationScriptId)
							FROM dbo.ViewMUEPrescribing AS cmsa
							WHERE (
									cmsa.Method = 'E'
									--OR (                                                                                                         
									-- cmsa.Method IN (                                                                   
									--  'E'                                                                                                          
									--  ,'P'                                                                                                          
									--  )                                           
									-- AND md.ClinicalFormulationId IS NULL                                                                                                          
									-- )                                                              
									)
								AND cmsa.OrderDate >= CAST(@StartDate AS DATE)
								AND cast(cmsa.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
								AND cmsa.OrderingPrescriberId = r.StaffId
								AND EXISTS (
									SELECT 1
									FROM dbo.MDDrugs md
									WHERE md.ClinicalFormulationId = cmsa.ClinicalFormulationId
										AND isnull(md.RecordDeleted, 'N') = 'N'
										AND md.DEACode = 0
									)
								AND EXISTS (
									SELECT 1
									FROM dbo.SureScriptsEligibilityResponse SSER
									WHERE SSER.ClientId = cmsa.ClientId
										AND isnull(SSER.RecordDeleted, 'N') = 'N'
										--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                                                                                             
										AND (
											SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
											AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
											)
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE cmsa.OrderingPrescriberId = SE.StaffId
										AND SE.MeasureType = 8683
										AND CAST(cmsa.OrderDate AS DATE) = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CAST(cmsa.OrderDate AS DATE) = OE.Dates
										AND OE.MeasureType = 8683
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8683
					AND R.MeasureSubTypeId = 6267
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8683'
					)
				AND @MeaningfulUseStageLevel IN (
					9476
					,9477
					,9480
					,9481
					) --ACI Transition                        
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE MeasureSubType = '6266'
					)
			BEGIN
				/*  8683--(e-Prescribing) */
				CREATE TABLE #EPRESRESULT21 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					,StaffId INT
					)

				INSERT INTO #EPRESRESULT21 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					,StaffId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
							THEN 'Yes'
						ELSE 'No'
						END
					,cms.OrderingPrescriberId
				FROM dbo.ClientMedicationScriptActivities AS cmsa
				INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
					AND isnull(cmsd.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
					AND isnull(cmi.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
					AND isnull(cms.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN Locations L ON cms.LocationId = L.LocationId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND (
						@Tin = 'NA'
						OR L.TaxIdentificationNumber = @Tin
						)
					AND NOT EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						WHERE CM.ClientId = CI.ClientId
							AND isnull(CI.RecordDeleted, 'N') = 'N'
						)

				CREATE TABLE #EPRESRESULT15 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					,StaffId INT
					)

				INSERT INTO #EPRESRESULT15 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					,StaffId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
							THEN 'Yes'
						ELSE 'No'
						END
					,cms.OrderingPrescriberId
				FROM dbo.ClientMedicationScriptActivities AS cmsa
				INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
					AND isnull(cmsd.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
					AND isnull(cmi.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
					AND isnull(cms.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Locations L ON cms.LocationId = L.LocationId
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cmsa.Method = 'E'
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND (
						@Tin = 'NA'
						OR L.TaxIdentificationNumber = @Tin
						)
					AND NOT EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						WHERE CM.ClientId = CI.ClientId
							AND isnull(CI.RecordDeleted, 'N') = 'N'
						)
					AND EXISTS (
						SELECT 1
						FROM SureScriptsEligibilityResponse SSER
						WHERE SSER.ClientId = CMS.ClientId
							AND isnull(SSER.RecordDeleted, 'N') = 'N'
							--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
							AND (
								SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
								AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
								)
						)

				UPDATE R
				SET R.Denominator = (
						SELECT count(*)
						FROM #EPRESRESULT21 a
						WHERE a.StaffId = R.StaffId
						)
					,R.Numerator = (
						SELECT count(*)
						FROM #EPRESRESULT15 b
						WHERE b.StaffId = R.StaffId
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8683
					AND R.MeasureSubTypeId = 6266
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8683'
					)
				AND @MeaningfulUseStageLevel IN (
					9476
					,9477
					,9480
					,9481
					) --ACI Transition                        
				AND EXISTS (
					SELECT 1
					FROM #MeasureSubList
					WHERE MeasureSubType = '6267'
					)
			BEGIN
				CREATE TABLE #EPRESRESULT22 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					,StaffId INT
					)

				INSERT INTO #EPRESRESULT22 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					,StaffId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
							THEN 'Yes'
						ELSE 'No'
						END
					,cms.OrderingPrescriberId
				FROM dbo.ClientMedicationScriptActivities AS cmsa
				INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
					AND isnull(cmsd.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
					AND isnull(cmi.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
					AND isnull(cms.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN Locations L ON cms.LocationId = L.LocationId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND (
						@Tin = 'NA'
						OR L.TaxIdentificationNumber = @Tin
						)
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND NOT EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						WHERE CM.ClientId = CI.ClientId
							AND isnull(CI.RecordDeleted, 'N') = 'N'
						)
					AND EXISTS (
						SELECT 1
						FROM dbo.MDDrugs AS md
						WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
							AND isnull(md.RecordDeleted, 'N') = 'N'
							AND md.DEACode = 0
						)

				CREATE TABLE #EPRESRESULT31 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					,StaffId INT
					)

				INSERT INTO #EPRESRESULT31 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					,StaffId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
							THEN 'Yes'
						ELSE 'No'
						END
					,cms.OrderingPrescriberId
				FROM dbo.ClientMedicationScriptActivities AS cmsa
				INNER JOIN dbo.ClientMedicationScriptDrugs AS cmsd ON cmsd.ClientMedicationScriptId = cmsa.ClientMedicationScriptId
					AND isnull(cmsd.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationInstructionId = cmsd.ClientMedicationInstructionId
					AND isnull(cmi.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = cmsd.ClientMedicationScriptId
					AND isnull(cms.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Locations L ON cms.LocationId = L.LocationId
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                            
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cmsa.Method = 'E'
					AND (
						@Tin = 'NA'
						OR L.TaxIdentificationNumber = @Tin
						)
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND NOT EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						WHERE CM.ClientId = CI.ClientId
							AND isnull(CI.RecordDeleted, 'N') = 'N'
						)
					AND EXISTS (
						SELECT 1
						FROM SureScriptsEligibilityResponse SSER
						WHERE SSER.ClientId = CMS.ClientId
							AND isnull(SSER.RecordDeleted, 'N') = 'N'
							--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
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

				UPDATE R
				SET R.Denominator = (
						SELECT count(*)
						FROM #EPRESRESULT22 a
						WHERE a.StaffId = R.StaffId
						)
					,R.Numerator = (
						SELECT count(*)
						FROM #EPRESRESULT31 b
						WHERE b.StaffId = R.StaffId
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8683
					AND R.MeasureSubTypeId = 6267
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8680'
					)
				AND @MeaningfulUseStageLevel = 8768 --Satge3                 
			BEGIN
				/*  8680--(CPOE)*/
				UPDATE R
				SET R.Denominator = IsNULL((
							SELECT count(DISTINCT CM.ClientId)
							FROM dbo.ViewMUCPOEMedication CM
							WHERE CM.PrescriberId = R.StaffId
								AND CM.MedicationStartDate >= CAST(@StartDate AS DATE)
								AND CM.MedicationStartDate <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE CM.PrescriberId = SE.StaffId
										AND SE.MeasureType = 8680
										AND SE.MeasureSubType = 6177
										AND CM.MedicationStartDate = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CM.MedicationStartDate = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6177
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0) + IsNULL((
							SELECT count(DISTINCT IR.ImageRecordId)
							FROM dbo.ViewMUCPOEMedicationImageRecords IR
							WHERE IR.CreatedBy = R.UserCode
								AND IR.AssociatedId = 1622 -- Document Codes for 'Medications'                                                                                                              
								AND IR.EffectiveDate >= CAST(@StartDate AS DATE)
								AND IR.EffectiveDate <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE IR.EffectiveDate = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6177
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8680
					AND R.MeasureSubTypeId = 6177 --(CPOE)                                                                                                                        

				UPDATE R
				SET R.Numerator = (
						SELECT count(DISTINCT CM.ClientId)
						FROM dbo.ViewMUCPOEMedication CM
						WHERE CM.PrescriberId = R.StaffId
							AND CM.MedicationStartDate >= CAST(@StartDate AS DATE)
							AND CM.MedicationStartDate <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CM.PrescriberId = SE.StaffId
									AND SE.MeasureType = 8680
									AND SE.MeasureSubType = 6177
									AND CM.MedicationStartDate = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CM.MedicationStartDate = OE.Dates
									AND OE.MeasureType = 8680
									AND OE.MeasureSubType = 6177
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8680
					AND R.MeasureSubTypeId = 6177 --(CPOE)                                                                                                                        

				UPDATE R
				SET R.Denominator = IsNULL((
							SELECT count(DISTINCT CO.ClientOrderId)
							FROM dbo.ViewMUCPOELabRadio CO
							WHERE CO.OrderType = 6481 -- 6481 (Lab)                                                                       
								AND CO.OrderingPhysician = R.StaffId
								AND CO.OrderStartDateTime >= CAST(@StartDate AS DATE)
								AND CO.OrderStartDateTime <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE CO.OrderingPhysician = SE.StaffId
										AND SE.MeasureType = 8680
										AND SE.MeasureSubType = 6178
										AND CO.OrderStartDateTime = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CO.OrderStartDateTime = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6178
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0) + IsNULL((
							SELECT count(DISTINCT IR.ImageRecordId)
							FROM dbo.ViewMUCPOEMedicationImageRecords IR
							WHERE IR.CreatedBy = R.UserCode
								AND IR.AssociatedId = 1623 -- Document Codes for 'Labs'                                                                                              
								AND IR.EffectiveDate >= CAST(@StartDate AS DATE)
								AND IR.EffectiveDate <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE IR.EffectiveDate = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6178
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0)
					,R.Numerator = (
						SELECT count(DISTINCT CO.ClientOrderId)
						FROM dbo.ViewMUCPOELabRadio CO
						WHERE CO.OrderType = 6481 -- 6481 (Lab)                                                                                                                  
							AND CO.OrderingPhysician = R.StaffId
							AND CO.OrderStartDateTime >= CAST(@StartDate AS DATE)
							AND CO.OrderStartDateTime <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CO.OrderingPhysician = SE.StaffId
									AND SE.MeasureType = 8680
									AND SE.MeasureSubType = 6178
									AND CO.OrderStartDateTime = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CO.OrderStartDateTime = OE.Dates
									AND OE.MeasureType = 8680
									AND OE.MeasureSubType = 6178
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8680
					AND R.MeasureSubTypeId = 6178 --(CPOE) & (Lab)                                                                           

				UPDATE R
				SET R.Denominator = IsNULL((
							SELECT count(DISTINCT CO.ClientOrderId)
							FROM dbo.ViewMUCPOELabRadio CO
							WHERE CO.OrderType = 6482 -- 6482 (Radiology)                                                                                            
								AND CO.OrderingPhysician = R.StaffId
								AND CO.OrderStartDateTime >= CAST(@StartDate AS DATE)
								AND CO.OrderStartDateTime <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #StaffExclusionDates SE
									WHERE CO.OrderingPhysician = SE.StaffId
										AND SE.MeasureType = 8680
										AND SE.MeasureSubType = 6179
										AND CO.OrderStartDateTime = SE.Dates
									)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE CO.OrderStartDateTime = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6179
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0) + IsNULL((
							SELECT count(DISTINCT IR.ImageRecordId)
							FROM dbo.ViewMUCPOEMedicationImageRecords IR
							WHERE IR.CreatedBy = R.UserCode
								AND IR.AssociatedId IN (
									1616
									,1617
									) -- Document Codes for 'Radiology documents'                                                                                                              
								AND IR.EffectiveDate >= CAST(@StartDate AS DATE)
								AND IR.EffectiveDate <= CAST(@EndDate AS DATE)
								AND NOT EXISTS (
									SELECT 1
									FROM #OrgExclusionDates OE
									WHERE IR.EffectiveDate = OE.Dates
										AND OE.MeasureType = 8680
										AND OE.MeasureSubType = 6179
										AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
									)
							), 0)
					,R.Numerator = (
						SELECT count(DISTINCT CO.ClientOrderId)
						FROM dbo.ViewMUCPOELabRadio CO
						WHERE CO.OrderType = 6482 -- 6482 (Radiology)                                                                                                   
							AND CO.OrderingPhysician = R.StaffId
							--and CO.OrderStatus <> 6510 -- Order discontinued                                                         
							AND CO.OrderStartDateTime >= CAST(@StartDate AS DATE)
							AND CO.OrderStartDateTime <= CAST(@EndDate AS DATE)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CO.OrderingPhysician = SE.StaffId
									AND SE.MeasureType = 8680
									AND SE.MeasureSubType = 6179
									AND CO.OrderStartDateTime = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CO.OrderStartDateTime = OE.Dates
									AND OE.MeasureType = 8680
									AND OE.MeasureSubType = 6179
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8680
					AND R.MeasureSubTypeId = 6179 --(CPOE) & (Radiology)                                                                                                                 
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8698' -- Patient Education                                                                                 
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					) --ACI Transition                                                                                             
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						WHERE S.ClinicianId = R.StaffId
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8698
									AND S.DateOfService = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8698
									AND S.DateOfService = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE S.DateOfService = OE.Dates
									AND OE.MeasureType = 8698
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
							AND S.DateOfService <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						WHERE S.ClinicianId = R.StaffId
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8698
									AND S.DateOfService = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8698
									AND S.DateOfService = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE S.DateOfService = OE.Dates
									AND OE.MeasureType = 8698
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
							--AND NOT EXISTS (                   -- 26-Feb-2017     Gautam                                                                                        
							-- SELECT 1                                                                                      
							-- FROM dbo.Documents D                                                                                                
							-- WHERE D.ServiceId = S.ServiceId                                                                                         
							--  AND D.DocumentCodeId = 115                                                                          
							--  AND isnull(D.RecordDeleted, 'N') = 'N'                                                                                          
							-- )                                                                                                
							AND S.DateOfService <= CAST(@EndDate AS DATE)
							AND EXISTS (
								SELECT 1
								FROM ClientEducationResources CE
								INNER JOIN EducationResources ER ON ER.EducationResourceId = CE.EducationResourceId
								WHERE CE.ClientId = S.ClientId
									AND isnull(CE.RecordDeleted, 'N') = 'N'
									AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
				--AND cast(CE.SharedDate AS DATE) >= CAST(@StartDate AS DATE)                                                                           
				--AND cast(CE.SharedDate AS DATE) <= CAS(@EndDate AS DATE)                                                                                                              
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8698 --8698(Patient Education Resources)                                                                                                              
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8697' --8697(Patient Portal)                                                                                               
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					) --ACI Transition                                                                                         
			BEGIN
				--8697(Patient Portal)                                                                                                                             
				-- Measure1                      
				CREATE TABLE #PatientPortalNumClient (
					ClientId INT
					,DateOfService DATETIME
					,ClinicianId INT
					)

				INSERT INTO #PatientPortalNumClient
				SELECT S.ClientId
					,max(S.DateOfService)
					,S.ClinicianId
				FROM dbo.ViewMUClientServices S
				JOIN #ResultSet R ON S.ClinicianId = R.StaffId
				WHERE (
						@MeaningfulUseStageLevel = 8768
						OR (
							@MeaningfulUseStageLevel IN (
								9476
								,9477
								,9480
								,9481
								)
							AND S.TaxIdentificationNumber = R.Tin
							)
						)
					AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
					AND S.DateOfService <= CAST(@EndDate AS DATE)
				GROUP BY S.ClientId
					,S.ClinicianId

				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						WHERE S.ClinicianId = r.StaffId
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8697
									AND PE.MeasureSubType = 6261
									AND S.DateOfService = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8697
									AND SE.MeasureSubType = 6261
									AND S.DateOfService = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE S.DateOfService = OE.Dates
									AND OE.MeasureType = 8697
									AND OE.MeasureSubType = 6261
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
							AND S.DateOfService <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						(
							SELECT count(DISTINCT S.ClientId)
							FROM #PatientPortalNumClient S
							--INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                                      
							--  AND ISNULL(C.RecordDeleted, 'N') = 'N'                                                    
							-- INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                                                      
							-- INNER JOIN dbo.Locations L ON S.LocationId = L.LocationId                                                      
							WHERE EXISTS (
									SELECT 1
									FROM TransitionOfCareDocuments TD
									JOIN DOCUMENTS D ON D.InProgressDocumentVersionId = TD.DocumentVersionId
										AND isnull(D.RecordDeleted, 'N') = 'N'
										AND D.DocumentCodeId IN (
											1611
											,1644
											,1645
											,1646
											)
									LEFT JOIN Locations L ON TD.LocationId = L.LocationId
									WHERE S.ClientId = D.ClientId
										AND (
											Datediff(hh, S.DateOfService, D.EffectiveDate) < 48
											AND Datediff(hh, cast(S.DateOfService AS DATE), cast(D.EffectiveDate AS DATE)) >= 0
											)
										AND isnull(TD.RecordDeleted, 'N') = 'N'
										AND TD.ProviderId = S.ClinicianId
										AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
										AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
										--AND TD.LocationId IS NOT NULL
										AND (
											ISNULL(TD.LocationId, - 1) = - 1
											OR L.TaxIdentificationNumber = @Tin
											)
									)
								AND S.ClinicianId = r.StaffId
								AND S.DateOfService >= CAST(@StartDate AS DATE)
								AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
							)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8697
					AND R.MeasureSubTypeId = 6261
					--UPDATE R                                                                                                
					--SET R.Denominator = (                                                                                                
					--  SELECT count(DISTINCT S.ClientId)                                                    
					--  FROM dbo.ViewMUClientServices S                                                                                                              
					--  WHERE  S.ClinicianId = r.StaffId                                                                                
					--  AND (@MeaningfulUseStageLevel = 8768 or                                                                                 
					--          (@MeaningfulUseStageLevel in ( 9476 ,9477) and S.TaxIdentificationNumber = R.Tin   ))                           
					--AND NOT EXISTS (                                                                                                
					-- SELECT 1                                                                                                
					-- FROM #ProcedureExclusionDates PE                                                                                                
					-- WHERE S.ProcedureCodeId = PE.ProcedureId                                                              
					--  AND PE.MeasureType = 8697                                    
					--  AND PE.MeasureSubType = 6212                                                                                                
					--  AND S.DateOfService  = PE.Dates                                                                                                
					-- )                                                                                              
					--AND NOT EXISTS (                                                                                                
					-- SELECT 1                                                                    
					-- FROM #StaffExclusionDates SE                                                                                                
					-- WHERE S.ClinicianId = SE.StaffId                                                                                                
					--  AND SE.MeasureType = 8697                           AND SE.MeasureSubType = 6212          
					--  AND S.DateOfService = SE.Dates                          
					-- )                                                                                   
					--AND NOT EXISTS (                                                                                                
					-- SELECT 1                                                                                                
					-- FROM #OrgExclusionDates OE                                                                                                
					-- WHERE S.DateOfService  = OE.Dates                                                                                                
					--  AND OE.MeasureType = 8697                                                                                                
					--  AND OE.MeasureSubType = 6212                                                      
					--  AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                 
					-- )                              
					--AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)                                                                                   
					--AND S.DateOfService  <= CAST(@EndDate AS DATE)                                                                                                
					--  )                           
					-- ,R.Numerator = (                                                                                                
					--  SELECT count(DISTINCT S.ClientId)                                                                      
					--  FROM dbo.Services S                                     
					--  INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                                                             
					--AND ISNULL(C.RecordDeleted, 'N') = 'N'                                                                                                
					--  INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId                                                                              
					--  INNER JOIN dbo.Locations L ON S.LocationId= L.LocationId                                                                                                     
					--  WHERE S.STATUS IN (                                                                          
					-- 71                                                                                                
					-- ,75                                                                                                
					-- ) -- 71 (Show), 75(complete)                                                                                                                      
					--AND isnull(S.RecordDeleted, 'N') = 'N'                                                                                                
					--AND isnull(St.RecordDeleted, 'N') = 'N'                                                                          
					--    AND (@MeaningfulUseStageLevel = 8768   or                                                                                 
					--          (@MeaningfulUseStageLevel in ( 9476 ,9477) and L.TaxIdentificationNumber = R.Tin   ))                                                                                            
					--AND S.ClinicianId = r.StaffId                                                                   
					--AND Isnull(St.NonStaffUser, 'N') = 'Y'                                                                                                
					----AND St.LastVisit IS NOT NULL                                                                                                          
					----AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                                                                                          
					--AND (                    
					-- Datediff(hh, S.DateOfService , St.CreatedDate ) < 48                                                                                                
					-- OR cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)                                                                                             -- )                                                             
					--AND NOT EXISTS (                                                                                                
					-- SELECT 1                                                                                                
					-- FROM #ProcedureExclusionDates PE                                                                                                
					-- WHERE S.ProcedureCodeId = PE.ProcedureId                                                                                                
					--  AND PE.MeasureType = 8697                                                 
					--  AND PE.MeasureSubType = 6212                              
					--  AND CAST(S.DateOfService AS DATE) = PE.Dates                                                                                                
					-- )                                                                                          
					--AND NOT EXISTS (                                                                                                
					-- SELECT 1                                           
					-- FROM #StaffExclusionDates SE                                                    
					-- WHERE S.ClinicianId = SE.StaffId                                                                                                
					--  AND SE.MeasureType = 8697                                                                                                
					--  AND SE.MeasureSubType = 6212                                                                                                
					--  AND CAST(S.DateOfService AS DATE) = SE.Dates                                                                                                
					-- )                                                                                    
					--AND NOT EXISTS (                                                                                                
					-- SELECT 1                                                                                                
					-- FROM #OrgExclusionDates OE                                                                                                
					-- WHERE CAST(S.DateOfService AS DATE) = OE.Dates                                                                                                
					--  AND OE.MeasureType = 8697                                                                   
					--  AND OE.MeasureSubType = 6212                                                                                        
					--  AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'                                                                                                
					-- )                                                                                                
					--AND S.DateOfService >= CAST(@StartDate AS DATE)                                                                                                
					--AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)                      
					--  )                                                                                                
					--FROM #ResultSet R                 
					--WHERE R.MeasureTypeId = 8697                                                                                                
					-- AND R.MeasureSubTypeId = 6212                        
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8703'
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						WHERE S.ClinicianId = r.StaffId
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8703
									AND S.DateOfService = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8703
									AND S.DateOfService = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE S.DateOfService = OE.Dates
									AND OE.MeasureType = 8703
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
							AND S.DateOfService <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.Services S
						INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId
							AND ISNULL(C.RecordDeleted, 'N') = 'N'
						INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId
						INNER JOIN dbo.Locations L ON S.LocationId = L.LocationId
						WHERE S.STATUS IN (
								71
								,75
								) -- 71 (Show), 75(complete)                                                                                           
							AND isnull(S.RecordDeleted, 'N') = 'N'
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND L.TaxIdentificationNumber = R.Tin
									)
								)
							AND isnull(St.RecordDeleted, 'N') = 'N'
							AND S.DateOfService >= CAST(@StartDate AS DATE)
							AND cast(S.DateOfService AS DATE) <= CAST(@EndDate AS DATE)
							AND S.ClinicianId = r.StaffId
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
							AND EXISTS (
								SELECT 1
								FROM dbo.Messages M
								WHERE M.ClientId = S.ClientId
									AND M.FromStaffId = S.clinicianid
									AND M.ToStaffId = St.StaffId
									--As per functionality on UI , User can delete the messages. so it will not count for Numerator     
									--AND isnull(M.RecordDeleted, 'N') = 'N'      
									--AND CAST(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)                                                      
									--AND CAST(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)                                                      
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8703
									AND CAST(S.DateOfService AS DATE) = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8703
									AND CAST(S.DateOfService AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(S.DateOfService AS DATE) = OE.Dates
									AND OE.MeasureType = 8703
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8703
			END

			--Medication Reconciliation 8699                                                                 
			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8699'
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
			BEGIN
				CREATE TABLE #Reconciliation (
					ClientId INT
					,TransitionDate DATETIME
					,DocumentVersionId INT
					,StaffId INT
					,LocationId INT
					,TaxIdentificationNumber VARCHAR(100)
					)

				CREATE TABLE #NumReconciliation (
					ClientId INT
					,ReconciliationDate DATETIME
					,DocumentVersionId INT
					)

				INSERT INTO #Reconciliation
				SELECT t.ClientId
					,t.TransitionDate
					,t.DocumentVersionId
					,t.RecipientPhysicianId
					,t.LocationId
					,t.TaxIdentificationNumber
				FROM (
					SELECT S.ClientId
						,S.TransferDate AS TransitionDate
						,S.DocumentVersionId
						,S.RecipientPhysicianId
						,S.LocationId
						,L.TaxIdentificationNumber
					FROM dbo.ViewMUClientCCDs S
					JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId
					LEFT JOIN Locations L ON S.LocationId = L.LocationId
					WHERE (
							g.GlobalCodeId IN (
								SELECT GlobalCodeId
								FROM GlobalCodes
								WHERE Category = 'XCCDType'
									AND CodeName IN (
										'Transitioned'
										,'Referred'
										,'New'
										)
								)
							)
						AND (
							S.LocationId IS NOT NULL
							AND (
								S.LocationId = - 1
								OR L.TaxIdentificationNumber = @Tin
								)
							)
						AND CAST(S.TransferDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(S.TransferDate AS DATE) <= CAST(@EndDate AS DATE)
						--AND S.RecipientPhysicianId = R.StaffId                                          
					) AS t

				UPDATE R
				SET R.Denominator = isnull((
							SELECT count(R1.ClientId)
							FROM #Reconciliation R1
							WHERE R1.StaffId = R.StaffId
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8699

				UPDATE R
				SET R.Numerator = isnull((
							SELECT count(C.ClientId)
							FROM dbo.Clients C
							INNER JOIN #Reconciliation R1 ON R1.ClientId = C.ClientId
							WHERE isnull(C.RecordDeleted, 'N') = 'N'
								AND R1.StaffId = R.StaffId
								AND CAST(R1.TransitionDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(R1.TransitionDate AS DATE) <= CAST(@EndDate AS DATE)
								AND (
									R1.LocationId IS NOT NULL
									AND (
										R1.LocationId = - 1
										OR R1.TaxIdentificationNumber = @Tin
										)
									)
								AND (
									(
										@MeaningfulUseStageLevel IN (
											9476
											,9477
											)
										AND EXISTS (
											SELECT 1
											FROM ClientMedicationReconciliations CM
											WHERE CM.DocumentVersionId = R1.DocumentVersionId
												AND CM.ReconciliationTypeId = 8793 --8793 Medications                                      
												AND isnull(CM.RecordDeleted, 'N') = 'N'
												AND CM.ReconciliationReasonId = (
													SELECT TOP 1 GC.GlobalCodeId
													FROM globalcodes GC
													WHERE GC.category = 'MEDRECONCILIATION'
														AND GC.codename = 'Transition'
														AND isnull(GC.RecordDeleted, 'N') = 'N'
													)
											)
										AND EXISTS (
											SELECT 1
											FROM ClientMedicationReconciliations CM
											WHERE CM.DocumentVersionId = R1.DocumentVersionId
												AND CM.ReconciliationTypeId = 8794 -- 8794 Allergy                                    
												AND isnull(CM.RecordDeleted, 'N') = 'N'
												AND CM.ReconciliationReasonId = (
													SELECT TOP 1 GC.GlobalCodeId
													FROM globalcodes GC
													WHERE GC.category = 'MEDRECONCILIATION'
														AND GC.codename = 'Transition'
														AND isnull(GC.RecordDeleted, 'N') = 'N'
													)
											)
										AND EXISTS (
											SELECT 1
											FROM ClientMedicationReconciliations CM
											WHERE CM.DocumentVersionId = R1.DocumentVersionId
												AND CM.ReconciliationTypeId = 8795 --   8795 problem                                     
												AND isnull(CM.RecordDeleted, 'N') = 'N'
												AND CM.ReconciliationReasonId = (
													SELECT TOP 1 GC.GlobalCodeId
													FROM globalcodes GC
													WHERE GC.category = 'MEDRECONCILIATION'
														AND GC.codename = 'Transition'
														AND isnull(GC.RecordDeleted, 'N') = 'N'
													)
											)
										)
									OR (
										@MeaningfulUseStageLevel IN (
											9480
											,9481
											)
										AND EXISTS (
											SELECT 1
											FROM ClientMedicationReconciliations CM
											WHERE CM.DocumentVersionId = R1.DocumentVersionId
												AND CM.ReconciliationTypeId = 8793 --8793 Medications                                      
												AND isnull(CM.RecordDeleted, 'N') = 'N'
												AND CM.ReconciliationReasonId = (
													SELECT TOP 1 GC.GlobalCodeId
													FROM globalcodes GC
													WHERE GC.category = 'MEDRECONCILIATION'
														AND GC.codename = 'Transition'
														AND isnull(GC.RecordDeleted, 'N') = 'N'
													)
											)
										)
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8699
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8700'
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
			BEGIN
				--Measure1                           
				UPDATE R
				SET R.Denominator = isnull((
							SELECT count(DISTINCT r1.ClientPrimaryCareExternalReferralId)
							FROM ClientPrimaryCareExternalReferrals r1
							--     left join ClientDisclosures c on r1.ClientId = c.ClientId                        
							-- and isnull(C.RecordDeleted, 'N') = 'N'    and C.DisclosureStatus= 10573                         
							--left join ClientDisclosedRecords cd on cd.ClientDisclosureId = c.ClientDisclosureId                        
							-- and isnull(CD.RecordDeleted, 'N') = 'N'                           
							--and r1.ReferringProviderId = t.ProviderId and isnull(t.RecordDeleted, 'N') = 'N'                           
							--left join Locations l on l.Locationid = t.LocationId and isnull(l.RecordDeleted, 'N') = 'N'                           
							WHERE
								--(                                                      
								-- cast(C.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                     
								-- AND cast(C.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                                                      
								-- )                            
								-- and                          
								cast(r1.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(r1.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
								AND r1.ReferringProviderId = R.StaffId
								--AND (      
								-- @Tin = 'NA'      
								-- OR cast(r1.ReasonComment AS VARCHAR(10)) = @Tin      
								-- )      
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8700
					AND R.MeasureSubTypeId = 6213

				UPDATE R
				SET R.Numerator = isnull((
							SELECT count(DISTINCT cd.ClientDisclosureId)
							FROM ClientPrimaryCareExternalReferrals r1
							JOIN ClientDisclosures c ON r1.ClientId = c.ClientId
								AND isnull(C.RecordDeleted, 'N') = 'N'
								--AND C.DisclosureStatus = 10573
								AND EXISTS (
									SELECT 1
									FROM dbo.ssf_RecodeValuesCurrent('DISCLOSURESTATUESFORMU3SOCMEASURE') AS cd
									WHERE cd.IntegerCodeId = C.DisclosureStatus
									)
							JOIN ClientDisclosedRecords cd ON cd.ClientDisclosureId = c.ClientDisclosureId
								AND isnull(CD.RecordDeleted, 'N') = 'N'
							JOIN Documents d ON d.DocumentId = cd.DocumentId
								AND isnull(D.RecordDeleted, 'N') = 'N'
							JOIN TransitionOfCareDocuments t ON t.DocumentVersionId = d.CurrentDocumentVersionId
								AND r1.ReferringProviderId = t.ProviderId
								AND isnull(t.RecordDeleted, 'N') = 'N'
							LEFT JOIN Locations l ON l.Locationid = t.LocationId
								AND isnull(l.RecordDeleted, 'N') = 'N'
							WHERE D.DocumentCodeId IN (
									1611
									,1644
									,1645
									,1646
									) -- Summary of Care                        
								AND D.STATUS = 22
								--and                                     
								--(                                                      
								-- cast(C.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                                                      
								-- AND cast(C.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                                                      
								-- )                            
								AND cast(r1.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(r1.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
								AND r1.ReferringProviderId = R.StaffId
								AND t.LocationId IS NOT NULL
								AND (
									t.LocationId = - 1
									OR l.TaxIdentificationNumber = @Tin
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8700
					AND R.MeasureSubTypeId = 6213
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8710' --8710(View, Download, Transmit)                                                                                               
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					) --ACI Transition                                                        
			BEGIN
				-- Measure1                                                                                                              
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						WHERE S.ClinicianId = r.StaffId
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8710
									AND S.DateOfService = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8710
									AND S.DateOfService = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE S.DateOfService = OE.Dates
									AND OE.MeasureType = 8710
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
							AND S.DateOfService <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId
						WHERE S.DateOfService >= CAST(@StartDate AS DATE)
							AND S.DateOfService <= CAST(@EndDate AS DATE)
							AND isnull(St.RecordDeleted, 'N') = 'N'
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							----   AND St.LastVisit IS NOT NULL                                                            
							----AND (                                                            
							---- cast(St.LastVisit AS DATE) >= CAST(@StartDate AS DATE)                                                            
							---- AND St.LastVisit IS NOT NULL                                                            
							---- AND cast(St.LastVisit AS DATE) <= CAST(@EndDate AS DATE)                                                            
							---- )                                                              
							AND EXISTS (
								SELECT 1
								FROM TransitionOfCareDocuments TD
								JOIN DOCUMENTS D ON D.InProgressDocumentVersionId = TD.DocumentVersionId
									AND isnull(D.RecordDeleted, 'N') = 'N'
									AND D.DocumentCodeId IN (
										1611
										,1644
										,1645
										,1646
										)
								INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
									-- check created date between date                                                            
									AND SCA.StaffId = ST.StaffId
									AND isnull(SCA.RecordDeleted, 'N') = 'N'
								LEFT JOIN Locations L ON TD.LocationId = L.LocationId
								WHERE S.ClientId = D.ClientId
									AND isnull(TD.RecordDeleted, 'N') = 'N'
									--and TD.ProviderId= r.StaffId                                                   
									AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
									AND (
										TD.LocationId IS NOT NULL
										AND (
											TD.LocationId = - 1
											OR L.TaxIdentificationNumber = @Tin
											)
										)
								)
							AND S.ClinicianId = r.StaffId
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
							--AND St.LastVisit IS NOT NULL                                                             
							--AND cast(St.CreatedDate AS DATE) <= CAST(@EndDate AS DATE)                                                      
							--AND (                                                      
							-- Datediff(hh, S.DateOfService, St.CreatedDate) < 48                                                      
							-- OR cast(St.CreatedDate AS DATE) <= cast(S.DateOfService AS DATE)                                                      
							-- )                                                      
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 8710
									AND CAST(S.DateOfService AS DATE) = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 8710
									AND CAST(S.DateOfService AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(S.DateOfService AS DATE) = OE.Dates
									AND OE.MeasureType = 8710
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8710
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '9478' --Patient Generated Health Data                                                                                    
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUClientServices S
						WHERE S.ClinicianId = R.StaffId
							AND (
								@MeaningfulUseStageLevel = 8768
								OR (
									@MeaningfulUseStageLevel IN (
										9476
										,9477
										,9480
										,9481
										)
									AND S.TaxIdentificationNumber = R.Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #ProcedureExclusionDates PE
								WHERE S.ProcedureCodeId = PE.ProcedureId
									AND PE.MeasureType = 9478
									AND S.DateOfService = PE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE S.ClinicianId = SE.StaffId
									AND SE.MeasureType = 9478
									AND S.DateOfService = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE S.DateOfService = OE.Dates
									AND OE.MeasureType = 9478
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
							AND S.DateOfService <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						isnull((
								SELECT count(DISTINCT S.ClientId)
								FROM dbo.ViewMUClientServices S
								WHERE S.ClinicianId = R.StaffId
									AND (
										@MeaningfulUseStageLevel = 8768
										OR (
											@MeaningfulUseStageLevel IN (
												9476
												,9477
												,9480
												,9481
												)
											AND S.TaxIdentificationNumber = R.Tin
											)
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #ProcedureExclusionDates PE
										WHERE S.ProcedureCodeId = PE.ProcedureId
											AND PE.MeasureType = 9478
											AND S.DateOfService = PE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #StaffExclusionDates SE
										WHERE S.ClinicianId = SE.StaffId
											AND SE.MeasureType = 9478
											AND S.DateOfService = SE.Dates
										)
									AND NOT EXISTS (
										SELECT 1
										FROM #OrgExclusionDates OE
										WHERE S.DateOfService = OE.Dates
											AND OE.MeasureType = 9478
											AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
										)
									AND S.DateOfServiceActual >= CAST(@StartDate AS DATE)
									--AND NOT EXISTS (                   -- 26-Feb-2017     Gautam                                                                     
									-- SELECT 1                                                                                                
									-- FROM dbo.Documents D                                                                                                
									-- WHERE D.ServiceId = S.ServiceId                                                                                                
									--  AND D.DocumentCodeId = 115                                                                                                
									--  AND isnull(D.RecordDeleted, 'N') = 'N'                        
									-- )                                                                                                
									AND S.DateOfService <= CAST(@EndDate AS DATE)
									AND 
									--( EXISTS (
									--	SELECT 1
									--	FROM ImageRecords IR
									--	JOIN Staff S1 ON IR.ScannedBy = S1.StaffId
									--	WHERE IR.ClientId = S.ClientId
									--		AND isnull(IR.RecordDeleted, 'N') = 'N'
									--		AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
									--		AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
									--	)
									-- or										
										EXISTS (                          
										SELECT 1                          
										from ImageRecords IR join Staff S1 on IR.ScannedBy= S1.StaffId                        
										WHERE IR.ClientId = S.ClientId 
										 AND IR.ClientId = S1.TempClientId      
										 AND Isnull(S1.NonStaffUser, 'N') = 'Y'                    
										 AND isnull(IR.RecordDeleted, 'N') = 'N'                       
										 AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)                                                                                
										AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                         
										) 
									 --)
								), 0)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 9478
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '9479' --Receive and Incorporate                                                                                        
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
			BEGIN
				UPDATE R
				SET R.Denominator = isnull((
							SELECT count(DISTINCT S.ClientCCDId)
							FROM dbo.ViewMUClientCCDs S
							JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId
							LEFT JOIN Locations L ON S.LocationId = L.LocationId
							WHERE S.TransferDate >= CAST(@StartDate AS DATE)
								AND S.TransferDate <= CAST(@EndDate AS DATE)
								AND (
									g.GlobalCodeId IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE Category = 'XCCDType'
											AND CodeName IN (
												'Transitioned'
												,'Referred'
												,'New'
												)
										)
									)
								AND (
									S.LocationId IS NOT NULL
									AND (
										S.LocationId = - 1
										OR L.TaxIdentificationNumber = @Tin
										)
									)
								AND S.RecipientPhysicianId = R.StaffId
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 9479

				UPDATE R
				SET R.Numerator = isnull((
							SELECT count(DISTINCT S.ClientCCDId)
							FROM dbo.ViewMUClientCCDs S
							JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId
							LEFT JOIN Locations L ON S.LocationId = L.LocationId
							WHERE S.TransferDate >= CAST(@StartDate AS DATE)
								AND S.TransferDate <= CAST(@EndDate AS DATE)
								AND (
									g.GlobalCodeId IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE Category = 'XCCDType'
											AND CodeName IN (
												'Transitioned'
												,'Referred'
												,'New'
												)
										)
									)
								AND (
									S.LocationId IS NOT NULL
									AND (
										S.LocationId = - 1
										OR L.TaxIdentificationNumber = @Tin
										)
									)
								AND S.RecipientPhysicianId = R.StaffId
								AND ISNULL(S.Incorporated, 'N') = 'Y'
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 9479
			END
		END

		IF @InPatient = 1
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '9478'
					)
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						WHERE S.ClinicianId = R.StaffId
							AND (
								S.AdmitDate >= CAST(@StartDate AS DATE)
								AND S.AdmitDate <= CAST(@EndDate AS DATE)
								)
							AND (
								@Tin = 'NA'
								OR EXISTS (
									SELECT 1
									FROM ClientPrograms CP
									JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId
										AND isnull(CP.RecordDeleted, 'N') = 'N'
										AND isnull(PL.RecordDeleted, 'N') = 'N'
										AND CP.PrimaryAssignment = 'Y'
									JOIN Locations L ON PL.LocationId = L.LocationId
									WHERE CP.ClientId = S.ClientId
										AND L.TaxIdentificationNumber = @Tin
									)
								)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						WHERE S.ClinicianId = R.StaffId
							AND (
								S.AdmitDate >= CAST(@StartDate AS DATE)
								AND S.AdmitDate <= CAST(@EndDate AS DATE)
								)
							AND (
								@Tin = 'NA'
								OR EXISTS (
									SELECT 1
									FROM ClientPrograms CP
									JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId
										AND isnull(CP.RecordDeleted, 'N') = 'N'
										AND isnull(PL.RecordDeleted, 'N') = 'N'
										AND CP.PrimaryAssignment = 'Y'
									JOIN Locations L ON PL.LocationId = L.LocationId
									WHERE CP.ClientId = S.ClientId
										AND L.TaxIdentificationNumber = @Tin
									)
								)
							AND EXISTS (
								SELECT 1
								FROM ImageRecords IR
								JOIN Staff S1 ON IR.ScannedBy = S1.StaffId
								WHERE IR.ClientId = S.ClientId
									AND isnull(IR.RecordDeleted, 'N') = 'N'
									AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 9478
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8698'
					)
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						WHERE
							--S.ClinicianId = R.StaffId                              
							-- AND                                               
							(
								S.AdmitDate >= CAST(@StartDate AS DATE)
								AND S.AdmitDate <= CAST(@EndDate AS DATE)
								)
							AND (
								@Tin = 'NA'
								OR EXISTS (
									SELECT 1
									FROM ClientPrograms CP
									JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId
										AND isnull(CP.RecordDeleted, 'N') = 'N'
										AND isnull(PL.RecordDeleted, 'N') = 'N'
										AND CP.PrimaryAssignment = 'Y'
									JOIN Locations L ON PL.LocationId = L.LocationId
									WHERE CP.ClientId = S.ClientId
										AND L.TaxIdentificationNumber = @Tin
									)
								)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						WHERE
							--S.ClinicianId = R.StaffId                                                      
							-- AND                                               
							(
								S.AdmitDate >= CAST(@StartDate AS DATE)
								AND S.AdmitDate <= CAST(@EndDate AS DATE)
								)
							AND (
								@Tin = 'NA'
								OR EXISTS (
									SELECT 1
									FROM ClientPrograms CP
									JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId
										AND isnull(CP.RecordDeleted, 'N') = 'N'
										AND isnull(PL.RecordDeleted, 'N') = 'N'
										AND CP.PrimaryAssignment = 'Y'
									JOIN Locations L ON PL.LocationId = L.LocationId
									WHERE CP.ClientId = S.ClientId
										AND L.TaxIdentificationNumber = @Tin
									)
								)
							AND NOT EXISTS (
								SELECT 1
								FROM Documents D
								WHERE D.ClientId = S.ClientId
									AND D.DocumentCodeId = 115
									AND isnull(D.RecordDeleted, 'N') = 'N'
								)
							AND EXISTS (
								SELECT 1
								FROM ClientEducationResources CE
								WHERE CE.ClientId = S.ClientId
									AND isnull(CE.RecordDeleted, 'N') = 'N'
								)
						)
				--AND cast(CE.SharedDate AS DATE) >= CAST(@StartDate AS DATE)                                                                                                            
				--AND cast(CE.SharedDate AS DATE) <= CAST(@EndDate AS DATE)                                                                                                            
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8698
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8683'
					)
				AND @InPatient = 1
			BEGIN
				CREATE TABLE #EPRESRESULT (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					)

				INSERT INTO #EPRESRESULT (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
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
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = CI.ClientId
						WHERE C.ClientId = CI.ClientId
							AND CI.STATUS <> 4981
							AND isnull(CI.RecordDeleted, 'N') = 'N'
							AND (
								cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)

				--AND EXISTS (                              
				-- SELECT 1                              
				-- FROM dbo.MDDrugs AS md                              
				-- WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId                              
				--  AND isnull(md.RecordDeleted, 'N') = 'N'                              
				--  AND md.DEACode = 0                              
				-- )                              
				CREATE TABLE #EPRESRESULT1 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					)

				INSERT INTO #EPRESRESULT1 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
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
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cmsa.Method = 'E'
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = CI.ClientId
						WHERE C.ClientId = CI.ClientId
							AND CI.STATUS <> 4981
							AND isnull(CI.RecordDeleted, 'N') = 'N'
							AND (
								cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
					AND EXISTS (
						SELECT 1
						FROM SureScriptsEligibilityResponse SSER
						WHERE SSER.ClientId = CMS.ClientId
							AND isnull(SSER.RecordDeleted, 'N') = 'N'
							--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
							AND (
								SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
								AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
								)
						)

				--AND EXISTS (                              
				-- SELECT 1                              
				-- FROM dbo.MDDrugs AS md                              
				-- WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId                              
				--  AND isnull(md.RecordDeleted, 'N') = 'N'                              
				--  AND md.DEACode = 0                              
				-- )                              
				UPDATE R
				SET R.Denominator = (
						SELECT count(*)
						FROM #EPRESRESULT
						)
					,R.Numerator = (
						SELECT count(*)
						FROM #EPRESRESULT1
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8683
					AND R.MeasureSubTypeId = 6266

				CREATE TABLE #EPRESRESULT2 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					)

				INSERT INTO #EPRESRESULT2 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
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
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = CI.ClientId
						WHERE C.ClientId = CI.ClientId
							AND CI.STATUS <> 4981
							AND isnull(CI.RecordDeleted, 'N') = 'N'
							AND (
								cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
					AND EXISTS (
						SELECT 1
						FROM dbo.MDDrugs AS md
						WHERE md.ClinicalFormulationId = mm.ClinicalFormulationId
							AND isnull(md.RecordDeleted, 'N') = 'N'
							AND md.DEACode = 0
						)

				CREATE TABLE #EPRESRESULT3 (
					ClientId INT
					,ClientName VARCHAR(250)
					,PrescribedDate DATETIME
					,MedicationName VARCHAR(max)
					,ProviderName VARCHAR(250)
					,AdmitDate DATETIME
					,DischargedDate DATETIME
					,ClientMedicationScriptId INT
					,ETransmitted VARCHAR(20)
					)

				INSERT INTO #EPRESRESULT3 (
					ClientId
					,ClientName
					,PrescribedDate
					,MedicationName
					,ProviderName
					,ClientMedicationScriptId
					,ETransmitted
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,cms.OrderDate AS PrescribedDate
					,MD.MedicationName
					,(IsNull(S.LastName, '') + coalesce(' , ' + S.FirstName, '')) AS ProviderName
					,cmsd.ClientMedicationScriptId
					,CASE 
						WHEN (cmsa.Method = 'E')
							THEN 'Yes'
						ELSE 'No'
						END + ' / ' + CASE 
						WHEN (SSER.ClientId = cms.ClientId)
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
				INNER JOIN dbo.MDMedications AS mm ON mm.MedicationId = cmi.StrengthId
					AND isnull(mm.RecordDeleted, 'N') = 'N'
				INNER JOIN MDMedicationNames MD ON mm.MedicationNameId = MD.MedicationNameId
				INNER JOIN ClientMedications CM ON CM.ClientId = cms.ClientId
					AND isnull(CM.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.Clients C ON cms.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff S ON S.StaffId = cms.OrderingPrescriberId
				LEFT JOIN SureScriptsEligibilityResponse SSER ON SSER.ClientId = C.ClientId
					AND isnull(SSER.RecordDeleted, 'N') = 'N'
					--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
					AND (
						SSER.ResponseDate >= DATEADD(dd, - 3, CAST(@StartDate AS DATE))
						AND SSER.ResponseDate <= DATEADD(dd, 3, CAST(@EndDate AS DATE))
						)
				WHERE cms.OrderDate >= CAST(@StartDate AS DATE)
					AND isnull(cmsa.RecordDeleted, 'N') = 'N'
					AND cmsa.Method = 'E'
					AND cast(cms.OrderDate AS DATE) <= CAST(@EndDate AS DATE)
					AND EXISTS (
						SELECT 1
						FROM ClientInpatientVisits CI
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = CI.ClientId
						WHERE C.ClientId = CI.ClientId
							AND CI.STATUS <> 4981
							AND isnull(CI.RecordDeleted, 'N') = 'N'
							AND (
								cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
					AND EXISTS (
						SELECT 1
						FROM SureScriptsEligibilityResponse SSER
						WHERE SSER.ClientId = CMS.ClientId
							AND isnull(SSER.RecordDeleted, 'N') = 'N'
							--AND SSER.ResponseDate > DATEADD(dd, - 3, getdate())                              
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

				UPDATE R
				SET R.Denominator = (
						SELECT count(*)
						FROM #EPRESRESULT2
						)
					,R.Numerator = (
						SELECT count(*)
						FROM #EPRESRESULT3
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8683
					AND R.MeasureSubTypeId = 6267
			END

			IF @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
				AND @InPatient = 1 --    'Stage2 - Modified'                                               
				AND EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8697'
					)
			BEGIN
				--Measure2               
				CREATE TABLE #PatientPortalNumClient1 (
					ClientId INT
					,DischargedDate DATETIME
					,ClinicianId INT
					)

				INSERT INTO #PatientPortalNumClient1
				SELECT S.ClientId
					,max(S.DischargedDate)
					,S.ClinicianId
				FROM dbo.ClientInpatientVisits S
				INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
				INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId
				INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId
					AND CP.ClientId = S.ClientId
				INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId
				WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                                        
					AND isnull(S.RecordDeleted, 'N') = 'N'
					AND isnull(BA.RecordDeleted, 'N') = 'N'
					AND isnull(CP.RecordDeleted, 'N') = 'N'
					AND isnull(C.RecordDeleted, 'N') = 'N'
					AND S.DischargedDate IS NOT NULL
					AND S.DischargedDate >= CAST(@StartDate AS DATE)
					AND S.DischargedDate <= CAST(@EndDate AS DATE)
				GROUP BY S.ClientId
					,S.ClinicianId

				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPPatientPortal S
						----       LEFT JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                                                                                
						----AND Isnull(St.NonStaffUser, 'N') = 'Y'                                                                                       
						----AND isnull(St.RecordDeleted, 'N') = 'N'                                                              
						----    LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = S.DocumentId                                                                     
						----AND SCA.StaffId = ST.StaffId                                                                                                
						----AND isnull(SCA.RecordDeleted, 'N') = 'N'                                                                                                            
						WHERE S.DischargedDate >= CAST(@StartDate AS DATE)
							AND S.DischargedDate <= CAST(@EndDate AS DATE)
							--AND S.ClinicianId = r.StaffId                                                
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM #PatientPortalNumClient1 S
						JOIN DOCUMENTS D ON S.ClientId = D.ClientId
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND D.DocumentCodeId IN (
								1611
								,1644
								,1645
								,1646
								)
						JOIN TransitionOfCareDocuments TD ON D.InProgressDocumentVersionId = TD.DocumentVersionId
						INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId
						WHERE S.DischargedDate >= CAST(@StartDate AS DATE)
							AND S.DischargedDate <= CAST(@EndDate AS DATE)
							AND (
								Datediff(hh, S.DischargedDate, D.EffectiveDate) < 36
								AND Datediff(hh, S.DischargedDate, D.EffectiveDate) > 0
								)
							AND isnull(TD.RecordDeleted, 'N') = 'N'
							AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(St.RecordDeleted, 'N') = 'N'
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8697
					AND R.MeasureSubTypeId = 6261
					--    UPDATE R                                                      
					--    SET R.Target = 'N/A'                                                      
					--     ,R.Result = CASE                            
					--      WHEN isnull(R.Denominator, 0) > 0                                                      
					--    THEN CASE                                                       
					--         WHEN EXISTS (                                                      
					--           SELECT 1                                                      
					--           FROM dbo.ViewMUIPPatientPortal S                                                      
					--           INNER JOIN dbo.Staff St ON St.TempClientId = S.ClientId                                                      
					--           INNER JOIN dbo.StaffClientAccess SCA ON SCA.ObjectId = S.DocumentId                                                      
					--            AND SCA.StaffId = ST.StaffId                                                      
					--            AND isnull(SCA.RecordDeleted, 'N') = 'N'                                                   
					--           WHERE S.DischargedDate >= CAST(@StartDate AS DATE)                                                      
					--            AND S.DischargedDate <= CAST(@EndDate AS DATE)                                                      
					--           )                                                      
					--          THEN '<span style="color:green">Met</span>'                                                      
					--         ELSE '<span style="color:red">Not Met</span>'                                  
					--         END                                                      
					--ELSE '<span style="color:red">Not Met</span>'                                                      
					--      END                                                   
					--    FROM #ResultSet R                                                      
					--    WHERE R.MeasureTypeId = 8697                                                     AND R.MeasureSubTypeId = 6261                                                      
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8710' --8710(View, Download, Transmit)                                                                                               
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					) --ACI Transition                                                       
				AND @InPatient = 1
			BEGIN
				-- Measure1                                                                                                              
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						WHERE S.ClinicianId = r.StaffId
							AND (
								@Tin = 'NA'
								OR EXISTS (
									SELECT 1
									FROM ClientPrograms CP
									JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId
										AND isnull(CP.RecordDeleted, 'N') = 'N'
										AND isnull(PL.RecordDeleted, 'N') = 'N'
										AND CP.PrimaryAssignment = 'Y'
									JOIN Locations L ON PL.LocationId = L.LocationId
									WHERE CP.ClientId = S.ClientId
										AND L.TaxIdentificationNumber = @Tin
									)
								)
							AND S.DischargedDate >= CAST(@StartDate AS DATE)
							AND S.DischargedDate <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId
						WHERE S.DischargedDate >= CAST(@StartDate AS DATE)
							AND S.DischargedDate <= CAST(@EndDate AS DATE)
							AND (
								@Tin = 'NA'
								OR EXISTS (
									SELECT 1
									FROM ClientPrograms CP
									JOIN ProgramLocations PL ON CP.ProgramId = PL.ProgramId
										AND isnull(CP.RecordDeleted, 'N') = 'N'
										AND isnull(PL.RecordDeleted, 'N') = 'N'
										AND CP.PrimaryAssignment = 'Y'
									JOIN Locations L ON PL.LocationId = L.LocationId
									WHERE CP.ClientId = S.ClientId
										AND L.TaxIdentificationNumber = @Tin
									)
								)
							AND isnull(St.RecordDeleted, 'N') = 'N'
							AND EXISTS (
								SELECT 1
								FROM TransitionOfCareDocuments TD
								JOIN DOCUMENTS D ON D.InProgressDocumentVersionId = TD.DocumentVersionId
									AND isnull(D.RecordDeleted, 'N') = 'N'
									AND D.DocumentCodeId IN (
										1611
										,1644
										,1645
										,1646
										)
								INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
									-- check created date between date                                                            
									AND SCA.StaffId = ST.StaffId
									AND isnull(SCA.RecordDeleted, 'N') = 'N'
								WHERE S.ClientId = D.ClientId
									AND isnull(TD.RecordDeleted, 'N') = 'N'
									AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
								)
							AND S.ClinicianId = r.StaffId
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
						)
				--AND St.LastVisit IS NOT NULL                                                                                                          
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8710
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8700' --8700(TOC)                                                                                               
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					) --ACI Transition                                                              
				AND @InPatient = 1
			BEGIN
				--CREATE TABLE #RES7 (                                                      
				-- ClientId INT                                                      
				-- ,ProviderName VARCHAR(250)                                     
				-- ,EffectiveDate VARCHAR(100)                                                      
				-- ,DateExported VARCHAR(100)                                                      
				-- ,DocumentVersionId INT           ,ClinicianId INT                                                      
				-- )                                                      
				--INSERT INTO #RES7 (                                                      
				-- ClientId                                                      
				-- ,ProviderName                                                      
				-- ,EffectiveDate     
				-- ,DateExported                                                      
				-- ,DocumentVersionId                                                      
				-- ,ClinicianId                                                      
				-- )                                                      
				--SELECT  D.ClientId                                                      
				-- ,D.ProviderName                                                      
				-- ,D.EffectiveDate                                                      
				-- ,D.ExportedDate                                                      
				-- ,D.CurrentDocumentVersionId                                                      
				-- ,D.ClinicianId                                                      
				--FROM ViewMUIPTransitionOfCare D                                                      
				--WHERE (                                                      
				--  D.AdmitDate >= CAST(@StartDate AS DATE)                                                      
				--  AND D.AdmitDate <= CAST(@EndDate AS DATE)                                                      
				--  )                                              
				-- AND D.EffectiveDate >= CAST(@StartDate AS DATE)                                          
				-- AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)                                                      
				--INSERT INTO #RES7 (                                                      
				-- ClientId                                                      
				-- ,ProviderName                                                  
				-- ,EffectiveDate                                                      
				-- ,DateExported                                                      
				-- ,DocumentVersionId                                                      
				-- ,ClinicianId                                                      
				-- )                                                      
				--SELECT DISTINCT CO.ClientId                                                      
				-- ,'' AS ProviderName                                    
				-- ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                                          
				-- ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                               
				-- ,0 --,ISNULL(D.CurrentDocumentVersionId,0)                                                            
				-- ,OrderingPhysician                                             
				--FROM ClientOrders CO                                                      
				--INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId                                                      
				-- AND isnull(S.RecordDeleted, 'N') = 'N'                                                      
				--INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                                      
				--INNER JOIN Orders OS ON CO.OrderId = OS.OrderId                                                      
				-- AND isnull(OS.RecordDeleted, 'N') = 'N'                                                      
				--INNER JOIN Clients C ON S.ClientId = C.ClientId                                                      
				-- AND isnull(C.RecordDeleted, 'N') = 'N'                                                      
				--WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                               
				-- AND OS.OrderId = 148 -- Referral/Transition Request                                                  
				-- --and CO.OrderStatus <> 6510 -- Order discontinued                                                                        
				-- AND (                                                      
				--  cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                                      
				--  AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                             
				--  )                                                      
				-- AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)                                                      
				-- AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)                                                      
				--INSERT INTO #RES7 (                                                      
				-- ClientId                                                      
				-- ,ProviderName                                                      
				-- ,EffectiveDate                                                      
				-- ,DateExported                                                      
				-- ,DocumentVersionId                                                      
				-- ,ClinicianId                                           
				-- )                                                      
				--SELECT DISTINCT CO.ClientId                                                      
				-- ,'' AS ProviderName                                                      
				-- ,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                                                                          
				-- ,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                                                                          
				-- ,0 --,ISNULL(D.CurrentDocumentVersionId,0)                                                          
				-- ,CO.ReferringProviderId                                                      
				--FROM ClientPrimaryCareExternalReferrals CO                                                      
				--INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId                                                      
				-- AND isnull(S.RecordDeleted, 'N') = 'N'                                            
				-- AND S.ClientId NOT IN (                                                      
				--  SELECT ClientId                                                      
				--  FROM #RES7                                                      
				--  )                                                      
				--INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                                      
				--INNER JOIN Clients C ON S.ClientId = C.ClientId                                                      
				-- AND isnull(C.RecordDeleted, 'N') = 'N'                                                      
				--WHERE isnull(CO.RecordDeleted, 'N') = 'N'                                                      
				-- --and CO.OrderStatus <> 6510 -- Order discontinued                                                                            
				-- AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)                                                      
				-- AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)                                                      
				-- AND (                     
				--  cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)                                              
				--  AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)                                                      
				--  )                                       
				-- AND S.ClientId NOT IN (                                                 
				--  SELECT ClientId                                                      
				--  FROM #RES7                                                      
				--  )                      
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT CDS.ClientDisclosureId)
						FROM ViewMUIPTransitionOfCare D
						INNER JOIN ClientDisclosedRecords CD ON CD.DocumentId = D.DocumentId
							AND isnull(CD.RecordDeleted, 'N') = 'N'
						INNER JOIN ClientDisclosures CDS ON CDS.ClientDisclosureId = CD.ClientDisclosureId --AND isnull(CDS.RecordDeleted, 'N') = 'N'                                           
							----AND CDS.DisclosureStatus IN (
							----	10573
							----	,10575
							----	) -- Finally moved to Recode                                          
							------          and CDS.DisclosureType in (5525,5526,5527,11127069,6641) -- Email(5525), Secure mail(5526), Electronic media(5527), Patient portal, Direct message                                                                   
							AND EXISTS (
									SELECT 1
									FROM dbo.ssf_RecodeValuesCurrent('DISCLOSURESTATUESFORMU3SOCMEASURE') AS cd
									WHERE cd.IntegerCodeId = CDS.DisclosureStatus
									)
						WHERE (
								cast(CDS.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CDS.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
				--and r7.ClinicianId = R.StaffId                                                      
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8700
					AND R.MeasureSubTypeId = 6214

				UPDATE R
				SET R.Numerator = isnull((
							SELECT count(DISTINCT CDS.ClientDisclosureId)
							FROM ViewMUIPTransitionOfCare D
							INNER JOIN ClientDisclosedRecords CD ON CD.DocumentId = D.DocumentId
								AND isnull(CD.RecordDeleted, 'N') = 'N'
							INNER JOIN ClientDisclosures CDS ON CDS.ClientDisclosureId = CD.ClientDisclosureId --AND isnull(CDS.RecordDeleted, 'N') = 'N'                                           
								----AND CDS.DisclosureStatus = 10573 -- Finally moved to Recode                                          
								------          and CDS.DisclosureType in (5525,5526,5527,11127069,6641) -- Email(5525), Secure mail(5526), Electronic media(5527), Patient portal, Direct message                                                                   
								AND EXISTS (
									SELECT 1
									FROM dbo.ssf_RecodeValuesCurrent('DISCLOSURESTATUESFORMU3SOCMEASURE') AS cd
									WHERE cd.IntegerCodeId = CDS.DisclosureStatus
									)
							WHERE (
									cast(CDS.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(CDS.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8700
					AND R.MeasureSubTypeId = 6214
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8699' --8699 (Medication Reconciliation)                                                     
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					) --ACI Transition                                                              
				AND @InPatient = 1
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM ClientInpatientVisits S
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                              
							AND isnull(S.RecordDeleted, 'N') = 'N'
							--AND S.ClinicianId = R.StaffId                                                                       
							AND (
								cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8699

				CREATE TABLE #Reconciliation1 (
					ClientId INT
					,TransitionDate DATETIME
					,DocumentVersionId INT
					)

				INSERT INTO #Reconciliation1
				SELECT t.ClientId
					,t.TransitionDate
					,t.DocumentVersionId
				FROM (
					SELECT C.ClientId
						,CD.TransferDate AS TransitionDate
						,CD.DocumentVersionId
					FROM ClientCCDs CD
					INNER JOIN Clients C ON C.ClientId = CD.ClientId
					INNER JOIN ClientInpatientVisits CI ON CI.ClientId = CD.ClientId
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
					INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
					INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
						AND CI.ClientId = CP.ClientId
					WHERE CI.STATUS <> 4981
						AND CD.FileType = 8805
						AND isnull(CD.RecordDeleted, 'N') = 'N'
						AND isnull(CI.RecordDeleted, 'N') = 'N'
						AND isnull(BA.RecordDeleted, 'N') = 'N'
						AND isnull(CP.RecordDeleted, 'N') = 'N'
						AND (
							(
								cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
							)
					-- AND CAST(CD.TransferDate AS DATE) >= CAST(@StartDate AS DATE)                                                                      
					-- AND cast(CD.TransferDate AS DATE) <= CAST(@EndDate AS DATE)                                                                      
					
					UNION
					
					SELECT C.ClientId
						,IR.EffectiveDate AS TransitionDate
						,NULL AS DocumentVersionId
					FROM ImageRecords IR
					INNER JOIN Clients C ON C.ClientId = IR.ClientId
						AND isnull(C.RecordDeleted, 'N') = 'N'
					INNER JOIN ClientInpatientVisits CI ON CI.ClientId = C.ClientId
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
					INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
					INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
						AND CI.ClientId = CP.ClientId
					WHERE CI.STATUS <> 4981
						AND isnull(IR.RecordDeleted, 'N') = 'N'
						AND IR.AssociatedId = 1624 -- Document Codes for 'Summary of care'                                                                      
						AND cast(IR.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(IR.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
						AND isnull(CI.RecordDeleted, 'N') = 'N'
						AND isnull(BA.RecordDeleted, 'N') = 'N'
						AND isnull(CP.RecordDeleted, 'N') = 'N'
						AND (
							(
								cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
							)
					) AS t

				UPDATE R
				SET R.Numerator = isnull((
							SELECT count(DISTINCT R.DocumentVersionId)
							FROM Clients C
							INNER JOIN #Reconciliation1 R ON R.ClientId = C.ClientId
							WHERE isnull(C.RecordDeleted, 'N') = 'N'
								AND EXISTS (
									SELECT 1
									FROM ClientMedicationReconciliations CM
									WHERE CM.DocumentVersionId = R.DocumentVersionId
										AND CM.ReconciliationTypeId = 8793 --8793 Medications                                      
										AND isnull(CM.RecordDeleted, 'N') = 'N'
										AND CM.ReconciliationReasonId = (
											SELECT TOP 1 GC.GlobalCodeId
											FROM globalcodes GC
											WHERE GC.category = 'MEDRECONCILIATION'
												AND GC.codename = 'Transition'
												AND isnull(GC.RecordDeleted, 'N') = 'N'
											)
									)
								AND EXISTS (
									SELECT 1
									FROM ClientMedicationReconciliations CM
									WHERE CM.DocumentVersionId = R.DocumentVersionId
										AND CM.ReconciliationTypeId = 8794 -- 8794 Allergy                                    
										AND isnull(CM.RecordDeleted, 'N') = 'N'
										AND CM.ReconciliationReasonId = (
											SELECT TOP 1 GC.GlobalCodeId
											FROM globalcodes GC
											WHERE GC.category = 'MEDRECONCILIATION'
												AND GC.codename = 'Transition'
												AND isnull(GC.RecordDeleted, 'N') = 'N'
											)
									)
								AND EXISTS (
									SELECT 1
									FROM ClientMedicationReconciliations CM
									WHERE CM.DocumentVersionId = R.DocumentVersionId
										AND CM.ReconciliationTypeId = 8795 --   8795 problem                                     
										AND isnull(CM.RecordDeleted, 'N') = 'N'
										AND CM.ReconciliationReasonId = (
											SELECT TOP 1 GC.GlobalCodeId
											FROM globalcodes GC
											WHERE GC.category = 'MEDRECONCILIATION'
												AND GC.codename = 'Transition'
												AND isnull(GC.RecordDeleted, 'N') = 'N'
											)
									)
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8699
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '8703'
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
				AND @InPatient = 1
			BEGIN
				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						WHERE S.DischargedDate >= CAST(@StartDate AS DATE)
							AND S.DischargedDate <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM dbo.ViewMUIPClientVisits S
						INNER JOIN dbo.Staff St ON S.ClientId = St.TempClientId
						WHERE isnull(St.RecordDeleted, 'N') = 'N'
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
							AND EXISTS (
								SELECT 1
								FROM dbo.Messages M
								WHERE M.ClientId = S.ClientId
									AND M.FromStaffId = S.clinicianid
									AND M.ToStaffId = St.StaffId
								)
						)
				--As per functionality on UI , User can delete the messages. so it will not count for Numerator       
				--AND isnull(M.RecordDeleted, 'N') = 'N'      
				--AND CAST(M.DateReceived AS DATE) >= CAST(@StartDate AS DATE)                                                      
				--AND CAST(M.DateReceived AS DATE) <= CAST(@EndDate AS DATE)                                                      
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8703
			END

			IF EXISTS (
					SELECT 1
					FROM #ResultSet
					WHERE MeasureTypeId = '9479' --Receive and Incorporate                                                                                        
					)
				AND @MeaningfulUseStageLevel IN (
					8768
					,9476
					,9477
					,9480
					,9481
					)
				AND @InPatient = 1
			BEGIN
				UPDATE R
				SET R.Denominator = isnull((
							SELECT count(DISTINCT S.ClientCCDId)
							FROM dbo.ViewMUClientCCDs S
							INNER JOIN ClientInpatientVisits CI ON CI.ClientId = S.ClientId
							INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
							JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId
							WHERE
								--S.TransferDate >= CAST(@StartDate AS DATE)      
								--   AND S.TransferDate <= CAST(@EndDate AS DATE)      
								--AND     
								(
									g.GlobalCodeId IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE Category = 'XCCDType'
											AND CodeName IN (
												'Transitioned'
												,'Referred'
												,'New'
												)
										)
									)
								AND (
									cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
									)
								AND isnull(CI.RecordDeleted, 'N') = 'N'
								AND CI.STATUS <> 4981
							), 0)
					,R.Numerator = isnull((
							SELECT count(DISTINCT S.ClientCCDId)
							FROM dbo.ViewMUClientCCDs S
							INNER JOIN ClientInpatientVisits CI ON CI.ClientId = S.ClientId
							INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
							JOIN GlobalCodes g ON S.CCDType = g.GlobalCodeId
							WHERE
								--S.TransferDate >= CAST(@StartDate AS DATE)      
								--   AND S.TransferDate <= CAST(@EndDate AS DATE)      
								--   AND     
								(
									g.GlobalCodeId IN (
										SELECT GlobalCodeId
										FROM GlobalCodes
										WHERE Category = 'XCCDType'
											AND CodeName IN (
												'Transitioned'
												,'Referred'
												,'New'
												)
										)
									)
								AND (
									cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
									AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
									)
								AND isnull(CI.RecordDeleted, 'N') = 'N'
								AND CI.STATUS <> 4981
								AND ISNULL(S.Incorporated, 'N') = 'Y'
							), 0)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 9479
					--CREATE TABLE #RESULT10 (      
					-- ClientId INT      
					-- ,TransitionDate DATETIME      
					-- ,RecipientPhysicianId INT      
					-- )      
					--INSERT INTO #RESULT10 (      
					-- ClientId      
					-- ,TransitionDate      
					-- ,RecipientPhysicianId      
					-- )      
					----Number of patient encounters where the EP, EH or CAH was the receiving party of a transition or referral                                                                                                
					--SELECT S.ClientId      
					-- ,S.ActualTransitionDate AS TransitionDate      
					-- ,S.RecipientPhysicianId      
					--FROM dbo.ViewMUClientCCDs S      
					--INNER JOIN ClientInpatientVisits CI ON CI.ClientId = S.ClientId      
					--INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType      
					--WHERE      
					-- --S.TransferDate >= CAST(@StartDate AS DATE)                                                      
					-- -- AND S.TransferDate <= CAST(@EndDate AS DATE)                                                      
					-- -- AND                                   
					-- (      
					--  cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)      
					--  AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)      
					--  )      
					-- AND isnull(CI.RecordDeleted, 'N') = 'N'      
					-- AND CI.STATUS <> 4981      
					----AND EXISTS (                                                     
					---- SELECT 1                                                      
					---- FROM #ResultSet R                                                      
					---- WHERE S.RecipientPhysicianId = R.StaffId                                                      
					---- )                                                      
					--INSERT INTO #RESULT10 (      
					-- ClientId      
					-- ,TransitionDate      
					-- ,RecipientPhysicianId      
					-- )      
					----Number of patient encounters where the EP, EH, or CAH has never before encountered the patient                                                                                         
					--SELECT S.ClientId      
					-- ,NULL      
					-- ,S.ClinicianId      
					--FROM dbo.ViewMUIPClientVisits S      
					--WHERE NOT EXISTS (      
					--  SELECT 1      
					--  FROM #RESULT10 R2      
					--  WHERE R2.ClientId = S.ClientId      
					--  )      
					-- AND (      
					--  cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)      
					--  AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)      
					--  )      
					----AND EXISTS (                                                      
					---- SELECT 1                                                      
					---- FROM #ResultSet R                                                      
					---- WHERE S.ClinicianId = R.StaffId                                                      
					---- )                                                      
					----AND NOT EXISTS (                                                      
					---- SELECT 1                                                      
					---- FROM dbo.ViewMUIPClientVisits S1                                                      
					---- WHERE EXISTS (                                                      
					----   SELECT 1                                                 
					----   FROM #ResultSet R                                                      
					----   WHERE S1.ClinicianId = R.StaffId                                                      
					----   )                                                      
					----  AND S.ClientId = S1.ClientId                                                      
					----  AND S1.AdmitDate <= CAST(@StartDate AS DATE)                                                      
					---- )                                                      
					--UPDATE R      
					--SET R.Denominator = isnull((      
					--   SELECT count(DISTINCT R1.ClientId)      
					--   FROM #RESULT10 R1      
					--   WHERE R1.RecipientPhysicianId = R.StaffId      
					--   ), 0)      
					--FROM #ResultSet R      
					--WHERE R.MeasureTypeId = 9479      
					--UPDATE R      
					--SET R.Numerator = isnull((      
					--   SELECT count(DISTINCT S.ClientId)      
					--   FROM dbo.ViewMUClientCCDs S      
					--   INNER JOIN ClientInpatientVisits CI ON CI.ClientId = S.ClientId      
					--   INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType      
					--   WHERE      
					--    --S.TransferDate >= CAST(@StartDate AS DATE)                                        
					--    -- AND S.TransferDate <= CAST(@EndDate AS DATE)                                                      
					--    -- AND                                   
					--    (      
					--     cast(CI.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)      
					--     AND cast(CI.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)      
					--     )      
					--    AND isnull(CI.RecordDeleted, 'N') = 'N'      
					--    AND CI.STATUS <> 4981      
					--    --AND S.RecipientPhysicianId = R.StaffId                                                      
					--   ), 0)      
					--FROM #ResultSet R      
					--WHERE R.MeasureTypeId = 9479      
			END
		END
		    
  --drop table #StaffList                                                                            
  --drop table #TinList                                                                            
  --drop table #ResultSet                                                                            
  --drop table #MeasureList                                                                            
  --drop table #MeasureSubList                                                                            
  --drop table #StaffExclusionDates                                                                            
  --drop table #ProcedureExclusionDates                                                           
  --drop table #OrgExclusionDates                                                                            
  --drop table #StaffExclusionDateRange                                                                            
  --drop table #OrgExclusionDateRange                                                                            
  --drop table #ProcedureExclusionDateRange                                                                                          
  UPDATE R                                                        
  SET R.ActualResult = CASE                                                           
    WHEN isnull(R.Denominator, 0) > 0                                                          
     THEN round((cast(R.Numerator AS FLOAT) * 100) / cast(R.Denominator AS FLOAT), 0)                                                          
    ELSE 0                                                          
    END                             
   ,R.Result = CASE                                  
    WHEN isnull(R.Denominator, 0) > 0                                                          
     THEN CASE                                                                  WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast(replace([Target], 'N/A', 0) AS DECIMAL(10, 0))                 
                                         
        THEN '<span style="color:green">Met</span>'                                                          
       ELSE '<span style="color:red">Not Met</span>'                                                          
       END                                                          
    ELSE '<span style="color:red">Not Met</span>'                                                          
    END                                                          
   ,R.[Target] = R.[Target]                                                          
  FROM #ResultSet R                                                          
                                                          
  --END                                                                                                     
  update R                                                                  
   Set R.TinNumeratorTotal = M.GroupTimNumerator                                                                  
   ,R.TinDenominatorTotal = M.GroupTimDenominator                                                                  
   From #ResultSet R join (                                                                  
   SELECT MeasureTypeId                                           
  -- ,MeasureSubTypeId                                                
   , case when MeasureTypeId in (8698,8697,8710,8703,9478) then max(cast(Numerator as int)) else sum(cast(Numerator as int)) end as 'GroupTimNumerator'                                      
   ,case when MeasureTypeId in (8698,8697,8710,8703,9478) then max(cast(Denominator as int)) else  sum(cast(Denominator as int)) end as 'GroupTimDenominator'                                                                                
   ,Tin                                                                             
  FROM #ResultSet                                                                       
  Group by  MeasureTypeId                                                                                
   ,Tin  )M on R.MeasureTypeId= M.MeasureTypeId --and R.MeasureSubTypeId= M.MeasureSubTypeId                                                                  
        and   R.Tin= M.Tin                                                                        
                                                            
  SELECT                                                    
   ISNULL(Tin,'NA') AS Tin                                                         
   ,MAX(TinNumeratorTotal)  AS  'GroupTimNumerator'                                                                    
   ,MAX(TinDenominatorTotal)   as 'GroupTimDenominator'                                                              
  FROM #ResultSet                                                                        
  WHERE (                                                                                  
    ISNULL(Numerator, 0) <> 0                                                                                  
    OR ISNULL(Denominator, 0) <> 0                                                     
    )                                                                                  
   AND ISNULL([Target], '') <> ''                                                                                  
  GROUP BY Tin                                                                    
 END TRY                                                                                  
                                                                                  
 BEGIN CATCH                                                                                  
  DECLARE @error VARCHAR(8000)                                                                                  
                                             
  SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicianTinDetailsFromMUThird') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'      
                                           
 + CONVERT(                                                              
                                                                          
VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                                                  
                                                                                  
  RAISERROR (                                                                                  
    @error                                                                                  
    ,-- Message text.                                                                                                      
    16                                                                                  
    ,-- Severity.                                                                                                      
    1 -- State.                                                                                                      
    );                                                                                  
 END CATCH                                                                 
END                                                          
SET NOCOUNT OFF; 