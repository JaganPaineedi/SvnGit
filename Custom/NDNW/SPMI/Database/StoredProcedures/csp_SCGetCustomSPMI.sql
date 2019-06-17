/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomSPMI]    Script Date: 03/10/2015 14:29:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomSPMI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomSPMI]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomSPMI]    Script Date: 03/10/2015 14:29:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_SCGetCustomSPMI] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetCustomSPMI]   */
/*       Date              Author                  Purpose                   */
/*       27/APRIL/2015      Anto               To Retrieve Data           */
/*********************************************************************/
BEGIN
	BEGIN TRY
		 SELECT CDSM.[DocumentVersionId]
			,CDSM.[CreatedBy]
			,CDSM.[CreatedDate]
			,CDSM.[ModifiedBy]
			,CDSM.[ModifiedDate]
			,CDSM.[RecordDeleted]
			,CDSM.[DeletedBy]
			,CDSM.[DeletedDate]
			,CDSM.[Schizophrenia],
			 CDSM.[MajorDepression],
			 CDSM.[Anxiety],
			 CDSM.[Personality],
			 CDSM.[Individual]			
		FROM [CustomDocumentSPMIs] CDSM			
		WHERE CDSM.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CDSM.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomSPMI') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


