
/****** Object:  StoredProcedure [dbo].[ssp_SCListPageForms]    Script Date: 12/15/2015 12:40:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageForms]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageForms]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCListPageForms]    Script Date: 12/15/2015 12:40:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[ssp_SCListPageForms]    
(    
 @SessionId VARCHAR(30),                                                          
 @InstanceId INT,                                                          
 @PageNumber INT,                                                              
 @PageSize INT,                                                              
 @SortExpression VARCHAR(100),      
 @FormName VARCHAR(1000),    
 @TableName VARCHAR(100) ,    
 @TotalNumberOfColumns INT,    
 @OtherFilter INT    
)    
/************************************************************************************************                            
**  File:                                               
**  Name: ssp_SCListPageForms                                             
**  Desc: This storeProcedure is for getting the list of Forms    
**  Called By: FormsList Page    
**  Parameters:     
**  Input   @SessionId VARCHAR(30),    
   @InstanceId INT,    
   @PageNumber INT,    
   @PageSize INT,    
   @SortExpression VARCHAR(100),      
   @OtherFilter INT,    
   @FormName VARCHAR(1000),    
            @TableName VARCHAR(100) ,    
            @TotalNumberOfColumns INT,    
**  Output     ----------       -----------     
**      
**  Author:  Vishant Garg    
**  Date:    May 22, 2012    
*************************************************************************************************    
**  Change History     
**  Date:    Author:   Description:     
**  8/8/2012  Vishant Garg  To add the functionality for cte expression    
** 12/15/2015 Pradeep Kumar Yadav  Modify the logic because its not showing the form name in the list page when we are not giving the table name in time of New DFA Form creation 
*************************************************************************************************/     
AS    
BEGIN    
BEGIN TRY                 
     SET NOCOUNT ON;        
                  
     DECLARE @CustomFilters TABLE (FormTrackId INT)     
           
 --        
 IF(@TotalNumberOfColumns=0)      
         BEGIN      
              SET @TotalNumberOfColumns=NULL      
         END     
         
 --        
 --Get custom filters         
 --                                                    
  IF @OtherFilter > 10000                                     
   BEGIN                                
                                    
     INSERT INTO @CustomFilters (FormTrackId)                                                      
     EXEC scsp_ListPageSCFormList @OtherFilter = @OtherFilter                                         
   END          
         
 --                                       
 --Insert data in to temp table which is fetched below by appling filter.           
 --          
    ;WITH FormList  AS         
    (      
     SELECT       
           FormId      
          ,FormName      
          ,TableName      
          ,TotalNumberOfColumns       
     FROM Forms      
     WHERE  1=1      
     AND (FormName LIKE '%'+@FormName+'%' OR @FormName IS NULL )      
     AND (TableName LIKE '%'+@TableName+'%' OR @TableName IS NULL)      
     AND (TotalNumberOfColumns=@TotalNumberOfColumns OR @TotalNumberOfColumns IS NULL)      
     AND (RecordDeleted='N' OR RecordDeleted IS NULL)      
     AND (Active='Y' OR Active IS NULL)       
     AND ((TableName in (select name from sys.tables ))or @TableName IS NULL)                         
     ),        
      counts AS         
     (         
     SELECT COUNT(*) AS totalrows FROM FormList        
     ),                    
     ListForms AS         
     (         
     SELECT          
           FormId      
          ,FormName      
          ,TableName      
          ,TotalNumberOfColumns ,        
           COUNT(*) OVER ( ) AS TotalCount ,        
           ROW_NUMBER() OVER ( ORDER BY               
          CASE WHEN @SortExpression= 'FormName' THEN FormName END ,                                       
          CASE WHEN @SortExpression= 'FormName desc' THEN FormName END DESC,       
          CASE WHEN @SortExpression= 'TableName' THEN TableName END ,                                       
          CASE WHEN @SortExpression= 'TableName desc' THEN TableName END DESC,      
          CASE WHEN @SortExpression= 'TotalNumberOfColumns' THEN TotalNumberOfColumns END ,                                       
          CASE WHEN @SortExpression= 'TotalNumberOfColumns desc' THEN TotalNumberOfColumns END DESC,      
                   FormId) as RowNumber        
            FROM FormList         
           )        
       SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)        
            FormId      
           ,FormName      
           ,TableName      
           ,TotalNumberOfColumns ,        
            TotalCount ,        
            RowNumber        
            INTO    #FinalResultSet        
            FROM    ListForms        
            WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )          
                        
    IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1        
    BEGIN        
    SELECT 0 AS PageNumber ,        
   0 AS NumberOfPages ,        
   0 NumberOfRows        
   END        
   ELSE        
   BEGIN        
   SELECT TOP 1        
   @PageNumber AS PageNumber,        
   CASE (TotalCount % @PageSize) WHEN 0 THEN         
   ISNULL(( TotalCount / @PageSize ), 0)        
   ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,        
   ISNULL(TotalCount, 0) AS NumberOfRows        
   FROM    #FinalResultSet             
  END         
         
           SELECT                
           FormId      
          ,FormName      
          ,TableName      
          ,TotalNumberOfColumns     
 FROM #FinalResultSet                                          
 ORDER BY RowNumber          
         
 DROP TABLE #FinalResultSet             
 SET NOCOUNT OFF;        
END TRY     
BEGIN CATCH    
           DECLARE @Error VARCHAR(8000)                                                                                                                                          
           SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                                                           
           + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCListPageForms')                                                                                                                                           
           + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                                                           
           + '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                                                                                         
           RAISERROR                
           (                                                                                    
            @Error, -- Message text.                                                                                                        
            16, -- Severity.                             
            1 -- State.                                                                    
           );           
END CATCH         
END
GO


