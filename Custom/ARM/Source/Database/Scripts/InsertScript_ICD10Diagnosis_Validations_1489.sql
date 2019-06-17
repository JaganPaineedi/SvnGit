IF not exists (Select * from DocumentValidations Where DocumentCodeId = 1489 AND  ErrorMessage = 'Only one primary type should be available')  
BEGIN
INSERT INTO DocumentValidations (DocumentCodeId,Active,DocumentType,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage)Values (1489,'Y',10,'DocumentDiagnosisCodes','DiagnosisType','From DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and ((Select Count(*) AS RecordCount from DocumentDiagnosisCodes WHERE DocumentVersionId =  @DocumentVersionId AND DiagnosisType = 140 AND ISNULL(RecordDeleted,''N'') = ''N'') > 1) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)','Only one primary type should be available',1,'Only one primary type should be available')
END
ELSE
BEGIN
UPDATE DocumentValidations SET DocumentCodeId = 1489,Active = 'Y',DocumentType = 10,TableName = 'DocumentDiagnosisCodes',ColumnName = 'DiagnosisType',ValidationLogic = 'From DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and ((Select Count(*) AS RecordCount from DocumentDiagnosisCodes WHERE DocumentVersionId =  @DocumentVersionId AND DiagnosisType = 140 AND ISNULL(RecordDeleted,''N'') = ''N'') > 1) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)',ValidationDescription = 'Only one primary type should be available' ,ValidationOrder= 1,ErrorMessage = 'Only one primary type should be available'  Where DocumentCodeId = 1489 AND  ErrorMessage = 'Only one primary type should be available'
END

IF not exists (Select * from DocumentValidations Where DocumentCodeId = 1489 AND  ErrorMessage = 'Primary Diagnosis must have a billing order of 1')  
BEGIN
INSERT INTO DocumentValidations (DocumentCodeId,Active,DocumentType,TableName,ColumnName,ValidationLogic,ValidationDescription,ValidationOrder,ErrorMessage)Values (1489,'Y',10,'DocumentDiagnosisCodes','DiagnosisType','where exists (Select 1 from #DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)','Primary Diagnosis must have a billing order of 1',1,'Primary Diagnosis must have a billing order of 1')
END
ELSE
BEGIN
UPDATE DocumentValidations SET DocumentCodeId = 1489,Active = 'Y',DocumentType = 10,TableName = 'DocumentDiagnosisCodes',ColumnName = 'DiagnosisType',ValidationLogic = 'where exists (Select 1 from #DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = ''Y'' and DocumentVersionId=@DocumentVersionId)',ValidationDescription = 'Primary Diagnosis must have a billing order of 1' ,ValidationOrder= 1,ErrorMessage = 'Primary Diagnosis must have a billing order of 1'  Where DocumentCodeId = 1489 AND  ErrorMessage = 'Primary Diagnosis must have a billing order of 1'
END