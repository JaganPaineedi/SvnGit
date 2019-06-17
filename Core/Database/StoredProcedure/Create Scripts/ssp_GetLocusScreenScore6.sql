if object_id('dbo.ssp_GetLocusScreenScore6') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore6
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore6
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 8. ssp_GetLocusScreenScore6.sql		
2. Name: ssp_GetLocusScreenScore6		
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
			DECLARE @OptimalEngagementComplete	CHAR(1) 
			DECLARE @OptimalEngagementActively	CHAR(1) 
			DECLARE @OptimalEngagementEnthusiastic	CHAR(1) 
			DECLARE @OptimalEngagementUnderstands	CHAR(1) 
			DECLARE @PositiveEngagementSignificant	CHAR(1) 
			DECLARE @PositiveEngagementWilling	CHAR(1) 
			DECLARE @PositiveEngagementPositive	CHAR(1) 
			DECLARE @PositiveEngagementShows	CHAR(1) 
			DECLARE @LimitedEngagementSomeVariability	CHAR(1) 
			DECLARE @LimitedEngagementLimitedDesire	CHAR(1) 
			DECLARE @LimitedEngagementRelatesToTreatment	CHAR(1) 
			DECLARE @LimitedEngagementNotUseResources	CHAR(1) 
			DECLARE @LimitedEngagementLimitedAbility	CHAR(1) 
			DECLARE @MinimalEngagementRarely	CHAR(1) 
			DECLARE @MinimalEngagementNoDesire	CHAR(1) 
			DECLARE @MinimalEngagementRelatesPoorly	CHAR(1) 
			DECLARE @MinimalEngagementAvoidsContact	CHAR(1) 
			DECLARE @MinimalEngagementNotAccept	CHAR(1) 
			DECLARE @UnengagedNoAwareness	CHAR(1) 
			DECLARE @UnengagedInability	CHAR(1) 
			DECLARE @UnengagedUnable	CHAR(1) 
			DECLARE @UnengagedExtremely	CHAR(1)
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)

			SELECT 
			   @OptimalEngagementComplete=OptimalEngagementComplete
			  ,@OptimalEngagementActively=OptimalEngagementActively
			  ,@OptimalEngagementEnthusiastic=OptimalEngagementEnthusiastic
			  ,@OptimalEngagementUnderstands=OptimalEngagementUnderstands
			  ,@PositiveEngagementSignificant=PositiveEngagementSignificant
			  ,@PositiveEngagementWilling=PositiveEngagementWilling
			  ,@PositiveEngagementPositive=PositiveEngagementPositive
			  ,@PositiveEngagementShows=PositiveEngagementShows
			  ,@LimitedEngagementSomeVariability=LimitedEngagementSomeVariability
			  ,@LimitedEngagementLimitedDesire=LimitedEngagementLimitedDesire
			  ,@LimitedEngagementRelatesToTreatment=LimitedEngagementRelatesToTreatment
			  ,@LimitedEngagementNotUseResources=LimitedEngagementNotUseResources
			  ,@LimitedEngagementLimitedAbility=LimitedEngagementLimitedAbility
			  ,@MinimalEngagementRarely=MinimalEngagementRarely
			  ,@MinimalEngagementNoDesire=MinimalEngagementNoDesire
			  ,@MinimalEngagementRelatesPoorly=MinimalEngagementRelatesPoorly
			  ,@MinimalEngagementAvoidsContact=MinimalEngagementAvoidsContact
			  ,@MinimalEngagementNotAccept=MinimalEngagementNotAccept
			  ,@UnengagedNoAwareness=UnengagedNoAwareness
			  ,@UnengagedInability=UnengagedInability
			  ,@UnengagedUnable=UnengagedUnable
			  ,@UnengagedExtremely=UnengagedExtremely
			FROM [dbo].[DocumentLOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@OptimalEngagementComplete ='Y')
			BEGIN
			SET @ScreenScore6='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6='0' 
			END

			IF(@OptimalEngagementActively ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@OptimalEngagementEnthusiastic ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@OptimalEngagementUnderstands ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------

			IF(@PositiveEngagementSignificant ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@PositiveEngagementWilling ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@PositiveEngagementPositive ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@PositiveEngagementShows='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@LimitedEngagementSomeVariability ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@LimitedEngagementLimitedDesire ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@LimitedEngagementRelatesToTreatment ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@LimitedEngagementNotUseResources ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@LimitedEngagementLimitedAbility='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@MinimalEngagementRarely ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@MinimalEngagementNoDesire ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@MinimalEngagementRelatesPoorly ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@MinimalEngagementAvoidsContact ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@MinimalEngagementNotAccept='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

--------------------------------------------------------------------------------
			IF(@UnengagedNoAwareness ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnengagedInability ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnengagedUnable ='Y')
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'5' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore6=@ScreenScore6+'0' 
			END

			IF(@UnengagedExtremely='Y')
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


UPDATE dbo.DocumentLOCUS SET EngagementScore =@ScreenScore6 WHERE DocumentVersionId=@DocumentVersionId


END