IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientOrders]
GO      
    
CREATE PROCEDURE [dbo].[ssp_GetClientOrders]     
 (    
 @DocumentVersionId INT    
    
)    
AS    
/******************************************************************************************     
  Created By   : Pabitra [ssp_GetClientOrders] 1115275           
  Created Date : 13 June 2017             
  Description  : To get the orders          
  Called From  :ClientOrderUserControl.ashx       
    Date			Author          Description           
    08/21/2017		Pabitra         Texas Customizations#104
    11/07/2017		Pabitra			Engineering Improvement Initiatives- NBL(I)#585    
    11/30/2017	    Chethan N		What : Retrieving data based on the DocumentVersionId.
									Why : Engineering Improvement Initiatives- NBL(I) task #585 
	02/26/2018		Chethan N		What : Added ClinicalLocation column for Lab Orders
									Why : Engineering Improvement Initiatives- NBL(I)  task #585 
	05/03/2018		Chethan N		What : Not initializing Discontinued Order to EM Note.
									Why : Engineering Improvement Initiatives- NBL(I)  task #585.2
	03/07/2018		Chethan N		What : Added new column LocationId to Orders and ClientOrders table.
									Why : Engineering Improvement Initiatives- NBL(I)  task #667
	16/10/2018		Shankha			What: Added INNER JOIN to ClientOrdersDiagnosisIIICodes		
	14/11/2018      Neha            What :Added Frequency and StartDate to the Client Orders Grid
									Why : Engineering Improvement Initiatives- NBL(I)  task #713 
******************************************************************************************/     
BEGIN    
 BEGIN TRY    
     
        
  DECLARE @ClientId int      
  SELECT TOP 1     
  @ClientId=d.ClientId    
  From Documents d Join DocumentVersions dv ON Dv.DocumentId=d.DocumentId    
  Where dv.DocumentVersionId  =@DocumentVersionId    
        
   CREATE TABLE #Diagnosis (    
 ClientOrderId INT    
 ,DiagnosisName VARCHAR(max)    
 ) 
 
 INSERT INTO #Diagnosis     
 SELECT     
   D.ClientOrderId,(ICDCode + ' - ' + D.[Description]) AS DiagnosisName         
  FROM ClientOrders AS CO    
  INNER JOIN ClientOrdersDiagnosisIIICodes D ON D.ClientOrderId=CO.ClientOrderId  AND ISNULL(D.RecordDeleted, 'N') = 'N'      
  WHERE CO.DocumentVersionId = @DocumentVersionId AND ISNULL(CO.RecordDeleted,'N') = 'N'     
        -- Select ClientOrders      
   
  
    
 
   SELECT     
		 CO.ClientOrderId
		,CO.CreatedBy
		,CO.CreatedDate
		,CO.ModifiedBy
		,CO.ModifiedDate
		,CO.RecordDeleted
		,CO.DeletedDate
		,CO.DeletedBy
		,CO.ClientId
		,CO.OrderDateTime
		,CO.OrderType
		,CO.OrderedBy
		,CO.[Status]
		,CO.AssignedTo
		,CO.OrderFlag
		,CO.HealthDataCategoryId
		,CO.LaboratoryId
		,CO.RadiologyType
		,CO.OrderDescription
		,CO.Indication
		,CO.Urgency
		,CO.Frequency
		,CO.Fasting
		,CO.FastingHours
		,CO.TotalVolumeRequired
		,CO.DateAndTimeOfLastDose
		,CO.HoursAfterLastDose
		,CO.ICDCode1
		,CO.ICDCode2
		,CO.ICDCode3
		,CO.Comment
		,CO.HealthDataId
		,CO.DocumentId
		,CO.LabCategory
		,CO.CommonLab
		,CO.Height
		,CO.[Weight]
		,CO.LabBodySite
		,CO.LabInfoNa
		,CO.LabInfoK
		,CO.LabInfoCl
		,CO.RadiologyCategory
		,CO.RadiologyLocation
		,CO.RadiologyAdditionalInstruction
		,CO.RadiologyComment
		,CO.RadiologyBodyLocation
		,CO.RadiologyNeurologist
		,CO.RadiologyRadiologist
		,CO.RadiologyWithContrast
		,CO.RadiologyWithoutContrast
		,CO.LabLocation
		,CO.LabType
		,CO.OrderId
		,CO.PreviousClientOrderId
		,CO.MedicationOrderStrengthId
		,CO.MedicationOrderRouteId
		,CO.OrderPriorityId
		,CO.OrderScheduleId
		,CO.OrderTemplateFrequencyId
		,CO.MedicationUseOtherUsage
		,CO.MedicationOtherDosage
		,CO.RationaleText
		,CO.CommentsText
		,CO.Active
		,CO.OrderPended
		,CO.OrderDiscontinued
		,CO.DiscontinuedDateTime
		,CO.OrderStartOther
		,CO.OrderStartDateTime
		,CO.OrderMode
		,CO.OrderStatus
		,CO.DocumentVersionId
		,CO.ReleasedOn
		,CO.ReleasedBy
		,CO.OrderPendAcknowledge
		,CO.OrderPendRequiredRoleAcknowledge
		,CO.OrderingPhysician
		,CO.OrderEndDateTime
		,CO.MedicationUnits
		,CO.MedicationDosage
		,CO.Legal
		,CO.[Level]
		,CO.MedicationDaySupply
		,CO.MedicationRefill
		,CO.ReviewedFlag
		,CO.ReviewedBy
		,CO.ReviewedDateTime
		,CO.ReviewedComments
		,CO.FlowSheetDateTime
		,CO.DispenseBrand
		,CO.IsReadBackAndVerified
		,CO.MayUseOwnSupply
		,CO.MaySelfAdminister
		,CO.ConsentIsRequired
		,CO.IsPRN
		,CO.MaxDispense
		,CO.RationaleOtherText
		,CO.ReviewInterpretationType
		,CO.DaysOfWeek
		,CO.DrawFromServiceCenter
		,CO.DiscontinuedReason
		,CO.PotencyUnit
		,CO.ParentClientOrderId
		,CO.ClinicalLocation
		,CO.LocationId    
  FROM ClientOrders AS CO        
  WHERE CO.DocumentVersionId = @DocumentVersionId  AND ISNULL(CO.RecordDeleted, 'N') = 'N'  
  
  SELECT 
		 CODIC.DiagnosisIIICodeId
		,CODIC.CreatedBy
		,CODIC.CreatedDate
		,CODIC.ModifiedBy
		,CODIC.ModifiedDate
		,CODIC.RecordDeleted
		,CODIC.DeletedBy
		,CODIC.DeletedDate
		,CODIC.ClientOrderId
		,CODIC.ICDCode
		,CODIC.[Description]
		,CODIC.ICD10CodeId
  FROM ClientOrdersDiagnosisIIICodes CODIC 
  INNER JOIN ClientOrders CO ON CO.ClientOrderId=CODIC.ClientOrderId  
  WHERE CO.DocumentVersionId = @DocumentVersionId  AND ISNULL(CO.RecordDeleted, 'N') = 'N' 
  AND  ISNULL(CODIC.RecordDeleted, 'N') = 'N'  
   
   
    SELECT     
    CO.ClientOrderId  AS GridClientOrderId          
   ,CO.CreatedBy           
   ,CO.CreatedDate           
   ,CO.ModifiedBy           
   ,CO.ModifiedDate          
   ,CO.RecordDeleted        
   ,CO.DeletedBy           
   ,CO.DeletedDate           
   ,O.OrderName  
   ,O.OrderId             
   ,L.LaboratoryName AS LabsName  
   ,L.LaboratoryId  AS LabId    
   ,REPLACE(REPLACE(STUFF(      
     (SELECT Distinct ', ' + QE.DiagnosisName    
     From #Diagnosis QE     
     Where  CO.ClientOrderId = QE.ClientOrderId                  
     FOR XML PATH(''))      
     ,1,1,'')      
     ,'&lt;','<'),'&gt;','>') AS DiagnosisName
     ,LO.LocationCode AS ClinicalLocationName 
     ,OTF.DisplayName AS FrequencyName
	 ,CONVERT(VARCHAR(10), CO.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7)  AS StartDate 
  FROM ClientOrders AS CO          
  JOIN Orders O ON O.OrderId=CO.OrderId  AND ISNULL(O.RecordDeleted, 'N') = 'N'
  LEFT JOIN Laboratories AS L ON L.LaboratoryId = CO.LaboratoryId  AND ISNULL(L.RecordDeleted, 'N') = 'N' -- AND O.EMNoteOrder='Y'
  LEFT JOIN Locations LO ON LO.LocationId = CO.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'  
  LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId     
  WHERE (CO.DocumentVersionId = @DocumentVersionId)
    AND ISNULL(CO.RecordDeleted, 'N') = 'N'
    AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
							AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
							AND R.IntegerCodeId = O.OrderId ))
   
	UNION
	 
    SELECT     
    0  AS GridClientOrderId          
   ,CO.CreatedBy           
   ,CO.CreatedDate           
   ,CO.ModifiedBy           
   ,CO.ModifiedDate          
   ,CO.RecordDeleted        
   ,CO.DeletedBy           
   ,CO.DeletedDate           
   ,O.OrderName  
   ,O.OrderId             
   ,L.LaboratoryName AS LabsName  
   ,L.LaboratoryId  AS LabId    
   ,REPLACE(REPLACE(STUFF(      
     (SELECT Distinct ', ' + QE.DiagnosisName    
     From #Diagnosis QE     
     Where  CO.ClientOrderId = QE.ClientOrderId                  
     FOR XML PATH(''))      
     ,1,1,'')      
     ,'&lt;','<'),'&gt;','>') AS DiagnosisName
     ,LO.LocationCode AS ClinicalLocationName 
     ,OTF.DisplayName AS FrequencyName
	 ,CONVERT(VARCHAR(10), CO.OrderStartDateTime, 101) + ' ' + RIGHT(CONVERT(VARCHAR, CO.OrderStartDateTime, 100), 7)  AS StartDate 
  FROM ClientOrders AS CO          
  JOIN Orders O ON O.OrderId=CO.OrderId  AND ISNULL(O.RecordDeleted, 'N') = 'N'
  LEFT JOIN Laboratories AS L ON L.LaboratoryId = CO.LaboratoryId  AND ISNULL(L.RecordDeleted, 'N') = 'N' -- AND O.EMNoteOrder='Y'
  LEFT JOIN Locations LO ON LO.LocationId = CO.LocationId AND ISNULL(L.RecordDeleted, 'N') = 'N'  
  LEFT JOIN OrderTemplateFrequencies AS OTF ON OTF.OrderTemplateFrequencyId = CO.OrderTemplateFrequencyId   
  WHERE (CO.ClientId = @ClientId AND CO.OrderType <> 'Labs')
    AND ISNULL(CO.RecordDeleted, 'N') = 'N' AND (ISNULL(OrderDiscontinued, 'N') = 'N' AND OrderStatus <> 6510)
    AND CO.DocumentVersionId <> @DocumentVersionId
	AND (NOT EXISTS( SELECT 1 FROM Recodes R JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder' 
							AND RC.RecodeCategoryId = R.RecodeCategoryId WHERE ISNULL(R.RecordDeleted, 'N') = 'N' 
							AND R.IntegerCodeId = O.OrderId ))
  
  
  SELECT COQA.ClientAnswerId
		,COQA.CreatedBy
		,COQA.CreatedDate
		,COQA.ModifiedBy
		,COQA.ModifiedDate
		,COQA.RecordDeleted
		,COQA.DeletedBy
		,COQA.DeletedDate
		,COQA.QuestionId
		,COQA.ClientOrderId
		,COQA.AnswerType
		,COQA.AnswerText
		,COQA.AnswerValue
		,COQA.AnswerDateTime
		,COQA.HealthDataAttributeId 
		,Co.OrderId
		FROM 
         ClientOrderQnAnswers COQA  INNER JOIN ClientOrders CO 
         ON Co.ClientOrderId=COQA.ClientOrderId AND ISNULL(COQA.RecordDeleted,'N')='N' AND ISNULL(CO.RecordDeleted,'N')='N'
         WHERE CO.DocumentVersionId = @DocumentVersionId 
  
  

  DROP  table #Diagnosis    
      
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                      
    16    
    ,-- Severity.                                                                                                      
    1 -- State.                                                                                                      
    );    
 END CATCH    
END    