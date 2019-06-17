GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedOrderTypeDetails]    Script Date: 10/21/2013 15:31:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = Object_id(N'[dbo].[ssp_SCGetSelectedOrderTypeDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetSelectedOrderTypeDetails]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedOrderTypeDetails]    Script Date: 10/21/2013 15:31:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Ssp_scgetselectedordertypedetails] @OrderId INT,
@ClientId INT = 0
AS
/*********************************************************************/
/* Stored Procedure: [Ssp_scgetselectedordertypedetails] 2    */
/* Creation Date:  27/June/2013                                      */
/* Purpose: To get Selected Order details For Order Entry    */
/* Input Parameters:@OrderId           */
/* Output Parameters:             */
/* Returns The Table of Orders,OrderStrengths,OrderFrequencies   */
/* Called By:                                                        */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date          Author    Purpose            */
/* 27/June/2013  S Ganesh  Created          */
/* 23/July/2013  Prasan    added OrderQuestions          */
/* 03/Oct/2013  Prasan    added Units          */
/* 04/Oct/2013  Prasan    added Legal && Level     */
/* 24/Apr/2014  PPOTNURU  Verifying active check*/
/* 26/Oct/2014  PPOTNURU  Getting Loinic Code for lab orders*/
/* 16/Mar/2015  Varun  added SensitiveOrder to Order Details*/
/* 14/Jul/2015  Chethan  What : Retrieving GlobalCodes to bind Rationale drop down based on Order Type
						 Why : Philhaven Development task# 328 */
/* 04/Aug/2015  Chethan  What : Sorting of Rationale Global Codes
						 Why : Philhaven Development task# 355 */
/* 07/12/2015	Chethan N	What : Added table 'OrderLabs' and columns 'LaboratoryId' and 'QuestionCode' to OrderQuestions 
							Why : Streamline Administration task #153*/
/* 07/12/2015	Pradeep A	What : Added Orders.DrawFromServiceCenter
							Why : Streamline Administration task #153*/	
/* 07/12/2015	Chethan N	What : Added ClientId Parameter and Retrieving Client Current Diagnosis.
							Why : Core Bugs task #2062*/	
/* 27 Dec 2016	 Chethan N	What: Retrieving Potency Units.
							Why:  Renaissance - Dev Items task #5	*/ 		
/* 16 Jan 2017	 Chethan N	What: Retrieving 'Other' strength only when SystemConfigurationKeys.COMPLETEORDERTORX = 'N'.
							Why:  Renaissance - Dev Items task #5	*/	
/* 15 Mar 2017	Chethan N	What : Added NULL check to LaboratoryId to get Order Questions.
							Why : Key Point - Support Go Live task #365 */			
/* 28/Mar/2017	Chethan N	What: Adding 'Other' Schedule option if it is not addedd for the Order.
							Why:  Renaissance - Dev Items task #5.1	*/	
/* 23/Aug/2017  Anto		What: Modified the logic to display diagnosis added through Problem detail along with DSM5 Diagnosis   
							Why: WRT Andrews Center - Environment Issues Tracking #64 */ 
/* 08/May/2018  Shankha		What: Modified the logic to display distinct Labs */
/* 02/Jul/2018	Chethan N	What : Retrieving Locations.
							Why : Engineering Improvement Initiatives- NBL(I) task #667		*/	 							  																	
/*********************************************************************/
BEGIN
	DECLARE @IsOrderActive VARCHAR(1)
	DECLARE @COMPLETEORDERTORX VARCHAR(1)

	SELECT @IsOrderActive = Isnull(O.Active, 'Y')
	FROM Orders AS O
	WHERE O.OrderId = @OrderId
		AND Isnull(O.Active, 'Y') = 'Y'
		AND Isnull(O.RecordDeleted, 'N') = 'N'

	SELECT @COMPLETEORDERTORX = ISNULL(SCK.[Value], 'N')
	FROM SystemConfigurationKeys SCK WHERE SCK.[Key] = 'COMPLETEORDERSTORX'

	IF @IsOrderActive = 'Y'
	BEGIN
		/* Order Strengths Details*/
		SELECT ODS.OrderId
			,Cast(ODS.OrderStrengthId AS VARCHAR) AS OrderStrengthId
			,Isnull(MedictionOtherStrength, MD.StrengthDescription) AS DisplayName
			,ODS.IsDefault
			,ODS.MedicationUnit
			,ODS.PreferredNDC
			,ODS.MedicationId
		FROM OrderStrengths ODS
		LEFT JOIN MDMedications md ON md.MedicationId = Isnull(ODS.MedicationId, 0)
			AND Isnull(md.RecordDeleted, 'N') != 'Y'
		WHERE ODS.OrderId = @OrderId
			AND Isnull(ODS.RecordDeleted, 'N') != 'Y'
			AND (ISNULL(@COMPLETEORDERTORX, 'N') = 'N' OR ODS.MedicationId IS NOT NULL )

		/* Order Frequency Details*/
		SELECT ODF.OrderId
			,Cast(ODF.OrderFrequencyId AS VARCHAR) AS OrderFrequencyId
			,CASE 
				WHEN OTF.IsPRN = 'Y'
					THEN ([dbo].[Getglobalcodename](OTF.FrequencyId) + ' - PRN')
				ELSE [dbo].[Getglobalcodename](OTF.FrequencyId)
				END AS FrequencyName
			,ODF.IsDefault
		FROM OrderFrequencies ODF
		INNER JOIN OrderTemplateFrequencies OTF ON ODF.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId
		WHERE OrderId = @OrderId
			AND Isnull(OTF.RecordDeleted, 'N') != 'Y'
			AND Isnull(ODF.RecordDeleted, 'N') != 'Y'

		/* Order MedicationRoute Details*/
		SELECT *
		FROM (
			SELECT ORD.OrderId
				,MedicationRoutePOName = MDR.RouteAbbreviation
				,MedicationRoutePOId = Cast(ORT.OrderRouteId AS VARCHAR)
				,IsDefault = ORT.IsDefault
			FROM Orders ORD
			INNER JOIN OrderRoutes ORT ON ORT.OrderId = ORD.OrderId
				AND Isnull(ORT.RecordDeleted, 'N') <> 'Y'
			INNER JOIN MDRoutes MDR ON MDR.RouteId = ORT.RouteId
				AND Isnull(MDR.RecordDeleted, 'N') = 'N'
			WHERE ORD.OrderId = @OrderId
				AND Isnull(ORD.RecordDeleted, 'N') <> 'Y'
			) MedicationRoute

		/* Order MedicationRoute Details                  
        SELECT * FROM (                  
        SELECT                  
        ORD.OrderId,              
        ORD.MedicationRoutePO,                   
        MedicationRoutePOName = CASE WHEN ISNULL(ORD.MedicationRoutePO, 'N') = 'Y' THEN 'PO' ELSE '' END,                  
        MedicationRoutePOId =CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='PO') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.MedicationDefaultRouteId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='PO') THEN 'Y' ELSE 'N' END                  
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
                          
        UNION ALL                   
                          
        SELECT               
        ORD.OrderId,                  
        ORD.MedicationRouteInjection,                  
        MedicationRouteInjectionName = CASE WHEN ISNULL(ORD.MedicationRouteInjection, 'N') = 'Y' THEN 'Injection' ELSE '' END,                  
        MedicationRouteInjectionId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='Injection') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.MedicationDefaultRouteId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='Injection') THEN 'Y' ELSE 'N' END                   
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
               
        UNION ALL                   
                          
        SELECT                 
        ORD.OrderId,                
        ORD.MedicationRouteIV,                  
        MedicationRouteIVName = CASE WHEN ISNULL(ORD.MedicationRouteIV, 'N') = 'Y' THEN 'IV' ELSE '' END,                  
        MedicationRouteIVId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='IV') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.MedicationDefaultRouteId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='IV') THEN 'Y' ELSE 'N' END                   
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
        ) MedicationRoute WHERE ISNULL(MedicationRoutePO, 'N') = 'Y'     
        */
		/* Order Priority Details*/
		SELECT *
		FROM (
			SELECT ORD.OrderId
				,PriorityRoutineName = [dbo].[Getglobalcodename](ORP.PriorityId)
				,PriorityRoutineId = Cast(ORP.PriorityId AS VARCHAR)
				,IsDefault = ORP.IsDefault
			FROM Orders ORD
			INNER JOIN OrderPriorities ORP ON ORP.OrderId = ORD.OrderId
				AND Isnull(ORP.RecordDeleted, 'N') <> 'Y'
			WHERE ORD.OrderId = @OrderId
				AND Isnull(ORD.RecordDeleted, 'N') <> 'Y'
			) Priority

		/* Order Priority Details                 
        SELECT * FROM (                  
        SELECT                 
        ORD.OrderId,                
        ORD.PriorityRoutine,                  
        PriorityRoutineName = CASE WHEN ISNULL(ORD.PriorityRoutine, 'N') = 'Y' THEN 'Routine' ELSE '' END,                  
        PriorityRoutineId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='Routine') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.DefaultPriorityId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='Routine') THEN 'Y' ELSE 'N' END                   
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
                          
        UNION ALL                  
                          
        SELECT               
        ORD.OrderId,                  
        ORD.PriorityASAP,                  
        PriorityASAPName = CASE WHEN ISNULL(ORD.PriorityASAP, 'N') = 'Y' THEN 'ASAP' ELSE '' END,                  
        PriorityASAPId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='ASAP') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.DefaultPriorityId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='ASAP') THEN 'Y' ELSE 'N' END                    
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
        ) Priority WHERE ISNULL(PriorityRoutine, 'N') = 'Y'      
        */
		/* Order Schedule Details*/
		-- Inserting 'Other' Schedule if not set up for the Order
		IF NOT EXISTS(SELECT * FROM OrderSchedules ORS WHERE ORS.OrderId = @OrderId AND ORS.ScheduleId = 8522 AND ISNULL(RecordDeleted, 'N') = 'N')
		BEGIN
			INSERT INTO OrderSchedules(CreatedBy, ModifiedBy, OrderId, ScheduleId, IsDefault)
			VALUES('OrderSetup', 'OrderSetup', @OrderId, 8522, 'N')
		END

		SELECT *
		FROM (
			SELECT ORD.OrderId
				,ScheduleNowName = [dbo].[Getglobalcodename](ORS.ScheduleId)
				,ScheduleNowId = Cast(ORS.ScheduleId AS VARCHAR)
				,IsDefault = ORS.IsDefault
			FROM Orders ORD
			INNER JOIN OrderSchedules ORS ON ORS.OrderId = ORD.OrderId
				AND Isnull(ORS.RecordDeleted, 'N') <> 'Y'
			WHERE ORD.OrderId = @OrderId
				AND Isnull(ORD.RecordDeleted, 'N') <> 'Y'
			) Schedule

		/* Order Schedule Details                  
        SELECT * FROM (                  
        SELECT                
        ORD.OrderId,                 
        ORD.ScheduleNow,                  
        ScheduleNowName = CASE WHEN ISNULL(ORD.ScheduleNow, 'N') = 'Y' THEN 'Now' ELSE '' END,                  
        ScheduleNowId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Now') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.DefaultScheduleId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Now') THEN 'Y' ELSE 'N' END                   
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
                          
        UNION ALL                   
                          
        SELECT                 
        ORD.OrderId,                
        ORD.ScheduleTomorrow,                  
        ScheduleTomorrowName = CASE WHEN ISNULL(ORD.ScheduleTomorrow, 'N') = 'Y' THEN 'Tomorrow' ELSE '' END,                  
        ScheduleTomorrowId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Tomorrow') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.DefaultScheduleId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Tomorrow') THEN 'Y' ELSE 'N' END                    
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                  
                           
        UNION ALL           
                          
        SELECT                 
        ORD.OrderId,                
        ORD.ScheduleAfter1PM,                  
        ScheduleAfter1PMName = CASE WHEN ISNULL(ORD.ScheduleAfter1PM, 'N') = 'Y' THEN 'After 1PM' ELSE '' END,                  
        ScheduleAfter1PMId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='After 1PM') AS VARCHAR),                  
        IsDefault = CASE WHEN ORD.DefaultScheduleId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='After 1PM') THEN 'Y' ELSE 'N' END                   
        FROM Orders ORD WHERE OrderId = @OrderId AND ISNULL(RecordDeleted, 'N') <> 'Y'                   
        ) Schedule WHERE ISNULL(ScheduleNow, 'N') = 'Y'      
        */
		/* Order Details*/
		SELECT ORD.OrderId
			,ORD.OrderName + Isnull(' (' + (
					SELECT MedicationName
					FROM MDMedicationNames
					WHERE MedicationNameId = ORD.MedicationNameId
					) + ')', '') AS OrderName
			,ORD.OrderType
			,OrderTypeText = (
				SELECT GC.CodeName
				FROM GlobalCodes GC
				WHERE ORD.OrderType = GC.GlobalCodeId
				)
			,ORD.HasRationale
			,ORD.HasComments
			,ORD.Active
			,HT.LoincCode
			,CASE Isnull(ORD.CanBePended, 'N')
				WHEN 'N'
					THEN 'N'
				ELSE 'Y'
				END AS CanBePended
			,OrderPendAcknowledge = Isnull((
					SELECT TOP 1 CanAcknowledge
					FROM OrderAcknowledgments
					WHERE OrderId = ORD.OrderId
						AND CanAcknowledge = 'Y'
						AND Isnull(RecordDeleted, 'N') = 'N'
					), 'N')
			,OrderPendRequiredRoleAcknowledge = Isnull((
					SELECT TOP 1 NeedsToAcknowledge
					FROM OrderAcknowledgments
					WHERE OrderId = ORD.OrderId
						AND NeedsToAcknowledge = 'Y'
						AND Isnull(RecordDeleted, 'N') = 'N'
					), 'N')
			,Isnull(ORD.OrderLevelRequired, 'N') AS OrderLevelRequired
			,Isnull(ORD.LegalStatusRequired, 'N') AS LegalStatusRequired
			,Isnull(ORD.NeedsDiagnosis, 'N') AS NeedsDiagnosis
			,Isnull(ORD.AdhocOrder, 'N') AS AdhocOrder
			,Isnull(ORD.IsSelfAdministered, 'N') AS MaySelfAdminister
			,Isnull(ORD.ConsentIsRequired, 'N') AS ConsentIsRequired
			,Isnull(ORD.Sensitive, 'N') AS SensitiveOrder
			,ISNULL(ORD.DrawFromServiceCenter,'N') AS DrawFromServiceCenter
		FROM ORDERS ORD
		LEFT JOIN HealthDataTemplates HT ON ORD.LabId = HT.HealthDataTemplateId
			AND Isnull(HT.RecordDeleted, 'N') <> 'Y'
			AND Isnull(HT.Active, 'Y') = 'Y'
		WHERE OrderId = @OrderId
			AND Isnull(ORD.RecordDeleted, 'N') <> 'Y'
			AND Isnull(ORD.Active, 'Y') = 'Y'

		/* OrderQuestions */
		SELECT ORQ.QuestionId
			,ORQ.CreatedBy
			,ORQ.CreatedDate
			,ORQ.ModifiedBy
			,ORQ.ModifiedDate
			,ORQ.RecordDeleted
			,ORQ.DeletedDate
			,ORQ.DeletedBy
			,ORQ.Question
			,ORQ.OrderId
			,ORQ.AnswerType
			,ORQ.AnswerRelatedCategory
			,ORQ.IsRequired
			,[dbo].[Getglobalcodename](ORQ.AnswerType) AS AnswerTypeName
			,ORQ.ShowQuestionTimeOption
			,ORQ.LaboratoryId
			,ORQ.QuestionCode
		FROM OrderQuestions ORQ
		JOIN ORDERS ORD ON ORD.OrderId = ORQ.OrderId
		WHERE ORQ.OrderId = @OrderId
			AND Isnull(ORQ.RecordDeleted, 'N') <> 'Y'
			AND (ISNULL(ORQ.ShowQuestionTimeOption,'B')='O' OR ISNULL(ORQ.ShowQuestionTimeOption,'B')='B')
			AND ( ORD.OrderType <> 6481 OR ( ISNULL(ORQ.LaboratoryId, 0) = 0 OR ORQ.LaboratoryId IN (SELECT ORL.LaboratoryId FROM OrderLabs ORL WHERE ORL.OrderId = @OrderId AND ISNULL(ORL.IsDefault,'N')='Y' )))

		/* Units*/
		DECLARE @MedicationNameId INT;

		SET @MedicationNameId = 0;

		SELECT @MedicationNameId = MedicationNameId
		FROM Orders
		WHERE OrderId = @OrderId

		EXEC [dbo].[ssp_SCGetMedicationUnits] @MedicationNameId

		/* Legal*/
		SELECT GlobalCodeId
			,CodeName
		FROM GlobalCodes
		WHERE Category = 'XORDERLEGALSTATUS'
			AND Isnull(RecordDeleted, 'N') <> 'Y'

		/* Level*/
		SELECT GlobalCodeId
			,CodeName
		FROM GlobalCodes
		WHERE Category = 'XORDERLEVEL'
			AND Isnull(RecordDeleted, 'N') <> 'Y' 
   
	   /*Rationale */
	   SELECT GlobalCodeId  
	   ,CodeName
	   FROM GlobalCodes
	   WHERE Category = 'XORDERRATIONALE' AND Active='Y'  AND ISNULL(RecordDeleted,'N')<>'Y'
	   AND ( ExternalCode1 IS NULL 
			OR 
			ExternalCode1 = 
				( 
					SELECT GC.GlobalCodeId	FROM GlobalCodes GC 
					JOIN Orders O ON O.OrderType=GC.GlobalCodeId 
					WHERE O.OrderId = @OrderId
				)
			)
		ORDER BY SortOrder
		
		/* Labs*/
		SELECT DISTINCT ORD.OrderId
			,ORL.LaboratoryId AS LabId
			,L.LaboratoryName AS LabName
			,IsDefault = ORL.IsDefault
		FROM Orders ORD
		INNER JOIN OrderLabs ORL ON ORL.OrderId = ORD.OrderId
			AND Isnull(ORL.RecordDeleted, 'N') <> 'Y'
		INNER JOIN Laboratories L ON L.LaboratoryId = ORL.LaboratoryId
		WHERE ORD.OrderId = @OrderId
			AND Isnull(ORD.RecordDeleted, 'N') <> 'Y'
		
		/* Diagnosis */
		DECLARE @LatestICD10DocumentVersionID INT
		
		CREATE TABLE  #DiagnosisTemp
		(
		 DSMCode VARCHAR(50),
		 DisplayAs VARCHAR(Max),
		 Diagnosisvalue VARCHAR(MAX)
		) 

		SET @LatestICD10DocumentVersionID = (
				SELECT TOP 1 a.CurrentDocumentVersionId
				FROM Documents AS a
				INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId
				INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId
				WHERE a.ClientId = @ClientId
					AND a.EffectiveDate <= CAST(GETDATE() AS DATE)
					AND a.STATUS = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
					AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				)
        INSERT INTO #DiagnosisTemp (DSMCode,DisplayAs,Diagnosisvalue)
		SELECT DDC.ICD10CodeId as DSMCode, 
		     SUBSTRING(CAST(DDC.ICD10Code AS VARCHAR(10)) + ' - ' + ICD10.ICDDescription, 0, 95) AS DisplayAs
			,CAST(DDC.ICD10Code AS VARCHAR(10)) + '$$$' + ICD10.ICDDescription + '$$$' + CAST(ISNULL(DDC.ICD9Code, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(DDC.ICD10CodeId, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(DDC.SNOMEDCODE, '') AS VARCHAR(10)) + '$$$' + ISNULL(SNC.SNOMEDCTDescription, '') AS Diagnosisvalue
		FROM DocumentDiagnosisCodes DDC
		INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
		LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE
		WHERE ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
			AND DDC.DocumentVersionId = @LatestICD10DocumentVersionID	
		ORDER BY DDC.DiagnosisOrder
		
		INSERT INTO #DiagnosisTemp (DSMCode,DisplayAs,Diagnosisvalue)
	    SELECT CP.ICD10CodeId as DSMCode,
	     SUBSTRING(CAST(CP.ICD10Code AS VARCHAR(10)) + ' - ' + ICD10.ICDDescription, 0, 95) AS DisplayAs 
	    ,CAST(CP.ICD10Code AS VARCHAR(10)) + '$$$' + ICD10.ICDDescription + '$$$' + CAST(ISNULL(DICD.ICD9Code, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(CP.ICD10CodeId, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(CP.SNOMEDCODE, '') AS VARCHAR(10)) + '$$$' + ISNULL(SNC.SNOMEDCTDescription, '') AS Diagnosisvalue  
	    FROM ClientProblems CP  
	    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = CP.ICD10CodeId  
	    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE  
	    LEFT JOIN DiagnosisICD10ICD9Mapping DICD ON DICD.ICD10CodeId = CP.ICD10CodeId
	    WHERE ISNULL(CP.RecordDeleted, 'N') <> 'Y'  
	    AND CP.ClientId = @ClientId AND (CP.ICD10CodeId NOT IN (SELECT DSMCode FROM #DiagnosisTemp))
	    ORDER BY CP.DiagnosisOrder 
	    
	    SELECT DisplayAs,Diagnosisvalue FROM #DiagnosisTemp
  
		DROP TABLE #DiagnosisTemp

		/* PotencyUnits*/
		
		EXEC [dbo].[ssp_GetPotencyUnitCodesByMedicationNameId] @MedicationNameId
		
		/* ClinicLocation */
		SELECT DISTINCT LLF.LocationLaboratoryFacilityId
			,LF.LaboratoryId
			,L.LocationCode AS LocationName
			,L.LocationId
			,LF.ClinicalLocation
			,CASE 
				WHEN L.LocationId = ORD.LocationId
				THEN 'Y'
				ELSE 'N'
				END AS 'IsDefault'
		FROM Orders ORD
		JOIN OrderLabs ORL ON ORL.OrderId = ORD.OrderId
			AND Isnull(ORL.RecordDeleted, 'N') = 'N'
		JOIN LaboratoryFacilities LF ON LF.LaboratoryId = ORL.LaboratoryId AND ISNULL(LF.RecordDeleted, 'N') = 'N'
		JOIN LocationLaboratoryFacilities LLF ON LLF.LaboratoryFacilityId = LF.LaboratoryFacilityId AND ISNULL(LLF.RecordDeleted, 'N') = 'N'
		JOIN Locations L ON L.LocationId = LLF.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'
		WHERE ORD.OrderId = @OrderId
			AND Isnull(ORL.IsDefault, 'N') = 'Y'
		ORDER BY LocationName
		
	END
END
GO

