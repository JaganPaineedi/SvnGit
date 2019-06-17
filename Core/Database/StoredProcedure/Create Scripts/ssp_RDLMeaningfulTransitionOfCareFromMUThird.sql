/****** Object:  StoredProcedure [dbo].[ssp_RDLMeaningfulTransitionOfCareFromMUThird]    Script Date: 09/16/2018 13:02:56 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulTransitionOfCareFromMUThird]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulTransitionOfCareFromMUThird]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLMeaningfulTransitionOfCareFromMUThird]    Script Date: 09/16/2018 13:02:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulTransitionOfCareFromMUThird] @StaffId INT
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
-- Stored Procedure: dbo.ssp_RDLMeaningfulTransitionOfCareFromMUThird              
--         
-- Copyright: Streamline Healthcate Solutions         
--            
-- Updates:                                                                   
--	Date			Author		Purpose            
	10-Oct-2017		Gautam		What:ssp for Report to display Summary of care.                                                                                                              
--								Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports   
    11-Sep-2018     Gautam      What: Removed the Hardcoded DisclosureStatus= 10573 to Recodes category value of DISCLOSURESTATUESFORMU3SOCMEASURE     
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		IF @MeasureType <> 8700
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
			,cast(MFP.ProviderExclusionToDate AS DATE)
			,MFP.StaffId
		FROM MeaningFulUseProviderExclusions MFP
		INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId
			AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
			AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
		WHERE MFU.Stage = @MeaningfulUseStageLevel
			AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)
			AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)
			AND MFP.StaffId = @StaffId

		INSERT INTO #OrgExclusionDateRange
		SELECT MFU.MeasureType
			,MFU.MeasureSubType
			,cast(MFP.ProviderExclusionFromDate AS DATE)
			,cast(MFP.ProviderExclusionToDate AS DATE)
			,MFP.OrganizationExclusion
		FROM MeaningFulUseProviderExclusions MFP
		INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId
			AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
			AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
		WHERE MFU.Stage = @MeaningfulUseStageLevel
			AND MFP.ProviderExclusionFromDate >= CAST(@StartDate AS DATE)
			AND MFP.ProviderExclusionToDate <= CAST(@EndDate AS DATE)
			AND MFP.StaffId IS NULL

		INSERT INTO #ProcedureExclusionDateRange
		SELECT MFU.MeasureType
			,MFU.MeasureSubType
			,cast(MFE.ProcedureExclusionFromDate AS DATE)
			,cast(MFE.ProcedureExclusionToDate AS DATE)
			,MFP.ProcedureCodeId
		FROM MeaningFulUseProcedureExclusionProcedures MFP
		INNER JOIN MeaningFulUseProcedureExclusions MFE ON MFP.MeaningFulUseProcedureExclusionId = MFE.MeaningFulUseProcedureExclusionId
			AND ISNULL(MFP.RecordDeleted, 'N') = 'N'
			AND ISNULL(MFE.RecordDeleted, 'N') = 'N'
		INNER JOIN MeaningFulUseDetails MFU ON MFU.MeaningFulUseDetailId = MFE.MeaningFulUseDetailId
			AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
		WHERE MFU.Stage = @MeaningfulUseStageLevel
			AND MFE.ProcedureExclusionFromDate >= CAST(@StartDate AS DATE)
			AND MFE.ProcedureExclusionToDate <= CAST(@EndDate AS DATE)
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

		CREATE TABLE #MeaningfulMeasurePermissions (GlobalCodeId INT)

		--MeaningfulUseBehavioralHealth(5732) MeaningfulUsePrimaryCare(5733)        
		INSERT INTO #MeaningfulMeasurePermissions
		SELECT PermissionItemId
		FROM ViewStaffPermissions
		WHERE StaffId = @StaffId
			AND PermissionItemId IN (
				5732
				,5733
				)

		CREATE TABLE #RESULT (
			ClientId INT
			,ClientName VARCHAR(250)
			,ProviderName VARCHAR(250)
			,EffectiveDate VARCHAR(100)
			,DateExported VARCHAR(100)
			,DocumentVersionId INT
			)

		CREATE TABLE #RES2 (
			ClientId INT
			,ClientName VARCHAR(250)
			,ProviderName VARCHAR(250)
			,EffectiveDate VARCHAR(100)
			,DateExported VARCHAR(100)
			,DocumentVersionId INT
			)

		IF @MeaningfulUseStageLevel IN (
				8768
				,9476
				,9477
				,9480
				,9481
				)
		BEGIN
			IF @MeasureType = 8700
				AND @MeasureSubType = 6213
			BEGIN
				IF @Option = 'D'
				BEGIN
					--Measure2                   
					INSERT INTO #RES2 (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT DISTINCT r1.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName AS ProviderName
						,CONVERT(VARCHAR, r1.ReferralDate, 101)
						,r1.ReferralDate AS EffectiveDate
						,NULL
					FROM ClientPrimaryCareExternalReferrals r1
					JOIN Clients C ON r1.ClientId = C.ClientId
					WHERE
						--(                                
						-- cast(C1.DisclosureDate AS DATE) >= CAST(@StartDate AS DATE)                                
						-- AND cast(C1.DisclosureDate AS DATE) <= CAST(@EndDate AS DATE)                                
						-- )      
						-- and    
						cast(r1.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(r1.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
						AND r1.ReferringProviderId = @StaffId

					--AND (@Tin='NA' or cast(r1.ReasonComment as VARCHAR(10)) = @Tin)      
					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT R.ClientId
						,R.ClientName
						,R.ProviderName
						,R.EffectiveDate
						,R.DateExported
						,R.DocumentVersionId
					FROM #RES2 R
				END

				IF (
						@Option = 'A'
						OR @Option = 'N'
						)
				BEGIN
					INSERT INTO #RES2 (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT DISTINCT r1.ClientId
						,RTRIM(c1.LastName + ', ' + c1.FirstName) AS ClientName
						,@ProviderName AS ProviderName
						,CONVERT(VARCHAR, r1.ReferralDate, 101)
						,r1.ReferralDate
						,D.CurrentDocumentVersionId
					FROM ClientPrimaryCareExternalReferrals r1
					JOIN Clients C1 ON r1.ClientId = C1.ClientId
					JOIN ClientDisclosures c ON r1.ClientId = c.ClientId
						AND isnull(C.RecordDeleted, 'N') = 'N'
						--and C.DisclosureStatus= 10573   
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
						AND cast(r1.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(r1.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
						AND r1.ReferringProviderId = @StaffId
						AND r1.ReferringProviderId = @StaffId
						AND t.LocationId IS NOT NULL
						AND (
							t.LocationId = - 1
							OR l.TaxIdentificationNumber = @Tin
							)

					--and r7.ClinicianId = R.StaffId                                
					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT R.ClientId
						,R.ClientName
						,R.ProviderName
						,R.EffectiveDate
						,R.DateExported
						,R.DocumentVersionId
					FROM #RES2 R
				END
						/* 8700(TransitionOfCare)*/
			END
		END

		SELECT R.ClientId
			,R.ClientName
			,R.ProviderName
			,R.EffectiveDate
			,R.DateExported
			,@Tin AS 'Tin'
		FROM #RESULT R
		ORDER BY R.ClientId ASC
			,R.DocumentVersionId DESC
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulTransitionOfCareFromMUThird') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


