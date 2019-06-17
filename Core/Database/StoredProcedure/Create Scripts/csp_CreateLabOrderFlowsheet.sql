/****** Object:  StoredProcedure [dbo].[csp_CreateLabOrderFlowsheet]    Script Date: 04/12/2016 14:46:39 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateLabOrderFlowsheet]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_CreateLabOrderFlowsheet]
GO

/****** Object:  StoredProcedure [dbo].[csp_CreateLabOrderFlowsheet]    Script Date: 04/12/2016 14:46:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_CreateLabOrderFlowsheet] @Identifier NVARCHAR(MAX)
	,@Value NVARCHAR(MAX)
	,@ClientId INT
	,@LoincCode NVARCHAR(100)
	,@ResultDateTime VARCHAR(MAX)
	,@CollectionDateTime VARCHAR(MAX)
	,@Range NVARCHAR(MAX)
	,@Flag NVARCHAR(MAX)
	,@Comment NVARCHAR(MAX)
	,@IsCorrected type_YorN
	,@ResultStatus INT
	,@LabSoftMessageId INT
AS -- =============================================
-- Author:		Pradeep
-- Create date: Feb 12 2014
-- Description:	This maps the OBX segment to Flowsheet
-- =============================================
BEGIN
	BEGIN TRY
		DECLARE @Error VARCHAR(8000)
		DECLARE @HealthDataTempleteId INT
		DECLARE @HealthDataSubTemplateId INT
		DECLARE @HealthDataAttributeId INT
		DECLARE @HealthDataRangeAttributeId INT
		DECLARE @HealthDataFlagAttributeId INT
		DECLARE @HealthDataCommentAttributeId INT
		DECLARE @UserCode type_currentUser
		DECLARE @ClientHealthDataAttributeId INT
		DECLARE @EntityType INT
		DECLARE @EntityId INT

		SET @UserCode = CURRENT_USER

		-- Read HealthDataTempleteId
		SELECT @HealthDataTempleteId = HDT.HealthDataTemplateId
		FROM HealthDataTemplates HDT
		INNER JOIN Orders O ON O.LabId = HDT.HealthDataTemplateId
		INNER JOIN OrderLabs OL ON OL.OrderId = O.OrderId
		WHERE OL.ExternalOrderId = @LoincCode
			AND HDT.Active = 'Y'
			AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
			AND ISNULL(OL.RecordDeleted, 'N') = 'N'

		-- Loop through the HealthDataTemplateAttributes to find the Attributes related to Sub template.
		-- Read HealthDataSubTemplateId
		DECLARE Subtemplates CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT HealthDataSubTemplateId
		FROM HealthDataTemplateAttributes HDTA
		WHERE HealthDataTemplateId = @HealthDataTempleteId
			AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'

		OPEN Subtemplates

		WHILE 1 = 1
		BEGIN
			FETCH Subtemplates
			INTO @HealthDataSubTemplateId

			IF @@fetch_status <> 0
				BREAK

			-- ========================================================================================
			-- Match the Observation Identifier with HealthDataAttributes.LoincCode Or AlternateName1 OR
			-- AlternateName2 OR AlternateName3 OR AlternateName4 OR AlternateName5 OR AlternateName6
			IF (
					EXISTS (
						SELECT 1
						FROM HealthDataAttributes HDA
						INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
						WHERE ISNULL(HDA.RecordDeleted, 'N') = 'N'
							AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'
							AND HDSTA.HealthDataSubTemplateId = @HealthDataSubTemplateId
							AND (
								HDA.LoincCode IN (@Identifier)
								OR HDA.AlternativeName1 = @Identifier
								OR HDA.AlternativeName2 = @Identifier
								OR HDA.AlternativeName3 = @Identifier
								OR HDA.AlternativeName4 = @Identifier
								OR HDA.AlternativeName5 = @Identifier
								OR HDA.AlternativeName5 = @Identifier
								)
						)
					)
			BEGIN
				--Read HealthDataAttributeId			
				SELECT @HealthDataAttributeId = HDSTA.HealthDataAttributeId
				FROM HealthDataAttributes HDA
				INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
				WHERE ISNULL(HDA.RecordDeleted, 'N') = 'N'
					AND ISNULL(HDSTA.RecordDeleted, 'N') = 'N'
					AND HDSTA.HealthDataSubTemplateId = @HealthDataSubTemplateId
					AND (
						HDA.LoincCode IN (@Identifier)
						OR HDA.AlternativeName1 = @Identifier
						OR HDA.AlternativeName2 = @Identifier
						OR HDA.AlternativeName3 = @Identifier
						OR HDA.AlternativeName4 = @Identifier
						OR HDA.AlternativeName5 = @Identifier
						OR HDA.AlternativeName6 = @Identifier
						)

				IF ISNULL(@HealthDataAttributeId, 0) > 0
				BEGIN
					--Select @HealthDataAttributeId,@Value,@ClientId,@CollectionDateTime,@HealthDataSubTemplateId,@HealthDataTempleteId,@Flag,@Range,@IsCorrected,@Comment,@ResultStatus
					IF LEN(@CollectionDateTime) = 12
					BEGIN
						SET @CollectionDateTime = @CollectionDateTime + '00'
					END

					INSERT INTO ClientHealthDataAttributes (
						HealthDataAttributeId
						,Value
						,ClientId
						,HealthRecordDate
						,HealthDataSubTemplateId
						,SubTemplateCompleted
						,CreatedDate
						,ModifiedDate
						,HealthDataTemplateId
						,Flag
						,Range
						,IsCorrected
						,Comments
						,ResultStatus
						)
					VALUES (
						@HealthDataAttributeId
						,@Value
						,@ClientId
						,CONVERT(DATETIME, stuff(stuff(stuff(@CollectionDateTime, 9, 0, ' '), 12, 0, ':'), 15, 0, ':'))
						,@HealthDataSubTemplateId
						,'N'
						,GetDate()
						,GetDate()
						,@HealthDataTempleteId
						,@Flag
						,@Range
						,@IsCorrected
						,@Comment
						,@ResultStatus
						)

					SET @ClientHealthDataAttributeId = SCOPE_IDENTITY()
					--SELECT  @ClientHealthDataAttributeId
					SET @EntityType = 8749 -- GlobalCodeId for ClientHealthDataAttributes
					SET @EntityId = @ClientHealthDataAttributeId -- @ClientHealthDataAttributeId

					EXEC SSP_SCInsertLabSoftMessageLink @UserCode
						,@LabSoftMessageId
						,@EntityType
						,@EntityId

					UPDATE LabSoftMessages
					SET MessageProcessingState = 9360
					WHERE LabSoftMessageId = @LabSoftMessageId
				END
				ELSE
				BEGIN
					--Error Out
					SET @Error = 'No matching Health Data Attribute found for the Identifier ' + @Identifier

					RAISERROR (
							@Error
							,16
							,-- Severity.                                                                      
							1 -- State.                                                                      
							);
				END
						-- ========================================================================================		
			END
		END

		CLOSE Subtemplates

		DEALLOCATE Subtemplates
	END TRY

	BEGIN CATCH
		SET @Error = CONVERT(VARCHAR(4000), ERROR_MESSAGE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'HL7 Procedure Error'
			,'SmartCare'
			,GETDATE()
			)

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


