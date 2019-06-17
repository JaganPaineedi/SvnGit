/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentMSH]    Script Date: 20-02-2018 21:33:15 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHL7_23_SegmentMSH]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetHL7_23_SegmentMSH]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetHL7_23_SegmentMSH]    Script Date: 20-02-2018 21:33:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetHL7_23_SegmentMSH] @VendorId INT
	,@ClientOrderId INT
	,@MessageType NVARCHAR(3)
	,@EventType INT
	,@HL7EncodingChars NVARCHAR(5)
	,@MSHSegmentRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================
-- Stored Procedure: ssp_GetHL7_23_SegmentMSH
-- Purpose : Generates MSH Segment
-- Script :
/* 
	Declare @MSHSegmentRaw nVarchar(max)
	EXEC [ssp_GetHL7_23_SegmentMSH] 2,1265,'A01','6347','|^~\&', @MSHSegmentRaw Output
	Select @MSHSegmentRaw
*/
-- ================================================================
-- History --
/*  Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
-- ================================================================
BEGIN
	BEGIN TRY
		DECLARE @SegmentName NVARCHAR(3)
		DECLARE @EncodingCharacters NVARCHAR(4)
		DECLARE @SendingApplication NVARCHAR(227)
		DECLARE @SendingFacility NVARCHAR(227)
			,@ClinicalLocation NVARCHAR(227)
		DECLARE @ReceivingApplication NVARCHAR(227)
		DECLARE @ReceivingFacility NVARCHAR(227)
		DECLARE @DateTimeOfMessge NVARCHAR(26)
		DECLARE @MessageControlId NVARCHAR(20)
		DECLARE @ProcessingId NVARCHAR(1)
		DECLARE @VersionId NVARCHAR(8)
		DECLARE @OverrideSPName NVARCHAR(200)
		DECLARE @MSHSegment NVARCHAR(200)
		DECLARE @MsgType NVARCHAR(10)
		DECLARE @EventTypeText NVARCHAR(3)

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

		-- get the message control ID
		EXEC SSP_SCGetHL7_MessageControlID @CurrDateTime
			,@HL7EncodingChars
			,@MessageControlID OUTPUT
		
		SELECT @OverrideSPName = StoredProcedureName  
		FROM HL7CPSegmentConfigurations  
		WHERE VendorId = @VendorId  
		AND SegmentType = @SegmentName  
		AND ISNULL(RecordDeleted, 'N') = 'N'  
   
		-- get config items		   
		SELECT @SendingApplication = dbo.HL7_OUTBOUND_XFORM(ISNULL(SendingApplication, ''), @HL7EncodingChars)
			,@SendingFacility = dbo.HL7_OUTBOUND_XFORM(ISNULL(SendingFacility, ''), @HL7EncodingChars)
			,@ReceivingApplication = dbo.HL7_OUTBOUND_XFORM(ISNULL(ReceivingApplication, ''), @HL7EncodingChars)
			,@ReceivingFacility = dbo.HL7_OUTBOUND_XFORM(ISNULL(ReceivingFacility, ''), @HL7EncodingChars)
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		SELECT @EventTypeText = dbo.[GetGlobalCodeName](@EventType)

		SET @MsgType = @MessageType + @CompChar + @EventTypeText
		SET @ProcessingId = 'P' --D->Debugging,P->Production,T->Training

		--Select the HL7 VersionId
		SELECT @VersionId = HL7Version
		FROM HL7CPVendorConfigurations
		WHERE VendorId = @VendorId

		-- Select Location Id from Client Orders for MSH4.0
		BEGIN TRY
			SELECT @ClinicalLocation = G.ExternalCode1
			FROM ClientOrders C
			JOIN GlobalCodes G ON C.ClinicalLocation = G.GlobalCodeId
			WHERE ClientOrderId = @ClientOrderId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(G.RecordDeleted, 'N') = 'N'
		END TRY

		BEGIN CATCH
		END CATCH
		
		IF ISNULL(@OverrideSPName, '') = '' 
			BEGIN
				SET @SendingFacility = ISNULL(@ClinicalLocation, @SendingFacility)
				SET @EncodingCharacters = SUBSTRING(@HL7EncodingChars, 2, 4) -- skip first char in encoding is actually the field separator which doesn't get saved in msh field 2
				SET @MSHSegment = @FieldChar + @EncodingCharacters + @FieldChar + @SendingApplication + @FieldChar + @SendingFacility + @FieldChar + @ReceivingApplication + @FieldChar + @ReceivingFacility + @FieldChar + @DateTimeOfMessge + @FieldChar + @FieldChar + @MsgType + @FieldChar + @MessageControlId + @FieldChar + @ProcessingId + @FieldChar + @VersionId
			END
		ELSE
			BEGIN  
			   --Pass the resulting string and modify in the Override SP.        
			   DECLARE @OutputString NVARCHAR(max)  
			   DECLARE @SPName NVARCHAR(max)  
			   DECLARE @ParamDef NVARCHAR(max)  
			   DECLARE @StartingString NVARCHAR(max) -- starting string to work with for override sp  
			  
			   SET @StartingString = @MSHSegment  
			   SET @SPName = 'EXEC ' + @OverrideSPName + ' @StartingString, @VendorId,@ClientOrderId,@MessageType,@EventType,@HL7EncodingChars,@OutputString OUTPUT'  
			   SET @ParamDef = N'@StartingString nvarchar(max),@VendorId int, @ClientOrderId int,@MessageType NVARCHAR(3),@EventType int,@HL7EncodingChars nVarchar(5),@OutputString nvarchar(max) OUTPUT'  
			 
			  
			   EXECUTE sp_executesql @SPName  
				,@ParamDef  
				,@StartingString  
				,@VendorId  
				,@ClientOrderId  
				,@MessageType
				,@EventType
				,@HL7EncodingChars  
				,@OutputString OUTPUT  
			  
			   SET @MSHSegment = @OutputString  
			END  
		
		SET @MSHSegmentRaw = @SegmentName + @MSHSegment
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetHL7_23_SegmentMSH') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
	END CATCH
END
GO


