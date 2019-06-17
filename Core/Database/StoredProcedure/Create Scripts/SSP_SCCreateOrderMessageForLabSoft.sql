/****** Object:  StoredProcedure [dbo].[SSP_SCCreateOrderMessageForLabSoft]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCCreateOrderMessageForLabSoft]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCCreateOrderMessageForLabSoft]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCCreateOrderMessageForLabSoft]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCCreateOrderMessageForLabSoft] @DocumentVersionId INT
	,@UserCode type_CurrentUser
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Oct 19, 2015      
-- Description:      
/*      
 Author			Modified Date			Reason      
 Pradeep.A		June 22 2016			Select only ClientOrders which OrderType is Labs and LaboratoryId is not null
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LabSoftOrganizationId INT
		DECLARE @LabSoftMessageId INT
		DECLARE @PendedOrderCount INT = 0
		DECLARE @OrderCount INT = 0
		
		-- Get Pended ClientOrder Count
		SELECT @PendedOrderCount = COUNT(*)
		FROM ClientOrders CO Where CO.DocumentVersionId = @DocumentVersionId
		AND ISNULL(CO.RecordDeleted,'N')= 'N' AND ISNULL(CO.OrderPended,'N')='Y' AND OrderType='Labs' AND LaboratoryId IS NOT NULL
		
		-- Get total ClientOrder Count
		SELECT @OrderCount = COUNT(*)
		FROM ClientOrders CO Where CO.DocumentVersionId = @DocumentVersionId
		AND ISNULL(CO.RecordDeleted,'N')= 'N' AND OrderType='Labs' AND LaboratoryId IS NOT NULL
		

		SELECT @LabSoftOrganizationId = CONVERT(INT, ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('LABSOFTORGANIZATIONID'), 0))
		
		-- If all clientOrders for the DocumentVersionId below condition will allow to send the non pended Orders.
		IF @LabSoftOrganizationId > 0 AND (@PendedOrderCount != @OrderCount)
		BEGIN
			-- ======================================
			EXEC SSP_SCProcess_LabSoft_OutboundMessage @LabSoftOrganizationId
				,@DocumentVersionId
				,@UserCode
				,@LabSoftMessageId OUTPUT

			IF ISNULL(@LabSoftMessageId, '') = ''
			BEGIN
				INSERT INTO LabSoftEventLog (
					ErrorMessage
					,VerboseInfo
					,ErrorType
					,CreatedBy
					,CreatedDate
					)
				VALUES (
					'Message is not Created for sending for the DocumentVersionId :' + Convert(VARCHAR(100), @DocumentVersionId)
					,NULL
					,NULL
					,'LabSoft Procedure Error'
					,GetDate()
					)
			END
			-- ======================================		
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCCreateOrderMessageForLabSoft') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


