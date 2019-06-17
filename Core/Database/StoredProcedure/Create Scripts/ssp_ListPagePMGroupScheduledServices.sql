/****** Object:  StoredProcedure [dbo].[ssp_ListPagePMGroupScheduledServices]    Script Date: 07/31/2012 11:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPagePMGroupScheduledServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPagePMGroupScheduledServices]
GO

Create procedure [dbo].[ssp_ListPagePMGroupScheduledServices]  
@SessionId varchar(30),                                          
@InstanceId int,                                          
@PageNumber int,                                              
@PageSize int,                                              
@SortExpression varchar(100),                                          
@GroupId int,                                                
@DateFromFilter datetime,                                                
@DateToFilter datetime,                                                
@ServiceStatusFilter int,                                          
@OtherFilter int,    
@LoggedInStaffId int    
/********************************************************************************                                          
-- Stored Procedure: ssp_ListPagePMGroupScheduledServices                                            
--                                          
-- Copyright: Streamline Healthcate Solutions                                          
--                                          
-- Purpose: used by Group Details screen                                         
--                                          
-- Updates:                                                                                                 
-- Date         Author      Purpose                                          
-- 04.24.2011   SFarber     Created.    
-- 05/25/2012   RAkesh-II   Modified (after marking  service as error, it show be shown:: comment condition  s.Status <> 76 )                                          
-- 03.20.2013 Wasif Butt Modified (fixed the where filters, pulled the gs.GroupId = @GroupId and record delete checks out of the OR statement)  
-- 19.08.2014 Venkatesht Modified (Exclude the error status services in the list page) 
-- 8/18/2015	Chethan N	What : Changed Join to Left Join On services table
							Why: Philhaven - Customization Issues Tracking task# 1326 
*********************************************************************************/                                          
as          
BEGIN                
BEGIN TRY                                                                                                        
create table #ResultSet(                                          
RowNumber       int,                                          
PageNumber      int,     
GroupId   int,                                        
GroupServiceId  int,                                          
NumberOfClients int,    
DateOfService   datetime,                                                                      
Status          varchar(50),    
Recurrence      varchar(250),    
StaffId1        int,                          
StaffName1      varchar(100),                                                                      
StaffId2        int,                          
StaffName2      varchar(100),                                                                      
StaffId3        int,                          
StaffName3      varchar(100),                                                                      
StaffId4        int,                          
StaffName4      varchar(100))                                          
                                          
declare @CustomFilters table (GroupServiceId int)                                          
declare @ApplyFilterClicked char(1)                                          
declare @CustomFiltersApplied char(1)    
                                             
set @ApplyFilterClicked = 'Y'                                          
set @PageNumber = 1                                              
set @CustomFiltersApplied = 'N'                                 
                                     -- Get custom filters                          
if @OtherFilter > 10000 or @ServiceStatusFilter > 10000             
begin    
    
 set @CustomFiltersApplied = 'Y'                       
       
 insert into @CustomFilters (GroupServiceId)                          
 exec scsp_ListPagePMGroupScheduledServices @GroupId = @GroupId,                                                
                                             @DateFromFilter = @DateFromFilter,                                                
                                             @DateToFilter = @DateToFilter,                                                
                                             @ServiceStatusFilter = @ServiceStatusFilter,                                          
                                             @OtherFilter = @OtherFilter,    
                                             @LoggedInStaffId = @LoggedInStaffId    
end                          
                            
insert into #ResultSet (    
    GroupId,                                                     
       GroupServiceId,                                          
       NumberOfClients,    
       DateOfService,                                                                      
       Status)                                                   
select min(gs.GroupId),    
    gs.GroupServiceId,    
       count(distinct s.ClientId),    
       min(gs.DateOfService),    
       dbo.SCGetGroupServiceStatusName(gs.GroupServiceId)    
  from GroupServices gs     
       Left join Services s on s.GroupServiceId = gs.GroupServiceId   and  s.Status <> 76   
 where   
    gs.GroupId = @GroupId      
    and  isnull(gs.RecordDeleted, 'N') = 'N'    
    and  isnull(s.RecordDeleted, 'N') = 'N'
 AND (    
        (@CustomFiltersApplied = 'Y' and exists(select * from @CustomFilters cf where cf.GroupServiceId = gs.GroupServiceId)) or    
        (@CustomFiltersApplied = 'N'     
    --below line commented By Rakesh-II on 25 May 2012(this is done bcz after mark error group service was not showing ) 
    -- As per discussion with Javed we should not show the Error status services in the list page as per task 592 core bugs 
              
    and (@DateFromFilter is null or gs.DateOfService >= @DateFromFilter)                                                     
    and (@DateToFilter is null or gs.DateOfService < dateadd(dd, 1, @DateToFilter))    
    and (@ServiceStatusFilter in (0, 484) or                                                           -- All Statuses    
      --Below new filter added By Rakesh-II on 06 Aug , 2012 W.r.t. Task #1720 in(Threshold Bugs & Features)   
         (@ServiceStatusFilter = 5004 and dbo.SCGetGroupServiceStatus(gs.GroupServiceId) =71) or -- Show                              
         (@ServiceStatusFilter = 487 and dbo.SCGetGroupServiceStatus(gs.GroupServiceId) in (70,71)) or -- Scheduled/Show                                         
         (@ServiceStatusFilter = 486 and dbo.SCGetGroupServiceStatus(gs.GroupServiceId) = 70) or       -- Scheduled                              
         (@ServiceStatusFilter = 485 and dbo.SCGetGroupServiceStatus(gs.GroupServiceId) = 75))         -- Complete       
         )    
        )                       
 group by gs.GroupServiceId    
                       
-- Get staff                        
update r                          
   set StaffId1 = s.StaffId,    
       StaffName1 = s.LastName + ', ' + s.FirstName                          
  from #ResultSet r                          
       join GroupServiceStaff gss on gss.GroupServiceId = r.GroupServiceId                          
       join Staff s on s.StaffId = gss.StaffId    
 where isnull(gss.RecordDeleted, 'N') = 'N'    
            
update r                          
   set StaffId2 = s.StaffId,    
       StaffName2 = s.LastName + ', ' + s.FirstName                          
  from #ResultSet r                          
       join GroupServiceStaff gss on gss.GroupServiceId = r.GroupServiceId                          
       join Staff s on s.StaffId = gss.StaffId    
 where isnull(gss.RecordDeleted, 'N') = 'N'    
   and s.StaffId not in (r.StaffId1)    
     
update r                          
    set StaffId3 = s.StaffId,    
        StaffName3 = s.LastName + ', ' + s.FirstName                          
   from #ResultSet r                          
        join GroupServiceStaff gss on gss.GroupServiceId = r.GroupServiceId                          
        join Staff s on s.StaffId = gss.StaffId    
  where isnull(gss.RecordDeleted, 'N') = 'N'    
    and s.StaffId not in (r.StaffId1, r.StaffId2)       
         
update r                          
    set StaffId4 = s.StaffId,    
        StaffName4 = s.LastName + ', ' + s.FirstName                          
   from #ResultSet r                          
        join GroupServiceStaff gss on gss.GroupServiceId = r.GroupServiceId                          
        join Staff s on s.StaffId = gss.StaffId    
  where isnull(gss.RecordDeleted, 'N') = 'N'    
    and s.StaffId not in (r.StaffId1, r.StaffId2, r.StaffId3)     
                              
-- Get recurring pattern    
update r    
   set Recurrence = rgs.RecurrenceDescription    
  from #ResultSet r    
       join RecurringGroupServicesProcessLog rgsp on rgsp.GroupServiceId = r.GroupServiceId    
       join RecurringGroupServices rgs on rgs.RecurringGroupServiceId = rgsp.RecurringGroupServiceId     
    
                                       
                                    
set @PageNumber = 1                                          
                                          
   ; with   counts as ( 
    select count(*) as totalrows from #ResultSet
    ),

             
   RankResultSet
                      AS ( select GroupId,    
								GroupServiceId,    
       NumberOfClients,    
       DateOfService,    
       Status,    
       Recurrence,    
       StaffName1,    
       StaffName2,    
       StaffName3,    
       StaffName4                                   ,                                          
       COUNT(*) OVER ( ) AS TotalCount,
         row_number() over (order by                                           
                                            case when @SortExpression= 'NumberOfClients' then NumberOfClients end,                                              
                                            case when @SortExpression= 'NumberOfClients desc' then NumberOfClients end desc,                                           
                                            case when @SortExpression= 'DateOfService' then DateOfService end,                                              
                                            case when @SortExpression= 'DateOfService desc' Then DateOfService end desc,                                          
                                            case when @SortExpression= 'Status' then Status end,                                              
                                            case when @SortExpression= 'Status desc' Then Status end desc,                                          
                                            case when @SortExpression= 'StaffName1' then StaffName1 end,                                              
                                            case when @SortExpression= 'StaffName1 desc' then StaffName1 end desc,                                          
                                            case when @SortExpression= 'StaffName2' then StaffName1 end,                                              
                                            case when @SortExpression= 'StaffName2 desc' then StaffName1 end desc,                                          
                                            case when @SortExpression= 'StaffName3' then StaffName1 end,                                              
                                            case when @SortExpression= 'StaffName3 desc' then StaffName1 end desc,                                          
                                            case when @SortExpression= 'StaffName4' then StaffName1 end,                                              
                                            case when @SortExpression= 'StaffName4 desc' then StaffName1 end desc,                                          
                                            GroupServiceId) AS RowNumber                                     
                                       from #ResultSet 
                      )
                      
                     
                           
       SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
       GroupId,    
	   GroupServiceId,    
       NumberOfClients,    
       DateOfService,    
       Status,    
       Recurrence,    
       StaffName1,    
       StaffName2,    
       StaffName3,    
       StaffName4,                        
       RowNumber,
       TotalCount 
		INTO    #FinalResultSet
		FROM    RankResultSet
		WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )  
		IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1
             BEGIN
                    SELECT 0 AS PageNumber ,
                    0 AS NumberOfPages ,
                    0 NumberOfRows
                  END
             ELSE
  BEGIN
    SELECT TOP 1
                    @PageNumber AS PageNumber ,
                    CASE (TotalCount % @PageSize) WHEN 0 THEN 
                    ISNULL(( TotalCount / @PageSize ), 0)
                    ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
                    ISNULL(TotalCount, 0) AS NumberOfRows
            FROM    #FinalResultSet  
            END
            
       SELECT   GroupId,    
		GroupServiceId,    
       NumberOfClients,    
       DateOfService,    
       Status,    
       Recurrence,    
       StaffName1,    
       StaffName2,    
       StaffName3,    
       StaffName4                      
            FROM    #FinalResultSet
            ORDER BY RowNumber
  
END TRY                
BEGIN CATCH                
 DECLARE @Error varchar(8000)                                                               
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPagePMGroupScheduledServices')                                                                                             
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                              
    + '*****' + Convert(varchar,ERROR_STATE())                                          
 RAISERROR                                                                                             
 (                   
   @Error, -- Message text.                                                                                            
   16, -- Severity.                                                                                            
   1 -- State.                                                                                            
  );                 
END CATCH                
END   
