/****** Object:  StoredProcedure [dbo].[ssp_ListPagePMGroups]    Script Date: 04/29/2015 12:24:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPagePMGroups]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPagePMGroups]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPagePMGroups]    Script Date: 04/29/2015 12:24:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPagePMGroups] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ActiveStatus CHAR(2)
	,@StaffId INT
	,@ProgramId INT
	,@LocationId INT
	,@OtherFilter INT
	,@LoggedInStaffId INT
	,@Attendance char(1) = NULL
	,@GroupName VARCHAR(100) = ''    
	/********************************************************************************                                  
-- Stored Procedure: [ssp_ListPagePMGroups]                                    
--                                  
-- Copyright: Streamline Healthcate Solutions                                  
--                                  
-- Purpose: used by GroupListPage                                  
--                                  
-- Updates:                                                                                         
-- Date         Author      Purpose                                  
-- Dec 17,2009  Pradeep     Created.                                        
-- Apr15, 2011 Shifali  Data model changes  
--19 july  Rakesh-II    Modified: changes as per the task #1619 in Threshold Bugs/features
-- 3rd Jan 2013         Modified by Sunil ...Increase the Size for Groupcode,locationcode,procedurecode.-- 
-- 04/11/2014  John S	Changed DataType length of ProcedureCode  from 100 to 250
-- 06/08/2015  Akwinass	Attendance Column - 'UsesAttendanceFunctions' Added (Task #829 Woods - Customizations)
-- 03/10/2018  Venkatesh	Added one more search filter and that will search based on the Group Name Ref Task  Engineering Improvement Initiatives- NBL(I) #721
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #ResultSet (
			ListPagePMGroupId [bigint] IDENTITY(1, 1) NOT NULL
			,RowNumber INT
			,PageNumber INT
			,GroupId INT
			,GroupCode VARCHAR(100)
			,Active VARCHAR(10)
			,ProgramId INT
			,ProgramCode VARCHAR(100)
			,LocationId INT
			,LocationCode VARCHAR(100)
			,ProcedureCodeId INT
			,ProcedureCode VARCHAR(250)
			,StaffId INT NULL
			,StaffId1 INT
			,StaffName1 VARCHAR(500)
			,StaffId2 INT
			,StaffName2 VARCHAR(500)
			,StaffId3 INT
			,StaffName3 VARCHAR(500)
			,StaffId4 INT
			,StaffName4 VARCHAR(500)
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions VARCHAR(3)
			)

		CREATE TABLE #ResultSetNew (
			ListPagePMGroupId [bigint] IDENTITY(1, 1) NOT NULL
			,RowNumber INT
			,PageNumber INT
			,GroupId INT
			,GroupCode VARCHAR(100)
			,Active VARCHAR(10)
			,ProgramId INT
			,ProgramCode VARCHAR(100)
			,LocationId INT
			,LocationCode VARCHAR(100)
			,ProcedureCodeId INT
			,ProcedureCode VARCHAR(250)
			,StaffId INT NULL
			,StaffId1 INT
			,StaffName1 VARCHAR(500)
			,StaffId2 INT
			,StaffName2 VARCHAR(500)
			,StaffId3 INT
			,StaffName3 VARCHAR(500)
			,StaffId4 INT
			,StaffName4 VARCHAR(500)
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions VARCHAR(3)
			)

		CREATE TABLE #CustomFilters (GroupId INT)

		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFiltersApplied CHAR(1)

		SET @ApplyFilterClicked = 'Y'
		SET @CustomFiltersApplied = 'N'

		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_ListPagePMGroups', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #CustomFilters (GroupId)
				EXEC scsp_ListPagePMGroups @ActiveStatus = @ActiveStatus
					,@StaffId = @StaffId
					,@ProgramId = @ProgramId
					,@LocationId = @LocationId
					,@OtherFilter = @OtherFilter
					,@LoggedInStaffId = @LoggedInStaffId
			END
		END

		INSERT INTO #ResultSet (
			GroupId
			,GroupCode
			,Active
			,ProgramId
			,ProgramCode
			,LocationId
			,LocationCode
			,ProcedureCodeId
			,ProcedureCode
			,StaffId
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions
			)
		--exec ssp_SCGetDataForGroups @ActiveStatus,@StaffsId,@ProgramsId,@LocationsId                                  
		SELECT Groups.GroupId
			,Groups.GroupCode
			,Groups.Active
			,Programs.ProgramId
			,Programs.ProgramCode
			,Locations.LocationId
			,Locations.LocationCode
			,Procedurecodes.ProcedureCodeId
			,ProcedureCodes.DisplayAs
			,Staff.StaffId
			-- 06/08/2015  Akwinass
			,CASE WHEN ISNULL(Groups.UsesAttendanceFunctions,'N') = 'Y' THEN 'Yes' ELSE 'No' END
		FROM Groups
		LEFT JOIN Programs ON Groups.ProgramId = Programs.ProgramId
		LEFT JOIN Locations ON groups.LocationId = Locations.LocationId
		LEFT JOIN Procedurecodes ON Groups.ProcedureCodeId = ProcedureCodes.ProcedureCodeId
		--left join Staff on Groups.ClinicianId=Staff.StaffId  --Commented by Rakesh-II #1619
		LEFT JOIN GroupStaff ON GroupStaff.GroupId = Groups.GroupId AND ISNULL(GroupStaff.RecordDeleted, 'N') = 'N'--added by Rakesh-II #1619
		LEFT JOIN Staff ON GroupStaff.StaffId = Staff.StaffId AND ISNULL(Staff.RecordDeleted, 'N') = 'N'--added by Rakesh-II   #1619                                               
		LEFT JOIN GlobalCodes GC ON Staff.Degree = GC.GlobalCodeId
		WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #CustomFilters cf WHERE cf.GroupId = Groups.GroupId))
				OR (
					@CustomFiltersApplied = 'N'
					AND ISNULL(Groups.RecordDeleted, 'N') = 'N'
					AND ISNULL(GC.RecordDeleted, 'N') = 'N'
					AND ISNULL(Locations.RecordDeleted, 'N') = 'N'
					AND ISNULL(Programs.RecordDeleted, 'N') = 'N'
					AND ISNULL(Procedurecodes.RecordDeleted, 'N') = 'N'					
					AND (Groups.Active = @ActiveStatus OR @ActiveStatus = '-1')
					AND (Programs.ProgramId = @ProgramId OR @ProgramId = - 1)
					AND (Staff.StaffId = @StaffId OR @StaffId = - 1)
					AND (Locations.LocationId = @LocationId	OR @LocationId = - 1)
					-- 06/08/2015  Akwinass
					AND (ISNULL(Groups.UsesAttendanceFunctions,'N') = @Attendance OR @Attendance= '')
					))
					AND (@GroupName='' OR (Groups.GroupName like '%'+@GroupName+'%' or Groups.GroupCode like '%'+@GroupName+'%'))  
		
		UPDATE r
		SET StaffId1 = s.StaffId
			,StaffName1 = s.LastName + ', ' + s.FirstName
		FROM #ResultSet r
		INNER JOIN GroupStaff gs ON gs.GroupId = r.GroupId
		INNER JOIN Staff s ON s.StaffId = gs.StaffId
		WHERE isnull(gs.RecordDeleted, 'N') = 'N'
		
		UPDATE r
		SET StaffId2 = s.StaffId
			,StaffName2 = s.LastName + ', ' + s.FirstName
		FROM #ResultSet r
		INNER JOIN GroupStaff gs ON gs.GroupId = r.GroupId
		INNER JOIN Staff s ON s.StaffId = gs.StaffId
		WHERE isnull(gs.RecordDeleted, 'N') = 'N'
			AND s.StaffId NOT IN (r.StaffId1)
			
		UPDATE r
		SET StaffId3 = s.StaffId
			,StaffName3 = s.LastName + ', ' + s.FirstName
		FROM #ResultSet r
		INNER JOIN GroupStaff gs ON gs.GroupId = r.GroupId
		INNER JOIN Staff s ON s.StaffId = gs.StaffId
		WHERE isnull(gs.RecordDeleted, 'N') = 'N'
			AND s.StaffId NOT IN (r.StaffId1,r.StaffId2)
				
		UPDATE r
		SET StaffId4 = s.StaffId
			,StaffName4 = s.LastName + ', ' + s.FirstName
		FROM #ResultSet r
		INNER JOIN GroupStaff gs ON gs.GroupId = r.GroupId
		INNER JOIN Staff s ON s.StaffId = gs.StaffId
		WHERE isnull(gs.RecordDeleted, 'N') = 'N'
			AND s.StaffId NOT IN (r.StaffId1,r.StaffId2,r.StaffId3) --Done By Rakesh-II for#task #1619 in Threshold bugs & features 
					
		TRUNCATE TABLE #ResultSetNew
		INSERT INTO #ResultSetNew --create new container(#ResultSetNew) & pour distinct result in to it & again reset final results into main #ResultSet table   
		SELECT RowNumber
			,PageNumber
			,GroupId
			,GroupCode
			,Active
			,ProgramId
			,ProgramCode
			,LocationId
			,LocationCode
			,ProcedureCodeId
			,ProcedureCode
			,StaffId
			,StaffId1
			,StaffName1
			,StaffId2
			,StaffName2
			,StaffId3
			,StaffName3
			,StaffId4
			,StaffName4
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions
		FROM (SELECT row_number() OVER (PARTITION BY GroupId ORDER BY GroupId DESC) AS RNo,* FROM #ResultSet) AS tab
		WHERE tab.RNo = 1 TRUNCATE TABLE #ResultSet
				
		INSERT INTO #ResultSet
		SELECT RowNumber
			,PageNumber
			,GroupId
			,GroupCode
			,Active
			,ProgramId
			,ProgramCode
			,LocationId
			,LocationCode
			,ProcedureCodeId
			,ProcedureCode
			,StaffId
			,StaffId1
			,StaffName1
			,StaffId2
			,StaffName2
			,StaffId3
			,StaffName3
			,StaffId4
			,StaffName4
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions
		FROM #ResultSetNew			

		;WITH Counts
		AS (SELECT Count(*) AS TotalRows  FROM #ResultSetNew)
		,RankResultSet
		AS (SELECT ListPagePMGroupId
				,GroupId
				,GroupCode
				,Active
				,ProgramId
				,ProgramCode
				,LocationId
				,LocationCode
				,ProcedureCodeId
				,ProcedureCode
				,StaffId
				,StaffId1
				,StaffName1
				,StaffId2
				,StaffName2
				,StaffId3
				,StaffName3
				,StaffId4
				,StaffName4
				-- 06/08/2015  Akwinass
				,UsesAttendanceFunctions
				,Count(*) OVER () AS TotalCount
				,Rank() OVER (
					ORDER BY CASE WHEN @SortExpression = 'GroupCode'      THEN GroupCode END
						,CASE WHEN @SortExpression = 'GroupCode desc'     THEN GroupCode END DESC
						,CASE WHEN @SortExpression = 'ProgramCode'        THEN ProgramCode END
						,CASE WHEN @SortExpression = 'ProgramCode desc'   THEN ProgramCode END DESC
						,CASE WHEN @SortExpression = 'LocationCode'       THEN LocationCode END
						,CASE WHEN @SortExpression = 'LocationCode desc'  THEN LocationCode END DESC
						,CASE WHEN @SortExpression = 'ProcedureCode'      THEN ProcedureCode END
						,CASE WHEN @SortExpression = 'ProcedureCode desc' THEN ProcedureCode END DESC
						,CASE WHEN @SortExpression = 'StaffName1'         THEN StaffName1 END
						,CASE WHEN @SortExpression = 'StaffName1 desc'    THEN StaffName1 END DESC
						,CASE WHEN @SortExpression = 'StaffName2'         THEN StaffName2 END
						,CASE WHEN @SortExpression = 'StaffName2 desc'    THEN StaffName2 END DESC
						,CASE WHEN @SortExpression = 'StaffName3'         THEN StaffName3 END
						,CASE WHEN @SortExpression = 'StaffName3 desc'    THEN StaffName3 END DESC
						,CASE WHEN @SortExpression = 'StaffName4'         THEN StaffName4 END
						,CASE WHEN @SortExpression = 'StaffName4 desc'    THEN StaffName4 END DESC
						-- 06/08/2015  Akwinass
						,CASE WHEN @SortExpression = 'Attendance'         THEN UsesAttendanceFunctions END
						,CASE WHEN @SortExpression = 'Attendance desc'    THEN UsesAttendanceFunctions END DESC
						,GroupCode
						,GroupId
						,ListPagePMGroupId
					) AS RowNumber
			FROM #ResultSetNew
			)
		SELECT TOP (CASE  WHEN (@PageNumber = - 1) THEN (SELECT Isnull(TotalRows, 0) FROM Counts) ELSE (@PageSize) END) GroupId
			,GroupCode
			,ProgramCode
			,LocationCode
			,ProcedureCode
			,StaffName1
			,StaffName2
			,StaffName3
			,StaffName4
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
 
				
		IF (SELECT Isnull(Count(*), 0) 	FROM #FinalResultSet) < 1
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
	
		SELECT @SessionId AS SessionId
			,@InstanceId AS InstanceId
			,RowNumber
			--,PageNumber
			,@SortExpression
			,GroupId
			,GroupCode
			,ProgramCode
			,LocationCode
			,ProcedureCode
			,StaffName1
			,StaffName2
			,StaffName3
			,StaffName4
			-- 06/08/2015  Akwinass
			,UsesAttendanceFunctions
		FROM #FinalResultSet
		ORDER BY RowNumber 
				
	END TRY

	 BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPagePMGroups') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


