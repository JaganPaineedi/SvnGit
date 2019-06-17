/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentCALOCUS]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDocumentCALOCUS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDocumentCALOCUS]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDocumentCALOCUS]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                   
**  File: ssp_SCGetDocumentCALOCUS 1306292 1306288                                            
**  Name: ssp_SCGetDocumentCALOCUS                        
**  Desc: GetData for CALOCUS Document
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Kaushal Pandey                              
**  Date:  Nov 26 2018
/* What :  created CALOCUS Document				*/
/* whay : Task #21 MHP - Enhancements - CALOCUS                              */                                          
****/

CREATE PROCEDURE  [dbo].[ssp_SCGetDocumentCALOCUS]                                                                   
(                                                                                                                                                           
  @DocumentVersionId int                                                                           
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   
   EXEC ssp_CalculateCALOCUSDimensionScore @DocumentVersionId   --required                                                       
                                                                                                       
		SELECT 
			DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,NoIndicationCurrentSuicidal
			,NoIndicationOfAggression
			,DevelopmentallyAppropriateAbility
			,LowRiskVictimization
			,PastHistoryFleetingSuicidal
			,MildSuicidalIdeation
			,IndicationOrReport
			,SubstanceUse
			,InfrequentBriefLapses
			,SomeRiskForVictimization
			,SignificantCurrentSuicidal
			,NoActiveSuicidal
			,IndicationOrReportOfIncidentsActing
			,BingeOrExcessiveUse
			,PeriodsOfInabilityToCare
			,SignificantRiskForVictimization
			,CurrentSuicidalOrHomicidalIdeation
			,IndicationOrReportOfSignificantImpulsivity
			,SignsOfConsistentDeficits
			,RecentPatternOfExcessiveSubstance
			,ClearAndPersistentInability
			,ImminentRiskOfSevereVictimization
			,CurrentSuicidalOrHomicidalBehavior
			,WithoutExpressedAmbivalence
			,WithAHistoryOfSeriousPast
			,InPresenceOfCommandHalucination
			,IndicationOrReportOfRepeatedBehavior
			,RelentlesslyEngagingInAcutely
			,APatternOfNearlyConstant
			,ConsistentFunctioningAppropriate
			,NoMoreThanTemporaryImpairment
			,SomeEvidenceOfMinorFailures
			,OccasionalEpisodesInWhichSomeAspects
			,DemonstratesSignificantImprovement
			,ConflictedWithdrawnOrOtherwiseTroubled
			,SelfCareHygieneDeterioratesBelowUsual
			,SignificantDisturbancesInPhysicalFunction
			,SchoolBehaviorHasDeterioratedToPoint
			,ChronicAndOrVariablySevereDeficits
			,RecentGainsAndOrStabilizationInFunctioning
			,SeriousDeteriorationOfInterpersonal
			,SignificantWithdrawalAndAvoidance
			,ConsistentFailureToAchieveSelfCare
			,SeriousDisturbancesInPhysical
			,InabilityToPerformAdequately
			,ExtremeDeteriorationInInteractions
			,CompleteWithdrawalFromAllSocial
			,CompleteNeglectOfInability
			,ExtremeDisruptionInPhysicalFunction
			,AttendingSchoolSporadically
			,NoEvidenceOfMedicalIllness
			,PastMedicalSubstanceUse
			,MinimalDevelopmentalDelayDisorder
			,SelfLimitedMedicalConditions
			,OccasionalSelfLimitedEpisodes
			,TransientOccasionalStressRelated
			,DevelopmentalDisabilityIsPresentThat
			,MedicalConditionsArePresentRequiring
			,MedicalConditionsArePresentAdversely
			,SubstanceAbuseSignificantAdverseEffect
			,RecentSubstanceUseThatHasSignificantImpact
			,PsychiatricSignsAndSymptomsArePresent
			,MedicalConditionsArePresentRequireMonitoring
			,MedicalConditionsArePresentAffecting
			,UncontrolledSubstanceUsePresentSeriousThreat
			,DevelopmentalDelayOrDisorderSignificantlyAlters
			,PsychiatricSymptomsPresentClearlyImpairFunctioning
			,SignificantMedicalConditionIsPresent
			,MedicalConditionAcutelyChronicallyWorsens
			,SubstanceDependencePresentWithInability
			,DevelopmentalDisorderPresentComplicates
			,AcuteSeverePsychiatricSymptomsPresent
			,AbsenceOfSignificantOrEnduringDifficulties
			,AbsenceOfRecentTransitionsOrLossesOfConsequence
			,MaterialNeedsMetWithoutSignificantCause
			,LivingEnvironmentConduciveNormativeGrowth
			,RoleExpectationsAreConsistentWithChild
			,SignificantTransitionRequiringAdjustment
			,MinorInterpersonalLossOrConflict
			,TransientButSignificantIllnessOrInjury
			,SomewhatInadequateMaterialResourcesThreat
			,ExpectationsForPerformanceAtHomeOrSchool
			,PotentialForExposureToSubstanceUse
			,DisruptionOfFamilySocialMilieu
			,InterpersonalOrMaterialLossThatHasSignificant
			,SeriousIllnessInjuryForProlongedPeriod
			,DangerOrThreatInNeighborhoodOrCommunity
			,ExposureToSubstanceAbuseAndItsEffects
			,RoleExpectationsThatExceedChild
			,SeriousDisruptionOfFamilySocialMilieu
			,ThreatOfSevereDisruptionInLifeCircumstances
			,InabilityToMeetNeedsForPhysical
			,ExposureToEndangeringCriminalActivities
			,DifficultyAvoidingExposureToSubstanceUse
			,HighlyTraumaticEnduringAndDisturbingCircumstances
			,PoliticalOrRacialPersecution
			,YouthFacesIncarcerationFosterHomePlacement
			,SeverePainInjuryOrDisability
			,FamilyAndOrdinaryCommunityResources
			,ContinuityOfActiveEngagedPrimary
			,EffectiveInvolvementOfWraparound
			,ContinuityOfFamilyOrPrimaryCaretakers
			,FamilyPrimaryCaretakersAreWilling
			,SpecialNeedsAreAddressedThroughSuccessful
			,CommunityResourcesAreSufficient
			,FamilyHasLimitedAbilityToRespond
			,CommunityResourcesOnlyPartiallyCompensate
			,FamilyOrPrimaryCaretakersDemonstrate
			,FamilyOrPrimaryCaretakersSeriouslyLimited
			,FewCommunitySupportsAndOrSerious
			,FamilyAndOtherPrimaryCaretakers
			,FamilyAndOrOtherPrimaryCaretakers
			,CommunityHasDeteriorated
			,LackOfLiaisonAndCooperation
			,InabilityOfFamilyOrOtherPrimary
			,LackOfEvenMinimalAttachment
			,ThereHasBeenNoPriorExperience
			,ChildHasDemonstratedSignificant
			,PriorExperienceIndicatesThatEfforts
			,ThereHasBeenSuccessfulManagement
			,AbleToTransitionSuccessfully
			,ChildDemonstratedAverageAbility
			,PreviousExperienceInTreatment
			,SignificantAbilityToManageRecovery
			,RecoveryHasBeenManagedForShort
			,AbleToTransitionSuccessfullyAndAccept
			,ChildHasDemonstratedAnInconsistent
			,PreviousExperienceInTreatmentAtLowLevel
			,RecoveryHasBeenMaintainedForModerate
			,HasDemonstratedLimitedAbility
			,DevelopmentalPressuresAndLifeChangesDeterioration
			,AbleToTransitionSuccessfullyAndAcceptChange
			,ChildHasDemonstratedFrequentEvidence
			,PreviousTreatmentHasNotAchievedComplete
			,AttemptsToMaintainWhateverGains
			,DevelopmentalPressuresAndLifeChangesDistress
			,TransitionsWithChangesInRoutine
			,ChildHasDemonstratedSignificantAndConsistent
			,PastResponseToTreatmentHasBeenQuite
			,SymptomsArePersistentAndFunctionalAbility
			,DevelopmentalPressuresAndLifeChangesTurmoil
			,UnableToTransitionOrAcceptChanges
			,QuicklyFormsATrustingAndRespectfulPositive
			,AbleToDefineProblemsAndUnderstands
			,AcceptsAgeAppropriateResponsibilityForBehavior
			,ActivelyParticipatesInTreatmentPlanning
			,AbleToDevelopATrustingPositiveRelationship
			,UnableToDefineTheProblemButCanUnderstand
			,AcceptsLimitedAgeAppropriate
			,PassivelyCooperatesInTreatmentPlanning
			,AmbivalentAvoidantOrDistrustfulRelationship
			,AcknowledgesExistenceOfProblemButResists
			,MinimizesOrRationalizesDistressingBehaviors
			,UnableToAcceptOthersDefinition
			,FrequentlyMissesOrLateForTreatment
			,ActivelyHostileRelationshipWithClinicians
			,AcceptsNoAgeAppropriateResponsibilityRole
			,ActivelyFrequentlyDisruptsOrStonewalls
			,UnableToFormTherapeutic
			,UnawareOfProblemOrItsConsequences
			,UnableToCommunicateWithClinician
			,TheChildOrAdolescentIsEmancipated
			,QuicklyAndActivelyAngages
			,SensitiveAndAwareOfTheChildsNeeds
			,SensitiveAndAwareOfTheChildsProblems
			,ActiveAndEnthusiasticInParticipating
			,DevelopsAPositiveTherapeuticRelationship
			,ExploresTheProblemAndAcceptsOthers
			,WorksCollaborativelyWithClinicians
			,CollaboratesWithTreatmentPlan
			,InconsistentAndOrAvoidantRelationship
			,DefinesProblemButHasDifficultyCreating
			,UnableToCollaborateInDevelopment
			,UnableToParticipateConsistently
			,ContentiousAndOrHostileRelationship
			,UnableToReachSharedDefinition
			,AbleToAcceptChildOrAdolescent
			,EngagesInBehaviorsThatAreInconsistent
			,NoAwarenessOfProblem
			,NotPhysicallyAvailable
			,RefusesToAcceptChildOrAdolescent
			,ActivelyAvoidantOfAndUnable
			,CAST(CALOCUSScore AS INTEGER) as CALOCUSScore
			,(SELECT CodeName from dbo.GlobalCodes WHERE Category='CALOCUSLEVEL' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND ExternalCode1= CALOCUSScore) AS CALOCUSScoreText
			,CAST(RiskOfHarmScore AS INTEGER) as RiskOfHarmScore
			,CAST(FunctionalStatusScore AS INTEGER) as FunctionalStatusScore
			,CAST(CoMorbidityScore AS INTEGER) as CoMorbidityScore
			--,CAST(MedicalAddictiveScore AS INTEGER) as MedicalAddictiveScore--
			,CAST(RecoveryEnvironmentStressScore AS INTEGER) as RecoveryEnvironmentStressScore
			,CAST(RecoveryEnvironmentSupportScore AS INTEGER) as RecoveryEnvironmentSupportScore
			,CAST(ResiliencyTreatmentHistoryScore AS INTEGER) as ResiliencyTreatmentHistoryScore
			,CAST(TreatmentAcceptanceEngagementChildScore AS INTEGER) as TreatmentAcceptanceEngagementChildScore
			,CAST(TreatmentAcceptanceEngagementParentScore AS INTEGER) as TreatmentAcceptanceEngagementParentScore
			,EvaluationNotes
			,CurrentLevelOfCare
			,CASE 
				When CAST(CALOCUSScore AS INTEGER)=0 Then 'Basic Services for Prevention and Maintenance'
				When CAST(CALOCUSScore AS INTEGER)=1 Then 'Level One – Recovery Maintenance and Health Management'
				When CAST(CALOCUSScore AS INTEGER) =2 Then 'Level Two – Low Intensity Community Based Services'
				When CAST(CALOCUSScore AS INTEGER) =3 Then 'Level Three – High Intensity Community Based Services'
				When CAST(CALOCUSScore AS INTEGER) =4 Then 'Level Four – Medically Monitored Non-Residential Services'
				When CAST(CALOCUSScore AS INTEGER) =5 Then 'Level Five – Medically Monitored Residential Services'
				When CAST(CALOCUSScore AS INTEGER) =6 Then 'Level Six – Medically Managed Residential Services'
				Else ''
			End	As	RecommendedDisposition--
			,ActualDisposition
			,ReasonForVariance
			,ProgramReferredTo
		FROM DocumentCALOCUS
		WHERE (ISNULL(RecordDeleted, 'N') = 'N')
			AND (DocumentVersionId = @DocumentVersionId) 
    
	
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetDocumentCALOCUS]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO




-----------------		
		
		--DocumentVersionId
		--	,CreatedBy
		--	,CreatedDate
		--	,ModifiedBy
		--	,ModifiedDate
		--	,RecordDeleted
		--	,DeletedBy
		--	,DeletedDate
		--	,MinimalRiskOfHarmNoIndication
		--	,MinimalRiskOfHarmClearAbility
		--	,LowRiskOfHarmNoCurrentSuicidal
		--	,LowRiskOfHarmOccasionalSubstance
		--	,LowRiskOfHarmPeriodsInPast
		--	,ModerateRiskOfHarmSignificant
		--	,ModerateRiskOfHarmNoActiveSuicidal
		--	,ModerateRiskOfHarmHistoryOfChronic
		--	,ModerateRiskOfHarmBinge
		--	,ModerateRiskOfHarmSomeEvidence
		--	,SeriousRiskOfHarmCurrentSuicidal
		--	,SeriousRiskOfHarmHistoryOfChronic
		--	,SeriousRiskOfHarmRecentPattern
		--	,SeriousRiskOfHarmClearCompromise
		--	,ExtremeRiskOfHarmCurrentSuicidal
		--	,ExtremeRiskOfHarmWithoutExpressed
		--	,ExtremeRiskOfHarmWithHistory
		--	,ExtremeRiskOfHarmPresenceOfCommand
		--	,ExtremeRiskOfHarmRepeatedEpisodes
		--	,ExtremeRiskOfHarmExtremeCompromise
		--	,MinimalImpairmentNoMore
		--	,MildImpairmentExperiencing
		--	,MildImpairmentRecentExperience
		--	,MildImpairmentDevelopingMinor
		--	,MildImpairmentDemonstrating
		--	,ModerateImpairmentRecentConflict
		--	,ModerateImpairmentAppearance
		--	,ModerateImpairmentSignificantDisturbances
		--	,ModerateImpairmentSignificantDeterioration
		--	,ModerateImpairmentOngoing
		--	,ModerateImpairmentRecentGains
		--	,SeriousImpairmentSeriousDecrease
		--	,SeriousImpairmentSignificantWithdrawal
		--	,SeriousImpairmentConsistentFailure
		--	,SeriousImpairmentSeriousDisturbances
		--	,SeriousImpairmentInability
		--	,SevereImpairmentExtremeDeterioration
		--	,SevereImpairmentDevelopmentComplete
		--	,SevereImpairmentCompleteNeglect
		--	,SevereImpairmentExtremeDistruptions
		--	,SevereImpairmentCompleteInability
		--	,NoComorbidityNoEvidence
		--	,NoComorbidityAnyIllnesses
		--	,MinorComorbidityExistence
		--	,MinorComorbidityOccasional
		--	,MinorComorbidityMayOccasionally
		--	,SignificantComorbidityPotential
		--	,SignificantComorbidityCreated
		--	,SignificantComorbidityAdversely
		--	,SignificantComorbidityOngoing
		--	,SignificantComorbidityRecentSubstance
		--	,SignificantComorbiditySignificant
		--	,MajorComorbidityHighLikelihood
		--	,MajorComorbidityExistence
		--	,MajorComorbidityOutcome
		--	,MajorComorbidityUncontrolled
		--	,MajorComorbidityPsychiatric
		--	,SevereComorbiditySignificant
		--	,SevereComorbidityPresence
		--	,SevereComorbidityUncontrolled
		--	,SevereComorbiditySerereSubstance
		--	,SevereComorbidityAcute
		--	,LowStressEssentially
		--	,LowStressNoRecent
		--	,LowStressNoMajor
		--	,LowStressMaterial
		--	,LowStressLiving
		--	,LowStressNoPressure
		--	,MildlyStressPresence
		--	,MildlyStressTransition
		--	,MildlyStressCircumstances
		--	,MildlyStressRecentOnset
		--	,MildlyStressPotential
		--	,MildlyStressPerformance
		--	,ModeratelyStressSignificantDiscord
		--	,ModeratelyStressSignificantTransition
		--	,ModeratelyStressRecentImportant
		--	,ModeratelyStressConcern
		--	,ModeratelyStressDanger
		--	,ModeratelyStressEasyExposure
		--	,ModeratelyStressPerception
		--	,HighlyStressSerious
		--	,HighlyStressSevere
		--	,HighlyStressInability
		--	,HighlyStressRecentOnset
		--	,HighlyStressDifficulty
		--	,HighlyStressEpisodes
		--	,HighlyStressOverwhelming
		--	,ExtremelyStressAcutely
		--	,ExtremelyStressOngoing
		--	,ExtremelyStressWitnessing
		--	,ExtremelyStressPersecution
		--	,ExtremelyStressSudden
		--	,ExtremelyStressUnavoidable
		--	,ExtremelyStressIncarceration
		--	,ExtremelyStressSevere
		--	,ExtremelyStressSustained
		--	,ExtremelyStressChaotic
		--	,HighlySupportivePlentiful
		--	,HighlySupportiveEffective
		--	,SupportiveResources
		--	,SupportiveSomeElements
		--	,SupportiveProfessional
		--	,LimitedSupportFew
		--	,LimitedSupportUsual
		--	,LimitedSupportPersons
		--	,LimitedSupportResources
		--	,LimitedSupportLimited
		--	,MinimalSupportVeryFew
		--	,MinimalSupportUsual
		--	,MinimalSupportExisting
		--	,MinimalSupportClient
		--	,NoSupportSources
		--	,FullyResponsiveNoPriorExperience
		--	,FullyResponsivePriorExperience
		--	,FullyResponsiveSuccessful
		--	,SignificantResponsePrevious
		--	,SignificantResponseRecovery
		--	,ModerateResponseCurrentTreatment
		--	,ModerateResponsePreviousTreatment
		--	,ModerateResponseUnclear
		--	,ModerateResponseLeastPartial
		--	,PoorResponsePrevious
		--	,PoorResponseAttempts
		--	,NegligibleResponsePast
		--	,NegligibleResponseSymptoms
		--	,OptimalEngagementComplete
		--	,OptimalEngagementActively
		--	,OptimalEngagementEnthusiastic
		--	,OptimalEngagementUnderstands
		--	,PositiveEngagementSignificant
		--	,PositiveEngagementWilling
		--	,PositiveEngagementPositive
		--	,PositiveEngagementShows
		--	,LimitedEngagementSomeVariability
		--	,LimitedEngagementLimitedDesire
		--	,LimitedEngagementRelatesToTreatment
		--	,LimitedEngagementNotUseResources
		--	,LimitedEngagementLimitedAbility
		--	,MinimalEngagementRarely
		--	,MinimalEngagementNoDesire
		--	,MinimalEngagementRelatesPoorly
		--	,MinimalEngagementAvoidsContact
		--	,MinimalEngagementNotAccept
		--	,UnengagedNoAwareness
		--	,UnengagedInability
		--	,UnengagedUnable
		--	,UnengagedExtremely
-------------