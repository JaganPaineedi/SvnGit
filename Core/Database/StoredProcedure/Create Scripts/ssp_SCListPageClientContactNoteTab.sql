IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageClientContactNoteTab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageClientContactNoteTab]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageClientContactNoteTab]    Script Date: 05/07/2014 15:53:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCListPageClientContactNoteTab] 
  @PageNumber INT                                                                              
 ,@PageSize INT                                                                              
 ,@SortExpression VARCHAR(100)    
 ,@ReferenceType INT
 ,@ReferenceId INT
 
                
/* *******************************************************************************/                                                                         
-- Stored Procedure: dbo.ssp_SCListPageClientContactNoteTab                                                                                                          
-- Copyright: Streamline Healthcate Solutions                                                                          
--                                                                          
-- Purpose: used by Contact Note List page.           
--    
--                                                                          
-- Updates:                                                                                                                                 
-- Date				Author			Purpose                                                                          
-- .07.2016		Venkate MR		   Created. - As per task Renaissance - Dev Items #780                
-- 25-Sep-2017   Pavani            What : Retreiving Contact Notes linked to all ClaimLineItems of the ClaimLineItemGroup
--								   Why : Core Bugs task #5000
-- 12/13/2017	jcarlson		   Fixed bug where only contacts with Reference type of Claim Line Item where being returned
/*********************************************************************************/                     
As            
BEGIN 
 BEGIN TRY 
 
 CREATE  TABLE #CustomFilters (ClientContactNoteId int)   
 DECLARE @CustomFiltersApplied char(1)='N'          
 DECLARE @Today DATETIME                          
 DECLARE @ApplyFilterClicked CHAR(1) 
 -- 25-Sep-2017   Pavani
 DECLARE  @ClaimLineItemGroupId int   
 --END
	CREATE TABLE #ResultSet (                                                                          
         ClientContactNoteId  INT 
         ,ClientId INT 
        ,ContactDateTime DATETIME                                        
        ,ContactReason VARCHAR(250)    
        ,ContactType VARCHAR(250)                
        ,ContactStatus VARCHAR(50)    
        ,ContactDetails VARCHAR(MAX)  
        ,ReferenceType VARCHAR(50) 
        ,AssignedTo VARCHAR(50)                   
        )          
 
 SET @SortExpression = rtrim(ltrim(@SortExpression))                    
                  
 IF ISNULL(@SortExpression, '') = ''                  
   SET @SortExpression= 'ContactDateTime desc'             
                      
                                            
--                                                            
-- New retrieve - the request came by clicking on the Apply Filter button             
 SET @ApplyFilterClicked = 'Y'                                                            
 --SET @PageNumber = 1                                                                                  
 SET @Today = CONVERT(CHAR(10), GETDATE(), 101)             
   
 -- Get custom filters                          
        -- 25-Sep-2017   Pavani  
	SELECT @ClaimLineItemGroupId = ClaimLineItemGroupId
	FROM ClaimLineItems
	WHERE ClaimLineItemId = @ReferenceId;
    --END
           
 INSERT INTO #ResultSet 
		(ClientContactNoteId 
		,ClientId
		,ContactDateTime                                      
		,ContactReason     
		,[ContactType]           
		,[ContactStatus]    
		,[ContactDetails]
		,ReferenceType
		,AssignedTo    
		)              
		SELECT  
		CCN.ClientContactNoteId
		,CCN.ClientId
		,CCN.ContactDateTime               
		,GCR.CodeName AS ContactReason    
		,GCT.CodeName AS [ContactType]     
		,GCS.CodeName AS [ContactStatus]    
		,CCN.ContactDetails   
		,ISNULL(DBO.csf_GetGlobalCodeNameById(CCN.ReferenceType), '') AS ReferenceType
		,S.DisplayAs      
		FROM ClientContactNotes CCN   
		INNER JOIN Clients C ON C.ClientId = CCN.ClientId AND ISNULL(C.RecordDeleted,'N') <> 'Y' AND ISNULL(CCN.RecordDeleted,'N') <> 'Y'      
		LEFT OUTER JOIN GlobalCodes GCR ON CCN.ContactReason = GCR.GlobalCodeId             
		LEFT OUTER JOIN GlobalCodes GCT ON CCN.ContactType = GCT.GlobalCodeId              
		LEFT OUTER JOIN GlobalCodes GCS ON CCN.[ContactStatus] = GCS.GlobalCodeId  
		LEFT OUTER JOIN Staff S ON CCN.AssignedTo = S.StaffId     
		-- 25-Sep-2017   Pavani
		WHERE  CCN.ReferenceType = @ReferenceType
		AND ISNULL(ccn.RecordDeleted,'N')='N'
		AND ( ( @ReferenceType = 9379 --9379	Claim Line Item
				AND EXISTS (SELECT 1
							FROM ClaimLineItems AS cli
							WHERE cli.ClaimLineItemId = ccn.ReferenceId
							AND cli.ClaimLineItemGroupId = @ClaimLineItemGroupId
							)
				)	 
				OR
				( @ReferenceType <> 9379 --9379	Claim Line Item
				  AND ccn.ReferenceId = @ReferenceId
				)
			)

		order by CCN.ContactDateTime desc

--------------------------------------------------------------------------------------------------------------------------------------------             
   ;WITH Counts
		AS (SELECT
		  COUNT(*) AS TotalRows
		FROM #ResultSet), 
	RankResultSet
	AS(SELECT   
	ClientContactNoteId
	,ClientId
	,ContactDateTime                                      
	,ContactReason     
	,ContactType           
	,ContactStatus    
	,ContactDetails
	,ReferenceType
	,AssignedTo
    ,COUNT(*) OVER () AS TotalCount
    ,ROW_NUMBER() OVER (ORDER BY CASE WHEN @SortExpression= 'ContactDateTime' THEN ContactDateTime END    
             ,CASE WHEN @SortExpression= 'ContactDateTime desc' THEN ContactDateTime END DESC                            
             ,CASE WHEN @SortExpression= 'ContactReason' THEN ContactReason END    
             ,CASE WHEN @SortExpression= 'ContactReason desc' THEN ContactReason END DESC    
             ,CASE WHEN @SortExpression= 'ContactType' THEN ContactType END    
             ,CASE WHEN @SortExpression= 'ContactType desc' THEN ContactType END DESC                                          
             ,CASE WHEN @SortExpression= 'ContactStatus' THEN ContactStatus END    
             ,CASE WHEN @SortExpression= 'ContactStatus desc' THEN ContactStatus END DESC    
             ,CASE WHEN @SortExpression= 'ContactDetails' THEN ContactDetails END    
             ,CASE WHEN @SortExpression= 'ContactDetails desc' THEN ContactDetails END DESC 
			 ,ClientContactNoteId)AS RowNumber
             FROM #ResultSet)
                                                 
		SELECT TOP (CASE
		WHEN (@PageNumber = -1) THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
		ELSE (@PageSize)END)
		ClientContactNoteId
		,ClientId
		,ContactDateTime                                      
		,ContactReason     
		,ContactType           
		,ContactStatus    
		,ContactDetails
		,ReferenceType
		,AssignedTo
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
	,ContactDateTime                                    
	,ContactReason     
	,ContactType          
	,ContactStatus     
	,ContactDetails
	,ReferenceType
	,AssignedTo               
	FROM #FinalResultSet                                   
	ORDER BY RowNumber  
 END TRY
  BEGIN CATCH
    DECLARE @error varchar(8000)

    SET @error = CONVERT(varchar, ERROR_NUMBER()) + '*****'
    + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****'
    + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),
    'ssp_SCListPageClientContactNoteTab')
    + '*****' + CONVERT(varchar, ERROR_LINE())
    + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())

    RAISERROR (@error,-- Message text.
    16,-- Severity.
    1 -- State.
    );
  END CATCH
END