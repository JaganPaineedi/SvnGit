IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCMoveImageRecordItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCMoveImageRecordItems]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 09/APRIL/2018
-- Purpose     : To move image record items when performing move documents
-- Updates:
-- Date			Author    Purpose 
-- 09/APRIL/2018  Akwinass  Created.(Task #589.1 in Engineering Improvement Initiatives- NBL(I)) */
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[ssp_SCMoveImageRecordItems] @XMLImageRecords XML
AS
BEGIN
	BEGIN TRY
		DECLARE @UserCode VARCHAR(30)
		IF OBJECT_ID('tempdb..#FromImageRecords') IS NOT NULL
			DROP TABLE #FromImageRecords
		IF OBJECT_ID('tempdb..#FromScanImageRecords') IS NOT NULL
			DROP TABLE #FromScanImageRecords
		IF OBJECT_ID('tempdb..#FromUploadImageRecords') IS NOT NULL
			DROP TABLE #FromUploadImageRecords

		IF OBJECT_ID('tempdb..#ToImageRecords') IS NOT NULL
			DROP TABLE #ToImageRecords
		IF OBJECT_ID('tempdb..#ToScanImageRecords') IS NOT NULL
			DROP TABLE #ToScanImageRecords
		IF OBJECT_ID('tempdb..#ToUploadImageRecords') IS NOT NULL
			DROP TABLE #ToUploadImageRecords

		CREATE TABLE #FromImageRecords (ImageRecordId INT,ScannedOrUploaded CHAR(1))
		CREATE TABLE #FromScanImageRecords (ID INT IDENTITY(1,1) NOT NULL,ImageRecordId INT,ScannedOrUploaded CHAR(1),ToImageRecordId INT)		
		CREATE TABLE #FromUploadImageRecords (ID INT IDENTITY(1,1) NOT NULL,ImageRecordId INT,ScannedOrUploaded CHAR(1),ToImageRecordId INT)

		CREATE TABLE #ToImageRecords (ImageRecordId INT,ScannedOrUploaded CHAR(1))				
		CREATE TABLE #ToScanImageRecords (ID INT IDENTITY(1,1) NOT NULL,ImageRecordId INT,ScannedOrUploaded CHAR(1))		
		CREATE TABLE #ToUploadImageRecords (ID INT IDENTITY(1,1) NOT NULL,ImageRecordId INT,ScannedOrUploaded CHAR(1))

		INSERT INTO #FromImageRecords(ImageRecordId,ScannedOrUploaded)
		SELECT a.b.value('ImageRecordId[1]', 'INT')
			,a.b.value('ScannedOrUploaded[1]', 'CHAR(1)')
		FROM @XMLImageRecords.nodes('NewDataSet/FromImageRecords') a(b)
		ORDER BY a.b.value('ImageRecordId[1]', 'INT') ASC

		INSERT INTO #ToImageRecords(ImageRecordId,ScannedOrUploaded)
		SELECT a.b.value('ImageRecordId[1]', 'INT')
			,a.b.value('ScannedOrUploaded[1]', 'CHAR(1)')
		FROM @XMLImageRecords.nodes('NewDataSet/ImageRecords') a(b)
		ORDER BY a.b.value('ImageRecordId[1]', 'INT') ASC

		SELECT TOP 1 @UserCode = a.b.value('CreatedBy[1]', 'VARCHAR(30)')
		FROM @XMLImageRecords.nodes('NewDataSet/ImageRecords') a(b)
		ORDER BY a.b.value('ImageRecordId[1]', 'INT') ASC

		DELETE TR
		FROM #ToImageRecords TR
		JOIN #FromImageRecords FR ON TR.ImageRecordId = FR.ImageRecordId

		INSERT INTO #FromScanImageRecords(ImageRecordId,ScannedOrUploaded)
		SELECT ImageRecordId,ScannedOrUploaded FROM #FromImageRecords WHERE ScannedOrUploaded = 'S'		

		INSERT INTO #FromUploadImageRecords(ImageRecordId,ScannedOrUploaded)
		SELECT ImageRecordId,ScannedOrUploaded FROM #FromImageRecords WHERE ScannedOrUploaded = 'U'

		INSERT INTO #ToScanImageRecords(ImageRecordId,ScannedOrUploaded)
		SELECT ImageRecordId,ScannedOrUploaded FROM #ToImageRecords WHERE ScannedOrUploaded = 'S'

		INSERT INTO #ToUploadImageRecords(ImageRecordId,ScannedOrUploaded)
		SELECT ImageRecordId,ScannedOrUploaded FROM #ToImageRecords WHERE ScannedOrUploaded = 'U'


		UPDATE FSIR
		SET FSIR.ToImageRecordId = TSIR.ImageRecordId
		FROM #FromScanImageRecords FSIR
		JOIN #ToScanImageRecords TSIR ON FSIR.ID = TSIR.ID

		UPDATE FUIR
		SET FUIR.ToImageRecordId = TUIR.ImageRecordId
		FROM #FromUploadImageRecords FUIR
		JOIN #ToUploadImageRecords TUIR ON FUIR.ID = TUIR.ID

		IF NOT EXISTS(SELECT 1 FROM ImageRecordItems IRI JOIN #FromScanImageRecords SR ON IRI.ImageRecordId = SR.ToImageRecordId)
		BEGIN
			INSERT INTO ImageRecordItems (ImageRecordId,ItemNumber,ItemImage,CreatedBy,ModifiedBy,Thumbnail,CreatedDate,ModifiedDate)
			SELECT SR.ToImageRecordId,IRI.ItemNumber,IRI.ItemImage,@UserCode,@UserCode,IRI.Thumbnail,GETDATE(),GETDATE()
			FROM ImageRecordItems IRI
			JOIN #FromScanImageRecords SR ON IRI.ImageRecordId = SR.ImageRecordId
				AND ISNULL(IRI.RecordDeleted, 'N') = 'N'
		END

		IF NOT EXISTS(SELECT 1 FROM ImageRecordItems IRI JOIN #FromUploadImageRecords UR ON IRI.ImageRecordId = UR.ToImageRecordId)
		BEGIN
			INSERT INTO ImageRecordItems (ImageRecordId,ItemNumber,ItemImage,CreatedBy,ModifiedBy,Thumbnail,CreatedDate,ModifiedDate)
			SELECT UR.ToImageRecordId,IRI.ItemNumber,IRI.ItemImage,@UserCode,@UserCode,IRI.Thumbnail,GETDATE(),GETDATE()
			FROM ImageRecordItems IRI
			JOIN #FromUploadImageRecords UR ON IRI.ImageRecordId = UR.ImageRecordId
				AND ISNULL(IRI.RecordDeleted, 'N') = 'N'
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCMoveImageRecordItems') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


