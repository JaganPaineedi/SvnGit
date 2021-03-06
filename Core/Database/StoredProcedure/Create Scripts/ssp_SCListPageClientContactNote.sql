IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageClientContactNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageClientContactNote]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageClientContactNote]    Script Date: 05/07/2014 15:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCListPageClientContactNote] 
   @SessionId VARCHAR(30)                                                                          
 ,@InstanceId INT                                                                          
 ,@PageNumber INT                                                                              
 ,@PageSize INT                                                                              
 ,@SortExpression VARCHAR(100)    
 ,@ClientId INT            
 ,@Status INT    
 ,@Type INT    
 ,@Reason INT    
 ,@FromDate DATETIME    
 ,@ToDate DATETIME    
 ,@OtherFilter int  
 ,@ReferenceType int= NULL
 ,@AssignedTo int = NULL
 ,@IndividualOrganization VARCHAR(250)=''    -- 31-Dec-2016      Ajay
 ,@StaffId int=null

/* *******************************************************************************/                                                                         
-- Stored Procedure: dbo.csp_SCListPageClientOrders                                                                                                          
-- Copyright: Streamline Healthcate Solutions                                                                          
--                                                                          
-- Purpose: used by Contact Note List page.           
--    
--                                                                          
-- Updates:                                                                                                                                 
-- Date				Author			Purpose                                                                          
-- 04.07.2011		Davinder Kumar  Created.                                                                                
-- 05/Feb/2014		Munish			Changed Custom CSP to Core SSP */
-- 07/May/2014		Revathi			What:remove the custom table ListPageSCClientContactNotes and Implement tempory table                        
--									why: Task #1301 of Customization Bugs 
-- 05/Apr/2016		Venkatesh		What: added 2 more parameters to get the data. As per task Renaissance - Dev Items - #780 
-- 02-06-2016       Pavani          Changed FromDate and ToDate Logic as per the Task #69 Bradford EIT
-- 6/22/2016		JHB				Fixed logic on dates
-- 13-Dec-2016      Ajay			Added IndividualOrganization and StaffId parameter Why:Woods - Support Go Live: Task#143
-- 27-July-2018     Bibhu           what:Added join with staffclients table to display associated clients for login staff  
--          		                why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  
/*********************************************************************************/                     
As            
BEGIN 
 BEGIN TRY 
 DECLARE @IsPermissionContactReason Char(1) ='N'  -- 31-Dec-2016      Ajay

      SET @IsPermissionContactReason = 
      (SELECT TOP 1 Value 
       FROM   SystemConfigurationKeys 
       WHERE  [Key] = 'SHOWPERMISSIONEDCONTACTREASONS' AND ISNULL(RecordDeleted,'N')='N') 

 CREATE  TABLE #CustomFilters (ClientContactNoteId int)   
 DECLARE @CustomFiltersApplied char(1)='N'          
 DECLARE @Today DATETIME                          
 DECLARE @ApplyFilterClicked CHAR(1) 
              
	CREATE TABLE #ResultSet (                                                                          
         ClientContactNoteId  INT
         ,ClientId  INT  
         ,ClientName VARCHAR(250)
        ,ContactDateTime DATETIME                                        
        ,ContactReason VARCHAR(250)    
        ,ContactType VARCHAR(250)                
        ,ContactStatus VARCHAR(50)    
        ,ContactDetails VARCHAR(MAX) 
        ,ReferenceType VARCHAR(50) 
        ,AssignedTo VARCHAR(50)   
        ,IndividualOrganization VARCHAR(250)      -- 13-Dec-2016      Ajay      
        )          
 
 SET @SortExpression = rtrim(ltrim(@SortExpression))                    
                  
 IF ISNULL(@SortExpression, '') = ''                  
   SET @SortExpression= 'ContactDateTime desc'             
                      
IF @AssignedTo =0
	SET @AssignedTo=-1                         
--                                                            
-- New retrieve - the request came by clicking on the Apply Filter button             
 SET @ApplyFilterClicked = 'Y'                                                            
 --SET @PageNumber = 1                                                                                  
 SET @Today = CONVERT(CHAR(10), GETDATE(), 101)             
   
 -- Get custom filters                          
if @OtherFilter > 10000                    
BEGIN    
    
  SET @CustomFiltersApplied = 'Y'                          
      
  INSERT  INTO #CustomFilters (ClientContactNoteId)                          
  EXEC scsp_SCListPageClientContactNote @ClientId = @ClientId,                          
          @Status = @Status,                                                    
          @Type = @Type,    
          @Reason = @Reason,                           
          @OtherFilter = @OtherFilter 
END             
  
   
    
 INSERT INTO #ResultSet 
		(ClientContactNoteId 
		,ClientId
		,ClientName
		,ContactDateTime                                      
		,ContactReason     
		,[ContactType]           
		,[ContactStatus]    
		,[ContactDetails] 
		,ReferenceType
		,AssignedTo
		,IndividualOrganization   -- 13-Dec-2016      Ajay
		)   
					          
		SELECT  
		CCN.ClientContactNoteId
		,C.ClientId
		,(C.LastName + ', ' + C.FirstName) AS ClientName
		,CCN.ContactDateTime               
		,GCR.CodeName AS ContactReason    
		,GCT.CodeName AS [ContactType]     
		,GCS.CodeName AS [ContactStatus]    
		,CCN.ContactDetails     
		,ISNULL(DBO.csf_GetGlobalCodeNameById(CCN.ReferenceType), '') AS ReferenceType
		,S.DisplayAs 
		,CCN.IndividualOrganization   -- 13-Dec-2016      Ajay  
		FROM ClientContactNotes CCN           
		INNER JOIN Clients C ON C.ClientId = CCN.ClientId AND ISNULL(C.RecordDeleted,'N') <> 'Y' AND ISNULL(CCN.RecordDeleted,'N') <> 'Y'
		     
		LEFT OUTER JOIN GlobalCodes GCR ON CCN.ContactReason = GCR.GlobalCodeId             
		LEFT OUTER JOIN GlobalCodes GCT ON CCN.ContactType = GCT.GlobalCodeId              
		LEFT OUTER JOIN GlobalCodes GCS ON CCN.[ContactStatus] = GCS.GlobalCodeId
		LEFT OUTER JOIN Staff S ON CCN.AssignedTo = S.StaffId
		INNER JOIN StaffClients SC ON  sc.StaffId = @StaffId AND  SC.ClientId = CCN.ClientId   -- 27-July-2018     Bibhu   
		WHERE  
		((@CustomFiltersApplied = 'Y' and exists(SELECT * FROM #CustomFilters cf WHERE cf.ClientContactNoteId = CCN.ClientContactNoteId))
				OR (@CustomFiltersApplied = 'N'))   AND
		((ISNULL(@IsPermissionContactReason,'N')='Y'	 and exists( SELECT *
						FROM ViewStaffPermissions
						WHERE CCN.ContactReason=PermissionItemId  and StaffId = @StaffId
							AND PermissionTemplateType = 5925
				) )
		
		or (ISNULL(@IsPermissionContactReason,'N')= 'N'	))
		and
		--Date Filter  
		
		--Pavani 02-06-2016		  
		--((CCN.ContactDateTime >= @FromDate AND CAST(CONVERT(varchar(50),CCN.ContactDateTime,106) as Datetime) <= @ToDate)    
		-- JHB 6/22/2016
		((@FromDate IS NULL or CCN.ContactDateTime IS NULL OR(CCN.ContactDateTime  >= CAST(@FromDate as DATE))  
          AND
        (@ToDate IS NULL OR CCN.ContactDateTime IS NULL OR (CCN.ContactDateTime < dateadd(dd,1,CAST(@ToDate as DATE))))) 
        --END
		
		--Type Filter    
		--AND (@Type = 0 --All Type    
		--OR (@Type = 4030 AND CCN.ContactType = 2141)    
		--OR (@Type = 4031 AND CCN.ContactType = 2142)    
		--OR (@Type = 4032 AND CCN.ContactType = 2143)    
		--OR (@Type = 4033 AND CCN.ContactType = 2144)    
		--OR (@Type = 4034 AND CCN.ContactType = 2145)    
		--OR (@Type = 4035 AND CCN.ContactType = 2146))   

		AND (@Type = 0 --All Status    
		OR (IsNull(CCN.ContactType, 0) = @Type))   
		AND (@ReferenceType = 0 --All Status    
		OR (IsNull(CCN.ReferenceType, 0) = @ReferenceType)) 
		
		AND (@AssignedTo = -1 --All Status    
		OR (IsNull(CCN.AssignedTo, -1) = @AssignedTo)) 
		
		----Status Filter    
		AND (@Status = 0 --All Status    
		OR (IsNull(CCN.ContactStatus, 0) = @Status))
		  AND (@ClientId = 0 
		OR (IsNull(CCN.ClientId, 0) = @ClientId))    
		--Reason Filter    
		AND (@Reason = 0 --All Reason    
		OR (IsNull(CCN.ContactReason, 0) = @Reason))
		--Individual Organization Filter    
		AND (@IndividualOrganization= '' --All IndividualOrganization       -- 13-Dec-2016      Ajay
		OR (IsNull(CCN.IndividualOrganization, '')  LIKE  '%'+@IndividualOrganization+'%'))
		
		) 
		
--------------------------------------------------------------------------------------------------------------------------------------------             
   ;WITH Counts
		AS (SELECT
		  COUNT(*) AS TotalRows
		FROM #ResultSet), 
	RankResultSet
	AS(SELECT   
	ClientContactNoteId
	,ClientId
	,ClientName
	,ContactDateTime                                      
	,ContactReason     
	,ContactType           
	,ContactStatus    
	,ContactDetails
	,ReferenceType
	,AssignedTo
	,IndividualOrganization                       -- 13-Dec-2016      Ajay
    ,COUNT(*) OVER () AS TotalCount
    ,ROW_NUMBER() OVER (ORDER BY 
			  CASE WHEN @SortExpression= 'ClientName' THEN ClientName END    
             ,CASE WHEN @SortExpression= 'ClientName desc' THEN ClientName END DESC  
			 ,CASE WHEN @SortExpression= 'ContactDateTime' THEN ContactDateTime END    
             ,CASE WHEN @SortExpression= 'ContactDateTime desc' THEN ContactDateTime END DESC                            
             ,CASE WHEN @SortExpression= 'ContactReason' THEN ContactReason END    
             ,CASE WHEN @SortExpression= 'ContactReason desc' THEN ContactReason END DESC    
             ,CASE WHEN @SortExpression= 'ContactType' THEN ContactType END    
             ,CASE WHEN @SortExpression= 'ContactType desc' THEN ContactType END DESC                                          
             ,CASE WHEN @SortExpression= 'ContactStatus' THEN ContactStatus END    
             ,CASE WHEN @SortExpression= 'ContactStatus desc' THEN ContactStatus END DESC    
             ,CASE WHEN @SortExpression= 'ContactDetails' THEN ContactDetails END    
             ,CASE WHEN @SortExpression= 'ContactDetails desc' THEN ContactDetails END DESC 
             ,CASE WHEN @SortExpression= 'ReferenceType' THEN ReferenceType END    
             ,CASE WHEN @SortExpression= 'ReferenceType desc' THEN ReferenceType END DESC 
             ,CASE WHEN @SortExpression= 'AssignedTo' THEN AssignedTo END    
             ,CASE WHEN @SortExpression= 'AssignedTo desc' THEN AssignedTo END DESC  
             ,CASE WHEN @SortExpression= 'IndividualOrganization' THEN IndividualOrganization END             -- 13-Dec-2016      Ajay
             ,CASE WHEN @SortExpression= 'IndividualOrganization desc' THEN IndividualOrganization END DESC 
			 ,ClientContactNoteId)AS RowNumber
             FROM #ResultSet)
                                                 
		SELECT TOP (CASE
		WHEN (@PageNumber = -1) THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
		ELSE (@PageSize)END)
		ClientContactNoteId
		,ClientId
		,ClientName
		,ContactDateTime                                      
		,ContactReason     
		,ContactType           
		,ContactStatus    
		,ContactDetails
		,ReferenceType
		,AssignedTo
		,IndividualOrganization           -- 13-Dec-2016      Ajay
		,TotalCount
		,RowNumber INTO 
		#FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

    IF (SELECT
        ISNULL(COUNT(*), 0)
      FROM #FinalResultSet)
      < 1
		BEGIN
			  SELECT
				0 AS PageNumber,
				0 AS NumberOfPages,
				0 NumberofRows
		END
    ELSE
		BEGIN
				SELECT TOP 1 @PageNumber AS PageNumber,
				CASE (Totalcount % @PageSize)
					WHEN 0 THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages,
					ISNULL(Totalcount, 0) AS NumberofRows
				FROM #FinalResultSet
		END
		
	SELECT  
	ClientContactNoteId 
	,ClientId
	,ClientName
	,ContactDateTime                                    
	,ContactReason     
	,ContactType          
	,ContactStatus     
	,ContactDetails 
	,ReferenceType
	,AssignedTo    
	,IndividualOrganization           -- 13-Dec-2016      Ajay         
	FROM #FinalResultSet                                   
	ORDER BY RowNumber  
 END TRY
  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_SCListPageClientContactNote')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END
GO


