/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomScreenForServices]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomScreenForServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomScreenForServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomScreenForServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomScreenForServices]     
(                    
 @DocumentVersionId  int                                                                                                                                       
)                    
As          
/******************************************************************************            
**  Name: csp_SCWebGetServiceNoteCustomScreenForServices            
**  Desc: This fetches data for Service Note Custom Tables           
**            
**  This template can be customized:            
**                          
**  Return values:            
**             
**  Parameters:            
**  Input       Output            
**     ----------      -----------            
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables          
**            
**  Auth: Mohit Madaan        
**  Date: 6-April-10            
*******************************************************************************            
**  Change History            
*******************************************************************************            
**  Date:    Author:    Description:            
**  --------   --------   -------------------------------------------            
*******************************************************************************/            
BEGIN TRY            
     
SELECT [DocumentVersionId]  
      ,[DateOfScreen]  
      ,[EventStartTime]  
      ,[DispositionTime]  
      ,[EventStopTime]  
      ,[ElapsedTimeOfScreen]  
      ,[ScreeningCompletedBy]  
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
      ,[ReferralSourceType]  
      ,[OtherReferral]  
      ,[ReferralSouceName]  
      ,[Location]  
      ,[Phone]  
      ,[ReferralSourceContacted]  
      ,[ReferralSourceContactedDetail]  
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
      ,[SuicidalIdeationWithin48Hours]  
      ,[SuicidalIdeationWithin14Days]  
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
      ,[UnableToObtain]  
      ,[NumberOfInpatient]  
      ,[DateOfRecentInpatient]  
      ,[Facility]  
      ,[PreviosOutpatientTreatment]  
      ,[LastSeen]  
      ,[CurrentTherapist]  
      ,[NameOfPrimaryCarePhysician]  
      ,[PhysicianPhone]  
      ,[Allergies]  
      ,[CurrentHealthConcerns]  
      ,[ConsumerRequested]  
      ,[OtherRequested]  
      ,[Recommended]  
      ,[OtherRecommended]  
      ,[RequestNotAuthorized]  
      ,[HospitalizationStatus]  
      ,[FacilityName]  
      ,[OtherFacilityName]  
      ,[Summary]  
      ,[NoSubstanceUseSuspected]  
      ,[FamilySUHistory]  
      ,[ClientSUHistory]  
      ,[CurrentSubstanceUse]  
      ,[CurrentSubstanceUseSuspected]  
      ,[RecomendedSubstanceUse]  
      ,[SubstanceUseDetails]  
      ,[FacilityProviderId]  
      ,[FacilitySiteId]  
      ,[NotifyStaffId1]  
      ,[NotifyStaffId2]  
      ,[NotifyStaffId3]  
      ,[NotifyStaffId4]  
      ,[NotificationMessage]  
      ,[NotificationSent]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]
       ,right(CONVERT(varchar, EventStartTime, 100),7)  as ''EStartTime''            
      ,right(CONVERT(varchar, DispositionTime, 100),7)  as  ''EDispositionTime''          
      ,right(CONVERT(varchar, EventStopTime, 100),7)  as ''EStopTime''           
        
 FROM [CustomScreenForServices]  
  WHERE (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)    
    
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
  WHERE (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)    
    
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
  WHERE (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)    
    
    
  SELECT [DocumentVersionId]  
      ,[UnableToAssess]  
      ,[AppearanceDressed]  
      ,[AppearanceAge]  
      ,[AppearanceAverageWeight]  
      ,[AppearanceAverageHeight]  
      ,[AppearanceGroomed]  
      ,[AppearanceHygiene]  
      ,[ApprearanceOther]  
      ,[AppearanceOtherText]  
      ,[BehaviorGait]  
      ,[BehaviorEyeContact]  
      ,[BehaviorTics]  
      ,[BehaviorTremors]  
      ,[BehaviorTwitches]  
      ,[BehaviorAgitated]  
      ,[BehaviorActivity]  
      ,[BehaviorLethargic]  
      ,[BehaviorAggressive]  
      ,[BehaviorNormalActivity]  
      ,[BehaviorOther]  
      ,[BehaviorOtherText]  
      ,[AttitudeCooperative]  
      ,[AttitudeDefensive]  
      ,[AttitudeReserved]  
      ,[AttitudeMistrustful]  
      ,[AttitudeOther]  
      ,[AttitudeOtherText]  
      ,[AffectBlunted]  
      ,[AffectCongruent]  
      ,[AffectUnremarkable]  
      ,[AffectUnableToAssess]  
      ,[AffectFlat]  
      ,[AffectRestricted]  
      ,[AffectExpansive]  
      ,[AffectAngry]  
      ,[AffectSad]  
      ,[AffectIrritable]  
      ,[AffectFearful]  
      ,[AffectMood]  
      ,[AffectOther]  
      ,[AffectOtherText]  
      ,[SpeechCoherent]  
      ,[SpeechSpeed]  
      ,[SpeechVerbal]  
      ,[SpeechClear]  
      ,[SpeechVolume]  
      ,[SpeechPressured]  
      ,[SpeechRepetitive]  
      ,[SpeechSpontaneous]  
      ,[SpeechSlurred]  
      ,[SpeechMonotonous]  
      ,[SpeechTalkative]  
      ,[SpeechEcholalia]  
      ,[SpeechOther]  
      ,[SpeechOtherText]  
      ,[ThoughtLucid]  
      ,[ThoughtParanoid]  
      ,[ThoughtDelusional]  
      ,[ThoughtTangential]  
      ,[ThoughtLoose]  
      ,[ThoughtPsychosis]  
      ,[ThoughtImpoverished]  
      ,[ThoughtConfused]  
      ,[ThoughtObsessive]  
      ,[ThoughtObsessiveText]  
      ,[ThoughtProcessingOther]  
      ,[MoodNeutral]  
      ,[MoodFriendly]  
      ,[MoodLabile]  
      ,[MoodAnxious]  
      ,[MoodGuilty]  
      ,[MoodIrritable]  
      ,[MoodFearful]  
      ,[MoodSad]  
      ,[MoodTearful]  
      ,[MoodAppropriate]  
      ,[MoodIncongruent]  
      ,[MoodOtherMoods]  
      ,[MoodOtherMoodsText]  
      ,[CognitionNormal]  
      ,[CognitionLimited]  
      ,[CognitionPhobias]  
      ,[CognitionObsessions]  
      ,[CognitionPreoccupation]  
      ,[CognitionOther]  
      ,[CognitionOtherText]  
      ,[AttentionAppropriate]  
      ,[AttentionGood]  
      ,[AttentionImpaired]  
      ,[AttentionOther]  
      ,[AttentionOtherText]  
      ,[LevelAlert]  
      ,[LevelSedate]  
      ,[LevelLethargic]  
      ,[LevelObtuned]  
      ,[LevelOther]  
      ,[LevelOtherText]  
      ,[PerceptualNo]  
      ,[PerceptualDelusions]  
      ,[PerceptualAuditory]  
      ,[PerceptualVisual]  
      ,[PerceptualOlfactory]  
      ,[PerceptualTactile]  
      ,[PerceptualDepersonalization]  
      ,[PerceptualIdeas]  
      ,[PerceptualParanoia]  
      ,[PerceptualOther]  
      ,[PerceptualOtherText]  
      ,[MemoryIntact]  
      ,[MemoryShortTerm]  
      ,[MemoryLongTerm]  
      ,[MemoryOther]  
      ,[MemoryOtherText]  
      ,[JudgementAware]  
      ,[JudgementUnderstandsOutcomes]  
      ,[JudgementUnderstandsNeed]  
      ,[JudgementRiskyBehavior]  
      ,[JudgementIntact]  
      ,[JudgementImpaired]  
      ,[JudgementImpairedText]  
      ,[JudgementOther]  
      ,[JudgementOtherText]  
      ,[OtherPx]  
      ,[OtherNotMedication]  
      ,[OtherEating]  
      ,[OtherEatingText]  
      ,[OtherSleep]  
      ,[OtherSleepText]  
      ,[OrientationPerson]  
      ,[OrientationPlace]  
      ,[OrientationTime]  
      ,[OrientationCircumstance]  
      ,[OrientationText]  
      ,[DisturbanceNoneNoted]  
      ,[DisturbanceDelusions]  
      ,[DisturbanceAuditory]  
      ,[DisturbanceVisual]  
      ,[DisturbanceOlfactory]  
      ,[DisturbanceTactile]  
      ,[DisturbanceDepersonalization]  
      ,[DisturbanceDerealization]  
      ,[DisturbanceIdeas]  
      ,[DisturbanceParanoia]  
      ,[DisturbanceOther]  
      ,[DisturbanceOtherText]  
      ,[RiskSuicideNotPresent]  
      ,[RiskSuicideIdeation]  
      ,[RiskSuicideActive]  
      ,[RiskSuicidePassive]  
      ,[RiskSuicideMeans]  
      ,[RiskSuicidePlan]  
      ,[RiskSuicideAttempt]  
      ,[RiskSuicideTxPlan]  
      ,[RiskHomicideNotPresent]  
      ,[RiskHomicideIdeation]  
      ,[RiskHomicideActive]  
      ,[RiskHomicidePassive]  
      ,[RiskHomicideMeans]  
      ,[RiskHomicidePlan]  
      ,[RiskHomicideAttempt]  
      ,[RiskHomicideTxPlan]  
      ,[RiskOther]  
      ,[RiskIntervention]  
      ,[ThoughtGrandiose]  
      ,[ThoughtFlightOfIdeas]  
      ,[ThoughtDisorganized]  
      ,[ThoughtBizarre]  
      ,[BehaviorCompulsive]  
      ,[BehaviorPeculiar]  
      ,[BehaviorManipulative]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
  FROM [MentalStatus]  
  WHERE (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)    
    
  Exec ssp_SCWebAssessmentSUDetails @DocumentVersionId      
  
  Exec csp_SCWebGetServiceNoteDiagnosesTables @DocumentVersionId      
    
  SELECT       
       CustomMedications.[MedicationId]  
      ,CustomMedications.[DocumentVersionId]  
      ,CustomMedications.[DrugId]  
      ,CustomMedications.[DrugName]  
      ,CustomMedications.[Dose]  
      ,CustomMedications.[Frequency]  
      ,CustomMedications.[Route]  
      ,CustomMedications.[OrderDate]  
      ,CustomMedications.[EndDate]  
      ,CustomMedications.[Status]  
      ,CustomMedications.[Comment]  
      ,CustomMedications.[Prescriber]  
      ,CustomMedications.[Strength]  
      ,CustomMedications.[ServiceId]  
      ,CustomMedications.[CreatedBy]  
      ,CustomMedications.[CreatedDate]  
      ,CustomMedications.[ModifiedBy]  
      ,CustomMedications.[ModifiedDate]  
      ,CustomMedications.[RecordDeleted]  
      ,CustomMedications.[DeletedDate]  
      ,CustomMedications.[DeletedBy]  
      ,GC1.CodeName AS FrequencyText, GC2.CodeName AS RouteText, NULL AS CheckBox,Drugs.DrugName as DrugIdText                                                                                                                  
   FROM  CustomMedications INNER JOIN                                                                                             
         Drugs ON CustomMedications.DrugId = Drugs.DrugId                                                                                                                    
   left JOIN     GlobalCodes GC1 ON GC1.GlobalCodeId = CustomMedications.Frequency AND GC1.Active = ''Y'' AND ISNULL(GC1.RecordDeleted, ''N'') = ''N''                                         
   left JOIN     GlobalCodes GC2 ON GC2.GlobalCodeId = CustomMedications.Route AND GC2.Active = ''Y'' AND ISNULL(GC2.RecordDeleted, ''N'') = ''N''                                                                                                   
   WHERE ISNull(CustomMedications.RecordDeleted,''N'')=''N'' AND CustomMedications.DocumentVersionId=@DocumentVersionId    AND                                                                       --(ISNULL(CustomMedications.RecordDeleted, ''N'') = ''N'') AND    
  
   (ISNULL(Drugs.RecordDeleted, ''N'') = ''N'')                                            
   ORDER BY Drugs.DrugName DESC, CustomMedications.MedicationId   
           
END TRY            
          
BEGIN CATCH            
 declare @Error varchar(8000)            
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomScreenForServices'')             
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
