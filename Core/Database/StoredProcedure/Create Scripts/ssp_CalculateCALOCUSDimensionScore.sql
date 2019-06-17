IF object_id('dbo.ssp_CalculateCALOCUSDimensionScore') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_CalculateCALOCUSDimensionScore
GO

CREATE PROCEDURE dbo.ssp_CalculateCALOCUSDimensionScore
(
	@DocumentVersionId INT
) 
AS 

/* 
1. File: 1. ssp_CalculateCALOCUSDimensionScore.sql		
2. Name: ssp_CalculateCALOCUSDimensionScore		
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
	DECLARE @ScreenScore6a VARCHAR(50)
	DECLARE @ScreenScore6b VARCHAR(50)
	DECLARE @CompletedTreatment BIT
    DECLARE @ACTPresent BIT
    DECLARE @SQL NVARCHAR(200)
	DECLARE @CALocusScoreString NVARCHAR(5)
    
	EXEC ssp_GetCALocusScreenScore1 @DocumentVersionId
	EXEC ssp_GetCALocusScreenScore2 @DocumentVersionId
	EXEC ssp_GetCALocusScreenScore3 @DocumentVersionId
	EXEC ssp_GetCALocusScreenScore4a @DocumentVersionId
	EXEC ssp_GetCALocusScreenScore4b @DocumentVersionId,@ACTPresent OUTPUT
	EXEC ssp_GetCALocusScreenScore5 @DocumentVersionId,@CompletedTreatment OUTPUT
	EXEC ssp_GetCALocusScreenScore6a @DocumentVersionId
	EXEC ssp_GetCALocusScreenScore6b @DocumentVersionId

	EXEC ssp_GetCALocusResult @DocumentVersionId, @ACTPresent,@CompletedTreatment
	
	--SELECT  @CALocusScoreString=CAST(CAST(LocusScore AS INT) AS NVARCHAR(5)) FROM dbo.DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId

	--SET @SQL='SELECT CodeName from dbo.GlobalCodes WHERE Category=''LOCUSLEVEL'' AND IsNull(RecordDeleted,''N'')<>''Y'' AND Active=''Y'' AND ExternalCode1='+''''+@CALocusScoreString+''''

	--EXECUTE(@SQL)

	--SELECT RiskOfHarmScore,FunctionalStatusScore,MedicalAddictiveScore,RecoveryEnvironmentStressScore,
	--RecoveryEnvironmentSupportScore,TreatmentRecoveryScore,EngagementScore
	--FROM dbo.DocumentLOCUS WHERE DocumentVersionId=@DocumentVersionId

    
END
GO
