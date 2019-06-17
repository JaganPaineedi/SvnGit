if object_id('dbo.ssp_GetCALocusScreenScore5') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore5
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore5
(
	@DocumentVersionId INT,
	@CompletedTreatment BIT OUTPUT
) 
AS 

/* 
1. File: 7. ssp_GetCALocusScreenScore5.sql		
2. Name: ssp_GetCALocusScreenScore5		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore5 VARCHAR(50)
			
			DECLARE @ThereHasBeenNoPriorExperience CHAR(1)
			DECLARE @ChildHasDemonstratedSignificant CHAR(1)
			DECLARE @PriorExperienceIndicatesThatEfforts CHAR(1)
			DECLARE @ThereHasBeenSuccessfulManagement CHAR(1)
			DECLARE @AbleToTransitionSuccessfully CHAR(1)

			DECLARE @ChildDemonstratedAverageAbility CHAR(1)
			DECLARE @PreviousExperienceInTreatment CHAR(1)
			DECLARE @SignificantAbilityToManageRecovery CHAR(1)
			DECLARE @RecoveryHasBeenManagedForShort CHAR(1)
			DECLARE @AbleToTransitionSuccessfullyAndAccept CHAR(1)

			DECLARE @ChildHasDemonstratedAnInconsistent CHAR(1)
			DECLARE @PreviousExperienceInTreatmentAtLowLevel CHAR(1)
			DECLARE @RecoveryHasBeenMaintainedForModerate CHAR(1)
			DECLARE @HasDemonstratedLimitedAbility CHAR(1)
			DECLARE @DevelopmentalPressuresAndLifeChanges CHAR(1)
			DECLARE @AbleToTransitionSuccessfullyAndAcceptChange CHAR(1)

			DECLARE @ChildHasDemonstratedFrequentEvidence CHAR(1)
			DECLARE @PreviousTreatmentHasNotAchievedComplete CHAR(1)
			DECLARE @AttemptsToMaintainWhateverGains CHAR(1)
			DECLARE @DevelopmentalPressuresAndLifeChangesDistress CHAR(1)
			DECLARE @TransitionsWithChangesInRoutine CHAR(1)

			DECLARE @ChildHasDemonstratedSignificantAndConsistent CHAR(1)
			DECLARE @PastResponseToTreatmentHasBeenQuite CHAR(1)
			DECLARE @SymptomsArePersistentAndFunctionalAbility CHAR(1)
			DECLARE @DevelopmentalPressuresAndLifeChangesTurmoil CHAR(1)
			DECLARE @UnableToTransitionOrAcceptChanges CHAR(1)

			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)
			

			SELECT 
				@ThereHasBeenNoPriorExperience	=	ThereHasBeenNoPriorExperience
				,@ChildHasDemonstratedSignificant	=	ChildHasDemonstratedSignificant
				,@PriorExperienceIndicatesThatEfforts	=	PriorExperienceIndicatesThatEfforts
				,@ThereHasBeenSuccessfulManagement	=	ThereHasBeenSuccessfulManagement
				,@AbleToTransitionSuccessfully	=	AbleToTransitionSuccessfully
				
				,@ChildDemonstratedAverageAbility	=	ChildDemonstratedAverageAbility
				,@PreviousExperienceInTreatment	=	PreviousExperienceInTreatment
				,@SignificantAbilityToManageRecovery	=	SignificantAbilityToManageRecovery
				,@RecoveryHasBeenManagedForShort	=	RecoveryHasBeenManagedForShort
				,@AbleToTransitionSuccessfullyAndAccept	=	AbleToTransitionSuccessfullyAndAccept
				
				,@ChildHasDemonstratedAnInconsistent	=	ChildHasDemonstratedAnInconsistent
				,@PreviousExperienceInTreatmentAtLowLevel	=	PreviousExperienceInTreatmentAtLowLevel
				,@RecoveryHasBeenMaintainedForModerate	=	RecoveryHasBeenMaintainedForModerate
				,@HasDemonstratedLimitedAbility	=	HasDemonstratedLimitedAbility
				,@DevelopmentalPressuresAndLifeChanges	=	DevelopmentalPressuresAndLifeChangesDeterioration
				,@AbleToTransitionSuccessfullyAndAcceptChange	=	AbleToTransitionSuccessfullyAndAcceptChange
				
				,@ChildHasDemonstratedFrequentEvidence	=	ChildHasDemonstratedFrequentEvidence
				,@PreviousTreatmentHasNotAchievedComplete	=	PreviousTreatmentHasNotAchievedComplete
				,@AttemptsToMaintainWhateverGains	=	AttemptsToMaintainWhateverGains
				,@DevelopmentalPressuresAndLifeChangesDistress	=	@DevelopmentalPressuresAndLifeChangesDistress
				,@TransitionsWithChangesInRoutine	=	TransitionsWithChangesInRoutine
				
				,@ChildHasDemonstratedSignificantAndConsistent	=	ChildHasDemonstratedSignificantAndConsistent
				,@PastResponseToTreatmentHasBeenQuite	=	PastResponseToTreatmentHasBeenQuite
				,@SymptomsArePersistentAndFunctionalAbility	=	SymptomsArePersistentAndFunctionalAbility
				,@DevelopmentalPressuresAndLifeChangesTurmoil	=	DevelopmentalPressuresAndLifeChangesTurmoil
				,@UnableToTransitionOrAcceptChanges	=	UnableToTransitionOrAcceptChanges
			FROM [dbo].[DocumentCALOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId

			IF(@ThereHasBeenNoPriorExperience='Y')
			BEGIN
			SET @ScreenScore5='1' 
			SET @CompletedTreatment=1
			END
			ELSE 
			BEGIN
			SET @ScreenScore5='0' 
			SET @CompletedTreatment=0
			END

			IF(@ChildHasDemonstratedSignificant='Y')
			BEGIN
			SET @ScreenScore5= @ScreenScore5+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5= @ScreenScore5+'0' 
			END

			IF(@PriorExperienceIndicatesThatEfforts='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@ThereHasBeenSuccessfulManagement='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@AbleToTransitionSuccessfully='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------

			IF(@ChildDemonstratedAverageAbility='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@PreviousExperienceInTreatment='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@SignificantAbilityToManageRecovery='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@RecoveryHasBeenManagedForShort='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@AbleToTransitionSuccessfullyAndAccept='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------
			IF(@ChildHasDemonstratedAnInconsistent='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@PreviousExperienceInTreatmentAtLowLevel ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@RecoveryHasBeenMaintainedForModerate ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@HasDemonstratedLimitedAbility='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@DevelopmentalPressuresAndLifeChanges='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@AbleToTransitionSuccessfullyAndAcceptChange='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------
			IF(@ChildHasDemonstratedFrequentEvidence ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@PreviousTreatmentHasNotAchievedComplete='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@AttemptsToMaintainWhateverGains='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@DevelopmentalPressuresAndLifeChangesDistress='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@TransitionsWithChangesInRoutine='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------
			IF(@ChildHasDemonstratedSignificantAndConsistent ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@PastResponseToTreatmentHasBeenQuite='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@SymptomsArePersistentAndFunctionalAbility ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@DevelopmentalPressuresAndLifeChangesTurmoil='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@UnableToTransitionOrAcceptChanges='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

SET @ScreenScoreString=REPLACE(@ScreenScore5,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore5 = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)

UPDATE dbo.DocumentCALOCUS SET ResiliencyTreatmentHistoryScore =@ScreenScore5 WHERE DocumentVersionId=@DocumentVersionId



END