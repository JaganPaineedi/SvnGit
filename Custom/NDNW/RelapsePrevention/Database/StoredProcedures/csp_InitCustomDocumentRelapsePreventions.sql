IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentRelapsePreventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentRelapsePreventions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_InitCustomDocumentRelapsePreventions] 
 (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Anto.G 
-- Date        : 04/JUNE/2015  
-- Purpose     : Initializing SP Created.	
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	
	SELECT TOP 1
                @LatestDocumentVersionID = CurrentDocumentVersionId
        FROM    CustomDocumentRelapsePreventionPlans CDSA
                INNER JOIN Documents Doc ON CDSA.DocumentVersionId = Doc.CurrentDocumentVersionId
        WHERE   Doc.ClientId = @ClientID
                AND Doc.[Status] = 22
                AND ISNULL(CDSA.RecordDeleted, 'N') = 'N'
                AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
        ORDER BY Doc.EffectiveDate DESC ,
                Doc.ModifiedDate DESC

        SET @LatestDocumentVersionId = ISNULL(@LatestDocumentVersionId, -1)

SELECT 'CustomDocumentRelapsePreventionPlans' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		PlanName,
		PlanPeriod,
		PlanStatus,
		HighRiskSituations,
		RecoveryActivities,
		PlanStartDate,
		PlanEndDate,
		NextReviewDate,
		ClientParticipated
	
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentRelapsePreventionPlans  ON DocumentVersionId = @LatestDocumentVersionID
	
	
	SELECT 'CustomRelapseLifeDomains' AS TableName
	    ,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		RelapseLifeDomainId as Id,		
		RelapseLifeDomainId,
		LifeDomainDetail,
		LifeDomainDate,
		LifeDomain,
		Resources,
		Barriers,
		LifeDomainNumber
		FROM CustomRelapseLifeDomains
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @LatestDocumentVersionID
			
			
       SELECT 'CustomRelapseGoals' AS TableName
         ,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,		
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		RelapseGoalId,
		RelapseLifeDomainId,
		RelapseGoalStatus,
		ProjectedDate,
		MyGoal,
		AchievedThisGoal,
		GoalNumber
		FROM CustomRelapseGoals
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @LatestDocumentVersionID		
			
			
		SELECT 'CustomRelapseObjectives' AS TableName
         ,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,		
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		RelapseObjectiveId,		
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
			AND DocumentVersionId = @LatestDocumentVersionID	
			
			
		SELECT 'CustomRelapseActionSteps' AS TableName
         ,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate,		
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		RelapseObjectiveId,	
		RelapseActionStepId,			
		RelapseActionSteps,
		CreateDate,
		ActionStepStatus,
		ToAchieveMyGoal,
		ActionStepNumber
		FROM CustomRelapseActionSteps
		WHERE ISNull(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @LatestDocumentVersionID							
	
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentRelapsePreventions') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                  
				16
				,-- Severity.                                                                                                  
				1 -- State.                                                                                                  
				);
	END CATCH
END

