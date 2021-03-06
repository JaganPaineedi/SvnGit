/****** Object:  StoredProcedure [dbo].[csp_ListPageSCInquiries]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ListPageSCInquiries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ListPageSCInquiries]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ListPageSCInquiries]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

create procedure [dbo].[csp_ListPageSCInquiries]           
(            
 @SessionId varchar(30),            
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
 @OtherFilter int            
)            
/********************************************************************************                                                 
** Stored Procedure: csp_ListPageSCInquiries                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                  
**                                                  
** Purpose: used by Inquiry list page                                                  
**             
** Author:Pradeep            
**    
**Called By:GetInquriesList from CustomListPageInquiries     
**     
**Created Date:7 Sept 2011                                                 
** Updates:                                                                                                         
** Date            Author              Purpose                                                  
** 21/Jun/2012     Rohit Katoch        ref:task#1275 in Threshold Bugs and Features  
** 25/Jun/2012     Rohit Katoch        ref:task#1275 in Threshold Bugs and Features  
** 31/July/2012    Rohit Katoch        ref:task#1275 in Threshold Bugs and Features     
*********************************************************************************/            
AS            
BEGIN            
  BEGIN TRY            
  CREATE TABLE #ResultSet            
 (            
  RowNumber        int,                                    
  PageNumber       int,            
  InquiryId INT,            
  MemberName varchar(55) NULL,            
  MemberId int null,            
  InquirerName varchar(55) NULL,            
  InQuiryDateTime DateTime NULL,            
  RecordedByName varchar(55) NULL,            
  AssignedToName varchar(55) NULL,            
  Disposition varchar(100) NULL            
 )            
 declare @CustomFiltersApplied char(1)           
 DECLARE @ApplyFilterClick AS CHAR(1)           
 Set @SortExpression=RTRIM(LTRIM(@SortExpression))          
 if ISNULL(@SortExpression,'''')=''''          
 BEGIN          
 Set @SortExpression=''MemberName desc''          
 END          
 -- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                      
 IF @PageNumber > 0 AND EXISTS(SELECT * FROM CustomListPageInquiries WHERE SessionId = @SessionId and InstanceId = @InstanceId)                         
 BEGIN                                                                    
   SET @ApplyFilterClick = ''N''                                                                    
   GOTO GetPage                                                                    
 END            
 -- New retrieve - the request came by clicking on the Apply Filter button                     
 SET @ApplyFilterClick = ''Y''                                                                    
 SET @PageNumber = 1           
 DECLARE @CustomFilters table (InquiryId INT)            
 --Get custom filters                                                    
 IF @OtherFilter > 10000            
    BEGIN            
      SET @CustomFiltersApplied = ''Y''                              
      INSERT INTO @CustomFilters (InquiryId)                                                    
      EXEC scsp_ListPageInquiries @OtherFilter = @OtherFilter            
    END            
             
 INSERT INTO #ResultSet            
   (            
    InquiryId,            
    MemberName,            
    MemberId,            
    InquirerName,            
    InQuiryDateTime,            
    RecordedByName,    
    AssignedToName,            
    Disposition            
   )            
   SELECT CI.InquiryId,CI.MemberLastName+'', ''+CI.MemberFirstName,CI.ClientId            
   ,CI.InquirerLastName+'', ''+CI.InquireFirstName,CI.InquiryDateTime,S1.LastName+'', ''+S1.FirstName            
   ,S.LastName+'', ''+S.FirstName,GC.CodeName            
   FROM CustomInquiries CI            
   LEFT JOIN Staff S on CI.AssignedToStaffId=S.StaffId            
   LEFT JOIN Staff S1 on S1.StaffId=CI.RecordedBy            
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=CI.Disposition            
WHERE ISNULL(CI.RecordDeleted,''N'')=''N''            
   AND (CI.AssignedToStaffId=@AssignedToStaffId OR ISNULL(@AssignedToStaffId, 0) = 0)            
   AND (CI.RecordedBy=@RecordedByStaffId OR ISNULL(@RecordedByStaffId, 0) = 0)             
   and (@InquiryFrom is null or cast(convert(varchar(10),CI.InquiryDateTime,101) as datetime) >= @InquiryFrom)            
   and (@InquiryTo is null or cast(convert(varchar(10),CI.InquiryDateTime,101) as datetime) <= @InquiryTo)            
   AND (CI.Disposition=@Dispositions OR ISNULL(@Dispositions, 0) = 0)            
   AND
     (
         CI.InquirerLastName like (substring(@MemberLatName,1,3)+''%'')
     OR  CI.MemberLastName like (substring(@MemberLatName,1,3)+''%'')
   --OR  CI.MemberLastName=soundex(@MemberLatName)  
   --OR  CI.InquirerLastName=soundex(@MemberLatName) 
     OR  SOUNDEX( substring(CI.InquirerLastName,1,LEN(@MemberLatName))) =soundex(@MemberLatName) 
     OR SOUNDEX( substring(CI.MemberLastName,1,LEN(@MemberLatName))) =soundex(@MemberLatName)
     OR   ISNULL(@MemberLatName,'''')=''''  
     )
   AND (
      CI.InquireFirstName like (substring(@MemberFirstName,1,3)+''%'')
   OR CI.MemberFirstName like (substring(@MemberFirstName,1,3)+''%'') 
 --OR CI.MemberFirstName=soundex(@MemberFirstName) 
 --OR CI.InquireFirstName=soundex(@MemberFirstName)
   OR SOUNDEX( substring(CI.InquireFirstName,1,LEN(@MemberFirstName))) =soundex(@MemberFirstName) 
   OR SOUNDEX( substring(CI.MemberFirstName,1,LEN(@MemberFirstName))) =soundex(@MemberFirstName)
   OR ISNULL(@MemberFirstName,'''')='''' 
   )           
          
 -------------------          
 GetPage:          
 IF @ApplyFilterClick = ''N'' AND EXISTS(select * from CustomListPageInquiries where SessionId = @SessionId and InstanceId = @InstanceId and  SortExpression = @SortExpression)                                        
  GOTO Final          
            
   --SET @ApplyFilterClick = ''Y''                                                                                
   SET @PageNumber = 1           
   IF @ApplyFilterClick= ''N''             
     BEGIN          
        INSERT INTO #ResultSet            
   (            
    InquiryId,            
    MemberName,            
    MemberId,            
    InquirerName,            
    InQuiryDateTime,            
    RecordedByName,            
    AssignedToName,            
    Disposition            
   )            
  SELECT             
  InquiryId,            
  MemberName,            
  MemberId,            
  InquirerName,            
  InQuiryDateTime,            
  RecordedByName,            
  AssignedToName,            
  Disposition            
  FROM            
  CustomListPageInquiries            
  WHERE SessionId = @SessionId                                                                          
  AND   InstanceId = @InstanceId           
     END           
     UPDATE d             
         SET RowNumber = rn.RowNumber,                                          
   PageNumber=(rn.RowNumber/@PageSize) +                                           
   CASE WHEN rn.RowNumber % @PageSize = 0             
   THEN 0 ELSE 1 END            
   FROM #ResultSet d            
   JOIN (            
          SELECT InquiryId,            
          row_number() over(            
           order by case when @SortExpression= ''MemberName'' then  MemberName end,            
           case when @SortExpression= ''MemberName desc'' then MemberName end desc ,            
           case when @SortExpression= ''MemberId'' then  MemberId end,            
           case when @SortExpression= ''MemberId desc'' then MemberId end desc ,            
           case when @SortExpression= ''InquirerName'' then  InquirerName end,            
           case when @SortExpression= ''InquirerName desc'' then InquirerName end desc ,            
           case when @SortExpression= ''InQuiryDateTime'' then  InQuiryDateTime end,            
           case when @SortExpression= ''InQuiryDateTime desc'' then InQuiryDateTime end desc ,            
           case when @SortExpression= ''RecordedByName'' then  RecordedByName end,            
       case when @SortExpression= ''RecordedByName desc'' then RecordedByName end desc ,            
           case when @SortExpression= ''AssignedToName'' then  AssignedToName end,            
           case when @SortExpression= ''AssignedToName desc'' then AssignedToName end desc ,            
           case when @SortExpression= ''Disposition'' then  Disposition end,            
           case when @SortExpression= ''Disposition desc'' then Disposition end desc             
           ,InquiryId) as RowNumber                                           
  FROM #ResultSet             
  )rn on rn.InquiryId= d.InquiryId          
            
            
   DELETE FROM              
  CustomListPageInquiries                
  WHERE SessionId = @SessionId                                               
  AND InstanceId = @InstanceId          
              
  INSERT INTO CustomListPageInquiries            
    (            
     SessionId,            
     InstanceId,            
     RowNumber,            
     PageNumber,            
     SortExpression,            
     InquiryId,            
     MemberName,            
     MemberId,            
     InquirerName,            
     InQuiryDateTime,            
     RecordedByName,            
     AssignedToName,            
     Disposition            
    )            
   SELECT             
   @SessionId,                                                                      
   @InstanceId,                                 
                
            
   --Fileds which you have added in the #ResultSet               
   RowNumber ,            
   PageNumber,          
   @SortExpression,            
   InquiryId,            
   MemberName,            
   MemberId,            
   InquirerName,            
      InQuiryDateTime,            
      RecordedByName,            
      AssignedToName,            
      Disposition            
      FROM #ResultSet            
                
  FINAL:          
  SELECT @PageNumber AS PageNumber, ISNULL(MAX(PageNumber), 0) AS NumberOfPages, ISNULL(MAX(RowNumber), 0) AS NumberOfRows            
                                  FROM CustomListPageInquiries                                                  
 WHERE SessionId = @SessionId AND InstanceId = @InstanceId          
           
 SELECT              
  -- Fileds which you have added in the #ResultSet (except RowNumber and PageNumber)            
  InquiryId,            
   MemberName,            
   MemberId,            
   InquirerName,            
      InQuiryDateTime,            
      RecordedByName,            
      AssignedToName,            
      Disposition                                                                       
     FROM             
     CustomListPageInquiries--< TableName which you have created for your list  page>             
     WHERE SessionId = @SessionId                                                                      
     AND InstanceId = @InstanceId                                                                      
  AND PageNumber = @PageNumber                                                                      
     ORDER BY RowNumber            
                  
    --Need to drop the temporary table.            
 Drop Table #ResultSet                    
                    
 END TRY            
 BEGIN CATCH            
  RAISERROR  20006  ''csp_ListPageSCInquiries: An Error Occured''                               
   Return                
 END CATCH            
             
END 
' 
END
GO
