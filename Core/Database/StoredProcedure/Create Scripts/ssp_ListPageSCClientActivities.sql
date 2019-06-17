/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientActivities]    Script Date: 02/13/2012 12:17:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCClientActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCClientActivities]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCClientActivities]    Script Date: 02/13/2012 12:17:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ssp_ListPageSCClientActivities]                                                                           
@SessionId VARCHAR(30),
@InstanceId INT,
@PageNumber INT,
@PageSize INT,
@SortExpression VARCHAR(100), 
@ActivityType INT, 
@ProgramId INT, 
@OtherFilter INT, 
@FromDate DATETIME,
@ToDate DATETIME,
@LoggedInStaffId INT,
@ClientId INT
/*********************************************************************************/          
/* Stored Procedure: ssp_ListPageSCClientActivities								 */ 
/* Copyright: Streamline Healthcare Solutions									 */          
/* Creation Date:  13-Feb-2012													 */          
/* Purpose: used by Client Activity List Page									 */         
/* Input Parameters:															 */        
/* Output Parameters:SessionId,InstanceId,PageNumber,PageSize,SortExpression,	 */
/* FromDate,ToDate,ActivityDate,ClientId,ProgramId								 */        
/* Return:																	     */          
/* Called By: Activity.cs , GetActivityListPageData()							 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date              Author                  Purpose							 */          
/* 13-Feb-2012       Vikas Kashyap			 Created							 */ 
/* 16-JUN-2016		 Ravichandra			 Removed the physical table  ListPageSCClientActivities from SP
										     Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
										     108 - Do NOT use list page tables for remaining list pages (refer #107)	*/ 	         
/*********************************************************************************/     
AS                                                        
BEGIN              
BEGIN TRY     
        SET NOCOUNT ON;                                                 
	CREATE TABLE #ResultSet(                                                                                                                             
	ClientActivityId	INT,
	ToDate				DATETIME,
	FromDate			DATETIME,
	ActivityDate		VARCHAR(100),
	ClientId			INT,
	ProgramId			INT,
	ActivityType		VARCHAR(100),
	ActivitySummary		VARCHAR(MAX)  
	)   
	                                                               
	                                
	DECLARE @CustomFilters TABLE (ClientActivities INT)                                                                       
	                                                           
  
	 IF @OtherFilter > 10000                           
	 BEGIN                                                 
	 EXEC scsp_ListPageSCClientActivities @OtherFilter = @OtherFilter                                 
	 END                                                                                                                     
                                              
	INSERT INTO #ResultSet(                                                                  
	ClientActivityId,
	ToDate,
	FromDate,
	ActivityDate,
	ClientId,
	ProgramId,
	ActivityType,
	ActivitySummary	     
	)                                                                 
	SELECT
			CA.ClientActivityId,
			@ToDate,
			@FromDate,
			CONVERT(VARCHAR(10),CA.ActivityDate,101) + ' '
			+ ISNULL(SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 13, 2) + ':'
			+ SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 16, 2) + ' '
			+ SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 18, 2) ,'')+' '+ 
			CASE WHEN ISNULL(CAST(DATEDIFF(mi,CA.ActivityStartTime,CA.ActivityEndTime) AS INT),0) <> 0 THEN
			'('+CONVERT(VARCHAR,DATEDIFF(mi,CA.ActivityStartTime,CA.ActivityEndTime))+' Min)' ELSE '' 
			END AS ActivityDate,
			CA.ClientId,
			@ProgramId,     
			dbo.csf_GetGlobalCodeNameById(CA.ActivityType) as ActivityType,
			CA.ActivitySummary
	FROM   
	ClientActivities AS CA
	LEFT JOIN Clients AS C ON C.ClientId=CA.ClientId    
	WHERE
	ISNULL(CA.RecordDeleted,'N') = 'N' 
	AND ISNULL(C.RecordDeleted,'N') = 'N'
	AND (CA.ActivityType = @ActivityType OR ISNULL(@ActivityType, 0) = 0)
	AND (@FromDate is null or cast(CA.ActivityDate as datetime) >= @FromDate)                                                                                   
    AND (@ToDate is null or cast(CA.ActivityDate as datetime) < dateadd(dd, 1, @ToDate))
    AND CA.ClientId=@ClientId
  
 
 ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientActivityId,
						ToDate,
						FromDate,
						ActivityDate,
						ClientId,
						ProgramId,
						ActivityType,
						ActivitySummary	  
					,Count(*) OVER () AS TotalCount
					,row_number() over (ORDER BY 
												CASE WHEN @SortExpression= 'ActivityDate'			THEN  
												CASE WHEN CAST(Substring(ActivityDate,0,charindex('(',ActivityDate)) AS DATETIME)>CONVERT(DATETIME,'01-01-1900') THEN
												CONVERT(DATETIME,Substring(ActivityDate,0,charindex('(',ActivityDate))) ELSE CONVERT(DATETIME,ActivityDate)
												END  
												END,                                                            
												CASE WHEN @SortExpression= 'ActivityDate desc'		THEN  
												CASE WHEN CAST(Substring(ActivityDate,0,charindex('(',ActivityDate)) AS DATETIME)>CONVERT(DATETIME,'01-01-1900') THEN
												    		CONVERT(DATETIME,Substring(ActivityDate,0,charindex('(',ActivityDate))) ELSE CONVERT(DATETIME,ActivityDate)
															END 
															END DESC, 
												--CASE WHEN @SortExpression= 'ClientName'				THEN ClientId END,                                                            
												--CASE WHEN @SortExpression= 'ClientName desc'			THEN ClientId END DESC,                                                               
												CASE WHEN @SortExpression= 'ActivityType'			THEN ActivityType END,                                                                      
												CASE WHEN @SortExpression= 'ActivityType desc'		THEN ActivityType END DESC,     
												CASE WHEN @SortExpression= 'ActivitySummary'		THEN ActivitySummary END,                                                            
												CASE WHEN @SortExpression= 'ActivitySummary desc'	THEN ActivitySummary END DESC ,                                                                                                                    
												ClientActivityId) as RowNumber     
							FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				) ClientActivityId,
				ToDate,
				FromDate,
				ActivityDate,
				ClientId,
				ProgramId,
				ActivityType,
				ActivitySummary	 
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

		SELECT ClientActivityId,
				ToDate,
				FromDate,
				ActivityDate,
				ClientId,
				ProgramId,
				ActivityType,
				ActivitySummary 
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY  
                                                                                        
BEGIN CATCH              
 DECLARE @Error varchar(8000)                                                             
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCClientActivities')                                                                                           
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
GO


