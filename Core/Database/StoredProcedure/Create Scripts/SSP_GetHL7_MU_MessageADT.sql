/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_MessageADT]    Script Date: 07/05/2016 14:42:29 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_MessageADT]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_MessageADT]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_MessageADT]    Script Date: 07/05/2016 14:42:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_MessageADT] @VendorId INT
	,@ClientId INT
	,@EventType INT
	,@DocumentVersionId INT
	,@MessageRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================    
-- Stored Procedure: SSP_GetHL7_MU_MessageADT
-- Created By: Varun    
-- Create Date : June 24 2016    
-- Purpose : Generates ADT Message    
-- Script :    
/*     
 Declare @MessageRaw nVarchar(Max)    
 EXEC SSP_GetHL7_MU_MessageADT 1,3826,8775,@MessageRaw Output    
 Select @MessageRaw    
*/
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
		DECLARE @PV2SegmentRaw NVARCHAR(max)
		DECLARE @OBXSegmentRaw NVARCHAR(max)
		DECLARE @PlaceHolder1 NVARCHAR(max)
		DECLARE @PlaceHolder2 NVARCHAR(max)
		DECLARE @EventTypeText NVARCHAR(200)

		SELECT @EventTypeText = dbo.[GetGlobalCodeName](@EventType)

		EXEC SSP_GetHL7_MU_SegmentMSH @VendorId
			,@MessageType
			,@EventType
			,@HL7EncodingChars
			,@DocumentVersionId
			,@MSHSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentEVN @VendorId
			,@EventType
			,@HL7EncodingChars
			,@DocumentVersionId
			,@EVNSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentPID @VendorId
			,@ClientId
			,@HL7EncodingChars
			,'S'
			,@DocumentVersionId
			,@PIDSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentPV1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@DocumentVersionId
			,@PV1SegmentRaw OUTPUT

		--EXEC SSP_GetHL7_MU_SegmentAL1 @VendorId,@ClientId,@HL7EncodingChars,@AL1SegmentRaw Output  
		EXEC SSP_GetHL7_MU_SegmentPV2 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@DocumentVersionId
			,@PV2SegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentOBX @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@DocumentVersionId
			,@OBXSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentDG1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@DocumentVersionId
			,@DG1SegmentRaw OUTPUT

		--EXEC SSP_GetHL7_MU_SegmentIN1 @VendorId,@ClientId,@HL7EncodingChars,@IN1SegmentRaw Output    
		IF (@EventTypeText = 'A03')
		BEGIN
			SET @PlaceHolder1 = @DG1SegmentRaw
			SET @PlaceHolder2 = @OBXSegmentRaw
		END
		ELSE
		BEGIN
			SET @PlaceHolder1 = @OBXSegmentRaw
			SET @PlaceHolder2 = @DG1SegmentRaw
		END

		IF ISNULL(@MSHSegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = ISNULL(@MSHSegmentRaw, '')
		END

		--ELSE    
		-- BEGIN    
		--  SET @SegMsg=NULL    
		--  Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)    
		--  values(@ErrSPName+':MSH segment is null.',NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())      
		-- END     
		IF ISNULL(@EVNSegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@EVNSegmentRaw, '')
		END

		--ELSE    
		-- BEGIN    
		--  SET @SegMsg=NULL    
		--  Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)    
		--  values(@ErrSPName+':EVN segment is null.',NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())      
		-- END    
		IF ISNULL(@PIDSegmentRaw, '') != ''
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PIDSegmentRaw, '')

		--ELSE    
		-- BEGIN    
		--  SET @SegMsg=NULL    
		--  Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)    
		--  values(@ErrSPName+':PID segment is null.',NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())      
		-- END    
		IF ISNULL(@PV1SegmentRaw, '') != ''
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PV1SegmentRaw, '')

		--ELSE    
		-- BEGIN    
		--  SET @SegMsg=NULL    
		--  Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)    
		--  values(@ErrSPName+':PV1 segment is null.',NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())      
		-- END      
		--IF ISNULL(@AL1SegmentRaw,'')!=''    
		-- BEGIN    
		--  SET @ADTMESSAGE=@ADTMESSAGE + CHAR(13) + ISNULL(@AL1SegmentRaw,'')    
		-- END    
		IF ISNULL(@PV2SegmentRaw, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PV2SegmentRaw, '')
		END

		IF ISNULL(@PlaceHolder1, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PlaceHolder1, '')
		END

		IF ISNULL(@PlaceHolder2, '') != ''
		BEGIN
			SET @ADTMESSAGE = @ADTMESSAGE + CHAR(13) + ISNULL(@PlaceHolder2, '')
		END

		SET @MessageRaw = @ADTMessage
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_MessageADT') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

