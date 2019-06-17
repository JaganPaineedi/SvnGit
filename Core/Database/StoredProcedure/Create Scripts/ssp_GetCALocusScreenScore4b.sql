if object_id('dbo.ssp_GetCALocusScreenScore4b') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore4b
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore4b
(
	@DocumentVersionId INT,
	@ACTPresent BIT OUTPUT
) 
AS 

/* 
1. File: 6. ssp_GetCALocusScreenScore4b.sql		
2. Name: ssp_GetCALocusScreenScore4b		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore4b VARCHAR(50)
			DECLARE @FamilyAndOrdinaryCommunityResources CHAR(1)
			DECLARE @ContinuityOfActiveEngagedPrimary CHAR(1)
			DECLARE @EffectiveInvolvementOfWraparound CHAR(1)

			DECLARE @ContinuityOfFamilyOrPrimaryCaretakers CHAR(1)
			DECLARE @FamilyPrimaryCaretakersAreWilling CHAR(1)
			DECLARE @SpecialNeedsAreAddressedThroughSuccessful CHAR(1)
			DECLARE @CommunityResourcesAreSufficient CHAR(1)

			DECLARE @FamilyHasLimitedAbilityToRespond CHAR(1)
			DECLARE @CommunityResourcesOnlyPartiallyCompensate CHAR(1)
			DECLARE @FamilyOrPrimaryCaretakersDemonstrate CHAR(1)

			DECLARE @FamilyOrPrimaryCaretakersSeriouslyLimited CHAR(1)
			DECLARE @FewCommunitySupportsAndOrSerious CHAR(1)
			DECLARE @FamilyAndOtherPrimaryCaretakers CHAR(1)

			DECLARE @FamilyAndOrOtherPrimaryCaretakers CHAR(1)
			DECLARE @CommunityHasDeteriorated CHAR(1)
			DECLARE @LackOfLiaisonAndCooperation CHAR(1)
			DECLARE @InabilityOfFamilyOrOtherPrimary CHAR(1)
			DECLARE @LackOfEvenMinimalAttachment CHAR(1)
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)


			SELECT 
			 	@FamilyAndOrdinaryCommunityResources	=	FamilyAndOrdinaryCommunityResources
				,@ContinuityOfActiveEngagedPrimary	=	ContinuityOfActiveEngagedPrimary
				,@EffectiveInvolvementOfWraparound	=	EffectiveInvolvementOfWraparound
				
				,@ContinuityOfFamilyOrPrimaryCaretakers	=	ContinuityOfFamilyOrPrimaryCaretakers
				,@FamilyPrimaryCaretakersAreWilling	=	FamilyPrimaryCaretakersAreWilling
				,@SpecialNeedsAreAddressedThroughSuccessful	=	SpecialNeedsAreAddressedThroughSuccessful
				,@CommunityResourcesAreSufficient	=	CommunityResourcesAreSufficient
				
				,@FamilyHasLimitedAbilityToRespond	=	FamilyHasLimitedAbilityToRespond
				,@CommunityResourcesOnlyPartiallyCompensate	=	CommunityResourcesOnlyPartiallyCompensate
				,@FamilyOrPrimaryCaretakersDemonstrate	=	FamilyOrPrimaryCaretakersDemonstrate
				
				,@FamilyOrPrimaryCaretakersSeriouslyLimited	=	FamilyOrPrimaryCaretakersSeriouslyLimited
				,@FewCommunitySupportsAndOrSerious	=	FewCommunitySupportsAndOrSerious
				,@FamilyAndOtherPrimaryCaretakers	=	FamilyAndOtherPrimaryCaretakers
				
				,@FamilyAndOrOtherPrimaryCaretakers	=	FamilyAndOrOtherPrimaryCaretakers
				,@CommunityHasDeteriorated	=	CommunityHasDeteriorated
				,@LackOfLiaisonAndCooperation	=	LackOfLiaisonAndCooperation
				,@InabilityOfFamilyOrOtherPrimary	=	InabilityOfFamilyOrOtherPrimary
				,@LackOfEvenMinimalAttachment	=	LackOfEvenMinimalAttachment
			FROM [dbo].[DocumentCALOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@FamilyAndOrdinaryCommunityResources='Y')
			BEGIN
			SET @ScreenScore4b='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b='0' 
			END

			IF(@ContinuityOfActiveEngagedPrimary='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@EffectiveInvolvementOfWraparound='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'1' 
			SET @ACTPresent=1
			END
			ELSE 
			BEGIN
			SET @ACTPresent=0
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

--------------------------------------------------------------------------------

			IF(@ContinuityOfFamilyOrPrimaryCaretakers='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@FamilyPrimaryCaretakersAreWilling='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@SpecialNeedsAreAddressedThroughSuccessful='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@CommunityResourcesAreSufficient='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

--------------------------------------------------------------------------------
			IF(@FamilyHasLimitedAbilityToRespond='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@CommunityResourcesOnlyPartiallyCompensate='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@FamilyOrPrimaryCaretakersDemonstrate='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

---------------------------------------------------------------------------------------------

			IF(@FamilyOrPrimaryCaretakersSeriouslyLimited='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@FewCommunitySupportsAndOrSerious='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@FamilyAndOtherPrimaryCaretakers='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

----------------------------------------------------------------------------------------------------

			IF(@FamilyAndOrOtherPrimaryCaretakers='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@CommunityHasDeteriorated='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@LackOfLiaisonAndCooperation='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@InabilityOfFamilyOrOtherPrimary='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@LackOfEvenMinimalAttachment='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

SET @ScreenScoreString=REPLACE(@ScreenScore4b,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore4b = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)

UPDATE dbo.DocumentCALOCUS SET RecoveryEnvironmentSupportScore  =@ScreenScore4b WHERE DocumentVersionId=@DocumentVersionId



END