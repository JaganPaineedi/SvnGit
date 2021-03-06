/****** Object:  StoredProcedure [dbo].[ssp_SCListPageOMTaskReports]    Script Date: 11/18/2011 16:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageOMTaskReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageOMTaskReports]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
           
CREATE procedure [dbo].[ssp_SCListPageOMTaskReports]                                                               
@SessionId varchar(30),                                                                                      
@InstanceId int,                                                                                      
@PageNumber int,                                                                                          
@PageSize int,                                                                                          
@SortExpression varchar(100),                                                  
@StaffID   int,           
@TaskId int ,          
@OtherFilter int,        
@Category int,        
@Group int,        
@Type int                         
                      
/********************************************************************************                                                      
-- Stored Procedure: dbo.ssp_SCListPageReports                                                       
--                                                      
-- Copyright: Streamline Healthcate Solutions                                                      
--                                                      
-- Purpose: used by Report list page                                                      
--                                                      
-- Updates:                                                                                                             
-- Date        Author          Purpose                                                      
-- 09.07.2010  Anuj            Created.    
-- 08.10.2010   Maninder    Modified      
-- 30.08.2016  Ravichandra	Removed the physical table ListPageSCOMReports from SP
							Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
							108 - Do NOT use list page tables for remaining list pages (refer #107)	                                                           
*********************************************************************************/                                                      
AS                   
BEGIN   
BEGIN TRY                                                
CREATE TABLE #ResultSet(                                                                
			TaskConfigurationReportId	int,           
			TaskId						int,            
			ReportId					int,                                                              
			ReportServerId				int,                                                                            
			ReportName					varchar(250),                                                                                                  
			[Description]				varchar(max),                                                                            
			Folder						varchar(500)          

			)              
              
declare @CustomFilters table (TaskConfigurationReportId int)                                             
                
set @SortExpression = rtrim(ltrim(@SortExpression))                  
                
if isnull(@SortExpression, '') = ''                
  set @SortExpression= 'ReportName desc'                
                
            
               
-- Get result set                              
insert into #ResultSet(                                      
					TaskConfigurationReportId,                                                                   
					--TaskId,                                                                                 
					ReportId ,                         
					ReportServerId,                                                      
					ReportName,                
					[Description],           
					Folder              
					)                           
-- Added Catgeory,Group and Type on condition Criteria                  
		SELECT   TC.TaskConfigurationReportId, 
				R.ReportId, 
				R.ReportServerId, 
				R.Name, 
				R.Description, 
				R.ReportServerPath  
		FROM	dbo.TaskConfigurationReports AS TC 
			INNER JOIN  dbo.Reports AS R ON R.ReportId = TC.ReportId 
			INNER JOIN  dbo.TaskConfigurations AS TC2 ON TC.TaskConfigurationId = TC2.TaskConfigurationId  
			WHERE (ISNULL(TC.RecordDeleted, 'N') = 'N') 
			AND (ISNULL(R.RecordDeleted, 'N') = 'N')  
			AND  TC2.[Category]=@Category 
			AND  TC2.[Type]=@Type 
			AND TC2.[Group]=@Group      
               
  -- Get custom filters                             
if @OtherFilter > 10000                                
begin                                       
  insert into @CustomFilters (TaskConfigurationReportId)                                      
  exec scsp_SCListPageOMTaskReports  @OtherFilter = @OtherFilter           
   delete d                                                        
    from #ResultSet d  where not exists(select * from @CustomFilters f where f.TaskConfigurationReportId = d.TaskConfigurationReportId)                   
                 
end 

;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT TaskConfigurationReportId,                                                                   
					--TaskId,                                                                                 
					ReportId ,                         
					ReportServerId,                                                      
					ReportName,                
					[Description],           
					Folder            
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by	case when @SortExpression= 'Name' then ReportName end,                                                
                                                case when @SortExpression= 'Name desc' then ReportName end desc,                                                 
                                                case when @SortExpression= 'Description' then [Description] end,                                                          
                                                case when @SortExpression= 'Description desc' then [Description] end desc,                                                       
                                                case when @SortExpression= 'Folder' then Folder end,                                                        
                                                case when @SortExpression= 'Folder desc' Then Folder end desc,                                                                                                                                  
                                                ReportName,                                                      
                                                TaskConfigurationReportId) as RowNumber                                                    
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  TaskConfigurationReportId,                                                                   
					--TaskId,                                                                                 
					ReportId ,                         
					ReportServerId,                                                      
					ReportName,                
					[Description],           
					Folder  ,                              
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

		SELECT		TaskConfigurationReportId,                                                                   
				  --TaskId,                                                                                 
					ReportId ,                         
					ReportServerId,                                                      
					ReportName,                
					[Description],           
					Folder           
		FROM #FinalResultSet
		ORDER BY RowNumber      

             
END TRY                                 
BEGIN CATCH                                            
                                          
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageOMTaskReports')                                                                                                                       
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

