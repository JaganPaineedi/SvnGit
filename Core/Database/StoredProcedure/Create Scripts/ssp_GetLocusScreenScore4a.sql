if object_id('dbo.ssp_GetLocusScreenScore4a') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore4a
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore4a
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 5. ssp_GetLocusScreenScore4a.sql		
2. Name: ssp_GetLocusScreenScore4a		
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
			DECLARE @LowStressEssentially CHAR(1)						
			DECLARE @LowStressNoRecent CHAR(1)							
			DECLARE @LowStressNoMajor CHAR(1)							
			DECLARE @LowStressMaterial CHAR(1)							
			DECLARE @LowStressLiving CHAR(1)								
			DECLARE @LowStressNoPressure CHAR(1)							
			DECLARE @MildlyStressPresence CHAR(1)						
			DECLARE @MildlyStressTransition	 CHAR(1)					
			DECLARE @MildlyStressCircumstances CHAR(1)					
			DECLARE @MildlyStressRecentOnset CHAR(1)						
			DECLARE @MildlyStressPotential CHAR(1)						
			DECLARE @MildlyStressPerformance CHAR(1)						
			DECLARE @ModeratelyStressSignificantDiscord CHAR(1)			
			DECLARE @ModeratelyStressSignificantTransition CHAR(1)		
			DECLARE @ModeratelyStressRecentImportant CHAR(1)				
			DECLARE @ModeratelyStressConcern CHAR(1)						
			DECLARE @ModeratelyStressDanger CHAR(1)						
			DECLARE @ModeratelyStressEasyExposure CHAR(1)				
			DECLARE @ModeratelyStressPerception CHAR(1)					
			DECLARE @HighlyStressSerious CHAR(1)							
			DECLARE @HighlyStressSevere CHAR(1)							
			DECLARE @HighlyStressInability CHAR(1)						
			DECLARE @HighlyStressRecentOnset CHAR(1)						
			DECLARE @HighlyStressDifficulty	 CHAR(1)					
			DECLARE @HighlyStressEpisodes CHAR(1)						
			DECLARE @HighlyStressOverwhelming CHAR(1)					
			DECLARE @ExtremelyStressAcutely CHAR(1)						
			DECLARE @ExtremelyStressOngoing CHAR(1)						
			DECLARE @ExtremelyStressWitnessing CHAR(1)					
			DECLARE @ExtremelyStressPersecution CHAR(1)					
			DECLARE @ExtremelyStressSudden	 CHAR(1)
			DECLARE @ExtremelyStressUnavoidable CHAR(1)
			DECLARE @ExtremelyStressIncarceration CHAR(1)
			DECLARE @ExtremelyStressSevere CHAR(1)
			DECLARE @ExtremelyStressSustained CHAR(1)
			DECLARE @ExtremelyStressChaotic CHAR(1)
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)



			SELECT 
			  @LowStressEssentially=LowStressEssentially
			  ,@LowStressNoRecent=LowStressNoRecent
			  ,@LowStressNoMajor=LowStressNoMajor
			  ,@LowStressMaterial=LowStressMaterial
			  ,@LowStressLiving=LowStressLiving
			  ,@LowStressNoPressure=LowStressNoPressure
			  ,@MildlyStressPresence=MildlyStressPresence
			  ,@MildlyStressTransition=MildlyStressTransition
			  ,@MildlyStressCircumstances=MildlyStressCircumstances
			  ,@MildlyStressRecentOnset=MildlyStressRecentOnset
			  ,@MildlyStressPotential=MildlyStressPotential
			  ,@MildlyStressPerformance=MildlyStressPerformance
			  ,@ModeratelyStressSignificantDiscord=ModeratelyStressSignificantDiscord
			  ,@ModeratelyStressSignificantTransition=ModeratelyStressSignificantTransition
			  ,@ModeratelyStressRecentImportant=ModeratelyStressRecentImportant
			  ,@ModeratelyStressConcern=ModeratelyStressConcern
			  ,@ModeratelyStressDanger=ModeratelyStressDanger
			  ,@ModeratelyStressEasyExposure=ModeratelyStressEasyExposure
			  ,@ModeratelyStressPerception=ModeratelyStressPerception
			  ,@HighlyStressSerious=HighlyStressSerious
			  ,@HighlyStressSevere=HighlyStressSevere
			  ,@HighlyStressInability=HighlyStressInability
			  ,@HighlyStressRecentOnset=HighlyStressRecentOnset
			  ,@HighlyStressDifficulty=HighlyStressDifficulty
			  ,@HighlyStressEpisodes=HighlyStressEpisodes
			  ,@HighlyStressOverwhelming=HighlyStressOverwhelming
			  ,@ExtremelyStressAcutely=ExtremelyStressAcutely
			  ,@ExtremelyStressOngoing=ExtremelyStressOngoing
			  ,@ExtremelyStressWitnessing=ExtremelyStressWitnessing
			  ,@ExtremelyStressPersecution=ExtremelyStressPersecution
			  ,@ExtremelyStressSudden=ExtremelyStressSudden
			  ,@ExtremelyStressUnavoidable=ExtremelyStressUnavoidable
			  ,@ExtremelyStressIncarceration=ExtremelyStressIncarceration
			  ,@ExtremelyStressSevere=ExtremelyStressSevere
			  ,@ExtremelyStressSustained=ExtremelyStressSustained
			  ,@ExtremelyStressChaotic=ExtremelyStressChaotic
				FROM [dbo].[DocumentLOCUS]
				WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@LowStressEssentially='Y')
			BEGIN
			SET @ScreenScore4a='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a='0' 
			END

			IF(@LowStressNoRecent='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@LowStressNoMajor='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@LowStressMaterial='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@LowStressLiving='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@LowStressNoPressure='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

--------------------------------------------------------------------------------

			IF(@MildlyStressPresence='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@MildlyStressTransition='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@MildlyStressCircumstances='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@MildlyStressRecentOnset='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@MildlyStressPotential='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@MildlyStressPerformance='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END
--------------------------------------------------------------------------------
			IF(@ModeratelyStressSignificantDiscord='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ModeratelyStressSignificantTransition='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ModeratelyStressRecentImportant='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ModeratelyStressConcern='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ModeratelyStressDanger='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ModeratelyStressEasyExposure='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ModeratelyStressPerception='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END
--------------------------------------------------------------------------------
			IF(@HighlyStressSerious='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@HighlyStressSevere='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@HighlyStressInability='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@HighlyStressRecentOnset='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@HighlyStressDifficulty='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@HighlyStressEpisodes='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@HighlyStressOverwhelming='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END
--------------------------------------------------------------------------------
			IF(@ExtremelyStressAcutely='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressOngoing='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressWitnessing='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressPersecution='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressSudden='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressUnavoidable='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressIncarceration='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressSevere='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressSustained='Y')
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4a=@ScreenScore4a+'0' 
			END

			IF(@ExtremelyStressChaotic='Y')
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

UPDATE dbo.DocumentLOCUS SET RecoveryEnvironmentStressScore =@ScreenScore4a WHERE DocumentVersionId=@DocumentVersionId


END