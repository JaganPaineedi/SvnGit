IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetRelapsePreventionPlanSummary]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCGetRelapsePreventionPlanSummary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_SCGetRelapsePreventionPlanSummary] (@DocumentVersionId INT)
AS
-- =============================================  
/*
Date				Author				Purpose
28-May-2015			Revathi				what:Get  prevention Plan Summary
										why:task #18  New Directions - Customizations
*/
-- =============================================  
BEGIN
	BEGIN TRY
		SELECT CRP.DocumentVersionId
			,dbo.csf_GetGlobalCodeNameById(CRLP.LifeDomain) AS LifeDomain
			,CRG.MyGoal AS Goals
			,CRO.RelapseObjectives AS Objectives
			,CRS.RelapseActionSteps AS ActionSteps
		FROM CustomDocumentRelapsePreventionPlans CRP
		LEFT JOIN CustomRelapseLifeDomains CRLP ON CRP.DocumentVersionId = CRLP.DocumentVersionId
			AND ISNULL(CRLP.RecordDeleted, 'N') = 'N'
		LEFT JOIN CustomRelapseGoals CRG ON CRG.RelapseLifeDomainId = CRLP.RelapseLifeDomainId
			AND CRG.DocumentVersionId = CRLP.DocumentVersionId
			AND CRG.RelapseGoalStatus IN (
				SELECT GlobalcodeId
				FROM GlobalCodes
				WHERE Category = 'Xrelapsegoalstatus'
					AND Code = 'INPROGRESS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(CRG.RecordDeleted, 'N') = 'N'
		LEFT JOIN CustomRelapseObjectives CRO ON CRO.RelapseGoalId = CRG.RelapseGoalId
			AND CRG.DocumentVersionId = CRO.DocumentVersionId
			AND CRO.ObjectiveStatus IN (
				SELECT GlobalcodeId
				FROM GlobalCodes
				WHERE Category = 'Xrelapseobjstatus'
					AND Code = 'INPROGRESS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(CRO.RecordDeleted, 'N') = 'N'
		LEFT JOIN CustomRelapseActionSteps CRS ON CRS.RelapseObjectiveId = CRO.RelapseObjectiveId
			AND CRS.DocumentVersionId = CRO.DocumentVersionId
			AND CRS.ActionStepStatus IN (
				SELECT GlobalcodeId
				FROM GlobalCodes
				WHERE Category = 'Xactionstepstatus'
					AND Code = 'INPROGRESS'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND ISNULL(CRS.RecordDeleted, 'N') = 'N'
		WHERE CRP.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CRP.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetRelapsePreventionPlanSummary') 
		+ '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
		+ '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
		+ '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                 
				16
				,
				-- Severity.                                                                                 
				1
				-- State.                                                                                 
				);
	END CATCH
END
GO

