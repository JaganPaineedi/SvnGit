/****** Object:  StoredProcedure [SSP_ProcessUnMatchedMessage]    Script Date: 03/07/2012 19:41:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[SSP_ProcessUnMatchedMessage]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [SSP_ProcessUnMatchedMessage]
GO

/****** Object:  StoredProcedure [SSP_ProcessUnMatchedMessage]    Script Date: 03/07/2012 19:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SSP_ProcessUnMatchedMessage] (
	@HL7CPQueueMessageID INT
	,@ClientId INT
	,@ClientOrderId INT
	,@Usercode VARCHAR(20)
	)
AS
-- =============================================        
-- Author:  Shankha        
-- Create date: Oct 15, 2018      
-- Description:       
/*        
 Author   Modified Date   Reason        
   
        
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ItemNode XML = '<ITEM>' + CAST(@ClientOrderId AS VARCHAR(20)) + '</ITEM>'
		DECLARE @StoredProcedureName NVARCHAR(400)
			,@sqlStr NVARCHAR(max)
			,@VendorId INT
			,@MessageXML XML
			,@OutputParamter NVARCHAR(Max)

		--Replace the Client Id  
		UPDATE HL7CPQueueMessages
		SET MessageXML.modify('replace value of  
(/HL7Message/PID/PID.2/PID.2.0/ITEM/text())[1] with (sql:variable("@ClientId"))  
')
		WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

		--Delete the first Client Order's Place Holder Field Value  
		UPDATE HL7CPQueueMessages
		SET MessageXML.modify('delete (/HL7Message/OBR/OBR.18/OBR.18.0/ITEM)[1]')
		WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

		--Insert first Client Order's Place Holder Field Value  
		UPDATE HL7CPQueueMessages
		SET MessageXML.modify('insert  
sql:variable("@ItemNode") into   
(/HL7Message/OBR/OBR.18/OBR.18.0)[1]')
		WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

		SELECT @StoredProcedureName = m.StoredProcedureName
			,@VendorId = h.CPVendorConnectorID
			,@MessageXML = h.MessageXML
		FROM HL7CPQueueMessages h
		JOIN HL7CPMessageConfigurations m ON m.VendorId = h.CPVendorConnectorID
			AND m.MessageType = 'ORM'
		WHERE h.HL7CPQueueMessageID = @HL7CPQueueMessageID
			AND ISNULL(h.RecordDeleted, 'N') = 'N'
			AND ISNULL(m.RecordDeleted, 'N') = 'N'

		SET @sqlStr = 'EXEC ' + @StoredProcedureName + ' ' + cast(@VendorId AS NVARCHAR(max)) + ',' + cast(@MessageXML AS NVARCHAR(max)) + cast(@HL7CPQueueMessageID AS NVARCHAR(max)) + ',@outputMessage OUTPUT'

		EXECUTE sp_executesql @sqlStr
			,N'@outputMessage nvarchar(max) OUTPUT'
			,@OutputParamter OUTPUT

		IF @OutputParamter IS NOT NULL
		BEGIN
			UPDATE HL7CPQueueMessages
			SET ErrorDescription = @OutputParamter
				,ModifiedDate = GETDATE()
				,ModifiedBy = @Usercode
			WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID
		END
		ELSE
		BEGIN
			UPDATE HL7CPQueueMessages
			SET ErrorDescription = ''
				,MessageProcessingState = 8616 --Finalized
				,MessageStatus = 8611 -- Success
				,ClientId = @ClientId
				,PotentialClientId = NULL
				,FivePointMatch = 'Y'
				,ModifiedDate = GETDATE()
				,ModifiedBy = @Usercode
			WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_ProcessUnMatchedMessage') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


