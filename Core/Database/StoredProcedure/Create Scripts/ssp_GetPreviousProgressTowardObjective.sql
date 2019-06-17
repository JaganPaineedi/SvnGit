/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousProgressTowardObjective]    Script Date: 01/20/2015 16:18:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPreviousProgressTowardObjective]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPreviousProgressTowardObjective]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPreviousProgressTowardObjective]    Script Date: 01/20/2015 16:18:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetPreviousProgressTowardObjective] (
	@ClientId INT
	,@EffectiveDate DATETIME
	,@DocumentCodeId INT
	,@CarePlanDomainGoalId INT
	,@CarePlanDomainObjectiveID INT
	,@RatingType CHAR(1)
	)
AS
BEGIN TRY
	BEGIN
		IF (@RatingType = 'O')
			SELECT TOP 1 CASE ProgressTowardsObjective
					WHEN 'D'
						THEN 'Deterioration'
					WHEN 'N'
						THEN 'No Change'
					WHEN 'S'
						THEN 'Some Improvement'
					WHEN 'M'
						THEN 'Moderate Improvement'
					WHEN 'A'
						THEN 'Achieved'
					WHEN 'R'
						THEN 'Not Reviewed'
					ELSE 'No Previous ratings available'
					END AS ProgressTowardsObjective
			FROM CarePlanObjectives CPO
			INNER JOIN CarePlanGoals CPG ON CPG.CarePlanGoalId = CPO.CarePlanGoalId
			WHERE EXISTS (
					SELECT *
					FROM Documents
					WHERE CurrentDocumentVersionId = CPG.DocumentVersionId
						AND ClientId = @ClientId
						AND CONVERT(VARCHAR(10), EffectiveDate, 110) <= CONVERT(VARCHAR(10), GETDATE(), 110)
						AND DocumentCodeId = @DocumentCodeId
						AND [Status] = 22
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
				OR CPG.CarePlanDomainGoalId = @CarePlanDomainGoalId
				OR CPO.CarePlanDomainObjectiveId = @CarePlanDomainObjectiveID
				AND ISNULL(CPO.RecordDeleted, 'N') = 'N'
			ORDER BY CPO.ModifiedDate DESC
	END
END TRY
                                        
BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPreviousProgressTowardObjective') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error /* Message text*/
			,16 /*Severity*/
			,1 /*State*/
			)
END CATCH
GO


