/****** Object:  StoredProcedure [dbo].[ssp_ListPageSecondOpinionDetailsFilter]    Script Date: 11/18/2011 16:25:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSecondOpinionDetailsFilter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSecondOpinionDetailsFilter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSecondOpinionDetailsFilter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/******************************************************************************                                                    
**  File:                                                     
**  Name: ssp_ListPageSecondOpinionDetailsFilter                                                    
**  Desc: This storeProcedure will return information regarding SeconOpinion ListPage based on filters                                               
**                                                                  
**  Parameters:                                                    
**  Input  Filters                                  
                                                      
**  Output     ----------       -----------                                                    
**  SecondOpinions Data                                     
                                                  
**  Auth:  Vikas Vyas                                                
**  Date:  10 may 2010                                                  
*******************************************************************************                                                    
**  Change History                                                    
*******************************************************************************                                                    
**  Date:			Author:			Description:                                                    
**  --------		 --------		-------------------------------------------                                                    
**  07 Sep 2010     Jitender Kumar	Kamboj  Removed logic of @SessionId,@InstanceId,@PageNumber,@PageSize, @SortExpression                                                     
**  25 Oct 2012     Rachna Singh	Modified SP to return the "DateReceived" column in 101 format.                                         
**	24 Jan 2013		AmitSr			Modified SP to change column names so that UI and Export to excel data remain same.Task #76 3.5x Issues.                                    
**  06-Jan-2014     Revathi         what: Added join with StaffClients table to display associated Clients for Login staff
**                                  why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter                              
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
*******************************************************************************/                                                 
                                                
                                                          
create procedure [dbo].[ssp_ListPageSecondOpinionDetailsFilter]                                      
--@SessionId varchar(30),                                                                              
--@InstanceId int,                                                                              
--@PageNumber int,                                                                                  
--@PageSize int,                                                      
--@SortExpression varchar(100),                                                      
@OrganizationId int,                                                      
@ClientId int,                                                      
@Type int,                                                      
@FromDate datetime,                                                      
@ToDate datetime,                                                                      
@StatusFilter int,                                                                                                      
@OtherFilter int,                                  
@StaffId int                
--@AllOrganization int                 
                      
                                                                                      
as                                                                
              
declare @ResultSet table(                  
SecondOpinionId  int,                                                                                                                                                                                                           
DateReceived     datetime,                                    
Status           varchar(100),                                                                                  
ClientId         int,                                                       
ClientName       varchar(100),      
DaysLeft         int,                                                                          
ComplainantName  varchar(50),                                                      
Type             varchar(100),                                                                                   
OrganizationId  int,                                                      
OrganizationName varchar(100)                               
  
)                                  
                                                    
declare @CustomFilters table (SecondOpinionId int)                           
declare @CustomFiltersApplied char(1)                  
                          
set @CustomFiltersApplied = ''N''                  
                                                     
if @StatusFilter > 10000 or @OtherFilter > 10000                  
begin                                  
                          
 set @CustomFiltersApplied = ''Y''                     
                                          
 insert into @CustomFilters (SecondOpinionId)                                                        
   exec scsp_ListPageSecondOpinionDetailsFilter    @OrganizationId = @OrganizationId,                                                      
            @ClientId = @ClientId,                                                      
            @Type = @Type,                                                      
            @FromDate = @FromDate,                                                      
            @ToDate = @ToDate,                                                                      
            @StatusFilter = @StatusFilter,                                                                                                      
            @OtherFilter = @OtherFilter,                                  
            @StaffId = @StaffId                                                            
                                   
end                             
                          
begin                  
  insert into @ResultSet(                  
    SecondOpinionId,                                                                                                                                
   DateReceived,                                         
   Status,                                                                               
   ClientId,                                                               
   ClientName,                                                            
   DaysLeft,                                                                           
   ComplainantName,                                                        
   Type,                                                                                      
   OrganizationId,                                                        
   OrganizationName                                                     
   )                                               
              
SELECT                                                       
       SecondOpinionId                                                      
      ,SecondOpinions.DateReceived                                      
      , case when  SecondOpinionStatus=''O'' then                          
         ''Open''                          
         else                          
         ''Close''                          
         end as SecondOpinionStatus                                   
      ,SecondOpinions.[ClientId]                                                       
     -- Modified by   Revathi   20 Oct 2015                                     
      ,case when  ISNULL(Clients.ClientType,''I'')=''I'' then ISNULL(Clients.LastName,'''') + '', '' + ISNULL(Clients.FirstName,'''')  ELSE ISNULL(Clients.OrganizationName, '''') END                                                        
      ,60- DATEDIFF(day,DateReceived, GETDATE())                                                             
      ,case when SecondOpinions.ComplainantRelationToClient =5661 and isnull(SecondOpinions.ComplainantName,'''') = ''''                                                                    
      	-- Modified by   Revathi   20 Oct 2015                                                               
      then case when  ISNULL(Clients.ClientType,''I'')=''I'' then ISNULL(Clients.LastName,'''') + '', '' + ISNULL(Clients.FirstName,'''') 
      else ISNULL(Clients.OrganizationName,'''') end else ComplainantName end as ComplainantName                                                              
      ,GC1.CodeName                                                                                           
      ,@OrganizationId as ''OrganizationId''                                                                      
      ,(select OrganizationName from SystemDatabases where SystemDatabaseId=@OrganizationId) as ''OrganizationName''                                                    
                                                  
       FROM [SecondOpinions]                                               
                                                
   left Join Clients on SecondOpinions.ClientId=Clients.ClientId
   --Added by Revathi on 06-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)
   join StaffClients sc on sc.ClientId=Clients.ClientId and sc.StaffId=@StaffId                                                            
   Left OUTER JOIN                                                              
   GlobalCodes GC1 ON  GC1.GlobalCodeId=SecondOpinions.SecondOpinionType                                                           
                                                    
   where                                                  
     ISNULL(Clients.RecordDeleted,''N'')<>''Y''                                                      
   and ISNULL(SecondOpinions.RecordDeleted,''N'')<>''Y'' and (@ClientId=0 or SecondOpinions.ClientId=@ClientId) and                                                   
  (@Type=423 or                           
    (SecondOpinions.SecondOpinionType=19558 and @Type=424) or                                         
    (SecondOpinions.SecondOpinionType=19559 and @Type=425)                                                     
   )                                                  
   --and (@StatusFilter=10449 or                                    
   --    (@StatusFilter=10448 and (SecondOpinionStatus=''C''))                                    
   --    or                                     
   --    (@StatusFilter=10447 and (SecondOpinionStatus=''O''))                          
   --    )                
   and (@StatusFilter=432 or                                    
       (@StatusFilter=431 and (SecondOpinionStatus=''C''))                                    
       or                                     
       (@StatusFilter=430 and (SecondOpinionStatus=''O''))                          
       )                                   
   and (@FromDate is null or SecondOpinions.DateReceived >= @FromDate)                                                                   
   and (@ToDate is null or SecondOpinions.DateReceived <dateadd(dd, 1, @ToDate))                 
                 
end                  
                      
--Modified By AmitSr
--Task #76  3.5x Issues.

select  SecondOpinionId,                                                                                                                                
   Convert(varchar(12),DateReceived,101) as ''Date'',                                  
   Status,                                                                               
   ClientId,                                                               
   ClientName AS ''Client'',                                                            
   DaysLeft AS ''Days Left'',                                                                           
   ComplainantName AS ''Complainant'',                                                        
   Type,                                                                                      
   OrganizationId,                                                        
   OrganizationName AS ''Organization Name''                                                     
      
  from @ResultSet                   
 order by DateReceived desc                   
                   
return ' 
END
GO
