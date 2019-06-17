/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_MessageADT]    Script Date: 05/19/2016 14:50:10 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetHL7_251_MessageADT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetHL7_251_MessageADT]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCGetHL7_251_MessageADT]    Script Date: 05/19/2016 14:50:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCGetHL7_251_MessageADT] @VendorId INT
	,@ClientId INT
	,@EventType INT
	,@MessageRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================
-- Stored Procedure: SSP_SCGetHL7_251_MessageADT
-- Create Date : Dec 14 2014
-- Purpose : Generates ADT Message
-- Script :
/* 
	Declare @MessageRaw nVarchar(Max)
	EXEC SSP_SCGetHL7_251_MessageADT 1,24,8742,@MessageRaw Output
	Select @MessageRaw
*/
-- Created By : Pradeep.A
-- ================================================================
-- History --
-- Jul 15 2014	Pradeep.A	Changed EventType from harcoded to GlobalCOde
-- ================================================================
BEGIN
	BEGIN TRY
		DECLARE @MessageType NVARCHAR(3)
		DECLARE @HL7Version NVARCHAR(10)
		DECLARE @ADTMessage NVARCHAR(max)
		DECLARE @SegMsg NVARCHAR(max)
		DECLARE @ErrSPName NVARCHAR(200)

		SET @MessageType = 'ADT'
		SET @SegMsg = ''
		SET @ErrSPName = OBJECT_NAME(@@PROCID)

		-- set default encoding chars
		DECLARE @HL7EncodingChars NVARCHAR(5) = '|^~\&'
		DECLARE @HL7EscapeCharsOverride NVARCHAR(5)

		SELECT @HL7Version = HL7Version
			,@HL7EscapeCharsOverride = HL7EscapeChars
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		-- check if override encoding chars set
		IF ISNULL(@HL7EscapeCharsOverride, '') != ''
		BEGIN
			SET @HL7EncodingChars = @HL7EscapeCharsOverride
		END

		DECLARE @MSHSegmentRaw NVARCHAR(max)
		DECLARE @EVNSegmentRaw NVARCHAR(max)
		DECLARE @PIDSegmentRaw NVARCHAR(max)
		DECLARE @PV1SegmentRaw NVARCHAR(max)
		DECLARE @AL1SegmentRaw NVARCHAR(max)
		DECLARE @DG1SegmentRaw NVARCHAR(max)
		DECLARE @IN1SegmentRaw NVARCHAR(max)

		EXEC SSP_SCGetHL7_251_SegmentMSH @VendorId
			,@MessageType
			,@EventType
			,@HL7EncodingChars
			,@MSHSegmentRaw OUTPUT

		EXEC SSP_SCGetHL7_251_SegmentEVN @VendorId
			,@EventType
			,@HL7EncodingChars
			,@EVNSegmentRaw OUTPUT

		EXEC SSP_SCGetHL7_251_SegmentPID @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@PIDSegmentRaw OUTPUT

		EXEC SSP_SCGetHL7_251_SegmentPV1 @VendorId
			,@ClientId
			,@MessageType
			,@EventType
			,@HL7EncodingChars
			,@PV1SegmentRaw OUTPUT

		EXEC SSP_SCGetHL7_251_SegmentAL1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@AL1SegmentRaw OUTPUT

		EXEC SSP_SCGetHL7_251_SegmentDG1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@DG1SegmentRaw OUTPUT

		EXEC SSP_SCGetHL7_251_SegmentIN1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@IN1SegmentRaw OUTPUT

		IF ISNULL(@MSHSegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = ISNULL(@MSHSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @SegMsg = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':MSH segment is null.'
				,NULL
				,NULL
				,'HL7 Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@EVNSegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@EVNSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @SegMsg = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':EVN segment is null.'
				,NULL
				,NULL
				,'HL7 Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@PIDSegmentRaw, '') != ''
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PIDSegmentRaw, '')
		ELSE
		BEGIN
			SET @SegMsg = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':PID segment is null.'
				,NULL
				,NULL
				,'HL7 Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@PV1SegmentRaw, '') != ''
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PV1SegmentRaw, '')
		ELSE
		BEGIN
			SET @SegMsg = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':PV1 segment is null.'
				,NULL
				,NULL
				,'HL7 Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@AL1SegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@AL1SegmentRaw, '')
		END

		IF ISNULL(@DG1SegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@DG1SegmentRaw, '')
		END

		IF ISNULL(@IN1SegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@IN1SegmentRaw, '')
		END

		IF @SegMsg IS NULL
		BEGIN
			SET @ADTMESSAGE = NULL
		END

		SET @MessageRaw = @ADTMessage
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetHL7_251_MessageADT') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


