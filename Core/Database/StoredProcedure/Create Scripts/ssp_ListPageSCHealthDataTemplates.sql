/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCHealthDataTemplates]    Script Date: 19-09-2018 18:11:11 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCHealthDataTemplates]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	DROP PROCEDURE [dbo].[ssp_ListPageSCHealthDataTemplates]
END
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCHealthDataTemplates]    Script Date: 19-09-2018 18:11:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCHealthDataTemplates]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_ListPageSCHealthDataTemplates] AS'
END
GO

ALTER PROCEDURE [DBO].[SSP_LISTPAGESCHEALTHDATATEMPLATES]   
@PageNumber INT,    
@PageSize INT,    
@SortExpression VARCHAR(100),     
--@HealthDataGoupId INT,     
@Status varchar(15),     
@OtherFilter INT 
,@HealthDataTemplateName VARCHAR(100) = null   
    
    
/*********************************************************************************/              
/* Stored Procedure: ssp_ListPageSCHealthDataTemplates        */     
/* Copyright: Streamline Healthcare Solutions          */              
/* Creation Date:  10-Aug-2012              */              
/* Purpose: used by Health Data Template List Page For Admin        */             
/* Input Parameters:                */            
/* Output Parameters:SessionId,InstanceId,PageNumber,PageSize,SortExpression,  */    
/*      OtherFilter,HealthDataGoupId,Status                         */            
/* Return:                      */              
/* Called By:                                                    */              
/* Calls:                   */              
/* Data Modifications:                */              
/* Updates:                   */              
/* Date              Author                  Purpose        */              
/* 10-Aug-2012  Rohit Katoch    Created        */          
/* 21-Aug-2012  Rohit Katoch    Modify -using CTE        */      
/* 11-Sep-2012 Rohit Katoch    Modify -change left join with inner join of HealthDataTemplateAttributes table        */                 
/* Sep 21,2012 Varinde Verma Moved recorddeleted condition from where to Left JOIN statement */    
/* Nov 26,2012 Rakesh Garg  Comment HealthDataGoupId paramter and Get HealthDataTemplateAttributes table information as it is of no use   
                                w.rf to task 128 &133 in Primary Care Bugs/Featurs */
 /* 20-SEPT-2018  Neha         Added a new filter @HealthDataTemplateName to search based on Template Name w.r.t Task EII 716.  */       
/*********************************************************************************/         
AS                                                            
BEGIN                  
BEGIN TRY         
    SET NOCOUNT ON;     
    
    --Declare table to get data if Other filter exists -------  
 --  
 CREATE TABLE #HealthDataTemplates  
 (  
  HealthDataTemplateId INT  
 )  
   
                                         
                                                                    
 --Get custom filters                                                  
 IF @OtherFilter > 10000                                 
 BEGIN      
 INSERT INTO #HealthDataTemplates                                                              
 EXEC scsp_ListPageSCHealthDataTemplates @OtherFilter = @OtherFilter                                  
 END        
                                                                              
            ------------------HealthDataTemplates-----------       
 ;With  TotalHealthDataTemplates as  
 (                                                   
                                                                 
 SELECT      
 HDT.HealthDataTemplateId,      
 HDT.TemplateName as HealthDataTemplateName,      
 Case when ISNULL(HDT.Active,'N')='Y' Then 'Yes'      
 Else 'No'      
 End as Active      
 FROM         
 HealthDataTemplates AS HDT      
 Left JOIN HealthDataTemplateAttributes HDTA on HDTA.HealthDataTemplateId=HDT.HealthDataTemplateId      
 --AND (HDTA.HealthDataGroup = @HealthDataGoupId OR  ISNULL(@HealthDataGoupId, 0) = 0)   
 AND ISNULL(HDTA.RecordDeleted,'N') = 'N'       
 WHERE  ISNULL(HDT.RecordDeleted,'N') = 'N'       
  AND  (HDT.Active= @Status OR ISNULL(@Status,'') = '')   
  AND ( @HealthDataTemplateName IS NULL 
                                               OR HDT.TemplateName LIKE '%' + 
                                                  @HealthDataTemplateName + 
                                                                   '%' 
                                            ) 
 GROUP BY HDT.HealthDataTemplateId,HDT.TemplateName,HDT.Active      
 ),  
                                                          
 counts AS   
(   
 SELECT COUNT(*) AS totalrows FROM TotalHealthDataTemplates  
),  
  LisHealthDataTemplates AS   
(   
   select  
 HealthDataTemplateId,      
    HealthDataTemplateName,      
    Active ,                                                                    
   COUNT(*) OVER ( ) AS TotalCount ,  
  ROW_NUMBER() OVER ( ORDER BY   
     CASE WHEN @SortExpression= 'HealthDataTemplateName'    THEN HealthDataTemplateName END,      
     CASE WHEN @SortExpression= 'HealthDataTemplateName desc'    THEN HealthDataTemplateName END DESC,       
     CASE WHEN @SortExpression= 'Status'  THEN Active END,                                                                  
     CASE WHEN @SortExpression= 'Status desc' THEN Active END DESC      
   )AS RowNumber  
  FROM TotalHealthDataTemplates                     
)                                                        
    
        SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)  
      HealthDataTemplateId,      
                        HealthDataTemplateName,      
      Active ,   
                        TotalCount ,  
                        RowNumber  
                INTO    #FinalHealthDataTemplates  
                FROM    LisHealthDataTemplates  
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )      
                             
      ----------------------HealthDataTemplateAttributes-----------            
                                                  
       
-- ;With  TotalHealthDataTemplateAttributes as  
-- (                                                                    
-- SELECT      
   
-- HDT.HealthDataTemplateId,      
-- HDT.TemplateName as HealthDataTemplateName,      
-- dbo.csf_GetGlobalCodeNameById(HDTA.HealthDataGroup) as HealthDataGroupName,      
-- Case when HDT.Active='Y' Then 'Active'      
-- Else 'Inactive'      
-- End as Active      
-- FROM         
-- HealthDataTemplates AS HDT      
-- LEFT JOIN HealthDataTemplateAttributes HDTA on HDTA.HealthDataTemplateId=HDT.HealthDataTemplateId       
         
        
-- WHERE  ISNULL(HDT.RecordDeleted,'N') = 'N'       
--  AND  (HDT.Active= @Status OR ISNULL(@Status,'') = '')    
--  --AND (HDTA.HealthDataGroup = @HealthDataGoupId OR  ISNULL(@HealthDataGoupId, 0) = 0)       
--  AND   ISNULL(HDTA.RecordDeleted,'N') = 'N'    
       
-- ),                                                    
-- counts AS   
--(   
-- SELECT COUNT(*) AS totalrows FROM TotalHealthDataTemplateAttributes  
--),  
--  ListHealthDataTemplateAttributes AS   
--(   
--   select  
-- HealthDataTemplateId,      
--    HealthDataTemplateName,      
--    HealthDataGroupName,      
--    Active ,                                                                    
--    COUNT(*) OVER ( ) AS TotalCount ,  
--    ROW_NUMBER() OVER ( ORDER BY   
--    CASE WHEN @SortExpression= 'HealthDataTemplateName'        THEN HealthDataTemplateName END,      
--    CASE WHEN @SortExpression= 'HealthDataTemplateName desc'   THEN HealthDataTemplateName END DESC,       
--    CASE WHEN @SortExpression= 'HealthDataGroupName'           THEN HealthDataGroupName END,           
--    CASE WHEN @SortExpression= 'HealthDataGroupName desc'      THEN HealthDataGroupName END DESC,           
--    CASE WHEN @SortExpression= 'Status'                        THEN Active END,                                                                  
--    CASE WHEN @SortExpression= 'Status desc'                   THEN Active END DESC      
--   )AS RowNumber  
--  FROM TotalHealthDataTemplateAttributes                     
--)                                                        
    
      --  SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)  
      --HealthDataTemplateId,      
      --HealthDataTemplateName,      
      --HealthDataGroupName,      
      --Active ,   
      --                  TotalCount ,  
      --                  RowNumber  
      --          INTO    #FinalHealthDataTemplateAttributes  
      --          FROM    ListHealthDataTemplateAttributes  
      --          WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )      
                                                    
                                                                 
                
                                                                             
     
                                                                 
             
  IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalHealthDataTemplates)<1  
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
   FROM    #FinalHealthDataTemplates       
  END           
                                           
                                                                  
                                                                                  
                                                                   
 SELECT                                                                         
 HealthDataTemplateId,      
 HealthDataTemplateName,      
 Active as Status                               
 FROM       
 #FinalHealthDataTemplates                                                                       
 ORDER BY RowNumber                                                  
       
       
                                                                  
 --SELECT                                                                         
 --HealthDataTemplateId,      
 --HealthDataTemplateName,      
 --HealthDataGroupName      
 --FROM       
 --#FinalHealthDataTemplateAttributes                                                                       
 --ORDER BY RowNumber        
       
 drop table #HealthDataTemplates   
 drop  table #FinalHealthDataTemplates            
--drop  table #FinalHealthDataTemplateAttributes  
    
    
END TRY                  
BEGIN CATCH                  
 DECLARE @Error varchar(8000)                                                                 
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCHealthDataTemplates')                                                                                               
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