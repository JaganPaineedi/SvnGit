--Validation scripts for Task #10 in Camino customization 
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       13-11-2015	    Lakshmi Kanth		Created                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 60000 and TableName = 'CustomDocumentPsychiatricNoteGenerals'

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','AdultChildAdolescent','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND AdultChildAdolescent is null  ','Adult or Child/Adolescent must be selected','1','Adult or Child/Adolescent must be selected','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','AppointmentType','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND AppointmentType is null  ','Walk-in or Scheduled Appointment required','2','Walk-in or Scheduled Appointment required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)
--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','PresentingProblem','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND PresentingProblem is null  ','Initial Presenting Problem is required','2','Initial Presenting Problem is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)



INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','ChiefComplaint','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ChiefComplaint,'''')='''' ','Chief Complaint is required','2','Chief Complaint is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','SideEffects','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId  AND isnull(SideEffects,'''') = '''' AND isnull(SideEffectsComments,'''') = '''' ','Side effects is required','3','Side effects is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','SideEffects','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND isnull(SideEffects,'''') = ''S'' AND isnull(SideEffectsComments,'''') = '''' ',' Side effects Text is required','4',' Side effects Text is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','SideEffectsComments','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SideEffectsComments,'''')=''''  ','General  – Side effects is required','5','General  – Side effects is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','PsychiatricHistory','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId   AND ISNULL(PsychiatricHistory,'''')='''' ','History – Psychiatric History is required','5','History – Psychiatric History is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null) --added 02-03-2016



INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','PsychiatricHistory','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId   AND ISNULL(PsychiatricHistoryComments,'''')='''' ','History – Psychiatric History comment box is required','6','History – Psychiatric History comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','PsychiatricHistoryComments','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsychiatricHistoryComments,'''')='''' ','General – History – Psychiatric History comment box is required','7','General – History – Psychiatric History comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','FamilyHistory','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(FamilyHistory,'''')='''' ','History – Family History is required','7','History – Family History is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null) --added 02-03-2016


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','FamilyHistory','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(FamilyHistoryComments,'''')='''' ','History – Family History comment box is required','8','History – Family History comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','FamilyHistoryComments','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FamilyHistoryComments,'''')='''' ','General – History – Family History comment box is required','9','History – Family History comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','SocialHistory','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SocialHistory,'''')='''' ','History – Social History is required','9','History – Social History is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null) 
--added 03-02-2015

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','SocialHistory','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId   AND ISNULL(SocialHistoryComments,'''')='''' ','History – Social History comment box is required','10','History – Social History comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','SocialHistoryComments','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SocialHistoryComments,'''')='''' ','General – History – Social History comment box is required','11','General – History – Social History comment box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General',1,'CustomDocumentPsychiatricNoteGenerals',Null,'FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND 
ISNULL(ReviewPsychiatric,''N'')=''N'' And 
ISNULL(ReviewMusculoskeletal,''N'')=''N'' And
ISNULL(ReviewConstitutional,''N'')=''N'' And
ISNULL(ReviewEarNoseMouthThroat,''N'')=''N'' And
ISNULL(ReviewGenitourinary,''N'')=''N'' And
ISNULL(ReviewGastrointestinal,''N'')=''N'' And
ISNULL(ReviewIntegumentary,''N'')=''N'' And
ISNULL(ReviewEndocrine,''N'')=''N'' And
ISNULL(ReviewNeurological,''N'')=''N'' And
ISNULL(ReviewImmune,''N'')=''N'' And
ISNULL(ReviewEyes,''N'')=''N'' And
ISNULL(ReviewRespiratory,''N'')=''N'' And
ISNULL(ReviewCardio,''N'')=''N'' And
ISNULL(ReviewHemLymph,''N'')=''N'' And
ISNULL(ReviewOthersNegative,''N'')=''N'' ','Review of Systems – at least one check box is required ',11,'Review of Systems – at least one check box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','ReviewComments','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReviewComments,'''')='''' ','General – Review of Systems – at least one check box is required','13','General – Review of Systems – at least one check box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','DrugAllergies','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND DrugAllergies is null  ','Allergy is required','10','Allergy is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','AllergiesSmoke','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND AllergiesSmoke is null  ','Allergies/Substance Use Hx/Medical Problems – Non-smoker/Smoker is required','12','Allergies/Substance Use Hx/Medical Problems – Non-smoker/Smoker is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','AllergiesSmokePerday','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND AllergiesSmokePerday is null AND isnull(AllergiesSmoke,'''') = ''S'' AND isnull(AllergiesSmokePerday,'''') = ''''','Allergies/Substance Use Hx/Medical Problems – specify # of cigarettes per day is required','13','Allergies/Substance Use Hx/Medical Problems – specify # of cigarettes per day is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'General','1','CustomDocumentPsychiatricNoteGenerals','Pregnant','FROM CustomDocumentPsychiatricNoteGenerals WHERE DocumentVersionId=@DocumentVersionId AND Pregnant is null  ','Pregnant is required','11','Pregnant is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)





