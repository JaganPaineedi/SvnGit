/****** Object:  StoredProcedure [dbo].[ssp_LabProcessOrderResults]    Script Date: 30-01-2019 11:53:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_LabProcessOrderResults]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_LabProcessOrderResults]
GO

/****** Object:  StoredProcedure [dbo].[ssp_LabProcessOrderResults]    Script Date: 12/23/2018 9:48:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_LabProcessOrderResults] @VendorId INT
	,@ClientOrderId INT
	,@LoincCode VARCHAR(100)
	,@ClientId INT
	,@InboundMessage XML
	,@CollectionDateTime VARCHAR(MAX)
	,@HL7CPQueueMessageID INT
	,@EmbeddedPDF CHAR(1) = 'N'
	,@EmbeddedPDFSegmentIdentifier VARCHAR(50) = ''
AS
--=======================================
/* 
Description : Used to update the Lab order Observation to Flowsheet      
ModifiedDate		ModifiedBy		Reason
Feb 01 2015			Pradeep			OBX is filtered based on respective LoincCode
Jan 16 2016			Pradeep			Modified to get the correct NTE segment value for the respective Observations (OBR)
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
				JOIN Orders O ON Co.OrderId = O.OrderId
				JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
				WHERE Co.ClientOrderId = @ClientOrderId
					AND HDT.OrderCode = @LoincCode
					AND HDT.Active = 'Y'
					AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
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
			DECLARE @ClientOrderResultId INT = 0
			DECLARE @LabMedicalDirector VARCHAR(MAX)
			DECLARE @ObservationDateTime VARCHAR(MAX)
			DECLARE @ObservationName VARCHAR(MAX)
			DECLARE @ImageRecordItemId INT
			DECLARE @CurrentObservationNode XML
			DECLARE @createPDFStoredProcedure NVARCHAR(400)
				,@sqlStr NVARCHAR(max)

			SET @UserCode = 'HL7 Lab Interface'
			SET @EntityType = 8747 -- GlobalCodeId for ClientOrders
			SET @EntityId = @ClientOrderId -- ClientOrderId.

			SELECT @LabMedicalDirector = m.c.value('OBR.16[1]/OBR.16.1[1]/ITEM[1]', 'nvarchar(max)') + ' ' + m.c.value('OBR.16[1]/OBR.16.2[1]/ITEM[1]', 'nvarchar(max)') + '(' + m.c.value('OBR.16[1]/OBR.16.0[1]/ITEM[1]', 'nvarchar(max)') + ')'
				,@ObservationDateTime = m.c.value('OBR.22[1]/OBR.22.0[1]/ITEM[1]', 'Varchar(MAX)')
			FROM @InboundMessage.nodes('HL7Message/OBR[OBR.4/OBR.4.0/ITEM =sql:variable("@LoincCode")]') AS m(c)

			PRINT '@ObservationDateTime' + @ObservationDateTime

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
								SELECT CHAR(13) + n.value('.', 'VARCHAR(MAX)') --RTRIM(LTRIM(n.value('.', 'VARCHAR(MAX)')))
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
				IF (
						ISNULL(@Value, '') <> ''
						AND isnull(@Identifier, '') <> ''
						)
					OR (isnull(@ObservationName, '') = 'METHODOLOGY COMMENT')
				BEGIN
					SET @ResultStatus = NULL
					SET @IsCorrected = NULL
					SET @IsCorrectionFound = NULL

					-- Get Observation Result Status Id from GlobalCodes based on the mapping done.
					SELECT @ResultStatus = dbo.fn_GetGlobalCode('HL7RESULTSTATUS', @Status)

					SET @IsCorrected = 'Y'
					SET @IsCorrectionFound = 'Y'

					IF ISnuLL(@ResultDateTime, '') = ''
					BEGIN
						SET @ResultDateTime = @ObservationDateTime
					END

					PRINT '@@ResultDateTime' + @ResultDateTime

					-- Call Flowsheet for mapping Individual Observations.
					IF (isnull(@ClientOrderResultId, 0) = 0)
					BEGIN
						EXEC @ClientOrderResultId = SSP_SCInsertClientOrderResults @ClientOrderId
							,@ResultDateTime
							,@LabMedicalDirector
					END

					PRINT '@ClientOrderResultId'
					PRINT @ClientOrderResultId

					IF @ClientOrderResultId > 0
					BEGIN
						EXEC ssp_LabCreateResultsAndObservations @ClientOrderResultId
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
							,@HL7CPQueueMessageID
							,@Unit

						EXEC ssp_LabCreateFlowsheet @Identifier
							,@value
							,@ClientId
							,@ClientOrderId
							,@LoincCode
							,@ResultDateTime
							,@CollectionDateTime
							,@Range
							,@Flag
							,@Comment
							,@IsCorrected
							,@ResultStatus
							,@HL7CPQueueMessageID
					END
				END

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

			--==============================================	
			CLOSE observation

			DEALLOCATE observation

			----PROCESS EMBEDDED PDF
			SELECT @createPDFStoredProcedure = StoredProcedureName
			FROM [dbo].[HL7CPInboundSegmentConfigurations]
			WHERE [VendorId] = @VendorId
				AND [SegmentType] = 'PDF'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF ISNULL(@createPDFStoredProcedure, '') <> ''
			BEGIN
				SET @sqlStr = 'EXEC ' + @createPDFStoredProcedure + ' ' + cast(@ClientOrderId AS NVARCHAR(max)) + ',' + cast(@ClientId AS NVARCHAR(max)) + ',' + cast(@HL7CPQueueMessageID AS NVARCHAR(max))

				PRINT @sqlStr

				EXECUTE sp_executesql @sqlStr
			END

			-- Record the processing for the Client Order
			EXEC SSP_SCInsertHL7CPQueueMessageLink @UserCode
				,@HL7CPQueueMessageID
				,@EntityType
				,@ClientOrderId

			IF ISNULL(@IsCorrectionFound, 'N') = 'Y'
			BEGIN
				DECLARE @PreviousHL7CPQueueMessageId INT

				SELECT TOP 1 @PreviousHL7CPQueueMessageId = HQML.HL7CPQueueMessageId
				FROM HL7CPQueueMessageLinks HQML
				INNER JOIN HL7CPQueueMessages HQM ON HQML.HL7CPQueueMessageID = HQML.HL7CPQueueMessageID
				WHERE HQML.HL7CPQueueMessageID != @HL7CPQueueMessageID
					AND HQML.EntityType = 8747
					AND HQML.EntityId = @ClientOrderId
					AND ISNULL(HQML.RecordDeleted, 'N') != 'Y'
				ORDER BY HL7CPQueueMessageLinkId DESC

				IF @PreviousHL7CPQueueMessageId > 0
				BEGIN
					UPDATE ClientHealthDataAttributes
					SET RecordDeleted = 'Y'
						,DeletedBy = @UserCode
						,DeletedDate = GetDate()
					WHERE ClientHealthDataAttributeId IN (
							SELECT EntityId
							FROM HL7CPQueueMessageLinks
							WHERE HL7CPQueueMessageId = @PreviousHL7CPQueueMessageId
								AND EntityType = 8749 --CLIENTHEALTHDATAATTRIBUTES
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)

					UPDATE HL7CPQueueMessageLinks
					SET RecordDeleted = 'Y'
						,DeletedBy = @UserCode
						,DeletedDate = GetDate()
					WHERE HL7CPQueueMessageId = @PreviousHL7CPQueueMessageId
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
				,ModifiedBy = @UserCode
				,ModifiedDate = Getdate()
			WHERE ClientOrderId = @ClientOrderId

			COMMIT TRANSACTION @TranName
		END
		ELSE
		BEGIN
			--Error Out
			PRINT '1 am here....'

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

		SET @Error = CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_LabProcessOrderResults')

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


