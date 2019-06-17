IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_ListPagePMClientPrograms]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_ListPagePMClientPrograms]
GO


SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[ssp_ListPagePMClientPrograms]  
@SessionId varchar(30),                                                      
@InstanceId int,                                                      
@PageNumber int,                                                          
@PageSize int,                                                          
@SortExpression varchar(100),                                                      
@ClientId int,                                      
@ProgramsFilter int,                                                      
@ProgramStatusFilter int,                                  
@OtherFilter int,        
@StaffId int   
/********************************************************************************                                                      
-- Stored Procedure: dbo.ssp_ListPagePMClientPrograms                                                        
--                                                      
-- Copyright: Streamline Healthcate Solutions                                                      
--                                                      
-- Purpose: used by  Program Assignment list page                                                      
--                                                      
-- Updates:                                                                                                             
-- Date        Author       Purpose                                                      
-- 22.12.2011  Malathi      Created.         
-- 06.01.2011  MSuma	   Included additional status for Not Discharged                                            
-- 12.03.2012  Ponnin Selvan Removed default @PageNumber  
-- 4.04.2012   Ponnin Selvan Conditions added for Export         
-- 12.04.2012	MSuma		Dropped table #CustomFilters
-- 13.04.2012   PSelvan     Added Conditions for NumberOfPages.   
-- 01/july/2015 Basudev Sahu  Modified the ProgramStatusFilter value to filter GlobalCodeId instead of GlobalSubCodeId For Core Bug Task #1810
                          
*********************************************************************************/                                                      
as         
   
 BEGIN
 BEGIN TRY                                                
  CREATE TABLE #CustomFilters
                (
                  ClientProgramId INT NOT NULL 
                )                                                     
                                                     
                                                      
declare @Today datetime                                                      
declare @ApplyFilterClicked char(1)   
declare @CustomFiltersApplied char(1)                                                     
  
                                                                                                      
     
--                                                      
-- New retrieve - the request came by clicking on the Apply Filter button                       
--                                                      
                                                      
set @ApplyFilterClicked = 'Y'                                                      
--set @PageNumber = 1                                             
set @Today = convert(char(10), getdate(), 101)                                   
set @CustomFiltersApplied = 'N'  
  
-- Get custom filters                        
if @ProgramStatusFilter > 10000 or @OtherFilter > 10000                  
begin  
  
  set @CustomFiltersApplied = 'Y'                        
    
  insert into #CustomFilters (ClientProgramId)                        
  exec scsp_ListPageSCProgramList @ClientId = @ClientId,                                      
                                  @ProgramsFilter = @ProgramsFilter,                                                      
                                  @ProgramStatusFilter = @ProgramStatusFilter,                                  
                                  @OtherFilter = @OtherFilter  
  
end                   
                                                                 
	 --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED 
  --          (
  --          [ClientProgramId] ASC
  --          ) 
            
            
	;WITH ListPagePMClientProgram
	AS
	(                           
select cp.ClientProgramId,                           
       cp.ClientId,                          
       p.ProgramCode as ProgramName,       
       p.ProgramId,                         
       gc.codeName as [Status],                  
       cp.EnrolledDate,                          
       cp.DischargedDate,                          
       s.LastName + ', ' + s.FirstName as ClinicianName,                              
       case cp.PrimaryAssignment when 'Y' then 'Yes' else 'No' end  as  PrimaryAssignment                          
  from Clients as c                          
       join ClientPrograms as cp on cp.ClientId = c.ClientId     and isnull(cp.RecordDeleted, 'N') = 'N'                        
       join Programs as p on p.ProgramId = cp.ProgramId          and isnull(p.RecordDeleted, 'N') = 'N'                
       join Globalcodes as gc on gc.GlobalCodeId = cp.Status    
        -- Modifed for CR on AssignedStaffId
       --left join Staff as s on s.StaffId = c.PrimaryClinicianId  
        left join Staff as s on s.StaffId = cp.AssignedStaffId                       
 where c.ClientId =  @ClientId  
   --Commented and moved the filter to join by MSuma to fix ACE 387
   --and isnull(cp.RecordDeleted, 'N') = 'N'                         
   --and isnull(p.RecordDeleted, 'N') = 'N'  
   and (  
        (@CustomFiltersApplied = 'Y' and exists(select * from #CustomFilters cf where cf.ClientProgramId = cp.ClientProgramId)) or  
        (@CustomFiltersApplied = 'N'     
     and (p.ProgramId = @ProgramsFilter or isnull(@ProgramsFilter, -1) <= 0)  
     --and (@ProgramStatusFilter in (0, 1233) or               -- All Statuses        
     --    (@ProgramStatusFilter = 234 and cp.Status = 1) or   -- Requested  
     --    (@ProgramStatusFilter = 235 and cp.Status = 3) or   -- Scheduled                      
     --    (@ProgramStatusFilter = 236 and cp.Status = 4) or   -- Enrolled                        
     --    (@ProgramStatusFilter = 237 and cp.Status = 5) or   -- Discharged      
     --    --Added by MSuma to include Not Discharged                                               
     --    (@ProgramStatusFilter = -3   and cp.Status <> 5)))) -- Not Discharged
      -- 01/july/2015 Basudev Sahu
      
	AND (@ProgramStatusFilter = -1 OR         -- All Statuses  
		 (cp.[Status] = @ProgramStatusFilter)   OR
			(@ProgramStatusFilter = -3   and cp.Status <> 5))))         -- Not Discharged      
             
--update r  
--   set LastDateOfService = s.DateOfService,                          
--       LastServiceId = s.ServiceId,                          
--       LastServiceDocumentId = d.DocumentId                          
--  from #ResultSet as r                          
--       join Services as s on s.ClientId = r.ClientId  
--       left join Documents as d on d.ServiceId = s.ServiceId  
-- where s.ClientId = @ClientId  
--   and s.ProgramId = r.ProgramId  
--   and s.Status in (71, 75)  
--   and isnull(s.RecordDeleted, 'N') = 'N'          
--   and not exists (select *      
--                     from Services as s2          
--                    where s2.ClientId = s.ClientId      
--                      and s2.ProgramId = s.ProgramId      
--                      and s2.Status in (71, 75)          
--                      and s2.DateOfService > s.DateOfService          
--                      and isnull(s2.RecordDeleted, 'N') = 'N')                          
                          
--update r  
--   set NextDateOfService = s.DateOfService,                          
--       NextServiceId = s.ServiceId,                          
--       NextServiceDocumentId = d.DocumentId                          
--  from #ResultSet as r                          
--       join Services as s on s.ClientId = r.ClientId  
--       left join Documents as d on d.ServiceId = s.ServiceId  
-- where s.ClientId = @ClientId  
--   and s.ProgramId = r.ProgramId  
--   and s.Status = 70  
--   and s.DateOfService >= @Today  
--   and isnull(s.RecordDeleted, 'N') = 'N'     
--   and not exists (select *          
--                     from Services as s2          
--                    where s2.ClientId = s.ClientId      
--                      and s2.ProgramId = s.ProgramId      
--                      and s2.Status = 70         
--                      and s2.DateOfService >= @Today  
--                      and s2.DateOfService < s.DateOfService          
--                      and isnull(s2.RecordDeleted, 'N') = 'N')                          
        ),
        
            counts as ( 
    select count(*) as totalrows from ListPagePMClientProgram
    ),
                   
RankResultSet
as

(                                             
			SELECT
			ClientProgramId,                   
         ClientId,                                                    
         ProgramName,      
         ProgramId,                        
         [Status],                        
         EnrolledDate,                        
         DischargedDate,                        
         ClinicianName,                        
         PrimaryAssignment,           
		 COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY case when @SortExpression= 'ProgramName' then ProgramName end,                                      
                                                case when @SortExpression= 'ProgramName desc' then ProgramName end desc,                                            
                                                case when @SortExpression= 'Status' then [Status] end ,                                                
                                                case when @SortExpression= 'Status desc' then [Status] end desc,                                
                                                case when @SortExpression= 'EnrolledDate' then EnrolledDate end,                                                
                                                case when @SortExpression= 'EnrolledDate desc' Then EnrolledDate  end  DESC,      
                                                case when @SortExpression= 'DischargedDate' then DischargedDate end,                                                
                                                case when @SortExpression= 'DischargedDate desc' Then DischargedDate end desc,                                             
                                                case when @SortExpression= 'ClinicianName' then ClinicianName end,                                                
                                                case when @SortExpression= 'ClinicianName desc' then ClinicianName end desc,                                            
                                                case when @SortExpression= 'PrimaryAssignment' then PrimaryAssignment end,                                                
                                                case when @SortExpression= 'PrimaryAssignment desc' then PrimaryAssignment end desc,                                            
                                                ClientProgramId
				)  AS RowNumber
                           FROM     ListPagePMClientProgram
				 )
                                            

        SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
							 ClientProgramId,                   
							 ClientId,                                                    
							 ProgramName,      
							 ProgramId,                        
							 [Status],                        
							 EnrolledDate,                        
							 DischargedDate,                        
							 ClinicianName,                        
							 PrimaryAssignment,
							 TotalCount ,
							 RowNumber
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

            SELECT  ClientProgramId,                   
         ClientId,                                                    
         ProgramName,      
         ProgramId,                        
         [Status],                        
         EnrolledDate,                        
         DischargedDate,                        
         ClinicianName,                        
         PrimaryAssignment	
            FROM    #FinalResultSet
            ORDER BY RowNumber   
                                     
   DROP TABLE #CustomFilters                
	
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPagePMClientPrograms')                                                                                             
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
