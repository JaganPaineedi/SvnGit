/****** Object:  StoredProcedure [dbo].[ssp_LabCreateResultsAndObservations]    Script Date: 12/18/2018 7:22:04 AM ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_LabCreateResultsAndObservations]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE [dbo].[ssp_LabCreateResultsAndObservations]
END
GO

/****** Object:  StoredProcedure [dbo].[ssp_LabCreateResultsAndObservations]    Script Date: 12/18/2018 7:22:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_LabCreateResultsAndObservations] @ClientOrderResultId BIGINT
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
	,@Unit VARCHAR(200) = NULL
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Nov 09, 2015  
-- Description: Create ClientOrderObservations    
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ObservationId INT
		DECLARE @ObservationDate DATETIME
		DECLARE @UserCode VARCHAR(100) = 'HL7 Lab Interface'
		DECLARE @CreatedDate DATETIME = GETDATE()

		IF LEN(@ResultDateTime) = 12
		BEGIN
			SET @ResultDateTime = @ResultDateTime + '00'
		END

		IF LEN(@CollectionDateTime) = 12
		BEGIN
			SET @CollectionDateTime = @CollectionDateTime + '00'
		END

		SELECT @ObservationId = ObservationId
		FROM Observations
		WHERE ObservationMethodIdentifier = @Identifier
			AND ISNULL(RecordDeleted, 'N') = 'N'

		PRINT @Identifier
		PRINT @ObservationId

		UPDATE Observations
		SET [Range] = @Range
			,[Unit] = Isnull(@Unit, [Unit])
			,ModifiedBy = @UserCode
			,ModifiedDate = Getdate()
		WHERE ObservationMethodIdentifier = @Identifier
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF @IsCorrected = 'Y'
			AND EXISTS (
				SELECT 1
				FROM ClientOrderObservations
				WHERE ClientOrderResultId = @ClientOrderResultId
					AND ISNULL(RecordDeleted, 'N') = 'N'
					AND ObservationId = @ObservationId
				)
		BEGIN
			UPDATE ClientOrderObservations
			SET RecordDeleted = 'Y'
				,DeletedDate = GETDATE()
				,DeletedBy = @UserCode
			WHERE ClientOrderResultId = @ClientOrderResultId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND ObservationId = @ObservationId
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
				,@CollectionDateTime
				,@ResultDateTime
				,@UserCode
				,@CreatedDate
				,@UserCode
				,@CreatedDate
				,@Range
				)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_LabCreateResultsAndObservations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

