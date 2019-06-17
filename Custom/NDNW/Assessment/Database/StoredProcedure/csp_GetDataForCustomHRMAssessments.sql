IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_GetDataForCustomHRMAssessments')
	BEGIN
		DROP  Procedure  csp_GetDataForCustomHRMAssessments
	END

GO
Create  Procedure [dbo].[csp_GetDataForCustomHRMAssessments]      
(                                                                                                                                                                                                                                          
  @DocumentVersionId int                                                                                                                               
)                                                                                                                                                                                                                                          
As                                                                                                                                                                                      
                                                                                                                                                                                    
/*********************************************************************/                                                                                                                                                                                        
/* Stored Procedure: dbo.csp_GetDataForCustomHRMAssessments                */                                                                                                                                                                                  
  
    
      
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                                                        
/* Creation Date:  03 April,2010                                       */                                                                                                                                                                                      
  
/*                                                                   */                                                                                                                                                                                        
/* Purpose:  Get Data for CustomHRMAssessments Pages */                                                                                                                                                                                      
/*                                                                   */                                                                                                                                                                                      
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                                                                      
/*                                                                   */                                                                                                                                                                                        
/* Output Parameters:   None                   */                                                                                                                                                                                        
/*                                                                   */                                        
/* Return:  0=success, otherwise an error number             */             
/*   */          
/* Called By:        */                     
/* */                             
/* Calls:         */                                                                  
/*                         */                                                                           
/* Data Modifications:                   */                                                                                                        
/*      */                                                                                                                                       
/* Updates:               */                                                                                                                                
/*   Date     Author             Purpose                             */                                                                                                           
    
 /* Hemant     3/5/2015     Added three tables CustomDocumentCSSRSAdultScreeners,CustomDocumentCSSRSAdultSinceLastVisits,CustomDocumentCSSRSChildSinceLastVisits why:955.2 Valley - Customizations*/  
 /* SuryaBalan  6-April-2015 Task 955.3 Valley - Customizations- Update Safety/Crisis Plan in Assessment. Added these 
       [InitialSafetyPlan],
       [InitialCrisisPlan],
       [SafetyPlanNotReviewed]
	  ,[ReviewCrisisPlanXDays]
	  ,[NextCrisisPlanReviewDate]   */            
                                                                                                                                                                                  
/*********************************************************************/                                                                                                                                                                                   
                                                                                                                                                                                  
                                                                                                                                                     
BEGIN                                                                                                                                        
declare @later datetime                                                    
set @later  = GETDATE()                                                                                                                                                        
declare @ClientId int                                                                                                                                                         
                                                                                                                                                        
                                                                                                                                                          
select @ClientId = ClientId from Documents where                                                                                                                                                         
 InProgressDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N'                                                                          
                                                                         
                          
declare @LatestDocumentVersionID int                                                      
declare @clientName varchar(100)  
declare @MaritalStatus varchar(100)                                                                                                            
declare @EmploymentStatus varchar(100)                                                                                                            
                                                                                                    
declare @clientDOB varchar(10)                                                                                                                                                                                    
declare @clientAge varchar(50)                                      
declare @InitialRequestDate datetime                                
-- For GuardianTypeText                              
declare @GuardianTypeText varchar(250)                              
                                                                  
 Declare @CafasURL varchar(1024)                            
 set @CafasURL= (Select CafasURL from CustomConfigurations)                                                                                              
                                                                                                
set @clientName = (Select C.LastName + ', ' + C.FirstName as ClientName from Clients C                                                                              
    where C.ClientId=@ClientID and IsNull(C.RecordDeleted,'N')='N')                                                                                                                   
set @clientDOB = (Select CONVERT(VARCHAR(10), DOB, 101) from Clients                                                   
    where ClientId=@ClientID and IsNull(RecordDeleted,'N')='N')            
   
SELECT @MaritalStatus=dbo.csf_GetGlobalCodeNameById(c.MaritalStatus) 
  ,@EmploymentStatus=dbo.csf_GetGlobalCodeNameById(c.EmploymentStatus) 
  FROM Documents D 
  JOIN Clients C ON D.ClientId = C.ClientId  
   AND isnull(C.RecordDeleted, 'N') <> 'Y'  
  WHERE D.InProgressDocumentVersionId =@DocumentVersionId   
   AND isnull(D.RecordDeleted, 'N') = 'N'
   
                                                                                 
Exec csp_CalculateAge @ClientId, @clientAge out                    
                                                                      
                                                
set @InitialRequestDate=(Select Top 1 InitialRequestDate from ClientEpisodes CP where CP.ClientId=@ClientID                                                
and IsNull(Cp.RecordDeleted,'N')='N' and IsNull(CP.RecordDeleted,'N')='N' order by CP.InitialRequestDate desc)                                                 
                                
                                                                                                                                 
   BEGIN TRY                                                                     
    -----For CustomHRMAssessments-----                                                                                                                                                                                
   SELECT                                                              
       [DocumentVersionId]                                          
      ,[ClientName]                                          
      ,[AssessmentType]                                          
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
      ,[RapCiDomainComment]                                          
      ,[RapCiDomainNeedsList]                                          
      ,[RapCbDomainIntensity]                                         
      ,[RapCbDomainComment]                      
      ,[RapCbDomainNeedsList]                                          
      ,[RapCaDomainIntensity]                                          
      ,[RapCaDomainComment]                                          
      ,[RapCaDomainNeedsList]                                          
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
      ,[PrePlanSeparateDocument]                                          
      ,[CommunityActivitiesCurrentDesired]                                          
      ,[CommunityActivitiesIncreaseDesired]                                          
      ,[CommunityActivitiesNeedsList]                                          
      ,[PsCurrentHealthIssues]                                          
      ,[PsCurrentHealthIssuesComment]                                          
      ,[PsCurrentHealthIssuesNeedsList]                                          
      ,[HistMentalHealthTx]                                          
      ,[HistMentalHealthTxNeedsList]                                          
      ,[HistMentalHealthTxComment]                                          
      ,[HistFamilyMentalHealthTx]                                          
      ,[HistFamilyMentalHealthTxNeedsList]                                          
      ,[HistFamilyMentalHealthTxComment]                          
      ,[PsClientAbuseIssues]                                          
      ,[PsClientAbuesIssuesComment]                                          
      ,[PsClientAbuseIssuesNeedsList]                                          
      ,[PsFamilyConcernsComment]                                          
      ,[PsRiskLossOfPlacement]                                          
      ,[PsRiskLossOfPlacementDueTo]                                          
      ,[PsRiskSensoryMotorFunction]                                          
      ,[PsRiskSensoryMotorFunctionDueTo]                                          
      ,[PsRiskSafety]                                          
      ,[PsRiskSafetyDueTo]                                          
      ,[PsRiskLossOfSupport]                                          
      ,[PsRiskLossOfSupportDueTo]                                          
      ,[PsRiskExpulsionFromSchool]                                          
  ,[PsRiskExpulsionFromSchoolDueTo]                                          
      ,[PsRiskHospitalization]                                          
      ,[PsRiskHospitalizationDueTo]                                          
      ,[PsRiskCriminalJusticeSystem]                           
      ,[PsRiskCriminalJusticeSystemDueTo]                                          
      ,[PsRiskElopementFromHome]                                          
      ,[PsRiskElopementFromHomeDueTo]                                          
      ,[PsRiskLossOfFinancialStatus]                                          
      ,[PsRiskLossOfFinancialStatusDueTo]                                          
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
      ,[PsFunctioningConcernComment]                                          
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
      ,[SuicideCurrent]                                          
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
      ,[HomicideCurrent]                                          
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
      ,[RiskOtherFactorsNone]                     
      ,[RiskOtherFactors]                                          
      ,[RiskOtherFactorsNeedsList]                                          
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
      ,[UncopeCompleteFullSUAssessment]                        
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
      ,[YouthTotalScore]                                          
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
      ,[PsMedicationsListToBeModified]                                          
      ,[PhysicalConditionQuadriplegic]                                          
      ,[PhysicalConditionMultipleSclerosis]                                          
      ,[PhysicalConditionBlindness]                                          
      ,[PhysicalConditionDeafness]                                          
      ,[PhysicalConditionParaplegic]                                          
      ,[PhysicalConditionCerebral]                                      
      ,[PhysicalConditionMuteness]                                          
      ,[PhysicalConditionOtherHearingImpairment]                                          
      ,[TestingReportsReviewed]                                          
      ,C.[LOCId]                                          
      ,SevereProfoundDisability                                        
      ,SevereProfoundDisabilityComment                                       
      ,EmploymentStatus                                   
      ,DxTabDisabled                                        
      --,C.RowIdentifier                                          
      ,C.CreatedBy                                          
      ,C.CreatedDate                                          
      ,C.ModifiedBy                                          
      ,C.ModifiedDate                                          
      ,C.RecordDeleted                             
      ,C.DeletedDate                                          
      ,C.DeletedBy                                          
      ,InitialRequestDate                     
   ,@clientAge as clientAge                                
   ,G.CodeName as GuardianTypeText                       
   ,@CafasURL as CafasURL                                  
  ,locat.LOCCategoryName + ' / ' + loc.LOCName as LevelOfCare  -- need to add CustomLOCs.LOCName                  
   ,locat.DeterminationDescription                   
   ,loc.[Description]                  
   ,loc.ADTCriteria                  
   ,loc.ProviderQualifications     
     ,PsMedicationsSideEffects        
,AutisticallyImpaired        
,CognitivelyImpaired        
,EmotionallyImpaired        
,BehavioralConcern        
,LearningDisabilities        
,PhysicalImpaired        
,IEP        
,ChallengesBarrier        
,UnProtectedSexualRelationMoreThenOnePartner        
,SexualRelationWithHIVInfected        
,SexualRelationWithDrugInject        
,InjectsDrugsSharedNeedle        
,ReceivedAnyFavorsForSexualRelation        
,FamilyFriendFeelingsCausedDistress        
,FeltNervousAnxious        
,NotAbleToStopWorrying        
,StressPeoblemForHandlingThing        
,SocialAndEmotionalNeed        
,DepressionAnxietyRecommendation        
,CommunicableDiseaseRecommendation        
,PleasureInDoingThings        
,DepressedHopelessFeeling        
,AsleepSleepingFalling        
,TiredFeeling        
,OverEating        
,BadAboutYourselfFeeling        
,TroubleConcentratingOnThings        
,SpeakingSlowlyOrOpposite        
,BetterOffDeadThought        
,DifficultProblem   
,SexualityComment  
,ReceivePrenatalCare  
,ReceivePrenatalCareNeedsList  
,ProblemInPregnancy  
,ProblemInPregnancyNeedsList  
,WhenTheyTalk  
,DevelopmentalAttachmentComments  
,PrenatalExposer  
,PrenatalExposerNeedsList  
,WhereMedicationUsed  
,WhereMedicationUsedNeedsList  
,IssueWithDelivery  
,IssueWithDeliveryNeedsList  
,ChildDevelopmentalMilestones  
,ChildDevelopmentalMilestonesNeedsList  
,TalkBefore  
,TalkBeforeNeedsList  
,ParentChildRelationshipIssue  
,ParentChildRelationshipNeedsList  
,FamilyRelationshipIssues  
,FamilyRelationshipNeedsList  
,WhenTheyTalkSentences    
,WhenTheyTalkSentenceUnknown  
,WhenTheyTalkUnknown  
,WhenTheyWalkUnknown  
,AddSexualitytoNeedList  
,WhenTheyWalk   
,ClientInAutsimPopulation  
,LegalIssues  
,CSSRSAdultOrChild  
,Strengths
,TransitionLevelOfCare
,ReductionInSymptoms
,AttainmentOfHigherFunctioning
,TreatmentNotNecessary
,OtherTransitionCriteria
,EstimatedDischargeDate
,ReductionInSymptomsDescription
,AttainmentOfHigherFunctioningDescription
,TreatmentNotNecessaryDescription
,OtherTransitionCriteriaDescription
,DepressionPHQToNeedList   
,PsRiskHigherLevelOfCare
,PsRiskHigherLevelOfCareDueTo
,PsRiskOutOfCountryPlacement
,PsRiskOutOfCountryPlacementDueTo
,PsRiskOutOfHomePlacement
,PsRiskOutOfHomePlacementDueTo
,CommunicableDiseaseAssessed
,CommunicableDiseaseFurtherInfo         
  FROM CustomHRMAssessments  C                       
   left outer JOIN  GlobalCodes G ON C.GuardianType = G.GlobalCodeId                     
   left outer join  CustomLOCs loc on loc.LOCId =C.LOCId                  
  left outer join CustomLOCCategories locat on locat.LOCCategoryId = loc.LOCCategoryId                  
  where (ISNULL(C.RecordDeleted, 'N') = 'N') AND (C.DocumentVersionId = @DocumentVersionId)                        
  AND IsNull(G.RecordDeleted,'N')='N'                         
                                                                                
                             
           
  --SELECT DailyLivingActivityScoreId               
  --    ,[DocumentVersionId]                                                                                                                                    
  --    ,[HRMActivityId]                                                                           
  --    ,[ActivityScore]                                                          
  --    ,[ActivityComment]                                                                                                                                    
  --    --,[RowIdentifier]                                                                                                  
  --    ,[CreatedBy]                                          
  --    ,[CreatedDate]                                                                                                                   
  --    ,[ModifiedBy]                                                                                                               
  --    ,[ModifiedDate]                                              
  --    ,[RecordDeleted]                                                                                                                                    
  --    ,[DeletedDate]                                                                        
  --    ,[DeletedBy]                                                                                                                                    
  --FROM CustomDailyLivingActivityScores                                                                                                                                    
  --WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                                    
                                                                                    
   --- CustomSubstanceUseAssessments ----                                                                                                                
    select  [DocumentVersionId]                                          
      ,[VoluntaryAbstinenceTrial]                                          
      ,[Comment]                                          
      ,[HistoryOrCurrentDUI]                                          
      ,[NumberOfTimesDUI]                                          
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
      ,[SubstanceAbuseAdmittedOrSuspected]                  
      ,[ClientSAHistory]                                          
      ,[FamilySAHistory]                                          
      ,[NoSubstanceAbuseSuspected]                                          
      ,[DUI30Days]                              
      ,[DUI5Years]                                          
      ,[DWI30Days]                                          
      ,[DWI5Years]                                          
      ,[Possession30Days]                                          
      ,[Possession5Years]                                          
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
      --,cs.[RowIdentifier]                                                                                                                                  
      ,cs.[CreatedBy]                                                                                                                
      ,cs.[CreatedDate]                                                                                                         
      ,cs.[ModifiedBy]                                                
      ,cs.[ModifiedDate]                                                                                                                          
      ,cs.[RecordDeleted]                                                   
      ,cs.[DeletedDate]                                                                                                                                                
      ,cs.[DeletedBy]          
      ,cs.[PreviousMedication]        
      ,cs.[CurrentSubstanceAbuseMedication]   
      ,cs.[MedicationAssistedTreatment]
      ,cs.[MedicationAssistedTreatmentRefferedReason]
                       
  FROM CustomSubstanceUseAssessments cs                                                                                                                                                                                   
  WHERE (ISNULL(cs.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                           
                                        
                                                                            
                                                                            
--End of Custom Substance Use Assessments                                                                                                                                            
   ---CustomSubstanceUseHistory2---                                                                                                                
  SELECT [SubstanceUseHistoryId]                                                                                                                        
      ,[DocumentVersionId]                                                                                                                
      ,[SUDrugId]                                                                                                                               
      ,[AgeOfFirstUse]                                                                     
      ,[Frequency]                                                                                        
      ,[Route]                                                       
      ,[LastUsed]                                                                                                                                    
      ,[InitiallyPrescribed]                                                                                                                                    
      ,[Preference]                                                                                                                                    
      ,[FamilyHistory]                                                                                                            
      --,[RowIdentifier]                                                                                                                      
      ,[CreatedBy]                                                                                                                                    
      ,[CreatedDate]                                                                                         
      ,[ModifiedBy]                                                                                         
      ,[ModifiedDate]                                               
      ,[RecordDeleted]                                                                                                                                    
      ,[DeletedDate]                                                        
      ,[DeletedBy]                                                                                                                                    
  FROM CustomSubstanceUseHistory2                                                                                                                                    
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                               
                                                                                                                ---CustomHRMAssessmentLevelOfCareOptions---                                                                                                   
  
    
           
SELECT [HRMAssessmentLevelOfCareOptionId]                                                                                  
      ,[DocumentVersionId]                                                                                                                                            
      ,c.HRMLevelOfCareOptionId                                                                 
      ,[OptionSelected]                                                                                                                                            
      --,c.Rowidentifier                                                                                                                                            
      ,c.CreatedBy                                                                   
      ,c.CreatedDate                                                                                                          
      ,c.ModifiedBy                                                                                                                                            
      ,c.ModifiedDate                                                                 
      ,c.RecordDeleted                                                                               
      ,c.DeletedDate                                                                                                                                     
      ,c.DeletedBy                                                                                                                              
 ,ServiceChoiceLabel                                                          
  FROM CustomHRMAssessmentLevelOfCareOptions c join CustomHRMLevelOfCareOptions                                                                                        
  on CustomHRMLevelOfCareOptions.HRMLevelOfCareOptionId = c.HRMLevelOfCareOptionId                                                              
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CustomHRMLevelOfCareOptions.RecordDeleted,'N')='N'   AND ISNULL(c.RecordDeleted,'N')='N'                                                           
                                       
                                                                                                                                          
  ---CustomOtherRiskFactors---                                                                                                                  
 SELECT [OtherRiskFactorId]                                                                                                                                        
     ,[DocumentVersionId]                                                                                                                                        
      ,[OtherRiskFactor]                                                                             
      --,c.[RowIdentifier]                                                                                                                                        
      ,c.[CreatedBy]                                                                                                                                        
      ,c.[CreatedDate]                                                                                                        
      ,c.[ModifiedBy]                                                                                                                                    
      ,c.[ModifiedDate]                                                                                                                
      ,c.[RecordDeleted]                                                                                                                                        
      ,c.[DeletedDate]                                                                                                   
      ,c.[DeletedBy]                                                             
      ,CodeName                                             
  FROM CustomOtherRiskFactors c join GlobalCodes                                                                
  on GlobalCodes.GlobalCodeId = c.OtherRiskFactor                                    
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GlobalCodes.RecordDeleted,'N')='N'   AND ISNULL(c.RecordDeleted,'N')='N'                                                                                          
                                                                                        
 ---CustomHRMAssessmentSupports2 ---                                                         
  SELECT [HRMAssessmentSupportId]                                                                                                                                      
      ,[DocumentVersionId]                                                                                                       
      ,[SupportDescription]                                                                                                                                      
      ,[Current]                                                                  
      ,[PaidSupport]                                                                                                                                      
      ,[UnpaidSupport]                                                                                                    
     ,[ClinicallyRecommended]                                                                                             
      ,[CustomerDesired]                                                                                                
      --,[RowIdentifier]                                                                                                   
      ,[CreatedBy]                                                           
      ,[CreatedDate]                          
      ,[ModifiedBy]                                         
      ,[ModifiedDate]                                                         
      ,[RecordDeleted]                                                                                                                                      
      ,[DeletedDate]                                              
      ,[DeletedBy]                                  
  FROM CustomHRMAssessmentSupports2                                                                                               
  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                                      
                                                                   
                                                                   
---CustomCAFAS2---                                                                                                                        
 -- SELECT [DocumentVersionId]                                                                                               
 --     ,[CAFASDate]                                                                                                                                    
 --,[RaterClinician]                             
 --     ,[CAFASInterval]                                                                                                                                    
 --     ,[SchoolPerformance]                                                                                                                                    
 --     ,[SchoolPerformanceComment]                                                                                                                  
 --     ,[HomePerformance]                                                                                   
 --     ,[HomePerfomanceComment]                                        
 --     ,[CommunityPerformance]                                                                                                                                    
 --     ,[CommunityPerformanceComment]                         
 --     ,[BehaviorTowardsOther]                                                                                                                               
 --     ,[BehaviorTowardsOtherComment]                                                                                                                                    
 --     ,[MoodsEmotion]                                                           
 --     ,[MoodsEmotionComment]                                                     
 --     ,[SelfHarmfulBehavior]                                                                                                                              
 --     ,[SelfHarmfulBehaviorComment]                                                                  
 --     ,[SubstanceUse]                                                                                     
 --     ,[SubstanceUseComment]                                                                                                    
 --     ,[Thinkng]                                                                        
 --     ,[ThinkngComment]                                                         
 --     ,[YouthTotalScore]                                                                                                                                 
 --     ,[PrimaryFamilyMaterialNeeds]                                                                        
 --     ,[PrimaryFamilyMaterialNeedsComment]                                             
 --     ,[PrimaryFamilySocialSupport]                                                                                   
 --     ,[PrimaryFamilySocialSupportComment]                                                                                                                                    
 --     ,[NonCustodialMaterialNeeds]                                                                                                               
 --     ,[NonCustodialMaterialNeedsComment]                
 --     ,[NonCustodialSocialSupport]                                                                                                                      
 --     ,[NonCustodialSocialSupportComment]                                                                                           
 --     ,[SurrogateMaterialNeeds]                                                                                                                                    
 --     ,[SurrogateMaterialNeedsComment]                                                                                                
 --     ,[SurrogateSocialSupport]                                                                                                                                    
 --     ,[SurrogateSocialSupportComment]                                                                                                                                    
 --     ,[CreatedDate]                                                        
 --     ,[CreatedBy]                                                                                                      
 --     ,[ModifiedDate]                                                                                                 
 --     ,[ModifiedBy]                         
 --     ,[RecordDeleted]                                                                                                                                    
 --     ,[DeletedDate]                                                                                                                                    
 --     ,[DeletedBy]                                                    
 -- FROM CustomCAFAS2          
 -- WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                    
                                                                   
                                                                   
                                                                                                         
   -- CustomHRMAssessmentRAPScores--                                              
  --     SELECT [HRMAssessmentRAPQuestionId]                                             
  --    ,[DocumentVersionId]                                                                                          
  --    ,[HRMRAPQuestionId]                                                                                          
  --    ,[RAPAssessedValue]                                       
  --    ,[AddToNeedsList]                                                                 
  --    --,[RowIdentifier]                                                                                          
  --    ,[CreatedBy]                                                           
  --    ,[CreatedDate]                                                                                          
  --    ,[ModifiedBy]                                                    
  --    ,[ModifiedDate]                                                                                 
  --    ,[RecordDeleted]                                                                                          
  --    ,[DeletedDate]                                                                                          
  -- ,[DeletedBy]                                                                                          
  --FROM CustomHRMAssessmentRAPScores                                                                                           
  -- WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                              
                                                                     
                                           
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
      --,[RowIdentifier]                                                                           
      ,CMS.[CreatedBy]                                                                                      
      ,CMS.[CreatedDate]                                                                                      
      ,CMS.[ModifiedBy]                                                                                      
      ,CMS.[ModifiedDate]                                                                                      
      ,[RecordDeleted]         
      ,[DeletedDate]                                                                                      
      ,[DeletedBy]                       
    FROM CustomMentalStatuses2 CMS                                           
    WHERE (ISNULL(CMS.RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                       
                                                             
     --- CustomHRMAssessmentNeeds ---                                                                                               
     --select HRMAssessmentNeedId,DocumentVersionId,HRMNeedId,NeedName,NeedStatus,NeedDate,HRM.NeedDescription,                                                                                              
     --HRM.ClientNeedId,        
     ----HRM.RowIdentifier,        
     --HRM.CreatedBy,HRM.CreatedDate,HRM.ModifiedBy,HRM.ModifiedDate,HRM.RecordDeleted,                            
     --HRM.DeletedDate,HRM.DeletedBy                                                                
     --from CustomHRMAssessmentNeeds  HRM                                            
     --where (DocumentVersionId = @DocumentVersionId)               

  --CustomDocumentCraffts For Kalamazoo--          
  SELECT DocumentVersionId,          
  CreatedBy,          
  CreatedDate,          
  ModifiedBy,          
  ModifiedDate,          
  RecordDeleted,          
  DeletedBy,          
  DeletedDate,          
  CrafftApplicable,          
  CrafftApplicableReason,     
  CrafftQuestionC,          
  CrafftQuestionR,          
  CrafftQuestionA,          
  CrafftQuestionF,          
  CrafftQuestionFR,          
  CrafftQuestionT,          
  CrafftCompleteFullSUAssessment,          
  CrafftStageOfChange          
  From CustomDocumentCRAFFTs          
  WHERE (ISNULL(RecordDeleted, 'N') = 'N')           
  AND (DocumentVersionId = @DocumentVersionId)                          
                   
 --- CustomDispositions            
  SELECT            
  CustomDispositionId,            
  CreatedBy,            
  CreatedDate,            
  ModifiedBy,            
  ModifiedDate,            
  RecordDeleted,            
  DeletedBy,            
  DeletedDate,           
  InquiryId,          
  DocumentVersionId,          
  Disposition from CustomDispositions           
  WHERE ISNULL(RecordDeleted, 'N') = 'N'          
  AND DocumentVersionId = @DocumentVersionId          
           
  --- CustomServiceDispositions            
  SELECT            
  CustomServiceDispositionId,            
  csd.CreatedBy,            
  csd.CreatedDate,            
  csd.ModifiedBy,            
  csd.ModifiedDate,            
  csd.RecordDeleted,            
  csd.DeletedBy,            
  csd.DeletedDate,           
  csd.ServiceType,          
  csd.CustomDispositionId           
  FROM          
  CustomServiceDispositions AS csd JOIN CustomDispositions AS cd ON csd.CustomDispositionId = cd.CustomDispositionId           
  WHERE ISNULL(csd.RecordDeleted, 'N') = 'N'           
  AND cd.DocumentVersionId = @DocumentVersionId          
            
  --- CustomProviderServices            
  SELECT           
  CustomProviderServiceId,            
  cps.CreatedBy,            
  cps.CreatedDate,            
  cps.ModifiedBy,            
  cps.ModifiedDate,            
  cps.RecordDeleted,            
  cps.DeletedBy,            
  cps.DeletedDate,           
  cps.ProgramId,          
  cps.CustomServiceDispositionId          
  FROM CustomProviderServices AS cps           
  JOIN CustomServiceDispositions AS csd ON cps.CustomServiceDispositionId = csd.CustomServiceDispositionId          
  JOIN CustomDispositions AS cd ON csd.CustomDispositionId = cd.CustomDispositionId          
  WHERE ISNULL(cps.RecordDeleted, 'N') = 'N'           
  AND cd.DocumentVersionId = @DocumentVersionId          
            
  SELECT        b.DocumentVersionId ,            
                b.Dimension1LevelOfCare ,            
                b.Dimension1Need ,            
                b.Dimension2LevelOfCare ,            
                b.Dimension2Need ,            
                b.Dimension3LevelOfCare ,            
                b.Dimension3Need ,            
                b.Dimension4LevelOfCare ,            
                b.Dimension4Need ,            
                b.Dimension5LevelOfCare ,            
                b.Dimension5Need ,            
                b.Dimension6LevelOfCare ,            
                b.Dimension6Need ,            
                b.SuggestedPlacement ,            
                b.FinalPlacement ,            
                b.FinalPlacementComment ,            
                b.CreatedBy,          
                b.CreatedDate,            
    b.ModifiedBy,            
       b.ModifiedDate,           
                --b.RowIdentifier ,            
                b.RecordDeleted ,            
                b.DeletedDate ,            
                b.DeletedBy          
                FROM   CustomASAMPlacements b            
    WHERE ISNULL(RecordDeleted, 'N') = 'N'           
    AND b.DocumentVersionId = @DocumentVersionId         
        
      --CustomDocumentAssessmentSubstanceUses--    
  SELECT      
   DocumentVersionId      
  ,CreatedBy      
  ,CreatedDate      
  ,ModifiedBy      
  ,ModifiedDate      
  ,RecordDeleted      
  ,DeletedBy      
  ,DeletedDate      
  ,UseOfAlcohol      
  ,AlcoholAddToNeedsList      
  ,UseOfTobaccoNicotine      
  ,UseOfTobaccoNicotineQuit      
  ,UseOfTobaccoNicotineTypeOfFrequency      
  ,UseOfTobaccoNicotineAddToNeedsList      
  ,UseOfIllicitDrugs      
  ,UseOfIllicitDrugsTypeFrequency      
  ,UseOfIllicitDrugsAddToNeedsList      
  ,PrescriptionOTCDrugs      
  ,PrescriptionOTCDrugsTypeFrequency      
  ,PrescriptionOTCDrugsAddtoNeedsList      
  FROM CustomDocumentAssessmentSubstanceUses          
  WHERE ISNULL(RecordDeleted, 'N') = 'N'          
  AND DocumentVersionId = @DocumentVersionId          
                                                                        
                                                                                        
      Select       
   HRMAssessmentMedicationId,      
 CreatedBy,      
 CreatedDate,      
 ModifiedBy,      
 ModifiedDate,      
 RecordDeleted,      
 DeletedBy,      
 DeletedDate,      
 DocumentVersionId,      
 Name,      
 Dosage,      
 Purpose,      
 PrescribingPhysician      
 From      
    CustomHRMAssessmentMedications HM      
     WHERE ISNULL(RecordDeleted, 'N') = 'N'           
    AND HM.DocumentVersionId = @DocumentVersionId  
    
  --   --Select CustomFamilyHistory        
            
  --   SELECT          
  --  FamilyHistoryId,          
  --  CFH.CreatedBy,          
  --  CFH.CreatedDate,          
  --  CFH.ModifiedBy,          
  --  CFH.ModifiedDate,          
  --  CFH.RecordDeleted,          
  --  CFH.DeletedBy,          
  --  CFH.DeletedDate,          
  --  DocumentVersionId,          
  --  FamilyMemberType,          
  --  IsLiving,          
  --  CurrentAge,          
  --  CauseOfDeath,          
  --  Hypertension,          
  --  Hyperlipidemia,          
  --  Diabetes,          
  --  DiabetesType1,          
  --  DiabetesType2,          
  --  Alcoholism,          
  --  COPD,          
  --  Depression,          
  --  ThyroidDisease,          
  --  CoronaryArteryDisease,          
  --  Cancer,          
  --  CancerType,          
  --  Other,          
  --  OtherComment,      
  --  DiseaseConditionDXCode,      
  --  DiseaseConditionDXCodeDescription,              
  --  GC.CodeName AS FamilyMemberTypeText,          
  --  CASE WHEN IsLiving ='Y' THEN 'Yes' WHEN IsLiving ='N' THEN 'No' ELSE '' END AS IsLivingDesc,            
  --STUFF(  (          
  --   CASE WHEN Hypertension = 'Y' THEN ', Hypertension' ELSE '' END +           
  --   CASE WHEN Hyperlipidemia = 'Y' THEN ', Hyperlipidemia' ELSE '' END +          
  --   CASE WHEN Diabetes = 'Y' THEN ', Diabetes (' + CASE WHEN DiabetesType1 = 'Y' THEN 'Type1' ELSE '' END +           
  --     CASE WHEN DiabetesType2 = 'Y' THEN (CASE WHEN DiabetesType1 = 'Y' THEN ',' ELSE '' END) + ' Type2)' ELSE ')' END ELSE '' END +          
  --   CASE WHEN Other = 'Y' THEN ', Other( '+ CAST(OtherComment AS VARCHAR)+')' ELSE '' END +          
  --   CASE WHEN Alcoholism = 'Y' THEN ', Alcoholism' ELSE '' END +          
  --   CASE WHEN COPD = 'Y' THEN ', COPD' ELSE '' END +          
  --   CASE WHEN Depression = 'Y' THEN ', Depression' ELSE '' END +          
  --   CASE WHEN ThyroidDisease = 'Y' THEN ', Thyroid Disease' ELSE '' END +          
  --   CASE WHEN CoronaryArteryDisease = 'Y' THEN ', Coronary Artery Disease' ELSE '' END +          
  --   CASE WHEN Cancer = 'Y' THEN ', Cancer ('+GCC.CodeName +')' ELSE '' END           
  --  ),1,2,'')AS DiseaseCondition,          
  --  CASE WHEN IsLiving ='Y' THEN 'Yes' WHEN IsLiving ='N' THEN 'No' WHEN IsLiving ='U' THEN 'Unknown' ELSE '' END AS IsLivingValue           
  -- FROM CustomFamilyHistory CFH          
  -- LEFT JOIN GlobalCodes GC ON CFH.FamilyMemberType = GC.GlobalCodeId and ISNull(GC.RecordDeleted,'N')='N'           
  -- LEFT JOIN GlobalCodes GCC ON CFH.CancerType = GCC.GlobalCodeId    and ISNull(GCC.RecordDeleted,'N')='N'       
  -- WHERE DocumentVersionId  = @DocumentVersionId   and ISNull(CFH.RecordDeleted,'N')='N'       
  
   exec ssp_GetDocumentFamilyHistory @DocumentVersionId   
         
 --CustomDocumentPreEmploymentActivities--      
 --SELECT       
 -- DocumentVersionId      
 --,CreatedBy      
 --,CreatedDate      
 --,ModifiedBy      
 --,ModifiedDate      
 --,RecordDeleted      
 --,DeletedBy      
 --,DeletedDate      
 --,EducationTraining      
 --,EducationTrainingNeeds      
 --,EducationTrainingNeedsComments      
 --,PersonalCareerPlanning      
 --,PersonalCareerPlanningNeeds      
 --,PersonalCareerPlanningNeedsComments      
 --,EmploymentOpportunities      
 --,EmploymentOpportunitiesNeeds      
 --,EmploymentOpportunitiesNeedsComments      
 --,SupportedEmployment      
 --,SupportedEmploymentNeeds      
 --,SupportedEmploymentNeedsComments      
 --,WorkHistory      
 --,WorkHistoryNeeds      
 --,WorkHistoryNeedsComments      
 --,GainfulEmploymentBenefits      
 --,GainfulEmploymentBenefitsNeeds      
 --,GainfulEmploymentBenefitsNeedsComments      
 --,GainfulEmployment      
 --,GainfulEmploymentNeeds      
 --,GainfulEmploymentNeedsComments      
 --FROM CustomDocumentPreEmploymentActivities      
 --WHERE ISNULL(RecordDeleted, 'N') = 'N'               
 --   AND DocumentVersionId = @DocumentVersionId         
          
  SELECT [DocumentVersionId]      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedBy]      
      ,[DeletedDate]      
      ,[ClientHasCurrentCrisis]      
      ,[WarningSignsCrisis]      
      ,[CopingStrategies]      
      ,[ThreeMonths]      
      ,[TwelveMonths]      
      ,[DateOfCrisis]      
      ,[DOB]      
      ,[ProgramId]      
      ,[StaffId]      
      ,[SignificantOther]      
      ,[CurrentCrisisDescription]      
      ,[CurrentCrisisSpecificactions]  
      ,[InitialSafetyPlan]
	  ,[InitialCrisisPlan]
	  ,[SafetyPlanNotReviewed]
	  ,[ReviewCrisisPlanXDays]
	  ,[NextCrisisPlanReviewDate]
    
  FROM [CustomDocumentSafetyCrisisPlans]         
  WHERE ISNULL(RecordDeleted, 'N') = 'N'               
    AND DocumentVersionId = @DocumentVersionId      
          
  SELECT [SupportContactId]      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedBy]      
      ,[DeletedDate]      
      ,[DocumentVersionId]      
      ,[ClientContactId]      
      ,[Name]      
      ,[Relationship]      
      ,[Address]      
      ,[Phone]      
  FROM [CustomSupportContacts]      
  WHERE ISNULL(RecordDeleted, 'N') = 'N'               
    AND DocumentVersionId = @DocumentVersionId      
           
  SELECT [SafetyCrisisPlanReviewId]      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedBy]      
      ,[DeletedDate]      
      ,[DocumentVersionId]      
      ,[SafetyCrisisPlanReviewed]      
      ,[DateReviewed]      
      ,[ReviewEveryXDays]      
      ,[DescribePlanReview]      
      ,[CrisisDisposition]      
      ,CAST(ReviewEveryXDays as varchar(5)) + ' Days' AS [ReviewEveryDaysText]
      ,CrisisResolved
      ,CASE WHEN CrisisResolved ='Y' THEN 'Yes' WHEN CrisisResolved ='N' THEN 'No' ELSE '' END AS CrisisResolvedText  
      ,NextSafetyPlanReviewDate      
  FROM [CustomSafetyCrisisPlanReviews]      
WHERE ISNULL(RecordDeleted, 'N') = 'N'               
    AND DocumentVersionId = @DocumentVersionId      
          
  SELECT [CrisisPlanMedicalProviderId]      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedBy]      
      ,[DeletedDate]      
      ,[DocumentVersionId]      
      ,[Name]      
      ,[AddressType]      
      ,[Address]      
      ,[Phone]      
      ,(SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = AddressType) AS 'AddressTypeText'      
  FROM [CustomCrisisPlanMedicalProviders]        
  WHERE ISNULL(RecordDeleted, 'N') = 'N'               
    AND DocumentVersionId = @DocumentVersionId      
          
  SELECT [CrisisPlanNetworkProviderId]      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedBy]      
      ,[DeletedDate]      
      ,[DocumentVersionId]      
      ,[Name]      
      ,[AddressType]      
      ,[Address]      
      ,[Phone]      
      ,(SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = AddressType) AS 'AddressTypeText'      
  FROM [CustomCrisisPlanNetworkProviders]       
  WHERE ISNULL(RecordDeleted, 'N') = 'N'               
    AND DocumentVersionId = @DocumentVersionId     
     
    exec csp_SCGetCustomDocumentDLA20  @DocumentVersionId  
    exec ssp_SCGetDataDiagnosisNew  @DocumentVersionId   
    
     --CustomDocumentAdultLT
-- SELECT
-- DocumentVersionId,
--CreatedBy,
--CreatedDate,
--ModifiedBy,
--ModifiedDate,
--RecordDeleted,
--DeletedBy,
--DeletedDate,
--DeadDescription,
--DeadLifeTime,
--DeadPast1Month,
--NonSpecificDescription,
--NonSpecificLifeTime,
--NonSpecificPast1Month,
--ActiveSuicidalIdeationDescription,
--ActiveSuicidalIdeationLifeTime,
--ActiveSuicidalIdeationPast1Month,
--ASISomeIntentActDescription,
--ASILifeTime,
--ASIPast1Month,
--ASISpecificPlanAndIntentDescription,
--ASISPILifeTime,
--ASISPIPast1Month,
--LifeTimeMostSevere,
--MostSevereDescription,
--RecentMostSevere,
--RecentMostSevereDescription,
--FrequencyMostSevereOne,
--FrequencyMostSevereTwo,
--DurationMostSevereOne,
--DurationMostSevereTwo,
--ControllabilityMostSevereOne,
--ControllabilityMostSevereTwo,
--DeterrentsMostSevereOne,
--DeterrentsMostSevereTwo,
--ReasonsMostSevereOne,
--ReasonsMostSevereTwo,
--ActualAttemptDescription,
--SuicidalBehaviourLifeTime,
--SuicidalBehaviourAttemptNoOne,
--SelfInjuriesOne,
--SuicidalBehaviourPast3Monts,
--SuicidalBehaviourAttemptNoTwo,
--SelfInjuriesTwo,
--InterruptedAttemptDescription,
--InterruptedAttemptLifeTime,
--TotalNointerruptedOne,
--InterruptedAttemptPast3Months,
--TotalNoInterruptedTwo,
--AbortedDescription,
--AbortedLifeTime,
--AbortedPast3Months,
--AbortedOne,
--AbortedTwo,
--PreparatoryDescription,
--PreparatoryLifeTime,
--preparatoryOne,
--preparatoryPast3Months,
--preparatoryTwo,
--SuicidalBehaviorLifeTime,
--SuicidalBehaviorPast3Months,
--RecentAttemptDate,
--LethalAttemptDate,
--FirstAttemptDate,
--ActualLethality1,
--ActualLethality2,
--ActualLethality3,
--PotentialLethality1,
--PotentialLethality2,
--PotentialLethality3
--FROM CustomDocumentAdultLTs WHERE ISNULL(RecordDeleted, 'N') = 'N'               
--    AND DocumentVersionId = @DocumentVersionId
  
--  -- CustomDocumentChildLT
--  Select DocumentVersionId,
--CreatedBy,
--CreatedDate,
--ModifiedBy,
--ModifiedDate,
--RecordDeleted,
--DeletedBy,
--DeletedDate,
--DeadDescription,
--DeadLifeTime,
--DeadPast1Month,
--NonSpecificDescription,
--NonSpecificLifeTime,
--NonSpecificPast1Month,
--ActiveSuicidalIdeationDescription,
--ActiveSuicidalIdeationLifeTime,
--ActiveSuicidalIdeationPast1Month,
--ASISomeIntentActDescription,
--ASILifeTime,
--ASIPast1Month,
--ASISpecificPlanAndIntentDescription,
--ASISPILifeTime,
--ASISPIPast1Month,
--LifeTimeMostSevere,
--MostSevereDescription,
--RecentMostSevere,
--RecentMostSevereDescription,
--FrequencyMostSevereOne,
--FrequencyMostSevereTwo,
--ActualAttemptDescription,
--SuicidalBehaviourLifeTime,
--SuicidalBehaviourAttemptNoOne,
--SelfInjuriesOne,
--SuicidalBehaviourPast3Monts,
--SuicidalBehaviourAttemptNoTwo,
--SelfInjuriesTwo,
--InterruptedAttemptDescription,
--InterruptedAttemptLifeTime,
--TotalNoInterruptedOne,
--InterruptedAttemptPast3Months,
--TotalNoInterruptedTwo,
--AbortedDescription,
--AbortedLifeTime,
--AbortedPast3Months,
--AbortedOne,
--AbortedTwo,
--PreparatoryDescription,
--PreparatoryLifeTime,
--PreparatoryOne,
--PreparatoryPast3Months,
--PreparatoryTwo,
--SuicidalBehaviorLifeTime,
--SuicidalBehaviorPast3Months,
--RecentAttemptDate,
--LethalAttemptDate,
--FirstAttemptDate,
--ActualLethality1,
--ActualLethality2,
--ActualLethality3,
--PotentialLethality1,
--PotentialLethality2,
--PotentialLethality3,
--SelfInjuriesIntentOne,
--SelfInjuriesIntentTwo
--from CustomDocumentChildLTs Where ISNULL(RecordDeleted, 'N') = 'N'        
--  AND DocumentVersionId = @DocumentVersionId      
  
   --CarePlanNeeds  
 SELECT CPN.[CarePlanNeedId]  
  ,CPN.[CreatedBy]  
  ,CPN.[CreatedDate]  
  ,CPN.[ModifiedBy]  
  ,CPN.[ModifiedDate]  
  ,CPN.[RecordDeleted]  
  ,CPN.[DeletedBy]  
  ,CPN.[DeletedDate]  
  ,CPN.[DocumentVersionId]  
  ,CPN.[CarePlanDomainNeedId]  
  ,CPN.[NeedDescription]  
  ,CPN.[AddressOnCarePlan]  
  ,CPN.[Source]  
  ,CPD.[CarePlanDomainId]  
  ,CPDN.[NeedName]  
  ,CASE CPN.[Source]  
   WHEN 'C' THEN 'Care Plan'   
   END AS SourceName  
 FROM CarePlanNeeds CPN  
 JOIN CarePlanDomainNeeds CPDN ON CPDN.CarePlanDomainNeedId = CPN.CarePlanDomainNeedId  
 JOIN CarePlanDomains CPD ON CPD.CarePlanDomainId = CPDN.CarePlanDomainId  
 WHERE ISNull(CPN.RecordDeleted, 'N') = 'N'  
  AND CPN.DocumentVersionId = @DocumentVersionId  
     
 --For CarePlanDomains      
  SELECT CPD.[CarePlanDomainId]  
   ,CPD.[CreatedBy]  
   ,CPD.[CreatedDate]  
   ,CPD.[ModifiedBy]  
   ,CPD.[ModifiedDate]  
   ,CPD.[RecordDeleted]  
   ,CPD.[DeletedBy]  
   ,CPD.[DeletedDate]  
   ,CPD.[DomainName]  
  FROM CarePlanDomains AS CPD  
  WHERE ISNull(CPD.RecordDeleted, 'N') = 'N'  
  ORDER BY CPD.DomainName  
  
  --CarePlanDomainNeeds      
  SELECT CPDN.CarePlanDomainNeedId  
   ,CPDN.CreatedBy  
   ,CPDN.CreatedDate  
   ,CPDN.ModifiedBy  
   ,CPDN.ModifiedDate  
   ,CPDN.RecordDeleted  
   ,CPDN.DeletedBy  
   ,CPDN.DeletedDate  
   ,CPDN.NeedName  
   ,CPDN.CarePlanDomainId  
   ,CPDN.MHAFieldIdentifierCode  
   ,CPDN.MHANeedDescription  
  FROM CarePlanDomainNeeds AS CPDN  
  WHERE ISNull(CPDN.RecordDeleted, 'N') = 'N'
  
  --CustomDocumentCSSRSAdultScreeners
	--	SELECT CD.[DocumentVersionId]  
 --  ,CD.[CreatedBy]  
 --  ,CD.[CreatedDate]  
 --  ,CD.[ModifiedBy]  
 --  ,CD.[ModifiedDate]  
 --  ,CD.[RecordDeleted]  
 --  ,CD.[DeletedBy]  
 --  ,CD.[DeletedDate]  
 --  ,CD.[WishToBeDead]  
 --  ,CD.[SuicidalThoughts]  
 --  ,CD.[SuicidalThoughtsWithMethods]  
 --  ,CD.[SuicidalIntentWithoutSpecificPlan]  
 --  ,CD.[SuicidalIntentWithSpecificPlan]  
 --  ,CD.[SuicidalBehaviorQuestion]  
 --  ,CD.[HowLongAgoSuicidalBehavior]  
 -- FROM CustomDocumentCSSRSAdultScreeners CD  
 -- WHERE CD.[DocumentVersionId] = @DocumentVersionId  
 --  AND ISNULL(CD.[RecordDeleted], 'N') = 'N'  
   
 --  	--CustomDocumentCSSRSAdultSinceLastVisits
	--	SELECT DocumentVersionId
	--	,CreatedBy
	--	,CreatedDate
	--	,ModifiedBy
	--	,ModifiedDate
	--	,RecordDeleted
	--	,DeletedBy
	--	,DeletedDate
	--	,WishToBeDead
	--	,SuicidalThoughts
	--	,SuicidalThoughtsWithMethods
	--	,SuicidalIntentWithoutSpecificPlan
	--	,SuicidalIntentWithSpecificPlan
	--	,SuicidalBehaviorQuestion
	--FROM CustomDocumentCSSRSAdultSinceLastVisits
	--WHERE DocumentVersionId = @DocumentVersionId
	--	AND ISNULL(RecordDeleted, 'N') <> 'Y'
 -- --CustomDocumentCSSRSChildSinceLastVisits
 --     SELECT DocumentVersionId
	--	,[CreatedBy]
	--	,[CreatedDate]
	--	,ModifiedBy
	--	,ModifiedDate
	--	,RecordDeleted
	--	,DeletedBy
	--	,DeletedDate
	--	,WishToBeDead
	--	,WishToBeDeadDescription
	--	,NonSpecificActiveSuicidalThoughts
	--	,NonSpecificActiveSuicidalThoughtsDescription
	--	,ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct
	--	,ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription
	--	,ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan
	--	,ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription
	--	,AciveSuicidalIdeationWithSpecificPlanAndIntent
	--	,AciveSuicidalIdeationWithSpecificPlanAndIntentDescription
	--	,MostSevereIdeation
	--	,MostSevereIdeationDescription
	--	,Frequency
	--	,ActualAttempt
	--	,TotalNumberOfAttempts
	--	,ActualAttemptDescription
	--	,HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior
	--	,HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown
	--	,InterruptedAttempt
	--	,TotalNumberOfAttemptsInterrupted
	--	,InterruptedAttemptDescription
	--	,AbortedOrSelfInterruptedAttempt
	--	,TotalNumberAttemptsAbortedOrSelfInterrupted
	--	,AbortedOrSelfInterruptedAttemptDescription
	--	,PreparatoryActsOrBehavior
	--	,TotalNumberOfPreparatoryActs
	--	,PreparatoryActsOrBehaviorDescription
	--	,SuicidalBehavior
	--	,MostLethalAttemptDate
	--	,ActualLethalityMedicalDamage
	--	,PotentialLethality
	--FROM CustomDocumentCSSRSChildSinceLastVisits
	--WHERE DocumentVersionId = @DocumentVersionId
	--	AND ISNULL(RecordDeleted, 'N') <> 'Y'   
		
		
   SELECT 
   CDG.DocumentVersionId
       ,CDG.CreatedBy
       ,CDG.CreatedDate
       ,CDG.ModifiedBy
       ,CDG.ModifiedDate
       ,CDG.RecordDeleted
       ,CDG.DeletedBy
       ,CDG.DeletedDate
       ,CDG.GamblingDate
       ,CDG.TotalMonthlyHousehold
       ,CDG.HealthInsurance
       ,CDG.PrimarySourceOfIncome
       ,CDG.TotalNumberOfDependents
       ,CDG.LastGradeCompleted
       ,CDG.TotalEstimatedGamblingDebt
       ,CDG.LifeInGeneral
       ,CDG.OverallPhysicalHealth
       ,CDG.OverallEmotionalWellbeing
       ,CDG.RelationshipWithSpouse
       ,CDG.RelationshipWithFriends
       ,CDG.RelationshipWithOtherFamilyMembers
       ,CDG.RelationshipWithChildren
       ,CDG.Job
       ,CDG.School
       ,CDG.SpiritualWellbeing
       ,CDG.AccomplishedResponsibilitiesAtWork
       ,CDG.PaidBillsOnTime
       ,CDG.AccomplishedResponsibilitiesAtHome
       ,CDG.HaveThoughtsOfSuicide
       ,CDG.AttemptToCommitSuicide
       ,CDG.DrinkAlcohol
       ,CDG.ProblemsAssociatedWithAlcohol
       ,CDG.UseOfIllegalDrugs
       ,CDG.ProblemsAssociatedWithIllegalDrugs
       ,CDG.UseOfTobacco
       ,CDG.CommitIllegalActs
       ,CDG.MaintainSupportiveNetworkOfFamily
       ,CDG.TakeTimeToRelax
       ,CDG.EatHealthyFood
       ,CDG.Exercise
       ,CDG.AttendCommunitySupport
       ,CDG.ThinkingAboutGambling
       ,CDG.GamblingWithMoreMoney
       ,CDG.UnsuccessfulAttemptsToControlGambling
       ,CDG.RestlessOrIrritable
       ,CDG.GambleToEscapeFromProblems
       ,CDG.ReturningAfterLosingGamblingMoney
       ,CDG.LieToFamily
       ,CDG.GoBeyondLegalGambling
       ,CDG.LoseSignificantRelationship
       ,CDG.SeekHelpFromOthers
       ,CDG.NumberOfDaysGambled
       ,CDG.AverageAmountGambled
       ,CDG.PrimaryGamblingActivity
       ,CDG.PrimarilyGamblingPlace
       ,CDG.NumberOfTimesEnteredEmergencyRoom
       ,CDG.EnrolledInTreatmentProgramForAlcohol
       ,CDG.AlcoholInpatientAAndD
       ,CDG.AlcoholOutpatientAAndD
       ,CDG.EnrolledInTreatmentProgramForMentalHealth
       ,CDG.MentalHealthInpatientAAndD
       ,CDG.MentalHealthOutpatientAAndD
       ,CDG.EnrolledInAnotherGamblingProgram
       ,CDG.GamblingInpatientAAndD
       ,CDG.GamblingOutpatientAAndD
       ,CDG.FiledForBankruptcy
       ,CDG.ConvictedOfGambling
       ,CDG.ExperiencedPhysicalViolence
       ,CDG.AbuseInRelationship
       ,CDG.ControlloedManipulatedByOther
       ,'Marital Status: ' + @MaritalStatus as MaritalStatus
       ,'Employment Status: ' + @EmploymentStatus as EmploymentStatus
        FROM CustomDocumentGambling AS CDG  
  WHERE ISNULL(CDG.RecordDeleted, 'N') = 'N'               
    AND CDG.DocumentVersionId = @DocumentVersionId   
                                                            
 END TRY                                                                                                           
                        
 BEGIN CATCH                                                                                                                                                                                                                        
   DECLARE @Error varchar(8000)                                                                                                                                                                   
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                  
                                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetDataForCustomHRMAssessments')                                                                          
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                           
                                                                                     
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                 
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                                                                 
 END CATCH                                                                            
 End           