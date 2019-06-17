

IF NOT EXISTS( SELECT 1 FROM DocumentValidations WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteGenerals' AND ColumnName='SubstanceUse')
BEGIN
INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General',1,'CustomDocumentPsychiatricNoteGenerals','SubstanceUse','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND SUOthers=''Y''  AND SubstanceUse is null','Allergies/Substance Use Hx - Substance Use Comment box is required ','10','Allergies/Substance Use Hx - Substance Use Comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)
END
ELSE
BEGIN
UPDATE DocumentValidations SET  ValidationLogic='FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND SUOthers=''Y''  AND SubstanceUse is null'
WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteGenerals' AND ColumnName='SubstanceUse'
END

UPDATE DocumentValidations SET  ErrorMessage ='Allergies/Substance Use Hx – Non-smoker/Smoker is required' 
WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteGenerals' AND ColumnName='AllergiesSmoke'

UPDATE DocumentValidations SET  ErrorMessage='Allergies/Substance Use Hx – specify # of cigarettes per day is required'
WHERE DocumentCodeId=60000 AND TableName='CustomDocumentPsychiatricNoteGenerals' AND ColumnName='AllergiesSmokePerday'


