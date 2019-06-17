/****** Object:  StoredProcedure [dbo].[SSP_CreateUnsolicitedOrdersFromLabs]    Script Date: 1/10/2017 12:52:36 PM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_CreateUnsolicitedOrdersFromLabs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_CreateUnsolicitedOrdersFromLabs]
GO

/****** Object:  StoredProcedure [dbo].[SSP_CreateUnsolicitedOrdersFromLabs]    Script Date: 1/10/2017 12:52:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_CreateUnsolicitedOrdersFromLabs] @InboundMessage XML
	,@MainClientOrderId INT OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Jan 16, 2016  
-- Description: Create unsolicited Orders      
/*      
 Author			Modified Date			Reason      
 Pradeep			24/Feb/2017		    ExternalOrderId exists check added in the LabSoftEventLog
 Pradeep			3/3/2017			Added Two transaction for Log in LabSoftEventLog and MainTransaction 
 Pradeep			Sept 24 2018		What: Added ISNUMERIC check to avoid conversion error. Why: AHN-Support Go Live #146.1
*/
-- =============================================      
BEGIN
	DECLARE @ClientId INT
	DECLARE @ClientIdText VARCHAR(100)
	DECLARE @ClientOrderId INT
	DECLARE @OrderPhysicianId INT
	DECLARE @LaboratoryId INT
	DECLARE @ReferenceLabId VARCHAR(50)
	DECLARE @DocumentId INT
	DECLARE @DocumentVersionId INT
	DECLARE @ExternalOrderId VARCHAR(100)
	DECLARE @OrderId INT
	DECLARE @Priority VARCHAR(50)
	DECLARE @PriorityId INT
	DECLARE @OrdereSheduleId INT
	DECLARE @OrderTemplateFrequencyId INT
	DECLARE @HL7EncChars NVARCHAR(5) = '|^~\&'
	DECLARE @OrderingPhysicianFirstName VARCHAR(50)
	DECLARE @OrderingPhysicianLastName VARCHAR(50)
	DECLARE @LabSoftMessageId INT
	DECLARE @CreatedBy VARCHAR(100) = 'CreateUnsolicitedOrders'
	DECLARE @ClientIdFirstNameString VARCHAR(MAX)
	DECLARE @ClientIdLastNameString VARCHAR(MAX)
	DECLARE @ClientDOBString VARCHAR(MAX)
	DECLARE @ClientSSNString VARCHAR(MAX)
	DECLARE @MainTransaction VARCHAR(100) = 'MAINTRANSACTION'
	DECLARE @EventLogTransaction VARCHAR(100) = 'EVENTLOG'
	
	BEGIN TRY
		SELECT @ReferenceLabId = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.5[1]/MSH.5.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

		SELECT @ClientIdText = dbo.HL7_INBOUND_XFORM(T.item.value('PID.2[1]/PID.2.0[1]/ITEM[1]', 'VARCHAR(MAX)'), @HL7EncChars)
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
			IF ISNUMERIC(@ClientIdText) = 1
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM Clients
						WHERE CLientId = CONVERT(INT, @ClientIdText)
							AND Active = 'Y'
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					SELECT @ClientId = ClientId
					FROM Clients
					WHERE CLientId = CONVERT(INT, @ClientIdText)
						AND Active = 'Y'
						AND ISNULL(RecordDeleted, 'N') = 'N'
				END
			END
			ELSE IF EXISTS (
					SELECT 1
					FROM Clients
					WHERE CONVERT(VARCHAR(10), DOB, 112) = @ClientDOBString
						AND SSN = @ClientSSNString
						AND Active = 'Y'
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				SELECT @ClientId = ClientId
				FROM Clients
				WHERE CONVERT(VARCHAR(10), DOB, 112) = @ClientDOBString
					AND SSN = @ClientSSNString
					AND Active = 'Y'
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
			ELSE
				GOTO ClientIdNotFound
		END

		BEGIN TRAN @MainTransaction

		DECLARE db_cursor CURSOR
		FOR
		SELECT dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.1[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.2[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.5[1]/OBR.5.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/OBR') AS T(item)

		OPEN db_cursor

		FETCH NEXT
		FROM db_cursor
		INTO @OrderingPhysicianLastName
			,@OrderingPhysicianFirstName
			,@ExternalOrderId
			,@Priority

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @OrderId = NULL
			SET @OrderPhysicianId = NULL
			SET @PriorityId = NULL
			SET @OrdereSheduleId = NULL
			SET @OrderTemplateFrequencyId = NULL
			SET @LaboratoryId = NULL

			SELECT @OrderId = OrderId
			FROM OrderLabs
			WHERE ExternalOrderId = @ExternalOrderId
			AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT TOP 1 @LaboratoryId = LaboratoryId
			FROM Laboratories
			WHERE ReferenceLabId = @ReferenceLabId
			AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT TOP 1 @OrderPhysicianId = StaffId
			FROM Staff S
			WHERE S.FirstName = @OrderingPhysicianFirstName
				AND S.LastName = @OrderingPhysicianLastName
				AND S.Active = 'Y'
				AND ISNULL(S.RecordDeleted, 'N') = 'N'

			SELECT @PriorityId = ISNULL(PriorityId, dbo.ssf_GetSystemConfigurationKeyValue('DEFAULTORDERPRIORITYID'))
			FROM OrderPriorities
			WHERE OrderId = @OrderId
				AND IsDefault = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT @OrdereSheduleId = ISNULL(ScheduleId, dbo.ssf_GetSystemConfigurationKeyValue('DEFAULTORDERSCHEDULEID'))
			FROM OrderSchedules
			WHERE OrderId = @OrderId
				AND IsDefault = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT @OrderTemplateFrequencyId = ISNULL(OrderTemplateFrequencyId, dbo.ssf_GetSystemConfigurationKeyValue('DEFAULTORDERTEMPLATEFREQUENCYID'))
			FROM OrderFrequencies
			WHERE OrderId = @OrderId
				AND IsDefault = 'Y'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			IF @OrderId > 0
			BEGIN
				IF (
						ISNULL(@ClientOrderId, '') = ''
						AND ISNULL(@DocumentId, '') = ''
						AND ISNULL(@DocumentVersionId, '') = ''
						)
				BEGIN
					INSERT INTO DOCUMENTS (
						ClientId
						,DocumentCodeId
						,EffectiveDate
						,STATUS
						,AuthorId
						,DocumentShared
						,SignedByAuthor
						,SignedByAll
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,CurrentVersionStatus
						)
					SELECT @ClientId
						,1506
						,GETDATE()
						,22
						,@OrderPhysicianId
						,'Y'
						,'Y'
						,'N'
						,@CreatedBy
						,Getdate()
						,@CreatedBy
						,Getdate()
						,22

					SET @DocumentId = SCOPE_IDENTITY()

					INSERT INTO DocumentVersions (
						DocumentId
						,Version
						,AuthorId
						,RevisionNumber
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					SELECT @DocumentId
						,1
						,@OrderPhysicianId
						,1
						,@CreatedBy
						,GETDATE()
						,@CreatedBy
						,GETDATE()

					SET @DocumentVersionId = SCOPE_IDENTITY()

					UPDATE d
					SET CurrentDocumentVersionId = @DocumentVersionId
						,InProgressDocumentVersionId = @DocumentVersionId
					FROM Documents d
					WHERE DocumentId = @DocumentId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				END
				ELSE
				BEGIN
					SELECT @DocumentId = DocumentId
						,@DocumentVersionId = DocumentVersionId
					FROM ClientOrders CO
					WHERE Co.ClientOrderId = @ClientOrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				END

				INSERT INTO ClientOrders (
					ClientId
					,OrderType
					,OrderedBy
					,OrderFlag
					,LaboratoryId
					,DocumentId
					,OrderId
					,OrderPriorityId
					,OrderScheduleId
					,OrderTemplateFrequencyId
					,MedicationUseOtherUsage
					,Active
					,OrderPended
					,OrderDiscontinued
					,OrderStartOther
					,OrderStartDateTime
					,OrderMode
					,OrderStatus
					,DocumentVersionId
					,OrderPendAcknowledge
					,OrderPendRequiredRoleAcknowledge
					,OrderingPhysician
					,FlowSheetDateTime
					,DispenseBrand
					,IsReadBackAndVerified
					,MayUseOwnSupply
					,MaySelfAdminister
					,ConsentIsRequired
					,IsPRN
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				VALUES (
					@ClientId
					,'Labs'
					,@OrderPhysicianId
					,'Y'
					,@LaboratoryId
					,@DocumentId
					,@OrderId
					,@PriorityId
					,@OrdereSheduleId
					,@OrderTemplateFrequencyId
					,'N'
					,'Y'
					,'N'
					,'N'
					,'Y'
					,GETDATE()
					,8508 -- Verbal (ORDERMODE)  
					,6509 -- Active (ORDERSTATUS)  
					,@DocumentVersionId
					,'N'
					,'N'
					,@OrderPhysicianId
					,NULL
					,'N'
					,'N'
					,'N'
					,'N'
					,'N'
					,'N'
					,@CreatedBy
					,GETDATE()
					,@CreatedBy
					,GETDATE()
					)

				SET @ClientOrderId = SCOPE_IDENTITY()

				IF (
						@ClientOrderId > 0
						AND NOT EXISTS (
							SELECT 1
							FROM LabSoftMessages LS
							JOIN CLientOrders Co ON Co.CLientOrderId = LS.ClientOrderId
							WHERE CO.DocumentID = @DocumentId
								AND CO.DocumentVersionId = @DocumentVersionId
								AND ISNULL(LS.RecordDeleted, 'N') = 'N'
								AND ISNULL(CO.RecordDeleted, 'N') = 'N'
							)
						)
				BEGIN
					SET @MainClientOrderId = @ClientOrderId

					INSERT INTO LabSoftMessages (
						ClientOrderId
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@MainClientOrderId
						,@CreatedBy
						,GETDATE()
						,@CreatedBy
						,GETDATE()
						)

					SET @LabSoftMessageId = SCOPE_IDENTITY()
				END
			END
			ELSE
			BEGIN
				BEGIN TRAN @EventLogTransaction
					INSERT INTO LabSoftEventLog (
						ErrorMessage
						,ErrorType
						,LabSoftMessageId
						,VerboseInfo
						)
					VALUES (
						'Could not find a matching Order for ExternalOrderId:' + @ExternalOrderId + '. Abort processing'
						,8763 -- Error
						,NULL
						,CONVERT(VARCHAR(MAX), @InboundMessage)
						)
				COMMIT TRAN	@EventLogTransaction
			END

			FETCH NEXT
			FROM db_cursor
			INTO @OrderingPhysicianLastName
				,@OrderingPhysicianFirstName
				,@ExternalOrderId
				,@Priority
		END

		CLOSE db_cursor

		DEALLOCATE db_cursor

		IF @LabSoftMessageId > 0
			COMMIT TRAN @MainTransaction
		ELSE IF @@TRANCOUNT > 0
		BEGIN
			SET @MainClientOrderId = NULL

			ROLLBACK TRANSACTION @MainTransaction
		END

		RETURN

		ClientIdNotFound:

		BEGIN
			DECLARE @ErMessage VARCHAR(500) = 'Client with FirstName:' + @ClientIdFirstNameString + ' and LastName:' + @ClientIdLastNameString + ' does not exist in the system.'
			BEGIN TRAN @EventLogTransaction
				INSERT INTO LabSoftEventLog (
					ErrorMessage
					,ErrorType
					,LabSoftMessageId
					,VerboseInfo
					)
				VALUES (
					@ErMessage
					,8763 -- Error
					,NULL
					,CONVERT(VARCHAR(MAX), @InboundMessage)
					)
			COMMIT TRAN	@EventLogTransaction
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_CreateUnsolicitedOrdersFromLabs') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION @MainTransaction

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                   
				16
				,
				-- Severity.                                                                                   
				1
				-- State.                                                                                   
				);
	END CATCH
END

GO


