-----------------------------------------------
--Author : Kaushal Pandey
--Date   : 30/12/2018
--Purpose: Added validations.Ref : #21MHP - Enhancements 
------------------------------------------------
Declare @DocumentCodeId int
--set @DocumentCodeId =1638 
Select @DocumentCodeId = DocumentCodeId FROM DOCUMENTCODES WHERE Code ='FB823686-2E4B-4350-A8C0-8F4B47EC4712'

DELETE FROM  DocumentValidations WHERE DocumentCodeId=@DocumentCodeId AND TableName='DocumentCALOCUS'

INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',@DocumentCodeId,NULL,NULL,1,'DocumentCALOCUS','NoIndicationCurrentSuicidal','FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId  
AND ( EXISTS(select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
ISNULL(NoIndicationCurrentSuicidal,''N'') = ''N''  AND
ISNULL(NoIndicationOfAggression,''N'') = ''N''  AND
ISNULL(DevelopmentallyAppropriateAbility,''N'') =''N''  AND
ISNULL(LowRiskVictimization,''N'') =''N'' AND
ISNULL(PastHistoryFleetingSuicidal,''N'') =''N'' AND
ISNULL(MildSuicidalIdeation,''N'') =''N'' AND
ISNULL(IndicationOrReport,''N'') =''N'' AND
ISNULL(SubstanceUse,''N'') =''N'' AND
ISNULL(InfrequentBriefLapses,''N'') =''N'' AND
ISNULL(SomeRiskForVictimization,''N'') =''N'' AND
ISNULL(SignificantCurrentSuicidal,''N'') =''N'' AND
ISNULL(NoActiveSuicidal,''N'') =''N'' AND
ISNULL(IndicationOrReportOfIncidentsActing,''N'') =''N'' AND
ISNULL(BingeOrExcessiveUse,''N'') =''N'' AND
ISNULL(PeriodsOfInabilityToCare,''N'') =''N'' AND
ISNULL(SignificantRiskForVictimization,''N'') =''N'' AND
ISNULL(CurrentSuicidalOrHomicidalIdeation,''N'') =''N'' AND
ISNULL(IndicationOrReportOfSignificantImpulsivity,''N'') =''N'' AND
ISNULL(SignsOfConsistentDeficits,''N'') =''N'' AND
ISNULL(RecentPatternOfExcessiveSubstance,''N'') =''N'' AND
ISNULL(ClearAndPersistentInability,''N'') =''N'' AND
ISNULL(ImminentRiskOfSevereVictimization,''N'') =''N'' AND
ISNULL(CurrentSuicidalOrHomicidalBehavior,''N'') =''N'' AND
ISNULL(IndicationOrReportOfRepeatedBehavior,''N'') =''N'' AND
ISNULL(RelentlesslyEngagingInAcutely,''N'') =''N'' AND
ISNULL(APatternOfNearlyConstant,''N'') =''N''
)) OR 
EXISTS (select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
ISNULL(ConsistentFunctioningAppropriate,''N'') = ''N''  AND
ISNULL(NoMoreThanTemporaryImpairment,''N'') = ''N''  AND
ISNULL(SomeEvidenceOfMinorFailures,''N'') = ''N''  AND
ISNULL(OccasionalEpisodesInWhichSomeAspects,''N'') = ''N''  AND
ISNULL(DemonstratesSignificantImprovement,''N'') = ''N''  AND
ISNULL(ConflictedWithdrawnOrOtherwiseTroubled,''N'') = ''N''  AND
ISNULL(SelfCareHygieneDeterioratesBelowUsual,''N'') = ''N''  AND
ISNULL(SignificantDisturbancesInPhysicalFunction,''N'') = ''N''  AND
ISNULL(SchoolBehaviorHasDeterioratedToPoint,''N'') = ''N''  AND
ISNULL(ChronicAndOrVariablySevereDeficits,''N'') = ''N''  AND
ISNULL(RecentGainsAndOrStabilizationInFunctioning,''N'') = ''N''  AND
ISNULL(SeriousDeteriorationOfInterpersonal,''N'') = ''N''  AND
ISNULL(SignificantWithdrawalAndAvoidance,''N'') = ''N''  AND
ISNULL(ConsistentFailureToAchieveSelfCare,''N'') = ''N''  AND
ISNULL(SeriousDisturbancesInPhysical,''N'') = ''N''  AND
ISNULL(InabilityToPerformAdequately,''N'') =''N''  AND
ISNULL(ExtremeDeteriorationInInteractions,''N'') =''N''  AND
ISNULL(CompleteWithdrawalFromAllSocial,''N'') =''N''  AND
ISNULL(CompleteNeglectOfInability,''N'') =''N''  AND
ISNULL(ExtremeDisruptionInPhysicalFunction,''N'') =''N''  AND
ISNULL(AttendingSchoolSporadically,''N'') =''N''  
))
OR EXISTS(select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(NoEvidenceOfMedicalIllness,''N'') =''N''  AND
 ISNULL(PastMedicalSubstanceUse,''N'') =''N''  AND
 ISNULL(MinimalDevelopmentalDelayDisorder,''N'') =''N''  AND
 ISNULL(SelfLimitedMedicalConditions,''N'') =''N''  AND
 ISNULL(OccasionalSelfLimitedEpisodes,''N'') =''N''  AND
 ISNULL(TransientOccasionalStressRelated,''N'') =''N''  AND
 ISNULL(DevelopmentalDisabilityIsPresentThat,''N'') =''N''  AND
 ISNULL(MedicalConditionsArePresentRequiring,''N'') =''N''  AND
 ISNULL(MedicalConditionsArePresentAdversely,''N'') =''N''  AND
 ISNULL(SubstanceAbuseSignificantAdverseEffect,''N'') =''N''  AND
 ISNULL(RecentSubstanceUseThatHasSignificantImpact,''N'') =''N''  AND
 ISNULL(PsychiatricSignsAndSymptomsArePresent,''N'') =''N''  AND
 ISNULL(MedicalConditionsArePresentRequireMonitoring,''N'') =''N''  AND
 ISNULL(MedicalConditionsArePresentAffecting,''N'') =''N''  AND
 ISNULL(UncontrolledSubstanceUsePresentSeriousThreat,''N'') =''N''  AND
 ISNULL(DevelopmentalDelayOrDisorderSignificantlyAlters,''N'') =''N''  AND
 ISNULL(PsychiatricSymptomsPresentClearlyImpairFunctioning,''N'') =''N''  AND
 ISNULL(SignificantMedicalConditionIsPresent,''N'') =''N''  AND
 ISNULL(MedicalConditionAcutelyChronicallyWorsens,''N'') =''N''  AND
 ISNULL(SubstanceDependencePresentWithInability,''N'') =''N''  AND
 ISNULL(DevelopmentalDisorderPresentComplicates,''N'') =''N'' AND
 ISNULL(AcuteSeverePsychiatricSymptomsPresent,''N'') =''N'' 
))
OR EXISTS(select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(AbsenceOfSignificantOrEnduringDifficulties,''N'') =''N''  AND
 ISNULL(AbsenceOfRecentTransitionsOrLossesOfConsequence,''N'') =''N''  AND
 ISNULL(MaterialNeedsMetWithoutSignificantCause,''N'') =''N''  AND
 ISNULL(LivingEnvironmentConduciveNormativeGrowth,''N'') =''N''  AND
 ISNULL(RoleExpectationsAreConsistentWithChild,''N'') =''N''  AND
 ISNULL(SignificantTransitionRequiringAdjustment,''N'') =''N''  AND
 ISNULL(MinorInterpersonalLossOrConflict,''N'') =''N''  AND
 ISNULL(TransientButSignificantIllnessOrInjury,''N'') =''N''  AND
 ISNULL(SomewhatInadequateMaterialResourcesThreat,''N'') =''N''  AND
 ISNULL(ExpectationsForPerformanceAtHomeOrSchool,''N'') =''N''  AND
 ISNULL(PotentialForExposureToSubstanceUse,''N'') =''N''  AND
 ISNULL(DisruptionOfFamilySocialMilieu,''N'') =''N''  AND
 ISNULL(InterpersonalOrMaterialLossThatHasSignificant,''N'') =''N''  AND
 ISNULL(SeriousIllnessInjuryForProlongedPeriod,''N'') =''N''  AND
 ISNULL(DangerOrThreatInNeighborhoodOrCommunity,''N'') =''N''  AND
 ISNULL(ExposureToSubstanceAbuseAndItsEffects,''N'') =''N''  AND
 ISNULL(RoleExpectationsThatExceedChild,''N'') =''N''  AND
 ISNULL(SeriousDisruptionOfFamilySocialMilieu,''N'') =''N''  AND
 ISNULL(ThreatOfSevereDisruptionInLifeCircumstances,''N'') =''N''  AND
 ISNULL(InabilityToMeetNeedsForPhysical,''N'') =''N''  AND
 ISNULL(ExposureToEndangeringCriminalActivities,''N'') =''N''  AND
 ISNULL(DifficultyAvoidingExposureToSubstanceUse,''N'') =''N''  AND
 ISNULL(HighlyTraumaticEnduringAndDisturbingCircumstances,''N'') =''N''  AND
 ISNULL(PoliticalOrRacialPersecution,''N'') =''N''  AND
 ISNULL(YouthFacesIncarcerationFosterHomePlacement,''N'') =''N''  AND
 ISNULL(SeverePainInjuryOrDisability,''N'') =''N''  
))

OR EXISTS(select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(FamilyAndOrdinaryCommunityResources,''N'') =''N''  AND
 ISNULL(ContinuityOfActiveEngagedPrimary,''N'') =''N''  AND
 ISNULL(EffectiveInvolvementOfWraparound,''N'') =''N''  AND
 ISNULL(ContinuityOfFamilyOrPrimaryCaretakers,''N'') =''N''  AND
 ISNULL(FamilyPrimaryCaretakersAreWilling,''N'') =''N''  AND
 ISNULL(SpecialNeedsAreAddressedThroughSuccessful,''N'') =''N''  AND
 ISNULL(CommunityResourcesAreSufficient,''N'') =''N''  AND
 ISNULL(FamilyHasLimitedAbilityToRespond,''N'') =''N''  AND
 ISNULL(CommunityResourcesOnlyPartiallyCompensate,''N'') =''N''  AND
 ISNULL(FamilyOrPrimaryCaretakersDemonstrate,''N'') =''N''  AND
 ISNULL(FamilyOrPrimaryCaretakersSeriouslyLimited,''N'') =''N''  AND
 ISNULL(FewCommunitySupportsAndOrSerious,''N'') =''N''  AND
 ISNULL(FamilyAndOtherPrimaryCaretakers,''N'') =''N''  AND
 ISNULL(FamilyAndOrOtherPrimaryCaretakers,''N'') =''N''  AND
 ISNULL(CommunityHasDeteriorated,''N'') =''N''  AND
 ISNULL(LackOfLiaisonAndCooperation,''N'') =''N''  AND
 ISNULL(InabilityOfFamilyOrOtherPrimary,''N'') =''N''  AND
 ISNULL(LackOfEvenMinimalAttachment,''N'') =''N''
))
OR EXISTS (select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(ThereHasBeenNoPriorExperience,''N'') =''N''  AND
 ISNULL(ChildHasDemonstratedSignificant,''N'') =''N''  AND
 ISNULL(PriorExperienceIndicatesThatEfforts,''N'') =''N''  AND
 ISNULL(ThereHasBeenSuccessfulManagement,''N'') =''N''  AND
 ISNULL(AbleToTransitionSuccessfully,''N'') =''N''  AND
 ISNULL(ChildDemonstratedAverageAbility,''N'') =''N''  AND
 ISNULL(PreviousExperienceInTreatment,''N'') =''N''  AND
 ISNULL(SignificantAbilityToManageRecovery,''N'') =''N''  AND
 ISNULL(RecoveryHasBeenManagedForShort,''N'') =''N''  AND
 ISNULL(AbleToTransitionSuccessfullyAndAccept,''N'') =''N''  AND
 ISNULL(ChildHasDemonstratedAnInconsistent,''N'') =''N''  AND
 ISNULL(PreviousExperienceInTreatmentAtLowLevel,''N'') =''N''  AND 
 ISNULL(RecoveryHasBeenMaintainedForModerate,''N'') =''N''  AND
 ISNULL(HasDemonstratedLimitedAbility,''N'') =''N''  AND
 ISNULL(DevelopmentalPressuresAndLifeChangesDeterioration,''N'') =''N''  AND
 ISNULL(AbleToTransitionSuccessfullyAndAcceptChange,''N'') =''N''  AND
 ISNULL(ChildHasDemonstratedFrequentEvidence,''N'') =''N''  AND
 ISNULL(PreviousTreatmentHasNotAchievedComplete,''N'') =''N''  AND
 ISNULL(AttemptsToMaintainWhateverGains,''N'') =''N''  AND
 ISNULL(DevelopmentalPressuresAndLifeChangesDistress,''N'') =''N''  AND
 ISNULL(TransitionsWithChangesInRoutine,''N'') =''N''  AND
 ISNULL(ChildHasDemonstratedSignificantAndConsistent,''N'') =''N''  AND
 ISNULL(PastResponseToTreatmentHasBeenQuite,''N'') =''N''  AND
 ISNULL(SymptomsArePersistentAndFunctionalAbility,''N'') =''N''  AND
 ISNULL(DevelopmentalPressuresAndLifeChangesTurmoil,''N'') =''N''  AND 
 ISNULL(UnableToTransitionOrAcceptChanges,''N'') =''N'' 
))

OR EXISTS(select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(QuicklyFormsATrustingAndRespectfulPositive,''N'') =''N''  AND
 ISNULL(AbleToDefineProblemsAndUnderstands,''N'') =''N''  AND
 ISNULL(AcceptsAgeAppropriateResponsibilityForBehavior,''N'') =''N''  AND
 ISNULL(ActivelyParticipatesInTreatmentPlanning,''N'') =''N''  AND
 ISNULL(AbleToDevelopATrustingPositiveRelationship,''N'') =''N''  AND
 ISNULL(UnableToDefineTheProblemButCanUnderstand,''N'') =''N''  AND
 ISNULL(AcceptsLimitedAgeAppropriate,''N'') =''N''  AND
 ISNULL(PassivelyCooperatesInTreatmentPlanning,''N'') =''N''  AND
 ISNULL(AmbivalentAvoidantOrDistrustfulRelationship,''N'') =''N''  AND
 ISNULL(AcknowledgesExistenceOfProblemButResists,''N'') =''N''  AND
 ISNULL(MinimizesOrRationalizesDistressingBehaviors,''N'') =''N''  AND
 ISNULL(UnableToAcceptOthersDefinition,''N'') =''N''  AND
 ISNULL(FrequentlyMissesOrLateForTreatment,''N'') =''N''  AND
 ISNULL(ActivelyHostileRelationshipWithClinicians,''N'') =''N''  AND
 ISNULL(AcceptsNoAgeAppropriateResponsibilityRole,''N'') =''N''  AND
 ISNULL(ActivelyFrequentlyDisruptsOrStonewalls,''N'') =''N''  AND
 ISNULL(UnableToFormTherapeutic,''N'') =''N''  AND
 ISNULL(UnawareOfProblemOrItsConsequences,''N'') =''N''  AND
 ISNULL(UnableToCommunicateWithClinician,''N'') =''N''
))

OR EXISTS (select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
 ISNULL(QuicklyAndActivelyAngages,''N'') =''N''  AND
 ISNULL(SensitiveAndAwareOfTheChildsNeeds,''N'') =''N''  AND
 ISNULL(SensitiveAndAwareOfTheChildsProblems,''N'') =''N''  AND
 ISNULL(ActiveAndEnthusiasticInParticipating,''N'') =''N''  AND
 ISNULL(DevelopsAPositiveTherapeuticRelationship,''N'') =''N''  AND
 ISNULL(ExploresTheProblemAndAcceptsOthers,''N'') =''N''  AND
 ISNULL(WorksCollaborativelyWithClinicians,''N'') =''N''  AND
 ISNULL(CollaboratesWithTreatmentPlan,''N'') =''N''  AND
 ISNULL(InconsistentAndOrAvoidantRelationship,''N'') =''N''  AND
 ISNULL(DefinesProblemButHasDifficultyCreating,''N'') =''N''  AND
 ISNULL(UnableToCollaborateInDevelopment,''N'') =''N''  AND
 ISNULL(UnableToParticipateConsistently,''N'') =''N''  AND
 ISNULL(ContentiousAndOrHostileRelationship,''N'') =''N''  AND
 ISNULL(UnableToReachSharedDefinition,''N'') =''N''  AND
 ISNULL(AbleToAcceptChildOrAdolescent,''N'') =''N''  AND
 ISNULL(EngagesInBehaviorsThatAreInconsistent,''N'') =''N''  AND
 ISNULL(NoAwarenessOfProblem,''N'') =''N''  AND
 ISNULL(NotPhysicallyAvailable,''N'') =''N''  AND
 ISNULL(RefusesToAcceptChildOrAdolescent,''N'') =''N''  AND
 ISNULL(ActivelyAvoidantOfAndUnable,''N'') =''N''  
 )))','At least one response needs to be selected per tab before calculating the summary.',1,'At least one response needs to be selected per tab before calculating the summary.',NULL)


INSERT INTO [documentvalidations] ([Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[SectionName])VALUES
('Y',@DocumentCodeId,NULL,NULL,1,'DocumentCALOCUS','CurrentSuicidalOrHomicidalBehavior','FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId  
AND  EXISTS(select 1 FROM DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId and (
	ISNULL(CurrentSuicidalOrHomicidalBehavior,''N'') =''Y'' AND 
	ISNULL(WithoutExpressedAmbivalence,''N'') =''N'' AND
	ISNULL(WithAHistoryOfSeriousPast,''N'') =''N'' AND
	ISNULL(InPresenceOfCommandHalucination,''N'') =''N'' 
  )) ',
'Risk of Harm - Extreme Risk of Harm - At least one sub-checkbox must be selected.',2,
'Risk of Harm - Extreme Risk of Harm - At least one sub-checkbox must be selected.',NULL)
