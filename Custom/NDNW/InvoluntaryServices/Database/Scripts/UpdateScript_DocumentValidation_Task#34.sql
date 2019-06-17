IF EXISTS(SELECT TOP 1 * FROM DocumentValidations WHERE DocumentCodeId=28812 AND TableName='CustomDocumentInvoluntaryServices' AND TabName='Involuntary Services' AND ColumnName='SIDNumber')
 BEGIN 
    UPDATE DocumentValidations SET ValidationLogic='FROM CustomDocumentInvoluntaryServices WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SIDNumber,'''')='''' AND ISNULL(RecordDeleted,''N'')=''N''' WHERE DocumentCodeId=28812 AND TableName='CustomDocumentInvoluntaryServices' AND TabName='Involuntary Services' AND ColumnName='SIDNumber'
 END
