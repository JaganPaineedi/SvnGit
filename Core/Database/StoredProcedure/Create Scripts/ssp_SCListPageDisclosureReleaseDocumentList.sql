IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'ssp_SCListPageDisclosureReleaseDocumentList')
DROP PROCEDURE [dbo].[ssp_SCListPageDisclosureReleaseDocumentList]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ssp_SCListPageDisclosureReleaseDocumentList]                                                                                 
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
--@StaffId int  --Modified by Sahil Dated : 19-May-2010                  
                                                                        
/********************************************************************************                                                                        
-- Stored Procedure: dbo.ssp_SCListPageDisclosureReleaseDocumentList                                                                          
--                                                                        
-- Copyright: Streamline Healthcate Solutions                                                                        
--                                                                        
-- Purpose: used by  AttachReleaseDocument list page                                                                        
--                                                                        
-- Updates:                                                                                                                               
-- Date        Author      Purpose                                                                        
------------------------------------------------------------------------------------                                                                   
-- 05.04.2009	Anuj Tomar		Created.      
-- 08.18.2011	dharvey			Adjusted filters to not include "To Do" documents on Final Result set                                                                               
-- 09.30.2016	Ravichandra		Removed the physical table ListPageSCDisclosureReleaseDocuments from SP
--								Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--								108 - Do NOT use list page tables for remaining list pages (refer #107)                                                                          
*********************************************************************************/                                                                        
AS                                                                        
BEGIN
BEGIN TRY

Declare @ScreenId int             

SET @SortExpression =Rtrim ( Ltrim(@SortExpression))         
      
CREATE TABLE #ResultSet(                                                                                                                                              
		DocumentId     int,                                                                         
		CurrentVersion int,                                                                        
		DocumentCodeId int,                                                                    
		DocumentScreenId int,                                                                     
		ClientId       int,                                                                        
		DocumentName   varchar(100),                                                                   
		EffectiveDate  datetime,                                                                        
		Status      int,                                                                        
		StatusName    varchar(50),                 
		AuthorId       int,                                                                        
		AuthorName     varchar(100),                                                
		 --Added By Sahil                                    
		ClientName varchar(100),                          
		--Ended over here                                      
		--Changes by Sonia reference new specs                         
		DocumentVersionId int                              
		                              
		--Changes end over here                                                                           
)                                                                        
                                                                 
DECLARE @CustomFilters table (DocumentId int)                                                        
DECLARE @DocumentCodeFilters table (DocumentCodeId int)                                   
                                                           
                                                                        
          
-- Get all document codes based on DocumentNavigationId              
IF @DocumentNavigationId > 0                                  
BEGIN                                  
	                       
	                    
	SELECT @ScreenId=isnull(ScreenId,0)  FROM DocumentNavigations WHERE DocumentNavigationId=@DocumentNavigationId                  
	IF (@ScreenId=0)                  
	BEGIN                  
		INSERT into @DocumentCodeFilters (DocumentCodeId)                   
		SELECT S.DocumentCodeId 
		FROM DocumentNavigations DN                  
			 INNER JOIN Screens  S on DN.ScreenId=S.ScreenId                     
		WHERE ParentDocumentNavigationId=@DocumentNavigationId                   
	END                  
	                  
	ELSE                  
	BEGIN                  
		INSERT INTO @DocumentCodeFilters (DocumentCodeId)                   
		SELECT S.DocumentCodeId FROM  Screens  S                   
		WHERE S.ScreenId=@ScreenId                  
	END                    
		-- End                        
	                                 
END          
                    
INSERT INTO #ResultSet(                                                                        
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
SELECT DISTINCT d.DocumentId,                                          
       d.CurrentDocumentVersionId,                                
       --dv.DocumentVersionId,                                                              
       d.DocumentCodeId,                                      
       '',                                                    
       --sr.ScreenId,       
       d.ClientId,                                                                                     
       CASE                                     
       WHEN pc.DisplayDocumentAsProcedureCode = 'Y' THEN pc.DisplayAs                                                                        
       WHEN dc.DocumentCodeId = 2 and tp.PlanOrAddendum = 'A' THEN 'TxPlan Addendum'                                                   
                                                                              
            ELSE dc.DocumentName                                                                
       END,                                                                        
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
		and ((exists(SELECT 1 from @DocumentCodeFilters dcf WHERE dcf.DocumentCodeId = d.DocumentCodeId)) or (isnull(@DocumentNavigationId, 0) = 0))                                                                        

		and (((@StatusFilter = 247 or -- All Statuses                       
			@StatusFilter = 0     or -- All Statuses                                                        
			@StatusFilter > 10000) 
		--Exclude all To Do Documents from Disclosures
		and d.Status <> 20) or -- Custom Status                                                                    
		--(@StatusFilter = 248 and d.Status = 20) or -- To Doo                             
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
                               
IF @StatusFilter > 10000 or @OtherFilter > 10000                                                                        
BEGIN                                                                        
  INSERT INTO @CustomFilters (DocumentId)                                                                        
  EXEC scsp_ListPageSCDisclosureReleaseDocumentList @StatusFilter = @StatusFilter, @OtherFilter = @OtherFilter                                                            
                                                                        
  DELETE d                                                         
    FROM #ResultSet d    WHERE not exists(SELECT 1 FROM @CustomFilters f WHERE f.DocumentId = d.DocumentId)                                                                        
END   


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
				,ROW_NUMBER() over (order by	case when @SortExpression= 'DocumentName' then DocumentName end,                                
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
					DocumentVersionId   ,                             
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

		SELECT	 DocumentId,                                                                        
       CurrentVersion,                                                                        
       DocumentCodeId,                                                                              
       DocumentScreenId,                                                                                    
       ClientId,                                       
       DocumentName,                                                
       --CONVERT(VARCHAR(10), EffectiveDate, 101) AS EffectiveDate ,                                                                       
       EffectiveDate,                                                                        
       Status,                                                                        
       StatusName,                                                                        
       --DueDate,                                                                        
       AuthorId,                                                                        
       AuthorName,                                            
       --Added By Sahil                                                
       ClientName,                                                      
       --Ended over here                                  
       --ToCoSign,                                                                        
      -- ClientToSign,                                                        
      -- Shared                                
      --Changes by Sonia                              
       DocumentVersionId                              
       --Changes end over here    
		FROM #FinalResultSet
		ORDER BY RowNumber                                                   

END TRY  
BEGIN CATCH                                                                             
 DECLARE @Error varchar(8000)                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageDisclosureReleaseDocumentList')                                                                                                                                             
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
                                                
                                                                                                                      
                                                                        
