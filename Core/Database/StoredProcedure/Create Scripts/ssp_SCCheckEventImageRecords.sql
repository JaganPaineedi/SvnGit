IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckEventImageRecords]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCCheckEventImageRecords]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCCheckEventImageRecords] @DocumentVersionId INT
AS
-- ============================================================================================================================     
-- Author      : K.Soujanya   
-- Date        : 04/Oct/2018  
-- Purpose     : To check image records for "Events"  
-- Updates:  
-- Date            Author      Purpose   
-- 04/Oct/2018     K.Soujanya  Created.(Partner Solutions - Enhancements #1) */  
-- ============================================================================================================================  
BEGIN
	BEGIN TRY
		DECLARE @DocumentCodeId INT = 0
		DECLARE @categoryId INT

		SELECT @DocumentCodeID = DocumentCodeId
		FROM Documents d
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId

		SET @categoryId = (
				SELECT TOP 1 RecodeCategoryId
				FROM RecodeCategories
				WHERE CategoryCode = 'EVENTATTACHMENTS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)

		IF EXISTS (
				SELECT IntegerCodeId
				FROM Recodes
				WHERE IntegerCodeId = @DocumentCodeId
					AND RecodeCategoryId = @categoryId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			SELECT DISTINCT IR.ImageRecordId
				,IR.ScannedOrUploaded
				,ReportServers.DomainName
				,ReportServers.URL
				,ReportServers.UserName
				,ReportServers.[Password]
				,ImS.ImageViewReportPath
				,ImS.ImageServerURL
				,IR.ScannedOrUploaded
			FROM Documents Doc
			JOIN DocumentVersions DV ON Doc.DocumentId = DV.DocumentId
			JOIN Events E ON Doc.EventId = E.EventId
				AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
				AND ISNULL(E.RecordDeleted, 'N') = 'N'
			JOIN ImageRecords IR ON DV.DocumentVersionId = IR.DocumentVersionId
				AND ISNULL(IR.RecordDeleted, 'N') = 'N'
			INNER JOIN ImageServers ImS ON IR.ImageServerId = ImS.ImageServerId
				AND ISNULL(ImS.RecordDeleted, 'N') = 'N'
			INNER JOIN ReportServers ON ImS.ReportServerId = ReportServers.ReportServerId
				AND ISNULL(ReportServers.RecordDeleted, 'N') = 'N'
			WHERE DV.DocumentVersionId = @DocumentVersionId
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCheckEventImageRecords') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.      
				16
				,-- Severity.      
				1 -- State.      
				);
	END CATCH
END
