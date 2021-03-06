IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCCopyGroupServiceDocuments]')
  AND type IN (N'P',
  N'PC'))
  DROP PROCEDURE [dbo].[ssp_ListPageSCCopyGroupServiceDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
               
Create procedure [dbo].[ssp_ListPageSCCopyGroupServiceDocuments] --'hjkzprrtd3ettkuuvbzv2455',4,0,40,'',10455,-1,10456,0                                                         
@SessionId varchar(30),                                                  
@InstanceId int,                                                  
@PageNumber int,                                                      
@PageSize int,                                                      
@SortExpression varchar(100),                                                  
                       
@FromDateFilter DateTime,                                                   
@ToDateFilter DateTime,                      
@ProcedureCodeIdFilter int,                                                  
@ProgramIdFilter int,        
@LocationIdFilter int,        
@GroupIdFilter int,        
@StaffIdFilter int,        
@GroupNoteDocumentCodeId int,        
@CurrentGroupId int,        
@CurrentGroupServiceId int        
/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_ListPageSCCopyGroupServiceDocuments                                              
-- Copyright: Streamline Healthcate Solutions                                                  
-- Purpose: used by Staff Users list page                                                  
-- Updates:                                                                                                         
-- Date        Author            Purpose                                                  
-- 08.15.2009  Maninder     Created.  
-- 3/14/2016   Hemant       Changed ProcedureCode length to 250 in #ResultSet table why: Core Bugs#2036   
-- 13-APRIL-2016  Akwinass	What:Included GroupNoteType Column.          
							Why:task #167.1 Valley - Support Go Live  
-- 27.09.2016  Ravichandra	Removed the physical table ListPageSCCopyGroupServiceDocuments from SP
--							Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--							108 - Do NOT use list page tables for remaining list pages (refer #107)	                                               
*********************************************************************************/                                                  
AS                                                                      
 BEGIN                                                                                  
 BEGIN TRY  
                                     
CREATE TABLE #ResultSet(         
		ListPageSCCopyGroupServiceDocumentId INT IDENTITY(1,1) NOT NULL,                                                                                                    
		GroupServiceId int,                                   
		GroupCode varchar(50),                       
		GroupServiceDate DATETIME,                       
		ProgramCode varchar(100),                      
		ProcedureCode varchar(250),                           
		LocationCode varchar(50),                       
		StaffNames varchar(MAX)                      
		)                                                                      
         
                                                        
                                                                                 
INSERT INTO #ResultSet(                                    
		 GroupServiceId,                                   
		GroupCode ,                       
		GroupServiceDate ,                       
		ProgramCode ,                      
		ProcedureCode ,                           
		LocationCode ,                       
		StaffNames                                    
		)                                           
 SELECT   
		gs.GroupServiceId,          
		(g.GroupCode),              
		(select top 1 min(DateOfService) from GroupServiceStaff where GroupServiceId=gs.GroupServiceId and isnull(GroupServiceStaff.RecordDeleted,'N')<>'Y' ) as DateOfService,                
		min(p.ProgramCode),        
		min(pc.ProcedureCodeName),        
		min(Locations.LocationCode),     
		dbo.SCGetGroupStaffNames(gs.GroupServiceId)      
  FROM GroupServices gs               
LEFT JOIN Groups g on g.GroupId=gs.GroupId               
LEFT JOIN GlobalCodes gc on gc.GlobalCodeId=g.GroupType              
LEFT JOIN Programs p on p.ProgramId = gs.ProgramId              
JOIN Services s on s.GroupServiceId = gs.GroupServiceId                
--left join Staff on Staff.StaffId=gs.ClinicianId        
LEFT JOIN ProcedureCodes pc on gs.ProcedureCodeId=pc.ProcedureCodeId        
LEFT JOIN Locations on Locations.LocationId=g.LocationId        
LEFT JOIN GroupServiceStaff gss on gss.GroupServiceId=gs.GroupServiceId        
         
 WHERE ISNULL(gs.RecordDeleted, 'N') = 'N'        
 AND (gss.DateOfService>=@FromDateFilter or @FromDateFilter is null )         
 AND (gss.EndDateOfService<=@ToDateFilter or @ToDateFilter is null )        
 AND (@GroupIdFilter=-1 or gs.GroupId=@GroupIdFilter)        
 AND (@ProcedureCodeIdFilter=-1 or gs.ProcedureCodeId=@ProcedureCodeIdFilter)        
 AND (@ProgramIdFilter=-1 or gs.ProgramId=@ProgramIdFilter)        
 AND (@LocationIdFilter=-1 or gs.LocationId=@LocationIdFilter) and g.GroupNoteDocumentCodeId=@GroupNoteDocumentCodeId AND ISNULL(g.GroupNoteType,0) = 9383 --13-APRIL-2016  Akwinass    
 AND (@StaffIdFilter=-1 or @StaffIdFilter in (select StaffId from GroupServiceStaff where GroupServiceId=gs.GroupServiceId and ISNULL(gss.RecordDeleted,'N')<>'Y'))        
 --and g.GroupId<>@CurrentGroupId        
 AND gs.GroupServiceId<>@CurrentGroupServiceId        
 group by gs.GroupServiceId,g.GroupCode,pc.ProcedureCodeName                    
                       
                
                            
 ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT   GroupServiceId,                                   
						GroupCode ,                       
						GroupServiceDate ,                       
						ProgramCode ,                      
						ProcedureCode ,                           
						LocationCode ,                       
						StaffNames          
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by	case when @SortExpression= 'StaffNames' then StaffNames end,                                                      
                                                case when @SortExpression= 'StaffNames desc' then StaffNames end desc,                                                            
                                                case when @SortExpression= 'ProgramCode' then ProgramCode end ,                                                                
                                                case when @SortExpression= 'ProgramCode desc' then ProgramCode end desc,                                                
                                                case when @SortExpression= 'ProcedureCode' then ProcedureCode end,                                                                
                                                case when @SortExpression= 'ProcedureCode desc' Then ProcedureCode end desc,                                                
                                                --case when @SortExpression= 'CaseLoad' then CaseLoad end,                                                                
                                                --case when @SortExpression= 'CaseLoad desc' Then CaseLoad end desc,                                                             
                                                case when @SortExpression= 'LocationCode' then LocationCode end,                                                                
                                                case when @SortExpression= 'LocationCode desc' then LocationCode end desc,                                                            
                                                case when @SortExpression= 'GroupCode' then GroupCode end,                                   
                                                case when @SortExpression= 'GroupCode desc' then GroupCode end desc,                                                            
                                                case when @SortExpression= 'GroupServiceDate' then GroupServiceDate end,                                   
                                                case when @SortExpression= 'GroupServiceDate desc' then GroupServiceDate end desc,                                                                         
                           GroupServiceId ) as RowNumber                                                                                       
				from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)		GroupServiceId,                                   
						GroupCode ,                       
						GroupServiceDate ,                       
						ProgramCode ,                      
						ProcedureCode ,                           
						LocationCode ,                       
						StaffNames,                                   
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

		SELECT	GroupServiceId,                                   
						GroupCode ,                       
						GroupServiceDate ,                       
						ProgramCode ,                      
						ProcedureCode ,                           
						LocationCode ,                       
						StaffNames                   
		FROM #FinalResultSet
		ORDER BY RowNumber       
 
 END TRY                                                     
                                                                                                                                                         
BEGIN CATCH                                      
                      
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCCopyGroupServiceDocuments')                                                                                                                 
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

