/****** Object:  StoredProcedure [SSP_GenerateRequisitionAndDownloadPDF]    Script Date: 03/07/2012 19:41:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[SSP_GenerateRequisitionAndDownloadPDF]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [SSP_GenerateRequisitionAndDownloadPDF]
GO

/****** Object:  StoredProcedure [SSP_GenerateRequisitionAndDownloadPDF]    Script Date: 03/07/2012 19:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SSP_GenerateRequisitionAndDownloadPDF] (
	@bytes IMAGE
	,@ClientOrderId VARCHAR(500)
	,@CurrentUser VARCHAR(30)
	)
AS
-- =============================================        
-- Author:  Neha        
-- Create date: Jan 31, 2019      
-- Description: Update Lab Requisition.
/*        
 Author   Modified Date   Reason        
   
        
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @DocumentVersionId INT
		DECLARE @ImageRecordId INT
		DECLARE @ImageServerId INT

		SELECT @ClientId = ClientId
			,@DocumentVersionId = DocumentVersionId
		FROM ClientOrders
		WHERE ClientOrderId = @ClientOrderId

		SELECT @ImageServerId = ImageServerId
		FROM ImageServers

		IF NOT EXISTS (
				SELECT 1  
				FROM ImageRecords  IR
				JOIN ClientOrderImageRecords COIR ON IR.ImageRecordId = COIR.ImageRecordId  
				WHERE COIR.ClientOrderId = @ClientOrderId  
					AND IR.RecordDescription = 'Lab Requisition'
				   AND ISNULL(COIR.RecordDeleted, 'N') = 'N'  
				   AND ISNULL(IR.RecordDeleted, 'N') = 'N'
				)
		BEGIN
			INSERT INTO ImageRecords (
				CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedDate
				,DeletedBy
				,ScannedOrUploaded
				,DocumentVersionId
				,ImageServerId
				,ClientId
				,RecordDescription
				)
			VALUES (
				@CurrentUser
				,GetDate()
				,@CurrentUser
				,GetDate()
				,NULL
				,NULL
				,NULL
				,'U'
				,@DocumentVersionId
				,@ImageServerId
				,@ClientId
				,'Lab Requisition'
				)

			SET @ImageRecordId = SCOPE_IDENTITY()
		END

		IF NOT EXISTS (
				SELECT *
				FROM ImageRecordItems
				WHERE ImageRecordId = @ImageRecordId
				)
		BEGIN
			INSERT INTO ImageRecordItems (
				ImageRecordId
				,ItemNumber
				,ItemImage
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedDate
				,DeletedBy
				)
			VALUES (
				@ImageRecordId
				,1
				,@bytes
				,@CurrentUser
				,GetDate()
				,@CurrentUser
				,GetDate()
				,NULL
				,NULL
				,NULL
				)
		END

		IF NOT EXISTS (
				SELECT 1  
				FROM ImageRecords  IR
				JOIN ClientOrderImageRecords COIR ON IR.ImageRecordId = COIR.ImageRecordId  
				WHERE COIR.ClientOrderId = @ClientOrderId  
					AND COIR.ImageRecordId = @ImageRecordId
				   AND ISNULL(COIR.RecordDeleted, 'N') = 'N'  
				   AND ISNULL(IR.RecordDeleted, 'N') = 'N'
				)
		BEGIN
			INSERT INTO ClientOrderImageRecords
			VALUES (
				@CurrentUser
				,GetDate()
				,@CurrentUser
				,GetDate()
				,NULL
				,NULL
				,NULL
				,@ClientOrderId
				,@ImageRecordId
				)
		END	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GenerateRequisitionAndDownloadPDF') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


