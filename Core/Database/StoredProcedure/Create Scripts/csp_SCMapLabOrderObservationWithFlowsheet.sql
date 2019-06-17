--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING! 
/****** Object:  StoredProcedure [dbo].[csp_SCMapLabOrderObservationWithFlowsheet]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCMapLabOrderObservationWithFlowsheet]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCMapLabOrderObservationWithFlowsheet]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCMapLabOrderObservationWithFlowsheet]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCMapLabOrderObservationWithFlowsheet] @InboundMessage XML
	,@LabSoftMessageId INT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 22, 2015  
-- Description: Parse the Lab Order Message      
/*      
 Author			Modified Date	Reason      
 Pradeep		 Feb 01 2016		Cursor implemented get all Lab Observation Results (OBR)  
 Pradeep		 Nov 04 2016		Changed the Reference from LoincCodeOrders to OrderLabs to Refer the LogicCode 
 Pradeep        Deb 02 2017        Added BEGIN END for the ClientNotFound Label.
 Pradeep		 Nov 03 2017		Modified to check whether the clientId contains characters or not. If it exists find the clientId based the FirstName,LastName and DOB	     
 Wasif Butt		Jul 13 2017				Setting @CollectionDateTime as Modififed when date wasn't provided in the message. 
 Pradeep		Sept 24 2018		What: Added Inner Join with Orders and HealthDataTemplates and added RecordDeleted check with HealthDataTemplates to not to consider deleted Orders Why: AHN-Support Go Live #146.1
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @HL7EncChars CHAR(5) = '|^~\&'

		SET @HL7EncChars = dbo.GetHL7EncodingCharactersFromMessage(@InboundMessage)

		DECLARE @ClientOrderId BIGINT
		DECLARE @LoincCode VARCHAR(100)
		DECLARE @ClientId BIGINT
		DECLARE @ClientIdString VARCHAR(MAX)
		DECLARE @ClientIdFirstNameString VARCHAR(MAX)
		DECLARE @ClientIdLastNameString VARCHAR(MAX)
		DECLARE @CollectionDateTime VARCHAR(MAX)
		DECLARE @ReceivedDateTime VARCHAR(MAX)
		DECLARE @OrderId INT
		DECLARE @Priority CHAR(1)
		DECLARE @DocumentVersionId INT
		DECLARE @ClientDOBString VARCHAR(MAX)
		DECLARE @ClientSSNString VARCHAR(MAX)

		SELECT @ClientIdString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.2[1]/PID.2.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientIdFirstNameString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.5[1]/PID.5.1[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientIdLastNameString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.5[1]/PID.5.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientDOBString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.7[1]/PID.7.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
			,@ClientSSNString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.19[1]/PID.19.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/PID') AS T(item)

		IF EXISTS (
				SELECT 1
				FROM Clients C
				WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
					AND C.Active = 'Y'
					AND C.LastName = @ClientIdLastNameString
					AND C.FirstName = @ClientIdFirstNameString
				)
		BEGIN
			SELECT @ClientId = C.ClientId
			FROM Clients C
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
				AND C.Active = 'Y'
				AND C.LastName = @ClientIdLastNameString
				AND C.FirstName = @ClientIdFirstNameString
		END
		ELSE
		BEGIN
			IF ISNUMERIC(@ClientIdString) = 1
			BEGIN
				IF EXISTS (SELECT 1 FROM Clients Where CLientId =CONVERT(INT,@ClientIdString) AND Active = 'Y' AND ISNULL(RecordDeleted,'N')='N')
				BEGIN
					SELECT @ClientId = ClientId FROM Clients Where CLientId =CONVERT(INT,@ClientIdString) AND Active = 'Y' AND ISNULL(RecordDeleted,'N')='N'
				END
				ELSE IF EXISTS (SELECT 1 FROM Clients Where CONVERT(VARCHAR(10),DOB,112) = @ClientDOBString AND SSN = @ClientSSNString AND Active = 'Y' AND ISNULL(RecordDeleted,'N')='N')
				BEGIN
					SELECT @ClientId = ClientId FROM Clients Where CONVERT(VARCHAR(10),DOB,112) = @ClientDOBString AND SSN = @ClientSSNString AND Active = 'Y' AND ISNULL(RecordDeleted,'N')='N'
				END
				ELSE
					GOTO ClientIdNotFound
			END
			ELSE
			BEGIN
				IF EXISTS (
					SELECT 1
					FROM Clients C
					WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
						AND C.Active = 'Y'
						AND C.LastName = @ClientIdLastNameString
						AND C.FirstName = @ClientIdFirstNameString
						AND Convert(VARCHAR(8),C.DOB,112) = @ClientDOBString
				)
				BEGIN
					SELECT TOP 1 @ClientId = C.ClientId
					FROM Clients C
					WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
						AND C.Active = 'Y'
						AND C.LastName = @ClientIdLastNameString
						AND C.FirstName = @ClientIdFirstNameString
						AND Convert(VARCHAR(8),C.DOB,112) = @ClientDOBString
				END 
				ELSE
					GOTO ClientIdNotFound
			END
		END

		SELECT @ClientOrderId = dbo.HL7_INBOUND_XFORM(T.item.value('ORC.2[1]/ORC.2.0[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/ORC') AS T(item)

		SELECT @DocumentVersionId = DocumentVersionId
		FROM ClientOrders
		WHERE ClientOrderId = @ClientOrderId

		DECLARE observationResults CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS LoincCode
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.7[1]/OBR.7.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS CollectionDateTime
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.14[1]/OBR.14.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS ReceivedDateTime
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.5[1]/OBR.5.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS Priority
		FROM @InboundMessage.nodes('HL7Message/OBR') AS T(item)

		OPEN observationResults

		FETCH NEXT
		FROM observationResults
		INTO @LoincCode
			,@CollectionDateTime
			,@ReceivedDateTime
			,@Priority

		declare @ModifiedDateTime datetime = (select top 1 lsm.ModifiedDate from dbo.LabSoftMessages as lsm where lsm.LabSoftMessageId = @LabSoftMessageId)

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF ISNULL(@CollectionDateTime,'')= ''
				SET @CollectionDateTime = @ReceivedDateTime
			IF ISNULL(@CollectionDateTime, '') = ''
				SET @CollectionDateTime = dbo.GetDateFormatForHL7(@ModifiedDateTime, @HL7EncChars)

			IF ISNULL(@LoincCode, '') = ''
			BEGIN
				RAISERROR (
						'LOINC Code does not exist in Inbound Messsage.'
						,16
						,-- Severity.                                                                      
						1 -- State.                                                                      
						);
			END
			ELSE
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM ClientOrders CO
						JOIN Clients C ON C.ClientId = CO.ClientId
						WHERE CO.ClientOrderId = @ClientOrderId
							AND ISNULL(CO.RecordDeleted, 'N') = 'N'
							AND CO.ClientId = @ClientId
							--AND C.FirstName = @ClientIdFirstNameString
							--AND C.LastName = @ClientIdLastNameString
							AND CO.DocumentVersionId = @DocumentVersionId
						)
				BEGIN
					IF EXISTS (
							SELECT 1
							FROM OrderLabs OL
							INNER JOIN Orders O ON O.OrderId = OL.OrderId
							INNER JOIN HealthDataTemplates hdt ON hdt.HealthDataTemplateId  = O.LabId
							WHERE OL.ExternalOrderId = @LoincCode
								AND ISNULL(OL.RecordDeleted, 'N') = 'N'
								AND ISNULL(O.RecordDeleted, 'N') = 'N'
								AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
							)
					BEGIN
						SELECT @OrderId = O.OrderId
						FROM OrderLabs OL
						INNER JOIN Orders O ON O.OrderId = OL.OrderId
						INNER JOIN HealthDataTemplates hdt ON hdt.HealthDataTemplateId  = O.LabId
						WHERE OL.ExternalOrderId = @LoincCode
							AND ISNULL(OL.RecordDeleted, 'N') = 'N'
							AND ISNULL(O.RecordDeleted, 'N') = 'N'
							AND ISNULL(HDT.RecordDeleted, 'N') = 'N'

						DECLARE @ClientOrderCount INT

						SELECT @ClientOrderCount = COUNT(*)
						FROM ClientOrders Co
						INNER JOIN Orders O ON Co.OrderId = O.OrderId
						WHERE O.OrderId = @OrderId
							AND ISNULL(O.RecordDeleted, 'N') = 'N'
							AND ISNULL(Co.RecordDeleted, 'N') = 'N'
							--AND Co.OrderFlag = 'Y'
							AND Co.ClientId = @ClientId
							AND Co.DocumentVersionId = @DocumentVersionId

						IF @ClientOrderCount > 0
						BEGIN
							SELECT @ClientOrderId = ClientOrderId
							FROM ClientOrders
							WHERE OrderId = @OrderId
								AND ClientId = @ClientId
								AND DocumentVersionId = @DocumentVersionId

							IF @ClientOrderId > 0
								EXEC Csp_MapLabObservationsWithFlowSheet @ClientOrderId
									,@LoincCode
									,@ClientId
									,@InboundMessage
									,@CollectionDateTime
									,@LabSoftMessageId
						END
						ELSE
						BEGIN
							IF @ClientOrderCount = 0
							BEGIN
								-- Create New ClientOrder and update flowsheet.							
								EXEC @ClientOrderId = Csp_SCCreateLabSoftNewClientOrder @OrderId
									,@ClientId
									,@HL7EncChars
									,@InboundMessage
									,@ClientOrderId
									,@Priority

								IF @ClientOrderId > 0
									EXEC Csp_MapLabObservationsWithFlowSheet @ClientOrderId
										,@LoincCode
										,@ClientId
										,@InboundMessage
										,@CollectionDateTime
										,@LabSoftMessageId
								ELSE
								BEGIN
									RAISERROR (
											'Error in creating new Client Order.'
											,16
											,-- Severity.                                                                      
											1 -- State.                                                                      
											);
								END
							END
						END
					END
				END
			END

			FETCH NEXT
			FROM observationResults
			INTO @LoincCode
				,@CollectionDateTime
				,@ReceivedDateTime
				,@Priority
		END

		CLOSE observationResults

		DEALLOCATE observationResults
        RETURN
		ClientIdNotFound:
        BEGIN
		-- Update the message as Finalized for no further processing.
		UPDATE LabSoftMessages
		SET MessageProcessingState = 9359, -- Finalized
		MessageStatus = 8612,
		ErrorDescription = 'Client not Found'
		WHERE LabSoftMessageId = @LabSoftMessageId

		DECLARE @ErMessage VARCHAR(500) = 'Client with FirstName:' + @ClientIdFirstNameString + ' and LastName:' + @ClientIdLastNameString + ' does not exist in the system. So setting the LabsoftMessage with LabsoftMessageId:' + Convert(VARCHAR(50), @LabSoftMessageId) + ' as finalized'

		INSERT INTO LabSoftEventLog (
			ErrorMessage
			,ErrorType
			,LabSoftMessageId
			)
		VALUES (
			@ErMessage
			,8763 -- Error
			,@LabSoftMessageId
			)
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCMapLabOrderObservationWithFlowsheet') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


