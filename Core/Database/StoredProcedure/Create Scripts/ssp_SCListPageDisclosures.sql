/****** Object:  StoredProcedure [dbo].[ssp_SCListPageDisclosures]    Script Date: 11/18/2011 16:25:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageDisclosures]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageDisclosures]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ssp_SCListPageDisclosures]                                                                         
@SessionId varchar(30),                                                                
@InstanceId int,                                                                
@PageNumber int,                                                                    
@PageSize int,                                                                    
@SortExpression varchar(100),                                                                           
@DocumentBannerFilter char(1),                                                                            
@DisclosedByIdFilter int,                                      
@DisclosedToIdFilter varchar(50),                                                               
@ReleaseAuthorizingIdFilter int,                                                                 
@DisclosedFromDateFilter varchar(50),                                                  
@DisclosedToDateFilter varchar(50),                                                  
@DisclosureMethodIdFilter int,                                                  
@OtherFilter int ,                                              
@ClientId int,                                              
@RequestFromDate varchar(50),                                                  
@RequestToDate varchar(50),                         
@RequestFromId varchar(50),                  
@DisclosurePurposeIdFilter int ,                                                  
@StaffId int,  --Modified by Sahil Dated : 19-May-2010                        
@AssignedToFilter int
                                                              
/********************************************************************************                                                                
-- Stored Procedure: dbo.ssp_ListPageSCDisclosure                                                                
--                                                                
-- Copyright: Streamline Healthcate Solutions                                                                
--                                                                
-- Purpose: Used by Disclosure list page                                                                
--                                                                
-- Updates:                                                                                                                       
-- Date        Author      Purpose                                                                
-- 8 Dec,2009  Anuj        Created.                                                                      
-- 2 JUN,2016 Ravichandra  Removed the physical table ListPageSCAuthorizationCodes from SP
						   Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
						   108 - Do NOT use list page tables for remaining list pages (refer #107)	  
-- 01 Aug 2016 Shruthi.S   Added Active check for Staff.Ref : #307 Network 180 Environment Issues Tracking.
-- 12 May 2017 Alok Kumar  Added a new filter '@AssignedToFilter' and a new column 'AssignedTo' to the List page.	Ref : #307 Network 180 Environment Issues Tracking.                                                                                  
*********************************************************************************/                                                                

AS
BEGIN

	BEGIN TRY
	                                                              
                                                                                                                              
create table #ResultSet(                                                                                                                            
ClientDisclosureId  int,                                                                               
DocumentScreenId int,                                                                    
DisclosedById int,                                                  
DisclosedByName varchar(100),       
DisclosureDate  datetime,                                                   
DisclosedToId int,                                                    
DisclosedToName varchar(100),                                                  
ClientInformationReleaseId int,                                                  
ClientInformationReleaseName varchar(100),                                                   
DisclosureType int,                                  
DisclosureTypeDescription varchar(100),                                               
RequestDate datetime,                        
RequestFromName varchar(100),                        
RequestFromId int,          
DisclosurePurposeDescription   varchar(100) ,   
AssignedTo varchar(100)			-- 12 May 2017 Alok Kumar                                           
)                                                                
                                             
declare @CustomFilters table (ClientDisclosureId int)                                                                     
                                   
                                                                
                                                                          
insert into #ResultSet(                                                                
  ClientDisclosureId,                                                                
  DocumentScreenId ,                                                                               
  DisclosedById,                                                                
  DisclosedByName,                                                                
  DisclosureDate,                                                                
  DisclosedToId,                                                                                 
  DisclosedToName,                                                                
  ClientInformationReleaseId,                                                                
  ClientInformationReleaseName,                                                             
  DisclosureType,                                                                
  DisclosureTypeDescription,                                     
  RequestDate,               
  RequestFromId,                        
  RequestFromName,          
    DisclosurePurposeDescription,   
  AssignedTo			-- 12 May 2017 Alok Kumar        
 )                                                               
select distinct CD.ClientDisclosureId,                                       
  ''  ,                                                                             
        CD.DisclosedBy,                                                   
        S.LastName + ', ' + S.FirstName as [DisclosedByName],                                                    
       CD.DisclosureDate,                                 
       CD.DisclosedToId,                                                  
       CD.DisclosedToName,                                                  
       CD.ClientInformationReleaseId,                                 
       CIR.ReleaseToName as [ClientInformationReleaseName],                                                                  
       CD.DisclosureType,                                                                            
       gcs.CodeName,                                                
      CD.RequestDate,                        
 CD.RequestFromId,                        
 CD.RequestFromName,                             
  gc.CodeName as DisclosurePurposeDescription,
  S1.LastName + ', ' + S1.FirstName as [AssignedTo]			-- 12 May 2017 Alok Kumar                                                                                              
  from ClientDisclosures CD                                                   
  inner join staff as S on S.StaffId=CD.Disclosedby and isnull(CD.RecordDeleted,'N')='N'                                    
  left join ClientInformationReleases as CIR on CIR.ClientInformationReleaseId=CD.ClientInformationReleaseId and isnull(CIR.RecordDeleted,'N')='N'                                                      
  left join Clients as C on C.ClientId=CIR. ClientId   and isnull(C.RecordDeleted, 'N') = 'N'                                                  
  left join ClientDisclosedRecords CDR on CDR.ClientDisclosureId = CD.ClientDisclosureId                                                     
  left join Documents d on  CDR.DocumentId =d.DocumentId and isnull(CDR.RecordDeleted, 'N') = 'N'                                   
  left join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId                                                                         
  left join Screens sr on sr.DocumentCodeId= d.DocumentCodeId                                                                            
  left join GlobalCodes gcs on gcs.GlobalCodeId = CD.DisclosureType                                             
  left join GlobalCodes gc on gc.GlobalCodeId = CD.DisclosurePurpose                      
  left join staff as S1 on S1.StaffId=CD.AssignedToStaffId and isnull(S1.RecordDeleted,'N')='N'    
                      
 where (CD.DisclosedToName=@DisclosedToIdFilter  or isnull(@DisclosedToIdFilter, '') = '')                                                                                            
 and (CD.RequestFromName=@RequestFromId  or isnull(@RequestFromId,'') = '')                                                  
and (CD.DisclosedBy = @DisclosedByIdFilter or isnull(@DisclosedByIdFilter, 0) = 0)                                                                
and (CD.ClientInformationReleaseId=@ReleaseAuthorizingIdFilter or isnull(@ReleaseAuthorizingIdFilter, 0) = 0 )                                                  
        
 and (@DisclosureMethodIdFilter = 0 or -- All Statuses                                        
        @DisclosureMethodIdFilter > 10000 or -- Custom Status                                        
        (@DisclosureMethodIdFilter = 264 and CD.DisclosureType = 5521) or -- Documents                                       
        (@DisclosureMethodIdFilter = 265 and CD.DisclosureType = 5522) or -- Claims                                        
        (@DisclosureMethodIdFilter = 266 and CD.DisclosureType= 5523) or -- Verbal                                        
        (@DisclosureMethodIdFilter = 267 and CD.DisclosureType = 5524)  -- Other                                        
          -- Complete                                                                     
        )  --Error               
        
        
--Disclosure Purpose                  
and (CD.DisclosurePurpose=@DisclosurePurposeIdFilter or isnull(@DisclosurePurposeIdFilter, 0) = 0 )                                                
--Disclosure/Request Dates                  
and (isnull(CD.DisclosureDate,@DisclosedFromDateFilter) >= @DisclosedFromDateFilter and isnull(CD.DisclosureDate,@DisclosedFromDateFilter)<=@DisclosedToDateFilter)                                              
and (isnull(CD.RequestDate,@RequestFromDate) >= @RequestFromDate and isnull(CD.RequestDate,@RequestFromDate)<=@RequestToDate)                                              
and CD.ClientId=@ClientId                                                                      
--and S.Active='Y'                  
and (CD.AssignedToStaffId=@AssignedToFilter or isnull(@AssignedToFilter, 0) = 0 )			-- 12 May 2017 Alok Kumar
                                                                         
--                                                                
-- Apply custom filters                                                                
--                                                                
                                         
if @OtherFilter > 10000                                                                
begin                                                                
  insert into @CustomFilters (ClientDisclosureId)                                                                
   exec scsp_ListPageSCDisclosures @OtherFilter = @OtherFilter                                                                
                                                                
  delete d                                                                
    from #ResultSet d  where not exists(select * from @CustomFilters f where f.ClientDisclosureId = d.ClientDisclosureId)                                                                
end                                                                
                                                         
 ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientDisclosureId,                                                                
					  DocumentScreenId ,                                                                               
					  DisclosedById,                                                                
					  DisclosedByName,                                                                
					  DisclosureDate,                                                                
					  DisclosedToId,                                                                                 
					  DisclosedToName,                                                                
					  ClientInformationReleaseId,                                                                
					  ClientInformationReleaseName,                                                             
					  DisclosureType,                                                                
					  DisclosureTypeDescription,                                     
					  RequestDate,               
					  RequestFromId,                        
					  RequestFromName,          
						DisclosurePurposeDescription,
						AssignedTo					-- 12 May 2017 Alok Kumar
				,Count(*) OVER () AS TotalCount
				 ,row_number() over (order by	case when @SortExpression= 'DisclosureDate' then DisclosureDate end,                                                          
												case when @SortExpression= 'DisclosureDate desc' then DisclosureDate end desc,                                                                
                                                case when @SortExpression= 'DisclosedToName' then DisclosedToName end,                                                                    
                                                case when @SortExpression= 'DisclosedToName desc' then DisclosedToName end desc,                                                         
                                                case when @SortExpression= 'DisclosedByName' then DisclosedByName end,                                                                    
                                                case when @SortExpression= 'DisclosedByName desc' Then DisclosedByName end desc,    
                                                case when @SortExpression= 'RequestFromName' then RequestFromName end,                                                                    
                                                case when @SortExpression= 'RequestFromName desc' Then RequestFromName end desc,                     
                                                case when @SortExpression= 'RequestDate' then RequestDate end,                                                          
												case when @SortExpression= 'RequestDate desc' then RequestDate end desc,                
												case when @SortExpression= 'DisclosureTypeDescription' then DisclosureTypeDescription end,                                                                    
                                                case when @SortExpression= 'DisclosureTypeDescription desc' Then DisclosureTypeDescription end desc, 
												case when @SortExpression= 'DisclosurePurposeDescription' then DisclosurePurposeDescription end,                                                                    
                                                case when @SortExpression= 'DisclosurePurposeDescription desc' Then DisclosurePurposeDescription end desc,  
												case when @SortExpression= 'ClientInformationReleaseName' then ClientInformationReleaseName end,                                                                    
                                                case when @SortExpression= 'ClientInformationReleaseName desc' then ClientInformationReleaseName end desc,
                                                case when @SortExpression= 'AssignedTo' then AssignedTo end,                     -- 12 May 2017 Alok Kumar                                               
                                                case when @SortExpression= 'AssignedTo desc' then AssignedTo end desc,                                                                
                            
												DisclosedByName,                                                                
												ClientDisclosureId) as RowNumber        
												FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ClientDisclosureId,                                                                
				  DocumentScreenId ,                                                                               
				  DisclosedById,                                                                
				  DisclosedByName,                                                                
				  DisclosureDate,                                                                
				  DisclosedToId,                                                                                 
				  DisclosedToName,                                                                
				  ClientInformationReleaseId,                                                                
				  ClientInformationReleaseName,                                                             
				  DisclosureType,                                                                
				  DisclosureTypeDescription,                                    
				  RequestDate,               
				  RequestFromId,                        
				  RequestFromName,          
					DisclosurePurposeDescription,
					AssignedTo					-- 12 May 2017 Alok Kumar
			,TotalCount
			,RowNumber
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

		SELECT ClientDisclosureId, 
				RequestDate,  
				RequestFromName,
				DisclosureDate,   
				DisclosedToName,
				DisclosedByName,  
				DisclosureTypeDescription, 
				DisclosurePurposeDescription,   
				ClientInformationReleaseName,                                                                  
				DocumentScreenId ,                                                                               
				DisclosedById,            
				DisclosedToId,
				ClientInformationReleaseId,
				DisclosureType, 
				RequestFromId,
				AssignedTo				-- 12 May 2017 Alok Kumar
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY                               
                                                                                     
                                                                
BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCListPageDisclosures')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
GO


