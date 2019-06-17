/****** Object:  StoredProcedure [ssp_ListPagePMPrograms]    Script Date: 03/28/2012 12:54:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_ListPagePMPrograms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_ListPagePMPrograms]
GO

/****** Object:  StoredProcedure [ssp_ListPagePMPrograms]    Script Date: 03/28/2012 12:54:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [ssp_ListPagePMPrograms]
@SessionId       varchar(30),  
@InstanceId      int,  
@PageNumber      int,  
@PageSize        int,  
@SortExpression  varchar(100),  
@Status          int,  
@ProgramType     int,  
@ProgramView     int,  
@ServiceAreaId   int,
@OtherFilter     int,  
@StaffId         int,
@programName     varchar(100)   --Added By Atul Pandey  
/*********************************************************************            
-- Stored Procedure: ssp_ListPagePMPrograms  
-- Copyright: Streamline Healthcare Solutions 
-- Creation Date:  30 Mar 2011                        
--                                                   
-- Purpose: returns data for the Programs list page.  
--                                                      
-- Modified Date    Modified By    Purpose  
-- 30 Mar 2011      Veena S Mani   Created.
-- 26 Jul 2011      Girish         Changed Status to int  
-- 29 Aug 2011      MSuma          Included Additional Column ProgramCode for the Grid  
-- 20 Oct 2011      SFarber        Optimized for better repformance.  Removed code related to YTD Charge.
-- 19 Dec 2011		MSuma		   MSuma included Active and primary program check for Staff
-- 28 Mar 2012      PSelvan		   Performance Tuning.
-- 4.04.2012		Ponnin Selvan  Conditions added for Export 	
-- 13.04.2012       PSelvan        Added Conditions for NumberOfPages. 
--25 apr 2012		Atul Pandey	   Added Partial Search by ProgramName  
--24 Nov 2015		Venkatesh MR   Join with Staffclients table and check based on Staff Id While updating enrolled and waiting programs - Ref Task 70 - Valley Support Go Live
-- 28-Feb-2017      Sachin         Added p.Programcode TO filter Programcode wise Task #2348 Core Bugs. 
-- 3-Mar-2018		Deej		   Reverted the change made for Valley SGL#70 and the number client enrolled should match the total number in detail page and shouldn't restrict based on the staff client access in Admin List page.
****************************************************************************/             
as   
BEGIN  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

BEGIN TRY 
create table #ResultSet (                                                    
RowNumber       int,                                                    
PageNumber      int,  
ProgramId       int,  
ProgramName     varchar(250),  
ProgramCode     varchar(100),  
Enrolled        int null,  
Waiting         int null,  
Staff           int null,  
ServiceAreaName varchar(100))                                                    
                                                     
declare @CustomFilters table (ProgramId int)                                                    
declare @ApplyFilterClicked char(1)  
declare @CustomFiltersApplied char(1)  
declare @StartDate datetime
    
if isnull(@SortExpression, '') = ''  
  set @SortExpression= 'ProgramName'  
    

    
--   
-- New retrieve - the request came by clicking on the Apply Filter button                     
--  
set @ApplyFilterClicked = 'Y'   
set @CustomFiltersApplied = 'N'                                                   
--set @PageNumber = 1  
    
--
-- Run custom logic if any custom filter passed
--    
if @OtherFilter > 10000                                      
begin  
  set @CustomFiltersApplied = 'Y'  
     
  insert into @CustomFilters (ProgramId)   
  exec scsp_ListPagePMPrograms   
    @Status        = @Status,  
    @ProgramType   = @ProgramType,  
    @ProgramView   = @ProgramView,  
    @ServiceAreaId = @ServiceAreaId,
    @OtherFilter   = @OtherFilter,  
    @StaffId       = @StaffId,
    @programName   =@programName   --Added By Atul Pandey    
end  
    
insert into #ResultSet (   
       ProgramId  
      ,ProgramName  
      ,ProgramCode  
      ,ServiceAreaName)  
select p.ProgramId        
      ,p.ProgramName
      ,p.ProgramCode
      ,sa.ServiceAreaName
  from Programs p        
       left join ServiceAreas sa on sa.ServiceAreaId = p.ServiceAreaId  
 where isnull(p.RecordDeleted, 'N') = 'N'   
   and ((@CustomFiltersApplied = 'Y' and exists(select * from @CustomFilters cf where cf.ProgramId = p.ProgramId)) OR  
        (@CustomFiltersApplied = 'N'  
         and (isnull(@ProgramView, -1) = -1 or 
              exists(select '*'
                       from ProgramViews pv
                            left join ProgramViewPrograms pvp on pvp.ProgramViewId = pvp.ProgramViewId and isnull(pvp.RecordDeleted, 'N') = 'N'
                      where pv.ProgramViewId = @ProgramView
                        and (pv.AllPrograms = 'Y' or pvp.ProgramId = p.ProgramId)
                        and isnull(pv.RecordDeleted, 'N') = 'N'))
         and (isnull(@Status, -1) = -1 or                     --   All Program states   
              (@Status = 1 and p.Active = 'Y') or             --   Active               
              (@Status = 2 and isnull(p.Active, 'N') = 'N'))  --   InActive  
         and (isnull(@ProgramType, 1) = 1 or p.ProgramType = @ProgramType)  
         and (isnull(@ServiceAreaId, -1) = -1 or p.ServiceAreaId = @ServiceAreaId)))
        -- AND (@programName='' OR p.ProgramName like '%'+@programName+'%')--added by atul pandey  
         AND (@programName='' OR p.ProgramName like '%'+@programName+'%' OR p.Programcode like '%'+@programName+'%')   
       
update rs
   set Enrolled = s.Enrolled,
       Waiting = s.Waiting
  from #ResultSet rs
       join(select rs.ProgramId,
                   sum(case when cp.Status = 4 then 1 else 0 end) as Enrolled,
                   sum(case when cp.Status = 1 then 1 else 0 end) as Waiting
              from #ResultSet rs
                   join ClientPrograms cp on cp.ProgramId = rs.ProgramId
                   join Clients c on c.ClientId = cp.ClientId
                   -- Added by Venkatesh for task 70 -- commented by deej 9-march-2018
                  -- INNER JOIN StaffClients sc ON sc.StaffId = @StaffId AND sc.ClientId = c.ClientId  
             where cp.Status in (1, 4)  
               and isnull(cp.RecordDeleted, 'N') = 'N'        
               and isnull(c.RecordDeleted, 'N') = 'N'  
             group by rs.ProgramId) as s on s.ProgramId = rs.ProgramId
           
update rs
   set Staff = s.Staff
  from #ResultSet rs
       join(select rs.ProgramId,
                   count(*) as Staff
              from #ResultSet rs
                   join StaffPrograms sp on sp.ProgramId = rs.ProgramId
                   join Staff s on s.StaffId = sp.StaffId
             where isnull(sp.RecordDeleted, 'N') = 'N'        
               and isnull(s.RecordDeleted, 'N') = 'N' 
               --MSUma included Active and primary program check for Staff
               and s.Active = 'Y' 
               and s.PrimaryProgramId = sp.ProgramId
             group by rs.ProgramId) as s on s.ProgramId = rs.ProgramId


 ; with   counts as ( 
    select count(*) as totalrows from #ResultSet
    ),

             
		 RankResultSet
                      AS ( SELECT   ProgramId  
        ,ProgramName  
        ,ProgramCode  
        ,Enrolled  
        ,Waiting  
        ,Staff  
        ,ServiceAreaName   ,
                                    COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY  
                                                               case when @SortExpression= 'ProgramName'          then ProgramName end,                                    
                                                               case when @SortExpression= 'ProgramName desc'     then ProgramName end desc,     
                                                               case when @SortExpression= 'ProgramCode'          then ProgramCode end,                                    
                                                               case when @SortExpression= 'ProgramCode desc'     then  ProgramCode end desc,                                         
                                                               case when @SortExpression= 'Enrolled'             then Enrolled end,                                              
                                                               case when @SortExpression= 'Enrolled desc'        then Enrolled end desc,  
                                                               case when @SortExpression= 'Waiting'              then Waiting end,                                    
                                                               case when @SortExpression= 'Waiting desc'         then Waiting end desc,  
                                                               case when @SortExpression= 'Staff'                then Staff end,                                    
                                                               case when @SortExpression= 'Staff desc'           then Staff end desc,  
                                                               case when @SortExpression= 'ServiceAreaName'      then ServiceAreaName end,                                    
                                                               case when @SortExpression= 'ServiceAreaName desc' then ServiceAreaName end desc,  
                                ProgramId ) AS RowNumber
                           FROM     #ResultSet
                           )
                           
                           SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
                         ProgramId  
						,ProgramName  
						,ProgramCode  
						,Enrolled  
						,Waiting  
						,Staff  
						,ServiceAreaName   
						,RowNumber
                        ,TotalCount 
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
            
             SELECT   ProgramId,  
       ProgramName,  
       Programcode,  
       Enrolled,  
       Waiting,  
       Staff,  
       ServiceAreaName  
            FROM    #FinalResultSet
            ORDER BY RowNumber     
            
            	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPagePMPrograms')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + Convert(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
GO


