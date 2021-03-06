/****** Object:  StoredProcedure [dbo].[ssp_ListPageGrievancesDetailsFilter]    Script Date: 11/18/2011 16:25:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageGrievancesDetailsFilter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageGrievancesDetailsFilter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageGrievancesDetailsFilter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'      
                                    
                                    
CREATE procedure [dbo].[ssp_ListPageGrievancesDetailsFilter]                                     
@OrganizationId int,                                                                          
@ClientId int,                                                                          
@CategoryId int,                                                                          
@FromDate datetime,                                                                          
@ToDate datetime,                                                                          
@ProviderId int,                                                                             
@StaffId int,                                                                          
@StatusFilter int,                                                                            
@Inquiry char,  --Takes value B,Y,N                                                                                                          
@OtherFilter int,
@LoggedInStaffId int                                        
as                                                                                    
/******************************************************************************                                                                          
**  File:                                                                           
**  Name: ssp_ListPageGrievancesDetailsFilter                                                                          
**  Desc: This storeProcedure will return information regarding GrievanceListPage based on filters                                                                     
**                                                                                        
**  Parameters:                                                                          
**  Input  Filters                                                        
                                                                            
**  Output     ----------       -----------                                                                          
**  Grievances Data                                                           
                                                                        
**  Auth:  Vikas Vyas                                                                      
**  Date:  10 may 2010                                                                        
*******************************************************************************                                                                          
**  Change History                                                                          
*******************************************************************************                                                                          
**  Date:    Author:     Description:                                                                          
**  --------  --------    -------------------------------------------                                                                          
**   Sep 07 2010     Jitender Kumar Kamboj  Removed logic of @SessionId,@InstanceId,@PageNumber,@PageSize, @SortExpression                                                                     
  Nov 18 2010     Jitender Kumar Kamboj Added @StatusFilter=446 in ref task G&A #111  
  Dec 29 2011	  Sourabh				Commented and Added to appropriately handle Provider and About filters so that the intersection of the filters
										is returned, rather than the union with ref to task#378	
  Jan 06 2014     Revathi         what: Added join with StaffClients table to display associated Clients for Login staff
                                  why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter                              										             
	18 May 2015		Vithobha				Changed the Filter value from GlobalSubCodes to GlobalCodes of CategoryId Philhaven - Customization Issues Tracking #1269   
	02 June 2015	Vithobha				Added one more Filter GrievanceType and Implemented the Custom logic based on SystemConfigurationKeys - Philhaven Development: #250                                                                               
   Oct 20 2015	Revathi			 what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. 
  								 why:task #609, Network180 Customization    
  Aug 10, 2016 Msood  What: Changed the datatype from 100 to 350, CodeName size is 250 and GrievanceAboutName is 100   
					  Why: SWMBH - Support Task # 1037	                     
****************************************************************************** */                                          
declare @ResultSet table(                                          
GrievanceId     int,                                                                                                                                                                                                                      
DateReceived     datetime,                                                                                                  
ClientId        int,                                                         
ClientName      varchar(100),                                                                          
DaysLeft        int,     
--Msood Aug 10, 2016                       
ComplainantName varchar(80),
--Msood Aug 10, 2016                                          
Category        varchar(250),  
-- Msood  Aug 10, 2016                                                  
-- About           varchar(100),
 About           varchar(350),                                                            
Status          varchar(100),                                                                          
OrganizationId  int,                                                           
OrganizationName varchar(100),                                                           
ConnectionString varchar(150),
GrievanceType varchar(10),   
Screenid int                                                          
)                                                                    
                                                                      
declare @CustomFilters table (GrievanceId int)                                                  
declare @CustomFiltersApplied char(1)                                       
                             
set @CustomFiltersApplied = ''N'' 
--Below logic Added by Vithobha for Philhaven Development: #250                                         
Declare @OtherCustomProgram varchar(1)
set @OtherCustomProgram = (select [dbo].[ssf_GetSystemConfigurationKeyValue] (''ShowProgramInOtherDropdown'')) 

if @OtherCustomProgram=''Y''
begin
set @CustomFiltersApplied = ''Y''                                               
                                                                    
 insert into @CustomFilters (GrievanceId)                                                                                  
   exec scsp_ListPageGrievancesDetailsFilter    @OrganizationId = @OrganizationId,                                                                            
           @ClientId = @ClientId,                                                              
           @CategoryId = @CategoryId,                                                                            
           @FromDate = @FromDate,                                                                            
           @ToDate = @ToDate,                                                                            
           @ProviderId = @ProviderId,                                                                               
           @StaffId = @StaffId,                                                                            
           @StatusFilter = @StatusFilter,                                                                              
           @Inquiry = @Inquiry,                                                                                                              
           @OtherFilter =  @OtherFilter    
end
else if @StatusFilter > 10000 or @OtherFilter > 10000 
begin                                                                             
	 set @CustomFiltersApplied = ''Y''                                             
	                                                                  
	 insert into @CustomFilters (GrievanceId)                                                                                
	   exec scsp_ListPageGrievancesDetailsFilter    @OrganizationId = @OrganizationId,                                                                          
			   @ClientId = @ClientId,                                                            
			   @CategoryId = @CategoryId,                                                                          
			   @FromDate = @FromDate,                                                                          
			   @ToDate = @ToDate,                                                                          
			   @ProviderId = @ProviderId,                                                                             
			   @StaffId = @StaffId,                                                                          
			   @StatusFilter = @StatusFilter,                                                                            
			   @Inquiry = @Inquiry,                                                                                                            
			   @OtherFilter =  @OtherFilter                                                                                   
end                                                  
                                                  
begin                                          
  insert into @ResultSet(                                          
  GrievanceId,                                                                      
  DateReceived,                                                                                                  
  ClientId,                                                                           
  ClientName,                                                                                                 
  DaysLeft,                                                                                                  
  ComplainantName,                                                                                                  
  Category,                                                                                                  
  About,        
  Status,                                                                           
  OrganizationId,           
  OrganizationName,
  GrievanceType,
  Screenid                                                                          
 )                                                                       
                             
SELECT                                                                           
       GrievanceId                                                                          
      ,Grievances.[DateReceived]                                                 
      ,Grievances.[ClientId]                                                                           
      --Added by Revathi  20-Oct-2015                                                                  
      ,case when  ISNULL(Clients.ClientType,''I'')=''I'' then ISNULL(Clients.LastName,'''') + '', '' + ISNULL(Clients.FirstName,'''') else ISNULL(Clients.OrganizationName,'''') end   as ClientName                                                                                                                                                              
      --,60- DATEDIFF(day,DateReceived, GETDATE()) as DaysLeft             
      ,case when (@StatusFilter=441 and (DateResolved IS NOT NULL)) -- Resolved            
      or (@StatusFilter=446 and (DateResolved IS NOT NULL))            
      then NULL            
      else            
      60-DATEDIFF(day,DateReceived, GETDATE()) end as DaysLeft                                                                         
      ,case when Grievances.ComplainantRelationToClient = 5661 and isnull(Grievances.ComplainantName,'''') = ''''                                                                        
      then Clients.LastName + '', '' + Clients.FirstName else ComplainantName end as ComplainantName                                                                         
      ,GC1.CodeName as  [ComplaintCategory]                                                                          
      ,GC2.CodeName + '': '' + GrievanceAboutName  as about                                                                                   
      ,case when DateAcknowledgedInWriting IS NULL and DateResolved Is null                                                                              
      then ''New''                                                                     
      else                                                           
      Case when  DateAcknowledgedInWriting Is Not null and dateresolved Is null                                                                              
      then                                                                                
      ''Acknowledged''                                                                              
      else ''Resolved''                                                                           
      end                                                                              
      end as Status                                                  
      ,@OrganizationId as ''OrganizationId''                                                                                          
      ,(select OrganizationName from SystemDatabases where SystemDatabaseId=@OrganizationId) as ''OrganizationName'' 
      --Below logic Added by Vithobha for Philhaven Development: #250  
       ,case when Grievances.Inquiry=''Y'' then                                  
        ''Inquiry''                                  
        when Grievances.Inquiry=''N'' then   
           ''Grievances''                            
        end      
		,case when Grievances.Inquiry=''Y'' then                                  
        73                                  
        when Grievances.Inquiry=''N'' then   
           71                           
        end                                                                       
      --,(select Connectionstring from Systemdatabases where systemdatabaseid=@OrganizationId) as ''ConnectionString''                                                             
       FROM [Grievances]                                                                   
                                                                    
   left Join Clients on Grievances.ClientId=Clients.ClientId
   --Added by Revathi on 06 Jan 2014 for task #77 Engineering Improvement Initiatives- NBL(I)
   join Staffclients sc on sc.ClientId=clients.ClientId and sc.StaffId=@LoggedInStaffId                                                   
   Left OUTER JOIN                                                                                
   GlobalCodes GC1 ON  GC1.GlobalCodeId=Grievances.ComplaintCategory                                                                                  
   Left OUTER JOIN                                                       
   GlobalCodes GC2 ON  GC2.GlobalCodeId=Grievances.GrievanceAboutCategory                                                                      
   where                                                    
     ISNULL(Clients.RecordDeleted,''N'')<>''Y''                                                                                         
   and ISNULL(Grievances.RecordDeleted,''N'')<>''Y'' and (@ClientId=0 or Grievances.ClientId=@ClientId) and                                                                       
    --(@CategoryId=10391 or  
      --18 May 2015		Vithobha				Changed the Filter value from GlobalSubCodes to GlobalCodes for Philhaven - Customization Issues Tracking #1269
    (ISNULL(@CategoryId,0) = 0 OR Grievances.ComplaintCategory=@CategoryId)  
    --Below code commented by Vithobha because it was refereeing GlobalSubCodes        
    --(@CategoryId = 417 or                                                 
    --(@CategoryId=10392 and (Grievances.ComplaintCategory=12552)) or                                     
    --(@CategoryId=10393 and (Grievances.ComplaintCategory=12553) ) or                                                             
    --(@CategoryId=10394 and (Grievances.ComplaintCategory=12554) ) or                                                            
    --(@CategoryId=10395 and (Grievances.ComplaintCategory=12555) ) or                                                            
    --(@CategoryId=10396 and (Grievances.ComplaintCategory=12556) ) or                                          
    --(@CategoryId=10397 and (Grievances.ComplaintCategory=12557) ) or                                                            
    --(@CategoryId=10398 and (Grievances.ComplaintCategory=12558) ) or                                    
    --(@CategoryId=10399 and (Grievances.ComplaintCategory=12559) ) or                                                            
    --(@CategoryId=10400 and (Grievances.ComplaintCategory=12560) ) or                                                            
    --(@CategoryId=10401 and (Grievances.ComplaintCategory=12561) ) or                                                            
    --(@CategoryId=10402 and (Grievances.ComplaintCategory=12562) ) or                                                            
    --(@CategoryId=10403 and (Grievances.ComplaintCategory=12563) ) or                                                            
    --(@CategoryId=10404 and (Grievances.ComplaintCategory=12564) ) or                                                            
    --(@CategoryId=10405 and (Grievances.ComplaintCategory=12565) ) or                                                            
    --(@CategoryId=10406 and (Grievances.ComplaintCategory=12566) ) or                                                            
    --(@CategoryId=10407 and (Grievances.ComplaintCategory=12567) ) or                                               
    --(@CategoryId=10408 and (Grievances.ComplaintCategory=12568) ) or                                                            
    --(@CategoryId=10409 and (Grievances.ComplaintCategory=12569) ) or                                   
    --(@CategoryId=10410 and (Grievances.ComplaintCategory=12570) ) or                                                            
    --(@CategoryId=10411 and (Grievances.ComplaintCategory=12571) ) or                                                            
    --(@CategoryId=10412 and (Grievances.ComplaintCategory=12572) ) or                                                            
    --(@CategoryId=10413 and (Grievances.ComplaintCategory=12573) ) or                                                            
    --(@CategoryId=10414 and (Grievances.ComplaintCategory=12574) )                                               
    --)                                                          
   --)                                                            
  --and (                                                      
  --     (@StatusFilter=10415 and (DateAcknowledgedInWriting IS NULL and DateResolved IS NULL)) -- New                                                        
  --      or                                   
  --     (@StatusFilter=418 and(DateAcknowledgedInWriting IS NULL  and DateResolved IS NULL))  -- For Not Resolved                                 
  --     or(@StatusFilter=418 and (DateAcknowledgedInWriting IS NOT NULL and DateResolved IS NULL)) -- For Not Resolved                              
  --     or                                                                             
  --     (@StatusFilter=10416 and (DateAcknowledgedInWriting IS NOT NULL and DateResolved IS NULL)) -- Acknowledged                            
  --      or                                       
  --     (@StatusFilter=10418 and (DateResolved IS NOT NULL)) -- Resolved                                                       
  --     -- or                                                        
  --     --(@StatusFilter=10433 and DateAcknowledgedInWriting IS NOT NULL and DateResolved IS NOT NULL)                                                      
  --   )                               
                              
  and (                 
    (@StatusFilter=446)                  
  or                                               
       (@StatusFilter=439 and (DateAcknowledgedInWriting IS NULL and DateResolved IS NULL)) -- New                                                        
        or                                   
       (@StatusFilter=418 and(DateAcknowledgedInWriting IS NULL  and DateResolved IS NULL))  -- For Not Resolved                                 
       or(@StatusFilter=418 and (DateAcknowledgedInWriting IS NOT NULL and DateResolved IS NULL)) -- For Not Resolved                                                                
       or                                                                             
       (@StatusFilter=440 and (DateAcknowledgedInWriting IS NOT NULL and DateResolved IS NULL)) -- Acknowledged                                                    
        or                                  
       (@StatusFilter=441 and (DateResolved IS NOT NULL)) -- Resolved                                                       
       -- or                                                        
       --(@StatusFilter=10433 and DateAcknowledgedInWriting IS NOT NULL and DateResolved IS NOT NULL)                                                      
     )     
     --Below logic Added by Vithobha for Philhaven Development: #250                                                      
   and (ISNULL(Grievances.Inquiry,''B'')=@Inquiry OR ISNULL(@Inquiry,''B'')=''B'')
   and ((@CustomFiltersApplied = ''Y'' and exists(SELECT * FROM @CustomFilters cf WHERE cf.GrievanceId = Grievances.GrievanceId))
    OR (@CustomFiltersApplied = ''N'')   )                                                                   
	-- Commented folloing condition as per Ryan comment on Task#378                                                                       
	--and(                                               
	--  (@ProviderId=0 and @StaffId=0)                    
	--   or  (GrievanceAboutProviderId=@ProviderId and GrievanceAboutStaffId  is null)                    
	--   or (GrievanceAboutStaffId=@StaffId and GrievanceAboutProviderId is  null)                    
	--  or (@ProviderId=0 and  GrievanceAboutProviderId is Not null )                    
	--  or (@StaffId=0 and  GrievanceAboutStaffId is Not null )                    
	--)      
	--Added following condition as per Ryan comment on Task#378, implement same as in inquiry list pages sp
	AND (GrievanceAboutProviderId=@ProviderId OR @ProviderID = 0)
	AND (GrievanceAboutStaffId = @StaffId OR @StaffId = 0)
                                                          
	and (@FromDate is null or Grievances.DateReceived >= @FromDate)                                                                                       
	and (@ToDate is null or Grievances.DateReceived <dateadd(dd, 1, @ToDate))                                       
                                         
end                                          
                                              
                                          
select                                     
 GrievanceId,                                                                      
 DateReceived,    
 Status,                                       
 ClientId,                                                                           
ClientName,                                                 
 DaysLeft,                                                                                                  
 ComplainantName,                                                                                                  
 Category,                                                   
 About ,                                                                  
 OrganizationId,                                                                          
 OrganizationName,
 GrievanceType,
 Screenid                                                                    
 --ConnectionString                                       
 from @ResultSet                                           
 order by DateReceived desc                                          
                                           
return ' 
END
GO
