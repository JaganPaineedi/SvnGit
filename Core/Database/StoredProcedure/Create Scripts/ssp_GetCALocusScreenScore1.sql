IF object_id('dbo.ssp_GetCALocusScreenScore1') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore1
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore1
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 2. ssp_GetCALocusScreenScore1.sql		
2. Name: ssp_GetCALocusScreenScore1		
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
			
			DECLARE	@NoIndicationCurrSuicidal CHAR(1)
			DECLARE	@NoINdicationOfAggression CHAR(1)
			DECLARE	@DevelopmentallyAppropriateAbility CHAR(1)
			DECLARE	@LowRiskVictimization CHAR(1)

			DECLARE	@PastHistoryFleetingSuicidal CHAR(1)
			DECLARE	@MildSuicidalIdeation CHAR(1)
			DECLARE	@IndicationOrReport CHAR(1)
			DECLARE	@SubstanceUse CHAR(1)
			DECLARE	@InfrequentBriefLapses CHAR(1)
			DECLARE	@SomeRiskForVictimization CHAR(1)

			DECLARE	@SignificantCurrentSuicidal CHAR(1)
			DECLARE	@NoActiveSuicidal CHAR(1)
			DECLARE	@IndicationOrReportOfIncidentsActing CHAR(1)
			DECLARE	@BingeOrExcessiveUse CHAR(1)
			DECLARE	@PeriodsOfInabilityToCare CHAR(1)
			DECLARE	@SignificantRiskForVictimization CHAR(1)

			DECLARE	@CurrentSuicidalOrHomicidalIdeation CHAR(1)
			DECLARE	@IndicationOrReportOfSignificantImpulsivity CHAR(1)
			DECLARE	@SignsOfConsistentDeficits CHAR(1)
			DECLARE	@RecentPatternOfExcessiveSubstance  CHAR(1)
			DECLARE	@ClearAndPersistentInability CHAR(1)
			DECLARE	@ImminentRiskOfSevereVictimization CHAR(1)

			DECLARE	@CurrentSuicidalOrHomicidalBehavior CHAR(1)
			DECLARE	@withoutExpressedAmbivalence CHAR(1)
			DECLARE	@WithAHistoryOfSeriousPast CHAR(1)
			DECLARE	@InPresenceOfCommandHalucination CHAR(1)
			DECLARE	@IndicationOrReportOfRepeatedBehavior CHAR(1)
			DECLARE	@RelentlesslyEngagingInAcutely CHAR(1)
			DECLARE	@APatternOfNearlyConstant CHAR(1)

			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)


SELECT 
@NoIndicationCurrSuicidal = NoIndicationCurrentSuicidal 
,@NoINdicationOfAggression=NoINdicationOfAggression
,@DevelopmentallyAppropriateAbility=DevelopmentallyAppropriateAbility
,@LowRiskVictimization=LowRiskVictimization

,@PastHistoryFleetingSuicidal=PastHistoryFleetingSuicidal
,@MildSuicidalIdeation=MildSuicidalIdeation
,@IndicationOrReport=IndicationOrReport
,@SubstanceUse=SubstanceUse
,@InfrequentBriefLapses=InfrequentBriefLapses
,@SomeRiskForVictimization=SomeRiskForVictimization

,@SignificantCurrentSuicidal=SignificantCurrentSuicidal
,@NoActiveSuicidal=NoActiveSuicidal
,@IndicationOrReportOfIncidentsActing=IndicationOrReportOfIncidentsActing
,@BingeOrExcessiveUse=BingeOrExcessiveUse
,@PeriodsOfInabilityToCare=PeriodsOfInabilityToCare
,@SignificantRiskForVictimization=SignificantRiskForVictimization

,@CurrentSuicidalOrHomicidalIdeation=CurrentSuicidalOrHomicidalIdeation
,@IndicationOrReportOfSignificantImpulsivity=IndicationOrReportOfSignificantImpulsivity
,@SignsOfConsistentDeficits=SignsOfConsistentDeficits
,@RecentPatternOfExcessiveSubstance=RecentPatternOfExcessiveSubstance
,@ClearAndPersistentInability=ClearAndPersistentInability
,@ImminentRiskOfSevereVictimization=ImminentRiskOfSevereVictimization

,@CurrentSuicidalOrHomicidalBehavior=CurrentSuicidalOrHomicidalBehavior
,@withoutExpressedAmbivalence=withoutExpressedAmbivalence
,@WithAHistoryOfSeriousPast=WithAHistoryOfSeriousPast
,@InPresenceOfCommandHalucination=InPresenceOfCommandHalucination
,@IndicationOrReportOfRepeatedBehavior=IndicationOrReportOfRepeatedBehavior
,@RelentlesslyEngagingInAcutely=RelentlesslyEngagingInAcutely
,@APatternOfNearlyConstant=APatternOfNearlyConstant
  FROM [dbo].[DocumentCALOCUS]
  WHERE [DocumentVersionId]=@DocumentVersionId

  IF(@NoIndicationCurrSuicidal='Y')
  BEGIN
	SET @ScreenScore1='1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1='0' 
  END

  IF(@NoINdicationOfAggression='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@DevelopmentallyAppropriateAbility='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@LowRiskVictimization='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END
---------------------------------------------------------------------------------

  IF(@PastHistoryFleetingSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@MildSuicidalIdeation='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@IndicationOrReport='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SubstanceUse='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@InfrequentBriefLapses='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SomeRiskForVictimization='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END
---------------------------------------------------------------------------------

  IF(@SignificantCurrentSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@NoActiveSuicidal='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@IndicationOrReportOfIncidentsActing='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END
  
  IF(@BingeOrExcessiveUse='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@PeriodsOfInabilityToCare='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SignificantRiskForVictimization='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

---------------------------------------------------------------------------------
  IF(@CurrentSuicidalOrHomicidalIdeation='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@IndicationOrReportOfSignificantImpulsivity='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@SignsOfConsistentDeficits='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@RecentPatternOfExcessiveSubstance='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ClearAndPersistentInability='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@ImminentRiskOfSevereVictimization='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

---------------------------------------------------------------------------------
  IF(@CurrentSuicidalOrHomicidalBehavior='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@withoutExpressedAmbivalence='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@WithAHistoryOfSeriousPast='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@InPresenceOfCommandHalucination='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@IndicationOrReportOfRepeatedBehavior='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@RelentlesslyEngagingInAcutely='Y')
  BEGIN
	SET @ScreenScore1=@ScreenScore1+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore1=@ScreenScore1+'0' 
  END

  IF(@APatternOfNearlyConstant='Y')
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

UPDATE dbo.DocumentCALOCUS SET RiskOfHarmScore = @ScreenScore1 WHERE DocumentVersionId=@DocumentVersionId


END
GO
