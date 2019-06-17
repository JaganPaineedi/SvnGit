
/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCProgramList]    Script Date: 07/19/2016 15:39:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCProgramList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCProgramList]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCProgramList]    Script Date: 07/19/2016 15:39:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create procedure [dbo].[ssp_ListPageSCProgramList]  
@SessionId varchar(30),                                                      
@InstanceId int,                                                      
@PageNumber int,                                                          
@PageSize int,                                                          
@SortExpression varchar(100),                                                      
@ClientId int,                                      
@ProgramsFilter int,                                                      
@ProgramStatusFilter int,                                  
@OtherFilter int,        
@StaffId int ,  
@ProgramType    INT,
@CurrentPageScreenId INT=NULL  
 
/********************************************************************************/                                                    
-- Stored Procedure: dbo.ssp_ListPageSCProgramList                                                        
--                                                      
-- Copyright: Streamline Healthcate Solutions                                                      
--                                                      
-- Purpose: used by  Attach/Review Claims list page                                                      
--                                                      
-- Updates:                                                                                                             
-- Date        Author      Purpose                                                      
-- 06.01.2010  Ankesh      Created.         
-- 11.04.2010  SFarber     Redesigned.  
-- 16.10.2011  MSuma	   Modified Clinician to AssignedStaff and included TryCatch Block    
-- 31.10.2011  MSuma	   Commented and moved the filter to join by MSuma to fix ACE 387    
-- 06.01.2011  MSuma	   Included additional status for Not Discharged
-- 07.03.2011  PSelvan     Redesigned for Performance Tunning.     
-- 12.03.2012  PSelvan     Removed default @PageNumber  
-- 23/03/2012  Amit Kumar Srivastava  Added a parameter @ProgramType 
-- 31.03.2012  MSuma		Fixed the filter on Program status which has been uncommented       
-- 4.04.2012   PSelvan		Conditions added for Export                             
-- 12.04.2012  MSuma		Removed Temp table                             
-- 13.04.2012  PSelvan      Added Conditions for NumberOfPages.
-- 01.02.2013  Sunilkh      Change the sorting Implemetation after the cte and put the result in a new tem table for task
--							PrimaryCare Bugs/Features 195   
-- 02.07.2013 Atul Pandey   What :Selected Top 1  totalcount from #FinalResultSet-Why  :#FinalResultSet contain more than 1 row and its throwing subquery error ,What :Modified condition to pagenumber=0-Why  :To select all record when @pagenumber=0 i.e. while exporting
--14 Feb 2013 Saurav Pande  Top was giving error in case of client "84176". Added Top 1 task #509 in Centra Wellness Bugs and Features.
--19 feb 2013 sunilkh	    remove top 1 and also check for task #509 in Centra Wellness Bugs and Features(2768 thresholds bugs/Features)
--01/july/2015 Basudev Sahu	Modified the ProgramStatusFilter value to filter GlobalCodeId instead of GlobalSubCodeId For Core Bug  Task #1810
--08/June/2016 Pabitra       What:TRR Tracks should not be shown on Program List Page (Client Tab/ Program Tab) Added Parameter @CurrentPageScreenId
 --                              Why:Task #4  Camino - Support Go Live  
/*********************************************************************************/                                                      
as         
   
 BEGIN
 BEGIN TRY                                                
   CREATE TABLE #ResultSet
                (
					ClientProgramId			INT NOT NULL ,
					ClientId				int, 
					ProgramCode				varchar(max),
					ProgramId				int, 
					[Status]				varchar(50), 
					EnrolledDate			datetime  ,  
					DischargedDate			datetime, 
					ClinicianName			varchar(250),   
					PrimaryAssignment		varchar(10),                                  
					LastDateOfService     datetime,              
					LastServiceId         int,                        
					LastServiceDocumentId int,                        
					NextDateOfService     datetime,                   
					NextServiceId         int,                        
					NextServiceDocumentId int
               )
                
    CREATE TABLE #CustomFilters(ClientProgramId INT NOT NULL)
    
    
  --Pabitra 06/08/2016
------Begin---

CREATE TABLE #ExcludePrograms(ProgramsType VARCHAR(500) NULL)
CREATE TABLE #tempExcludeProgramTYPE(ProgramsTypeList VARCHAR(500) NULL)

DECLARE @ExcludePrograms CHAR(500)    
SELECT @ExcludePrograms = ScreenParamters FROM Screens WHERE ScreenId=@CurrentPageScreenId 
INSERT INTO  #tempExcludeProgramTYPE(ProgramsTypeList)
SELECT item  FROM [dbo].fnSplit(@ExcludePrograms, '^')


DECLARE @ExcludeProgramTYPE CHAR(500) =  (SELECT  TOP 1 Substring(ProgramsTypeList, Charindex('=', ProgramsTypeList)+1, LEN(ProgramsTypeList)) from #tempExcludeProgramTYPE where ProgramsTypeList like 'EXCLUDEPROGRAMTYPE=%' )
INSERT INTO  #ExcludePrograms(ProgramsType)
select item  from [dbo].fnSplit(@ExcludeProgramTYPE, ',') 
-------End--- 
declare @Today datetime                                                      
declare @ApplyFilterClicked char(1)   
declare @CustomFiltersApplied char(1)                                                     
DECLARE @FetchedRecords INT  

set @ApplyFilterClicked = 'Y'                                                      
set @CustomFiltersApplied = 'N'  
set @Today = convert(char(10), getdate(), 101)                                  

 
-- Get custom filters                        
if @ProgramStatusFilter > 10000 or @OtherFilter > 10000                  
begin  
set @CustomFiltersApplied = 'Y'  

  insert into #CustomFilters (ClientProgramId)                        
  exec scsp_ListPageSCProgramList @ClientId = @ClientId,                                      
                                  @ProgramsFilter = @ProgramsFilter,                                                      
                                  @ProgramStatusFilter = @ProgramStatusFilter,                                  
                                  @OtherFilter = @OtherFilter ,
                                  @ProgramType= @ProgramType     
  
end                   
    

  insert into #ResultSet(                                                    
					ClientProgramId ,
					ClientId, 
					ProgramCode,
					ProgramId, 
					[Status] , 
					EnrolledDate ,  
					DischargedDate, 
					ClinicianName,   
					PrimaryAssignment,                                  
					LastDateOfService,              
					LastServiceId ,                        
					LastServiceDocumentId,                        
					NextDateOfService,                   
					NextServiceId,                        
					NextServiceDocumentId 
					  )                                                                  
				select cp.ClientProgramId,                           
					   cp.ClientId,                          
					   --p.ProgramName,       
					   P.ProgramCode,
					   p.ProgramId,                         
					   gc.codeName as [Status],                  
					   cp.EnrolledDate,                          
					   cp.DischargedDate,                          
					   s.LastName + ', ' + s.FirstName as ClinicianName,                              
					   case cp.PrimaryAssignment when 'Y' then 'Yes' else 'No' end  as  PrimaryAssignment , 
					   null as LastDateOfService,          
						null as LastServiceId,                      
						null as LastServiceDocumentId,                      
						null as NextDateOfService    ,               
						null as NextServiceId,                     
						null as NextServiceDocumentId                 
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
  --AND (p.ProgramType =@ProgramType or ISNULL(@ProgramType,-1) = -1)
  AND (p.ProgramType =@ProgramType or (ISNULL(@ProgramType,-1) = -1 AND (not exists(select 1 from  #ExcludePrograms where ProgramsType=p.ProgramType))) )  
 and (  
        (@CustomFiltersApplied = 'Y' and exists(select * from #CustomFilters cf where cf.ClientProgramId = cp.ClientProgramId)) or  
        (@CustomFiltersApplied = 'N'     
     and (p.ProgramId = @ProgramsFilter or isnull(@ProgramsFilter, -1) <= 0)  
   --  and (@ProgramStatusFilter in (0, 1233) or               -- All Statuses        
   --      (@ProgramStatusFilter = 234 and cp.Status = 1) or   -- Requested  
   --      (@ProgramStatusFilter = 235 and cp.Status = 3) or   -- Scheduled                      
   --      (@ProgramStatusFilter = 236 and cp.Status = 4) or   -- Enrolled                        
   --      (@ProgramStatusFilter = 237 and cp.Status = 5) or   -- Discharged   
   ----      --Added by MSuma to include Not Discharged
   --      (@ProgramStatusFilter = -3   and cp.Status <> 5)))) -- Not Discharged 
        
        -- 07/01/2015   Basudev Sahu    Modified the ProgramStatusFilter value to filter GlobalCodeId instead of GlobalSubCodeId Task #1810
 
         -- 01/july/2015 Basudev Sahu
			AND (@ProgramStatusFilter = -1 OR         -- All Statuses  
			 (cp.[Status] = @ProgramStatusFilter)   OR
			(@ProgramStatusFilter = -3   and cp.[Status] <> 5)))) 


			
			
	update r    
   set LastDateOfService = s.DateOfService,                            
       LastServiceId = s.ServiceId,                            
       LastServiceDocumentId = d.DocumentId                            
  from #ResultSet as r                            
       join Services as s on s.ClientId = r.ClientId    
       left join Documents as d on d.ServiceId = s.ServiceId    
 where s.ClientId = @ClientId    
   and s.ProgramId = r.ProgramId    
   and s.Status in (71, 75)    
   and isnull(s.RecordDeleted, 'N') = 'N'            
   and not exists (select *        
                     from Services as s2            
                    where s2.ClientId = s.ClientId        
                      and s2.ProgramId = s.ProgramId        
                      and s2.Status in (71, 75)            
                      and s2.DateOfService > s.DateOfService            
                      and isnull(s2.RecordDeleted, 'N') = 'N')                            
                            
update r    
   set NextDateOfService = s.DateOfService,                            
       NextServiceId = s.ServiceId,                            
       NextServiceDocumentId = d.DocumentId                            
  from #ResultSet as r                            
       join Services as s on s.ClientId = r.ClientId    
       left join Documents as d on d.ServiceId = s.ServiceId    
 where s.ClientId = @ClientId    
   and s.ProgramId = r.ProgramId    
   and s.Status = 70    
   and s.DateOfService >= @Today    
   and isnull(s.RecordDeleted, 'N') = 'N'       
   and not exists (select *            
                     from Services as s2            
                    where s2.ClientId = s.ClientId        
                      and s2.ProgramId = s.ProgramId        
                      and s2.Status = 70           
                      and s2.DateOfService >= @Today    
                      and s2.DateOfService < s.DateOfService            
                      and isnull(s2.RecordDeleted, 'N') = 'N') 
                      
                      
    
    
    ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientProgramId ,
					ClientId, 
					ProgramCode,
					ProgramId, 
					[Status] , 
					EnrolledDate ,  
					DischargedDate, 
					ClinicianName,   
					PrimaryAssignment,                                  
					LastDateOfService,              
					LastServiceId ,                        
					LastServiceDocumentId,                        
					NextDateOfService,                   
					NextServiceId,                        
					NextServiceDocumentId                          
				,Count(*) OVER () AS TotalCount
				, ROW_NUMBER() OVER ( ORDER BY case when @SortExpression= 'ProgramCode' then ProgramCode end,                                      
							case when @SortExpression= 'ProgramCode desc' then ProgramCode end desc,                                            
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
							case when @SortExpression= 'LastDateOfService' then ISNULL(LastDateOfService,'') end,                                                
							case when @SortExpression= 'LastDateOfService desc' then ISNULL(LastDateOfService,'') end desc,                                            
							case when @SortExpression= 'NextDateOfService' then ISNULL(NextDateOfService,'')  end,                                
							case when @SortExpression= 'NextDateOfService desc' then ISNULL(NextDateOfService,'') end desc, 
							ClientProgramId
		) RowNumber                                               
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ClientProgramId ,
					ClientId, 
					ProgramCode,
					ProgramId, 
					[Status] , 
					EnrolledDate ,  
					DischargedDate, 
					ClinicianName,   
					PrimaryAssignment,                                  
					LastDateOfService,              
					LastServiceId ,                        
					LastServiceDocumentId,                        
					NextDateOfService,                   
					NextServiceId,                        
					NextServiceDocumentId ,                              
			 TotalCount,
			 RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
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
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT		ClientProgramId ,
					ClientId, 
					ProgramCode,
					ProgramId, 
					[Status] , 
					EnrolledDate ,  
					DischargedDate, 
					ClinicianName,   
					PrimaryAssignment,                                  
					LastDateOfService,              
					LastServiceId ,                        
					LastServiceDocumentId,                        
					NextDateOfService,                   
					NextServiceId,                        
					NextServiceDocumentId       
		FROM #FinalResultSet
		ORDER BY RowNumber 
		

DROP TABLE #CustomFilters
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPageSCProgramList')                                                                                             
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


