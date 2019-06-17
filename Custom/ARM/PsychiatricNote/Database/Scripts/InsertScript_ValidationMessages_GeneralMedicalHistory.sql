IF EXISTS(Select 1  from DocumentValidations where ColumnName='SocialHistory' AND ErrorMessage='History – Social History comment box is required' AND DocumentCodeId=60000)
BEGIN
UPDATE DocumentValidations SET ValidationOrder=9 where ColumnName='SocialHistory' AND ErrorMessage='History – Social History comment box is required' AND DocumentCodeId=60000  
END

IF NOT EXISTS(Select 1  from DocumentValidations where ColumnName='MedicalHistoryComments' AND ErrorMessage='History – Medical History comment box is required' AND DocumentCodeId=60000)
BEGIN
INSERT INTO [dbo].[DocumentValidations]
( [Active],
[DocumentCodeId],
[DocumentType],
[TabName],
[TabOrder],
[TableName],
[ColumnName],
[ValidationLogic],
[ValidationDescription],
[ValidationOrder],
[ErrorMessage],
[CreatedBy],
[CreatedDate],
[ModifiedBy],
[ModifiedDate],
[RecordDeleted],
[DeletedBy],
[DeletedDate],
[SectionName]) 
VALUES
( 'Y',
'60000',
Null,
'General',
'1',
'CustomDocumentPsychiatricNoteGenerals',
'MedicalHistoryComments',
'FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId   AND ISNULL(MedicalHistoryComments,'''')='''' ',
'History – Medical History comment box is required','10',
'History – Medical History comment box is required',
'admin',
GETDATE(),
'admin',
GETDATE(),
Null,
Null,
Null,
Null)
END

