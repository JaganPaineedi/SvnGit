IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCMyAuthorization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCMyAuthorization]

GO     
Create procedure [dbo].[ssp_ListPageSCMyAuthorization]                                                                              
@SessionId varchar(30),                                                                          
@InstanceId int,                                                                          
@PageNumber int,                                                                              
@PageSize int,                                                                              
@SortExpression varchar(100),                                           
@ClientId int ,                               
@AuthDocStatusFilter int,                      
@StartDate varchar(10),                                                
@EndDate varchar(10),                                                
@AuthNumber varchar(50),                                                       
@OtherFilter int ,                          
@StaffId int,          
@LoggedInStaffId int                                                                 
/********************************************************************************                                                                          
-- Stored Procedure: dbo.ssp_ListPageSCMyAuthorization                                                                            
--                                                                          
-- Copyright: Streamline Healthcate Solutions                                                                          
--                                                                          
-- Purpose: used by  Attach/Review Claims list page                                                                          
--                                                                          
-- Updates:                                                                                                                                 
-- Date				Author				Purpose                                                                          
-- 18Oct,2010		Damanpreet Kaur		Created For UM-Part2
-- 16 March 2012	Sudhir Singh		updated as per requirement of custom requirement in kalamazoo
-- 13 october 2012	Sunil khunger		changed inner join to left with Screens table in refrence of #149 listing was not coming in Authorization
-- 09 May 2013		Rakesh Garg			Get ClientId c.ClientId insetead of d.ClientId, As Authorization created from Authorization detail page have no row in Documents.
-- 07.JAN.2014		Revathi				what:Added join with staffclients table to display associated clients for login staff
										why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter 
--17,DEC,2015 Basudev sahu Modified For Task #609 Network180 Customization to Get Organisation  As ClientName		
/* 29 Jan 2016		Basudev				what:Changed code to display Clients LastName and FirstName and removed null check for this field  when ClientType=''I'' else  OrganizationName.  */
/*										why:task #2238, Core Bugs */	
/* 16 JUN,2016		Ravichandra			Removed the physical table  ListPageSCMyAuthorizations from SP
										Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
										108 - Do NOT use list page tables for remaining list pages (refer #107)	 	*/	
/07 Nov 2017        Prem 				What: Added IsNull condition for 'a.DateRequested' 
                                        Why:Task # 2425 Core Bugs 
							
*********************************************************************************/                                                                          
AS                                                                          
BEGIN                                                                                    
  SET NOCOUNT ON;                                              
BEGIN TRY 
	IF @AuthDocStatusFilter > 10000                                                       
		BEGIN                       
		  EXEC scsp_ListPageSCMyAuthorizations @SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,@ClientId,@AuthDocStatusFilter,@StartDate,@EndDate,
		  @AuthNumber,@OtherFilter,@StaffId,@LoggedInStaffId
		END
	ELSE
	BEGIN 
                               
	CREATE TABLE #ResultSet(                                                                                 
	[AuthorizationDocumentId] int,              
	[ClientId] int,              
	[ClientName] varchar(100),              
	[StaffId] int,              
	[StaffName] varchar(100),              
	[DocumentId] int,              
	[DocumentCodeId] int,              
	[DocumentScreenId] int,              
	[DocumentName] varchar(100),              
	[DateRequested] datetime,              
	[Requested] int,              
	[Pended]  char(1),        
	[ConsumerAppealed] int,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page        
	[ClinicianAppealed] int,        
	[PartialDenied] int,              
	--[Appealed] int,              
	[Approved] int,              
	[Denied] int,               
	[Total] int,              
	[RequesterComment] varchar(max)                                                       
	)                                                                          
                                         
declare @CustomFilters table (AuthorizationDocumentId int)                                                                          
declare @DocumentCodeFilters table (DocumentCodeId int)                                                                          
                                        
                                                   
                                                                                     
INSERT INTO #ResultSet(                                                
		[AuthorizationDocumentId],              
		[ClientId],              
		[ClientName],              
		[StaffId],              
		[StaffName],              
		[DocumentId],              
		[DocumentCodeId],              
		[DocumentScreenId],              
		[DocumentName],              
		[DateRequested] ,              
		[Requested],              
		[Pended],         
		[ConsumerAppealed] ,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page        
		[ClinicianAppealed] ,        
		[PartialDenied] ,             
		--[Appealed],              
		[Approved] ,              
		[Denied],               
		[Total] ,              
		[RequesterComment]                                                              
)                                                     
                              
SELECT ad.AuthorizationDocumentId,               
		--max(d.ClientId) as ClientId,                                                        
		max(c.ClientId) as ClientId,          -- Ref. to task 832 in Centra Wellness find CLientID was coming Null so comment d.ClientId
		max(CASE     
			WHEN ISNULL(C.ClientType, 'I') = 'I'
			 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
			ELSE ISNULL(C.OrganizationName, '')
			END
		) as ClientName,
		--max(c.LastName + ', ' + c.FirstName) as ClientName,                  
		max(ad.StaffId) as StaffId,                                              
		max(s.LastName + ', ' + s.FirstName) as Staffname,              
		max(d.DocumentId) as DocumentId,                                             
		max(dc.DocumentCodeId) as DocumentCodeId,                
		sr.ScreenId as DocumentScreenId,                                              
		max(dc.DocumentName) as DocumentName,                                          
		max(a.DateRequested) as DateRequested,                                           
		sum(case a.Status when 4242 then 1 else 0 end) as Requested,                                     
		sum(case a.Status when 4245 then 1 else 0  end ) as Pended,                      
		--sum(case a.Modified when 'Y' then 1 else 0  end) as Modified,               
		-- sum(case a.Status when 6044 then 1 when 6045 then 1 else 0 end) as Appealed,        
		sum(case a.Status when 6045 then 1 else 0 end) as ConsumerAppealed,         
		sum(case a.Status when 6044 then 1 else 0 end) as ClinicianAppealed,        
		sum(case a.Status when 304 then 1 else 0 end) as PartialDenied,               
		sum(case a.Status when 4243 then 1 else 0 end) as Approved,                                             
		sum(case a.Status when 4244 then 1 else 0 end) as Denied,                                                
		sum(case a.Status when 4245 then 1 else 0 end + case a.Status when 4243 then 1 else 0 end   +                                                            
		case a.Status when 4244 then 1 else 0 end  + case a.Status when 6044  then 1 else 0 end +  case a.Status when 304  then 1 else 0 end +                                                       
		case a.Status when 6045  then 1 else 0 end + case a.Status when 4242 then 1 else 0 end) as Total,              
		max(convert(varchar(max), ad.RequesterComment)) as RequesterComment                                            
                                           
  FROM AuthorizationDocuments ad                                            
       join Authorizations a on a.AuthorizationDocumentId = ad.AuthorizationDocumentId                                                 
       join ClientCoveragePlans ccp on ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId  and isnull(ccp.RecordDeleted, 'N') = 'N'                                                 
       left join Staff s on s.StaffId = ad.StaffId   and isnull(s.RecordDeleted, 'N') = 'N'                                           
       left join Documents d on d.DocumentId = ad.DocumentId  and isnull(d.RecordDeleted, 'N') = 'N'                         
       left join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId  and isnull(dc.RecordDeleted, 'N') = 'N'                                                
       join Clients c on c.ClientId = ccp.ClientId   and isnull(c.RecordDeleted, 'N') = 'N' 
       --Added by Revathi on 07-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)
       join staffclients sc on sc.ClientId=c.ClientId and sc.StaffId=@LoggedInStaffId                              
       left join Providers p on p.ProviderId = a.ProviderId  and isnull(p.RecordDeleted, 'N') = 'N'                                                   
       left join Sites si on si.SiteId = a.SiteId   and isnull(si.RecordDeleted, 'N') = 'N'                                               
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId   and isnull(cp.RecordDeleted, 'N') = 'N'                           
       left join Screens sr on sr.DocumentCodeId= d.DocumentCodeId  and ISNULL(sr.RecordDeleted,'N')='N'                                       
 WHERE                     
	 cp.Capitated = 'Y'                                              
	   and isnull(ad.RecordDeleted, 'N') = 'N'                                            
	   and isnull(a.RecordDeleted, 'N') = 'N'                          
                                                                      
	   and(  @AuthDocStatusFilter = 0 or --- for All                              
		   ( @AuthDocStatusFilter = 238 and (a.Status in (4242, 4245, 6044, 6045)))or                                
		   ( @AuthDocStatusFilter = 239 and a.Status = 4242) or                              
		   ( @AuthDocStatusFilter = 240 and a.Status = 4245) or                              
		   ( @AuthDocStatusFilter = 455 and a.Status = 6044) or    -- Modified BY Rakesh Get Data Based on CLinician Appeal or consumer appeal status        
			( @AuthDocStatusFilter = 456 and a.Status = 6045) or                                
		   ( @AuthDocStatusFilter = 242 and a.Status = 4244) or                              
		   ( @AuthDocStatusFilter = 243 and a.Status = 4243) or                              
		   --( @AuthDocStatusFilter = 244 and a.Modified = 'Y') or                              
		   ( @AuthDocStatusFilter = 245 and a.Status in (4243,4244,304)) or        
			( @AuthDocStatusFilter = 454 and a.Status in (304))                             
		  ) 	                                 
	   and ( @StartDate <> '' and (ISNULL(a.DateRequested, a.StartDateRequested) >=  @StartDate ) or isnull(@StartDate, '') = '') --Modfied By Prem Added Isnull Condition for 'a.DateRequested'                            
	   and ( @EndDate <> ''  and (ISNULL(a.DateRequested, a.StartDateRequested) <  convert(varchar(10), dateadd(dd, 1, @EndDate), 101))or isnull(@EndDate, '') = '')                              
	   and ( @AuthNumber <> '' and (a.AuthorizationNumber = @AuthNumber)or isnull(@AuthNumber, '') = '')                              
	   and ( @ClientId <> 0  and (c.ClientId = cast(@ClientId as varchar(10)))or isnull(@ClientId, 0) = 0) and           
	   s.StaffId=@StaffId and s.StaffId = @LoggedInStaffId                            
	   GROUP BY ad.AuthorizationDocumentId , ScreenId                                   
                
  
  
   ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT AuthorizationDocumentId,              
					  ClientId,              
					  ClientName,              
					  StaffId,              
					  StaffName,              
					  DocumentId,              
					  DocumentCodeId,              
					  DocumentScreenId,              
					  DocumentName,              
					  DateRequested ,              
					  Requested,              
					  Pended,         
					  ConsumerAppealed ,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page        
					  ClinicianAppealed ,        
					  PartialDenied ,             
					 --Appealed,              
					  Approved ,              
					  Denied,               
					  Total ,              
					  RequesterComment      
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'AuthorizationDocumentId' then AuthorizationDocumentId end,                                                          
                                                case when @SortExpression= 'AuthorizationDocumentId desc' then AuthorizationDocumentId end desc,                                                                
                                                case when @SortExpression= 'ClientName' then ClientName end,                                                             
                                                case when @SortExpression= 'ClientName desc' then ClientName end desc,                                                    
                                                case when @SortExpression= 'Staffname' then Staffname end,                                                                    
                                                case when @SortExpression= 'Staffname desc' Then Staffname end desc,                                                    
                                                case when @SortExpression= 'DocumentName' then DocumentName end,                                                                    
                                                case when @SortExpression= 'DocumentName desc' Then DocumentName end desc,                                                                 
                                                case when @SortExpression= 'Requested' then Requested end,                                                                    
                                                case when @SortExpression= 'Requested desc' then Requested end desc,                                                                
                                                case when @SortExpression= 'Pended' then Pended end,                                                                    
                                                case when @SortExpression= 'Pended desc' then Pended end desc,        
                                                case when @SortExpression= 'ConsumerAppealed' then ConsumerAppealed end,                                                              
                                                case when @SortExpression= 'ConsumerAppealed desc' then ConsumerAppealed end desc,           
                                                case when @SortExpression= 'ClinicianAppealed' then ClinicianAppealed end,                                                              
                                                case when @SortExpression= 'ClinicianAppealed desc' then ClinicianAppealed end desc,           
                                                case when @SortExpression= 'PartialDenied' then PartialDenied end,                                                              
                                                case when @SortExpression= 'PartialDenied desc' then PartialDenied end desc,                                                                 
                                                --case when @SortExpression= 'Appealed' then Appealed end,                                           
                                                --case when @SortExpression= 'Appealed desc' then Appealed end desc,                                          
                                                case when @SortExpression= 'Approved' then Approved end,                                           
                                                case when @SortExpression= 'Approved desc' then Approved end desc,                                          
                                                case when @SortExpression= 'Denied' then Denied end,                                           
												case when @SortExpression= 'Denied desc' then Denied end desc ,                                          
                                                case when @SortExpression= 'TotalUnits' then Total end,         
                                                case when @SortExpression= 'TotalUnits desc' then Total end desc ,                                          
                                                case when @SortExpression= 'RequesterComment' then RequesterComment end,                                           
                                                case when @SortExpression= 'RequesterComment desc' then RequesterComment end desc,                          
                                                DocumentName,DocumentId) as RowNumber                                               
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  AuthorizationDocumentId,              
					  ClientId,              
					  ClientName,              
					  StaffId,              
					  StaffName,              
					  DocumentId,              
					  DocumentCodeId,              
					  DocumentScreenId,              
					  DocumentName,              
					  DateRequested ,              
					  Requested,              
					  Pended,         
					  ConsumerAppealed ,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page        
					  ClinicianAppealed ,        
					  PartialDenied ,             
					 --Appealed,              
					  Approved ,              
					  Denied,               
					  Total ,              
					  RequesterComment,                             
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

		SELECT		  AuthorizationDocumentId,              
					  ClientId,              
					  ClientName,              
					  StaffId,              
					  StaffName,              
					  DocumentId,              
					  DocumentCodeId,              
					  DocumentScreenId,              
					  DocumentName,              
					  DateRequested ,              
					  Requested,              
					  Pended,         
					  ConsumerAppealed ,      -- By Rakesh Garg As New Status for UM Part2 new show in List Page        
					  ClinicianAppealed ,             
					 --Appealed,              
					  Approved ,              
					  Denied, 
					   PartialDenied ,                 
					  Total ,              
					  RequesterComment   
		FROM #FinalResultSet
		ORDER BY RowNumber                                
                                           
                                          
 END                             
END TRY                             
BEGIN CATCH                                        
                                      
DECLARE @Error varchar(8000)                                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCMyAuthorization')                                                                                                                   
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