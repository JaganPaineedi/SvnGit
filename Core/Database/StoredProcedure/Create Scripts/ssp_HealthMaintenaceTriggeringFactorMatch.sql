
/****** Object:  StoredProcedure [dbo].[ssp_HealthMaintenaceTriggeringFactorMatch]    Script Date: 08/12/2014 19:07:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_HealthMaintenaceTriggeringFactorMatch]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_HealthMaintenaceTriggeringFactorMatch]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_HealthMaintenaceTriggeringFactorMatch] (
	@ParamClientId INT
	,@ParamStaffId INT
	,@ParamHealthMaintenanceTriggeringFactorId INT
	,@ParamPerformCheckClientDocVerId INT
	,@ParamPerformCheckClientMedId INT
	,@ParamPerformCheckClientProcId INT
	,@ParamPerformCheckClientHealthDataAttrId INT
	,@ParamPerformCheckClientAllergyId INT
	,@ParamRetValue CHAR(1) OUTPUT
	,@ParamClientDocVerId INT OUTPUT
	,@ParamClientMedId INT OUTPUT
	,@ParamClientProcId INT OUTPUT
	,@ParamClientHealthDataAttrId INT OUTPUT
	,@ParamClientAllergyId INT OUTPUT
	)
AS

/****** Object:  StoredProcedure [dbo].[ssp_HealthMaintenaceTriggeringFactorMatch]    Script Date: 08/12/2014 19:07:17 ******/
/********************************************************************************************/                                                                    
/* Stored Procedure: sp_HealthMaintenaceTriggeringFactorMatch          */                                                           
/* Copyright: 2012 Streamline Healthcare Solutions           */                                                                    
/* Creation Date:  18 July 2014 by Prasan               */                                                                    
/* Purpose: Gets Data from PrimaryCate Health Maintenance Template */                                                                   
/* Input Parameters:  @HealthMaintenanceTriggeringFactorGroupId                    */                                                                  
/* Output Parameters:                  */                                                                    
/* Return:                     */  
/* Data Modifications:                  */
/* 18 July 2014    Prasan   Created   */    
/* 3 Nov  2014	   Ponnin		   Health Maintenance Alert popup will display for signed Diagnosis-New document. 
									Why : For task #4 of Certification 2014 */  
/* 11 Dec 2014	   Ponnin			Condition modified as >= instead of > for the parameters @ParamPerformCheckClientDocVerId, @ParamPerformCheckClientMedId, @ParamPerformCheckClientProcId etc Why : For task #4 of Certification 2014 */  
/* 8  Jan 2015	   Ponnin			Added Union for Health Data Attributes Factor, To display alert popup on save of Client orders. Why : For task #64 of Certification 2014 */  
/* 21 Dec 2015	   Ponnin			Removed logic of DiagnosesIIICodes and ICD9code check. For task #14 of Diagnosis Changes (ICD10) */
/* 03 Oct 2017	   Varun			Modified Gender Factor section. For task #58 Meaningful Use-Stage 3 */
/* 24 Oct 2018	   Ravi			    added temp table #CurrentDocumentVersionIdList to list all current DocumentVersionId's and checked exists condition to improve performance. For task Journey-Support Go Live #314 */
/* 07 Dec 2018	   Jeffin			Changed logic of matching health triggers from a range of values also implemented dropdown functionality. Why : For task #38 of Meaningful Use - Stage 3 */
/********************************************************************************************/ 

BEGIN
 
BEGIN TRY
	SELECT @ParamRetValue = 'N'
		,@ParamClientDocVerId = 0
		,@ParamClientMedId = 0
		,@ParamClientProcId = 0
		,@ParamClientHealthDataAttrId = 0
		,@ParamClientAllergyId = 0
		
		DECLARE @PerformCheckClientOrderObservationsId  INT
		SET @PerformCheckClientOrderObservationsId = (SELECT MAX(ClientOrderObservationId) from clientOrderObservations where ISNULL(RecordDeleted, 'N') = 'N') 

	-- initializing with 0 if null	
	SELECT @ParamPerformCheckClientDocVerId = COALESCE(@ParamPerformCheckClientDocVerId, 0)
		,@ParamPerformCheckClientMedId = COALESCE(@ParamPerformCheckClientMedId, 0)
		,@ParamPerformCheckClientProcId = COALESCE(@ParamPerformCheckClientProcId, 0)
		,@ParamPerformCheckClientHealthDataAttrId = COALESCE(@ParamPerformCheckClientHealthDataAttrId, 0)
		,@ParamPerformCheckClientAllergyId = COALESCE(@ParamPerformCheckClientAllergyId, 0)
		,@PerformCheckClientOrderObservationsId =  COALESCE(@PerformCheckClientOrderObservationsId, 0)

	DECLARE @TriggeringFactor INT = 0
		,@FromTimeYear INT
		,@ToTimeYear INT
		,@FromTimeMonth INT
		,@ToTimeMonth INT
		,@Gender CHAR(1);

	SELECT @TriggeringFactor = HMTF.TrigerringFactor
		,@FromTimeYear = ISNULL(HMTF.FromTimeYear, 0)
		,@FromTimeMonth = ISNULL(HMTF.FromTimeMonth, 0)
		,@ToTimeYear = ISNULL(HMTF.ToTimeYear, 0)
		,@ToTimeMonth = ISNULL(HMTF.ToTimeMonth, 0)
		,@Gender = HMTF.Gender
	FROM HealthMaintenanceTriggeringFactors HMTF
	WHERE HMTF.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
		AND ISNULL(HMTF.RecordDeleted, 'N') = 'N'

	---(1)AGE Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8116)
	BEGIN
		DECLARE @ClientDOB DATETIME;
		DECLARE @clientYearsPart INT
			,@clientMonthsPart INT;

		SELECT @ClientDOB = c.DOB
		FROM clients c
		WHERE c.ClientId = @ParamClientId;

		IF (@ClientDOB IS NOT NULL)
		BEGIN
			SELECT @clientYearsPart = diffYearsPart
				,@clientMonthsPart = diffMonthsPart
			FROM dbo.ssf_getDateDiffInYearsMonthsDays(@ClientDOB, GETDATE())

			IF (
					@clientYearsPart > @FromTimeYear
					OR (
						@clientYearsPart = @FromTimeYear
						AND @clientMonthsPart >= @FromTimeMonth
						)
					)
			BEGIN
				SET @ParamRetValue = 'Y';

				IF (
						@ToTimeYear > 0
						OR @ToTimeMonth > 0
						) --if to time exists
				BEGIN
					SET @ParamRetValue = 'N';

					IF (
							@clientYearsPart < @ToTimeYear
							OR (
								@clientYearsPart = @ToTimeYear
								AND @clientMonthsPart <= @ToTimeMonth
								)
							)
					BEGIN
						SET @ParamRetValue = 'Y';
					END
				END
			END
		END
				--SELECT @clientYearsPart ClientYrs
				--	,@clientMonthsPart ClientMon
				--	,@FromTimeYear fromYrs
				--	,@FromTimeMonth fromMon
				--	,@ToTimeYear toYrs
				--	,@ToTimeMonth toMon
				--	,@ParamRetValue RetValue
				--  ,@ParamHealthMaintenanceTriggeringFactorId FactorID
	END
			---(1) ENDS----------------------------------------------------------------------------------------
	ELSE
	---(2)GENDER Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8120)
	BEGIN
		IF (@Gender = 'A')
		BEGIN
			SET @ParamRetValue = 'Y';
		END
		ELSE
		BEGIN
			SELECT @ParamRetValue = CASE 
					WHEN c.Sex = @Gender
						THEN 'Y'
					ELSE 'N'
					END
			FROM clients c
			WHERE c.ClientId = @ParamClientId;
		END
				--SELECT @Gender GENDER
				--	,@ParamRetValue RetValue
				--	,@ParamHealthMaintenanceTriggeringFactorId FactorID
	END
			---(2) ENDS----------------------------------------------------------------------------------------
	ELSE
	---(3)MEDICATIONS Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8117)
	BEGIN
		SELECT @ParamClientMedId = MAX(cm.ClientMedicationId)
		FROM ClientMedications cm

		SELECT @ParamRetValue = CASE 
				WHEN COUNT(*) > 0
					THEN 'Y'
				ELSE 'N'
				END
		FROM ClientMedications cm
		WHERE cm.ClientMedicationId >= @ParamPerformCheckClientMedId 
			AND cm.ClientMedicationId <= @ParamClientMedId
			AND cm.ClientId = @ParamClientId
			AND ISNULL(cm.Discontinued, 'N') = 'N'
			AND ISNULL(cm.RecordDeleted, 'N') = 'N'
			AND CAST(cm.MedicationNameId AS VARCHAR) IN (
				SELECT HMTFD.CodeId
				FROM HealthMaintenanceTriggeringFactorDetails HMTFD
				WHERE HMTFD.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
					AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
				)
	END
			---(3) ENDS----------------------------------------------------------------------------------------
	ELSE
	---(4)PROCEDURES Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8118)
	BEGIN
		SELECT @ParamClientProcId = MAX(CP.ClientProcedureId)
		FROM ClientProcedures CP

		SELECT @ParamRetValue = CASE 
				WHEN COUNT(*) > 0
					THEN 'Y'
				ELSE 'N'
				END
		FROM ClientProcedures CP
		INNER JOIN PCProcedureCodes PPC ON PPC.PCProcedureCodeId = CP.ProcedureId
			AND PPC.Active = 'Y'
			AND ISNULL(PPC.RecordDeleted, 'N') = 'N'
		INNER JOIN HealthMaintenanceTriggeringFactorDetails HMTFD ON HMTFD.CodeId = PPC.ProcedureCode
			AND HMTFD.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
			AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
		WHERE CP.ClientProcedureId >= @ParamPerformCheckClientProcId
			AND CP.ClientProcedureId <= @ParamClientProcId
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			AND CP.ClientId = @ParamClientId
			--AND ISNULL(CP.Completed,'N') = 'Y'
			--AND (CP.OrderDate is NULL OR CAST(CP.OrderDate As DATE)<CAST(getdate() AS DATE)  )
			--SELECT @ParamRetValue = CASE 
			--		WHEN COUNT(*) > 0
			--			THEN 'Y'
			--		ELSE 'N'
			--		END
			--FROM ClientProcedures CP
			--INNER JOIN (
			--	SELECT PCProcedureCodeId
			--	FROM PCProcedureCodes PPC
			--	INNER JOIN HealthMaintenanceTriggeringFactorDetails HMTFD ON HMTFD.CodeId = PPC.ProcedureCode
			--		AND HMTFD.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
			--		AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
			--	WHERE PPC.Active = 'Y'
			--		AND ISNULL(PPC.RecordDeleted, 'N') = 'N'
			--	) t ON CP.ProcedureId = t.PCProcedureCodeId
			--WHERE CP.ClientProcedureId > @ParamPerformCheckClientProcId
			--	AND CP.ClientProcedureId <= @ParamClientProcId
			--	AND ISNULL(CP.RecordDeleted, 'N') = 'N'
			--	AND CP.ClientId = @ParamClientId
			--	--AND ISNULL(CP.Completed,'N') = 'Y'
			--	--AND (CP.OrderDate is NULL OR CAST(CP.OrderDate As DATE)<CAST(getdate() AS DATE)  )
	END
			---(4) ENDS----------------------------------------------------------------------------------------
	ELSE
	---(5)DIAGNOSIS Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8119)
	BEGIN
		IF (OBJECT_ID('tempdb..#tmpDocuments') IS NOT NULL)
		BEGIN
			DROP TABLE #tmpDocuments
		END

		SELECT @ParamClientDocVerId = MAX(DV.DocumentVersionId)
		FROM DocumentVersions DV


--24 Oct 2018	   Ravi	
CREATE TABLE #CurrentDocumentVersionIdList (CurrentDocumentVersionId INT)

INSERT INTO #CurrentDocumentVersionIdList (CurrentDocumentVersionId)
SELECT CurrentDocumentVersionId
FROM Documents D
WHERE D.ClientId = @ParamClientId
	AND D.STATUS = 22
	AND CAST(D.EffectiveDate AS DATE) <= CAST(GETDATE() AS DATE)
	AND ISNULL(D.RecordDeleted, 'N') = 'N'
	AND D.CurrentDocumentVersionId >= @ParamPerformCheckClientDocVerId
	AND D.CurrentDocumentVersionId <= @ParamClientDocVerId

		
	-- Modified by Ponnin on 21 Dec 2015 - For task #14 of Diagnosis Changes (ICD10)
		SELECT @ParamRetValue = CASE 
		WHEN COUNT(*) > 0
			THEN 'Y'
		ELSE 'N'
		END
		FROM DocumentCodes DC
		INNER JOIN Documents D ON D.DocumentCodeId = DC.DocumentCodeId
		INNER JOIN DocumentDiagnosisCodes DDC ON DDC.DocumentVersionId = D.CurrentDocumentVersionId
			AND ISNULL(DDC.RecordDeleted, 'N') = 'N'
		INNER JOIN HealthMaintenanceTriggeringFactorDetails HMTFD ON HMTFD.CodeId = DDC.ICD10Code
			AND HMTFD.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
			AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(DC.DiagnosisDocument, 'N') = 'Y'
			AND isNull(DC.RecordDeleted, 'N') = 'N'
			AND DC.Active = 'Y'
			AND EXISTS (								--24 Oct 2018	   Ravi	
				SELECT 1
				FROM #CurrentDocumentVersionIdList T
				WHERE D.CurrentDocumentVersionId = T.CurrentDocumentVersionId
				)

	END
			---(5) ENDS----------------------------------------------------------------------------------------	
	ELSE
	---(6)Health Data Attributes Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8121)
	BEGIN
		SELECT @ParamClientHealthDataAttrId = MAX(CHD.ClientHealthDataAttributeId)
		FROM ClientHealthDataAttributes CHD
		
			CREATE TABLE #tmpHealthDataAttributeFactor (
			RetValue CHAR(1) 
			)
			
		INSERT INTO #tmpHealthDataAttributeFactor 
			
				SELECT  CASE 
						WHEN COUNT(*) > 0
							THEN 'Y'
							ELSE 'N'
							END
			FROM CLIENTORDERS CO
			INNER JOIN ClientOrderResults COR ON COR.ClientOrderId = CO.ClientOrderId
				  AND ISNULL(COR.RecordDeleted, 'N') = 'N'
			INNER JOIN clientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId
				  AND ISNULL(COO.RecordDeleted, 'N') = 'N'
			INNER JOIN Observations O ON O.ObservationId = COO.ObservationId
				  AND ISNULL(O.RecordDeleted, 'N') = 'N'
			INNER JOIN HealthDataAttributes HDA ON HDA.LOINCCode = O.LOINCCode
				  AND ISNULL(HDA.RecordDeleted, 'N') = 'N'
			INNER JOIN HealthMaintenanceTriggeringFactorDetails HMTFD ON HMTFD.Codeid = HDA.HealthDataAttributeId
				  AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
			INNER JOIN HealthMaintenanceTriggeringFactors HMTF ON HMTF.HealthMaintenanceTriggeringFactorId = HMTFD.HealthMaintenanceTriggeringFactorId
				  AND ISNULL(HMTF.RecordDeleted, 'N') = 'N'
			WHERE CO.CLIENTID = @ParamClientId
				  AND HMTF.TrigerringFactor = 8121
				  AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				  AND COO.ClientOrderObservationId >= @PerformCheckClientOrderObservationsId
				  AND HMTFD.HealthDataAttributeValue = COO.Value
				  
				  UNION
				  
			SELECT  CASE 
				WHEN COUNT(*) > 0
					THEN 'Y'
				ELSE 'N'
				END
		FROM (
			SELECT *
				,CASE 
					--Modified by Jeffin on 07 Dec 2018 - For task #38 of Meaningful Use - Stage 3
					WHEN t.DataType = 8082
						OR t.DataType = 8083 -- 8082(Decimal), 8083(Numeric)
						THEN 
							CASE 
								WHEN CHARINDEX('-',t.HealthDataAttributeValue) > 0
									THEN 
										CASE 
											WHEN cast(t.Value AS DECIMAL) 
											BETWEEN cast((SELECT item FROM [dbo].fnSplitWithIndex (t.HealthDataAttributeValue,'-') WHERE [index]=0) AS DECIMAL) 
											AND cast((SELECT item FROM [dbo].fnSplitWithIndex (t.HealthDataAttributeValue,'-') WHERE [index]=1) AS DECIMAL)
											THEN 'Y'
											ELSE 'N'
										END
									ELSE 
										CASE 
											WHEN cast(t.HealthDataAttributeValue AS DECIMAL) = cast(t.Value AS DECIMAL)
											THEN 'Y'
											ELSE 'N'
										END
							END	
								
					WHEN t.DataType = 8081-- 8081(DropDown-int)
						THEN CASE 
								WHEN cast(t.Value AS DECIMAL) IN (SELECT VALUE FROM [dbo].fn_CommaSeparatedStringToTable (t.HealthDataAttributeValue,'N'))
									THEN 'Y'
								ELSE 'N'
								END
								
								
					WHEN t.DataType = 8084
						OR t.DataType = 8087 -- 8084(Character),  8087(Multiline)
						THEN CASE 
								WHEN rtrim(ltrim(cast(t.HealthDataAttributeValue AS VARCHAR(max)))) = rtrim(ltrim(cast(t.Value AS VARCHAR(max))))
									THEN 'Y'
								ELSE 'N'
								END
					WHEN t.DataType = 8085 --CheckBox
						THEN CASE 
								WHEN cast(t.HealthDataAttributeValue AS CHAR(1)) = cast(t.Value AS CHAR(1))
									THEN 'Y'
								ELSE 'N'
								END
					WHEN t.DataType = 8086 --Formula
						THEN CASE 
								WHEN t.HealthDataAttributeValue = t.Value
									THEN 'Y'
								ELSE 'N'
								END
					WHEN t.DataType = 8089 --Date
						THEN CASE 
								WHEN cast(t.HealthDataAttributeValue AS DATETIME) = cast(t.Value AS DATETIME)
									THEN 'Y'
								ELSE 'N'
								END
					END AS 'ValueMatched'
			FROM (
				SELECT CHD.ClientHealthDataAttributeId
					,HMTFD.CodeId
					,CHD.HealthDataAttributeId
					,HDA.DataType
					,GC.CodeName
					,HMTFD.HealthDataAttributeValue
					,CHD.Value
				FROM ClientHealthDataAttributes CHD
				INNER JOIN HealthMaintenanceTriggeringFactorDetails HMTFD ON HMTFD.CodeId = CHD.HealthDataAttributeId
					AND HMTFD.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
					AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
					AND ISNULL(HMTFD.HealthDataAttributeValue,'') <> ''
				INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = CHD.HealthDataAttributeId
					AND ISNULL(HDA.RecordDeleted, 'N') = 'N'
				LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDA.DataType
				WHERE CHD.ClientHealthDataAttributeId >= @ParamPerformCheckClientHealthDataAttrId
					AND CHD.ClientHealthDataAttributeId <= @ParamClientHealthDataAttrId
					AND CHD.ClientId = @ParamClientId
					AND ISNULL(CHD.RecordDeleted, 'N') = 'N'
				) t
			) t2 	where ISNULL(t2.ValueMatched,'N') = 'Y';
				  
				  SELECT @ParamRetValue =  CASE 
				WHEN COUNT(*) > 0
					THEN 'Y'
				ELSE 'N'
				END
		FROM #tmpHealthDataAttributeFactor tDAF where  tDAF.RetValue = 'Y'

	END

	---(6) ENDS----------------------------------------------------------------------------------------	
	---(7)Allergies Factor----------------------------------------------------------------------------------------
	IF (@TriggeringFactor = 8122)
	BEGIN
		SELECT @ParamClientAllergyId = MAX(CA.ClientAllergyId)
		FROM ClientAllergies CA

		SELECT @ParamRetValue = CASE 
				WHEN COUNT(*) > 0
					THEN 'Y'
				ELSE 'N'
				END
		FROM ClientAllergies CA
		INNER JOIN HealthMaintenanceTriggeringFactorDetails HMTFD ON HMTFD.CodeId = CA.AllergenConceptId
			AND HMTFD.HealthMaintenanceTriggeringFactorId = @ParamHealthMaintenanceTriggeringFactorId
			AND ISNULL(HMTFD.RecordDeleted, 'N') = 'N'
		WHERE CA.ClientAllergyId >= @ParamPerformCheckClientAllergyId
			AND CA.ClientAllergyId <= @ParamClientAllergyId
			AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CA.Active,'Y') = 'Y'
			AND CA.ClientId = @ParamClientId
			
	END
			---(7) ENDS----------------------------------------------------------------------------------------
	-----(8) drop temp tables----------------------------------------------			
	IF (OBJECT_ID('tempdb..#tmpDocuments') IS NOT NULL)
	BEGIN
		DROP TABLE #tmpDocuments
	END
	
	IF (OBJECT_ID('tempdb..#tmpDiagnosisFactors') IS NOT NULL)
	BEGIN
		DROP TABLE #tmpDiagnosisFactors
	END
	
	IF (OBJECT_ID('tempdb..#tmpHealthDataAttributeFactor') IS NOT NULL)
	BEGIN
		DROP TABLE #tmpHealthDataAttributeFactor
	END
	

			-----(8) ENDS----------------------------------------------------------		
			
                       
END TRY                              
BEGIN CATCH                              
 DECLARE @Error varchar(8000)                                                                             
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_HealthMaintenaceTriggeringFactorMatch')                                                                                                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
    + '*****' + Convert(varchar,ERROR_STATE())                                                        
 RAISERROR                                                                                                           
 (                                 
   @Error, -- Message text.                                           
   16, -- Severity.                                                                                                          
   1 -- State.                                                                                                          
  );                               
END CATCH                              
END	
GO

