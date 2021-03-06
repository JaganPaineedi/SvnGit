/****** Object:  StoredProcedure [dbo].[csp_validateCustomHRMAssessmentNew]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMAssessmentNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomHRMAssessmentNew]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomHRMAssessmentNew]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE     PROCEDURE [dbo].[csp_validateCustomHRMAssessmentNew]
@DocumentVersionId int
as


Declare @DocumentCodeId int
Set @DocumentCodeId = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId=@DocumentVersionId)

Declare @DocumentId int
Set @DocumentId = (Select DocumentId From Documents Where CurrentDocumentVersionId=@DocumentVersionId)



--
--Create Temp Tables
--
create table #CustomHRMAssessments
(
	DocumentVersionId int
	,ClientName varchar(150)
	,AssessmentType char(1)
	,CurrentAssessmentDate datetime
	,PreviousAssessmentDate datetime
	,ClientDOB datetime
	,AdultOrChild char(1)
	,ChildHasNoParentalConsent char(1)
	,ClientHasGuardian char(1)
	,GuardianName varchar(150)
	,GuardianAddress varchar(100)
	,GuardianPhone varchar(50)
	,GuardianType int
	,ClientInDDPopulation char(1)
	,ClientInSAPopulation char(1)
	,ClientInMHPopulation char(1)
	,PreviousDiagnosisText varchar(max)
	,ReferralType int
	,PresentingProblem varchar(max)
	,CurrentLivingArrangement int
	,CurrentPrimaryCarePhysician varchar(50)
	,ReasonForUpdate varchar(max)
	,DesiredOutcomes varchar(max)
	,PsMedicationsComment varchar(max)
	,PsEducationComment varchar(max)
	,IncludeFunctionalAssessment char(1)
	,IncludeSymptomChecklist char(1)
	,IncludeUNCOPE char(1)
	,ClientIsAppropriateForTreatment char(1)
	,SecondOpinionNoticeProvided char(1)
	,TreatmentNarrative varchar(max)
	,RapCiDomainIntensity varchar(50)
	,RapCiDomainComment varchar(max)
	,RapCiDomainNeedsList char(1)
	,RapCbDomainIntensity varchar(50)
	,RapCbDomainComment varchar(max)
	,RapCbDomainNeedsList char(1)
	,RapCaDomainIntensity varchar(50)
	,RapCaDomainComment varchar(max)
	,RapCaDomainNeedsList char(1)
	,RapHhcDomainIntensity varchar(50)
	,OutsideReferralsGiven char(1)
	,ReferralsNarrative varchar(max)
	,ServiceOther char(1)
	,ServiceOtherDescription varchar(100)
	,AssessmentAddtionalInformation varchar(max)
	,TreatmentAccomodation varchar(max)
	,Participants varchar(max)
	,Facilitator varchar(max)
	,TimeLocation varchar(max)
	,AssessmentsNeeded varchar(max)
	,CommunicationAccomodations varchar(max)
	,IssuesToAvoid varchar(max)
	,IssuesToDiscuss varchar(max)
	,SourceOfPrePlanningInfo varchar(max)
	,SelfDeterminationDesired char(1)
	,FiscalIntermediaryDesired char(1)
	,PamphletGiven char(1)
	,PamphletDiscussed char(1)
	,PrePlanIndependentFacilitatorDiscussed char(1)
	,PrePlanIndependentFacilitatorDesired char(1)
	,PrePlanGuardianContacted char(1)
	,PrePlanSeparateDocument char(1)
	,CommunityActivitiesCurrentDesired varchar(max)
	,CommunityActivitiesIncreaseDesired char(1)
	,CommunityActivitiesNeedsList char(1)
	,PsCurrentHealthIssues char(1)
	,PsCurrentHealthIssuesComment varchar(max)
	,PsCurrentHealthIssuesNeedsList char(1)
	,HistMentalHealthTx char(1)
	,HistMentalHealthTxNeedsList char(1)
	,HistMentalHealthTxComment varchar(max)
	,HistFamilyMentalHealthTx char(1)
	,HistFamilyMentalHealthTxNeedsList char(1)
	,HistFamilyMentalHealthTxComment varchar(max)
	,PsClientAbuseIssues char(1)
	,PsClientAbuesIssuesComment varchar(max)
	,PsClientAbuseIssuesNeedsList char(1)
	,PsFamilyConcernsComment varchar(max)
	,PsRiskLossOfPlacement char(1)
	,PsRiskLossOfPlacementDueTo int
	,PsRiskSensoryMotorFunction char(1)
	,PsRiskSensoryMotorFunctionDueTo int
	,PsRiskSafety char(1)
	,PsRiskSafetyDueTo int
	,PsRiskLossOfSupport char(1)
	,PsRiskLossOfSupportDueTo int
	,PsRiskExpulsionFromSchool char(1)
	,PsRiskExpulsionFromSchoolDueTo int
	,PsRiskHospitalization char(1)
	,PsRiskHospitalizationDueTo int
	,PsRiskCriminalJusticeSystem char(1)
	,PsRiskCriminalJusticeSystemDueTo int
	,PsRiskElopementFromHome char(1)
	,PsRiskElopementFromHomeDueTo int
	,PsRiskLossOfFinancialStatus char(1)
	,PsRiskLossOfFinancialStatusDueTo int
	,PsDevelopmentalMilestones char(1)
	,PsDevelopmentalMilestonesComment varchar(max)
	,PsDevelopmentalMilestonesNeedsList char(1)
	,PsChildEnvironmentalFactors char(1)
	,PsChildEnvironmentalFactorsComment varchar(max)
	,PsChildEnvironmentalFactorsNeedsList char(1)
	,PsLanguageFunctioning char(1)
	,PsLanguageFunctioningComment varchar(max)
	,PsLanguageFunctioningNeedsList char(1)
	,PsVisualFunctioning char(1)
	,PsVisualFunctioningComment varchar(max)
	,PsVisualFunctioningNeedsList char(1)
	,PsPrenatalExposure char(1)
	,PsPrenatalExposureComment varchar(max)
	,PsPrenatalExposureNeedsList char(1)
	,PsChildMentalHealthHistory char(1)
	,PsChildMentalHealthHistoryComment varchar(max)
	,PsChildMentalHealthHistoryNeedsList char(1)
	,PsIntellectualFunctioning char(1)
	,PsIntellectualFunctioningComment varchar(max)
	,PsIntellectualFunctioningNeedsList char(1)
	,PsLearningAbility char(1)
	,PsLearningAbilityComment varchar(max)
	,PsLearningAbilityNeedsList char(1)
	,PsFunctioningConcernComment varchar(max)
	,PsPeerInteraction char(1)
	,PsPeerInteractionComment varchar(max)
	,PsPeerInteractionNeedsList char(1)
	,PsParentalParticipation char(1)
	,PsParentalParticipationComment varchar(max)
	,PsParentalParticipationNeedsList char(1)
	,PsSchoolHistory char(1)
	,PsSchoolHistoryComment varchar(max)
	,PsSchoolHistoryNeedsList char(1)
	,PsImmunizations char(1)
	,PsImmunizationsComment varchar(max)
	,PsImmunizationsNeedsList char(1)
	,PsChildHousingIssues char(1)
	,PsChildHousingIssuesComment varchar(max)
	,PsChildHousingIssuesNeedsList char(1)
	,PsSexuality char(1)
	,PsSexualityComment varchar(max)
	,PsSexualityNeedsList char(1)
	,PsFamilyFunctioning char(1)
	,PsFamilyFunctioningComment varchar(max)
	,PsFamilyFunctioningNeedsList char(1)
	,PsTraumaticIncident char(1)
	,PsTraumaticIncidentComment varchar(max)
	,PsTraumaticIncidentNeedsList char(1)
	,HistDevelopmental char(1)
	,HistDevelopmentalComment varchar(max)
	,HistResidential char(1)
	,HistResidentialComment varchar(max)
	,HistOccupational char(1)
	,HistOccupationalComment varchar(max)
	,HistLegalFinancial char(1)
	,HistLegalFinancialComment varchar(max)
	,SignificantEventsPastYear varchar(max)
	,PsGrossFineMotor char(1)
	,PsGrossFineMotorComment varchar(max)
	,PsGrossFineMotorNeedsList char(1)
	,PsSensoryPerceptual char(1)
	,PsSensoryPerceptualComment varchar(max)
	,PsSensoryPerceptualNeedsList char(1)
	,PsCognitiveFunction char(1)
	,PsCognitiveFunctionComment varchar(max)
	,PsCognitiveFunctionNeedsList char(1)
	,PsCommunicativeFunction char(1)
	,PsCommunicativeFunctionComment varchar(max)
	,PsCommunicativeFunctionNeedsList char(1)
	,PsCurrentPsychoSocialFunctiion char(1)
	,PsCurrentPsychoSocialFunctiionComment varchar(max)
	,PsCurrentPsychoSocialFunctiionNeedsList char(1)
	,PsAdaptiveEquipment char(1)
	,PsAdaptiveEquipmentComment varchar(max)
	,PsAdaptiveEquipmentNeedsList char(1)
	,PsSafetyMobilityHome char(1)
	,PsSafetyMobilityHomeComment varchar(max)
	,PsSafetyMobilityHomeNeedsList char(1)
	,PsHealthSafetyChecklistComplete char(3)
	,PsAccessibilityIssues char(1)
	,PsAccessibilityIssuesComment varchar(max)
	,PsAccessibilityIssuesNeedsList char(1)
	,PsEvacuationTraining char(1)
	,PsEvacuationTrainingComment varchar(max)
	,PsEvacuationTrainingNeedsList char(1)
	,Ps24HourSetting char(1)
	,Ps24HourSettingComment varchar(max)
	,Ps24HourSettingNeedsList char(1)
	,Ps24HourNeedsAwakeSupervision char(1)
	,PsSpecialEdEligibility char(1)
	,PsSpecialEdEligibilityComment varchar(max)
	,PsSpecialEdEligibilityNeedsList char(1)
	,PsSpecialEdEnrolled char(1)
	,PsSpecialEdEnrolledComment varchar(max)
	,PsSpecialEdEnrolledNeedsList char(1)
	,PsEmployer char(1)
	,PsEmployerComment varchar(max)
	,PsEmployerNeedsList char(1)
	,PsEmploymentIssues char(1)
	,PsEmploymentIssuesComment varchar(max)
	,PsEmploymentIssuesNeedsList char(1)
	,PsRestrictionsOccupational char(1)
	,PsRestrictionsOccupationalComment varchar(max)
	,PsRestrictionsOccupationalNeedsList char(1)
	,PsFunctionalAssessmentNeeded char(1)
	,PsAdvocacyNeeded char(1)
	,PsPlanDevelopmentNeeded char(1)
	,PsLinkingNeeded char(1)
	,PsDDInformationProvidedBy varchar(max)
	,HistPreviousDx char(1)
	,HistPreviousDxComment varchar(max)
	,PsLegalIssues char(1)
	,PsLegalIssuesComment varchar(max)
	,PsLegalIssuesNeedsList char(1)
	,PsCulturalEthnicIssues char(1)
	,PsCulturalEthnicIssuesComment varchar(max)
	,PsCulturalEthnicIssuesNeedsList char(1)
	,PsSpiritualityIssues char(1)
	,PsSpiritualityIssuesComment varchar(max)
	,PsSpiritualityIssuesNeedsList char(1)
	,SuicideNotPresent char(1)
	,SuicideIdeation char(1)
	,SuicideActive char(1)
	,SuicidePassive char(1)
	,SuicideMeans char(1)
	,SuicidePlan char(1)
	,SuicideCurrent char(1)
	,SuicidePriorAttempt char(1)
	,SuicideNeedsList char(1)
	,SuicideBehaviorsPastHistory varchar(max)
	,SuicideOtherRiskSelf char(1)
	,SuicideOtherRiskSelfComment varchar(max)
	,HomicideNotPresent char(1)
	,HomicideIdeation char(1)
	,HomicideActive char(1)
	,HomicidePassive char(1)
	,HomicideMeans char(1)
	,HomicidePlan char(1)
	,HomicideCurrent char(1)
	,HomicidePriorAttempt char(1)
	,HomicideNeedsList char(1)
	,HomicideBehaviorsPastHistory varchar(max)
	,HomicdeOtherRiskOthers char(1)
	,HomicideOtherRiskOthersComment varchar(max)
	,PhysicalAgressionNotPresent char(1)
	,PhysicalAgressionSelf char(1)
	,PhysicalAgressionOthers char(1)
	,PhysicalAgressionCurrentIssue char(1)
	,PhysicalAgressionNeedsList char(1)
	,PhysicalAgressionBehaviorsPastHistory varchar(max)
	,RiskAccessToWeapons char(1)
	,RiskAppropriateForAdditionalScreening char(1)
	,RiskClinicalIntervention varchar(max)
	,RiskOtherFactorsNone char(1)
	,RiskOtherFactors varchar(max)
	,RiskOtherFactorsNeedsList char(1)
	,StaffAxisV int
	,StaffAxisVReason varchar(max)
	,ClientStrengthsNarrative varchar(max)
	,CrisisPlanningClientHasPlan char(1)
	,CrisisPlanningNarrative varchar(max)
	,CrisisPlanningDesired char(1)
	,CrisisPlanningNeedsList char(1)
	,CrisisPlanningMoreInfo char(1)
	,AdvanceDirectiveClientHasDirective char(1)
	,AdvanceDirectiveDesired char(1)
	,AdvanceDirectiveNarrative varchar(max)
	,AdvanceDirectiveNeedsList char(1)
	,AdvanceDirectiveMoreInfo char(1)
	,NaturalSupportSufficiency char(2)
	,NaturalSupportNeedsList char(1)
	,NaturalSupportIncreaseDesired char(1)
	,ClinicalSummary varchar(max)
	,UncopeQuestionU char(1)
	,UncopeApplicable char(1)
	,UncopeApplicableReason varchar(max)
	,UncopeQuestionN char(1)
	,UncopeQuestionC char(1)
	,UncopeQuestionO char(1)
	,UncopeQuestionP char(1)
	,UncopeQuestionE char(1)
	,UncopeCompleteFullSUAssessment char(1)
	,SubstanceUseNeedsList char(1)
	,DecreaseSymptomsNeedsList char(1)
	,DDEPreviouslyMet char(1)
	,DDAttributableMentalPhysicalLimitation char(1)
	,DDDxAxisI varchar(max)
	,DDDxAxisII varchar(max)
	,DDDxAxisIII varchar(max)
	,DDDxAxisIV varchar(max)
	,DDDxAxisV varchar(max)
	,DDDxSource varchar(max)
	,DDManifestBeforeAge22 char(1)
	,DDContinueIndefinitely char(1)
	,DDLimitSelfCare char(1)
	,DDLimitLanguage char(1)
	,DDLimitLearning char(1)
	,DDLimitMobility char(1)
	,DDLimitSelfDirection char(1)
	,DDLimitEconomic char(1)
	,DDLimitIndependentLiving char(1)
	,DDNeedMulitpleSupports char(1)
	,CAFASDate datetime
	,RaterClinician int
	,CAFASInterval int
	,SchoolPerformance int
	,SchoolPerformanceComment varchar(max)
	,HomePerformance int
	,HomePerfomanceComment varchar(max)
	,CommunityPerformance int
	,CommunityPerformanceComment varchar(max)
	,BehaviorTowardsOther int
	,BehaviorTowardsOtherComment varchar(max)
	,MoodsEmotion int
	,MoodsEmotionComment varchar(max)
	,SelfHarmfulBehavior int
	,SelfHarmfulBehaviorComment varchar(max)
	,SubstanceUse int
	,SubstanceUseComment varchar(max)
	,Thinkng int
	,ThinkngComment varchar(max)
	,YouthTotalScore int
	,PrimaryFamilyMaterialNeeds int
	,PrimaryFamilyMaterialNeedsComment varchar(max)
	,PrimaryFamilySocialSupport int
	,PrimaryFamilySocialSupportComment varchar(max)
	,NonCustodialMaterialNeeds int
	,NonCustodialMaterialNeedsComment varchar(max)
	,NonCustodialSocialSupport int
	,NonCustodialSocialSupportComment varchar(max)
	,SurrogateMaterialNeeds int
	,SurrogateMaterialNeedsComment varchar(max)
	,SurrogateSocialSupport int
	,SurrogateSocialSupportComment varchar(max)
	,DischargeCriteria varchar(max)
	,PrePlanFiscalIntermediaryComment varchar(max)
	,StageOfChange int
	,PsEducation char(1)
	,PsEducationNeedsList char(1)
	,PsMedications char(1)
	,PsMedicationsNeedsList char(1)
	,PsMedicationsListToBeModified char(1)
	,PhysicalConditionQuadriplegic char(1)
	,PhysicalConditionMultipleSclerosis char(1)
	,PhysicalConditionBlindness char(1)
	,PhysicalConditionDeafness char(1)
	,PhysicalConditionParaplegic char(1)
	,PhysicalConditionCerebral char(1)
	,PhysicalConditionMuteness char(1)
	,PhysicalConditionOtherHearingImpairment char(1)
	,TestingReportsReviewed varchar(2)
	,LOCId int
	,SevereProfoundDisability char(1)
	,SevereProfoundDisabilityComment varchar(max)
	,EmploymentStatus int
	,DxTabDisabled char(1)
	,CreatedBy varchar(30)
	,CreatedDate datetime
	,ModifiedBy varchar(30)
	,ModifiedDate datetime
	,RecordDeleted char(1)
	,DeletedDate datetime
	,DeletedBy varchar(30)
)

CREATE TABLE #CustomSUAssessments
(	DocumentVersionId int,
	VoluntaryAbstinenceTrial varchar(max),
	Comment varchar(max),
	HistoryOrCurrentDUI char(1),
	NumberOfTimesDUI int,
	HistoryOrCurrentDWI char(1),
	NumberOfTimesDWI int,
	HistoryOrCurrentMIP char(1),
	NumberOfTimeMIP int,
	HistoryOrCurrentBlackOuts char(1),
	NumberOfTimesBlackOut int,
	HistoryOrCurrentDomesticAbuse char(1),
	NumberOfTimesDomesticAbuse int,
	LossOfControl char(1),
	IncreasedTolerance char(1),
	OtherConsequence char(1),
	OtherConsequenceDescription varchar (1000),
	RiskOfRelapse varchar(max),
	PreviousTreatment char(1),
	CurrentSubstanceAbuseTreatment char(1),
	CurrentTreatmentProvider varchar (100),
	CurrentSubstanceAbuseReferralToSAorTx char(1),
	CurrentSubstanceAbuseRefferedReason varchar(max),
	ToxicologyResults varchar(max),
	ClientSAHistory char(1),
	FamilySAHistory char(1),
	SubstanceAbuseAdmittedOrSuspected char(1),
	CurrentSubstanceAbuse char(1),
	SuspectedSubstanceAbuse char(1),
	SubstanceAbuseDetail varchar(max),
	SubstanceAbuseTxPlan char(1),
	OdorOfSubstance char(1),
	SlurredSpeech char(1),
	WithdrawalSymptoms char(1),
	DTOther char(1),
	DTOtherText varchar (100),
	Blackouts char(1),
	RelatedArrests char(1),
	RelatedSocialProblems char(1),
	FrequentJobSchoolAbsence char(1),
	NoneSynptomsReportedOrObserved char(1),
	CreatedBy varchar(100),
	CreatedDate datetime,
	ModifiedBy varchar(100),
	ModifiedDate datetime,
	RecordDeleted char(1),
	DeletedDate datetime,
	DeletedBy varchar(100)
)

CREATE table #CustomCAFAS2
	(DocumentVersionId int
	,CAFASDate datetime
	,RaterClinician int
	,CAFASInterval int
	,SchoolPerformance int
	,SchoolPerformanceComment varchar(max)
	,HomePerformance int
	,HomePerfomanceComment varchar(max)
	,CommunityPerformance int
	,CommunityPerformanceComment varchar(max)
	,BehaviorTowardsOther int
	,BehaviorTowardsOtherComment varchar(max)
	,MoodsEmotion int
	,MoodsEmotionComment varchar(max)
	,SelfHarmfulBehavior int
	,SelfHarmfulBehaviorComment varchar(max)
	,SubstanceUse int
	,SubstanceUseComment varchar(max)
	,Thinkng int
	,ThinkngComment varchar(max)
	,PrimaryFamilyMaterialNeeds int
	,PrimaryFamilyMaterialNeedsComment varchar(max)
	,PrimaryFamilySocialSupport int
	,PrimaryFamilySocialSupportComment varchar(max)
	,NonCustodialMaterialNeeds int
	,NonCustodialMaterialNeedsComment varchar(max)
	,NonCustodialSocialSupport int
	,NonCustodialSocialSupportComment varchar(max)
	,SurrogateMaterialNeeds int
	,SurrogateMaterialNeedsComment varchar(max)
	,SurrogateSocialSupport int
	,SurrogateSocialSupportComment varchar(max)
	,CreatedDate datetime
	,CreatedBy varchar(30)
	,ModifiedDate datetime
	,ModifiedBy varchar(30)
	,RecordDeleted char(1)
	,DeletedDate datetime
	,DeletedBy int)

CREATE table #CustomMentalStatuses2
	(DocumentVersionId int
	,AppearanceAddToNeedsList char(1)
	,AppearanceNeatClean char(1)
	,AppearancePoorHygiene char(1)
	,AppearanceWellGroomed char(1)
	,AppearanceAppropriatelyDressed char(1)
	,AppearanceYoungerThanStatedAge char(1)
	,AppearanceOlderThanStatedAge char(1)
	,AppearanceOverweight char(1)
	,AppearanceUnderweight char(1)
	,AppearanceEccentric char(1)
	,AppearanceSeductive char(1)
	,AppearanceUnkemptDisheveled char(1)
	,AppearanceOther char(1)
	,AppearanceComment varchar(max)
	,IntellectualAddToNeedsList char(1)
	,IntellectualAboveAverage char(1)
	,IntellectualAverage char(1)
	,IntellectualBelowAverage char(1)
	,IntellectualPossibleMR char(1)
	,IntellectualDocumentedMR char(1)
	,IntellectualOther char(1)
	,IntellectualComment varchar(max)
	,CommunicationAddToNeedsList char(1)
	,CommunicationNormal char(1)
	,CommunicationUsesSignLanguage char(1)
	,CommunicationUnableToRead char(1)
	,CommunicationNeedForBraille char(1)
	,CommunicationHearingImpaired char(1)
	,CommunicationDoesLipReading char(1)
	,CommunicationEnglishIsSecondLanguage char(1)
	,CommunicationTranslatorNeeded char(1)
	,CommunicationOther char(1)
	,CommunicationComment varchar(max)
	,MoodAddToNeedsList char(1)
	,MoodUnremarkable char(1)
	,MoodCooperative char(1)
	,MoodAnxious char(1)
	,MoodTearful char(1)
	,MoodCalm char(1)
	,MoodLabile char(1)
	,MoodPessimistic char(1)
	,MoodCheerful char(1)
	,MoodGuilty char(1)
	,MoodEuphoric char(1)
	,MoodDepressed char(1)
	,MoodHostile char(1)
	,MoodIrritable char(1)
	,MoodDramatized char(1)
	,MoodFearful char(1)
	,MoodSupicious char(1)
	,MoodOther char(1)
	,MoodComment varchar(max)
	,AffectAddToNeedsList char(1)
	,AffectPrimarilyAppropriate char(1)
	,AffectRestricted char(1)
	,AffectBlunted char(1)
	,AffectFlattened char(1)
	,AffectDetached char(1)
	,AffectPrimarilyInappropriate char(1)
	,AffectOther char(1)
	,AffectComment varchar(max)
	,SpeechAddToNeedsList char(1)
	,SpeechNormal char(1)
	,SpeechLogicalCoherent char(1)
	,SpeechTangential char(1)
	,SpeechSparseSlow char(1)
	,SpeechRapidPressured char(1)
	,SpeechSoft char(1)
	,SpeechCircumstantial char(1)
	,SpeechLoud char(1)
	,SpeechRambling char(1)
	,SpeechOther char(1)
	,SpeechComment varchar(max)
	,ThoughtAddToNeedsList char(1)
	,ThoughtUnremarkable char(1)
	,ThoughtParanoid char(1)
	,ThoughtGrandiose char(1)
	,ThoughtObsessive char(1)
	,ThoughtBizarre char(1)
	,ThoughtFlightOfIdeas char(1)
	,ThoughtDisorganized char(1)
	,ThoughtAuditoryHallucinations char(1)
	,ThoughtVisualHallucinations char(1)
	,ThoughtTactileHallucinations char(1)
	,ThoughtOther char(1)
	,ThoughtComment varchar(max)
	,BehaviorAddToNeedsList char(1)
	,BehaviorNormal char(1)
	,BehaviorRestless char(1)
	,BehaviorTremors char(1)
	,BehaviorPoorEyeContact char(1)
	,BehaviorAgitated char(1)
	,BehaviorPeculiar char(1)
	,BehaviorSelfDestructive char(1)
	,BehaviorSlowed char(1)
	,BehaviorDestructiveToOthers char(1)
	,BehaviorCompulsive char(1)
	,BehaviorOther char(1)
	,BehaviorComment varchar(max)
	,OrientationAddToNeedsList char(1)
	,OrientationToPersonPlaceTime char(1)
	,OrientationNotToPerson char(1)
	,OrientationNotToPlace char(1)
	,OrientationNotToTime char(1)
	,OrientationOther char(1)
	,OrientationComment varchar(max)
	,InsightAddToNeedsList char(1)
	,InsightGood char(1)
	,InsightFair char(1)
	,InsightPoor char(1)
	,InsightLacking char(1)
	,InsightOther char(1)
	,InsightComment varchar(max)
	,MemoryAddToNeedsList char(1)
	,MemoryGoodNormal char(1)
	,MemoryImpairedShortTerm char(1)
	,MemoryImpairedLongTerm char(1)
	,MemoryOther char(1)
	,MemoryComment varchar(max)
	,RealityOrientationAddToNeedsList char(1)
	,RealityOrientationIntact char(1)
	,RealityOrientationTenuous char(1)
	,RealityOrientationPoor char(1)
	,RealityOrientationOther char(1)
	,RealityOrientationComment varchar(max)
	,CreatedBy varchar(30)
	,CreatedDate datetime
	,ModifiedBy varchar(30)
	,ModifiedDate datetime
	,RecordDeleted char(1)
	,DeletedDate datetime
	,DeletedBy varchar(30))

CREATE table #CustomHRMAssessmentSupports2
	(DocumentVersionId int
	,SupportDescription varchar(max)
	,[Current] char(1)
	,PaidSupport char(1)
	,UnpaidSupport char(1)
	,ClinicallyRecommended char(1)
	,CustomerDesired char(1)
	,CreatedBy varchar(30)
	,CreatedDate datetime
	,ModifiedBy varchar(30)
	,ModifiedDate datetime
	,RecordDeleted char(1)
	,DeletedDate datetime
	,DeletedBy varchar(30))



--
--Insert into Temp Tables
--
Insert into #CustomSUAssessments
(DocumentVersionId,
VoluntaryAbstinenceTrial, [Comment], HistoryOrCurrentDUI, NumberOfTimesDUI, HistoryOrCurrentDWI, 
NumberOfTimesDWI, HistoryOrCurrentMIP, NumberOfTimeMIP, HistoryOrCurrentBlackOuts, NumberOfTimesBlackOut,
 HistoryOrCurrentDomesticAbuse, NumberOfTimesDomesticAbuse, LossOfControl, IncreasedTolerance,
 OtherConsequence, OtherConsequenceDescription, RiskOfRelapse, PreviousTreatment, 
CurrentSubstanceAbuseTreatment, CurrentTreatmentProvider, CurrentSubstanceAbuseReferralToSAorTx,
 CurrentSubstanceAbuseRefferedReason, ToxicologyResults, ClientSAHistory, FamilySAHistory,
 SubstanceAbuseAdmittedOrSuspected, CurrentSubstanceAbuse, SuspectedSubstanceAbuse, SubstanceAbuseDetail, 
SubstanceAbuseTxPlan, OdorOfSubstance, SlurredSpeech, WithdrawalSymptoms, DTOther, DTOtherText,
 Blackouts, RelatedArrests, RelatedSocialProblems, FrequentJobSchoolAbsence, NoneSynptomsReportedOrObserved,
 CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy)
select
a.DocumentVersionId, 
VoluntaryAbstinenceTrial, [Comment], HistoryOrCurrentDUI, NumberOfTimesDUI, HistoryOrCurrentDWI, 
NumberOfTimesDWI, HistoryOrCurrentMIP, NumberOfTimeMIP, HistoryOrCurrentBlackOuts, NumberOfTimesBlackOut,
 HistoryOrCurrentDomesticAbuse, NumberOfTimesDomesticAbuse, LossOfControl, IncreasedTolerance,
 OtherConsequence, OtherConsequenceDescription, RiskOfRelapse, PreviousTreatment, 
CurrentSubstanceAbuseTreatment, CurrentTreatmentProvider, CurrentSubstanceAbuseReferralToSAorTx,
 CurrentSubstanceAbuseRefferedReason, ToxicologyResults, ClientSAHistory, FamilySAHistory,
 SubstanceAbuseAdmittedOrSuspected, CurrentSubstanceAbuse, SuspectedSubstanceAbuse, SubstanceAbuseDetail,
 SubstanceAbuseTxPlan, OdorOfSubstance, SlurredSpeech, WithdrawalSymptoms, DTOther, DTOtherText, 
Blackouts, RelatedArrests, RelatedSocialProblems, FrequentJobSchoolAbsence, NoneSynptomsReportedOrObserved,
a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedDate, a.DeletedBy
FROM CustomSubstanceUseAssessments a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''

Insert into #CustomHRMAssessments
	(DocumentVersionId
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
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedDate
	,DeletedBy)

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
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedDate
,DeletedBy
FROM CustomHRMAssessments a
where a.documentVersionId = @DocumentVersionId
and isnull(a.RecordDeleted,''N'') = ''N''


INSERT into #CustomCAFAS2 (
	DocumentVersionId,
	CAFASDate, 
	RaterClinician, 
	CAFASInterval, 
	SchoolPerformance, 
	SchoolPerformanceComment, 
	HomePerformance, 
	HomePerfomanceComment, 
	CommunityPerformance, 
	CommunityPerformanceComment, 
	BehaviorTowardsOther, 
	BehaviorTowardsOtherComment, 
	MoodsEmotion, 
	MoodsEmotionComment, 
	SelfHarmfulBehavior, 
	SelfHarmfulBehaviorComment, 
	SubstanceUse, 
	SubstanceUseComment, 
	Thinkng, 
	ThinkngComment, 
	PrimaryFamilyMaterialNeeds, 
	PrimaryFamilyMaterialNeedsComment, 
	PrimaryFamilySocialSupport, 
	PrimaryFamilySocialSupportComment, 
	NonCustodialMaterialNeeds, 
	NonCustodialMaterialNeedsComment, 
	NonCustodialSocialSupport, 
	NonCustodialSocialSupportComment, 
	SurrogateMaterialNeeds, 
	SurrogateMaterialNeedsComment, 
	SurrogateSocialSupport, 
	SurrogateSocialSupportComment,
	CreatedBy, 
	CreatedDate, 
	ModifiedBy, 
	ModifiedDate, 
	RecordDeleted, 
	DeletedDate, 
	DeletedBy 
	)
SELECT 
DocumentVersionId,
CAFASDate, 
RaterClinician, 
CAFASInterval, 
SchoolPerformance, 
SchoolPerformanceComment, 
HomePerformance, 
HomePerfomanceComment, 
CommunityPerformance, 
CommunityPerformanceComment, 
BehaviorTowardsOther, 
BehaviorTowardsOtherComment, 
MoodsEmotion, 
MoodsEmotionComment, 
SelfHarmfulBehavior, 
SelfHarmfulBehaviorComment, 
SubstanceUse, 
SubstanceUseComment, 
Thinkng, 
ThinkngComment, 
PrimaryFamilyMaterialNeeds, 
PrimaryFamilyMaterialNeedsComment, 
PrimaryFamilySocialSupport, 
PrimaryFamilySocialSupportComment, 
NonCustodialMaterialNeeds, 
NonCustodialMaterialNeedsComment, 
NonCustodialSocialSupport, 
NonCustodialSocialSupportComment, 
SurrogateMaterialNeeds, 
SurrogateMaterialNeedsComment, 
SurrogateSocialSupport, 
SurrogateSocialSupportComment,
CreatedBy, 
CreatedDate, 
ModifiedBy, 
ModifiedDate, 
RecordDeleted, 
DeletedDate, 
DeletedBy 
From CustomCAFAS2
where DocumentVersionId = @DocumentVersionId
and isnull(RecordDeleted,''N'') = ''N''


INSERT into #CustomMentalStatuses2
	(DocumentVersionId
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
SELECT
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
From CustomMentalStatuses2
Where DocumentVersionId = @DocumentVersionId
and isnull(RecordDeleted,''N'')=''N''


INSERT into #CustomHRMAssessmentSupports2
	(DocumentVersionId
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
SELECT
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
From CustomHRMAssessmentSupports2
Where DocumentVersionId = @DocumentVersionId
and isnull(RecordDeleted,''N'')=''N''



--
--DX Tables
--
Create Table #DiagnosesIandII
(
	DocumentVersionId int,
	Axis int NOT NULL ,
	DSMCode char (6) NOT NULL ,
	DSMNumber int NOT NULL ,
	DiagnosisType int,
	RuleOut char(1),
	Billable char(1),
	Severity int,
	DSMVersion varchar (6) NULL ,
	DiagnosisOrder int NOT NULL ,
	Specifier text NULL ,
	RowIdentifier char(36),
	CreatedBy varchar(100),
	CreatedDate Datetime,
	ModifiedBy varchar(100),
	ModifiedDate Datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100) 
)
Insert into #DiagnosesIandII
(
DocumentVersionId, Axis, DSMCode, DSMNumber, DiagnosisType,
RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier,
 RowIdentifier, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, 
RecordDeleted, DeletedDate, DeletedBy )

select
DocumentVersionId, Axis, DSMCode, DSMNumber, DiagnosisType,
 RuleOut, Billable, Severity, DSMVersion, DiagnosisOrder, Specifier, 
a.RowIdentifier, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate,
 a.RecordDeleted, a.DeletedDate, a.DeletedBy
FROM DiagnosesIAndII a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''


CREATE TABLE #DiagnosesV (
	DocumentVersionId int,
	AxisV int NULL ,
	CreatedBy varchar(100),
	CreatedDate Datetime,
	ModifiedBy varchar(100),
	ModifiedDate Datetime,
	RecordDeleted char(1),
	DeletedDate datetime NULL ,
	DeletedBy varchar(100))

Insert into #DiagnosesV
(
DocumentVersionId, AxisV, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted,
 DeletedDate, DeletedBy
)
select
DocumentVersionId, AxisV, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted,
a.DeletedDate, a.DeletedBy
FROM DiagnosesV a
where a.documentversionId = @documentversionId
and isnull(a.RecordDeleted,''N'') = ''N''

--
-- DECLARE VARIABLES
--
Declare @AdultOrChild char(1)
Declare @Diagnosis char(2)
Declare @AssessmentType char(1)
Declare @CafasRater char(1)
Declare @ClientId int, @EffectiveDate datetime
declare @Age decimal(10,2)
declare @AuthorId int
declare @Variables varchar(max)
declare @DocumentType varchar(20)
declare @RunSUAssessmentValidations char(1)
declare @AxisIIIBug char(1)


--Determine if SU Assessment validation are required
IF exists (select DocumentVersionId From #CustomHRMAssessments 
	where case when isnull(UncopeQuestionU, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionN, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionC, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionO, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionP, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionE, ''X'') =''Y'' then 1 else 0 end 
		> 2 or isnull(UncopeCompleteFullSUAssessment,''N'') = ''Y'' )
	begin
		SET @RunSUAssessmentValidations = ''Y''
	end



set @AdultOrChild = (select AdultOrChild
from #CustomHRMAssessments)

set @Diagnosis = (select Case when isnull(ClientInDDPopulation, ''N'') = ''Y'' then ''DD'' else ''MH'' end 
					from #CustomHRMAssessments)

set @AssessmentType = (select AssessmentType from #CustomHRMAssessments)

If exists (Select a.DocumentVersionId from #CustomHRMAssessments a
			Join Documents d on d.CurrentDocumentVersionId = a.DocumentVersionId
			Join CustomCafasRaters cr on cr.StaffId = d.AuthorId
			Where d.CurrentDocumentVersionId = @DocumentVersionId
			and isnull(cr.Active, ''N'')= ''Y''
			)
Begin 
Set @CafasRater = ''Y''
End


select @ClientId = clientId
		,@AuthorId = AuthorId
		,@EffectiveDate = EffectiveDate 
from documents where CurrentdocumentVersionId = @DocumentVersionId

select @Age = dbo.GetAge(isnull(a.ClientDOB,''1/1/1900''),@EffectiveDate)
from #CustomHRMAssessments  a


--
--TEMP Axis III Fix
--
IF exists (
	select d.DocumentId from documents d
	join clients c on c.ClientId=d.CLientId
	where documentcodeid in (349,1469)
	and status in (21)
	and exists (select di.DocumentVersionId from diagnosesIandII di
				where di.documentversionid = d.currentdocumentversionid
				and isnull(di.recorddeleted, ''N'')= ''N''
				)
	and not exists (select di.DocumentVersionId from diagnosesIII di
				where di.documentversionid = d.currentdocumentversionid
				and isnull(di.recorddeleted, ''N'')= ''N''
				)
	and isnull(d.recorddeleted, ''n'')= ''N''
	and d.currentdocumentversionId = @DocumentVersionId
	)
	BEGIN

		begin tran
			insert into diagnosesIII
			(DocumentVersionId)
			values
			(@DocumentVersionId)

			insert into diagnosesIV
			(DocumentVersionId)
			values
			(@DocumentVersionId)

			insert into diagnosesV
			(DocumentVersionId)
			values
			(@DocumentVersionId)
		commit tran

		--Update GAF Score on MI ADULT
					declare @Gafscore int

					If @AdultOrChild = ''A''and @Diagnosis = ''MH''
						Begin
						exec scsp_HRMCalculateGAFScoreFromDLA @DocumentVersionId, @GAFScore output
						if @@error = 0
							begin

								update DiagnosesV set AxisV = @GAFScore
								where DocumentVersionId = @DocumentVersionId

							end
						End


		-- Track the issue
		Insert into CustomBugTrackingHRMAssessmentAxisVIssue
		(DocumentVersionId, CreatedDate)
		Values
		(@DocumentVersionId, getdate())

		SET @AxisIIIBug = ''Y''

	END

/*
	--Create signature validation
	Insert into #validationReturnTable
	(TableName,
	ColumnName,
	ErrorMessage,
	 PageIndex
	)
	Select ''CustomHRMAssessments'', ''DeletedBy'',''*ERROR - Diag Axis III, IV, V - Please re-enter diagnosis and sign again.'',16
*/

DECLARE @SevereProfoundDisability char(1)
SET @SevereProfoundDisability = (Select SevereProfoundDisability From #CustomHRMAssessments)

--
-- DECLARE TABLE SELECT VARIABLES
--
set @Variables = ''Declare @DocumentVersionId int,@AssessmentType char(1),@DocumentId int
					,@CafasRater char(1),@ClientId int, @EffectiveDate datetime,@Age decimal(10,2),@AuthorId int
					,@RunSUAssessmentValidations char(1), @AxisIIIBug char(1), @SevereProfoundDisability char(1)
					Set @DocumentVersionId = '' + convert(varchar(20), @DocumentVersionId)+ '' ''+
					''Set @DocumentId = '' + convert(varchar(20), @DocumentId)+ '' ''+
					''Set @AssessmentType = ''''''+ isnull(@AssessmentType, '''') + '''''' '' + 
					''Set @CafasRater = ''''''+ isnull(@CafasRater, '''') + '''''' '' + 
					''Set @ClientId = ''''''+ isnull(convert(varchar(20),@ClientId), '''') + '''''' '' + 
					''Set @EffectiveDate = ''''''+ convert(varchar(10),@EffectiveDate,101) + '''''' '' + 
					''Set @Age = ''''''+ isnull(convert(varchar(10),@Age), '''') + '''''' '' + 
					''Set @AuthorId = ''''''+ isnull(convert(varchar(20),@AuthorId), '''') + '''''' '' +
					''Set @RunSUAssessmentValidations = ''''''+ isnull(@RunSUAssessmentValidations,''N'') + '''''' '' +
					''Set @AxisIIIBug = ''''''+ isnull(@AxisIIIBug,''N'') + '''''' '' +
					''Set @SevereProfoundDisability = ''''''+ isnull(@SevereProfoundDisability,''N'') + '''''' ''

set @DocumentType = Case When @Diagnosis=''MH'' Then ''MHSA'' Else @Diagnosis End  --Groups MH & SA
					+ Case When @Diagnosis=''DD'' Then '''' Else @AdultOrChild End  --Excludes Age if 
					+ Case When @AssessmentType=''A'' Then ''A'' Else '''' End		--Add Annual specifier for pencil icon validations

--
-- Exec csp_validateDocumentsTableSelect to determine validation list
--
Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables


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
Select ''CustomHRMAssessments'', ''ReferralType'', ''Initial - Referral Source is required'', 0
Union
Select ''CustomHRMAssessments'', ''PresentingProblem'', ''Initial - Presenting Problem is required'', 0
Union
Select ''CustomHRMAssessments'', ''CurrentPrimaryCarePhysician'', ''Initial - Primary Care Physician is required'', 0
Union
Select ''CustomHRMAssessments'', ''DesiredOutcomes'', ''Initial - Desired Outcomes is required'', 0
Union
Select ''CustomHRMAssessments'', ''ReasonForUpdate'', ''Initial - Reason for Update is required'', 0
From #CustomHRMAssessments
where isnull(AssessmentType, ''X'')= ''U''
and isnull(convert(varchar(8000), ReasonForUpdate), '''') = ''''
Union
Select ''CustomHRMAssessments'', ''ReasonForUpdate'', ''Initial - Summary of Progress is required'', 0
From #CustomHRMAssessments
where isnull(AssessmentType, ''X'')= ''A''
and isnull(convert(varchar(8000), ReasonForUpdate), '''') = ''''


--
-- 1- CAFAS
--

Union
Select ''CustomHRMAssessments'', ''CAFASDate'', ''CAFAS - Date is required'', 1
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and @AssessmentType <> ''S''
and @CafasRater = ''Y''


Union
Select ''CustomHRMAssessments'', ''RaterClinician'', ''CAFAS - Rater is required'', 1
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''CAFASInterval'', ''CAFAS - Interval is required'', 1
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and @AssessmentType <> ''S''
and @CafasRater = ''Y''

Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - School/work performance score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and SchoolPerformance is null 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - School/work performance comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),SchoolPerformanceComment), '''') = ''''
and SchoolPerformance >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''

Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Home performance score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and HomePerformance is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Home performance comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),HomePerfomanceComment), '''') = ''''
and HomePerformance >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Community performance score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and CommunityPerformance is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Community performance comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),CommunityPerformanceComment), '''') = ''''
and CommunityPerformance >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Behavior toward others score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and BehaviorTowardsOther is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Behavior toward others comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),BehaviorTowardsOtherComment), '''') = ''''
and BehaviorTowardsOther >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Moods/emotions score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and MoodsEmotion is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Moods/emotions comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),MoodsEmotionComment), '''') = ''''
and MoodsEmotion >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Self-harmful behavior score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and SelfHarmfulBehavior is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Self-harmful behavior comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),SelfHarmfulBehaviorComment), '''') = ''''
and SelfHarmfulBehavior >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Substance use score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and SubstanceUse is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Substance use comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),SubstanceUseComment), '''') = ''''
and SubstanceUse >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Thinking score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and Thinkng is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Thinking comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),ThinkngComment), '''') = ''''
and Thinkng >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/family - material score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and PrimaryFamilyMaterialNeeds is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/family - material comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),PrimaryFamilyMaterialNeedsComment), '''') = ''''
and PrimaryFamilyMaterialNeeds >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/family - support score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and PrimaryFamilySocialSupport is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/family - support comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),PrimaryFamilySocialSupportComment), '''') = ''''
and PrimaryFamilySocialSupport >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/non custodial - material score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and NonCustodialMaterialNeeds is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/non custodial - material comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),NonCustodialMaterialNeedsComment), '''') = ''''
and NonCustodialMaterialNeeds >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/non custodial - support score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and NonCustodialSocialSupport is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/non custodial - support comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),NonCustodialSocialSupportComment), '''') = ''''
and NonCustodialSocialSupport >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/surrogate - material score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and SurrogateMaterialNeeds is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/surrogate - material comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),SurrogateMaterialNeedsComment), '''') = ''''
and SurrogateMaterialNeeds >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/surrogate - support score is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and SurrogateSocialSupport is null
and @AssessmentType <> ''S''
and @CafasRater = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''CAFAS - Caregiver/surrogate - support comment is required'', 1
From #CustomHRMAssessments
where @AdultOrChild = ''C''and @Diagnosis = ''MH''
and isnull(convert(varchar(8000),SurrogateSocialSupportComment), '''') = ''''
and SurrogateSocialSupport >= 10 
and @AssessmentType <> ''S''
and @CafasRater = ''Y''



--
-- 2- DLA
--
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''DLA - Section is required'' , 2
From #CustomHRMAssessments a
left join CustomHRMAssessmentActivityScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
where isnull(s.DocumentId, 0) = 0
and isnull(s.recorddeleted, ''N'')= ''N''
and @AdultOrChild = ''A''and @Diagnosis = ''MH''
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''DLA - Score requried for: '' + isnull(convert(varchar(300), HRMActivityDescription), '''') , 2
From #CustomHRMAssessments a
join CustomHRMAssessmentActivityScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
join CustomHRMActivities q on q.HRMActivityId = s.HRMActivityId
where isnull(s.ActivityScore, 0) = 0
and isnull(s.recorddeleted, ''N'')= ''N''
and isnull(q.recorddeleted, ''N'')= ''N''
and @AdultOrChild = ''A''and @Diagnosis = ''MH''

union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''DLA - Narrative requried for: '' + isnull(convert(varchar(300), HRMActivityDescription), '''') , 2
From #CustomHRMAssessments a
join CustomHRMAssessmentActivityScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
join CustomHRMActivities q on q.HRMActivityId = s.HRMActivityId
where ((isnull(s.ActivityScore, 10) <= 4  and isnull(activityScore, 10) <> 0 )
	   OR
		q.HRMActivityID in (2, 3, 6, 7, 8, 9, 13, 14, 15, 16)
		)	
and isnull(activityComment, '''') = ''''
and isnull(s.recorddeleted, ''N'')= ''N''
and isnull(q.recorddeleted, ''N'')= ''N''
and @AdultOrChild = ''A''and @Diagnosis = ''MH''
--select * from CustomHRMAssessmentActivityScores
--select * from CustomHRMActivities
--
-- 3- DD Eligibility
--

Union
Select ''CustomHRMAssessments'', ''DDEPreviouslyMet'', ''DD Eligibility - Eligibility criteria previously met is required'', 3
where @Diagnosis = ''DD''
Union
Select ''CustomHRMAssessments'', ''DDAttributableMentalPhysicalLimitation'', ''DD Eligibility - Attributable to mental/physcial limitation? is required'', 3
From #CustomHRMAssessments a
where @Diagnosis = ''DD''
and DDEPreviouslyMet = ''N''
Union
Select ''CustomHRMAssessments'', ''DDManifestBeforeAge22'', ''DD Eligibility - Manifested before age 22? is required'', 3
From #CustomHRMAssessments a
where @Diagnosis = ''DD''
and DDEPreviouslyMet = ''N''

Union
Select ''CustomHRMAssessments'', ''DDContinueIndefinitely'', ''DD Eligibility - Likely to continue indefinitely? is required'', 3
From #CustomHRMAssessments a
where @Diagnosis = ''DD''
and DDEPreviouslyMet = ''N''

Union
Select ''CustomHRMAssessments'', ''DDNeedMulitpleSupports'', ''DD Eligibility - Need for multiple services/supports? is required'', 3
From #CustomHRMAssessments a
where @Diagnosis = ''DD''
and DDEPreviouslyMet = ''N''



--
-- 4- DD RAP 1
--
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP - Community section required'', 4
From #CustomHRMAssessments a
where
exists (select * from CustomHRMRAPQuestions q2
				left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId
								and s2.DocumentId = a.DocumentId
								and s2.Version = a.Version
								and isnull(s2.RecordDeleted, ''N'')= ''N''
				where 
				s2.DocumentId is null
				and q2.RAPDomain = ''Community Inclusion''
				)
				
and @Diagnosis = ''DD''
and AssessmentType <> ''S''

union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP - '' + isnull(RAPDomain, '''') + '': Question '' + isnull(convert(varchar(20), RAPQuestionNumber), '''') + '' is required'', 4
From #CustomHRMAssessments a
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId
where q.RAPDomain = ''Community Inclusion''
and RAPAssessedValue is null
and isnull(s.recorddeleted, ''N'')= ''N''
and isnull(q.recorddeleted, ''N'')= ''N''
and @Diagnosis = ''DD''
and AssessmentType <> ''S''


--
-- 5- DD RAP 2
--
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP - Behaviors section required'', 5
From #CustomHRMAssessments a
where
exists (select * from CustomHRMRAPQuestions q2
				left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId
								and s2.DocumentId = a.DocumentId
								and s2.Version = a.Version
								and isnull(s2.RecordDeleted, ''N'')= ''N''
				where 
				s2.DocumentId is null
				and q2.RAPDomain = ''Challenging Behaviors''
				)
				
and @Diagnosis = ''DD''
and AssessmentType <> ''S''
union
Select ''CustomHRMAssessments'', ''Deletedby'', ''RAP (CB Domain) - '' + isnull(RAPDomain, '''') + '': Question '' + isnull(convert(varchar(20), RAPQuestionNumber), '''') + '' is required'', 5
From #CustomHRMAssessments a
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId
where q.RAPDomain = ''Challenging Behaviors''
and RAPAssessedValue is null
and isnull(s.recorddeleted, ''N'')= ''N''
and isnull(q.recorddeleted, ''N'')= ''N''
and @Diagnosis = ''DD''
and AssessmentType <> ''S''


--
-- 6- DD RAP 3
--
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP - Health section required'', 5
From #CustomHRMAssessments a
where
exists (select * from CustomHRMRAPQuestions q2
				left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId
								and s2.DocumentId = a.DocumentId
								and s2.Version = a.Version
								and isnull(s2.RecordDeleted, ''N'')= ''N''
				where 
				s2.DocumentId is null
				and q2.RAPDomain = ''Health and Health Care''
				)
				
and @Diagnosis = ''DD''
and AssessmentType <> ''S''
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP (HHC Domain) - '' + isnull(RAPDomain, '''') + '': Question '' + isnull(convert(varchar(20), RAPQuestionNumber), '''') + '' is required'',6
From #CustomHRMAssessments a
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId
where q.RAPDomain = ''Health and Health Care''
and RAPAssessedValue is null
and isnull(s.recorddeleted, ''N'')= ''N''
and isnull(q.recorddeleted, ''N'')= ''N''
and @Diagnosis = ''DD''
and AssessmentType <> ''S''


--
-- 24- DD RAP Current Ability
--
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP - Abilities section required'', 5
From #CustomHRMAssessments a
where
exists (select * from CustomHRMRAPQuestions q2
				left join CustomHRMAssessmentRAPScores s2 on q2.HRMRAPQuestionId = s2.HRMRAPQuestionId
								and s2.DocumentId = a.DocumentId
								and s2.Version = a.Version
								and isnull(s2.RecordDeleted, ''N'')= ''N''
				where 
				s2.DocumentId is null
				and q2.RAPDomain = ''Current Abilities''
				)
				
and @Diagnosis = ''DD''
and AssessmentType <> ''S''
union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''RAP (CB Domain) - '' + isnull(RAPDomain, '''') + '': Question '' + isnull(convert(varchar(20), RAPQuestionNumber), '''') + '' is required'', 24
From #CustomHRMAssessments a
join CustomHRMAssessmentRAPScores s on s.DocumentId = a.DocumentId and s.Version = a.Version
join CustomHRMRAPQuestions q on q.HRMRAPQuestionId = s.HRMRAPQuestionId
where q.RAPDomain = ''Current Abilities''
and RAPAssessedValue is null
and isnull(s.recorddeleted, ''N'')= ''N''
and isnull(q.recorddeleted, ''N'')= ''N''
and @Diagnosis = ''DD''
and AssessmentType <> ''S''




--
-- 7- UNCOPE
--
union
Select ''CustomHRMAssessments'', ''UncopeApplicable'', ''UNCOPE - Is UNCOPE applicable selection required'', 7
from #CustomHRMAssessments
where @Age >= 12
and @Diagnosis <> ''DD''

union
Select ''CustomHRMAssessments'', ''UncopeApplicableReason'', ''UNCOPE - Not applicable reason is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''N''
and @Age >= 12
and @Diagnosis <> ''DD''

union
Select ''CustomHRMAssessments'', ''UncopeQuestionU'', ''UNCOPE - Question 1 is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''Y''

Union
Select ''CustomHRMAssessments'', ''UncopeQuestionN'', ''UNCOPE - Question 2 is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''Y''

Union
Select ''CustomHRMAssessments'', ''UncopeQuestionC'', ''UNCOPE - Question 3 is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''Y''

Union
Select ''CustomHRMAssessments'', ''UncopeQuestionO'', ''UNCOPE - Question 4 is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''Y''

Union
Select ''CustomHRMAssessments'', ''UncopeQuestionP'', ''UNCOPE - Question 5 is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''Y''

Union
Select ''CustomHRMAssessments'', ''UncopeQuestionE'', ''UNCOPE - Question 6 is required'', 7
From #CustomHRMAssessments a
where UncopeApplicable = ''Y''
Union
Select ''CustomHRMAssessments'', ''DeletedBy'', ''UNCOPE - Stage of Change is required'', 7
From #CustomHRMAssessments 
where case when isnull(UncopeQuestionU, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionN, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionC, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionO, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionP, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionE, ''X'') =''Y'' then 1 else 0 end 
		> 2 and StageOfChange is null
		and UncopeApplicable = ''Y''



--
-- 8- PS Adult
--


union
select ''CustomHRMAssessments'', ''PsCurrentHealthIssues'', ''Psychosocial - Adult: Current Health Issues selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Current Health Issues narrative is required'',8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCurrentHealthIssuesComment), '''')= ''''
and isnull(PsCurrentHealthIssues, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

-- NEW
union
select ''CustomHRMAssessments'', ''PsMedications'', ''Psychosocial - Adult: Medications selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Medications narrative is required'',8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsMedicationsComment), '''')= ''''
and isnull(PsMedications, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Abuse or Neglect narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsClientAbuesIssuesComment), '''')= ''''
and isnull(PsClientAbuseIssues, ''N'')  = ''Y''
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''PsClientAbuseIssues'', ''Psychosocial - Adult: Abuse or Neglect selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsLegalIssues'', ''Psychosocial - Adult: Legal Issues selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Legal Issues narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsLegalIssuesComment), '''')= ''''
and isnull(PsLegalIssues, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''


union
select ''CustomHRMAssessments'', ''PsCulturalEthnicIssues'', ''Psychosocial - Adult: Cultural/ethnic issue selection is required'',8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Cultural/ethnic narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCulturalEthnicIssuesComment), '''')=''''
and isnull(PsCulturalEthnicIssues, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsSpiritualityIssues'', ''Psychosocial - Adult: Spirituality concern selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Spirituality concern narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSpiritualityIssuesComment), '''')= ''''
and isnull(PsSpiritualityIssues, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

--NEW
union
select ''CustomHRMAssessments'', ''PsEducation'', ''Psychosocial - Adult: Education selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Adult: Education narrative is required'',8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsEducationComment), '''')= ''''
and isnull(PsEducation, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''HistMentalHealthTx'', ''Psychosocial - History: Mental health treatment selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Mental health treatment narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistMentalHealthTxComment), '''')= ''''
and isnull(HistMentalHealthTx, ''N'')  = ''Y''
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''HistFamilyMentalHealthTx'', ''Psychosocial - History: Family mental health treatment selection is required'', 8
WHERE @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Family mental health treatment narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistFamilyMentalHealthTxComment), '''')= ''''
and isnull(HistFamilyMentalHealthTx, ''N'')  = ''Y''
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''HistPreviousDx'', ''Psychosocial - History: Previous Dx selection is required'', 8
where @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Previous Dx narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistPreviousDxComment), '''')= ''''
and isnull(HistPreviousDx, ''N'')  = ''Y''
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsTraumaticIncident'', ''Psychosocial - History: Previous traumatic incident selection is required'', 8
where @AdultOrChild = ''A'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Previous traumatic incident narrative is required'', 8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsTraumaticIncidentComment), '''')= ''''
and isnull(PsTraumaticIncident, ''N'')  = ''Y''
and @AdultOrChild = ''A'' and @Diagnosis = ''MH''


--
-- 9- PS Child
--
union
select ''CustomHRMAssessments'', ''PsCurrentHealthIssues'', ''Psychosocial - Child: Physical issues selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Physical issues narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCurrentHealthIssuesComment), '''')= ''''
and isnull(PsCurrentHealthIssues, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''
--NEW
union
select ''CustomHRMAssessments'', ''PsMedications'', ''Psychosocial - Child: Medications selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Medications narrative is required'',9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsMedicationsComment), '''')= ''''
and isnull(PsMedications, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsDevelopmentalMilestones'', ''Psychosocial - Child: Developmental milestones selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Developmental milestones narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsDevelopmentalMilestonesComment), '''')= ''''
and ((isnull(PsDevelopmentalMilestones, ''N'')  in (''Y'', ''N'', ''U'') and @AssessmentType <> ''S'') or (isnull(PsDevelopmentalMilestones, ''N'')  in (''Y'') and @AssessmentType = ''S''))

and @AdultOrChild = ''C'' and @Diagnosis = ''MH''


union
select ''CustomHRMAssessments'', ''PsPrenatalExposure'', ''Psychosocial - Child: Prenatal exposure selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Prenatal exposure narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsPrenatalExposureComment), '''')= ''''
and isnull(PsPrenatalExposure, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsChildMentalHealthHistory'', ''Psychosocial - Child: Mental health history of family/child selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Mental health history of family/child narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsChildMentalHealthHistoryComment), '''')= ''''
and isnull(PsChildMentalHealthHistory, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''



union
select ''CustomHRMAssessments'', ''PsChildEnvironmentalFactors'', ''Psychosocial - Child: Environmental factors selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Environmental factors narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsChildEnvironmentalFactorsComment), '''')= ''''
and isnull(PsChildEnvironmentalFactors, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsImmunizations'', ''Psychosocial - Child: Immunizations current selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Immunizations current narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsImmunizationsComment), '''')= ''''
and isnull(PsImmunizations, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsLanguageFunctioning'', ''Psychosocial - Child: Language functioning selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Language functioning narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsLanguageFunctioningComment), '''')= ''''
and isnull(PsLanguageFunctioning, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsVisualFunctioning'', ''Psychosocial - Child: Visual functioning selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Visual functioning narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsVisualFunctioningComment), '''')= ''''
and isnull(PsVisualFunctioning, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsIntellectualFunctioning'', ''Psychosocial - Child: Intellectual functioning selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Intellectual functioning narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsIntellectualFunctioningComment), '''')= ''''
and isnull(PsIntellectualFunctioning, ''N'')  in (''Y'', ''N'', ''U'')
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsLearningAbility'', ''Psychosocial - Child: Learning ability selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Learning ability narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsLearningAbilityComment), '''')= ''''
and isnull(PsLearningAbility, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsPeerInteraction'', ''Psychosocial - Child: Peer interaction selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Peer interaction narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsPeerInteractionComment), '''')= ''''
and isnull(PsPeerInteraction, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsChildHousingIssues'', ''Psychosocial - Child: Housing selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Housing narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsChildHousingIssuesComment), '''')= ''''
and isnull(PsChildHousingIssues, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsClientAbuseIssues'', ''Psychosocial - Child: Abuse or neglect selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Abuse or neglect narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsClientAbuesIssuesComment), '''')= ''''
and isnull(PsClientAbuseIssues, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsSexuality'', ''Psychosocial - Child: Sexuality selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Sexuality narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSexualityComment), '''')= ''''
and isnull(PsSexuality, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsFamilyFunctioning'', ''Psychosocial - Child: Functioning of the family selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Functioning of the family narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsFamilyFunctioningComment), '''')= ''''
and isnull(PsFamilyFunctioning, ''N'')  in ( ''Y'', ''N'')
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsLegalIssues'', ''Psychosocial - Child: Legal issues selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Legal issues narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsLegalIssuesComment), '''')= ''''
and ((isnull(PsLegalIssues, ''N'')  in (''Y'', ''N'', ''U'') and @AssessmentType <> ''S'') or (isnull(PsLegalIssues, ''N'')  in (''Y'') and @AssessmentType = ''S''))
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''


union
select ''CustomHRMAssessments'', ''PsCulturalEthnicIssues'', ''Psychosocial - Child: Cultural/ethnic issues selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Cultural/ethnic issues narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCulturalEthnicIssuesComment), '''')= ''''
and ((isnull(PsCulturalEthnicIssues, ''N'')  in (''Y'', ''N'', ''U'') and @AssessmentType <> ''S'') or (isnull(PsCulturalEthnicIssues, ''N'')  in (''Y'') and @AssessmentType = ''S''))
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsSpiritualityIssues'', ''Psychosocial - Child: Spirituality selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Spritituality narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSpiritualityIssuesComment), '''')= ''''
and ((isnull(PsSpiritualityIssues, ''N'')  in (''Y'', ''N'', ''U'') and @AssessmentType <> ''S'') or (isnull(PsSpiritualityIssues, ''N'')  in (''Y'') and @AssessmentType = ''S''))
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsParentalParticipation'', ''Psychosocial - Child: Parents/guardian unwilling selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Parents/guardian unwilling narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsParentalParticipationComment), '''')= ''''
and isnull(PsParentalParticipation, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsTraumaticIncident'', ''Psychosocial - Child: Physical or emotional trauma selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Physical or emotional trauma narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsTraumaticIncidentComment), '''')= ''''
and isnull(PsTraumaticIncident, ''N'')  = ''Y''
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

union
select ''CustomHRMAssessments'', ''PsSchoolHistory'', ''Psychosocial - Child: School history selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: School history narrative is required'', 9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSchoolHistoryComment), '''')= ''''
and ((isnull(PsSchoolHistory, ''N'')  in (''Y'', ''N'', ''U'') and @AssessmentType <> ''S'') or (isnull(PsSchoolHistory, ''N'')  in (''Y'') and @AssessmentType = ''S''))
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''

--NEW
union
select ''CustomHRMAssessments'', ''PsEducation'', ''Psychosocial - Education: School history selection is required'', 9
where @AdultOrChild = ''C'' and @Diagnosis = ''MH''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - Child: Education narrative is required'',9
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsEducationComment), '''')= ''''
and ((isnull(PsEducation, ''N'')  in (''Y'', ''N'', ''U'') and @AssessmentType <> ''S'') or (isnull(PsEducation, ''N'')  in (''Y'') and @AssessmentType = ''S''))
and @AdultOrChild = ''C'' and @Diagnosis = ''MH''




--
-- 10- PS DD 1
--

--NEW
union
select ''CustomHRMAssessments'', ''PsCurrentHealthIssues'', ''Psychosocial - DD: Current Health Issues selection is required'', 8
WHERE  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Current Health Issues narrative is required'',8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCurrentHealthIssuesComment), '''')= ''''
and isnull(PsCurrentHealthIssues, ''N'')  in (''Y'', ''N'', ''U'')
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''


--NEW
union
select ''CustomHRMAssessments'', ''PsMedications'', ''Psychosocial - DD: Medications selection is required'', 8
WHERE @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Medications narrative is required'',8
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsMedicationsComment), '''')= ''''
and isnull(PsMedications, ''N'')  in (''Y'', ''N'', ''U'')
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsClientAbuseIssues'', ''Psychosocial - DD: Abuse or neglect selection is required'', 10
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Abuse or neglect narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsClientAbuesIssuesComment), '''')= ''''
and isnull(PsClientAbuseIssues, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''


union
select ''CustomHRMAssessments'', ''PsLegalIssues'', ''Psychosocial - DD: Legal issues selection is required'', 10
where @AdultOrChild = ''C'' and @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Legal issues narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsLegalIssuesComment), '''')= ''''
and isnull(PsLegalIssues, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsCulturalEthnicIssues'', ''Psychosocial - DD: Cultural/ethnic issues selection is required'', 10
where @AdultOrChild = ''C'' and @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Cultural/ethnic issues narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCulturalEthnicIssuesComment), '''')= ''''
and isnull(PsCulturalEthnicIssues, ''N'')  = ''Y''
AND @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsSpiritualityIssues'', ''Psychosocial - DD: Spirituality selection is required'', 10
where @AdultOrChild = ''C'' and @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Spritituality narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSpiritualityIssuesComment), '''')= ''''
and isnull(PsSpiritualityIssues, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

--NEW
union
select ''CustomHRMAssessments'', ''PsEducation'', ''Psychosocial - DD: Education selection is required'', 10
where @AdultOrChild = ''C'' and @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - DD: Education narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsEducationComment), '''')= ''''
and isnull(PsEducation, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''



union
select ''CustomHRMAssessments'', ''HistMentalHealthTx'', ''Psychosocial - History: Mental health treatment selection is required'', 10
WHERE  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Mental health treatment narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistMentalHealthTxComment), '''')= ''''
and isnull(HistMentalHealthTx, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''HistFamilyMentalHealthTx'', ''Psychosocial - History: Family mental health treatment selection is required'', 10
WHERE  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Family mental health treatment narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistFamilyMentalHealthTxComment), '''')= ''''
and isnull(HistFamilyMentalHealthTx, ''N'')  = ''Y''
and  @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''HistDevelopmental'', ''Psychosocial - History: Developmental selection is required'', 10
where @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Developmental narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistDevelopmentalComment), '''')= ''''
and isnull(HistDevelopmental, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''HistResidential'', ''Psychosocial - History: Residential selection is required'', 10
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Residential narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistResidentialComment), '''')= ''''
and isnull(HistResidential, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''HistOccupational'', ''Psychosocial - History: Occupational selection is required'', 10
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Occupational narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistOccupationalComment), '''')= ''''
and isnull(HistOccupational, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''HistLegalFinancial'', ''Psychosocial - History: Legal/financial selection is required'', 10
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Psychosocial - History: Legal/financial narrative is required'', 10
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), HistLegalFinancialComment), '''')= ''''
and isnull(HistLegalFinancial, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''


--
-- 11- PS DD 2
--
union
select ''CustomHRMAssessments'', ''PsGrossFineMotor'', ''DD Concerns -  Gross/fine motor selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Gross/fine motor narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsGrossFineMotorComment), '''')= ''''
and isnull(PsGrossFineMotor, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsSensoryPerceptual'', ''DD Concerns -  Sensory/perceptual selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Sensory/perceptual narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSensoryPerceptualComment), '''')= ''''
and isnull(PsSensoryPerceptual, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsCognitiveFunction'', ''DD Concerns -  Cognitive function selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Cognitive function narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCognitiveFunctionComment), '''')= ''''
and isnull(PsCognitiveFunction, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsCommunicativeFunction'', ''DD Concerns -  Communicative function selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Communicative function narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCommunicativeFunctionComment), '''')= ''''
and isnull(PsCommunicativeFunction, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsCurrentPsychoSocialFunctiion'', ''DD Concerns -  Current psychosocial function selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Current psychosocial function narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsCurrentPsychoSocialFunctiionComment), '''')= ''''
and isnull(PsCurrentPsychoSocialFunctiion, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsAdaptiveEquipment'', ''DD Concerns -  Adaptive equipment selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Adaptive equipment narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsAdaptiveEquipmentComment), '''')= ''''
and isnull(PsAdaptiveEquipment, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsSafetyMobilityHome'', ''DD Concerns - Safety/mobility selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Safety/mobility narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSafetyMobilityHomeComment), '''')= ''''
and isnull(PsSafetyMobilityHome, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsHealthSafetyChecklistComplete'', ''DD Concerns - Home health/safety checklist selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''


union
select ''CustomHRMAssessments'', ''PsAccessibilityIssues'', ''DD Concerns - Accessibility/community mobility selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Accessibility/community mobility narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsAccessibilityIssuesComment), '''')= ''''
and isnull(PsAccessibilityIssues, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsEvacuationTraining'', ''DD Concerns - Emergency evacuation training selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Emergency evacuation training narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsEvacuationTrainingComment), '''')= ''''
and isnull(PsEvacuationTraining, ''N'')  = ''N''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''Ps24HourSetting'', ''DD Concerns - 24 hours supervised setting selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - 24 hours supervised setting narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), Ps24HourSettingComment), '''')= ''''
and isnull(Ps24HourSetting, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''Ps24HourNeedsAwakeSupervision'', ''DD Concerns - Needs awake supervision selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''


union
select ''CustomHRMAssessments'', ''PsSpecialEdEligibility'', ''DD Concerns - Special education eligibility selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Special education eligibility  narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSpecialEdEligibilityComment), '''')= ''''
and isnull(PsSpecialEdEligibility, ''N'')  = ''N''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsSpecialEdEnrolled'', ''DD Concerns - Enrolled in special education selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Enrolled in special education narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsSpecialEdEnrolledComment), '''')= ''''
and isnull(PsSpecialEdEnrolled, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsEmployer'', ''DD Concerns - Employed? selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Employed? narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsEmployerComment), '''')= ''''
and isnull(PsEmployer, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsEmploymentIssues'', ''DD Concerns - Employment issues selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Employment issues narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsEmploymentIssuesComment), '''')= ''''
and isnull(PsEmploymentIssues, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''

union
select ''CustomHRMAssessments'', ''PsRestrictionsOccupational'', ''DD Concerns - Employment restrictions/adaptations selection is required'', 11
where  @Diagnosis = ''DD''
and @AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''DD Concerns - Employment restrictions/adaptations narrative is required'', 11
From #CustomHRMAssessments 
Where isnull(convert(varchar(8000), PsRestrictionsOccupationalComment), '''')= ''''
and isnull(PsRestrictionsOccupational, ''N'')  = ''Y''
and @Diagnosis = ''DD''
and @AssessmentType <> ''S''


--
-- 12- PS DD 3
--
union
select ''CustomHRMAssessments'', ''PsDDInformationProvidedBy'', ''DD Summary - Information on this assessment was provided by is required'', 12
where  @Diagnosis = ''DD''


--
-- 13- Strengths and Supports
--
union
select ''CustomHRMAssessments'', ''ClientStrengthsNarrative'', ''Strengths and Supports - Strengths is required'' , 13
union
select ''CustomHRMAssessments'', ''NaturalSupportSufficiency'', ''Strengths and Supports - Support Sufficiency selection is required'', 13
union
select ''CustomHRMAssessments'', ''NaturalSupportIncreaseDesired'', ''Strengths and Supports - Increased Support selection is required'', 13
union
select ''CustomHRMAssessments'', ''CommunityActivitiesCurrentDesired'', ''Strengths and Supports - Community Activities comment is required'', 13
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''CommunityActivitiesIncreaseDesired'', ''Strengths and Supports - Desired Increased Activities selection is required'', 13
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Strengths and Supports - Natural and Community Support is required'', 13
From #CustomHRMAssessments a
where not exists (select * from customhrmassessmentsupports b
					where b.documentid = a.Documentid
					and b.Version = a.Version		
					and isnull(b.NaturalSupportType, ''X'') = ''C''
					and isnull(b.recorddeleted, ''N'')= ''N'')

union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Strengths and Supports - Increased Support entry is required'', 13
From #CustomHRMAssessments a
where not exists (select * from customhrmassessmentsupports b
					where b.documentid = a.Documentid
					and b.Version = a.Version		
					and isnull(b.NaturalSupportType, ''X'') = ''P''
					and isnull(b.recorddeleted, ''N'')= ''N'')
and NaturalSupportIncreaseDesired = ''Y''


union
select ''CustomHRMAssessments'', ''CrisisPlanningClientHasPlan'', ''Strengths and Supports - Cri Plan: Does client have crisis plan? '', 13
union
select ''CustomHRMAssessments'', ''CrisisPlanningDesired'', ''Strengths and Supports - Cri Plan: Client desires crisis plan? '', 13
union
select ''CustomHRMAssessments'', ''CrisisPlanningMoreInfo'', ''Strengths and Supports - Cri Plan: Client would like more crisis info?'', 13
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Strengths and Supports - Cri Plan: What info was client given regarding crisis plan?'', 13
from #CustomHRMAssessments
Where CrisisPlanningDesired = ''Y''
and isnull(convert(Varchar(8000), CrisisPlanningNarrative), '''') = ''''
 
--
-- needs logic on when this is required
--
union
select ''CustomHRMAssessments'', ''AdvanceDirectiveClientHasDirective'', ''Strengths and Supports - Adv Dir: Does client have advance directive?'', 13
where @AdultOrChild = ''A''
union
select ''CustomHRMAssessments'', ''AdvanceDirectiveDesired'', ''Strengths and Supports - Adv Dir: Client desires advance directive plan?'', 13
where @AdultOrChild = ''A''
union
select ''CustomHRMAssessments'', ''AdvanceDirectiveMoreInfo'', ''Strengths and Supports - Adv Dir: Client would like more info about advance directives?'', 13
where @AdultOrChild = ''A''
--union
--select ''CustomHRMAssessments'', ''AdvanceDirectiveNarrative'', ''Strengths and Supports - Adv Dir: What information was given to the client?'', 13
--where @AdultOrChild = ''A''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Strengths and Supports - Adv Dir: What information was given to the client?'', 13
from #CustomHRMAssessments
Where (AdvanceDirectiveDesired = ''Y'' or AdvanceDirectiveMoreInfo = ''Y'')
and isnull(convert(Varchar(8000), AdvanceDirectiveNarrative), '''') = ''''
and @AdultOrChild = ''A''


--
-- 14- Mental Status
--
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Mental Status - '' + b.SectionLabel + '' selection is required'', 14
from  #CustomHRMAssessments a
join customhrmmentalstatussections b on b.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId
where not exists (select * from customhrmassessmentmentalstatusitems c
					join customhrmmentalstatusitems d on c.HRMMentalStatusItemId = d.HRMMentalStatusItemId
					where d.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId
					and c.DocumentId = a.DocumentId
					and c.Version = a.Version
					and isnull(c.ItemChecked, ''N'') = ''Y''
					and isnull(c.RecordDeleted, ''N'')= ''N''
					and isnull(d.RecordDeleted, ''N'')= ''N''
					)
and b.Active = ''Y''
and isnull(b.RecordDeleted, ''N'')= ''N''

--
--  Mental Status Comment Field
--
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Mental Status - '' + b.SectionLabel + '' '' + i.MentalStatusLabel+'' text is required'',14
from  #CustomHRMAssessments a
join customhrmmentalstatussections b on b.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId
Join customhrmmentalstatusitems i on i.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId
where  exists (select * from customhrmassessmentmentalstatusitems c
					join customhrmmentalstatusitems d on c.HRMMentalStatusItemId = d.HRMMentalStatusItemId
					where d.HRMMentalStatusSectionId = b.HRMMentalStatusSectionId
					and d.HRMMentalStatusItemId = i.HRMMentalStatusItemId
					and c.DocumentId = a.DocumentId
					and c.Version = a.Version
					and isnull(c.ItemChecked, ''N'') = ''Y''
					and isnull(c.ItemNarrative, '''')= ''''
					and isnull(c.RecordDeleted, ''N'')= ''N''
					and isnull(d.RecordDeleted, ''N'')= ''N''
					)
and b.Active = ''Y''
and i.Active = ''Y''
and isnull(i.ItemRequiresNarrative, ''N'') = ''Y''
and isnull(b.RecordDeleted, ''N'')= ''N''
and isnull(i.RecordDeleted, ''N'')= ''N''


--
--15- Risk Assessment
--
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Risk Assessment - Suicidality: Not Present/Ideation is required'', 15
From #CustomHRMAssessments 
where isnull(SuicideNotPresent, ''N'')= ''N'' and isnull(SuicideIdeation, ''N'') = ''N''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Risk Assessment - Suicidality: Active/Passive is required'', 15
From #CustomHRMAssessments 
where isnull(SuicideIdeation, ''N'') = ''Y''
and isnull(SuicideActive, ''N'')= ''N'' and isnull(SuicidePassive, ''N'')= ''N''
union
select ''CustomHRMAssessments'', ''SuicideBehaviorsPastHistory'', ''Risk Assessment - Suicidality: Details text is required'', 15
From #CustomHRMAssessments 
where isnull(SuicideIdeation, ''N'') = ''Y''
union
select ''CustomHRMAssessments'', ''SuicideOtherRiskSelfComment'', ''Risk Assessment - Suicidality: Other Risk to Self text is required'', 15
From #CustomHRMAssessments 
where isnull(SuicideOtherRiskSelf, ''N'') = ''Y''


union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Risk Assessment - Homicidality: Not Present/Ideation is required'', 15
From #CustomHRMAssessments 
where isnull(HomicideNotPresent, ''N'')= ''N'' and isnull(HomicideIdeation, ''N'') = ''N''
union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Risk Assessment - Homicidality: Active/Passive is required'', 15
From #CustomHRMAssessments 
where isnull(HomicideIdeation, ''N'') = ''Y''
and isnull(HomicideActive, ''N'')= ''N'' and isnull(HomicidePassive, ''N'')= ''N''
union
select ''CustomHRMAssessments'', ''HomicideBehaviorsPastHistory'', ''Risk Assessment - Homicidality: Details text is required'', 15
From #CustomHRMAssessments 
where isnull(HomicideIdeation, ''N'') = ''Y''
union
select ''CustomHRMAssessments'', ''HomicideOtherRiskOthersComment'', ''Risk Assessment - Homicidality: Other Risk to Self text is required'', 15
From #CustomHRMAssessments 
where isnull(HomicdeOtherRiskOthers, ''N'') = ''Y''


union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Risk Assessment - Physical Agression: Not Present/Toward Self/Toward Others is required'', 15
From #CustomHRMAssessments 
where isnull(PhysicalAgressionNotPresent, ''N'')= ''N'' and isnull(PhysicalAgressionSelf, ''N'') = ''N''and isnull(PhysicalAgressionOthers, ''N'') = ''N''

union
select ''CustomHRMAssessments'', ''PhysicalAgressionBehaviorsPastHistory'', ''Risk Assessment - Physical Agression: Details text is required'', 15
From #CustomHRMAssessments 
where isnull(PhysicalAgressionSelf, ''N'') = ''Y''or isnull(PhysicalAgressionOthers, ''N'') = ''Y''

union
select ''CustomHRMAssessments'', ''DeletedBy'', ''Risk Assessment - High Risk Clients: clinical intervention text is required'', 15
From #CustomHRMAssessments 
where (isnull(PhysicalAgressionSelf, ''N'') = ''Y''
or isnull(PhysicalAgressionOthers, ''N'') = ''Y'' 
or isnull(HomicideIdeation, ''N'') = ''Y''
or isnull(SuicideIdeation, ''N'') = ''Y'')
and isnull(convert(varchar(8000), RiskClinicalIntervention), '''')= ''''

union
select ''CustomHRMAssessments'', ''RiskOtherFactors'', ''Risk Assessment - Other Risk Factors: details text is required'', 15
From #CustomHRMAssessments 
where isnull(RiskAccessToWeapons, ''N'') = ''Y''
or isnull(RiskAppropriateForAdditionalScreening, ''N'') = ''Y'' 






--
--17- Assessment Needs List
--

--
--18- Summary
--
union
select ''CustomHRMAssessments'', ''ClinicalSummary'', ''Summary - Clinical Interpretive Summary is required'', 18
union
select ''CustomHRMAssessments'', ''DischargeCriteria'', ''Summary - Criteria for Discharge is required'', 18

--
--19- Pre Plan
--
union
Select ''CustomHRMAssessments'', ''Participants'',''Pre Plan - Participants is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''Facilitator'',''Pre Plan - Facilitator text is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S'' and PrePlanIndependentFacilitatorDesired = ''Y''
and @AuthorId not in (1022) --Amy Zwart

union
Select ''CustomHRMAssessments'', ''PrePlanIndependentFacilitatorDiscussed'',''Pre Plan - Was client offered info on independent facilitation?'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''PrePlanIndependentFacilitatorDesired'',''Pre Plan - Does client request an independent facilitator?'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''TimeLocation'',''Pre Plan - Time/Location is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''IssuesToAvoid'',''Pre Plan - Issues to Avoid is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''IssuesToDiscuss'',''Pre Plan - What does the client wish to discuss?.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''CommunicationAccomodations'',''Pre Plan - Communication Accomodations is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @AuthorId not in (1022) --Amy Zwart
--union
--Select ''CustomHRMAssessments'', ''SourceOfPrePlanningInfo'',''Pre Plan - Source of Pre-Planning Information is required.'',19
union
Select ''CustomHRMAssessments'', ''SelfDeterminationDesired'',''Pre Plan - Self Determination selection is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @Diagnosis = ''DD''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''FiscalIntermediaryDesired'',''Pre Plan - Fiscal Intermediary selection is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and @Diagnosis = ''DD''
and @AuthorId not in (1022) --Amy Zwart
union
Select ''CustomHRMAssessments'', ''PrePlanFiscalIntermediaryComment'',''Pre Plan - Self Determination/Fiscal Intermediary text is required.'',19
From #CustomHRMAssessments a
Where AssessmentType <> ''S''
and (FiscalIntermediaryDesired = ''Y''
or SelfDeterminationDesired = ''Y'')
and @Diagnosis = ''DD''
and @AuthorId not in (1022) --Amy Zwart


--
--20- Level of Care/Servcies
--
union
Select ''CustomHRMAssessments'', ''ClientIsAppropriateForTreatment'',''Level of Care/Services - Is client appropriate for treatment? selection is required.'',20

union
Select ''CustomHRMAssessments'', ''SecondOpinionNoticeProvided'',''Level of Care/Services - Second opinion notice provided selection is required.'',20
From #CustomHRMAssessments a
where ClientIsAppropriateForTreatment = ''N''

union
Select ''CustomHRMAssessments'', ''TreatmentNarrative'',''Level of Care/Services - Is client appropriate for treatment? narrative is required.'',20
From #CustomHRMAssessments a
where ClientIsAppropriateForTreatment = ''N''
union
Select ''CustomHRMAssessments'', ''OutsideReferralsGiven'',''Level of Care/Services - Outside referrals given? selection is required.'',20
union
Select ''CustomHRMAssessments'', ''ReferralsNarrative'',''Level of Care/Services - Outside referrals given? narrative is required.'',20
From #CustomHRMAssessments a
where OutsideReferralsGiven = ''Y''
union
Select ''CustomHRMAssessments'', ''AssessmentsNeeded'',''Level of Care/Services - Assessments needed narrative is required.'',20
union
Select ''CustomHRMAssessments'', ''TreatmentAccomodation'',''Level of Care/Services - Treatment Accomodation narrative is required.'',20

union
Select ''CustomHRMAssessments'', ''DeletedBy'',''Level of Care/Services - Recommended Service must be selected.'',20
From #CustomHRMAssessments a
where not exists (select * from CustomHRMAssessmentLevelOfCareOptions l
					where a.DocumentId = l.DocumentId and a.Version = l.Version
					and isnull(l.optionselected, ''N'')= ''Y''
					and isnull(l.recorddeleted, ''N'')= ''N'')
and ClientIsAppropriateForTreatment = ''Y''


union
Select ''CustomHRMAssessments'', ''DeletedBy'',''Client Needs Error - Please contact tech support.'',20
From #CustomHRMAssessments a
where exists (select * from customhrmassessmentneeds an
				join documents d on d.documentid = an.documentid
				where an.DocumentId = a.DocumentId
				and exists (select * from Customclientneeds n
							join clientepisodes ce on ce.clientepisodeid = n.clientepisodeid
							where n.clientneedid = an.clientneedid
							and ce.clientid <> d.clientId
							and isnull(n.recorddeleted, ''N'')= ''N'')
				and isnull(an.recorddeleted, ''N'')= ''N''
				and isnull(d.recorddeleted, ''N'')= ''N'')

union
Select ''CustomHRMAssessments'', ''StaffAxisVReason'',''Dx - Reason for staff assigned Axis V value is required.'',16
From #CustomHRMAssessments a
where isnull(StaffAxisV, 0) <> 0
and @AdultOrChild = ''A''and @Diagnosis = ''MH''

--
-- Co-Signature requirements
--

--UNION
--SELECT ''CustomHRMAssessments'', ''DeletedBy'', ''Signatures - Physician cosignature is required.'', 0
--From #CustomHRMAssessments t
--where not exists (select * from DocumentSignatures ds
--				  join staff s on s.staffid = ds.staffid
--					where s.degree in (10104, 10134) --DR
--				  and ds.documentid = t.documentId
--					and isnull(ds.RecordDeleted, ''N'')= ''N'')

--UNION
--SELECT ''CustomHRMAssessments'', ''DeletedBy'', ''Signatures - Supervisor cosignature is required.'', 0
--From #CustomHRMAssessments t
--where not exists (select * from DocumentSignatures ds
--				  join staff s on s.staffid = ds.staffid
--					where ds.documentid = t.documentid
--				  and s.Supervisor = ''Y''
--					and isnull(ds.RecordDeleted, ''N'')= ''N'')


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
where case when isnull(UncopeQuestionU, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionN, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionC, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionO, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionP, ''X'') =''Y'' then 1 else 0 end + 
	  case when isnull(UncopeQuestionE, ''X'') =''Y'' then 1 else 0 end 
		> 2 )
begin
--exec csp_validateCustomHRMSUAssessments @DocumentVersionId  --RESOLVE SECONDARY PROC BEFORE UNCOMMENTING
end
if @@error <> 0 goto error
*/



--if @@error <> 0 goto error




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
If exists 
(Select a.DocumentVersionId From #CustomHRMAssessments a
where exists (select an.DocumentVersionId from customhrmassessmentneeds an
				join documents d on d.currentdocumentversionid = an.documentversionid
				where an.DocumentVersionId = a.DocumentVersionId
				and exists (select n.ClientEpisodeId from Customclientneeds n
							join clientepisodes ce on ce.clientepisodeid = n.clientepisodeid
							where n.clientneedid = an.clientneedid
							and ce.clientid <> d.clientId
							and isnull(n.recorddeleted, ''N'')= ''N'')
				and isnull(an.recorddeleted, ''N'')= ''N''
				and isnull(d.recorddeleted, ''N'')= ''N'')
)
Begin 
Insert into CustomHRMAssessmentNeedTracking
(DocumentVersionId, CreatedDate)
Select DocumentVersionId, Getdate()
from  #CustomHRMAssessments a
End


return

error:
raiserror 50000 ''csp_validateCustomHRMAssessmentNew failed.  Contact your system administrator.''
' 
END
GO
