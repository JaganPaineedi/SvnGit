--Script to update FormType in Forms Table for existing records-----
--------------------------------------------------------------------

DECLARE @DocumentFormType  INT 
DECLARE @CustomFieldsFormType  INT 
SET @DocumentFormType = 9469

SET @CustomFieldsFormType = 9468
--select @DocumentFormType,@CustomFieldsFormType
DECLARE @TableName VARCHAR(200)
DECLARE @FormId INT
DECLARE FormCursor  CURSOR 
FOR
SELECT FormId,TableName FROM FORMS
OPEN FormCursor
FETCH NEXT FROM FormCursor INTO @FormId,@TableName
BEGIN TRANSACTION
BEGIN TRY
WHILE @@FETCH_STATUS = 0
BEGIN
	 IF EXISTS(SELECT *
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
        JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON tc.CONSTRAINT_NAME = ccu.Constraint_name
    WHERE tc.CONSTRAINT_TYPE = 'Primary Key' AND tc.Table_Name=@TableName AND LOWER(Column_Name)='documentversionid')
    BEGIN
		--UPDATE @Forms SET FormType = 46847 WHERE FormId = @FormId
		--UPDATE @Forms SET FormType = 46847 WHERE CURRENT OF FormCursor
		UPDATE Forms SET FormType = @DocumentFormType WHERE FormId = @FormId --AND FormType IS NULL--CURRENT OF FormCursor
		
		
    END	
    ELSE 
    BEGIN
    
		UPDATE Forms SET FormType = @CustomFieldsFormType WHERE FormId = @FormId --AND FormType IS NULL -- CURRENT OF FormCursor  
    END

	 FETCH NEXT FROM FormCursor INTO @FormId,@TableName
END
END TRY
BEGIN CATCH
 ROLLBACK TRANSACTION
  RAISERROR ('Error while updating forms table',16, 1)
END CATCH
IF @@TranCount>0 
 COMMIT TRANSACTION
CLOSE FormCursor
DEALLOCATE FormCursor

