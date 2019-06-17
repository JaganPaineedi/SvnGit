if object_id('dbo.ssp_GetCALocusScreenScore6a') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore6a
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore6a
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 8. ssp_GetCALocusScreenScore6a.sql		
2. Name: ssp_GetCALocusScreenScore6a		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore6 VARCHAR(50)
			DECLARE @QuicklyFormsATrustingAndRespectfulPositive CHAR(1)
			DECLARE @AbleToDefineProblemsAndUnderstands CHAR(1)
			DECLARE @AcceptsAgeAppropriateResponsibilityForBehavior CHAR(1)
			DECLARE @ActivelyParticipatesInTreatmentPlanning CHAR(1)

			DECLARE @AbleToDevelopATrustingPositiveRelationship CHAR(1)
			DECLARE @UnableToDefineTheProblemButCanUnderstand CHAR(1)
			DECLARE @AcceptsLimitedAgeAppropriate CHAR(1)
			DECLARE @PassivelyCooperatesInTreatmentPlanning CHAR(1)

			DECLARE @AmbivalentAvoidantOrDistrustfulRelationship CHAR(1)
			DECLARE @AcknowledgesExistenceOfProblemButResists CHAR(1)
			DECLARE @MinimizesOrRationalizesDistressingBehaviors CHAR(1)
			DECLARE @UnableToAcceptOthersDefinition CHAR(1)
			DECLARE @FrequentlyMissesOrLateForTreatment CHAR(1)

			DECLARE @ActivelyHostileRelationshipWithClinicians CHAR(1)
			DECLARE @AcceptsNoAgeAppropriateResponsibilityRole CHAR(1)
			DECLARE @ActivelyFrequentlyDisruptsOrStonewalls CHAR(1)

			DECLARE @UnableToFormTherapeutic CHAR(1)
			DECLARE @UnawareOfProblemOrItsConsequences CHAR(1)
			DECLARE @UnableToCommunicateWithClinician CHAR(1)
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)

			SELECT 
			  	@QuicklyFormsATrustingAndRespectfulPositive	=	QuicklyFormsATrustingAndRespectfulPositive
				,@AbleToDefineProblemsAndUnderstands	=	AbleToDefineProblemsAndUnderstands
				,@AcceptsAgeAppropriateResponsibilityForBehavior	=	AcceptsAgeAppropriateResponsibilityForBehavior
				,@ActivelyParticipatesInTreatmentPlanning	=	ActivelyParticipatesInTreatmentPlanning
				
				,@AbleToDevelopATrustingPositiveRelationship	=	AbleToDevelopATrustingPositiveRelationship
				,@UnableToDefineTheProblemButCanUnderstand	=	UnableToDefineTheProblemButCanUnderstand
				,@AcceptsLimitedAgeAppropriate	=	AcceptsLimitedAgeAppropriate
				,@PassivelyCooperatesInTreatmentPlanning	=	PassivelyCooperatesInTreatmentPlanning
				
				,@AmbivalentAvoidantOrDistrustfulRelationship	=	AmbivalentAvoidantOrDistrustfulRelationship
				,@AcknowledgesExistenceOfProblemButResists	=	AcknowledgesExistenceOfProblemButResists
				,@MinimizesOrRationalizesDistressingBehaviors	=	MinimizesOrRationalizesDistressingBehaviors
				,@UnableToAcceptOthersDefinition	=	UnableToAcceptOthersDefinition
				,@FrequentlyMissesOrLateForTreatment	=	FrequentlyMissesOrLateForTreatment
				
				,@ActivelyHostileRelationshipWithClinicians	=	ActivelyHostileRelationshipWithClinicians
				,@AcceptsNoAgeAppropriateResponsibilityRole	=	AcceptsNoAgeAppropriateResponsibilityRole
				,@ActivelyFrequentlyDisruptsOrStonewalls	=	ActivelyFrequentlyDisruptsOrStonewalls
				
				,@UnableToFormTherapeutic	=	UnableToFormTherapeutic
				,@UnawareOfProblemOrItsConsequences	=	UnawareOfProblemOrItsConsequences
				,@UnableToCommunicateWithClinician	=	UnableToCommunicateWithClinician

			FROM [dbo].[DocumentCALOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@QuicklyFormsATrustingAndRespectfulPositive ='Y')
			BEGIN
			SET @ScreenScore6='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6='0' 
			END

			IF(@AbleToDefineProblemsAndUnderstands ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@AcceptsAgeAppropriateResponsibilityForBehavior ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@ActivelyParticipatesInTreatmentPlanning ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------

			IF(@AbleToDevelopATrustingPositiveRelationship ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnableToDefineTheProblemButCanUnderstand ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@AcceptsLimitedAgeAppropriate ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@PassivelyCooperatesInTreatmentPlanning='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@AmbivalentAvoidantOrDistrustfulRelationship ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@AcknowledgesExistenceOfProblemButResists ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@MinimizesOrRationalizesDistressingBehaviors ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnableToAcceptOthersDefinition ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@FrequentlyMissesOrLateForTreatment='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@ActivelyHostileRelationshipWithClinicians ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@AcceptsNoAgeAppropriateResponsibilityRole ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@ActivelyFrequentlyDisruptsOrStonewalls ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@UnableToFormTherapeutic ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnawareOfProblemOrItsConsequences ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnableToCommunicateWithClinician ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

SET @ScreenScoreString=REPLACE(@ScreenScore6,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore6 = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)


UPDATE dbo.DocumentCALOCUS SET TreatmentAcceptanceEngagementChildScore =@ScreenScore6 WHERE DocumentVersionId=@DocumentVersionId


END