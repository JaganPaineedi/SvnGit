IF object_id('dbo.ssp_CalculateLOCUSDimensionScore') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_CalculateLOCUSDimensionScore
GO

CREATE PROCEDURE dbo.ssp_CalculateLOCUSDimensionScore
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 1. ssp_CalculateLOCUSDimensionScore.sql		
2. Name: ssp_CalculateLOCUSDimensionScore		
3. Desc: Procedure to Calculate Locus Dimension Score and result description and return the result sets	
4. RETURN values:Returns the LocusTestId	
5. Called by: Code		
6. Parameters:DocumentVersionId
*/		


/*
Date: 04/05/2016		Author:	Nandita S			Procedure to Calculate Locus Dimension Score and result description and return the Resultsets	
*/

BEGIN

	DECLARE @ScreenScore1 VARCHAR(50)
	DECLARE @ScreenScore2 VARCHAR(50)
	DECLARE @ScreenScore3 VARCHAR(50)
	DECLARE @ScreenScore4a VARCHAR(50)
	DECLARE @ScreenScore4b VARCHAR(50)
	DECLARE @ScreenScore5 VARCHAR(50)
	DECLARE @ScreenScore6 VARCHAR(50)
	DECLARE @CompletedTreatment BIT
    DECLARE @ACTPresent BIT
    DECLARE @SQL NVARCHAR(200)
	DECLARE @LocusScoreString NVARCHAR(5)
    
	EXEC ssp_GetLocusScreenScore1 @DocumentVersionId
	EXEC ssp_GetLocusScreenScore2 @DocumentVersionId
	EXEC ssp_GetLocusScreenScore3 @DocumentVersionId
	EXEC ssp_GetLocusScreenScore4a @DocumentVersionId
	EXEC ssp_GetLocusScreenScore4b @DocumentVersionId,@ACTPresent OUTPUT
	EXEC ssp_GetLocusScreenScore5 @DocumentVersionId,@CompletedTreatment OUTPUT
	EXEC ssp_GetLocusScreenScore6 @DocumentVersionId

	EXEC ssp_GetLocusResult @DocumentVersionId, @ACTPresent,@CompletedTreatment
	
	--SELECT  @LocusScoreString=CAST(CAST(LocusScore AS INT) AS NVARCHAR(5)) FROM dbo.DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId

	--SET @SQL='SELECT CodeName from dbo.GlobalCodes WHERE Category=''LOCUSLEVEL'' AND IsNull(RecordDeleted,''N'')<>''Y'' AND Active=''Y'' AND ExternalCode1='+''''+@LocusScoreString+''''

	--EXECUTE(@SQL)

	--SELECT RiskOfHarmScore,FunctionalStatusScore,MedicalAddictiveScore,RecoveryEnvironmentStressScore,
	--RecoveryEnvironmentSupportScore,TreatmentRecoveryScore,EngagementScore
	--FROM dbo.DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId

    
END
GO
