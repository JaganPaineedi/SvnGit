--Validation scripts for DAST document.
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Description                   */
/*       11/APR/2018	Suneel N			Westbridge-Customizations-#4650                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 1651 and TableName = 'DocumentDASTs'

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','MedicalReason',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MedicalReason,'''')='''' ',
'Have you used drugs other than those required for medical reasons? Is required','1',
'DAST – Have you used drugs other than those required for medical reasons? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','PrescriptionDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrescriptionDrugs,'''')='''' ',
'Have you abused prescription drugs? Is required','2',
'DAST – Have you abused prescription drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','OneDrugAtATime',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(OneDrugAtATime,'''')='''' ',
'Do you abuse more than one drug at a time? Is required','3',
'DAST – Do you abuse more than one drug at a time? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','WeekWithoutDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(WeekWithoutDrugs,'''')='''' ',
'Can you get through the week without using drugs? (other than those required for a medical reason) is required','4',
'DAST – Can you get through the week without using drugs? (other than those required for a medical reason) is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','StopDrug',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(StopDrug,'''')='''' ',
'Are you always able to stop using drugs when you want to? Is required','5',
'DAST – Are you always able to stop using drugs when you want to? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','ContinuousDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ContinuousDrugs,'''')='''' ',
'Do you abuse drugs on a continuous basis? Is required','6',
'DAST – Do you abuse drugs on a continuous basis? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','LimitDrugsSituations',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LimitDrugsSituations,'''')='''' ',
'Do you try to limit your drug use to certain situations? Is required','7',
'DAST – Do you try to limit your drug use to certain situations? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','Flashback',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Flashback,'''')='''' ',
'Have you had “blackouts” or “flashbacks” as a result of  drug use? Is required','8',
'DAST – Have you had “blackouts” or “flashbacks” as a result of  drug use? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','DrugAbuse',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DrugAbuse,'''')='''' ',
'Do you ever feel bad about your drug abuse? Is required','9',
'DAST – Do you ever feel bad about your drug abuse? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','InvolvementWithDrug',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(InvolvementWithDrug,'''')='''' ',
'Does your spouse (or parents) ever complain about your involvement with drugs? Is required','10',
'DAST – Does your spouse (or parents) ever complain about your involvement with drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','SuspectDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SuspectDrugs,'''')='''' ',
'Do your friends or relatives know or suspect you abuse drugs? Is required','11',
'DAST – Do your friends or relatives know or suspect you abuse drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','ProblemCreatedSpouse',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProblemCreatedSpouse,'''')='''' ',
'Has drug abuse ever created problems between you and your spouse? Is required? Is required','12',
'DAST – Has drug abuse ever created problems between you and your spouse? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','ShoughtHelp',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ShoughtHelp,'''')='''' ',
'Has any family member ever sought help for problems related to your drug use? is required','13',
'DAST – Has any family member ever sought help for problems related to your drug use? is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','LostFriends',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LostFriends,'''')='''' ',
'Have you ever lost friends because of your use of drugs? Is required','14',
'DAST – Have you ever lost friends because of your use of drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','NeglectedDrug',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NeglectedDrug,'''')='''' ',
'Have you ever neglected your family or missed work because of your use of drugs? Is required','15',
'DAST – Have you ever neglected your family or missed work because of your use of drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','TroubleWork',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleWork,'''')='''' ',
'Have you ever been in trouble at work because of drug abuse? Is required','16',
'DAST – Have you ever been in trouble at work because of drug abuse? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','LostJob',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LostJob,'''')='''' ',
'Have you ever lost a job because of drug abuse? Is required','17',
'DAST – Have you ever lost a job because of drug abuse? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','GottenIntoFights',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GottenIntoFights,'''')='''' ',
'Have you gotten into fights when under the influence of drugs? Is required','18',
'DAST – Have you gotten into fights when under the influence of drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','ArrestedDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ArrestedDrugs,'''')='''' ',
'Have you ever been arrested because of unusual behavior while under the influence of drugs? Is required','19',
'DAST – Have you ever been arrested because of unusual behavior while under the influence of drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','ArrestedDrivingDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ArrestedDrivingDrugs,'''')='''' ',
'Have you ever been arrested for driving while under the influence of drugs? Is required','20',
'DAST – Have you ever been arrested for driving while under the influence of drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','ObtainDrug',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ObtainDrug,'''')='''' ',
'Have you engaged in illegal activities in order to obtain drugs? Is required','21',
'DAST – Have you engaged in illegal activities in order to obtain drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','PossessionIligalDrugs',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PossessionIligalDrugs,'''')='''' ',
'Have you ever been arrested for possession of illegal drugs? Is required','22',
'DAST – Have you ever been arrested for possession of illegal drugs? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','HeavyDrugIntake',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HeavyDrugIntake,'''')='''' ',
'Have you ever experienced withdrawal symptoms as a result of heavy drug intake? Is required','23',
'DAST – Have you ever experienced withdrawal symptoms as a result of heavy drug intake? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','MedicalProblem',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MedicalProblem,'''')='''' ',
'Have you had medical problems as a result of your drug use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)? Is required','24',
'DAST – Have you had medical problems as a result of your drug use (e.g. memory loss, hepatitis, convulsions, bleeding, etc.)? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','GoneAnyoneHelp',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(GoneAnyoneHelp,'''')='''' ',
'Have you ever gone to anyone for help for a drug problem? Is required','25',
'DAST – Have you ever gone to anyone for help for a drug problem? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','HospitalisedDrug',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HospitalisedDrug,'''')='''' ',
'Have you ever been in a hospital for medical problems related to your drug use? Is required','26',
'DAST – Have you ever been in a hospital for medical problems related to your drug use? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','TreatmentProgram',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TreatmentProgram,'''')='''' ',
'Have you ever been involved in a treatment program specifically related to drug use? Is required','27',
'DAST – Have you ever been involved in a treatment program specifically related to drug use? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]
( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],
[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','1651',Null,'DAST','1','DocumentDASTs','TreatedAsOutpatient',
'FROM DocumentDASTs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TreatedAsOutpatient,'''')='''' ',
'Have you been treated as an outpatient for problems related to drug abuse? Is required','28',
'DAST – Have you been treated as an outpatient for problems related to drug abuse? Is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)