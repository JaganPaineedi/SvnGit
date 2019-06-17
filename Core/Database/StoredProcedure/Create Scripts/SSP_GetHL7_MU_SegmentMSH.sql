/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentMSH]    Script Date: 06/10/2016 01:33:51 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_SegmentMSH]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentMSH]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_SegmentMSH]    Script Date: 06/10/2016 01:33:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_SegmentMSH] @VendorId INT
	,@MessageType NVARCHAR(3)
	,@EventType INT
	,@HL7EncodingChars NVARCHAR(5)
	,@DocumentVersionId INT =NULL
	,@MSHSegmentRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================
-- Stored Procedure: SSP_GetHL7_MU_SegmentMSH
-- Create Date : June 15 2016
-- Purpose : Generates MSH Segment
-- Script :
/* 
	Declare @MSHSegmentRaw nVarchar(max)
	EXEC [SSP_GetHL7_MU_SegmentMSH] 1,'ADT','A01','|^~\&', @MSHSegmentRaw Output
	Select @MSHSegmentRaw
*/
-- Created By : Varun
-- ================================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @EncodingCharacters NVARCHAR(4)
		DECLARE @SendingApplication NVARCHAR(227)
		DECLARE @SendingFacility NVARCHAR(227)
		DECLARE @ReceivingApplication NVARCHAR(227)
		DECLARE @ReceivingFacility NVARCHAR(227)
		DECLARE @DateTimeOfMessge NVARCHAR(26)
		DECLARE @MessageControlId NVARCHAR(20)
		DECLARE @ProcessingId NVARCHAR(1)
		DECLARE @VersionId NVARCHAR(8)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @MSHSegment NVARCHAR(max)
		DECLARE @MsgType NVARCHAR(20)
		DECLARE @EventTypeText NVARCHAR(3)
		DECLARE @MsgTypeExt NVARCHAR(20)
		DECLARE @AcceptanceAckType NVARCHAR(20)
		DECLARE @AppAckType NVARCHAR(20)
		DECLARE @MsgProfilerId NVARCHAR(250)

		SET @SegmentName = 'MSH'

		-- pull out encoding characters
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		DECLARE @CurrDateTime DATETIME = GETDATE()

		SELECT @DateTimeOfMessge = dbo.GetDateFormatForHL7(@CurrDateTime, @HL7EncodingChars)
		IF (@MessageType = 'QBP' OR @MessageType = 'VXU')
		SET @DateTimeOfMessge= @DateTimeOfMessge +'-0500'

		-- get the message control ID
		EXEC SSP_SCGetHL7_MessageControlID @CurrDateTime
			,@HL7EncodingChars
			,@MessageControlID OUTPUT

		-- get config items		   
		SELECT @SendingApplication = dbo.HL7_OUTBOUND_XFORM(ISNULL(SendingApplication, ''), @HL7EncodingChars)
			,@SendingFacility = SendingFacility
			,@ReceivingApplication = dbo.HL7_OUTBOUND_XFORM(ISNULL(ReceivingApplication, ''), @HL7EncodingChars)
			,@ReceivingFacility = dbo.HL7_OUTBOUND_XFORM(ISNULL(ReceivingFacility, ''), @HL7EncodingChars)
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		SELECT @EventTypeText = dbo.[GetGlobalCodeName](@EventType)

		IF (@MessageType = 'ADT')
		BEGIN
			IF (@EventTypeText <> 'A03')
				SET @MsgTypeExt = @MessageType + '_A01'
			ELSE
				SET @MsgTypeExt = @MessageType + '_A03'
		END
		ELSE IF (@MessageType = 'VXU')
			SET @MsgTypeExt = @MessageType + '_V04'
		ELSE IF (@MessageType = 'ACK')
			SET @MsgTypeExt = @MessageType
		ELSE IF (@MessageType = 'QBP')
			SET @MsgTypeExt = @MessageType + '_Q11'
		SET @MsgType = @MessageType + @CompChar + @EventTypeText + @CompChar + @MsgTypeExt
		SET @ProcessingId = 'P' --D->Debugging,P->Production,T->Training

		--Select the HL7 VersionId
		SELECT @VersionId = HL7Version
			,@AcceptanceAckType = AcceptAckType
			,@AppAckType = AppAckType
			,@MsgProfilerId = MessageProfileIdentifier
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		SET @EncodingCharacters = SUBSTRING(@HL7EncodingChars, 2, 4) -- skip first char in encoding is actually the field separator which doesn't get saved in msh field 2
		IF (@MessageType = 'VXU')
			SET @MSHSegment = @FieldChar + @EncodingCharacters + @FieldChar + @SendingApplication + '^2.16.840.1.113883.3.72.5.40.1^ISO' + @FieldChar + @SendingFacility + '^2.16.840.1.113883.3.72.5.40.2^ISO' + @FieldChar + @ReceivingApplication +'^2.16.840.1.113883.3.72.5.40.3^ISO' + @FieldChar + @ReceivingFacility +'^2.16.840.1.113883.3.72.5.40.4^ISO' + @FieldChar + @DateTimeOfMessge + @FieldChar + @FieldChar + @MsgType + @FieldChar + @MessageControlId + @FieldChar + @ProcessingId + @FieldChar + @VersionId + @FieldChar + @FieldChar + @FieldChar + ISNULL(@AcceptanceAckType, '') + @FieldChar + ISNULL(@AppAckType, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@MsgProfilerId, '')
		ELSE
			SET @MSHSegment = @FieldChar + @EncodingCharacters + @FieldChar + @SendingApplication + @FieldChar + @SendingFacility + @FieldChar + @ReceivingApplication + @FieldChar + @ReceivingFacility + @FieldChar + @DateTimeOfMessge + @FieldChar + @FieldChar + @MsgType + @FieldChar + @MessageControlId + @FieldChar + @ProcessingId + @FieldChar + @VersionId + @FieldChar + @FieldChar + @FieldChar + ISNULL(@AcceptanceAckType, '') + @FieldChar + ISNULL(@AppAckType, '') + @FieldChar + @FieldChar + @FieldChar + @FieldChar + @FieldChar + ISNULL(@MsgProfilerId, '')
		SET @MSHSegmentRaw = LTRIM(RTRIM(@SegmentName + @MSHSegment))

		IF (@MessageType <> 'ADT')
		BEGIN
			IF(@MessageType = 'QBP')
				SET @MSHSegmentRaw = LTRIM(RTRIM(@MSHSegmentRaw + @FieldChar + @SendingFacility+'^^^^^NIST-AA-1^XX^^^100-6482' + @FieldChar + @ReceivingFacility+'^^^^^NIST-AA-1^XX^^^100-3322'))
			ELSE IF(@MessageType = 'VXU')
				SET @MSHSegmentRaw = LTRIM(RTRIM(@MSHSegmentRaw + @FieldChar + @SendingFacility+'^^^^^NIST-AA-IZ-1&2.16.840.1.113883.3.72.5.40.9&ISO^XX^^^100-6482' + @FieldChar + @ReceivingFacility+'^^^^^NIST-AA-IZ-1&2.16.840.1.113883.3.72.5.40.9&ISO^XX^^^100-3322'))
			ELSE
				SET @MSHSegmentRaw = LTRIM(RTRIM(@MSHSegmentRaw + @FieldChar + @SendingFacility + @FieldChar + @ReceivingFacility))
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_SegmentMSH') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

