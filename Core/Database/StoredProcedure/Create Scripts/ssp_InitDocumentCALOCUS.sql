/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentCALOCUS]    Script Date: 01/29/2015 17:40:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentCALOCUS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitDocumentCALOCUS]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentCALOCUS]    Script Date: 01/29/2015 17:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitDocumentCALOCUS] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/******************************************************************************                                                
**  File: ssp_InitDocumentCALOCUS 1001060, 550, null                                           
**  Name: ssp_InitDocumentCALOCUS                        
**  Desc: To Initialize Locus Document                                                             
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  March 10 2016
/* What : created Locus Document		*/
/* whay : Task #41 Network 180 - Customizations                              */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:			Author:			Description:                                    
	03 Nov 2016		Alok Kumar		Added three new fields to the DocumentLOCUS table for task#340 CEI - Support Go Live.
	26-11-2018		Kaushal Pandey	created new copy of LOCUS TO CALOCUS for task#21 	MHP - Enhancements - CALOCUS
	
*******************************************************************************/ 
BEGIN
	BEGIN TRY
	
		
		
-------------------------------------------------------------------------
-- To get the latest DocumentVersionId 
--------------------------------------------------------------------------
 
  DECLARE @LatestDocumentVersionID int  
  DECLARE @ActualDisposition int
  DECLARE @CurrentLevelOfCare varchar(500)

	SET @LatestDocumentVersionID = (  
	SELECT TOP 1 CurrentDocumentVersionId  
	FROM DocumentCALOCUS DL  
	INNER JOIN Documents Doc ON DL.DocumentVersionId = Doc.CurrentDocumentVersionId  
	WHERE Doc.ClientId = @ClientID AND Doc.[Status] = 22  
	AND ISNULL(DL.RecordDeleted, 'N') = 'N'  
	AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
	ORDER BY Doc.EffectiveDate DESC  
	,Doc.ModifiedDate DESC  
) 

	SELECT @ActualDisposition = ActualDisposition
		   FROM DocumentCALOCUS  WHERE (ISNULL(RecordDeleted, 'N') = 'N') 
		   AND DocumentVersionId = @LatestDocumentVersionID	
	
	IF(@ActualDisposition >0)
		BEGIN
			Select @CurrentLevelOfCare= CodeName 
				from GlobalCodes where GlobalCodeId=@ActualDisposition AND ISNULL(RecordDeleted, 'N') = 'N'
		END
	ELSE 
		BEGIN
			SET @CurrentLevelOfCare='None'
		END
		
	
		
		SELECT 'DocumentCALOCUS' AS TableName
			,-1 AS DocumentVersionId 
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,CBTA.RecordDeleted
			,CBTA.DeletedDate
			,CBTA.DeletedBy
			,@CurrentLevelOfCare As CurrentLevelOfCare
			,CBTA.NoIndicationCurrentSuicidal
			,CBTA.NoIndicationOfAggression
			,CBTA.DevelopmentallyAppropriateAbility
			,CBTA.LowRiskVictimization
			,CBTA.PastHistoryFleetingSuicidal
			,CBTA.MildSuicidalIdeation
			,CBTA.IndicationOrReport
			,CBTA.SubstanceUse
			,CBTA.InfrequentBriefLapses
			,CBTA.SomeRiskForVictimization
			,CBTA.SignificantCurrentSuicidal
			,CBTA.NoActiveSuicidal
			,CBTA.IndicationOrReportOfIncidentsActing
			,CBTA.BingeOrExcessiveUse
			,CBTA.PeriodsOfInabilityToCare
			,CBTA.SignificantRiskForVictimization
			,CBTA.CurrentSuicidalOrHomicidalIdeation
			,CBTA.IndicationOrReportOfSignificantImpulsivity
			,CBTA.SignsOfConsistentDeficits
			,CBTA.RecentPatternOfExcessiveSubstance
			,CBTA.ClearAndPersistentInability
			,CBTA.ImminentRiskOfSevereVictimization
			,CBTA.CurrentSuicidalOrHomicidalBehavior
			,CBTA.WithoutExpressedAmbivalence
			,CBTA.WithAHistoryOfSeriousPast
			,CBTA.InPresenceOfCommandHalucination
			,CBTA.IndicationOrReportOfRepeatedBehavior
			,CBTA.RelentlesslyEngagingInAcutely
			,CBTA.APatternOfNearlyConstant
			,CBTA.ConsistentFunctioningAppropriate
			,CBTA.NoMoreThanTemporaryImpairment
			,CBTA.SomeEvidenceOfMinorFailures
			,CBTA.OccasionalEpisodesInWhichSomeAspects
			,CBTA.DemonstratesSignificantImprovement
			,CBTA.ConflictedWithdrawnOrOtherwiseTroubled
			,CBTA.SelfCareHygieneDeterioratesBelowUsual
			,CBTA.SignificantDisturbancesInPhysicalFunction
			,CBTA.SchoolBehaviorHasDeterioratedToPoint
			,CBTA.ChronicAndOrVariablySevereDeficits
			,CBTA.RecentGainsAndOrStabilizationInFunctioning
			,CBTA.SeriousDeteriorationOfInterpersonal
			,CBTA.SignificantWithdrawalAndAvoidance
			,CBTA.ConsistentFailureToAchieveSelfCare
			,CBTA.SeriousDisturbancesInPhysical
			,CBTA.InabilityToPerformAdequately
			,CBTA.ExtremeDeteriorationInInteractions
			,CBTA.CompleteWithdrawalFromAllSocial
			,CBTA.CompleteNeglectOfInability
			,CBTA.ExtremeDisruptionInPhysicalFunction
			,CBTA.AttendingSchoolSporadically
			,CBTA.NoEvidenceOfMedicalIllness
			,CBTA.PastMedicalSubstanceUse
			,CBTA.MinimalDevelopmentalDelayDisorder
			,CBTA.SelfLimitedMedicalConditions
			,CBTA.OccasionalSelfLimitedEpisodes
			,CBTA.TransientOccasionalStressRelated
			,CBTA.DevelopmentalDisabilityIsPresentThat
			,CBTA.MedicalConditionsArePresentRequiring
			,CBTA.MedicalConditionsArePresentAdversely
			,CBTA.SubstanceAbuseSignificantAdverseEffect
			,CBTA.RecentSubstanceUseThatHasSignificantImpact
			,CBTA.PsychiatricSignsAndSymptomsArePresent
			,CBTA.MedicalConditionsArePresentRequireMonitoring
			,CBTA.MedicalConditionsArePresentAffecting
			,CBTA.UncontrolledSubstanceUsePresentSeriousThreat
			,CBTA.DevelopmentalDelayOrDisorderSignificantlyAlters
			,CBTA.PsychiatricSymptomsPresentClearlyImpairFunctioning
			,CBTA.SignificantMedicalConditionIsPresent
			,CBTA.MedicalConditionAcutelyChronicallyWorsens
			,CBTA.SubstanceDependencePresentWithInability
			,CBTA.DevelopmentalDisorderPresentComplicates
			,CBTA.AcuteSeverePsychiatricSymptomsPresent
			,CBTA.AbsenceOfSignificantOrEnduringDifficulties
			,CBTA.AbsenceOfRecentTransitionsOrLossesOfConsequence
			,CBTA.MaterialNeedsMetWithoutSignificantCause
			,CBTA.LivingEnvironmentConduciveNormativeGrowth
			,CBTA.RoleExpectationsAreConsistentWithChild
			,CBTA.SignificantTransitionRequiringAdjustment
			,CBTA.MinorInterpersonalLossOrConflict
			,CBTA.TransientButSignificantIllnessOrInjury
			,CBTA.SomewhatInadequateMaterialResourcesThreat
			,CBTA.ExpectationsForPerformanceAtHomeOrSchool
			,CBTA.PotentialForExposureToSubstanceUse
			,CBTA.DisruptionOfFamilySocialMilieu
			,CBTA.InterpersonalOrMaterialLossThatHasSignificant
			,CBTA.SeriousIllnessInjuryForProlongedPeriod
			,CBTA.DangerOrThreatInNeighborhoodOrCommunity
			,CBTA.ExposureToSubstanceAbuseAndItsEffects
			,CBTA.RoleExpectationsThatExceedChild
			,CBTA.SeriousDisruptionOfFamilySocialMilieu
			,CBTA.ThreatOfSevereDisruptionInLifeCircumstances
			,CBTA.InabilityToMeetNeedsForPhysical
			,CBTA.ExposureToEndangeringCriminalActivities
			,CBTA.DifficultyAvoidingExposureToSubstanceUse
			,CBTA.HighlyTraumaticEnduringAndDisturbingCircumstances
			,CBTA.PoliticalOrRacialPersecution
			,CBTA.YouthFacesIncarcerationFosterHomePlacement
			,CBTA.SeverePainInjuryOrDisability
			,CBTA.FamilyAndOrdinaryCommunityResources
			,CBTA.ContinuityOfActiveEngagedPrimary
			,CBTA.EffectiveInvolvementOfWraparound
			,CBTA.ContinuityOfFamilyOrPrimaryCaretakers
			,CBTA.FamilyPrimaryCaretakersAreWilling
			,CBTA.SpecialNeedsAreAddressedThroughSuccessful
			,CBTA.CommunityResourcesAreSufficient
			,CBTA.FamilyHasLimitedAbilityToRespond
			,CBTA.CommunityResourcesOnlyPartiallyCompensate
			,CBTA.FamilyOrPrimaryCaretakersDemonstrate
			,CBTA.FamilyOrPrimaryCaretakersSeriouslyLimited
			,CBTA.FewCommunitySupportsAndOrSerious
			,CBTA.FamilyAndOtherPrimaryCaretakers
			,CBTA.FamilyAndOrOtherPrimaryCaretakers
			,CBTA.CommunityHasDeteriorated
			,CBTA.LackOfLiaisonAndCooperation
			,CBTA.InabilityOfFamilyOrOtherPrimary
			,CBTA.LackOfEvenMinimalAttachment
			,CBTA.ThereHasBeenNoPriorExperience
			,CBTA.ChildHasDemonstratedSignificant
			,CBTA.PriorExperienceIndicatesThatEfforts
			,CBTA.ThereHasBeenSuccessfulManagement
			,CBTA.AbleToTransitionSuccessfully
			,CBTA.ChildDemonstratedAverageAbility
			,CBTA.PreviousExperienceInTreatment
			,CBTA.SignificantAbilityToManageRecovery
			,CBTA.RecoveryHasBeenManagedForShort
			,CBTA.AbleToTransitionSuccessfullyAndAccept
			,CBTA.ChildHasDemonstratedAnInconsistent
			,CBTA.PreviousExperienceInTreatmentAtLowLevel
			,CBTA.RecoveryHasBeenMaintainedForModerate
			,CBTA.HasDemonstratedLimitedAbility
			,CBTA.DevelopmentalPressuresAndLifeChangesDeterioration
			,CBTA.AbleToTransitionSuccessfullyAndAcceptChange
			,CBTA.ChildHasDemonstratedFrequentEvidence
			,CBTA.PreviousTreatmentHasNotAchievedComplete
			,CBTA.AttemptsToMaintainWhateverGains
			,CBTA.DevelopmentalPressuresAndLifeChangesDistress
			,CBTA.TransitionsWithChangesInRoutine
			,CBTA.ChildHasDemonstratedSignificantAndConsistent
			,CBTA.PastResponseToTreatmentHasBeenQuite
			,CBTA.SymptomsArePersistentAndFunctionalAbility
			,CBTA.DevelopmentalPressuresAndLifeChangesTurmoil
			,CBTA.UnableToTransitionOrAcceptChanges
			,CBTA.QuicklyFormsATrustingAndRespectfulPositive
			,CBTA.AbleToDefineProblemsAndUnderstands
			,CBTA.AcceptsAgeAppropriateResponsibilityForBehavior
			,CBTA.ActivelyParticipatesInTreatmentPlanning
			,CBTA.AbleToDevelopATrustingPositiveRelationship
			,CBTA.UnableToDefineTheProblemButCanUnderstand
			,CBTA.AcceptsLimitedAgeAppropriate
			,CBTA.PassivelyCooperatesInTreatmentPlanning
			,CBTA.AmbivalentAvoidantOrDistrustfulRelationship
			,CBTA.AcknowledgesExistenceOfProblemButResists
			,CBTA.MinimizesOrRationalizesDistressingBehaviors
			,CBTA.UnableToAcceptOthersDefinition
			,CBTA.FrequentlyMissesOrLateForTreatment
			,CBTA.ActivelyHostileRelationshipWithClinicians
			,CBTA.AcceptsNoAgeAppropriateResponsibilityRole
			,CBTA.ActivelyFrequentlyDisruptsOrStonewalls
			,CBTA.UnableToFormTherapeutic
			,CBTA.UnawareOfProblemOrItsConsequences
			,CBTA.UnableToCommunicateWithClinician
			,CBTA.TheChildOrAdolescentIsEmancipated
			,CBTA.QuicklyAndActivelyAngages
			,CBTA.SensitiveAndAwareOfTheChildsNeeds
			,CBTA.SensitiveAndAwareOfTheChildsProblems
			,CBTA.ActiveAndEnthusiasticInParticipating
			,CBTA.DevelopsAPositiveTherapeuticRelationship
			,CBTA.ExploresTheProblemAndAcceptsOthers
			,CBTA.WorksCollaborativelyWithClinicians
			,CBTA.CollaboratesWithTreatmentPlan
			,CBTA.InconsistentAndOrAvoidantRelationship
			,CBTA.DefinesProblemButHasDifficultyCreating
			,CBTA.UnableToCollaborateInDevelopment
			,CBTA.UnableToParticipateConsistently
			,CBTA.ContentiousAndOrHostileRelationship
			,CBTA.UnableToReachSharedDefinition
			,CBTA.AbleToAcceptChildOrAdolescent
			,CBTA.EngagesInBehaviorsThatAreInconsistent
			,CBTA.NoAwarenessOfProblem
			,CBTA.NotPhysicallyAvailable
			,CBTA.RefusesToAcceptChildOrAdolescent
			,CBTA.ActivelyAvoidantOfAndUnable
			,CBTA.CALOCUSScore
			,CBTA.RiskOfHarmScore
			,CBTA.FunctionalStatusScore
			,CBTA.CoMorbidityScore
			,CBTA.RecoveryEnvironmentStressScore
			,CBTA.RecoveryEnvironmentSupportScore
			,CBTA.ResiliencyTreatmentHistoryScore
			,CBTA.TreatmentAcceptanceEngagementChildScore
			,CBTA.TreatmentAcceptanceEngagementParentScore
			,CBTA.CurrentLevelOfCare
			,CBTA.ActualDisposition
			,CBTA.ReasonForVariance
			,CBTA.ProgramReferredTo
			,CBTA.EvaluationNotes			
		FROM systemconfigurations SC
		LEFT JOIN DocumentCALOCUS CBTA ON SC.DatabaseVersion = - 1

		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitDocumentCALOCUS') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                            
				16
				,-- Severity.                                                                                                            
				1 -- State.                                                                                                            
				);
	END CATCH
END
GO

