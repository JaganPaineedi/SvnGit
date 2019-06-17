IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCListPageAuthorizationDocumentList')
	BEGIN
		DROP  Procedure  ssp_SCListPageAuthorizationDocumentList
	END

GO

CREATE Procedure ssp_SCListPageAuthorizationDocumentList
                        
@SessionId varchar(30),                                                                      
@InstanceId int,                                                                      
@PageNumber int,                                                                          
@PageSize int,                                                                          
@SortExpression varchar(100),                                                                      
@ClinicianId int,                                                                                                
@ClientId int,                                                                      
@AuthorIdFilter int,                                                                      
--@DocumentCodeIdFilter int,                                                                                                                           
--@DocumentBannerFilter char(1),                                                                      
@StatusFilter int,                                                        
@EffectiveFromDate datetime,                                                        
@EffectiveToDate datetime,                                                        
@OtherFilter int,                
@DocumentNavigationId int               
/********************************************************************************                                                                      
-- Stored Procedure: dbo.ssp_SCListPageAuthorizationDocumentList                                                                        
--                                                                      
-- Copyright: Streamline Healthcate Solutions                                                                      
--                                                                      
-- Purpose: used by  AttachReleaseDocument list page                                                                      
--                                                                      
-- Updates:                                                                                                                             
-- Date				Author      Purpose                                                                      
-- 12 June 2012  Rahul Aneja     Created.                                                                            
-- 30 Aug 2016	 Ravichandra	Removed the physical table ListPageSCDisclosureDocuments from SP
								Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
								108 - Do NOT use list page tables for remaining list pages (refer #107)	                                                                        
*********************************************************************************/                                                                      
AS      
BEGIN
BEGIN TRY                                                                   
Declare @ScreenId int                   
set @SortExpression =Rtrim ( Ltrim(@SortExpression))                  
                                                                                                                             
CREATE TABLE #ResultSet(                                                                                                                                     
			DocumentId     int,                                                                       
			CurrentVersion int,                                                                      
			DocumentCodeId int,                                                                  
			DocumentScreenId int,                                                                   
			ClientId       int,                                                                      
			DocumentName   varchar(100),                                                                      
			EffectiveDate  datetime,                                                                      
			Status         int,                                                                    
			StatusName     varchar(50),                                                                      
			AuthorId  int,                                                                      
			AuthorName     varchar(100),                                              
			--Added By Sahil                     
			ClientName varchar(100),                               
			--Ended over here                 
			--Changes by Sonia reference new specs                            
			DocumentVersionId int                                                   
			--Changes end over here                                 
)                                                                      
                                                          
declare @CustomFilters table (DocumentId int)                                            
declare @DocumentCodeFilters table (DocumentCodeId int)                                   
                                                                 
                                                                
            
-- Get all document codes based on DocumentNavigationId                    
if @DocumentNavigationId > 0                                        
begin                                        
 -- if @DocumentBannerFilter = 'Y'                                        
  --begin                             
                          
Select @ScreenId=isnull(ScreenId,0)  from DocumentNavigations where DocumentNavigationId=@DocumentNavigationId                        
if (@ScreenId=0)              
begin                        
    insert into @DocumentCodeFilters (DocumentCodeId)                         
Select S.DocumentCodeId from DocumentNavigations DN                        
inner join Screens  S on DN.ScreenId=S.ScreenId                           
 where ParentDocumentNavigationId=@DocumentNavigationId                         
End                        
                        
Else                        
begin                        
insert into @DocumentCodeFilters (DocumentCodeId)                         
Select S.DocumentCodeId from  Screens  S                         
 where S.ScreenId=@ScreenId                        
     end                          
    -- End                              
                                       
end                          
                                                                       
                                                                                 
insert into #ResultSet(                                                                      
			DocumentId,                                                                   
			CurrentVersion,                                                                      
			DocumentCodeId,                                                                             
			DocumentScreenId ,                                                                                
			ClientId,                                                               
			DocumentName,                                                                      
			EffectiveDate,                                                                      
			Status,                                                                      
			StatusName,                                                                                      
			AuthorId,                                                                      
			AuthorName,                              
			--Added By Sahil                                              
			ClientName ,                                                    
			--Ended over here                                                                            
			DocumentVersionId                            
			)                                                                                                               
			select distinct d.DocumentId,                                          
			d.CurrentDocumentVersionId,                              
			--dv.DocumentVersionId,                                                            
			d.DocumentCodeId,                                    
			'',                                                  
			--sr.ScreenId,                                                                              
			d.ClientId,                                                                                   
			case                                   
			when pc.DisplayDocumentAsProcedureCode = 'Y' then pc.DisplayAs                                                                      
			when dc.DocumentCodeId = 2 and tp.PlanOrAddendum = 'A' then 'TxPlan Addendum'                      
			else dc.DocumentName                                                                      
			end,                                                                      
			d.EffectiveDate,                                         
			d.Status,                                                  
			gcs.CodeName,                                                                       
			d.AuthorId,         
			a.LastName + ', ' + a.FirstName ,                                             
			--Aded By Sahil                                              
			C.LastName + ', ' + C.FirstName,                               
		   dv.DocumentVersionId                                                                   
		   --Ended over here                                              
		   --case when dss.DocumentId is not null and dss.SignatureDate is null and isnull(dss.DeclinedSignature,'N') = 'N'                                                                      
		   --     then 'To Co-Sign'                                                                       
		   --     else null                                                                       
		   --end,                                       
		   --case when dsc.DocumentId is not null and dsc.SignatureDate is null and isnull(dsc.DeclinedSignature,'N') = 'N' and d.Status = 22                                                                      
		   --     then 'To Sign'                                                                                                          
		   --     else null                                 
		   --end,                                                                        
		   --case when d.DocumentShared = 'Y' then 'Yes' else 'No' end                                                                      
  FROM Documents d                                                                                                            
		join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId                               
		--following added by sonia                            
		join DocumentVersions dv on dv.DocumentId=d.DocumentId and dv.DocumentVersionId=d.CurrentDocumentVersionId                                                                             
		--Changes end over here                            
        --left join Screens sr on sr.DocumentCodeId= d.DocumentCodeId                                                                                     
        join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                                                                      
        join Staff a on a.StaffId = d.AuthorId                                              
        --Added By Sahil                                              
        join Clients as C on d.ClientId=C.ClientId                                              
        --Ened Over here                                                                      
        left join DocumentSignatures dss on dss.DocumentId = d.DocumentId and dss.StaffId = @ClinicianId and dss.StaffId <> d.AuthorId and isnull(dss.RecordDeleted, 'N') = 'N'                                                                       
        left join DocumentSignatures dsc on dsc.DocumentId = d.DocumentId and dsc.IsClient = 'Y' and Isnull(dsc.RecordDeleted, 'N') = 'N'                              
        left join Services s on s.ServiceId = d.ServiceId and d.Status in (20, 21, 22, 23) and dc.ServiceNote = 'Y'                                                                                                                                
        left join ProcedureCodes pc on pc.ProcedureCodeId = s.ProcedureCodeID                                                                                                
        left join TpGeneral tp on tp.DocumentVersionId = d.CurrentDocumentVersionId                                                                                                                                                                                                                            
 WHERE d.ClientID = @ClientId                                  
 --and ISNULL(dc.ServiceNote,'N')='N'                       
   and (d.AuthorId = @ClinicianId or -- Current clinician is an author                                                                      
    d.ProxyId = @ClinicianId or  -- Current clinician is a proxy                                                                      
    d.Status in (22, 23) or -- Document is in the final status: Signed or Cancelled                                                                      
    d.DocumentShared = 'Y' or -- Document is shared             
   (d.Status = 22 and dss.DocumentId is not null)) -- Signed documents where current clinician is a co-signer                                   
                                             
   and (d.AuthorId = @AuthorIdFilter or isnull(@AuthorIdFilter, 0) = 0)                                                        
   --Added by Anuj                                                        
     and (isnull(d.EffectiveDate,@EffectiveFromDate) >= @EffectiveFromDate and isnull(d.EffectiveDate,@EffectiveFromDate)<=@EffectiveToDate)                                                  
   --and (d.EffectiveDate >= @EffectiveFromDate and d.EffectiveDate <= @EffectiveToDate)                            
   --End                                                        
   and ((exists(select * from @DocumentCodeFilters dcf where dcf.DocumentCodeId = d.DocumentCodeId)) or (isnull(@DocumentNavigationId, 0) = 0))                                                                      
                
   and (@StatusFilter = 247 or -- All Statuses                         
        @StatusFilter = 0     or -- All Statuses                                                          
        @StatusFilter > 10000 or -- Custom Status                                                                      
        (@StatusFilter = 248 and d.Status = 20) or -- To Do                                                        
        (@StatusFilter = 249 and d.Status = 21) or -- In Progress                                                                      
        (@StatusFilter = 250 and d.Status = 22 and d.SignedByAuthor = 'Y') or -- Signed                                                                      
        (@StatusFilter = 251 and d.Status = 22 and isnull(d.SignedByAuthor, 'N') = 'N') or -- Completed                                                   
        (@StatusFilter = 252 and dss.DocumentId is not null and dss.SignatureDate is null and isnull(dss.DeclinedSignature, 'N') = 'N') or -- To Co-Sign                                                                                                   
        (@StatusFilter = 253 and d.Status = 22) or --Signed, Completed                                          
        (@StatusFilter = 254 and d.Status not in (22,23)) or -- Not-Signed and Completed                                                                      
        (@StatusFilter = 254 and d.Status = 21 and d.ToSign = 'Y')) -- To Sign                                                                                                                          
   and isnull(d.RecordDeleted, 'N') = 'N'                                                                      
                                                                                
--                                                                      
-- Apply custom filters                                                                      
--                                                           
                                                                     
if @StatusFilter > 10000 or @OtherFilter > 10000                                                                      
begin                                                                      
  insert into @CustomFilters (DocumentId)                        
  exec scsp_ListPageSCDisclosureDocumentList @StatusFilter = @StatusFilter, @OtherFilter = @OtherFilter                                                          
                                                                      
  delete d                                                       
    from #ResultSet d     where not exists(select * from @CustomFilters f where f.DocumentId = d.DocumentId)                                                            
end 

;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT 			
			DocumentId,                                                                   
			CurrentVersion,                                                                      
			DocumentCodeId,                                                                             
			DocumentScreenId ,                                                                                
			ClientId,                                                               
			DocumentName,                                                                      
			EffectiveDate,                                                                      
			Status,                                                                      
			StatusName,                                                                                      
			AuthorId,                                                                      
			AuthorName,                              
			--Added By Sahil                                              
			ClientName ,                                                    
			--Ended over here                                                                            
			DocumentVersionId           
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'DocumentName' then DocumentName end,                              
                                             case when @SortExpression= 'DocumentName desc' then DocumentName end desc,                                                                      
                                             case when @SortExpression= 'EffectiveDate' then EffectiveDate end,                                                                          
											 case when @SortExpression= 'EffectiveDate desc' then EffectiveDate end desc,                                                     
											 case when @SortExpression= 'StatusName' then StatusName end,                                                                          
                                             case when @SortExpression= 'StatusName desc' Then StatusName end desc,                                                                      
                                             case when @SortExpression= 'AuthorName' then AuthorName end,                                                                          
                                             case when @SortExpression= 'AuthorName desc' then AuthorName end desc,                                                                      
                                             DocumentName,                                                        
                                             DocumentId) as RowNumber                                             
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  	
				DocumentId,                                                                   
				CurrentVersion,                                                                      
				DocumentCodeId,                                                                             
				DocumentScreenId ,                                                                                
				ClientId,                                                               
				DocumentName,                                                                      
				EffectiveDate,                                                                      
				Status,                                                                      
				StatusName,                                                                                      
				AuthorId,                                                                      
				AuthorName,                              
				--Added By Sahil                                              
				ClientName ,                                                    
				--Ended over here                                                                            
				DocumentVersionId ,                              
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

		SELECT	DocumentId,                                                                   
			CurrentVersion,                                                                      
			DocumentCodeId,                                                                             
			DocumentScreenId ,                                                                                
			ClientId,                                                               
			DocumentName,                                                                      
			EffectiveDate,                                                                      
			Status,                                                                      
			StatusName,                                                                                      
			AuthorId,                                                                      
			AuthorName,                              
			--Added By Sahil                                              
			ClientName ,                                                    
			--Ended over here                                                                            
			DocumentVersionId       
		FROM #FinalResultSet
		ORDER BY RowNumber                                       

  END TRY  
BEGIN CATCH                                                                             
 DECLARE @Error varchar(8000)                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageAuthorizationDocumentList')                                                                                                                                             
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