
/****** Object:  UserDefinedFunction [dbo].[ssp_GetDFAMutitabDetailPageSchema]    Script Date: 12/27/2017 18:04:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDFAMutitabDetailPageSchema]'))
DROP PROCEDURE [dbo].[ssp_GetDFAMutitabDetailPageSchema]
GO


/****** Object:  UserDefinedFunction [dbo].[ssp_GetDFAMutitabDetailPageSchema]    Script Date: 12/27/2017 18:04:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.ssp_GetDFAMutitabDetailPageSchema 
@ScreenId INT                 
               
AS           
/************************************************************************************************                              
**  File:                                                 
**  Name: ssp_GetDFAMutitabDetailPageSchema                                                
**  Desc:   
**      
**  Parameters:       
**  Input        
**  Output     ----------       -----------       
**        
**  Author:  Rajesh     
**      
*************************************************************************************************      
**  Change History        
*************************************************************************************************       
**  Date:   Author:   Description:       
**  25/07/2018 Rajesh Engineering improvement initiative - 627 - Added recorddeleted condition
*************************************************************************************************/   
BEGIN          
BEGIN TRY        
        
        
           
 DECLARE @TableName Table          
 (          
  TableName varchar(300)   
  ,FormOrder INT         
 )           
           
 INSERT INTO @TableName (TableName,FormOrder)         
 SELECT  
  F.TableName  
  ,FF.FormOrder  
 FROM  
  ScreenObjectCollections SO   
  JOIN FormCollections FC ON FC.FormCollectionId = SO.FormCollectionId  
  JOIN FormCollectionForms FF ON FF.FormCollectionId = FC.FormCollectionId  
  JOIN Forms F ON F.FormId = FF.FormId  
 WHERE   
  SO.ScreenId=@ScreenId  
  AND ISNULL(SO.RecordDeleted,'N')='N'
  AND ISNULL(FF.RecordDeleted,'N')='N'
  AND ISNULL(FC.RecordDeleted,'N')='N'
  AND FF.FormOrder IS NOT NULL  
 UNION  
 SELECT  
  F.TableName  
  ,FF.FormOrder  
 FROM  
  ScreenObjectCollections SO   
  JOIN FormCollections FC ON FC.FormCollectionId = SO.FormCollectionId  
  JOIN FormCollectionForms FF ON FF.FormCollectionId = FC.FormCollectionId  
  JOIN Forms F ON F.FormId = FF.FormId  
 WHERE   
  SO.ScreenId=@ScreenId  
  AND ISNULL(SO.RecordDeleted,'N')='N'
  AND ISNULL(FF.RecordDeleted,'N')='N'
  AND ISNULL(FC.RecordDeleted,'N')='N'
  AND FF.FormOrder IS NULL  
    
DECLARE @PrimaryTableName  varchar(300)   
 SET @PrimaryTableName = (SELECT TOP 1 TABLENAME FROM @TableName WHERE FormOrder=1)  
--Get Primary key of the table            
 DECLARE @PrimaryKey VARCHAR(300)            
             
 SELECT @PrimaryKey = COLUMN_NAME            
 FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE            
 WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1            
 AND TABLE_NAME = @PrimaryTableName---'Forms'             
   PRINT @PrimaryKey            
         
    
      
       
 DECLARE @SelectTables NVARCHAR(MAX)          
           
 SET @SelectTables = (          
           
 SELECT STUFF((          
 SELECT ' SELECT * FROM '+tablename+'  WHERE 1=0'      
  FROM @TableName FOR XML PATH(''),TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''))       
  PRINT @SelectTables       
 EXECUTE sp_executesql @SelectTables          
         
 END TRY        
 BEGIN CATCH        
 DECLARE @ErrorMessage NVARCHAR(MAX)            
 DECLARE @ErrorSeverity INT            
 DECLARE @ErrorState INT    SET @ErrorMessage =  ERROR_MESSAGE()            
 SET @ErrorSeverity =  ERROR_SEVERITY()            
 SET @ErrorState =  ERROR_STATE()            
 RAISERROR  (@ErrorMessage,@ErrorSeverity,@ErrorState);           
 END CATCH        
           
END  
  
  