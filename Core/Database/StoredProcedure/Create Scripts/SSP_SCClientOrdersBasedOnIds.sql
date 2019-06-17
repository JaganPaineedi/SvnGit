
/****** Object:  StoredProcedure [dbo].[SSP_SCClientOrdersBasedOnIds]    Script Date: 08/12/2013 19:45:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCClientOrdersBasedOnIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCClientOrdersBasedOnIds]
GO



/****** Object:  StoredProcedure [dbo].[SSP_SCClientOrdersBasedOnIds]    Script Date: 08/12/2013 19:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE Procedure [dbo].[SSP_SCClientOrdersBasedOnIds]
	@ClientOrderIds varchar(max)
AS
  -- =============================================      
  -- Author: Pradeep    [dbo].[SSP_SCClientOrdersBasedOnIds] 1254
  -- Create date:31/07/2013     
  -- Description: Return the ClientOrders based on Ids
  -- Change History
  -- Modified Date   Modified By	Reason   
    ----------------------------------------------------------------   
  /* 19/Feb/2015	Gautam			The column OrderFrequencyId changed to OrderTemplateFrequencyId in ClientOrders table
									and linked directly to OrderTemplateFrequencies table, Why : Task#221,Philhaven Development */
  /* 27/March/2015  Varun			Returning Sensitive column from Orders table, Why: Task #873 Woods - Customization*/	
/*	07 May 2015		Chethan N		What: Added new column 'MaxDispense'
									Why:  Philhaven Development task # 234.2 */	
/*	25 May 2015		Chethan N		What: Added new column 'RationaleOtherText'
									Why:  Philhaven Development task # 252 */	
/*	06 Jun 2015		Chethan N		What: Added missing columns 
									Why:  Philhaven Development task # 298 */
/*	30 Jul 2015		Chethan N		What: Added new column 'DaysOfWeek' and 'NumberOfDays'
									Why:  Philhaven Development task # 258 */	    
/*	21 Dec 2015		Chethan N		What: Removed hardcoded logic to get NumberOfDays
									Why:  Key Point - Environment Issues Tracking task # 151    */	
/*	19 Jan 2017		Chethan N		What: Retrieving PotencyUnit and ParentClientOrderId 
									Why:  Renaissance - Dev Items task #5    */		
/*  10 Feb 2017		Chethan N		What : Added new column 'ClinicalLocation' to ClientOrders table.
									Why : Key Point - Support Go Live task #365	*/				
/*  28/Mar/2017		Chethan N		What: Retrieving MedicationDaySupply and OrderEndDateTime.
									Why:  Renaissance - Dev Items task #5.1	*/
/*	02/Jul/2018		Chethan N		What : Added new column 'LocationId' to ClientOrders table.
									Why : Engineering Improvement Initiatives- NBL(I) task #667		*/	
/*	02/Jul/2018		Chethan N		What : Initializing ClientOrder.IsPRN = 'N'as ClientOrder.IsPRN is updated based on Priority and Frequency.
									Why : AHN Support GO live Task # 372		*/	
/*  01/Feb/2019     Neha            What: Initializing [ClientOrdersDiagnosisIIICodes] and [ClientOrderQnAnswers] table. */				
  -- =============================================   
BEGIN
	BEGIN TRY
		SELECT           
		   Cl.[ClientOrderId],        
		   Cl.[CreatedBy],          
		   Cl.[CreatedDate],          
		   Cl.[ModifiedBy],          
		   Cl.[ModifiedDate],          
		   Cl.[RecordDeleted],          
		   Cl.[DeletedDate],          
		   Cl.[DeletedBy],          
		   Cl.[ClientId],          
		   Cl.[OrderId],          
		   Cl.[DocumentId],          
		   Cl.[ClientOrderId] AS PreviousClientOrderId,          
		   Cl.[MedicationOrderStrengthId],          
		   Cl.[MedicationOrderRouteId],          
		   Cl.[OrderPriorityId],          
		   '8522' AS [OrderScheduleId],          
		   Cl.[OrderTemplateFrequencyId],          
		   Cl.[MedicationUseOtherUsage],          
		   Cl.[MedicationOtherDosage],          
		   Cl.[RationaleText],          
		   Cl.[CommentsText],          
		   Cl.[Active],          
		   Cl.[OrderPended],          
		   Cl.[OrderDiscontinued],          
		   Cl.[DiscontinuedDateTime],      
		   'Y' AS [OrderStartOther],     
		   Cl.[OrderStartDateTime],          
		   Cl.[OrderedBy],          
		   Cl.[OrderMode],          
		   Cl.[OrderStatus],          
		   Cl.[AssignedTo],          
		   'N' AS OrderFlag,          
		   Cl.[DocumentVersionId],    
		   ISNULL(Cl.OrderPendRequiredRoleAcknowledge, 'N') AS OrderPendRequiredRoleAcknowledge,    
		   ISNULL(Cl.OrderPendAcknowledge, 'N') AS OrderPendAcknowledge,    
		   Cl.[ReleasedBy],    
		   Cl.[ReleasedOn], 
		   Cl.MedicationDosage,  
		   Cl.MedicationUnits,  
		   Cl.OrderingPhysician,   
		   GC.CodeName AS OrderType,       
		   CASE ISNULL(Cl.[MedicationUseOtherUsage],'N')      
		  WHEN 'Y' THEN ( O.OrderName+' '+Cl.[MedicationOtherDosage])      
		  WHEN 'N' THEN ( O.OrderName+' '+ISNULL(md.StrengthDescription,''))      
		   END AS OrderText,      
		   OTF.DisplayName AS FrequencyText,          
		   GCP.CodeName AS PriorityText,          
		   CASE Cl.Active          
			WHEN 'Y' THEN 'Active'          
			WHEN 'N' THEN 'Discontinued'          
		   END AS StatusText,          
		   CONVERT(VARCHAR(10), Cl.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, Cl.OrderStartDateTime, 100), 7) AS StartDateText,         
		   (S.LastName+', '+S.FirstName) AS OrderedByText,          
		   'No' AS Signed,      
		   CONVERT(VARCHAR(10), Cl.OrderStartDateTime, 101) AS ScheduleDate,      
		   LEFT(RIGHT(CONVERT(VARCHAR, Cl.OrderStartDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, Cl.OrderStartDateTime, 100), 7),2) AS ScheduleTime,
		   ISNULL(Cl.Legal, 0) AS Legal,
		   ISNULL(Cl.[Level], 0) AS Level,
		   ISNULL(O.Sensitive, 'N') AS SensitiveOrder, 
		   Cl.MaxDispense,
		   Cl.RationaleOtherText,
		   Cl.MedicationRefill,
		   Cl.DispenseBrand,
		   Cl.MayUseOwnSupply,
		   Cl.ConsentIsRequired,
		   Cl.MaySelfAdminister,
		   'N' AS IsPRN,
			ISNULL(O.Sensitive,'N') AS Sensitive,
			Cl.MaxDispense,
			Cl.RationaleOtherText,
			Cl.DaysOfWeek,
			CASE 
				WHEN CONVERT(FLOAT,GCF.ExternalCode1) < 1 
					THEN CASE 
						WHEN CONVERT(FLOAT,GCF.ExternalCode1)*7 > 1 
							THEN FLOOR(CONVERT(FLOAT,GCF.ExternalCode1)*7) 
						ELSE 1 
						END
				ELSE '0'
				END AS 'NumberofDays',
			Cl.DiscontinuedReason,
			Cl.PotencyUnit,
			Cl.ParentClientOrderId,
			Cl.ClinicalLocation,
			Cl.MedicationDaySupply,
			Cl.OrderEndDateTime,
			Cl.LaboratoryId,
			Cl.LocationId
		  FROM ClientOrders Cl          
		  JOIN Orders O on O.OrderId=Cl.OrderId          
		  JOIN GlobalCodes GC on GC.GlobalCodeId=O.OrderType          
		  --LEFT JOIN OrderFrequencies OFC on OFC.OrderFrequencyId=Cl.OrderFrequencyId        
		  LEFT JOIN OrderTemplateFrequencies OTF on Cl.OrderTemplateFrequencyId=OTF.OrderTemplateFrequencyId 
		  LEFT JOIN GlobalCodes GCF ON GCF.GlobalCodeId = OTF.RxFrequencyId  
			AND ISNULL(GCF.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(OTF.SelectDays,'N')='Y'       
		  --LEFT JOIN GlobalCodes GCF on GCF.GlobalCodeId=Cl.OrderFrequencyId          
		  LEFT JOIN GlobalCodes GCP on GCP.GlobalCodeId=Cl.OrderPriorityId          
		  LEFT JOIN OrderStrengths OS on OS.OrderStrengthId=Cl.MedicationOrderStrengthId        
		  JOIN Staff S on S.StaffId = Cl.OrderedBy   
		  Left outer Join MDMedications md on md.MedicationId = ISNULL(OS.MedicationId,0) AND ISNULL(md.RecordDeleted,'N') = 'N'       
		  WHERE Cl.ClientOrderId IN (SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,','))   
		  
		  --ClientOrdersDiagnosisIIICodes  
		SELECT cod.[DiagnosisIIICodeId]
			,cod.[CreatedBy]
			,cod.[CreatedDate]
			,cod.[ModifiedBy]
			,cod.[ModifiedDate]
			,cod.[RecordDeleted]
			,cod.[DeletedBy]
			,cod.[DeletedDate]
			,cod.[ClientOrderId]
			,cod.[ICDCode]
			,cod.[Description]
			,cod.[ICD10CodeId]
			,DICD.[ICD10Code]
		FROM [dbo].[ClientOrdersDiagnosisIIICodes] cod
		INNER JOIN ClientOrders CL ON CL.ClientOrderId = cod.ClientOrderId
		JOIN DiagnosisICD10Codes DICD ON DICD.ICD10CodeId=cod.ICD10CodeId  
		WHERE ISNULL(cod.RecordDeleted, 'N') <> 'Y'  
		AND Cl.ClientOrderId IN (SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,',')) 
		
		  --ClientOrderQnAnswers     
		SELECT coq.ClientAnswerId
			,coq.CreatedBy
			,coq.CreatedDate
			,coq.ModifiedBy
			,coq.ModifiedDate
			,coq.RecordDeleted
			,coq.DeletedBy
			,coq.DeletedDate
			,coq.QuestionId
			,coq.ClientOrderId
			,coq.AnswerType
			,coq.AnswerText
			,coq.AnswerValue
			,coq.AnswerDateTime
			,coq.HealthDataAttributeId
		FROM ClientOrderQnAnswers coq
		INNER JOIN ClientOrders CL ON CL.ClientOrderId = coq.ClientOrderId
		WHERE ISNULL(coq.RecordDeleted, 'N') <> 'Y' AND 
		Cl.ClientOrderId IN (SELECT Token FROM [dbo].[SplitString] (@ClientOrderIds,',')) 

		
	END TRY
	BEGIN CATCH
		 declare @Error varchar(8000)                    
		 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                     
			+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCClientOrdersBasedOnIds')                     
			+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                      
			+ '*****' + Convert(varchar,ERROR_STATE())                    
		 RAISERROR                     
		 (                    
		  @Error, -- Message text.                    
		  16,  -- Severity.                    
		  1  -- State.                    
		 );    
	END CATCH
END


GO


