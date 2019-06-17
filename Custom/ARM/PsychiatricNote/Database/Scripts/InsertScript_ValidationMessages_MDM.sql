--Validation scripts for Task #651 in Network 180 customization.
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       22/July/2015	Vijay			    Created                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 60000 and TableName = 'CustomDocumentPsychiatricNoteMDMs'

--nursepillbox

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','NurseMonitorPillBox','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(NurseMonitorPillBox,'''') = '''' ','Nurse will monitor pill box – Nurse will monitor pill box is required.','1','Nurse will monitor pill box – Nurse will monitor pill box is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','NurseMonitorFrequency','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NurseMonitorPillBox,'''')=''Y'' and isnull(NurseMonitorFrequency,'''') = '''' ','Nurse will monitor pill box – Nurse will monitor pill box frequency is required.','2','Nurse will monitor pill box – Nurse will monitor pill box frequency is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','NurseMonitorFrequencyOther','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NurseMonitorFrequency,'''')=''47435'' and isnull(NurseMonitorFrequencyOther,'''') = '''' ','Nurse will monitor pill box – frequency other textbox is required.','3','Nurse will monitor pill box – frequency other textbox is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--nursepillbox end

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','Other','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Other,'''')=''Y'' and isnull(MedicalRecordsComments,'''') = '''' ','Medical Records Reviewed – Comments is required when Other is selected.','4','Medical Records Reviewed – Comments is required when Other is selected.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','MedicalRecordsRelevantResults','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId And ISNULL(Labs,''N'')=''Y''  and isnull(MedicalRecordsRelevantResults,'''') = '''' ','Medical Records Reviewed – Relevant Result is required when Other or labs is selected.','4','Medical Records Reviewed – Relevant Result is required when Other or labs is selected.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)




--Medical Decision Making 
--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingSchizophrenia','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingSchizophrenia,'''') = '''' ','Medical Decision Making – Problem 1 – Comment is required.','5','Medical Decision Making – Problem 1 – Comment is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingSchizophreniaStatus','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingSchizophreniaStatus,'''') = '''' ','Medical Decision Making – Problem 1 – Status is required.','6','Medical Decision Making – Problem 1 – Status is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingAnxiety','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingAnxiety,'''') = '''' ','Medical Decision Making – Problem 2 – Comment is required.','7','Medical Decision Making – Problem 2 – Comment is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingSchizophreniaStatus','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingAnxietyStatus,'''') = '''' ','Medical Decision Making – Problem 2 – Status is required.','8','Medical Decision Making – Problem 2 – Status is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingWeightLoss','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingWeightLoss,'''') = '''' ','Medical Decision Making – Problem 3 – Comment is required.','9','Medical Decision Making – Problem 3 – Comment is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingWeightLossStatus','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingWeightLossStatus,'''') = '''' ','Medical Decision Making – Problem 3 – Status is required.','10','Medical Decision Making – Problem 3 – Status is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingInsomnia','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingInsomnia,'''') = '''' ','Medical Decision Making – Problem 4 – Comment is required.','11','Medical Decision Making – Problem 4 – Comment is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','DecisionMakingInsomniaStatus','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId  and isnull(DecisionMakingInsomniaStatus,'''') = '''' ','Medical Decision Making – Problem 4 – Status is required.','12','Medical Decision Making – Problem 4 – Status is required.','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--Medical Decision Making end


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','PatientConsent','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND PatientConsent is null  ','Plan – Patient/Parent/Guardian voiced understanding and gave consent for the above treatment plan is required','13','Plan – Patient/Parent/Guardian voiced understanding and gave consent for the above treatment plan is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','3','CustomDocumentPsychiatricNoteMDMs','PatientConsent','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MedicationsReviewed,'''')='''' ','The medications below were reviewed with the client is required','2','Medical Records Reviewed – The medications below were reviewed with the client is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','4','CustomDocumentPsychiatricNoteMDMs','RisksBenefits','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RisksBenefits,'''')='''' ','Risk/benefits have been discussed with client and understood is required','14','Medications – Risk/benefits have been discussed with client and understood is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Medical Decision Making','4','CustomDocumentPsychiatricNoteMDMs','RisksBenefitscomment','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RisksBenefits,'''')=''N'' AND ISNULL(RisksBenefitscomment,'''')='''' ','Risk/benefits have been discussed with client and understood Comment is required','15','Medications – Risk/benefits have been discussed with client and understood Comment is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)




--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','4','CustomDocumentPsychiatricNoteMDMs','SideEffects','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SideEffects,'''')='''' ','Side effects is required','4','Medications– Side effects is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
--VALUES( 'Y','60000',Null,'Medical Decision Making','4','CustomDocumentPsychiatricNoteMDMs','InformationAndEducation','FROM CustomDocumentPsychiatricNoteMDMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(InformationAndEducation,'''')='''' ','Medications – Information and education is required','5','Medications – Information and education is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


 --Diagnosis


	
--	INSERT [dbo].[DocumentValidations] (
--	[Active]
--	,[DocumentCodeId]
--	,[DocumentType]
--	,[TabName]
--	,[TabOrder]
--	,[TableName]
--	,[ColumnName]
--	,[ValidationLogic]
--	,[ValidationDescription]
--	,[ValidationOrder]
--	,[ErrorMessage]
--	)
--VALUES (
--	N'Y'
--	,60000
--	,NULL
--	,'Diagnosis'
--	,5
--	,N'CustomDocumentPsychiatricNoteGenerals'
--	,N'DocumentVersionId'
--	,N'FROM CustomDocumentPsychiatricNoteGenerals CD where (select count(documentversionid) from DocumentDiagnosisCodes dc where documentversionid = @DocumentVersionId and IsNull(dc.RecordDeleted, ''N'') = ''N'' ) = 0  '
--	,N'Please specify a diagnosis code and description'
--	,50
--	,N'Please specify a diagnosis code and description'
--	)


