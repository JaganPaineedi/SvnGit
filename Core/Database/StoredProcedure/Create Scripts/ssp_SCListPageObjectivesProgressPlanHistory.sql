/****** Object:  StoredProcedure [dbo].[ssp_SCListPageObjectivesProgressPlanHistory]    Script Date: 01/21/2015 13:27:54 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageObjectivesProgressPlanHistory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageObjectivesProgressPlanHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageObjectivesProgressPlanHistory]    Script Date: 01/21/2015 13:27:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageObjectivesProgressPlanHistory] (
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientId INT
	,@StartDate DATETIME
	,@EndDate DATETIME
	,@ReviewSource INT
	,@CurrentObjects CHAR(1)
	,@ScoreFromDate DATETIME
	,@ScoreToDate DATETIME
	,@Scores INT
	,@GoalObjective VARCHAR(MAX)
	,@RevieweBy INT
	,@ReviewStatus INT
	,@OtherFilter INT
	)
	/*******************************************************************************                                                   
** Stored Procedure: ssp_SCListPageObjectivesProgressPlanHistory                                                      
**                                                    
** Copyright: Streamline Healthcate Solutions                                                      
** Updates:                                                                                                           
** Date				Author          Purpose     
-------------------------------------------------------------------------------
** 06-Jan-2015		Revathi			What:Get Level Of Care Plan History        
**									Why:task  #915 Valley - Customizations     
** 28 Jul 2015		Avi Goyal		What : Modified Join with CarePlanDomainObjectives
									Why : Task # 257 Objective/Progress Plan History Banner ; Project : Valley Client Acceptance Testing Issues
/* 04/27/2018       Neha            Added a radio button called 'Not reviewed' to the Progress towards objective field. Task #10004.14 Porter Starke Customizations	*/	  
									
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		DECLARE @ApplyFilterClick AS CHAR(1)

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'Goal desc'

		IF @Scores NOT IN (	- 1	,0,1,2,3)
			SET @Scores = NULL

		CREATE TABLE #ResultSet (
			Goal DECIMAL(18, 0)
			,Objective VARCHAR(MAX)
			,ReviewStatus VARCHAR(100)
			,ScoreDate DATETIME
			,ReviewBy VARCHAR(250)
			,Score INT
			,StartDate DATETIME
			,EndDate DATETIME
			,ReviewSource VARCHAR(MAX)
			,DocumentId INT
			)

		CREATE TABLE #CustomFilters (DocumentVersionId INT)

		--Get custom filters                                                      
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_SCListPageObjectivesProgressPlanHistory', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #CustomFilters (DocumentVersionId)
				EXEC scsp_SCListPageObjectivesProgressPlanHistory @ClientId = @ClientId
					,@StartDate = @StartDate
					,@EndDate = @EndDate
					,@ReviewSource = @ReviewSource
					,@CurrentObjects = @CurrentObjects
					,@ScoreFromDate = @ScoreFromDate
					,@ScoreToDate = @ScoreToDate
					,@Scores = @Scores
					,@GoalObjective = @GoalObjective
					,@RevieweBy = @RevieweBy
					,@ReviewStatus = @ReviewStatus
					,@OtherFilter = @OtherFilter
			END
		END

		INSERT INTO #ResultSet (
			Goal
			,Objective
			,ReviewStatus
			,ScoreDate
			,ReviewBy
			,Score
			,StartDate
			,EndDate
			,ReviewSource
			,DocumentId
			)
		SELECT CG.GoalNumber AS Number
			,CONVERT(VARCHAR(100), CO.ObjectiveNumber) + '-' + DC.NameInGoalDescriptions + + ' ' + ISNULL(CDO.ObjectiveDescription,ISNULL(CO.AssociatedObjectiveDescription,''))	-- Modified By Avi Goyal, on 28 July 2015
			,CASE 
				WHEN CO.ProgressTowardsObjective = 'D'
					THEN 'Deterioration'
				WHEN CO.ProgressTowardsObjective = 'N'
					THEN 'No change'
				WHEN CO.ProgressTowardsObjective = 'S'
					THEN 'Some Improvement'
				WHEN CO.ProgressTowardsObjective = 'M'
					THEN 'Moderate Improvement'
				WHEN CO.ProgressTowardsObjective = 'A'
					THEN 'Achieved'
				WHEN CO.ProgressTowardsObjective = 'R'
					THEN 'Not Reviewed'
				ELSE 'Never Reviewed'
				END
			,CO.ScoreDate
			,ISNULL(S1.LastName, '') + coalesce(', ' + S1.Firstname, '')
			,CASE 
				WHEN CO.ProgressTowardsObjective = 'D'
					THEN - 1
				WHEN CO.ProgressTowardsObjective = 'N'
					THEN 0
				WHEN CO.ProgressTowardsObjective = 'S'
					THEN 1
				WHEN CO.ProgressTowardsObjective = 'M'
					THEN 2
				WHEN CO.ProgressTowardsObjective = 'A'
					THEN 3
				WHEN CO.ProgressTowardsObjective = 'R'
					THEN 0
				END
			,CO.ObjectiveStartDate
			,CO.ObjectiveEndDate
			,DC1.DocumentName
			,D.DocumentId
		FROM CarePlanGoals CG
		INNER JOIN CarePlanObjectives CO ON CG.CarePlanGoalId = CO.CarePlanGoalId		
		LEFT JOIN CarePlanDomainObjectives CDO ON CDO.CarePlanDomainObjectiveId = CO.CarePlanDomainObjectiveId	AND ISNULL(CDO.RecordDeleted, 'N') = 'N' -- Modified By Avi Goyal, on 28 July 2015
		INNER JOIN DocumentCarePlans DC ON DC.DocumentVersionId = CG.DocumentVersionId
		INNER JOIN Staff S1 ON S1.UserCode = CO.ModifiedBy
		INNER JOIN Documents D ON D.CurrentDocumentVersionId = DC.DocumentVersionId
		INNER JOIN DocumentCodes DC1 ON D.DocumentCodeId = DC1.DocumentCodeId
		WHERE (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM #CustomFilters cf
						WHERE cf.DocumentVersionId = DC.DocumentVersionId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND ISNULL(CO.RecordDeleted, 'N') = 'N'
					AND ISNULL(CG.RecordDeleted, 'N') = 'N'
					
					AND ISNULL(DC.RecordDeleted, 'N') = 'N'
					AND ISNULL(D.RecordDeleted, 'N') = 'N'
					AND D.STATUS = 22  
					AND D.ClientId = @ClientId
					AND (
						ISNULL(@StartDate, '') = ''
						OR CAST(CO.ObjectiveStartDate AS DATE) >= CAST(@StartDate AS DATE)
						)
					AND (
						(
							@CurrentObjects = 'Y'
							AND ISNULL(CO.ObjectiveEndDate, '') = ''
							)
						OR (
							(
								ISNULL(@CurrentObjects, 'N') = 'N'
								AND (
									ISNULL(@EndDate, '') = ''
									OR CAST(CO.ObjectiveEndDate AS DATE) <= CAST(@EndDate AS DATE)
									)
								)
							)
						)
					AND (
						ISNULL(@ScoreFromDate, '') = ''
						OR cast(CO.ScoreDate AS DATE) >= cast(@ScoreFromDate AS DATE)
						)
					AND (
						@ScoreToDate IS NULL
						OR cast(CO.ScoreDate AS DATE) <= cast(@ScoreToDate AS DATE)
						)
					AND (
						@Scores IS NULL
						OR CO.ProgressTowardsObjective = (
							CASE 
								WHEN @Scores = - 1
									THEN 'D'
								WHEN @Scores = 0
									THEN 'N'
								WHEN @Scores = 1
									THEN 'S'
								WHEN @Scores = 2
									THEN 'M'
								WHEN @Scores = 3
									THEN 'A'
								ELSE CO.ProgressTowardsObjective
								END
							)
						)
					AND (
						ISNULL(@RevieweBy, - 1) = - 1
						OR S1.StaffId = @RevieweBy
						)
					AND (
						ISNULL(@ReviewSource, - 1) = - 1
						OR DC1.DocumentCodeId = (
							CASE 
								WHEN @ReviewSource = 8879
									THEN 1620
								END
							)
						)
					AND (
						ISNULL(@ReviewStatus, - 1) = - 1
						OR CO.ProgressTowardsObjective = (
							CASE 
								WHEN @ReviewStatus = 8880
									THEN 'D'
								WHEN @ReviewStatus = 8881
									THEN 'N'
								WHEN @ReviewStatus = 8882
									THEN 'S'
								WHEN @ReviewStatus = 8883
									THEN 'M'
								WHEN @ReviewStatus = 8884
									THEN 'A'
								ELSE CO.ProgressTowardsObjective
								END
							)
						)
					)
				);

		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT Goal
				,Objective
				,ReviewStatus
				,ScoreDate
				,ReviewBy
				,Score
				,StartDate
				,EndDate
				,ReviewSource
				,DocumentId
				,Count(*) OVER () AS TotalCount
				,Row_Number() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'Goal'
								THEN Goal
							END
						,CASE 
							WHEN @SortExpression = 'Goal desc'
								THEN Goal
							END DESC
						,CASE 
							WHEN @SortExpression = 'Objective'
								THEN Objective
							END
						,CASE 
							WHEN @SortExpression = 'Objective desc'
								THEN Objective
							END DESC
						,CASE 
							WHEN @SortExpression = 'ReviewStatus'
								THEN ReviewStatus
							END
						,CASE 
							WHEN @SortExpression = 'ReviewStatus desc'
								THEN ReviewStatus
							END DESC
						,CASE 
							WHEN @SortExpression = 'ScoreDate'
								THEN ScoreDate
							END
						,CASE 
							WHEN @SortExpression = 'ScoreDate desc'
								THEN ScoreDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'ReviewBy'
								THEN ReviewBy
							END
						,CASE 
							WHEN @SortExpression = 'ReviewBy desc'
								THEN ReviewBy
							END DESC
						,CASE 
							WHEN @SortExpression = 'Score'
								THEN Score
							END
						,CASE 
							WHEN @SortExpression = 'Score desc'
								THEN Score
							END DESC
						,CASE 
							WHEN @SortExpression = 'StartDate'
								THEN StartDate
							END
						,CASE 
							WHEN @SortExpression = 'StartDate desc'
								THEN StartDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'EndDate'
								THEN EndDate
							END
						,CASE 
							WHEN @SortExpression = 'EndDate desc'
								THEN EndDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'ReviewSource'
								THEN ReviewSource
							END
						,CASE 
							WHEN @SortExpression = 'ReviewSource desc'
								THEN ReviewSource
							END DESC
					) AS RowNumber
			FROM #ResultSet
			WHERE (
					(
						ISNULL(@GoalObjective, '') = ''
						OR (
							LEN(@GoalObjective) > 1
							AND LEN(@GoalObjective) < 3
							)
						)
					OR (
						Goal = (
							CASE 
								WHEN ISNumeric(@GoalObjective) = 1
									AND FLOOR(@GoalObjective) = CEILING(@GoalObjective)
									THEN cast(@GoalObjective AS DECIMAL)
								END
							)
						OR Objective LIKE '%' + CASE 
							WHEN ISNumeric(@GoalObjective) = 1
								AND FLOOR(@GoalObjective) <> CEILING(@GoalObjective)
								THEN @GoalObjective
							ELSE CASE 
									WHEN ISNumeric(@GoalObjective) <> 1
										THEN @GoalObjective
									END
							END + '%'
						)
					)
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) Goal
			,Objective
			,ReviewStatus
			,ScoreDate
			,ReviewBy
			,Score
			,StartDate
			,EndDate
			,ReviewSource
			,DocumentId
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT CASE 
				WHEN FLOOR(Goal) = CEILING(Goal)
					THEN Goal
				ELSE CAST(Goal AS INT)
				END AS Goal
			,Objective
			,ReviewStatus
			,CONVERT(VARCHAR, ScoreDate, 101) AS ScoreDate
			,ReviewBy
			,Score
			,convert(VARCHAR, StartDate, 101) AS StartDate
			,convert(VARCHAR, EndDate, 101) AS EndDate
			,ReviewSource
			,DocumentId
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + 
		CONVERT(VARCHAR(4000), Error_message()) + '*****' +
		 Isnull(CONVERT(VARCHAR, Error_procedure()), 
		 'ssp_SCListPageObjectivesProgressPlanHistory') 
		 + '*****' + CONVERT(VARCHAR, Error_line()) 
		 + '*****' + CONVERT(VARCHAR, Error_severity())
		  + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
GO

