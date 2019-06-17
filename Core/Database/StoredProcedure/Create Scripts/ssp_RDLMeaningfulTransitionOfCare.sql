IF EXISTS (
		SELECT 1
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMeaningfulTransitionOfCare]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLMeaningfulTransitionOfCare]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLMeaningfulTransitionOfCare] @StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@MeasureType INT
	,@MeasureSubType INT
	,@ProblemList VARCHAR(50)
	,@Option CHAR(1)
	,@Stage VARCHAR(10) = NULL
	,@InPatient INT = 0
	/********************************************************************************        
-- Stored Procedure: dbo.ssp_RDLMeaningfulTransitionOfCare          
--       
-- Copyright: Streamline Healthcate Solutions     
--        
-- Updates:                                                               
-- Date    Author   Purpose        
-- 22-sep-2014  Revathi  What:Get TransitionOfCare Document List        
--        Why:task #43 MeaningFul Use     
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts           
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

		IF @MeaningfulUseStageLevel = 8767
			OR @MeaningfulUseStageLevel = 9373
		BEGIN
			IF @MeasureType = 8700
				AND @MeasureSubType = 6214
			BEGIN
				IF (
						@Option = 'D'
						OR @Option = 'A'
						OR @Option = 'N'
						)
				BEGIN
					--Measure2               
					CREATE TABLE #RES2 (
						ClientId INT
						,ClientName VARCHAR(250)
						,ProviderName VARCHAR(250)
						,EffectiveDate VARCHAR(100)
						,DateExported VARCHAR(100)
						,DocumentVersionId INT
						)

					INSERT INTO #RES2 (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName AS ProviderName
						,CONVERT(VARCHAR, D.EffectiveDate, 101)
						,CONVERT(VARCHAR, T.ExportedDate, 101)
						,ISNULL(D.CurrentDocumentVersionId, 0)
					FROM Documents D
					INNER JOIN Clients C ON D.ClientId = C.ClientId
						AND isnull(C.RecordDeleted, 'N') = 'N'
					INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId
						--AND T.ExportedDate IS NOT NULL                
						AND isnull(T.RecordDeleted, 'N') = 'N'
						AND T.ProviderId = @StaffId
					WHERE D.DocumentCodeId = 1644  -- Transition Of Care -- 1611 Summary of Care                     
						AND isnull(D.RecordDeleted, 'N') = 'N'
						AND d.STATUS = 22
						AND D.AuthorId = @StaffId
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE D.AuthorId = SE.StaffId
								AND SE.MeasureType = 8700
								AND CAST(D.EffectiveDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8700
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND D.EffectiveDate >= CAST(@StartDate AS DATE)
						AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)

					INSERT INTO #RES2 (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName AS ProviderName
						,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
						,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
						,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
					FROM ClientOrders CO
					INNER JOIN Clients C ON CO.ClientId = C.ClientId
						AND isnull(C.RecordDeleted, 'N') = 'N'
					INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
						AND isnull(OS.RecordDeleted, 'N') = 'N'
					WHERE isnull(CO.RecordDeleted, 'N') = 'N'
						AND OS.OrderId = 148 -- Referral/Transition Request                  
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE CO.OrderingPhysician = SE.StaffId
								AND SE.MeasureType = 8700
								AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates
								AND OE.MeasureType = 8700
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND CO.OrderingPhysician = @StaffId
						--and CO.OrderStatus <> 6510 -- Order discontinued                    
						AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)

					INSERT INTO #RES2 (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT DISTINCT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName AS ProviderName
						,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
						,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
						,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
					FROM ClientPrimaryCareExternalReferrals CO
					INNER JOIN Clients C ON CO.ClientId = C.ClientId
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND C.ClientId NOT IN (
							SELECT ClientId
							FROM #RES2
							)
					WHERE isnull(CO.RecordDeleted, 'N') = 'N'
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE C.PrimaryClinicianId = SE.StaffId
								AND SE.MeasureType = 8700
								AND CAST(CO.ModifiedDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8700
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND C.PrimaryPhysicianId = @StaffId
						--and CO.OrderStatus <> 6510 -- Order discontinued                    
						AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
						AND C.ClientId NOT IN (
							SELECT ClientId
							FROM #RES2
							)

					IF (@Option = 'D')
					BEGIN
						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,ProviderName
							,EffectiveDate
							,DateExported
							,DocumentVersionId
							)
						SELECT ClientId
							,ClientName
							,ProviderName
							,EffectiveDate
							,DateExported
							,DocumentVersionId
						FROM #RES2
					END
				END

				IF (
						@Option = 'A'
						OR @Option = 'N'
						)
				BEGIN
					INSERT INTO #RESULT (
						ClientId
						,ClientName
						,ProviderName
						,EffectiveDate
						,DateExported
						,DocumentVersionId
						)
					SELECT C.ClientId
						,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
						,@ProviderName AS ProviderName
						,CONVERT(VARCHAR, D.EffectiveDate, 101)
						,CONVERT(VARCHAR, T.ExportedDate, 101)
						,ISNULL(D.CurrentDocumentVersionId, 0)
					FROM Documents D
					JOIN Clients C ON C.ClientId = D.ClientId
					INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId
					WHERE D.DocumentCodeId = 1644  -- Transition Of Care -- 1611 -- Summary of Care                   
						AND isnull(D.RecordDeleted, 'N') = 'N'
						AND d.STATUS = 22
						AND EXISTS (
							SELECT 1
							FROM #RES2 R2
							WHERE R2.ClientId = D.ClientId
							)
						AND D.AuthorId = @StaffId
						AND EXISTS (
							SELECT 1
							FROM STAFFCLIENTACCESS SCA
							WHERE SCA.ClientId = D.ClientId
								AND SCA.Screenid = 891
								AND SCA.Staffid = @StaffId
								AND SCA.ActivityType = 'N'
								AND isnull(SCA.RecordDeleted, 'N') = 'N'
							)
						AND EXISTS (
							SELECT 1
							FROM TransitionOfCareDocuments TOC
							WHERE isnull(TOC.RecordDeleted, 'N') = 'N'
								AND TOC.DocumentVersionId = D.InProgressDocumentVersionId
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #StaffExclusionDates SE
							WHERE D.AuthorId = SE.StaffId
								AND SE.MeasureType = 8700
								AND CAST(D.EffectiveDate AS DATE) = SE.Dates
							)
						AND NOT EXISTS (
							SELECT 1
							FROM #OrgExclusionDates OE
							WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates
								AND OE.MeasureType = 8700
								AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
							)
						AND D.EffectiveDate >= CAST(@StartDate AS DATE)
						AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
				END
						/* 8700(TransitionOfCare)*/
			END
			ELSE
				IF @MeasureType = 8700
					AND @MeasureSubType = 6213
				BEGIN
					IF (
							@Option = 'D'
							OR @Option = 'A'
							OR @Option = 'N'
							)
					BEGIN
						CREATE TABLE #RES3 (
							ClientId INT
							,ClientName VARCHAR(250)
							,ProviderName VARCHAR(250)
							,EffectiveDate VARCHAR(100)
							,DateExported VARCHAR(100)
							,DocumentVersionId INT
							)

						INSERT INTO #RES3 (
							ClientId
							,ClientName
							,ProviderName
							,EffectiveDate
							,DateExported
							,DocumentVersionId
							)
						SELECT DISTINCT C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName
							,CONVERT(VARCHAR, D.EffectiveDate, 101)
							,CONVERT(VARCHAR, T.ExportedDate, 101)
							,ISNULL(D.CurrentDocumentVersionId, 0)
						FROM Documents D
						INNER JOIN Clients C ON D.ClientId = C.ClientId
							AND isnull(C.RecordDeleted, 'N') = 'N'
						INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId
							--AND T.ExportedDate IS NOT NULL                
							AND isnull(T.RecordDeleted, 'N') = 'N'
							AND T.ProviderId = @StaffId
						WHERE D.DocumentCodeId = 1644  -- Transition Of Care 1611 -- Summary of Care                     
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND d.STATUS = 22
							AND D.AuthorId = @StaffId
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE D.AuthorId = SE.StaffId
									AND SE.MeasureType = 8700
									AND CAST(D.EffectiveDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8700
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND D.EffectiveDate >= CAST(@StartDate AS DATE)
							AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)

						INSERT INTO #RES3 (
							ClientId
							,ClientName
							,ProviderName
							,EffectiveDate
							,DateExported
							,DocumentVersionId
							)
						SELECT DISTINCT C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName
							,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
							,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
							,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
						FROM ClientOrders CO
						INNER JOIN Clients C ON CO.ClientId = C.ClientId
							AND isnull(C.RecordDeleted, 'N') = 'N'
						INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
							AND isnull(OS.RecordDeleted, 'N') = 'N'
						WHERE isnull(CO.RecordDeleted, 'N') = 'N'
							AND OS.OrderId = 148 -- Referral/Transition Request                  
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE CO.OrderingPhysician = SE.StaffId
									AND SE.MeasureType = 8700
									AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates
									AND OE.MeasureType = 8700
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND CO.OrderingPhysician = @StaffId
							--and CO.OrderStatus <> 6510 -- Order discontinued                    
							AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)

						INSERT INTO #RES3 (
							ClientId
							,ClientName
							,ProviderName
							,EffectiveDate
							,DateExported
							,DocumentVersionId
							)
						SELECT DISTINCT C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName
							,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
							,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
							,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
						FROM ClientPrimaryCareExternalReferrals CO
						INNER JOIN Clients C ON CO.ClientId = C.ClientId
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND C.ClientId NOT IN (
								SELECT ClientId
								FROM #RES3
								)
						WHERE isnull(CO.RecordDeleted, 'N') = 'N'
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE C.PrimaryClinicianId = SE.StaffId
									AND SE.MeasureType = 8700
									AND CAST(CO.ModifiedDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8700
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND C.PrimaryPhysicianId = @StaffId
							--and CO.OrderStatus <> 6510 -- Order discontinued                    
							AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
							AND C.ClientId NOT IN (
								SELECT ClientId
								FROM #RES3
								)

						IF @Option = 'D'
						BEGIN
							INSERT INTO #RESULT (
								ClientId
								,ClientName
								,ProviderName
								,EffectiveDate
								,DateExported
								,DocumentVersionId
								)
							SELECT ClientId
								,ClientName
								,ProviderName
								,EffectiveDate
								,DateExported
								,DocumentVersionId
							FROM #RES3
						END
					END

					IF (
							@Option = 'A'
							OR @Option = 'N'
							)
					BEGIN
						INSERT INTO #RESULT (
							ClientId
							,ClientName
							,ProviderName
							,EffectiveDate
							,DateExported
							,DocumentVersionId
							)
						SELECT C.ClientId
							,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
							,@ProviderName AS ProviderName
							,CONVERT(VARCHAR, D.EffectiveDate, 101)
							,NULL --CONVERT(VARCHAR, T.ExportedDate, 101)  
							,ISNULL(D.CurrentDocumentVersionId, 0)
						FROM Documents D
						JOIN Clients C ON C.ClientId = D.ClientId
						--INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId      
						WHERE D.DocumentCodeId = 1644  -- Transition Of Care 1611 -- Summary of Care                   
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND d.STATUS = 22
							AND D.AuthorId = @StaffId
							AND EXISTS (
								SELECT 1
								FROM #RES3 R2
								WHERE R2.ClientId = D.ClientId
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #StaffExclusionDates SE
								WHERE D.AuthorId = SE.StaffId
									AND SE.MeasureType = 8700
									AND CAST(D.EffectiveDate AS DATE) = SE.Dates
								)
							AND NOT EXISTS (
								SELECT 1
								FROM #OrgExclusionDates OE
								WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates
									AND OE.MeasureType = 8700
									AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
								)
							AND D.EffectiveDate >= CAST(@StartDate AS DATE)
							AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
					END
				END
		END

		IF @MeaningfulUseStageLevel = 8766
		BEGIN
			IF @Option = 'D'
			BEGIN
				CREATE TABLE #RES1 (
					ClientId INT
					,ClientName VARCHAR(250)
					,ProviderName VARCHAR(250)
					,EffectiveDate VARCHAR(100)
					,DateExported VARCHAR(100)
					,DocumentVersionId INT
					)

				INSERT INTO #RES1 (
					ClientId
					,ClientName
					,ProviderName
					,EffectiveDate
					,DateExported
					,DocumentVersionId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,@ProviderName
					,CONVERT(VARCHAR, D.EffectiveDate, 101)
					,CONVERT(VARCHAR, T.ExportedDate, 101)
					,ISNULL(D.CurrentDocumentVersionId, 0)
				FROM Documents D
				INNER JOIN Clients C ON D.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId
					--AND T.ExportedDate IS NOT NULL                
					AND isnull(T.RecordDeleted, 'N') = 'N'
					AND T.ProviderId = @StaffId
				WHERE D.DocumentCodeId = 1611 -- Summary of Care                     
					AND isnull(D.RecordDeleted, 'N') = 'N'
					AND d.STATUS = 22
					AND D.AuthorId = @StaffId
					AND NOT EXISTS (
						SELECT 1
						FROM #StaffExclusionDates SE
						WHERE D.AuthorId = SE.StaffId
							AND SE.MeasureType = 8700
							AND CAST(D.EffectiveDate AS DATE) = SE.Dates
						)
					AND NOT EXISTS (
						SELECT 1
						FROM #OrgExclusionDates OE
						WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates
							AND OE.MeasureType = 8700
							AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
						)
					AND D.EffectiveDate >= CAST(@StartDate AS DATE)
					AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)

				INSERT INTO #RES1 (
					ClientId
					,ClientName
					,ProviderName
					,EffectiveDate
					,DateExported
					,DocumentVersionId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,@ProviderName
					,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
					,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
					,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
				FROM ClientOrders CO
				INNER JOIN Clients C ON CO.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
				INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
					AND isnull(OS.RecordDeleted, 'N') = 'N'
				WHERE isnull(CO.RecordDeleted, 'N') = 'N'
					AND OS.OrderId = 148 -- Referral/Transition Request                  
					AND NOT EXISTS (
						SELECT 1
						FROM #StaffExclusionDates SE
						WHERE CO.OrderingPhysician = SE.StaffId
							AND SE.MeasureType = 8700
							AND CAST(CO.OrderStartDateTime AS DATE) = SE.Dates
						)
					AND NOT EXISTS (
						SELECT 1
						FROM #OrgExclusionDates OE
						WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates
							AND OE.MeasureType = 8700
							AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
						)
					AND CO.OrderingPhysician = @StaffId
					--and CO.OrderStatus <> 6510 -- Order discontinued                    
					AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)

				INSERT INTO #RES1 (
					ClientId
					,ClientName
					,ProviderName
					,EffectiveDate
					,DateExported
					,DocumentVersionId
					)
				SELECT DISTINCT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,@ProviderName
					,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
					,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
					,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
				FROM ClientPrimaryCareExternalReferrals CO
				INNER JOIN Clients C ON CO.ClientId = C.ClientId
					AND isnull(C.RecordDeleted, 'N') = 'N'
					AND C.ClientId NOT IN (
						SELECT ClientId
						FROM #RES1
						)
				WHERE isnull(CO.RecordDeleted, 'N') = 'N'
					AND NOT EXISTS (
						SELECT 1
						FROM #StaffExclusionDates SE
						WHERE C.PrimaryClinicianId = SE.StaffId
							AND SE.MeasureType = 8700
							AND CAST(CO.ModifiedDate AS DATE) = SE.Dates
						)
					AND NOT EXISTS (
						SELECT 1
						FROM #OrgExclusionDates OE
						WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates
							AND OE.MeasureType = 8700
							AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
						)
					AND C.PrimaryClinicianId = @StaffId
					--and CO.OrderStatus <> 6510 -- Order discontinued                    
					AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
					AND C.ClientId NOT IN (
						SELECT ClientId
						FROM #RES1
						)

				INSERT INTO #RESULT (
					ClientId
					,ClientName
					,ProviderName
					,EffectiveDate
					,DateExported
					,DocumentVersionId
					)
				SELECT ClientId
					,ClientName
					,ProviderName
					,EffectiveDate
					,DateExported
					,DocumentVersionId
				FROM #RES1
			END

			IF (
					@Option = 'A'
					OR @Option = 'N'
					)
			BEGIN
				INSERT INTO #RESULT (
					ClientId
					,ClientName
					,ProviderName
					,EffectiveDate
					,DateExported
					,DocumentVersionId
					)
				SELECT C.ClientId
					,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName
					,@ProviderName AS ProviderName
					,CONVERT(VARCHAR, D.EffectiveDate, 101)
					,NULL --CONVERT(VARCHAR, T.ExportedDate, 101)  
					,ISNULL(D.CurrentDocumentVersionId, 0)
				FROM Documents D
				JOIN Clients C ON C.ClientId = D.ClientId
				--INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId      
				WHERE D.DocumentCodeId = 1611 -- Summary of Care                   
					AND isnull(D.RecordDeleted, 'N') = 'N'
					AND d.STATUS = 22
					AND D.AuthorId = @StaffId
					AND NOT EXISTS (
						SELECT 1
						FROM #StaffExclusionDates SE
						WHERE D.AuthorId = SE.StaffId
							AND SE.MeasureType = 8700
							AND CAST(D.EffectiveDate AS DATE) = SE.Dates
						)
					AND NOT EXISTS (
						SELECT 1
						FROM #OrgExclusionDates OE
						WHERE CAST(d.EffectiveDate AS DATE) = OE.Dates
							AND OE.MeasureType = 8700
							AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
						)
					AND D.EffectiveDate >= CAST(@StartDate AS DATE)
					AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
			END
		END

		SELECT R.ClientId
			,R.ClientName
			,R.ProviderName
			,R.EffectiveDate
			,R.DateExported
		FROM #RESULT R
		ORDER BY R.ClientId ASC
			,R.DocumentVersionId DESC
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLMeaningfulTransitionOfCare') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.                  
				16
				,-- Severity.                  
				1 -- State.                  
				);
	END CATCH
END
