/****** Object:  StoredProcedure [dbo].[ssp_SCGetImageRecordServices]    Script Date: 11/24/2017 15:05:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetImageRecordServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetImageRecordServices]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetImageRecordServices]    Script Date: 11/24/2017 15:05:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 03/NOV/2017
-- Purpose     : To get image records for "Scan/Upload Service"
-- Updates:
-- Date			Author    Purpose 
-- 03/NOV/2017  Akwinass  Created.(Task #589 in Engineering Improvement Initiatives- NBL(I)) */
-- 12-MAR-2018  Akwinass  Added "SignatureDate" (Task #589.1 in Engineering Improvement Initiatives- NBL(I))
-- ============================================================================================================================
CREATE PROCEDURE [dbo].[ssp_SCGetImageRecordServices] @ServiceId INT,@ImageRecordIds VARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		IF OBJECT_ID('tempdb..#ImageRecordIds') IS NOT NULL
			DROP TABLE #ImageRecordIds

		CREATE TABLE #ImageRecordIds (ImageRecordId INT)

		INSERT INTO #ImageRecordIds (ImageRecordId)
		SELECT CAST(item AS INT)
		FROM dbo.fnSplit(@ImageRecordIds, ',')
		WHERE ISNULL(item, '') <> ''
		
		DECLARE @DocumentId INT
		DECLARE @SignatureDate DATETIME
		SELECT TOP 1 @DocumentId = DocumentId
		FROM Documents
		WHERE ServiceId = @ServiceId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT TOP 1 @SignatureDate = SignatureDate
		FROM DocumentSignatures
		WHERE DocumentId = @DocumentId
			AND SignedDocumentVersionId IS NOT NULL
			AND SignatureOrder = 1
		ORDER BY CreatedBy DESC
		
		SELECT IM.ImageRecordId
			,IM.CreatedBy
			,IM.CreatedDate
			,IM.ModifiedBy
			,IM.ModifiedDate
			,IM.RecordDeleted
			,IM.DeletedDate
			,IM.DeletedBy
			,IM.ScannedOrUploaded
			,IM.DocumentVersionId
			,IM.ImageServerId
			,IM.ClientId
			,IM.AssociatedId
			,IM.AssociatedWith
			,CASE WHEN ISNULL(IM.RecordDescription,'') = '' THEN '[untitled]' ELSE IM.RecordDescription END AS RecordDescription
			,IM.EffectiveDate
			,IM.NumberOfItems
			,IM.AssociatedWithDocumentId
			,IM.AppealId
			,IM.StaffId
			,IM.EventId
			,IM.ProviderId
			,IM.TaskId
			,IM.AuthorizationDocumentId
			,IM.ScannedBy
			,IM.CoveragePlanId
			,IM.ClientDisclosureId
			,IM.ProviderAuthorizationDocumentId
			,IM.BatchId
			,IM.PaymentId
			,IM.ServiceId
			,@SignatureDate AS SignatureDate
		FROM ImageRecords IM
		WHERE IM.ServiceId = @ServiceId
			AND ISNULL(IM.RecordDeleted,'N') = 'N'
			AND NOT EXISTS (SELECT 1 FROM #ImageRecordIds Ids WHERE Ids.ImageRecordId = IM.ImageRecordId)
		ORDER BY IM.ImageRecordId ASC		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetImageRecordServices') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


