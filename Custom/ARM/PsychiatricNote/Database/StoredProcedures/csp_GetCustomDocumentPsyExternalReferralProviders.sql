/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentPsyExternalReferralProviders]  ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentPsyExternalReferralProviders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_GetCustomDocumentPsyExternalReferralProviders]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentPsyExternalReferralProviders]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_GetCustomDocumentPsyExternalReferralProviders] @DocumentVersionId INT
AS
BEGIN
	BEGIN TRY
		SELECT ERP.PsychiatricPCPProviderId
			,ERP.CreatedBy
			,ERP.CreatedDate
			,ERP.ModifiedBy
			,ERP.ModifiedDate
			,ERP.RecordDeleted
			,ERP.DeletedDate
			,ERP.DeletedBy
			,ERP.DocumentVersionId
			,ERP.ExternalReferralProviderId
		FROM CustomPsychiatricPCPProviders ERP
		WHERE (ERP.DocumentVersionId = @DocumentVersionId)
			AND ISNULL(ERP.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_GetCustomDocumentPsyExternalReferralProviders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH

	RETURN
END
GO

