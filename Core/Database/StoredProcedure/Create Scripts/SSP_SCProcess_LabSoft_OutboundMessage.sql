/****** Object:  StoredProcedure [dbo].[SSP_SCProcess_LabSoft_OutboundMessage]    Script Date: 04/12/2016 14:25:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCProcess_LabSoft_OutboundMessage]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCProcess_LabSoft_OutboundMessage]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCProcess_LabSoft_OutboundMessage]    Script Date: 04/12/2016 14:25:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCProcess_LabSoft_OutboundMessage] @OrganizationId INT
	,@DocumentVersionId INT
	,@UserCode type_CurrentUser
	,@MessageIdentity INT OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_SCProcess_LabSoft_OutboundMessage  
-- Create Date : Sep 09 2015 
-- Purpose : Create a new Lab Order Message requests to Labsoft system   
-- Created By : Gautam  
-- EXEC SSP_SCProcess_LabSoft_OutboundMessage  5307
-- ================================================================  
-- History --  
-- ================================================================  
BEGIN
	BEGIN TRY
		--Declare @Direction Int    
		DECLARE @MessageRaw NVARCHAR(max)
		DECLARE @ErrSPName NVARCHAR(200)
		--Declare @EntityType Int  
		--Declare @EntityId Int  
		--DEclare @VendorId int  
		DECLARE @ClientId INT
		--DECLARE @EventType int  
		DECLARE @MessageTypeId type_GlobalCode = 6347

		--Set @Direction =8610 -- Outbound Message.    
		SET @ErrSPName = OBJECT_NAME(@@PROCID)

		-- set default encoding chars    
		DECLARE @EncodingChars NVARCHAR(5) = '|^~\&'
		DECLARE @EscapeCharsOverride NVARCHAR(5)
		DECLARE @IDSSegmentRaw NVARCHAR(max)
		DECLARE @PIDSegmentRaw NVARCHAR(max)
		DECLARE @DIAGSegmentRaw NVARCHAR(max)
		DECLARE @INSSegmentRaw NVARCHAR(max)
		DECLARE @GUARSegmentRaw NVARCHAR(max)
		DECLARE @ORDRSegmentRaw NVARCHAR(max)
		DECLARE @DrawSegmentRaw NVARCHAR(max)
		DECLARE @OrdPhysSegmentRaw NVARCHAR(max)
		DECLARE @LocationSegmentRaw NVARCHAR(max)
		DECLARE @DiagsSegmentRaw NVARCHAR(max)
		DECLARE @TestSegmentRaw NVARCHAR(max)
		--DECLARE @QASegmentRaw NVARCHAR(max)
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @EscChar CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @ClientOrderId INT

		EXEC SSP_SCGetLabSoft_EncChars @EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@EscChar OUTPUT
			,@SubCompChar OUTPUT

		SELECT TOP 1 @ClientId = dbo.GetParseLabSoft_OUTBOUND_XFORM(CO.ClientId, @EncodingChars)
			,@ClientOrderId = dbo.GetParseLabSoft_OUTBOUND_XFORM(CO.ClientOrderId, @EncodingChars)
		FROM ClientOrders CO
		WHERE CO.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.OrderPended, 'N') = 'N'
			AND NOT EXISTS (
				SELECT 1
				FROM LabsoftMessages LM
				WHERE LM.ClientOrderId = CO.ClientOrderId
					AND ISNULL(LM.RecordDeleted, 'N') = 'N'
				)

		EXEC SSP_SCGetLabsoft_SegmentIDS @OrganizationId
			,@EncodingChars
			,@IDSSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentPID @ClientId
			,@EncodingChars
			,@PIDSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentDIAG @DocumentVersionId
			,@EncodingChars
			,@DIAGSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentINS @ClientId
			,@EncodingChars
			,@INSSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentGUAR @ClientId
			,@EncodingChars
			,@GUARSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentORDR @ClientOrderId
			,@EncodingChars
			,@ORDRSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentDraw @ClientOrderId
			,@EncodingChars
			,@DrawSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentOrdPhys @ClientOrderId
			,@EncodingChars
			,@OrdPhysSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentLocation @ClientOrderId
			,@EncodingChars
			,@LocationSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentDiags @DocumentVersionId
			,@EncodingChars
			,@DiagsSegmentRaw OUTPUT

		EXEC SSP_SCGetLabsoft_SegmentTest @DocumentVersionId
			,@EncodingChars
			,@TestSegmentRaw OUTPUT

		IF ISNULL(@IDSSegmentRaw, '') != ''
			SET @MessageRaw = ISNULL(@IDSSegmentRaw, '')
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':IDS segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@PIDSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@PIDSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

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
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@DIAGSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@DIAGSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':DIAG segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@INSSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@INSSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':INS segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@GUARSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@GUARSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':GUAR segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@ORDRSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@ORDRSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':ORDR segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@DrawSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@DrawSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':Draw segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@OrdPhysSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@OrdPhysSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':OrdPhys segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@LocationSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@LocationSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':Location segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@DiagsSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@DiagsSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':Diags segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		IF ISNULL(@TestSegmentRaw, '') != ''
		BEGIN
			SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@TestSegmentRaw, '')
		END
		ELSE
		BEGIN
			SET @MessageRaw = NULL

			INSERT INTO ErrorLog (
				ErrorMessage
				,VerboseInfo
				,DataSetInfo
				,ErrorType
				,CreatedBy
				,CreatedDate
				)
			VALUES (
				@ErrSPName + ':Test segment is null.'
				,NULL
				,NULL
				,'LabSoft Procedure Error'
				,'SmartCare'
				,GetDate()
				)
		END

		--IF ISNULL(@QASegmentRaw, '') != ''
		--BEGIN
		--	SET @MessageRaw = @MessageRaw + CHAR(13) + ISNULL(@QASegmentRaw, '')
		--END
		--ELSE
		--BEGIN
		--	SET @MessageRaw = NULL
		--	INSERT INTO ErrorLog (
		--		ErrorMessage
		--		,VerboseInfo
		--		,DataSetInfo
		--		,ErrorType
		--		,CreatedBy
		--		,CreatedDate
		--		)
		--	VALUES (
		--		@ErrSPName + ':QA segment is null.'
		--		,NULL
		--		,NULL
		--		,'LabSoft Procedure Error'
		--		,'SmartCare'
		--		,GetDate()
		--		)
		--END
		-- Insert messages to Queue table    
		
		IF Isnull(@MessageRaw, '') != ''
		BEGIN
			--SET @MessageRaw = @MessageRaw + CHAR(13) + 'SampleType' + @FieldChar + CHAR(13) + 'Container' + @FieldChar + CHAR(13) + 'DrawReq' + @FieldChar
			--SET @MessageRaw = @MessageRaw + CHAR(13) + 'TransportMode' + @FieldChar + CHAR(13) + 'TransportGroup' + @FieldChar
			INSERT INTO LabsoftMessages (
				RequestMessage
				,ClientOrderId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,MessageProcessingState
				)
			SELECT @MessageRaw
				,@ClientOrderId
				,@UserCode
				,GetDate()
				,@UserCode
				,GetDate()
				,9357 -- 9357 ReadyForProcessing  

			SELECT @MessageIdentity = Scope_Identity()

			DECLARE @EntityType INT = 8747 -- GlobalCodeId for ClientOrders    
			DECLARE @EntityId INT = @ClientOrderId

			IF ISNULL(@MessageIdentity, 0) > 0
			BEGIN
				EXEC [SSP_SCInsertLabSoftMessageLink] @UserCode
					,@MessageIdentity
					,@EntityType
					,@EntityId
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCProcess_LabSoft_OutboundMessage') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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
			,'LabSoft Procedure Error'
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


