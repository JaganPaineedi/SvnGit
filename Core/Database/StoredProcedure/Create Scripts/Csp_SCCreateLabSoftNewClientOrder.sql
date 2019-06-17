/****** Object:  StoredProcedure [dbo].[Csp_SCCreateLabSoftNewClientOrder]    Script Date: 02/17/2014 14:30:28 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[Csp_SCCreateLabSoftNewClientOrder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[Csp_SCCreateLabSoftNewClientOrder]
GO

/****** Object:  StoredProcedure [dbo].[Csp_SCCreateLabSoftNewClientOrder]    Script Date: 02/17/2014 14:30:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Csp_SCCreateLabSoftNewClientOrder] @OrderId INT
	,@ClientId INT
	,@HL7EncChars CHAR(5)
	,@InboundMessage XML
	,@MainClientOrderId INT
	,@Priority CHAR(1)
AS
BEGIN
	DECLARE @OrderStatus INT
	DECLARE @OrderPriorityValue CHAR(1)
	DECLARE @OrderPriority INT
	DECLARE @OrderStartDateTime DATETIME
	DECLARE @Error VARCHAR(4000)
	DECLARE @LaboratoryId INT
	DECLARE @OrderedBy INT
	DECLARE @DocumentId INT
	DECLARE @PriorityId INT
	DECLARE @OrdereSheduleId INT
	DECLARE @OrderTemplateFrequencyId INT
	DECLARE @DocumentVersionId INT
	DECLARE @OrderStartOther CHAR(1)
	DECLARE @OrderingPhysician INT

	SELECT @LaboratoryId = [dbo].[sfn_GetLaboratoryId](T.item.value('MSH.5[1]/MSH.5.0[1]/ITEM[1]', 'Varchar(50)'))
	FROM @InboundMessage.nodes('HL7Message/MSH') AS T(item)

	SELECT @OrderStatus = dbo.GetOrderStatus(dbo.HL7_INBOUND_XFORM(T.item.value('ORC.5[1]/ORC.5.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars))
		,@OrderStartDateTime = dbo.GetOrderStartDate(dbo.HL7_INBOUND_XFORM(T.item.value('ORC.7[1]/ORC.7.3[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars))
		,@OrderPriorityValue = dbo.HL7_INBOUND_XFORM(T.item.value('ORC.7[1]/ORC.7.5[1]/ORC.7.5.0[1]/ITEM[1]', 'Varchar(10)'), @HL7EncChars)
	FROM @InboundMessage.nodes('HL7Message/ORC') AS T(item)
	
	SELECT @PriorityId = GlobalCodeId
	FROM GlobalCodes
	WHERE Category = 'ORDERPRIORITY'
		AND ExternalCode1 = @OrderPriorityValue

	SELECT @OrderedBy = OrderedBy
		,@DocumentId = DocumentId
		,@OrdereSheduleId = OrderScheduleId
		,@OrderTemplateFrequencyId = OrderTemplateFrequencyId
		,@DocumentVersionId = DocumentVersionId
		,@OrderStartOther = OrderStartOther
		,@OrderingPhysician = OrderingPhysician
	FROM ClientOrders
	WHERE CLientOrderId = @MainClientOrderId

	IF @OrderStartOther = 'Y'
		SET @OrderStartDateTime = GETDATE()
		
	IF ISNULL(@OrderStartDateTime,'') = ''
		SET @OrderStartDateTime = GETDATE()
	

	BEGIN TRY
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
			)
		VALUES (
			@ClientId
			,'Labs'
			,@OrderedBy
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
			,@OrderStartOther
			,@OrderStartDateTime
			,8508 -- Verbal (ORDERMODE)
			,6509 -- Active (ORDERSTATUS)
			,@DocumentVersionId
			,'N'
			,'N'
			,@OrderingPhysician
			,NULL
			,'N'
			,'N'
			,'N'
			,'N'
			,'N'
			,'N'
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
			,'SmartCare'
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


