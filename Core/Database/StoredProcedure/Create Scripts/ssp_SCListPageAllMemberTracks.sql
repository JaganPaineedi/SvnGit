IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageAllMemberTracks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageAllMemberTracks]
GO

/*********************************************************************/                                                                        
 /* Stored Procedure: [ssp_SCListPageAllMemberTracks]      */                                                               
 /* Creation Date:  26/August/2011               */                                                                        
 /* Purpose: To Get The Data on List Page of Tracks Screen */                                                                      
 /* Input Parameters: @SessionId ,@InstanceId,@PageNumber,@PageSize,@SortExpression ,@OtherFilter                  */                                                                      
 /* Output Parameters:   Returns The Two Table, One have the page Information and second table Contain the List Page Data  */                                                                        
 /* Called By: Client Tab for Member List Page(Threshold)              */                                                              
 /* Data Modifications:              */                                                                        
 /*   Updates:                */                                                                        
 /*   Date     Author           */                                                                        
 /*   26/August/2011       Minakshi Varma         */   
 /*	  08/05/2012		   Vikas Kashyap          Changes w.e.f. Task#801*/   
 /*   19/06/2012		   Rohit Katoch           Changes w.e.f. Task#1235 in THRESHOLD BUGS & FEATURES*/     
 /*   11/07/2016		   Ravichandra			  Removed the physical table ListPageSCAllClientTracks from SP */
 /*										          Why:Task #108, Engineering Improvement Initiatives- NBL(I)	*/
 /*										          108 - Do NOT use list page tables for remaining list pages (refer #107)	 */                                                               
 /*********************************************************************/     
create PROCEDURE [dbo].[ssp_SCListPageAllMemberTracks]
-- Add the parameters for the stored procedure here  
 @SessionId varchar(30),                                          
 @InstanceId int,                                          
 @PageNumber int,                                              
 @PageSize int,                                              
 @SortExpression varchar(100),  
 @TrackTypeId int,  
 @TrackId INT,                          
 @Status INT,      
 @StaffId INT,      
 @FromDate DATETIME,          
 @ToDate DATETIME,          
 @OtherFilter INT    
  
AS  
BEGIN  
BEGIN TRY
CREATE Table #ResultSet (  
	ClientTrackId int,
	ClientId int,
	ClientName varchar(250),  
	TrackType varchar(250),  
	TrackId int,  
	AssignedToStaffId int,    
	RequestedDate DATETIME,                      
	EnrolledDate DATETIME,      
	DischargedDate DATETIME,      
	ClientTrackStatus VARCHAR(100),  
	TrackName Varchar(100),      
	AssignedStaff VARCHAR(250),  
	Status Varchar(250)   
	) 
	
	DECLARE @CustomFilters table (ClientTrackId INT)	        
    IF ISNULL(@SortExpression,'')=''            
    BEGIN            
    Set @SortExpression='ClientName'            
    END   
		
		INSERT INTO #ResultSet  
		(  
			ClientTrackId,
			ClientId,
			ClientName,  
			TrackType,  
			TrackId,  
			AssignedToStaffId,  
			RequestedDate,  
			EnrolledDate,  
			DischargedDate,  
			ClientTrackStatus,  
			TrackName,  
			AssignedStaff,  
			Status  
		)  
		SELECT  
			CT.ClientTrackId AS ClientTrackId,
			C.ClientId as ClientId,
			C.LastName+','+C.FirstName As ClientName,  
			GTT.CodeName As TrackType,  
			T.TrackId As TrackId,  
			ST.StaffId As AssignedToStaffId,  
			CT.RequestedDate AS RequestedDate,  
			CT.EnrolledDate AS EnrolledDate,  
			CT.DischargedDate As DischargedDate,  
			CT.Status As ClientTrackStatus,  
			T.TrackName As TrackName,  
			ST.LastName+', '+ST.FirstName AS AssignedStaff,  
			GCT.CodeName As Status   
		FROM  
			ClientTracks CT  
			Inner Join Clients C on CT.ClientId=C.ClientId AND ISNULL(CT.RecordDeleted,'N')='N' 
			Left outer JOIN Staff ST on CT.AssignedToStaffId=ST.StaffId AND ISNULL(ST.RecordDeleted,'N')='N'  
			Left outer Join Tracks T on CT.TrackId=T.TrackId AND ISNULL(T.RecordDeleted,'N')='N'   
			LEFT OUTER JOIN GlobalCodes GCT ON CT.Status = GCT.GlobalCodeId  
			LEFT OUTER JOIN GlobalCodes GTT ON T.TrackType = GTT.GlobalCodeId                
		WHERE
		(    
			ISNULL(CT.RecordDeleted,'N')='N'   
			AND ((CT.AssignedToStaffId=@StaffId) or @StaffId=0)  
			AND ((CT.TrackId=@TrackId) or @TrackId=0)
			AND ((T.TrackType= @TrackTypeId) or @TrackTypeId=0)  
			AND ((((CT.Status= @Status) OR @Status=0)  
		  AND (@FromDate is null or cast(convert(varchar(10),CT.EnrolledDate,101)as datetime) >= @FromDate or cast(convert(varchar(10),CT.RequestedDate,101)as datetime) >= @FromDate or cast(convert(varchar(10),CT.DischargedDate,101)as datetime) >= @FromDate)  
		  AND (@ToDate is null or cast(convert(varchar(10),CT.EnrolledDate,101)as datetime) < dateadd(dd, 1, @ToDate) or cast(convert(varchar(10),CT.RequestedDate,101)as datetime) < dateadd(dd, 1, @ToDate) or cast(convert(varchar(10),CT.DischargedDate,101)as datetime) < dateadd(dd, 1, @ToDate))  
		  )
		  OR ((CT.Status= @Status)  
		  AND (@FromDate is null or cast(convert(varchar(10),CT.RequestedDate,101)as datetime) >= @FromDate)  
		  AND (@ToDate is null or cast(convert(varchar(10),CT.RequestedDate,101)as datetime) < dateadd(dd, 1, @ToDate))  
		  )
		  OR ((CT.Status= @Status)  
		  AND (@FromDate is null or cast(convert(varchar(10),CT.EnrolledDate,101)as datetime) >= @FromDate)  
		  AND (@ToDate is null or cast(convert(varchar(10),CT.EnrolledDate,101)as datetime) < dateadd(dd, 1, @ToDate))  
		  )
		  OR ((CT.Status= @Status)  
		  AND (@FromDate is null or cast(convert(varchar(10),CT.DischargedDate,101)as datetime) >= @FromDate)  
		  AND (@ToDate is null or cast(convert(varchar(10),CT.DischargedDate,101)as datetime) < dateadd(dd, 1, @ToDate))  
		  ))
		)
		order by EnrolledDate desc   
		
	
    
	--Get custom filters                                        
	IF @OtherFilter > 10000                       
	BEGIN                                   
	INSERT INTO @CustomFilters (ClientTrackId)                                        
	EXEC scsp_ListPageAllTracks @OtherFilter = @OtherFilter                                   
	END
			
		;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
				AS (SELECT ClientTrackId,
				ClientId,
				ClientName,  
				TrackType,  
				TrackId,  
				AssignedToStaffId,  
				RequestedDate,  
				EnrolledDate,  
				DischargedDate,  
				ClientTrackStatus,  
				TrackName,  
				AssignedStaff,  
				Status  
					,Count(*) OVER () AS TotalCount
					,row_number() over(order by
										case when @SortExpression= 'ClientId' then ClientId end ,	--Added by By Rohit Katoch sorting by as ClientId							                                                            
										case when @SortExpression= 'ClientId desc' then ClientId end desc,--Added by By Rohit Katoch sorting by as ClientId	
										case when @SortExpression= 'ClientName' then ClientName end ,		--changes made By Rohit Katoch replace TrackName as ClientName								                                                            
										case when @SortExpression= 'ClientName desc' then ClientName end desc,  --changes made By Rohit Katoch replace TrackName as ClientName                                                          
										case when @SortExpression= 'TrackName' then TrackName end ,                                                            
										case when @SortExpression= 'TrackName desc' then TrackName end desc,                                                            
										case when @SortExpression= 'Status' then ClientTrackStatus end,                                                            
										case when @SortExpression= 'Status desc' then ClientTrackStatus end desc,                                          
										case when @SortExpression= 'RequestedDate' then RequestedDate end,        
										case when @SortExpression= 'RequestedDate desc' then RequestedDate end desc,  
										case when @SortExpression= 'EnrolledDate' then EnrolledDate end,        
										case when @SortExpression= 'EnrolledDate desc' then EnrolledDate end desc,                                                               
										case when @SortExpression= 'DischargedDate' then DischargedDate end,        
										case when @SortExpression= 'DischargedDate desc' then DischargedDate end desc,                                                               
										case when @SortExpression= 'AssignedStaff' then AssignedStaff end,        
										case when @SortExpression= 'AssignedStaff desc' then AssignedStaff end desc,
										--case when @SortExpression= 'ClientName,EnrolledDate desc' then ClientName end desc,
										EnrolledDate desc,ClientTrackId) as RowNumber          
							FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
			)	ClientTrackId,
				ClientId,
				ClientName,  
				TrackType,  
				TrackId,  
				AssignedToStaffId,  
				RequestedDate,  
				EnrolledDate,  
				DischargedDate,  
				ClientTrackStatus,  
				TrackName,  
				AssignedStaff,  
				Status  
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

			SELECT ClientTrackId,
					ClientId,
					ClientName,
					TrackId,  
					TrackName,      
					TrackType,
					ClientTrackStatus,   
					Status,   
					RequestedDate,  
					EnrolledDate as EnrolledDate,  
					DischargedDate as DischargedDate, 
					AssignedToStaffId, 
					AssignedStaff 
	
		FROM #FinalResultSet
		ORDER BY RowNumber	
                            
END TRY

BEGIN CATCH
	DECLARE @Error varchar(8000)                                               
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageAllMemberTracks')                                                                             
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


