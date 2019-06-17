/****** Object:  StoredProcedure [dbo].[SSP_GetHL7Outbound]    Script Date: 9/24/2018 5:33:39 AM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetHL7Outbound]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetHL7Outbound]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetHL7Outbound]    Script Date: 9/24/2018 5:33:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetHL7Outbound] @VendorId INT
	,@ClientOrderId INT
	,@EventType INT
	,@SeparateMessagePerOrder VARCHAR(1)
	,@MessageRaw NVARCHAR(max) OUTPUT
AS
-- ================================================================  
-- Stored Procedure: SSP_GetHL7Outbound  
-- Create Date : Oct 12 2018  
-- Purpose : Generates ADT Message  
-- Script :  
/*   
 Declare @MessageRaw nVarchar(Max)  
 EXEC SSP_GetHL7Outbound 2,372,8746,@MessageRaw Output  
 Select @MessageRaw  
*/
-- ================================================================  
/*  Date            Author      Purpose          
 Oct 12 2018     Gautam  Created ,  Gulf Bend - Enhancements, #211   
*/
-- ================================================================  
BEGIN
	BEGIN TRY
		DECLARE @MessageType NVARCHAR(3)
		DECLARE @HL7Version NVARCHAR(10)
		DECLARE @ORMMessage NVARCHAR(max)
		DECLARE @SegMsg NVARCHAR(max)
		DECLARE @ErrSPName NVARCHAR(200)
		DECLARE @ClientId INT
			,@DocumetVersionId NVARCHAR(MAX)
		DECLARE @ClientOrderCount INT
			,@RowId INT

		CREATE TABLE #ClientOrderList (
			Id INT identity(1, 1)
			,ClientOrderId INT
			)

		SELECT @ClientId = ClientId
			,@DocumetVersionId = DocumentVersionId
		FROM ClientOrders
		WHERE ClientOrderId = @ClientOrderId

		SET @MessageType = 'ORM'
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

		DECLARE @MSHSegmentRaw NVARCHAR(max) = ''
			,@EVNSegmentRaw NVARCHAR(max) = ''
			,@PIDSegmentRaw NVARCHAR(max) = ''
			,@PV1SegmentRaw NVARCHAR(max) = ''
			,@AL1SegmentRaw NVARCHAR(max) = ''
			,@DG1SegmentRaw NVARCHAR(max) = ''
			,@IN1SegmentRaw NVARCHAR(max) = ''
			,@OBRSegmentRaw NVARCHAR(max) = ''
			,@ORCSegmentRaw NVARCHAR(max) = ''
			,@OBXSegmentRaw NVARCHAR(max) = ''
			,@GT1SegmentRaw NVARCHAR(max) = ''

		-- common section for both SeparateMessagePerOrder or SeparateMessagePerOrder  
		EXEC ssp_GetHL7_23_SegmentMSH @VendorId
			,@ClientOrderId
			,@MessageType
			,@EventType
			,@HL7EncodingChars
			,@MSHSegmentRaw OUTPUT

		EXEC ssp_GetHL7_23_SegmentPID @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@PIDSegmentRaw OUTPUT

		EXEC SSP_GetHL7_23_SegmentPV1 @VendorId
			,@ClientId
			,@DocumetVersionId
			,@HL7EncodingChars
			,@PV1SegmentRaw OUTPUT

		EXEC SSP_GetHL7_23_SegmentIN1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@IN1SegmentRaw OUTPUT
		
		EXEC SSP_GetHL7_23_SegmentGT1 @VendorId
			,@ClientId
			,@HL7EncodingChars
			,@GT1SegmentRaw OUTPUT
			
		IF ISNULL(@MSHSegmentRaw, '') != ''
		BEGIN
			SET @ORMMessage = ISNULL(@MSHSegmentRaw, '')
		END

		IF ISNULL(@PIDSegmentRaw, '') != ''
		BEGIN
			SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@PIDSegmentRaw, '')
		END

		IF ISNULL(@PV1SegmentRaw, '') != ''
		BEGIN
			SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@PV1SegmentRaw, '')
		END

		IF ISNULL(@IN1SegmentRaw, '') != ''
		BEGIN
			SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@IN1SegmentRaw, '')
		END
		
		IF ISNULL(@GT1SegmentRaw, '') != ''
		BEGIN
			SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@GT1SegmentRaw, '')
		END
		
		IF @SeparateMessagePerOrder = 'N'
		BEGIN
			-- If there is more than one OrderNumber exists in ClientOrderOrderNumbers then get all ClientOrderId in list  
			INSERT INTO #ClientOrderList (ClientOrderId)
			SELECT DISTINCT ClientOrderId
			FROM #LabOrderDetails
			WHERE VendorId = @VendorId
				AND OrderNo = (
					SELECT OrderNumber
					FROM ClientOrderOrderNumbers
					WHERE ClientOrderId = @ClientOrderId
						AND isnull(RecordDeleted, 'N') = 'N'
					)

			SELECT @ClientOrderCount = Count(*)
			FROM #ClientOrderList


			SELECT * FROM #ClientOrderList

			-- ORC Segement  
			SET @RowId = 1

			WHILE @RowId <= @ClientOrderCount
			BEGIN
				SELECT @ClientOrderId = ClientOrderId
				FROM #ClientOrderList
				WHERE Id = @RowId

				EXEC ssp_GetHL7_23_SegmentORC @VendorId
					,@ClientOrderId
					,@HL7EncodingChars
					,@ORCSegmentRaw OUTPUT

				IF ISNULL(@ORCSegmentRaw, '') != ''
				BEGIN
					SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@ORCSegmentRaw, '')
				END

				EXEC ssp_GetHL7_23_SegmentOBR @VendorId
					,@ClientOrderId
					,@HL7EncodingChars
					,@OBRSegmentRaw OUTPUT

				IF ISNULL(@OBRSegmentRaw, '') != ''
				BEGIN
					SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@OBRSegmentRaw, '')
				END

				EXEC ssp_GetHL7_23_SegmentDG1 @VendorId
					,@ClientOrderId
					,@HL7EncodingChars
					,@DG1SegmentRaw OUTPUT

				IF ISNULL(@DG1SegmentRaw, '') != ''
				BEGIN
					SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@DG1SegmentRaw, '')
				END

				EXEC ssp_GetHL7_23_SegmentOBX @VendorId
					,@ClientOrderId
					,@HL7EncodingChars
					,@OBXSegmentRaw OUTPUT

				IF ISNULL(@OBXSegmentRaw, '') != ''
				BEGIN
					SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@OBXSegmentRaw, '')
				END

				SET @RowId = @RowId + 1
			END
		END
		ELSE
		BEGIN -- @SeparateMessagePerOrder ='Y'  
			EXEC ssp_GetHL7_23_SegmentORC @VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@ORCSegmentRaw OUTPUT

			EXEC ssp_GetHL7_23_SegmentOBR @VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OBRSegmentRaw OUTPUT

			EXEC ssp_GetHL7_23_SegmentDG1 @VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@DG1SegmentRaw OUTPUT

			EXEC ssp_GetHL7_23_SegmentOBX @VendorId
				,@ClientOrderId
				,@HL7EncodingChars
				,@OBXSegmentRaw OUTPUT

			IF ISNULL(@ORCSegmentRaw, '') != ''
			BEGIN
				SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@ORCSegmentRaw, '')
			END

			IF ISNULL(@OBRSegmentRaw, '') != ''
			BEGIN
				SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@OBRSegmentRaw, '')
			END

			IF ISNULL(@DG1SegmentRaw, '') != ''
			BEGIN
				SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@DG1SegmentRaw, '')
			END

			IF ISNULL(@OBXSegmentRaw, '') != ''
			BEGIN
				SET @ORMMessage = @ORMMessage + CHAR(13) + ISNULL(@OBXSegmentRaw, '')
			END
		END

		SET @MessageRaw = @ORMMessage
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetHL7Outbound') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


