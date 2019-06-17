 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ListPageSCPeerRecordReview')
	BEGIN
		DROP  Procedure  ssp_ListPageSCPeerRecordReview
	END
GO
    
 SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
   
 CREATE  PROCEDURE [dbo].[ssp_ListPageSCPeerRecordReview]                                        
 @LoggedInStaffId INT,          
 @SessionId VARCHAR(30),                                                                                          
 @InstanceId int,                                                                                          
 @PageNumber int,                                                                                              
 @PageSize int,                                                                                              
 @SortExpression VARCHAR(100),                                            
 @RecordReviewTemplateId   int,                                           
 @ReviewedByStaffId   int,                                              
 @ClinicianReviewedId   int,                                                 
 @Status int,                                              
 @AssignedDateFrom  DateTime,                                                  
 @AssignedDateTo  DateTime,                                                  
 @OtherFilter int               
           
 /********************************************************************************                                                                                                              
-- Stored Procedure: dbo.ssp_ListPageSCPeerRecordReview                                                                                                                
--                                                                                                              
-- Copyright: Streamline Healthcate Solutions                                                                                                              
--                                                                                                              
-- Purpose:  To get the Record Review List Data                 
--                                                                                                              
-- Updates:                                                                                                                                                                     
-- Date				 Author			Purpose                                                                                                          
      
-- Oct 05,2011		Karan Garg		Created   
-- july10,2012		Rohitk			Task #19(Threshold 3.5x Merged Issues),Record Reviews: Required space in client LastName, Firstname
-- Mar 19,2014		Revathi         What:Removed the CustomListPageSCRecordReviews and implemented temporary  and change custom tables                            
									why: Task #22 of Customization Bugs 
-- April 13,2017	Kishore			What: Modified the Condition  of (AssignedDateFrom and AssignedDateTo)  
									Why:Task #559 - SC: 4.0 x: Peer Record Review: Export button does not function.									
*********************************************************************************/               
AS
  BEGIN
      SET Nocount ON;

      BEGIN Try
      
        DECLARE @CustomFiltersApplied CHAR(1) 
        SET @CustomFiltersApplied = 'N' 
          CREATE TABLE #ListPagePeerRecordReview
            (
               RecordReviewId    INT,
               ReviewedBy        VARCHAR(100),
               ClinicianReviewed VARCHAR(100),
               Status            VARCHAR(50),
               AssignedDate      DATETIME,
               CompletedDate     DATETIME,
               Results           VARCHAR(250),
               ClientName        VARCHAR(100),
               TemplateName      VARCHAR(250),
               ClientId          INT
            )

          CREATE TABLE #CustomFilters
            (
               RecordReviewId INT NULL
            )

          IF @OtherFilter > 10000
            BEGIN
                SET @CustomFiltersApplied = 'Y'
               INSERT INTO #CustomFilters (RecordReviewId) 
                EXEC scsp_ListPageSCPeerRecordReview
                  @LoggedInStaffId,
                  @RecordReviewTemplateId,
                  @ReviewedByStaffId,
                  @ClinicianReviewedId,
                  @Status,
                  @AssignedDateFrom,
                  @AssignedDateTo,
                  @OtherFilter
            END

          INSERT INTO #ListPagePeerRecordReview
                      (RecordReviewId,
                       ReviewedBy,
                       ClinicianReviewed,
                       Status,
                       AssignedDate,
                       CompletedDate,
                       Results,
                       ClientName,
                       TemplateName,
                       ClientId)
          SELECT Rr.RecordReviewId,
                 Dbo.GetStaffMember(Rr.Reviewingstaff)    AS ReviewedBy,
                 Dbo.GetStaffMember(Rr.Clinicianreviewed) AS ClinicianReviewed,
                 Isnull(Gc.CodeName, '')                  AS Status,               
                 Rr.AssignedDate,
                 Rr.CompletedDate,
                 Rr.Results,
                 C.FirstName + ', ' + C.LastName + '('+ CONVERT(VARCHAR(10), C.ClientId) + ')' AS ClientName,
                 Rrt.RecordReviewTemplateName             AS TemplateName,
                 C.ClientId
          FROM   RecordReviews Rr                
                 LEFT OUTER JOIN Clients C  ON Rr.ClientId = C.ClientId AND Isnull(C.RecordDeleted, 'N') <> 'Y'
                 LEFT OUTER JOIN RecordReviewTemplates Rrt ON Rr.RecordReviewTemplateId =Rrt.RecordReviewTemplateId   AND Isnull(Rrt.RecordDeleted, 'N') <> 'Y'              
                 LEFT OUTER JOIN GlobalCodes Gc ON Gc.GlobalCodeId = Rr.Status				
				WHERE  --  Need to Implement @ReviewTeam Logic AND
				((@CustomFiltersApplied = 'Y' and exists(SELECT * FROM #CustomFilters cf WHERE cf.RecordReviewId = Rr.RecordReviewId))
				OR (@CustomFiltersApplied = 'N'))
				AND(( Rr.ReviewingStaff = @ReviewedByStaffId )
				OR Isnull(@ReviewedByStaffId, 0) = 0 )
				AND ( ( Rr.ClinicianReviewed = @ClinicianReviewedId )
				OR Isnull(@ClinicianReviewedId, 0) = 0 )
				AND ( ( Rr.Status = @Status )OR ( @Status = 0 ) )
				AND (( ISNULL(@AssignedDateFrom,'') <> ''  
				AND ( Rr.AssignedDate >= @AssignedDateFrom ) ) 
				
				--April 13,2017	Kishore--
				OR (Isnull(@AssignedDateFrom, '') = '') )  
				AND (( Rr.AssignedDate < Dateadd(Dd, 1, @AssignedDateTo) )
				OR (Isnull(@AssignedDateTo, '') = '' ) )
				
				--April 13,2017	Kishore--
				AND Isnull(Rr.RecordDeleted, 'N') <> 'Y'
				AND ( ( Rrt.RecordReviewTemplateId = @RecordReviewTemplateId )
                OR Isnull(@RecordReviewTemplateId, 0) = 0 )

          ;WITH Counts
               AS (SELECT Count(*) AS TotalRows
                   FROM   #ListPagePeerRecordReview),
               RankResultSet
               AS (SELECT RecordReviewId,
						  ReviewedBy,
                          ClinicianReviewed,
                          Status,
                          AssignedDate,
                          CompletedDate,
                          Results,
                          ClientName,
                          TemplateName,
                          ClientId,
                          Count(*) OVER () AS TotalCount,
                          Rank()OVER(ORDER BY CASE WHEN @SortExpression= 'TemplateName' THEN TemplateName END,
                                              CASE WHEN @SortExpression= 'TemplateName desc' THEN TemplateName END DESC,
											  CASE WHEN @SortExpression= 'ReviewedBy' THEN ReviewedBy END,
											  CASE WHEN @SortExpression= 'ReviewedBy desc' THEN ReviewedBy END DESC,
											  CASE WHEN @SortExpression= 'ClinicianReviewed' THEN ClinicianReviewed END,
                                              CASE WHEN @SortExpression= 'ClinicianReviewed desc' THEN ClinicianReviewed END DESC,                           
                                              CASE WHEN @SortExpression= 'Status' THEN Status END,
											  CASE WHEN @SortExpression= 'Status desc' THEN Status END DESC, 
											  CASE WHEN @SortExpression= 'AssignedDate' THEN AssignedDate END, 
											  CASE WHEN @SortExpression= 'AssignedDate desc' THEN AssignedDate END DESC, 
											  CASE WHEN @SortExpression= 'CompletedDate' THEN CompletedDate END,
											  CASE WHEN @SortExpression= 'CompletedDate desc' THEN CompletedDate END DESC,
											  CASE WHEN @SortExpression= 'Results' THEN Results END, 
											  CASE WHEN @SortExpression= 'Results desc' THEN Results END DESC, 
											  CASE WHEN @SortExpression= 'ClientName' THEN ClientName END,
											  CASE WHEN @SortExpression= 'ClientName desc' THEN ClientName END DESC,
											  RecordReviewId
                            ) AS RowNumber
							
					FROM   #ListPagePeerRecordReview)
          SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(TotalRows,0) FROM Counts)
          ELSE (@PageSize) END) RecordReviewId,
                                ReviewedBy,
                                ClinicianReviewed,
                                Status,
                                AssignedDate,
                                CompletedDate,
                                Results,
                                ClientName,
                                TemplateName,
                                ClientId,
                                TotalCount,
                                RowNumber
          INTO   #FinalResultSet
          FROM   RankResultSet
          WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize )

          IF (SELECT Isnull(Count(*), 0)
              FROM   #FinalResultSet) < 1
            BEGIN
                SELECT 0 AS PageNumber,
                       0 AS NumberOfPages,
                       0 NumberofRows
            END
          ELSE
            BEGIN
                SELECT TOP 1 @PageNumber           AS PageNumber,
                             CASE ( Totalcount % @PageSize )
                               WHEN 0 THEN Isnull(( Totalcount / @PageSize ), 0)
                               ELSE Isnull((Totalcount / @PageSize), 0) + 1
                             END                   AS NumberOfPages,
                             Isnull(Totalcount, 0) AS NumberofRows
                FROM   #FinalResultSet
            END

          SELECT RecordReviewId,
                 ReviewedBy,
                 ClinicianReviewed,
                 Status,
                 AssignedDate,
                 CompletedDate,
                 Results,
                 ClientName,
                 TemplateName,
                 ClientId
          FROM   #FinalResultSet
          ORDER  BY RowNumber
      END Try

      BEGIN Catch
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_ListPageSCPeerRecordReview')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END Catch
  END 