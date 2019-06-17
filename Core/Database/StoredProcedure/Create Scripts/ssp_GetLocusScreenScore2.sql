if object_id('dbo.ssp_GetLocusScreenScore2') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore2
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore2
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 3. ssp_GetLocusScreenScore2.sql		
2. Name: ssp_GetLocusScreenScore2		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore2 VARCHAR(50)
			DECLARE @MinimalImpairmentNoMore	CHAR(1)
			DECLARE @MildImpairmentExperiencing	CHAR(1)
			DECLARE @MildImpairmentRecentExperience	CHAR(1)
			DECLARE @MildImpairmentDevelopingMinor	CHAR(1)
			DECLARE @MildImpairmentDemonstrating	CHAR(1)
			DECLARE @ModerateImpairmentRecentConflict	CHAR(1)
			DECLARE @ModerateImpairmentAppearance	CHAR(1)
			DECLARE @ModerateImpairmentSignificantDisturbances CHAR(1)
			DECLARE @ModerateImpairmentSignificantDeterioration CHAR(1)
			DECLARE @ModerateImpairmentOngoing CHAR(1)
			DECLARE @ModerateImpairmentRecentGains CHAR(1)
			DECLARE @SeriousImpairmentSeriousDecrease CHAR(1)
			DECLARE @SeriousImpairmentSignificantWithdrawal CHAR(1)
			DECLARE @SeriousImpairmentConsistentFailure CHAR(1)
			DECLARE @SeriousImpairmentSeriousDisturbances CHAR(1)
			DECLARE @SeriousImpairmentInability CHAR(1)
			DECLARE @SevereImpairmentExtremeDeterioration CHAR(1)
			DECLARE @SevereImpairmentDevelopmentComplete CHAR(1)
			DECLARE @SevereImpairmentCompleteNeglect CHAR(1)
			DECLARE @SevereImpairmentExtremeDistruptions CHAR(1)
			DECLARE @SevereImpairmentCompleteInability CHAR(1)
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)

			SELECT 
			  @MinimalImpairmentNoMore=MinimalImpairmentNoMore
			  ,@MildImpairmentExperiencing=MildImpairmentExperiencing
			  ,@MildImpairmentRecentExperience=MildImpairmentRecentExperience
			  ,@MildImpairmentDevelopingMinor=MildImpairmentDevelopingMinor
			  ,@MildImpairmentDemonstrating=MildImpairmentDemonstrating
			  ,@ModerateImpairmentRecentConflict=ModerateImpairmentRecentConflict
			  ,@ModerateImpairmentAppearance=ModerateImpairmentAppearance
			  ,@ModerateImpairmentSignificantDisturbances=ModerateImpairmentSignificantDisturbances
			  ,@ModerateImpairmentSignificantDeterioration=ModerateImpairmentSignificantDeterioration
			  ,@ModerateImpairmentOngoing=ModerateImpairmentOngoing
			  ,@ModerateImpairmentRecentGains=ModerateImpairmentRecentGains
			  ,@SeriousImpairmentSeriousDecrease=SeriousImpairmentSeriousDecrease
			  ,@SeriousImpairmentSignificantWithdrawal=SeriousImpairmentSignificantWithdrawal
			  ,@SeriousImpairmentConsistentFailure=SeriousImpairmentConsistentFailure
			  ,@SeriousImpairmentSeriousDisturbances=SeriousImpairmentSeriousDisturbances
			  ,@SeriousImpairmentInability=SeriousImpairmentInability
			  ,@SevereImpairmentExtremeDeterioration=SevereImpairmentExtremeDeterioration
			  ,@SevereImpairmentDevelopmentComplete=SevereImpairmentDevelopmentComplete
			  ,@SevereImpairmentCompleteNeglect=SevereImpairmentCompleteNeglect
			  ,@SevereImpairmentExtremeDistruptions=SevereImpairmentExtremeDistruptions
			  ,@SevereImpairmentCompleteInability=SevereImpairmentCompleteInability
				FROM [dbo].[DocumentLOCUS]
				WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@MinimalImpairmentNoMore='Y')
			BEGIN
			SET @ScreenScore2='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2='0' 
			END

			IF(@MildImpairmentExperiencing='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@MildImpairmentRecentExperience='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@MildImpairmentDevelopingMinor='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@MildImpairmentDemonstrating='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@ModerateImpairmentRecentConflict='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@ModerateImpairmentAppearance='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@ModerateImpairmentSignificantDisturbances='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@ModerateImpairmentSignificantDeterioration='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@ModerateImpairmentOngoing='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@ModerateImpairmentRecentGains='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SeriousImpairmentSeriousDecrease='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SeriousImpairmentSignificantWithdrawal='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SeriousImpairmentConsistentFailure='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SeriousImpairmentSeriousDisturbances='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SeriousImpairmentInability='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SevereImpairmentExtremeDeterioration='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SevereImpairmentDevelopmentComplete='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SevereImpairmentCompleteNeglect='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SevereImpairmentExtremeDistruptions='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

			IF(@SevereImpairmentCompleteInability='Y')
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore2=@ScreenScore2+'0' 
			END

SET @ScreenScoreString=REPLACE(@ScreenScore2,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore2 = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)

UPDATE dbo.DocumentLOCUS SET FunctionalStatusScore =@ScreenScore2 WHERE DocumentVersionId=@DocumentVersionId

END