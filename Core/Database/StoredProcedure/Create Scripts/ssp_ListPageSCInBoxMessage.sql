  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ListPageSCInBoxMessage')
	BEGIN
		DROP  Procedure  ssp_ListPageSCInBoxMessage
	END

GO       
CREATE procedure [dbo].[ssp_ListPageSCInBoxMessage]    
@SessionId varchar(30),    
@InstanceId int,    
@PageNumber int,    
@PageSize int,    
@SortExpression varchar(100),    
@StaffId int,    
@ClientId int,    
@FromDate datetime,    
@ToDate datetime,    
@OtherFilter int ,    
@SeletedMessageId INT =NULL    
    
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
-- 26.05.2010 Vikas Vyas     Modified.    
-- 26.07.2010 Mahesh S    
--           1)Change the select condition from Message.Documentid to Message.ReferenceId    
--                           2)Added new column in ListPageSCMessageInBox ReferenceScreenType    
  08.04.2010 avoss  modified message to varchar(max)    
  05.16.2011 priya modified add the new column PartOfClientRecord    
  -- 19 Oct 2015   Revathi   what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.            
--              why:task #609, Network180 Customization    
    
-- 8 Feb 2016               Jayashree       What : Modified Date format of ReceiveDate w.r.t MFS - Customization Issue Tracking #331    
-- 15.02.2016	Manjunath K		What: Added Condition to Check ClientID when selecting ClientName.
								Why : It was returning only ',' if ClientId is 0. SWMBH - Support #867.
-- 18.2.2016    Pradeep Kumar Yadav  What -Change FromSystemDatabaseID to FromSystemDatabaseId from final result set
									 Why  - For SWMBH - Support #867.	
--5/3/2016      tkumar         What: Modified DateReceived type to datetime to fix the sort issue.
							   Why:  Core Bugs Task# 2091
--5/6/2016		Gkumar		   What: Added Cast condition with From and To Date	
							   Why: KCHMSAS - Support 536 
--02 July 2018	Vithobha		Added new column ProviderAuthorizationDocumentId in Messages for SWMBH - Support #1121
--08 Aug  2018  Chethan N		What : Retrieving ScreenId based on the Reference Type -- 'LabResults', 'BatchLabResults'
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
   SET @SortExpression = 'DateReceived desc'        
     
  
  
create table #ResultSet(    
MessageId int,    
[Status] varchar(50),    
FromStaffId int,    
FromStaffName varchar(100),    
[Message] varchar(max),    
--[Message] varchar(4000),    
DateReceived datetime,    
ClientId int,    
ClientName  varchar(100),    
[Subject] varchar(700),--Change the 700 from 100 as in ListPageSCMessageInBox    
Priority varchar(50),    
ReferenceId int,    
ReferenceName varchar(100),    
ReferenceScreenId int,    
ReferenceScreenType varchar(150),--Added on 26 July,2010    
ReferenceDocumentCodeId int,    
RecordDeleted char(1),    
FromSystemStaffID int,    
FromSystemDatabaseID int,    
FromSystemStaffName varchar(50),    
ReferenceType int,    
ReferenceSystemDatabaseId int ,    
OtherRecipients varchar(2000),    
PartOfClientRecord char(1),
ProviderAuthorizationDocumentId int    --02 July 2018	Vithobha
)    
        
-- Min & Max range is 1753 to 9999 in SQL Server 2008    
IF(ISNULL(@FromDate,'')= '')BEGIN  SET @FromDate = '1953-12-12 00:00:00.000' END    
IF(ISNULL(@ToDate,'') = '')BEGIN  SET @ToDate = '9999 -12-12 00:00:00.000' END    
/* End of modification 28 july 2008*/    
     
     
INSERT INTO #ResultSet (  
    MessageId ,    
    [Status] ,    
    FromStaffId ,    
    FromStaffName ,    
    [Message] ,    
    --[Message] varchar(4000),    
    DateReceived ,    
    ClientId ,    
    ClientName ,    
    [Subject] ,--Change the 700 from 100 as in ListPageSCMessageInBox    
    Priority ,    
    ReferenceId,    
    ReferenceName ,    
    ReferenceScreenId ,    
    ReferenceScreenType ,--Added on 26 July,2010    
    ReferenceDocumentCodeId ,    
    RecordDeleted ,    
    FromSystemStaffID ,    
    FromSystemDatabaseID ,    
    FromSystemStaffName ,    
    ReferenceType ,    
    ReferenceSystemDatabaseId  ,    
    OtherRecipients ,    
    PartOfClientRecord,
    ProviderAuthorizationDocumentId     --02 July 2018	Vithobha
    )  
      
    SELECT  distinct     
    a.MessageId,    
    case when a.Unread='Y' then 'Not Read'  when a.Unread='N' then 'Read' end as [Status],    
    case when a.FromStaffId IS not null then a.FromStaffId else a.FromSystemStaffId end as FromStaffId,    
    case when a.FromStaffId IS not null then rtrim(c.LastName) + ', ' + rtrim(c.FirstName) else a.FromSystemStaffName end as FromStaffName,    
    cast(a.[Message] as varchar(Max)) as [Message],  
    --a.Message,    
    --convert(varchar(10), cast(a.DateReceived as date), 101)+ RIGHT(Convert(VARCHAR(20), a.DateReceived, 0) ,8) as DateReceived,  --Added by Jayashree
    a.DateReceived,    
    a.ClientId,    
    --rtrim(e.LastName)+ ', ' +rtrim(e.FirstName) as ClientName,    
    --Added by Revathi  19 Oct 2015      
      CASE WHEN a.ClientId <> 0 then CASE    --  15.02.2016 Manjunath   
     WHEN ISNULL(e.ClientType, 'I') = 'I'      
      THEN ISNULL(e.LastName, '') + ', ' + ISNULL(e.FirstName, '')      
     ELSE ISNULL(e.OrganizationName, '')      
     END ELSE '' END AS 'ClientName'       
            
    ,a.Subject,    
    f.CodeName as Priority ,    
    --Modified by Vikas Vyas    
    --a.DocumentVersionId as ReferenceId,    
    a.ReferenceId,    
    a.Reference as ReferenceName,    
    --Screens.ScreenId as ReferenceScreenId,           Commented on 26 July,2010    
    --Changes on 26 July,2010    
    CASE WHEN a.ReferenceType  = '5606' THEN '44' --Authorization Document    
    When a.ReferenceType = '5603' and dCodes.ServiceNote='Y' then '29'    
    --WHEN a.ReferenceType = '5854' THEN Screens.ScreenId    
    WHEN a.ReferenceType='5602' then '75'   --Appeals Reference    
    WHEN a.ReferenceType='5601' and a.Reference='Grievances' then '71' --Grievances    
    WHEN a.ReferenceType='5601' and a.Reference='Inquiry' then '73' -- Inquiry    
    WHEN a.ReferenceType='5607' then '77' --SecondOpinion Reference  
	WHEN dbo.ssf_GetGlobalCodeCODEById(a.ReferenceType) = 'LabResults' THEN '778' -- ClientOrder Details 
	WHEN dbo.ssf_GetGlobalCodeCODEById(a.ReferenceType) = 'BatchLabResults' THEN '1299' -- Lab Results Review   
    else Screens.ScreenId END AS ReferenceScreenId,    
        
        
    CASE WHEN a.ReferenceType  = '5606' THEN '5761' --Andy type of Document Screen    
    WHEN a.ReferenceType = '5603' THEN Screens.ScreenType    
    WHEN a.ReferenceType='5602' then '5761'    
    WHEN a.ReferenceType='5601' then '5761'    
    WHEN a.ReferenceType='5607' then '5761'
    WHEN dbo.ssf_GetGlobalCodeCODEById(a.ReferenceType) = 'LabResults' THEN '5761' -- ClientOrder Details 
	WHEN dbo.ssf_GetGlobalCodeCODEById(a.ReferenceType) = 'BatchLabResults' THEN '5764' -- Lab Results Review       
     else Screens.ScreenType END AS ReferenceScreenType,    
        
    --end of modificaiton 26 July,2010    
    doc.DocumentId  as ReferenceDocumentCodeId,    
    a.RecordDeleted ,    
    a.FromSystemStaffId,    
    a.FromSystemDatabaseId,    
    a.FromSystemStaffName  ,    
    --Added by Mahesh on 11th-Dec-2010    
    a.ReferenceType,    
    a.ReferenceSystemDatabaseId ,    
    a.OtherRecipients,    
    a.PartOfClientRecord,
    a.ProviderAuthorizationDocumentId    --02 July 2018	Vithobha
    --a.ToStaffId,    
    --rtrim(d.LastName)+ ', '+ rtrim(d.FirstName) as ToName,    
        
        
        
        
    from Messages a    
    -- join GlobalCodes b on a.Status = b.GlobalCodeId    
     left join Staff c on a.FromStaffId = c.StaffId and IsNull(c.RecordDeleted,'N')= 'N'    
     join Staff d on a.ToStaffId = d.StaffId and IsNull(d.RecordDeleted,'N')='N'    
     LEft join Clients e on a.ClientId = e.ClientId and IsNull(e.RecordDeleted,'N')= 'N'    
     left join GlobalCodes f on a.Priority = f.GlobalCodeId    
     --Modified by Vikas Vyas    
     --left join DocumentVersions dv on dv.DocumentVersionId=a.DocumentVersionId    
     --left join DocumentVersions dv on dv.DocumentId=a.DocumentId  commented on 26 July,2010    
     --left join DocumentVersions dv on dv.DocumentId=a.ReferenceId  -- Modified on 26 July,2010  By Someone    
        --Above line commneted By Sumanta, on 03 Sep, 2010 as we are not accessing any record from document version    
     left join Documents doc on   doc.DocumentId= a.ReferenceId --  dv.DocumentId --Modified by Sumanta, add join direct with  doc.DocumentId= a.ReferenceId    
     left join Screens on Screens.DocumentCodeId=doc.DocumentCodeId and ISNULL(Screens.RecordDeleted, 'N') <> 'Y'    
     left join DocumentCodes dCodes on dCodes.DocumentCodeId=Screens.DocumentCodeId    
     --Newly added Left outer join    
     --left join Authorizations Auth on Auth.AuthorizationCodeId = a.ReferenceId    
     where    
     --Commented by Umesh for From Dropdwn Staff Filtering    
    --(e.ClientId=@ClientId or @ClientId=0)    
        
     --Added by Umesh for From Dropdwn Staff Filtering    
    (a.FromStaffId = @ClientId OR @ClientId= 0)    
     --Up to here    
     -- Gautam: Commented the code and added Cast condition to display the result with date/time KCMHSAS - Support 536   
    --and (a.DateReceived >=@FromDate and a.DateReceived <=@ToDate)   
     and (cast(a.DateReceived as date) >=@FromDate and cast(a.DateReceived as date) <=@ToDate)   
    --and (cast(convert(varchar(10),a.DateReceived,101) as datetime) >=@FromDate and cast(convert(varchar(10),a.DateReceived,101) as datetime) <=@ToDate)    
        
    and (a.ToStaffId=@StaffId ) and    
    IsNull(a.RecordDeleted,'N') <> 'Y'    
      
   
   
   
 ;WITH Counts  
  AS (SELECT Count(*) AS TotalRows  
   FROM #ResultSet)  
   ,RankResultSet  
  AS (SELECT   
    MessageId ,    
    [Status] ,    
    FromStaffId ,    
    FromStaffName ,    
    [Message] ,    
    --[Message] varchar(4000),    
    DateReceived ,    
    ClientId ,    
    ClientName ,    
    [Subject] ,--Change the 700 from 100 as in ListPageSCMessageInBox    
    Priority ,    
    ReferenceId,    
    ReferenceName ,    
    ReferenceScreenId ,    
    ReferenceScreenType ,--Added on 26 July,2010    
    ReferenceDocumentCodeId ,    
    RecordDeleted ,    
    FromSystemStaffID ,    
    FromSystemDatabaseID ,    
    FromSystemStaffName ,    
    ReferenceType ,    
    ReferenceSystemDatabaseId  ,    
    OtherRecipients ,    
    PartOfClientRecord ,
    ProviderAuthorizationDocumentId    --02 July 2018	Vithobha
    ,Count(*) OVER () AS TotalCount  
     ,row_number() over (order by case when @SortExpression= 'Status' then [Status] end,    
                                                case when @SortExpression= 'Status desc' then [Status] end desc,    
                                                case when @SortExpression= 'FromStaffName ' then FromStaffName end,    
                                                case when @SortExpression= 'FromStaffName desc' then FromStaffName end desc,    
                                                case when @SortExpression= 'DateReceived ' then DateReceived end ,    
                                                case when @SortExpression= 'DateReceived desc' then DateReceived end desc,    
                                                case when @SortExpression= 'DateReceived ' then DateReceived end,    
                                                case when @SortExpression= 'DateReceived desc' then DateReceived end desc,    
                                                case when @SortExpression= 'ClientName ' Then ClientName end ,    
                                                case when @SortExpression= 'ClientName desc' Then ClientName end desc,    
                                                case when @SortExpression= 'Subject ' then [Subject] end ,    
                                                case when @SortExpression= 'Subject desc' then [Subject] end desc,    
                                                case when @SortExpression= 'Priority ' then Priority end ,    
                                                case when @SortExpression= 'Priority desc ' then Priority end desc,    
                                                case when @SortExpression= 'ReferenceName ' then ReferenceName end ,    
                                                case when @SortExpression= 'ReferenceName desc' then ReferenceName end desc    
                                                --case when @SortExpression= 'FromName ' then FromName end desc,    
                                                --case when @SortExpression= 'FromName desc' then FromName end,    
                                               -- case when @SortExpression= 'ToName ' then ToName end,    
                                                -- case when @SortExpression= 'ToName desc' then ToName end desc,    
                                                -- case when @SortExpression= 'ClientName ' then ClientName end,    
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
    FromStaffId ,    
    FromStaffName ,    
    [Message] ,    
    --[Message] varchar(4000),    
    DateReceived ,    
    ClientId ,    
    ClientName ,    
    [Subject] ,--Change the 700 from 100 as in ListPageSCMessageInBox    
    Priority ,    
    ReferenceId,    
    ReferenceName ,    
    ReferenceScreenId ,    
    ReferenceScreenType ,--Added on 26 July,2010    
    ReferenceDocumentCodeId ,    
    RecordDeleted ,    
    FromSystemStaffID ,    
    FromSystemDatabaseID ,    
    FromSystemStaffName ,    
    ReferenceType ,    
    ReferenceSystemDatabaseId  ,    
    OtherRecipients ,    
    PartOfClientRecord  ,  
    ProviderAuthorizationDocumentId ,--02 July 2018	Vithobha
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
    FromStaffId ,    
    FromStaffName ,    
    [Message] ,    
    --[Message] varchar(4000),    
    DateReceived ,
    ClientId ,    
    ClientName ,    
    [Subject] ,--Change the 700 from 100 as in ListPageSCMessageInBox    
    Priority ,    
    ReferenceId,    
    ReferenceName ,    
    ReferenceScreenId ,    
    ReferenceScreenType ,--Added on 26 July,2010    
    ReferenceDocumentCodeId ,    
    RecordDeleted ,    
    FromSystemStaffID ,    
    FromSystemDatabaseId ,    
    FromSystemStaffName ,    
    ReferenceType ,    
    ReferenceSystemDatabaseId  ,    
    OtherRecipients ,    
    PartOfClientRecord ,
    ProviderAuthorizationDocumentId   --02 July 2018	Vithobha
  FROM #FinalResultSet  
  ORDER BY RowNumber--, DateReceived Desc    
      
      
 END TRY  
  
  BEGIN CATCH  
          DECLARE @error VARCHAR(8000)  
  
          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'  
                      + CONVERT(VARCHAR(4000), Error_message())  
                      + '*****'  
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),  
                      'ssp_ListPageSCInBoxMessage')  
                      + '*****' + CONVERT(VARCHAR, Error_line())  
                      + '*****' + CONVERT(VARCHAR, Error_severity())  
                      + '*****' + CONVERT(VARCHAR, Error_state())  
  
          RAISERROR (@error,-- Message text.  
                     16,-- Severity.  
                     1 -- State.  
          );  
      END CATCH  
  END    