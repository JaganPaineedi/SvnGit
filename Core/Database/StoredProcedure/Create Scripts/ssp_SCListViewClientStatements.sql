Create PROCEDURE [dbo].[ssp_SCListViewClientStatements]   
 @PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@DateOfStatement DATETIME  
 ,@PDFVersionOfStatement varchar(100)
 ,@ClientId INT  
/********************************************************************************                                                            
-- Stored Procedure: ssp_SCListViewClientStatements                
--          
-- Purpose: To display cliets statements       
-- 
-- Task Engineering Improvement Initiatives- NBL(I) #529
--         
-- Author:  Manjunath K
-- Date:    24/May/2017          
-- Date              Author                  Purpose
--
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY
 
  ;WITH ViewClientStatements
  AS (   
		SELECT   
		'' as PrintButton,
		CB.PrintedDate,
		CS.ClientStatementId,
		CS.ClientBalance,
		ResponsiblePartyName,
		ResponsiblePartyAddress  
		FROM ClientStatements CS   
		JOIN ClientStatementBatches CB on CB.ClientStatementBatchId=CS.ClientStatementBatchId    
		WHERE (ClientId = @ClientId) AND (DATEDIFF(day,CB.PrintedDate, GETDATE()) <= 365 * 2)  
		AND (CS.RecordDeleted='N' or CS.RecordDeleted is Null)
		AND (ISNULL(@DateOfStatement,'') = '' OR CAST(CB.PrintedDate AS DATE) = @DateOfStatement  
        )    
        
   )  
   ,counts  
  AS (  
   SELECT count(*) AS totalrows  
   FROM ViewClientStatements  
   )  
   ,RankResultSet  
  AS (  
   SELECT 
	PrintButton,
	PrintedDate,
	ClientStatementId,
	ClientBalance,
	ResponsiblePartyName,
	ResponsiblePartyAddress    
    ,COUNT(*) OVER () AS TotalCount  
    ,RANK() OVER (  
     ORDER BY CASE   
       WHEN @SortExpression = 'PrintedDate'  
        THEN PrintedDate  
       END  
      ,CASE   
       WHEN @SortExpression = 'PrintedDate desc'  
        THEN PrintedDate  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ClientStatementId'  
        THEN ClientStatementId  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientStatementId desc'  
        THEN ClientStatementId  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ClientBalance'  
        THEN ClientBalance  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientBalance desc'  
        THEN ClientBalance  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ResponsiblePartyName'  
        THEN ResponsiblePartyName  
       END  
      ,CASE   
       WHEN @SortExpression = 'ResponsiblePartyName desc'  
        THEN ResponsiblePartyName  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ResponsiblePartyAddress'  
        THEN ResponsiblePartyAddress  
       END  
      ,CASE   
       WHEN @SortExpression = 'ResponsiblePartyAddress desc'  
        THEN ResponsiblePartyAddress  
       END DESC    
     ,ClientStatementId) AS RowNumber  
   FROM ViewClientStatements  
    
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT ISNULL(totalrows, 0)  
        FROM counts  
        )  
     ELSE (@PageSize)  
     END  
    ) 
    PrintButton,
	PrintedDate,
	ClientStatementId,
	ClientBalance,
	ResponsiblePartyName,
	ResponsiblePartyAddress,     
    TotalCount,  
    RowNumber  
  INTO #FinalResultSet  
  FROM RankResultSet  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT ISNULL(COUNT(*), 0)  
    FROM #FinalResultSet  
    ) < 1  
  BEGIN  
   SELECT 0 AS PageNumber  
    ,0 AS NumberOfPages  
    ,0 NumberOfRows  
  END  
  ELSE  
  BEGIN  
   SELECT TOP 1 @PageNumber AS PageNumber  
    ,CASE (TotalCount % @PageSize)  
     WHEN 0  
      THEN ISNULL((TotalCount / @PageSize), 0)  
     ELSE ISNULL((TotalCount / @PageSize), 0) + 1  
     END AS NumberOfPages  
    ,ISNULL(TotalCount, 0) AS NumberOfRows  
   FROM #FinalResultSet  
  END  
  
  SELECT 
	PrintButton,
	PrintedDate,
	ClientStatementId,
	ClientBalance,
	ResponsiblePartyName,
	ResponsiblePartyAddress     
  FROM #FinalResultSet  
  ORDER BY RowNumber  
  
 
 END TRY   
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListViewClientStatements') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                            
    16  
    ,-- Severity.                                                                                            
    1 -- State.                                                                                            
    );  
 END CATCH  
END  
  