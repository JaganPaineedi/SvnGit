UPDATE documentvalidations
SET ValidationLogic = N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (AgeOfFirstUseText1 is  NULL AND DrugName1 is NOT NULL and AgeOfFirstUse1 IS NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
WHERE [DocumentCodeId] = 46221
	AND [TabName] = 'Substance Use'
	AND [ColumnName] = N'AgeOfFirstUseText1'

UPDATE documentvalidations
SET ValidationLogic = N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (AgeOfFirstUseText2 is  NULL AND DrugName2 is NOT NULL and AgeOfFirstUse2 IS NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
WHERE [DocumentCodeId] = 46221
	AND [TabName] = 'Substance Use'
	AND [ColumnName] = N'AgeOfFirstUseText2'

UPDATE documentvalidations
SET ValidationLogic = N'FROM CustomDocumentSUDischarges WHERE DocumentVersionId=@DocumentVersionId AND  (AgeOfFirstUseText3 is  NULL AND DrugName3 is NOT NULL and AgeOfFirstUse3 IS NULL) and ISNULL(RecordDeleted,''N'') = ''N'''
WHERE [DocumentCodeId] = 46221
	AND [TabName] = 'Substance Use'
	AND [ColumnName] = N'AgeOfFirstUseText3'
