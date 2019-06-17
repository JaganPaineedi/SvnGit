/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_MessageQBP]    Script Date: 07/05/2016 14:42:29 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7_MU_MessageQBP]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7_MU_MessageQBP]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7_MU_MessageQBP]    Script Date: 07/05/2016 14:42:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7_MU_MessageQBP] 
	 @ClientId INT
	,@MessageRaw NVARCHAR(MAX) OUTPUT
AS
-- ================================================================    
-- Stored Procedure: SSP_GetHL7_MU_MessageQBP
-- Created By: Varun    
-- Create Date : June 24 2017    
-- Purpose : Generates QBP Message    
-- Script :    
/*     
 Declare @MessageRaw nVarchar(Max)    
 EXEC SSP_GetHL7_MU_MessageQBP 124458,@MessageRaw Output    
 Select @MessageRaw     
*/
BEGIN
	BEGIN TRY
		DECLARE @MessageType NVARCHAR(3)
		DECLARE @HL7Version NVARCHAR(10)
		DECLARE @QBPMessage NVARCHAR(max)
		DECLARE @SegMsg NVARCHAR(max)
		DECLARE @ErrSPName NVARCHAR(200)
		DECLARE @VendorId INT
		DECLARE @EventType INT
		SET @MessageType = 'QBP'
		SET @SegMsg = ''
		SET @ErrSPName = OBJECT_NAME(@@PROCID)

		-- set default encoding chars    
		DECLARE @HL7EncodingChars NVARCHAR(5) = '|^~\&'
		DECLARE @HL7EscapeCharsOverride NVARCHAR(5)
		SELECT @VendorId = [dbo].[ssf_GetSystemConfigurationKeyValue]('ImmunizationHistoryForecastVendorId')
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
		DECLARE @QPDSegmentRaw NVARCHAR(max)
		
		SELECT @EventType = GlobalCodeId from GlobalCodes where Category='HL7EVENTTYPE' AND Code='Q11'

		EXEC SSP_GetHL7_MU_SegmentMSH @VendorId
			,@MessageType
			,@EventType
			,@HL7EncodingChars
			,NULL
			,@MSHSegmentRaw OUTPUT

		EXEC SSP_GetHL7_MU_SegmentQPD @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@QPDSegmentRaw OUTPUT

		IF ISNULL(@MSHSegmentRaw, '') != ''
		BEGIN
			SET @QBPMessage = ISNULL(@MSHSegmentRaw, '')
		END
		
		IF ISNULL(@QPDSegmentRaw, '') != ''
		BEGIN
			SET @QBPMessage = @QBPMessage + CHAR(13) + ISNULL(@QPDSegmentRaw, '')
		END

		SET @QBPMessage = @QBPMessage + CHAR(13) + 'RCP|I|1^RD&Records&HL70126'

	
		SET @MessageRaw = @QBPMessage
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7_MU_MessageQBP') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

