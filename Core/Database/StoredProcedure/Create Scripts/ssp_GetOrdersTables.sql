IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrdersTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetOrdersTables]
GO      
    
CREATE PROCEDURE [dbo].[ssp_GetOrdersTables]     
 (    
 @ClientId INT    
    
)    
AS    
/******************************************************************************************     
  Created By   : Pabitra [ssp_GetOrdersTables] 4           
  Created Date : 13 June 2017             
  Description  : To get the orders          
  Called From  :ClientOrderUserControl.ashx       
    Date        Author          Description           
    08/21/2017    Pabitra         Texas Customizations#104                   
******************************************************************************************/     
BEGIN    
 BEGIN TRY    
     
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
  FROM ClientOrders AS CO        
  WHERE CO.ClientId=@ClientID  AND ISNULL(CO.RecordDeleted, 'N') = 'N' 
  
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
  WHERE CO.ClientId=@ClientID  AND ISNULL(CO.RecordDeleted, 'N') = 'N' 
  AND  ISNULL(CODIC.RecordDeleted, 'N') = 'N'
 
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetOrdersTables') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                      
    16    
    ,-- Severity.                                                                                                      
    1 -- State.                                                                                                      
    );    
 END CATCH    
END    