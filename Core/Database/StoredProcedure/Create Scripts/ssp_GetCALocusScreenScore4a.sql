if object_id('dbo.ssp_GetCALocusScreenScore4a') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore4a
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore4a
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 5. ssp_GetCALocusScreenScore4a.sql		
2. Name: ssp_GetCALocusScreenScore4a		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore4a VARCHAR(50)
			DECLARE @AbsenceOfSignificantOrEnduringDifficulties CHAR(1)
			DECLARE @AbsenceOfRecentTransitionsOrLossesOfConsequence CHAR(1)
			DECLARE @MaterialNeedsMetWithoutSignificantCause CHAR(1)
			DECLARE @LivingEnvironmentConduciveNormativeGrowth CHAR(1)
			DECLARE @RoleExpectationsAreConsistentWithChild CHAR(1)

			DECLARE @SignificantTransitionRequiringAdjustment CHAR(1)
			DECLARE @MinorInterpersonalLossOrConflict CHAR(1)
			DECLARE @TransientButSignificantIllnessOrInjury CHAR(1)
			DECLARE @SomewhatInadequateMaterialResourcesThreat CHAR(1)
			DECLARE @ExpectationsForPerformanceAtHomeOrSchool CHAR(1)
			DECLARE @PotentialForExposureToSubstanceUse CHAR(1)

			DECLARE @DisruptionOfFamilySocialMilieu CHAR(1)
			DECLARE @InterpersonalOrMaterialLossThatHasSignificant CHAR(1)
			DECLARE @SeriousIllnessInjuryForProlongedPeriod CHAR(1)
			DECLARE @DangerOrThreatInNeighborhoodOrCommunity CHAR(1)
			DECLARE @ExposureToSubstanceAbuseAndItsEffects CHAR(1)
			DECLARE @RoleExpectationsThatExceedChild CHAR(1)

			DECLARE @SeriousDisruptionOfFamilySocialMilieu CHAR(1)
			DECLARE @ThreatOfSevereDisruptionInLifeCircumstances CHAR(1)
			DECLARE @InabilityToMeetNeedsForPhysical CHAR(1)
			DECLARE @ExposureToEndangeringCriminalActivities CHAR(1)
			DECLARE @DifficultyAvoidingExposureToSubstanceUse CHAR(1)


			DECLARE @HighlyTraumaticEnduringAndDisturbingCircumstances CHAR(1)
			DECLARE @PoliticalOrRacialPersecution CHAR(1)
			DECLARE @YouthFacesIncarcerationFosterHomePlacement CHAR(1)
			DECLARE @SeverePainInjuryOrDisability CHAR(1)

			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)



			SELECT 
			  	@AbsenceOfSignificantOrEnduringDifficulties	=	AbsenceOfSignificantOrEnduringDifficulties
				,@AbsenceOfRecentTransitionsOrLossesOfConsequence	=	AbsenceOfRecentTransitionsOrLossesOfConsequence
				,@MaterialNeedsMetWithoutSignificantCause	=	MaterialNeedsMetWithoutSignificantCause
				,@LivingEnvironmentConduciveNormativeGrowth	=	LivingEnvironmentConduciveNormativeGrowth
				,@RoleExpectationsAreConsistentWithChild	=	RoleExpectationsAreConsistentWithChild
			
				,@SignificantTransitionRequiringAdjustment	=	SignificantTransitionRequiringAdjustment
				,@MinorInterpersonalLossOrConflict	=	MinorInterpersonalLossOrConflict
				,@TransientButSignificantIllnessOrInjury	=	TransientButSignificantIllnessOrInjury
				,@SomewhatInadequateMaterialResourcesThreat	=	SomewhatInadequateMaterialResourcesThreat
				,@ExpectationsForPerformanceAtHomeOrSchool	=	ExpectationsForPerformanceAtHomeOrSchool
				,@PotentialForExposureToSubstanceUse	=	PotentialForExposureToSubstanceUse
				
				,@DisruptionOfFamilySocialMilieu	=	DisruptionOfFamilySocialMilieu
				,@InterpersonalOrMaterialLossThatHasSignificant	=	InterpersonalOrMaterialLossThatHasSignificant
				,@SeriousIllnessInjuryForProlongedPeriod	=	SeriousIllnessInjuryForProlongedPeriod
				,@DangerOrThreatInNeighborhoodOrCommunity	=	DangerOrThreatInNeighborhoodOrCommunity
				,@ExposureToSubstanceAbuseAndItsEffects	=	ExposureToSubstanceAbuseAndItsEffects
				,@RoleExpectationsThatExceedChild	=	RoleExpectationsThatExceedChild
				
				,@SeriousDisruptionOfFamilySocialMilieu	=	SeriousDisruptionOfFamilySocialMilieu
				,@ThreatOfSevereDisruptionInLifeCircumstances	=	ThreatOfSevereDisruptionInLifeCircumstances
				,@InabilityToMeetNeedsForPhysical	=	InabilityToMeetNeedsForPhysical
				,@ExposureToEndangeringCriminalActivities	=	ExposureToEndangeringCriminalActivities
				,@DifficultyAvoidingExposureToSubstanceUse	=	DifficultyAvoidingExposureToSubstanceUse

				,@HighlyTraumaticEnduringAndDisturbingCircumstances	=	HighlyTraumaticEnduringAndDisturbingCircumstances
				,@PoliticalOrRacialPersecution	=	PoliticalOrRacialPersecution
				,@YouthFacesIncarcerationFosterHomePlacement	=	YouthFacesIncarcerationFosterHomePlacement
				,@SeverePainInjuryOrDisability	=	SeverePainInjuryOrDisability
				FROM [dbo].[DocumentCALOCUS]
				WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@AbsenceOfSignificantOrEnduringDifficulties='Y')
			BEGIN
			SET @ScreenScore4a='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a='0' 
			END

			IF(@AbsenceOfRecentTransitionsOrLossesOfConsequence='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@MaterialNeedsMetWithoutSignificantCause='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@LivingEnvironmentConduciveNormativeGrowth='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@RoleExpectationsAreConsistentWithChild='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

---------------------------------------------------------------------------------

			IF(@SignificantTransitionRequiringAdjustment='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END


			IF(@MinorInterpersonalLossOrConflict='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@TransientButSignificantIllnessOrInjury='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@SomewhatInadequateMaterialResourcesThreat='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExpectationsForPerformanceAtHomeOrSchool='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@PotentialForExposureToSubstanceUse='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

-----------------------------------------------------------------------------------------------

			IF(@DisruptionOfFamilySocialMilieu='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@InterpersonalOrMaterialLossThatHasSignificant='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@SeriousIllnessInjuryForProlongedPeriod='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@DangerOrThreatInNeighborhoodOrCommunity='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExposureToSubstanceAbuseAndItsEffects='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@RoleExpectationsThatExceedChild='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

--------------------------------------------------------------------------------------------------

			IF(@SeriousDisruptionOfFamilySocialMilieu='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ThreatOfSevereDisruptionInLifeCircumstances='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@InabilityToMeetNeedsForPhysical='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExposureToEndangeringCriminalActivities='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@DifficultyAvoidingExposureToSubstanceUse='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

-----------------------------------------------------------------------------------------------------

			IF(@HighlyTraumaticEnduringAndDisturbingCircumstances='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@PoliticalOrRacialPersecution='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@YouthFacesIncarcerationFosterHomePlacement='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@SeverePainInjuryOrDisability='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			

SET @ScreenScoreString=REPLACE(@ScreenScore4a,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore4a = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)

UPDATE dbo.DocumentCALOCUS SET RecoveryEnvironmentStressScore =@ScreenScore4a WHERE DocumentVersionId=@DocumentVersionId


END