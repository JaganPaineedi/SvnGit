/****** Object:  StoredProcedure [dbo].[csp_SCListPageClientContactNote]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCListPageClientContactNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCListPageClientContactNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCListPageClientContactNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCListPageClientContactNote] --''yrdpqenq3zknxrfkw0gc4iev'',6,0,10,''ContactDateTime desc'',40541,0,0,20381,''7/5/2010'',''7/6/2070''    
  @SessionId VARCHAR(30)                                                                          
 ,@InstanceId INT                                                                          
 ,@PageNumber INT                                                                              
 ,@PageSize INT                                                                              
 ,@SortExpression VARCHAR(100)    
 ,@ClientId INT            
 ,@Status INT    
 ,@Type INT    
 ,@Reason INT    
 ,@FromDate DATETIME    
 ,@ToDate DATETIME    
 ,@OtherFilter int  
                
/********************************************************************************                                                                          
-- Stored Procedure: dbo.csp_SCListPageClientOrders                                                                                                          
-- Copyright: Streamline Healthcate Solutions                                                                          
--                                                                          
-- Purpose: used by Contact Note List page.           
--    
--                                                                          
-- Updates:                                                                                                                                 
-- Date    Author    Purpose                                                                          
-- 04.07.2011  Davinder Kumar  Created.                                                                                
--                                                                          
*********************************************************************************/                     
As            
BEGIN            
 CREATE TABLE #ResultSet (RowNumber  INT                                                                           
        ,PageNumber  INT                                                                            
        ,ClientContactNoteId  INT    
           
        ,ContactDateTime DATETIME                                        
        ,ContactReason VARCHAR(250)    
        ,ContactType VARCHAR(250)                
        ,ContactStatus VARCHAR(50)    
        ,ContactDetails VARCHAR(MAX)             
        )          
 declare @CustomFilters table (ClientContactNoteId int)   
 declare @CustomFiltersApplied char(1)          
 DECLARE @Today DATETIME                          
 DECLARE @ApplyFilterClicked CHAR(1)    
 SET @SortExpression = rtrim(ltrim(@SortExpression))                    
                  
 IF ISNULL(@SortExpression, '''') = ''''                  
   SET @SortExpression= ''ContactDateTime desc''             
                      
--                            
-- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data              
 IF @PageNumber > 0 AND EXISTS(SELECT * FROM ListPageSCClientContactNotes WHERE SessionId = @SessionId and InstanceId = @InstanceId)                 
 BEGIN                                                            
   SET @ApplyFilterClicked = ''N''                                                            
   GOTO GetPage                                                            
 END                                             
--                                                            
-- New retrieve - the request came by clicking on the Apply Filter button             
 SET @ApplyFilterClicked = ''Y''                                                            
 SET @PageNumber = 1                                                                                  
 SET @Today = CONVERT(CHAR(10), GETDATE(), 101)             
   
 -- Get custom filters                          
if @OtherFilter > 10000                    
begin    
    
  set @CustomFiltersApplied = ''Y''                          
      
  insert into @CustomFilters (ClientContactNoteId)                          
  exec scsp_SCListPageClientContactNote @ClientId = @ClientId,                          
          @Status = @Status,                                                    
          @Type = @Type,    
          @Reason = @Reason,                           
          @OtherFilter = @OtherFilter    
    
end             
   
           
 INSERT INTO #ResultSet ( ClientContactNoteId    
        
       ,ContactDateTime                                      
       ,ContactReason     
       ,[ContactType]           
       ,[ContactStatus]    
       ,[ContactDetails]    
     )              
 SELECT  CCN.ClientContactNoteId     
    
   ,CCN.ContactDateTime               
   ,GCR.CodeName AS ContactReason    
   ,GCT.CodeName AS [ContactType]     
   ,GCS.CodeName AS [ContactStatus]    
   ,CCN.ContactDetails     
    FROM ClientContactNotes CCN              
     INNER JOIN Clients C ON C.ClientId = CCN.ClientId AND CCN.ClientId = @ClientId AND ISNULL(C.RecordDeleted,''N'') <> ''Y'' AND ISNULL(CCN.RecordDeleted,''N'') <> ''Y''      
     LEFT OUTER JOIN GlobalCodes GCR ON CCN.ContactReason = GCR.GlobalCodeId             
     LEFT OUTER JOIN GlobalCodes GCT ON CCN.ContactType = GCT.GlobalCodeId              
     LEFT OUTER JOIN GlobalCodes GCS ON CCN.[ContactStatus] = GCS.GlobalCodeId      
    WHERE     
  --Date Filter    
  (CCN.ContactDateTime >= @FromDate AND CAST(CONVERT(varchar(50),CCN.ContactDateTime,106) as Datetime) <= @ToDate)     
  --Type Filter    
  --AND (@Type = 0 --All Type    
  --OR (@Type = 4030 AND CCN.ContactType = 2141)    
  --OR (@Type = 4031 AND CCN.ContactType = 2142)    
  --OR (@Type = 4032 AND CCN.ContactType = 2143)    
  --OR (@Type = 4033 AND CCN.ContactType = 2144)    
  --OR (@Type = 4034 AND CCN.ContactType = 2145)    
  --OR (@Type = 4035 AND CCN.ContactType = 2146))    
    
   AND (@Type = 0 --All Status    
  OR (IsNull(CCN.ContactType, 0) = @Type))    
  --Status Filter    
  AND (@Status = 0 --All Status    
  OR (IsNull(CCN.ContactStatus, 0) = @Status))    
  --Reason Filter    
  AND (@Reason = 0 --All Reason    
  OR (IsNull(CCN.ContactReason, 0) = @Reason))    
--------------------------------------------------------------------------------------------------------------------------------------------             
            
 GetPage:                                             
                                                       
 IF @ApplyFilterClicked = ''N'' AND EXISTS(select * from ListPageSCClientContactNotes where SessionId = @SessionId and InstanceId = @InstanceId and  SortExpression = @SortExpression)                                
  GOTO Final                                                            
                                                            
 SET @PageNumber = 1                                                            
 IF @ApplyFilterClicked = ''N''                                                            
 BEGIN                         
  INSERT INTO #ResultSet(  ClientContactNoteId    
            
        ,ContactDateTime                                      
        ,ContactReason     
        ,[ContactType]           
        ,[ContactStatus]    
        ,[ContactDetails])                                                            
  SELECT   ClientContactNoteId    
     
    ,ContactDateTime                                      
    ,ContactReason     
    ,ContactType           
    ,ContactStatus    
    ,ContactDetails    
  FROM ListPageSCClientContactNotes                                                              
  WHERE SessionId = @SessionId AND InstanceId = @InstanceId                    
 END     
                              
 UPDATE d                                                          
  SET RowNumber = rn.RowNumber,                                           
   PageNumber = (rn.RowNumber/@PageSize) + CASE WHEN rn.RowNumber % @PageSize = 0 THEN 0 ELSE 1 END                                                        
 FROM #ResultSet d                                                       
  JOIN (SELECT  ClientContactNoteId                                                          
      ,ROW_NUMBER() OVER (ORDER BY CASE WHEN @SortExpression= ''ContactDateTime'' THEN ContactDateTime END    
             ,CASE WHEN @SortExpression= ''ContactDateTime desc'' THEN ContactDateTime END DESC                            
                                                 ,CASE WHEN @SortExpression= ''ContactReason'' THEN ContactReason END    
                                                 ,CASE WHEN @SortExpression= ''ContactReason desc'' THEN ContactReason END DESC    
                                                 ,CASE WHEN @SortExpression= ''ContactType'' THEN ContactType END    
                                                 ,CASE WHEN @SortExpression= ''ContactType desc'' THEN ContactType END DESC                                          
             ,CASE WHEN @SortExpression= ''ContactStatus'' THEN ContactStatus END    
             ,CASE WHEN @SortExpression= ''ContactStatus desc'' THEN ContactStatus END DESC    
             ,CASE WHEN @SortExpression= ''ContactDetails'' THEN ContactDetails END    
             ,CASE WHEN @SortExpression= ''ContactDetails desc'' THEN ContactDetails END DESC    
                                                  
                                                 ,ClientContactNoteId) AS RowNumber                                     
   FROM #ResultSet) rn ON rn.ClientContactNoteId = d.ClientContactNoteId                                                           
                                              
 DELETE FROM ListPageSCClientContactNotes                                                          
  WHERE SessionId = @SessionId and InstanceId = @InstanceId                   
               
 INSERT INTO ListPageSCClientContactNotes( [SessionId]              
            ,[InstanceId]              
            ,[RowNumber]              
            ,[PageNumber]              
            ,[SortExpression]              
            ,ClientContactNoteId    
            ,ContactDateTime                                      
            ,ContactReason     
            ,[ContactType]           
            ,[ContactStatus]    
            ,[ContactDetails]    
          )                                    
  SELECT @SessionId                                                          
     ,@InstanceId                                                          
     ,RowNumber                                                          
     ,PageNumber                                                          
     ,@SortExpression               
     ,ClientContactNoteId    
     ,ContactDateTime                                      
     ,ContactReason     
     ,[ContactType]           
     ,[ContactStatus]    
     ,[ContactDetails]        
  FROM  #ResultSet                  
                    
                    
 FINAL:         
                  
 SELECT @PageNumber AS PageNumber, ISNULL(MAX(PageNumber), 0) AS NumberOfPages, ISNULL(MAX(RowNumber), 0) AS NumberOfRows    
                                  FROM ListPageSCClientContactNotes                                          
 WHERE SessionId = @SessionId AND InstanceId = @InstanceId                
      
 SELECT  ClientContactNoteId    
        
   ,ContactDateTime                                    
   ,ContactReason     
   ,ContactType          
   ,ContactStatus     
   ,ContactDetails               
 FROM ListPageSCClientContactNotes                                                          
 WHERE SessionId = @SessionId AND InstanceId = @InstanceId AND PageNumber = @PageNumber                                                          
 ORDER BY RowNumber                             
 END                                                    
                   
' 
END
GO
