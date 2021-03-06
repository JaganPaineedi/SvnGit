/****** Object:  StoredProcedure [dbo].[csp_SCHRMGetRecentSignedAssessmentUpdate]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMGetRecentSignedAssessmentUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCHRMGetRecentSignedAssessmentUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMGetRecentSignedAssessmentUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCHRMGetRecentSignedAssessmentUpdate]                   
/****************************************************************************/                  
/* csp_SCHRMGetRecentSignedAssessmentUpdate          */                  
/*   Initializes values for new assessments         */                  
/* Called by: scsp_SCHRMGetRecentSignedAssessment       */                  
/*                   */                  
/* Created: 06/25/2010              */                  
/* Created by: Sahil Bhagat            */                  
/* Modification Log:              */                  
/****************************************************************************/                  
 @ClientId int,                  
 @LatestDocumentVersionID int ,    
 @AssessmentType varchar(10)    
as                  
set nocount on                   
          
           
Begin            
--Get AxisI and AxisII for Initial Tab                                                                                        
DECLARE @AxisIAxisIIOut nvarchar(1100)                                                                                        
                                                                                        
EXEC [dbo].[csp_HRMGetAxisIAxisII]                                                                                        
  @ClientID,                                                                                        
  @AxisIAxisIIOut OUTPUT          
 -----For CustomHRMAssessments-----                                                                                                  
   SELECT  ''CustomHRMAssessments'' AS TableName,[DocumentVersionId]           
      ,[ClientName]                                                                  
      ,@AssessmentType as [AssessmentType]                                                              
      ,[CurrentAssessmentDate]                                                                  
      ,[PreviousAssessmentDate]                                                                  
      ,[ClientDOB]                                                                  
      ,[AdultOrChild]                                                                  
      ,[ChildHasNoParentalConsent]                                                                  
      ,[ClientHasGuardian]                                                                  
      ,[GuardianName]                                                                  
      ,[GuardianAddress]                                                                  
      ,[GuardianPhone]                                                                  
      ,[GuardianType]                                                                  
      ,[ClientInDDPopulation]                                                                  
      ,[ClientInSAPopulation]                                                                  
      ,[ClientInMHPopulation]                                                                  
      ,[PreviousDiagnosisText]                                                                  
      ,[ReferralType]                                                                  
      ,[PresentingProblem]                                                                  
      ,[CurrentLivingArrangement]                                                                  
      ,[CurrentPrimaryCarePhysician]                                                                  
      ,[ReasonForUpdate]                                             
      ,[DesiredOutcomes]                                                                  
      ,[PsMedicationsComment]                                           
      ,[PsEducationComment]                                                                  
      ,[IncludeFunctionalAssessment]                                                        
      ,[IncludeSymptomChecklist]                              
      ,[IncludeUNCOPE]         
      ,[ClientIsAppropriateForTreatment]                                                                 
      ,[SecondOpinionNoticeProvided]           
      ,[TreatmentNarrative]                               
,[RapCiDomainIntensity]                                                                  
      ,[RapCbDomainIntensity]                                                                  
      ,[RapCaDomainIntensity]                                                                  
      ,[RapHhcDomainIntensity]                                                                  
      ,[OutsideReferralsGiven]                                                                  
      ,[ReferralsNarrative]                                                               
      ,[ServiceOther]                                                                  
      ,[ServiceOtherDescription]                                       
      ,[AssessmentAddtionalInformation]                                                                  
      ,[TreatmentAccomodation]                                                                  
      ,[Participants]                                                   
      ,[Facilitator]                                                                  
      ,[TimeLocation]                                                                  
      ,[AssessmentsNeeded]                                                                  
   ,[CommunicationAccomodations]                                                                  
      ,[IssuesToAvoid]                                                                  
      ,[IssuesToDiscuss]                                                                  
      ,[SourceOfPrePlanningInfo]                                                                  
      ,[SelfDeterminationDesired]                                                                  
      ,[FiscalIntermediaryDesired]                                                                  
      ,[PamphletGiven]                                                                  
      ,[PamphletDiscussed]                                                                  
  ,[PrePlanIndependentFacilitatorDiscussed]                                                                  
      ,[PrePlanIndependentFacilitatorDesired]                                                                  
      ,[PrePlanGuardianContacted]                                                                  
      ,[CommunityActivitiesCurrentDesired]                                                                  
      ,[CommunityActivitiesIncreaseDesired]                                                                  
      ,[CommunityActivitiesNeedsList]                                                                  
      ,[PsCurrentHealthIssues]                                                                  
      ,[PsCurrentHealthIssuesComment]                                                                  
      ,[PsCurrentHealthIssuesNeedsList]                                                     
      ,[HistMentalHealthTx]                                                                  
      ,[HistMentalHealthTxComment]                                                                  
      ,[HistFamilyMentalHealthTx]                                                                  
      ,[HistFamilyMentalHealthTxComment]                                                                  
      ,[PsClientAbuseIssues]                                                                  
      ,[PsClientAbuesIssuesComment]                                                                  
      ,[PsClientAbuseIssuesNeedsList]                                                       
      ,[PsDevelopmentalMilestones]                 
      ,[PsDevelopmentalMilestonesComment]                                                               
      ,[PsDevelopmentalMilestonesNeedsList]                      
      ,[PsChildEnvironmentalFactors]                  
   ,[PsChildEnvironmentalFactorsComment]                                                                  
      ,[PsChildEnvironmentalFactorsNeedsList]                                                                  
      ,[PsLanguageFunctioning]                                                                  
      ,[PsLanguageFunctioningComment]                           
      ,[PsLanguageFunctioningNeedsList]                                                           
      ,[PsVisualFunctioning]                                                                  
      ,[PsVisualFunctioningComment]                                                                  
      ,[PsVisualFunctioningNeedsList]                                                                  
      ,[PsPrenatalExposure]                                                                  
      ,[PsPrenatalExposureComment]                                                                  
      ,[PsPrenatalExposureNeedsList]                                                                  
    ,[PsChildMentalHealthHistory]                                                                  
      ,[PsChildMentalHealthHistoryComment]                                                                  
      ,[PsChildMentalHealthHistoryNeedsList]                                                                  
      ,[PsIntellectualFunctioning]                                                                  
      ,[PsIntellectualFunctioningComment]                                                  
   ,[PsIntellectualFunctioningNeedsList]                                                                  
      ,[PsLearningAbility]                                                                  
      ,[PsLearningAbilityComment]                                                                  
      ,[PsLearningAbilityNeedsList]                                                                  
      ,[PsPeerInteraction]                                                                  
      ,[PsPeerInteractionComment]                                                                  
      ,[PsPeerInteractionNeedsList]                                                                 
      ,[PsParentalParticipation]                                                         
      ,[PsParentalParticipationComment]                                                                  
      ,[PsParentalParticipationNeedsList]                                                                  
      ,[PsSchoolHistory]                                                                  
      ,[PsSchoolHistoryComment]                                               
      ,[PsSchoolHistoryNeedsList]                                                                  
      ,[PsImmunizations]                                                                  
      ,[PsImmunizationsComment]                                                                  
      ,[PsImmunizationsNeedsList]                                                                  
      ,[PsChildHousingIssues]                                                            
      ,[PsChildHousingIssuesComment]                                                                  
      ,[PsChildHousingIssuesNeedsList]                                                                  
      ,[PsSexuality]                                                                  
    ,[PsSexualityComment]                                              
      ,[PsSexualityNeedsList]                                                                  
      ,[PsFamilyFunctioning]                                                                  
     ,[PsFamilyFunctioningComment]                                                                  
      ,[PsFamilyFunctioningNeedsList]                                                                  
      ,[PsTraumaticIncident]                                                
      ,[PsTraumaticIncidentComment]                                                                  
      ,[PsTraumaticIncidentNeedsList]                
      ,[HistDevelopmental]           
      ,[HistDevelopmentalComment]                                                                  
      ,[HistResidential]                                                              
      ,[HistResidentialComment]                                           
      ,[HistOccupational]                                                        
      ,[HistOccupationalComment]                                                                  
      ,[HistLegalFinancial]                             
      ,[HistLegalFinancialComment]                                                                  
      ,[SignificantEventsPastYear]                                                     
      ,[PsGrossFineMotor]                                                                  
      ,[PsGrossFineMotorComment]                          
      ,[PsGrossFineMotorNeedsList]                                                                  
      ,[PsSensoryPerceptual]                                                                  
      ,[PsSensoryPerceptualComment]                                                                  
      ,[PsSensoryPerceptualNeedsList]                                                                  
      ,[PsCognitiveFunction]                                                                  
      ,[PsCognitiveFunctionComment]                                                                  
      ,[PsCognitiveFunctionNeedsList]                                                                  
      ,[PsCommunicativeFunction]                                                                  
      ,[PsCommunicativeFunctionComment]                                                                  
,[PsCommunicativeFunctionNeedsList]                                                             
      ,[PsCurrentPsychoSocialFunctiion]                                                                  
      ,[PsCurrentPsychoSocialFunctiionComment]                              
      ,[PsCurrentPsychoSocialFunctiionNeedsList]                                                                  
      ,[PsAdaptiveEquipment]                                                                  
      ,[PsAdaptiveEquipmentComment]                                                                  
      ,[PsAdaptiveEquipmentNeedsList]                                                                  
      ,[PsSafetyMobilityHome]                                    
      ,[PsSafetyMobilityHomeComment]                                                                  
      ,[PsSafetyMobilityHomeNeedsList]                                                                  
      ,[PsHealthSafetyChecklistComplete]                                                                  
      ,[PsAccessibilityIssues]                                                                  
      ,[PsAccessibilityIssuesComment]                                                                  
      ,[PsAccessibilityIssuesNeedsList]                                                          
      ,[PsEvacuationTraining]                                                                  
      ,[PsEvacuationTrainingComment]                                                                  
      ,[PsEvacuationTrainingNeedsList]                                                                  
 ,[Ps24HourSetting]                                                                  
      ,[Ps24HourSettingComment]                             
      ,[Ps24HourSettingNeedsList]                                                                  
      ,[Ps24HourNeedsAwakeSupervision]                                                                  
      ,[PsSpecialEdEligibility]         
      ,[PsSpecialEdEligibilityComment]                                                                  
      ,[PsSpecialEdEligibilityNeedsList]                                                                  
      ,[PsSpecialEdEnrolled]                                                                  
      ,[PsSpecialEdEnrolledComment]                                                                  
      ,[PsSpecialEdEnrolledNeedsList]                                                                  
      ,[PsEmployer]                                                                  
      ,[PsEmployerComment]                                                      
      ,[PsEmployerNeedsList]                                         
      ,[PsEmploymentIssues]                                                                  
    ,[PsEmploymentIssuesComment]                                                        
      ,[PsEmploymentIssuesNeedsList]                                                                  
      ,[PsRestrictionsOccupational]                                                   
      ,[PsRestrictionsOccupationalComment]                                                                  
     ,[PsRestrictionsOccupationalNeedsList]                                                                  
      ,[PsFunctionalAssessmentNeeded]                                                                  
      ,[PsAdvocacyNeeded]                                                                  
      ,[PsPlanDevelopmentNeeded]                                                                  
      ,[PsLinkingNeeded]                                                                  
      ,[PsDDInformationProvidedBy]                                                                  
   ,[HistPreviousDx]                                                                  
      ,[HistPreviousDxComment]                                                                  
      ,[PsLegalIssues]                                                                  
      ,[PsLegalIssuesComment]                                                                  
      ,[PsLegalIssuesNeedsList]                                                                  
     ,[PsCulturalEthnicIssues]                                                                  
      ,[PsCulturalEthnicIssuesComment]                                                                  
      ,[PsCulturalEthnicIssuesNeedsList]                                                                  
      ,[PsSpiritualityIssues]                                                                  
      ,[PsSpiritualityIssuesComment]                                                              
      ,[PsSpiritualityIssuesNeedsList]                                                                  
      ,[SuicideNotPresent]                                                                  
      ,[SuicideIdeation]                                        
      ,[SuicideActive]                                                                  
      ,[SuicidePassive]                                                                  
      ,[SuicideMeans]                                                                  
      ,[SuicidePlan]                                                                  
     ,[SuicidePriorAttempt]                                                                  
      ,[SuicideNeedsList]                                              
      ,[SuicideBehaviorsPastHistory]                                                                  
      ,[SuicideOtherRiskSelf]              
      ,[SuicideOtherRiskSelfComment]                                                                  
      ,[HomicideNotPresent]                                                                  
      ,[HomicideIdeation]                                       
      ,[HomicideActive]           
      ,[HomicidePassive]                                                                  
      ,[HomicideMeans]                                                                  
      ,[HomicidePlan]                                                            
      ,[HomicidePriorAttempt]                                                                  
      ,[HomicideNeedsList]                                             
      ,[HomicideBehaviorsPastHistory]                                                   
      ,[HomicdeOtherRiskOthers]                                                      
      ,[HomicideOtherRiskOthersComment]                                                                  
      ,[PhysicalAgressionNotPresent]                                                                  
      ,[PhysicalAgressionSelf]                                                                  
      ,[PhysicalAgressionOthers]                                                
      ,[PhysicalAgressionCurrentIssue]                                                           
      ,[PhysicalAgressionNeedsList]                                                                  
      ,[PhysicalAgressionBehaviorsPastHistory]                                                                  
      ,[RiskAccessToWeapons]                                                                  
      ,[RiskAppropriateForAdditionalScreening]                                                                  
      ,[RiskClinicalIntervention]                                                                  
 ,[RiskOtherFactors]                                                                  
      ,[StaffAxisV]                                                                  
      ,[StaffAxisVReason]                                                                  
      ,[ClientStrengthsNarrative]                                                                  
      ,[CrisisPlanningClientHasPlan]                                                   
      ,[CrisisPlanningNarrative]                                                                  
      ,[CrisisPlanningDesired]                                                                  
      ,[CrisisPlanningNeedsList]                                                                  
    ,[CrisisPlanningMoreInfo]                                                                  
      ,[AdvanceDirectiveClientHasDirective]                                                                  
      ,[AdvanceDirectiveDesired]                                                                  
      ,[AdvanceDirectiveNarrative]                                                                  
      ,[AdvanceDirectiveNeedsList]                                                                  
      ,[AdvanceDirectiveMoreInfo]                                                                  
      ,[NaturalSupportSufficiency]                                            
      ,[NaturalSupportNeedsList]                                                                  
,[NaturalSupportIncreaseDesired]                                              
      ,[ClinicalSummary]                                                                  
      ,[UncopeQuestionU]                                                                  
      ,[UncopeApplicable]                                                                  
      ,[UncopeApplicableReason]                                                                  
      ,[UncopeQuestionN]                                                                  
      ,[UncopeQuestionC]                                              
      ,[UncopeQuestionO]                                                                  
      ,[UncopeQuestionP]                                                                  
      ,[UncopeQuestionE]                                                                  
      ,[SubstanceUseNeedsList]                            
      ,[DecreaseSymptomsNeedsList]                                                                  
      ,[DDEPreviouslyMet]                                                                  
      ,[DDAttributableMentalPhysicalLimitation]                                                                  
      ,[DDDxAxisI]                                                                  
      ,[DDDxAxisII]        
      ,[DDDxAxisIII]                                                                  
      ,[DDDxAxisIV]                                                                  
  ,[DDDxAxisV]                                                                  
      ,[DDDxSource]                                                                  
      ,[DDManifestBeforeAge22]                                                                  
      ,[DDContinueIndefinitely]                                                                  
      ,[DDLimitSelfCare]                                                                  
      ,[DDLimitLanguage]                                                                  
      ,[DDLimitLearning]                                                          
      ,[DDLimitMobility]                                                                  
      ,[DDLimitSelfDirection]                                                                  
      ,[DDLimitEconomic]                                   
      ,[DDLimitIndependentLiving]                                                                  
      ,[DDNeedMulitpleSupports]                                                                  
      ,[CAFASDate]                                                                  
      ,[RaterClinician]                                                                  
      ,[CAFASInterval]                                                                  
      ,[SchoolPerformance]                                                          
      ,[SchoolPerformanceComment]                                                                  
      ,[HomePerformance]                                                             
      ,[HomePerfomanceComment]                                                                  
 ,[CommunityPerformance]                                                                  
      ,[CommunityPerformanceComment]                                                                  
      ,[BehaviorTowardsOther]                                                                  
      ,[BehaviorTowardsOtherComment]                                
      ,[MoodsEmotion]                                                                  
      ,[MoodsEmotionComment]                                                                  
      ,[SelfHarmfulBehavior]                                                                  
      ,[SelfHarmfulBehaviorComment]                                                                  
      ,[SubstanceUse]                                                                  
      ,[SubstanceUseComment]                                                                  
      ,[Thinkng]                                                                  
      ,[ThinkngComment]                                       
      ,[PrimaryFamilyMaterialNeeds]                                                                  
      ,[PrimaryFamilyMaterialNeedsComment]                                                                  
      ,[PrimaryFamilySocialSupport]           
      ,[PrimaryFamilySocialSupportComment]                                                                  
    ,[NonCustodialMaterialNeeds]                                                                  
      ,[NonCustodialMaterialNeedsComment]                                                                  
      ,[NonCustodialSocialSupport]                                                        
      ,[NonCustodialSocialSupportComment]                                                                  
      ,[SurrogateMaterialNeeds]                                                                  
      ,[SurrogateMaterialNeedsComment]                                                                  
      ,[SurrogateSocialSupport]                                                              
      ,[SurrogateSocialSupportComment]                                                                  
      ,[DischargeCriteria]                                              
      ,[PrePlanFiscalIntermediaryComment]                                     
      ,[StageOfChange]                                                                  
      ,[PsEducation]                            
      ,[PsEducationNeedsList]                                                                  
      ,[PsMedications]                                                                  
      ,[PsMedicationsNeedsList]    
      ,[PhysicalConditionQuadriplegic]    
      ,[PhysicalConditionMultipleSclerosis]    
      ,[PhysicalConditionBlindness]    
      ,[PhysicalConditionDeafness]    
      ,[PhysicalConditionParaplegic]    
      ,[PhysicalConditionCerebral]    
      ,[PhysicalConditionMuteness]    
      ,[PhysicalConditionOtherHearingImpairment]      
      ,[CreatedBy]                                                                  
      ,[CreatedDate]                                                                  
      ,[ModifiedBy]                                                                  
      ,[ModifiedDate]                                         
      ,[RecordDeleted]                                                                  
      ,[DeletedDate]                                                                  
      ,[DeletedBy]                                        
      ,@AxisIAxisIIOut as AxisIAxisII                                                                            
  FROM CustomHRMAssessments                                                                                 
  WHERE  (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                 
 -----For DiagnosesIII-----                           
   SELECT         
   ''DiagnosesIII'' AS TableName,                                                                                                             
  [DocumentVersionId]    
      ,[CreatedBy]    
      ,[CreatedDate]    
      ,[ModifiedBy]    
      ,[ModifiedDate]    
      ,[RecordDeleted]    
      ,[DeletedDate]    
      ,[DeletedBy]    
      ,[Specification]                                                                                                      
   FROM DiagnosesIII                                                       
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                            
                                                                                                              
   -----For DiagnosesIV-----                                                                       
   SELECT ''DiagnosesIV'' AS TableName,                                                                                                               
  DocumentVersionId                                                                                                              
  ,PrimarySupport                                                                                                              
  ,SocialEnvironment                                                              
  ,Educational                                                                                                              
  ,Occupational                                                                                                              
,Housing                                                   
  ,Economic                                                                                     
  ,HealthcareServices                                                                                                              
  ,Legal                                                            
  ,Other                                                                                                              
  ,Specification                                                       
  ,CreatedBy                                                           
  ,CreatedDate                                                
  ,ModifiedBy                                                                                                              
  ,ModifiedDate                                                                             
  ,RecordDeleted                                                                                                              
  ,DeletedDate                                                                                                       
  ,DeletedBy                                                                                                              
   FROM DiagnosesIV                                                                                                              
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                                              
                                                                                                
   -----For DiagnosesV-----                                                              
 SELECT   ''DiagnosesV'' AS TableName,                                           
 DocumentVersionId                                                                            
 ,AxisV                                                                                                              
 ,CreatedBy                                                                                                              
 ,CreatedDate                                                        
 ,ModifiedBy                                                   
 ,ModifiedDate                                                                                       
 ,RecordDeleted                                                                                                              
 ,DeletedDate                                                                                                              
 ,DeletedBy                                                          
 FROM DiagnosesV                                                             
 WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                      
                                                
                                                            
  ---CustomPsychosocialAdult2---                                                              
 SELECT ''CustomPsychosocialAdult2'' AS TableName,  [DocumentVersionId]                                                      
      ,[HealthIssues]                                                      
      ,[HealthIssuesAddToNeedsList]                                              
      ,[HealthIssuesDescription]                                 
      ,[Medications]                                           
      ,[MedicationsAddToNeedsList]                                                      
      ,[MedicationsListToBeModified]                                                      
      ,[MedicationsDescription]                                                      
      ,[AbuseNeglect]                                             
    ,[AbuseNeglectAddToNeedsList]                                                      
      ,[AbuseNeglectDescription]                                                      
      ,[CulturalEthnic]                 
      ,[CulturalEthnicAddToNeedsList]                                                      
      ,[CulturalEthnicDescription]                                                      
      ,[Spirituality]                                                      
      ,[SpiritualityAddToNeedsList]                                                      
      ,[SpiritualityDescription]                                                      
      ,[EducationStatusAddToNeedsList]                                                      
      ,[EducationStatusDescription]                                                      
      ,[MentalHealth]                                                      
      ,[MentalHealthAddToNeedsList]                                                      
      ,[MentalHealthDescription]                                                      
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                                      
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                      
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                                      
    ,[DeletedBy]                                                      
  FROM CustomPsychosocialAdult2                                               
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                             
                                                        
                                                             
 
  --FROM CustomAssessments2 ca ,CustomLOCCategories c,CustomLOCs l     
                                                     
  --WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ca.RecordDeleted,''N'')=''N''                                               
  --and ca.LOCId=l.LOCId  and c.LOCCategoryId=l.LOCCategoryId                                                     
                                                       
 ---CustomRiskAssessments2---                                                      
 SELECT ''CustomRiskAssessments2'' AS TableName,  [DocumentVersionId]                                                      
      ,[CurrentSuicidality]                                                      
      ,[SuicidalityPreviousAttempts]                                                      
      ,[NoCurrentOrPastSuicidality]                                                      
      ,[CurrentSuicidalityIdeation]                                                      
      ,[CurrentSuicidalityActive]                                                      
      ,[CurrentSuicidalityPassive]                                                      
      ,[CurrentSuicidalityMeans]                                                      
      ,[CurrentSuicidalityPlans]                         
      ,[SuicidalityDetails]                                                      
      ,[SuicidalityAddToNeedsList]                                    ,[CurrentHomicidality]                                                      
      ,[HomicidalityPreviousAttempts]                                                      
  ,[NoCurrentOrPastHomicidality]                                                      
      ,[CurrentHomicidalityIdeation]                                                      
      ,[CurrentHomicidalityActive]                                                      
      ,[CurrentHomicidalityPassive]                                                      
      ,[CurrentHomicidalityMeans]                                                      
      ,[CurrentHomicidalityPlans]                                                      
      ,[HomicidalityDetails]                                                      
      ,[HomicidalityAddToNeedsList]                                                      
      ,[OtherRiskFactorsNone]                                                      
      ,[OtherRiskFactorDetails]                                                      
      ,[OtherRiskFactorsAddToNeedsList]                                          
      ,[CrisisPlanningClientHasPlan]                                                      
      ,[CrisisPlanningClientDesiresPlan]                                                     
      ,[CrisisPlanningClientLikesMoreInformation]                                                      
 ,[CrisisPlanningInformationGiven]                                                      
      ,[CrisisPlanningAddToNeedsList]                                                      
      ,[AdvanceDirectiveClientHas]                                                      
      ,[AdvanceDirectiveClientDesires]                                                      
      ,[AdvanceDirectiveClientLikesMoreInformation]                                                 
      ,[AdvanceDirectiveMoreInformationGiven]                                                      
      ,[AdvanceDirectiveAddToNeedsList]                                                      
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                                      
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                      
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                                      
      ,[DeletedBy]                      
  FROM CustomRiskAssessments2                                     
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                      
                                                      
                                                       
        ---CustomHRMAssessmentActivityScores---     
         --- CustomDailyLivingActivityScores ---                                                     
  SELECT ''CustomDailyLivingActivityScores'' AS TableName,  [DailyLivingActivityScoreId]                                                      
      ,[DocumentVersionId]                                                        
      ,[HRMActivityId]                                                        
      ,[ActivityScore]          
      ,[ActivityComment]                                                        
      ,[CreatedBy]                                                        
      ,[CreatedDate]                                       
      ,[ModifiedBy]                                                        
      ,[ModifiedDate]                            
      ,[RecordDeleted]                                                        
      ,[DeletedDate]                                            
      ,[DeletedBy]                                                       
  FROM CustomDailyLivingActivityScores                                                      
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                      
                                                              
   ---CustomSubstanceUseHistory2---                                                      
  SELECT ''CustomSubstanceUseHistory2'' AS TableName,  [SubstanceUseHistoryId]                                                      
      ,[DocumentVersionId]                                                      
      ,[SUDrugId]                                                      
      ,[AgeOfFirstUse]                                                      
      ,[Frequency]                                       
   ,[Route]                                                      
      ,[LastUsed]                                                      
      ,[InitiallyPrescribed]                                                      
      ,[Preference]                                                      
      ,[FamilyHistory]                              
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                                      
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                      
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                                      
      ,[DeletedBy]                                                      
  FROM CustomSubstanceUseHistory2                                                      
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                     
                                    
  ---CustomHRMAssessmentLevelOfCareOptions---                                                               
 SELECT ''CustomHRMAssessmentLevelOfCareOptions'' AS TableName,  [HRMAssessmentLevelOfCareOptionId]                                                              
 ,[DocumentVersionId]                                                              
      ,[HRMLevelOfCareOptionId]                                                              
      ,[OptionSelected]                                                              
      ,[CreatedBy]                                                              
     ,[CreatedDate]                                                              
      ,[ModifiedBy]                                               
      ,[ModifiedDate]                                                              
   ,[RecordDeleted]                                                              
      ,[DeletedDate]                                                              
      ,[DeletedBy]                                                            
   --,(select ServiceChoiceLabel from CustomHRMLevelOfCareOptions  where isnull(RecordDeleted,''N'')=''N''                                                                         
   -- and HRMLevelOfCareOptionId = isnull(HRMLevelOfCareOptionId,'''')) as ServiceChoiceLabel                     
  FROM CustomHRMAssessmentLevelOfCareOptions                                                        
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                            
                                                            
  ---CustomOtherRiskFactors---                                                           
  SELECT ''CustomOtherRiskFactors'' AS TableName,  [OtherRiskFactorId]                                                          
      ,[DocumentVersionId]                                                          
      ,[OtherRiskFactor]                                                          
      ,[CreatedBy]                                                          
      ,[CreatedDate]                                                          
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                          
      ,[RecordDeleted]                                                          
      ,[DeletedDate]                                                   
      ,[DeletedBy]                                                          
      ,(select CodeName from GlobalCodes  where isnull(RecordDeleted,''N'')=''N''                                                                   
  and GlobalCodeId = isnull(OtherRiskFactor,'''')) as CodeName                                                          
  FROM CustomOtherRiskFactors                                                           
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                     
                                   
 ---CustomSupports2---                                                               
  SELECT ''CustomSupports2'' AS TableName,  [SupportId]                                                        
      ,[DocumentVersionId]                                                        
      ,[SupportDescription]                                                        
      ,[Current]                                                        
      ,[PaidSupport]                                                        
      ,[UnpaidSupport]                                                        
      ,[ClinicallyRecommended]                                                        
      ,[CustomerDesired]                                                        
      ,[CreatedBy]                                                        
      ,[CreatedDate]                                                        
      ,[ModifiedBy]                                                        
      ,[ModifiedDate]                              
      ,[RecordDeleted]                                                        
      ,[DeletedDate]                                    ,[DeletedBy]    
  FROM CustomSupports2                                                        
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                        
                                                   
                                                               
 -- CustomHRMActivities---                                   
                                                                        
   SELECT  ''CustomHRMActivities'' AS TableName,  [HRMActivityId]                                                                    
      ,[HRMActivityDescription]                                                                    
      ,[SortOrder]                                                                    
      ,[Active]                                                                    
      ,[AssociatedHRMNeedId]                                           
      ,[Example]                                                          
      ,[CreatedBy]                                                                    
      ,[CreatedDate]                                                                    ,[ModifiedBy]                                                                    
      ,[ModifiedDate]                                                                    
      ,[RecordDeleted]                                                                    
    ,[DeletedDate]                                     
      ,[DeletedBy]                                                                    
      from  CustomHRMActivities where                                                                             
 Active=''Y'' and  isnull(RecordDeleted,''N'')<>''Y''                                                        
                                            
                                                                 
  ---CustomCAFAS2---                                                        
  SELECT ''CustomCAFAS2'' AS TableName,  [DocumentVersionId]                                     
      ,[CAFASDate]                                                        
      ,[RaterClinician]                                                  
      ,[CAFASInterval]                                                        
      ,[SchoolPerformance]                                                        
      ,[SchoolPerformanceComment]                                                        
      ,[HomePerformance]                                                        
      ,[HomePerfomanceComment]                                                        
      ,[CommunityPerformance]                                                        
      ,[CommunityPerformanceComment]                                                        
      ,[BehaviorTowardsOther]                                                        
      ,[BehaviorTowardsOtherComment]                                                        
      ,[MoodsEmotion]                                                        
      ,[MoodsEmotionComment]                                                        
      ,[SelfHarmfulBehavior]                                                  
      ,[SelfHarmfulBehaviorComment]                                                        
      ,[SubstanceUse]                                                        
      ,[SubstanceUseComment]                                                        
      ,[Thinkng]                                                     
      ,[ThinkngComment]                                                        
      ,[PrimaryFamilyMaterialNeeds]                                                        
      ,[PrimaryFamilyMaterialNeedsComment]                                                        
      ,[PrimaryFamilySocialSupport]          
      ,[PrimaryFamilySocialSupportComment]                                                        
      ,[NonCustodialMaterialNeeds]                                                        
      ,[NonCustodialMaterialNeedsComment]                                                        
      ,[NonCustodialSocialSupport]                                                        
      ,[NonCustodialSocialSupportComment]                                                        
      ,[SurrogateMaterialNeeds]                         
      ,[SurrogateMaterialNeedsComment]                                                        
      ,[SurrogateSocialSupport]                                                        
      ,[SurrogateSocialSupportComment]                                                        
      ,[CreatedDate]                                                        
      ,[CreatedBy]                          
      ,[ModifiedDate]                     
      ,[ModifiedBy]          ,[RecordDeleted]                         
      ,[DeletedDate]                                                        
      ,[DeletedBy]                                                        
  FROM CustomCAFAS2                                                         
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                 
                                                          
  ---CustomPsychosocialChild2---                                     
  SELECT ''CustomPsychosocialChild2'' AS TableName,  [DocumentVersionId]                                                        
      ,[HealthPhysicalHealth]                                                        
      ,[HealthPhysicalHealthAddToNeedsList]                                                        
      ,[HealthMetMilestones]                                                        
      ,[HealthMetMilestonesAddtoNeedsList]                                                        
      ,[HealthPrenatalSubstances]                                                        
      ,[HealthPrenatalSubstancesAddToNeedsList]                                             
      ,[HealthSexualityIssues]                                                        
      ,[HealthSexualityIssuesAddToNeedsList]                                                   
      ,[Medications]                                                        
      ,[MedicationsAddToNeedsList]                                                        
      ,[MedicationsListToBeModified]                                                        
      ,[MedicationsDescription]                                                        
      ,[FunctioningLanguage]                                                        
      ,[FunctioningLanguageAddToNeedsList]                                                        
      ,[FunctioningVisual]                                                        
      ,[FunctioningVisualAddToNeedsList]                                                        
      ,[FunctioningIntellectual]                                                        
      ,[FunctioningIntellectualAddToNeedsList]                                                        
      ,[FunctioningLearning]                                                        
      ,[FunctioningLearningAddToNeedsList]                                                        
                                                    
      ,[FunctioningConcerns]                                                        
      ,[CultureEthnic]                                                        
      ,[CultureEthnicAddToNeedsList]                                  
      ,[CultureSpirituality]                                                        
      ,[CultureSpiritualityAddToNeedsList]                                                        
      ,[CultureEthnicConcerns]                                                        
      ,[FamilyMentalHistory]                                                        
      ,[FamilyMentalHistoryAddToNeedsList]                                                        
      ,[FamilyHousing]                                                        
      ,[FamilyHousingAddToNeedsList]                                                        
      ,[FamilyParticipate]                                                        
      ,[FamilyParticipateAddToNeedsList]                                                        
      ,[FamilyLearning]                                                      
      ,[FamilyLearningAddToNeedsList]                                                        
     ,[FamilyAbuse]                                                        
      ,[FamilyAbuseAddToNeedsList]                                                        
      ,[FamilyConcerns]                                                        
      ,[Spirituality]                                                        
      ,[SpiritualityAddToNeedsList]                                                        
      ,[SpiritualityDescription]                                                        
      ,[EducationStatusAddToNeedsList]                                                        
      ,[EducationStatusDescription]                                                        
      ,[MentalHealth]                                                        
      ,[MentalHealthAddToNeedsList]                                                        
      ,[MentalHealthDescription]                                                        
      ,CPC2.[CreatedBy]                                                      
      ,CPC2.[CreatedDate]                                             
      ,CPC2.[ModifiedBy]             
      ,CPC2.[ModifiedDate]                                                        
      ,CPC2.[RecordDeleted]                                   
      ,[DeletedDate]                                                     
      ,[DeletedBy]                                                        
                                                        
    FROM CustomPsychosocialChild2 CPC2                                                         
    WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                          
                                                               
  ---CustomPsychosocialDD2---                                                         
  SELECT ''CustomPsychosocialDD2'' AS TableName,  [DocumentVersionId]                                                        
      ,[MentalHealth]                                        
      ,[MentalHealthAddToNeedsList]                                        
      ,[MentalHealthDescription]                                        
      ,[CulturalEthnic]                                        
      ,[CulturalEthnicAddToNeedsList]                                        
      ,[CulturalEthnicDescription]                                        
      ,[Spirituality]                                        
      ,[SpiritualityAddToNeedsList]                                  
      ,[SpiritualityDescription]                                        
      ,[AbuseNeglect]                                        
      ,[AbuseNeglectAddToNeedsList]                                        
      ,[AbuseNeglectDescription]                      
      ,[RiskLossOfPlacement]                                        
      ,[RiskLossOfPlacementDueTo]                                        
      ,[RiskSensoryMotorFunction]                                        
      ,[RiskSensoryMotorFunctionDueTo]                                        
      ,[RiskEmploymentIssues]                                        
      ,[RiskEmploymentIssuesDueTo]                                        
      ,[RiskCognitiveFunction]                                        
   ,[RiskCognitiveFunctionDueTo]                                        
      ,[RiskSafety]                                        
      ,[RiskSafetyDueTo]                                        
      ,[CreatedBy]                                        
      ,[CreatedDate]                                        
      ,[ModifiedBy]                                        
      ,[ModifiedDate]                                        
      ,[RecordDeleted]                                        
      ,[DeletedDate]                                        
      ,[DeletedBy]                         
  FROM    CustomPsychosocialDD2 CPDD2                                                       
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                   
                                                       
       ---CustomSubstanceUseAssessments2---                                                     
   SELECT ''CustomSubstanceUseAssessments2'' AS TableName,  [DocumentVersionId]                  
      ,[SuspectedSubstanceUse]                 
      ,[ClientSAHistory]                  
      ,[FamilySAHistory]                  
      ,[ClientAdmitsSubstanceUse]                  
      ,[CurrentSubstanceUseSuspected]                  
      ,[SubstanceUseTxPlan]                  
      ,[Comment]                  
      ,[OdorOfSubstance]                  
      ,[SlurredSpeech]                  
      ,[WithdrawalSymptoms]                  
      ,[IncreasedTolerance]                  
      ,[Blackouts]                  
      ,[LossOfControl]                  
      ,[RelatedArrests]                  
      ,[RelatedSocialProblems]                  
      ,[FrequentJobSchoolAbsence]                  
      ,[NoneSynptomsReportedOrObserved]                  
      ,[DUI30Days]                  
      ,[DUI5Years]                  
      ,[DWI30Days]                  
      ,[DWI5Years]                  
      ,[Possession30Days]                  
      ,[Possession5Years]                  
      ,[SubstanceAbuseSymptomsComments]                  
      ,[PreviousSubstanceAbuseTreatment]                  
      ,[CurrentSubstanceAbuseTreatment]                  
      ,[CurrentTreatmentProvider]                  
      ,[CurrentSubstanceUseSymptoms]                  
      ,[CurrentSubstanceAbuseRefferedReason]                  
      ,[ToxicologicalResults]                  
      ,[VoluntaryAbstinenceTrial]                  
      ,[RiskOfRelapse]                  
      ,[SUIssuesAddToNeedsList]                  
      ,[CreatedBy]                  
      ,[CreatedDate]                  
      ,[ModifiedBy]                  
      ,[ModifiedDate]                  
      ,[RecordDeleted]                  
      ,[DeletedDate]                  
      ,[DeletedBy]                                            
  FROM                                                   
                                                    
  CustomSubstanceUseAssessments2 CSUA2                                                       
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                           
                       
       -- CustomHRMAssessmentRAPScores --            
       SELECT ''CustomHRMAssessmentRAPScores'' AS TableName,  [HRMAssessmentRAPQuestionId]            
      ,[DocumentVersionId]            
      ,[HRMRAPQuestionId]            
      ,[RAPAssessedValue]            
      ,[CreatedBy]            
      ,[CreatedDate]            
      ,[ModifiedBy]            
      ,[ModifiedDate]            
      ,[RecordDeleted]            
      ,[DeletedDate]            
      ,[DeletedBy]            
  FROM CustomHRMAssessmentRAPScores             
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                
                                        
                                        
   -- Modified by sweety kamboj on 25may                                           
  -- add this table at end according to TableList                                          
                                        
   --- CustomSubstanceUseAssessments ----                                                                                                     
    select  ''CustomSubstanceUseAssessments'' AS TableName,  [DocumentVersionId]                                             
      ,[VoluntaryAbstinenceTrial]                                                                  
      ,[Comment]                                                                  
      ,[HistoryOrCurrentDUI]                                                                ,[NumberOfTimesDUI]                                                                  
      ,[HistoryOrCurrentDWI]                                                                  
      ,[NumberOfTimesDWI]                                                                  
      ,[HistoryOrCurrentMIP]                                                       
      ,[NumberOfTimeMIP]                                      
      ,[HistoryOrCurrentBlackOuts]                                    
      ,[NumberOfTimesBlackOut]                                                                  
      ,[HistoryOrCurrentDomesticAbuse]                                                                  
      ,[NumberOfTimesDomesticAbuse]                                                                  
      ,[LossOfControl]                                                                  
      ,[IncreasedTolerance]                                                                  
     ,[OtherConsequence]                                                    
      ,[OtherConsequenceDescription]                                                                  
      ,[RiskOfRelapse]                                                                  
      ,[PreviousTreatment]                                                
      ,[CurrentSubstanceAbuseTreatment]                                                                  
      ,[CurrentTreatmentProvider]                                                                  
      ,[CurrentSubstanceAbuseReferralToSAorTx]                                                                  
      ,[CurrentSubstanceAbuseRefferedReason]                                                 
      ,[ToxicologyResults]                                                                  
      ,[ClientSAHistory]                                                                  
      ,[FamilySAHistory]                                                                  
      ,[NoSubstanceAbuseSuspected]                                                                  
      ,[CurrentSubstanceAbuse]                                                                  
      ,[SuspectedSubstanceAbuse]                                                          
      ,[SubstanceAbuseDetail]                                                                  
      ,[SubstanceAbuseTxPlan]                                                                  
      ,[OdorOfSubstance]                                                                  
      ,[SlurredSpeech]                                                                  
      ,[WithdrawalSymptoms]                                                                  
      ,[DTOther]                                                                  
      ,[DTOtherText]                               
    ,[Blackouts]                                                                  
      ,[RelatedArrests]                                                                  
      ,[RelatedSocialProblems]                               
      ,[FrequentJobSchoolAbsence]                                                                  
      ,[NoneSynptomsReportedOrObserved]                                                                  
      ,cs.[CreatedBy]                                  
      ,cs.[CreatedDate]                                                                  
      ,cs.[ModifiedBy]                                                                  
      ,cs.[ModifiedDate]                                                                  
      ,cs.[RecordDeleted]                                                                  
      ,cs.[DeletedDate]                                                                  
      ,cs.[DeletedBy]                                                                                                 
  FROM CustomSubstanceUseAssessments cs                                                                                                     
  WHERE (ISNULL(cs.RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                                           
                                               
                                      
      ------Added By Ashwani Kumar Angrish                      
------1 june 2010                                
------For Initailization of Needs from TXPlan                                
select ClientNeedId,ClientEpisodeId,NeedName,NeedDescription,NeedStatus,AssociatedHRMNeedId,SourceDocumentVersionId,                                
AssessmentUpdateType,DiagnosisUpdateRequired,NeedCreatedByName,CreatedBy,CreatedDate,                                
ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,(select NeedId from CustomTPNeedsClientNeeds where CustomTPNeedsClientNeeds.ClientNeedId=CustomClientNeeds.ClientNeedId) as AssociatedGoalId from CustomClientNeeds where SourceDocumentVersionId 
  
in         
                            
(select  CurrentDocumentVersionId from Documents where ClientId=@ClientId                               
and (DocumentCodeId=352 or DocumentCodeId=503 or DocumentCodeId=350) and ISNULL(RecordDeleted,''N'')=''N'')and ISNULL(RecordDeleted,''N'')=''N''                                
                     
  -- CustomRAP2--                           
  select  ''CustomRAP2'' AS TableName,  [DocumentVersionId]                                  
      ,[RapCiDomainIntensity]                                  
      ,[CommunityInclusionSummary]                                  
      ,[CommunityInclusionSummaryAddToNeedsList]                                  
      ,[RapCbDomainIntensity]                                  
      ,[ChallengingBehaviorsSummary]                                  
      ,[ChallengingBehaviorsSummaryAddToNeedsList]                                  
      ,[RapCaDomainIntensity]                                  
      ,[CurrentAbilitiesSummary]                                  
      ,[CurrentAbilitiesSummaryAddToNeedsList]                                  
      ,[RapHhcDomainIntensity]                                  
      ,[HealthIssuesMedications]                              
      ,[HealthIssuesMedicationsAddToNeedsList]                                  
      ,[HealthIssuesMedicationsModified]                                  
      ,[HealthIssuesMedicationsList]                                  
      ,[HealthIssuesSummary]                                  
      ,[HealthIssuesSummaryAddToNeedsList]                                  
      ,[CreatedBy]                                  
      ,[CreatedDate]                                  
      ,[ModifiedBy]                                  
      ,[ModifiedDate]                                  
      ,[RecordDeleted]                                  
      ,[DeletedDate]                                  
     from CustomRAP2 CR2                                  
     WHERE (ISNULL(CR2.RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                  
                
                             
     -----For DiagnosesIAndII-----                                              
    SELECT  ''DiagnosesIAndII'' AS TableName,                                                                                                                  
   D.DocumentVersionId                                                                                                                  
  ,D.DiagnosisId                                                                              
  ,D.Axis                                                                                                                  
  ,D.DSMCode                                                                                                                  
  ,D.DSMNumber                                                                                      
  ,D.DiagnosisType                                                                                                                  
  ,D.RuleOut                                                      
  ,D.Billable                                                                                               
  ,D.Severity                                                                                    
  ,D.DSMVersion                              
  ,D.DiagnosisOrder                                                                            
  ,D.Specifier                                                                                                                  
  ,D.CreatedBy                                                                      
  ,D.CreatedDate                                            
  ,D.ModifiedBy                                                                                                                  
  ,D.ModifiedDate                                                                                                                  
  ,D.RecordDeleted                                                                                      
  ,D.DeletedDate                                                                                                                  
  ,D.DeletedBy                                                                 
  ,DSM.DSMDescription                                                                                                             
   FROM DiagnosesIAndII  D                                                                                                                  
  inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                                                                                                      
  and DSM.DSMNumber = D.DSMNumber                                            
   WHERE                                                     
  DocumentVersionId=@LatestDocumentVersionID   AND ISNULL(RecordDeleted,''N'')=''N''       
            
                 --- CustomMentalStatuses2 ---                  
   SELECT  [DocumentVersionId]                
      ,[AppearanceAddToNeedsList]                
      ,[AppearanceNeatClean]                
      ,[AppearancePoorHygiene]                
      ,[AppearanceWellGroomed]                
      ,[AppearanceAppropriatelyDressed]                
      ,[AppearanceYoungerThanStatedAge]                
      ,[AppearanceOlderThanStatedAge]                
      ,[AppearanceOverweight]                
      ,[AppearanceUnderweight]                
      ,[AppearanceEccentric]                
      ,[AppearanceSeductive]                
      ,[AppearanceUnkemptDisheveled]                
      ,[AppearanceOther]                
      ,[AppearanceComment]                
      ,[IntellectualAddToNeedsList]                
      ,[IntellectualAboveAverage]                
      ,[IntellectualAverage]                
      ,[IntellectualBelowAverage]                
      ,[IntellectualPossibleMR]                
      ,[IntellectualDocumentedMR]                
      ,[IntellectualOther]                
      ,[IntellectualComment]                
      ,[CommunicationAddToNeedsList]                
      ,[CommunicationNormal]                
      ,[CommunicationUsesSignLanguage]                
      ,[CommunicationUnableToRead]                
      ,[CommunicationNeedForBraille]                
      ,[CommunicationHearingImpaired]                
      ,[CommunicationDoesLipReading]                
      ,[CommunicationEnglishIsSecondLanguage]                
      ,[CommunicationTranslatorNeeded]                
      ,[CommunicationOther]                
      ,[CommunicationComment]                
      ,[MoodAddToNeedsList]                
      ,[MoodUnremarkable]                
      ,[MoodCooperative]                
  ,[MoodAnxious]                
      ,[MoodTearful]                
      ,[MoodCalm]                
      ,[MoodLabile]                
      ,[MoodPessimistic]                
      ,[MoodCheerful]                
      ,[MoodGuilty]                
      ,[MoodEuphoric]                
      ,[MoodDepressed]                
      ,[MoodHostile]                
      ,[MoodIrritable]                
      ,[MoodDramatized]                
      ,[MoodFearful]                
      ,[MoodSupicious]                
      ,[MoodOther]                
      ,[MoodComment]                
      ,[AffectAddToNeedsList]         
      ,[AffectPrimarilyAppropriate]                
      ,[AffectRestricted]                
      ,[AffectBlunted]                
      ,[AffectFlattened]                
      ,[AffectDetached]                
      ,[AffectPrimarilyInappropriate]                
      ,[AffectOther]                
      ,[AffectComment]                
      ,[SpeechAddToNeedsList]                
      ,[SpeechNormal]                
      ,[SpeechLogicalCoherent]                
      ,[SpeechTangential]                
      ,[SpeechSparseSlow]                
      ,[SpeechRapidPressured]                
      ,[SpeechSoft]                
      ,[SpeechCircumstantial]                
      ,[SpeechLoud]                
      ,[SpeechRambling]                
      ,[SpeechOther]                
      ,[SpeechComment]                
      ,[ThoughtAddToNeedsList]                
      ,[ThoughtUnremarkable]                
      ,[ThoughtParanoid]                
      ,[ThoughtGrandiose]                
      ,[ThoughtObsessive]                
      ,[ThoughtBizarre]                
      ,[ThoughtFlightOfIdeas]                
      ,[ThoughtDisorganized]                
      ,[ThoughtAuditoryHallucinations]                
      ,[ThoughtVisualHallucinations]                
      ,[ThoughtTactileHallucinations]                
      ,[ThoughtOther]                
      ,[ThoughtComment]                
      ,[BehaviorAddToNeedsList]                
      ,[BehaviorNormal]                
      ,[BehaviorRestless]                
      ,[BehaviorTremors]                
      ,[BehaviorPoorEyeContact]                
      ,[BehaviorAgitated]                
      ,[BehaviorPeculiar]                
      ,[BehaviorSelfDestructive]                
      ,[BehaviorSlowed]                
      ,[BehaviorDestructiveToOthers]                
      ,[BehaviorCompulsive]                
      ,[BehaviorOther]                
      ,[BehaviorComment]                
      ,[OrientationAddToNeedsList]                
      ,[OrientationToPersonPlaceTime]                
      ,[OrientationNotToPerson]                
      ,[OrientationNotToPlace]                
      ,[OrientationNotToTime]                
      ,[OrientationOther]                
      ,[OrientationComment]                
      ,[InsightAddToNeedsList]                
      ,[InsightGood]                
     ,[InsightFair]                
      ,[InsightPoor]                
      ,[InsightLacking]                
      ,[InsightOther]                
      ,[InsightComment]                
      ,[MemoryAddToNeedsList]                
      ,[MemoryGoodNormal]                
      ,[MemoryImpairedShortTerm]                
      ,[MemoryImpairedLongTerm]                
      ,[MemoryOther]                
      ,[MemoryComment]                
      ,[RealityOrientationAddToNeedsList]                
      ,[RealityOrientationIntact]                
      ,[RealityOrientationTenuous]                
      ,[RealityOrientationPoor]                
      ,[RealityOrientationOther]                
      ,[RealityOrientationComment]                
      ,CMS.[CreatedBy]                
      ,CMS.[CreatedDate]                
      ,CMS.[ModifiedBy]                
      ,CMS.[ModifiedDate]                
      ,[RecordDeleted]                
      ,[DeletedDate]                
      ,[DeletedBy]                
  FROM CustomMentalStatuses2 CMS                                          
     WHERE (ISNULL(CMS.RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)               
     -------CustomHRMAssessmentNeeds                
     -------Added By Ashwani Kumar Angrish                
     -------June 11 2010                
     select HRMAssessmentNeedId,DocumentVersionId,HRMNeedId,NeedName,NeedStatus,NeedDate,NeedDescription,                
     ClientNeedId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,                
     DeletedDate,DeletedBy from CustomHRMAssessmentNeeds where (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                 
                
--DiagnosesIIICodes     
 SELECT DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy  
         
 FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode         
 WHERE (DIIICod.DocumentVersionId = @LatestDocumentVersionID) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')                                                                       
                  
End
' 
END
GO
