/****** Object:  StoredProcedure [dbo].[ssp_SCListPageOMTaskList]    Script Date: 11/18/2011 16:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageOMTaskList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageOMTaskList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                                 
CREATE procedure [dbo].[ssp_SCListPageOMTaskList]   
@SessionId varchar(30),                                                              
@InstanceId int,                                                              
@PageNumber int,                                                                  
@PageSize int,                                                                  
@SortExpression varchar(100),                                                              
@categoryId int,                                                                                        
@typeId int,                                                              
@statusId int,                                                              
@authorIdFilter int,                                                
@loggedInUserId int,                                                                                                                   
@otherFilter int                                                                            
                                                             
/********************************************************************************                                                              
-- Stored Procedure: dbo.ssp_SCListPageOMTaskList                                                                
--                                                              
-- Copyright: Streamline Healthcate Solutions                                                              
--                                                              
-- Purpose: used by  OMTask list page                                                              
--                                                              
-- Updates:                                                                                                                     
-- Date        Author       Purpose                                                              
-- 30.08.2010  Anuj         Created.                                                                    
-- 19.06.2016  Ravichandra	Removed the physical table ListPageSCOMTasks from SP
							Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
							108 - Do NOT use list page tables for remaining list pages (refer #107)	 	
*********************************************************************************/                                                              
AS
BEGIN
BEGIN TRY                                                           
                                                                                                                            
CREATE TABLE #ResultSet(                                                                                                                          
						TaskId		int,                                              
					  --CategoryID  int,                                              
						Category	varchar(100),                                              
					  --TypeId		int,                                              
						Type		varchar(100),                                                                                                   
					  --StatusID    int,                                                              
						Status      varchar(100),                                                              
					  --AuthorId    int,                                                              
						AssignedTo  varchar(100),                    
						StartDate   datetime,                    
						EndDate		datetime                           
					  --loggedInUserId     int,                    
					  --loggedInUserName varchar(100),                      
	                                              
					)                                                              
                                                              
DECLARE @CustomFilters TABLE (TaskId int)                                                              
                                                     
                                        
INSERT INTO #ResultSet(                                                              
					TaskId,                                                      
					--   CategoryID,                                              
					Category,                                           
					--TypeId,                                               
					Type,                                                                                                                      
					-- StatusID,                                                                             
					Status,                                                              
					-- AuthorId,                                                              
					AssignedTo ,                    
					StartDate,                    
					EndDate                                                                          
					--loggedInUserId,                                                              
					-- loggedInUserName                                                                           
					 )                                                                                                       
SELECT  DISTINCT t.TaskId,                                             
				--t.Category,                                            
				gcs.Codename,                                                
				--t.Type,                                             
				gcs1.CodeName,                                                                                       
				-- t.Status,                                                                   
				--   gcs2.CodeName + ' (' + Cast(t.PercentComplete as varchar) + '%)',    
				gcs2.CodeName ,                                             
				--  t.AssignedToStaffId,                                                                                            
				a.LastName + ', ' + a.FirstName,                    
				t.StartDate,                    
				t.EndDate                              
                                                                                           
	  FROM Tasks t                                                                         
		   left join GlobalCodes gcs on gcs.GlobalCodeId =   t.Category                                                                                              
		   left join GlobalCodes gcs1 on gcs1.GlobalCodeId= t.Type                                            
		   left join GlobalCodes gcs2 on  gcs2.GlobalCodeId= t.Status                                                                                                        
		   left join Staff a on a.StaffId = t.AssignedToStaffId                                                                                      
 WHERE                                                                                                                                           
			-- (t.Category= @categoryId or isnull(@categoryId, 0) = 0)                                   
			--and (t.Type= @typeId or ISNULL(@typeId,0) = 0)                         
			-- and (t.Status= @statusId or ISNULL(@statusId,0) = 0)                     
			(t.AssignedToStaffId= @authorIdFilter or ISNULL(@authorIdFilter,0) = 0)                                                                                                                      

			and (@categoryId = 0 or -- All Statuses                    
			--@categoryId > 10000 or -- Custom Status     
			(t.Category = @categoryId))               
			and (@typeId = 0 or -- All Statuses                                                                                                                   
			(t.[Type] = @typeId))                                      
			and (@statusId = 0 or -- All Statuses                                                              
			(@statusId = 451 and t.[Status] = 6041) or -- Scheduled                                                             
			(@statusId = 452 and t.[Status] = 6042) or -- Show                                                              
			(@statusId = 453 and t.[Status] = 6043)) --or -- No Show                                                                                                                        
			and isnull(t.RecordDeleted, 'N') = 'N'                                                     
     
                           
                                                              
--if @categoryId > 10000 or @typeId > 10000 or @statusId > 10000 or @OtherFilter > 10000          
IF  @OtherFilter < 10000                   
BEGIN                                       
  INSERT INTO @CustomFilters (TaskId)                                                              
  EXECUTE dbo.scsp_SCListPageOMTaskList @categoryId = @categoryId,@typeId = @typeId,@statusId=@statusId, @OtherFilter = @OtherFilter                                                              
                                                              
  DELETE d              
   FROM #ResultSet d  WHERE not exists(SELECT * FROM @CustomFilters f WHERE f.TaskId = d.TaskId)                                                              
END 



;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT TaskId,                                                                                         
					Category,                                                                                    
					Type,                                                                                                                                                                                              
					Status,                                                                                                                     
					AssignedTo ,                    
					StartDate,                    
					EndDate                                                                           
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'TaskId' then TaskId end,                                                      
												case when @SortExpression= 'TaskId desc' then TaskId end desc,
												case when @SortExpression= 'Type' then Type end,                                                        
												case when @SortExpression= 'Type desc' then Type end desc,                                                              
                                                case when @SortExpression= 'Category' then Category end,                                                                  
                                                case when @SortExpression= 'Category desc' then Category end desc,                                                 
                                                case when @SortExpression= 'Type' then Type end,                                                                  
                                                case when @SortExpression= 'Type desc' Then Type end desc,                  
                                                                                         
                                                case when @SortExpression= 'Status' then Status end,                                                                  
                                                case when @SortExpression= 'Status desc' then Status end desc,                                            
                                                case when @SortExpression= 'AssignedTo' then AssignedTo end,                                                                  
												case when @SortExpression= 'AssignedTo desc' then AssignedTo end desc,                     
												case when @SortExpression= 'StartDate' then StartDate end,                                                                  
												case when @SortExpression= 'StartDate desc' then StartDate end desc,                    
												case when @SortExpression= 'EndDate' then EndDate end,                                                                  
												case when @SortExpression= 'EndDate desc' then EndDate end desc,                                        
                                                Category,                                                              
                                                TaskId) as RowNumber                                                
               FROM #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  TaskId,                                                                                         
					Category,                                                                                    
					Type,                                                                                                                                                                                              
					Status,                                                                                                                     
					AssignedTo ,                    
					StartDate,                    
					EndDate  ,                             
			 TotalCount,
			 RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
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

		SELECT		TaskId,                                                                                         
					Category,                                                                                    
					Type,                                                                                                                                                                                              
					Status,                                                                                                                                    
					StartDate,                    
					EndDate,  
					AssignedTo       
		FROM #FinalResultSet
		ORDER BY RowNumber                                
                               
END TRY                             
BEGIN CATCH                                        
                                      
DECLARE @Error varchar(8000)                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageOMTaskList')                                                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                                
 RAISERROR                                                                       
 (                                                                                     
  @Error, -- Message text.                                                                                                                  
  16, -- Severity.                                                                                                                  
  1 -- State.                                                                                                                  
 );                                                                                                                
END CATCH                                                              
END                                                                
                                        

