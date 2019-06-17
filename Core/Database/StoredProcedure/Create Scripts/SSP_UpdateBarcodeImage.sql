/****** Object:  StoredProcedure [SSP_UpdateBarcodeImage]    Script Date: 03/07/2012 19:41:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[SSP_UpdateBarcodeImage]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [SSP_UpdateBarcodeImage]
GO

/****** Object:  StoredProcedure [SSP_UpdateBarcodeImage]    Script Date: 03/07/2012 19:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SSP_UpdateBarcodeImage] (
	@ClientOrderId INT
	,@bytes IMAGE
	,@OrderNumber Varchar(300)
	,@CurrentUser VARCHAR(30)
	)
AS
-- =============================================        
-- Author:  Neha        
-- Create date: Jan 07, 2019     
-- Description: Updating BarCode Image Column  
/*        
 Author   Modified Date   Reason     
*/
-- =============================================      
BEGIN
	BEGIN TRY
		UPDATE ClientOrderOrderNumbers
		SET BarcodeImage = @bytes,
		  ModifiedBy = @CurrentUser,
		  ModifiedDate = GETDATE()
		WHERE ClientOrderid = @ClientOrderId
			AND OrderNumber = @OrderNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_UpdateBarcodeImage') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


