/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCInquiries]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCInquiries]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageSCInquiries]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCInquiries]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageSCInquiries]                                       
  -- =============================================                                              
  -- Create date:21/12/2017                                             
  -- Description: Return the Inquires  List page based on the filter.                                       
  -- Author RK                     
  -- =============================================                                                                                                                         
 @InstanceId int,                                                                                                            
 @PageNumber int,                                                                                                                
 @PageSize int,                                                                                                                
 @SortExpression varchar(100),                                    
 @RecordedByStaffId int,                                    
 @AssignedToStaffId int,                                    
 @InquiryFrom DateTime,                                    
 @InquiryTo DateTime,                                    
 @MemberLatName varchar(30),                                    
 @MemberFirstName varchar(20),                                    
 @Dispositions int,                                    
 @InquiryStatus int,                      
 @OtherFilter int
                                                                              
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
              SET @SortExpression='InQuiryDateTime Desc'                             
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
                            
        WITH listInquiries                             
             AS (                                  
      SELECT CI.InquiryId                    
        , case when ltrim(rtrim(isnull(CI.MemberLastName,'')))<>'' AND  ltrim(rtrim(isnull(CI.MemberFirstName,'')))<> '' then                     
       CI.MemberLastName +', ' + CI.MemberFirstName                    
      else                     
       isnull(CI.MemberLastName,'') + isnull(CI.MemberFirstName,'')                    
      end  as MemberName                    
        , CI.ClientId AS MemberID                               
        , case when ltrim(rtrim(isnull(CI.InquirerLastName,'')))<>'' AND ltrim(rtrim(isnull(CI.InquirerFirstName,'')))<>'' then                     
     CI.InquirerLastName +', ' + CI.InquirerFirstName                    
      else                     
       isnull(CI.InquirerLastName,'') + isnull(CI.InquirerFirstName,'')                    
      end  As InquirerName                    
        , CI.InquiryStartDateTime as InQuiryDateTime                
                            
        , case when ltrim(rtrim(isnull(S1.LastName,'')))<>'' AND ltrim(rtrim(isnull(S1.FirstName,'')))<>'' then                     
       S1.LastName + ', ' + S1.FirstName                     
      else         isnull(S1.LastName,'') + isnull(S1.FirstName,'')                    
      end As RecordedByName                      
                          
        , case when ltrim(rtrim(isnull(S.LastName,'')))<>'' AND ltrim(rtrim(isnull(S.FirstName,'')))<>'' then                     
       S.LastName +', ' +S.FirstName                    
      else                     
       isnull(S.LastName,'') + isnull(S.FirstName,'')                    
      end  As AssignedToName                    
                         
        , GC.CodeName as Disposition, GC1.CodeName InquiryStatus                      
        FROM Inquiries CI                                    
        LEFT JOIN Staff S on CI.AssignedToStaffId=S.StaffId                                    
        LEFT JOIN Staff S1 on S1.StaffId=CI.RecordedBy                      
        LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId in (Select CDSTP.Disposition From [InquiryDispositions] CDSTP Where CDSTP.InquiryId=CI.InquiryId and ISNULL(CDSTP.RecordDeleted,'N')='N' )                      
        LEFT JOIN GlobalCodes GC1 ON GC1.GlobalCodeId=CI.InquiryStatus                      
        WHERE ISNULL(CI.RecordDeleted,'N')='N'                      
        AND (CI.AssignedToStaffId=@AssignedToStaffId OR ISNULL(@AssignedToStaffId, 0) = 0)                                    
        AND (CI.RecordedBy=@RecordedByStaffId OR ISNULL(@RecordedByStaffId, 0) = 0)                                     
        and (@InquiryFrom is null or cast(convert(varchar(10),CI.InquiryStartDateTime,101) as datetime) >= @InquiryFrom)                                    
        and (@InquiryTo is null or cast(convert(varchar(10),CI.InquiryStartDateTime,101) as datetime) <= @InquiryTo)                                             
        AND (GC.GlobalCodeId=@Dispositions OR ISNULL(@Dispositions, 0) = 0)                                    
        AND (GC1.GlobalCodeId=@InquiryStatus OR ISNULL(@InquiryStatus, 0) = 0)                     
                           
        ---Updated By Sudhir Singh on date Task#756 in kalamazooBugs                    
       AND ( CI.InquirerLastName like '%' + isnull(@MemberLatName,'') +'%' OR                                    
        CI.MemberLastName like '%' + isnull(@MemberLatName,'') +'%'                    
       )                                     
        AND ( CI.InquirerFirstName like '%' + isnull(@MemberFirstName,'') +'%' OR                                    
      CI.MemberFirstName like '%' + isnull(@MemberFirstName,'') +'%'                     
       )
                                     
        ),                             
             counts                             
             AS (SELECT Count(*) AS TotalRows                             
                 FROM   listInquiries),                             
             rankresultset                             
             AS (SELECT                                                                            
                                         
                                          
        --RowNumber,                                                            
        --PageNumber ,        
        InquiryId ,                                    
        MemberName ,                                    
        MemberId ,                                    
        InquirerName ,                                    
        InQuiryDateTime,                                    
        RecordedByName ,                                    
        AssignedToName ,                                    
        Disposition ,                      
        InquiryStatus,       
                        Count(*)                             
                          OVER ( ) AS                             
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
                          'AssignedToName' THEN AssignedToName END, CASE WHEN                             
                          @SortExpression=                             
                          'AssignedToName DESC' THEN AssignedToName END DESC,                             
                          CASE                             
                          WHEN                             
                          @SortExpression=                             
                          'Disposition' THEN Disposition END, CASE WHEN                             
                          @SortExpression=                             
                          'Disposition DESC' THEN Disposition END DESC,                             
                          CASE                             
                          WHEN                             
                          @SortExpression                             
                          = 'InquiryStatus' THEN InquiryStatus END, CASE WHEN                             
                          @SortExpression=                             
                          'InquiryStatus DESC' THEN InquiryStatus END DESC ,                
                           CASE                             
                          WHEN                             
                          @SortExpression                             
                          = 'MemberName' THEN MemberName END, CASE WHEN                             
                          @SortExpression=                             
                          'MemberName DESC' THEN InquiryStatus END DESC                
       -- CASE                             
                          --WHEN                             
                          --@SortExpression                             
                          --= 'MemberId' THEN MemberId END, CASE WHEN                             
                          --@SortExpression=                             
                   --'MemberId DESC' THEN MemberId END DESC                             
                                                    
                           ) AS                             
                        RowNumber                             
                 FROM   listInquiries)                             
        SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows,                             
        0)                             
        FROM counts)                             
        ELSE (@PageSize) END)                                    
        --RowNumber,                                                            
       -- PageNumber ,                                    
    InquiryId ,                                    
        MemberName ,                                    
        MemberId ,                                    
        InquirerName ,                                    
        InQuiryDateTime,                                    
        RecordedByName ,                                    
        AssignedToName ,                                    
        Disposition ,                      
        InquiryStatus,                
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
                           END           AS NumberOfPages,                             
                           Isnull(totalcount, 0) AS NumberOfRows                             
        FROM   #finalresultset                             
          END                             
                            
        SELECT                                   
      RowNumber,                                                            
      --PageNumber ,                                    
      InquiryId ,                                    
      MemberName ,                                    
      MemberId ,                                    
      InquirerName ,                                    
      InQuiryDateTime,                                    
      RecordedByName ,                                    
      AssignedToName ,                                    
      Disposition ,                      
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
                    + Isnull(CONVERT(VARCHAR, Error_procedure()),                                               'ssp_ListPageSCInquiries' )                             
                    + '*****' + CONVERT(VARCHAR, Error_line())                             
                    + '*****' + CONVERT(VARCHAR, Error_severity())                             
                    + '*****' + CONVERT(VARCHAR, Error_state())                             
                            
        RAISERROR ( @Error,-- Message text.                                                         
       16,-- Severity.                                                         
                    1 -- State.                                                         
        );                             
    END catch                             
END 