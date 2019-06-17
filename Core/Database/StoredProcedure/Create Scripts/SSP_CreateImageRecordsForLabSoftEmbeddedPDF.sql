/****** Object:  StoredProcedure [dbo].[SSP_CreateImageRecordsForLabSoftEmbeddedPDF]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_CreateImageRecordsForLabSoftEmbeddedPDF]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_CreateImageRecordsForLabSoftEmbeddedPDF]
GO

/****** Object:  StoredProcedure [dbo].[SSP_CreateImageRecordsForLabSoftEmbeddedPDF]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_CreateImageRecordsForLabSoftEmbeddedPDF] @ClientOrderId INT
	,@ClientId INT
	,@InboundMessage XML
	,@LabSoftMessageId INT
	,@RecordDescription VARCHAR(100)
	,@ReportByte IMAGE = NULL
	,@ImageRecordItemId INT OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Create Image Records for LabSoft Embedded PDF      
/*      
 Author			Modified Date			Reason      
 Pradeep			Apr 06 2017			DataSource of ImageRecordItems table is decided based on the SystemConfigurations.ReportServerConnection  
      
*/
-- =============================================      
BEGIN
	DECLARE @TranName VARCHAR(40) = 'LabSoftCreateImageRecordsForPDF'

	BEGIN TRY
		BEGIN
			DECLARE @DocumentVersionId AS INT = 0
			DECLARE @ImageServerId AS INT = 0
			DECLARE @ImageRecordId AS INT = 0
			DECLARE @ServerName NVARCHAR(100)
			DECLARE @DBNAME NVARCHAR(100)
		     DECLARE @TEMPLATE NVARCHAR(MAX) 

			EXEC SSP_ParseConnectionString @ServerName OUTPUT,@DBNAME OUTPUT

			-- This condition decides whether it is Requisition or Result
			IF @ReportByte IS NULL AND @InboundMessage IS NOT NULL
			BEGIN
			SELECT @ReportByte = ReportByte
							 FROM LabSoftMessages
							 WHERE LabSoftMessageId = @LabSoftMessageId
						      AND ISNULL(RecordDeleted, 'N') = 'N'
			END

			IF ISNULL(@ClientOrderId, '') = ''
			BEGIN
				SELECT @ClientOrderId = ClientOrderId
				FROM LabSoftMessages LSM
				WHERE LSM.LabSoftMessageId = @LabSoftMessageId					
					AND ISNULL(LSM.RecordDeleted, 'N') = 'N'

				IF @ClientOrderId > 0
				BEGIN
					SELECT @ClientId = ClientId
					FROM ClientOrders CO
					WHERE CO.ClientOrderId = @ClientOrderId
						AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				END
			END

			SELECT @DocumentVersionId = DocumentVersionId
			FROM ClientOrders
			WHERE ClientOrderId = @ClientOrderId

			SELECT @ImageServerId = ImageServerId
			FROM ImageServers IMG
			WHERE ISNULL(IMG.RecordDeleted, 'N') = 'N'

			IF (
					@DocumentVersionId > 0
					AND @ImageServerId > 0
					)
			BEGIN
				BEGIN TRANSACTION @TranName

				INSERT INTO ImageRecords (
					CreatedDate
					,ModifiedDate
					,ScannedOrUploaded
					,DocumentVersionId
					,ImageServerId
					,ClientId
					,AssociatedId
					,AssociatedWith
					,RecordDescription
					,EffectiveDate
					,NumberOfItems
					)
				VALUES (
					getDate()
					,getDate()
					,'U'
					,@DocumentVersionId
					,@ImageServerId
					,@ClientId
					,1625
					,5828 -- Lab Results As Structured Data
					,@RecordDescription
					,getDate()
					,1
					)

				SET @ImageRecordId = SCOPE_IDENTITY()

				IF (@ImageRecordId > 0)
				BEGIN
					INSERT INTO ClientOrderImageRecords (
						CreatedDate
						,CreatedBy
						,ModifiedBy
						,ModifiedDate
						,ClientOrderId
						,ImageRecordId
						)
					VALUES (
						GETDATE()
						,'LabSoftInboundProcedure'
						,'LabSoftInboundProcedure'
						,GETDATE()
						,@ClientOrderId
						,@ImageRecordId
						)

					CREATE TABLE #TempImageRecordItems(ImageRecordId INT,ItemNumber INT,ItemImage IMAGE,CreatedDate DATETIME,ModifiedDate DATETIME,CreateBy Varchar(30),ModifiedBy Varchar(30))

					Insert Into #TempImageRecordItems--(ImageRecordId,ItemNumber,ITEMIMAGE,
					Values(@ImageRecordId,1,@ReportByte,GETDATE(),GETDATE(),'LsService','lsService')

				     SET @TEMPLATE='INSERT INTO ['+@DBNAME+'].dbo.ImageRecordItems (
						ImageRecordId
						,ItemNumber
						,ItemImage
						,CreatedDate
						,ModifiedDate
						,CreatedBy
						,ModifiedBy
                        ,RowIdentifier
						)
					SELECT ImageRecordId,ItemNumber,ItemImage,CreatedDate,ModifiedDate,CreateBy,ModifiedBy,NEWID() FROM #TempImageRecordItems SELECT @ImageRecordItemId = SCOPE_IDENTITY()'
				     
					EXECUTE sp_executesql @TEMPLATE, N'@ImageRecordItemId INTEGER OUTPUT', @ImageRecordItemId OUTPUT
				END

				COMMIT TRANSACTION @TranName

				SELECT @ImageRecordItemId
			END
		END
	END TRY

	BEGIN CATCH
		IF EXISTS (
				SELECT 1
				FROM Sys.dm_tran_active_transactions
				WHERE NAME = @TranName
				)
			ROLLBACK TRANSACTION @TranName

		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_CreateImageRecordsForLabSoftEmbeddedPDF') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


