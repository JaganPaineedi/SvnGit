IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListRecordReviewTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListRecordReviewTemplate]
GO
 CREATE  PROCEDURE [dbo].[ssp_ListRecordReviewTemplate]                          
 @SessionId varchar(30),                                                                  
 @InstanceId int,                                                                  
 @PageNumber int,                                                                      
 @PageSize int,                                                                      
 @SortExpression varchar(100),                              
 @Status char(1),    
 @LoggedInStaffId int,                      
 @OtherFilter int        
       
 /********************************************************************************                                                                                                            
-- Stored Procedure: dbo.ssp_ListRecordReviewTemplate                                                                                                              
--                                                                                                            
-- Copyright: Streamline Healthcate Solutions                                                                                                            
--                                                                                                            
-- Purpose:  To get the Record Review List Data               
--                                                                                                            
-- Updates:                                                                                                                                                                   
-- Date            Author   Purpose                                                                                                        
-- May 30,2011     Priyanka   Created.            
-- August 04,2011  Karan Garg  Fixed logic for all filters and Changed the Physical table      
-- June 28, 2013   Manju Padmanabhan A Renewed Mind - Bugs Task#4 Delete Error (ARM is moved from Harbor, copying from same from Harbor)     
*********************************************************************************/          
                         
AS                          
BEGIN                      
SET NOCOUNT ON;       
      
CREATE TABLE #ResultSet (          
 ListPageSCRecordReviewTemplateId BIGINT,                         
 RowNumber int,                                                                                      
 PageNumber int,                          
 RecordReviewTemplateId  int,      
 RecordReviewTemplateName varchar(250),      
 Status varchar(50), 
 DeleteAllowed char(1)
   )                                    
       
DECLARE @CustomFilters table (RecordReviewTemplateId INT)             
DECLARE @Today DATETIME                                               
DECLARE @ApplyFilterClicked CHAR(1)                                                                 
DECLARE @CustomFiltersApplied CHAR(1)        
      
--                                                                  
-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                                  
--                                                                  
if @PageNumber > 0 and exists(select * from CustomListPageSCRecordReviewTemplates where SessionId = @SessionId and InstanceId = @InstanceId)                       
begin                                                                  
  set @ApplyFilterClicked = 'N'                                                                  
  goto GetPage                                                                  
end                                                                                                         
            
--                                                
-- New retrieve - the request came by clicking on the Apply Filter button                                                                             
--       
      
                       
set @ApplyFilterClicked = 'Y'                                                                  
set @PageNumber = 1                                                           
set @Today = convert(char(10), getdate(), 101)                           
set @CustomFiltersApplied = 'N'        
      
      
 --Get custom filters                                            
if @OtherFilter > 10000-- OR @Status > 10000                             
begin                      
                      
  set @CustomFiltersApplied = 'Y'                      
                        
  insert into @CustomFilters (RecordReviewTemplateId)                                            
  exec scsp_ListRecordReviewTemplate @LoggedInStaffId = @LoggedInStaffId,                                         
          @Status = @Status,           
                                     @OtherFilter = @OtherFilter                                       
                                               
                      
end        
      
      
  --Insert data in to temp table which is fetched below by appling filter.        
INSERT INTO #ResultSet                           
(                          
RecordReviewTemplateId,                      
RecordReviewTemplateName,      
Status,
DeleteAllowed                                  
)                            
SELECT RecordReviewTemplateId,RecordReviewTemplateName,
CASE WHEN Active = 'Y' THEN 'Active' else 'InActive' end as status  ,
CASE WHEN (select COUNT(*) from CustomRecordReviews where CustomRecordReviews.RecordReviewTemplateId = CustomRecordReviewTemplates.RecordReviewTemplateId AND isnull(CustomRecordReviews.RecordDeleted,'N')='N' ) > 0 THEN 'N' ELSE 'Y' END AS DeleteAllowed
FROM CustomRecordReviewTemplates            
WHERE  (Active = @status)  and IsNull(RecordDeleted,'N')<>'Y'        
                
      
GetPage:                                  
         
  if @ApplyFilterClicked = 'N' and exists(select * from CustomListPageSCRecordReviewTemplates where SessionId = @SessionId and InstanceId = @InstanceId and SortExpression = @SortExpression)                                                            
  goto Final                                                            
                                                            
set @PageNumber = 1                   
                  
if @ApplyFilterClicked = 'N'        
BEGIN      
      
INSERT INTO #ResultSet                           
(         
ListPageSCRecordReviewTemplateId,                       
RecordReviewTemplateId,                      
RecordReviewTemplateName,      
Status ,
DeleteAllowed                                 
)      
SELECT         
 LPRRT.ListPageSCRecordReviewTemplateId,      
 LPRRT.RecordReviewTemplateId,        
 LPRRT.RecordReviewTemplateName,        
 LPRRT.Status,
 LPRRT.DeleteAllowed from CustomListPageSCRecordReviewTemplates LPRRT    
 where SessionId = @SessionId                                      
     and InstanceId = @InstanceId            
END         
      
      
 UPDATE d                                                                                    
   SET RowNumber = rn.RowNumber,                          
    PageNumber=(rn.RowNumber/@PageSize) +                           
   case when rn.RowNumber % @PageSize = 0 then 0 else 1 end                          
   FROM #ResultSet d                                                                                    
   JOIN (                          
      SELECT                          
      RecordReviewTemplateId,                                                      
      row_number() over(                                                      
      order by case when @SortExpression= 'RecordReviewTemplateName' then  RecordReviewTemplateName end,                                                      
      case when @SortExpression= 'RecordReviewTemplateName desc' then RecordReviewTemplateName end desc ,                                                      
      case when @SortExpression= 'Active' then Status end ,                                                      
      case when @SortExpression= 'Active desc' then Status end desc                                                     
                                            
      ) as RowNumber                             
    FROM #ResultSet                                                      
    ) rn on rn.RecordReviewTemplateId= d.RecordReviewTemplateId                           
                                       
   DELETE FROM    CustomListPageSCRecordReviewTemplates                                                       
   WHERE SessionId = @SessionId                                                                                         
   AND InstanceId = @InstanceId         
      
      
      
INSERT INTO dbo.CustomListPageSCRecordReviewTemplates                                                    
    (                                                                                                                
      SessionId,                                                          
      InstanceId,                                                                                             
      RowNumber ,                                                      
      PageNumber,                      
      SortExpression,                                                    
      RecordReviewTemplateName,               
      [Status],
      DeleteAllowed,             
      RecordReviewTemplateId                                
                                        
  )                                                                                     
  SELECT                                                      
   @SessionId,                                                                                                                
   @InstanceId,                                               
   RowNumber ,                                                      
   PageNumber,                      
   @SortExpression,                      
   RecordReviewTemplateName,      
   Status, 
   DeleteAllowed,               
   RecordReviewTemplateId                                                
   FROM #ResultSet             
      
      
      
Final:         
           
   select @PageNumber as PageNumber, isnull(max(PageNumber), 0) as NumberOfPages, isnull(max(RowNumber), 0) as NumberOfRows                                                        
   from CustomListPageSCRecordReviewTemplates                                                        
   where SessionId = @SessionId                                                        
   and InstanceId = @InstanceId         
      
      
      
SELECT                                                        
   @SessionId as SessionId,                                                                                                                
   @InstanceId as InstanceId,                                              
   @SortExpression as SortExpression,                                                     
   Status,      
   DeleteAllowed,          
   RecordReviewTemplateName,RecordReviewTemplateId            
   FROM dbo.CustomListPageSCRecordReviewTemplates                                                   
   WHERE SessionId = @SessionId AND InstanceId = @InstanceId AND PageNumber = @PageNumber                                                                                                                
 ORDER BY RowNumber                                                    
 Drop Table #ResultSet          
       
 END