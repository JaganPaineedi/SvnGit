IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportPsychiatricNoteAIMS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportPsychiatricNoteAIMS] --949
GO

CREATE PROCEDURE [dbo].[csp_RDLSubReportPsychiatricNoteAIMS] (
	@DocumentVersionId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLSubReportPsychiatricNoteAIMS]   */
/*       Date              Author                  Purpose          */
/*       14/07/2015        Vijay              What:SubReport for Psychiatric Note AIMS tab   */
/* 												  Why:task #329 Woods-Customizations    */
/*********************************************************************/
BEGIN
	BEGIN TRY

	SELECT 
		CDPA.DocumentVersionId
		,CDPA.CreatedBy
		,CDPA.CreatedDate
		,CDPA.ModifiedBy
		,CDPA.ModifiedDate
		,CDPA.RecordDeleted
		,CDPA.DeletedBy
		,CDPA.DeletedDate
		,dbo.csf_GetGlobalCodeNameById(MuscleFacialExpression) AS MuscleFacialExpression
		,dbo.csf_GetGlobalCodeNameById(LipsPerioralArea) AS LipsPerioralArea
		,dbo.csf_GetGlobalCodeNameById(Jaw) AS Jaw
		,dbo.csf_GetGlobalCodeNameById(Tongue) AS Tongue
		,dbo.csf_GetGlobalCodeNameById(ExtremityMovementsUpper) AS ExtremityMovementsUpper
		,dbo.csf_GetGlobalCodeNameById(ExtremityMovementsLower) AS ExtremityMovementsLower
		,dbo.csf_GetGlobalCodeNameById(NeckShouldersHips) AS NeckShouldersHips
		,dbo.csf_GetGlobalCodeNameById(SeverityAbnormalMovements) AS SeverityAbnormalMovements
		,dbo.csf_GetGlobalCodeNameById(IncapacitationAbnormalMovements) AS IncapacitationAbnormalMovements
		,dbo.csf_GetGlobalCodeNameById(PatientAwarenessAbnormalMovements) AS PatientAwarenessAbnormalMovements
		,CDPA.CurrentProblemsTeeth
		,CDPA.DoesPatientWearDentures
		,CDPA.AIMSTotalScore				
	FROM CustomDocumentPsychiatricNoteAIMs CDPA
	WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(CDPA.RecordDeleted,'N') = 'N' 
		
	END TRY
	BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLSubReportPsychiatricNoteAIMS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	
	END CATCH
END