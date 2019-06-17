

/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedClientOrderDetails]    Script Date: 08/12/2013 19:51:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetSelectedClientOrderDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetSelectedClientOrderDetails]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetSelectedClientOrderDetails]    Script Date: 08/12/2013 19:51:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

          
                
CREATE  PROCEDURE [dbo].[ssp_SCGetSelectedClientOrderDetails] 
 @ClientOrderId INT          
AS                
/*********************************************************************/                                                                                                        
/* Stored Procedure: [ssp_SCGetSelectedClientOrderDetails]           */                                                                                               
/* Creation Date:  22/July/2013                                      */                                                                                                        
/* Purpose: To get Selected Clent Order details For Order Entry      */                                                                                                      
/* Input Parameters:@ClientOrderId          */                                  
/* Output Parameters:             */                            
/* Returns The Table of Orders,OrderStrengths,OrderFrequencies   */                                                                                                        
/* Called By:                                                        */                                                                                              
/* Data Modifications:                                               */                                                                                                        
/* Updates:                                                          */                                                                                                        
/* Date          Author    Purpose          */                                                                                                        
/* 22/July/2013  Vithobha  Created          */   
/* 19/Feb/2015   Gautam    The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
						  and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */ 
/* 25 May 2015	 Chethan N	What: Added new column 'RationaleOtherText'
							Why:  Philhaven Development task # 252 */ 	 
/* 03 Jun 2015	 Chethan N	What: Retrieving 'RationaleOtherText' if 'RationaleOtherText' is not NULL
							Why:  Philhaven Development task # 252 */	
/* 15 Jun 2015	 Chethan N	What: Passing Flow Sheet Date Time to ssp_SCGetClientHealthDataAttributes And Reverted 'Retrieving 'RationaleOtherText' if 'RationaleOtherText' is not NULL'
							Why:  Woods - Environment Issues Tracking # 26 */
/* 05 Jan 2016	 Chethan N  What: Retrieving Questions and Answer 
							Why:  Philhaven Development task # 368	*/	  
/* 07 Jan 2016	 Chethan N  What: Retrieving Laboratories table 
							Why:  Streamline Administration task #153	*/	
/* 13th Jan 2015 Chethan N	What: Retrieving Order Name from MDMedicationNames for Client Medication Mapping Client orders
							Why: Engineering Improvement Initiatives- NBL(I) task#280*/   
/* 07/12/2015	Pradeep A	What : Added Orders.DrawFromServiceCenter
							Why : Streamline Administration task #153*/		
/* 27 Dec 2016	 Chethan N	What: Retrieving Potency Units and Added new columns DiscontinuedReason, PotencyUnit and ParentClientOrderId to ClientOrders.
							Why:  Renaissance - Dev Items task #5	*/ 		
/* 16 Jan 2017	 Chethan N	What: Retrieving 'Other' strength only when SystemConfigurationKeys.COMPLETEORDERTORX = 'N'.
							Why:  Renaissance - Dev Items task #5	*/ 		
/* 10 Feb 2017	 Chethan N	What : Added new column 'ClinicalLocation' to ClientOrders table.
							Why : Key Point - Support Go Live task #365	*/	
/* 15 Mar 2017	Chethan N	What : Added NULL check to LaboratoryId to get Order Questions.
							Why : Key Point - Support Go Live task #365 */	
/* 08/May/2018  Shankha		What: Modified the logic to display distinct Labs */							
/*********************************************************************/                   
BEGIN     
	
	DECLARE @OrderId INT
	DECLARE @COMPLETEORDERTORX VARCHAR(1)

	SET @OrderId = (SELECT  TOP 1 R.IntegerCodeId
	FROM Recodes R
	JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder'
		AND RC.RecodeCategoryId = R.RecodeCategoryId
	WHERE ISNULL(R.RecordDeleted, 'N') = 'N')
		
	SELECT @COMPLETEORDERTORX = ISNULL(SCK.[Value], 'N')
	FROM SystemConfigurationKeys SCK WHERE SCK.[Key] = 'COMPLETEORDERSTORX'
           
 /* Order Strengths Details*/                
 SELECT ODS.OrderId,CAST(ODS.OrderStrengthId AS VARCHAR) AS OrderStrengthId, md.StrengthDescription as DisplayName,CASE WHEN ODS.OrderStrengthId = CO.MedicationOrderStrengthId THEN 'Y' ELSE 'N' END AS IsDefault   
 FROM OrderStrengths ODS   
 INNER JOIN   
 ClientOrders CO ON ODS.OrderId=CO.OrderId  
 Left outer Join MDMedications md on md.MedicationId = isnull(ODS.MedicationId,0)  AND ISNULL(md.RecordDeleted, 'N') != 'Y'
 WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ODS.RecordDeleted, 'N') != 'Y' AND ISNULL(CO.RecordDeleted, 'N') != 'Y' 
			AND (ISNULL(@COMPLETEORDERTORX, 'N') = 'N' OR ODS.MedicationId IS NOT NULL )
                
 /* Order Frequency Details*/                
 SELECT CO.OrderId,CAST(OTF.OrderTemplateFrequencyId AS VARCHAR) AS OrderTemplateFrequencyId , OTF.DisplayName as FrequencyName, CASE WHEN OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId THEN 'Y' ELSE 'N' END AS IsDefault                
 FROM ClientOrders CO INNER JOIN  OrderTemplateFrequencies OTF ON CO.OrderTemplateFrequencyId = OTF.OrderTemplateFrequencyId          
 WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(OTF.RecordDeleted, 'N') != 'Y' 

/* Order MedicationRoute Details*/                
 SELECT * FROM (                
  SELECT                
  ORD.OrderId,            
   MedicationRoutePOName = MDR.RouteAbbreviation, 
   MedicationRoutePOId= CAST(ORT.OrderRouteId as varchar),
  IsDefault = CASE WHEN MDR.RouteId = CO.MedicationOrderRouteId THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
   INNER JOIN OrderRoutes ORT on ORT.OrderId = ORD.OrderId AND ISNULL(ORT.RecordDeleted, 'N') <> 'Y'
   INNER JOIN MDRoutes MDR ON MDR.RouteId=ORT.RouteId AND ISNULL(MDR.RecordDeleted, 'N') = 'N'
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'           
              
  ) MedicationRoute 
                   
 /* Order MedicationRoute Details               
 SELECT * FROM (                
  SELECT                
  ORD.OrderId,            
  ORD.MedicationRoutePO,                 
  MedicationRoutePOName = CASE WHEN ISNULL(ORD.MedicationRoutePO, 'N') = 'Y' THEN 'PO' ELSE '' END,                
  MedicationRoutePOId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='PO') AS VARCHAR),                
  IsDefault = CASE WHEN (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='PO') = CO.MedicationOrderRouteId THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'           
                  
  UNION ALL                 
                  
  SELECT             
  ORD.OrderId,                
  ORD.MedicationRouteInjection,                
  MedicationRouteInjectionName = CASE WHEN ISNULL(ORD.MedicationRouteInjection, 'N') = 'Y' THEN 'Injection' ELSE '' END,                
  MedicationRouteInjectionId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='Injection') AS VARCHAR),                
  IsDefault = CASE WHEN (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='Injection') = CO.MedicationOrderRouteId THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'               
       
  UNION ALL                 
                  
  SELECT               
  ORD.OrderId,              
  ORD.MedicationRouteIV,                
  MedicationRouteIVName = CASE WHEN ISNULL(ORD.MedicationRouteIV, 'N') = 'Y' THEN 'IV' ELSE '' END,                
  MedicationRouteIVId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='IV') AS VARCHAR),                
  IsDefault = CASE WHEN (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERROUTE' AND GC.CodeName='IV') = CO.MedicationOrderRouteId THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'             
  ) MedicationRoute WHERE ISNULL(MedicationRoutePO, 'N') = 'Y'    
  */  

SELECT * FROM (                
  SELECT               
  ORD.OrderId,              
   PriorityRoutineName = [dbo].[GetGlobalCodeName](ORP.PriorityId),          
   PriorityRoutineId = CAST(ORP.PriorityId as varchar),  
  IsDefault = CASE WHEN CO.OrderPriorityId = ORP.PriorityId THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
   INNER JOIN OrderPriorities ORP on ORP.OrderId = ORD.OrderId AND ISNULL(ORP.RecordDeleted, 'N') <> 'Y'
  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'          
               
 ) Priority 
              
 /* Order Priority Details                
 SELECT * FROM (                
  SELECT               
  ORD.OrderId,              
  ORD.PriorityRoutine,                
  PriorityRoutineName = CASE WHEN ISNULL(ORD.PriorityRoutine, 'N') = 'Y' THEN 'Routine' ELSE '' END,                
  PriorityRoutineId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='Routine') AS VARCHAR),                
  IsDefault = CASE WHEN CO.OrderPriorityId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='Routine') THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'          
                  
  UNION ALL                
                  
  SELECT             
  ORD.OrderId,                
  ORD.PriorityASAP,                
  PriorityASAPName = CASE WHEN ISNULL(ORD.PriorityASAP, 'N') = 'Y' THEN 'ASAP' ELSE '' END,                
  PriorityASAPId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='ASAP') AS VARCHAR),                
  IsDefault = CASE WHEN CO.OrderPriorityId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERPRIORITY' AND GC.CodeName='ASAP') THEN 'Y' ELSE 'N' END                  
  FROM Orders ORD   
  INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'               
 ) Priority WHERE ISNULL(PriorityRoutine, 'N') = 'Y'   
 */             

/* Order Schedule Details*/                
 SELECT * FROM (                
  SELECT              
  ORD.OrderId,               
   ScheduleNowName = [dbo].[GetGlobalCodeName](ORS.ScheduleId),        
   ScheduleNowId = cast(ORS.ScheduleId as varchar),  
  IsDefault = CASE WHEN CO.OrderScheduleId = ORS.ScheduleId THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
   INNER JOIN OrderSchedules ORS on ORS.OrderId = ORD.OrderId AND ISNULL(ORS.RecordDeleted, 'N') <> 'Y'
  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'                
     
 ) Schedule 
                  
 /* Order Schedule Details                
 SELECT * FROM (                
  SELECT              
  ORD.OrderId,               
  ORD.ScheduleNow,                
  ScheduleNowName = CASE WHEN ISNULL(ORD.ScheduleNow, 'N') = 'Y' THEN 'Now' ELSE '' END,                
  ScheduleNowId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Now') AS VARCHAR),                
  IsDefault = CASE WHEN CO.OrderScheduleId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Now') THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'                
                  
  UNION ALL                 
                  
  SELECT               
  ORD.OrderId,              
  ORD.ScheduleTomorrow,                
  ScheduleTomorrowName = CASE WHEN ISNULL(ORD.ScheduleTomorrow, 'N') = 'Y' THEN 'Tomorrow' ELSE '' END,                
  ScheduleTomorrowId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Tomorrow') AS VARCHAR),                
  IsDefault = CASE WHEN CO.OrderScheduleId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='Tomorrow') THEN 'Y' ELSE 'N' END                  
  FROM Orders ORD INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'                
                   
  UNION ALL                 
                  
  SELECT               
  ORD.OrderId,              
  ORD.ScheduleAfter1PM,                
  ScheduleAfter1PMName = CASE WHEN ISNULL(ORD.ScheduleAfter1PM, 'N') = 'Y' THEN 'After 1PM' ELSE '' END,                
  ScheduleAfter1PMId = CAST((SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='After 1PM') AS VARCHAR),                
  IsDefault = CASE WHEN CO.OrderScheduleId = (SELECT GC.GlobalCodeId FROM GlobalCodes GC WHERE GC.Category='ORDERSTART' AND GC.CodeName='After 1PM') THEN 'Y' ELSE 'N' END                 
  FROM Orders ORD INNER JOIN   
  ClientOrders CO ON ORD.OrderId=CO.OrderId  
  WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'                 
 ) Schedule WHERE ISNULL(ScheduleNow, 'N') = 'Y' 
 */               
                 
 /* Order Details*/                
 SELECT                  
 ORD.OrderId,                
 CASE WHEN ORD.OrderType = 8503 AND ORD.OrderId = @OrderId THEN (SELECT TOP 1 ORD.OrderName + ' (' + Md.MedicationName + ')'    
		 FROM MedAdminRecords MAR  
		 LEFT JOIN ClientMedications CM ON CM.ClientMedicationId = MAR.ClientMedicationId AND ISNULL(CM.RecordDeleted, 'N') = 'N'
		 LEFT JOIN MDMedicationNames MD ON MD.MedicationNameId = CM.MedicationNameId AND ISNULL(MD.RecordDeleted, 'N') = 'N'
		 WHERE MAR.ClientOrderId = @ClientOrderId AND ISNULL(MAR.RecordDeleted, 'N') = 'N' )
 ELSE ORD.OrderName + ISNULL(' (' +(SELECT  MedicationName FROM MDMedicationNames WHERE  MedicationNameId = ORD.MedicationNameId) + ')','') END AS OrderName,    
 ORD.OrderType,                
 OrderTypeText = CASE WHEN ORD.OrderType = 8503 AND ORD.OrderId = @OrderId THEN 'RxOrder'
 ELSE (SELECT GC.CodeName FROM GlobalCodes GC WHERE ORD.OrderType = GC.GlobalCodeId) END,                
 ORD.HasRationale,                
 ORD.HasComments,                
 ORD.Active,          
 CASE ISNULL(ORD.CanBePended ,'N') WHEN 'N' THEN 'N' ELSE 'Y' END AS CanBePended,  
 CO.MedicationUseOtherUsage,  
 CO.MedicationOtherDosage,  
 CO.RationaleText,   
 CO.CommentsText,  
 CO.OrderPended,  
 CO.OrderDiscontinued,  
 CO.DiscontinuedDateTime,
 CO.OrderStartOther,  
 CO.OrderStartDateTime,  
 CO.OrderedBy,  
 CO.OrderMode,  
 CO.OrderStatus,  
 CO.AssignedTo,
 ISNULL(ORD.OrderLevelRequired, 'N') AS OrderLevelRequired,
 ISNULL(ORD.LegalStatusRequired, 'N') AS LegalStatusRequired,
 CO.MedicationDaySupply,
 CO.MedicationDosage,
 CO.MedicationRefill,
 CO.DispenseBrand,
 CO.OrderEndDateTime,
 CO.ConsentIsRequired,
 CO.MaySelfAdminister,
 CO.RationaleOtherText,
 CO.DrawFromServiceCenter,
 CO.DiscontinuedReason,
 CO.PotencyUnit,
 CO.ParentClientOrderId,
 CO.ClinicalLocation
 FROM ORDERS ORD                
 INNER JOIN   
 ClientOrders CO ON ORD.OrderId=CO.OrderId  
 WHERE CO.ClientOrderId=@ClientOrderId AND ISNULL(ORD.RecordDeleted, 'N') <> 'Y' AND ISNULL(CO.RecordDeleted, 'N') <> 'Y'  
 
 /* Units*/  
DECLARE @MedicationNameId INT ;  
SET @MedicationNameId = 0;  
SELECT @MedicationNameId = MedicationNameId FROM Orders WHERE OrderId = (SELECT OrderId FROM ClientOrders WHERE ClientOrderId = @ClientOrderId)  
EXEC [dbo].[ssp_SCGetMedicationUnits]  @MedicationNameId 
 
 /* Legal*/  
select GlobalCodeId,CodeName from GlobalCodes where Category ='XORDERLEGALSTATUS'
/* Level*/  
select GlobalCodeId,CodeName from GlobalCodes where Category = 'XORDERLEVEL'

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
		JOIN ClientOrders CO ON CO.OrderId = ORD.OrderId AND CO.ClientOrderId = @ClientOrderId
		WHERE  Isnull(ORQ.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(ShowQuestionTimeOption,'O')='O'
			AND ( ORD.OrderType <> 6481 OR ( ISNULL(ORQ.LaboratoryId, -1) = -1 OR ORQ.LaboratoryId IN (SELECT ORL.LaboratoryId FROM OrderLabs ORL WHERE ORL.OrderId = @ClientOrderId AND ISNULL(ORL.IsDefault,'N')='Y' )))
			
			/* Labs*/
		SELECT DISTINCT ORD.OrderId
			,ORL.LaboratoryId AS LabId
			,L.LaboratoryName AS LabName
			,IsDefault = ORL.IsDefault
		FROM Orders ORD
		INNER JOIN OrderLabs ORL ON ORL.OrderId = ORD.OrderId
			AND Isnull(ORL.RecordDeleted, 'N') <> 'Y'
		INNER JOIN Laboratories L ON L.LaboratoryId = ORL.LaboratoryId
		JOIN ClientOrders CO ON CO.OrderId = ORD.OrderId AND CO.ClientOrderId = @ClientOrderId
		WHERE  Isnull(ORD.RecordDeleted, 'N') <> 'Y'

		/* PotencyUnits*/
		
		EXEC [dbo].[ssp_GetPotencyUnitCodesByMedicationNameId] @MedicationNameId
           
END 

GO


