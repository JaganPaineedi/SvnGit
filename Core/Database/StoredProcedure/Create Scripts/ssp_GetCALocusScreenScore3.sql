if object_id('dbo.ssp_GetCALocusScreenScore3') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore3
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore3
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 4. ssp_GetCALocusScreenScore3.sql		
2. Name: ssp_GetCALocusScreenScore3		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore3 VARCHAR(50)
			DECLARE @NoEvidenceOfMedicalIllness CHAR(1)
			DECLARE @PastMedicalSubstanceUse CHAR(1)

			DECLARE @MinimalDevelopmentalDelayDisorder CHAR(1)
			DECLARE @SelfLimitedMedicalConditions CHAR(1)
			DECLARE @OccasionalSelfLimitedEpisodes CHAR(1)
			DECLARE @TransientOccasionalStressRelated CHAR(1)

			DECLARE @DevelopmentalDisabilityIsPresentThat CHAR(1)
			DECLARE @MedicalConditionsArePresentRequiring CHAR(1)
			DECLARE @MedicalConditionsArePresentAdversely CHAR(1)
			DECLARE @SubstanceAbuseSignificantAdverseEffect CHAR(1)
			DECLARE @RecentSubstanceUseThatHasSignificantImpact CHAR(1)
			DECLARE @PsychiatricSignsAndSymptomsArePresent CHAR(1)

			DECLARE @MedicalConditionsArePresentRequireMonitoring CHAR(1)
			DECLARE @MedicalConditionsArePresentAffecting CHAR(1)
			DECLARE @UncontrolledSubstanceUsePresentSeriousThreat CHAR(1)
			DECLARE @DevelopmentalDelayOrDisorderSignificantlyAlters CHAR(1)
			DECLARE @PsychiatricSymptomsPresentClearlyImpairFunctioning CHAR(1)

			DECLARE @SignificantMedicalConditionIsPresent CHAR(1)
			DECLARE @MedicalConditionAcutelyChronicallyWorsens CHAR(1)
			DECLARE @SubstanceDependencePresentWithInability CHAR(1)
			DECLARE @DevelopmentalDisorderPresentComplicates CHAR(1)
			DECLARE @AcuteSeverePsychiatricSymptomsPresent CHAR(1)
				
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)

			SELECT 
			  	@NoEvidenceOfMedicalIllness	=	NoEvidenceOfMedicalIllness
				,@PastMedicalSubstanceUse	=	PastMedicalSubstanceUse
				
				,@MinimalDevelopmentalDelayDisorder	=	MinimalDevelopmentalDelayDisorder
				,@SelfLimitedMedicalConditions	=	SelfLimitedMedicalConditions
				,@OccasionalSelfLimitedEpisodes	=	OccasionalSelfLimitedEpisodes
				,@TransientOccasionalStressRelated	=	TransientOccasionalStressRelated
				
				,@DevelopmentalDisabilityIsPresentThat	=	DevelopmentalDisabilityIsPresentThat
				,@MedicalConditionsArePresentRequiring	=	MedicalConditionsArePresentRequiring
				,@MedicalConditionsArePresentAdversely	=	MedicalConditionsArePresentAdversely
				,@SubstanceAbuseSignificantAdverseEffect	=	SubstanceAbuseSignificantAdverseEffect
				,@RecentSubstanceUseThatHasSignificantImpact	=	RecentSubstanceUseThatHasSignificantImpact
				,@PsychiatricSignsAndSymptomsArePresent	=	PsychiatricSignsAndSymptomsArePresent

				,@MedicalConditionsArePresentRequireMonitoring	=	MedicalConditionsArePresentRequireMonitoring
				,@MedicalConditionsArePresentAffecting	=	MedicalConditionsArePresentAffecting
				,@UncontrolledSubstanceUsePresentSeriousThreat	=	UncontrolledSubstanceUsePresentSeriousThreat
				,@DevelopmentalDelayOrDisorderSignificantlyAlters	=	DevelopmentalDelayOrDisorderSignificantlyAlters
				,@PsychiatricSymptomsPresentClearlyImpairFunctioning	=	PsychiatricSymptomsPresentClearlyImpairFunctioning
	
				,@SignificantMedicalConditionIsPresent	=	SignificantMedicalConditionIsPresent
				,@MedicalConditionAcutelyChronicallyWorsens	=	MedicalConditionAcutelyChronicallyWorsens
				,@SubstanceDependencePresentWithInability	=	SubstanceDependencePresentWithInability
				,@DevelopmentalDisorderPresentComplicates	=	DevelopmentalDisorderPresentComplicates
				FROM [dbo].[DocumentCALOCUS]
				WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@NoEvidenceOfMedicalIllness='Y')
			BEGIN
			SET @ScreenScore3='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3='0' 
			END

			IF(@PastMedicalSubstanceUse='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END
-----------------------------------------------------------------------------------------

			IF(@MinimalDevelopmentalDelayDisorder='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SelfLimitedMedicalConditions='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@OccasionalSelfLimitedEpisodes='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@TransientOccasionalStressRelated='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

----------------------------------------------------------------------------------

			IF(@DevelopmentalDisabilityIsPresentThat='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MedicalConditionsArePresentRequiring='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MedicalConditionsArePresentAdversely='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SubstanceAbuseSignificantAdverseEffect='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@RecentSubstanceUseThatHasSignificantImpact='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@PsychiatricSignsAndSymptomsArePresent='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

-------------------------------------------------------------------------------------------------

			IF(@MedicalConditionsArePresentRequireMonitoring='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MedicalConditionsArePresentAffecting='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@UncontrolledSubstanceUsePresentSeriousThreat='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@DevelopmentalDelayOrDisorderSignificantlyAlters='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@PsychiatricSymptomsPresentClearlyImpairFunctioning='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

----------------------------------------------------------------------------------------------------

			IF(@SignificantMedicalConditionIsPresent='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MedicalConditionAcutelyChronicallyWorsens='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SubstanceDependencePresentWithInability='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@DevelopmentalDisorderPresentComplicates='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@AcuteSeverePsychiatricSymptomsPresent='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END


SET @ScreenScoreString=REPLACE(@ScreenScore3,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore3 = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)

UPDATE dbo.DocumentCALOCUS SET CoMorbidityScore =@ScreenScore3 WHERE DocumentVersionId=@DocumentVersionId

END