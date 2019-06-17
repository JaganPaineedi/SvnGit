IF object_id('dbo.ssp_GetLocusScreenScore1') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore1
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore1
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 2. ssp_GetLocusScreenScore1.sql		
2. Name: ssp_GetLocusScreenScore1		
3. Desc: Procedure to Update Locus Dimension Score	
4. RETURN values:None	
5. Called by: Code	
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Description: Procedure to Update Locus Dimension Score
*/

BEGIN
			DECLARE @ScreenScore1 VARCHAR(50)
			DECLARE @MinimalRiskOfHarmNoIndication	CHAR(1)
			DECLARE @MinimalRiskOfHarmClearAbility	CHAR(1)	
			DECLARE @LowRiskOfHarmNoCurrentSuicidal	CHAR(1)
			DECLARE @LowRiskOfHarmOccasionalSubstance	CHAR(1)
			DECLARE @LowRiskOfHarmPeriodsInPast	CHAR(1)
			DECLARE @ModerateRiskOfHarmSignificant	CHAR(1)
			DECLARE @ModerateRiskOfHarmNoActiveSuicidal	CHAR(1)
			DECLARE @ModerateRiskOfHarmHistoryOfChronic	CHAR(1)
			DECLARE @ModerateRiskOfHarmBinge	CHAR(1)
			DECLARE @ModerateRiskOfHarmSomeEvidence	CHAR(1)
			DECLARE @SeriousRiskOfHarmCurrentSuicidal	CHAR(1)
			DECLARE @SeriousRiskOfHarmHistoryOfChronic	CHAR(1)
			DECLARE @SeriousRiskOfHarmRecentPattern	CHAR(1)
			DECLARE @SeriousRiskOfHarmClearCompromise	CHAR(1)
			DECLARE @ExtremeRiskOfHarmCurrentSuicidal	CHAR(1)
			DECLARE @ExtremeRiskOfHarmWithoutExpressed	CHAR(1)
			DECLARE @ExtremeRiskOfHarmWithHistory	CHAR(1)
			DECLARE @ExtremeRiskOfHarmPresenceOfCommand	CHAR(1)
			DECLARE @ExtremeRiskOfHarmRepeatedEpisodes	CHAR(1)
			DECLARE @ExtremeRiskOfHarmExtremeCompromise	CHAR(1)
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)


SELECT 
      @MinimalRiskOfHarmNoIndication= MinimalRiskOfHarmNoIndication
      ,@MinimalRiskOfHarmClearAbility=MinimalRiskOfHarmClearAbility
      ,@LowRiskOfHarmNoCurrentSuicidal=LowRiskOfHarmNoCurrentSuicidal
      ,@LowRiskOfHarmOccasionalSubstance=LowRiskOfHarmOccasionalSubstance
      ,@LowRiskOfHarmPeriodsInPast=LowRiskOfHarmPeriodsInPast
      ,@ModerateRiskOfHarmSignificant=ModerateRiskOfHarmSignificant
      ,@ModerateRiskOfHarmNoActiveSuicidal=ModerateRiskOfHarmNoActiveSuicidal
      ,@ModerateRiskOfHarmHistoryOfChronic=ModerateRiskOfHarmHistoryOfChronic
      ,@ModerateRiskOfHarmBinge=ModerateRiskOfHarmBinge
      ,@ModerateRiskOfHarmSomeEvidence=ModerateRiskOfHarmSomeEvidence
      ,@SeriousRiskOfHarmCurrentSuicidal=SeriousRiskOfHarmCurrentSuicidal
      ,@SeriousRiskOfHarmHistoryOfChronic=SeriousRiskOfHarmHistoryOfChronic
      ,@SeriousRiskOfHarmRecentPattern=SeriousRiskOfHarmRecentPattern
      ,@SeriousRiskOfHarmClearCompromise=SeriousRiskOfHarmClearCompromise
      ,@ExtremeRiskOfHarmCurrentSuicidal=ExtremeRiskOfHarmCurrentSuicidal
      ,@ExtremeRiskOfHarmWithoutExpressed=ExtremeRiskOfHarmWithoutExpressed
      ,@ExtremeRiskOfHarmWithHistory=ExtremeRiskOfHarmWithHistory
      ,@ExtremeRiskOfHarmPresenceOfCommand=ExtremeRiskOfHarmPresenceOfCommand
      ,@ExtremeRiskOfHarmRepeatedEpisodes=ExtremeRiskOfHarmRepeatedEpisodes
      ,@ExtremeRiskOfHarmExtremeCompromise=ExtremeRiskOfHarmExtremeCompromise
  FROM [dbo].[DocumentLOCUS]
  WHERE [DocumentVersionId]=@DocumentVersionId

  IF(@MinimalRiskOfHarmNoIndication='Y')
  BEGIN
	SET @ScreenScore1='1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1='0' 
  END

  IF(@MinimalRiskOfHarmClearAbility='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@LowRiskOfHarmNoCurrentSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@LowRiskOfHarmOccasionalSubstance='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@LowRiskOfHarmPeriodsInPast='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ModerateRiskOfHarmSignificant='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ModerateRiskOfHarmNoActiveSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ModerateRiskOfHarmHistoryOfChronic='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ModerateRiskOfHarmBinge='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ModerateRiskOfHarmSomeEvidence='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SeriousRiskOfHarmCurrentSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SeriousRiskOfHarmHistoryOfChronic='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SeriousRiskOfHarmRecentPattern='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SeriousRiskOfHarmClearCompromise='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ExtremeRiskOfHarmCurrentSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ExtremeRiskOfHarmWithoutExpressed='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ExtremeRiskOfHarmWithHistory='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ExtremeRiskOfHarmPresenceOfCommand='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ExtremeRiskOfHarmRepeatedEpisodes='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ExtremeRiskOfHarmExtremeCompromise='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

SET @ScreenScoreString=REPLACE(@ScreenScore1,'0','')
SET @MaskLEngth=LEN(@ScreenScoreString)
SET @ScreenScore1 = CAST(SUBSTRING(@ScreenScoreString,@MaskLEngth,1) AS INT)

UPDATE dbo.DocumentLOCUS SET RiskOfHarmScore = @ScreenScore1 WHERE DocumentVersionId=@DocumentVersionId


END
GO
