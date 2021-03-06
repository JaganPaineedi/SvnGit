/****** Object:  UserDefinedFunction [dbo].[GetDocumentValidations]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentValidations]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetDocumentValidations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDocumentValidations]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE function [dbo].[GetDocumentValidations]  (@DocumentCodeId int, @DocumentType varchar(20), @DocumentVersionId int)  
returns varchar(max)  
as  
BEGIN  
  
 Declare @sql varchar(max)  
 Declare @CurrentDocumentValidationId int  
 Declare @EndDocumentValidationId int  
  
  
 Select @CurrentDocumentValidationId = min(DocumentValidationId),  
     @EndDocumentValidationId = max(DocumentValidationId)  
 From DocumentValidations  
 Where DocumentCodeId = @DocumentCodeId  
 and Active = ''Y''  
 and ( DocumentType = @DocumentType or DocumentType is null ) --HRM Assessment types (MH,SA,DD) + Client Age (C,A)  
 and isnull(RecordDeleted, ''N'')= ''N''  
  
  
 While @CurrentDocumentValidationId <= @EndDocumentValidationId  
  Begin  
  
   IF @Sql is null  
    Begin  
    Set @Sql = (select ''SELECT '' + ''''''''+ isnull(dv.TableName, '''') + '''''''' + '' , '' + ''''''''   
	   + isnull(dv.ColumnName, '''') + '''''''' + '', '' +  
       '''' + '''''''' + isnull(dv.TabName, '''') + Case When dv.TabName is null Then '''' Else '' - '' End + isnull(dv.ErrorMessage, '''') + ''''''''  
       + '', '' + '''''''' + isnull(convert(varchar(max),dv.TabOrder),'''') + ''''''''  
       + '', '' + '''''''' + isnull(convert(varchar(max),dv.ValidationOrder),'''') + ''''''''  
       + '' '' + dv.ValidationLogic  
        from DocumentValidations dv 
       where dv.DocumentValidationId = @CurrentDocumentValidationId  
       and ( dv.DocumentType = @DocumentType or dv.DocumentType is null )
       -- Eliminate Validations in which there was an approved override
			and not exists
			(Select * from CustomDocumentValidationExceptions cde
			where cde.DocumentVersionId = @DocumentVersionId
			and cde.documentValidationId = dv.DocumentValidationId
			and cde.ValidToDate >= getdate())
       and isnull(dv.RecordDeleted,''N'')=''N'')  
    End  
   Else  
    Begin  
    Set @Sql = @Sql + '' UNION '' +   
       (select ''SELECT '' + ''''''''+ isnull(dv.TableName, '''') + '''''''' + '' , '' + ''''''''   
       + isnull(dv.ColumnName, '''') + '''''''' + '', '' +  
       '''' + '''''''' + isnull(dv.TabName, '''') + Case When dv.TabName is null Then '''' Else '' - '' End + isnull(dv.ErrorMessage, '''') + ''''''''  
       + '', '' + '''''''' + isnull(convert(varchar(max),dv.TabOrder),'''') + ''''''''  
       + '', '' + '''''''' + isnull(convert(varchar(max),dv.ValidationOrder),'''') + ''''''''  
       + '' '' + dv.ValidationLogic  
        from DocumentValidations dv 
       where dv.DocumentValidationId = @CurrentDocumentValidationId  
       and ( dv.DocumentType = @DocumentType or dv.DocumentType is null )
       -- Eliminate Validations in which there was an approved override
			and not exists
			(Select * from CustomDocumentValidationExceptions cde
			where cde.DocumentVersionId = @DocumentVersionId
			and cde.documentValidationId = dv.DocumentValidationId
			and cde.ValidToDate >= getdate())
       and isnull(dv.RecordDeleted,''N'')=''N'')  
    End  
  
   Set @CurrentDocumentValidationId = (Select min(DocumentValidationId)   
            From DocumentValidations   
            Where DocumentCodeId = @DocumentCodeId  
            AND DocumentValidationId > @CurrentDocumentValidationId  
            and ( DocumentType = @DocumentType or DocumentType is null )  
            AND Active = ''Y''  
            AND isnull(RecordDeleted, ''N'')= ''N''  
  
            )  
  
  End  
  
  
 return(@Sql)  
END  
  
' 
END
GO
