IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InsertListPageConfigurationTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InsertListPageConfigurationTemplate]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

CREATE PROCEDURE [dbo].[ssp_InsertListPageConfigurationTemplate]  
@ScreenId INT  
,@StaffId INT  
,@ColumnNames VARCHAR(MAX)  
AS  
/******************************************************************************    
**  File:     
**  Name: ssp_InsertListPageConfigurationTemplate    
**  Desc:     
**    
**  This template can be customized:    
**                  
**  Return values:    
**     
**  Called by:       
**                  
**  Parameters:    
**    
**  Auth:     
**  Date:   
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:      Author:        Description:    
**  --------  --------    -------------------------------------------    
**        
*******************************************************************************/    
BEGIN  
  
  
 IF NOT EXISTS(SELECT 1   
     FROM ListPageColumnConfigurations   
     WHERE ScreenId = @ScreenId AND Template='Y')  
 BEGIN  
  INSERT INTO ListPageColumnConfigurations  
  (  
   ScreenId  
   ,StaffId  
   ,ViewName  
   ,Active  
   --,DefaultView  
   ,Template  
  )   
  VALUES  
  (  
   @ScreenId  
   ,@StaffId  
   ,'Original'  
   ,'Y'  
   ,'Y'  
  )  
    
 DECLARE @ListPageColumnConfigurationId INT  
 SELECT @ListPageColumnConfigurationId = SCOPE_IDENTITY()  
 --PRINT @ListPageColumnConfigurationId  
 INSERT INTO ListPageColumnConfigurationColumns(ListPageColumnConfigurationId,FieldName,Caption,DisplayAs,SortOrder,ShowColumn,Width)  
 SELECT @ListPageColumnConfigurationId,Token,Token,Token,Position,'Y',100 FROM dbo.SplitString(@ColumnNames,',')  
   
   
    
 END  
  
END  
  
  