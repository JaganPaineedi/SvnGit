/****** Object:  StoredProcedure [dbo].[SSP_SCProcessInboundLabOrderMessages]    Script Date: 12/11/2015 17:31:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCProcessInboundLabOrderMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCProcessInboundLabOrderMessages]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCProcessInboundLabOrderMessages]    Script Date: 12/11/2015 17:31:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCProcessInboundLabOrderMessages]
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Process inbound LabSoft Messages
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LabSoftMessageId INT
		DECLARE @ResultMessageXML XML
		DECLARE @ProcessedMessageCount INT
		DECLARE @LabSoftServiceUrl VARCHAR(500)
		DECLARE @TimeOut INT
		DECLARE @ServiceKey VARCHAR(100)
		DECLARE @ServiceSecret VARCHAR(100)
		DECLARE @LabSoftOrganizationId INT

		SELECT @LabSoftOrganizationId = CONVERT(INT, ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTORGANIZATIONID'), 0))

		IF @LabSoftOrganizationId > 0
		BEGIN
			SELECT @LabSoftServiceUrl = ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTWEBSERVICEURL'), '')

			SELECT @ServiceKey = AuthenticationKey
				,@ServiceSecret = AuthenticationSecret
			FROM LabSoftServiceAuthentications LSSA
			WHERE LSSA.LabSoftOrganizationId = @LabSoftOrganizationId
				AND ISNULL(LSSA.REcordDeleted, 'N') = 'N'

			SELECT @ProcessedMessageCount = CAST([dbo].[ReceiveLabOrderMessage](@LabSoftServiceUrl, 600000, @ServiceKey, @ServiceSecret) AS INT)
			
			DECLARE labSoftMessages CURSOR LOCAL FAST_FORWARD
			FOR
			SELECT LabSoftMessageId,ResultMessageXML
			FROM LabSoftMessages
			WHERE MessageProcessingState = 9359 AND MessageStatus =8611 AND ISNULL(RecordDeleted,'N') = 'N' 
			AND ResultMessageXML IS NOT NULL -- Pick messages which are ready for internal system processing

			OPEN labSoftMessages

			WHILE 1 = 1
			BEGIN
				FETCH labSoftMessages
				INTO @LabSoftMessageId,@ResultMessageXML

				IF @@fetch_status <> 0
					BREAK
				EXEC ssp_SCMapLabOrderObservationWithFlowsheet @ResultMessageXML,@LabSoftMessageId
			END

			CLOSE labSoftMessages

			DEALLOCATE labSoftMessages			
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCProcessInboundLabOrderMessages') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


