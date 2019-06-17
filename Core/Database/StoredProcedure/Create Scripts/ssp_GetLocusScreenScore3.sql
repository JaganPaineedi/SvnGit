if object_id('dbo.ssp_GetLocusScreenScore3') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore3
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore3
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 4. ssp_GetLocusScreenScore3.sql		
2. Name: ssp_GetLocusScreenScore3		
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
			DECLARE @NoComorbidityNoEvidence CHAR(1)
			DECLARE @NoComorbidityAnyIllnesses CHAR(1)
			DECLARE @MinorComorbidityExistence	 CHAR(1)
			DECLARE @MinorComorbidityOccasional	 CHAR(1)
			DECLARE @MinorComorbidityMayOccasionally CHAR(1)
			DECLARE @SignificantComorbidityPotential CHAR(1)
			DECLARE @SignificantComorbidityCreated CHAR(1)
			DECLARE @SignificantComorbidityAdversely CHAR(1)
			DECLARE @SignificantComorbidityOngoing CHAR(1)
			DECLARE @SignificantComorbidityRecentSubstance CHAR(1)
			DECLARE @SignificantComorbiditySignificant CHAR(1)
			DECLARE @MajorComorbidityHighLikelihood CHAR(1)
			DECLARE @MajorComorbidityExistence CHAR(1)
			DECLARE @MajorComorbidityOutcome CHAR(1)
			DECLARE @MajorComorbidityUncontrolled CHAR(1)
			DECLARE @MajorComorbidityPsychiatric CHAR(1)					
			DECLARE @SevereComorbiditySignificant CHAR(1)				
			DECLARE @SevereComorbidityPresence CHAR(1)					
			DECLARE @SevereComorbidityUncontrolled CHAR(1)				
			DECLARE @SevereComorbiditySerereSubstance CHAR(1)			
			DECLARE @SevereComorbidityAcute CHAR(1)	
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)

			SELECT 
			  @NoComorbidityNoEvidence=NoComorbidityNoEvidence
			  ,@NoComorbidityAnyIllnesses=NoComorbidityAnyIllnesses
			  ,@MinorComorbidityExistence=MinorComorbidityExistence
			  ,@MinorComorbidityOccasional=MinorComorbidityOccasional
			  ,@MinorComorbidityMayOccasionally=MinorComorbidityMayOccasionally
			  ,@SignificantComorbidityPotential=SignificantComorbidityPotential
			  ,@SignificantComorbidityCreated=SignificantComorbidityCreated
			  ,@SignificantComorbidityAdversely=SignificantComorbidityAdversely
			  ,@SignificantComorbidityOngoing=SignificantComorbidityOngoing
			  ,@SignificantComorbidityRecentSubstance=SignificantComorbidityRecentSubstance
			  ,@SignificantComorbiditySignificant=SignificantComorbiditySignificant
			  ,@MajorComorbidityHighLikelihood=MajorComorbidityHighLikelihood
			  ,@MajorComorbidityExistence=MajorComorbidityExistence
			  ,@MajorComorbidityOutcome=MajorComorbidityOutcome
			  ,@MajorComorbidityUncontrolled=MajorComorbidityUncontrolled
			  ,@MajorComorbidityPsychiatric=MajorComorbidityPsychiatric
			  ,@SevereComorbiditySignificant=SevereComorbiditySignificant
			  ,@SevereComorbidityPresence=SevereComorbidityPresence
			  ,@SevereComorbidityUncontrolled=SevereComorbidityUncontrolled
			  ,@SevereComorbiditySerereSubstance=SevereComorbiditySerereSubstance
			  ,@SevereComorbidityAcute=SevereComorbidityAcute
				FROM [dbo].[DocumentLOCUS]
				WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@NoComorbidityNoEvidence='Y')
			BEGIN
			SET @ScreenScore3='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3='0' 
			END

			IF(@NoComorbidityAnyIllnesses='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MinorComorbidityExistence='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MinorComorbidityOccasional='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MinorComorbidityMayOccasionally='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SignificantComorbidityPotential='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SignificantComorbidityCreated='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SignificantComorbidityAdversely='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SignificantComorbidityOngoing='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SignificantComorbidityRecentSubstance='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SignificantComorbiditySignificant='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MajorComorbidityHighLikelihood='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MajorComorbidityExistence='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MajorComorbidityOutcome='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MajorComorbidityUncontrolled='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@MajorComorbidityPsychiatric='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SevereComorbiditySignificant='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SevereComorbidityPresence='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SevereComorbidityUncontrolled='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SevereComorbiditySerereSubstance='Y')
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore3=@ScreenScore3+'0' 
			END

			IF(@SevereComorbidityAcute='Y')
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

UPDATE dbo.DocumentLOCUS SET MedicalAddictiveScore =@ScreenScore3 WHERE DocumentVersionId=@DocumentVersionId

END