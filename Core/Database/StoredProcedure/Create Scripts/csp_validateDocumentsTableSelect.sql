IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentsTableSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE csp_validateDocumentsTableSelect
GO

CREATE PROCEDURE [dbo].[csp_validateDocumentsTableSelect]  
@DocumentVersionId Int,  
@DocumentCodeId Int,  
@DocumentType varchar(20),  
@Variables varchar(max)  
as  
  
  
Declare @sql varchar(max)  
  
  
set @Sql = @Variables +  ' ' +   
'Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage,  
TabOrder,  
ValidationOrder  
)'  
+ ' ' + dbo.GetDocumentValidations(@DocumentCodeId,@DocumentType,@DocumentVersionId)  
   
  
  
exec (@sql)  
  
GO