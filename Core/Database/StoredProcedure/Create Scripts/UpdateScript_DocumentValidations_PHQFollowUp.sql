IF   EXISTS(SELECT * FROM DocumentValidations WHERE DocumentCodeId=1635 and ErrorMessage='Documentation of follow-up plan is required' and TableName = 'PHQ9Documents' and ColumnName = 'DocumentationFollowup')
BEGIN
Update [dbo].[DocumentValidations] set [ValidationLogic]=  N'FROM PHQ9Documents WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(OtherInterventions, ''N'') = ''Y'' AND ISNULL(DocumentationFollowup,'''')='''' AND ISNULL(ClientRefusedOrContraIndicated,''N'')=''N''  AND  ISNULL(RecordDeleted,''N'') = ''N'''  WHERE DocumentCodeId=1635 and ErrorMessage='Documentation of follow-up plan is required' and TableName = 'PHQ9Documents' and ColumnName = 'DocumentationFollowup'
END