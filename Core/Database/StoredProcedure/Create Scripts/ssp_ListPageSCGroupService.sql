
/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCGroupService]    Script Date: 08/18/2015 16:08:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCGroupService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCGroupService]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCGroupService]    Script Date: 08/18/2015 16:08:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_ListPageSCGroupService]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @GroupId INT ,
    @GroupType INT ,
    @StaffId INT ,
    @ServiceStatusFilter INT ,
    @ProgramId INT ,
    @DateFrom DATETIME ,
    @DateTo DATETIME ,
    @OtherFilter INT                              
/********************************************************************************                              
-- Stored Procedure: dbo.ssp_ListPageSCGroupService                                
--                              
-- Copyright: Streamline Healthcate Solutions                              
--                              
-- Purpose: used by Client Documents list page                              
--                              
-- Updates:                                                                                     
-- Date        Author      Purpose                              
-- 05.06.2011  Shifali     Created.                                    
-- 29May, 2012 Rakesh-II   Modified: While fetching from #ResultSet(at last) all staff were added as StaffName4..changed them to StaffName1,StaffName2,3,4 etc                            
--19 july  Rakesh-II       Modified: changes as per the task #1613 in threshold bugs/features 
--26 Sep Venkatesh MR      Fix the issue to filter the group service based on clinician. Ref task # 175 in core-bugs. And also formate the sp if it is left join
							join is there then the record deleted should be in the same line only
--28 Oct, 2013 Manju P	   Modified: What/Why: Thresholds - Support #335 The start time for the group should be the minimum of the start time from GroupServicesStaff table for the group. Currently it is picking from GroupServices table.	
--8/18/2015	Chethan N		What : Changed Join to Left Join On services table
							Why: Philhaven - Customization Issues Tracking task# 1326 
--9/15/2015	Chethan N		What : Retrieving Dateservice from GroupServices table
							Why: Philhaven - Customization Issues Tracking task# 1372 	
--2/06/2016	Ravichandra		Removed the physical table ListPageSCAuthorizationCodes from SP
							Why:Engineering Improvement Initiatives- NBL(I)	
							108 - Do NOT use list page tables for remaining list pages (refer #107)
--9/12/2016	Hemant          What:Included the missing variable declaration SET @CustomFiltersApplied = 'N'
                            Why:group Services list page not returning any results Thresholds - Support #732																		
*********************************************************************************/
AS 
    BEGIN              
        BEGIN TRY                                                                                       
            CREATE TABLE #ResultSet
                (
                  GroupId INT ,
                  GroupCode VARCHAR(250) ,
                  GroupServiceId INT ,
                  NumberOfClients INT ,
                  [Status] VARCHAR(50) ,
                  DateOfService DATETIME ,
                  EndDateOfService DATETIME ,
                  ProgramId INT ,
                  ProgramCode VARCHAR(100) ,
                  StaffId1 INT ,
                  StaffName1 VARCHAR(150) ,
                  StaffId2 INT ,
                  StaffName2 VARCHAR(150) ,
                  StaffId3 INT ,
                  StaffName3 VARCHAR(150) ,
                  StaffId4 INT ,
                  StaffName4 VARCHAR(150)
                )        

            CREATE TABLE #FilterGroupService ( GroupServiceId INT )

            DECLARE @ApplyFilterClicked CHAR(1)                                              
            DECLARE @CustomFiltersApplied CHAR(1)                             
                     
            SET @CustomFiltersApplied = 'N' --Added by Hemant 9/12/2016           
-- Get custom filters                              
            IF @OtherFilter > 10000
                OR @ServiceStatusFilter > 10000 
                BEGIN        
        
                    INSERT  INTO #FilterGroupService
                            ( GroupServiceId
                            )
                            EXEC scsp_ListPageSCGroupService @GroupId = @GroupId,
                                @GroupType = @GroupType, @StaffId = @StaffId,
                                @ServiceStatusFilter = @ServiceStatusFilter,
                                @ProgramId = @ProgramId, @DateFrom = @DateFrom,
                                @DateTo = @DateTo, @OtherFilter = @OtherFilter                                     

                    IF EXISTS ( SELECT  *
                                FROM    #FilterGroupService
                                WHERE   GroupServiceId = -1 ) 
                        SET @CustomFiltersApplied = 'N'                             
                    ELSE 
                        SET @CustomFiltersApplied = 'Y'                             
                                
                END            
            
            

            IF @CustomFiltersApplied = 'N' 
                INSERT  INTO #FilterGroupService
                        ( GroupServiceId                            
                        )
                        SELECT  DISTINCT
                                gs.GroupServiceId
                        FROM    GroupServices gs
                                LEFT JOIN Groups g
                                    ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N'
                                LEFT JOIN GlobalCodes gc
                                    ON gc.GlobalCodeId = g.GroupType AND ISNULL(gc.RecordDeleted, 'N') = 'N'
                                LEFT JOIN Programs p	
                                    ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N'
                                LEFT JOIN Services s
                                    ON s.GroupServiceId = gs.GroupServiceId  
                                    AND s.Status <> 76 -- Exclude errors                                                 
                            -- Changes start  ---- done by Venkatesh for Task #175 in Core-bugs     
                                 LEFT JOIN GroupServiceStaff
                                    ON GroupServiceStaff.GroupServiceId = gs.GroupServiceId
                                   AND ISNULL(GroupServiceStaff.RecordDeleted, 'N') = 'N'
                               LEFT JOIN Staff
                                    ON GroupServiceStaff.StaffId = Staff.StaffId
                               AND ISNULL(Staff.RecordDeleted, 'N') = 'N'                             
                        WHERE   ISNULL(gs.RecordDeleted, 'N') = 'N'
                                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                
                                AND ( g.GroupId = @GroupId
                                      OR @GroupId = 0
                                    )
                                AND ( Staff.StaffId = @StaffId 
                                      OR @StaffId = 0
                                    )                                
                                AND ( gc.GlobalCodeId = @GroupType
                                      OR @GroupType = 0
                                    )
                                AND ( p.ProgramId = @ProgramId
                                      OR @ProgramId = 0
                                    )
                                AND ( @DateFrom IS NULL
                                      OR gs.DateOfService >= @DateFrom
                                    )
                                AND ( @DateTo IS NULL
                                      OR gs.DateOfService < DATEADD(dd, 1,
                                                              @DateTo)
                                    )
                                AND ( @ServiceStatusFilter IN ( 0, 471 )
                                      OR                 -- All Statuses                                   
                                      ( @ServiceStatusFilter = 474
                                        AND dbo.SCGetGroupServiceStatus(gs.GroupServiceId) IN (
                                        70, 71 )
                                      )
                                      OR -- Scheduled/Show                                             
                                      ( @ServiceStatusFilter = 473
                                        AND dbo.SCGetGroupServiceStatus(gs.GroupServiceId) = 70
                                      )
                                      OR       -- Scheduled                                  
                                      ( @ServiceStatusFilter = 472
                                        AND dbo.SCGetGroupServiceStatus(gs.GroupServiceId) = 75
                                      )
                                    )         -- Complete           
			
            INSERT  INTO #ResultSet
                    ( GroupId ,
                      GroupCode ,
                      GroupServiceId ,
                      NumberOfClients ,
                      [Status] ,
                      DateOfService ,
                      ProgramCode ,
                      ProgramId    
                    )
                    SELECT  g.GroupId ,
                            g.GroupCode ,
                            gs.GroupServiceId ,
                            COUNT(DISTINCT s.ClientId) ,
                            svcstatusgc.CodeName ,
                            gs.DateOfService ,
                            --MIN(GroupServiceStaff.DateOfService) ,
                            p.ProgramCode ,
                            p.ProgramId
                    FROM    GroupServices gs
                            LEFT JOIN Groups g
                                ON g.GroupId = gs.GroupId AND ISNULL(g.RecordDeleted, 'N') = 'N' 
                            LEFT JOIN GlobalCodes gc
                                ON gc.GlobalCodeId = g.GroupType AND ISNULL(gc.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Programs p
                                ON p.ProgramId = gs.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Services s
                                ON s.GroupServiceId = gs.GroupServiceId AND ISNULL(s.RecordDeleted, 'N') = 'N'
                                AND s.Status<>76
                            LEFT JOIN GroupServiceStaff
                                ON GroupServiceStaff.GroupServiceId = gs.GroupServiceId AND ISNULL(GroupServiceStaff.RecordDeleted, 'N') = 'N'
                            CROSS APPLY [dbo].[ssf_SCGetGroupServiceStatus](gs.GroupServiceId) svcstatus
                            LEFT OUTER JOIN dbo.GlobalCodes svcstatusgc
                                ON svcstatusgc.GlobalCodeId = svcstatus.[Status] AND ISNULL(svcstatusgc.RecordDeleted, 'N') = 'N'
                            INNER JOIN #FilterGroupService fgs
                                ON fgs.GroupServiceId = gs.GroupServiceId
                    WHERE  ISNULL(gs.RecordDeleted, 'N') = 'N' 
                    GROUP BY g.GroupId ,
                            g.GroupCode ,
                            gs.GroupServiceId ,
                            svcstatusgc.CodeName ,
                            gs.DateOfService ,
                            p.ProgramCode ,
                            p.ProgramId                    
   
-- Get staff                            
            UPDATE  r
            SET     StaffId1 = s.StaffId ,
                    StaffName1 = s.LastName + ', ' + s.FirstName
            FROM    #ResultSet r
                    JOIN GroupServiceStaff gss
                        ON gss.GroupServiceId = r.GroupServiceId
                    JOIN Staff s
                        ON s.StaffId = gss.StaffId
            WHERE   ISNULL(gss.RecordDeleted, 'N') = 'N'        
        
            UPDATE  r
            SET     StaffId2 = s.StaffId ,
                    StaffName2 = s.LastName + ', ' + s.FirstName
            FROM    #ResultSet r
                    JOIN GroupServiceStaff gss
                        ON gss.GroupServiceId = r.GroupServiceId
                    JOIN Staff s
                        ON s.StaffId = gss.StaffId
            WHERE   ISNULL(gss.RecordDeleted, 'N') = 'N'
                    AND s.StaffId NOT IN ( r.StaffId1 )        
    
            UPDATE  r
            SET     StaffId3 = s.StaffId ,
                    StaffName3 = s.LastName + ', ' + s.FirstName
            FROM    #ResultSet r
                    JOIN GroupServiceStaff gss
                        ON gss.GroupServiceId = r.GroupServiceId
                    JOIN Staff s
                        ON s.StaffId = gss.StaffId
            WHERE   ISNULL(gss.RecordDeleted, 'N') = 'N'
                    AND s.StaffId NOT IN ( r.StaffId1, r.StaffId2 )           
        
            UPDATE  r
            SET     StaffId4 = s.StaffId ,
                    StaffName4 = s.LastName + ', ' + s.FirstName
            FROM    #ResultSet r
                    JOIN GroupServiceStaff gss
                        ON gss.GroupServiceId = r.GroupServiceId
                    JOIN Staff s
                        ON s.StaffId = gss.StaffId
            WHERE   ISNULL(gss.RecordDeleted, 'N') = 'N'
                    AND s.StaffId NOT IN ( r.StaffId1, r.StaffId2, r.StaffId3 )         
  
           
           
           
           ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
		AS (SELECT GroupId ,
                      GroupCode ,
                      GroupServiceId ,
                      NumberOfClients ,
                      [Status] ,
                      DateOfService ,
                      ProgramCode ,
                      ProgramId 
                      StaffId1 ,
					  StaffName1 ,
					  StaffId2 ,
					  StaffName2 ,
					  StaffId3  ,
					  StaffName3 ,
					  StaffId4  ,
					  StaffName4    
				,Count(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER ( ORDER BY CASE
                                                              WHEN @SortExpression = 'GroupCode'
                                                              THEN GroupCode
                                                              END, CASE
                                                              WHEN @SortExpression = 'GroupCode desc'
                                                              THEN GroupCode
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'NumberOfClients'
                                                              THEN NumberOfClients
                                                              END, CASE
                                                              WHEN @SortExpression = 'NumberOfClients desc'
                                                              THEN NumberOfClients
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'Status'
                                                              THEN Status
                                                              END, CASE
                                                              WHEN @SortExpression = 'Status desc'
                                                              THEN Status
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'DateOfService'
                                                              THEN DateOfService
                                                              END, CASE
                                                              WHEN @SortExpression = 'DateOfService desc'
                                                              THEN DateOfService
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'ProgramCode'
                                                              THEN ProgramCode
                                                              END, CASE
                                                              WHEN @SortExpression = 'ProgramCode desc'
                                                              THEN ProgramCode
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'StaffName1'
                                                              THEN StaffName1
                                                              END, CASE
                                                              WHEN @SortExpression = 'StaffName1 desc'
                                                              THEN StaffName1
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'StaffName2'
                                                              THEN StaffName2
                                                              END, CASE
                                                              WHEN @SortExpression = 'StaffName2 desc'
                                                              THEN StaffName2
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'StaffName3'
                                                              THEN StaffName3
                                                              END, CASE
                                                              WHEN @SortExpression = 'StaffName3 desc'
                                                              THEN StaffName3
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'StaffName4'
                                                              THEN StaffName4
                                                              END, CASE
                                                              WHEN @SortExpression = 'StaffName4 desc'
                                                              THEN StaffName4
                                                              END DESC, GroupCode, GroupServiceId ) AS RowNumber
			FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT Isnull(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)	  GroupId ,
                      GroupCode ,
                      GroupServiceId ,
                      NumberOfClients ,
                      [Status] ,
                      DateOfService ,
                      ProgramCode ,
                      StaffId1 ,
					  StaffName1 ,
					  StaffId2 ,
					  StaffName2 ,
					  StaffId3  ,
					  StaffName3 ,
					  StaffId4  ,
					  StaffName4      
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT Isnull(Count(*), 0)	FROM #FinalResultSet) < 1
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

		SELECT		  GroupId ,
                      GroupCode ,
                      GroupServiceId ,
                      NumberOfClients ,
                      [Status] ,
                      DateOfService ,
                      ProgramCode ,
                      StaffId1 ,
					  StaffName1 ,
					  StaffId2 ,
					  StaffName2 ,
					  StaffId3  ,
					  StaffName3 ,
					  StaffId4  ,
					  StaffName4    
		FROM #FinalResultSet
		ORDER BY RowNumber

        END TRY              
        BEGIN CATCH              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_ListPageSCGroupService') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                        
            RAISERROR                                                                                           
 (                 
   @Error, -- Message text.                                                                                          
   16, -- Severity.                                                                                          
   1 -- State.                                                                                          
  );               
        END CATCH              
    END 


GO


