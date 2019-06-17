/****** Object:  StoredProcedure [dbo].[ssp_LabCreateUnsolicitedClientOrder]    Script Date: 12/21/2018 4:51:57 AM ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_LabCreateUnsolicitedClientOrder]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE  [dbo].[ssp_LabCreateUnsolicitedClientOrder]
END
GO

/****** Object:  StoredProcedure [dbo].[ssp_LabCreateUnsolicitedClientOrder]    Script Date: 12/21/2018 4:51:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_LabCreateUnsolicitedClientOrder] @OrderId INT
	,@ClientId INT
	,@HL7EncChars CHAR(5)
	,@InboundMessage XML
	,@ReferenceParentClientOrderId INT
	,@VendorId INT
AS
BEGIN
	DECLARE @OrderStatus INT = 6504
		,@OrderPriority INT = 8510
		,@OrderingPhysician INT
		,@OrderScheduleId INT = 8512
		,@DocumentId INT
		,@DocumentVersionId INT
	DECLARE @OrderFlag CHAR(1) = 'Y'
	DECLARE @OrderStartDateTime DATETIME
	DECLARE @Error VARCHAR(4000)
	DECLARE @UserCode VARCHAR(100) = 'HL7 Lab Interface'

	SELECT @OrderStatus = OrderStatus
		,@OrderPriority = OrderPriorityId
		,@OrderScheduleId = OrderScheduleId
		,@OrderingPhysician = OrderingPhysician
		,@OrderFlag = OrderFlag
		,@OrderStartDateTime = OrderStartDateTime
		,@DocumentId = DocumentId
		,@DocumentVersionId = DocumentVersionId
	FROM ClientOrders
	WHERE ClientOrderId = @ReferenceParentClientOrderId

	IF (ISNULL(@DocumentId, 0) = 0)
		AND (ISNULL(@DocumentVersionId, 0) = 0)
	BEGIN
		-- NEED TO MODIFY
		DECLARE @OrderingPhysicianNPI VARCHAR(50)
		DECLARE @OrderingPhysicianFirstName VARCHAR(50)
		DECLARE @OrderingPhysicianLastName VARCHAR(50)
		DECLARE @OrderNumber VARCHAR(200)

		SELECT TOP 1 @OrderNumber = dbo.HL7_INBOUND_XFORM(T.item.value('OBR.2[1]/OBR.2.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
			,@OrderingPhysicianNPI = dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
			,@OrderingPhysicianLastName = dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.1[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
			,@OrderingPhysicianFirstName = dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.2[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars)
		FROM @InboundMessage.nodes('HL7Message/OBR') AS T(item)

		-- Get the Ordering Physician
		PRINT @OrderingPhysicianLastName
		PRINT @OrderingPhysicianFirstName
		PRINT @OrderingPhysicianNPI

		SELECT @OrderingPhysician = S.StaffId
		FROM STAFF S
		JOIN StaffLicenseDegrees SL ON S.StaffId = SL.StaffId
		WHERE (
				S.LASTNAME = @OrderingPhysicianLastName
				AND SL.LicenseNumber = @OrderingPhysicianNPI
				)
			OR (
				S.FIRSTNAME = @OrderingPhysicianFirstName
				AND SL.LicenseNumber = @OrderingPhysicianNPI
				)
			AND SL.LicenseTypeDegree = 9408 -- NPI Number
			AND ISNULL(SL.RecordDeleted, 'N') = 'N'


		--IF NO MATCH FOUND USE RECODES
		IF (ISNULL(@OrderingPhysician, 0) = 0)
		BEGIN
			SELECT top 1 @OrderingPhysician = IntegerCodeId from  dbo.ssf_RecodeValuesCurrent('LABRESULTSCOPYTOSTAFFASORDERINGPHYSICIAN')
		END

		IF (ISNULL(@OrderingPhysician, 0) = 0)
		BEGIN
			SET @Error = 'Unsolicited Lab order creation failed since Ordering Physician not found for NPI:' + isnull(@OrderingPhysicianNPI, '')

			RAISERROR (
					@Error
					,16
					,-- Severity.                                                                      
					1 -- State.                                                                      
					);
		END

		-- Get LabId based on @HL7CPQueueMessageID Input 
		DECLARE @LabId INT

		SELECT TOP 1 @LabId = l.LaboratoryId
		FROM Laboratories l
		WHERE  l.VendorId = @VendorId

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
			,@OrderingPhysician
			,'Y'
			,'Y'
			,'N'
			,@UserCode
			,Getdate()
			,@UserCode
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
			,@OrderingPhysician
			,1
			,@UserCode
			,GETDATE()
			,@UserCode
			,GETDATE()

		SET @DocumentVersionId = SCOPE_IDENTITY()

		UPDATE d
		SET CurrentDocumentVersionId = @DocumentVersionId
			,InProgressDocumentVersionId = @DocumentVersionId
		FROM Documents d
		WHERE DocumentId = @DocumentId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END

	IF (ISNULL(@DocumentId, 0) = 0)
		AND (ISNULL(@DocumentVersionId, 0) = 0)
	BEGIN
		SET @Error = 'Unsolicited Lab order creation failed since DocumentId could not be found for Order Number:'

		RAISERROR (
				@Error
				,16
				,-- Severity.                                                                      
				1 -- State.                                                                      
				);
	END

	-- NOW ADD THE ORDER
	BEGIN TRY
		INSERT INTO ClientOrders (
			ClientId
			,OrderType
			,OrderedBy
			,AssignedTo
			,OrderFlag
			,DocumentId
			,OrderId
			,MedicationOrderStrengthId
			,MedicationOrderRouteId
			,OrderPriorityId
			,OrderScheduleId
			,OrderTemplateFrequencyId
			,Active
			,OrderStartDateTime
			,OrderStatus
			,DocumentVersionId
			,OrderingPhysician
			,OrderEndDateTime
			,ParentClientOrderId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ExternalClientOrderId
			,LaboratoryId
			)
		VALUES (
			@ClientId
			,'Labs'
			,NULL
			,NULL
			,@OrderFlag
			,@DocumentId
			,@OrderId
			,NULL
			,NULL
			,@OrderPriority
			,@OrderScheduleId
			,NULL
			,'Y'
			,isnull(@OrderStartDateTime, getdate())
			,@OrderStatus
			,@DocumentVersionId
			,@OrderingPhysician
			,NULL
			,NULL
			,@UserCode
			,GETDATE()
			,@UserCode
			,GETDATE()
			,@OrderNumber
			,@LabId
			)

		RETURN SCOPE_IDENTITY()
	END TRY

	BEGIN CATCH
		SET @Error = Convert(VARCHAR(4000), ERROR_MESSAGE())

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
			,GetDate()
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


