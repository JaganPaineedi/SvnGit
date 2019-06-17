/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomClientDemographics]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomASAMs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomASAMs]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomASAMs]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetCustomASAMs] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetCustomASAMs]   */
/*       Date              Author                  Purpose                   */
/*       01/DEC/2014      Akwinass               To Retrieve Data           */
/*********************************************************************/
BEGIN
	BEGIN TRY
		 SELECT [DocumentVersionId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedBy]
			,[DeletedDate]
			,[Dimension1]
			,[D1Level]
			,[D1Risk]
			,[D1Comments]
			,[Dimension2]
			,[D2Level]
			,[D2Risk]
			,[D2Comments]
			,[Dimension3]
			,[D3Level]
			,[D3Risk]
			,[D3Comments]
			,[Dimension4]
			,[D4Level]
			,[D4Risk]
			,[D4Comments]
			,[Dimension5]
			,[D5Level]
			,[D5Risk]
			,[D5Comments]
			,[Dimension6]
			,[D6Level]
			,[D6Risk]
			,[D6Comments]
			,[IndicatedReferredLevel]
			,[ProvidedLevel]
			,[FinalDeterminationComments]
			,[D1CarePlan]
			,[D2CarePlan]
			,[D3CarePlan]
			,[D4CarePlan]
			,[D5CarePlan]
			,[D6CarePlan]
		FROM [CustomDocumentASAMs]
		WHERE DocumentVersionId = @DocumentVersionId

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomASAMs') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


