
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentCALOCUS')
BEGIN

CREATE TABLE [dbo].[DocumentCALOCUS](
	[DocumentVersionId] [int] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
	[DeletedDate] [datetime] NULL,
	
	NoIndicationCurrSuicidal [dbo].[type_YOrN] NULL,
	NoINdicationOfAggression [dbo].[type_YOrN] NULL,
	DevelopmentallyAppropriateAbility [dbo].[type_YOrN] NULL,
	LowRiskVictimization [dbo].[type_YOrN] NULL,


	PastHistoryFleetingSuicidal [dbo].[type_YOrN] NULL,
	MilSuicidalIdeation [dbo].[type_YOrN] NULL,
	IndicationOrReport [dbo].[type_YOrN] NULL,
	SubstanceUse [dbo].[type_YOrN] NULL,
	InfrequentBriefLapses [dbo].[type_YOrN] NULL,
	SomeRiskForVictimization [dbo].[type_YOrN] NULL,


	SignificantCurrentSuicidal [dbo].[type_YOrN] NULL,
	NoActiveSuicidal [dbo].[type_YOrN] NULL,
	IndicationOrReportOfIncidentsActing [dbo].[type_YOrN] NULL,
	BingeOrExcessiveUse [dbo].[type_YOrN] NULL,
	PeriodsOfInabilityToCare [dbo].[type_YOrN] NULL,
	SignificantRiskForVictimization [dbo].[type_YOrN] NULL,

	CurrentSuicidalOrHomicidalIdeation [dbo].[type_YOrN] NULL,
	IndicationOrReportOfSignificantImpulsivity [dbo].[type_YOrN] NULL,
	SignsOfConsistentDeficits [dbo].[type_YOrN] NULL,
	RecentPatternOfExcessiveSubstance  [dbo].[type_YOrN] NULL,
	ClearAndPersistentInability  [dbo].[type_YOrN] NULL,
	ImminentRiskOfSevereVictimization [dbo].[type_YOrN] NULL,

	CurrentSuicidalOrHomicidalBehavior [dbo].[type_YOrN] NULL,
	withoutExpressedAmbivalence [dbo].[type_YOrN] NULL,
	WithAHistoryOfSeriousPast [dbo].[type_YOrN] NULL,
	InPresenceOfCommandHalucination [dbo].[type_YOrN] NULL,
	IndicationOrReportOfRepeatedBehavior [dbo].[type_YOrN] NULL,
	RelentlesslyEngagingInAcutely [dbo].[type_YOrN] NULL,
	APatternOfNearlyConstant [dbo].[type_YOrN] NULL,
 
	----------------------------------------------------------------------

	ConsistentFunctioningAppropriate [dbo].[type_YOrN] NULL,
	NoMoreThanTemporaryImpairment [dbo].[type_YOrN] NULL,

	SomeEvidenceOfMinorFailures [dbo].[type_YOrN] NULL,
	OccasionalEpisodesInWhichSomeAspects [dbo].[type_YOrN] NULL,
	DemonstratesSignificantImprovement [dbo].[type_YOrN] NULL,

	ConflictedWithdrawnOrOtherwiseTroubled [dbo].[type_YOrN] NULL,
	SelfCareHygieneDeterioratesBelowUsual [dbo].[type_YOrN] NULL,
	SignificantDisturbancesInPhysicalFunction [dbo].[type_YOrN] NULL,
	SchoolBehaviorHasDeterioratedToPoint [dbo].[type_YOrN] NULL,
	ChronicAndOrVariablySevereDeficits [dbo].[type_YOrN] NULL,
	RecentGainsAndOrStabilizationInFunctioning [dbo].[type_YOrN] NULL,

	SeriousDeteriorationOfInterpersonal [dbo].[type_YOrN] NULL,
	SignificantWithdrawalAndAvoidance [dbo].[type_YOrN] NULL,
	ConsistentFailureToAchieveSelfCare [dbo].[type_YOrN] NULL,
	SeriousDisturbancesInPhysical [dbo].[type_YOrN] NULL,
	InabilityToPerformAdequately [dbo].[type_YOrN] NULL,

	ExtremeDeteriorationInInteractions [dbo].[type_YOrN] NULL,
	CompleteWithdrawalFromAllSocial [dbo].[type_YOrN] NULL,
	CompleteNeglectOfInability [dbo].[type_YOrN] NULL,
	ExtremeDisruptionInPhysicalFunction [dbo].[type_YOrN] NULL,
	AttendingSchoolSporadically [dbo].[type_YOrN] NULL,

	----------------------------------------------------------------------
	NoEvidenceOfMedicalIllness [dbo].[type_YOrN] NULL,
	PastMedicalSubstanceUse [dbo].[type_YOrN] NULL,

	MinimalDevelopmentalDelayDisorder [dbo].[type_YOrN] NULL,
	SelfLimitedMedicalConditions [dbo].[type_YOrN] NULL,
	OccasionalSelfLimitedEpisodes [dbo].[type_YOrN] NULL,
	TransientOccasionalStressRelated [dbo].[type_YOrN] NULL,

	DevelopmentalDisabilityIsPresentThat [dbo].[type_YOrN] NULL,
	MedicalConditionsArePresentRequiring [dbo].[type_YOrN] NULL,
	MedicalConditionsArePresentAdversely [dbo].[type_YOrN] NULL,
	SubstanceAbuseSignificantAdverseEffect [dbo].[type_YOrN] NULL,
	RecentSubstanceUseThatHasSignificantImpact [dbo].[type_YOrN] NULL,
	PsychiatricSignsAndSymptomsArePresent [dbo].[type_YOrN] NULL,

	MedicalConditionsArePresentRequireMonitoring [dbo].[type_YOrN] NULL,
	MedicalConditionsArePresentAffecting [dbo].[type_YOrN] NULL,
	UncontrolledSubstanceUsePresentSeriousThreat [dbo].[type_YOrN] NULL,
	DevelopmentalDelayOrDisorderSignificantlyAlters [dbo].[type_YOrN] NULL,
	PsychiatricSymptomsPresentClearlyImpairFunctioning [dbo].[type_YOrN] NULL,

	SignificantMedicalConditionIsPresent [dbo].[type_YOrN] NULL,
	MedicalConditionAcutelyChronicallyWorsens [dbo].[type_YOrN] NULL,
	SubstanceDependencePresentWithInability [dbo].[type_YOrN] NULL,
	DevelopmentalDisorderPresentComplicates [dbo].[type_YOrN] NULL,
	AcuteSeverePsychiatricSymptomsPresent [dbo].[type_YOrN] NULL,

	----------------------------------------------------------------------

	AbsenceOfSignificantOrEnduringDifficulties [dbo].[type_YOrN] NULL,
	AbsenceOfRecentTransitionsOrLossesOfConsequence [dbo].[type_YOrN] NULL,
	MaterialNeedsMetWithoutSignificantCause [dbo].[type_YOrN] NULL,
	LivingEnvironmentConduciveNormativeGrowth [dbo].[type_YOrN] NULL,
	RoleExpectationsAreConsistentWithChild [dbo].[type_YOrN] NULL,

	SignificantTransitionRequiringAdjustment [dbo].[type_YOrN] NULL,
	MinorInterpersonalLossOrConflict [dbo].[type_YOrN] NULL,
	TransientButSignificantIllnessOrInjury [dbo].[type_YOrN] NULL,
	SomewhatInadequateMaterialResourcesThreat [dbo].[type_YOrN] NULL,
	ExpectationsForPerformanceAtHomeOrSchool [dbo].[type_YOrN] NULL,
	PotentialForExposureToSubstanceUse [dbo].[type_YOrN] NULL,

	DisruptionOfFamilySocialMilieu [dbo].[type_YOrN] NULL,
	InterpersonalOrMaterialLossThatHasSignificant [dbo].[type_YOrN] NULL,
	SeriousIllnessInjuryForProlongedPeriod [dbo].[type_YOrN] NULL,
	DangerOrThreatInNeighborhoodOrCommunity [dbo].[type_YOrN] NULL,
	ExposureToSubstanceAbuseAndItsEffects [dbo].[type_YOrN] NULL,
	RoleExpectationsThatExceedChild [dbo].[type_YOrN] NULL,

	SeriousDisruptionOfFamilySocialMilieu [dbo].[type_YOrN] NULL,
	ThreatOfSevereDisruptionInLifeCircumstances [dbo].[type_YOrN] NULL,
	InabilityToMeetNeedsForPhysical [dbo].[type_YOrN] NULL,
	ExposureToEndangeringCriminalActivities [dbo].[type_YOrN] NULL,
	DifficultyAvoidingExposureToSubstanceUse [dbo].[type_YOrN] NULL,


	HighlyTraumaticEnduringAndDisturbingCircumstances [dbo].[type_YOrN] NULL,
	PoliticalOrRacialPersecution [dbo].[type_YOrN] NULL,
	YouthFacesIncarcerationFosterHomePlacement [dbo].[type_YOrN] NULL,
	SeverePainInjuryOrDisability [dbo].[type_YOrN] NULL,

	----------------------------------------------------------------------

	FamilyAndOrdinaryCommunityResources [dbo].[type_YOrN] NULL,
	ContinuityOfActiveEngagedPrimary [dbo].[type_YOrN] NULL,
	EffectiveInvolvementOfWraparound [dbo].[type_YOrN] NULL,

	ContinuityOfFamilyOrPrimaryCaretakers [dbo].[type_YOrN] NULL,
	FamilyPrimaryCaretakersAreWilling [dbo].[type_YOrN] NULL,
	SpecialNeedsAreAddressedThroughSuccessful [dbo].[type_YOrN] NULL,
	CommunityResourcesAreSufficient [dbo].[type_YOrN] NULL,

	FamilyHasLimitedAbilityToRespond [dbo].[type_YOrN] NULL,
	CommunityResourcesOnlyPartiallyCompensate [dbo].[type_YOrN] NULL,
	FamilyOrPrimaryCaretakersDemonstrate [dbo].[type_YOrN] NULL,

	FamilyOrPrimaryCaretakersSeriouslyLimited [dbo].[type_YOrN] NULL,
	FewCommunitySupportsAndOrSerious [dbo].[type_YOrN] NULL,
	FamilyAndOtherPrimaryCaretakers [dbo].[type_YOrN] NULL,

	FamilyAndOrOtherPrimaryCaretakers [dbo].[type_YOrN] NULL,
	CommunityHasDeteriorated [dbo].[type_YOrN] NULL,
	LackOfLiaisonAndCooperation [dbo].[type_YOrN] NULL,
	InabilityOfFamilyOrOtherPrimary [dbo].[type_YOrN] NULL,
	LackOfEvenMinimalAttachment [dbo].[type_YOrN] NULL,

	----------------------------------------------------------------------

	ThereHasBeenNoPriorExperience [dbo].[type_YOrN] NULL,
	ChildHasDemonstratedSignificant [dbo].[type_YOrN] NULL,
	PriorExperienceIndicatesThatEfforts [dbo].[type_YOrN] NULL,
	ThereHasBeenSuccessfulManagement [dbo].[type_YOrN] NULL,
	AbleToTransitionSuccessfully [dbo].[type_YOrN] NULL,

	ChildDemonstratedAverageAbility [dbo].[type_YOrN] NULL,
	PreviousExperienceInTreatment [dbo].[type_YOrN] NULL,
	SignificantAbilityToManageRecovery [dbo].[type_YOrN] NULL,
	RecoveryHasBeenManagedForShort [dbo].[type_YOrN] NULL,
	AbleToTransitionSuccessfullyAndAccept [dbo].[type_YOrN] NULL,

	ChildHasDemonstratedAnInconsistent [dbo].[type_YOrN] NULL,
	PreviousExperienceInTreatmentAtLowLevel [dbo].[type_YOrN] NULL,
	RecoveryHasBeenMaintainedForModerate [dbo].[type_YOrN] NULL,
	HasDemonstratedLimitedAbility [dbo].[type_YOrN] NULL,
	DevelopmentalPressuresAndLifeChangesDeterioration [dbo].[type_YOrN] NULL,
	AbleToTransitionSuccessfullyAndAcceptChange [dbo].[type_YOrN] NULL,

	ChildHasDemonstratedFrequentEvidence [dbo].[type_YOrN] NULL,
	PreviousTreatmentHasNotAchievedComplete [dbo].[type_YOrN] NULL,
	AttemptsToMaintainWhateverGains [dbo].[type_YOrN] NULL,
	DevelopmentalPressuresAndLifeChangesDistress [dbo].[type_YOrN] NULL,
	TransitionsWithChangesInRoutine [dbo].[type_YOrN] NULL,

	ChildHasDemonstratedSignificantAndConsistent [dbo].[type_YOrN] NULL,
	PastResponseToTreatmentHasBeenQuite [dbo].[type_YOrN] NULL,
	SymptomsArePersistentAndFunctionalAbility [dbo].[type_YOrN] NULL,
	DevelopmentalPressuresAndLifeChangesTurmoil [dbo].[type_YOrN] NULL,
	UnableToTransitionOrAcceptChanges [dbo].[type_YOrN] NULL,
	----------------------------------------------------------------------

	QuicklyFormsATrustingAndRespectfulPositive [dbo].[type_YOrN] NULL,
	AbleToDefineProblemsAndUnderstands [dbo].[type_YOrN] NULL,
	AcceptsAgeAppropriateResponsibilityForBehavior [dbo].[type_YOrN] NULL,
	ActivelyParticipatesInTreatmentPlanning [dbo].[type_YOrN] NULL,

	AbleToDevelopATrustingPositiveRelationship [dbo].[type_YOrN] NULL,
	UnableToDefineTheProblemButCanUnderstand [dbo].[type_YOrN] NULL,
	AcceptsLimitedAgeAppropriate [dbo].[type_YOrN] NULL,
	PassivelyCooperatesInTreatmentPlanning [dbo].[type_YOrN] NULL,

	AmbivalentAvoidantOrDistrustfulRelationship [dbo].[type_YOrN] NULL,
	AcknowledgesExistenceOfProblemButResists [dbo].[type_YOrN] NULL,
	MinimizesOrRationalizesDistressingBehaviors [dbo].[type_YOrN] NULL,
	UnableToAcceptOthersDefinition [dbo].[type_YOrN] NULL,
	FrequentlyMissesOrLateForTreatment [dbo].[type_YOrN] NULL,

	ActivelyHostileRelationshipWithClinicians [dbo].[type_YOrN] NULL,
	AcceptsNoAgeAppropriateResponsibilityRole [dbo].[type_YOrN] NULL,
	ActivelyFrequentlyDisruptsOrStonewalls [dbo].[type_YOrN] NULL,

	UnableToFormTherapeutic [dbo].[type_YOrN] NULL,
	UnawareOfProblemOrItsConsequences [dbo].[type_YOrN] NULL,
	UnableToCommunicateWithClinician [dbo].[type_YOrN] NULL,

	----------------------------------------------------------------------

	TheChildOrAdolescentIsEmancipated [dbo].[type_YOrN] NULL,

	QuicklyAndActivelyAngages [dbo].[type_YOrN] NULL,
	SensitiveAndAwareOfTheChildsNeeds [dbo].[type_YOrN] NULL,
	SensitiveAndAwareOfTheChildsProblems [dbo].[type_YOrN] NULL,
	ActiveAndEnthusiasticInParticipating [dbo].[type_YOrN] NULL,

	DevelopsAPositiveTherapeuticRelationship [dbo].[type_YOrN] NULL,
	ExploresTheProblemAndAcceptsOthers [dbo].[type_YOrN] NULL,
	WorksCollaborativelyWithClinicians [dbo].[type_YOrN] NULL,
	CollaboratesWithTreatmentPlan [dbo].[type_YOrN] NULL,

	InconsistentAndOrAvoidantRelationship [dbo].[type_YOrN] NULL,
	DefinesProblemButHasDifficultyCreating [dbo].[type_YOrN] NULL,
	UnableToCollaborateInDevelopment [dbo].[type_YOrN] NULL,
	UnableToParticipateConsistently [dbo].[type_YOrN] NULL,

	ContentiousAndOrHostileRelationship [dbo].[type_YOrN] NULL,
	UnableToReachSharedDefinition [dbo].[type_YOrN] NULL,
	AbleToAcceptChildOrAdolescent [dbo].[type_YOrN] NULL,
	EngagesInBehaviorsThatAreInconsistent [dbo].[type_YOrN] NULL,

	NoAwarenessOfProblem [dbo].[type_YOrN] NULL,
	NotPhysicallyAvailable [dbo].[type_YOrN] NULL,
	RefusesToAcceptChildOrAdolescent [dbo].[type_YOrN] NULL,
	ActivelyAvoidantOfAndUnable  [dbo].[type_YOrN] NULL,

	[CALocusScore] [decimal](18, 2) NULL,
	[RiskOfHarmScore] [decimal](18, 2) NULL,
	[FunctionalStatusScore] [decimal](18, 2) NULL,
	[CoMorbidityScore] [decimal](18, 2) NULL,
	[RecoveryEnvironmentStressScore] [decimal](18, 2) NULL,
	[RecoveryEnvironmentSupportScore] [decimal](18, 2) NULL,
	[ResiliencyTreatmentHistoryScore] [decimal](18, 2) NULL,
	[TreatmentAcceptanceEngagementChildScore] [decimal](18, 2) NULL,
	[TreatmentAcceptanceEngagementParentScore] [decimal](18, 2) NULL,
	[EvaluationNotes] [dbo].[type_Comment2] NULL,
	[CurrentLevelOfCare] [varchar](250) NULL,
	[ActualDisposition] [dbo].[type_GlobalCode] NULL,
	[ReasonForVariance] [dbo].[type_GlobalCode] NULL,
	[ProgramReferredTo] [dbo].[type_GlobalCode] NULL,
 CONSTRAINT [DocumentCALOCUS_PK] PRIMARY KEY CLUSTERED 
(
	[DocumentVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

END

GO
