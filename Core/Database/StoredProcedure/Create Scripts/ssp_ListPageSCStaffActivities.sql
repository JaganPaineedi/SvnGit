/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCStaffActivities]    Script Date: 02/13/2012 12:17:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCStaffActivities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCStaffActivities]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCStaffActivities]    Script Date: 02/16/2012 12:17:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ssp_ListPageSCStaffActivities]                                                                           
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
@StaffId INT
/*********************************************************************************/          
/* Stored Procedure: ssp_ListPageSCStaffActivities								 */ 
/* Copyright: Streamline Healthcare Solutions									 */          
/* Creation Date:  13-Feb-2012													 */          
/* Purpose: used by Client Activity List Page For Staff							 */         
/* Input Parameters:															 */        
/* Output Parameters:SessionId,InstanceId,PageNumber,PageSize,SortExpression,	 */
/*					 OtherFilter,ToDate,FromDate,ActivityDate,ClientId,ProgramId */        
/* Return:																	     */          
/* Called By: Activity.cs , GetActivityListPageData()							 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date              Author                  Purpose							 */          
/* 16-Feb-2012       Vikas Kashyap			 Created							 */ 
/* 07.JAN.2014		 Revathi				 what:Added join with staffclients table to display associated clients for login staff */ 	
/*											 why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter */          
/* 30 JUN,2016		 Ravichandra			 Removed the physical table ListPageSCStaffActivities from SP
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
	StaffId				INT,
	ProgramId			INT,
	ActivityType		VARCHAR(100),
	ActivitySummary		VARCHAR(MAX), 
	ClientName			VARCHAR(100) 
	)   
	                                                               
	                                               
	DECLARE @CustomFilters TABLE (ClientActivities INT)                                                                       
	                                                                
                                                          
	INSERT INTO #ResultSet(                                                                  
	ClientActivityId,
	ToDate,
	FromDate,
	ActivityDate,
	ClientId,
	StaffId,
	ProgramId,
	ActivityType,
	ActivitySummary,
	ClientName	     
	)                                                                 
	SELECT
	CA.ClientActivityId,
	@ToDate,
	@FromDate,
	CONVERT(VARCHAR(10),CA.ActivityDate,101) + ' '
	+ ISNULL(SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 13, 2) + ':'
	+ SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 16, 2) + ' '
	+ SUBSTRING(CONVERT(VARCHAR, CA.ActivityStartTime, 100), 18, 2) ,'') +' '+ 
	CASE WHEN ISNULL(CAST(DATEDIFF(mi,CA.ActivityStartTime,CA.ActivityEndTime) AS INT),0) <> 0 THEN
	'('+CONVERT(VARCHAR,DATEDIFF(mi,CA.ActivityStartTime,CA.ActivityEndTime))+' Min)' ELSE '' 
	END AS ActivityDate,
	CA.ClientId,
	@StaffId, 
	@ProgramId,     
	dbo.csf_GetGlobalCodeNameById(CA.ActivityType) as ActivityType,
	CA.ActivitySummary,
	CASE WHEN ISNULL(CA.ClientId,0)<>0 THEN COALESCE(C.LastName,'') + ', ' + COALESCE(C.FirstName,'') ELSE '' END as [MemberName]           
	FROM   
	ClientActivities AS CA
	LEFT JOIN Clients AS C ON C.ClientId=CA.ClientId 
	--Added by Revathi on 07-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)
	Join StaffClients sc on sc.StaffId=@LoggedInStaffId and sc.ClientId=C.ClientId
	WHERE
	ISNULL(CA.RecordDeleted,'N') = 'N' 
	AND ISNULL(C.RecordDeleted,'N') = 'N'
	AND (CA.ActivityType = @ActivityType OR ISNULL(@ActivityType, 0) = 0)
	AND (@FromDate is null or cast(CA.ActivityDate as date) >= cast(@FromDate as date) )                                                                                  
    AND (@ToDate is null or cast(CA.ActivityDate as date) <cast(dateadd(dd, 1, @ToDate) as date))
    AND (C.ClientId IN(
						SELECT DISTINCT CP.ClientId 
						FROM 
						ClientPrograms AS CP
						LEFT JOIN Programs AS P ON (CP.ProgramId=P.ProgramId)
						Where CP.Status in(4,5) AND CP.ProgramId=@ProgramId) OR @ProgramId=0)
						 /* CP.Status 4=Enrolled and 5=Discharged */
                                                                            
                                         
 IF @OtherFilter > 10000                           
 BEGIN                                                      
 EXEC scsp_ListPageSCStaffActivities @OtherFilter = @OtherFilter                                 
 END  
 
;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientActivityId,
						ToDate,
						FromDate,
						ActivityDate,
						ClientId,
						StaffId,
						ProgramId,
						ActivityType,
						ActivitySummary,
						ClientName	 
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
										CASE WHEN @SortExpression= 'ClientName'				THEN ClientName END,                                                            
										CASE WHEN @SortExpression= 'ClientName desc'		THEN ClientName END DESC,                                                               
										CASE WHEN @SortExpression= 'ActivityType'			THEN ActivityType END,                                                                      
										CASE WHEN @SortExpression= 'ActivityType desc'		THEN ActivityType END DESC,     
										CASE WHEN @SortExpression= 'ActivitySummary'		THEN ActivitySummary END,                                                            
										CASE WHEN @SortExpression= 'ActivitySummary desc'	THEN ActivitySummary END DESC  ,                                                                                                                    
										ClientActivityId ) as RowNumber      
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
			StaffId,
			ProgramId,
			ActivityType,
			ActivitySummary,
			ClientName	  
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
				ClientName	,
				StaffId,
				ProgramId,
				ActivityType,
				ActivitySummary		  
		FROM #FinalResultSet
		ORDER BY RowNumber
		
	END TRY  
                           
BEGIN CATCH              
 DECLARE @Error varchar(8000)                                                             
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCStaffActivities')                                                                                           
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


 