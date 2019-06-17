/****** Object:  StoredProcedure [dbo].[ssp_SCSystemConfigurationKeysList]    Script Date: 10/14/2016 11:02:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSystemConfigurationKeysList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSystemConfigurationKeysList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCSystemConfigurationKeysList]    Script Date: 10/14/2016 11:02:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
 CREATE PROCEDURE [dbo].[ssp_SCSystemConfigurationKeysList] (     
  @PageNumber INT    
 ,@PageSize INT    
 ,@SortExpression VARCHAR(100)    
 ,@SystemConfigurationKeyId INT    
 ,@ModuleId INT   
 ,@ScreenId  INT  
 ,@Value VARCHAR(100)    
 ,@OtherFilter INT    
 )    
AS    
/************************************************************************************************                            
**  File:                                               
**  Name: ssp_SCEmployeeList                                             
**  Desc: This storeProcedure is for getting the list of EmployeeList.    
**    
**  Parameters:     
**  Input                                                          
    @PageNumber int,                                                              
    @PageSize int,                                                              
    @SortExpression varchar(100),    
    @OtherFilter int    
**  Output     ----------       -----------     
**      
**  Author:  Talasu Hemant Kumar    
**  Date:    9/11/2014    
*************************************************************************************************    
**  Change History     
**  Date:    Author:   Description:     
**  --------   --------  -------------------------------------------------------------    
** Modify By: Vijeta Sinha for Putting Screen Filter in List Page, Date: 14-10-2016  
*************************************************************************************************/    
BEGIN    
 BEGIN TRY    
  SET NOCOUNT ON;    
  ---       
  --Declare table to get data if Other filter exists -------      
  --      
  CREATE TABLE #SystemConfigurationKeys (SystemConfigurationKeyId INT)    
       
  --Get custom filters       
  --                                                  
  IF @OtherFilter > 10000    
  BEGIN    
   INSERT INTO #SystemConfigurationKeys (SystemConfigurationKeyId)    
   EXEC scsp_ListPageSCConfigurationKeysList @OtherFilter = @OtherFilter    
  END    
    
  --                                     
  --Insert data in to temp table which is fetched below by appling filter.         
  --        
    
 ; WITH TotalSystemConfigurationKeys    
  AS (   
   SELECT DISTINCT SystemConfigurationKeys.SystemConfigurationKeyId    
    ,SystemConfigurationKeys.[Key]    
    ,ISNULL(SystemConfigurationKeys.Value, '') AS Value    
    ,SystemConfigurationKeys.[Description]    
    ,SystemConfigurationKeys.AcceptedValues
    ,SystemConfigurationKeys.SourceTableName   --------- // Added by vsinha
    ,STUFF(( SELECT DISTINCT ', ' + m.ModuleName AS [text()]    
          FROM  SystemConfigurationKeys s
		  LEFT JOIN screenconfigurationkeys sk on s.SystemConfigurationKeyId= sk.SystemConfigurationKeyId AND isnull(sk.RecordDeleted, 'N') = 'N'
		  LEFT JOIN ModuleScreens ms on sk.screenId= ms.ScreenId AND isnull(ms.RecordDeleted, 'N') = 'N' 
		  LEFT Join Modules m ON ms.ModuleId=m.ModuleId AND isnull(m.RecordDeleted, 'N') = 'N'
		   WHERE s.SystemConfigurationKeyId=SystemConfigurationKeys.SystemConfigurationKeyId ---259 
                        FOR XML PATH('')   
                        ), 1,1, '' ) as Modules   ----------- // Added by vsinha    
    FROM SystemConfigurationKeys    
    left JOIN ScreenConfigurationKeys sck ON SystemConfigurationKeys.SystemConfigurationKeyId =  sck.SystemConfigurationKeyId  
    AND ISNULL (sck.RecordDeleted,'N')='N'  
    LEFT JOIN ModuleScreens ms ON sck.ScreenId = ms.ScreenId AND ISNULL (ms.RecordDeleted,'N')='N'  
    LEFT JOIN Modules m ON ms.ModuleId = m.ModuleId AND ISNULL (m.RecordDeleted,'N')='N' 
   WHERE (    
      @ModuleId = 0 or ms.ModuleId = @ModuleId    
        )   
        And (  
       @ScreenId = 0 or  sck.ScreenId =  @ScreenId   
        )  
    AND (    
     SystemConfigurationKeys.SystemConfigurationKeyId = @SystemConfigurationKeyId    
     or @SystemConfigurationKeyId = 0          
     )    
        
    AND (    
     SystemConfigurationKeys.[Key] LIKE '%' + @Value + '%'    
      OR @Value IS NULL    
      OR SystemConfigurationKeys.[Description] LIKE '%' + @Value + '%'    
      OR @Value IS NULL    
     -- OR SystemConfigurationKeys.Modules LIKE '%' + @Value + '%'   
      OR m.ModuleName LIKE '%' + @Value + '%' 
      OR @Value IS NULL            
     )    
        
    AND [KEY] NOT IN (    
     'EndUserMonitoringFilePath'    
     ,'EndUserMonitoringEnabled'    
     )    
    --AND SystemConfigurationKeys.ShowKeyForViewingAndEditing = 'Y'    // Commented by vsinha
   )    
       
       
   ,counts    
  AS (    
   SELECT COUNT(*) AS totalrows    
   FROM TotalSystemConfigurationKeys    
   )    
   ,ListSystemConfigurationKeys    
  AS (    
   SELECT DISTINCT SystemConfigurationKeyId    
    ,[Key]    
    ,[Description]    
    ,AcceptedValues 
    ,SourceTableName   
    ,Modules    
    ,ISNULL(TotalSystemConfigurationKeys.Value, '') AS Value    
    ,COUNT(*) OVER () AS TotalCount    
    ,ROW_NUMBER() OVER (    
     ORDER BY CASE     
       WHEN @SortExpression = 'Key'    
        THEN [Key]    
       END    
      ,CASE     
       WHEN @SortExpression = 'Key desc'    
        THEN [Key]    
       END DESC    
      ,CASE     
       WHEN @SortExpression = 'Description'    
        THEN [Description]    
       END    
      ,CASE     
       WHEN @SortExpression = 'Description desc'    
        THEN [Description]    
       END DESC    
      ,CASE     
       WHEN @SortExpression = 'AcceptedValues'    
        THEN AcceptedValues    
       END    
      ,CASE     
       WHEN @SortExpression = 'AcceptedValues desc'    
        THEN AcceptedValues    
       END DESC    
      ,CASE     
       WHEN @SortExpression = 'Value'    
        THEN Value    
       END    
      ,CASE     
       WHEN @SortExpression = 'Value desc'    
        THEN Value    
       END DESC 
       ,CASE     
       WHEN @SortExpression = 'SourceTableName'    
        THEN SourceTableName    
       END    
      ,CASE     
       WHEN @SortExpression = 'SourceTableName desc'    
        THEN SourceTableName    
       END DESC   
      ,CASE     
       WHEN @SortExpression = 'Modules'    
        THEN Modules    
       END    
      ,CASE     
       WHEN @SortExpression = 'Modules desc'    
        THEN Modules    
       END DESC    
     ) AS RowNumber    
   FROM TotalSystemConfigurationKeys    
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
    ) SystemConfigurationKeyId    
   ,[Key]    
   ,[Description]    
   ,AcceptedValues 
   ,SourceTableName   
   ,Modules    
   ,ISNULL(ListSystemConfigurationKeys.Value, '') AS Value    
   ,TotalCount    
   ,RowNumber    
  INTO #FinalResultSet    
  FROM ListSystemConfigurationKeys    
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
    
  SELECT SystemConfigurationKeyId    
   ,[Key]    
   ,[Description]    
   ,AcceptedValues    
   ,SourceTableName
   ,Modules    
   ,CASE     
    WHEN value = 'NULL'    
     THEN ''    
    ELSE Value    
    END AS value    
  FROM #FinalResultSet    
  ORDER BY RowNumber    
    
  DROP TABLE #FinalResultSet    
  DROP TABLE #SystemConfigurationKeys   
     --DROP TABLE #Temp  
       
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCSystemConfigurationKeysList') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert
  
(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                        
    16    
    ,-- Severity.                                                                                        
    1 -- State.                                            
    );    
 END CATCH    
END    

GO


