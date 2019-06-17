IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageReports]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageReports]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageReports]        
@SessionId varchar(30),                                                                                  
@InstanceId int,                                                                                  
@PageNumber int,                                                                                      
@PageSize int,                                                                                      
@SortExpression varchar(100),                                                                                             
@FolderNavigationId int,                                                                                                                                                 
@ReportDescription varchar(100),                                        
@OtherFilter int,              
@StaffId   int,                      
@AssociatedWith int,              
@DetailScreenId int                      
/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_ListPageReports                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by Reports list page                                                  
--                                                  
-- Updates:                                                                                                         
-- Date			 Author          Purpose                                                  
-- 06.08.2011	 SFarber         Created.       
-- 11 June 2012  Vikesh          #1482(String or Data Truncated Error)    
-- 16 JUN,2016   Ravichandra	 Removed the physical table ListPageReports  from SP
								 Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
								 108 - Do NOT use list page tables for remaining list pages (refer #107)	                 
*********************************************************************************/  
AS
BEGIN

	BEGIN TRY
	 SET NOCOUNT ON; 
		DECLARE @CustomFiltersApplied char(1)            
		DECLARE @ApplyFilterClicked char(1)                                  
        
SET @SortExpression = rtrim(ltrim(@SortExpression))              
            
IF ISNULL(@SortExpression, '') = ''            
  SET @SortExpression= 'Name'            
  
  
 SET @ApplyFilterClicked = 'Y'                         
SET @CustomFiltersApplied = 'N';  
		
	CREATE TABLE #ResultSet (                                                                                          
			ReportId         int,                                                          
			ReportServerId   int,                                                                                           
			DetailScreenId   int,                                                                           
			ReportName       varchar(260),                                                                                              
			Description      varchar(max),                                                                        
			Folder           varchar(500),        
			ReportServerPath varchar(500)
			)    

	CREATE TABLE #Reports (  
			ParentFolderId   int,   
			ParentFolderName varchar(max),   
			ParentFolderIDs  varchar(max),   
			ReportId         int,   
			ReportName       varchar(260)
			)    
          
	CREATE TABLE #CustomFilters (ReportId int)            
 
 IF @OtherFilter > 10000                            
	BEGIN            
            
	  SET @CustomFiltersApplied = 'Y'                  
	            
	  INSERT INTO #CustomFilters (ReportId)                                  
	  exec scsp_ListPageReports @FolderNavigationId = @FolderNavigationId,                                                                                                                                                 
								@ReportDescription = @ReportDescription,                                        
								@OtherFilter = @OtherFilter,              
								@StaffId   = @StaffId,         
								@AssociatedWith = @AssociatedWith,              
								@DetailScreenId = @DetailScreenId  
	END           
  
-- Get report item catalog    
		;WITH ReportCatalog(ParentFolderId, ParentFolderName, ParentFolderIDs, ReportId, ReportName)    
		AS    
		(    
		-- Anchor definition    
				SELECT r.ParentFolderId as ParentFolderId,    
						CONVERT(varchar(max), '') as ParentFolderName,   
						CONVERT(varchar(max), '.0.') as ParentFolderIDs,   
						r.ReportId as ReportId,    
						r.Name as ReportName    
				FROM Reports r    
				WHERE r.ParentFolderId is null  
				and ISNULL(r.RecordDeleted, 'N') = 'N' 
				  
				UNION ALL    
				-- Recursive definition    
				SELECT r.ParentFolderId,    
						rc.ParentFolderName + case when LEN(rc.ParentFolderName) > 0 then '\' else '' end  + rc.ReportName,    
						rc.ParentFolderIDs + ISNULL(CONVERT(varchar, rc.ReportId), '') + '.',  
						r.ReportId,    
						r.Name    
				FROM Reports r    
				join ReportCatalog rc on rc.ReportId = r.ParentFolderId    
				WHERE ISNULL(r.RecordDeleted, 'N') = 'N'    
		)    
		
INSERT INTO #Reports (
			ParentFolderId, 
			ParentFolderName, 
			ParentFolderIDs, 
			ReportId, 
			ReportName
			)    
			SELECT
			 rc.ParentFolderId, 
			 rc.ParentFolderName, 
			 ParentFolderIDs, 
			 rc.ReportId,  
			 rc.ReportName +  case when r.IsFolder = 'Y' then ' (Folder)' else '' end as ReportName    
			FROM ReportCatalog rc    
			JOIN Reports r on r.ReportId = rc.ReportId    
       
         


INSERT INTO #ResultSet(                                  
       ReportId,                                                               
       ReportServerId,                                                                             
       DetailScreenId ,                     
       ReportName,                                                  
       [Description],            
       Folder ,        
       ReportServerPath)           
SELECT r.ReportId,        
       ISNULL(r.ReportServerId,0),                                                                              
       @DetailScreenId as DetailScreenId,        
       rc.ReportName,        
       r.Description,        
       rc.ParentFolderName,        
       r.ReportServerPath  
  FROM Reports r    
       JOIN #Reports rc on rc.ReportId = r.ReportId     
 WHERE (@DetailScreenId = 108 or exists(select * from ViewStaffPermissions vsp where vsp.StaffId = @StaffId and vsp.PermissionItemId = r.ReportId and vsp.PermissionTemplateType=5907))  
   and (@DetailScreenId = 108 or ISNULL(r.IsFolder, 'N') = 'N')  
   and ((@CustomFiltersApplied = 'Y' and exists(select * from #CustomFilters cf where cf.ReportId = r.ReportId)) or  
        (@CustomFiltersApplied = 'N' and  
         (ISNULL(@FolderNavigationId, 0) = 0 or rc.ParentFolderIDs like '%.' + CONVERT(varchar, @FolderNavigationId) + '.%') and  
         (ISNULL(@AssociatedWith, 0) = 0 or r.AssociatedWith = @AssociatedWith) and  
         (ISNULL(@ReportDescription, '') = '' or r.Description like '%' + @ReportDescription + '%' or r.Name like '%' + @ReportDescription + '%')  
        )  
       )  ;
  
  WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ReportId,                                      
			 ReportServerId,                                                                     
			 DetailScreenId,                                                                          
			 ReportName,                                                  
			 [Description],                      
			 Folder ,        
			 ReportServerPath  
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'Name' then ReportName end,                                            
                                                case when @SortExpression= 'Name desc' then ReportName end desc,                                                  
                                                case when @SortExpression= 'Description' then [Description] end,                                                      
                                                case when @SortExpression= 'Description desc' then [Description] end desc,                                                   
                                                case when @SortExpression= 'Folder' then Folder end,                                                      
                                                case when @SortExpression= 'Folder desc' Then Folder end desc,        
                                                case when @SortExpression= 'ReportServerPath' then ReportServerPath end,                                                      
                                                case when @SortExpression= 'ReportServerPath desc' Then ReportServerPath end desc,                                                                                                                             
                                                ReportName,                                                  
                                                ReportId) as RowNumber    
												FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ReportId,                                      
				 ReportServerId,                                                                     
				 DetailScreenId,                                                                          
				 ReportName,                                                  
				 [Description],                      
				 Folder ,        
				 ReportServerPath  
				,TotalCount
				,RowNumber
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

		SELECT ReportId,                                      
			 ReportServerId,                                                                     
			 DetailScreenId,                                                                          
			 ReportName,                                                  
			 [Description],                      
			 Folder ,        
			 ReportServerPath 
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY
	
	 BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_ListPageReports')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 

      