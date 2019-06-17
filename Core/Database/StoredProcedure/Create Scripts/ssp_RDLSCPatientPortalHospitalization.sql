IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCPatientPortalHospitalization]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCPatientPortalHospitalization]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLSCPatientPortalHospitalization] (
	@StaffId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@MeasureType INT
	,@MeasureSubType INT
	,@ProblemList VARCHAR(50)
	,@Option CHAR(1)
	,@Stage VARCHAR(10) = NULL
	,@InPatient INT= 1
	)
	/********************************************************************************          
-- Stored Procedure: dbo.ssp_RDLSCPatientPortalHospitalization            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date			Author   Purpose          
-- 04-Nov-2014  Revathi  What:Patient Portal Hospitalization.                
--				Why:task #22 Certification 2014    
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement
						 why : Meaningful Use, Task	#66 - Stage 2 - Modified    
-- 04-May-2017	Ravi	 What : added the code for SubMeasure 6261 'Measure 1 2017' for Patient Portal(8697) 
						 why : Meaningful Use - Stage 3  # 39       
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
	
	IF @MeasureType <> 8697 OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END    
			  
		DECLARE @MeaningfulUseStageLevel VARCHAR(10)
		DECLARE @ReportPeriod VARCHAR(100)
		DECLARE @ProviderName VARCHAR(40)

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

		SET @ReportPeriod = convert(VARCHAR, @StartDate, 101) + ' - ' + convert(VARCHAR, @EndDate, 101)

		SELECT TOP 1 @ProviderName = (IsNull(LastName, '') + ', ' + IsNull(FirstName, ''))
		FROM staff
		WHERE staffId = @StaffId

		CREATE TABLE #ResultSet (
			Stage VARCHAR(20)
			,MeasureType VARCHAR(250)
			,MeasureTypeId VARCHAR(15)
			,MeasureSubTypeId VARCHAR(15)
			,DetailsType VARCHAR(250)
			,[Target] VARCHAR(20)
			,ReportPeriod VARCHAR(100)
			,ProviderName VARCHAR(250)
			,Numerator VARCHAR(20)
			,Denominator VARCHAR(20)
			,ActualResult VARCHAR(20)
			,Result VARCHAR(100)
			,DetailsSubType VARCHAR(50)
			,ProblemList VARCHAR(100)
			,SortOrder INT
			)

		INSERT INTO #ResultSet (
			Stage
			,MeasureType
			,MeasureTypeId
			,MeasureSubTypeId
			,DetailsType
			,[Target]
			,ProviderName
			,ReportPeriod
			,Numerator
			,Denominator
			,ActualResult
			,Result
			,DetailsSubType
			,SortOrder
			)
		SELECT DISTINCT GC1.CodeName
			,MU.DisplayWidgetNameAs
			,MU.MeasureType
			,MU.MeasureSubType
			,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE 
					WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0
						THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))
					ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2
					END) + ' (H)'
			,cast(isnull(mu.Target, 0) AS INT)
			,@ProviderName
			,@ReportPeriod
			,NULL
			,NULL
			,0
			,NULL
			,substring(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs), 1, CASE 
					WHEN CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) = 0
						THEN LEN(isnull(GS.SubCodeName, MU.DisplayWidgetNameAs))
					ELSE CHARINDEX('(', isnull(GS.SubCodeName, MU.DisplayWidgetNameAs)) - 2
					END) + ' (H)'
			,GC.SortOrder
		FROM MeaningfulUseMeasureTargets MU
		INNER JOIN GlobalCodes GC ON MU.MeasureType = GC.GlobalCodeId
			AND ISNULL(MU.RecordDeleted, 'N') = 'N'
			AND ISNULL(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalSubCodes GS ON MU.MeasureSubType = GS.GlobalSubCodeId
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = MU.Stage
		WHERE MU.Stage = @MeaningfulUseStageLevel
			AND isnull(mu.Target, 0) > 0
			AND GC.GlobalCodeId = @MeasureType
			AND (
				@MeasureSubType = 0
				OR MU.MeasureSubType = @MeasureSubType
				)
		ORDER BY GC.SortOrder ASC

		/*  8697--(Patient Portal)*/
		--   	UPDATE R
		--SET R.Denominator = (
		--		SELECT count(DISTINCT CI.ClientId)
		--	FROM ClientInpatientVisits CI  
		--  INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
		--  INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
		--  INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
		--   AND CP.ClientId = CI.ClientId  
		--  INNER JOIN Clients C ON CI.ClientId = C.ClientId  
		--  INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId  
		--  INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId= D.CurrentDocumentVersionId  
		--  LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
		--  LEFT JOIN Staff St ON St.TempClientId = CI.ClientId  
		--   AND Isnull(St.NonStaffUser, 'N') = 'Y'  
		--   AND isnull(St.RecordDeleted, 'N') = 'N'  
		--  LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId  
		--   AND SCA.StaffId = ST.StaffId  
		--   AND isnull(SCA.RecordDeleted, 'N') = 'N'  
		--	WHERE CI.STATUS <> 4981 --   4981 (Schedule)      
		--	AND isnull(CI.RecordDeleted, 'N') = 'N'  
		--	   AND isnull(BA.RecordDeleted, 'N') = 'N'  
		--	   AND isnull(CP.RecordDeleted, 'N') = 'N'  
		--	   AND isnull(C.RecordDeleted, 'N') = 'N'  
		--	   AND isnull(D.RecordDeleted, 'N') = 'N'  
		--	   AND isnull(CS.RecordDeleted, 'N') = 'N'  
		--	   AND CI.DischargedDate IS NOT NULL  
		--	   AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)  
		--	   AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE) ) 
		--    FROM #ResultSet R        
		--  WHERE R.MeasureTypeId = 8697        
		IF @MeaningfulUseStageLevel = 8766
		BEGIN
			UPDATE R
			SET R.Denominator = (
					SELECT count(DISTINCT CI.ClientId)
					FROM ClientInpatientVisits CI
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
					INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
					INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
						AND CP.ClientId = CI.ClientId
					INNER JOIN Clients C ON CI.ClientId = C.ClientId
					INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId
					INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
					--LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId          
					LEFT JOIN Staff St ON St.TempClientId = CI.ClientId
						AND Isnull(St.NonStaffUser, 'N') = 'Y'
						AND isnull(St.RecordDeleted, 'N') = 'N'
					LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
						AND SCA.StaffId = ST.StaffId
						AND isnull(SCA.RecordDeleted, 'N') = 'N'
					WHERE CI.STATUS <> 4981 --   4981 (Schedule)                    
						AND isnull(CI.RecordDeleted, 'N') = 'N'
						AND isnull(BA.RecordDeleted, 'N') = 'N'
						AND isnull(CP.RecordDeleted, 'N') = 'N'
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND isnull(D.RecordDeleted, 'N') = 'N'
						AND isnull(CS.RecordDeleted, 'N') = 'N'
						AND CI.DischargedDate IS NOT NULL
						AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				,R.Numerator = (
					SELECT count(DISTINCT CI.ClientId)
					FROM ClientInpatientVisits CI
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
					INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
					INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
						AND CP.ClientId = CI.ClientId
					INNER JOIN Clients C ON CI.ClientId = C.ClientId
					INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId
					INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
					--LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId          
					LEFT JOIN Staff St ON St.TempClientId = CI.ClientId
						AND Isnull(St.NonStaffUser, 'N') = 'Y'
						AND isnull(St.RecordDeleted, 'N') = 'N'
					WHERE CI.STATUS <> 4981
						AND isnull(CI.RecordDeleted, 'N') = 'N'
						AND isnull(BA.RecordDeleted, 'N') = 'N'
						AND isnull(CP.RecordDeleted, 'N') = 'N'
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND CI.DischargedDate IS NOT NULL
						AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
						AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36
						AND Isnull(St.NonStaffUser, 'N') = 'Y'
					)
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8697
				--	AND R.Hospital = 'Y' 
				--   UPDATE R SET         
				--   R.Numerator = (        
				--    	SELECT count(DISTINCT CI.ClientId)
				--	 FROM ClientInpatientVisits CI  
				--INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
				--INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
				--INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
				-- AND CP.ClientId = CI.ClientId  
				--INNER JOIN Clients C ON CI.ClientId = C.ClientId  
				--INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId  
				--INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId= D.CurrentDocumentVersionId  
				--LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
				--LEFT JOIN Staff St ON St.TempClientId = CI.ClientId  
				-- AND Isnull(St.NonStaffUser, 'N') = 'Y'  
				-- AND isnull(St.RecordDeleted, 'N') = 'N'  
				--WHERE CI.STATUS <> 4981  
				-- AND isnull(CI.RecordDeleted, 'N') = 'N'  
				-- AND isnull(BA.RecordDeleted, 'N') = 'N'  
				-- AND isnull(CP.RecordDeleted, 'N') = 'N'  
				-- AND isnull(C.RecordDeleted, 'N') = 'N'  
				-- AND CI.DischargedDate IS NOT NULL  
				-- AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)  
				-- AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)  
				-- AND Datediff(hour, CI.DischargedDate, St.CreatedDate ) < 36      
				-- AND Isnull(St.NonStaffUser, 'N') = 'Y'  )
				--  FROM #ResultSet R        
				--  WHERE R.MeasureTypeId = 8697        
		END

		/*  8697--(Patient Portal)*/
		IF @MeaningfulUseStageLevel = 8767
			-- 11-Jan-2016  Ravi
			OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'          
			--8697(Patient Portal)         
		BEGIN
			UPDATE R
			SET R.Denominator = (
					SELECT count(DISTINCT CI.ClientId)
					FROM ClientInpatientVisits CI
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
					INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
					INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
						AND CP.ClientId = CI.ClientId
					INNER JOIN Clients C ON CI.ClientId = C.ClientId
					INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId
					INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
					LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
					LEFT JOIN Staff St ON St.TempClientId = CI.ClientId
						AND Isnull(St.NonStaffUser, 'N') = 'Y'
						AND isnull(St.RecordDeleted, 'N') = 'N'
					LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
						AND SCA.StaffId = ST.StaffId
						AND isnull(SCA.RecordDeleted, 'N') = 'N'
					WHERE CI.STATUS <> 4981 --   4981 (Schedule)                    
						AND isnull(CI.RecordDeleted, 'N') = 'N'
						AND isnull(BA.RecordDeleted, 'N') = 'N'
						AND isnull(CP.RecordDeleted, 'N') = 'N'
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND isnull(D.RecordDeleted, 'N') = 'N'
						AND isnull(CS.RecordDeleted, 'N') = 'N'
						AND CI.DischargedDate IS NOT NULL
						AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				,R.Numerator = (
					SELECT count(DISTINCT CI.ClientId)
					FROM ClientInpatientVisits CI
					INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
					INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
					INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
						AND CP.ClientId = CI.ClientId
					INNER JOIN Clients C ON CI.ClientId = C.ClientId
					INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId
					INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
					LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
					LEFT JOIN Staff St ON St.TempClientId = CI.ClientId
						AND Isnull(St.NonStaffUser, 'N') = 'Y'
						AND isnull(St.RecordDeleted, 'N') = 'N'
					WHERE CI.STATUS <> 4981
						AND isnull(CI.RecordDeleted, 'N') = 'N'
						AND isnull(BA.RecordDeleted, 'N') = 'N'
						AND isnull(CP.RecordDeleted, 'N') = 'N'
						AND isnull(C.RecordDeleted, 'N') = 'N'
						AND CI.DischargedDate IS NOT NULL
						AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
						AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
						AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36
						AND Isnull(St.NonStaffUser, 'N') = 'Y'
					)
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8697
				AND R.MeasureSubTypeId = 6211
				
				--- Measure 1 2017    -- 04-May-2017  Ravi 
				IF  @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'            
				BEGIN
					UPDATE R
					SET R.Denominator = (
						SELECT count(DISTINCT CI.ClientId)
						FROM ClientInpatientVisits CI
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = CI.ClientId
						INNER JOIN Clients C ON CI.ClientId = C.ClientId
						INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId
						INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
						LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
						LEFT JOIN Staff St ON St.TempClientId = CI.ClientId
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
							AND isnull(St.RecordDeleted, 'N') = 'N'
						LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
							AND SCA.StaffId = ST.StaffId
							AND isnull(SCA.RecordDeleted, 'N') = 'N'
						WHERE CI.STATUS <> 4981 --   4981 (Schedule)                    
							AND isnull(CI.RecordDeleted, 'N') = 'N'
							AND isnull(BA.RecordDeleted, 'N') = 'N'
							AND isnull(CP.RecordDeleted, 'N') = 'N'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND isnull(CS.RecordDeleted, 'N') = 'N'
							AND CI.DischargedDate IS NOT NULL
							AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT CI.ClientId)
						FROM ClientInpatientVisits CI
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = CI.ClientId
						INNER JOIN Clients C ON CI.ClientId = C.ClientId
						INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId
						INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
						LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
						LEFT JOIN Staff St ON St.TempClientId = CI.ClientId
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
							AND isnull(St.RecordDeleted, 'N') = 'N'
						WHERE CI.STATUS <> 4981
							AND isnull(CI.RecordDeleted, 'N') = 'N'
							AND isnull(BA.RecordDeleted, 'N') = 'N'
							AND isnull(CP.RecordDeleted, 'N') = 'N'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND CI.DischargedDate IS NOT NULL
							AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
							AND Datediff(hour, CI.DischargedDate, St.CreatedDate) < 36
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8697
					AND R.MeasureSubTypeId = 6261
			END
			--Measure 1        
			--   UPDATE R SET         
			--   R.Numerator = (        
			--    SELECT count(DISTINCT CI.ClientId)
			--	 FROM ClientInpatientVisits CI  
			--INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = CI.AdmissionType
			--INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CI.ClientInpatientVisitId  
			--INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId  
			-- AND CP.ClientId = CI.ClientId  
			--INNER JOIN Clients C ON CI.ClientId = C.ClientId  
			--INNER JOIN DOCUMENTS D ON D.ClientId = CI.ClientId  
			--INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId= D.CurrentDocumentVersionId  
			--LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId  
			--LEFT JOIN Staff St ON St.TempClientId = CI.ClientId  
			-- AND Isnull(St.NonStaffUser, 'N') = 'Y'  
			-- AND isnull(St.RecordDeleted, 'N') = 'N'  
			--WHERE CI.STATUS <> 4981  
			-- AND isnull(CI.RecordDeleted, 'N') = 'N'  
			-- AND isnull(BA.RecordDeleted, 'N') = 'N'  
			-- AND isnull(CP.RecordDeleted, 'N') = 'N'  
			-- AND isnull(C.RecordDeleted, 'N') = 'N'  
			-- AND CI.DischargedDate IS NOT NULL  
			-- AND cast(CI.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)  
			-- AND cast(CI.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)  
			-- AND Datediff(hour, CI.DischargedDate, St.CreatedDate ) < 36      
			-- AND Isnull(St.NonStaffUser, 'N') = 'Y'  )
			--  FROM #ResultSet R        
			--  WHERE R.MeasureTypeId = 8697        
			--  AND R.MeasureSubTypeId = 6211      
			-- 11-Jan-2016  Ravi
			IF @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'    
			BEGIN
				----Measure 2        
				UPDATE R
				SET R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM ClientInpatientVisits S
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = S.ClientId
						INNER JOIN Clients C ON S.ClientId = C.ClientId
						INNER JOIN DOCUMENTS D ON D.ClientId = c.ClientId
							AND isnull(D.RecordDeleted, 'N') = 'N'
						INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
							AND isnull(CS.RecordDeleted, 'N') = 'N'
						LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
						INNER JOIN Staff St ON St.TempClientId = S.ClientId
						INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
							AND SCA.StaffId = ST.StaffId
							AND isnull(SCA.RecordDeleted, 'N') = 'N'
						WHERE S.STATUS <> 4981 --   4981 (Schedule)      
							AND isnull(S.RecordDeleted, 'N') = 'N'
							AND isnull(BA.RecordDeleted, 'N') = 'N'
							AND isnull(CP.RecordDeleted, 'N') = 'N'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND S.DischargedDate IS NOT NULL
							AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8697
					AND R.MeasureSubTypeId = 6212

				UPDATE R
				SET R.Denominator = (
						SELECT count(DISTINCT S.ClientId)
						FROM ClientInpatientVisits S
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = S.ClientId
						INNER JOIN Clients C ON S.ClientId = C.ClientId
						INNER JOIN DOCUMENTS D ON D.ClientId = S.ClientId
						INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
						LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
						LEFT JOIN Staff St ON St.TempClientId = S.ClientId
							AND Isnull(St.NonStaffUser, 'N') = 'Y'
							AND isnull(St.RecordDeleted, 'N') = 'N'
						LEFT JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
							AND SCA.StaffId = ST.StaffId
							AND isnull(SCA.RecordDeleted, 'N') = 'N'
						WHERE S.STATUS <> 4981 --   4981 (Schedule)                    
							AND isnull(S.RecordDeleted, 'N') = 'N'
							AND isnull(BA.RecordDeleted, 'N') = 'N'
							AND isnull(CP.RecordDeleted, 'N') = 'N'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND isnull(CS.RecordDeleted, 'N') = 'N'
							--AND CP.AssignedStaffId= @StaffId              
							AND S.DischargedDate IS NOT NULL
							AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
						)
					,R.Numerator = (
						SELECT count(DISTINCT S.ClientId)
						FROM ClientInpatientVisits S
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId
						INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
							AND CP.ClientId = S.ClientId
						INNER JOIN Clients C ON S.ClientId = C.ClientId
						INNER JOIN DOCUMENTS D ON D.ClientId = c.ClientId
							AND isnull(D.RecordDeleted, 'N') = 'N'
						INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
							AND isnull(CS.RecordDeleted, 'N') = 'N'
						LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
						INNER JOIN Staff St ON St.TempClientId = S.ClientId
						INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
							AND SCA.StaffId = ST.StaffId
							AND isnull(SCA.RecordDeleted, 'N') = 'N'
						WHERE S.STATUS <> 4981 --   4981 (Schedule)                    
							AND isnull(S.RecordDeleted, 'N') = 'N'
							AND isnull(BA.RecordDeleted, 'N') = 'N'
							AND isnull(CP.RecordDeleted, 'N') = 'N'
							AND isnull(C.RecordDeleted, 'N') = 'N'
							AND S.DischargedDate IS NOT NULL
							AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
						)
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8697
					AND R.MeasureSubTypeId = 6212
					
					
					
					

				UPDATE R
				SET R.Target = 'N/A'
					,R.Result = CASE 
						WHEN isnull(R.Denominator, 0) > 0
							THEN CASE 
									WHEN EXISTS (
											SELECT 1
											FROM ClientInpatientVisits S
											INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
											INNER JOIN BedAssignments BA ON BA.ClientInpatientVisitId = s.ClientInpatientVisitId
											INNER JOIN ClientPrograms CP ON CP.ProgramId = BA.ProgramId
												AND CP.ClientId = S.ClientId
											INNER JOIN Clients C ON S.ClientId = C.ClientId
											INNER JOIN DOCUMENTS D ON D.ClientId = c.ClientId
												AND isnull(D.RecordDeleted, 'N') = 'N'
											INNER JOIN TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId
												AND isnull(CS.RecordDeleted, 'N') = 'N'
											LEFT JOIN Staff St1 ON St1.StaffId = CP.AssignedStaffId
											INNER JOIN Staff St ON St.TempClientId = S.ClientId
											INNER JOIN StaffClientAccess SCA ON SCA.ObjectId = D.DocumentId
												AND SCA.StaffId = ST.StaffId
												AND isnull(SCA.RecordDeleted, 'N') = 'N'
											WHERE S.STATUS <> 4981 --   4981 (Schedule)                      
												AND isnull(S.RecordDeleted, 'N') = 'N'
												AND isnull(BA.RecordDeleted, 'N') = 'N'
												AND isnull(CP.RecordDeleted, 'N') = 'N'
												AND isnull(C.RecordDeleted, 'N') = 'N'
												AND S.DischargedDate IS NOT NULL
												AND cast(S.DischargedDate AS DATE) >= CAST(@StartDate AS DATE)
												AND cast(S.DischargedDate AS DATE) <= CAST(@EndDate AS DATE)
											)
										THEN '<span style="color:green">Met</span>'
									ELSE '<span style="color:red">Not Met</span>'
									END
						ELSE '<span style="color:red">Not Met</span>'
						END
				FROM #ResultSet R
				WHERE R.MeasureTypeId = 8697
					AND R.MeasureSubTypeId = 6212
			END
		END

		UPDATE R
		SET R.ActualResult = CASE 
				WHEN isnull(R.Denominator, 0) > 0
					THEN round((cast(R.Numerator AS FLOAT) * 100) / cast(R.Denominator AS FLOAT), 0)
				ELSE 0
				END
			,R.Result = CASE 
				WHEN isnull(R.Denominator, 0) > 0
					THEN CASE 
							WHEN round(cast(cast(R.Numerator AS FLOAT) / cast(R.Denominator AS FLOAT) * 100 AS DECIMAL(10, 0)), 0) >= cast([Target] AS DECIMAL(10, 0))
								THEN '<span style="color:green">Met</span>'
							ELSE '<span style="color:red">Not Met</span>'
							END
				ELSE '<span style="color:red">Not Met</span>'
				END
			,R.[Target] = R.[Target]
		FROM #ResultSet R

		SELECT Stage
			,MeasureType
			,MeasureTypeId
			,MeasureSubTypeId
			,[Target]
			,DetailsType
			,ReportPeriod
			,ProviderName
			,ISNULL(Numerator,0) as Numerator
			,ISNULL(Denominator,0) as Denominator
			,ActualResult
			,Result
			,DetailsSubType
			,ProblemList
		FROM #ResultSet
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCPatientPortalHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


