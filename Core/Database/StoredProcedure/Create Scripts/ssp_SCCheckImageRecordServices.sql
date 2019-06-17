/****** Object:  StoredProcedure [dbo].[ssp_SCCheckImageRecordServices]    Script Date: 11/24/2017 16:06:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCCheckImageRecordServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCCheckImageRecordServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCCheckImageRecordServices]    Script Date: 11/24/2017 16:06:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 24/NOV/2017
-- Purpose     : To check image records for "Service"
-- Updates:
-- Date			Author    Purpose 
-- 24/NOV/2017  Akwinass  Created.(Task #589 in Engineering Improvement Initiatives- NBL(I)) */
-- 12-MAR-2018  Akwinass  Added "NoteReplacement" column (Task #589.1 in Engineering Improvement Initiatives- NBL(I))
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[ssp_SCCheckImageRecordServices] @DocumentVersionId INT
AS
BEGIN
	BEGIN TRY
		DECLARE @ServiceId INT
		DECLARE @NoteReplacement CHAR(1)
		SELECT TOP 1 @ServiceId = S.ServiceId, @NoteReplacement = NoteReplacement
		FROM Documents Doc
		JOIN DocumentVersions DV ON Doc.DocumentId = DV.DocumentId
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
		JOIN Services S ON Doc.ServiceId = S.ServiceId
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(PC.AllowAttachmentsToService, 'N') = 'Y'
		WHERE DV.DocumentVersionId = @DocumentVersionId

		DECLARE @FromDocumentVersionId INT = 0
		IF EXISTS (
				SELECT 1
				FROM DocumentMoves
				WHERE ServiceIdTo = @ServiceId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			DECLARE @ServiceIdFrom INT			
			SELECT TOP 1 @ServiceIdFrom = ServiceIdFrom
			FROM DocumentMoves
			WHERE ServiceIdTo = @ServiceId
				AND ISNULL(RecordDeleted, 'N') = 'N'
			SELECT TOP 1 @FromDocumentVersionId = CurrentDocumentVersionId
			FROM Documents
			WHERE ServiceId = @ServiceIdFrom
				AND ISNULL(RecordDeleted, 'N') = 'N'
		END

		SELECT DISTINCT IR.ImageRecordId
			,IR.ScannedOrUploaded
			,ReportServers.DomainName
			,ReportServers.URL
			,ReportServers.UserName
			,ReportServers.[Password]
			,ImS.ImageViewReportPath
			,ImS.ImageServerURL
			,IR.ScannedOrUploaded
			,ISNULL(@NoteReplacement,'N') AS NoteReplacement			
		FROM Documents Doc
		JOIN DocumentVersions DV ON Doc.DocumentId = DV.DocumentId
		JOIN Services S ON Doc.ServiceId = S.ServiceId
			AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
		JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'			
		JOIN ImageRecords IR ON S.ServiceId = IR.ServiceId
			AND ISNULL(IR.RecordDeleted, 'N') = 'N'
		INNER JOIN ImageServers ImS ON IR.ImageServerId = ImS.ImageServerId
			AND ISNULL(ImS.RecordDeleted, 'N') = 'N'
		INNER JOIN ReportServers ON ImS.ReportServerId = ReportServers.ReportServerId
			AND ISNULL(ReportServers.RecordDeleted, 'N') = 'N'		
		WHERE DV.DocumentVersionId IN (@DocumentVersionId, @FromDocumentVersionId)
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCCheckImageRecordServices') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


