/****** Object:  StoredProcedure [dbo].[ssp_SCListPageMemberInquiries]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageMemberInquiries]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageMemberInquiries]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageMemberInquiries]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCListPageMemberInquiries]                             
  -- =============================================                                      
  -- Create date:27/09/2013                                     
  -- Description: Return the Client Inquires  List page based on the filter.                               
  -- Author  RK    
  -- =============================================                                                                                             
 @InstanceId int,                                                                  
 @PageNumber int,                                                                      
 @PageSize int,                                                                      
 @SortExpression varchar(100),                          
 @ClientId int,                          
 @RecordedBy INT,                                                  
 @StaffId INT,                              
 @Disposition INT,  
 @InquiryStatus INT,                            
 @FromDate DATETIME,                                  
 @ToDate DATETIME,                                  
 @OtherFilter INT                 
                                                             
AS                                     
  BEGIN                   
    BEGIN try                   
        CREATE TABLE #customfilters                   
          (                   
             InquiryId INT NOT NULL                   
          )                   
                  
        DECLARE @ApplyFilterClicked CHAR(1)                   
        DECLARE @CustomFilterApplied CHAR(1)                   
                  
        SET @SortExpression=Rtrim(Ltrim(@SortExpression))                   
                  
        IF Isnull(@SortExpression, '') = ''                   
          BEGIN                   
              SET @SortExpression='InquiryDateTime DESC'                   
          END                   
                  
        SET @ApplyFilterClicked= 'Y'                   
        SET @CustomFilterApplied= 'N'                   
                  
        IF @OtherFilter > 10000                   
          BEGIN                   
              SET @CustomFilterApplied= 'Y'                   
                  
              INSERT INTO #customfilters                   
                          (InquiryId)                   
              EXEC scsp_ListPageMemberInquiriesList                           
     @OtherFilter =@OtherFilter                   
          END;                   
                  
        WITH listclientInquiries                   
             AS ( SELECT                          
				  CI.InquiryId AS InquiryId,                    
				  CI.InquirerLastName+', '+CI.InquirerFirstName as InquirerName,                    
				  CI.InquiryStartDateTime as InquiryDateTime,                    
				  S.StaffId as RecordedBy,                    
				  S.LastName+', '+S.FirstName as RecordedByName,                            
				  ST.StaffId As AssignedToStaffId,                          
				  ST.LastName+', '+ST.FirstName AS AssignedStaffName,                    
				  GC.GlobalCodeId as Disposition,                          
				  GC.CodeName as DispositionName,                  
				  GC1.GlobalCodeId AS InquiryStatusId,                  
				  GC1.CodeName InquiryStatus                    
				  FROM                          
				  Inquiries CI                          
				  Left Outer Join Staff ST on CI.AssignedToStaffId=ST.StaffId AND ISNULL(ST.RecordDeleted,'N')='N'                    
				  Inner JOIN Staff S on CI.RecordedBy=S.StaffId AND ISNULL(S.RecordDeleted,'N')='N'                  
				  LEFT OUTER JOIN GlobalCodes GC ON GC.GlobalCodeId IN(SELECT CDSTP.Disposition From [CustomDispositions] CDSTP Where CDSTP.InquiryId=CI.InquiryId and ISNULL(CDSTP.RecordDeleted,'N')='N')                  
				   LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId=CI.InquiryStatus AND ISNULL(GC1.RecordDeleted,'N')='N'                  
				  WHERE                     
				  (                    
				  ISNULL(CI.RecordDeleted,'N')='N'                               
				  AND CI.ClientId=@ClientId                    
				  AND ((CI.RecordedBy=@RecordedBy) OR @RecordedBy=0)                    
				  AND ((CI.AssignedToStaffId=@StaffId) OR @StaffId=0)                  
				  AND (@FromDate is null or CI.InquiryStartDateTime >= @FromDate)                    
				  AND (@ToDate is null or CI.InquiryStartDateTime < dateadd(dd, 1, @ToDate))                  
				  AND (GC.GlobalCodeId=@Disposition OR ISNULL(@Disposition, 0) = 0)                                  
				  AND (GC1.GlobalCodeId=@InquiryStatus OR ISNULL(@InquiryStatus, 0) = 0)                         
				  )            ),                   
             counts                   
             AS (SELECT Count(*) AS TotalRows                   
                 FROM   listclientInquiries),                   
             rankresultset                   
             AS (SELECT InquiryId,                    
        InquirerName,                    
       InquiryDateTime,                    
       RecordedBy,                    
       RecordedByName,                            
       AssignedToStaffId,                          
       AssignedStaffName,                    
       Disposition,                          
       DispositionName,                  
       InquiryStatusId,                  
      InquiryStatus ,                   
                        Count(*)                   
                          OVER ( )                                            AS                   
                        TotalCount,                   
                        Rank()                   
                          OVER(                   
ORDER BY CASE WHEN @SortExpression= 'InquirerName' THEN                   
                          InquirerName                   
                          END,                   
                          CASE                   
                          WHEN @SortExpression= 'InquirerName desc' THEN InquirerName                   
                          END                   
                          DESC                   
                          ,                   
                          CASE                   
                          WHEN                   
                          @SortExpression= 'InquiryDateTime' THEN InquiryDateTime END, CASE                   
                          WHEN                   
                       @SortExpression=                   
                          'InquiryDateTime desc' THEN InquiryDateTime END DESC, CASE WHEN                   
                          @SortExpression                   
                          =                   
                          'RecordedByName' THEN RecordedByName END, CASE WHEN                   
                          @SortExpression=                   
                          'RecordedByName DESC' THEN RecordedByName END DESC, CASE                   
                          WHEN                   
                          @SortExpression=                   
                          'AssignedStaffName' THEN AssignedStaffName END, CASE WHEN                   
                          @SortExpression=                   
                          'AssignedStaffName DESC' THEN AssignedStaffName END DESC,                   
                          CASE                   
                          WHEN                   
                          @SortExpression=                   
                          'DispositionName' THEN DispositionName END, CASE WHEN                   
                          @SortExpression=                   
                          'DispositionName DESC' THEN DispositionName END DESC,                   
                          CASE                   
                          WHEN                   
                          @SortExpression                   
                          = 'InquiryStatus' THEN InquiryStatus END, CASE WHEN                   
                        @SortExpression=                   
                          'InquiryStatus DESC' THEN InquiryStatus END DESC                  
                                          
                           ) AS                   
                        RowNumber                   
               FROM   listclientInquiries)                   
        SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows,                   
        0)                   
        FROM counts)                   
        ELSE (@PageSize) END) InquiryId,                    
        InquirerName,                    
       InquiryDateTime,                    
       RecordedBy,                    
       RecordedByName,                            
       AssignedToStaffId,                          
       AssignedStaffName,                    
       Disposition,                          
       DispositionName,                  
       InquiryStatusId,                  
      InquiryStatus ,           
        totalcount,                   
                                rownumber                   
        INTO   #finalresultset                   
        FROM   rankresultset                   
        WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize )                   
                  
        IF (SELECT Isnull(Count(*), 0)                   
            FROM   #finalresultset) < 1                   
          BEGIN                   
              SELECT 0 AS PageNumber,                   
                     0 AS NumberOfPages,                   
                     0 NumberOfRows                   
          END                   
        ELSE                   
          BEGIN                   
              SELECT TOP 1 @PageNumber           AS PageNumber,                   
                           CASE ( totalcount % @PageSize )                   
                             WHEN 0 THEN Isnull(( totalcount / @PageSize ), 0)                   
                             ELSE Isnull(( totalcount / @PageSize ), 0) + 1                   
                           END                   AS NumberOfPages,                   
                           Isnull(totalcount, 0) AS NumberOfRows                   
        FROM   #finalresultset                   
          END                   
                  
        SELECT InquiryId,                    
        InquirerName,                    
       InquiryDateTime,                    
       RecordedBy,                    
       RecordedByName,                            
       AssignedToStaffId,                          
       AssignedStaffName,                    
       Disposition,                          
       DispositionName,                  
       InquiryStatusId,                  
      InquiryStatus         
        FROM   #finalresultset                   
        ORDER  BY rownumber                   
                  
        DROP TABLE #customfilters                   
    END try                   
                  
    BEGIN catch                   
        DECLARE @Error VARCHAR(8000)                   
                  
        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'                   
                    + CONVERT(VARCHAR(4000), Error_message())                   
                    + '*****'                   
                    + Isnull(CONVERT(VARCHAR, Error_procedure()),                   
                    'ssp_SCListPageMemberInquiries' )                   
                    + '*****' + CONVERT(VARCHAR, Error_line())                   
                    + '*****' + CONVERT(VARCHAR, Error_severity())                   
                    + '*****' + CONVERT(VARCHAR, Error_state())                   
                  
        RAISERROR ( @Error,-- Message text.                                               
                    16,-- Severity.                                               
                    1 -- State.    
        );                   
    END catch                   
END 