/****** Object:  StoredProcedure [dbo].[ssp_ListPageCourses]    Script Date: 16/03/2018 11:54:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCourses]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageCourses]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageCourses]    Script Date: 16/03/2018 11:54:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCourses]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_ListPageCourses	0,200,'DESC','','-1',-1,-1,-1,-1,-1,0          */
	/* Creation Date:  Mar 16 2018                                */
	/* Purpose: To get the list of Courses 
			 */
	/*  Date                  Author                 Purpose     */
	/* April 17 2018           Chita Ranjan            To get the list of Courses. PEP-Customizations #10005     */
	/*History*/
	/*************************************************************/
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@AsOfDate DATETIME
	,@ClientAssignedFilter INT
	,@ClassroomFilters INT
	,@AcademicTermsFilter INT
	,@TeachersAssignedFilter INT
	,@CourseTypeFilter VARCHAR(500)
	,@CourseGroupFilter INT
	,@OtherFilter INT
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		CREATE TABLE #CustomFilters (AcademicTermId INT NOT NULL)

		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_ListPageCourses', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #CustomFilters (AcademicTermId)
				EXEC scsp_ListPageCourses @AsOfDate = @AsOfDate
					,@ClientAssignedFilter = @ClientAssignedFilter
					,@ClassroomFilters = @ClassroomFilters
					,@AcademicTermsFilter = @AcademicTermsFilter
					,@TeachersAssignedFilter = @TeachersAssignedFilter
					,@CourseTypeFilter = @CourseTypeFilter
					,@CourseGroupFilter = @CourseGroupFilter
					,@OtherFilter = @OtherFilter
			END
		END;

		CREATE TABLE #ResultSET (
			CourseId INT
			,StartDate DATETIME
			,EndDate DATETIME
			,TypeOfCourse VARCHAR(500)
			,CourseGroup VARCHAR(250)
			,NumberOfCredits VARCHAR(250)
			,QuarterSemester VARCHAR(50)
			,PrimaryTeacher VARCHAR(500)
			,TeachersAssigned VARCHAR(MAX)
			,AssignedClients VARCHAR(MAX)
			)

		INSERT INTO #ResultSET (
			CourseId
			,StartDate
			,EndDate
			,TypeOfCourse
			,CourseGroup
			,NumberOfCredits
			,QuarterSemester
			,PrimaryTeacher
			,TeachersAssigned
			,AssignedClients
			)
		SELECT DISTINCT CR.CourseId
			,CONVERT(VARCHAR(10), CS.StartDate, 101) AS StartDate
			,CONVERT(VARCHAR(10), CS.EndDate, 101) AS EndDate
			,CT.TypeOfCourse AS TypeOfCourse
			,G.CodeName AS CourseGroup
			,G1.CodeName AS NumberOfCredits
			,CASE 
				WHEN AY.QuarterOrSemester = 'Q'
					THEN 'Quarter'
				WHEN AY.QuarterOrSemester = 'S'
					THEN 'Semester'
				END AS QuarterSemester
			,(
				SELECT TOP 1 St.LastName + ', ' + St.FirstName
				FROM CourseStaffAssignments CAS
				JOIN Staff St ON St.StaffId = CAS.StaffId
				WHERE CAS.IsPrimary = 'Y'
					AND CAS.CourseId = CR.CourseId
					AND ISNULL(CAS.RecordDeleted, 'N') <> 'Y'
				) AS PrimaryTeacher
			,(
				SELECT ISNULL(STUFF((
								SELECT ', ' + ISNULL(SS.DisplayAs, '')
								FROM CourseStaffAssignments CSA1
								JOIN Staff SS ON CSA1.StaffId = SS.StaffId
								WHERE CR.CourseId = CSA1.CourseId
									AND ISNULL(CSA1.RecordDeleted, 'N') = 'N'
								FOR XML PATH('')
									,type
								).value('.', 'nvarchar(max)'), 1, 1, ' '), '')
				) AS TeachersAssigned
			,(
				SELECT ISNULL(STUFF((
								SELECT ', ' + ISNULL(CC.LastName + ', ' + CC.FirstName, '')
								FROM CourseClientAssignments CSA2
								JOIN Clients CC ON CSA2.ClientId = CC.ClientId
								WHERE CR.CourseId = CSA2.CourseId
									AND ISNULL(CSA2.RecordDeleted, 'N') = 'N'
									AND ISNULL(CC.RecordDeleted, 'N') = 'N'
									AND CC.Active = 'Y'
								FOR XML PATH('')
									,type
								).value('.', 'nvarchar(max)'), 1, 1, ' '), '')
				) AS AssignedClients
		FROM Courses CR
		LEFT JOIN CourseSchedules CS ON CR.Courseid = CS.CourseId AND ISNULL(CS.RecordDeleted, 'N') = 'N'
		LEFT JOIN CourseTypes CT  ON CT.CourseTypeId = CR.CourseType AND ISNULL(CT.RecordDeleted, 'N') = 'N'
		LEFT JOIN AcademicTerms AT ON AT.AcademicTermId = CR.AcademicTermId AND ISNULL(AT.RecordDeleted, 'N') = 'N'
		LEFT JOIN AcademicYears AY ON AY.AcademicYearId = AT.AcademicYearId AND AY.Active = 'Y' AND ISNULL(AY.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes G ON G.GlobalCodeId = CR.CourseGroup AND ISNULL(G.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes G1 ON G1.GlobalCodeId = CR.NoOfCredits AND ISNULL(G.RecordDeleted, 'N') = 'N'
		LEFT JOIN CourseClientAssignments CCA ON CCA.CourseId = CR.CourseId AND ISNULL(CCA.RecordDeleted, 'N') = 'N'  
		WHERE (
				(
					@AsOfDate = ''
					 OR (CS.StartDate <= @AsOfDate AND CS.EndDate >= @AsOfDate )
					)
				AND (
					@ClassroomFilters = '-1'
					OR CS.RoomId = @ClassroomFilters
					)
				AND (
					@AcademicTermsFilter = '-1'
					OR CR.AcademicTermId = @AcademicTermsFilter
					)
				AND (
					@CourseTypeFilter = '-1'
					OR CR.CourseType = @CourseTypeFilter
					)
				AND (
					@CourseGroupFilter = '-1'
					OR CR.CourseGroup = @CourseGroupFilter
					)
				
				AND ISNULL(CR.RecordDeleted, 'N') = 'N'
				AND EXISTS (
					SELECT 1
					FROM CourseStaffAssignments a
					WHERE CR.CourseId = a.CourseId
						AND (
							@TeachersAssignedFilter = '-1'
							OR a.StaffId = @TeachersAssignedFilter
							)
						AND ISNULL(a.RecordDeleted, 'N') = 'N'
					)

                    AND (@ClientAssignedFilter = '-1' OR CCA.ClientId = @ClientAssignedFilter)			
				--AND EXISTS (
				--	SELECT 1
				--	FROM CourseClientAssignments b
				--	WHERE CR.CourseId = b.CourseId
				--		AND (
				--			@ClientAssignedFilter = '-1'
				--			OR b.ClientId = @ClientAssignedFilter
				--			)
				--		AND ISNULL(b.RecordDeleted, 'N') = 'N'
				--	)
				);

		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT CourseId
				,CONVERT(VARCHAR(10), StartDate, 101) AS StartDate
				,CONVERT(VARCHAR(10), EndDate, 101) AS EndDate
				,TypeOfCourse
				,CourseGroup
				,NumberOfCredits
				,QuarterSemester
				,PrimaryTeacher
				,TeachersAssigned
				,AssignedClients
				,Count(*) OVER () AS TotalCount
				,row_number() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'StartDate'
								THEN StartDate
							END
						,CASE 
							WHEN @SortExpression = 'StartDate DESC'
								THEN StartDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'EndDate'
								THEN EndDate
							END
						,CASE 
							WHEN @SortExpression = 'EndDate DESC'
								THEN EndDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'TypeOfCourse'
								THEN TypeOfCourse
							END
						,CASE 
							WHEN @SortExpression = 'TypeOfCourse DESC'
								THEN TypeOfCourse
							END DESC
						,CASE 
							WHEN @SortExpression = 'CourseGroup'
								THEN CourseGroup
							END
						,CASE 
							WHEN @SortExpression = 'CourseGroup DESC'
								THEN CourseGroup
							END DESC
						,CASE 
							WHEN @SortExpression = 'NumberOfCredits'
								THEN NumberOfCredits
							END
						,CASE 
							WHEN @SortExpression = 'NumberOfCredits DESC'
								THEN NumberOfCredits
							END DESC
						,CASE 
							WHEN @SortExpression = 'QuarterSemester'
								THEN QuarterSemester
							END
						,CASE 
							WHEN @SortExpression = 'QuarterSemester DESC'
								THEN QuarterSemester
							END DESC
						,CASE 
							WHEN @SortExpression = 'PrimaryTeacher'
								THEN PrimaryTeacher
							END
						,CASE 
							WHEN @SortExpression = 'PrimaryTeacher DESC'
								THEN PrimaryTeacher
							END DESC
						,CASE 
							WHEN @SortExpression = 'TeachersAssigned'
								THEN TeachersAssigned
							END
						,CASE 
							WHEN @SortExpression = 'TeachersAssigned DESC'
								THEN TeachersAssigned
							END DESC
						,CASE 
							WHEN @SortExpression = 'AssignedClients'
								THEN AssignedClients
							END
						,CASE 
							WHEN @SortExpression = 'AssignedClients DESC'
								THEN AssignedClients
							END DESC
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) CourseId
			,CONVERT(VARCHAR(10), StartDate, 101) AS StartDate
			,CONVERT(VARCHAR(10), EndDate, 101) AS EndDate
			,TypeOfCourse
			,CourseGroup
			,NumberOfCredits
			,QuarterSemester
			,PrimaryTeacher
			,TeachersAssigned
			,AssignedClients
			,Totalcount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(Count(*), 0)
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
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT CourseId
			,CONVERT(VARCHAR(10), StartDate, 101) AS StartDate
			,CONVERT(VARCHAR(10), EndDate, 101) AS EndDate
			,TypeOfCourse
			,CourseGroup
			,NumberOfCredits
			,QuarterSemester
			,PrimaryTeacher
			,TeachersAssigned
			,AssignedClients
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCourses') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


