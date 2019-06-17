IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSCSummaryCareHospitalization]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSCSummaryCareHospitalization]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLSCSummaryCareHospitalization] (
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
-- Stored Procedure: dbo.ssp_RDLSCMedicationReconciliationHospitalization            
--          
-- Copyright: Streamline Healthcate Solutions       
--          
-- Updates:                                                                 
-- Date			Author   Purpose          
-- 04-Nov-2014  Revathi  What:Medication Hospitalization.                
--							Why:task #22 Certification 2014    
-- 11-Jan-2016  Ravi     What : Change the code for Stage 9373 'Stage2 - Modified' requirement
						 why : Meaningful Use, Task	#66 - Stage 2 - Modified    
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
	
		IF @MeasureType <> 8700  OR  @InPatient <> 1
			 BEGIN  
			   RETURN  
			  END   
		
		DECLARE @MeaningfulUseStageLevel VARCHAR(10)
		DECLARE @ProviderName VARCHAR(40)
		DECLARE @ReportPeriod VARCHAR(100)

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

		IF @MeaningfulUseStageLevel = 8766
			OR @MeaningfulUseStageLevel = 8767 -- Stage1          
		BEGIN
			UPDATE R
			SET R.Numerator = isnull((
						SELECT count(DISTINCT D.DocumentId)
						FROM Documents D
						INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						INNER JOIN Clients C ON S.ClientId = C.ClientId
							AND isnull(C.RecordDeleted, 'N') = 'N'
						WHERE D.DocumentCodeId = 1611 -- Summary of Care                   
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND d.STATUS = 22
							AND CAST(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
							AND isnull(S.RecordDeleted, 'N') = 'N'
							AND (
								cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
						), 0)
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8700
				AND (
					@MeaningfulUseStageLevel = 8766
					OR (
						@MeaningfulUseStageLevel = 8767
						AND @MeasureSubType = 6213
						)
					)

			CREATE TABLE #RES6 (
				ClientId INT
				,ProviderName VARCHAR(250)
				,EffectiveDate VARCHAR(100)
				,DateExported VARCHAR(100)
				,DocumentVersionId INT
				)

			INSERT INTO #RES6 (
				ClientId
				,ProviderName
				,EffectiveDate
				,DateExported
				,DocumentVersionId
				)
			SELECT DISTINCT D.ClientId
				,'' AS ProviderName
				,CONVERT(VARCHAR, D.EffectiveDate, 101)
				,CONVERT(VARCHAR, T.ExportedDate, 101)
				,ISNULL(D.CurrentDocumentVersionId, 0)
			FROM Documents D
			INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId
				AND isnull(S.RecordDeleted, 'N') = 'N'
			INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
			INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId
				--AND T.ExportedDate IS NOT NULL                
				AND isnull(T.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON S.ClientId = C.ClientId
				AND isnull(C.RecordDeleted, 'N') = 'N'
			WHERE D.DocumentCodeId = 1611 -- Summary of Care                     
				AND isnull(D.RecordDeleted, 'N') = 'N'
				AND d.STATUS = 22
				AND (
					cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				--AND NOT EXISTS (
				--	SELECT 1
				--	FROM #OrgExclusionDates OE
				--	WHERE CAST(D.EffectiveDate AS DATE) = OE.Dates
				--		AND OE.MeasureType = 8700
				--		AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
				--	)
				AND D.EffectiveDate >= CAST(@StartDate AS DATE)
				AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)

			INSERT INTO #RES6 (
				ClientId
				,ProviderName
				,EffectiveDate
				,DateExported
				,DocumentVersionId
				)
			SELECT DISTINCT CO.ClientId
				,'' AS ProviderName
				,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
				,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
				,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
			FROM ClientOrders CO
			INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId
				AND isnull(S.RecordDeleted, 'N') = 'N'
			INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
			INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
				AND isnull(OS.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON S.ClientId = C.ClientId
				AND isnull(C.RecordDeleted, 'N') = 'N'
			WHERE isnull(CO.RecordDeleted, 'N') = 'N'
				AND OS.OrderId = 148 -- Referral/Transition Request               
				AND (
					cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				--AND NOT EXISTS (
				--	SELECT 1
				--	FROM #OrgExclusionDates OE
				--	WHERE CAST(CO.OrderStartDateTime AS DATE) = OE.Dates
				--		AND OE.MeasureType = 8700
				--		AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
				--	)
				--and CO.OrderStatus <> 6510 -- Order discontinued                    
				AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
				AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)

			INSERT INTO #RES6 (
				ClientId
				,ProviderName
				,EffectiveDate
				,DateExported
				,DocumentVersionId
				)
			SELECT DISTINCT CO.ClientId
				,'' AS ProviderName
				,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
				,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
				,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
			FROM ClientPrimaryCareExternalReferrals CO
			INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId
				AND isnull(S.RecordDeleted, 'N') = 'N'
				AND S.ClientId NOT IN (
					SELECT ClientId
					FROM #RES6
					)
			INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
			INNER JOIN Clients C ON S.ClientId = C.ClientId
				AND isnull(C.RecordDeleted, 'N') = 'N'
			WHERE isnull(CO.RecordDeleted, 'N') = 'N'
				AND (
					cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				--AND NOT EXISTS (
				--	SELECT 1
				--	FROM #OrgExclusionDates OE
				--	WHERE CAST(CO.ModifiedDate AS DATE) = OE.Dates
				--		AND OE.MeasureType = 8700
				--		AND Isnull(OE.OrganizationExclusion, 'N') = 'Y'
				--	)
				--and CO.OrderStatus <> 6510 -- Order discontinued                    
				AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
				AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)

			UPDATE R
			SET R.Denominator = (
					SELECT count(*)
					FROM #RES6
					)
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8700
				AND (
					@MeaningfulUseStageLevel = 8766
					OR (
						@MeaningfulUseStageLevel = 8767
						AND @MeasureSubType = 6213
						)
					)
		END

		IF @MeaningfulUseStageLevel = 8767
		-- 11-Jan-2016  Ravi 
			OR @MeaningfulUseStageLevel = 9373 --  Stage2  or  'Stage2 - Modified'      
		BEGIN
			--Measure2        
			CREATE TABLE #RES7 (
				ClientId INT
				,ProviderName VARCHAR(250)
				,EffectiveDate VARCHAR(100)
				,DateExported VARCHAR(100)
				,DocumentVersionId INT
				)

			INSERT INTO #RES7 (
				ClientId
				,ProviderName
				,EffectiveDate
				,DateExported
				,DocumentVersionId
				)
			SELECT DISTINCT S.ClientId
				,'' AS ProviderName
				,CONVERT(VARCHAR, D.EffectiveDate, 101)
				,CONVERT(VARCHAR, T.ExportedDate, 101)
				,ISNULL(D.CurrentDocumentVersionId, 0)
			FROM Documents D
			INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId
				AND isnull(S.RecordDeleted, 'N') = 'N'
			INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
			INNER JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.CurrentDocumentVersionId
				--AND T.ExportedDate IS NOT NULL                
				AND isnull(T.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON S.ClientId = C.ClientId
				AND isnull(C.RecordDeleted, 'N') = 'N'
			WHERE D.DocumentCodeId = 1611 -- Summary of Care                     
				AND isnull(D.RecordDeleted, 'N') = 'N'
				AND d.STATUS = 22
				AND (
					cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				AND D.EffectiveDate >= CAST(@StartDate AS DATE)
				AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)

			INSERT INTO #RES7 (
				ClientId
				,ProviderName
				,EffectiveDate
				,DateExported
				,DocumentVersionId
				)
			SELECT DISTINCT CO.ClientId
				,'' AS ProviderName
				,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
				,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
				,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
			FROM ClientOrders CO
			INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId
				AND isnull(S.RecordDeleted, 'N') = 'N'
			INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
			INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
				AND isnull(OS.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON S.ClientId = C.ClientId
				AND isnull(C.RecordDeleted, 'N') = 'N'
			WHERE isnull(CO.RecordDeleted, 'N') = 'N'
				AND OS.OrderId = 148 -- Referral/Transition Request                  
				--and CO.OrderStatus <> 6510 -- Order discontinued                
				AND (
					cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				AND cast(CO.OrderStartDateTime AS DATE) >= CAST(@StartDate AS DATE)
				AND cast(CO.OrderStartDateTime AS DATE) <= CAST(@EndDate AS DATE)

			INSERT INTO #RES7 (
				ClientId
				,ProviderName
				,EffectiveDate
				,DateExported
				,DocumentVersionId
				)
			SELECT DISTINCT CO.ClientId
				,'' AS ProviderName
				,'' --,CONVERT(VARCHAR,D.EffectiveDate,101)                  
				,'' --,CONVERT(VARCHAR,T.ExportedDate,101)                  
				,0 --,ISNULL(D.CurrentDocumentVersionId,0)                    
			FROM ClientPrimaryCareExternalReferrals CO
			INNER JOIN ClientInpatientVisits S ON CO.ClientId = S.ClientId
				AND isnull(S.RecordDeleted, 'N') = 'N'
				AND S.ClientId NOT IN (
					SELECT ClientId
					FROM #RES7
					)
			INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
			INNER JOIN Clients C ON S.ClientId = C.ClientId
				AND isnull(C.RecordDeleted, 'N') = 'N'
			WHERE isnull(CO.RecordDeleted, 'N') = 'N'
				--and CO.OrderStatus <> 6510 -- Order discontinued                    
				AND cast(CO.ReferralDate AS DATE) >= CAST(@StartDate AS DATE)
				AND cast(CO.ReferralDate AS DATE) <= CAST(@EndDate AS DATE)
				AND (
					cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
					AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
					)
				AND S.ClientId NOT IN (
					SELECT ClientId
					FROM #RES7
					)

			UPDATE R
			SET R.Denominator = (
					SELECT count(*)
					FROM #RES7
					)
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8700
				AND R.MeasureSubTypeId = 6214

			UPDATE R
			SET R.Numerator = isnull((
						SELECT count(DISTINCT D.DocumentId)
						FROM Documents D
						INNER JOIN ClientInpatientVisits S ON D.ClientId = S.ClientId
							AND isnull(S.RecordDeleted, 'N') = 'N'
						INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType
						INNER JOIN STAFFCLIENTACCESS SCA ON SCA.ClientId = D.ClientId
							AND SCA.Screenid = 891
							AND SCA.ActivityType = 'N'
							AND isnull(SCA.RecordDeleted, 'N') = 'N'
						INNER JOIN Clients C ON S.ClientId = C.ClientId
							AND isnull(C.RecordDeleted, 'N') = 'N'
						WHERE D.DocumentCodeId = 1611 -- Summary of Care                   
							AND isnull(D.RecordDeleted, 'N') = 'N'
							AND d.STATUS = 22
							AND (
								cast(S.AdmitDate AS DATE) >= CAST(@StartDate AS DATE)
								AND cast(S.AdmitDate AS DATE) <= CAST(@EndDate AS DATE)
								)
							AND EXISTS (
								SELECT 1
								FROM TransitionOfCareDocuments TOC
								WHERE isnull(TOC.RecordDeleted, 'N') = 'N'
									AND TOC.DocumentVersionId = D.InProgressDocumentVersionId
								)
							AND cast(D.EffectiveDate AS DATE) >= CAST(@StartDate AS DATE)
							AND cast(D.EffectiveDate AS DATE) <= CAST(@EndDate AS DATE)
						), 0)
			FROM #ResultSet R
			WHERE R.MeasureTypeId = 8700
				AND R.MeasureSubTypeId = 6214
		END

		/*8700--(Medication Reconciliation)*/
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
			,Numerator
			,Denominator
			,ActualResult
			,Result
			,DetailsSubType
			,ProblemList
		FROM #ResultSet
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSCSummaryCareHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


