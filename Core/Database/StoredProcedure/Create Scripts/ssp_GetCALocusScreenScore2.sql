IF object_id('dbo.ssp_GetCALocusScreenScore2') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusScreenScore2
GO

CREATE PROCEDURE dbo.ssp_GetCALocusScreenScore2
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 2. ssp_GetCALocusScreenScore2.sql		
2. Name: ssp_GetCALocusScreenScore2		
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
			
			DECLARE @ConsistentFunctioningAppropriate CHAR(1)
			DECLARE @NoMoreThanTemporaryImpairment CHAR(1)

			DECLARE @SomeEvidenceOfMinorFailures CHAR(1)
			DECLARE @OccasionalEpisodesInWhichSomeAspects CHAR(1)
			DECLARE @DemonstratesSignificantImprovement CHAR(1)

			DECLARE @ConflictedWithdrawnOrOtherwiseTroubled CHAR(1)
			DECLARE @SelfCareHygieneDeterioratesBelowUsual CHAR(1)
			DECLARE @SignificantDisturbancesInPhysicalFunction CHAR(1)
			DECLARE @SchoolBehaviorHasDeterioratedToPoint CHAR(1)
			DECLARE @ChronicAndOrVariablySevereDeficits CHAR(1)
			DECLARE @RecentGainsAndOrStabilizationInFunctioning CHAR(1)

			DECLARE @SeriousDeteriorationOfInterpersonal CHAR(1)
			DECLARE @SignificantWithdrawalAndAvoidance CHAR(1)
			DECLARE @ConsistentFailureToAchieveSelfCare CHAR(1)
			DECLARE @SeriousDisturbancesInPhysical CHAR(1)
			DECLARE @InabilityToPerformAdequately CHAR(1)

			DECLARE @ExtremeDeteriorationInInteractions CHAR(1)
			DECLARE @CompleteWithdrawalFromAllSocial CHAR(1)
			DECLARE @CompleteNeglectOfInability CHAR(1)
			DECLARE @ExtremeDisruptionInPhysicalFunction CHAR(1)
			DECLARE @AttendingSchoolSporadically CHAR(1)

			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)


SELECT 
@ConsistentFunctioningAppropriate	=	ConsistentFunctioningAppropriate
,@NoMoreThanTemporaryImpairment	=	NoMoreThanTemporaryImpairment
			
,@SomeEvidenceOfMinorFailures	=	SomeEvidenceOfMinorFailures
,@OccasionalEpisodesInWhichSomeAspects	=	OccasionalEpisodesInWhichSomeAspects
,@DemonstratesSignificantImprovement	=	DemonstratesSignificantImprovement
			
,@ConflictedWithdrawnOrOtherwiseTroubled	=	ConflictedWithdrawnOrOtherwiseTroubled
,@SelfCareHygieneDeterioratesBelowUsual	=	SelfCareHygieneDeterioratesBelowUsual
,@SignificantDisturbancesInPhysicalFunction	=	SignificantDisturbancesInPhysicalFunction
,@SchoolBehaviorHasDeterioratedToPoint	=	SchoolBehaviorHasDeterioratedToPoint
,@ChronicAndOrVariablySevereDeficits	=	ChronicAndOrVariablySevereDeficits
,@RecentGainsAndOrStabilizationInFunctioning	=	RecentGainsAndOrStabilizationInFunctioning
			
,@SeriousDeteriorationOfInterpersonal	=	SeriousDeteriorationOfInterpersonal
,@SignificantWithdrawalAndAvoidance	=	SignificantWithdrawalAndAvoidance
,@ConsistentFailureToAchieveSelfCare	=	ConsistentFailureToAchieveSelfCare
,@SeriousDisturbancesInPhysical	=	SeriousDisturbancesInPhysical
,@InabilityToPerformAdequately	=	InabilityToPerformAdequately
			
,@ExtremeDeteriorationInInteractions	=	ExtremeDeteriorationInInteractions
,@CompleteWithdrawalFromAllSocial	=	CompleteWithdrawalFromAllSocial
,@CompleteNeglectOfInability	=	CompleteNeglectOfInability
,@ExtremeDisruptionInPhysicalFunction	=	ExtremeDisruptionInPhysicalFunction
,@AttendingSchoolSporadically	=	AttendingSchoolSporadically
  FROM [dbo].[DocumentCALOCUS]
  WHERE [DocumentVersionId]=@DocumentVersionId

  IF(@ConsistentFunctioningAppropriate='Y')
  BEGIN
	SET @ScreenScore2='1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2='0' 
  END

  IF(@NoMoreThanTemporaryImpairment='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'1' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END
------------------------------------------------------------------------

  IF(@SomeEvidenceOfMinorFailures='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END
  
  IF(@OccasionalEpisodesInWhichSomeAspects='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@DemonstratesSignificantImprovement='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'2' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END
------------------------------------------------------------------------
  IF(@ConflictedWithdrawnOrOtherwiseTroubled='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@SelfCareHygieneDeterioratesBelowUsual='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@SignificantDisturbancesInPhysicalFunction='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@SchoolBehaviorHasDeterioratedToPoint='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@ChronicAndOrVariablySevereDeficits='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@RecentGainsAndOrStabilizationInFunctioning='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'3' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END
------------------------------------------------------------------------------------
  IF(@SeriousDeteriorationOfInterpersonal='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@SignificantWithdrawalAndAvoidance='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@ConsistentFailureToAchieveSelfCare='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@SeriousDisturbancesInPhysical='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@InabilityToPerformAdequately='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'4' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END
--------------------------------------------------------------------

  IF(@ExtremeDeteriorationInInteractions='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@CompleteWithdrawalFromAllSocial='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@CompleteNeglectOfInability='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END

  IF(@ExtremeDisruptionInPhysicalFunction='Y')
  BEGIN
	SET @ScreenScore2=@ScreenScore2+'5' 
  END
  ELSE 
  BEGIN
	 SET @ScreenScore2=@ScreenScore2+'0' 
  END


  IF(@AttendingSchoolSporadically='Y')
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

UPDATE dbo.DocumentCALOCUS SET FunctionalStatusScore = @ScreenScore2 WHERE DocumentVersionId=@DocumentVersionId


END
GO
