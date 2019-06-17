IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIndividualServiceNoteDiagnoses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIndividualServiceNoteDiagnoses] 
GO

CREATE PROCEDURE [dbo].[csp_RDLIndividualServiceNoteDiagnoses] (
	@DocumentVersionId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLIndividualServiceNoteDiagnoses]   */
/*       Date              Author                  Purpose                   */
/*       03/02/2015        Bernardin               To get CustomIndividualServiceNoteDiagnoses table vlaues */
/*********************************************************************/
BEGIN
	BEGIN TRY
	
	SELECT     CISND.DocumentVersionId, CISND.DSMCode, 
                      CISND.DSMNumber, CISND.DSMVCodeId, CISND.ICD10Code, 
                      CISND.ICD9Code, CISND.[Order], 
                      CISND.IndividualServiceNoteDiagnosisId,
                      DiagnosisICD10Codes.ICDDescription
FROM         CustomIndividualServiceNoteDiagnoses CISND INNER JOIN
                      DiagnosisICD10Codes ON CISND.DSMVCodeId = DiagnosisICD10Codes.ICD10CodeId
              WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,'N') = 'N'
	
	END TRY
	BEGIN CATCH
DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIndividualServiceNoteDiagnoses') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	
	END CATCH
END