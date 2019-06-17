/****** Object:  StoredProcedure [dbo].[ssp_SCListPageDisclosureServiceList]    Script Date: 11/18/2011 16:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageDisclosureServiceList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageDisclosureServiceList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE procedure [dbo].[ssp_SCListPageDisclosureServiceList]                  
@SessionId varchar(30),                                        
@InstanceId int,                                        
@PageNumber int,                                            
@PageSize int,                                            
@SortExpression varchar(100),                                        
@ClinicianId int,                                                                  
@ClientId int,                                        
@AuthorIdFilter int,                                        
@ProgramIdFilter int,                          
@StatusFilter int,                                                                                             
@DocumentBannerFilter char(1),                                        
@DateOfServiceFromDate datetime,                          
@DateOfServiceToDate datetime,                          
@OtherFilter int    
                                       
/********************************************************************************                                        
-- Stored Procedure: dbo.ssp_ListPageSCDisclosureServiceList                                          
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: used by  Attach/Review Claims list page                                        
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
-- 11.12.2009  Anuj			Created.                                              
-- 26.09.2016  Ravichandra	Removed the physical table ListPageSCDisclosureServices from SP
--							Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--							108 - Do NOT use list page tables for remaining list pages (refer #107)	
-- 06.04.2017 Bernardin     Added Comma(,) after DocumentCodeId to separate the columns and added four missed columns(DocumentId ,[Version] ,DocumentVersionId ,DocumentCodeId). Harbor - Support Task# 1238 	          
   11/20/2018 shivam          What:Added column effectivedate in select statement
                              why: Proviso Build Cycle Tasks#12                  
*********************************************************************************/                                        
AS
BEGIN
BEGIN TRY                                        
                                                                                                      
CREATE TABLE #ResultSet(                                                                              
		ServiceId  int,                        
		ProgamId  int,                        
		ProgramCode  varchar(100),                        
		ProcedureCodeId  int,                        
		ProcedureName   varchar(100),                                       
		--DocumentScreenId int,                                     
		ClientId   int,                                        
		DateofService  datetime,                                        
		Status    int,                                        
		StatusName       varchar(50),                                        
		AuthorId         int,                                        
		AuthorName       varchar(100),        
		--Following added with ref Disclosure New Specs        
		DocumentId int,        
		[Version] int,        
		DocumentVersionId int,        
		DocumentCodeId int    ,
		EffectiveDate DateTime    
--Changes end over here                               
	)                                        
                                        
declare @CustomFilters table (ServiceId int)                                        
declare @DocumentCodeFilters table (DocumentCodeId int)                                        
                                                                           
                     
insert into #ResultSet(                                        
		ServiceId,                                
		ProgamId,                        
		ProgramCode,                     
		ProcedureCodeId,                         
		ProcedureName,                                              
		--DocumentScreenId ,                                                  
		ClientId,                                                       
		DateofService,                                        
		Status,                                        
		StatusName,                                                        
		AuthorId,                                        
		AuthorName,        
		DocumentId ,        
		[Version] ,        
		DocumentVersionId ,        
		DocumentCodeId ,   
		EffectiveDate                                           
      )                                                                                 
select  distinct s.ServiceId,                         
		s.ProgramId,                         
		p.ProgramCode,                        
		s.ProcedureCodeId,                        
		pro.DisplayAs,                                                                 
		-- sr.ScreenId,                                                
		s.ClientId,                        
		s.DateOfService,                        
		s.Status,                                                                                                                                
		gcs.CodeName,                                         
		s.ClinicianId,                                        
		a.LastName + ', ' + a.FirstName  ,        
		d.DocumentId ,        
		d.CurrentDocumentVersionId ,        
		DV.DocumentVersionId ,        
		d.DocumentCodeId ,
	    d.EffectiveDate                                                            
  FROM [Services] s                                                   
       join Programs p on p.ProgramId =  s.ProgramId                         
       join ProcedureCodes pro on pro.ProcedureCodeId= s.ProcedureCodeId          
       --Moified here        
       join Documents d on  d.ServiceId=s.ServiceId           
       join DocumentVersions DV on DV.DocumentId=d.DocumentId and DV.DocumentVersionId=d.CurrentDocumentVersionId and ISNULL(DV.RecordDeleted,'N')<>'Y'                              
       --end        
       --join Screens sr on sr.DocumentCodeId= d.DocumentCodeId                                                       
       join GlobalCodes gcs on gcs.GlobalCodeId =  s.Status                                      
       left join Staff a on a.StaffId = s.ClinicianId                                                  
                                            
 where s.ClientID = @ClientId                                                                               
                                        
   AND (s.ClinicianId = @AuthorIdFilter or isnull(@AuthorIdFilter, 0) = 0)                          
   AND (s.ProgramId=@ProgramIdFilter or ISNULL(@ProgramIdFilter,0) = 0)              
   AND (isnull(s.DateOfService,@DateOfServiceFromDate) >= @DateOfServiceFromDate and isnull(s.DateOfService,@DateOfServiceFromDate)<=@DateOfServiceToDate)                        
                  
   --AND (s.DateOfService >= @DateOfServiceFromDate and s.DateOfService <= @DateOfServiceToDate)                                        
              
        
          
   AND (@StatusFilter = 0 or -- All Statuses                                        
        @StatusFilter > 10000 or -- Custom Status                                        
        (@StatusFilter = 256 and s.Status = 70) or -- Scheduled                                       
        (@StatusFilter = 257 and s.Status = 71) or -- Show                                        
        (@StatusFilter = 258 and s.Status = 72) or -- No Show                                        
        (@StatusFilter = 259 and s.Status = 73) or -- Cancel                                        
        (@StatusFilter = 260 and s.Status = 75) or -- Complete                                                                     
        (@StatusFilter = 261 and s.Status = 76))  --Error                                                                               
   AND isnull(s.RecordDeleted, 'N') = 'N'                                        
                       
-- Apply custom filters                                        
--                                        
                                        
if @StatusFilter > 10000 or @OtherFilter > 10000                                        
begin                                        
  insert into @CustomFilters (ServiceId)                                        
  exec scsp_ListPageSCDisclosureServiceList @StatusFilter = @StatusFilter, @OtherFilter = @OtherFilter                                        
                                        
  delete d                                        
    from #ResultSet d  where not exists(select * from @CustomFilters f where f.ServiceId = d.ServiceId)                                        
end  

 
 ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT  ServiceId,                                
					ProgamId,                        
					ProgramCode,                     
					ProcedureCodeId,                         
					ProcedureName,                                              
					--DocumentScreenId ,                                                  
					ClientId,                                                       
					DateofService,                                        
					Status,                                        
					StatusName,                                                        
					AuthorId,                                        
					AuthorName,        
					DocumentId ,        
					[Version] ,        
					DocumentVersionId ,        
					DocumentCodeId   ,
					EffectiveDate    
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'DateofService' then DateofService end,                                  
                                                case when @SortExpression= 'DateofService desc' then DateofService end desc,                                        
                                                case when @SortExpression= 'ProcedureName' then ProcedureName end,                                            
                                                case when @SortExpression= 'ProcedureName desc' then ProcedureName end desc,                                         
                                                case when @SortExpression= 'StatusName' then StatusName end,                                            
                                                case when @SortExpression= 'StatusName desc' Then StatusName end desc,                                                      
                                                case when @SortExpression= 'ClinicianName' then AuthorName end,                                            
                                                case when @SortExpression= 'ClinicianName desc' then AuthorName end desc,                        
                                                case when @SortExpression= 'ProgramCode' then ProgramCode end,                                            
												case when @SortExpression= 'ProgramCode desc' then ProgramCode end desc,                                                                      
                                                ProgramCode,                                        
                                                ServiceId) as RowNumber                                                                                         
				from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)   ServiceId,                                
					ProgamId,                        
					ProgramCode,                     
					ProcedureCodeId,                         
					ProcedureName,                                              
					--DocumentScreenId ,                                                  
					ClientId,                                                       
					DateofService,                                        
					Status,                                        
					StatusName,                                                        
					AuthorId,                                        
					AuthorName,        
					DocumentId ,        
					[Version] ,        
					DocumentVersionId ,        
					DocumentCodeId, 
					EffectiveDate,                                 
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

		SELECT	ServiceId,                                       
       ProgamId,                  
       ProgramCode,                  
       ProcedureCodeId,                   
       ProcedureName,                         
    --DocumentScreenId ,                                            
       ClientId,            
       CONVERT(VARCHAR(10), DateofService, 101) AS DateofService ,                                                        
       --DateofService,                                  
       Status,                                  
       StatusName,                                                  
       AuthorId as ClinicianId,                                  
       AuthorName as ClinicianName,  
       DocumentId ,        
	   [Version] ,        
	   DocumentVersionId ,        
	   DocumentCodeId,
	   EffectiveDate             
		FROM #FinalResultSet
		ORDER BY RowNumber       
 
 END TRY  
      
    BEGIN CATCH  
 DECLARE @Error varchar(8000)                                                 
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCDisclosureServiceList')                                                                               
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
 
                                      
                                        
