IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[SSP_DFACreateTable]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[SSP_DFACreateTable]
END
Go     
/*********************************************************************/              
/* Stored Procedure: dbo.SSP_DFACreateTable    --1629         */              
/* Copyright:             */              
/* Creation Date:  12-06-2017                                  */              
/*                                                                   */              
/* Purpose:Create Table          */             
/*                                                                   */            
/* Input Parameters:       */            
/*                                                                   */              
/* Output Parameters:                                */              
/*                                                                   */              
/* Return: */              
/*                                                                   */              
/* Called By:                                                        */              
/*                                                                   */              
/* Calls:                                                            */              
/*                                                                   */              
/* Data Modifications:                                               */              
/*                                                                   */              
/* Updates:                                                          */              
/*  Date        	 Author      Purpose                                    */              
/* 06/12/2017   Rajesh S      Created                                    */              
/*********************************************************************/   
CREATE Procedure [dbo].[SSP_DFACreateTable]      
(      
@TableName  varchar(100),      
@type varchar(2),      
@For varchar(100),        
@PrimaryTableName varchar(200),   
@IsPrimary INT        
      
)      
AS      
SET NOCOUNT ON     
DECLARE @Exist VARCHAR(3)         
BEGIN        
        
  BEGIN TRY        
  DECLARE @SQL nVARCHAR(MAX)        
    IF (@type='D')        
    BEGIN        
  -- declare @sql nvarchar(max)        
   --set @sql = 'select ''' + ntableName + ''''        
  set @SQL = ' CREATE TABLE ['+@TableName+']        
 (        
 [DocumentVersionId] [int] NOT NULL,        
 [CreatedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [RecordDeleted] [dbo].[type_YOrN] NULL,        
 [DeletedBy] [dbo].[type_UserId] NULL,        
 [DeletedDate] [datetime] null        
 )        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT ['+@tableName+'_PK] PRIMARY KEY CLUSTERED  ([DocumentVersionId]) WITH (FILLFACTOR=80) ON [PRIMARY]        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT [DocumentVersions_'+@tableName+'_FK] FOREIGN KEY ([DocumentVersionId]) REFERENCES [dbo].[DocumentVersions] ([DocumentVersionId])'        
 --print @sql        
 SET @Exist=0        
-- SELECT @Exist=        
 exec SP_ExecuteSQL @SQL        
 --PRINT @Exist        
 --RETURN        
        
END        
        
--ELSE        
         
IF (@type='C')        
BEGIN        
DECLARE @PrimaryKey varchar(max)        
        
--select @PrimaryKey= c.name from sys.tables as t join sys.columns as c on c.object_id = t.object_id where t.name =@For and c.is_identity = 1        
  SELECT @PrimaryKey= Col.Column_Name from     
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab,     
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col     
WHERE     
    Col.Constraint_Name = Tab.Constraint_Name    
    AND Col.Table_Name = Tab.Table_Name    
    AND Constraint_Type = 'PRIMARY KEY'    
    AND Col.Table_Name = @For       
        
  --Declare @SQ nvarchar (MAX)        
  set @SQL='CREATE TABLE['+@TableName+']        
  (        
    ['+@PrimaryKey+'] [int] NOT NULL,        
    [CreatedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [RecordDeleted] [dbo].[type_YOrN] NULL,        
 [DeletedBy] [dbo].[type_UserId] NULL,        
 [DeletedDate] [datetime] null        
 )        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT ['+@tableName+'_PK] PRIMARY KEY CLUSTERED  (['+@PrimaryKey+']) WITH (FILLFACTOR=80) ON [PRIMARY]        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT ['+@For+'_'+@tableName+'_FK] FOREIGN KEY (['+@PrimaryKey+']) REFERENCES [dbo].['+@For+'] (['+@PrimaryKey+'])'        
 SET @Exist=1        
 exec SP_ExecuteSQL @SQL        
 -- SELECT @Exist='YES';        
END    
  
  
        
IF (@type='Dt' AND @IsPrimary = 1)       
BEGIN        
PRINT 'HI'  
DECLARE @PrimaryTableId varchar(max)    
  
  
IF (LOWER(SUBSTRING(@TableName,len(@TableName),1))='s')  
SET @PrimaryTableId = SUBSTRING(@TableName,0,len(@TableName)) + 'id'  
ELSE  
    SET @PrimaryTableId = @TableName +'id'  
      
     
        
  --Declare @SQ nvarchar (MAX)        
  set @SQL='CREATE TABLE['+@TableName+']        
  (        
    ['+@PrimaryTableId+'] [int] identity(1,1) NOT NULL,        
    [CreatedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [RecordDeleted] [dbo].[type_YOrN] NULL,        
 [DeletedBy] [dbo].[type_UserId] NULL,        
 [DeletedDate] [datetime] null        
 )        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT ['+@tableName+'_PK] PRIMARY KEY CLUSTERED  (['+@PrimaryTableId+']) WITH (FILLFACTOR=80) ON [PRIMARY]        
 '        
 SET @Exist=1        
 exec SP_ExecuteSQL @SQL        
 -- SELECT @Exist='YES';        
END      
  
   
IF (@type='Dt' AND @IsPrimary = 0)        
BEGIN        
  
DECLARE @PrimaryKeyDt varchar(max)    
  
  
IF (LOWER(SUBSTRING(@TableName,len(@TableName),1))='s')  
SET @PrimaryKeyDt = SUBSTRING(@TableName,0,len(@TableName)) + 'id'  
ELSE  
    SET @PrimaryKeyDt = @TableName +'id'  
   
  
DECLARE @ForiegnKey varchar(max)        
        
--select @PrimaryKey= c.name from sys.tables as t join sys.columns as c on c.object_id = t.object_id where t.name =@For and c.is_identity = 1        
  SELECT @ForiegnKey= Col.Column_Name from     
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab,     
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col     
WHERE     
    Col.Constraint_Name = Tab.Constraint_Name    
    AND Col.Table_Name = Tab.Table_Name    
    AND Constraint_Type = 'PRIMARY KEY'    
    AND Col.Table_Name = @PrimaryTableName       
        
  --Declare @SQ nvarchar (MAX)        
  set @SQL='CREATE TABLE['+@TableName+']        
  (       
   ['+@PrimaryKeyDt+'] [int] IDENTITY(1,1) NOT NULL,    
    ['+@ForiegnKey+'] [int] NULL,        
    [CreatedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,        
 [ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,        
 [RecordDeleted] [dbo].[type_YOrN] NULL,        
 [DeletedBy] [dbo].[type_UserId] NULL,        
 [DeletedDate] [datetime] null        
 )        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT ['+@tableName+'_PK] PRIMARY KEY CLUSTERED  (['+@PrimaryKeyDt+']) WITH (FILLFACTOR=80) ON [PRIMARY]        
  ALTER TABLE [dbo].['+@tableName+'] ADD CONSTRAINT ['+@PrimaryTableName+'_'+@tableName+'_FK] FOREIGN KEY (['+@ForiegnKey+']) REFERENCES [dbo].['+@PrimaryTableName+'] (['+@ForiegnKey+'])'        
 SET @Exist=1        
 exec SP_ExecuteSQL @SQL        
 -- SELECT @Exist='YES';        
END        
        
--RETURN @Exist        
  END TRY        
BEGIN CATCH                
    DECLARE @Error varchar(8000)                                                               
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'CreateTableDFA')                                                                                             
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                              
    + '*****' + Convert(varchar,ERROR_STATE())                                          
   RAISERROR                                                                                             
  (                                                               
   @Error, -- Message text.                                                                                            
   16, -- Severity.      
   1 -- State.                                                                                            
   );                 
END CATCH        
RETURN @Exist        
SET NOCOUNT OFF        
END   