IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLIndividualServiceNoteGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLIndividualServiceNoteGoals] 
GO

CREATE PROCEDURE [dbo].[csp_RDLIndividualServiceNoteGoals] (
	@DocumentVersionId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: [csp_RDLIndividualServiceNoteGoals]   */
/*       Date              Author                  Purpose                   */
/*       03/02/2015        Bernardin               To get CustomIndividualServiceNoteGoals table vlaues */
/*********************************************************************/
BEGIN
	BEGIN TRY

SELECT IndividualServiceNoteGoalId
		,DocumentVersionId
		,GoalId
		,'Goal '+ CAST( GoalNumber AS varchar(6) ) AS GoalNumber
		,GoalText
		,CustomGoalActive		
	FROM CustomIndividualServiceNoteGoals
		 WHERE DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,'N') = 'N'
		 

		
		
END TRY
	BEGIN CATCH
DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLIndividualServiceNoteGoals') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	
	END CATCH
END