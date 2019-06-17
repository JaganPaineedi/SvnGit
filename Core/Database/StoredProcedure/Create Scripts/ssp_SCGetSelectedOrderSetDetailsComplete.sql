/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedOrderSetDetailsComplete]    Script Date: 05/10/2017 12:15:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSelectedOrderSetDetailsComplete]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSelectedOrderSetDetailsComplete]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedOrderSetDetailsComplete]    Script Date: 05/10/2017 12:15:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




    
CREATE  PROCEDURE [dbo].[ssp_SCGetSelectedOrderSetDetailsComplete]      
 @OrderIdString VARCHAR(MAX),
@ClientId INT = 0  
AS          
/*********************************************************************/                                                                                                  
/* Stored Procedure: [ssp_SCGetSelectedOrderSetDetailsComplete]   */                                                                                         
/* Creation Date:  04/July/2013                                      */                                                                                                  
/* Purpose: To get Selected Order details For Order set Entry        */                                                                                                
/* Input Parameters:@OrderIdString          */                            
/* Output Parameters:             */                                                                                                                   
/* Called By:                                                        */                                                                                        
/* Data Modifications:                                               */                                                                                                  
/* Updates:                                                          */                                                                                                  
/* Date           Author    Purpose            */                                                                                                  
/* 04/July/2013  S Ganesh  Created          */          
/* 31/July/2013  Prasan    added OrderQuestions          */  
/* 06/Oct/2013  Prasan    added Units ,Legal && Level     */
/* 10/Apr/2017  Chethan N	What : Client Order Set Changes.
							Why : Engineering Improvement Initiatives- NBL(I) task #475     */ 
/* 08/May/2018  Shankha		What: Modified the logic to display distinct Labs */
/* 02/Jul/2018	Chethan N	What : Retrieving Locations.
							Why : Engineering Improvement Initiatives- NBL(I) task #667		*/		
/* 27/Feb/2019	Sunil Dasari	What : Added Active='Y' check condition on selection global codes for Rationale dropdown using global code category 'XORDERRATIONALE'
								Why : Front end code is not checking if the Global code is Active or not before displaying the Rationale drop down list  
									  Unison - EIT #539      */					
/*********************************************************************/             
BEGIN     
    
		DECLARE @COMPLETEORDERTORX VARCHAR(1)
		SELECT @COMPLETEORDERTORX = ISNULL(SCK.[Value], 'N')
			FROM SystemConfigurationKeys SCK WHERE SCK.[Key] = 'COMPLETEORDERSTORX'

		 /* Order Strengths Details*/          
		SELECT ODS.OrderId
			,Cast(ODS.OrderStrengthId AS VARCHAR) AS OrderStrengthId
			,ISNULL(MedictionOtherStrength, md.StrengthDescription) AS DisplayName
			,ODS.IsDefault
			,ODS.MedicationUnit
			,ODS.PreferredNDC
			,CAST(ODS.MedicationId AS VARCHAR) AS MedicationId
		FROM OrderStrengths ODS
		LEFT JOIN MDMedications md ON md.MedicationId = isnull(ODS.MedicationId, 0)
			AND ISNULL(md.RecordDeleted, 'N') != 'Y'
		WHERE ODS.OrderId IN (
				SELECT Token
				FROM dbo.SplitString(@OrderIdString, ',')
				)
			AND ISNULL(ODS.RecordDeleted, 'N') != 'Y' 
			AND (ISNULL(@COMPLETEORDERTORX, 'N') = 'N' OR ODS.MedicationId IS NOT NULL )  
	        
		  /* Order Frequency Details*/          
		  SELECT ODF.OrderId, ODF.OrderFrequencyId AS OrderTemplateFrequencyId, 
		  CASE WHEN OTF.IsPRN = 'Y' THEN  ([dbo].[GetGlobalCodeName](OTF.FrequencyId)+' - PRN') 
		 ELSE [dbo].[GetGlobalCodeName](OTF.FrequencyId) END AS FrequencyName,
		  ODF.IsDefault           
		  FROM OrderFrequencies ODF INNER JOIN  OrderTemplateFrequencies OTF ON ODF.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId          
		  WHERE OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(OTF.RecordDeleted, 'N') != 'Y' AND ISNULL(ODF.RecordDeleted, 'N') != 'Y'          

		/* Order MedicationRoute Details*/          
		  SELECT * FROM (          
		   SELECT          
		   ORD.OrderId,      
			MedicationRoutePOName = MDR.RouteAbbreviation, 
		   MedicationRoutePOId= Cast(ORT.OrderRouteId AS VARCHAR),       
		   IsDefault = ORT.IsDefault        
		   FROM Orders ORD 
		   INNER JOIN OrderRoutes ORT on ORT.OrderId = ORD.OrderId AND ISNULL(ORT.RecordDeleted, 'N') <> 'Y'
		   INNER JOIN MDRoutes MDR ON MDR.RouteId=ORT.RouteId AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
		   WHERE ORD.OrderId  IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y'          
   
		  ) MedicationRoute  
      
		/* Order Priority Details*/          
		  SELECT * FROM (          
		   SELECT         
		   ORD.OrderId,        
		   PriorityRoutineName = [dbo].[GetGlobalCodeName](ORP.PriorityId),          
		   PriorityRoutineId = Cast(ORP.PriorityId AS VARCHAR),          
		   IsDefault = ORP.IsDefault
		   FROM Orders ORD 
		   INNER JOIN OrderPriorities ORP on ORP.OrderId = ORD.OrderId AND ISNULL(ORP.RecordDeleted, 'N') <> 'Y'
   
		   WHERE ORD.OrderId  IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y'          
   
		  ) Priority 

		/* Order Schedule Details*/  
		 -- Inserting 'Other' Schedule if not set up for the Order
		  INSERT INTO OrderSchedules(CreatedBy, ModifiedBy, OrderId, ScheduleId, IsDefault)
		   SELECT 'OrderSetup', 'OrderSetup', Token, 8522, 'N'
		   FROM dbo.SplitString(@OrderIdString,',')
		   WHERE Not EXISTS(SELECT * FROM OrderSchedules ORS WHERE ORS.OrderId = Token AND ORS.ScheduleId = 8522 AND ISNULL(RecordDeleted, 'N') = 'N')
        
		  SELECT * FROM (          
		   SELECT        
		   ORD.OrderId,         
		   ScheduleNowName = [dbo].[GetGlobalCodeName](ORS.ScheduleId),        
		   ScheduleNowId = Cast(ORS.ScheduleId AS VARCHAR),    
		   IsDefault = ORS.IsDefault
		   FROM Orders ORD 
		   INNER JOIN OrderSchedules ORS on ORS.OrderId = ORD.OrderId AND ISNULL(ORS.RecordDeleted, 'N') <> 'Y'
   
		   WHERE ORD.OrderId  IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y'          
      
		  ) Schedule
 
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
		  INNER JOIN Orders OD On OD.OrderId = ORQ.OrderId 
		  WHERE 
		  ORQ.OrderId IN (
			SELECT Token
			FROM dbo.SplitString(@OrderIdString, ',')
			)
		   AND Isnull(ORQ.RecordDeleted, 'N') <> 'Y'
		   AND (ISNULL(ShowQuestionTimeOption, 'B') = 'O'
		   or ISNULL(ShowQuestionTimeOption, 'B') = 'B')
		   And (OD.OrderType <> 6481 
		   or
		   Exists(Select 1 from   OrderLabs ORD where ORD.OrderId = ORQ.OrderId 
		  and  (ORD.LaboratoryId = ORQ.LaboratoryId or ISNULL(ORQ.LaboratoryId, 0)=0 )
		  and ORD.IsDefault='Y')
		  or 
		   not Exists(Select 1 from   OrderLabs ORD where ORD.OrderId = ORQ.OrderId )
		)
		 /* Units*/  
		DECLARE @tblUnits TABLE
		(
		  GlobalCodeId int,
		  CodeName varchar(250),
		  MedicationId VARCHAR(500)
		)
		DECLARE @tblUnitsOS TABLE
		(
		  GlobalCodeId int,
		  CodeName varchar(250),
		  MedicationId VARCHAR(500),
		  OrderId int
		)  
 
		DECLARE @MedicationNameId INT ,@OrderId INT;  
		DECLARE crsVar CURSOR FOR 
		   SELECT MedicationNameId,OrderId FROM Orders WHERE OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,','))
		   AND OrderType = 8501;
		OPEN crsVar;
		FETCH NEXT FROM crsVar INTO @MedicationNameId,@OrderId;
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
		  if(@MedicationNameId is not null)
		   BEGIN
			   INSERT INTO @tblUnits  EXEC [dbo].[ssp_SCGetMedicationUnits]  @MedicationNameId   
			   INSERT INTO @tblUnitsOS select GlobalCodeId,CodeName,MedicationId,@OrderId from @tblUnits
			   DELETE FROM @tblUnits
		   END
   
		   FETCH NEXT FROM crsVar INTO @MedicationNameId,@OrderId;   
		END   
		CLOSE crsVar
		DEALLOCATE crsVar
		SELECT GlobalCodeId,CodeName,MedicationId,OrderId FROM @tblUnitsOS

		/* Legal*/  
		select GlobalCodeId,CodeName from GlobalCodes where Category ='XORDERLEGALSTATUS' AND ISNULL(RecordDeleted, 'N') <> 'Y'
		/* Level*/  
		select GlobalCodeId,CodeName from GlobalCodes where Category = 'XORDERLEVEL' AND ISNULL(RecordDeleted, 'N') <> 'Y'

		
	   /*Rationale */
	   SELECT GC.GlobalCodeId  
	   ,GC.CodeName
	   ,CAST(ISNULL(GC.ExternalCode1, -1) AS INT) AS OrderType
	   FROM GlobalCodes GC 
	   WHERE Category = 'XORDERRATIONALE' AND Active='Y' 
			AND ISNULL(RecordDeleted, 'N') = 'N'
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
		WHERE ORD.OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,','))
			AND Isnull(ORD.RecordDeleted, 'N') <> 'Y'

/* Diagnosis */
		DECLARE @LatestICD10DocumentVersionID INT

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

		SELECT SUBSTRING(CAST(DDC.ICD10Code AS VARCHAR(10)) + ' - ' + ICD10.ICDDescription, 0, 95) AS DisplayAs
			,CAST(DDC.ICD10Code AS VARCHAR(10)) + '$$$' + ICD10.ICDDescription + '$$$' + CAST(ISNULL(DDC.ICD9Code, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(DDC.ICD10CodeId, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(DDC.SNOMEDCODE, '') AS VARCHAR(10)) + '$$$' + ISNULL(SNC.SNOMEDCTDescription, '') AS Diagnosisvalue
		FROM DocumentDiagnosisCodes DDC
		INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
		LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE
		WHERE ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
			AND DDC.DocumentVersionId = @LatestICD10DocumentVersionID	
		ORDER BY DDC.DiagnosisOrder


	/* PotencyUnits*/
		DECLARE @tblPotencyUnit TABLE
		(
		  SureScriptsCode varchar(250),
		  SmartCareRxCode varchar(250)
		)
		DECLARE @tblPotencyUnitOS TABLE
		(
		  SureScriptsCode varchar(250),
		  SmartCareRxCode varchar(250),
		  OrderId int
		)  
 
		DECLARE @PMedicationNameId INT ,@POrderId INT;  
		DECLARE crsVar CURSOR FOR 
		   SELECT MedicationNameId,OrderId FROM Orders WHERE OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,','))
		   AND OrderType = 8501;
		OPEN crsVar;
		FETCH NEXT FROM crsVar INTO @PMedicationNameId,@POrderId;
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
		  if(@PMedicationNameId is not null)
		   BEGIN
			   INSERT INTO @tblPotencyUnit  EXEC [dbo].[ssp_GetPotencyUnitCodesByMedicationNameId] @PMedicationNameId   
			   INSERT INTO @tblPotencyUnitOS select SureScriptsCode,SmartCareRxCode,@POrderId from @tblPotencyUnit
			   DELETE FROM @tblPotencyUnit
		   END
   
		   FETCH NEXT FROM crsVar INTO @PMedicationNameId,@POrderId;   
		END   
		CLOSE crsVar
		DEALLOCATE crsVar
		SELECT SureScriptsCode,SmartCareRxCode,OrderId FROM @tblPotencyUnitOS
		--EXEC [dbo].[ssp_GetPotencyUnitCodesByMedicationNameId] @MedicationNameId

		/* ClinicLocation */
		SELECT DISTINCT ORD.OrderId
			,LLF.LocationLaboratoryFacilityId
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
		WHERE ORD.OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,','))
			AND Isnull(ORL.IsDefault, 'N') = 'Y'
		ORDER BY LocationName
 
 END


GO


