IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ListPageSCSentMessage')
	BEGIN
		DROP  Procedure  ssp_ListPageSCSentMessage
	END

GO     
 CREATE procedure [dbo].[ssp_ListPageSCSentMessage]                                                               
@SessionId varchar(30),                                                                  
@InstanceId int,                                                                  
@PageNumber int,                                                                      
@PageSize int,                                                                      
@SortExpression varchar(100),                                 
@StaffId int,                            
@OtherFilter int                                                                  
/********************************************************************************                                                                  
-- Stored Procedure: dbo.ssp_ListPageSCInBoxMessage                                                                    
--                                                                  
-- Copyright: Streamline Healthcate Solutions                                                                  
--                                                                  
-- Purpose: used by  Message Inbox Page                                                               
--                                                                  
-- Updates:                                                                                                                         
-- Date        Author      Purpose                                                                  
-- 14.1.2010  Mohit Madaan   Created.                                                                        
-- 26.05.2010 Vikas Vyas  Modified.                
-- 26.07.2010 Mahesh S   Modifications             
       1)Add new column ReferenceScreenType in ListPageSCMessageSent            
--       2)Change the select condiion, Changed  the Msg.ReferenceId from Msg.DocumentID with doc.DocumentId            
    05.16.2011 priya modified add the new column PartOfClientRecord      
-- Jan03-2012  Vikas k (Added comman betweedn Last name & first name Ref to task  49 in Kalamazoo bugs)     
-- 10-Dec-2015 Basudev Sahu Modified for task #609 Network180 Customization  
-- 8 Feb 2016  Jayashree       What : Modified Date format of ReceiveDate w.r.t MFS - Customization Issue Tracking #331
-- 09 June 2016 GKumar/MSood	What: Modified DateSent to DateTime w.r.t Newaygo - Support Task # 526
-- 08/24/2076   Chethan N		What : Retrieving ScreenId based on the Reference Type -- 'LabResults', 'BatchLabResults'
								Why : Engineering Improvement Initiatives- NBL(I) task #551                                                          
*********************************************************************************/                                                                  
AS  
BEGIN  
 BEGIN TRY     
  
DECLARE @ApplyFilterClick AS CHAR(1)  
  
  SET @ApplyFilterClick = 'N'  
  
  DECLARE @CustomFiltersApplied CHAR(1)  
  
  SET @CustomFiltersApplied = 'N'  
  SET @SortExpression = RTRIM(LTRIM(@SortExpression))  
  
  IF ISNULL(@SortExpression, '') = ''  
   SET @SortExpression = 'DateSent desc'        
     
   declare @Today datetime                                                                  
              set @Today = convert(char(10), getdate(), 101)  ;                                             
                                  
                                                                                                                                
create table #ResultSet(                                                                  
RowNumber int,                                                                  
PageNumber int,                                  
MessageId int,                       
[Status] varchar(50),                                 
ToStaffId int,                             
ToStaffName varchar(Max),                      
[Message] varchar(Max),
-- 09 June 2016 GKumar/MSood                       
DateSent datetime,   -- Modified by jayashree                          
ClientId int,                         
ClientName  varchar(100),                      
[Subject] varchar(700),                      
Priority varchar(50),                      
ReferenceId int,                      
ReferenceName varchar(100),                      
ReferenceScreenId int,              
ReferenceScreenType varchar(150),--Added on 26 July,2010                      
ReferenceDocumentCodeId int,                      
RecordDeleted char(1),        
ReferenceSystemDatabaseId int,      
PartOfClientRecord char(1),    
ReferenceType int,                                  
)                                                                  
                                                                  
CREATE TABLE #CustomFilters (ServiceId INT)                                                              
declare @DocumentCodeFilters table (DocumentCodeId int)          
  
--IF @OtherFilter > 10000  
--  BEGIN  
--   IF OBJECT_ID('dbo.scsp_ListPageSCSentMessage', 'P') IS NOT NULL  
--   BEGIN  
--    SET @CustomFiltersApplied = 'Y'  
  
--    INSERT INTO #CustomFilters (ServiceId)  
--    EXEC scsp_ListPageSCSentMessage @OtherFilter = @OtherFilter  
--   END  
--  END      
    
    
INSERT INTO #ResultSet (  
    MessageId ,                       
    [Status] ,                                 
    ToStaffId ,                             
    ToStaffName ,                      
    [Message] ,                       
    DateSent ,                             
    ClientId ,                         
    ClientName ,                      
    [Subject] ,                      
    Priority ,                      
    ReferenceId ,                      
    ReferenceName ,                      
    ReferenceScreenId ,              
    ReferenceScreenType ,--Added on 26 July,2010                      
    ReferenceDocumentCodeId,                      
    RecordDeleted ,        
    ReferenceSystemDatabaseId ,      
    PartOfClientRecord ,    
    ReferenceType   
    )  
  SELECT  distinct  
    a.MessageId,  
   'Not Read' as status ,  
   dbo.Fn_CombinedStaffID(a.MessageId) as  ToStaffId,           
  dbo.Fn_CombinedStaffName(a.MessageId) as ToStaffName,          
  cast(Msg.[Message] as varchar(Max)) as [Message],  
  --convert(varchar(10), cast(Msg.CreatedDate as date), 101)+ RIGHT(Convert(VARCHAR(20), Msg.CreatedDate, 0) ,8) as DateSent, -- Modified by Jayashree  
  Msg.CreatedDate as DateSent,  
  Msg.ClientId as ClientId,     
  (Case when Msg.ClientId IS Not null then     
  case when  ISNULL(clnt.ClientType,'I')='I' then ISNULL(clnt.LastName,'') + ', ' + ISNULL(clnt.FirstName,'') else clnt. OrganizationName end  else null end )as ClientName,          
  Msg.[Subject] as [Subject]   
  ,glbc.CodeName as Priority,            
  Msg.ReferenceId,              
  Msg.Reference as ReferenceName,                      
           
--CASE WHEN Msg.ReferenceType  = '5855' THEN '44' --Authorization Document             
--When Msg.ReferenceType = '5854' and dCodes.ServiceNote='Y' then '29'          
--WHEN Msg.ReferenceType = '5854' THEN Screens.ScreenId END AS ReferenceScreenId,                      
            
--CASE WHEN Msg.ReferenceType  = '5855' THEN '5761' --Andy type of Document Screen            
          
--WHEN Msg.ReferenceType = '5854' THEN Screens.ScreenType  END AS ReferenceScreenType,        
        
  CASE WHEN Msg.ReferenceType  = '5606' THEN '44' --Authorization Document                
  When Msg.ReferenceType = '5603' and dCodes.ServiceNote='Y' then '29'              
--WHEN a.ReferenceType = '5854' THEN Screens.ScreenId         
  WHEN Msg.ReferenceType='5602' then '75'   --Appeals Reference        
  WHEN Msg.ReferenceType='5601' and Msg.Reference='Grievances' then '71' --Grievances         
  WHEN Msg.ReferenceType='5601' and Msg.Reference='Inquiry' then '73' -- Inquiry        
  WHEN Msg.ReferenceType='5607' then '77' --SecondOpinion Reference 
  WHEN dbo.ssf_GetGlobalCodeCODEById(Msg.ReferenceType) = 'LabResults' THEN '778' -- ClientOrder Details 
  WHEN dbo.ssf_GetGlobalCodeCODEById(Msg.ReferenceType) = 'BatchLabResults' THEN '1299' -- Lab Results Review     
  else Screens.ScreenId END AS ReferenceScreenId,                                      
    
  CASE WHEN Msg.ReferenceType  = '5606' THEN '5761' --Andy type of Document Screen                
  WHEN Msg.ReferenceType = '5603' THEN Screens.ScreenType        
  WHEN Msg.ReferenceType='5602' then '5761'        
  WHEN Msg.ReferenceType='5601' then '5761'        
  WHEN Msg.ReferenceType='5607' then '5761' 
  WHEN dbo.ssf_GetGlobalCodeCODEById(Msg.ReferenceType) = 'LabResults' THEN '5761' -- ClientOrder Details  
  WHEN dbo.ssf_GetGlobalCodeCODEById(Msg.ReferenceType) = 'BatchLabResults' THEN '5764' -- Lab Results Review   
   else Screens.ScreenType END AS ReferenceScreenType,              
              
   doc.DocumentId as ReferenceDocumentCodeId,                
   Msg.RecordDeleted    
   ,Msg.ReferenceSystemDatabaseId,      
   Msg.PartOfClientRecord ,  
   Msg.ReferenceType         
   from MessageRecepients a  inner join  Messages Msg on a.MessageId=Msg.MessageId left join  Staff staf          
   on  Msg.ToStaffId = staf.StaffId           
   LEft join Clients clnt on Msg.ClientId = clnt.ClientId                                        
   left join GlobalCodes glbc on Msg.Priority = glbc.GlobalCodeId               
    --Modified by Vikas Vyas                       
    --left join DocumentVersions dv on dv.DocumentVersionId=Msg.DocumentVersionId                        
    --left join DocumentVersions dv on dv.DocumentId=Msg.DocumentId                        
    --left join Documents doc on doc.DocumentId=Msg.DocumentId            Coomented on 26 July add join with referenceID            
    left join Documents doc on doc.DocumentId=Msg.ReferenceId             
    left join Screens on Screens.DocumentCodeId=doc.DocumentCodeId and ISNULL(Screens.RecordDeleted, 'N') <> 'Y'    
    left join DocumentCodes dCodes on dCodes.DocumentCodeId=Screens.DocumentCodeId 
    where           
   Msg.FromStaffId=@StaffId and           
    Isnull(Msg.RecordDeleted,'N')<>'Y' --(a.DeletedBySender='N' or a.DeletedBySender is Null)                            
   -- order by Msg.MessageId desc           
                                                      
   ;WITH Counts  
  AS (SELECT Count(*) AS TotalRows  
   FROM #ResultSet)  
   ,RankResultSet  
  AS (SELECT MessageId ,                       
    [Status] ,                                 
    ToStaffId ,                             
    ToStaffName ,                      
    [Message] ,                       
    DateSent ,                             
    ClientId ,                         
    ClientName ,                      
    [Subject] ,                      
    Priority ,                      
    ReferenceId ,                      
    ReferenceName ,                      
    ReferenceScreenId ,              
    ReferenceScreenType ,--Added on 26 July,2010                      
    ReferenceDocumentCodeId,                      
    RecordDeleted ,        
    ReferenceSystemDatabaseId ,      
    PartOfClientRecord ,    
    ReferenceType   
    ,Count(*) OVER () AS TotalCount  
    , row_number() over (order by case when @SortExpression= '[Status]' then [Status] end,                                                  
    case when @SortExpression= '[Status] desc' then [Status] end desc,                                                        
                                                 case when @SortExpression= 'ToStaffName' then ToStaffName end,                            
                                                case when @SortExpression= 'ToStaffName desc' then ToStaffName end desc,                     
                                                --case when @SortExpression= '[Message] ' then [Message] end ,                                                         
                                               -- case when @SortExpression= '[Message] desc' then [Message] end desc,  
                                               -- 09 June 2016 GKumar/MSood                        
                                                 case when @SortExpression= 'DateSent' then DateSent end,                                            
                                                case when @SortExpression= 'DateSent desc' then DateSent end desc,                                            
                                                case when @SortExpression= 'ClientName' Then ClientName end ,                           
            case when @SortExpression= 'ClientName desc' Then ClientName end desc,                          
                                                 case when @SortExpression= 'Subject' then Subject end ,                                            
                                                case when @SortExpression= 'Subject desc' then Subject end desc,              
                                                case when @SortExpression= 'Priority ' then Priority end ,                           
                                                case when @SortExpression= 'Priority desc' then Priority end desc,                            
                                                --case when @SortExpression= 'ReferenceName ' then ReferenceName end desc,                          
                                                case when @SortExpression= 'ReferenceName ' then ReferenceName end ,                          
                                                case when @SortExpression= 'ReferenceName desc' then ReferenceName end desc ,                  
                                                case when @SortExpression= '' then MessageId end desc                             
                                                --case when @SortExpression= 'FromName ' then FromName end,                          
                                               -- case when @SortExpression= 'FromName desc' then FromName end desc,                             
                                              --case when @SortExpression= 'ToName ' then ToName end ,      
                                                -- case when @SortExpression= 'ToName desc' then ToName end desc,                           
                                               --  case when @SortExpression= 'ClientName ' then ClientName end,                             
                                                --  case when @SortExpression= 'ClientName desc' then ClientName end desc,                          
                                                 -- case when @SortExpression= 'PriorityCodeName ' then PriorityCodeName end,                             
                                                --   case when @SortExpression= 'PriorityCodeName desc' then PriorityCodeName end desc     
      ,MessageId) AS RowNumber  
   FROM #ResultSet )  
  SELECT TOP (CASE WHEN (@PageNumber = - 1)  
      THEN (SELECT Isnull(TotalRows, 0) FROM Counts)  
     ELSE (@PageSize)  
     END  
    )  MessageId ,                       
    [Status] ,                                 
    ToStaffId ,                             
    ToStaffName ,                      
    [Message] ,                       
    DateSent ,                             
    ClientId ,                         
    ClientName ,                      
    [Subject] ,                      
    Priority ,                      
    ReferenceId ,                      
    ReferenceName ,                      
    ReferenceScreenId ,              
    ReferenceScreenType ,--Added on 26 July,2010                      
    ReferenceDocumentCodeId,                      
    RecordDeleted ,        
    ReferenceSystemDatabaseId ,      
    PartOfClientRecord ,    
    ReferenceType ,  
    TotalCount,  
    RowNumber  
  INTO #FinalResultSet  
  FROM RankResultSet  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (SELECT Isnull(Count(*), 0) FROM #FinalResultSet) < 1  
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
      THEN Isnull((Totalcount / @PageSize), 0)  
     ELSE Isnull((Totalcount / @PageSize), 0) + 1  
     END AS NumberOfPages  
    ,Isnull(Totalcount, 0) AS NumberofRows  
   FROM #FinalResultSet  
  END  
  
  SELECT MessageId ,                       
    [Status] ,                                 
    ToStaffId ,                             
    ToStaffName ,                      
    [Message] ,                       
    DateSent ,                             
    ClientId ,                         
    ClientName ,                      
    [Subject] ,                      
    Priority ,                      
    ReferenceId ,                      
    ReferenceName ,                      
    ReferenceScreenId ,              
    ReferenceScreenType ,--Added on 26 July,2010                      
    ReferenceDocumentCodeId,                      
    RecordDeleted ,        
    ReferenceSystemDatabaseId ,      
    PartOfClientRecord ,    
    ReferenceType   
  FROM #FinalResultSet  
  ORDER BY RowNumber  
     
    
  END TRY  
  
  BEGIN CATCH  
          DECLARE @error VARCHAR(8000)  
  
          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'  
                      + CONVERT(VARCHAR(4000), Error_message())  
                      + '*****'  
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),  
                      'ssp_ListPageSCSentMessage')  
                      + '*****' + CONVERT(VARCHAR, Error_line())  
                      + '*****' + CONVERT(VARCHAR, Error_severity())  
                      + '*****' + CONVERT(VARCHAR, Error_state())  
  
          RAISERROR (@error,-- Message text.  
                     16,-- Severity.  
                     1 -- State.  
          );  
      END CATCH  
  END    
     
     
     
     
     
     
     
     