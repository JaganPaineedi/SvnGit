/****** Object:  StoredProcedure [dbo].[SSP_SCSendOrderMessageToLabSoft]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCSendOrderMessageToLabSoft]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCSendOrderMessageToLabSoft]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCSendOrderMessageToLabSoft]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCSendOrderMessageToLabSoft] @DocumentVersionId INT
	,@UserCode type_CurrentUser
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Oct 19, 2015      
-- Description:      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LabSoftServiceUrl VARCHAR(500)
		DECLARE @TimeOut INT
		DECLARE @ServiceKey VARCHAR(100)
		DECLARE @ServiceSecret VARCHAR(100)
		DECLARE @LabSoftOutboundMessage VARCHAR(MAX)
		DECLARE @LabSoftOrganizationId INT
		DECLARE @ClientOrderId INT
		DECLARE @MessageOUTPUT INT
		DECLARE @LabSoftMessageId INT
		
		SELECT @LabSoftOrganizationId = CONVERT(INT,ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTORGANIZATIONID'),0))
		
		IF @LabSoftOrganizationId > 0
		BEGIN
			SELECT @ServiceKey = AuthenticationKey,
				   @ServiceSecret = AuthenticationSecret
			FROM LabSoftServiceAuthentications LSSA
			WHERE LSSA.LabSoftOrganizationId = @LabSoftOrganizationId
			AND ISNULL(LSSA.REcordDeleted,'N') = 'N'
			
			DECLARE LabMessages CURSOR LOCAL FAST_FORWARD FOR
				SELECT
					ClientOrderId
				FROM ClientOrders CO WHERE CO.DocumentVersionId = @DocumentVersionId AND ISNULL(CO.RecordDeleted,'N') = 'N' AND OrderType = 'Labs' 
			
			OPEN LabMessages
			WHILE 1 = 1
			BEGIN
				FETCH LabMessages INTO @ClientOrderId
				IF @@fetch_status <> 0 BREAK
				-- ======================================
				SELECT @LabSoftServiceUrl = ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTWEBSERVICEURL'),'')
				
				EXEC SSP_SCProcess_LabSoft_OutboundMessage @LabSoftOrganizationId,@ClientOrderId,@UserCode,@LabSoftMessageId OUTPUT
				
				IF ISNULL(@LabSoftMessageId,'') != ''
				BEGIN
					 
					 SELECT  @MessageOUTPUT = CAST([dbo].[SendLabOrderMessage](@LabSoftServiceUrl,
                                                              600000,
                                                              @ServiceKey,
                                                              @ServiceSecret,
                                                              @LabSoftMessageId) AS INT)
                                                              
					 IF @MessageOUTPUT <= 0
					 BEGIN
						Insert into LabSoftEventLog (ErrorMessage, VerboseInfo, ErrorType, CreatedBy, CreatedDate)    
						values('Message sending failed. Please try again.',NULL,NULL,'LabSoft Procedure Error',GetDate())    
					 END                                                             
					
				END
				ELSE
				BEGIN
					Insert into LabSoftEventLog (ErrorMessage, VerboseInfo, ErrorType, CreatedBy, CreatedDate)    
					values('Message is not Created for sending.',NULL,NULL,'LabSoft Procedure Error',GetDate())   
				END
				-- ======================================			
			END
			CLOSE LabMessages
			DEALLOCATE LabMessages
			
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCSendOrderMessageToLabSoft') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


