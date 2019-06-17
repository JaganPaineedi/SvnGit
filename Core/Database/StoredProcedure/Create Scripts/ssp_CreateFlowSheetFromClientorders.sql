/****** Object:  StoredProcedure [dbo].[ssp_CreateFlowSheetFromClientorders]    Script Date: 13/12/2016 01:57:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateFlowSheetFromClientorders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CreateFlowSheetFromClientorders]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_CreateFlowSheetFromClientorders     */                        
/* Creation Date:  13/Dec/2016                                        */                        
/* Author: Chethan N                                                                  */                        
/* Purpose: To Create Flow Sheet  
                  */                       
/*                                                                   */                      
/* Input Parameters:             */                      
/*                                                                   */                        
/* Output Parameters:             */                        
/*                                                                   */                        
/*  Date                  Author                 Purpose             */                 
/*********************************************************************/   
CREATE Procedure [dbo].[ssp_CreateFlowSheetFromClientorders]  
   @ClientOrderId INT
AS  
BEGIN  
BEGIN TRY  
   
	DECLARE @HealthDataAttributeId INT
	DECLARE @value NVARCHAR(MAX)
	DECLARE @ClientId INT
	DECLARE @ResultDateTime VARCHAR(MAX)
	DECLARE @HealthDataSubTemplateId INT
	DECLARE @HealthDataTemplateId INT
	DECLARE @UserCode VARCHAR(50)
	DECLARE @ClientOrderResultId INT
	DECLARE @ClientHealthDataAttributeId INT

	CREATE TABLE #TempClientHealthDataAttributes( ClientHealthDataAttributeId INT)

	DECLARE ClientHealthDataAttributesResults CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT COR.ClientOrderResultId
		,HDA.HealthDataAttributeId
		,COO.Value
		,CO.ClientId
		,COR.ResultDateTime
		,HDST.HealthDataSubTemplateId
		,HDT.HealthDataTemplateId
		,COO.ModifiedBy
	FROM ClientOrderResults COR
	INNER JOIN ClientOrderObservations COO ON COO.ClientOrderResultId = COR.ClientOrderResultId
		AND ISNULL(COO.RecordDeleted, 'N') = 'N'
	INNER JOIN Observations OB ON OB.ObservationId = COO.ObservationId
		AND ISNULL(OB.RecordDeleted, 'N') = 'N'
	INNER JOIN HealthDataAttributes HDA ON OB.ObservationMethodIdentifier = HDA.LoincCode
		AND OB.ObservationName = HDA.NAME
		AND ISNULL(HDA.RecordDeleted, 'N') = 'N'
	INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
		AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'
	INNER JOIN HealthDataSubTemplates HDST ON HDSTA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId
		AND ISNULL(HDST.RecordDeleted, 'N') = 'N'
	INNER JOIN HealthDataTemplateAttributes HDTA ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
		AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'
	INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId
		AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
	--JOIN Orders O ON HDT.HealthDataTemplateId = O.LabId  
	INNER JOIN ClientOrders CO ON COR.ClientOrderId = CO.ClientOrderId
	--JOIN ClientHealthDataAttributes CHDA ON HDA.HealthDataAttributeId = CHDA.HealthDataAttributeId 
	--AND CHDA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId AND CHDA.HealthDataTemplateId = HDT.HealthDataTemplateId 
	--AND CHDA.HealthRecordDate = COR.ResultDateTime AND ISNULL(CHDA.RecordDeleted,'N') = 'N'
	WHERE COR.ClientOrderId = @ClientOrderId
		AND ISNULL(COR.RecordDeleted, 'N') = 'N'
	ORder BY COR.ClientOrderResultId

	OPEN ClientHealthDataAttributesResults

	FETCH NEXT
	FROM ClientHealthDataAttributesResults
	INTO @ClientOrderResultId
		,@HealthDataAttributeId
		,@value
		,@ClientId
		,@ResultDateTime
		,@HealthDataSubTemplateId
		,@HealthDataTemplateId
		,@UserCode

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM ClientHealthDataAttributes CHDA
				WHERE CHDA.HealthDataAttributeId = @HealthDataAttributeId
					AND CHDA.HealthDataSubTemplateId = @HealthDataSubTemplateId
					AND CHDA.HealthRecordDate = @ResultDateTime
					AND CHDA.ClientId = @ClientId
					AND CHDA.HealthDataTemplateId = @HealthDataTemplateId
				)
		BEGIN
			--Print 'IF'
			IF NOT EXISTS (
					SELECT 1
					FROM ClientHealthDataAttributes CHDA
					WHERE CHDA.HealthDataAttributeId = @HealthDataAttributeId
						AND CHDA.HealthDataSubTemplateId = @HealthDataSubTemplateId
						AND CHDA.HealthRecordDate = @ResultDateTime
						AND CHDA.ClientId = @ClientId
						AND CHDA.HealthDataTemplateId = @HealthDataTemplateId
						AND Value = @value
					)
			BEGIN
				UPDATE ClientHealthDataAttributes
				SET Value = @value
					,ModifiedDate = GETDATE()
					,ModifiedBy = @UserCode
				WHERE HealthDataAttributeId = @HealthDataAttributeId
					AND HealthDataSubTemplateId = @HealthDataSubTemplateId
					AND HealthRecordDate = @ResultDateTime
					AND ClientId = @ClientId
					AND HealthDataTemplateId = @HealthDataTemplateId
			END
		END
		ELSE
		BEGIN
			--Print 'Else'
			INSERT INTO ClientHealthDataAttributes (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,HealthDataAttributeId
				,Value
				,ClientId
				,HealthRecordDate
				,HealthDataSubTemplateId
				,SubTemplateCompleted
				,HealthDataTemplateId
				)
			VALUES (
				@UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,@HealthDataAttributeId
				,@value
				,@ClientId
				,@ResultDateTime
				,@HealthDataSubTemplateId
				,'N'
				,@HealthDataTemplateId
				)

				SET @ClientHealthDataAttributeId = SCOPE_IDENTITY()

				IF (@ClientHealthDataAttributeId > 0)
				BEGIN
					INSERT INTO OrderResultsClientHealthDataAttributesMapping (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,ClientOrderResultId
						,ClientHealthDataAttributeId
						,ResultDateTime
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@ClientOrderResultId
						,@ClientHealthDataAttributeId
						,@ResultDateTime
						)
				END

		END

		FETCH NEXT
		FROM ClientHealthDataAttributesResults
		INTO @ClientOrderResultId
			,@HealthDataAttributeId
			,@value
			,@ClientId
			,@ResultDateTime
			,@HealthDataSubTemplateId
			,@HealthDataTemplateId
			,@UserCode
	END

	-- ==============================================	
	CLOSE ClientHealthDataAttributesResults

	DEALLOCATE ClientHealthDataAttributesResults

	--- To delete the Existing Flow sheet entries if new entries are created due to the change in Client order Result Date time
	INSERT INTO #TempClientHealthDataAttributes
	SELECT CORCHDM.ClientHealthDataAttributeId
	FROM ClientOrderResults COR
	INNER JOIN OrderResultsClientHealthDataAttributesMapping CORCHDM ON COR.ClientOrderResultId = CORCHDM.ClientOrderResultId
		AND COR.ResultDateTime <> CORCHDM.ResultDateTime AND ISNULL(CORCHDM.RecordDeleted, 'N') = 'N'
	WHERE COR.ClientOrderId = @ClientOrderId
		AND ISNULL(COR.RecordDeleted, 'N') = 'N'

	UPDATE CHDA
	SET CHDA.RecordDeleted = 'Y'
		,CHDA.DeletedBy = @UserCode
		,CHDA.DeletedDate = GETDATE()
	FROM ClientHealthDataAttributes CHDA
	JOIN #TempClientHealthDataAttributes TCHDA ON TCHDA.ClientHealthDataAttributeId = CHDA.ClientHealthDataAttributeId 
	WHERE ISNULL(CHDA.RecordDeleted,'N') = 'N'

	UPDATE CORCHDM
	SET	CORCHDM.RecordDeleted = 'Y'
		,CORCHDM.DeletedBy = @UserCode
		,CORCHDM.DeletedDate = GETDATE()
	FROM OrderResultsClientHealthDataAttributesMapping CORCHDM
	JOIN #TempClientHealthDataAttributes TCHDA ON TCHDA.ClientHealthDataAttributeId = CORCHDM.ClientHealthDataAttributeId 
	WHERE ISNULL(CORCHDM.RecordDeleted,'N') = 'N'
   
   DROP TABLE #TempClientHealthDataAttributes

   END TRY                
 BEGIN CATCH              
  DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_CreateFlowSheetFromClientorders') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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
