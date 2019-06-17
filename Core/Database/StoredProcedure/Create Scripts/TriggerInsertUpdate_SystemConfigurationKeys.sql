/****** Object:  Trigger [TriggerInsertUpdate_SystemConfigurationKeys]    Script Date: 07/07/2016 18:37:01 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerInsertUpdate_SystemConfigurationKeys]'))
DROP TRIGGER [dbo].[TriggerInsertUpdate_SystemConfigurationKeys]
GO

/****** Object:  Trigger [dbo].[TriggerInsertUpdate_SystemConfigurationKeys]    Script Date: 07/07/2016 18:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TriggerInsertUpdate_SystemConfigurationKeys] ON [dbo].[SystemConfigurationKeys]
  FOR INSERT, UPDATE
/*********************************************************************  
-- Trigger: TriggerInsertUpdate_SystemConfigurationKeys  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Updates:   
--  Date         Author       Purpose  
--  08.19.2016   VSinha      Created For Task #380 Engineering Improvement Initiatives- NBL(I)
--  
**********************************************************************/    
AS
Begin
Begin Try

if trigger_nestlevel() > 1 return
BEGIN
DECLARE @PrimaryKeyValue int
DECLARE @column varchar(200)
DECLARE @oldvalue varchar(MAX)
DECLARE @value varchar(MAX)
DECLARE @tablename varchar(100)
DECLARE @modifiedby varchar(100)
DECLARE @SqlQuery NVARCHAR(1000)

SELECT 
@PrimaryKeyValue=i.SystemConfigurationKeyId
,@column=i.[Key]
,@value=i.Value
,@tablename=i.SourceTableName
,@modifiedby=i.ModifiedBy 
FROM INSERTED i
SELECT @oldvalue= d.Value FROM DELETED d

IF  EXISTS (SELECT 1 from  INSERTED i  JOIN DELETED d on i.[Key] = d.[Key] WHERE ISNULL(i.Value, '') <> ISNULL(d.Value, '') )
BEGIN                               
                               
IF(@value IS NULL)
BEGIN

SET @value= 'Null'
SET @SqlQuery='UPDATE'+' '+@tablename+' '+'SET'+' '+'['+@column+']'+'='+' '+@value+', [ModifiedBy]= '+''''+@modifiedby+''''+', [ModifiedDate]= '+''''+cast (GETDATE() AS VARCHAR(100))+''''
SET @value = NULL
END;

ELSE
BEGIN
SET @SqlQuery='UPDATE'+' '+@tablename+' '+'SET'+' '+'['+@column+']'+'='''+@value+''''+', [ModifiedBy]= '+''''+@modifiedby+''''+', [ModifiedDate]= '+''''+cast (GETDATE() AS VARCHAR(100))+''''
PRINT @SqlQuery
END;
EXECUTE sp_executesql @SqlQuery

DECLARE @TableId int
SET @TableId = (SELECT AuditLogTableId FROM dbo.AuditLogTables WHERE TableName = 'SystemConfigurationKeys' AND isnull(RecordDeleted, 'N') = 'N' )
IF EXISTS (SELECT 1 FROM dbo.AuditLogTables WHERE AuditLogTableId = @TableId)
 BEGIN
		 INSERT INTO AuditLog 
						(CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,AuditLogTableId
						,PrimaryKeyValue
						,StaffId
						,ColumnName
						,OldValue
						,NewValue
						) 
				VALUES	(@modifiedby
						,GETDATE()
						,@modifiedby
						,GETDATE()
						,@TableId
						,@PrimaryKeyValue
						,(SELECT StaffId FROM Staff WHERE UserCode = @modifiedby)
						,@column
						, CASE 
						  WHEN @oldvalue IS NOT NULL THEN '[OldValue] - '+@oldvalue
                          ELSE NULL
                          END
                        , CASE
						  WHEN @value IS NOT NULL THEN '[NewValue] - '+@value
                          ELSE NULL
                          END
				) 
 
 END
END
END 
END TRY                                                                                                 
BEGIN CATCH                                                   
   DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'TriggerInsertUpdate_SystemConfigurationKeys')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                                
END CATCH          
END

GO
