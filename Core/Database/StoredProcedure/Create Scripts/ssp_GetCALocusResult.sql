if object_id('dbo.ssp_GetCALocusResult') IS NOT NULL 
  DROP PROCEDURE dbo.ssp_GetCALocusResult
GO

CREATE PROCEDURE dbo.ssp_GetCALocusResult
(                                                                                       
	@DocumentVersionId INT,
	@ACTPresent BIT,
	@CompletedTreatment BIT
)   
AS 

/* 
1. File: 9. ssp_GetCALocusResult.sql		
2. Name: ssp_GetCALocusResult		
3. Desc: Procedure to Insert Locus score	
4. RETURN values:None
5. Called by:   Code	
6. Parameters:DocumentVersionId ,CompletedTreatment ,ACTPresent 
*/		


/*
Date: 03/16/2016		Author:	Nandita S			Description: Procedure to Insert Locus Dimension Score
*/

BEGIN

        DECLARE @Total INT
		DECLARE @Level INT
		DECLARE @Locus INT
		DECLARE @ScreenScore1 INT
		DECLARE @ScreenScore2 INT
		DECLARE @ScreenScore3 INT
		DECLARE @ScreenScore4a INT
		DECLARE @ScreenScore4b INT
		DECLARE @ScreenScore5 INT
		DECLARE @ScreenScore6a INT
		DECLARE @ScreenScore6b INT
		DECLARE @ScreenScore6 INT
		DECLARE @Z INT

		SET @Locus=0
		SET @Total=0
		SET @Level = -1
        SET @Z = 0

		BEGIN TRY

		--Get @ScreenScore parameter
		SELECT	@ScreenScore1= [RiskOfHarmScore],
				@ScreenScore2 = [FunctionalStatusScore],
				@ScreenScore3 = [CoMorbidityScore],
				@ScreenScore4a = [RecoveryEnvironmentStressScore],
				@ScreenScore4b = [RecoveryEnvironmentSupportScore],
				@ScreenScore5 = [ResiliencyTreatmentHistoryScore],
				@ScreenScore6a = [TreatmentAcceptanceEngagementChildScore],
				@ScreenScore6b = [TreatmentAcceptanceEngagementParentScore]
		FROM dbo.DocumentCALOCUS WHERE DocumentVersionId=@DocumentVersionId

		IF @ScreenScore6a > @ScreenScore6b
		BEGIN 
			SET @ScreenScore6 =  @ScreenScore6a
		END
        ELSE
		BEGIN
			SET @ScreenScore6 =  @ScreenScore6b
		END
        

		--Calculate @Total parameter
		  If @ScreenScore1 = 2 BEGIN SET @Total = @Total + 1 END
		  If @ScreenScore2 = 2 BEGIN SET @Total = @Total + 1 END
		  If @ScreenScore3 = 2 BEGIN SET @Total = @Total + 1 END
		  If @ScreenScore4a=2 BEGIN SET @Total = @Total + 1 END
		  If @ScreenScore4b= 2 BEGIN SET @Total = @Total + 1 END
		  If @ScreenScore5 = 2 BEGIN SET @Total = @Total + 1 END
		  If @ScreenScore6 = 2 BEGIN SET @Total = @Total + 1 END

		  --Calculate @Locus parameter
		  SET @Locus=@ScreenScore1+@ScreenScore2+@ScreenScore3+@ScreenScore4a+@ScreenScore4b+@ScreenScore5+@ScreenScore6


while (@Level = -1)
	    BEGIN
			IF(@Z= 0) BEGIN IF(@Locus <= 16 AND @ScreenScore1 <= 3 AND @ScreenScore2 <= 3 AND @ScreenScore3 <= 3) BEGIN SET @Z=1 END ELSE BEGIN SET @Z=11 END END
			IF(@Z= 1) BEGIN IF(@ScreenScore1 <= 2 AND @ScreenScore2 <= 2 AND @ScreenScore3 <= 2 AND @ScreenScore4a <= 2 AND @ScreenScore4b <= 2 AND @ScreenScore5 <= 2 AND @ScreenScore6 <= 2) BEGIN SET @Z=2 end ELSE begin SET @Z=5 END END
			IF(@Z= 2) BEGIN IF(@Locus >= 14) BEGIN SET @Level = 2 END ELSE BEGIN SET @Z=3 END END
			IF(@Z= 3) BEGIN IF(@CompletedTreatment=1) BEGIN SET @Level = 0 END ELSE BEGIN SET @Z=4 END END
			IF(@Z= 4) BEGIN IF(@Locus >= 10) BEGIN SET @Level = 1 END ELSE BEGIN SET @Level = 0 END END
			IF(@Z= 5) BEGIN IF(@ScreenScore1 <= 2 AND @ScreenScore3 <= 2 AND @ScreenScore6 <= 2 AND @ScreenScore2 <= 3) BEGIN SET @Z=7 END ELSE BEGIN SET @Z=6 END END
			IF(@Z= 6) BEGIN IF((@ScreenScore4a + @ScreenScore4b) <= 4) BEGIN SET @Z=7 END ELSE BEGIN SET @Z=9 END END
			IF(@Z= 7) BEGIN IF(@ScreenScore4a >= 3 OR @ScreenScore4b >= 3 OR @ScreenScore5 >= 3) BEGIN SET @Z=8 END ELSE BEGIN SET @Z=2 END END
			IF(@Z= 8) BEGIN IF(@ScreenScore4b <= 2) BEGIN SET @Z=2 END ELSE BEGIN SET @Z=9 END END
			IF(@Z= 9) BEGIN IF(@ScreenScore5 <= 2 AND (@ScreenScore4a + @ScreenScore4b) <= 5) BEGIN SET @Z=2 END ELSE BEGIN SET @Z=10 END END
			IF(@Z= 10) BEGIN IF(@ScreenScore1 = 3 OR @ScreenScore2 = 3 OR @ScreenScore3 = 3) BEGIN SET @Level = 3 END ELSE BEGIN SET @Level = 2 END END
			IF(@Z= 11) BEGIN IF(@ScreenScore1 = 5 OR @ScreenScore2 = 5 OR @ScreenScore3 = 5) BEGIN SET @Level = 6 END ELSE BEGIN SET @Z = 12 END END
			IF(@Z= 12) BEGIN IF(@Locus >= 28) BEGIN SET @Level = 6 END ELSE BEGIN SET @Z = 13 END END
			IF(@Z= 13) BEGIN IF(@ScreenScore1 = 4) BEGIN SET @Level = 5 END ELSE BEGIN SET @Z = 14 END END
			IF(@Z= 14) BEGIN IF(@ScreenScore2 = 4 OR @ScreenScore3 = 4) BEGIN SET @Z = 15 END ELSE BEGIN SET @Z = 16 END END
			IF(@Z= 15) BEGIN IF(@ScreenScore4a = 1 AND @ScreenScore4b = 1) BEGIN SET @Z = 17 END ELSE BEGIN SET @Level = 5 END END
			IF(@Z= 16) BEGIN IF(@ScreenScore1 >= 4 OR @ScreenScore2 >= 4 OR @ScreenScore3 >= 4 OR @ScreenScore4a >= 4 OR @ScreenScore4b >= 4 OR @ScreenScore5 >= 4 OR @ScreenScore6 >= 4) BEGIN SET @Z = 17 END ELSE BEGIN SET @Z = 23 END END
			IF(@Z= 17) BEGIN IF(@ScreenScore5 >= 4 OR @ScreenScore6 >= 4) BEGIN SET @Z = 21 END ELSE BEGIN SET @Z = 18 END END
			IF(@Z= 18) BEGIN IF(@Locus >= 20 AND @Locus <= 22) BEGIN SET @Level = 4 END ELSE BEGIN SET @Z = 19 END END 
			IF(@Z= 19) BEGIN IF(@Locus >= 23) BEGIN SET @Level = 5 END ELSE BEGIN SET @Z = 20 END END
			IF(@Z= 20) BEGIN IF(@Locus >= 17) BEGIN SET @Level = 3 END ELSE BEGIN SET @Z = 2 END END
			IF(@Z= 21) BEGIN IF(@ScreenScore4a = 1 AND @ScreenScore4b = 1) BEGIN SET @Z = 18 END ELSE BEGIN SET @Z = 22 END END
			IF(@Z= 22) BEGIN IF(@ACTPresent=1 AND @ScreenScore4a <= 2) BEGIN SET @Level = 4 END ELSE BEGIN SET @Z = 18 END END
			IF(@Z= 23) BEGIN IF(@Total >= 2) BEGIN SET @Z = 24 END ELSE BEGIN SET @Z = 18 END END
			IF(@Z= 24) BEGIN IF((@ScreenScore4a + @ScreenScore4b) <= 5) BEGIN SET @Z = 20 END ELSE BEGIN SET @Z = 18 END END
			
		END

		UPDATE dbo.DocumentCALOCUS SET CALocusScore=@Level WHERE DocumentVersionId=@DocumentVersionId

		END TRY


		BEGIN CATCH
	
		DECLARE @Error varchar(8000)
		ROLLBACK TRAN 

				set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE()) 				
															+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_DeleteUnsavedChanges') 
															+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())  
															+ '*****' + Convert(varchar,ERROR_STATE())		
				RAISERROR 	(		@Error, -- Message text.		
									16, -- Severity.		
									1 -- State.	
							);
		END CATCH

END
GO
