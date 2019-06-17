/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomTablesCrisisIntervention]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomTablesCrisisIntervention]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomTablesCrisisIntervention]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomTablesCrisisIntervention]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomTablesCrisisIntervention]           
(              
 @DocumentId as int,              
 @DocumentVersionId as int                                                                                                                                 
)              
As    
/******************************************************************************      
**  File: MSDE.cs      
**  Name: csp_SCWebGetServiceNoteCustomTablesCrisisIntervention      
**  Desc: This fetches data for Service Note Custom Tables     
**      
**  This template can be customized:      
**                    
**  Return values:      
**       
**  Called by:   DownloadReqServiceData function in MSDE Class in DataServices      
**                    
**  Parameters:      
**  Input       Output      
**     ----------      -----------      
**  DocumentID,DocumentVersionId    Result Set containing values from Service Note Custom Tables    
**      
**  Auth: Mohit Madaan      
**  Date: 16-Feb-10      
*******************************************************************************      
**  Change History      
*******************************************************************************      
**  Date:    Author:    Description:      
**  --------   --------   -------------------------------------------      
    
*******************************************************************************/      
BEGIN TRY      
     
SELECT [DocumentVersionId]    
      ,[DateOfCrisisIntervention]    
      ,[ScreeningComletedBy]    
      ,[County]    
      ,[OtherCounty]    
      ,[Ethnicity]    
      ,[MaritalStatus]    
      ,[Sex]    
      ,[ClientName]    
      ,[CMHCaseNumber]    
      ,[SSN]    
      ,[DateOfBirth]    
      ,[ClientAddress]    
      ,[ClientCity]    
      ,[ClientState]    
      ,[ClientZip]    
      ,[ClientCounty]    
      ,[ClientHomePhone]    
      ,[EmergencyContact]    
      ,[RelationWithClient]    
      ,[EmergencyPhone]    
      ,[GuardianName]    
      ,[GuardianPhone]    
      ,[JustificationForReferral]    
      ,[Aggressive]    
      ,[AWOLRisk]    
      ,[AWOLRiskDetail]    
      ,[Physical]    
      ,[PhysicalDetail]    
      ,[Ideation]    
      ,[IdeationDetail]    
      ,[SexualActingOut]    
      ,[SexualActingOutDetail]    
      ,[Verbal]    
      ,[VerbalDetail]    
      ,[DestructionOfProperty]    
      ,[DestructionOfPropertyDetail]    
      ,[History]    
      ,[ChargesPending]    
      ,[ChargesPendingDetail]    
      ,[JailHold]    
      ,[CurrentSuicidalIdeation]    
      ,[ActiveSuicidal]    
      ,[PassiveSuicidal]    
      ,[SuicidalIdeationWithin48]    
      ,[SuicidalIdeationWithin14]    
      ,[SuicidalEgoSyntonic]    
      ,[SuicidalEgoDystonic]    
      ,[EgoExplanation]    
      ,[HasPlan]    
      ,[HasPlanDetail]    
      ,[AccessToMeans]    
      ,[AccessToMeansDetail]    
      ,[HistorySuicidalAttempts]    
      ,[HistoryFamily]    
      ,[Diagnosis]    
      ,[PreviousRescue]    
      ,[FamilySupport]    
      ,[FamilyUnwillingToHelp]    
      ,[Dependence]    
      ,[ConstrictedThinking]    
      ,[EgosyntonicAttitude]    
      ,[Helplessness]    
      ,[Hopelessness]    
      ,[MakingPreparations]    
      ,[NoAmbivalence]    
      ,[SelfHarmfulBehaviour]    
      ,[SelfHarmfulBehaviourDetail]    
      ,[OutcomeDetail]    
      ,[NumberOfHospitalizations]    
      ,[CurrentTherapist]    
      ,[ConsumerRequested]    
      ,[OtherRequested]    
      ,[Recommended]    
      ,[OtherRecommended]    
      ,[RequestNotAuthorized]    
      ,[HospitalizationStatus]    
      ,[FacilityName]    
      ,[OtherFacilityName]    
      ,[Summary]    
      ,[FacilityProviderId]    
      ,[FacilitySiteId]    
      ,[NotifyStaffId1]    
      ,[NotifyStaffId2]    
      ,[NotifyStaffId3]    
      ,[NotifyStaffId4]    
      ,[NotificationMessage]    
      ,[NotificationSent]    
      ,[Modality]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
  FROM [CustomCrisisInterventions]     
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId       
    
SELECT [CustomRequestedServicesId]    
      ,[DocumentVersionId]  
      ,[Requested]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
  FROM [CustomRequestedServices]    
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId       
    
SELECT [CustomRecommendedServicesId]    
      ,[DocumentVersionId]  
      ,[Recommended]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
  FROM [CustomRecommendedServices]    
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId       
    
Exec csp_SCWebGetServiceNoteSubstanceUseTables @DocumentId,@DocumentVersionId    
     
END TRY      
    
BEGIN CATCH      
 declare @Error varchar(8000)      
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomTablesCrisisIntervention'')       
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())        
    + ''*****'' + Convert(varchar,ERROR_STATE())      
        
 RAISERROR       
 (      
  @Error, -- Message text.      
  16,  -- Severity.      
  1  -- State.      
 );      
      
END CATCH
' 
END
GO
