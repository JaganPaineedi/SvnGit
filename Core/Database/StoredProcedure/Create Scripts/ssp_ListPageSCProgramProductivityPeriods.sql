IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND NAME = 'ssp_ListPageSCProgramProductivityPeriods'
		)
BEGIN
	DROP PROCEDURE ssp_ListPageSCProgramProductivityPeriods
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCProgramProductivityPeriods] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@StaffId INT
	,@ProgramIdFilter INT
	,@EffectiveDateFilter VARCHAR(20)
	,@OtherFilter INT
	/*+*/
	/* Stored Procedure:  ssp_ListPageSCProgramProductivityPeriods                */
	/* Copyright:         2010 Streamline Healthcare Solutions           */
	/* Creation Date:     07 March 2012                                  */
	/* Creation By:       Jagdeep Hundal                                 */
	/* Purpose:           Used by ProgramProductivityPeriods list page   */
	/* Input Parameters:  @SessionId,@InstanceId,@PageNumber,            */
	/*                    @PageSize,@SortExpression,@effectiveDateFilter */
	/*                    @StaffId,@statusFilter,@otherFilter            */
	/* Called By:         ProductivityTargets list page                  */
	/* Updates:                                                          */
	/*  Date        Author                     Purpose                   */
	/* 23-Oct-2012	 Vikas Kashyap  What:@EffectiveDateFilter is future and PTD.EndDate is null then featching record not correct*/
	/*								Why:When PTD.EndDate is null then set Enddate set as a @EffectiveDateFilter .,w.r.t. Task#2090 TH Bugs/Features*/
	/* 28-Jan-2014  Revathi         What:Removed the ListPageSCProgramProductivityPeriods and implemented temporary                                 
                                why: the task#1364 - Corebugs while modifying column to ProgramCode from ProgramName*/
	/* 15-Dec-2016	Irfan			What: Added SELECT Statement in the WHERE CLAUSE to get the levelnumber of ParentLevel instead of hardcoding the levelnumber. It was '3' earlier.
								Why : Camino - Supoort Go Live -#234*/
    /* 29-Dec-2019  Chita Ranjan  What: Removed tables (OrganizationLevels,OrganizationLevelTypes) from the select statement.
	                              Why: Team Productivity Product List page should be independent of 'OrganizationLevels' table and 'OrganizationLevelTypes' table. CCC - Customizations #35 */
	/*********************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @ApplyFilterClicked CHAR(1)

		SET @ApplyFilterClicked = 'Y'
			--DECLARE @LevelNumber INT
			--SET @LevelNumber=(SELECT OrganizationLevelTypes.LevelNumber -1  as 'LevelNumber'
			--						 FROM OrganizationLevelTypes where ProgramLevel = 'Y' 
			--						 AND ISNULL(RecordDeleted,'N') = 'N')
			;

		WITH listProgramProductivityPeriods
		AS (
			SELECT DISTINCT PPP.ProgramProductivityPeriodId
				,P.ProgramName AS TeamName
				,PPPD.StartDate AS PeriodStartDate
				,PPPD.EndDate AS PeriodEndDate
				,'' AS Program
			FROM 
			--Organizationlevels OL
			--INNER JOIN OrganizationLevels OL2 ON (OL.ParentLevelId = OL2.OrganizationLevelId)
			--INNER JOIN 
			Programs P 
			--ON (OL.ProgramId = P.ProgramId)
			INNER JOIN ProgramProductivityPeriods PPP ON PPP.ProgramId = P.ProgramId
			LEFT JOIN ProgramProductivityPeriodDates PPPD ON PPP.ProgramProductivityPeriodId = PPPD.ProgramProductivityPeriodId
			AND ISNULL(PPPD.RecordDeleted, 'N') = 'N'
			WHERE 
			--OL.ParentLevelId IN (
			--		SELECT OrganizationLevelId
			--		FROM Organizationlevels OL
			--		INNER JOIN OrganizationLevelTypes OLT ON OLT.LevelTypeId = OL.LevelTypeId
			--		WHERE OLT.LevelNumber = (
			--				SELECT MAX(LevelNumber) - 1
			--				FROM OrganizationLevelTypes
			--				)
			--			AND ISNULL(OLT.RecordDeleted, 'N') = 'N'
			--			--AND ISNULL(OL.RecordDeleted, 'N') = 'N'
			--		) --Modified on 15-Dec-2016 by Irfan
			--	AND
				 (
					P.ProgramId = @ProgramIdFilter
					OR isnull(@ProgramIdFilter, '') = ''
					)
				AND 
				(
					@EffectiveDateFilter >= PPPD.StartDate
					OR isnull(@EffectiveDateFilter, '') = ''
					)
				AND (
					@EffectiveDateFilter <= isnull(PPPD.EndDate, @EffectiveDateFilter)
					OR isnull(@EffectiveDateFilter, '') = ''
					)
				--AND ISNULL(OL.RecordDeleted, 'N') = 'N'
				--AND ISNULL(OL2.RecordDeleted, 'N') = 'N'
				AND ISNULL(PPP.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.RecordDeleted, 'N') = 'N'
				AND ISNULL(P.Active, 'Y') = 'Y'
			)
			,counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM listProgramProductivityPeriods
			)
			,rankresultset
		AS (
			SELECT ProgramProductivityPeriodId
				,TeamName
				,PeriodStartDate
				,PeriodEndDate
				,Program
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'TeamName'
								THEN TeamName
							END
						,CASE 
							WHEN @SortExpression = 'TeamName desc'
								THEN TeamName
							END DESC
						,CASE 
							WHEN @SortExpression = 'PeriodStartDate'
								THEN PeriodStartDate
							END
						,CASE 
							WHEN @SortExpression = 'PeriodStartDate desc'
								THEN PeriodStartDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'PeriodEndDate'
								THEN PeriodEndDate
							END
						,CASE 
							WHEN @SortExpression = 'PeriodEndDate desc'
								THEN PeriodEndDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'Program'
								THEN Program
							END
						,CASE 
							WHEN @SortExpression = 'Program desc'
								THEN Program
							END DESC
						,ProgramProductivityPeriodId
					) AS RowNumber
			FROM listProgramProductivityPeriods
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) ProgramProductivityPeriodId
			,TeamName
			,PeriodStartDate
			,PeriodEndDate
			,Program
			,totalcount
			,rownumber
		INTO #finalresultset
		FROM rankresultset
		WHERE rownumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #finalresultset
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (totalcount % @PageSize)
					WHEN 0
						THEN Isnull((totalcount / @PageSize), 0)
					ELSE Isnull((totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(totalcount, 0) AS NumberOfRows
			FROM #finalresultset
		END

		SELECT ProgramProductivityPeriodId
			,TeamName
			,Convert(varchar(10), PeriodStartDate, 101) AS PeriodStartDate
			,Convert(varchar(10), PeriodEndDate, 101) AS PeriodEndDate
			,Program
		FROM #finalresultset
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListPageSCProgramProductivityPeriods') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.                                           
				16
				,-- Severity.                                           
				1 -- State.                                           
				);
	END CATCH
END