
IF NOT EXISTS (SELECT 1 FROM DocumentValidations WHERE DocumentCodeId=1628 AND ErrorMessage='Diagnosis List – Please correct the duplicate diagnosis order' AND TableName='InpatientCodingDocuments')
BEGIN
INSERT INTO DocumentValidations 
            (Active, 
             DocumentCodeId, 
             TabOrder, 
             TableName, 
             ColumnName, 
             ValidationLogic, 
             ValidationDescription, 
             ValidationOrder, 
             ErrorMessage) 
VALUES      ('Y', 
             1628, 
             1, 
             'InpatientCodingDocuments', 
             'DischargeType', 
             'FROM InpatientCodingDiagnoses
			  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N''
			  GROUP BY DiagnosisOrder
			  HAVING COUNT(DiagnosisOrder) > 1', 
             'Diagnosis List – Please correct the duplicate diagnosis order', 
             8, 
             'Diagnosis List – Please correct the duplicate diagnosis order') 
END