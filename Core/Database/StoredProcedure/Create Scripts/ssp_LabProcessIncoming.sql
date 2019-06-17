/****** Object:  StoredProcedure [dbo].[ssp_LabProcessIncoming]    Script Date: 30-01-2019 11:53:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_LabProcessIncoming]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_LabProcessIncoming]
GO

/****** Object:  StoredProcedure [dbo].[ssp_LabProcessIncoming]    Script Date: 30-01-2019 11:53:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_LabProcessIncoming] @VendorId INT
	,@InboundMessage XML
	,@HL7CPQueueMessageID INT
	,@OutputParamter NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @Error VARCHAR(8000)

	BEGIN TRY
		DECLARE @HL7EncChars CHAR(5) = '|^~\&'

		SET @HL7EncChars = dbo.GetHL7EncodingCharactersFromMessage(@InboundMessage)

		DECLARE @ClientOrderId VARCHAR(MAX)
			,@OrderNumber VARCHAR(MAX)
		DECLARE @LoincCode VARCHAR(100)
		DECLARE @ClientId BIGINT
		DECLARE @ClientIdString VARCHAR(MAX)
		DECLARE @ClientIdFirstNameString VARCHAR(MAX)
		DECLARE @ClientIdLastNameString VARCHAR(MAX)
		DECLARE @CollectionDateTime VARCHAR(MAX)
		DECLARE @ReceivedDateTime VARCHAR(MAX)
		DECLARE @OrderId INT
		DECLARE @PlacerField1 INT
		DECLARE @DocumentVersionId INT
		DECLARE @ClientDOBString VARCHAR(MAX)
		DECLARE @ClientSSNString VARCHAR(MAX)
		DECLARE @OrderedClientOrderId VARCHAR(MAX)
		DECLARE @UserCode VARCHAR(100) = 'HL7 Lab Interface'
		DECLARE @EmbeddedPDF CHAR(1) = 'N'
		DECLARE @EmbeddedPDFSegmentIdentifier VARCHAR(50) = ''
		DECLARE @OrderingPhysicianNPI VARCHAR(50)
		DECLARE @OrderingPhysicianFirstName VARCHAR(50)
		DECLARE @OrderingPhysicianLastName VARCHAR(50)
		DECLARE @ResultCopiesToPhysicianNPI VARCHAR(50)
		DECLARE @ResultCopiesToPhysicianFirstName VARCHAR(50)
		DECLARE @ResultCopiesToPhysicianLastName VARCHAR(50)

		SELECT @EmbeddedPDF = EmbeddedPDF
			,@EmbeddedPDFSegmentIdentifier = EmbeddedPDFSegmentIdentifier
		FROM HL7CPVendorCommOverrides
		WHERE VendorId = @VendorId
			AND Direction = 8609

		PRINT '@@VendorId = ' + cast(@VendorId AS VARCHAR(10))
		PRINT '@EmbeddedPDFSegmentIdentifier = ' + @EmbeddedPDFSegmentIdentifier

		SELECT @ClientIdString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.2[1]/PID.2.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientIdFirstNameString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.5[1]/PID.5.1[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientIdLastNameString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.5[1]/PID.5.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientDOBString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.7[1]/PID.7.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientSSNString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.19[1]/PID.19.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		IF LEN(@ClientDOBString) > 8
		BEGIN
			SET @ClientDOBString = LEFT(@ClientDOBString, 8)
		END

		--3/5 POINT MATCH (last name, firstname, with SSN/DOB)
		BEGIN
			IF isnumeric(isnull(@ClientIdString, '')) <> 0
			BEGIN
				SELECT @ClientId = ClientId
				FROM Clients
				WHERE CLientId = CONVERT(INT, @ClientIdString)
					AND ISNULL(RecordDeleted, 'N') = 'N'
					AND Active = 'Y'
			END

			IF ISNULL(@ClientId, 0) = 0
			BEGIN
				SELECT @ClientId = ClientId
				FROM Clients
				WHERE DOB = CAST(@ClientDOBString AS DATETIME)
					AND LastName = @ClientIdLastNameString
					AND FirstName = @ClientIdFirstNameString
					AND ISNULL(RecordDeleted, 'N') = 'N'
					AND Active = 'Y'

				IF ISNULL(@ClientId, 0) = 0
				BEGIN
					SELECT @ClientId = ClientId
					FROM Clients
					WHERE DOB = CAST(@ClientDOBString AS DATETIME)
						AND LastName = @ClientIdLastNameString
						AND FirstName = @ClientIdFirstNameString
						AND ISNULL(RecordDeleted, 'N') = 'N'
						AND Active = 'Y'
				END

				IF ISNULL(@ClientId, 0) = 0
				BEGIN
					SELECT @ClientId = ClientId
					FROM Clients
					WHERE (
							SSN = @ClientSSNString
							AND LastName = @ClientIdLastNameString
							)
						OR (
							SSN = @ClientSSNString
							AND FirstName = @ClientIdFirstNameString
							)
						AND ISNULL(RecordDeleted, 'N') = 'N'
						AND Active = 'Y'
				END
			END
		END

		PRINT @ClientId

		IF ISNULL(@ClientId, 0) <> 0
		BEGIN
			UPDATE HL7CPQueueMessages
			SET ClientId = @ClientId
				,MessageType = 6348
				,EventType = 8739
				,FivePointMatch = 'Y'
			WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID
		END
		ELSE
		BEGIN
			SELECT TOP 1 @ClientId = ClientId
			FROM Clients
			WHERE (
					DOB = CAST(@ClientDOBString AS DATETIME)
					AND LastName = @ClientIdLastNameString
					)
				OR (
					DOB = CAST(@ClientDOBString AS DATETIME)
					AND FirstName = @ClientIdFirstNameString
					)
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND Active = 'Y'

			--3/5 POINT MATCH FAILED. LOG AND ABORT PROCESSING
			UPDATE HL7CPQueueMessages
			SET FivePointMatch = 'N'
				,MessageType = 6348
				,EventType = 8739
				,PotentialClientId = @ClientId
			WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

			RETURN
		END

		UPDATE HL7CPQueueMessages
		SET MessageType = 6348
			,EventType = 8739
			,ClientId = @ClientId
		WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

		--CHECK AND CREATE ORDER AND RELATED ATTRIBUTES IF IT DOES NOT EXIST AS PART OF THE SETUP
		EXEC ssp_LabCreateOrdersAndTemplates @InboundMessage
			,@HL7CPQueueMessageID

		DECLARE observationResults CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT dbo.HL7_INBOUND_XFORM(T.item.value('OBR.2[1]/OBR.2.0[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars) AS OrderNumber
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS LoincCode
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.7[1]/OBR.7.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS CollectionDateTime
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.14[1]/OBR.14.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS ReceivedDateTime
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderingPhysicianNPI
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.1[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderingPhysicianLastName
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.2[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderingPhysicianFirstName
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.18[1]/OBR.18.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS ClientOrderId
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.28[1]/OBR.28.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS ResultCopiesToPhysicianNPI
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.28[1]/OBR.28.1[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS ResultCopiesToPhysicianFirstName
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.28[1]/OBR.28.2[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS ResultCopiesToPhysicianLastName
		FROM @InboundMessage.nodes('HL7Message/OBR') AS T(item)

		OPEN observationResults

		FETCH NEXT
		FROM observationResults
		INTO @OrderNumber
			,@LoincCode
			,@CollectionDateTime
			,@ReceivedDateTime
			,@OrderingPhysicianNPI
			,@OrderingPhysicianLastName
			,@OrderingPhysicianFirstName
			,@ClientOrderId
			,@ResultCopiesToPhysicianNPI
			,@ResultCopiesToPhysicianFirstName
			,@ResultCopiesToPhysicianLastName

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF ISNULL(@LoincCode, '') = ''
			BEGIN
				RAISERROR (
						'LOINC Code is not found in the message'
						,16
						,-- Severity.                                                                      
						1 -- State.                                                                      
						);
			END
			ELSE
			BEGIN
				IF @LoincCode <> ISNULL(@EmbeddedPDFSegmentIdentifier, '')
				BEGIN
					DECLARE @orderingPhysicianId INT

					--4/5 POINT MATCH (Ordering Physician last name, firstname, with NPI)
					SELECT @orderingPhysicianId = s.StaffId
					FROM Staff s
					JOIN StaffLicenseDegrees SL ON SL.StaffId = S.StaffId
					WHERE SL.LicenseTypeDegree = 9408 -- NPI Number
						AND ISNULL(SL.RecordDeleted, 'N') = 'N'
						AND SL.LicenseNumber = isnull(@OrderingPhysicianNPI, '')
						AND (
							S.LastName = @OrderingPhysicianLastName
							OR S.FirstName = @OrderingPhysicianFirstName
							)

					--set @orderingPhysicianId = 336
					--4/5 POINT MATCH FAILED. LOG AND ABORT PROCESSING
					IF ISNULL(@orderingPhysicianId, 0) = 0
					BEGIN
						PRINT '--4/5 POINT MATCH FAILED. LOG AND ABORT PROCESSING'
						PRINT @OrderingPhysicianNPI
						PRINT @OrderingPhysicianLastName
						PRINT @OrderingPhysicianFirstName

						UPDATE HL7CPQueueMessages
						SET FivePointMatch = 'N'
							,PotentialClientId = @ClientId
						WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

						RETURN
					END

					IF ISNUMERIC(@ClientOrderId) = 0
						SET @ClientOrderId = 0

					--5/5 POINT MATCH (Whether this test (Loinc) was ordered for this Client by the Ordering Physician same as on file)
					SELECT @ClientOrderId = Co.ClientOrderId
					FROM ClientOrders Co
					JOIN ClientOrderOrderNumbers cn ON CN.ClientOrderId = CO.ClientOrderId
					JOIN Orders O ON Co.OrderId = O.OrderId
					JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
					WHERE co.ClientId = @ClientId
						AND Co.OrderingPhysician = @orderingPhysicianId
						AND HDT.OrderCode = ISNULL(@LoincCode, '')
						AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
						AND ISNULL(Co.RecordDeleted, 'N') = 'N'
						AND ISNULL(O.RecordDeleted, 'N') = 'N'
						AND CO.OrderStatus <> 6510
						AND CN.OrderNumber = @OrderNumber

					--CHECK IF THERE IS AN EXISTING REFLEX ORDER
					IF ISNULL(@ClientOrderId, 0) = 0
					BEGIN
						SELECT @ClientOrderId = Co.ClientOrderId
						FROM ClientOrders Co
						JOIN Orders O ON Co.OrderId = O.OrderId
						JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
						WHERE co.ClientId = @ClientId
							AND Co.OrderingPhysician = @orderingPhysicianId
							AND HDT.OrderCode = ISNULL(@LoincCode, '')
							AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
							AND ISNULL(Co.RecordDeleted, 'N') = 'N'
							AND ISNULL(O.RecordDeleted, 'N') = 'N'
							AND CO.OrderStatus <> 6510
							AND Co.ExternalClientOrderId = @OrderNumber
					END

					IF ISNULL(@ClientOrderId, 0) = 0
					BEGIN
						-- CREATE THE RESULT AS REFLEX ORDER
						SELECT @OrderId = O.OrderId
						FROM Orders O
						JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
						WHERE OrderCode = RTRIM(LTRIM(@LoincCode))
							AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
							AND ISNULL(o.RecordDeleted, 'N') = 'N'

						EXEC @ClientOrderId = ssp_LabCreateUnsolicitedClientOrder @OrderId
							,@ClientId
							,@HL7EncChars
							,@InboundMessage
							,NULL
							,@VendorId
					END

					IF ISNULL(@ClientOrderId, 0) = 0
					BEGIN
						RAISERROR (
								'Matching client order could not be found/Reflex order could not be created'
								,16
								,-- Severity.                                                                      
								1 -- State.                                                                      
								);
					END

					IF ISNULL(@CollectionDateTime, '') = ''
					BEGIN
						SET @CollectionDateTime = @ReceivedDateTime
					END

					IF LEN(@CollectionDateTime) = 12
					BEGIN
						SET @CollectionDateTime = @CollectionDateTime + '00'
					END
					ELSE IF LEN(@CollectionDateTime) > 14
					BEGIN
						SET @CollectionDateTime = LEFT(@CollectionDateTime, 14)
					END

					IF @ClientOrderId > 0
						AND @LoincCode <> ISNULL(@EmbeddedPDFSegmentIdentifier, '') --'PDF'
					BEGIN
						PRINT 'calling ssp_LabProcessOrderResults ' + @LoincCode + ' ' + @EmbeddedPDFSegmentIdentifier

						EXEC ssp_LabProcessOrderResults @VendorId
							,@ClientOrderId
							,@LoincCode
							,@ClientId
							,@InboundMessage
							,@CollectionDateTime
							,@HL7CPQueueMessageID
							,@EmbeddedPDF
							,@EmbeddedPDFSegmentIdentifier
					END
				END
			END

			FETCH NEXT
			FROM observationResults
			INTO @OrderNumber
				,@LoincCode
				,@CollectionDateTime
				,@ReceivedDateTime
				,@OrderingPhysicianNPI
				,@OrderingPhysicianLastName
				,@OrderingPhysicianFirstName
				,@ClientOrderId
				,@ResultCopiesToPhysicianNPI
				,@ResultCopiesToPhysicianFirstName
				,@ResultCopiesToPhysicianLastName
		END

		CLOSE observationResults

		DEALLOCATE observationResults

		RETURN
	END TRY

	BEGIN CATCH
		--*****************************************************************************************
		-- Set error message for .NET program to capture
		--*****************************************************************************************
		SET @OutputParamter = ERROR_MESSAGE()
		--*****************************************************************************************
		-- Log error
		--*****************************************************************************************
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_LabProcessIncoming') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,-- Severity.                                                                      
				1 -- State.                                                                      
				);

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
			,@UserCode
			,GETDATE()
			)
	END CATCH
END
GO


