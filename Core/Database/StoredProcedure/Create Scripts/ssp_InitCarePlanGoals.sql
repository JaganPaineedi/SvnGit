

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitCarePlanGoals]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitCarePlanGoals] -- 1373288
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitCarePlanGoals] --180
	(@CarePlanDocumentVersionID INT)
AS

/* 2016.05.11    Veena S Mani       Review changes Valley Support Go live #390   EndDate logic added            */
/* 2016.05.24    Veena S Mani       Added the resetting the goals/objective number logic added                   */
/* 2017.03.06    Neelima	        Added the IsNewCarePlanGoal column in CarePlanGoals table as per AspenPointe-Customizations #86            */
/* 2018.05.16    Vijay	            We are adding scsp_InitCarePlanGoals, if goals end date is future date we need to show goals while initializing the care plan.
								    Currently if we end date the goal even if it is a future date also we are not displaying the goal       
								    Keystone Support Go Live #118 */

BEGIN TRY
	BEGIN
		
	  IF EXISTS(SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitCarePlanGoals]') AND type in (N'P', N'PC'))
	  BEGIN
		EXEC scsp_InitCarePlanGoals @CarePlanDocumentVersionID
	  END
	  ELSE
	  BEGIN		
		CREATE TABLE #DocumentGoals (
			CarePlanGoalId INT --IDENTITY(- 1, - 1)
			,TableName VARCHAR(30)
			,CreatedBy VARCHAR(30)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(30)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedBy VARCHAR(30)
			,DeletedDate DATETIME
			,DocumentVersionId INT
			,CarePlanDomainGoalId INT
			,GoalNumber DECIMAL(18, 0)
			,ClientGoal VARCHAR(MAX)
			,GoalActive CHAR(1)
			,ProgressTowardsGoal CHAR(1)
			,GoalReviewUpdate VARCHAR(MAX)
			,InitializedFromPreviousCarePlan CHAR(1)
			,GoalStartDate DATETIME
			--,GoalEndDate DATETIME
			,MonitoredByType CHAR(1)
			,MonitoredBy INT
			,MonitoredByOtherDescription VARCHAR(MAX)
			,AssociatedGoalDescription VARCHAR(MAX)
			)

		INSERT INTO #DocumentGoals
		SELECT CG.CarePlanGoalId
			,'CarePlanGoals' AS TableName
			,CG.CreatedBy
			,CG.CreatedDate
			,CG.ModifiedBy
			,CG.ModifiedDate
			,CG.RecordDeleted
			,CG.DeletedBy
			,CG.DeletedDate
			,ISNULL(CG.DocumentVersionId, - 1) AS DocumentVersionId
			,CG.CarePlanDomainGoalId
			,Case when (ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N') = 'Y')
			THEN
			ROW_NUMBER() OVER (ORDER BY CG.GoalNumber)
			ELSE CG.GoalNumber END as GoalNumber  --CG.GoalNumber
			,CG.ClientGoal
			,CG.GoalActive
			,CG.ProgressTowardsGoal
			,CG.GoalReviewUpdate
			,CG.InitializedFromPreviousCarePlan
			,CG.GoalStartDate
			--,CG.GoalEndDate
			,CG.MonitoredByType
			,CG.MonitoredBy
			,CG.MonitoredByOtherDescription
			,CG.AssociatedGoalDescription
		FROM CarePlanGoals CG 
		--Added by Veena on 05/11/16 for CarePlan Review changes Valley Support Go live #390 end date logic added
		WHERE ((CG.DocumentVersionId = @CarePlanDocumentVersionID and CG.GoalEndDate IS NULL and ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N') = 'Y'
			AND ISNULL(CG.RecordDeleted, 'N') = 'N') OR (CG.DocumentVersionId = @CarePlanDocumentVersionID and ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N') = 'N'
			AND ISNULL(CG.RecordDeleted, 'N') = 'N'))

		SELECT TableName
			,CarePlanGoalId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,DocumentVersionId
			,CarePlanDomainGoalId
			,GoalNumber
			,ClientGoal
			,GoalActive
			,ProgressTowardsGoal
			,GoalReviewUpdate
			,InitializedFromPreviousCarePlan
			,GoalStartDate
			--,GoalEndDate 
			,MonitoredByType
			,MonitoredBy
			,MonitoredByOtherDescription
			,AssociatedGoalDescription
			,'N' as IsNewGoal
			,'N' as IsNewCarePlanGoal            --Added by Neelima
		FROM #DocumentGoals

		CREATE TABLE #GoalsNeeds (
			TableName VARCHAR(30)
			,CarePlanGoalNeedId INT --IDENTITY(- 1, - 1)
			,CreatedBy VARCHAR(30)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(30)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedBy VARCHAR(30)
			,DeletedDate DATETIME
			,CarePlanGoalId INT
			,CarePlanNeedId INT
			,AssociatedNeedDescription VARCHAR(MAX)
			)

		INSERT INTO #GoalsNeeds
		SELECT 'CarePlanGoalNeeds' AS TableName
			, CN.CarePlanGoalNeedId  
			,CN.CreatedBy
			,CN.CreatedDate
			,CN.ModifiedBy
			,CN.ModifiedDate
			,CN.RecordDeleted
			,CN.DeletedBy
			,CN.DeletedDate
			,CN.CarePlanGoalId
			,CN.CarePlanNeedId
			,CN.AssociatedNeedDescription
		FROM CarePlanGoalNeeds CN
		INNER JOIN #DocumentGoals CG ON CG.CarePlanGoalId = CN.CarePlanGoalId
		WHERE ISNULL(CN.RecordDeleted, 'N') = 'N'

		SELECT CarePlanGoalNeedId
			,TableName
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,CarePlanGoalId
			,CarePlanNeedId
		FROM #GoalsNeeds

		CREATE TABLE #CarePlanObjectives (
			CarePlanObjectiveId INT --IDENTITY(- 1, - 1)
			,TableName VARCHAR(30)
			,CreatedBy VARCHAR(30)
			,CreatedDate DATETIME
			,ModifiedBy VARCHAR(30)
			,ModifiedDate DATETIME
			,RecordDeleted CHAR(1)
			,DeletedBy VARCHAR(30)
			,DeletedDate DATETIME
			,CarePlanGoalId INT
			,CarePlanDomainObjectiveId INT
			,ObjectiveNumber DECIMAL(18, 2)
			,StaffSupports VARCHAR(MAX)
			,MemberActions VARCHAR(MAX)
			,UseOfNaturalSupports VARCHAR(MAX)
			,STATUS CHAR(1)
			,InitializedFromPreviousCarePlan CHAR(1)
			,ProgressTowardsGoal CHAR(1)
			,ObjectiveReview VARCHAR(max)
			,ObjectiveStartDate DATETIME
			--,ObjectiveEndDate datetime 
			,AssociatedObjectiveDescription VARCHAR(MAX)
			)

		INSERT INTO #CarePlanObjectives
		SELECT CO.CarePlanObjectiveId  
			,'CarePlanObjectives' AS TableName
			,CO.CreatedBy
			,CO.CreatedDate
			,CO.ModifiedBy
			,CO.ModifiedDate
			,CO.RecordDeleted
			,CO.DeletedBy
			,CO.DeletedDate
			,CO.CarePlanGoalId
			,CO.CarePlanDomainObjectiveId
			,Case when (ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N') = 'Y')
			THEN CAST(CG.GoalNumber + (CO.ObjectiveNumber % 1) as decimal(18,2)) 
			ELSE CO.ObjectiveNumber end as ObjectiveNumber 
			--,cast(isnull(CG.GoalNumber + SUBSTRING(CO.ObjectiveNumber,'.',LEN(CO.ObjectiveNumber)),0) as decimal (18,0)) --CG.GoalNumber 
			,CO.StaffSupports
			,CO.MemberActions
			,CO.UseOfNaturalSupports
			,CO.STATUS
			,CO.InitializedFromPreviousCarePlan
			,CO.ProgressTowardsObjective
			,CO.ObjectiveReview
			,CO.ObjectiveStartDate
			--,CO.ObjectiveEndDate 
			,CO.AssociatedObjectiveDescription
		FROM CarePlanObjectives CO
		INNER JOIN #DocumentGoals CG ON CG.CarePlanGoalId = CO.CarePlanGoalId
		--Added by Veena on 05/11/16 for CarePlan Review changes Valley Support Go live #390 end date logic added
		WHERE ((ISNULL(CO.RecordDeleted, 'N') = 'N' and CO.ObjectiveEndDate IS NULL AND ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N')='Y')
		OR (ISNULL(dbo.ssf_GetSystemConfigurationKeyValue('SetReviewInCarePlan'),'N')='N' and ISNULL(CO.RecordDeleted, 'N') = 'N'))

		SELECT TableName
			,CarePlanObjectiveId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedBy
			,DeletedDate
			,CarePlanGoalId
			,CarePlanDomainObjectiveId
			,ObjectiveNumber
			,StaffSupports
			,MemberActions
			,UseOfNaturalSupports
			,STATUS
			,InitializedFromPreviousCarePlan
			,ProgressTowardsGoal
			,ObjectiveReview
			,ObjectiveStartDate
			--,ObjectiveEndDate 
			,AssociatedObjectiveDescription
			,'N' as IsNewObjective
		FROM #CarePlanObjectives
       END
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitCarePlanGoals') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.       
			16
			,-- Severity.       
			1 -- State.                                                         
			);
END CATCH
GO

