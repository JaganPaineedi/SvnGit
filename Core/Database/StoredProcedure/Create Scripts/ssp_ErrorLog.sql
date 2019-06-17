    
    /****** Object:  StoredProcedure [dbo].[ssp_ErrorLog]    Script Date: 12/03/2015 18:52:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ErrorLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ErrorLog]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ErrorLog]  Script Date: 11/21/2014 18:52:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
       
CREATE PROCEDURE [dbo].[ssp_ErrorLog]          
    @PageNumber INT,                                
    @PageSize INT,                                
    @SortExpression VARCHAR(100),                   
    @CreatedBy VARCHAR (100) ,                                                    
    @ErrorType VARCHAR (100) ,               
    @ErrorLogId int = null ,        
    @FromDate datetime ,        
    @ToDate datetime ,        
    @NoOfRecords int=null         
AS           
  /************************************************************************************************                                          
   
 /*************************************************************/                   
/* Stored Procedure: dbo.[ssp_ErrorLog]              */                   
/* Creation Date:  01/12/2017                                */                   
/* Purpose: To display all ErrorLogs in list page and detail page   */                   
/*  Date                  Author                  Purpose     */                   
/*  01/12/2017          Mohammed Junaid            Created     */                
/*************************************************************/   
               
  *************************************************************************************************/          
  BEGIN           
      BEGIN TRY           
          SET nocount ON;           
           
    --DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------                      
          DECLARE @CustomFiltersApplied CHAR(1)           
          CREATE TABLE #CustomFilters (InsurersID int)           
                   
          SET @CustomFiltersApplied = 'N'              
        
      IF  @FromDate=''  
      set  @FromDate='1900-01-01'     
        
      IF  @ToDate=''  
      set  @ToDate='2999-01-01'       
          
          CREATE TABLE #ErrorLog          
            (           
              ErrorLogId  INT,      
              ErrorType VARCHAR(100),      
              CreatedBy VARCHAR(100),      
              CreatedDate VARCHAR(100)         
            )           
          
                            
      IF @CustomFiltersApplied = 'N'           
  BEGIN       
   INSERT INTO #ErrorLog      
   SELECT distinct top (@NoOfRecords) p.ErrorLogId       
    ,p.ErrorType       
    ,p.CreatedBy       
    ,p.CreatedDate       
   FROM ErrorLog p     
   join GlobalCodes c on c.CodeName=p.ErrorType   
           
   WHERE (ISNULL(@CreatedBy,'')='' OR p.CreatedBy like '%'+@CreatedBy+'%')         
         and (ISNULL(@ErrorType,'')='' OR c.GlobalCodeId like '%'+@ErrorType+'%' or c.GlobalCodeId like '%All Error Types%' )   
         and(cast(p.CreatedDate As Date ) between Cast(@FromDate as Date) and Cast(@ToDate as Date))  
          
            
            
         order by ErrorLogId desc    
   END;      
     
     
    
          
   WITH Counts           
         AS (SELECT COUNT(*) AS TotalRows           
             FROM   #ErrorLog),           
         ListBanners           
              AS (SELECT    ErrorLogId,                
                            ErrorType,           
                             CreatedBy,           
                             CreatedDate,           
                             COUNT(*)           
                             OVER ()   AS           
                             TotalCount,           
                             RANK()           
                               OVER (  ORDER BY           
                                          CASE WHEN @SortExpression='ErrorLogId' THEN ErrorLogId  END,           
                                          CASE WHEN @SortExpression='ErrorLogId desc' THEN ErrorLogId END DESC,          
                                          CASE WHEN @SortExpression='ErrorType' THEN ErrorType END,           
                                          CASE WHEN @SortExpression='ErrorType desc' THEN ErrorType END DESC,           
                                          CASE WHEN @SortExpression='CreatedBy' THEN CreatedBy END,           
                                          CASE WHEN @SortExpression='CreatedBy desc' THEN CreatedBy END DESC,                    
                                          CASE WHEN @SortExpression='CreatedDate' THEN CreatedDate END,      
                                          CASE WHEN @SortExpression='CreatedDate desc' THEN CreatedDate END DESC,ErrorLogId) AS  RowNumber          
              FROM  #ErrorLog)           
    SELECT TOP (CASE WHEN (@PageNumber = -1) THEN     
    (SELECT ISNULL( totalrows, 0)           
    FROM           
    Counts ) ELSE (@PageSize) END)     
   ErrorLogId,      
           ErrorType,      
           CreatedBy,      
           CreatedDate,           
                                   TotalCount,           
                                   RowNumber           
    INTO   #FinalResultSet           
    FROM   ListBanners           
    WHERE  RowNumber > ((@PageNumber - 1 ) * @PageSize )           
          
          
  
           
         
          
         
    IF (SELECT ISNULL(COUNT(*), 0)           
        FROM   #finalresultset) < 1           
      BEGIN           
          SELECT 0 AS PageNumber,           
                 0 AS NumberOfPages,           
                 0 NumberOfRows           
      END           
    ELSE           
      BEGIN           
          SELECT TOP 1 @PageNumber           AS PageNumber,           
                       CASE ( TotalCount % @PageSize )           
                       WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)           
                       ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1           
                       END  AS NumberOfPages,           
                       ISNULL(totalcount, 0) AS NumberOfRows           
          FROM   #FinalResultSet           
      END           
           
           
          
    SELECT ErrorLogId,           
           ErrorType,           
           CreatedBy,           
           CreatedDate           
    FROM   #FinalResultSet           
    ORDER  BY RowNumber           
           
      
      
      
      
      
END TRY           
          
    BEGIN CATCH           
        DECLARE @Error VARCHAR(8000)           
          
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'           
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())           
                    + '*****'           
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),           
                    'ssp_ErrorLog')           
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())           
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())           
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())           
          
        RAISERROR ( @Error,           
                    -- Message text.                                                                                                      
                    16,           
                    -- Severity.                                                                                                      
                    1           
                   -- State.                                                                                                      
                    );           
     END CATCH           
END       