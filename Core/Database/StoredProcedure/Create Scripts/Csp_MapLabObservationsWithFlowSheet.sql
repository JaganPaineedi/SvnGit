/****** Object:  StoredProcedure [dbo].[Csp_MapLabObservationsWithFlowSheet]    Script Date: 06/25/2015 16:04:30 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[Csp_MapLabObservationsWithFlowSheet]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[Csp_MapLabObservationsWithFlowSheet]
GO

/****** Object:  StoredProcedure [dbo].[Csp_MapLabObservationsWithFlowSheet]    Script Date: 06/25/2015 16:04:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Csp_MapLabObservationsWithFlowSheet] @ClientOrderId INT
	,@LoincCode VARCHAR(100)
	,@ClientId INT
	,@InboundMessage XML
	,@CollectionDateTime VARCHAR(MAX)
	,@LabSoftMessageId INT
AS
--=======================================
/* 
Description : Used to update the Lab order Observation to Flowsheet      
ModifiedDate		     ModifiedBy		Reason
Feb 01 2015			Pradeep			OBX is filtered based on respective LoincCode
Jan 16 2016			Pradeep			Modified to get the correct NTE segment value for the respective Observations (OBR)
Apr 06 2017		    Pradeep		     Passed NULL IN Image parameter to SSP_CreateImageRecordsForLabSoftEmbeddedPDF
May 08 2018			Shankha			Modified logic to identify the correct HealthDataSubTemplateId
*/
--=======================================
BEGIN
	DECLARE @TranName VARCHAR(20);

	SET @TranName = 'UpdateObservations'

	BEGIN TRY
		DECLARE @Error VARCHAR(8000)

		-- Steps to Execute For FlowSheet with ClientOrderId Match.
		IF EXISTS (
				SELECT 1
				FROM ClientOrders Co
				INNER JOIN Orders O ON Co.OrderId = O.OrderId
				INNER JOIN OrderLabs OL ON OL.OrderId = O.OrderId
				WHERE Co.ClientOrderId = @ClientOrderId
					AND OL.ExternalOrderId = @LoincCode
					AND ISNULL(OL.RecordDeleted, 'N') = 'N'
					AND ISNULL(Co.RecordDeleted, 'N') = 'N'
					AND ISNULL(O.RecordDeleted, 'N') = 'N'
					AND ISNULL(@LoincCode, '') <> ''
				)
		BEGIN
			BEGIN TRANSACTION @TranName

			-- Loop through OBX segment
			DECLARE @Identifier NVARCHAR(MAX)
			DECLARE @value NVARCHAR(MAX)
			DECLARE @Unit NVARCHAR(MAX)
			DECLARE @Status NVARCHAR(1)
			DECLARE @ResultDateTime VARCHAR(MAX)
			DECLARE @Range NVARCHAR(MAX)
			DECLARE @Flag NVARCHAR(MAX)
			DECLARE @Comment NVARCHAR(MAX)
			DECLARE @EntityType INT
			DECLARE @EntityId INT
			DECLARE @IsCorrected type_YorN
			DECLARE @UserCode type_currentUser
			DECLARE @ResultStatus INT
			DECLARE @IsCorrectionFound type_YorN
			DECLARE @ClientOrderResultId INT
			DECLARE @LabMedicalDirector VARCHAR(MAX)
			DECLARE @ObservationDateTime VARCHAR(MAX)
			DECLARE @ObservationName VARCHAR(MAX)
			DECLARE @ImageRecordItemId INT
			DECLARE @CurrentObservationNode XML

			SET @UserCode = CURRENT_USER
			SET @EntityType = 8747 -- GlobalCodeId for ClientOrders
			SET @EntityId = @ClientOrderId -- ClientOrderId.

			EXEC SSP_SCInsertLabSoftMessageLink @UserCode
				,@LabSoftMessageId
				,@EntityType
				,@EntityId

			-- Insert entry in ClientOrderResults		
			SELECT @LabMedicalDirector = m.c.value('OBR.16[1]/OBR.16.1[1]/ITEM[1]', 'nvarchar(max)') + ' ' + m.c.value('OBR.16[1]/OBR.16.2[1]/ITEM[1]', 'nvarchar(max)') + '(' + m.c.value('OBR.16[1]/OBR.16.0[1]/ITEM[1]', 'nvarchar(max)') + ')'
			FROM @InboundMessage.nodes('HL7Message/OBR[OBR.4/OBR.4.0/ITEM =sql:variable("@LoincCode")]') AS m(c)

			EXEC SSP_CreateImageRecordsForLabSoftEmbeddedPDF @ClientOrderId
				,@ClientId
				,@InboundMessage
				,@LabSoftMessageId
				,'Lab Results'
				,NULL -- Set NULL to getch data from LabSoftMessagesx`
				,@ImageRecordItemId OUTPUT

			DECLARE observation CURSOR LOCAL FAST_FORWARD
			FOR
			SELECT m.c.value('OBX.3[1]/OBX.3.0[1]/ITEM[1]', 'nvarchar(max)') AS Identifier
				,m.c.value('OBX.5[1]/OBX.5.0[1]/ITEM[1]', 'nvarchar(max)') AS Value
				,m.c.value('OBX.6[1]/OBX.6.0[1]/ITEM[1]', 'nvarchar(max)') AS Unit
				,m.c.value('OBX.11[1]/OBX.11.0[1]/ITEM[1]', 'nvarchar(max)') AS ResultStatus
				,m.c.value('OBX.14[1]/OBX.14.0[1]/ITEM[1]', 'nvarchar(max)') AS ResultDateTime
				,m.c.value('OBX.7[1]/OBX.7.0[1]/ITEM[1]', 'nvarchar(max)') AS [Range]
				,m.c.value('OBX.8[1]/OBX.8.0[1]/ITEM[1]', 'nvarchar(max)') AS Flag
				,m.c.value('OBX.3[1]/OBX.3.1[1]/ITEM[1]', 'nvarchar(max)') AS ObservationName
				,(
					SELECT STUFF((
								SELECT CHAR(13) + RTRIM(LTRIM(n.value('.', 'VARCHAR(MAX)')))
								FROM (
									SELECT m.c.query('.')
									) AS t(Response)
								CROSS APPLY t.Response.nodes('.//NTE.3.0/ITEM') r(n)
								FOR XML PATH('')
									,TYPE
								).value('.', 'VARCHAR(MAX)'), 1, 1, '')
					) AS Comment
				,m.c.query('.') AS CurrentObservationNode
			FROM @InboundMessage.nodes('HL7Message/OBR[OBR.4/OBR.4.0/ITEM =sql:variable("@LoincCode")]/OBX') AS m(c)

			OPEN observation

			FETCH NEXT
			FROM observation
			INTO @Identifier
				,@value
				,@Unit
				,@Status
				,@ResultDateTime
				,@Range
				,@Flag
				,@ObservationName
				,@Comment
				,@CurrentObservationNode

			WHILE @@FETCH_STATUS = 0
			BEGIN
				-- Get Observation Result Status Id from GlobalCodes based on the mapping done.
				SELECT @ResultStatus = dbo.GetHL7ResultStatus(@Status)

				IF @Status = 'C'
				BEGIN
					SET @IsCorrected = 'Y'
					SET @IsCorrectionFound = 'Y'
				END
				ELSE
					SET @IsCorrected = NULL

				-- ==============================================		
				-- Create HealthDataAttributes if it doesn't exist
				DECLARE @HealthDataSubTemplateId INT

				SELECT TOP 1 @HealthDataSubTemplateId = HealthDataSubTemplateId
				FROM ClientOrders Co
				INNER JOIN Orders O ON Co.OrderId = O.OrderId
				INNER JOIN OrderLabs OL ON OL.OrderId = O.OrderId
				INNER JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
				INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataTemplateId = HDT.HealthDataTemplateId
				WHERE Co.ClientOrderId = @ClientOrderId
					AND HDT.Active = 'Y'
					AND OL.ExternalOrderId = @LoincCode
					AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
					AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'
					AND ISNULL(Co.RecordDeleted, 'N') = 'N'
					AND ISNULL(O.RecordDeleted, 'N') = 'N'
					AND ISNULL(OL.RecordDeleted, 'N') = 'N'
					AND ISNULL(@LoincCode, '') <> ''
					AND EXISTS (
						SELECT 1
						FROM HealthDataTemplates HDT
						WHERE HDT.OrderCode = OL.OrderCode 
						AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
						AND HDT.Active = 'Y'

						)

				-- Create HeathDataAttributes if it does not exists
				EXEC SSP_SCCreateHealthDataAttributes @ObservationName
					,@HealthDataSubTemplateId
					,@Identifier

				-- Create Observations if it does not exists
				EXEC SSP_SCCreateObservations @ObservationName
					,@Identifier
					,@Range
					,@Unit
					,@CurrentObservationNode

				-- ==============================================			
				-- Call Flowsheet for mapping Individual Observations.
				EXEC csp_CreateLabOrderFlowsheet @Identifier
					,@value
					,@ClientId
					,@LoincCode
					,@ResultDateTime
					,@CollectionDateTime
					,@Range
					,@Flag
					,@Comment
					,@IsCorrected
					,@ResultStatus
					,@LabSoftMessageId

				EXEC @ClientOrderResultId = SSP_SCInsertClientOrderResults @ClientOrderId
					,@ResultDateTime
					,@LabMedicalDirector

				IF @ClientOrderResultId > 0
					EXEC SSP_CreateClientOrderResultsAndObservations @ClientOrderResultId
						,@Identifier
						,@value
						,@ClientId
						,@LoincCode
						,@ResultDateTime
						,@CollectionDateTime
						,@Range
						,@Flag
						,@Comment
						,@IsCorrected
						,@ResultStatus
						,@LabSoftMessageId

				FETCH NEXT
				FROM observation
				INTO @Identifier
					,@value
					,@Unit
					,@Status
					,@ResultDateTime
					,@Range
					,@Flag
					,@ObservationName
					,@Comment
					,@CurrentObservationNode
			END

			-- ==============================================	
			CLOSE observation

			DEALLOCATE observation

			IF ISNULL(@IsCorrectionFound, 'N') = 'Y'
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM LabSoftMessageLinks HQML
						INNER JOIN LabSoftMessages HQM ON HQML.LabSoftMessageId = HQML.LabSoftMessageId
						WHERE HQML.LabSoftMessageId != @LabSoftMessageId
							AND HQML.EntityType = 8747
							AND HQML.EntityId = @ClientOrderId
							AND ISNULL(HQML.RecordDeleted, 'N') != 'Y'
						)
				BEGIN
					DECLARE @LabSoftMId INT
					DECLARE @LabSoftMLId INT

					SELECT TOP 1 @LabSoftMId = HQML.LabSoftMessageId
						,@LabSoftMLId = HQML.LabSoftMessageLinkId
					FROM LabSoftMessageLinks HQML
					INNER JOIN LabSoftMessages HQM ON HQML.LabSoftMessageId = HQML.LabSoftMessageId
					WHERE HQML.LabSoftMessageId != @LabSoftMessageId
						AND HQML.EntityType = 8747
						AND HQML.EntityId = @ClientOrderId
						AND ISNULL(HQML.RecordDeleted, 'N') != 'Y'
					ORDER BY LabSoftMessageLinkId DESC

					UPDATE LabSoftMessageLinks
					SET RecordDeleted = 'Y'
						,DeletedBy = @UserCode
						,DeletedDate = GetDate()
					WHERE LabSoftMessageLinkId = @LabSoftMLId
						AND EntityType = 8747 --CLIENTORDERS
						AND ISNULL(RecordDeleted, 'N') = 'N'

					UPDATE ClientHealthDataAttributes
					SET RecordDeleted = 'Y'
						,DeletedBy = @UserCode
						,DeletedDate = GetDate()
					WHERE ClientHealthDataAttributeId IN (
							SELECT EntityId
							FROM LabSoftMessageLinks
							WHERE LabSoftMessageId = @LabSoftMId
								AND EntityType = 8749 --CLIENTHEALTHDATAATTRIBUTES
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)

					UPDATE LabSoftMessageLinks
					SET RecordDeleted = 'Y'
						,DeletedBy = @UserCode
						,DeletedDate = GetDate()
					WHERE LabSoftMessageId = @LabSoftMId
						AND EntityType = 8749 --CLIENTHEALTHDATAATTRIBUTES
						AND ISNULL(RecordDeleted, 'N') = 'N'
				END
			END

			-- Update ClientOrder With its Status (Results Obtained)
			IF LEN(@CollectionDateTime) = 12
			BEGIN
				SET @CollectionDateTime = @CollectionDateTime + '00'
			END

			UPDATE ClientOrders
			SET OrderStatus = 6504
				,FlowSheetDateTime = CONVERT(DATETIME, stuff(stuff(stuff(@CollectionDateTime, 9, 0, ' '), 12, 0, ':'), 15, 0, ':'))
			WHERE ClientOrderId = @ClientOrderId

			COMMIT TRANSACTION @TranName
		END
		ELSE
		BEGIN
			--Error Out
			SET @Error = 'The LOINC Code ' + @LoincCode + ' is not associated with the ClientOrder with the ClientOrderId=' + CONVERT(VARCHAR(100), @ClientOrderId)

			RAISERROR (
					@Error
					,16
					,-- Severity.                                                                      
					1 -- State.                                                                      
					);
		END
	END TRY

	BEGIN CATCH
		IF EXISTS (
				SELECT 1
				FROM Sys.dm_tran_active_transactions
				WHERE NAME = @TranName
				)
			ROLLBACK TRANSACTION @TranName

		SET @Error = CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'Csp_MapLabObservationsWithFlowSheet')

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


