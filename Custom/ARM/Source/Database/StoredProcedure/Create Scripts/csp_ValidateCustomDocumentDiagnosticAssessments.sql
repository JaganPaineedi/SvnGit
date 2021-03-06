/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessments] 
 @DocumentVersionId int    
AS    
    
/*    
avoss 08.06.2012  corrected EAP_MD_AST procedure code 
Maninder : 31/Aug/2012   Corrected Column varchar(250) to varchar(max)
*/    
    
declare @InitialOrUpdate char(1)    
    
-- Take a snapshot of the assessment    
CREATE TABLE #CustomDocumentDiagnosticAssessments (    
 [DocumentVersionId] [int] ,    
 [CreatedBy] varchar(35) ,    
 [CreatedDate] datetime ,    
 [ModifiedBy] varchar(35) ,    
 [ModifiedDate] datetime ,    
 [RecordDeleted] char(1) ,    
 [DeletedBy] varchar(35) ,    
 [DeletedDate] [datetime] ,    
 [TypeOfAssessment] [char](1) ,    
 [InitialOrUpdate] [char](1) ,    
 [ReasonForUpdate] varchar(max) ,    
 [UpdatePsychoSocial] char(1) ,    
 [UpdateSubstanceUse] char(1) ,    
 [UpdateRiskIndicators] char(1) ,    
 [UpdatePhysicalHealth] char(1) ,    
 [UpdateEducationHistory] char(1) ,    
 [UpdateDevelopmentalHistory] char(1) ,    
 [UpdateSleepHygiene] char(1) ,    
 [UpdateFamilyHistory] char(1) ,    
 [UpdateHousing] char(1) ,    
 [UpdateVocational] char(1) ,    
 [TransferReceivingStaff] [int] ,    
 [TransferReceivingProgram] int ,    
 [TransferAssessedNeed] [varchar](250) ,    
 [TransferClientParticipated] char(1) ,    
 [PresentingProblem] varchar(max) ,    
 [OptionsAlreadyTried] varchar(max) ,    
 [ClientHasLegalGuardian] char(1) ,    
 [LegalGuardianInfo] varchar(max) ,    
 [AbilitiesInterestsSkills] varchar(max) ,    
 [FamilyHistory] varchar(max) ,    
 [EthnicityCulturalBackground] varchar(max) ,    
 [SexualOrientationGenderExpression] varchar(max) ,    
 [GenderExpressionConsistent] char(1) ,    
 [SupportSystems] varchar(max) ,    
 [ClientStrengths] varchar(max) ,    
 [LivingSituation] varchar(max) ,    
 [IncludeHousingAssessment] char(1) ,    
 [ClientEmploymentNotApplicable] char(1) ,    
 [ClientEmploymentMilitaryHistory] varchar(max) ,    
 [IncludeVocationalAssessment] char(1) ,    
 [HighestEducationCompleted] int ,    
 [EducationComment] varchar(max) ,    
 [LiteracyConcerns] [char](1) ,    
 [LegalInvolvement] char(1) ,    
 [LegalInvolvementComment] varchar(max) ,    
 [HistoryEmotionalProblemsClient] varchar(max) ,    
 [ClientHasReceivedTreatment] char(1) ,    
 [ClientPriorTreatmentDiagnosis] varchar(max) ,    
 [PriorTreatmentCounseling] char(1) ,    
 [PriorTreatmentCounselingDates] [varchar](250) ,    
 [PriorTreatmentCounselingComment] varchar(max) ,    
 [PriorTreatmentCaseManagement] char(1) ,    
 [PriorTreatmentCaseManagementDates] [varchar](250) ,    
 [PriorTreatmentCaseManagementComment] varchar(max) ,    
 [PriorTreatmentOther] char(1) ,    
 [PriorTreatmentOtherDates] [varchar](250) ,    
 [PriorTreatmentOtherComment] varchar(max) ,    
 [PriorTreatmentMedication] char(1) ,    
 [PriorTreatmentMedicationDates] [varchar](250) ,    
 [PriorTreatmentMedicationComment] varchar(max) ,    
 [TypesOfMedicationResults] varchar(max) ,    
 [ClientResponsePastTreatment] [char](1) ,    
 [ClientResponsePastTreatmentNA] char(1) ,    
 [AbuseNotApplicable] char(1) ,    
 [AbuseEmotionalVictim] char(1) ,    
 [AbuseEmotionalOffender] char(1) ,    
 [AbuseVerbalVictim] char(1) ,    
 [AbuseVerbalOffender] char(1) ,    
 [AbusePhysicalVictim] char(1) ,    
 [AbusePhysicalOffender] char(1) ,    
 [AbuseSexualVictim] char(1) ,    
 [AbuseSexualOffender] char(1) ,    
 [AbuseNeglectVictim] char(1) ,    
 [AbuseNeglectOffender] char(1) ,    
 [AbuseComment] varchar(max) ,    
 [FamilyPersonalHistoryLossTrauma] varchar(max) ,    
 [BiologicalMotherUseNoneReported] char(1) ,    
 [BiologicalMotherUseAlcohol] char(1) ,    
 [BiologicalMotherTobacco] char(1) ,    
 [BiologicalMotherUseOther] char(1) ,    
 [BiologicalMotherUseOtherType] [varchar](250) ,    
 [ClientReportAlcoholTobaccoDrugUse] char(1) ,    
 [ClientReportDrugUseComment] varchar(max) ,    
 [FurtherSubstanceAssessmentIndicated] char(1) ,    
 [ClientHasHistorySubstanceUse] char(1) ,    
 [ClientHistorySubstanceUseComment] varchar(max) ,    
 [AlcoholUseWithin30Days] char(1) ,    
 [AlcoholUseCurrentFrequency] int ,    
 [AlcoholUseWithinLifetime] char(1) ,    
 [AlcoholUsePastFrequency] int ,    
 [AlcoholUseReceivedTreatment] char(1) ,    
 [CocaineUseWithin30Days] char(1) ,    
 [CocaineUseCurrentFrequency] int ,    
 [CocaineUseWithinLifetime] char(1) ,    
 [CocaineUsePastFrequency] int ,    
 [CocaineUseReceivedTreatment] char(1) ,    
 [SedtativeUseWithin30Days] char(1) ,    
 [SedtativeUseCurrentFrequency] int ,    
 [SedtativeUseWithinLifetime] char(1) ,    
 [SedtativeUsePastFrequency] int ,    
 [SedtativeUseReceivedTreatment] char(1) ,    
 [HallucinogenUseWithin30Days] char(1) ,    
 [HallucinogenUseCurrentFrequency] int ,    
 [HallucinogenUseWithinLifetime] char(1) ,    
 [HallucinogenUsePastFrequency] int ,    
 [HallucinogenUseReceivedTreatment] char(1) ,    
 [StimulantUseWithin30Days] char(1) ,    
 [StimulantUseCurrentFrequency] int ,    
 [StimulantUseWithinLifetime] char(1) ,    
 [StimulantUsePastFrequency] int ,    
 [StimulantUseReceivedTreatment] char(1) ,    
 [NarcoticUseWithin30Days] char(1) ,    
 [NarcoticUseCurrentFrequency] int ,    
 [NarcoticUseWithinLifetime] char(1) ,    
 [NarcoticUsePastFrequency] int ,    
 [NarcoticUseReceivedTreatment] char(1) ,    
 [MarijuanaUseCurrentFrequency] int ,    
 [MarijuanaUsePastFrequency] int ,    
 [MarijuanaUseWithin30Days] char(1) ,    
 [MarijuanaUseWithinLifetime] char(1) ,    
 [MarijuanaUseReceivedTreatment] char(1) ,    
 [InhalantsUseWithin30Days] char(1) ,    
 [InhalantsUseCurrentFrequency] int ,    
 [InhalantsUseWithinLifetime] char(1) ,    
 [InhalantsUsePastFrequency] int ,    
 [InhalantsUseReceivedTreatment] char(1) ,    
 [OtherUseWithin30Days] char(1) ,    
 [OtherUseCurrentFrequency] int ,    
 [OtherUseWithinLifetime] char(1) ,    
 [OtherUsePastFrequency] int ,    
 [OtherUseReceivedTreatment] char(1) ,    
 [OtherUseType] [varchar](250) ,    
 [DASTScore] [int] ,    
 [MASTScore] [int] ,    
 [ClientReferredSubstanceTreatment] [char](1) ,    
 [ClientReferredSubstanceTreatmentWhere] [varchar](250) ,    
 [RiskSuicideIdeation] char(1) ,    
 [RiskSuicideIdeationComment] varchar(max) ,    
 [RiskSuicideIntent] char(1) ,    
 [RiskSuicideIntentComment] varchar(max) ,    
 [RiskSuicidePriorAttempts] char(1) ,    
 [RiskSuicidePriorAttemptsComment] varchar(max) ,    
 [RiskPriorHospitalization] char(1) ,    
 [RiskPriorHospitalizationComment] varchar(max) ,    
 [RiskPhysicalAggressionSelf] char(1) ,    
 [RiskPhysicalAggressionSelfComment] varchar(max) ,    
 [RiskVerbalAggressionOthers] char(1) ,    
 [RiskVerbalAggressionOthersComment] varchar(max) ,    
 [RiskPhysicalAggressionObjects] char(1) ,    
 [RiskPhysicalAggressionObjectsComment] varchar(max) ,    
 [RiskPhysicalAggressionPeople] char(1) ,    
 [RiskPhysicalAggressionPeopleComment] varchar(max) ,    
 [RiskReportRiskTaking] char(1) ,    
 [RiskReportRiskTakingComment] varchar(max) ,    
 [RiskThreatClientPersonalSafety] char(1) ,    
 [RiskThreatClientPersonalSafetyComment] varchar(max) ,    
 [RiskPhoneNumbersProvided] char(1) ,    
 [RiskCurrentRiskIdentified] char(1) ,    
 [RiskTriggersDangerousBehaviors] varchar(max) ,    
 [RiskCopingSkills] varchar(max) ,    
 [RiskInterventionsPersonalSafetyNA] char(1) ,    
 [RiskInterventionsPersonalSafety] varchar(max) ,    
 [RiskInterventionsPublicSafetyNA] char(1) ,    
 [RiskInterventionsPublicSafety] varchar(max) ,    
 [PhysicalProblemsNoneReported] char(1) ,    
 [PhysicalProblemsComment] varchar(max) ,    
 [SpecialNeedsNoneReported] char(1) ,    
 [SpecialNeedsVisualImpairment] char(1) ,    
 [SpecialNeedsHearingImpairment] char(1) ,    
 [SpecialNeedsSpeechImpairment] char(1) ,    
 [SpecialNeedsOtherPhysicalImpairment] char(1) ,    
 [SpecialNeedsOtherPhysicalImpairmentComment] varchar(max) ,    
 [EducationSchoolName] [varchar](250) ,    
 [EducationPreviousExpulsions] varchar(max) ,    
 [EducationClassification] [char](1) ,    
 [EducationEmotionalDisturbance] char(1) ,    
 [EducationPreschoolersDisability] char(1) ,    
 [EducationTraumaticBrainInjury] char(1) ,    
 [EducationCognitiveDisability] char(1) ,    
 [EducationCurrent504] char(1) ,    
 [EducationOtherMajorHealthImpaired] char(1) ,    
 [EducationSpecificLearningDisability] char(1) ,    
 [EducationAutism] char(1) ,    
 [EducationOtherMinorHealthImpaired] char(1) ,    
 [EdcuationClassificationComment] varchar(max) ,    
 [EducationPreviousRetentions] varchar(max) ,    
 [EducationClientIsHomeSchooled] char(1) ,    
 [EducationClientAttendedPreschool] char(1) ,    
 [EducationFrequencyOfAttendance] varchar(max) ,    
 [EducationReceivedServicesAsToddler] char(1) ,    
 [EducationReceivedServicesAsToddlerComment] varchar(max) ,    
 [ClientPreferencesForTreatment] varchar(max) ,    
 [ExternalSupportsReferrals] varchar(max) ,    
 [PrimaryClinicianTransfer] char(1) ,    
 [EAPMentalStatus] [char](1) ,    
 [DiagnosticImpressionsSummary] varchar(max) ,    
 [MilestoneUnderstandingLanguage] [char](1) ,    
 [MilestoneVocabulary] [char](1) ,    
 [MilestoneFineMotor] [char](1) ,    
 [MilestoneGrossMotor] [char](1) ,    
 [MilestoneIntellectual] [char](1) ,    
 [MilestoneMakingFriends] [char](1) ,    
 [MilestoneSharingInterests] [char](1) ,    
 [MilestoneEyeContact] [char](1) ,    
 [MilestoneToiletTraining] [char](1) ,    
 [MilestoneCopingSkills] [char](1) ,    
 [MilestoneComment] varchar(max) ,    
 [SleepConcernSleepHabits] char(1) ,    
 [SleepTimeGoToBed] [varchar](250) ,    
 [SleepTimeFallAsleep] [varchar](250) ,    
 [SleepThroughNight] char(1) ,    
 [SleepNightmares] char(1) ,    
 [SleepNightmaresHowOften] [varchar](250) ,    
 [SleepTerrors] char(1) ,    
 [SleepTerrorsHowOften] [varchar](250) ,    
 [SleepWalking] char(1) ,    
 [SleepWalkingHowOften] [varchar](250) ,    
 [SleepTimeWakeUp] [varchar](250) ,    
 [SleepWhere] [varchar](250) ,    
 [SleepShareRoom] char(1) ,    
 [SleepShareRoomWithWhom] [varchar](250) ,    
 [SleepTakeNaps] char(1) ,    
 [SleepTakeNapsHowOften] [varchar](250) ,    
 [FamilyPrimaryCaregiver] [varchar](250) ,    
 [FamilyPrimaryCaregiverType] [char](1) ,    
 [FamilyPrimaryCaregiverEducation] [char](1) ,    
 [FamilyPrimaryCaregiverAge] [varchar](250) ,    
 [FamilyAdditionalCareGivers] varchar(max) ,    
 [FamilyEmploymentFirstCareGiver] int ,    
 [FamilyEmploymentSecondCareGiver] int ,    
 [FamilyStatusParentsRelationship] varchar(max) ,    
 [FamilyNonCustodialContact] [char](1) ,    
 [FamilyNonCustodialHowOften] varchar(max) , 
 [FamilyNonCustodialTypeOfVisit] varchar(max) ,  
 [FamilyNonCustodialConsistency] varchar(max) ,    
 [FamilyNonCustodialLegalInvolvement] varchar(max) ,    
 [FamilyClientMovedResidences] char(1) ,    
 [FamilyClientMovedResidencesComment] varchar(max) ,    
 [FamilyClientHasSiblings] char(1) ,    
 [FamilyClientSiblingsComment] varchar(max) ,    
 [FamilyQualityRelationships] varchar(max) ,    
 [FamilySupportSystems] varchar(max) ,    
 [FamilyClientAbilitiesNA] char(1) ,    
 [FamilyClientAbilitiesComment] varchar(max) ,    
 [ChildHistoryLegalInvolvement] char(1) ,    
 [ChildHistoryLegalInvolvementComment] varchar(max) ,    
 [ChildHistoryBehaviorInFamily] char(1) ,    
 [ChildHistoryBehaviorInFamilyComment] varchar(max) ,    
 [ChildAbuseReported] char(1) ,    
 [ChildProtectiveServicesInvolved] char(1) ,    
 [ChildProtectiveServicesReason] varchar(max) ,    
 [ChildProtectiveServicesCounty] varchar(max) ,    
 [ChildProtectiveServicesCaseWorker] varchar(max) ,    
 [ChildProtectiveServicesDates] varchar(max) ,    
 [ChildProtectiveServicesPlacements] char(1) ,    
 [ChildProtectiveServicesPlacementsComment] varchar(max) ,    
 [ChildHistoryOfViolence] char(1) ,    
 [ChildHistoryOfViolenceComment] varchar(max) ,    
 [ChildCTESComplete] char(1) ,    
 [ChildCTESResults] varchar(max) ,    
 [ChildWitnessedSubstances] char(1) ,    
 [ChildWitnessedSubstancesComment] varchar(max) ,    
 [ChildBornFullTermPreTerm] [char](1) ,    
 [ChildBornFullTermPreTermComment] varchar(max) ,    
 [ChildPostPartumDepression] char(1) ,    
 [ChildMotherUsedDrugsPregnancy] char(1) ,    
 [ChildMotherUsedDrugsPregnancyComment] varchar(max) ,    
 [ChildConcernsNutrition] char(1) ,    
 [ChildConcernsNutritionComment] varchar(max) ,    
 [ChildConcernsAbilityUnderstand] char(1) ,    
 [ChildUsingWordsPhrases] char(1) ,    
 [ChildReceivedSpeechEval] char(1) ,    
 [ChildReceivedSpeechEvalComment] varchar(max) ,    
 [ChildConcernMotorSkills] char(1) ,    
 [ChildGrossMotorSkillsProblem] char(1) ,    
 [ChildWalking14Months] char(1) ,    
 [ChildFineMotorSkillsProblem] char(1) ,    
 [ChildPickUpCheerios] char(1) ,    
 [ChildConcernSocialSkills] char(1) ,    
 [ChildConcernSocialSkillsComment] varchar(max) ,    
 [ChildToiletTraining] char(1) ,    
 [ChildToiletTrainingComment] varchar(max) ,    
 [ChildSensoryAversions] char(1) ,    
 [ChildSensoryAversionsComment] varchar(max) ,    
 [HousingHowStable] varchar(max) ,    
 [HousingAbleToStay] varchar(max) ,    
 [HousingEvictionsUnpaidUtilities] varchar(max) ,    
 [HousingAbleGetUtilities] varchar(max) ,    
 [HousingAbleSignLease] varchar(max) ,    
 [HousingSpecializedProgram] varchar(max) ,    
 [HousingHasPets] varchar(max) ,    
 [VocationalUnemployed] char(1) ,    
 [VocationalInterestedWorking] char(1) ,    
 [VocationalInterestedWorkingComment] varchar(max) ,    
 [VocationalTimeSinceEmployed] varchar(max) ,    
 [VocationalTimeJobHeld] varchar(max) ,    
 [VocationalBarriersGainingEmployment] varchar(max) ,    
 [VocationalEmployed] char(1) ,    
 [VocationalTimeCurrentJob] varchar(max) ,    
 [VocationalBarriersMaintainingEmployment] varchar(max) ,
 [LevelofCare] [int]     
)    
    
insert into #CustomDocumentDiagnosticAssessments    
(    
 [DocumentVersionId],    
 [CreatedBy],    
 [CreatedDate],    
 [ModifiedBy],    
 [ModifiedDate],    
 [RecordDeleted],    
 [DeletedBy],    
 [DeletedDate],    
 [TypeOfAssessment],    
 [InitialOrUpdate],    
 [ReasonForUpdate],    
 [UpdatePsychoSocial],    
 [UpdateSubstanceUse],    
 [UpdateRiskIndicators],    
 [UpdatePhysicalHealth],    
 [UpdateEducationHistory],    
 [UpdateDevelopmentalHistory],    
 [UpdateSleepHygiene],    
 [UpdateFamilyHistory],    
 [UpdateHousing],    
 [UpdateVocational],    
 [TransferReceivingStaff],    
 [TransferReceivingProgram],    
 [TransferAssessedNeed],    
 [TransferClientParticipated],    
 [PresentingProblem],    
 [OptionsAlreadyTried],    
 [ClientHasLegalGuardian],    
 [LegalGuardianInfo],    
 [AbilitiesInterestsSkills],    
 [FamilyHistory],    
 [EthnicityCulturalBackground],    
 [SexualOrientationGenderExpression],    
 [GenderExpressionConsistent],    
 [SupportSystems],    
 [ClientStrengths],    
 [LivingSituation],    
 [IncludeHousingAssessment],    
 [ClientEmploymentNotApplicable],    
 [ClientEmploymentMilitaryHistory],    
 [IncludeVocationalAssessment],    
 [HighestEducationCompleted],    
 [EducationComment],    
 [LiteracyConcerns],    
 [LegalInvolvement],    
 [LegalInvolvementComment],    
 [HistoryEmotionalProblemsClient],    
 [ClientHasReceivedTreatment],    
 [ClientPriorTreatmentDiagnosis],    
 [PriorTreatmentCounseling],    
 [PriorTreatmentCounselingDates],    
 [PriorTreatmentCounselingComment],    
 [PriorTreatmentCaseManagement],    
 [PriorTreatmentCaseManagementDates],    
 [PriorTreatmentCaseManagementComment],    
 [PriorTreatmentOther],    
 [PriorTreatmentOtherDates],    
 [PriorTreatmentOtherComment],    
 [PriorTreatmentMedication],    
 [PriorTreatmentMedicationDates],    
 [PriorTreatmentMedicationComment],    
 [TypesOfMedicationResults],    
 [ClientResponsePastTreatment],    
 [ClientResponsePastTreatmentNA],    
 [AbuseNotApplicable],    
 [AbuseEmotionalVictim],    
 [AbuseEmotionalOffender],    
 [AbuseVerbalVictim],    
 [AbuseVerbalOffender],    
 [AbusePhysicalVictim],    
 [AbusePhysicalOffender],    
 [AbuseSexualVictim],    
 [AbuseSexualOffender],    
 [AbuseNeglectVictim],    
 [AbuseNeglectOffender],    
 [AbuseComment],    
 [FamilyPersonalHistoryLossTrauma],    
 [BiologicalMotherUseNoneReported],    
 [BiologicalMotherUseAlcohol],    
 [BiologicalMotherTobacco],    
 [BiologicalMotherUseOther],    
 [BiologicalMotherUseOtherType],    
 [ClientReportAlcoholTobaccoDrugUse],    
 [ClientReportDrugUseComment],    
 [FurtherSubstanceAssessmentIndicated],   
 [ClientHasHistorySubstanceUse],    
 [ClientHistorySubstanceUseComment],    
 [AlcoholUseWithin30Days],    
 [AlcoholUseCurrentFrequency],    
 [AlcoholUseWithinLifetime],    
 [AlcoholUsePastFrequency],    
 [AlcoholUseReceivedTreatment],    
 [CocaineUseWithin30Days],    
 [CocaineUseCurrentFrequency],    
 [CocaineUseWithinLifetime],    
 [CocaineUsePastFrequency],    
 [CocaineUseReceivedTreatment],    
 [SedtativeUseWithin30Days],    
 [SedtativeUseCurrentFrequency],    
 [SedtativeUseWithinLifetime],    
 [SedtativeUsePastFrequency],    
 [SedtativeUseReceivedTreatment],    
 [HallucinogenUseWithin30Days],    
 [HallucinogenUseCurrentFrequency],    
 [HallucinogenUseWithinLifetime],    
 [HallucinogenUsePastFrequency],    
 [HallucinogenUseReceivedTreatment],    
 [StimulantUseWithin30Days],    
 [StimulantUseCurrentFrequency],    
 [StimulantUseWithinLifetime],    
 [StimulantUsePastFrequency],    
 [StimulantUseReceivedTreatment],    
 [NarcoticUseWithin30Days],    
 [NarcoticUseCurrentFrequency],    
 [NarcoticUseWithinLifetime],    
 [NarcoticUsePastFrequency],    
 [NarcoticUseReceivedTreatment],    
 [MarijuanaUseCurrentFrequency],    
 [MarijuanaUsePastFrequency],    
 [MarijuanaUseWithin30Days],    
 [MarijuanaUseWithinLifetime],    
 [MarijuanaUseReceivedTreatment],    
 [InhalantsUseWithin30Days],    
 [InhalantsUseCurrentFrequency],    
 [InhalantsUseWithinLifetime],    
 [InhalantsUsePastFrequency],    
 [InhalantsUseReceivedTreatment],    
 [OtherUseWithin30Days],    
 [OtherUseCurrentFrequency],    
 [OtherUseWithinLifetime],    
 [OtherUsePastFrequency],    
 [OtherUseReceivedTreatment],    
 [OtherUseType],    
 [DASTScore],    
 [MASTScore],    
 [ClientReferredSubstanceTreatment],    
 [ClientReferredSubstanceTreatmentWhere],    
 [RiskSuicideIdeation],    
 [RiskSuicideIdeationComment],    
 [RiskSuicideIntent],    
 [RiskSuicideIntentComment],    
 [RiskSuicidePriorAttempts],    
 [RiskSuicidePriorAttemptsComment],    
 [RiskPriorHospitalization],    
 [RiskPriorHospitalizationComment],    
 [RiskPhysicalAggressionSelf],    
 [RiskPhysicalAggressionSelfComment],    
 [RiskVerbalAggressionOthers],    
 [RiskVerbalAggressionOthersComment],    
 [RiskPhysicalAggressionObjects],    
 [RiskPhysicalAggressionObjectsComment],    
 [RiskPhysicalAggressionPeople],    
 [RiskPhysicalAggressionPeopleComment],    
 [RiskReportRiskTaking],    
 [RiskReportRiskTakingComment],    
 [RiskThreatClientPersonalSafety],    
 [RiskThreatClientPersonalSafetyComment],    
 [RiskPhoneNumbersProvided],    
 [RiskCurrentRiskIdentified],    
 [RiskTriggersDangerousBehaviors],    
 [RiskCopingSkills],    
 [RiskInterventionsPersonalSafetyNA],    
 [RiskInterventionsPersonalSafety],    
 [RiskInterventionsPublicSafetyNA],    
 [RiskInterventionsPublicSafety],    
 [PhysicalProblemsNoneReported],    
 [PhysicalProblemsComment],    
 [SpecialNeedsNoneReported],    
 [SpecialNeedsVisualImpairment],    
 [SpecialNeedsHearingImpairment],    
 [SpecialNeedsSpeechImpairment],    
 [SpecialNeedsOtherPhysicalImpairment],    
 [SpecialNeedsOtherPhysicalImpairmentComment],    
 [EducationSchoolName],    
 [EducationPreviousExpulsions],    
 [EducationClassification],    
 [EducationEmotionalDisturbance],    
 [EducationPreschoolersDisability],    
 [EducationTraumaticBrainInjury],    
 [EducationCognitiveDisability],    
 [EducationCurrent504],    
 [EducationOtherMajorHealthImpaired],    
 [EducationSpecificLearningDisability],    
 [EducationAutism],    
 [EducationOtherMinorHealthImpaired],    
 [EdcuationClassificationComment],    
 [EducationPreviousRetentions],    
 [EducationClientIsHomeSchooled],    
 [EducationClientAttendedPreschool],    
 [EducationFrequencyOfAttendance],    
 [EducationReceivedServicesAsToddler],    
 [EducationReceivedServicesAsToddlerComment],    
 [ClientPreferencesForTreatment],    
 [ExternalSupportsReferrals],    
 [PrimaryClinicianTransfer],    
 [EAPMentalStatus],    
 [DiagnosticImpressionsSummary],    
 [MilestoneUnderstandingLanguage],    
 [MilestoneVocabulary],    
 [MilestoneFineMotor],    
 [MilestoneGrossMotor],    
 [MilestoneIntellectual],    
 [MilestoneMakingFriends],    
 [MilestoneSharingInterests],    
 [MilestoneEyeContact],    
 [MilestoneToiletTraining],    
 [MilestoneCopingSkills],    
 [MilestoneComment],    
 [SleepConcernSleepHabits],    
 [SleepTimeGoToBed],    
 [SleepTimeFallAsleep],    
 [SleepThroughNight],    
 [SleepNightmares],    
 [SleepNightmaresHowOften],    
 [SleepTerrors],    
 [SleepTerrorsHowOften],    
 [SleepWalking],    
 [SleepWalkingHowOften],    
 [SleepTimeWakeUp],    
 [SleepWhere],    
 [SleepShareRoom],    
 [SleepShareRoomWithWhom],    
 [SleepTakeNaps],    
 [SleepTakeNapsHowOften],    
 [FamilyPrimaryCaregiver],    
 [FamilyPrimaryCaregiverType],    
 [FamilyPrimaryCaregiverEducation],    
 [FamilyPrimaryCaregiverAge],    
 [FamilyAdditionalCareGivers],    
 [FamilyEmploymentFirstCareGiver],    
 [FamilyEmploymentSecondCareGiver],    
 [FamilyStatusParentsRelationship],    
 [FamilyNonCustodialContact],    
 [FamilyNonCustodialHowOften],    
 [FamilyNonCustodialTypeOfVisit],    
 [FamilyNonCustodialConsistency],    
 [FamilyNonCustodialLegalInvolvement],    
 [FamilyClientMovedResidences],    
 [FamilyClientMovedResidencesComment],    
 [FamilyClientHasSiblings],    
 [FamilyClientSiblingsComment],    
 [FamilyQualityRelationships],    
 [FamilySupportSystems],    
 [FamilyClientAbilitiesNA],    
 [FamilyClientAbilitiesComment],    
 [ChildHistoryLegalInvolvement],    
 [ChildHistoryLegalInvolvementComment],    
 [ChildHistoryBehaviorInFamily],    
 [ChildHistoryBehaviorInFamilyComment],    
 [ChildAbuseReported],    
 [ChildProtectiveServicesInvolved],    
 [ChildProtectiveServicesReason],    
 [ChildProtectiveServicesCounty],    
 [ChildProtectiveServicesCaseWorker],    
 [ChildProtectiveServicesDates],    
 [ChildProtectiveServicesPlacements],    
 [ChildProtectiveServicesPlacementsComment],    
 [ChildHistoryOfViolence],    
 [ChildHistoryOfViolenceComment],    
 [ChildCTESComplete],    
 [ChildCTESResults],    
 [ChildWitnessedSubstances],    
 [ChildWitnessedSubstancesComment],    
 [ChildBornFullTermPreTerm],    
 [ChildBornFullTermPreTermComment],    
 [ChildPostPartumDepression],    
 [ChildMotherUsedDrugsPregnancy],    
 [ChildMotherUsedDrugsPregnancyComment],    
 [ChildConcernsNutrition],    
 [ChildConcernsNutritionComment],    
 [ChildConcernsAbilityUnderstand],    
 [ChildUsingWordsPhrases],    
 [ChildReceivedSpeechEval],    
 [ChildReceivedSpeechEvalComment],    
 [ChildConcernMotorSkills],    
 [ChildGrossMotorSkillsProblem],    
 [ChildWalking14Months],    
 [ChildFineMotorSkillsProblem],    
 [ChildPickUpCheerios],    
 [ChildConcernSocialSkills],    
 [ChildConcernSocialSkillsComment],    
 [ChildToiletTraining],    
 [ChildToiletTrainingComment],    
 [ChildSensoryAversions],    
 [ChildSensoryAversionsComment],    
 [HousingHowStable],    
 [HousingAbleToStay],    
 [HousingEvictionsUnpaidUtilities],    
 [HousingAbleGetUtilities],    
 [HousingAbleSignLease],    
 [HousingSpecializedProgram],    
 [HousingHasPets],    
 [VocationalUnemployed],    
 [VocationalInterestedWorking],    
 [VocationalInterestedWorkingComment],    
 [VocationalTimeSinceEmployed],    
 [VocationalTimeJobHeld],    
 [VocationalBarriersGainingEmployment],    
 [VocationalEmployed],    
 [VocationalTimeCurrentJob],    
 [VocationalBarriersMaintainingEmployment],
 [LevelofCare]    
)    
select    
 [DocumentVersionId],    
 [CreatedBy],    
 [CreatedDate],    
 [ModifiedBy],    
 [ModifiedDate],    
 [RecordDeleted],    
 [DeletedBy],    
 [DeletedDate],    
 [TypeOfAssessment],    
 [InitialOrUpdate],    
 [ReasonForUpdate],    
 [UpdatePsychoSocial],    
 [UpdateSubstanceUse],    
 [UpdateRiskIndicators],    
 [UpdatePhysicalHealth],    
 [UpdateEducationHistory],    
 [UpdateDevelopmentalHistory],    
 [UpdateSleepHygiene],    
 [UpdateFamilyHistory],    
 [UpdateHousing],    
 [UpdateVocational],    
 [TransferReceivingStaff],    
 [TransferReceivingProgram],    
 [TransferAssessedNeed],    
 [TransferClientParticipated],    
 [PresentingProblem],    
 [OptionsAlreadyTried],    
 [ClientHasLegalGuardian],    
 [LegalGuardianInfo],    
 [AbilitiesInterestsSkills],    
 [FamilyHistory],    
 [EthnicityCulturalBackground],    
 [SexualOrientationGenderExpression],    
 [GenderExpressionConsistent],    
 [SupportSystems],    
 [ClientStrengths],    
 [LivingSituation],    
 [IncludeHousingAssessment],    
 [ClientEmploymentNotApplicable],    
 [ClientEmploymentMilitaryHistory],    
 [IncludeVocationalAssessment],    
 [HighestEducationCompleted],    
 [EducationComment],    
 [LiteracyConcerns],    
 [LegalInvolvement],    
 [LegalInvolvementComment],    
 [HistoryEmotionalProblemsClient],    
 [ClientHasReceivedTreatment],    
 [ClientPriorTreatmentDiagnosis],    
 [PriorTreatmentCounseling],    
 [PriorTreatmentCounselingDates],    
 [PriorTreatmentCounselingComment],    
 [PriorTreatmentCaseManagement],    
 [PriorTreatmentCaseManagementDates],    
 [PriorTreatmentCaseManagementComment],    
 [PriorTreatmentOther],    
 [PriorTreatmentOtherDates],    
 [PriorTreatmentOtherComment],    
 [PriorTreatmentMedication],    
 [PriorTreatmentMedicationDates],    
 [PriorTreatmentMedicationComment],    
 [TypesOfMedicationResults],    
 [ClientResponsePastTreatment],    
 [ClientResponsePastTreatmentNA],    
 [AbuseNotApplicable],    
 [AbuseEmotionalVictim],    
 [AbuseEmotionalOffender],    
 [AbuseVerbalVictim],    
 [AbuseVerbalOffender],    
 [AbusePhysicalVictim],    
 [AbusePhysicalOffender],    
 [AbuseSexualVictim],    
 [AbuseSexualOffender],    
 [AbuseNeglectVictim],    
 [AbuseNeglectOffender],    
 [AbuseComment],    
 [FamilyPersonalHistoryLossTrauma],    
 [BiologicalMotherUseNoneReported],    
 [BiologicalMotherUseAlcohol],    
 [BiologicalMotherTobacco],    
 [BiologicalMotherUseOther],    
 [BiologicalMotherUseOtherType],    
 [ClientReportAlcoholTobaccoDrugUse],    
 [ClientReportDrugUseComment],    
 [FurtherSubstanceAssessmentIndicated],    
 [ClientHasHistorySubstanceUse],    
 [ClientHistorySubstanceUseComment],    
 [AlcoholUseWithin30Days],    
 [AlcoholUseCurrentFrequency],    
 [AlcoholUseWithinLifetime],    
 [AlcoholUsePastFrequency],    
 [AlcoholUseReceivedTreatment],    
 [CocaineUseWithin30Days],    
 [CocaineUseCurrentFrequency],    
 [CocaineUseWithinLifetime],    
 [CocaineUsePastFrequency],    
 [CocaineUseReceivedTreatment],    
 [SedtativeUseWithin30Days],    
 [SedtativeUseCurrentFrequency],    
 [SedtativeUseWithinLifetime],    
 [SedtativeUsePastFrequency],    
 [SedtativeUseReceivedTreatment],    
 [HallucinogenUseWithin30Days],    
 [HallucinogenUseCurrentFrequency],    
 [HallucinogenUseWithinLifetime],    
 [HallucinogenUsePastFrequency],    
 [HallucinogenUseReceivedTreatment],    
 [StimulantUseWithin30Days],    
 [StimulantUseCurrentFrequency],    
 [StimulantUseWithinLifetime],    
 [StimulantUsePastFrequency],    
 [StimulantUseReceivedTreatment],    
 [NarcoticUseWithin30Days],    
 [NarcoticUseCurrentFrequency],    
 [NarcoticUseWithinLifetime],    
 [NarcoticUsePastFrequency],    
 [NarcoticUseReceivedTreatment],    
 [MarijuanaUseCurrentFrequency],    
 [MarijuanaUsePastFrequency],    
 [MarijuanaUseWithin30Days],    
 [MarijuanaUseWithinLifetime],    
 [MarijuanaUseReceivedTreatment],    
 [InhalantsUseWithin30Days],    
 [InhalantsUseCurrentFrequency],    
 [InhalantsUseWithinLifetime],    
 [InhalantsUsePastFrequency],    
 [InhalantsUseReceivedTreatment],    
 [OtherUseWithin30Days],    
 [OtherUseCurrentFrequency],    
 [OtherUseWithinLifetime],    
 [OtherUsePastFrequency],    
 [OtherUseReceivedTreatment],    
 [OtherUseType],    
 [DASTScore],    
 [MASTScore],    
 [ClientReferredSubstanceTreatment],    
 [ClientReferredSubstanceTreatmentWhere],    
 [RiskSuicideIdeation],    
 [RiskSuicideIdeationComment],    
 [RiskSuicideIntent],    
 [RiskSuicideIntentComment],    
 [RiskSuicidePriorAttempts],    
 [RiskSuicidePriorAttemptsComment],    
 [RiskPriorHospitalization],    
 [RiskPriorHospitalizationComment],    
 [RiskPhysicalAggressionSelf],    
 [RiskPhysicalAggressionSelfComment],    
 [RiskVerbalAggressionOthers],    
 [RiskVerbalAggressionOthersComment],    
 [RiskPhysicalAggressionObjects],    
 [RiskPhysicalAggressionObjectsComment],    
 [RiskPhysicalAggressionPeople],    
 [RiskPhysicalAggressionPeopleComment],    
 [RiskReportRiskTaking],    
 [RiskReportRiskTakingComment],    
 [RiskThreatClientPersonalSafety],    
 [RiskThreatClientPersonalSafetyComment],    
 [RiskPhoneNumbersProvided],    
 [RiskCurrentRiskIdentified],    
 [RiskTriggersDangerousBehaviors],    
 [RiskCopingSkills],    
 [RiskInterventionsPersonalSafetyNA],    
 [RiskInterventionsPersonalSafety],    
 [RiskInterventionsPublicSafetyNA],    
 [RiskInterventionsPublicSafety],    
 [PhysicalProblemsNoneReported],    
 [PhysicalProblemsComment],    
 [SpecialNeedsNoneReported],    
 [SpecialNeedsVisualImpairment],    
 [SpecialNeedsHearingImpairment],    
 [SpecialNeedsSpeechImpairment],    
 [SpecialNeedsOtherPhysicalImpairment],    
 [SpecialNeedsOtherPhysicalImpairmentComment],    
 [EducationSchoolName],    
 [EducationPreviousExpulsions],    
 [EducationClassification],    
 [EducationEmotionalDisturbance],    
 [EducationPreschoolersDisability],    
 [EducationTraumaticBrainInjury],    
 [EducationCognitiveDisability],    
 [EducationCurrent504],    
 [EducationOtherMajorHealthImpaired],    
 [EducationSpecificLearningDisability],    
 [EducationAutism],    
 [EducationOtherMinorHealthImpaired],    
 [EdcuationClassificationComment],    
 [EducationPreviousRetentions],    
 [EducationClientIsHomeSchooled],    
 [EducationClientAttendedPreschool],    
 [EducationFrequencyOfAttendance],    
 [EducationReceivedServicesAsToddler],    
 [EducationReceivedServicesAsToddlerComment],    
 [ClientPreferencesForTreatment],    
 [ExternalSupportsReferrals],    
 [PrimaryClinicianTransfer],    
 [EAPMentalStatus],    
 [DiagnosticImpressionsSummary],    
 [MilestoneUnderstandingLanguage],    
 [MilestoneVocabulary],    
 [MilestoneFineMotor],    
 [MilestoneGrossMotor],    
 [MilestoneIntellectual],    
 [MilestoneMakingFriends],    
 [MilestoneSharingInterests],    
 [MilestoneEyeContact],    
 [MilestoneToiletTraining],    
 [MilestoneCopingSkills],    
 [MilestoneComment],    
 [SleepConcernSleepHabits],    
 [SleepTimeGoToBed],    
 [SleepTimeFallAsleep],    
 [SleepThroughNight],    
 [SleepNightmares],    
 [SleepNightmaresHowOften],    
 [SleepTerrors],    
 [SleepTerrorsHowOften],    
 [SleepWalking],    
 [SleepWalkingHowOften],    
 [SleepTimeWakeUp],    
 [SleepWhere],    
 [SleepShareRoom],    
 [SleepShareRoomWithWhom],    
 [SleepTakeNaps],    
 [SleepTakeNapsHowOften],    
 [FamilyPrimaryCaregiver],    
 [FamilyPrimaryCaregiverType],    
 [FamilyPrimaryCaregiverEducation],    
 [FamilyPrimaryCaregiverAge],    
 [FamilyAdditionalCareGivers],    
 [FamilyEmploymentFirstCareGiver],    
 [FamilyEmploymentSecondCareGiver],    
 [FamilyStatusParentsRelationship],    
 [FamilyNonCustodialContact],    
 [FamilyNonCustodialHowOften],    
 [FamilyNonCustodialTypeOfVisit],    
 [FamilyNonCustodialConsistency],    
 [FamilyNonCustodialLegalInvolvement],    
 [FamilyClientMovedResidences],    
 [FamilyClientMovedResidencesComment],    
 [FamilyClientHasSiblings],    
 [FamilyClientSiblingsComment],    
 [FamilyQualityRelationships],    
 [FamilySupportSystems],    
 [FamilyClientAbilitiesNA],    
 [FamilyClientAbilitiesComment],    
 [ChildHistoryLegalInvolvement],    
 [ChildHistoryLegalInvolvementComment],    
 [ChildHistoryBehaviorInFamily],    
 [ChildHistoryBehaviorInFamilyComment],    
 [ChildAbuseReported],    
 [ChildProtectiveServicesInvolved],    
 [ChildProtectiveServicesReason],    
 [ChildProtectiveServicesCounty],    
 [ChildProtectiveServicesCaseWorker],    
 [ChildProtectiveServicesDates],    
 [ChildProtectiveServicesPlacements],    
 [ChildProtectiveServicesPlacementsComment],    
 [ChildHistoryOfViolence],    
 [ChildHistoryOfViolenceComment],    
 [ChildCTESComplete],    
 [ChildCTESResults],    
 [ChildWitnessedSubstances],    
 [ChildWitnessedSubstancesComment],    
 [ChildBornFullTermPreTerm],    
 [ChildBornFullTermPreTermComment],    
 [ChildPostPartumDepression],    
 [ChildMotherUsedDrugsPregnancy],    
 [ChildMotherUsedDrugsPregnancyComment],    
 [ChildConcernsNutrition],    
 [ChildConcernsNutritionComment],    
 [ChildConcernsAbilityUnderstand],    
 [ChildUsingWordsPhrases],    
 [ChildReceivedSpeechEval],    
 [ChildReceivedSpeechEvalComment],    
 [ChildConcernMotorSkills],    
 [ChildGrossMotorSkillsProblem],    
 [ChildWalking14Months],    
 [ChildFineMotorSkillsProblem],    
 [ChildPickUpCheerios],    
 [ChildConcernSocialSkills],    
 [ChildConcernSocialSkillsComment],    
 [ChildToiletTraining],    
 [ChildToiletTrainingComment],    
 [ChildSensoryAversions],    
 [ChildSensoryAversionsComment],    
 [HousingHowStable],    
 [HousingAbleToStay],    
 [HousingEvictionsUnpaidUtilities],    
 [HousingAbleGetUtilities],    
 [HousingAbleSignLease],    
 [HousingSpecializedProgram],    
 [HousingHasPets],    
 [VocationalUnemployed],    
 [VocationalInterestedWorking],    
 [VocationalInterestedWorkingComment],    
 [VocationalTimeSinceEmployed],    
 [VocationalTimeJobHeld],    
 [VocationalBarriersGainingEmployment],    
 [VocationalEmployed],    
 [VocationalTimeCurrentJob],    
 [VocationalBarriersMaintainingEmployment] ,
 [LevelofCare]   
from CustomDocumentDiagnosticAssessments    
where DocumentVersionId = @DocumentVersionId    
    
-- Initial / Adult BH    
if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''A'' and [InitialOrUpdate] = ''I'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialAdult @DocumentVersionId    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 -- determine whether the treatment goals need to be validated    
 if exists (    
  select *    
  from CustomDocumentAssessmentReferrals as cdar    
  where cdar.DocumentVersionId = @DocumentVersionId    
  -- need logic to exclude evals    
  and cdar.ServiceRecommended not in (10, 14, 15) -- DP Consult, Psych Testing, Psych Eval    
  and ISNULL(cdar.RecordDeleted, ''N'') <> ''Y''    
 )    
 or exists (    
  select *    
  from dbo.CustomTPGoals as tpg    
  where tpg.DocumentVersionId = @DocumentVersionId    
 -- and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '''')))) > 0    
  and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''    
 )    
 begin    
  exec csp_ValidateCustomDocumentDiagnosticAssessmentsTreatmentPlan @DocumentVersionId, 8    
 end    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Update / Adult BH    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''A'' and [InitialOrUpdate] = ''U'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialAdult @DocumentVersionId    
 -- exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Initial / Minor BH    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''M'' and [InitialOrUpdate] = ''I'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor @DocumentVersionId    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 -- determine whether the treatment goals need to be validated    
 if exists (    
  select *    
  from CustomDocumentAssessmentReferrals as cdar    
  where cdar.DocumentVersionId = @DocumentVersionId    
  -- need logic to exclude evals    
  and cdar.ServiceRecommended not in (10, 14, 15) -- DP Consult, Psych Testing, Psych Eval    
  and ISNULL(cdar.RecordDeleted, ''N'') <> ''Y''    
 )    
 or exists (    
  select *    
  from dbo.CustomTPGoals as tpg    
  where tpg.DocumentVersionId = @DocumentVersionId    
  --and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '''')))) > 0    
  and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''    
 )    
 begin    
  exec csp_ValidateCustomDocumentDiagnosticAssessmentsTreatmentPlan @DocumentVersionId, 8    
 end    
    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Update / Minor BH    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''M'' and [InitialOrUpdate] = ''U'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor @DocumentVersionId    
 -- exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Initial / Early Child/DP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''C'' and [InitialOrUpdate] = ''I'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP @DocumentVersionId    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 -- determine whether the treatment goals need to be validated    
 if exists (    
  select *    
  from CustomDocumentAssessmentReferrals as cdar    
  where cdar.DocumentVersionId = @DocumentVersionId    
  and cdar.ServiceRecommended not in (10, 14, 15) -- DP Consult, Psych Testing, Psych Eval    
  and ISNULL(cdar.RecordDeleted, ''N'') <> ''Y''    
 )    
 or exists (    
  select *    
  from dbo.CustomTPGoals as tpg    
  where tpg.DocumentVersionId = @DocumentVersionId    
  -- and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '''')))) > 0    
  and ISNULL(tpg.RecordDeleted, ''N'') <> ''Y''    
 )    
 begin    
  exec csp_ValidateCustomDocumentDiagnosticAssessmentsTreatmentPlan @DocumentVersionId, 8   end    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Update / Early Child / DP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''C'' and [InitialOrUpdate] = ''U'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP @DocumentVersionId    
 -- exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Initial / EAP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''E'' and [InitialOrUpdate] = ''I'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialEAP @DocumentVersionId    
    
end    
-- Update / EAP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = ''E'' and [InitialOrUpdate] = ''U'')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialEAP @DocumentVersionId    
    
end    
 
-- check for an "assessment" service on the same day for the same client.    
--if not exists (    
-- select *    
-- from dbo.DocumentVersions as dv    
-- join dbo.Documents as d on d.DocumentId = dv.DocumentId    
-- join dbo.Services as s on s.ClientId = d.ClientId    
-- where dv.DocumentVersionId = @DocumentVersionId    
-- and s.ProcedureCodeId in (    
--  24,  --ASSESSMENT    
--  26,  --ASSMT_UPD     
--  258, --EAP_ASSESS    
--  269, --EAPPHON_AS    
--  277, --EQ_ASSESS     
--  318, --ASSMT_HOSP    
--  509, --V_RSCASSMT    
--  532, --V_SIT_ASST    
--  --617, --WELL_ASSES    
--  241, --EAP_MD_AST    
--  267, --EAP_MD_AST  avoss 08.06.2012    
--  159  --OWF_NB_AST    
-- )    
-- and s.Status in (71, 75) -- show complete    
-- and DATEDIFF(DAY, d.EffectiveDate, s.DateOfService) = 0    
-- and ISNULL(s.RecordDeleted, ''N'') <> ''Y''    
-- and ISNULL(d.RecordDeleted, ''N'') <> ''Y''    
--)    
--begin    
-- Insert into #validationReturnTable (    
--  TableName,      
--  ColumnName,      
--  ErrorMessage,      
--  TabOrder,      
--  ValidationOrder      
-- ) values (    
--  ''CustomDocumentDiagnosticAssessments'',    
--  ''DeletedBy'',    
--  ''A show/complete "Assessment" service must exist for this document effective date.'',    
--  11,    
--  1    
-- )    
--end    
    
    
  
-- check for an "LevelofCare" in CustomDocumentDiagnosticAssessments. 
declare @levelofcare int
select  @levelofcare = LevelofCare from #CustomDocumentDiagnosticAssessments as da   
 where da.DocumentVersionId = @DocumentVersionId  and ISNULL(da.RecordDeleted, ''N'') <> ''Y''  
if (@levelofcare is null )
begin    
 Insert into #validationReturnTable (    
  TableName,      
  ColumnName,      
  ErrorMessage,      
  TabOrder,      
  ValidationOrder      
 ) values (    
  ''CustomDocumentDiagnosticAssessments'',    
  ''LevelofCare'',    
  ''Level of Care is required'',    
  12,    
  1    
 )    
end
' 
END
GO
