if object_id('dbo.ssp_GetLocusScreenScore4b') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetLocusScreenScore4b
GO

CREATE PROCEDURE dbo.ssp_GetLocusScreenScore4b
(
	@DocumentVersionId INT,
	@ACTPresent BIT OUTPUT
) 
AS 

/* 
1. File: 6. ssp_GetLocusScreenScore4b.sql		
2. Name: ssp_GetLocusScreenScore4b		
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
			DECLARE @HighlySupportivePlentiful CHAR(1)					
			DECLARE @HighlySupportiveEffective CHAR(1)					
			DECLARE @SupportiveResources CHAR(1)							
			DECLARE @SupportiveSomeElements CHAR(1)						
			DECLARE @SupportiveProfessional CHAR(1)						
			DECLARE @LimitedSupportFew	 CHAR(1)						
			DECLARE @LimitedSupportUsual CHAR(1)							
			DECLARE @LimitedSupportPersons CHAR(1)						
			DECLARE @LimitedSupportResources CHAR(1)						
			DECLARE @LimitedSupportLimited CHAR(1)						
			DECLARE @MinimalSupportVeryFew	 CHAR(1)					
			DECLARE @MinimalSupportUsual CHAR(1)							
			DECLARE @MinimalSupportExisting CHAR(1)						
			DECLARE @MinimalSupportClient CHAR(1)						
			DECLARE @NoSupportSources CHAR(1)	
			DECLARE @MaskLEngth INT
			DECLARE @ScreenScoreString VARCHAR(40)


			SELECT 
			 @HighlySupportivePlentiful=HighlySupportivePlentiful
			,@HighlySupportiveEffective=HighlySupportiveEffective
			,@SupportiveResources=SupportiveResources
			,@SupportiveSomeElements=SupportiveSomeElements
			,@SupportiveProfessional=SupportiveProfessional
			,@LimitedSupportFew=LimitedSupportFew
			,@LimitedSupportUsual=LimitedSupportUsual
			,@LimitedSupportPersons=LimitedSupportPersons
			,@LimitedSupportResources=LimitedSupportResources
			,@LimitedSupportLimited=LimitedSupportLimited
			,@MinimalSupportVeryFew=MinimalSupportVeryFew
			,@MinimalSupportUsual=MinimalSupportUsual
			,@MinimalSupportExisting=MinimalSupportExisting
			,@MinimalSupportClient=MinimalSupportClient
			,@NoSupportSources=NoSupportSources
			FROM [dbo].[DocumentLOCUS]
			WHERE [DocumentVersionId]=@DocumentVersionId


			IF(@HighlySupportivePlentiful='Y')
			BEGIN
			SET @ScreenScore4b='1' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b='0' 
			END

			IF(@HighlySupportiveEffective='Y')
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

			IF(@SupportiveResources='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@SupportiveSomeElements='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@SupportiveProfessional='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'2' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

--------------------------------------------------------------------------------
			IF(@LimitedSupportFew='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@LimitedSupportUsual='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@LimitedSupportPersons='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@LimitedSupportResources='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@LimitedSupportLimited='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'3' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

--------------------------------------------------------------------------------
			IF(@MinimalSupportVeryFew='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@MinimalSupportUsual='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@MinimalSupportExisting='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

			IF(@MinimalSupportClient='Y')
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'4' 
			END
			ELSE 
			BEGIN
			SET @ScreenScore4b=@ScreenScore4b+'0' 
			END

--------------------------------------------------------------------------------
			IF(@NoSupportSources='Y')
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

UPDATE dbo.DocumentLOCUS SET RecoveryEnvironmentSupportScore  =@ScreenScore4b WHERE DocumentVersionId=@DocumentVersionId



END