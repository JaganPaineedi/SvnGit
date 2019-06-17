

/****** Object:  StoredProcedure [dbo].[scsp_SCWebDeleteDocuments]    Script Date: 02/04/2015 16:30:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCWebDeleteDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCWebDeleteDocuments]
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCWebDeleteDocuments]    Script Date: 02/04/2015 16:30:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
          
CREATE PROCEDURE [dbo].[scsp_SCWebDeleteDocuments]                   
@DocumentId INT,                  
@DeletedBy VARCHAR(100)                  
AS                  
/****************************************************************************************/                                                                                          
/* Stored Procedure: dbo.ssp_SCWebDeleteDocuments          */                                                                                          
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC        */                                                                                          
/* Creation Date:   24 March 2010              */                                                                                          
/*                      */                                                                                          
/* Purpose:This procedure is used to Delete the custom documents/Events/ServiceNote  */                                                                                        
/*                      */                                                                                        
/* Input Parameters: @DocumentId,@ServiceId,@EventId  @DeletedBy      */                                                                                        
/*                      */                                                                                          
/* Output Parameters:                 */                                     
/*                      */                  
/* Return:  0=success, otherwise an error number          */                  
/*                      */                  
/* Called By:                   */                  
/*                      */                  
/* Calls:                    */                  
/*                      */                  
/* Data Modifications:                 */                  
/*                      */                  
/* Updates:                    */                  
/*  Date                Author               Purpose                                    */                                                                                          
/*  24 March 2010       Vikas Monga     Delete the custom documents/Events/ServiceNote */                    
/*  22 Feb 2012         Maninder        set @DocumentVersionId=InProgressDocumentVersionId */                    
  
/****************************************************************************************/                  
              
              
BEGIN                  
               
DECLARE @DocumentVersionId AS INT                  
DECLARE @DocumentCodeId AS INT                  
BEGIN TRY                  
--Get DocumentVersionId and DocumentCodeId from Documents table based on DocumentId                  
--SELECT     @DocumentVersionId=CurrentDocumentVersionId, @DocumentCodeId=DocumentCodeId                  
SELECT     @DocumentVersionId=InProgressDocumentVersionId, @DocumentCodeId=DocumentCodeId                  
FROM       Documents                  
WHERE     (DocumentId = @DocumentId)                  
                
                 
--Update Statement Begin                  
  
  
  
                
--Update ActEntrance                  
IF  @DocumentCodeId=272                   
BEGIN                   
UPDATE    CustomActEntranceStayCriteria                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
  
--Addded By Jagdeep     
  
ELSE IF  @DocumentCodeId=1492                  
BEGIN    
UPDATE    CustomRegistrations                  
SET RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)     
End   
ELSE IF  @DocumentCodeId=1493                  
BEGIN    
UPDATE    CustomDischarges                  
SET RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)     
END    
--Addded By Jagdeep For MHAssessment--Start  
--ELSE IF  @DocumentCodeId=10001                     
--BEGIN    
--exec csp_DeleteDocumentMHAssessment @DocumentVersionId,@DeletedBy  
--END  
  
ELSE IF  @DocumentCodeId=10032    
BEGIN  
UPDATE CustomDocumentMHAContents SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId   
END  
ELSE IF  @DocumentCodeId=10002    
BEGIN  
UPDATE CustomDocumentEducations SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10003    
BEGIN  
UPDATE CustomDocumentEmployments SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10004    
BEGIN   
UPDATE CustomDocumentEmploymentBarriers SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId   
END  
ELSE IF  @DocumentCodeId=10005    
BEGIN   
UPDATE CustomDocumentEmploymentHistories SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10006    
BEGIN   
UPDATE CustomDocumentEmploymentPrefrences SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10007    
BEGIN  
UPDATE CustomDocumentEducationBarriers SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10008    
BEGIN  
UPDATE CustomDocumentFinancials SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10009    
BEGIN  
UPDATE CustomDocumentTxHistories SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10010    
BEGIN  
UPDATE CustomDocumentMedications SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10011    
BEGIN  
UPDATE CustomDocumentDailyLivings SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10012    
BEGIN  
UPDATE CustomDocumentSocials SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10013    
BEGIN  
UPDATE CustomDocumentPhysicalHealths SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10014    
BEGIN   
UPDATE CustomDocumentSubstanceUses SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10015    
BEGIN  
UPDATE CustomDocumentCAGEs SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10016    
BEGIN  
UPDATE CustomDocumentAlcoholDrugUseScales SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10017    
BEGIN   
UPDATE CustomDocumentSUContexts SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
--ELSE IF  @DocumentCodeId=10018    
--BEGIN  
--UPDATE CustomDocumentTraumaticEvents SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
--WHERE DocumentVersionId = @DocumentVersionId    
--END  
ELSE IF  @DocumentCodeId=10019    
BEGIN  
UPDATE CustomDocumentLegals SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10020    
BEGIN   
UPDATE CustomDocumentMentalStatuses SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10021    
BEGIN   
UPDATE CustomDocumentRiskAssessments SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10034    
BEGIN   
UPDATE CustomDocumentSupports SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10022    
BEGIN   
UPDATE CustomDocumentCrisisRecoverys SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10023    
BEGIN   
UPDATE CustomDocumentParentings SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10024    
BEGIN  
UPDATE CustomDocumentMHASummaries SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10033    
BEGIN   
UPDATE CustomDocumentPrescribedServices SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
ELSE IF  @DocumentCodeId=10025    
BEGIN  
UPDATE CustomDocumentAnnualExamples SET RecordDeleted = 'Y', DeletedBy = @DeletedBy, DeletedDate = GETDATE()                    
WHERE DocumentVersionId = @DocumentVersionId    
END  
  
--Addded By Jagdeep For MHAssessment--End  
     
--Added By Amit Kumar Srivastava  
ELSE IF  @DocumentCodeId=10028                  
BEGIN   
UPDATE    CustomDocumentMCASs                  
SET RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)   
END                
--Update AdvanceAdequateNotice                  
ELSE IF  @DocumentCodeId=100                   
BEGIN                   
UPDATE    CustomAdvanceAdequateNotices                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
                
--Update AuthorizationDocument                  
ELSE IF  @DocumentCodeId=253                   
BEGIN                   
UPDATE    CustomAuthorizationDocuments                 
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                 WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
                
--Update Basic_32                  
ELSE IF  @DocumentCodeId=254                  
BEGIN                   
UPDATE    CustomBasis32                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
                
--Update Cafas                
ELSE IF  @DocumentCodeId=113       
BEGIN                   
UPDATE    CustomCAFAS                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
                
--Update Custom AIMS                   
ELSE IF  @DocumentCodeId=303                  
BEGIN                   
UPDATE    CustomAIMS                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
                
--Update CustomBehaviorTxPlan                  
ELSE IF  @DocumentCodeId=321                   
BEGIN                   
UPDATE    CustomBehaviorTxPlan                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
                
--Update  DCH3803                    
ELSE IF  @DocumentCodeId=299                  
BEGIN                   
UPDATE    CustomDCH3803                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
                
--Update  DDAssessment                    
ELSE IF  @DocumentCodeId= 110                  
BEGIN                   
UPDATE    CustomDDAssessment                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
                
--Update  MedsOnlyTreatmentPlan                    
ELSE IF  @DocumentCodeId=270                   
BEGIN                   
UPDATE    CustomMedsOnlyTxPlan                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
END                  
              
--Update  MSTWeekly                    
ELSE IF  @DocumentCodeId=308                   
BEGIN                   
UPDATE    CustomMSTWeeklyNote                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
                 
END                  
                
--Update  Multisystemic_Assessment                    
ELSE IF  @DocumentCodeId=292                   
BEGIN                   
UPDATE    CustomMSTAssessments                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                  
              
END                  
                
--update Personal_Care_Assessment                  
ELSE IF  @DocumentCodeId=108                   
BEGIN                   
UPDATE    CustomPersonalCareAssessment                  
SET  RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
                
--update PrePlanningCheckList                  
ELSE IF  @DocumentCodeId=123                   
BEGIN       
UPDATE    CustomPrePlanningChecklists                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
                
--update Psychological_Assessment                  
ELSE IF  @DocumentCodeId=294                   
BEGIN                   
UPDATE    CustomPsychAssessment                  SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
              
END                  
                
--update CustomDateTracking                  
ELSE IF  @DocumentCodeId=112                   
BEGIN                   
UPDATE    CustomDateTracking                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
                 
--update Discharge,DiagnosesIAndII,CustomMedications                  
ELSE IF  @DocumentCodeId=103                   
BEGIN                   
UPDATE    CustomDischarges                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)               
UPDATE   DiagnosesIAndII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE    CustomMedications                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                 
END                  
                
--update TransferBroker                  
ELSE IF  @DocumentCodeId=114                   
BEGIN                   
UPDATE    CustomTransferBroker                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
            
--update CustomMiscellaneousNotes                  
ELSE IF  @DocumentCodeId=115                  
BEGIN                   
UPDATE    CustomMiscellaneousNotes                   
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
            
--update CustomConnectionsNotes                  
ELSE IF  @DocumentCodeId=107                  
BEGIN                   
UPDATE    CustomConnectionsNotes                   
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                  
            
--update CustomDBTGroupNotes                  
ELSE IF  @DocumentCodeId=111                  
BEGIN                   
UPDATE    CustomDBTGroupNotes                   
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                
            
--update CustomDBTIndividualNote                  
ELSE IF  @DocumentCodeId=281                 
BEGIN                   
UPDATE    CustomDBTIndividualNote                   
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                
          
--update CustomCrossroadsReportingNote                  
ELSE IF  @DocumentCodeId=307                  
BEGIN                   
UPDATE    CustomCrossroadsReportingNote                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                
            
--update CustomNursingHomes,CustomMedications,MentalStatus                  
ELSE IF  @DocumentCodeId=109                  
BEGIN                   
UPDATE    CustomNursingHomes                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
UPDATE    CustomMedications                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                 
UPDATE    MentalStatus                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)     END                
           
--update CustomMedicationReviews,DiagnosesIAndII                  
ELSE IF  @DocumentCodeId=117                  
BEGIN                   
UPDATE   CustomMedicationReviews                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
UPDATE   DiagnosesIAndII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
END                
            
--update CustomMedicationAdministrations,CustomMedicalStatus,CustomMedications                  
ELSE IF  @DocumentCodeId=118                  
BEGIN                   
UPDATE   CustomMedicationAdministrations                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                   
UPDATE   CustomMedicalStatus                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE    CustomMedications                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                 
END                
            
--update CustomMedicationCheckups,CustomMedications                  
ELSE IF  @DocumentCodeId=120                  
BEGIN                   
UPDATE   CustomMedicationCheckups                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE    CustomMedications                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                 
END               
            
--update CustomPsychiatricEvaluations,DiagnosesIAndII                  
ELSE IF  @DocumentCodeId=121                  
BEGIN                   
UPDATE   CustomPsychiatricEvaluations                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE    DiagnosesIAndII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                 
END               
            
--update CustomMDNotes,DiagnosesIAndII                  
ELSE IF  @DocumentCodeId=306                  
BEGIN                   
UPDATE   CustomMDNotes                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE    DiagnosesIAndII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)                 
END               
          
--update CustomHRMServiceNotes                
ELSE IF  @DocumentCodeId=353                  
BEGIN                   
UPDATE   CustomHRMServiceNotes                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
END               
            
--update CustomMedicationAdministrations,CustomMedicalStatus,CustomMedications                
ELSE IF  @DocumentCodeId=354                  
BEGIN                   
UPDATE   CustomMedicationAdministrations                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE   CustomMedicalStatus                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE   CustomMedications                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
END              
          
--Update DiagnosesIAndII,DiagnosesIII,DiagnosesIIICodes,DiagnosesIV,DiagnosesV            
ELSE IF  @DocumentCodeId=5                  
BEGIN                   
UPDATE   DiagnosesIAndII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
  UPDATE   DiagnosesIII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)       UPDATE   DiagnosesIIICodes                  
SET    RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE (DocumentVersionId = @DocumentVersionId)            
 UPDATE   DiagnosesIV                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)            
 UPDATE   DiagnosesV                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)            
END               
  ELSE IF  @DocumentCodeId=1468    --For Discharge New            
BEGIN           
UPDATE    CustomDischarges                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()            
WHERE     (DocumentVersionId = @DocumentVersionId)               
UPDATE   DiagnosesIAndII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)              
UPDATE    DiagnosesIII                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    DiagnosesIV                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    DiagnosesV                  
SET           RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    DiagnosesIIICodes                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomCAFAS2                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomDischargeClientRequests                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomDischargeClientRequests                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomDailyLivingActivityScores                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomLOFTabDetails                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
end           
    ELSE IF  @DocumentCodeId=352   --For Periodic Review          
    begin          
     UPDATE    TPGeneral                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)          
    UPDATE    TPNeeds                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    TPObjectives                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    TPInterventions                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    TPProcedures                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    PeriodicReviewNeeds                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    periodicReviews                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomHRMAssessmentLevelOfCareOptions                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomDailyLivingActivityScores                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomCAFAS2                  
SET             RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)           
UPDATE    CustomLOFTabDetails                  
SET RecordDeleted = 'Y', DeletedBy = @DeletedBy,                   
   DeletedDate = GETDATE()                  
WHERE     (DocumentVersionId = @DocumentVersionId)    
        
end            
  
  
  
  
       
      
END TRY                  
BEGIN CATCH                  
DECLARE @Error varchar(8000)                   
                
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_SCWebDeleteDocuments')                  
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                
+ '*****' + Convert(varchar,ERROR_STATE())                                                                                              
                
RAISERROR ( @Error, /*Message text*/16 /*Severity*/,1 /* State*/);                   
END CATCH                  
END   
GO


