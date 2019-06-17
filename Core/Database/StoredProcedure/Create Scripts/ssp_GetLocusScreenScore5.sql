if object_id('dbo.ssp_GetLocusScreenScore5') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore5
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore5
(
	@DocumentVersionId INT,
	@CompletedTreatment BIT OUTPUT
) 
AS 

/* 
1. File: 7. ssp_GetLocusScreenScore5.sql		
2. Name: ssp_GetLocusScreenScore5		
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
			DECLARE @FullyResponsiveNoPriorExperience CHAR(1)			
			DECLARE @FullyResponsivePriorExperience CHAR(1)				
			DECLARE @FullyResponsiveSuccessful CHAR(1)					
			DECLARE @SignificantResponsePrevious CHAR(1)					
			DECLARE @SignificantResponseRecovery CHAR(1)					
			DECLARE @ModerateResponseCurrentTreatment	CHAR(1)
			DECLARE @ModerateResponsePreviousTreatment	CHAR(1) 
			DECLARE @ModerateResponseUnclear	CHAR(1) 
			DECLARE @ModerateResponseLeastPartial	CHAR(1) 
			DECLARE @PoorResponsePrevious	CHAR(1) 
			DECLARE @PoorResponseAttempts	CHAR(1) 
			DECLARE @NegligibleResponsePast	CHAR(1) 
			DECLARE @NegligibleResponseSymptoms	CHAR(1) 
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)
			

			SELECT 
			@FullyResponsiveNoPriorExperience=FullyResponsiveNoPriorExperience
			,@FullyResponsivePriorExperience=FullyResponsivePriorExperience
			,@FullyResponsiveSuccessful=FullyResponsiveSuccessful
			,@SignificantResponsePrevious=SignificantResponsePrevious
			,@SignificantResponseRecovery=SignificantResponseRecovery
			,@ModerateResponseCurrentTreatment=ModerateResponseCurrentTreatment
			,@ModerateResponsePreviousTreatment=ModerateResponsePreviousTreatment
			,@ModerateResponseUnclear=ModerateResponseUnclear
			,@ModerateResponseLeastPartial=ModerateResponseLeastPartial
			,@PoorResponsePrevious=PoorResponsePrevious
			,@PoorResponseAttempts=PoorResponseAttempts
			,@NegligibleResponsePast=NegligibleResponsePast
			,@NegligibleResponseSymptoms=NegligibleResponseSymptoms
			FROM [dbo].[DocumentLOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId

			IF(@FullyResponsiveNoPriorExperience='Y')
			BEGIN
			SET @ScreenScore5='1' 
			SET @CompletedTreatment=1
			END
			ELSE 
			BEGIN
			SET @ScreenScore5='0' 
			SET @CompletedTreatment=0
			END

			IF(@FullyResponsivePriorExperience='Y')
			BEGIN
			SET @ScreenScore5= @ScreenScore5+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5= @ScreenScore5+'0' 
			END

			IF(@FullyResponsiveSuccessful='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------

			IF(@SignificantResponsePrevious='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@SignificantResponseRecovery='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------
			IF(@ModerateResponseCurrentTreatment='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@ModerateResponsePreviousTreatment ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@ModerateResponseUnclear ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@ModerateResponseLeastPartial='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------
			IF(@PoorResponsePrevious ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@PoorResponseAttempts='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

--------------------------------------------------------------------------------
			IF(@NegligibleResponsePast ='Y')
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore5=@ScreenScore5+'0' 
			END

			IF(@NegligibleResponseSymptoms='Y')
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

UPDATE dbo.DocumentLOCUS SET TreatmentRecoveryScore =@ScreenScore5 WHERE DocumentVersionId=@DocumentVersionId



END