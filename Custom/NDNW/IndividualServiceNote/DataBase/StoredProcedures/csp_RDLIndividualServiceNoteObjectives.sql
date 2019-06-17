IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIndividualServiceNoteObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIndividualServiceNoteObjectives] 
GO

CREATE PROCEDURE [dbo].[csp_RDLIndividualServiceNoteObjectives] (
@DocumentVersionId INT,
	@GoalId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLIndividualServiceNoteObjectives]   */
/*       Date              Author                  Purpose                   */
/*       03/02/2015        Bernardin               To get CustomIndividualServiceNoteObjectives table vlaues */
/*       02/02/2016        Arjun K R               Only Distinct records are selected. Task #236 New Directions - Support Go Live */
/*********************************************************************/
BEGIN
	BEGIN TRY

SELECT     distinct CISNO.IndividualServiceNoteObjectiveId, 
           CISNO.DocumentVersionId, 
           CISNO.GoalId, 
           'Objective #'+ CAST( CISNO.ObjectiveNumber AS varchar(6) ) AS ObjectiveNumber, 
           CISNO.ObjectiveText, 
           CISNO.CustomObjectiveActive, 
           dbo.csf_GetGlobalCodeNameById(CISNO.Status) AS [Status]
FROM         CustomIndividualServiceNoteObjectives CISNO INNER JOIN
                      CustomIndividualServiceNoteGoals CISNG ON CISNO.GoalId = CISNG.GoalId AND  ISNULL(CISNO.RecordDeleted,'N')='N'
WHERE ISNULL(CISNO.RecordDeleted,'N')='N'
		AND CISNG.GoalId = @GoalId AND CISNO.DocumentVersionId = @DocumentVersionId
		
END TRY
	BEGIN CATCH
DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIndividualServiceNoteObjectives') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	
	END CATCH
END