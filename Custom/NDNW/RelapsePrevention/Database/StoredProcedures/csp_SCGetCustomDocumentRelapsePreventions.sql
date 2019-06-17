/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentRelapsePreventions]    Script Date: 04/06/2015 14:29:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentRelapsePreventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentRelapsePreventions]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentRelapsePreventions]     Script Date: 04/06/2015 14:29:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_SCGetCustomDocumentRelapsePreventions] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetCustomDocumentRelapsePreventions]   */
/*       Date              Author                  Purpose                   */
/*       04/JUNE/2015      Anto               To Retrieve Data           */
/*********************************************************************/
BEGIN
	BEGIN TRY
		 SELECT CDRP.[DocumentVersionId]
			,CDRP.[CreatedBy]
			,CDRP.[CreatedDate]
			,CDRP.[ModifiedBy]
			,CDRP.[ModifiedDate]
			,CDRP.[RecordDeleted]
			,CDRP.[DeletedBy]
			,CDRP.[DeletedDate]
			,CDRP.[PlanName],
			 CDRP.[PlanPeriod],
			 CDRP.[PlanStatus],
			 CDRP.[HighRiskSituations],
			 CDRP.[RecoveryActivities],
			 CDRP.[PlanStartDate],
			 CDRP.[PlanEndDate],
			 CDRP.[NextReviewDate],
			 CDRP.[ClientParticipated]			
		FROM [CustomDocumentRelapsePreventionPlans] CDRP			
		WHERE CDRP.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CDRP.RecordDeleted, 'N') = 'N'
			
			
		--	------CustomRelapseLifeDomains
		SELECT ROW_NUMBER() OVER (ORDER BY RelapseLifeDomainId) As Id,
		RelapseLifeDomainId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		DocumentVersionId,
		LifeDomainDetail,
		LifeDomainDate,
		LifeDomain,
		Resources,
		Barriers,
		LifeDomainNumber
		FROM CustomRelapseLifeDomains
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId
			
			
			
		--	------CustomRelapseGoals
		SELECT ROW_NUMBER() OVER (ORDER BY RelapseGoalId) As Id,
		RelapseGoalId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		DocumentVersionId,
		RelapseLifeDomainId,
		RelapseGoalStatus,
		ProjectedDate,
		MyGoal,
		AchievedThisGoal,
		GoalNumber
		FROM CustomRelapseGoals
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId
			
			
	   --	------CustomRelapseObjectives
		SELECT ROW_NUMBER() OVER (ORDER BY RelapseObjectiveId) As Id,
		RelapseObjectiveId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		DocumentVersionId,
		RelapseGoalId,
		RelapseObjectives,
		ObjectivesCreateDate,
		ObjectiveStatus,
		IWillAchieve,
		ExpectedAchieveDate,
		ResolutionDate,
		ObjectivesNumber
		FROM CustomRelapseObjectives
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId		
			
			
			--	------CustomRelapseActionSteps
		SELECT ROW_NUMBER() OVER (ORDER BY RelapseActionStepId) As Id,
		RelapseActionStepId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		DocumentVersionId,
		RelapseObjectiveId,
		RelapseActionSteps,
		CreateDate,
		ActionStepStatus,
		ToAchieveMyGoal,
		ActionStepNumber
		FROM CustomRelapseActionSteps
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId	
			
			
			
			
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomDocumentRelapsePreventions') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


