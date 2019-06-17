/****** Object:  StoredProcedure [dbo].[ssp_SCInsertClientOrderMedicationOthers]    Script Date: 05/19/2015 11:10:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInsertClientOrderMedicationOthers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCInsertClientOrderMedicationOthers]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCInsertClientOrderMedicationOthers]    Script Date: 05/19/2015 11:10:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCInsertClientOrderMedicationOthers] @DocumentVersionId INT  
 ,@UserCode type_CurrentUser  
AS  
/*********************************************************************/  
/* Stored Procedure: dbo.ssp_SCInsertClientOrderMedicationOthers            */  
/* Purpose:  To Insert data in Client Medications and other related tables                */  
/*  Date   Author   Purpose              */  
/* 06/Oct/2013  Prasan   Created              */  
/* 19/Nov/2014      Gautam          Modified code to insert MedicationDosage in table ClientMedicationInstructions   
									in place of NULL, Why: Instructions was not showing in RX application    */  
/* 19/Feb/2015		Gautam			The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table  
									and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */  
/* 13/May/2015      Shankha			Added logic to discontinue Medications in RX when they are  discontinued in SmartCare Order   
										Entry*/  
/* 29/Jul/2015      Gautam          What : Trailing zero removed for dosage quantity Why : Philhaven Development task#259  */		
/* 17/Jan/2017		Chethan N		What: 1. Pushing PotencyUnit, Dispense Quantity and Refills from ClientOrders table and inserting a row in ClientMedicationScripts with corresponding Client Order data.
										2. Updating the Client Medication related tables when ClientOrders is modified (Instead of insert new Client Medication)
									Why:  Renaissance - Dev Items task #5	*/			
/* 28/Mar/2017		Chethan N		What: Inserting ClientMedicationScripts.VerbalOrderApproved = 'Y' -- Marking Medication as Non Verbal.
									Why:  Renaissance - Dev Items task #5.1	*/			
/* 26/Jul/2017		Chethan N		What: Inserting 0 in ClientMedicationScriptDrugs.Sample and ClientMedicationScriptDrugs.Stock.
									Why:  Renaissance - Dev Items task #5.1	*/			
/* 26/Jul/2017		Chethan N		What: Pushing Comments to SpecailIntructions.
									Why:  Renaissance - Environment Issues Tracking task #71 */			
/* 06/Oct/2017		Chethan N		What: Pushing Ordered DateTime to Rx.
									Why:  Renaissance - Dev Items task #5.13	*/	
/* Apr 13 2017		Chethan N		What : Discontinuing Client Medication and inserting new Client Medication when ClientOrder is modified.
									Why : AHN Support GO live Task #194	*/		
/*June 06 2018      Pranay B        What: Added CAST(CEILING(CO.MedicationDaySupply= * MedicationDosage * GC.ExternalCode1) AS DECIMAL(10,2)) w.r.t AHN-Support Go Live: #135.1 Orders: Dispense Calculation in Orders */	
/* Aug 13 2018		Chethan N		What : Cast MedicationDosage to Decimal as Dosage is transferred to Rx as Int.
									Why : AHN Support GO live Task #375	*/	
/*Sep 06 2018		Vithobha		What: Added DISTINCT to get the distinct rows from OrdersInteractionDetails
									Why:  OrdersInteractionDetails has duplicate values for some medications. AHN-Support Go Live: #380*/
/*JAN 03 2018       Lakshmi			What: CHARINDEX function throws error (Invalid length parameter passed to the LEFT or SUBSTRING												  function.*****ssp_SCInsertClientOrderMedicat)
									Why: CHARINDEX  used inside sub string function if CHARINDEX doesn’t returns a position then it will										  throw an error,  AHN-Support Go Live #484
 Jan 11 2019		Chethan N		What : Inserting value in ClientMedicationScriptDrugs.PharmacyText same as Pharmacy column as Dispense Qty drop down binds from PharmacyText column.
									Why : AHN Support GO live Task #489	*/										
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  BEGIN TRANSACTION  
   
  DECLARE @OrderInteractionReferenceTable TABLE (  
   IsInteraction CHAR(1)  
   ,ClientMedicationInteractionId INT  
   ,ClientOrderId INT  
   ,OrderId INT  
   ,ClientId INT  
   ,ClientMedicationId INT  
   ,ClientMedicationInstructionId INT  
   ,ClientMedicationScriptId INT  
   ,ClientMedicationScriptDrugId INT  
   ,ClientMedicationScriptDrugStrengthId INT  
   ,ClientMedicationScriptActivityId INT  
   )  
  
  BEGIN -- Inserting into ClientMedications table & @OrderInteractionReferenceTable table    
   MERGE ClientMedications trgt  
   USING (  
    SELECT CO.ClientOrderId  
     ,CO.OrderId  
     ,CO.ClientId  
     ,'N' AS Ordered  
     ,O.MedicationNameId  
     ,CAST(CO.OrderStartDateTime AS DATETIME) AS MedicationStartDate  
     ,CAST(CO.OrderEndDateTime AS DATETIME) AS MedicationEndDate  
     ,CO.OrderingPhysician AS PrescriberId  
     ,S.LastName + ', ' + S.FirstName AS PrescriberName  
     ,'N' AS IncludeCommentOnPrescription  
     ,CommentsText AS Comments   
     ,CommentsText AS SpecialInstructions  
     ,OrderDiscontinued AS Discontinued  
     ,DiscontinuedDateTime AS DiscontinueDate  
     ,'Y' AS PermitChangesByOtherUsers  
     ,@UserCode AS CreatedBy  
     ,GETDATE() AS CreatedDate  
     ,@UserCode AS ModifiedBy  
     ,GETDATE() AS ModifiedDate  
     ,NULL AS RecordDeleted  
     ,NULL AS DeletedBy  
     ,NULL AS DeletedDate  
    FROM ClientOrders CO  
    INNER JOIN Orders O ON CO.OrderId = O.OrderId  
     AND O.OrderType = 8501 -- Only Medication order type    
     AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
     AND ISNULL(O.RecordDeleted, 'N') = 'N'  
    LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
     AND ISNULL(S.RecordDeleted, 'N') = 'N'  
    WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 --AND CO.PreviousClientOrderId IS NULL
    ) src  
    ON (1 = 0)  
   WHEN NOT MATCHED  
    THEN  
     INSERT (  
      ClientId  
      ,Ordered  
      ,MedicationNameId  
      ,MedicationStartDate  
      ,MedicationEndDate  
      ,PrescriberId  
      ,PrescriberName  
      ,IncludeCommentOnPrescription  
      ,Comments
      ,SpecialInstructions  
      ,Discontinued  
      ,DiscontinueDate  
      ,PermitChangesByOtherUsers  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedBy  
      ,DeletedDate  
      ,SmartCareOrderEntry  
      )  
     VALUES (  
      src.ClientId  
      ,src.Ordered  
      ,src.MedicationNameId  
      ,src.MedicationStartDate  
      ,src.MedicationEndDate  
      ,src.PrescriberId  
      ,src.PrescriberName  
      ,src.IncludeCommentOnPrescription  
      ,src.Comments
      ,src.SpecialInstructions  
      ,src.Discontinued  
      ,src.DiscontinueDate  
      ,src.PermitChangesByOtherUsers  
      ,src.CreatedBy  
      ,src.CreatedDate  
      ,src.ModifiedBy  
      ,src.ModifiedDate  
      ,src.RecordDeleted  
      ,src.DeletedBy  
      ,src.DeletedDate  
      ,'Y'  
      )  
   OUTPUT 'N'  
    ,NULL  
    ,src.ClientOrderId  
    ,src.OrderId  
    ,inserted.ClientId  
    ,inserted.ClientMedicationId      ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
   INTO @OrderInteractionReferenceTable;  
  END  
  
  BEGIN --Inserting into ClientMedicationInstructions table    
   DECLARE @ClientMedicationInstructionsRefTable TABLE (  
    ClientOrderId INT  
    ,ClientMedicationInstructionId INT  
    )  
  
   MERGE ClientMedicationInstructions trgt  
   USING (  
    SELECT O.ClientMedicationId  
     ,os.MedicationId AS StrengthId  
     -- Gautam 19th Nov,2014  
     ,CAST(CO.MedicationDosage AS DECIMAL(10, 2)) AS Quantity  
     ,CO.MedicationUnits AS Unit  
     ,  
     --CO.OrderScheduleId as Schedule,    
     --otfq.FrequencyId as Schedule,      
     otfq.RxFrequencyId AS Schedule  
     ,'Y' AS Active  
     ,@UserCode AS CreatedBy  
     ,GETDATE() AS CreatedDate  
     ,@UserCode AS ModifiedBy  
     ,GETDATE() AS ModifiedDate  
     ,NULL AS RecordDeleted  
     ,NULL AS DeletedDate  
     ,NULL AS DeletedBy  
     ,CO.ClientOrderId
	 ,CO.PotencyUnit  
    FROM ClientOrders CO  
    INNER JOIN @OrderInteractionReferenceTable O ON O.ClientOrderId = CO.ClientOrderId  
    LEFT JOIN OrderStrengths os ON os.OrderStrengthId = ISNULL(CO.MedicationOrderStrengthId, 0)  
    --LEFT JOIN OrderFrequencies ofq ON ofq.OrderFrequencyId = ISNULL(CO.OrderFrequencyId, 0)  
    LEFT JOIN OrderTemplateFrequencies otfq ON otfq.OrderTemplateFrequencyId = ISNULL(CO.OrderTemplateFrequencyId, 0)  
    ) src  
    ON (1 = 0)  
   WHEN NOT MATCHED  
    THEN  
     INSERT (  
      ClientMedicationId  
      ,StrengthId  
      ,Quantity  
      ,Unit  
      ,Schedule  
      ,Active  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy
	  ,PotencyUnitCode  
      )  
     VALUES (  
      src.ClientMedicationId  
      ,src.StrengthId  
      ,src.Quantity  
      ,src.Unit  
      ,src.Schedule  
      ,src.Active  
      ,src.CreatedBy  
      ,src.CreatedDate  
      ,src.ModifiedBy  
      ,src.ModifiedDate  
      ,src.RecordDeleted  
      ,src.DeletedDate  
      ,src.DeletedBy
	  ,src.PotencyUnit  
      )  
   OUTPUT src.ClientOrderId  
    ,inserted.ClientMedicationInstructionId  
   INTO @ClientMedicationInstructionsRefTable;  
  
   UPDATE t  
   SET t.ClientMedicationInstructionId = t1.ClientMedicationInstructionId  
   FROM @OrderInteractionReferenceTable t  
   INNER JOIN @ClientMedicationInstructionsRefTable t1 ON t.ClientOrderId = t1.ClientOrderId  
    AND t.IsInteraction = 'N';  
  END  
  
  BEGIN -- Inserting into @ClientMedicationInteractionsTmp table    
   DECLARE @OrdersInteractionDetailsFiltered TABLE (  
    SeverityLevel VARCHAR(30)  
    ,DrugInteractionMonographId INT  
    ,OrderId INT  
    ,DrugDrugInteractionId INT  
    )  
   DECLARE @OrdersInteractionDetailsGrouped TABLE (  
    SeverityLevel VARCHAR(30)  
    ,DrugInteractionMonographId INT  
    ,OrderIdList VARCHAR(max)  
    ,DrugDrugInteractionIdList VARCHAR(max)  
    )  
   DECLARE @ClientMedicationInteractionsTmp TABLE (  
    ClientMedicationId1 INT  
    ,ClientMedicationId2 INT  
    ,DrugInteractionMonographId INT  
    ,InteractionLevel VARCHAR(30)  
    ,OrderIdList VARCHAR(max)  
    ,DrugDrugInteractionIdList VARCHAR(max)  
    )  
  
   INSERT INTO @OrdersInteractionDetailsFiltered  
   SELECT DISTINCT oid.SeverityLevel  
    ,oid.DrugInteractionMonographId  
    ,oid.OrderId  
    ,oid.DrugDrugInterractionId  
   FROM OrdersInteractionDetails oid  
   WHERE isnull(oid.RecordDeleted, 'N') = 'N'  
    AND oid.DocumentVersionId = @DocumentVersionId  
    AND oid.MedicationId IS NOT NULL -- only medications    
    AND oid.OrderId IN (  
     SELECT OrderId  
     FROM @OrderInteractionReferenceTable  
     )  
  
   INSERT INTO @OrdersInteractionDetailsGrouped  
   SELECT t.SeverityLevel  
    ,t.DrugInteractionMonographId  
    ,OrderIdList = Replace((  
      SELECT t1.OrderId AS [data()]  
      FROM @OrdersInteractionDetailsFiltered t1  
      WHERE t1.SeverityLevel = t.SeverityLevel  
       AND t1.DrugInteractionMonographId = t.DrugInteractionMonographId  
      FOR XML path('')  
      ), ' ', ',')  
    ,DrugDrugInteractionIdList = Replace((  
      SELECT t1.DrugDrugInteractionId AS [data()]  
      FROM @OrdersInteractionDetailsFiltered t1  
      WHERE t1.SeverityLevel = t.SeverityLevel  
       AND t1.DrugInteractionMonographId = t.DrugInteractionMonographId  
      FOR XML path('')  
      ), ' ', ',')  
   FROM @OrdersInteractionDetailsFiltered t  
   GROUP BY t.SeverityLevel  
    ,t.DrugInteractionMonographId  
   HAVING COUNT(*) > 1  
  
   DECLARE @NewOrderListVar VARCHAR(max);  
   DECLARE @OrderListVar VARCHAR(max)  
    ,@DrugDrugInteractionIdList VARCHAR(max)  
    ,@DrugInteractionMonographId INT  
    ,@SeverityLevel VARCHAR(30);  
  
   DECLARE cursVar CURSOR  
   FOR  
   SELECT OrderIdList  
    ,DrugDrugInteractionIdList  
    ,DrugInteractionMonographId  
    ,SeverityLevel  
   FROM @OrdersInteractionDetailsGrouped  
  
   OPEN cursVar  
  
   FETCH NEXT  
   FROM cursVar  
   INTO @OrderListVar  
    ,@DrugDrugInteractionIdList  
    ,@DrugInteractionMonographId  
    ,@SeverityLevel  
  
   WHILE @@FETCH_STATUS = 0  
   BEGIN  
    DECLARE @OrderId1 INT  
     ,@OrderId2 INT;  
  
    SET @NewOrderListVar = NULL  
  
    IF (CHARINDEX(',', @OrderListVar) > 0)  
    BEGIN  
     SELECT @NewOrderListVar = coalesce(@NewOrderListVar + ',', '') + CONVERT(VARCHAR, TOKEN)  
     FROM (  
      SELECT DISTINCT TOP 2 TOKEN  
      FROM dbo.SplitString(@OrderListVar, ',')  
      ) t  
  
     SET @OrderListVar = @NewOrderListVar  
    END  
  
    SELECT @OrderId1 = cast(SUBSTRING(@OrderListVar, 1, CASE WHEN CHARINDEX(',',@ORDERLISTVAR)=0 THEN LEN(@ORDERLISTVAR) ELSE CHARINDEX(',',@ORDERLISTVAR) - 1 END) AS INT)  
     ,@OrderId2 = cast(SUBSTRING(@OrderListVar, CHARINDEX(',', @OrderListVar) + 1, LEN(@OrderListVar)) AS INT)  
  
    INSERT INTO @ClientMedicationInteractionsTmp (  
     ClientMedicationId1  
     ,ClientMedicationId2  
     ,OrderIdList  
     ,DrugDrugInteractionIdList  
     ,InteractionLevel  
     ,DrugInteractionMonographId  
     )  
    SELECT t.ClientMedicationId AS ClientMedicationId1  
     ,t1.ClientMedicationId AS ClientMedicationId2  
     ,@OrderListVar  
     ,@DrugDrugInteractionIdList  
     ,@SeverityLevel  
     ,@DrugInteractionMonographId  
    FROM (  
     SELECT ClientMedicationId  
     FROM @OrderInteractionReferenceTable  
     WHERE OrderId = @OrderId1  
     ) t  
     ,(  
      SELECT ClientMedicationId  
      FROM @OrderInteractionReferenceTable  
      WHERE OrderId = @OrderId2  
      ) t1  
  
    FETCH NEXT  
    FROM cursVar  
    INTO @OrderListVar  
     ,@DrugDrugInteractionIdList  
     ,@DrugInteractionMonographId  
     ,@SeverityLevel  
   END  
  
   CLOSE cursVar  
  
   DEALLOCATE cursVar  
    --select * from @OrdersInteractionDetailsFiltered    
    --select * from @OrdersInteractionDetailsGrouped    
    --select * from @OrderInteractionReferenceTable    
    --select * from @ClientMedicationInteractionsTmp    
    -----------------------    
  END  
  
  BEGIN --Inserting into ClientMedicationInteractions table    
   DECLARE @outputTblForClientMedIntDetails TABLE (  
    ClientMedicationInteractionId INT  
    ,DrugDrugInteractionIdList VARCHAR(max)  
    )  
  
   MERGE ClientMedicationInteractions trgt  
   USING (  
    SELECT ClientMedicationId1  
     ,ClientMedicationId2  
     ,InteractionLevel  
     ,NULL AS PrescriberAcknowledgementRequired  
     ,NULL AS PrescriberAcknowledged  
     ,@UserCode AS CreatedBy  
     ,GETDATE() AS CreatedDate  
     ,@UserCode AS ModifiedBy  
     ,GETDATE() AS ModifiedDate  
     ,NULL AS RecordDeleted  
     ,NULL AS DeletedBy  
     ,NULL AS DeletedDate  
     ,DrugDrugInteractionIdList  
    FROM @ClientMedicationInteractionsTmp  
    ) src  
    ON (1 = 0)  
   WHEN NOT MATCHED  
    THEN  
     INSERT (  
      ClientMedicationId1  
      ,ClientMedicationId2  
      ,InteractionLevel  
      ,PrescriberAcknowledgementRequired  
      ,PrescriberAcknowledged  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy  
      )  
     VALUES (  
      src.ClientMedicationId1  
      ,src.ClientMedicationId2  
      ,src.InteractionLevel  
      ,src.PrescriberAcknowledgementRequired  
      ,src.PrescriberAcknowledged  
      ,src.CreatedBy  
      ,src.CreatedDate  
      ,src.ModifiedBy  
      ,src.ModifiedDate  
      ,src.RecordDeleted  
      ,src.DeletedDate  
      ,src.DeletedBy  
      )  
   OUTPUT inserted.ClientMedicationInteractionId  
    ,src.DrugDrugInteractionIdList  
   INTO @outputTblForClientMedIntDetails;  
  
   INSERT INTO @OrderInteractionReferenceTable  
   SELECT 'Y'  
    ,ClientMedicationInteractionId  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
    ,NULL  
   FROM @outputTblForClientMedIntDetails;  
  END  
  
  BEGIN --Insert in ClientMedicationInteractionDetails table    
   INSERT INTO ClientMedicationInteractionDetails (  
    ClientMedicationInteractionId  
    ,DrugDrugInteractionId  
    ,CreatedBy  
    ,CreatedDate  
    ,ModifiedBy  
    ,ModifiedDate  
    ,RecordDeleted  
    ,DeletedDate  
    ,DeletedBy  
    )  
   SELECT DISTINCT A.[ClientMedicationInteractionId]  
    ,--DISTINCT added for preventing duplicate DrugDrugInteractionId     
    Split.a.value('.', 'VARCHAR(100)') AS String  
    ,@UserCode  
    ,--CreatedBy              
    GETDATE()  
    ,--CreatedDate              
    @UserCode  
    ,--ModifiedBy              
    GETDATE()  
    ,--ModifiedDate              
    NULL  
    ,--RecordDeleted              
    NULL  
    ,--DeletedBy              
    NULL --DeletedDate         
   FROM (  
    SELECT [ClientMedicationInteractionId]  
     ,CAST('<M>' + REPLACE([DrugDrugInteractionIdList], ',', '</M><M>') + '</M>' AS XML) AS String  
    FROM @outputTblForClientMedIntDetails  
    ) AS A  
   CROSS APPLY String.nodes('/M') AS Split(a);  
  END  
  
  BEGIN --Insert in ClientMedicationScripts table    
	DECLARE @ClientMedicationScriptsRefTable TABLE (
		ClientOrderId INT
		,ClientMedicationScriptId INT
		)

	MERGE [ClientMedicationScripts] trgt
	USING (
		SELECT O.ClientId
			,CAST(CO.OrderStartDateTime AS DATE) AS OrderDate
			,CO.OrderingPhysician AS OrderingPrescriberId
			,S.LastName + ' ,' + S.FirstName AS OrderingPrescriberName
			,@UserCode AS CreatedBy
			,GETDATE() AS CreatedDate
			,@UserCode AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,NULL AS RecordDeleted
			,NULL AS DeletedDate
			,NULL AS DeletedBy
			,CO.ClientOrderId
			,CO.IsReadBackAndVerified
			,'Y' AS VerbalOrderApproved
		FROM ClientOrders CO
		INNER JOIN @OrderInteractionReferenceTable O ON O.ClientOrderId = CO.ClientOrderId
		LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		) src
		ON (1 = 0)
	WHEN NOT MATCHED
		THEN
			INSERT (
				[ClientId]
				,[OrderDate]
				,[OrderingPrescriberId]
				,[OrderingPrescriberName]
				,[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedDate]
				,[DeletedBy]
				,[VerbalOrderReadBack]
				,[VerbalOrderApproved]
				)
			VALUES (
				src.ClientId
				,src.OrderDate
				,src.OrderingPrescriberId
				,src.OrderingPrescriberName
				,src.CreatedBy
				,src.CreatedDate
				,src.ModifiedBy
				,src.ModifiedDate
				,src.RecordDeleted
				,src.DeletedDate
				,src.DeletedBy
				,src.IsReadBackAndVerified
				,src.VerbalOrderApproved
				)
	OUTPUT src.ClientOrderId
		,inserted.ClientMedicationScriptId
	INTO @ClientMedicationScriptsRefTable;

	UPDATE t
	SET t.ClientMedicationScriptId = t1.ClientMedicationScriptId
	FROM @OrderInteractionReferenceTable t
	INNER JOIN @ClientMedicationScriptsRefTable t1 ON t.ClientOrderId = t1.ClientOrderId
		AND t.IsInteraction = 'N';
	END
  BEGIN --Insert in ClientMedicationScriptDrugs table    
   DECLARE @ClientMedicationScriptDrugsRefTable TABLE (  
    ClientOrderId INT  
    ,ClientMedicationScriptDrugId INT  
    )  
  
   MERGE ClientMedicationScriptDrugs trgt  
   USING (  
    SELECT O.ClientMedicationScriptId  
     ,O.ClientMedicationInstructionId  
     ,CAST(CO.OrderStartDateTime AS DATE) AS StartDate  
     ,CO.MedicationDaySupply AS Days  
     ,ISNULL(CO.MedicationRefill,0) AS Refills  
     ,CAST(CO.OrderEndDateTime AS DATE) AS EndDate
	 --,CAST(ROUND(CO.MedicationDaySupply * MedicationDosage * GC.ExternalCode1, 2) AS DECIMAL(10,2)) AS Pharmacy  
	 ,CAST(CEILING(CO.MedicationDaySupply * MedicationDosage * GC.ExternalCode1) AS DECIMAL(10,2))  AS Pharmacy 
	 ,CAST(CEILING(CO.MedicationDaySupply * MedicationDosage * GC.ExternalCode1) AS DECIMAL(10,2))  AS PharmacyText 
     ,@UserCode AS CreatedBy  
     ,GETDATE() AS CreatedDate  
     ,@UserCode AS ModifiedBy  
     ,GETDATE() AS ModifiedDate  
     ,NULL AS RecordDeleted  
     ,NULL AS DeletedDate  
     ,NULL AS DeletedBy  
     ,CO.ClientOrderId 
    FROM ClientOrders CO  
    INNER JOIN @OrderInteractionReferenceTable O ON O.ClientOrderId = CO.ClientOrderId
	JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
	JOIN GlobalCodes GC ON GC.GlobalCodeId = OTF.RxFrequencyId
    ) src  
    ON (1 = 0)  
   WHEN NOT MATCHED  
    THEN  
     INSERT (  
      [ClientMedicationScriptId]  
      ,[ClientMedicationInstructionId]  
      ,[StartDate]  
      ,[Days]  
      ,[Refills]  
      ,[EndDate]
	  ,[Pharmacy]
	  ,[PharmacyText]
	  ,[Sample]
	  ,[Stock]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      )  
     VALUES (  
      src.ClientMedicationScriptId  
      ,src.ClientMedicationInstructionId  
      ,src.StartDate  
      ,src.Days  
      ,src.Refills  
      ,src.EndDate
	  ,src.Pharmacy
	  ,src.PharmacyText
	  ,0
	  ,0  
      ,src.CreatedBy  
      ,src.CreatedDate  
      ,src.ModifiedBy  
      ,src.ModifiedDate  
      ,src.RecordDeleted  
      ,src.DeletedDate  
      ,src.DeletedBy  
      )  
   OUTPUT src.ClientOrderId  
    ,inserted.ClientMedicationScriptDrugId  
   INTO @ClientMedicationScriptDrugsRefTable;  
  
   UPDATE t  
   SET t.ClientMedicationScriptDrugId = t1.ClientMedicationScriptDrugId  
   FROM @OrderInteractionReferenceTable t  
   INNER JOIN @ClientMedicationScriptDrugsRefTable t1 ON t.ClientOrderId = t1.ClientOrderId  
    AND t.IsInteraction = 'N';  
  END  
  
  BEGIN --Insert in ClientMedicationScriptDrugStrengths table    
   DECLARE @ClientMedicationScriptDrugStrengthsRefTable TABLE (  
    ClientOrderId INT  
    ,ClientMedicationScriptDrugStrengthId INT  
    )  
  
   MERGE ClientMedicationScriptDrugStrengths trgt  
   USING (  
    SELECT O.ClientMedicationScriptId  
     ,O.ClientMedicationId  
     ,  
     --CO.MedicationOrderStrengthId as StrengthId,    
     os.MedicationId AS StrengthId  
     ,ISNULL(CO.MedicationRefill, 0) AS Refills  
     ,@UserCode AS CreatedBy  
     ,GETDATE() AS CreatedDate  
     ,@UserCode AS ModifiedBy  
     ,GETDATE() AS ModifiedDate  
     ,NULL AS RecordDeleted  
     ,NULL AS DeletedDate  
     ,NULL AS DeletedBy  
     ,CO.ClientOrderId  
    FROM ClientOrders CO  
    INNER JOIN @OrderInteractionReferenceTable O ON O.ClientOrderId = CO.ClientOrderId  
     AND CO.MedicationOrderStrengthId IS NOT NULL  
    INNER JOIN OrderStrengths os ON os.OrderStrengthId = ISNULL(CO.MedicationOrderStrengthId, 0)  
     AND os.MedicationId IS NOT NULL  
    ) src  
    ON (1 = 0)  
   WHEN NOT MATCHED  
    THEN  
     INSERT (  
      ClientMedicationScriptId  
      ,ClientMedicationId  
      ,StrengthId  
      ,Refills  
      ,CreatedBy  
      ,CreatedDate  
      ,ModifiedBy  
      ,ModifiedDate  
      ,RecordDeleted  
      ,DeletedDate  
      ,DeletedBy  
      )  
     VALUES (  
      src.ClientMedicationScriptId  
      ,src.ClientMedicationId  
      ,src.StrengthId  
      ,src.Refills  
      ,src.CreatedBy  
      ,src.CreatedDate  
      ,src.ModifiedBy  
      ,src.ModifiedDate  
      ,src.RecordDeleted  
      ,src.DeletedDate  
      ,src.DeletedBy  
      )  
   OUTPUT src.ClientOrderId  
    ,inserted.ClientMedicationScriptDrugStrengthId  
   INTO @ClientMedicationScriptDrugStrengthsRefTable;  
  
   UPDATE t  
   SET t.ClientMedicationScriptDrugStrengthId = t1.ClientMedicationScriptDrugStrengthId  
   FROM @OrderInteractionReferenceTable t  
   INNER JOIN @ClientMedicationScriptDrugStrengthsRefTable t1 ON t.ClientOrderId = t1.ClientOrderId  
    AND t.IsInteraction = 'N';  
  END  
  
  --begin  --Insert in ClientMedicationScriptActivities table    
  --declare @ClientMedicationScriptActivitiesRefTable table    
  --(    
  --  ClientOrderId int,    
  --  ClientMedicationScriptActivityId int      
  --)    
  --MERGE ClientMedicationScriptActivities trgt    
  --using    
  --(    
  --  Select   O.ClientMedicationScriptId,    
  --   @UserCode as CreatedBy,                    
  --   GETDATE() as CreatedDate,       
  --   @UserCode as ModifiedBy,                 
  --   GETDATE() as ModifiedDate,       
  --   NULL as RecordDeleted,        
  --   NULL as DeletedDate,        
  --   NULL as DeletedBy,    
  --   CO.ClientOrderId         
  -- FROM  ClientOrders CO     
  -- Inner Join @OrderInteractionReferenceTable O On O.ClientOrderId= CO.ClientOrderId    
  --)src on(1=0)    
  --when not matched then    
  --insert (ClientMedicationScriptId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy)    
  --values (src.ClientMedicationScriptId,src.CreatedBy,src.CreatedDate,src.ModifiedBy,src.ModifiedDate,src.RecordDeleted,src.DeletedDate,src.DeletedBy)    
  --output src.ClientOrderId,inserted.ClientMedicationScriptActivityId into @ClientMedicationScriptActivitiesRefTable;    
  --update t set t.ClientMedicationScriptActivityId = t1.ClientMedicationScriptActivityId    
  -- from @OrderInteractionReferenceTable t     
  -- inner join @ClientMedicationScriptActivitiesRefTable t1 on t.ClientOrderId = t1.ClientOrderId    
  -- and t.IsInteraction = 'N';     
  --end    
  -- insert in ClientMedicationScriptActivitiesPending     
  BEGIN -- Inserting into ClientOrderMedicationReferences table    
   DECLARE @currDate DATETIME = getdate();  
  
   INSERT INTO [ClientOrderMedicationReferences] (  
    DocumentVersionId  
    ,IsInteraction  
    ,ClientMedicationInteractionId  
    ,ClientOrderId  
    ,ClientMedicationId  
    ,ClientMedicationInstructionId  
    ,ClientMedicationScriptId  
    ,ClientMedicationScriptDrugId  
    ,ClientMedicationScriptDrugStrengthId  
    ,ClientMedicationScriptActivityId  
    ,CreatedBy  
    ,CreatedDate  
    ,IsActive  
    )  
   SELECT @DocumentVersionId  
    ,IsInteraction  
    ,ClientMedicationInteractionId  
    ,ClientOrderId  
    ,ClientMedicationId  
    ,ClientMedicationInstructionId  
    ,ClientMedicationScriptId  
    ,ClientMedicationScriptDrugId  
    ,ClientMedicationScriptDrugStrengthId  
    ,ClientMedicationScriptActivityId  
    ,@UserCode  
    ,@currDate  
    ,'Y'  
   FROM @OrderInteractionReferenceTable  
  END  
  
  BEGIN --updating ClientMedicationInteractions table for Level 1 acknowledged interactions    
   DECLARE @tmpUpdateTblClientOrdIntDet TABLE (  
    ClientOrderId1 INT  
    ,ClientOrderId2 INT  
    ,PrescriberAcknowledged CHAR(1)  
    ,ClientMedicationId1 INT  
    ,ClientMedicationId2 INT  
    )  
  
   INSERT INTO @tmpUpdateTblClientOrdIntDet (  
    ClientOrderId1  
    ,ClientOrderId2  
    ,PrescriberAcknowledged  
    ,ClientMedicationId1  
    ,ClientMedicationId2  
    )  
   SELECT ClientOrderId1  
    ,ClientOrderId2  
    ,PrescriberAcknowledged  
    ,SUBSTRING(t.ClientMedicationIds, 1, CHARINDEX(',', t.ClientMedicationIds) - 1) AS ClientMedicationId1  
    ,SUBSTRING(t.ClientMedicationIds, CHARINDEX(',', t.ClientMedicationIds) + 1, Len(t.ClientMedicationIds)) AS ClientMedicationId2  
   FROM (  
    SELECT COID.ClientOrderId1  
     ,COID.ClientOrderId2  
     ,PrescriberAcknowledged  
     ,ClientMedicationIds = Replace((  
       SELECT TOP 2 ClientMedicationId AS [data()]  
       FROM ClientOrderMedicationReferences COMR  
       WHERE (  
         COMR.ClientOrderId = COID.ClientOrderId1  
         OR COMR.ClientOrderId = COID.ClientOrderId2  
         )  
        AND isnull(COMR.IsActive, 'N') = 'Y'  
        AND COMR.DocumentVersionId = @DocumentVersionId  
        AND COMR.IsInteraction = 'N'  
       ORDER BY COMR.CreatedDate DESC  
       FOR XML path('')  
       ), ' ', ',')  
    FROM ClientOrdersInteractionDetails COID  
    WHERE ISNULL(COID.RecordDeleted, 'N') = 'N'  
     AND COID.DocumentVersionId = @DocumentVersionId  
     AND COID.InteractionLevel = 1  
     AND isnull(COID.PrescriberAcknowledged, 'N') = 'Y'  
    ) t  
  
   UPDATE CMI  
   SET CMI.PrescriberAcknowledged = t.PrescriberAcknowledged  
   FROM ClientMedicationInteractions CMI  
   INNER JOIN @tmpUpdateTblClientOrdIntDet t ON (  
     (  
      CMI.ClientMedicationId1 = t.ClientMedicationId1  
      AND CMI.ClientMedicationId2 = t.ClientMedicationId2  
      )  
     OR (  
      CMI.ClientMedicationId2 = t.ClientMedicationId1  
      AND CMI.ClientMedicationId1 = t.ClientMedicationId2  
      )  
     )  
   WHERE ISNULL(CMI.RecordDeleted, 'N') = 'N'  
    AND CMI.ClientMedicationInteractionId IN (  
     SELECT ClientMedicationInteractionId  
     FROM ClientOrderMedicationReferences  
     WHERE isnull(IsActive, 'N') = 'Y'  
      AND DocumentVersionId = @DocumentVersionId  
      AND IsInteraction = 'Y'  
     )  
    AND CMI.InteractionLevel = 1  
  END  
  
  BEGIN --insert into ClientAllergies    
   INSERT INTO ClientAllergies (  
    [CreatedBy]  
    ,[CreatedDate]  
    ,[ModifiedBy]  
    ,[ModifiedDate]  
    ,[ClientId]  
    ,[AllergenConceptId]  
    ,[AllergyType]  
    ,[Active]  
    )  
   SELECT @UserCode AS [CreatedBy]  
    ,GETDATE() AS [CreatedDate]  
    ,@UserCode AS [ModifiedBy]  
    ,GETDATE() AS [ModifiedDate]  
    ,oid.[ClientId]  
    ,oid.[AllergenConceptId]  
    ,'A' AS [AllergyType]  
    ,'Y' AS [Active]  
   FROM OrdersInteractionDetails oid  
   INNER JOIN @OrderInteractionReferenceTable O ON O.OrderId = oid.OrderId  
    AND O.IsInteraction = 'N'  
   WHERE isnull(oid.RecordDeleted, 'N') = 'N'  
    AND oid.DocumentVersionId = @DocumentVersionId  
    AND oid.AllergenConceptId IS NOT NULL -- only allergies    
  END  
  
  -- Process Discontinued Medications  
  DECLARE @tDiscontinuedClientMedicationId INT  
  DECLARE @tPrescriberId INT  
  DECLARE @tDiscontinuedReason INT  
  DECLARE @UserName VARCHAR(30)  
  
  SELECT @UserName = UserCode  
  FROM Staff  
  WHERE UserCode = @UserCode  
   AND ISNULL(RecordDeleted, 'N') = 'N'  
  
  DECLARE @tDiscontinuedMedications TABLE (  
   [ClientMedicationid] INT  
   ,[PrescriberId] INT
   ,[DiscontinuedReason] INT  
   )  
  
  INSERT INTO @tDiscontinuedMedications  
  SELECT DISTINCT CM.ClientMedicationId  
   ,CM.PrescriberId
   ,CO.DiscontinuedReason  
  FROM ClientOrders CO  
  INNER JOIN Orders O ON CO.OrderId = O.OrderId  
   AND O.OrderType = 8501 -- Only Medication order type    
   AND ISNULL(O.RecordDeleted, 'N') = 'N'  
  INNER JOIN ClientOrderMedicationReferences CMR ON CMR.ClientOrderId = CO.ClientOrderId  
  INNER JOIN ClientMedications CM ON CMR.ClientMedicationId = CM.ClientMedicationId  
  WHERE CO.DocumentVersionId = @DocumentVersionId  
    AND (
   ISNULL(CO.OrderDiscontinued, 'N') = 'Y'  OR CO.OrderStatus = 6510
   )   
   
   UNION
   
  SELECT DISTINCT CM.ClientMedicationId  
   ,CM.PrescriberId
   ,PCO.DiscontinuedReason  
  FROM ClientOrders CO  
  JOIN ClientOrders PCO ON PCO.ClientOrderId = CO.PreviousClientOrderId  
  INNER JOIN Orders O ON CO.OrderId = O.OrderId  
   AND O.OrderType = 8501 -- Only Medication order type    
   AND ISNULL(O.RecordDeleted, 'N') = 'N'  
  INNER JOIN ClientOrderMedicationReferences CMR ON CMR.ClientOrderId = PCO.ClientOrderId  
  INNER JOIN ClientMedications CM ON CMR.ClientMedicationId = CM.ClientMedicationId  
  WHERE CO.DocumentVersionId = @DocumentVersionId  
    AND (
   ISNULL(PCO.OrderDiscontinued, 'N') = 'Y'  OR PCO.OrderStatus = 6510
   ) 
    
    
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [ClientMedicationid]  
   ,[PrescriberId]
   ,[DiscontinuedReason]  
  FROM @tDiscontinuedMedications TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tDiscontinuedClientMedicationId  
   ,@tPrescriberId
   ,@tDiscontinuedReason  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   EXEC ssp_SCDiscontinueMedication @tDiscontinuedClientMedicationId  
    ,'Y'  
    ,@UserName  
    ,''  
    ,@tDiscontinuedReason  
    ,NULL  
    ,''  
    ,'N'  
    ,@tPrescriberId 
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tDiscontinuedClientMedicationId  
    ,@tPrescriberId
	,@tDiscontinuedReason  
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor 
  
  -- To update the Rx Medication tables when existing Orders is modified in SC
  -- Update ClientMedications Table
 -- UPDATE CM
 -- SET CM.ModifiedDate = @currDate
	-- ,CM.ModifiedBy = @UserCode
	-- ,CM.MedicationNameId = O.MedicationNameId
	-- ,CM.MedicationStartDate = CAST(CO.OrderStartDateTime AS DATETIME)
	-- ,CM.MedicationEndDate = CAST(CO.OrderEndDateTime AS DATETIME)
	-- ,CM.PrescriberId = CO.OrderingPhysician
	-- ,CM.PrescriberName = S.LastName + ', ' + S.FirstName
	-- ,CM.Comments = CO.CommentsText
	-- ,CM.SpecialInstructions = CO.CommentsText
 -- FROM ClientMedications CM
 -- JOIN ClientOrderMedicationReferences COMR ON COMR.ClientMedicationId = CM.ClientMedicationId
 -- JOIN ClientOrders CO  ON CO.PreviousClientOrderId = COMR.ClientOrderId
 -- JOIN Orders O ON CO.OrderId = O.OrderId  
 --    AND O.OrderType = 8501 -- Only Medication order type 
 --    AND ISNULL(O.RecordDeleted, 'N') = 'N'  
 -- LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId  
 --    AND ISNULL(S.RecordDeleted, 'N') = 'N'  
 --   WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 AND CO.PreviousClientOrderId IS NOT NULL
	--AND CM.Ordered = 'N' AND ISNULL(CO.RecordDeleted, 'N') = 'N'

 -- -- Update ClientMedicationInstructions Table

 -- UPDATE CMI
	--SET CMI.ModifiedDate = @currDate
	--   ,CMI.ModifiedBy = @UserCode
	--   ,CMI.StrengthId = OS.MedicationId
	--   ,CMI.Quantity = CAST(CO.MedicationDosage AS INT)
	--   ,CMI.Schedule = OTFQ.RxFrequencyId
	--   ,CMI.PotencyUnitCode = CO.PotencyUnit
 -- FROM ClientMedicationInstructions CMI
 --   JOIN ClientOrderMedicationReferences COMR ON COMR.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
	--JOIN ClientOrders CO ON CO.PreviousClientOrderId = COMR.ClientOrderId
	--JOIN ClientMedications CM ON CM.ClientMedicationId = COMR.ClientMedicationId AND CM.Ordered = 'N' 
 --   LEFT JOIN OrderStrengths OS ON OS.OrderStrengthId = ISNULL(CO.MedicationOrderStrengthId, 0) 
 --   LEFT JOIN OrderTemplateFrequencies OTFQ ON OTFQ.OrderTemplateFrequencyId = ISNULL(CO.OrderTemplateFrequencyId, 0)  
	--WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 AND CO.PreviousClientOrderId IS NOT NULL
	--AND ISNULL(CO.RecordDeleted, 'N') = 'N'

 -- -- Update ClientMedicationScripts Table
 -- UPDATE CMS
	--SET CMS.ModifiedDate = @currDate
	--   ,CMS.ModifiedBy = @UserCode
	--   ,CMS.OrderDate = CAST(CO.OrderStartDateTime AS DATE)
	--   ,CMS.OrderingPrescriberId = CO.OrderingPhysician
	--   ,CMS.OrderingPrescriberName = S.LastName + ' ,' + S.FirstName
	--   ,CMS.VerbalOrderReadBack = ISNULL(CO.IsReadBackAndVerified, 'N')
	--   ,CMS.VerbalOrderApproved = 'Y'
	--FROM ClientMedicationScripts CMS
	--JOIN ClientOrderMedicationReferences COMR ON COMR.ClientMedicationScriptId = CMS.ClientMedicationScriptId
	--JOIN ClientOrders CO ON CO.PreviousClientOrderId = COMR.ClientOrderId
	--JOIN ClientMedications CM ON CM.ClientMedicationId = COMR.ClientMedicationId AND CM.Ordered = 'N'
	--LEFT JOIN Staff S ON CO.OrderingPhysician = S.StaffId
	--WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 AND CO.PreviousClientOrderId IS NOT NULL
	--AND ISNULL(CO.RecordDeleted, 'N') = 'N'

 -- -- Update ClientMedicationScriptDrugs Table
 -- UPDATE CMSD
	--SET CMSD.ModifiedDate = @currDate
	--   ,CMSD.ModifiedBy = @UserCode
	--   ,CMSD.StartDate = CAST(CO.OrderStartDateTime AS DATE)
	--   ,CMSD.Days = CO.MedicationDaySupply
	--   ,CMSD.Refills = ISNULL(CO.MedicationRefill,0)
	--   ,CMSD.EndDate = CAST(CO.OrderEndDateTime AS DATE)
	--   ,CMSD.Pharmacy = CAST(ROUND(CO.MedicationDaySupply * MedicationDosage * GC.ExternalCode1, 2) AS DECIMAL(10,2))
	--FROM ClientMedicationScriptDrugs CMSD
	--JOIN ClientOrderMedicationReferences COMR ON COMR.ClientMedicationScriptDrugId = CMSD.ClientMedicationScriptDrugId
	--JOIN ClientOrders CO ON CO.PreviousClientOrderId = COMR.ClientOrderId
	--JOIN ClientMedications CM ON CM.ClientMedicationId = COMR.ClientMedicationId AND CM.Ordered = 'N'
	--JOIN OrderTemplateFrequencies OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId
	--JOIN GlobalCodes GC ON GC.GlobalCodeId = OTF.RxFrequencyId
	--WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 AND CO.PreviousClientOrderId IS NOT NULL
	--AND ISNULL(CO.RecordDeleted, 'N') = 'N'

 -- -- Update ClientMedicationScriptDrugStrengths Table
 -- UPDATE CMSDS
	--SET CMSDS.ModifiedDate = @currDate
	--   ,CMSDS.ModifiedBy = @UserCode
	--   ,CMSDS.StrengthId = OS.MedicationId
	--   ,CMSDS.Refills = ISNULL(CO.MedicationRefill, 0)
	--FROM ClientMedicationScriptDrugStrengths CMSDS
	--JOIN ClientOrderMedicationReferences COMR ON COMR.ClientMedicationScriptDrugStrengthId = CMSDS.ClientMedicationScriptDrugStrengthId
	--JOIN ClientOrders CO ON CO.PreviousClientOrderId = COMR.ClientOrderId
	--JOIN ClientMedications CM ON CM.ClientMedicationId = COMR.ClientMedicationId AND CM.Ordered = 'N'
	--JOIN OrderStrengths OS ON OS.OrderStrengthId = ISNULL(CO.MedicationOrderStrengthId, 0)  
 --    AND OS.MedicationId IS NOT NULL
	--WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 AND CO.PreviousClientOrderId IS NOT NULL
	--AND ISNULL(CO.RecordDeleted, 'N') = 'N'


 -- Insert new rows in ClientOrders and ClientMedication refernce
 --INSERT INTO [ClientOrderMedicationReferences] (  
 --   DocumentVersionId  
 --   ,IsInteraction  
 --   ,ClientMedicationInteractionId  
 --   ,ClientOrderId  
 --   ,ClientMedicationId  
 --   ,ClientMedicationInstructionId  
 --   ,ClientMedicationScriptId  
 --   ,ClientMedicationScriptDrugId  
 --   ,ClientMedicationScriptDrugStrengthId  
 --   ,ClientMedicationScriptActivityId  
 --   ,CreatedBy  
 --   ,CreatedDate 
 --   ,IsActive 
 --   )  
 --  SELECT CO.DocumentVersionId  
 --   ,COMR.IsInteraction  
 --   ,COMR.ClientMedicationInteractionId  
 --   ,CO.ClientOrderId  
 --   ,COMR.ClientMedicationId  
 --   ,COMR.ClientMedicationInstructionId  
 --   ,COMR.ClientMedicationScriptId  
 --   ,COMR.ClientMedicationScriptDrugId  
 --   ,COMR.ClientMedicationScriptDrugStrengthId  
 --   ,COMR.ClientMedicationScriptActivityId  
 --   ,@UserCode  
 --   ,@currDate 
 --   ,'Y'  
 --  FROM ClientOrderMedicationReferences COMR
 --  JOIN ClientOrders CO ON CO.PreviousClientOrderId = COMR.ClientOrderId
	--JOIN ClientMedications CM ON CM.ClientMedicationId = COMR.ClientMedicationId
	--WHERE CO.DocumentVersionId = @DocumentVersionId  AND CO.OrderStatus = 6509 AND CO.PreviousClientOrderId IS NOT NULL
	--AND CM.Ordered = 'N'  

  COMMIT TRANSACTION  
  
  IF @@error <> 0  
   GOTO rollback_tran  
  
  RETURN  
  
  rollback_tran:  
  
  ROLLBACK TRANSACTION  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInsertClientOrderMedicationOthers') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                            
    16  
    ,-- Severity.                            
    1 -- State.                            
    );  
 END CATCH  
END

GO


