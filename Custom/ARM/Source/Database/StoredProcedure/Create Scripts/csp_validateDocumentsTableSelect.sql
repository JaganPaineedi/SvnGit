/****** Object:  StoredProcedure [dbo].[csp_validateDocumentsTableSelect]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentsTableSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateDocumentsTableSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentsTableSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE      PROCEDURE [dbo].[csp_validateDocumentsTableSelect]  
@DocumentVersionId Int,  
@DocumentCodeId Int,  
@DocumentType varchar(20),  
@Variables varchar(max)  
as  
  
  
Declare @sql varchar(max)  
  
  
set @Sql = @Variables +  '' '' +   
''Insert into #validationReturnTable  
(TableName,  
ColumnName,  
ErrorMessage,  
TabOrder,  
ValidationOrder  
)''  
+ '' '' + dbo.GetDocumentValidations(@DocumentCodeId,@DocumentType,@DocumentVersionId)  
   
  
  
exec (@sql)
' 
END
GO
