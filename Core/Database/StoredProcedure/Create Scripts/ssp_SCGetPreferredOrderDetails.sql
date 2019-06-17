GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPreferredOrderDetails]    Script Date: 10/21/2013 15:42:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetPreferredOrderDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetPreferredOrderDetails]
GO

GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPreferredOrderDetails]    Script Date: 10/21/2013 15:42:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




  
CREATE PROCEDURE [dbo].[ssp_SCGetPreferredOrderDetails]
 @StaffId INT         
AS        
/*********************************************************************/                                                                                                
/* Stored Procedure: [ssp_SCGetPreferredOrderDetails]				 */                                                                                       
/* Creation Date:  22/July/2013     
  exec ssp_SCGetPreferredOrderDetails 550                                 */                                                                                                
/* Purpose: To get Selected Order details For Order set Entry        */                                                                                              
/* Input Parameters:@StaffId										 */                          
/* Output Parameters:												 */                                                                                                                 
/* Called By:                                                        */                                                                                      
/* Data Modifications:                                               */                                                                                                
/* Updates:                                                          */                                                                                                
/* Date          Author    Purpose									 */                                                                                                
/* 22/July/2013  S Ganesh  Created									 */     
/* 02/Aug/2013   Prasan    added OrderQuestions          */      
/* 06/Oct/2013  Prasan    added Units ,Legal && Level     */  
/* 07/Oct/2013  Prasan    fetching StaffPreferredOrders new columns (like MedicationUnits,MedicationDosage...MedicationRefill)     */  
/* 06/Mar/2014  Prasan    added space after comma in  HeaderText column   */  
/* 10/April/2014  Prasan    added DispenseBrand column   */  
/* 19/Sep/2014  PPotnur    added MayUseOwnSupply column   */ 
/* 19/Feb/2015  Gautam    The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
						  and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */
/* 11/Apr/2017  Chethan N	What : Client Preferred Order Changes.
							Why : Engineering Improvement Initiatives- NBL(I) task #475     */ 
/*********************************************************************/           
BEGIN   
  
 DECLARE @OrderIdString VARCHAR(MAX)
 SET @OrderIdString=''  
  
   SELECT SPO.StaffPreferredOrderId
			,ORD.OrderId
			,CAST(ORD.OrderType AS varchar) AS OrderType
			,OrderTypeName = (
				SELECT GC.CodeName
				FROM GlobalCodes GC
				WHERE GC.GlobalCodeId = ORD.OrderType
				)
			,ORD.OrderName + ISNULL(' (' + (
					SELECT MedicationName
					FROM MDMedicationNames
					WHERE MedicationNameId = ORD.MedicationNameId
					) + ')', '') AS OrderName
			,ORD.HasRationale
			,ORD.HasComments
			,ORD.Active
			,CASE ISNULL(ORD.CanBePended, 'N')
				WHEN 'N'
					THEN 'N'
				ELSE 'Y'
				END AS CanBePended
			,HeaderText = (
				ISNULL((
						CASE 
							WHEN ISNULL(SPO.MedicationOtherDosage, '') = ''
								THEN (
										SELECT ISNULL(md.StrengthDescription, ISNULL(SPO.MedicationOtherDosage, '')) + ', '
										FROM OrderStrengths OS
										LEFT JOIN MDMedications md ON md.MedicationId = isnull(OS.MedicationId, 0)
											AND ISNULL(md.RecordDeleted, 'N') != 'Y'
										WHERE OS.OrderId = SPO.OrderId
											AND OS.OrderStrengthId = SPO.MedicationOrderStrengthId
										)
							ELSE SPO.MedicationOtherDosage + ', '
							END
						), '') + ISNULL((
						SELECT GC.CodeName + ', '
						FROM GlobalCodes GC
						WHERE GC.Category = 'ORDERROUTE'
							AND GC.GlobalCodeId = SPO.MedicationOrderRouteId
						), '') + ISNULL((
						SELECT GC.CodeName + ', '
						FROM GlobalCodes GC
						WHERE GC.Category = 'ORDERPRIORITY'
							AND GC.GlobalCodeId = SPO.OrderPriorityId
						), '') + ISNULL((
						SELECT OTF.DisplayName
						FROM OrderTemplateFrequencies OTF
						WHERE OTF.OrderTemplateFrequencyId = SPO.OrderTemplateFrequencyId
						), '') + ISNULL((
						SELECT ', ' + GC.CodeName
						FROM GlobalCodes GC
						WHERE GC.Category = 'ORDERSTART'
							AND GC.GlobalCodeId = SPO.OrderScheduleId
						), '')
				)
			,SPO.MedicationUseOtherUsage
			,SPO.MedicationOtherDosage
			,SPO.OrderStartOther
			,SPO.RationaleText
			,SPO.CommentsText
			,SPO.OrderPend
			,OrderPendAcknowledge = ISNULL((
					SELECT TOP 1 CanAcknowledge
					FROM OrderAcknowledgments
					WHERE OrderId = ORD.OrderId
						AND CanAcknowledge = 'Y'
						AND ISNULL(RecordDeleted, 'N') = 'N'
					), 'N')
			,OrderPendRequiredRoleAcknowledge = ISNULL((
					SELECT TOP 1 NeedsToAcknowledge
					FROM OrderAcknowledgments
					WHERE OrderId = ORD.OrderId
						AND NeedsToAcknowledge = 'Y'
						AND ISNULL(RecordDeleted, 'N') = 'N'
					), 'N')
			,CAST(ISNULL(SPO.MedicationUnits, 0) AS VARCHAR(15)) AS MedicationUnits
			,ISNULL(SPO.MedicationDosage, 0) AS MedicationDosage
			,ISNULL(SPO.Legal, 0) AS Legal
			,ISNULL(SPO.LEVEL, 0) AS LEVEL
			,ISNULL(SPO.MedicationDaySupply, 0) AS MedicationDaySupply
			,ISNULL(SPO.MedicationRefill, 0) AS MedicationRefill
			,ISNULL(ORD.OrderLevelRequired, 'N') AS OrderLevelRequired
			,ISNULL(ORD.LegalStatusRequired, 'N') AS LegalStatusRequired
			,ISNULL(ORD.NeedsDiagnosis, 'N') AS NeedsDiagnosis
			,ISNULL(SPO.DispenseBrand, 'N') AS DispenseBrand
			,ISNULL(SPO.MayUseOwnSupply, 'N') AS MayUseOwnSupply
			,ISNULL(SPO.MaySelfAdminister, 'N') AS MaySelfAdminister
			,ISNULL(SPO.ConsentIsRequired, 'N') AS ConsentIsRequired
			,ISNULL(SPO.IsPRN, 'N') AS IsPRN
			,ISNULL(OTF.DisplayName, '') AS FrequencyText
			,ISNULL(OTF.OrderTemplateFrequencyId, '') AS OrderTemplateFrequencyId
			,ISNULL(ORD.Sensitive,'N') AS SensitiveOrder
		FROM Orders ORD
		INNER JOIN StaffPreferredOrders SPO ON ORD.OrderId = SPO.OrderId
		LEFT JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = SPO.OrderTemplateFrequencyId
		WHERE SPO.StaffId = @StaffId
			AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(SPO.RecordDeleted, 'N') <> 'Y'
		ORDER BY ORD.OrderName ASC

 SELECT @OrderIdString = @OrderIdString + CAST(OrderId AS varchar(5)) + ',' FROM StaffPreferredOrders SPO WHERE SPO.StaffId = @StaffId 
 
 SET @OrderIdString =  SUBSTRING(@OrderIdString, 0, LEN(@OrderIdString))  
  
 /* Order Strengths Details*/          
 SELECT SPO.StaffPreferredOrderId, ODS.OrderId, CAST(ODS.OrderStrengthId AS VARCHAR(15)) AS MedicationId, ISNULL(MedictionOtherStrength,md.StrengthDescription) as DisplayName,IsDefault = CASE WHEN SPO.MedicationOrderStrengthId = ODS.OrderStrengthId THEN 'Y' ELSE 'N' END,
 ODS.MedicationUnit
 FROM OrderStrengths ODS
 INNER JOIN StaffPreferredOrders SPO ON SPO.OrderId = ODS.OrderId 
 Left outer Join MDMedications md on md.MedicationId = isnull(ODS.MedicationId,0)  AND ISNULL(md.RecordDeleted, 'N') != 'Y'
 WHERE SPO.StaffId = @StaffId AND ODS.OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ODS.RecordDeleted, 'N') != 'Y' AND ISNULL(SPO.RecordDeleted, 'N') != 'Y' ORDER BY ODS.OrderId  
 
 /* Order Frequency Details*/          
 SELECT SPO.StaffPreferredOrderId, SPO.OrderId, OTF.OrderTemplateFrequencyId AS OrderTemplateFrequencyId,
  CASE WHEN OTF.IsPRN = 'Y' THEN  (OTF.DisplayName +' - PRN') 
 ELSE OTF.DisplayName END AS FrequencyName,
  IsDefault = CASE WHEN OTF.OrderTemplateFrequencyId = SPO.OrderTemplateFrequencyId THEN 'Y' ELSE 'N' END           
 FROM OrderTemplateFrequencies OTF INNER JOIN StaffPreferredOrders SPO ON SPO.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId         
 WHERE SPO.StaffId = @StaffId AND SPO.OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(OTF.RecordDeleted, 'N') != 'Y' AND ISNULL(SPO.RecordDeleted, 'N') != 'Y' ORDER BY SPO.OrderId         
 
 /* Order MedicationRoute Details*/          
  SELECT * FROM (          
   SELECT          
   SPO.StaffPreferredOrderId, 
   ORD.OrderId,      
   MedicationRoutePOName = MDR.RouteAbbreviation, 
   MedicationRoutePOId= CAST(ORT.OrderRouteId AS VARCHAR(15)),
   IsDefault = CASE WHEN SPO.MedicationOrderRouteId = MDR.RouteId THEN 'Y' ELSE 'N' END          
   FROM Orders ORD 
   INNER JOIN StaffPreferredOrders SPO ON SPO.OrderId = ORD.OrderId
   INNER JOIN OrderRoutes ORT on ORT.OrderId = ORD.OrderId AND ISNULL(ORT.RecordDeleted, 'N') <> 'Y'
   INNER JOIN MDRoutes MDR ON MDR.RouteId=ORT.RouteId AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
   WHERE SPO.StaffId = @StaffId AND ORD.OrderId  IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(SPO.RecordDeleted, 'N') <> 'Y'          
  
  ) MedicationRoute  ORDER BY OrderId
  
  
  /* Order Priority Details*/          
  SELECT * FROM (          
   SELECT         
   SPO.StaffPreferredOrderId, 
   ORD.OrderId,        
   PriorityRoutineName = [dbo].[GetGlobalCodeName](ORP.PriorityId),          
   PriorityRoutineId = CAST(ORP.PriorityId AS VARCHAR(15)),          
   IsDefault = CASE WHEN SPO.OrderPriorityId = ORP.PriorityId THEN 'Y' ELSE 'N' END           
   FROM Orders ORD 
   INNER JOIN StaffPreferredOrders SPO ON SPO.OrderId = ORD.OrderId
   INNER JOIN OrderPriorities ORP on ORP.OrderId = ORD.OrderId AND ISNULL(ORP.RecordDeleted, 'N') <> 'Y'
   WHERE SPO.StaffId = @StaffId AND ORD.OrderId  IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y'          
       
  ) Priority  ORDER BY OrderId
  
  
  /* Order Schedule Details*/          
  SELECT * FROM (          
   SELECT        
   SPO.StaffPreferredOrderId, 
   ORD.OrderId,         
   ScheduleNowName = [dbo].[GetGlobalCodeName](ORS.ScheduleId),        
   ScheduleNowId = CAST(ORS.ScheduleId AS VARCHAR(15)),          
   IsDefault = CASE WHEN SPO.OrderScheduleId = ORS.ScheduleId THEN 'Y' ELSE 'N' END           
   FROM Orders ORD 
   INNER JOIN StaffPreferredOrders SPO ON SPO.OrderId = ORD.OrderId
   INNER JOIN OrderSchedules ORS on ORS.OrderId = ORD.OrderId AND ISNULL(ORS.RecordDeleted, 'N') <> 'Y'
   WHERE SPO.StaffId = @StaffId AND ORD.OrderId  IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y'          
   
  ) Schedule   ORDER BY OrderId
  
  
  /* OrderQuestions */  
SELECT QuestionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, Question, OrderId, AnswerType, AnswerRelatedCategory, IsRequired      
 ,[dbo].[GetGlobalCodeName](AnswerType) AS AnswerTypeName  
FROM OrderQuestions  
WHERE OrderId IN (SELECT Token FROM dbo.SplitString(@OrderIdString,',')) 
 AND ISNULL(RecordDeleted, 'N') <> 'Y'  
 AND ISNULL(ShowQuestionTimeOption,'O')='O' 
  
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

END  



GO


