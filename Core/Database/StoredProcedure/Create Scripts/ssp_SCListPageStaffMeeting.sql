IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_SCListPageStaffMeeting]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCListPageStaffMeeting] 

GO 
               
CREATE procedure [dbo].[ssp_SCListPageStaffMeeting]  
@SessionId varchar(30),                                                        
@InstanceId int,                                                        
@PageNumber int,                                                            
@PageSize int,                                                            
@SortExpression varchar(100),                                                          
@MeetingTypeFilter INT,                
@MeetingStatusFilter CHAR(1),                
@FaciltatorsFilter INT,                
@AttendeesFilter INT,                
@MeetingDateFromFilter DATETIME,                
@MeetingDateToFilter DATETIME,                
@LoggedInStaffId INT,                  
@StaffId INT,                                                        
@OtherFilter INT                                                                        
                                 
/********************************************************************************                                                                
-- Stored Procedure: dbo.ssp_SCListPageStaffMeeting                                                                 
--                                                                
-- Copyright: Streamline Healthcate Solutions                                                                
--                                                                
-- Purpose: used by Report list page                                                                
--                                                                
-- Updates:                                                                                                                       
-- Date               Author                Purpose                                                                           
/*  19/Jun/2017       Anto                  Created a ssp to make it as a core sp - Core Bugs #2387 */                                                           
*********************************************************************************/                                                                
AS                            
BEGIN    
  BEGIN TRY    
  IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageStaffMeeting]')
					AND type IN ( N'P', N'PC' ) ) 
   BEGIN					
		EXEC scsp_SCListPageStaffMeeting @SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,
		                                 @MeetingTypeFilter,@MeetingStatusFilter,@FaciltatorsFilter,
										 @AttendeesFilter,@MeetingDateFromFilter,@MeetingDateToFilter,
										 @LoggedInStaffId,@StaffId,@OtherFilter
   END
   
   ELSE
   BEGIN       
      CREATE TABLE #ResultSet(          
						RowNumber    INT,                                                        
						PageNumber    INT,                                                                                                   
						MeetingType    VARCHAR(100),                           
						MeetingDateTime   DATETIME,                                                        
						FacilitatorName   VARCHAR(100),                                                        
						Status     VARCHAR(50),                  
						Location    VARCHAR(100),                  
						StaffMeetingId  INT
						)                  
                                                                                                
                                                        
                    
INSERT INTO #ResultSet (            
 MeetingType,                           
 MeetingDateTime,                                                        
 FacilitatorName,                               
 Status,                  
 Location,                  
 StaffMeetingId)          
SELECT DISTINCT                     
 GC.CodeName AS [MeetingType],                
 CSM.StartDateTime,              
 COALESCE(S.LastName,'') + ', ' + COALESCE(S.FirstName,'') as [FacilitatorName],                
 CASE CSM.Status         
 WHEN 'S' THEN 'Scheduled'        
 WHEN 'I' THEN 'In Progress'        
 WHEN 'C' THEN 'Complete'        
 WHEN 'A' THEN 'Cancelled'        
 ELSE ''        
 END AS [Status],        
 LC.LocationName,                
 CSM.StaffMeetingId                   
 FROM            CustomStaffMeetings AS CSM      
 LEFT JOIN CustomStaffMeetingAttendees AS SCMA ON SCMA.StaffMeetingId=CSM.StaffMeetingId                      
    LEFT JOIN  Locations AS LC ON CSM.LocationId = LC.LocationId                 
    LEFT JOIN  GlobalCodes AS GC ON CSM.MeetingType = GC.GlobalCodeId                
    LEFT JOIN  Staff AS S ON CSM.FacilitatorId = S.StaffId                      
 WHERE ISNULL(CSM.RecordDeleted, 'N') = 'N'                
   AND (CSM.MeetingType = @MeetingTypeFilter OR ISNULL(@MeetingTypeFilter, 0) = 0)                 
   AND (CSM.Status=@MeetingStatusFilter OR ISNULL(@MeetingStatusFilter, '0') = '0')   --ISNULL(@MeetingStatusFilter,'0')='0')                   
   AND (CSM.FacilitatorId=@FaciltatorsFilter OR ISNULL(@FaciltatorsFilter,0)=0)                
   --AND (CSM.LocationId=@FaciltatorsFilter OR ISNULL(@FaciltatorsFilter,0)=0)               
   AND (@MeetingDateFromFilter is null or CSM.StartDateTime >= @MeetingDateFromFilter)                                                                                   
   AND (@MeetingDateToFilter is null or CSM.StartDateTime <dateadd(dd, 1, @MeetingDateToFilter))  AND (SCMA.StaffId=@AttendeesFilter OR @AttendeesFilter=0)                                  
                                              
                                                               


 ;  WITH Counts    
  AS (    
   SELECT count(*) AS totalrows    
   FROM #ResultSET    
   )    
   ,RankResultSet    
  AS (    
   SELECT MeetingType,                           
 MeetingDateTime,                                                        
 FacilitatorName,                               
 Status,                  
 Location,                  
 StaffMeetingId
    ,COUNT(*) OVER () AS TotalCount    
    ,RANK() OVER (    
     ORDER BY CASE WHEN @SortExpression= 'MeetingType' THEN MeetingType END,                                                            
                                            CASE WHEN @SortExpression= 'MeetingDateTime DESC' THEN MeetingDateTime END DESC,                     
                                            CASE WHEN @SortExpression= 'FacilitatorName DESC' THEN FacilitatorName END,                                         
                                            CASE WHEN @SortExpression= 'Status DESC' THEN [Status] END DESC,                                                        
                                            CASE WHEN @SortExpression= 'Location DESC' THEN Location END,              
                                            CASE WHEN @SortExpression= 'StaffMeetingId desc' THEN StaffMeetingId END,                                                    
   StaffMeetingId ) AS RowNumber    
   FROM #ResultSet    
     
   )    
  SELECT TOP (    
    CASE     
     WHEN (@PageNumber = - 1)    
      THEN (    
        SELECT ISNULL(totalrows, 0)    
        FROM counts    
        )    
     ELSE (@PageSize)    
     END    
    ) MeetingType,                           
 MeetingDateTime,                                                        
 FacilitatorName,                               
 Status,                  
 Location,                  
 StaffMeetingId
   ,RowNumber    
   ,TotalCount    
  INTO #FinalResultSet    
  FROM RankResultSet    
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)    
    
  IF (    
    SELECT ISNULL(COUNT(*), 0)    
    FROM #FinalResultSet    
   ) < 1    
  BEGIN    
   SELECT 0 AS PageNumber    
    ,0 AS NumberOfPages    
    ,0 NumberOfRows    
  END    
  ELSE    
  BEGIN    
   SELECT TOP 1 @PageNumber AS PageNumber    
    ,CASE (TotalCount % @PageSize)    
     WHEN 0    
      THEN ISNULL((TotalCount / @PageSize), 0)    
     ELSE ISNULL((TotalCount / @PageSize), 0) + 1    
     END AS NumberOfPages    
    ,ISNULL(TotalCount, 0) AS NumberOfRows    
   FROM #FinalResultSet    
  END    
    
  SELECT MeetingType,                           
 MeetingDateTime,                                                        
 FacilitatorName,                               
 Status,                  
 Location,                  
 StaffMeetingId
  FROM #FinalResultSet    
  ORDER BY RowNumber      
        
   END                  
 END TRY                                                                                                                                       
                                                                                                                                              
 BEGIN CATCH                                                                                                                                                                                                                                        
   DECLARE @Error varchar(8000)                                                                                                                                                      
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                  
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageStaffMeeting')                                                                                          
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                                       
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                     
 END CATCH              
               
 End 