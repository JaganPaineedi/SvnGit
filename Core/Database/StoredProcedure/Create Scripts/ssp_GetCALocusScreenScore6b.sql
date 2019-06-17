if object_id('dbo.ssp_GetCALocusScreenScore6b') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore6b
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore6b
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 8. ssp_GetCALocusScreenScore6b.sql		
2. Name: ssp_GetCALocusScreenScore6b		
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
			
			DECLARE @TheChildOrAdolescentIsEmancipated CHAR(1)

			DECLARE @QuicklyAndActivelyAngages CHAR(1)
			DECLARE @SensitiveAndAwareOfTheChildsNeeds CHAR(1)
			DECLARE @SensitiveAndAwareOfTheChildsProblems CHAR(1)
			DECLARE @ActiveAndEnthusiasticInParticipating CHAR(1)

			DECLARE @DevelopsAPositiveTherapeuticRelationship CHAR(1)
			DECLARE @ExploresTheProblemAndAcceptsOthers CHAR(1)
			DECLARE @WorksCollaborativelyWithClinicians CHAR(1)
			DECLARE @CollaboratesWithTreatmentPlan CHAR(1)

			DECLARE @InconsistentAndOrAvoidantRelationship CHAR(1)
			DECLARE @DefinesProblemButHasDifficultyCreating CHAR(1)
			DECLARE @UnableToCollaborateInDevelopment CHAR(1)
			DECLARE @UnableToParticipateConsistently CHAR(1)

			DECLARE @ContentiousAndOrHostileRelationship CHAR(1)
			DECLARE @UnableToReachSharedDefinition CHAR(1)
			DECLARE @AbleToAcceptChildOrAdolescent CHAR(1)
			DECLARE @EngagesInBehaviorsThatAreInconsistent CHAR(1)

			DECLARE @NoAwarenessOfProblem CHAR(1)
			DECLARE @NotPhysicallyAvailable CHAR(1)
			DECLARE @RefusesToAcceptChildOrAdolescent CHAR(1)
			DECLARE @ActivelyAvoidantOfAndUnable  CHAR(1)

			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)

			SELECT 
			  		@TheChildOrAdolescentIsEmancipated	=	TheChildOrAdolescentIsEmancipated
				
					,@QuicklyAndActivelyAngages	=	QuicklyAndActivelyAngages
					,@SensitiveAndAwareOfTheChildsNeeds	=	SensitiveAndAwareOfTheChildsNeeds
					,@SensitiveAndAwareOfTheChildsProblems	=	SensitiveAndAwareOfTheChildsProblems
					,@ActiveAndEnthusiasticInParticipating	=	ActiveAndEnthusiasticInParticipating
				
					,@DevelopsAPositiveTherapeuticRelationship	=	DevelopsAPositiveTherapeuticRelationship
					,@ExploresTheProblemAndAcceptsOthers	=	ExploresTheProblemAndAcceptsOthers
					,@WorksCollaborativelyWithClinicians	=	WorksCollaborativelyWithClinicians
					,@CollaboratesWithTreatmentPlan	=	CollaboratesWithTreatmentPlan
				
					,@InconsistentAndOrAvoidantRelationship	=	InconsistentAndOrAvoidantRelationship
					,@DefinesProblemButHasDifficultyCreating	=	DefinesProblemButHasDifficultyCreating
					,@UnableToCollaborateInDevelopment	=	UnableToCollaborateInDevelopment
					,@UnableToParticipateConsistently	=	UnableToParticipateConsistently
				
					,@ContentiousAndOrHostileRelationship	=	ContentiousAndOrHostileRelationship
					,@UnableToReachSharedDefinition	=	UnableToReachSharedDefinition
					,@AbleToAcceptChildOrAdolescent	=	AbleToAcceptChildOrAdolescent
					,@EngagesInBehaviorsThatAreInconsistent	=	EngagesInBehaviorsThatAreInconsistent
				
					,@NoAwarenessOfProblem	=	NoAwarenessOfProblem
					,@NotPhysicallyAvailable	=	NotPhysicallyAvailable
					,@RefusesToAcceptChildOrAdolescent	=	RefusesToAcceptChildOrAdolescent
					,@ActivelyAvoidantOfAndUnable 	=	ActivelyAvoidantOfAndUnable 

			FROM [dbo].[DocumentCALOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@TheChildOrAdolescentIsEmancipated ='Y')
			BEGIN
			SET @ScreenScore6='0' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6='0' 
			END

--------------------------------------------------------------------------------------------------------------------			

			IF(@QuicklyAndActivelyAngages ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@SensitiveAndAwareOfTheChildsNeeds ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@SensitiveAndAwareOfTheChildsProblems ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@ActiveAndEnthusiasticInParticipating ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------

			IF(@DevelopsAPositiveTherapeuticRelationship ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@ExploresTheProblemAndAcceptsOthers ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@WorksCollaborativelyWithClinicians ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@CollaboratesWithTreatmentPlan='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@InconsistentAndOrAvoidantRelationship ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@DefinesProblemButHasDifficultyCreating ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnableToCollaborateInDevelopment ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnableToParticipateConsistently ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@ContentiousAndOrHostileRelationship ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnableToReachSharedDefinition ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@AbleToAcceptChildOrAdolescent ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@EngagesInBehaviorsThatAreInconsistent ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@NoAwarenessOfProblem ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@NotPhysicallyAvailable ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@RefusesToAcceptChildOrAdolescent ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@ActivelyAvoidantOfAndUnable  ='Y')
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


UPDATE dbo.DocumentCALOCUS SET TreatmentAcceptanceEngagementParentScore =@ScreenScore6 WHERE DocumentVersionId=@DocumentVersionId


END