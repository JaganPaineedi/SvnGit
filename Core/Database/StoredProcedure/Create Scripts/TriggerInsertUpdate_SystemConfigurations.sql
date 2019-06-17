/****** Object:  Trigger [TriggerInsertUpdate_SystemConfigurations]    Script Date: 07/07/2016 18:37:01 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TriggerInsertUpdate_SystemConfigurations]'))
DROP TRIGGER [dbo].[TriggerInsertUpdate_SystemConfigurations]
GO

/****** Object:  Trigger [dbo].[TriggerInsertUpdate_SystemConfigurations]    Script Date: 07/07/2016 18:37:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TriggerInsertUpdate_SystemConfigurations] ON [dbo].[SystemConfigurations]
  FOR INSERT, UPDATE
/*********************************************************************  
-- Trigger: TriggerInsertUpdate_SystemConfigurations  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Updates:   
--  Date         Author       Purpose  
--  08.19.2016   VSinha      Created For Task #380 Engineering Improvement Initiatives- NBL(I)
--  
**********************************************************************/    
AS
BEGIN
BEGIN TRY
if trigger_nestlevel() > 2 return
BEGIN
CREATE TABLE #TMP
			(
			 ColumnName varchar(200),
			 ColumnValue varchar(max)
			)
DECLARE @sql nvarchar(max);
DECLARE @sql1 nvarchar(max);

SELECT @sql = COALESCE(@sql + ',','') + '(' + QUOTENAME(name,'''') + ',CONVERT(nvarchar(max),' + QUOTENAME(name) + '))'
FROM sys.all_columns
WHERE object_id = object_id('SystemConfigurations')

set @sql = 'SELECT t.[FieldName], t.[FieldValue]
   FROM SystemConfigurations
   CROSS APPLY (VALUES ' + @sql + ') AS t([FieldName], [FieldValue])
   --WHERE ISNULL(t.[FieldValue], '''') <> '''''

set @sql1='insert into #TMP '+ @sql

 EXECUTE sp_executesql @sql1
 
 IF   EXISTS (SELECT 1 from  SystemConfigurationKeys s1  JOIN #tmp t on s1.[Key] COLLATE DATABASE_DEFAULT =t.ColumnName COLLATE DATABASE_DEFAULT  
                               WHERE ISNULL(s1.Value, '') <> ISNULL(t.ColumnValue, '') )
 BEGIN 
 
 DECLARE @ModifiedBy varchar(100)
 DECLARE @ModifiedDate Datetime
 
				SELECT @ModifiedBy = ModifiedBy,
					  @ModifiedDate =ModifiedDate
				FROM SystemConfigurations 
 
				 SELECT [Key],
						Value 
				 INTO #tempSystemConfigurationKeys 
				 FROM SystemConfigurationKeys
 

				UPDATE  S  
				SET S.Value=t.ColumnValue
					,S.ModifiedBy=@ModifiedBy
					,S.ModifiedDate=GETDATE()
				FROM SystemConfigurationKeys S 
					JOIN #TMP t on S.[Key] COLLATE DATABASE_DEFAULT =t.ColumnName COLLATE DATABASE_DEFAULT  
				WHERE ISNULL(S.Value,'') <> ISNULL(t.ColumnValue,'')
                                                        
DECLARE @TableId int
SET @TableId = (SELECT AuditLogTableId FROM dbo.AuditLogTables WHERE TableName = 'SystemConfigurations' AND isnull(RecordDeleted, 'N') = 'N')
if trigger_nestlevel() = 1
BEGIN
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
				SELECT  @ModifiedBy
						,GETDATE()
						,@ModifiedBy
						,GETDATE()
						,@TableId
						,1
						,(SELECT StaffId FROM Staff WHERE UserCode = @modifiedby)
						,t.ColumnName
						, CASE 
						  WHEN s.Value IS NOT NULL THEN '[OldValue] - '+s.Value
                          ELSE NULL
                          END
                        , CASE
						  WHEN t.ColumnValue IS NOT NULL THEN '[NewValue] - '+t.ColumnValue
                          ELSE NULL
                          END
				FROM #tmp t  
				JOIN #tempSystemConfigurationKeys s ON t.ColumnName = s.[Key] 
				WHERE ISNULL(t.ColumnValue, '') <> ISNULL(s.Value, '')
 END   
 END 

END
 drop table #tmp;
END

END TRY
BEGIN CATCH
DECLARE @Error varchar(8000)                                                                                                                                 
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'TriggerInsertUpdate_SystemConfigurations')                     
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                      
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                            
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )     

END CATCH
END

GO



