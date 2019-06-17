/****** Object:  StoredProcedure [dbo].[SSP_CreateClientOrderResultsAndObservations]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_CreateClientOrderResultsAndObservations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_CreateClientOrderResultsAndObservations]
GO

/****** Object:  StoredProcedure [dbo].[SSP_CreateClientOrderResultsAndObservations]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_CreateClientOrderResultsAndObservations] @ClientOrderResultId BIGINT
	,@Identifier VARCHAR(MAX)
	,@value VARCHAR(MAX)
	,@ClientId INT 
	,@LoincCode VARCHAR(100)
	,@ResultDateTime VARCHAR(MAX)
	,@CollectionDateTime VARCHAR(MAX)
	,@Range VARCHAR(MAX)
	,@Flag VARCHAR(MAX)
	,@Comment VARCHAR(MAX)
	,@IsCorrected type_YOrN
	,@ResultStatus INT
	,@LabSoftMessageId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Nov 09, 2015  
-- Description: Create ClientOrderObservations    
/*      
 Author			Modified Date			Reason      
 Pradeep		     Nov 03 2017		     What: Added ObservationRange column for inserting Range value. Previous implementation was in Observations table
								     Why:  AP-SGL #530.1
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ObservationId INT
		DECLARE @ObservationDate DATETIME
        DECLARE @CreatedBy VARCHAR(100) = 'CreateUnsolicitedOrders'
		DECLARE @CreatedDate DATETIME =GETDATE()
		
        IF LEN(@ResultDateTime) = 12
        BEGIN        
            SET @ResultDateTime = @ResultDateTime + '00'
        END
		
		SELECT @ObservationId = ObservationId
		FROM Observations
		WHERE ObservationMethodIdentifier = @Identifier
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF @IsCorrected = 'Y'
			AND EXISTS (
				SELECT 1
				FROM ClientOrderObservations
				WHERE ClientOrderResultId = @ClientOrderResultId
					AND STATUS != 8750
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			UPDATE ClientOrderObservations
			SET RecordDeleted = 'Y'
				,DeletedDate = GETDATE()
				,DeletedBy = 'CorrectionProcess'
			WHERE ClientOrderResultId = @ClientOrderResultId
				AND STATUS != 8750
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END
        
        
		IF @ObservationId >= 0
		BEGIN
			INSERT INTO ClientOrderObservations (
				ClientOrderResultId
				,ObservationId
				,Value
				,Comment
				,Flag
				,FlagText
				,STATUS
				,ObservationDateTime
				,AnalysisDateTime
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,ObservationRange
				)
			VALUES (
				@ClientOrderResultId
				,@ObservationId
				,@value
				,@Comment
				,@Flag
				,@Flag
				,@ResultStatus
				,@ResultDateTime
				,@ResultDateTime
				,@CreatedBy
				,@CreatedDate
				,@CreatedBy
				,@CreatedDate
				,@Range
				)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_CreateClientOrderResultsAndObservations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END
GO


