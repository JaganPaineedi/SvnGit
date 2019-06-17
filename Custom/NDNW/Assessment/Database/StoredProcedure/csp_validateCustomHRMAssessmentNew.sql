

/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMAssessmentNew]    Script Date: 01/16/2015 17:11:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMAssessmentNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHRMAssessmentNew]
GO


/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMAssessmentNew]    Script Date: 01/16/2015 17:11:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--Jay Wheeler CraftApplicableReason was changed from varchar(100) to Varchar(max).
--Hemant Included the DX validations.New Directions - Support Go Live #497    
CREATE PROCEDURE [dbo].[csp_validateCustomHRMAssessmentNew] @DocumentVersionId INT    
AS    
DECLARE @DocumentCodeId INT    
    
SET @DocumentCodeId = (    
  SELECT DocumentCodeId    
  FROM Documents    
  WHERE CurrentDocumentVersionId = @DocumentVersionId    
  )    
    
DECLARE @DocumentId INT    
    
SET @DocumentId = (    
  SELECT DocumentId    
  FROM Documents    
  WHERE CurrentDocumentVersionId = @DocumentVersionId    
  )    
    
--      
--Create Temp Tables      
--      
CREATE TABLE #CustomHRMAssessments (    
 DocumentVersionId INT    
 ,ClientName VARCHAR(150)    
 ,AssessmentType CHAR(1)    
 ,CurrentAssessmentDate DATETIME    
 ,PreviousAssessmentDate DATETIME    
 ,ClientDOB DATETIME    
 ,AdultOrChild CHAR(1)    
 ,ChildHasNoParentalConsent CHAR(1)    
 ,ClientHasGuardian CHAR(1)    
 ,GuardianName VARCHAR(150)    
 ,GuardianAddress VARCHAR(100)    
 ,GuardianPhone VARCHAR(50)    
 ,GuardianType INT    
 ,ClientInDDPopulation CHAR(1)    
 ,ClientInSAPopulation CHAR(1)    
 ,ClientInMHPopulation CHAR(1)    
 ,PreviousDiagnosisText VARCHAR(max)    
 ,ReferralType INT    
 ,PresentingProblem VARCHAR(max)    
 ,CurrentLivingArrangement INT    
 ,CurrentPrimaryCarePhysician VARCHAR(50)    
 ,ReasonForUpdate VARCHAR(max)    
 ,DesiredOutcomes VARCHAR(max)    
 ,PsMedicationsComment VARCHAR(max)    
 ,PsEducationComment VARCHAR(max)    
 ,IncludeFunctionalAssessment CHAR(1)    
 ,IncludeSymptomChecklist CHAR(1)    
 ,IncludeUNCOPE CHAR(1)    
 ,ClientIsAppropriateForTreatment CHAR(1)    
 ,SecondOpinionNoticeProvided CHAR(1)    
 ,TreatmentNarrative VARCHAR(max)    
 ,RapCiDomainIntensity VARCHAR(50)    
 ,RapCiDomainComment VARCHAR(max)    
 ,RapCiDomainNeedsList CHAR(1)    
 ,RapCbDomainIntensity VARCHAR(50)    
 ,RapCbDomainComment VARCHAR(max)    
 ,RapCbDomainNeedsList CHAR(1)    
 ,RapCaDomainIntensity VARCHAR(50)    
 ,RapCaDomainComment VARCHAR(max)    
 ,RapCaDomainNeedsList CHAR(1)    
 ,RapHhcDomainIntensity VARCHAR(50)    
 ,OutsideReferralsGiven CHAR(1)    
 ,ReferralsNarrative VARCHAR(max)    
 ,ServiceOther CHAR(1)    
 ,ServiceOtherDescription VARCHAR(100)    
 ,AssessmentAddtionalInformation VARCHAR(max)    
 ,TreatmentAccomodation VARCHAR(max)    
 ,Participants VARCHAR(max)    
 ,Facilitator VARCHAR(max)    
 ,TimeLocation VARCHAR(max)    
 ,AssessmentsNeeded VARCHAR(max)    
 ,CommunicationAccomodations VARCHAR(max)    
 ,IssuesToAvoid VARCHAR(max)    
 ,IssuesToDiscuss VARCHAR(max)    
 ,SourceOfPrePlanningInfo VARCHAR(max)    
 ,SelfDeterminationDesired CHAR(1)    
 ,FiscalIntermediaryDesired CHAR(1)    
 ,PamphletGiven CHAR(1)    
 ,PamphletDiscussed CHAR(1)    
 ,PrePlanIndependentFacilitatorDiscussed CHAR(1)    
 ,PrePlanIndependentFacilitatorDesired CHAR(1)    
 ,PrePlanGuardianContacted CHAR(1)    
 ,PrePlanSeparateDocument CHAR(1)    
 ,CommunityActivitiesCurrentDesired VARCHAR(max)    
 ,CommunityActivitiesIncreaseDesired CHAR(1)    
 ,CommunityActivitiesNeedsList CHAR(1)    
 ,PsCurrentHealthIssues CHAR(1)    
 ,PsCurrentHealthIssuesComment VARCHAR(max)    
 ,PsCurrentHealthIssuesNeedsList CHAR(1)    
 ,HistMentalHealthTx CHAR(1)    
 ,HistMentalHealthTxNeedsList CHAR(1)    
 ,HistMentalHealthTxComment VARCHAR(max)    
 ,HistFamilyMentalHealthTx CHAR(1)    
 ,HistFamilyMentalHealthTxNeedsList CHAR(1)    
 ,HistFamilyMentalHealthTxComment VARCHAR(max)    
 ,PsClientAbuseIssues CHAR(1)    
 ,PsClientAbuesIssuesComment VARCHAR(max)    
 ,PsClientAbuseIssuesNeedsList CHAR(1)    
 ,PsFamilyConcernsComment VARCHAR(max)    
 ,PsRiskLossOfPlacement CHAR(1)    
 ,PsRiskLossOfPlacementDueTo INT    
 ,PsRiskSensoryMotorFunction CHAR(1)    
 ,PsRiskSensoryMotorFunctionDueTo INT    
 ,PsRiskSafety CHAR(1)    
 ,PsRiskSafetyDueTo INT    
 ,PsRiskLossOfSupport CHAR(1)    
 ,PsRiskLossOfSupportDueTo INT    
 ,PsRiskExpulsionFromSchool CHAR(1)    
 ,PsRiskExpulsionFromSchoolDueTo INT    
 ,PsRiskHospitalization CHAR(1)    
 ,PsRiskHospitalizationDueTo INT    
 ,PsRiskCriminalJusticeSystem CHAR(1)    
 ,PsRiskCriminalJusticeSystemDueTo INT    
 ,PsRiskElopementFromHome CHAR(1)    
 ,PsRiskElopementFromHomeDueTo INT    
 ,PsRiskLossOfFinancialStatus CHAR(1)    
 ,PsRiskLossOfFinancialStatusDueTo INT    
 ,PsDevelopmentalMilestones CHAR(1)    
 ,PsDevelopmentalMilestonesComment VARCHAR(max)    
 ,PsDevelopmentalMilestonesNeedsList CHAR(1)    
 ,PsChildEnvironmentalFactors CHAR(1)    
 ,PsChildEnvironmentalFactorsComment VARCHAR(max)    
 ,PsChildEnvironmentalFactorsNeedsList CHAR(1)    
 ,PsLanguageFunctioning CHAR(1)    
 ,PsLanguageFunctioningComment VARCHAR(max)    
 ,PsLanguageFunctioningNeedsList CHAR(1)    
 ,PsVisualFunctioning CHAR(1)    
 ,PsVisualFunctioningComment VARCHAR(max)    
 ,PsVisualFunctioningNeedsList CHAR(1)    
 ,PsPrenatalExposure CHAR(1)    
 ,PsPrenatalExposureComment VARCHAR(max)    
 ,PsPrenatalExposureNeedsList CHAR(1)    
 ,PsChildMentalHealthHistory CHAR(1)    
 ,PsChildMentalHealthHistoryComment VARCHAR(max)    
 ,PsChildMentalHealthHistoryNeedsList CHAR(1)    
 ,PsIntellectualFunctioning CHAR(1)    
 ,PsIntellectualFunctioningComment VARCHAR(max)    
 ,PsIntellectualFunctioningNeedsList CHAR(1)    
 ,PsLearningAbility CHAR(1)    
 ,PsLearningAbilityComment VARCHAR(max)    
 ,PsLearningAbilityNeedsList CHAR(1)    
 ,PsFunctioningConcernComment VARCHAR(max)    
 ,PsPeerInteraction CHAR(1)    
 ,PsPeerInteractionComment VARCHAR(max)    
 ,PsPeerInteractionNeedsList CHAR(1)    
 ,PsParentalParticipation CHAR(1)    
 ,PsParentalParticipationComment VARCHAR(max)    
 ,PsParentalParticipationNeedsList CHAR(1)    
 ,PsSchoolHistory CHAR(1)    
 ,PsSchoolHistoryComment VARCHAR(max)    
 ,PsSchoolHistoryNeedsList CHAR(1)    
 ,PsImmunizations CHAR(1)    
 ,PsImmunizationsComment VARCHAR(max)    
 ,PsImmunizationsNeedsList CHAR(1)    
 ,PsChildHousingIssues CHAR(1)    
 ,PsChildHousingIssuesComment VARCHAR(max)    
 ,PsChildHousingIssuesNeedsList CHAR(1)    
 ,PsSexuality CHAR(1)    
 ,PsSexualityComment VARCHAR(max)    
 ,PsSexualityNeedsList CHAR(1)    
 ,PsFamilyFunctioning CHAR(1)    
 ,PsFamilyFunctioningComment VARCHAR(max)    
 ,PsFamilyFunctioningNeedsList CHAR(1)    
 ,PsTraumaticIncident CHAR(1)    
 ,PsTraumaticIncidentComment VARCHAR(max)    
 ,PsTraumaticIncidentNeedsList CHAR(1)    
 ,HistDevelopmental CHAR(1)    
 ,HistDevelopmentalComment VARCHAR(max)    
 ,HistResidential CHAR(1)    
 ,HistResidentialComment VARCHAR(max)    
 ,HistOccupational CHAR(1)    
 ,HistOccupationalComment VARCHAR(max)    
 ,HistLegalFinancial CHAR(1)    
 ,HistLegalFinancialComment VARCHAR(max)    
 ,SignificantEventsPastYear VARCHAR(max)    
 ,PsGrossFineMotor CHAR(1)    
 ,PsGrossFineMotorComment VARCHAR(max)    
 ,PsGrossFineMotorNeedsList CHAR(1)    
 ,PsSensoryPerceptual CHAR(1)    
 ,PsSensoryPerceptualComment VARCHAR(max)    
 ,PsSensoryPerceptualNeedsList CHAR(1)    
 ,PsCognitiveFunction CHAR(1)    
 ,PsCognitiveFunctionComment VARCHAR(max)    
 ,PsCognitiveFunctionNeedsList CHAR(1)    
 ,PsCommunicativeFunction CHAR(1)    
 ,PsCommunicativeFunctionComment VARCHAR(max)    
 ,PsCommunicativeFunctionNeedsList CHAR(1)    
 ,PsCurrentPsychoSocialFunctiion CHAR(1)    
 ,PsCurrentPsychoSocialFunctiionComment VARCHAR(max)    
 ,PsCurrentPsychoSocialFunctiionNeedsList CHAR(1)    
 ,PsAdaptiveEquipment CHAR(1)    
 ,PsAdaptiveEquipmentComment VARCHAR(max)    
 ,PsAdaptiveEquipmentNeedsList CHAR(1)    
 ,PsSafetyMobilityHome CHAR(1)    
 ,PsSafetyMobilityHomeComment VARCHAR(max)    
 ,PsSafetyMobilityHomeNeedsList CHAR(1)    
 ,PsHealthSafetyChecklistComplete CHAR(3)    
 ,PsAccessibilityIssues CHAR(1)    
 ,PsAccessibilityIssuesComment VARCHAR(max)    
 ,PsAccessibilityIssuesNeedsList CHAR(1)    
 ,PsEvacuationTraining CHAR(1)    
 ,PsEvacuationTrainingComment VARCHAR(max)    
 ,PsEvacuationTrainingNeedsList CHAR(1)    
 ,Ps24HourSetting CHAR(1)    
 ,Ps24HourSettingComment VARCHAR(max)    
 ,Ps24HourSettingNeedsList CHAR(1)    
 ,Ps24HourNeedsAwakeSupervision CHAR(1)    
 ,PsSpecialEdEligibility CHAR(1)    
 ,PsSpecialEdEligibilityComment VARCHAR(max)    
 ,PsSpecialEdEligibilityNeedsList CHAR(1)    
 ,PsSpecialEdEnrolled CHAR(1)    
 ,PsSpecialEdEnrolledComment VARCHAR(max)    
 ,PsSpecialEdEnrolledNeedsList CHAR(1)    
 ,PsEmployer CHAR(1)    
 ,PsEmployerComment VARCHAR(max)    
 ,PsEmployerNeedsList CHAR(1)    
 ,PsEmploymentIssues CHAR(1)    
 ,PsEmploymentIssuesComment VARCHAR(max)    
 ,PsEmploymentIssuesNeedsList CHAR(1)    
 ,PsRestrictionsOccupational CHAR(1)    
 ,PsRestrictionsOccupationalComment VARCHAR(max)    
 ,PsRestrictionsOccupationalNeedsList CHAR(1)    
 ,PsFunctionalAssessmentNeeded CHAR(1)    
 ,PsAdvocacyNeeded CHAR(1)    
 ,PsPlanDevelopmentNeeded CHAR(1)    
 ,PsLinkingNeeded CHAR(1)    
 ,PsDDInformationProvidedBy VARCHAR(max)    
 ,HistPreviousDx CHAR(1)    
 ,HistPreviousDxComment VARCHAR(max)    
 ,PsLegalIssues CHAR(1)    
 ,PsLegalIssuesComment VARCHAR(max)    
 ,PsLegalIssuesNeedsList CHAR(1)    
 ,PsCulturalEthnicIssues CHAR(1)    
 ,PsCulturalEthnicIssuesComment VARCHAR(max)    
 ,PsCulturalEthnicIssuesNeedsList CHAR(1)    
 ,PsSpiritualityIssues CHAR(1)    
 ,PsSpiritualityIssuesComment VARCHAR(max)    
 ,PsSpiritualityIssuesNeedsList CHAR(1)    
 ,SuicideNotPresent CHAR(1)    
 ,SuicideIdeation CHAR(1)    
 ,SuicideActive CHAR(1)    
 ,SuicidePassive CHAR(1)    
 ,SuicideMeans CHAR(1)    
 ,SuicidePlan CHAR(1)    
 ,SuicideCurrent CHAR(1)    
 ,SuicidePriorAttempt CHAR(1)    
 ,SuicideNeedsList CHAR(1)    
 ,SuicideBehaviorsPastHistory VARCHAR(max)    
 ,SuicideOtherRiskSelf CHAR(1)    
 ,SuicideOtherRiskSelfComment VARCHAR(max)    
 ,HomicideNotPresent CHAR(1)    
 ,HomicideIdeation CHAR(1)    
 ,HomicideActive CHAR(1)    
 ,HomicidePassive CHAR(1)    
 ,HomicideMeans CHAR(1)    
 ,HomicidePlan CHAR(1)    
 ,HomicideCurrent CHAR(1)    
 ,HomicidePriorAttempt CHAR(1)    
 ,HomicideNeedsList CHAR(1)    
 ,HomicideBehaviorsPastHistory VARCHAR(max)    
 ,HomicdeOtherRiskOthers CHAR(1)    
 ,HomicideOtherRiskOthersComment VARCHAR(max)    
 ,PhysicalAgressionNotPresent CHAR(1)    
 ,PhysicalAgressionSelf CHAR(1)    
 ,PhysicalAgressionOthers CHAR(1)    
 ,PhysicalAgressionCurrentIssue CHAR(1)    
 ,PhysicalAgressionNeedsList CHAR(1)    
 ,PhysicalAgressionBehaviorsPastHistory VARCHAR(max)    
 ,RiskAccessToWeapons CHAR(1)    
 ,RiskAppropriateForAdditionalScreening CHAR(1)    
 ,RiskClinicalIntervention VARCHAR(max)    
 ,RiskOtherFactorsNone CHAR(1)    
 ,RiskOtherFactors VARCHAR(max)    
 ,RiskOtherFactorsNeedsList CHAR(1)    
 ,StaffAxisV INT    
 ,StaffAxisVReason VARCHAR(max)    
 ,ClientStrengthsNarrative VARCHAR(max)    
 ,CrisisPlanningClientHasPlan CHAR(1)    
 ,CrisisPlanningNarrative VARCHAR(max)    
 ,CrisisPlanningDesired CHAR(1)    
 ,CrisisPlanningNeedsList CHAR(1)    
 ,CrisisPlanningMoreInfo CHAR(1)    
 ,AdvanceDirectiveClientHasDirective CHAR(1)    
 ,AdvanceDirectiveDesired CHAR(1)    
 ,AdvanceDirectiveNarrative VARCHAR(max)    
 ,AdvanceDirectiveNeedsList CHAR(1)    
 ,AdvanceDirectiveMoreInfo CHAR(1)    
 ,NaturalSupportSufficiency CHAR(2)    
 ,NaturalSupportNeedsList CHAR(1)    
 ,NaturalSupportIncreaseDesired CHAR(1)    
 ,ClinicalSummary VARCHAR(max)    
 ,UncopeQuestionU CHAR(1)    
 ,UncopeApplicable CHAR(1)    
 ,UncopeApplicableReason VARCHAR(max)    
 ,UncopeQuestionN CHAR(1)    
 ,UncopeQuestionC CHAR(1)    
 ,UncopeQuestionO CHAR(1)    
 ,UncopeQuestionP CHAR(1)    
 ,UncopeQuestionE CHAR(1)    
 ,UncopeCompleteFullSUAssessment CHAR(1)    
 ,SubstanceUseNeedsList CHAR(1)    
 ,DecreaseSymptomsNeedsList CHAR(1)    
 ,DDEPreviouslyMet CHAR(1)    
 ,DDAttributableMentalPhysicalLimitation CHAR(1)    
 ,DDDxAxisI VARCHAR(max)    
 ,DDDxAxisII VARCHAR(max)    
 ,DDDxAxisIII VARCHAR(max)    
 ,DDDxAxisIV VARCHAR(max)    
 ,DDDxAxisV VARCHAR(max)    
 ,DDDxSource VARCHAR(max)    
 ,DDManifestBeforeAge22 CHAR(1)    
 ,DDContinueIndefinitely CHAR(1)    
 ,DDLimitSelfCare CHAR(1)    
 ,DDLimitLanguage CHAR(1)    
 ,DDLimitLearning CHAR(1)    
 ,DDLimitMobility CHAR(1)    
 ,DDLimitSelfDirection CHAR(1)    
 ,DDLimitEconomic CHAR(1)    
 ,DDLimitIndependentLiving CHAR(1)    
 ,DDNeedMulitpleSupports CHAR(1)    
 ,CAFASDate DATETIME    
 ,RaterClinician INT    
 ,CAFASInterval INT    
 ,SchoolPerformance INT    
 ,SchoolPerformanceComment VARCHAR(max)    
 ,HomePerformance INT    
 ,HomePerfomanceComment VARCHAR(max)    
 ,CommunityPerformance INT    
 ,CommunityPerformanceComment VARCHAR(max)    
 ,BehaviorTowardsOther INT    
 ,BehaviorTowardsOtherComment VARCHAR(max)    
 ,MoodsEmotion INT    
 ,MoodsEmotionComment VARCHAR(max)    
 ,SelfHarmfulBehavior INT    
 ,SelfHarmfulBehaviorComment VARCHAR(max)    
 ,SubstanceUse INT    
 ,SubstanceUseComment VARCHAR(max)    
 ,Thinkng INT    
 ,ThinkngComment VARCHAR(max)    
 ,YouthTotalScore INT    
 ,PrimaryFamilyMaterialNeeds INT    
 ,PrimaryFamilyMaterialNeedsComment VARCHAR(max)    
 ,PrimaryFamilySocialSupport INT    
 ,PrimaryFamilySocialSupportComment VARCHAR(max)    
 ,NonCustodialMaterialNeeds INT    
 ,NonCustodialMaterialNeedsComment VARCHAR(max)    
 ,NonCustodialSocialSupport INT    
 ,NonCustodialSocialSupportComment VARCHAR(max)    
 ,SurrogateMaterialNeeds INT    
 ,SurrogateMaterialNeedsComment VARCHAR(max)    
 ,SurrogateSocialSupport INT    
 ,SurrogateSocialSupportComment VARCHAR(max)    
 ,DischargeCriteria VARCHAR(max)    
 ,PrePlanFiscalIntermediaryComment VARCHAR(max)    
 ,StageOfChange INT    
 ,PsEducation CHAR(1)    
 ,PsEducationNeedsList CHAR(1)    
 ,PsMedications CHAR(1)    
 ,PsMedicationsNeedsList CHAR(1)    
 ,PsMedicationsListToBeModified CHAR(1)    
 ,PhysicalConditionQuadriplegic CHAR(1)    
 ,PhysicalConditionMultipleSclerosis CHAR(1)    
 ,PhysicalConditionBlindness CHAR(1)    
 ,PhysicalConditionDeafness CHAR(1)    
 ,PhysicalConditionParaplegic CHAR(1)    
 ,PhysicalConditionCerebral CHAR(1)    
 ,PhysicalConditionMuteness CHAR(1)    
 ,PhysicalConditionOtherHearingImpairment CHAR(1)    
 ,TestingReportsReviewed VARCHAR(2)    
 ,LOCId INT    
 ,SevereProfoundDisability CHAR(1)    
 ,SevereProfoundDisabilityComment VARCHAR(max)    
 ,EmploymentStatus INT    
 ,DxTabDisabled CHAR(1)  
 ,LegalIssues VARCHAR(max)    
,CSSRSAdultOrChild  CHAR(1)  
,Strengths VARCHAR(max)  
,TransitionLevelOfCare VARCHAR(max) 
,ReductionInSymptoms CHAR(1)  
,AttainmentOfHigherFunctioning CHAR(1)
,TreatmentNotNecessary CHAR(1)
,OtherTransitionCriteria CHAR(1)
,EstimatedDischargeDate DATETIME
,ReductionInSymptomsDescription VARCHAR(max) 
,AttainmentOfHigherFunctioningDescription VARCHAR(max) 
,TreatmentNotNecessaryDescription VARCHAR(max) 
,OtherTransitionCriteriaDescription  VARCHAR(max)  
,PsRiskHigherLevelOfCare VARCHAR(max) 
,PsRiskHigherLevelOfCareDueTo INT
,PsRiskOutOfCountryPlacement VARCHAR(max) 
,PsRiskOutOfCountryPlacementDueTo INT
,PsRiskOutOfHomePlacement VARCHAR(max) 
,PsRiskOutOfHomePlacementDueTo INT
,CommunicableDiseaseAssessed INT
,CommunicableDiseaseFurtherInfo VARCHAR(max) 
 ,CreatedBy VARCHAR(30)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(30)    
 )    
    
CREATE TABLE #CustomSUAssessments (    
 DocumentVersionId INT    
 ,VoluntaryAbstinenceTrial VARCHAR(max)    
 ,Comment VARCHAR(max)    
 ,HistoryOrCurrentDUI CHAR(1)    
 ,NumberOfTimesDUI INT    
 ,HistoryOrCurrentDWI CHAR(1)    
 ,NumberOfTimesDWI INT    
 ,HistoryOrCurrentMIP CHAR(1)    
 ,NumberOfTimeMIP INT    
 ,HistoryOrCurrentBlackOuts CHAR(1)    
 ,NumberOfTimesBlackOut INT    
 ,HistoryOrCurrentDomesticAbuse CHAR(1)    
 ,NumberOfTimesDomesticAbuse INT    
 ,LossOfControl CHAR(1)    
 ,IncreasedTolerance CHAR(1)    
 ,OtherConsequence CHAR(1)    
 ,OtherConsequenceDescription VARCHAR(2000)    
 ,RiskOfRelapse VARCHAR(max)    
 ,PreviousTreatment CHAR(1)    
 ,CurrentSubstanceAbuseTreatment CHAR(1)    
 ,CurrentTreatmentProvider VARCHAR(max)    
 ,CurrentSubstanceAbuseReferralToSAorTx CHAR(1)    
 ,CurrentSubstanceAbuseRefferedReason VARCHAR(max)    
 ,ToxicologyResults VARCHAR(max)    
 ,ClientSAHistory CHAR(1)    
 ,FamilySAHistory CHAR(1)    
 ,SubstanceAbuseAdmittedOrSuspected CHAR(1)    
 ,CurrentSubstanceAbuse CHAR(1)    
 ,SuspectedSubstanceAbuse CHAR(1)    
 ,SubstanceAbuseDetail VARCHAR(max)    
 ,SubstanceAbuseTxPlan CHAR(1)    
 ,OdorOfSubstance CHAR(1)    
 ,SlurredSpeech CHAR(1)    
 ,WithdrawalSymptoms CHAR(1)    
 ,DTOther CHAR(1)    
 ,DTOtherText VARCHAR(max)    
 ,Blackouts CHAR(1)    
 ,RelatedArrests CHAR(1)    
 ,RelatedSocialProblems CHAR(1)    
 ,FrequentJobSchoolAbsence CHAR(1)    
 ,NoneSynptomsReportedOrObserved CHAR(1)  
 ,PreviousMedication  CHAR(1)
,CurrentSubstanceAbuseMedication  CHAR(1) 
,MedicationAssistedTreatmentRefferedReason  VARCHAR(max) 
,MedicationAssistedTreatment  CHAR(1)
 ,CreatedBy VARCHAR(100)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(100)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(100)    
 )    
    
--CREATE TABLE #CustomCAFAS2 (    
-- DocumentVersionId INT    
-- ,CAFASDate DATETIME    
-- ,RaterClinician INT    
-- ,CAFASInterval INT    
-- ,SchoolPerformance INT    
-- ,SchoolPerformanceComment VARCHAR(max)    
-- ,HomePerformance INT    
-- ,HomePerfomanceComment VARCHAR(max)    
-- ,CommunityPerformance INT    
-- ,CommunityPerformanceComment VARCHAR(max)    
-- ,BehaviorTowardsOther INT    
-- ,BehaviorTowardsOtherComment VARCHAR(max)    
-- ,MoodsEmotion INT    
-- ,MoodsEmotionComment VARCHAR(max)    
-- ,SelfHarmfulBehavior INT    
-- ,SelfHarmfulBehaviorComment VARCHAR(max)    
-- ,SubstanceUse INT    
-- ,SubstanceUseComment VARCHAR(max)    
-- ,Thinkng INT    
-- ,ThinkngComment VARCHAR(max)    
-- ,PrimaryFamilyMaterialNeeds INT    
-- ,PrimaryFamilyMaterialNeedsComment VARCHAR(max)    
-- ,PrimaryFamilySocialSupport INT    
-- ,PrimaryFamilySocialSupportComment VARCHAR(max)    
-- ,NonCustodialMaterialNeeds INT    
-- ,NonCustodialMaterialNeedsComment VARCHAR(max)    
-- ,NonCustodialSocialSupport INT    
-- ,NonCustodialSocialSupportComment VARCHAR(max)    
-- ,SurrogateMaterialNeeds INT    
-- ,SurrogateMaterialNeedsComment VARCHAR(max)    
-- ,SurrogateSocialSupport INT    
-- ,SurrogateSocialSupportComment VARCHAR(max)    
-- ,CreatedDate DATETIME    
-- ,CreatedBy VARCHAR(30)    
-- ,ModifiedDate DATETIME    
-- ,ModifiedBy VARCHAR(30)    
-- ,RecordDeleted CHAR(1)    
-- ,DeletedDate DATETIME    
-- ,DeletedBy INT    
-- )    
    
CREATE TABLE #CustomMentalStatuses2 (    
 DocumentVersionId INT    
 ,AppearanceAddToNeedsList CHAR(1)    
 ,AppearanceNeatClean CHAR(1)    
 ,AppearancePoorHygiene CHAR(1)    
 ,AppearanceWellGroomed CHAR(1)    
 ,AppearanceAppropriatelyDressed CHAR(1)    
 ,AppearanceYoungerThanStatedAge CHAR(1)    
 ,AppearanceOlderThanStatedAge CHAR(1)    
 ,AppearanceOverweight CHAR(1)    
 ,AppearanceUnderweight CHAR(1)    
 ,AppearanceEccentric CHAR(1)    
 ,AppearanceSeductive CHAR(1)    
 ,AppearanceUnkemptDisheveled CHAR(1)    
 ,AppearanceOther CHAR(1)    
 ,AppearanceComment VARCHAR(max)    
 ,IntellectualAddToNeedsList CHAR(1)    
 ,IntellectualAboveAverage CHAR(1)    
 ,IntellectualAverage CHAR(1)    
 ,IntellectualBelowAverage CHAR(1)    
 ,IntellectualPossibleMR CHAR(1)    
 ,IntellectualDocumentedMR CHAR(1)    
 ,IntellectualOther CHAR(1)    
 ,IntellectualComment VARCHAR(max)    
 ,CommunicationAddToNeedsList CHAR(1)    
 ,CommunicationNormal CHAR(1)    
 ,CommunicationUsesSignLanguage CHAR(1)    
 ,CommunicationUnableToRead CHAR(1)    
 ,CommunicationNeedForBraille CHAR(1)    
 ,CommunicationHearingImpaired CHAR(1)    
 ,CommunicationDoesLipReading CHAR(1)    
 ,CommunicationEnglishIsSecondLanguage CHAR(1)    
 ,CommunicationTranslatorNeeded CHAR(1)    
 ,CommunicationOther CHAR(1)    
 ,CommunicationComment VARCHAR(max)    
 ,MoodAddToNeedsList CHAR(1)    
 ,MoodUnremarkable CHAR(1)    
 ,MoodCooperative CHAR(1)    
 ,MoodAnxious CHAR(1)    
 ,MoodTearful CHAR(1)    
 ,MoodCalm CHAR(1)    
 ,MoodLabile CHAR(1)    
 ,MoodPessimistic CHAR(1)    
 ,MoodCheerful CHAR(1)    
 ,MoodGuilty CHAR(1)    
 ,MoodEuphoric CHAR(1)    
 ,MoodDepressed CHAR(1)    
 ,MoodHostile CHAR(1)    
 ,MoodIrritable CHAR(1)    
 ,MoodDramatized CHAR(1)    
 ,MoodFearful CHAR(1)    
 ,MoodSupicious CHAR(1)    
 ,MoodOther CHAR(1)    
 ,MoodComment VARCHAR(max)    
 ,AffectAddToNeedsList CHAR(1)    
 ,AffectPrimarilyAppropriate CHAR(1)    
 ,AffectRestricted CHAR(1)    
 ,AffectBlunted CHAR(1)    
 ,AffectFlattened CHAR(1)    
 ,AffectDetached CHAR(1)    
 ,AffectPrimarilyInappropriate CHAR(1)    
 ,AffectOther CHAR(1)    
 ,AffectComment VARCHAR(max)    
 ,SpeechAddToNeedsList CHAR(1)    
 ,SpeechNormal CHAR(1)    
 ,SpeechLogicalCoherent CHAR(1)    
 ,SpeechTangential CHAR(1)    
 ,SpeechSparseSlow CHAR(1)    
 ,SpeechRapidPressured CHAR(1)    
 ,SpeechSoft CHAR(1)    
 ,SpeechCircumstantial CHAR(1)    
 ,SpeechLoud CHAR(1)    
 ,SpeechRambling CHAR(1)    
 ,SpeechOther CHAR(1)    
 ,SpeechComment VARCHAR(max)    
 ,ThoughtAddToNeedsList CHAR(1)    
 ,ThoughtUnremarkable CHAR(1)    
 ,ThoughtParanoid CHAR(1)    
 ,ThoughtGrandiose CHAR(1)    
 ,ThoughtObsessive CHAR(1)    
 ,ThoughtBizarre CHAR(1)    
 ,ThoughtFlightOfIdeas CHAR(1)    
 ,ThoughtDisorganized CHAR(1)    
 ,ThoughtAuditoryHallucinations CHAR(1)    
 ,ThoughtVisualHallucinations CHAR(1)    
 ,ThoughtTactileHallucinations CHAR(1)    
 ,ThoughtOther CHAR(1)    
 ,ThoughtComment VARCHAR(max)    
 ,BehaviorAddToNeedsList CHAR(1)    
 ,BehaviorNormal CHAR(1)    
 ,BehaviorRestless CHAR(1)    
 ,BehaviorTremors CHAR(1)    
 ,BehaviorPoorEyeContact CHAR(1)    
 ,BehaviorAgitated CHAR(1)    
 ,BehaviorPeculiar CHAR(1)    
 ,BehaviorSelfDestructive CHAR(1)    
 ,BehaviorSlowed CHAR(1)    
 ,BehaviorDestructiveToOthers CHAR(1)    
 ,BehaviorCompulsive CHAR(1)    
 ,BehaviorOther CHAR(1)    
 ,BehaviorComment VARCHAR(max)    
 ,OrientationAddToNeedsList CHAR(1)    
 ,OrientationToPersonPlaceTime CHAR(1)    
 ,OrientationNotToPerson CHAR(1)    
 ,OrientationNotToPlace CHAR(1)    
 ,OrientationNotToTime CHAR(1)    
 ,OrientationOther CHAR(1)    
 ,OrientationComment VARCHAR(max)    
 ,InsightAddToNeedsList CHAR(1)    
 ,InsightGood CHAR(1)    
 ,InsightFair CHAR(1)    
 ,InsightPoor CHAR(1)    
 ,InsightLacking CHAR(1)    
 ,InsightOther CHAR(1)    
 ,InsightComment VARCHAR(max)    
 ,MemoryAddToNeedsList CHAR(1)    
 ,MemoryGoodNormal CHAR(1)    
 ,MemoryImpairedShortTerm CHAR(1)    
 ,MemoryImpairedLongTerm CHAR(1)    
 ,MemoryOther CHAR(1)    
 ,MemoryComment VARCHAR(max)    
 ,RealityOrientationAddToNeedsList CHAR(1)    
 ,RealityOrientationIntact CHAR(1)    
 ,RealityOrientationTenuous CHAR(1)    
 ,RealityOrientationPoor CHAR(1)    
 ,RealityOrientationOther CHAR(1)    
 ,RealityOrientationComment VARCHAR(max)    
 ,CreatedBy VARCHAR(30)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(30)    
 )    
    
CREATE TABLE #CustomHRMAssessmentSupports2 (    
 DocumentVersionId INT    
 ,SupportDescription VARCHAR(max)    
 ,[Current] CHAR(1)    
 ,PaidSupport CHAR(1)    
 ,UnpaidSupport CHAR(1)    
 ,ClinicallyRecommended CHAR(1)    
 ,CustomerDesired CHAR(1)    
 ,CreatedBy VARCHAR(30)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(30)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME    
 ,DeletedBy VARCHAR(30)    
 )    
    
--      
--Insert into Temp Tables      
--      
INSERT INTO #CustomSUAssessments (    
 DocumentVersionId    
 ,VoluntaryAbstinenceTrial    
 ,[Comment]    
 ,HistoryOrCurrentDUI    
 ,NumberOfTimesDUI    
 ,HistoryOrCurrentDWI    
 ,NumberOfTimesDWI    
 ,HistoryOrCurrentMIP    
 ,NumberOfTimeMIP    
 ,HistoryOrCurrentBlackOuts    
 ,NumberOfTimesBlackOut    
 ,HistoryOrCurrentDomesticAbuse    
 ,NumberOfTimesDomesticAbuse    
 ,LossOfControl    
 ,IncreasedTolerance    
 ,OtherConsequence    
 ,OtherConsequenceDescription    
 ,RiskOfRelapse    
 ,PreviousTreatment    
 ,CurrentSubstanceAbuseTreatment    
 ,CurrentTreatmentProvider    
 ,CurrentSubstanceAbuseReferralToSAorTx    
 ,CurrentSubstanceAbuseRefferedReason    
 ,ToxicologyResults    
 ,ClientSAHistory    
 ,FamilySAHistory    
 ,SubstanceAbuseAdmittedOrSuspected    
 ,CurrentSubstanceAbuse    
 ,SuspectedSubstanceAbuse    
 ,SubstanceAbuseDetail    
 ,SubstanceAbuseTxPlan    
 ,OdorOfSubstance    
 ,SlurredSpeech    
 ,WithdrawalSymptoms    
 ,DTOther    
 ,DTOtherText    
 ,Blackouts    
 ,RelatedArrests    
 ,RelatedSocialProblems    
 ,FrequentJobSchoolAbsence    
 ,NoneSynptomsReportedOrObserved 
 ,PreviousMedication  
,CurrentSubstanceAbuseMedication   
,MedicationAssistedTreatmentRefferedReason
,MedicationAssistedTreatment   
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT a.DocumentVersionId    
 ,VoluntaryAbstinenceTrial    
 ,[Comment]    
 ,HistoryOrCurrentDUI    
 ,NumberOfTimesDUI    
 ,HistoryOrCurrentDWI    
 ,NumberOfTimesDWI    
 ,HistoryOrCurrentMIP    
 ,NumberOfTimeMIP    
 ,HistoryOrCurrentBlackOuts    
 ,NumberOfTimesBlackOut    
 ,HistoryOrCurrentDomesticAbuse    
 ,NumberOfTimesDomesticAbuse    
 ,LossOfControl    
 ,IncreasedTolerance    
 ,OtherConsequence    
 ,OtherConsequenceDescription    
 ,RiskOfRelapse    
 ,PreviousTreatment    
 ,CurrentSubstanceAbuseTreatment    
 ,CurrentTreatmentProvider    
 ,CurrentSubstanceAbuseReferralToSAorTx    
 ,CurrentSubstanceAbuseRefferedReason    
 ,ToxicologyResults    
 ,ClientSAHistory    
 ,FamilySAHistory    
 ,SubstanceAbuseAdmittedOrSuspected    
 ,CurrentSubstanceAbuse    
 ,SuspectedSubstanceAbuse    
 ,SubstanceAbuseDetail    
 ,SubstanceAbuseTxPlan    
 ,OdorOfSubstance    
 ,SlurredSpeech    
 ,WithdrawalSymptoms    
 ,DTOther   
 ,DTOtherText    
 ,Blackouts    
 ,RelatedArrests    
 ,RelatedSocialProblems    
 ,FrequentJobSchoolAbsence    
 ,NoneSynptomsReportedOrObserved   
 ,PreviousMedication       
  ,CurrentSubstanceAbuseMedication   
  ,MedicationAssistedTreatmentRefferedReason
  ,MedicationAssistedTreatment
 ,a.CreatedBy    
 ,a.CreatedDate    
 ,a.ModifiedBy    
 ,a.ModifiedDate    
 ,a.RecordDeleted    
 ,a.DeletedDate    
 ,a.DeletedBy    
FROM CustomSubstanceUseAssessments a    
WHERE a.documentversionId = @documentversionId    
 AND isnull(a.RecordDeleted, 'N') = 'N'    
    
INSERT INTO #CustomHRMAssessments (    
 DocumentVersionId    
 ,ClientName    
 ,AssessmentType    
 ,CurrentAssessmentDate    
 ,PreviousAssessmentDate    
 ,ClientDOB    
 ,AdultOrChild    
 ,ChildHasNoParentalConsent    
 ,ClientHasGuardian    
 ,GuardianName    
 ,GuardianAddress    
 ,GuardianPhone    
 ,GuardianType    
 ,ClientInDDPopulation    
 ,ClientInSAPopulation    
 ,ClientInMHPopulation    
 ,PreviousDiagnosisText    
 ,ReferralType    
 ,PresentingProblem    
 ,CurrentLivingArrangement    
 ,CurrentPrimaryCarePhysician    
 ,ReasonForUpdate    
 ,DesiredOutcomes    
 ,PsMedicationsComment    
 ,PsEducationComment    
 ,IncludeFunctionalAssessment    
 ,IncludeSymptomChecklist    
 ,IncludeUNCOPE    
 ,ClientIsAppropriateForTreatment    
 ,SecondOpinionNoticeProvided    
 ,TreatmentNarrative    
 ,RapCiDomainIntensity    
 ,RapCiDomainComment    
 ,RapCiDomainNeedsList    
 ,RapCbDomainIntensity    
 ,RapCbDomainComment    
 ,RapCbDomainNeedsList    
 ,RapCaDomainIntensity    
 ,RapCaDomainComment    
 ,RapCaDomainNeedsList    
 ,RapHhcDomainIntensity    
 ,OutsideReferralsGiven    
 ,ReferralsNarrative    
 ,ServiceOther    
 ,ServiceOtherDescription    
 ,AssessmentAddtionalInformation    
 ,TreatmentAccomodation    
 ,Participants    
 ,Facilitator    
 ,TimeLocation    
 ,AssessmentsNeeded    
 ,CommunicationAccomodations    
 ,IssuesToAvoid    
 ,IssuesToDiscuss    
 ,SourceOfPrePlanningInfo    
 ,SelfDeterminationDesired    
 ,FiscalIntermediaryDesired    
 ,PamphletGiven    
 ,PamphletDiscussed    
 ,PrePlanIndependentFacilitatorDiscussed    
 ,PrePlanIndependentFacilitatorDesired    
 ,PrePlanGuardianContacted    
 ,PrePlanSeparateDocument    
 ,CommunityActivitiesCurrentDesired    
 ,CommunityActivitiesIncreaseDesired    
 ,CommunityActivitiesNeedsList    
 ,PsCurrentHealthIssues    
 ,PsCurrentHealthIssuesComment    
 ,PsCurrentHealthIssuesNeedsList    
 ,HistMentalHealthTx    
 ,HistMentalHealthTxNeedsList    
 ,HistMentalHealthTxComment    
 ,HistFamilyMentalHealthTx    
 ,HistFamilyMentalHealthTxNeedsList    
 ,HistFamilyMentalHealthTxComment    
 ,PsClientAbuseIssues    
 ,PsClientAbuesIssuesComment    
 ,PsClientAbuseIssuesNeedsList    
 ,PsFamilyConcernsComment    
 ,PsRiskLossOfPlacement    
 ,PsRiskLossOfPlacementDueTo    
 ,PsRiskSensoryMotorFunction    
 ,PsRiskSensoryMotorFunctionDueTo    
 ,PsRiskSafety    
 ,PsRiskSafetyDueTo    
 ,PsRiskLossOfSupport    
 ,PsRiskLossOfSupportDueTo    
 ,PsRiskExpulsionFromSchool    
 ,PsRiskExpulsionFromSchoolDueTo    
 ,PsRiskHospitalization    
 ,PsRiskHospitalizationDueTo    
 ,PsRiskCriminalJusticeSystem    
 ,PsRiskCriminalJusticeSystemDueTo    
 ,PsRiskElopementFromHome    
 ,PsRiskElopementFromHomeDueTo    
 ,PsRiskLossOfFinancialStatus    
 ,PsRiskLossOfFinancialStatusDueTo    
 ,PsDevelopmentalMilestones    
 ,PsDevelopmentalMilestonesComment    
 ,PsDevelopmentalMilestonesNeedsList    
 ,PsChildEnvironmentalFactors    
 ,PsChildEnvironmentalFactorsComment    
 ,PsChildEnvironmentalFactorsNeedsList    
 ,PsLanguageFunctioning    
 ,PsLanguageFunctioningComment    
 ,PsLanguageFunctioningNeedsList    
 ,PsVisualFunctioning    
 ,PsVisualFunctioningComment    
 ,PsVisualFunctioningNeedsList    
 ,PsPrenatalExposure    
 ,PsPrenatalExposureComment    
 ,PsPrenatalExposureNeedsList    
 ,PsChildMentalHealthHistory    
 ,PsChildMentalHealthHistoryComment    
 ,PsChildMentalHealthHistoryNeedsList    
 ,PsIntellectualFunctioning    
 ,PsIntellectualFunctioningComment    
 ,PsIntellectualFunctioningNeedsList    
 ,PsLearningAbility    
 ,PsLearningAbilityComment    
 ,PsLearningAbilityNeedsList    
 ,PsFunctioningConcernComment    
 ,PsPeerInteraction    
 ,PsPeerInteractionComment    
 ,PsPeerInteractionNeedsList    
 ,PsParentalParticipation    
 ,PsParentalParticipationComment    
 ,PsParentalParticipationNeedsList    
 ,PsSchoolHistory    
 ,PsSchoolHistoryComment    
 ,PsSchoolHistoryNeedsList    
 ,PsImmunizations    
 ,PsImmunizationsComment    
 ,PsImmunizationsNeedsList    
 ,PsChildHousingIssues    
 ,PsChildHousingIssuesComment    
 ,PsChildHousingIssuesNeedsList    
 ,PsSexuality    
 ,PsSexualityComment    
 ,PsSexualityNeedsList    
 ,PsFamilyFunctioning    
 ,PsFamilyFunctioningComment    
 ,PsFamilyFunctioningNeedsList    
 ,PsTraumaticIncident    
 ,PsTraumaticIncidentComment    
 ,PsTraumaticIncidentNeedsList    
 ,HistDevelopmental    
 ,HistDevelopmentalComment    
 ,HistResidential    
 ,HistResidentialComment    
 ,HistOccupational    
 ,HistOccupationalComment    
 ,HistLegalFinancial    
 ,HistLegalFinancialComment    
 ,SignificantEventsPastYear    
 ,PsGrossFineMotor    
 ,PsGrossFineMotorComment    
 ,PsGrossFineMotorNeedsList    
 ,PsSensoryPerceptual    
 ,PsSensoryPerceptualComment    
 ,PsSensoryPerceptualNeedsList    
 ,PsCognitiveFunction    
 ,PsCognitiveFunctionComment    
 ,PsCognitiveFunctionNeedsList    
 ,PsCommunicativeFunction    
 ,PsCommunicativeFunctionComment    
 ,PsCommunicativeFunctionNeedsList    
 ,PsCurrentPsychoSocialFunctiion    
 ,PsCurrentPsychoSocialFunctiionComment    
 ,PsCurrentPsychoSocialFunctiionNeedsList    
 ,PsAdaptiveEquipment    
 ,PsAdaptiveEquipmentComment    
 ,PsAdaptiveEquipmentNeedsList    
 ,PsSafetyMobilityHome    
 ,PsSafetyMobilityHomeComment    
 ,PsSafetyMobilityHomeNeedsList    
 ,PsHealthSafetyChecklistComplete    
 ,PsAccessibilityIssues    
 ,PsAccessibilityIssuesComment    
 ,PsAccessibilityIssuesNeedsList    
 ,PsEvacuationTraining    
 ,PsEvacuationTrainingComment    
 ,PsEvacuationTrainingNeedsList    
 ,Ps24HourSetting    
 ,Ps24HourSettingComment    
 ,Ps24HourSettingNeedsList    
 ,Ps24HourNeedsAwakeSupervision    
 ,PsSpecialEdEligibility    
 ,PsSpecialEdEligibilityComment    
 ,PsSpecialEdEligibilityNeedsList    
 ,PsSpecialEdEnrolled    
 ,PsSpecialEdEnrolledComment    
 ,PsSpecialEdEnrolledNeedsList    
 ,PsEmployer    
 ,PsEmployerComment    
 ,PsEmployerNeedsList    
 ,PsEmploymentIssues    
 ,PsEmploymentIssuesComment    
 ,PsEmploymentIssuesNeedsList    
 ,PsRestrictionsOccupational    
 ,PsRestrictionsOccupationalComment    
 ,PsRestrictionsOccupationalNeedsList    
 ,PsFunctionalAssessmentNeeded    
 ,PsAdvocacyNeeded    
 ,PsPlanDevelopmentNeeded    
 ,PsLinkingNeeded    
 ,PsDDInformationProvidedBy    
 ,HistPreviousDx    
 ,HistPreviousDxComment    
 ,PsLegalIssues    
 ,PsLegalIssuesComment    
 ,PsLegalIssuesNeedsList    
 ,PsCulturalEthnicIssues    
 ,PsCulturalEthnicIssuesComment    
 ,PsCulturalEthnicIssuesNeedsList    
 ,PsSpiritualityIssues    
 ,PsSpiritualityIssuesComment    
 ,PsSpiritualityIssuesNeedsList    
 ,SuicideNotPresent    
 ,SuicideIdeation    
 ,SuicideActive    
 ,SuicidePassive    
 ,SuicideMeans    
 ,SuicidePlan    
 ,SuicideCurrent    
 ,SuicidePriorAttempt    
 ,SuicideNeedsList    
 ,SuicideBehaviorsPastHistory    
 ,SuicideOtherRiskSelf    
 ,SuicideOtherRiskSelfComment    
 ,HomicideNotPresent    
 ,HomicideIdeation    
 ,HomicideActive    
 ,HomicidePassive    
 ,HomicideMeans    
 ,HomicidePlan    
 ,HomicideCurrent    
 ,HomicidePriorAttempt    
 ,HomicideNeedsList    
 ,HomicideBehaviorsPastHistory    
 ,HomicdeOtherRiskOthers    
 ,HomicideOtherRiskOthersComment    
 ,PhysicalAgressionNotPresent    
 ,PhysicalAgressionSelf    
 ,PhysicalAgressionOthers    
 ,PhysicalAgressionCurrentIssue    
 ,PhysicalAgressionNeedsList    
 ,PhysicalAgressionBehaviorsPastHistory    
 ,RiskAccessToWeapons    
 ,RiskAppropriateForAdditionalScreening    
 ,RiskClinicalIntervention    
 ,RiskOtherFactorsNone    
 ,RiskOtherFactors    
 ,RiskOtherFactorsNeedsList    
 ,StaffAxisV    
 ,StaffAxisVReason    
 ,ClientStrengthsNarrative    
 ,CrisisPlanningClientHasPlan    
 ,CrisisPlanningNarrative    
 ,CrisisPlanningDesired    
 ,CrisisPlanningNeedsList    
 ,CrisisPlanningMoreInfo    
 ,AdvanceDirectiveClientHasDirective    
 ,AdvanceDirectiveDesired    
 ,AdvanceDirectiveNarrative    
 ,AdvanceDirectiveNeedsList    
 ,AdvanceDirectiveMoreInfo    
 ,NaturalSupportSufficiency    
 ,NaturalSupportNeedsList    
 ,NaturalSupportIncreaseDesired    
 ,ClinicalSummary    
 ,UncopeQuestionU    
 ,UncopeApplicable    
 ,UncopeApplicableReason    
 ,UncopeQuestionN    
 ,UncopeQuestionC    
 ,UncopeQuestionO    
 ,UncopeQuestionP    
 ,UncopeQuestionE    
 ,UncopeCompleteFullSUAssessment    
 ,SubstanceUseNeedsList    
 ,DecreaseSymptomsNeedsList    
 ,DDEPreviouslyMet    
 ,DDAttributableMentalPhysicalLimitation    
 ,DDDxAxisI    
 ,DDDxAxisII    
 ,DDDxAxisIII    
 ,DDDxAxisIV    
 ,DDDxAxisV    
 ,DDDxSource    
 ,DDManifestBeforeAge22    
 ,DDContinueIndefinitely    
 ,DDLimitSelfCare    
 ,DDLimitLanguage    
 ,DDLimitLearning    
 ,DDLimitMobility    
 ,DDLimitSelfDirection    
 ,DDLimitEconomic    
 ,DDLimitIndependentLiving    
 ,DDNeedMulitpleSupports    
 ,CAFASDate    
 ,RaterClinician    
 ,CAFASInterval    
 ,SchoolPerformance    
 ,SchoolPerformanceComment    
 ,HomePerformance    
 ,HomePerfomanceComment    
 ,CommunityPerformance    
 ,CommunityPerformanceComment    
 ,BehaviorTowardsOther    
 ,BehaviorTowardsOtherComment    
 ,MoodsEmotion    
 ,MoodsEmotionComment    
 ,SelfHarmfulBehavior    
 ,SelfHarmfulBehaviorComment    
 ,SubstanceUse    
 ,SubstanceUseComment    
 ,Thinkng    
 ,ThinkngComment    
 ,YouthTotalScore    
 ,PrimaryFamilyMaterialNeeds    
 ,PrimaryFamilyMaterialNeedsComment    
 ,PrimaryFamilySocialSupport    
 ,PrimaryFamilySocialSupportComment    
 ,NonCustodialMaterialNeeds    
 ,NonCustodialMaterialNeedsComment    
 ,NonCustodialSocialSupport    
 ,NonCustodialSocialSupportComment    
 ,SurrogateMaterialNeeds    
 ,SurrogateMaterialNeedsComment    
 ,SurrogateSocialSupport    
 ,SurrogateSocialSupportComment    
 ,DischargeCriteria    
 ,PrePlanFiscalIntermediaryComment    
 ,StageOfChange    
 ,PsEducation    
 ,PsEducationNeedsList    
 ,PsMedications    
 ,PsMedicationsNeedsList    
 ,PsMedicationsListToBeModified    
 ,PhysicalConditionQuadriplegic    
 ,PhysicalConditionMultipleSclerosis    
 ,PhysicalConditionBlindness    
 ,PhysicalConditionDeafness    
 ,PhysicalConditionParaplegic    
 ,PhysicalConditionCerebral    
 ,PhysicalConditionMuteness    
 ,PhysicalConditionOtherHearingImpairment    
 ,TestingReportsReviewed    
 ,LOCId    
 ,SevereProfoundDisability    
 ,SevereProfoundDisabilityComment    
 ,EmploymentStatus    
 ,DxTabDisabled  
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
,PsRiskHigherLevelOfCare
,PsRiskHigherLevelOfCareDueTo
,PsRiskOutOfCountryPlacement
,PsRiskOutOfCountryPlacementDueTo
,PsRiskOutOfHomePlacement
,PsRiskOutOfHomePlacementDueTo
,CommunicableDiseaseAssessed
,CommunicableDiseaseFurtherInfo
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT DocumentVersionId    
 ,ClientName    
 ,AssessmentType    
 ,CurrentAssessmentDate    
 ,PreviousAssessmentDate    
 ,ClientDOB    
 ,AdultOrChild    
 ,ChildHasNoParentalConsent    
 ,ClientHasGuardian    
 ,GuardianName    
 ,GuardianAddress    
 ,GuardianPhone    
 ,GuardianType    
 ,ClientInDDPopulation    
 ,ClientInSAPopulation    
 ,ClientInMHPopulation    
 ,PreviousDiagnosisText    
 ,ReferralType    
 ,PresentingProblem    
 ,CurrentLivingArrangement    
 ,CurrentPrimaryCarePhysician    
 ,ReasonForUpdate    
 ,DesiredOutcomes    
 ,PsMedicationsComment    
 ,PsEducationComment    
 ,IncludeFunctionalAssessment    
 ,IncludeSymptomChecklist    
 ,IncludeUNCOPE    
 ,ClientIsAppropriateForTreatment    
 ,SecondOpinionNoticeProvided    
 ,TreatmentNarrative    
 ,RapCiDomainIntensity    
 ,RapCiDomainComment    
 ,RapCiDomainNeedsList    
 ,RapCbDomainIntensity    
 ,RapCbDomainComment    
 ,RapCbDomainNeedsList    
 ,RapCaDomainIntensity    
 ,RapCaDomainComment    
 ,RapCaDomainNeedsList    
 ,RapHhcDomainIntensity    
 ,OutsideReferralsGiven    
 ,ReferralsNarrative    
 ,ServiceOther    
 ,ServiceOtherDescription    
 ,AssessmentAddtionalInformation    
 ,TreatmentAccomodation    
 ,Participants    
 ,Facilitator    
 ,TimeLocation    
 ,AssessmentsNeeded    
 ,CommunicationAccomodations    
 ,IssuesToAvoid    
 ,IssuesToDiscuss    
 ,SourceOfPrePlanningInfo    
 ,SelfDeterminationDesired    
 ,FiscalIntermediaryDesired    
 ,PamphletGiven    
 ,PamphletDiscussed    
 ,PrePlanIndependentFacilitatorDiscussed    
 ,PrePlanIndependentFacilitatorDesired    
 ,PrePlanGuardianContacted    
 ,PrePlanSeparateDocument    
 ,CommunityActivitiesCurrentDesired    
 ,CommunityActivitiesIncreaseDesired    
 ,CommunityActivitiesNeedsList    
 ,PsCurrentHealthIssues    
 ,PsCurrentHealthIssuesComment    
 ,PsCurrentHealthIssuesNeedsList    
 ,HistMentalHealthTx    
 ,HistMentalHealthTxNeedsList    
 ,HistMentalHealthTxComment    
 ,HistFamilyMentalHealthTx    
 ,HistFamilyMentalHealthTxNeedsList    
 ,HistFamilyMentalHealthTxComment    
 ,PsClientAbuseIssues    
 ,PsClientAbuesIssuesComment    
 ,PsClientAbuseIssuesNeedsList    
 ,PsFamilyConcernsComment    
 ,PsRiskLossOfPlacement    
 ,PsRiskLossOfPlacementDueTo    
 ,PsRiskSensoryMotorFunction    
 ,PsRiskSensoryMotorFunctionDueTo    
 ,PsRiskSafety    
 ,PsRiskSafetyDueTo    
 ,PsRiskLossOfSupport    
 ,PsRiskLossOfSupportDueTo    
 ,PsRiskExpulsionFromSchool    
 ,PsRiskExpulsionFromSchoolDueTo    
 ,PsRiskHospitalization    
 ,PsRiskHospitalizationDueTo    
 ,PsRiskCriminalJusticeSystem    
 ,PsRiskCriminalJusticeSystemDueTo    
 ,PsRiskElopementFromHome    
 ,PsRiskElopementFromHomeDueTo    
 ,PsRiskLossOfFinancialStatus    
 ,PsRiskLossOfFinancialStatusDueTo    
 ,PsDevelopmentalMilestones    
 ,PsDevelopmentalMilestonesComment    
 ,PsDevelopmentalMilestonesNeedsList    
 ,PsChildEnvironmentalFactors    
 ,PsChildEnvironmentalFactorsComment    
 ,PsChildEnvironmentalFactorsNeedsList    
 ,PsLanguageFunctioning    
 ,PsLanguageFunctioningComment    
 ,PsLanguageFunctioningNeedsList    
 ,PsVisualFunctioning    
 ,PsVisualFunctioningComment    
 ,PsVisualFunctioningNeedsList    
 ,PsPrenatalExposure    
 ,PsPrenatalExposureComment    
 ,PsPrenatalExposureNeedsList    
 ,PsChildMentalHealthHistory    
 ,PsChildMentalHealthHistoryComment    
 ,PsChildMentalHealthHistoryNeedsList    
 ,PsIntellectualFunctioning    
 ,PsIntellectualFunctioningComment    
 ,PsIntellectualFunctioningNeedsList    
 ,PsLearningAbility    
 ,PsLearningAbilityComment    
 ,PsLearningAbilityNeedsList    
 ,PsFunctioningConcernComment    
 ,PsPeerInteraction    
 ,PsPeerInteractionComment    
 ,PsPeerInteractionNeedsList    
 ,PsParentalParticipation    
 ,PsParentalParticipationComment    
 ,PsParentalParticipationNeedsList    
 ,PsSchoolHistory    
 ,PsSchoolHistoryComment    
 ,PsSchoolHistoryNeedsList    
 ,PsImmunizations    
 ,PsImmunizationsComment    
 ,PsImmunizationsNeedsList    
 ,PsChildHousingIssues    
 ,PsChildHousingIssuesComment    
 ,PsChildHousingIssuesNeedsList    
 ,PsSexuality    
 ,PsSexualityComment    
 ,PsSexualityNeedsList    
 ,PsFamilyFunctioning    
 ,PsFamilyFunctioningComment    
 ,PsFamilyFunctioningNeedsList    
 ,PsTraumaticIncident    
 ,PsTraumaticIncidentComment    
 ,PsTraumaticIncidentNeedsList    
 ,HistDevelopmental    
 ,HistDevelopmentalComment    
 ,HistResidential    
 ,HistResidentialComment    
 ,HistOccupational    
 ,HistOccupationalComment    
 ,HistLegalFinancial    
 ,HistLegalFinancialComment    
 ,SignificantEventsPastYear    
 ,PsGrossFineMotor    
 ,PsGrossFineMotorComment    
 ,PsGrossFineMotorNeedsList    
 ,PsSensoryPerceptual    
 ,PsSensoryPerceptualComment    
 ,PsSensoryPerceptualNeedsList    
 ,PsCognitiveFunction    
 ,PsCognitiveFunctionComment    
 ,PsCognitiveFunctionNeedsList    
 ,PsCommunicativeFunction    
 ,PsCommunicativeFunctionComment    
 ,PsCommunicativeFunctionNeedsList    
 ,PsCurrentPsychoSocialFunctiion    
 ,PsCurrentPsychoSocialFunctiionComment    
 ,PsCurrentPsychoSocialFunctiionNeedsList    
 ,PsAdaptiveEquipment    
 ,PsAdaptiveEquipmentComment    
 ,PsAdaptiveEquipmentNeedsList    
 ,PsSafetyMobilityHome    
 ,PsSafetyMobilityHomeComment    
 ,PsSafetyMobilityHomeNeedsList    
 ,PsHealthSafetyChecklistComplete    
 ,PsAccessibilityIssues    
 ,PsAccessibilityIssuesComment    
 ,PsAccessibilityIssuesNeedsList    
 ,PsEvacuationTraining    
 ,PsEvacuationTrainingComment    
 ,PsEvacuationTrainingNeedsList    
 ,Ps24HourSetting    
 ,Ps24HourSettingComment    
 ,Ps24HourSettingNeedsList    
 ,Ps24HourNeedsAwakeSupervision    
 ,PsSpecialEdEligibility    
 ,PsSpecialEdEligibilityComment    
 ,PsSpecialEdEligibilityNeedsList    
 ,PsSpecialEdEnrolled    
 ,PsSpecialEdEnrolledComment    
 ,PsSpecialEdEnrolledNeedsList    
 ,PsEmployer    
 ,PsEmployerComment    
 ,PsEmployerNeedsList    
 ,PsEmploymentIssues    
 ,PsEmploymentIssuesComment    
 ,PsEmploymentIssuesNeedsList    
 ,PsRestrictionsOccupational    
 ,PsRestrictionsOccupationalComment    
 ,PsRestrictionsOccupationalNeedsList    
 ,PsFunctionalAssessmentNeeded    
 ,PsAdvocacyNeeded    
 ,PsPlanDevelopmentNeeded    
 ,PsLinkingNeeded    
 ,PsDDInformationProvidedBy    
 ,HistPreviousDx    
 ,HistPreviousDxComment    
 ,PsLegalIssues    
 ,PsLegalIssuesComment    
 ,PsLegalIssuesNeedsList    
 ,PsCulturalEthnicIssues    
 ,PsCulturalEthnicIssuesComment    
 ,PsCulturalEthnicIssuesNeedsList    
 ,PsSpiritualityIssues    
 ,PsSpiritualityIssuesComment    
 ,PsSpiritualityIssuesNeedsList    
 ,SuicideNotPresent    
 ,SuicideIdeation    
 ,SuicideActive    
 ,SuicidePassive    
 ,SuicideMeans    
 ,SuicidePlan    
 ,SuicideCurrent    
 ,SuicidePriorAttempt    
 ,SuicideNeedsList    
 ,SuicideBehaviorsPastHistory    
 ,SuicideOtherRiskSelf    
 ,SuicideOtherRiskSelfComment    
 ,HomicideNotPresent    
 ,HomicideIdeation    
 ,HomicideActive    
 ,HomicidePassive    
 ,HomicideMeans    
 ,HomicidePlan    
 ,HomicideCurrent    
 ,HomicidePriorAttempt    
 ,HomicideNeedsList    
 ,HomicideBehaviorsPastHistory    
 ,HomicdeOtherRiskOthers    
 ,HomicideOtherRiskOthersComment    
 ,PhysicalAgressionNotPresent    
 ,PhysicalAgressionSelf    
 ,PhysicalAgressionOthers    
 ,PhysicalAgressionCurrentIssue    
 ,PhysicalAgressionNeedsList    
 ,PhysicalAgressionBehaviorsPastHistory    
 ,RiskAccessToWeapons    
 ,RiskAppropriateForAdditionalScreening    
 ,RiskClinicalIntervention    
 ,RiskOtherFactorsNone    
 ,RiskOtherFactors    
 ,RiskOtherFactorsNeedsList    
 ,StaffAxisV    
 ,StaffAxisVReason    
 ,ClientStrengthsNarrative    
 ,CrisisPlanningClientHasPlan    
 ,CrisisPlanningNarrative    
 ,CrisisPlanningDesired    
 ,CrisisPlanningNeedsList    
 ,CrisisPlanningMoreInfo    
 ,AdvanceDirectiveClientHasDirective    
 ,AdvanceDirectiveDesired    
 ,AdvanceDirectiveNarrative    
 ,AdvanceDirectiveNeedsList    
 ,AdvanceDirectiveMoreInfo    
 ,NaturalSupportSufficiency    
 ,NaturalSupportNeedsList    
 ,NaturalSupportIncreaseDesired    
 ,ClinicalSummary    
 ,UncopeQuestionU    
 ,UncopeApplicable    
 ,UncopeApplicableReason    
 ,UncopeQuestionN    
 ,UncopeQuestionC    
 ,UncopeQuestionO    
 ,UncopeQuestionP    
 ,UncopeQuestionE    
 ,UncopeCompleteFullSUAssessment    
 ,SubstanceUseNeedsList    
 ,DecreaseSymptomsNeedsList    
 ,DDEPreviouslyMet    
 ,DDAttributableMentalPhysicalLimitation    
 ,DDDxAxisI    
 ,DDDxAxisII    
 ,DDDxAxisIII    
 ,DDDxAxisIV    
 ,DDDxAxisV    
 ,DDDxSource    
 ,DDManifestBeforeAge22    
 ,DDContinueIndefinitely    
 ,DDLimitSelfCare    
 ,DDLimitLanguage    
 ,DDLimitLearning    
 ,DDLimitMobility    
 ,DDLimitSelfDirection    
 ,DDLimitEconomic    
 ,DDLimitIndependentLiving    
 ,DDNeedMulitpleSupports    
 ,CAFASDate    
 ,RaterClinician    
 ,CAFASInterval    
 ,SchoolPerformance    
 ,SchoolPerformanceComment    
 ,HomePerformance    
 ,HomePerfomanceComment    
 ,CommunityPerformance    
 ,CommunityPerformanceComment    
 ,BehaviorTowardsOther    
 ,BehaviorTowardsOtherComment    
 ,MoodsEmotion    
 ,MoodsEmotionComment    
 ,SelfHarmfulBehavior    
 ,SelfHarmfulBehaviorComment    
 ,SubstanceUse    
 ,SubstanceUseComment    
 ,Thinkng    
 ,ThinkngComment    
 ,YouthTotalScore    
 ,PrimaryFamilyMaterialNeeds    
 ,PrimaryFamilyMaterialNeedsComment    
 ,PrimaryFamilySocialSupport    
 ,PrimaryFamilySocialSupportComment    
 ,NonCustodialMaterialNeeds    
 ,NonCustodialMaterialNeedsComment    
 ,NonCustodialSocialSupport    
 ,NonCustodialSocialSupportComment    
 ,SurrogateMaterialNeeds    
 ,SurrogateMaterialNeedsComment    
 ,SurrogateSocialSupport    
 ,SurrogateSocialSupportComment    
 ,DischargeCriteria    
 ,PrePlanFiscalIntermediaryComment    
 ,StageOfChange    
 ,PsEducation    
 ,PsEducationNeedsList    
 ,PsMedications    
 ,PsMedicationsNeedsList    
 ,PsMedicationsListToBeModified    
 ,PhysicalConditionQuadriplegic    
 ,PhysicalConditionMultipleSclerosis    
 ,PhysicalConditionBlindness    
 ,PhysicalConditionDeafness    
 ,PhysicalConditionParaplegic    
 ,PhysicalConditionCerebral    
 ,PhysicalConditionMuteness    
 ,PhysicalConditionOtherHearingImpairment    
 ,TestingReportsReviewed    
 ,LOCId    
 ,SevereProfoundDisability    
 ,SevereProfoundDisabilityComment    
 ,EmploymentStatus    
 ,DxTabDisabled
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
  ,PsRiskHigherLevelOfCare
,PsRiskHigherLevelOfCareDueTo
,PsRiskOutOfCountryPlacement
,PsRiskOutOfCountryPlacementDueTo
,PsRiskOutOfHomePlacement
,PsRiskOutOfHomePlacementDueTo
,CommunicableDiseaseAssessed
,CommunicableDiseaseFurtherInfo
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
FROM CustomHRMAssessments a    
WHERE a.documentVersionId = @DocumentVersionId    
 AND isnull(a.RecordDeleted, 'N') = 'N'    
    
--INSERT INTO #CustomCAFAS2 (    
-- DocumentVersionId    
-- ,CAFASDate    
-- ,RaterClinician    
-- ,CAFASInterval    
-- ,SchoolPerformance    
-- ,SchoolPerformanceComment    
-- ,HomePerformance    
-- ,HomePerfomanceComment    
-- ,CommunityPerformance    
-- ,CommunityPerformanceComment    
-- ,BehaviorTowardsOther    
-- ,BehaviorTowardsOtherComment    
-- ,MoodsEmotion    
-- ,MoodsEmotionComment    
-- ,SelfHarmfulBehavior    
-- ,SelfHarmfulBehaviorComment    
-- ,SubstanceUse    
-- ,SubstanceUseComment    
-- ,Thinkng    
-- ,ThinkngComment    
-- ,PrimaryFamilyMaterialNeeds    
-- ,PrimaryFamilyMaterialNeedsComment    
-- ,PrimaryFamilySocialSupport    
-- ,PrimaryFamilySocialSupportComment    
-- ,NonCustodialMaterialNeeds    
-- ,NonCustodialMaterialNeedsComment    
-- ,NonCustodialSocialSupport    
-- ,NonCustodialSocialSupportComment    
-- ,SurrogateMaterialNeeds    
-- ,SurrogateMaterialNeedsComment    
-- ,SurrogateSocialSupport    
-- ,SurrogateSocialSupportComment    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
-- )    
--SELECT DocumentVersionId    
-- ,CAFASDate    
-- ,RaterClinician    
-- ,CAFASInterval    
-- ,SchoolPerformance    
-- ,SchoolPerformanceComment    
-- ,HomePerformance    
-- ,HomePerfomanceComment    
-- ,CommunityPerformance    
-- ,CommunityPerformanceComment    
-- ,BehaviorTowardsOther    
-- ,BehaviorTowardsOtherComment    
-- ,MoodsEmotion    
-- ,MoodsEmotionComment    
-- ,SelfHarmfulBehavior    
-- ,SelfHarmfulBehaviorComment    
-- ,SubstanceUse    
-- ,SubstanceUseComment    
-- ,Thinkng    
-- ,ThinkngComment    
-- ,PrimaryFamilyMaterialNeeds    
-- ,PrimaryFamilyMaterialNeedsComment    
-- ,PrimaryFamilySocialSupport    
-- ,PrimaryFamilySocialSupportComment    
-- ,NonCustodialMaterialNeeds    
-- ,NonCustodialMaterialNeedsComment    
-- ,NonCustodialSocialSupport    
-- ,NonCustodialSocialSupportComment    
-- ,SurrogateMaterialNeeds    
-- ,SurrogateMaterialNeedsComment    
-- ,SurrogateSocialSupport    
-- ,SurrogateSocialSupportComment    
-- ,CreatedBy    
-- ,CreatedDate    
-- ,ModifiedBy    
-- ,ModifiedDate    
-- ,RecordDeleted    
-- ,DeletedDate    
-- ,DeletedBy    
--FROM CustomCAFAS2    
--WHERE DocumentVersionId = @DocumentVersionId    
-- AND isnull(RecordDeleted, 'N') = 'N'    
    
INSERT INTO #CustomMentalStatuses2 (    
 DocumentVersionId    
 ,AppearanceAddToNeedsList    
 ,AppearanceNeatClean    
 ,AppearancePoorHygiene    
 ,AppearanceWellGroomed    
 ,AppearanceAppropriatelyDressed    
 ,AppearanceYoungerThanStatedAge    
 ,AppearanceOlderThanStatedAge    
 ,AppearanceOverweight    
 ,AppearanceUnderweight    
 ,AppearanceEccentric    
 ,AppearanceSeductive    
 ,AppearanceUnkemptDisheveled    
 ,AppearanceOther    
 ,AppearanceComment    
 ,IntellectualAddToNeedsList    
 ,IntellectualAboveAverage    
 ,IntellectualAverage    
 ,IntellectualBelowAverage    
 ,IntellectualPossibleMR    
 ,IntellectualDocumentedMR    
 ,IntellectualOther    
 ,IntellectualComment    
 ,CommunicationAddToNeedsList    
 ,CommunicationNormal    
 ,CommunicationUsesSignLanguage    
 ,CommunicationUnableToRead    
 ,CommunicationNeedForBraille    
 ,CommunicationHearingImpaired    
 ,CommunicationDoesLipReading    
 ,CommunicationEnglishIsSecondLanguage    
 ,CommunicationTranslatorNeeded    
 ,CommunicationOther    
 ,CommunicationComment    
 ,MoodAddToNeedsList    
 ,MoodUnremarkable    
 ,MoodCooperative    
 ,MoodAnxious    
 ,MoodTearful    
 ,MoodCalm    
 ,MoodLabile    
 ,MoodPessimistic    
 ,MoodCheerful    
 ,MoodGuilty    
 ,MoodEuphoric    
 ,MoodDepressed    
 ,MoodHostile    
 ,MoodIrritable    
 ,MoodDramatized    
 ,MoodFearful    
 ,MoodSupicious    
 ,MoodOther    
 ,MoodComment    
 ,AffectAddToNeedsList    
 ,AffectPrimarilyAppropriate    
 ,AffectRestricted    
 ,AffectBlunted    
 ,AffectFlattened    
 ,AffectDetached    
 ,AffectPrimarilyInappropriate    
 ,AffectOther    
 ,AffectComment    
 ,SpeechAddToNeedsList    
 ,SpeechNormal    
 ,SpeechLogicalCoherent    
 ,SpeechTangential    
 ,SpeechSparseSlow    
 ,SpeechRapidPressured    
 ,SpeechSoft    
 ,SpeechCircumstantial    
 ,SpeechLoud    
 ,SpeechRambling    
 ,SpeechOther    
 ,SpeechComment    
 ,ThoughtAddToNeedsList    
 ,ThoughtUnremarkable    
 ,ThoughtParanoid    
 ,ThoughtGrandiose    
 ,ThoughtObsessive    
 ,ThoughtBizarre    
 ,ThoughtFlightOfIdeas    
 ,ThoughtDisorganized    
 ,ThoughtAuditoryHallucinations    
 ,ThoughtVisualHallucinations    
 ,ThoughtTactileHallucinations    
 ,ThoughtOther    
 ,ThoughtComment    
 ,BehaviorAddToNeedsList    
 ,BehaviorNormal    
 ,BehaviorRestless    
 ,BehaviorTremors    
 ,BehaviorPoorEyeContact    
 ,BehaviorAgitated    
 ,BehaviorPeculiar    
 ,BehaviorSelfDestructive    
 ,BehaviorSlowed    
 ,BehaviorDestructiveToOthers    
 ,BehaviorCompulsive    
 ,BehaviorOther    
 ,BehaviorComment    
 ,OrientationAddToNeedsList    
 ,OrientationToPersonPlaceTime    
 ,OrientationNotToPerson    
 ,OrientationNotToPlace    
 ,OrientationNotToTime    
 ,OrientationOther    
 ,OrientationComment    
 ,InsightAddToNeedsList    
 ,InsightGood    
 ,InsightFair    
 ,InsightPoor    
 ,InsightLacking    
 ,InsightOther    
 ,InsightComment    
 ,MemoryAddToNeedsList    
 ,MemoryGoodNormal    
 ,MemoryImpairedShortTerm    
 ,MemoryImpairedLongTerm    
 ,MemoryOther    
 ,MemoryComment    
 ,RealityOrientationAddToNeedsList    
 ,RealityOrientationIntact    
 ,RealityOrientationTenuous    
 ,RealityOrientationPoor    
 ,RealityOrientationOther    
 ,RealityOrientationComment    
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT DocumentVersionId    
 ,AppearanceAddToNeedsList    
 ,AppearanceNeatClean    
 ,AppearancePoorHygiene    
 ,AppearanceWellGroomed    
 ,AppearanceAppropriatelyDressed    
 ,AppearanceYoungerThanStatedAge    
 ,AppearanceOlderThanStatedAge    
 ,AppearanceOverweight    
 ,AppearanceUnderweight    
 ,AppearanceEccentric    
 ,AppearanceSeductive    
 ,AppearanceUnkemptDisheveled    
 ,AppearanceOther    
 ,AppearanceComment    
 ,IntellectualAddToNeedsList    
 ,IntellectualAboveAverage    
 ,IntellectualAverage    
 ,IntellectualBelowAverage    
 ,IntellectualPossibleMR    
 ,IntellectualDocumentedMR    
 ,IntellectualOther    
 ,IntellectualComment    
 ,CommunicationAddToNeedsList    
 ,CommunicationNormal    
 ,CommunicationUsesSignLanguage    
 ,CommunicationUnableToRead    
 ,CommunicationNeedForBraille    
 ,CommunicationHearingImpaired    
 ,CommunicationDoesLipReading    
 ,CommunicationEnglishIsSecondLanguage    
 ,CommunicationTranslatorNeeded    
 ,CommunicationOther    
 ,CommunicationComment    
 ,MoodAddToNeedsList    
 ,MoodUnremarkable    
 ,MoodCooperative    
 ,MoodAnxious    
 ,MoodTearful    
 ,MoodCalm    
 ,MoodLabile    
 ,MoodPessimistic    
 ,MoodCheerful    
 ,MoodGuilty    
 ,MoodEuphoric    
 ,MoodDepressed    
 ,MoodHostile    
 ,MoodIrritable    
 ,MoodDramatized    
 ,MoodFearful    
 ,MoodSupicious    
 ,MoodOther    
 ,MoodComment    
 ,AffectAddToNeedsList    
 ,AffectPrimarilyAppropriate    
 ,AffectRestricted    
 ,AffectBlunted    
 ,AffectFlattened    
 ,AffectDetached    
 ,AffectPrimarilyInappropriate    
 ,AffectOther    
 ,AffectComment    
 ,SpeechAddToNeedsList    
 ,SpeechNormal    
 ,SpeechLogicalCoherent    
 ,SpeechTangential    
 ,SpeechSparseSlow    
 ,SpeechRapidPressured    
 ,SpeechSoft    
 ,SpeechCircumstantial    
 ,SpeechLoud    
 ,SpeechRambling    
 ,SpeechOther    
 ,SpeechComment     ,ThoughtAddToNeedsList    
 ,ThoughtUnremarkable    
 ,ThoughtParanoid    
 ,ThoughtGrandiose    
 ,ThoughtObsessive    
 ,ThoughtBizarre    
 ,ThoughtFlightOfIdeas    
 ,ThoughtDisorganized    
 ,ThoughtAuditoryHallucinations    
 ,ThoughtVisualHallucinations    
 ,ThoughtTactileHallucinations    
 ,ThoughtOther    
 ,ThoughtComment    
 ,BehaviorAddToNeedsList    
 ,BehaviorNormal    
 ,BehaviorRestless    
 ,BehaviorTremors    
 ,BehaviorPoorEyeContact    
 ,BehaviorAgitated    
 ,BehaviorPeculiar    
 ,BehaviorSelfDestructive    
 ,BehaviorSlowed    
 ,BehaviorDestructiveToOthers    
 ,BehaviorCompulsive    
 ,BehaviorOther    
 ,BehaviorComment    
 ,OrientationAddToNeedsList    
 ,OrientationToPersonPlaceTime    
 ,OrientationNotToPerson    
 ,OrientationNotToPlace    
 ,OrientationNotToTime    
 ,OrientationOther    
 ,OrientationComment    
 ,InsightAddToNeedsList    
 ,InsightGood    
 ,InsightFair    
 ,InsightPoor    
 ,InsightLacking    
 ,InsightOther    
 ,InsightComment    
 ,MemoryAddToNeedsList    
 ,MemoryGoodNormal    
 ,MemoryImpairedShortTerm    
 ,MemoryImpairedLongTerm    
 ,MemoryOther    
 ,MemoryComment    
 ,RealityOrientationAddToNeedsList    
 ,RealityOrientationIntact    
 ,RealityOrientationTenuous    
 ,RealityOrientationPoor    
 ,RealityOrientationOther    
 ,RealityOrientationComment    
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
FROM CustomMentalStatuses2    
WHERE DocumentVersionId = @DocumentVersionId    
 AND isnull(RecordDeleted, 'N') = 'N'    
    
INSERT INTO #CustomHRMAssessmentSupports2 (    
 DocumentVersionId    
 ,SupportDescription    
 ,[Current]    
 ,PaidSupport    
 ,UnpaidSupport    
 ,ClinicallyRecommended    
 ,CustomerDesired    
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT DocumentVersionId    
 ,SupportDescription    
 ,[Current]    
 ,PaidSupport    
 ,UnpaidSupport    
 ,ClinicallyRecommended    
 ,CustomerDesired    
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
FROM CustomHRMAssessmentSupports2    
WHERE DocumentVersionId = @DocumentVersionId    
 AND isnull(RecordDeleted, 'N') = 'N'    
    
--      
--DX Tables      
--      
CREATE TABLE #DiagnosesIandII (    
 DocumentVersionId INT    
 ,Axis INT NOT NULL    
 ,DSMCode CHAR(6) NOT NULL    
 ,DSMNumber INT NOT NULL    
 ,DiagnosisType INT    
 ,RuleOut CHAR(1)    
 ,Billable CHAR(1)    
 ,Severity INT    
 ,DSMVersion VARCHAR(6) NULL    
 ,DiagnosisOrder INT NOT NULL    
 ,Specifier TEXT NULL    
 ,RowIdentifier CHAR(36)    
 ,CreatedBy VARCHAR(100)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(100)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME NULL    
 ,DeletedBy VARCHAR(100)    
 )    
    
INSERT INTO #DiagnosesIandII (    
 DocumentVersionId    
 ,Axis    
 ,DSMCode    
 ,DSMNumber    
 ,DiagnosisType    
 ,RuleOut    
 ,Billable    
 ,Severity    
 ,DSMVersion    
 ,DiagnosisOrder    
 ,Specifier    
 ,RowIdentifier    
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT DocumentVersionId    
 ,Axis    
 ,DSMCode    
 ,DSMNumber    
 ,DiagnosisType    
 ,RuleOut    
 ,Billable    
 ,Severity    
 ,DSMVersion    
 ,DiagnosisOrder    
 ,Specifier    
 ,a.RowIdentifier    
 ,a.CreatedBy    
 ,a.CreatedDate    
 ,a.ModifiedBy    
 ,a.ModifiedDate    
 ,a.RecordDeleted    
 ,a.DeletedDate    
 ,a.DeletedBy    
FROM DiagnosesIAndII a    
WHERE a.documentversionId = @documentversionId    
 AND isnull(a.RecordDeleted, 'N') = 'N'    
    
CREATE TABLE #DiagnosesV (    
 DocumentVersionId INT    
 ,AxisV INT NULL    
 ,CreatedBy VARCHAR(100)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(100)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME NULL    
 ,DeletedBy VARCHAR(100)    
 )    
    
INSERT INTO #DiagnosesV (    
 DocumentVersionId    
 ,AxisV    
 ,CreatedBy    
 ,CreatedDate    
 ,ModifiedBy    
 ,ModifiedDate    
 ,RecordDeleted    
 ,DeletedDate    
 ,DeletedBy    
 )    
SELECT DocumentVersionId    
 ,AxisV    
 ,a.CreatedBy    
 ,a.CreatedDate    
 ,a.ModifiedBy    
 ,a.ModifiedDate    
 ,a.RecordDeleted    
 ,a.DeletedDate    
 ,a.DeletedBy    
FROM DiagnosesV a    
WHERE a.documentversionId = @documentversionId    
 AND isnull(a.RecordDeleted, 'N') = 'N'    
    
--Changes Made By Rakesh to validate ASAM Pop up for Kalamazoo    
--*TABLE CREATE*--                     
CREATE TABLE #CustomASAMPlacements (    
 DocumentVersionId INT    
 ,Dimension1LevelOfCare INT    
 ,Dimension2LevelOfCare INT    
 ,Dimension3LevelOfCare INT    
 ,Dimension4LevelOfCare INT    
 ,Dimension5LevelOfCare INT    
 ,Dimension6LevelOfCare INT    
 )    
    
--*INSERT LIST*--                     
INSERT INTO #CustomASAMPlacements (    
 DocumentVersionId    
 ,Dimension1LevelOfCare    
 ,Dimension2LevelOfCare    
 ,Dimension3LevelOfCare    
 ,Dimension4LevelOfCare    
 ,Dimension5LevelOfCare    
 ,Dimension6LevelOfCare    
 )    
--*Select LIST*--                     
SELECT DocumentVersionId    
 ,Dimension1LevelOfCare    
 ,Dimension2LevelOfCare    
 ,Dimension3LevelOfCare    
 ,Dimension4LevelOfCare    
 ,Dimension5LevelOfCare    
 ,Dimension6LevelOfCare    
FROM CustomASAMPlacements    
WHERE DocumentVersionId = @documentversionId    
 AND isnull(RecordDeleted, 'N') = 'N'    
    
--Changes End here    
    
----CustomDocumentAssessmentSubstanceUses--    
CREATE TABLE #CustomDocumentAssessmentSubstanceUses (    
 DocumentVersionId int    
 ,CreatedBy VARCHAR(100)    
 ,CreatedDate DATETIME    
 ,ModifiedBy VARCHAR(100)    
 ,ModifiedDate DATETIME    
 ,RecordDeleted CHAR(1)    
 ,DeletedDate DATETIME NULL    
 ,DeletedBy VARCHAR(100)    
 ,UseOfAlcohol char(1)    
 ,AlcoholAddToNeedsList char(1)    
 ,UseOfTobaccoNicotine char(1)    
 ,UseOfTobaccoNicotineQuit DATETIME  NULL  
 ,UseOfTobaccoNicotineTypeOfFrequency varchar(100)    
 ,UseOfTobaccoNicotineAddToNeedsList char(1)   
 ,UseOfIllicitDrugs char(1)    
 ,UseOfIllicitDrugsTypeFrequency varchar(100)    
 ,UseOfIllicitDrugsAddToNeedsList char(1)   
 ,PrescriptionOTCDrugs char(1)    
 ,PrescriptionOTCDrugsTypeFrequency varchar(100)    
 ,PrescriptionOTCDrugsAddtoNeedsList char(1)    
 )    
     
--Insert CustomDocumentAssessmentSubstanceUses     
INSERT INTO #CustomDocumentAssessmentSubstanceUses (    
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
 )    
     
--Select CustomDocumentAssessmentSubstanceUses    
SELECT DocumentVersionId    
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
WHERE DocumentVersionId = @documentversionId    
 AND isnull(RecordDeleted, 'N') = 'N'      
   
   
-- ----DocumentFamilyHistory--    
--CREATE TABLE #DocumentFamilyHistory (    
-- DocumentFamilyHistoryId int  
--  ,CreatedBy VARCHAR(100)  
--  ,CreatedDate DATETIME  
--  ,ModifiedBy VARCHAR(100)  
--  ,ModifiedDate DATETIME  
--  ,RecordDeleted CHAR(1)    
--  ,DeletedBy DATETIME  
--  ,DeletedDate DATETIME  
--  ,DocumentVersionId int  
--  ,FamilyMemberType int  
--  ,IsLiving char(1)  
--  ,CurrentAge int  
--  ,CauseOfDeath varchar(100)  
--  ,Hypertension char(1)  
--  ,Hyperlipidemia char(1)  
--  ,Diabetes char(1)  
--  ,DiabetesType1 char(1)  
--  ,DiabetesType2 char(1)  
--  ,Alcoholism char(1)  
--  ,COPD char(1)  
--  ,Depression char(1)  
--  ,ThyroidDisease char(1)  
--  ,CoronaryArteryDisease char(1)  
--  ,Cancer char(1)  
--  ,CancerType int  
--  ,Other char(1)  
--  ,OtherComment varchar(100)  
--  ,DiseaseConditionDXCode varchar(100)
--  ,DiseaseConditionDXCodeDescription varchar(1000)
-- )    
     
----Insert DocumentFamilyHistory     
--INSERT INTO #DocumentFamilyHistory (    
--   DocumentFamilyHistoryId  
--  ,CreatedBy  
--  ,CreatedDate  
--  ,ModifiedBy  
--  ,ModifiedDate  
--  ,RecordDeleted  
--  ,DeletedBy  
--  ,DeletedDate  
--  ,DocumentVersionId  
--  ,FamilyMemberType  
--  ,IsLiving  
--  ,CurrentAge  
--  ,CauseOfDeath  
--  ,Hypertension  
--  ,Hyperlipidemia  
--  ,Diabetes  
--  ,DiabetesType1  
--  ,DiabetesType2  
--  ,Alcoholism  
--  ,COPD  
--  ,Depression  
--  ,ThyroidDisease  
--  ,CoronaryArteryDisease  
--  ,Cancer  
--  ,CancerType  
--  ,Other  
--  ,OtherComment
--  ,DiseaseConditionDXCode 
--  ,DiseaseConditionDXCodeDescription  
-- )    
     
----Select DocumentFamilyHistory    
--SELECT DocumentFamilyHistoryId  
--  ,CreatedBy  
--  ,CreatedDate  
--  ,ModifiedBy  
--  ,ModifiedDate  
--  ,RecordDeleted  
--  ,DeletedBy  
--  ,DeletedDate  
--  ,DocumentVersionId  
--  ,FamilyMemberType  
--  ,IsLiving  
--  ,CurrentAge  
--  ,CauseOfDeath  
--  ,Hypertension  
--  ,Hyperlipidemia  
--  ,Diabetes  
--  ,DiabetesType1  
--  ,DiabetesType2  
--  ,Alcoholism  
--  ,COPD  
--  ,Depression  
--  ,ThyroidDisease  
--  ,CoronaryArteryDisease  
--  ,Cancer  
--  ,CancerType  
--  ,Other  
--  ,OtherComment  
--  ,DiseaseConditionDXCode 
--  ,DiseaseConditionDXCodeDescription  
--FROM DocumentFamilyHistory     
--WHERE DocumentVersionId = @documentversionId    
-- AND isnull(RecordDeleted, 'N') = 'N'      
    
-- CustomDocumentPreEmploymentActivities  
--CREATE TABLE #CustomDocumentPreEmploymentActivities (    
--  DocumentVersionId int  
--  ,CreatedBy varchar(100)  
--  ,CreatedDate DATETIME  
--  ,ModifiedBy VARCHAR(100)  
--  ,ModifiedDate DATETIME  
--  ,RecordDeleted CHAR(1)  
--  ,DeletedBy DATETIME  
--  ,DeletedDate DATETIME  
--  ,EducationTraining char(1)  
--  ,EducationTrainingNeeds char(1)  
--  ,EducationTrainingNeedsComments varchar(100)  
--  ,PersonalCareerPlanning char(1)  
--  ,PersonalCareerPlanningNeeds char(1)  
--  ,PersonalCareerPlanningNeedsComments varchar(100)  
--  ,EmploymentOpportunities char(1)  
--  ,EmploymentOpportunitiesNeeds char(1)  
--  ,EmploymentOpportunitiesNeedsComments varchar(100)  
--  ,SupportedEmployment char(1)  
--  ,SupportedEmploymentNeeds char(1)  
--  ,SupportedEmploymentNeedsComments varchar(100)  
--  ,WorkHistory char(1)  
--  ,WorkHistoryNeeds char(1)  
--  ,WorkHistoryNeedsComments varchar(100)  
--  ,GainfulEmploymentBenefits char(1)  
--  ,GainfulEmploymentBenefitsNeeds char(1)  
--  ,GainfulEmploymentBenefitsNeedsComments varchar(100)  
--  ,GainfulEmployment char(1)  
--  ,GainfulEmploymentNeeds char(1)  
--  ,GainfulEmploymentNeedsComments varchar(100)  
-- )    
     
--Insert CustomDocumentPreEmploymentActivities     
--INSERT INTO #CustomDocumentPreEmploymentActivities (    
--  DocumentVersionId  
-- ,CreatedBy  
-- ,CreatedDate  
-- ,ModifiedBy  
-- ,ModifiedDate  
-- ,RecordDeleted  
-- ,DeletedBy  
-- ,DeletedDate  
-- ,EducationTraining  
-- ,EducationTrainingNeeds  
-- ,EducationTrainingNeedsComments  
-- ,PersonalCareerPlanning  
-- ,PersonalCareerPlanningNeeds  
-- ,PersonalCareerPlanningNeedsComments  
-- ,EmploymentOpportunities  
-- ,EmploymentOpportunitiesNeeds  
-- ,EmploymentOpportunitiesNeedsComments  
-- ,SupportedEmployment  
-- ,SupportedEmploymentNeeds  
-- ,SupportedEmploymentNeedsComments  
-- ,WorkHistory  
-- ,WorkHistoryNeeds  
-- ,WorkHistoryNeedsComments  
-- ,GainfulEmploymentBenefits  
-- ,GainfulEmploymentBenefitsNeeds  
-- ,GainfulEmploymentBenefitsNeedsComments  
-- ,GainfulEmployment  
-- ,GainfulEmploymentNeeds  
-- ,GainfulEmploymentNeedsComments  
-- )    
     
--Select CustomDocumentPreEmploymentActivities    
--SELECT   
-- DocumentVersionId  
-- ,CreatedBy  
-- ,CreatedDate  
-- ,ModifiedBy  
-- ,ModifiedDate  
-- ,RecordDeleted  
-- ,DeletedBy  
-- ,DeletedDate  
-- ,EducationTraining  
-- ,EducationTrainingNeeds  
-- ,EducationTrainingNeedsComments  
-- ,PersonalCareerPlanning  
-- ,PersonalCareerPlanningNeeds  
-- ,PersonalCareerPlanningNeedsComments  
-- ,EmploymentOpportunities  
-- ,EmploymentOpportunitiesNeeds  
-- ,EmploymentOpportunitiesNeedsComments  
-- ,SupportedEmployment  
-- ,SupportedEmploymentNeeds  
-- ,SupportedEmploymentNeedsComments  
-- ,WorkHistory  
-- ,WorkHistoryNeeds  
-- ,WorkHistoryNeedsComments  
-- ,GainfulEmploymentBenefits  
-- ,GainfulEmploymentBenefitsNeeds  
-- ,GainfulEmploymentBenefitsNeedsComments  
-- ,GainfulEmployment  
-- ,GainfulEmploymentNeeds  
-- ,GainfulEmploymentNeedsComments  
-- FROM CustomDocumentPreEmploymentActivities  
-- WHERE ISNULL(RecordDeleted, 'N') = 'N'           
--    AND DocumentVersionId = @DocumentVersionId     
      
  
--CustomDocumentCraffts For Kalamazoo--  
CREATE TABLE #CustomDocumentCraffts (   
 DocumentVersionId int ,   
  CreatedBy varchar(100) ,          
  CreatedDate DATETIME,          
  ModifiedBy varchar(100),          
  ModifiedDate DATETIME,          
  RecordDeleted DATETIME,          
  DeletedBy DATETIME,          
  DeletedDate DATETIME,          
  CrafftApplicable char(1),          
  CrafftApplicableReason varchar(max),     
  CrafftQuestionC char(1),          
  CrafftQuestionR char(1),          
  CrafftQuestionA char(1),          
  CrafftQuestionF char(1),          
  CrafftQuestionFR char(1),          
  CrafftQuestionT char(1),          
  CrafftCompleteFullSUAssessment char(1),          
  CrafftStageOfChange int          
 )    
     
--Insert CustomDocumentCraffts     
INSERT INTO #CustomDocumentCraffts (    
  DocumentVersionId,  
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
 )    
     
 --Select CustomDocumentCraffts            
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
    
-- DECLARE VARIABLES      
--      
DECLARE @AdultOrChild CHAR(1)    
DECLARE @Diagnosis CHAR(2)    
DECLARE @AssessmentType CHAR(1)    
DECLARE @CafasRater CHAR(1)    
DECLARE @ClientId INT    
 ,@EffectiveDate DATETIME    
DECLARE @Age DECIMAL(10, 2)    
DECLARE @AuthorId INT    
DECLARE @Variables VARCHAR(max)    
DECLARE @DocumentType VARCHAR(20)    
DECLARE @RunSUAssessmentValidations CHAR(1)    
DECLARE @AxisIIIBug CHAR(1) 
Declare @ClientSU CHAR(1)  
    
--Determine if SU Assessment validation are required      

set @ClientSU = (    
  SELECT ClientInSAPopulation    
  FROM #CustomHRMAssessments    
  ) 
    
SET @AdultOrChild = (    
  SELECT AdultOrChild    
  FROM #CustomHRMAssessments    
  ) 
 IF @AdultOrChild='A'
 BEGIN
			 IF EXISTS (    
			  SELECT DocumentVersionId    
			  FROM #CustomHRMAssessments    
			  WHERE (    
				CASE     
				 WHEN isnull(UncopeQuestionU, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionN, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionC, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionO, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionP, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END + CASE     
				 WHEN isnull(UncopeQuestionE, 'X') = 'Y'    
				  THEN 1    
				 ELSE 0    
				 END > 2    
				)  
				OR isnull(ClientInSAPopulation, 'N') = 'Y'
			  )    
			BEGIN    
			 SET @RunSUAssessmentValidations = 'Y'    
			END       
	END
 ELSE
	 BEGIN
	  IF EXISTS (SELECT DocumentVersionId    
	  FROM #CustomDocumentCraffts    
	  WHERE (    
		CASE     
		 WHEN isnull(CrafftQuestionC, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionR, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionA, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionF, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionFR, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END + CASE     
		 WHEN isnull(CrafftQuestionT, 'X') = 'Y'    
		  THEN 1    
		 ELSE 0    
		 END > 2    
		)
		OR isnull(@ClientSU, 'N') = 'Y'
		)
	BEGIN    
	 SET @RunSUAssessmentValidations = 'Y'    
	END     
 END
 
SET @Diagnosis = (    
  SELECT CASE     
    WHEN isnull(ClientInDDPopulation, 'N') = 'Y'    
     THEN 'DD'    
    ELSE 'MH'    
    END    
  FROM #CustomHRMAssessments    
  )    
SET @AssessmentType = (    
  SELECT AssessmentType    
  FROM #CustomHRMAssessments    
  )    
    
IF EXISTS (    
  SELECT a.DocumentVersionId    
  FROM #CustomHRMAssessments a    
  JOIN Documents d ON d.CurrentDocumentVersionId = a.DocumentVersionId    
  JOIN CustomCafasRaters cr ON cr.StaffId = d.AuthorId    
  WHERE d.CurrentDocumentVersionId = @DocumentVersionId    
   AND isnull(cr.Active, 'N') = 'Y'    
  )    
BEGIN    
 SET @CafasRater = 'Y'    
END    
    
SELECT @ClientId = clientId    
 ,@AuthorId = AuthorId    
 ,@EffectiveDate = EffectiveDate    
FROM documents    
WHERE CurrentdocumentVersionId = @DocumentVersionId    
    
SELECT @Age = dbo.GetAge(isnull(a.ClientDOB, '1/1/1900'), @EffectiveDate)    
FROM #CustomHRMAssessments a    
    
--      
--TEMP Axis III Fix      
--      
IF EXISTS (    
  SELECT d.DocumentId    
  FROM documents d    
  JOIN clients c ON c.ClientId = d.CLientId    
  WHERE documentcodeid IN (    
    349    
    ,10018    
    )    
   AND STATUS IN (21)    
   AND EXISTS (    
    SELECT di.DocumentVersionId    
    FROM diagnosesIandII di    
    WHERE di.documentversionid = d.currentdocumentversionid    
     AND isnull(di.recorddeleted, 'N') = 'N'    
    )    
   AND NOT EXISTS (    
    SELECT di.DocumentVersionId    
    FROM diagnosesIII di    
    WHERE di.documentversionid = d.currentdocumentversionid    
     AND isnull(di.recorddeleted, 'N') = 'N'    
    )    
   AND isnull(d.recorddeleted, 'n') = 'N'    
   AND d.currentdocumentversionId = @DocumentVersionId    
  )    
BEGIN    
 BEGIN TRAN    
    
 INSERT INTO diagnosesIII (DocumentVersionId)    
 VALUES (@DocumentVersionId)    
    
 INSERT INTO diagnosesIV (DocumentVersionId)    
 VALUES (@DocumentVersionId)    
    
 INSERT INTO diagnosesV (DocumentVersionId)    
 VALUES (@DocumentVersionId)    
    
 COMMIT TRAN    
    
 --Update GAF Score on MI ADULT      
 DECLARE @Gafscore INT    
    
 IF @AdultOrChild = 'A'    
  AND @Diagnosis = 'MH'    
 BEGIN    
  EXEC scsp_HRMCalculateGAFScoreFromDLA @DocumentVersionId    
   ,@GAFScore OUTPUT    
    
  IF @@error = 0    
  BEGIN    
   UPDATE DiagnosesV    
   SET AxisV = @GAFScore    
   WHERE DocumentVersionId = @DocumentVersionId    
  END    
 END    
    
 -- Track the issue      
 INSERT INTO CustomBugTrackingHRMAssessmentAxisVIssue (    
  DocumentVersionId    
  ,CreatedDate    
  )    
 VALUES (    
  @DocumentVersionId    
  ,getdate()    
  )    
    
 SET @AxisIIIBug = 'Y'    
END    
    
--      
-- Intake Consult Document Type to restrict validations      
--      
DECLARE @Consult CHAR(1)    
    
SET @Consult = 'N'    
    
SELECT @Consult = CASE     
  WHEN isnull(ClientIsAppropriateForTreatment, 'Y') = 'N'    
   THEN 'Y'    
  ELSE @Consult    
  END    
FROM #CustomHRMAssessments    
    
/*      
 --Create signature validation      
 Insert into #validationReturnTable      
 (TableName,      
 ColumnName,      
 ErrorMessage,      
  PageIndex      
 )      
 Select 'CustomHRMAssessments', 'DeletedBy','*ERROR - Diag Axis III, IV, V - Please re-enter diagnosis and sign again.',16      
*/ 
  Create Table #DocumentDiagnosisCodes          
(          
 ICD10CodeId Varchar(20) NULL ,          
 ICD10Code Varchar(20) NULL ,          
 ICD9Code Varchar(20) NULL ,          
 DiagnosisType int,          
 RuleOut char(1),          
 Billable char(1),          
 Severity int,         
 DiagnosisOrder int NOT NULL ,          
 Specifier text NULL ,          
 CreatedBy varchar(100),          
 CreatedDate Datetime,          
 ModifiedBy varchar(100),          
 ModifiedDate Datetime,          
 RecordDeleted char(1),          
 DeletedDate datetime NULL ,          
 DeletedBy varchar(100) ,  
 DocumentVersionId int         
)
Insert into #DocumentDiagnosisCodes          
(          
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,          
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,          
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,           
RecordDeleted, DeletedDate, DeletedBy,DocumentVersionId)          
          
select          
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,          
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,          
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,           
RecordDeleted, DeletedDate, DeletedBy,DocumentVersionId          
FROM DocumentDiagnosisCodes          
where documentversionId = @documentversionId          
and isnull(RecordDeleted,'N') = 'N' 

Insert into #validationReturnTable (  TableName, ColumnName, ErrorMessage,TabOrder)   
SELECT 'DocumentDiagnosisCodes','DiagnosisType','DX - Only one primary type should be available',13 From #DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and((Select Count(*) AS RecordCount from #DocumentDiagnosisCodes WHERE DocumentVersionId =
 @DocumentVersionId AND DiagnosisType = 140 AND ISNULL(RecordDeleted,'N') = 'N') > 1) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = 'Y' and DocumentVersionId=@DocumentVersionId)  
UNION  
SELECT 'DocumentDiagnosisCodes','DiagnosisType','DX - Primary Diagnosis must have a billing order of 1',13 From #DocumentDiagnosisCodes where exists (Select 1 from #DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 
and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = 'Y' and DocumentVersionId=@DocumentVersionId)  


   
DECLARE @SevereProfoundDisability CHAR(1)    
    
SET @SevereProfoundDisability = (    
  SELECT SevereProfoundDisability    
  FROM #CustomHRMAssessments    
  )    
--      
-- DECLARE TABLE SELECT VARIABLES      
--      
SET @Variables = 'Declare @DocumentVersionId int,@AssessmentType char(1),@DocumentId int      
     ,@CafasRater char(1),@ClientId int, @EffectiveDate datetime,@Age decimal(10,2),@AuthorId int      
     ,@RunSUAssessmentValidations char(1), @AxisIIIBug char(1), @SevereProfoundDisability char(1)      
     Set @DocumentVersionId = ' + convert(VARCHAR(20), @DocumentVersionId) + ' ' + 'Set @DocumentId = ' + convert(VARCHAR(20), @DocumentId) + ' ' + 'Set @AssessmentType = ''' + isnull(@AssessmentType, '') + ''' ' + 'Set @CafasRater = ''' + isnull(@CafasRater, '') + ''' ' + 'Set @ClientId = ''' + isnull(convert(VARCHAR(20), @ClientId), '') + ''' ' + 'Set @EffectiveDate = ''' + convert(VARCHAR(10), @EffectiveDate, 101) + ''' ' + 'Set @Age = ''' + isnull(convert(VARCHAR(10), @Age), '') + ''' ' + 'Set @AuthorId = ''' + isnull(convert(VARCHAR(20), @AuthorId), '') + ''' ' + 'Set @RunSUAssessmentValidations = ''' + isnull(@RunSUAssessmentValidations, 'N') + ''' ' + 'Set @AxisIIIBug = ''' + isnull(@AxisIIIBug, 'N') + ''' ' + 'Set @SevereProfoundDisability = ''' 
  
+ isnull(    
  @SevereProfoundDisability, 'N') + ''' '    
    
IF isnull(@Consult, 'N') = 'Y'    
BEGIN    
 SET @DocumentType = 'Cx' + CASE     
   WHEN @Diagnosis = 'MH'    
    THEN 'MHSA'    
   ELSE @Diagnosis    
   END --Groups MH & SA      
  + CASE     
   WHEN @Diagnosis = 'DD'    
    THEN ''    
   ELSE @AdultOrChild    
   END --Excludes Age if      
  + CASE     
   WHEN @AssessmentType = 'A'    
    THEN 'A'    
   ELSE ''    
   END --Add Annual specifier for pencil icon validations      
END    
ELSE    
 IF isnull(@Consult, 'N') = 'N'    
 BEGIN    
  SET @DocumentType = CASE     
    WHEN @Diagnosis = 'MH'    
     THEN 'MHSA'    
    ELSE @Diagnosis    
    END --Groups MH & SA      
   + CASE     
    WHEN @Diagnosis = 'DD'    
     THEN ''    
    ELSE @AdultOrChild    
    END --Excludes Age if        
   + CASE     
    WHEN @AssessmentType = 'A'    
     THEN 'A'    
    ELSE ''    
    END --Add Annual specifier for pencil icon validations      
 END    
 ELSE    
 BEGIN    
  SET @DocumentType = CASE     
    WHEN @Diagnosis = 'MH'    
     THEN 'MHSA'    
    ELSE @Diagnosis    
    END --Groups MH & SA      
   + CASE     
    WHEN @Diagnosis = 'DD'    
     THEN ''    
    ELSE @AdultOrChild    
    END --Excludes Age if       
   + CASE     
    WHEN @AssessmentType = 'A'    
     THEN 'A'    
    ELSE ''    
    END --Add Annual specifier for pencil icon validations      
 END    
    
--      
-- Exec csp_validateDocumentsTableSelect to determine validation list      
--    
  
EXEC csp_validateDocumentsTableSelect @DocumentVersionId    
 ,@DocumentCodeId    
 ,@DocumentType    
 ,@Variables    
 
 EXEC Csp_validatecustomdocumentdla20 @DocumentVersionId 
    
/*      
Insert into #validationReturnTable      
(TableName,      
ColumnName,      
ErrorMessage,      
 PageIndex      
)      
      
      
      
      
      
--      
-- 0 - Initial       
--      
Select 'CustomHRMAssessments', 'ReferralType', 'Initial - Referral Source is required', 0      
Union      
Select 'CustomHRMAssessments', 'PresentingProblem', 'Initial - Presenting Problem is required', 0      
Union      
Select 'CustomHRMAssessments', 'CurrentPrimaryCarePhysician', 'Initial - Primary Care Physician is required', 0      
Union      
Select 'CustomHRMAssessments', 'DesiredOutcomes', 'Initial - Desired Outcomes is required', 0      
Union      
Select 'CustomHRMAssessments', 'ReasonForUpdate', 'Initial - Reason for Update is required', 0      
From #CustomHRMAssessments      
where isnull(AssessmentType, 'X')= 'U'      
and isnull(convert(varchar(8000), ReasonForUpdate), '') = ''      
Union      
Select 'CustomHRMAssessments', 'ReasonForUpdate', 'Initial - Summary of Progress is required', 0      
From #CustomHRMAssessments      
where isnull(AssessmentType, 'X')= 'A'      
and isnull(convert(varchar(8000), ReasonForUpdate), '') = ''      
      
      
--      
-- 1- CAFAS      
--      
      
Union      
Select 'CustomHRMAssessments', 'CAFASDate', 'CAFAS - Date is required', 1      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
      
      
Union      
Select 'CustomHRMAssessments', 'RaterClinician', 'CAFAS - Rater is required', 1      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'CAFASInterval', 'CAFAS - Interval is required', 1      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - School/work performance score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and SchoolPerformance is null       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - School/work performance comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),SchoolPerformanceComment), '') = ''      
and SchoolPerformance >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Home performance score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and HomePerformance is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Home performance comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),HomePerfomanceComment), '') = ''      
and HomePerformance >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Community performance score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and CommunityPerformance is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Community performance comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),CommunityPerformanceComment), '') = ''      
and CommunityPerformance >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Behavior toward others score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and BehaviorTowardsOther is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Behavior toward others comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),BehaviorTowardsOtherComment), '') = ''      
and BehaviorTowardsOther >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Moods/emotions score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and MoodsEmotion is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Moods/emotions comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),MoodsEmotionComment), '') = ''      
and MoodsEmotion >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Self-harmful behavior score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and SelfHarmfulBehavior is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Self-harmful behavior comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),SelfHarmfulBehaviorComment), '') = ''      
and SelfHarmfulBehavior >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Substance use score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and SubstanceUse is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Substance use comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),SubstanceUseComment), '') = ''      
and SubstanceUse >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Thinking score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and Thinkng is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Thinking comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),ThinkngComment), '') = ''      
and Thinkng >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/family - material score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and PrimaryFamilyMaterialNeeds is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/family - material comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),PrimaryFamilyMaterialNeedsComment), '') = ''      
and PrimaryFamilyMaterialNeeds >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/family - support score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and PrimaryFamilySocialSupport is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/family - support comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),PrimaryFamilySocialSupportComment), '') = ''      
and PrimaryFamilySocialSupport >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/non custodial - material score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and NonCustodialMaterialNeeds is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/non custodial - material comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),NonCustodialMaterialNeedsComment), '') = ''      
and NonCustodialMaterialNeeds >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/non custodial - support score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and NonCustodialSocialSupport is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/non custodial - support comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),NonCustodialSocialSupportComment), '') = ''      
and NonCustodialSocialSupport >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/surrogate - material score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and SurrogateMaterialNeeds is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/surrogate - material comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),SurrogateMaterialNeedsComment), '') = ''      
and SurrogateMaterialNeeds >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/surrogate - support score is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and SurrogateSocialSupport is null      
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'CAFAS - Caregiver/surrogate - support comment is required', 1      
From #CustomHRMAssessments      
where @AdultOrChild = 'C'and @Diagnosis = 'MH'      
and isnull(convert(varchar(8000),SurrogateSocialSupportComment), '') = ''      
and SurrogateSocialSupport >= 10       
and @AssessmentType <> 'S'      
and @CafasRater = 'Y'      
      
      
      
--      
-- 2- DLA      
--      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'DLA - Section is required' , 2      
From #CustomHRMAssessments a      
left join CustomHRMAssessmentActivityScores s on s.DocumentId = a.DocumentId and s.Version = a.Version      
where isnull(s.DocumentId, 0) = 0      
and isnull(s.recorddeleted, 'N')= 'N'      
and @AdultOrChild = 'A'and @Diagnosis = 'MH'      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'DLA - Score requried for: ' + isnull(convert(varchar(300), HRMActivityDescription), '') , 2      
From #CustomHRMAssessments a      
join CustomHRMAssessmentActivityScores s on s.DocumentId = a.DocumentId and s.Version = a.Version      
join CustomHRMActivities q on q.HRMActivityId = s.HRMActivityId      
where isnull(s.ActivityScore, 0) = 0      
and isnull(s.recorddeleted, 'N')= 'N'      
and isnull(q.recorddeleted, 'N')= 'N'      
and @AdultOrChild = 'A'and @Diagnosis = 'MH'      
      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'DLA - Narrative requried for: ' + isnull(convert(varchar(300), HRMActivityDescription), '') , 2      
From #CustomHRMAssessments a      
join CustomHRMAssessmentActivityScores s on s.DocumentId = a.DocumentId and s.Version = a.Version      
join CustomHRMActivities q on q.HRMActivityId = s.HRMActivityId      
where ((isnull(s.ActivityScore, 10) <= 4  and isnull(activityScore, 10) <> 0 )      
    OR      
  q.HRMActivityID in (2, 3, 6, 7, 8, 9, 13, 14, 15, 16)      
  )       
and isnull(activityComment, '') = ''      
and isnull(s.recorddeleted, 'N')= 'N'      
and isnull(q.recorddeleted, 'N')= 'N'      
and @AdultOrChild = 'A'and @Diagnosis = 'MH'      
--select * from CustomHRMAssessmentActivityScores      
--select * from CustomHRMActivities      
--      
-- 3- DD Eligibility      
--      
      
Union      
Select 'CustomHRMAssessments', 'DDEPreviouslyMet', 'DD Eligibility - Eligibility criteria previously met is required', 3      
where @Diagnosis = 'DD'      
Union      
Select 'CustomHRMAssessments', 'DDAttributableMentalPhysicalLimitation', 'DD Eligibility - Attributable to mental/physcial limitation? is required', 3      
From #CustomHRMAssessments a      
where @Diagnosis = 'DD'      
and DDEPreviouslyMet = 'N'      
Union      
Select 'CustomHRMAssessments', 'DDManifestBeforeAge22', 'DD Eligibility - Manifested before age 22? is required', 3      
From #CustomHRMAssessments a      
where @Diagnosis = 'DD'      
and DDEPreviouslyMet = 'N'      
      
Union      
Select 'CustomHRMAssessments', 'DDContinueIndefinitely', 'DD Eligibility - Likely to continue indefinitely? is required', 3      
From #CustomHRMAssessments a      
where @Diagnosis = 'DD'      
and DDEPreviouslyMet = 'N'   
      
Union      
Select 'CustomHRMAssessments', 'DDNeedMulitpleSupports', 'DD Eligibility - Need for multiple services/supports? is required', 3      
From #CustomHRMAssessments a      
where @Diagnosis = 'DD'      
and DDEPreviouslyMet = 'N'      
      
      
      
--      
-- 4- DD RAP 1      
--      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP - Community section required', 4      
From #CustomHRMAssessments a      
where      
exists (select * from CustomHRMRAPQuestions q2      
    left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId      
        and s2.DocumentId = a.DocumentId      
        and s2.Version = a.Version      
        and isnull(s2.RecordDeleted, 'N')= 'N'      
    where       
    s2.DocumentId is null      
    and q2.RAPDomain = 'Community Inclusion'      
    )      
          
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP - ' + isnull(RAPDomain, '') + ': Question ' + isnull(convert(varchar(20), RAPQuestionNumber), '') + ' is required', 4      
From #CustomHRMAssessments a      
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version  join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId      
where q.RAPDomain = 'Community Inclusion'      
and RAPAssessedValue is null      
and isnull(s.recorddeleted, 'N')= 'N'      
and isnull(q.recorddeleted, 'N')= 'N'      
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
      
      
--      
-- 5- DD RAP 2      
--      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP - Behaviors section required', 5      
From #CustomHRMAssessments a      
where      
exists (select * from CustomHRMRAPQuestions q2      
    left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId      
        and s2.DocumentId = a.DocumentId      
        and s2.Version = a.Version      
        and isnull(s2.RecordDeleted, 'N')= 'N'      
    where       
    s2.DocumentId is null      
    and q2.RAPDomain = 'Challenging Behaviors'      
    )      
          
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
union      
Select 'CustomHRMAssessments', 'Deletedby', 'RAP (CB Domain) - ' + isnull(RAPDomain, '') + ': Question ' + isnull(convert(varchar(20), RAPQuestionNumber), '') + ' is required', 5      
From #CustomHRMAssessments a      
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version      
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId      
where q.RAPDomain = 'Challenging Behaviors'      
and RAPAssessedValue is null      
and isnull(s.recorddeleted, 'N')= 'N'      
and isnull(q.recorddeleted, 'N')= 'N'      
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
      
      
--      
-- 6- DD RAP 3      
--      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP - Health section required', 5      
From #CustomHRMAssessments a      
where      
exists (select * from CustomHRMRAPQuestions q2      
    left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId      
        and s2.DocumentId = a.DocumentId      
        and s2.Version = a.Version      
        and isnull(s2.RecordDeleted, 'N')= 'N'      
    where       
    s2.DocumentId is null      
    and q2.RAPDomain = 'Health and Health Care'      
    )      
          
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP (HHC Domain) - ' + isnull(RAPDomain, '') + ': Question ' + isnull(convert(varchar(20), RAPQuestionNumber), '') + ' is required',6      
From #CustomHRMAssessments a      
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version      
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId      
where q.RAPDomain = 'Health and Health Care'      
and RAPAssessedValue is null      
and isnull(s.recorddeleted, 'N')= 'N'      
and isnull(q.recorddeleted, 'N')= 'N'      
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
      
      
--      
-- 24- DD RAP Current Ability      
--      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP - Abilities section required', 5      
From #CustomHRMAssessments a      
where      
exists (select * from CustomHRMRAPQuestions q2      
    left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId      
        and s2.DocumentId = a.DocumentId      
        and s2.Version = a.Version      
        and isnull(s2.RecordDeleted, 'N')= 'N'      
    where       
    s2.DocumentId is null      
    and q2.RAPDomain = 'Current Abilities'      
    )      
          
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
union      
Select 'CustomHRMAssessments', 'DeletedBy', 'RAP (CB Domain) - ' + isnull(RAPDomain, '') + ': Question ' + isnull(convert(varchar(20), RAPQuestionNumber), '') + ' is required', 24      
From #CustomHRMAssessments a      
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version      
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId      
where q.RAPDomain = 'Current Abilities'      
and RAPAssessedValue is null      
and isnull(s.recorddeleted, 'N')= 'N'      
and isnull(q.recorddeleted, 'N')= 'N'      
and @Diagnosis = 'DD'      
and AssessmentType <> 'S'      
      
      
      
      
--      
-- 7- UNCOPE      
--      
union      
Select 'CustomHRMAssessments', 'UncopeApplicable', 'UNCOPE - Is UNCOPE applicable selection required', 7      
from #CustomHRMAssessments      
where @Age >= 12      
and @Diagnosis <> 'DD'      
      
union      
Select 'CustomHRMAssessments', 'UncopeApplicableReason', 'UNCOPE - Not applicable reason is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'N'      
and @Age >= 12      
and @Diagnosis <> 'DD'      
      
union      
Select 'CustomHRMAssessments', 'UncopeQuestionU', 'UNCOPE - Question 1 is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'UncopeQuestionN', 'UNCOPE - Question 2 is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'UncopeQuestionC', 'UNCOPE - Question 3 is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'UncopeQuestionO', 'UNCOPE - Question 4 is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'UncopeQuestionP', 'UNCOPE - Question 5 is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'Y'      
      
Union      
Select 'CustomHRMAssessments', 'UncopeQuestionE', 'UNCOPE - Question 6 is required', 7      
From #CustomHRMAssessments a      
where UncopeApplicable = 'Y'      
Union      
Select 'CustomHRMAssessments', 'DeletedBy', 'UNCOPE - Stage of Change is required', 7      
From #CustomHRMAssessments       
where case when isnull(UncopeQuestionU, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionN, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionC, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionO, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionP, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionE, 'X') ='Y' then 1 else 0 end       
  > 2 and StageOfChange is null      
  and UncopeApplicable = 'Y'      
      
      
      
--      
-- 8- PS Adult      
--      
      
      
union      
select 'CustomHRMAssessments', 'PsCurrentHealthIssues', 'Psychosocial - Adult: Current Health Issues selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Current Health Issues narrative is required',8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCurrentHealthIssuesComment), '')= ''      
and isnull(PsCurrentHealthIssues, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
-- NEW      
union      
select 'CustomHRMAssessments', 'PsMedications', 'Psychosocial - Adult: Medications selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Medications narrative is required',8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsMedicationsComment), '')= ''      
and isnull(PsMedications, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Abuse or Neglect narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsClientAbuesIssuesComment), '')= ''      
and isnull(PsClientAbuseIssues, 'N')  = 'Y'      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'PsClientAbuseIssues', 'Psychosocial - Adult: Abuse or Neglect selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsLegalIssues', 'Psychosocial - Adult: Legal Issues selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Legal Issues narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsLegalIssuesComment), '')= ''      
and isnull(PsLegalIssues, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
      
union      
select 'CustomHRMAssessments', 'PsCulturalEthnicIssues', 'Psychosocial - Adult: Cultural/ethnic issue selection is required',8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Cultural/ethnic narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCulturalEthnicIssuesComment), '')=''      
and isnull(PsCulturalEthnicIssues, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsSpiritualityIssues', 'Psychosocial - Adult: Spirituality concern selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Spirituality concern narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSpiritualityIssuesComment), '')= ''      
and isnull(PsSpiritualityIssues, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
--NEW      
union      
select 'CustomHRMAssessments', 'PsEducation', 'Psychosocial - Adult: Education selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Adult: Education narrative is required',8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsEducationComment), '')= ''      
and isnull(PsEducation, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'HistMentalHealthTx', 'Psychosocial - History: Mental health treatment selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Mental health treatment narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistMentalHealthTxComment), '')= ''      
and isnull(HistMentalHealthTx, 'N')  = 'Y'      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'HistFamilyMentalHealthTx', 'Psychosocial - History: Family mental health treatment selection is required', 8      
WHERE @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Family mental health treatment narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistFamilyMentalHealthTxComment), '')= ''      
and isnull(HistFamilyMentalHealthTx, 'N')  = 'Y'      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'HistPreviousDx', 'Psychosocial - History: Previous Dx selection is required', 8      
where @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Previous Dx narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistPreviousDxComment), '')= ''      
and isnull(HistPreviousDx, 'N')  = 'Y'      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsTraumaticIncident', 'Psychosocial - History: Previous traumatic incident selection is required', 8      
where @AdultOrChild = 'A' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Previous traumatic incident narrative is required', 8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsTraumaticIncidentComment), '')= ''      
and isnull(PsTraumaticIncident, 'N')  = 'Y'      
and @AdultOrChild = 'A' and @Diagnosis = 'MH'      
      
      
--      
-- 9- PS Child      
--      
union      
select 'CustomHRMAssessments', 'PsCurrentHealthIssues', 'Psychosocial - Child: Physical issues selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Physical issues narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCurrentHealthIssuesComment), '')= ''      
and isnull(PsCurrentHealthIssues, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
--NEW      
union      
select 'CustomHRMAssessments', 'PsMedications', 'Psychosocial - Child: Medications selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Medications narrative is required',9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsMedicationsComment), '')= ''      
and isnull(PsMedications, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsDevelopmentalMilestones', 'Psychosocial - Child: Developmental milestones selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Developmental milestones narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsDevelopmentalMilestonesComment), '')= ''      
and ((isnull(PsDevelopmentalMilestones, 'N')  in ('Y', 'N', 'U') and @AssessmentType <> 'S') or (isnull(PsDevelopmentalMilestones, 'N')  in ('Y') and @AssessmentType = 'S'))      
      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
      
union      
select 'CustomHRMAssessments', 'PsPrenatalExposure', 'Psychosocial - Child: Prenatal exposure selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Prenatal exposure narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsPrenatalExposureComment), '')= ''      
and isnull(PsPrenatalExposure, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsChildMentalHealthHistory', 'Psychosocial - Child: Mental health history of family/child selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Mental health history of family/child narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsChildMentalHealthHistoryComment), '')= ''      
and isnull(PsChildMentalHealthHistory, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
      
      
union      
select 'CustomHRMAssessments', 'PsChildEnvironmentalFactors', 'Psychosocial - Child: Environmental factors selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Environmental factors narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsChildEnvironmentalFactorsComment), '')= ''      
and isnull(PsChildEnvironmentalFactors, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsImmunizations', 'Psychosocial - Child: Immunizations current selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Immunizations current narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsImmunizationsComment), '')= ''      
and isnull(PsImmunizations, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsLanguageFunctioning', 'Psychosocial - Child: Language functioning selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Language functioning narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsLanguageFunctioningComment), '')= ''      
and isnull(PsLanguageFunctioning, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsVisualFunctioning', 'Psychosocial - Child: Visual functioning selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Visual functioning narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsVisualFunctioningComment), '')= ''      
and isnull(PsVisualFunctioning, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsIntellectualFunctioning', 'Psychosocial - Child: Intellectual functioning selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Intellectual functioning narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsIntellectualFunctioningComment), '')= ''      
and isnull(PsIntellectualFunctioning, 'N')  in ('Y', 'N', 'U')      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsLearningAbility', 'Psychosocial - Child: Learning ability selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Learning ability narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsLearningAbilityComment), '')= ''      
and isnull(PsLearningAbility, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsPeerInteraction', 'Psychosocial - Child: Peer interaction selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Peer interaction narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsPeerInteractionComment), '')= ''      
and isnull(PsPeerInteraction, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsChildHousingIssues', 'Psychosocial - Child: Housing selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Housing narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsChildHousingIssuesComment), '')= ''      
and isnull(PsChildHousingIssues, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsClientAbuseIssues', 'Psychosocial - Child: Abuse or neglect selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Abuse or neglect narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsClientAbuesIssuesComment), '')= ''      
and isnull(PsClientAbuseIssues, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsSexuality', 'Psychosocial - Child: Sexuality selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Sexuality narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSexualityComment), '')= ''      
and isnull(PsSexuality, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsFamilyFunctioning', 'Psychosocial - Child: Functioning of the family selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Functioning of the family narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsFamilyFunctioningComment), '')= ''      
and isnull(PsFamilyFunctioning, 'N')  in ( 'Y', 'N')      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsLegalIssues', 'Psychosocial - Child: Legal issues selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Legal issues narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsLegalIssuesComment), '')= ''      
and ((isnull(PsLegalIssues, 'N')  in ('Y', 'N', 'U') and @AssessmentType <> 'S') or (isnull(PsLegalIssues, 'N')  in ('Y') and @AssessmentType = 'S'))      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
      
union      
select 'CustomHRMAssessments', 'PsCulturalEthnicIssues', 'Psychosocial - Child: Cultural/ethnic issues selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Cultural/ethnic issues narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCulturalEthnicIssuesComment), '')= ''      
and ((isnull(PsCulturalEthnicIssues, 'N')  in ('Y', 'N', 'U') and @AssessmentType <> 'S') or (isnull(PsCulturalEthnicIssues, 'N')  in ('Y') and @AssessmentType = 'S'))      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsSpiritualityIssues', 'Psychosocial - Child: Spirituality selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Spritituality narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSpiritualityIssuesComment), '')= ''      
and ((isnull(PsSpiritualityIssues, 'N')  in ('Y', 'N', 'U') and @AssessmentType <> 'S') or (isnull(PsSpiritualityIssues, 'N')  in ('Y') and @AssessmentType = 'S'))      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsParentalParticipation', 'Psychosocial - Child: Parents/guardian unwilling selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Parents/guardian unwilling narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsParentalParticipationComment), '')= ''      
and isnull(PsParentalParticipation, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsTraumaticIncident', 'Psychosocial - Child: Physical or emotional trauma selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Physical or emotional trauma narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsTraumaticIncidentComment), '')= ''      
and isnull(PsTraumaticIncident, 'N')  = 'Y'      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
union      
select 'CustomHRMAssessments', 'PsSchoolHistory', 'Psychosocial - Child: School history selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: School history narrative is required', 9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSchoolHistoryComment), '')= ''      
and ((isnull(PsSchoolHistory, 'N')  in ('Y', 'N', 'U') and @AssessmentType <> 'S') or (isnull(PsSchoolHistory, 'N')  in ('Y') and @AssessmentType = 'S'))      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
--NEW      
union      
select 'CustomHRMAssessments', 'PsEducation', 'Psychosocial - Education: School history selection is required', 9      
where @AdultOrChild = 'C' and @Diagnosis = 'MH'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - Child: Education narrative is required',9      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsEducationComment), '')= ''      
and ((isnull(PsEducation, 'N')  in ('Y', 'N', 'U') and @AssessmentType <> 'S') or (isnull(PsEducation, 'N')  in ('Y') and @AssessmentType = 'S'))      
and @AdultOrChild = 'C' and @Diagnosis = 'MH'      
      
      
      
      
--      
-- 10- PS DD 1      
--      
      
--NEW      
union      
select 'CustomHRMAssessments', 'PsCurrentHealthIssues', 'Psychosocial - DD: Current Health Issues selection is required', 8      
WHERE  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Current Health Issues narrative is required',8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCurrentHealthIssuesComment), '')= ''      
and isnull(PsCurrentHealthIssues, 'N')  in ('Y', 'N', 'U')      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
--NEW      
union      
select 'CustomHRMAssessments', 'PsMedications', 'Psychosocial - DD: Medications selection is required', 8      
WHERE @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Medications narrative is required',8      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsMedicationsComment), '')= ''      
and isnull(PsMedications, 'N')  in ('Y', 'N', 'U')      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsClientAbuseIssues', 'Psychosocial - DD: Abuse or neglect selection is required', 10      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Abuse or neglect narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsClientAbuesIssuesComment), '')= ''      
and isnull(PsClientAbuseIssues, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
union      
select 'CustomHRMAssessments', 'PsLegalIssues', 'Psychosocial - DD: Legal issues selection is required', 10      
where @AdultOrChild = 'C' and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Legal issues narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsLegalIssuesComment), '')= ''      
and isnull(PsLegalIssues, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsCulturalEthnicIssues', 'Psychosocial - DD: Cultural/ethnic issues selection is required', 10      
where @AdultOrChild = 'C' and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Cultural/ethnic issues narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCulturalEthnicIssuesComment), '')= ''      
and isnull(PsCulturalEthnicIssues, 'N')  = 'Y'      
AND @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsSpiritualityIssues', 'Psychosocial - DD: Spirituality selection is required', 10      
where @AdultOrChild = 'C' and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Spritituality narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSpiritualityIssuesComment), '')= ''      
and isnull(PsSpiritualityIssues, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
--NEW      
union      
select 'CustomHRMAssessments', 'PsEducation', 'Psychosocial - DD: Education selection is required', 10      
where @AdultOrChild = 'C' and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - DD: Education narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsEducationComment), '')= ''      
and isnull(PsEducation, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
      
union      
select 'CustomHRMAssessments', 'HistMentalHealthTx', 'Psychosocial - History: Mental health treatment selection is required', 10      
WHERE  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Mental health treatment narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistMentalHealthTxComment), '')= ''      
and isnull(HistMentalHealthTx, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'HistFamilyMentalHealthTx', 'Psychosocial - History: Family mental health treatment selection is required', 10      
WHERE  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Family mental health treatment narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistFamilyMentalHealthTxComment), '')= ''      
and isnull(HistFamilyMentalHealthTx, 'N')  = 'Y'      
and  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'HistDevelopmental', 'Psychosocial - History: Developmental selection is required', 10      
where @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Developmental narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistDevelopmentalComment), '')= ''      
and isnull(HistDevelopmental, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'HistResidential', 'Psychosocial - History: Residential selection is required', 10      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Residential narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistResidentialComment), '')= ''      
and isnull(HistResidential, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'HistOccupational', 'Psychosocial - History: Occupational selection is required', 10      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Occupational narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistOccupationalComment), '')= ''      
and isnull(HistOccupational, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'HistLegalFinancial', 'Psychosocial - History: Legal/financial selection is required', 10      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Psychosocial - History: Legal/financial narrative is required', 10      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), HistLegalFinancialComment), '')= ''      
and isnull(HistLegalFinancial, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
--      
-- 11- PS DD 2      
--      
union      
select 'CustomHRMAssessments', 'PsGrossFineMotor', 'DD Concerns -  Gross/fine motor selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Gross/fine motor narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsGrossFineMotorComment), '')= ''      
and isnull(PsGrossFineMotor, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsSensoryPerceptual', 'DD Concerns -  Sensory/perceptual selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Sensory/perceptual narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSensoryPerceptualComment), '')= ''      
and isnull(PsSensoryPerceptual, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsCognitiveFunction', 'DD Concerns -  Cognitive function selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Cognitive function narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCognitiveFunctionComment), '')= ''      
and isnull(PsCognitiveFunction, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsCommunicativeFunction', 'DD Concerns -  Communicative function selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Communicative function narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCommunicativeFunctionComment), '')= ''      
and isnull(PsCommunicativeFunction, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsCurrentPsychoSocialFunctiion', 'DD Concerns -  Current psychosocial function selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Current psychosocial function narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsCurrentPsychoSocialFunctiionComment), '')= ''      
and isnull(PsCurrentPsychoSocialFunctiion, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsAdaptiveEquipment', 'DD Concerns -  Adaptive equipment selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Adaptive equipment narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsAdaptiveEquipmentComment), '')= ''      
and isnull(PsAdaptiveEquipment, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsSafetyMobilityHome', 'DD Concerns - Safety/mobility selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Safety/mobility narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSafetyMobilityHomeComment), '')= ''      
and isnull(PsSafetyMobilityHome, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsHealthSafetyChecklistComplete', 'DD Concerns - Home health/safety checklist selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
union      
select 'CustomHRMAssessments', 'PsAccessibilityIssues', 'DD Concerns - Accessibility/community mobility selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Accessibility/community mobility narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsAccessibilityIssuesComment), '')= ''      
and isnull(PsAccessibilityIssues, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsEvacuationTraining', 'DD Concerns - Emergency evacuation training selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Emergency evacuation training narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsEvacuationTrainingComment), '')= ''      
and isnull(PsEvacuationTraining, 'N')  = 'N'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'Ps24HourSetting', 'DD Concerns - 24 hours supervised setting selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - 24 hours supervised setting narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), Ps24HourSettingComment), '')= ''      
and isnull(Ps24HourSetting, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'Ps24HourNeedsAwakeSupervision', 'DD Concerns - Needs awake supervision selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
union      
select 'CustomHRMAssessments', 'PsSpecialEdEligibility', 'DD Concerns - Special education eligibility selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Special education eligibility  narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSpecialEdEligibilityComment), '')= ''      
and isnull(PsSpecialEdEligibility, 'N')  = 'N'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsSpecialEdEnrolled', 'DD Concerns - Enrolled in special education selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Enrolled in special education narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsSpecialEdEnrolledComment), '')= ''      
and isnull(PsSpecialEdEnrolled, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsEmployer', 'DD Concerns - Employed? selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Employed? narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsEmployerComment), '')= ''      
and isnull(PsEmployer, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsEmploymentIssues', 'DD Concerns - Employment issues selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Employment issues narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsEmploymentIssuesComment), '')= ''      
and isnull(PsEmploymentIssues, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
union      
select 'CustomHRMAssessments', 'PsRestrictionsOccupational', 'DD Concerns - Employment restrictions/adaptations selection is required', 11      
where  @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'DD Concerns - Employment restrictions/adaptations narrative is required', 11      
From #CustomHRMAssessments       
Where isnull(convert(varchar(8000), PsRestrictionsOccupationalComment), '')= ''      
and isnull(PsRestrictionsOccupational, 'N')  = 'Y'      
and @Diagnosis = 'DD'      
and @AssessmentType <> 'S'      
      
      
--      
-- 12- PS DD 3      
--      
union      
select 'CustomHRMAssessments', 'PsDDInformationProvidedBy', 'DD Summary - Information on this assessment was provided by is required', 12      
where  @Diagnosis = 'DD'      
      
      
--      
-- 13- Strengths and Supports      
--      
union      
select 'CustomHRMAssessments', 'ClientStrengthsNarrative', 'Strengths and Supports - Strengths is required' , 13      
union      
select 'CustomHRMAssessments', 'NaturalSupportSufficiency', 'Strengths and Supports - Support Sufficiency selection is required', 13      
union      
select 'CustomHRMAssessments', 'NaturalSupportIncreaseDesired', 'Strengths and Supports - Increased Support selection is required', 13      
union      
select 'CustomHRMAssessments', 'CommunityActivitiesCurrentDesired', 'Strengths and Supports - Community Activities comment is required', 13      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'CommunityActivitiesIncreaseDesired', 'Strengths and Supports - Desired Increased Activities selection is required', 13      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Strengths and Supports - Natural and Community Support is required', 13      
From #CustomHRMAssessments a      
where not exists (select * from customhrmassessmentsupports b      
     where b.documentid = a.Documentid      
     and b.Version = a.Version        
     and isnull(b.NaturalSupportType, 'X') = 'C'      
     and isnull(b.recorddeleted, 'N')= 'N')      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Strengths and Supports - Increased Support entry is required', 13      
From #CustomHRMAssessments a      
where not exists (select * from customhrmassessmentsupports b      
     where b.documentid = a.Documentid      
     and b.Version = a.Version        
     and isnull(b.NaturalSupportType, 'X') = 'P'      
     and isnull(b.recorddeleted, 'N')= 'N')      
and NaturalSupportIncreaseDesired = 'Y'      
      
      
union      
select 'CustomHRMAssessments', 'CrisisPlanningClientHasPlan', 'Strengths and Supports - Cri Plan: Does client have crisis plan? ', 13      
union      
select 'CustomHRMAssessments', 'CrisisPlanningDesired', 'Strengths and Supports - Cri Plan: Client desires crisis plan? ', 13      
union      
select 'CustomHRMAssessments', 'CrisisPlanningMoreInfo', 'Strengths and Supports - Cri Plan: Client would like more crisis info?', 13      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Strengths and Supports - Cri Plan: What info was client given regarding crisis plan?', 13      
from #CustomHRMAssessments      
Where CrisisPlanningDesired = 'Y'      
and isnull(convert(Varchar(8000), CrisisPlanningNarrative), '') = ''      
       
--      
-- needs logic on when this is required      
--      
union      
select 'CustomHRMAssessments', 'AdvanceDirectiveClientHasDirective', 'Strengths and Supports - Adv Dir: Does client have advance directive?', 13      
where @AdultOrChild = 'A'      
union      
select 'CustomHRMAssessments', 'AdvanceDirectiveDesired', 'Strengths and Supports - Adv Dir: Client desires advance directive plan?', 13      
where @AdultOrChild = 'A'      
union      
select 'CustomHRMAssessments', 'AdvanceDirectiveMoreInfo', 'Strengths and Supports - Adv Dir: Client would like more info about advance directives?', 13      
where @AdultOrChild = 'A'      
--union      
--select 'CustomHRMAssessments', 'AdvanceDirectiveNarrative', 'Strengths and Supports - Adv Dir: What information was given to the client?', 13      
--where @AdultOrChild = 'A'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Strengths and Supports - Adv Dir: What information was given to the client?', 13      
from #CustomHRMAssessments      
Where (AdvanceDirectiveDesired = 'Y' or AdvanceDirectiveMoreInfo = 'Y')      
and isnull(convert(Varchar(8000), AdvanceDirectiveNarrative), '') = ''      
and @AdultOrChild = 'A'      
      
      
--      
-- 14- Mental Status      
--      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Mental Status - ' + b.SectionLabel + ' selection is required', 14      
from  #CustomHRMAssessments a      
join customhrmmentalstatussections b on b.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId      
where not exists (select * from customhrmassessmentmentalstatusitems c      
     join customhrmmentalstatusitems d on c.HRMMentalStatusItemId = d.HRMMentalStatusItemId      
     where d.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId      
     and c.DocumentId = a.DocumentId      
     and c.Version = a.Version      
     and isnull(c.ItemChecked, 'N') = 'Y'      
     and isnull(c.RecordDeleted, 'N')= 'N'      
     and isnull(d.RecordDeleted, 'N')= 'N'      
     )      
and b.Active = 'Y'      
and isnull(b.RecordDeleted, 'N')= 'N'      
      
--      
--  Mental Status Comment Field      
--      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Mental Status - ' + b.SectionLabel + ' ' + i.MentalStatusLabel+' text is required',14      
from  #CustomHRMAssessments a      
join customhrmmentalstatussections b on b.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId      
Join customhrmmentalstatusitems i on i.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId      
where  exists (select * from customhrmassessmentmentalstatusitems c      
     join customhrmmentalstatusitems d on c.HRMMentalStatusItemId = d.HRMMentalStatusItemId      
     where d.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId      
     and d.HRMMentalStatusItemId = i.HRMMentalStatusItemId      
     and c.DocumentId = a.DocumentId      
     and c.Version = a.Version      
     and isnull(c.ItemChecked, 'N') = 'Y'      
     and isnull(c.ItemNarrative, '')= ''      
     and isnull(c.RecordDeleted, 'N')= 'N'      
     and isnull(d.RecordDeleted, 'N')= 'N'      
     )      
and b.Active = 'Y'      
and i.Active = 'Y'      
and isnull(i.ItemRequiresNarrative, 'N') = 'Y'      
and isnull(b.RecordDeleted, 'N')= 'N'      
and isnull(i.RecordDeleted, 'N')= 'N'      
      
      
--      
--15- Risk Assessment      
--      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Risk Assessment - Suicidality: Not Present/Ideation is required', 15      
From #CustomHRMAssessments       
where isnull(SuicideNotPresent, 'N')= 'N' and isnull(SuicideIdeation, 'N') = 'N'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Risk Assessment - Suicidality: Active/Passive is required', 15      
From #CustomHRMAssessments       
where isnull(SuicideIdeation, 'N') = 'Y'      
and isnull(SuicideActive, 'N')= 'N' and isnull(SuicidePassive, 'N')= 'N'      
union      
select 'CustomHRMAssessments', 'SuicideBehaviorsPastHistory', 'Risk Assessment - Suicidality: Details text is required', 15      
From #CustomHRMAssessments       
where isnull(SuicideIdeation, 'N') = 'Y'      
union      
select 'CustomHRMAssessments', 'SuicideOtherRiskSelfComment', 'Risk Assessment - Suicidality: Other Risk to Self text is required', 15      
From #CustomHRMAssessments       
where isnull(SuicideOtherRiskSelf, 'N') = 'Y'      
      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Risk Assessment - Homicidality: Not Present/Ideation is required', 15      
From #CustomHRMAssessments       
where isnull(HomicideNotPresent, 'N')= 'N' and isnull(HomicideIdeation, 'N') = 'N'      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Risk Assessment - Homicidality: Active/Passive is required', 15      
From #CustomHRMAssessments       
where isnull(HomicideIdeation, 'N') = 'Y'      
and isnull(HomicideActive, 'N')= 'N' and isnull(HomicidePassive, 'N')= 'N'      
union      
select 'CustomHRMAssessments', 'HomicideBehaviorsPastHistory', 'Risk Assessment - Homicidality: Details text is required', 15      
From #CustomHRMAssessments       
where isnull(HomicideIdeation, 'N') = 'Y'      
union      
select 'CustomHRMAssessments', 'HomicideOtherRiskOthersComment', 'Risk Assessment - Homicidality: Other Risk to Self text is required', 15      
From #CustomHRMAssessments       
where isnull(HomicdeOtherRiskOthers, 'N') = 'Y'      
      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Risk Assessment - Physical Agression: Not Present/Toward Self/Toward Others is required', 15      
From #CustomHRMAssessments       
where isnull(PhysicalAgressionNotPresent, 'N')= 'N' and isnull(PhysicalAgressionSelf, 'N') = 'N'and isnull(PhysicalAgressionOthers, 'N') = 'N'      
      
union      
select 'CustomHRMAssessments', 'PhysicalAgressionBehaviorsPastHistory', 'Risk Assessment - Physical Agression: Details text is required', 15      
From #CustomHRMAssessments       
where isnull(PhysicalAgressionSelf, 'N') = 'Y'or isnull(PhysicalAgressionOthers, 'N') = 'Y'      
      
union      
select 'CustomHRMAssessments', 'DeletedBy', 'Risk Assessment - High Risk Clients: clinical intervention text is required', 15      
From #CustomHRMAssessments       
where (isnull(PhysicalAgressionSelf, 'N') = 'Y'      
or isnull(PhysicalAgressionOthers, 'N') = 'Y'       
or isnull(HomicideIdeation, 'N') = 'Y'   
or isnull(SuicideIdeation, 'N') = 'Y')      
and isnull(convert(varchar(8000), RiskClinicalIntervention), '')= ''      
      
union      
select 'CustomHRMAssessments', 'RiskOtherFactors', 'Risk Assessment - Other Risk Factors: details text is required', 15      
From #CustomHRMAssessments       
where isnull(RiskAccessToWeapons, 'N') = 'Y'      
or isnull(RiskAppropriateForAdditionalScreening, 'N') = 'Y'       
      
      
      
      
      
      
--      
--17- Assessment Needs List      
--      
      
--      
--18- Summary      
--      
union      
select 'CustomHRMAssessments', 'ClinicalSummary', 'Summary - Clinical Interpretive Summary is required', 18      
union      
select 'CustomHRMAssessments', 'DischargeCriteria', 'Summary - Criteria for Discharge is required', 18      
      
--      
--19- Pre Plan      
--      
union      
Select 'CustomHRMAssessments', 'Participants','Pre Plan - Participants is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'Facilitator','Pre Plan - Facilitator text is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S' and PrePlanIndependentFacilitatorDesired = 'Y'      
and @AuthorId not in (1022) --Amy Zwart      
      
union      
Select 'CustomHRMAssessments', 'PrePlanIndependentFacilitatorDiscussed','Pre Plan - Was client offered info on independent facilitation?',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'PrePlanIndependentFacilitatorDesired','Pre Plan - Does client request an independent facilitator?',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'TimeLocation','Pre Plan - Time/Location is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'IssuesToAvoid','Pre Plan - Issues to Avoid is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'IssuesToDiscuss','Pre Plan - What does the client wish to discuss?.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'CommunicationAccomodations','Pre Plan - Communication Accomodations is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @AuthorId not in (1022) --Amy Zwart      
--union      
--Select 'CustomHRMAssessments', 'SourceOfPrePlanningInfo','Pre Plan - Source of Pre-Planning Information is required.',19      
union      
Select 'CustomHRMAssessments', 'SelfDeterminationDesired','Pre Plan - Self Determination selection is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @Diagnosis = 'DD'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'FiscalIntermediaryDesired','Pre Plan - Fiscal Intermediary selection is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and @Diagnosis = 'DD'      
and @AuthorId not in (1022) --Amy Zwart      
union      
Select 'CustomHRMAssessments', 'PrePlanFiscalIntermediaryComment','Pre Plan - Self Determination/Fiscal Intermediary text is required.',19      
From #CustomHRMAssessments a      
Where AssessmentType <> 'S'      
and (FiscalIntermediaryDesired = 'Y'      
or SelfDeterminationDesired = 'Y')      
and @Diagnosis = 'DD'      
and @AuthorId not in (1022) --Amy Zwart      
      
      
--      
--20- Level of Care/Servcies      
--      
union      
Select 'CustomHRMAssessments', 'ClientIsAppropriateForTreatment','Level of Care/Services - Is client appropriate for treatment? selection is required.',20      
      
union      
Select 'CustomHRMAssessments', 'SecondOpinionNoticeProvided','Level of Care/Services - Second opinion notice provided selection is required.',20      
From #CustomHRMAssessments a      
where ClientIsAppropriateForTreatment = 'N'      
      
union      
Select 'CustomHRMAssessments', 'TreatmentNarrative','Level of Care/Services - Is client appropriate for treatment? narrative is required.',20      
From #CustomHRMAssessments a      
where ClientIsAppropriateForTreatment = 'N'      
union      
Select 'CustomHRMAssessments', 'OutsideReferralsGiven','Level of Care/Services - Outside referrals given? selection is required.',20      
union      
Select 'CustomHRMAssessments', 'ReferralsNarrative','Level of Care/Services - Outside referrals given? narrative is required.',20      
From #CustomHRMAssessments a      
where OutsideReferralsGiven = 'Y'      
union      
Select 'CustomHRMAssessments', 'AssessmentsNeeded','Level of Care/Services - Assessments needed narrative is required.',20      
union      
Select 'CustomHRMAssessments', 'TreatmentAccomodation','Level of Care/Services - Treatment Accomodation narrative is required.',20      
      
union      
Select 'CustomHRMAssessments', 'DeletedBy','Level of Care/Services - Recommended Service must be selected.',20      
From #CustomHRMAssessments a      
where not exists (select * from CustomHRMAssessmentLevelOfCareOptions l      
     where a.DocumentId = l.DocumentId and a.Version = l.Version      
     and isnull(l.optionselected, 'N')= 'Y'      
     and isnull(l.recorddeleted, 'N')= 'N')      
and ClientIsAppropriateForTreatment = 'Y'      
      
      
union      
Select 'CustomHRMAssessments', 'DeletedBy','Client Needs Error - Please contact tech support.',20      
From #CustomHRMAssessments a      
where exists (select * from customhrmassessmentneeds an      
    join documents d on d.documentid = an.documentid      
    where an.DocumentId = a.DocumentId      
    and exists (select * from Customclientneeds n      
       join clientepisodes ce on ce.clientepisodeid = n.clientepisodeid      
       where n.clientneedid = an.clientneedid      
       and ce.clientid <> d.clientId      
       and isnull(n.recorddeleted, 'N')= 'N')      
    and isnull(an.recorddeleted, 'N')= 'N'      
    and isnull(d.recorddeleted, 'N')= 'N')      
      
union      
Select 'CustomHRMAssessments', 'StaffAxisVReason','Dx - Reason for staff assigned Axis V value is required.',16      
From #CustomHRMAssessments a      
where isnull(StaffAxisV, 0) <> 0      
and @AdultOrChild = 'A'and @Diagnosis = 'MH'      
      
--      
-- Co-Signature requirements      
--      
      
--UNION      
--SELECT 'CustomHRMAssessments', 'DeletedBy', 'Signatures - Physician cosignature is required.', 0      
--From #CustomHRMAssessments t      
--where not exists (select * from DocumentSignatures ds      
--      join staff s on s.staffid = ds.staffid      
--     where s.degree in (10104, 10134) --DR      
--      and ds.documentid = t.documentId      
--     and isnull(ds.RecordDeleted, 'N')= 'N')      
      
--UNION      
--SELECT 'CustomHRMAssessments', 'DeletedBy', 'Signatures - Supervisor cosignature is required.', 0      
--From #CustomHRMAssessments t      
--where not exists (select * from DocumentSignatures ds      
--      join staff s on s.staffid = ds.staffid      
--     where ds.documentid = t.documentid      
--      and s.Supervisor = 'Y'      
--     and isnull(ds.RecordDeleted, 'N')= 'N')      
      
      
*/    
--      
--16- Diagnosis Validation      
--      
--exec csp_validateDiagnosis @DocumentVersionId        
--if @@error <> 0 goto error      
/*  Included in HRM Assessment Validation logic      
--      
--21- SU Assessment Validation      
--      
if exists (select * From #CustomHRMAssessments       
where case when isnull(UncopeQuestionU, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionN, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionC, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionO, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionP, 'X') ='Y' then 1 else 0 end +       
   case when isnull(UncopeQuestionE, 'X') ='Y' then 1 else 0 end       
  > 2 )      
begin      
--exec csp_validateCustomHRMSUAssessments @DocumentVersionId  --RESOLVE SECONDARY PROC BEFORE UNCOMMENTING      
end      
if @@error <> 0 goto error      
*/    
IF @@error <> 0    
 GOTO error    
    
--      
-- GAF calculation workaround      
--      
/*declare @GAFScore int, @Version int      
select @Version = CurrentVersion from Documents where Documentid = @DocumentId      
exec scsp_HRMCalculateGAFScoreFromDLA @DocumentId, @Version, @GAFScore output      
if @@error = 0      
begin      
      
 update DiagnosesV set AxisV = @GAFScore      
 where DocumentId = @DocumentId      
 and Version = @Version      
      
end      
*/    
--Track Client Need For Wrong Client Bug      
--IF EXISTS (    
--  SELECT a.DocumentVersionId    
--  FROM #CustomHRMAssessments a    
--  WHERE EXISTS (    
--    SELECT an.DocumentVersionId    
--    FROM customhrmassessmentneeds an    
--    JOIN documents d ON d.currentdocumentversionid = an.documentversionid    
--    WHERE an.DocumentVersionId = a.DocumentVersionId    
--     AND EXISTS (    
--      SELECT n.ClientEpisodeId    
--      FROM Customclientneeds n    
--      JOIN clientepisodes ce ON ce.clientepisodeid = n.clientepisodeid    
--      WHERE n.clientneedid = an.clientneedid    
--       AND ce.clientid <> d.clientId    
--       AND isnull(n.recorddeleted, 'N') = 'N'    
--      )    
--     AND isnull(an.recorddeleted, 'N') = 'N'    
--     AND isnull(d.recorddeleted, 'N') = 'N'    
--    )    
--  )    
--BEGIN    
-- INSERT INTO CustomHRMAssessmentNeedTracking (    
--  DocumentVersionId    
--  ,CreatedDate    
--  )    
-- SELECT DocumentVersionId    
--  ,Getdate()    
-- FROM #CustomHRMAssessments a    
--END    
    
RETURN    
    
error:    
DECLARE @Error VARCHAR(8000)   
      SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'csp_validateCustomHRMAssessmentNew') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())  
      RAISERROR ( @Error ,-- Message text.   
      16 ,                -- Severity.   
      1                   -- State.   
      ); 
GO


