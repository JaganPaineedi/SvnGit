
/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePqriMeasureSubmission]    Script Date: 12/15/2011 16:25:42 ******/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCListPagePqriMeasureSubmission')
	BEGIN
		DROP  Procedure  ssp_SCListPagePqriMeasureSubmission
	END

GO           

CREATE  PROCEDURE ssp_SCListPagePqriMeasureSubmission    
(                            
 @LoggedInStaffId INT,        
 @SessionId VARCHAR(30),                                                                                        
 @InstanceId int,                                                                                        
 @PageNumber int,                                                                                            
 @PageSize int,                                                                                            
 @SortExpression VARCHAR(100),                                          
 @dateFilter datetime = null,
 @staffId int = null,
 @OtherFilter int             
 )        
 /********************************************************************************                                                                                                            
-- Stored Procedure: dbo.ssp_SCListPagePqriMeasureSubmission                                                                                                              
--                                                                                                            
-- Copyright: Streamline Healthcate Solutions                                                                                                            
--                                                                                                            
-- Purpose:  To fecth the data for the list page of PQRI Measure Submissions (ARRA Development)              
--                                                                                                            
-- Updates:                                                                                                                                                                   
-- Date            Author		  Purpose                                                                                                        
-- 15 Dec 2011	   Karan Garg	  To fecth the data for the list page of PQRI Measure Submissions (ARRA Development)
-- 9 JUN,2016	   Ravichandra	  Removed the physical table  ListPageSCPQRIMeasureBatches from SP
								  Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
								  108 - Do NOT use list page tables for remaining list pages (refer #107)	 	
*********************************************************************************/             
                                
AS                                      
BEGIN                                  
SET NOCOUNT ON;                        
BEGIN TRY                                   
CREATE TABLE #ResultSet (                                         
   ListPageSCPQRIMeasureBatchId BIGINT,            
   PQRIMeasureBatchId   INT,                                     
   FromDate DATETIME,
   ToDate	DateTIME,
   Provider	varchar(100),
   CreatedDate DATETIME,
   RegistryName VARCHAR(100)
   )           
                
DECLARE @CustomFilters table (RecordReviewId INT)             
                                                              
DECLARE @CustomFiltersApplied CHAR(1)           
        
      
    
 --Get custom filters                                            
if @OtherFilter > 10000                   
begin                      
                      
  set @CustomFiltersApplied = 'Y'                      
                        
  insert into @CustomFilters (RecordReviewId)                                            
  exec scsp_SCListPagePqriMeasureSubmission @LoggedInStaffId = @LoggedInStaffId,                                         
                                            @OtherFilter = @OtherFilter                                       
                                                                    
end          
                                  
                                      
  --Insert data in to temp table which is fetched below by appling filter.                         
INSERT INTO #ResultSet                                       
(                                 
PQRIMeasureBatchId,
FromDate,
ToDate,
Provider,
CreatedDate,
RegistryName              
)                             
                 
SELECT PB.PQRIMeasureBatchId,
		CONVERT(varchar(50),
		PB.FromDate,106),
		CONVERT(varchar(50),
		PB.ToDate,106),  
		ISNULL(S.LastName + ', ' + S.FirstName,'All') as Provider,
		pb.CreatedDate,
		pb.RegistryName 
FROM PQRIMeasureBatches PB LEFT OUTER JOIN Staff S ON s.StaffId = PB.StaffId
 
WHERE ((@staffid = PB.StaffId) OR (@staffId is NULL)) 
	AND (FromDate <= ISNULL(@dateFilter,FromDate) AND PB.ToDate >= ISNULL(@dateFilter,ToDate))
     AND ISNULL(PB.RecordDeleted,'N') = 'N'
     

;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT PQRIMeasureBatchId,
						FromDate,
						ToDate,
						Provider,
						CreatedDate,
						RegistryName        
				,Count(*) OVER () AS TotalCount
				,row_number() over(order by case when @SortExpression= 'FromDate' then  FromDate end,                                                                  
										  case when @SortExpression= 'FromDate desc' then FromDate end desc ,                                                                  
										  case when @SortExpression= 'ToDate' then ToDate end ,                                                                  
										  case when @SortExpression= 'ToDate desc' then ToDate end desc,                                                                  
										  case when @SortExpression= 'Provider' then Provider end,                                                    
										  case when @SortExpression= 'Provider desc' then Provider end desc ,                                              
										  case when @SortExpression= 'CreatedDate' then CreatedDate end,                                                                  
										  case when @SortExpression= 'CreatedDate desc' then CreatedDate end desc,                                                
										  case when @SortExpression= 'RegistryName' then RegistryName end,              
										  case when @SortExpression= 'RegistryName desc' then RegistryName end desc,
										  PQRIMeasureBatchId ) as RowNumber                                                                            
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  PQRIMeasureBatchId,
					FromDate,
					ToDate,
					Provider,
					CreatedDate,
					RegistryName   ,                             
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

		SELECT	PQRIMeasureBatchId,
				FromDate,
				ToDate,
				Provider,
				CreatedDate,
				RegistryName      
		FROM #FinalResultSet
		ORDER BY RowNumber        
     
                              
END TRY                             
BEGIN CATCH                                        
                                      
DECLARE @Error varchar(8000)                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPagePqriMeasureSubmission')                                                                                                                   
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
     
     
 