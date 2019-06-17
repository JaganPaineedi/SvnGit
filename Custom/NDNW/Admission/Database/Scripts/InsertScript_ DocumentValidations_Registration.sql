/*
Insert script for Registration - Document - Validation Messgae
Author : Aravind
Created Date : 16/10/2014
Purpose : What/Why : Task #964 - valley Customization

*/
--select * from Programs where 
--set @Program = ProgramName
--print  @Program
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10500
	AND TableName = 'CustomDocumentRegistrations'

DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10500
	AND TableName = 'CustomRegistrationCoveragePlans'

DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10500
	AND TableName = 'CustomRegistrationFormsAndAgreements'

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'FirstName'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FirstName,'''')='''' '
	,'Basic demographics- First Name is required '
	,1
	,'Basic demographics- First Name is required '
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'LastName'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LastName,'''')='''' '
	,'Basic demographics- Last Name is required '
	,2
	,'Basic demographics- Last Name is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'SSN'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SSN,'''')=''_________'' '
	,'Basic demographics- SSN is required '
	,3
	,'Basic demographics- SSN is required '
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'DateOfBirth'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DateOfBirth,'''')='''' '
	,'Basic demographics- DOB is required '
	,4
	,'Basic demographics- DOB is required '
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'Sex'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Sex,'''')='''' '
	,'Basic demographics- Gender is required'
	,5
	,'Basic demographics- Gender is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'MaritalStatus'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MaritalStatus,'''')='''' '
	,'Basic demographics- Marital Status is required '
	,6
	,'Basic demographics- Marital Status is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'PrimaryLanguage'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimaryLanguage,'''')='''' '
	,'Basic demographics- Primary language is required '
	,7
	,'Basic demographics- Primary language is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'SecondaryLanguage'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SecondaryLanguage,'''')='''' '
	,'Basic demographics- Secondary language is required'
	,8
	,'Basic demographics- Secondary language is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'HispanicOrigin'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HispanicOrigin,'''')='''' '
	,'Basic demographics- Ethnicity is required'
	,9
	,'Basic demographics- Ethnicity is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'Race'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Race,'''')='''' '
	,'Basic demographics- Race is required '
	,10
	,'Basic demographics- Race is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'TribalAffiliation'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TribalAffiliation,'''')='''' '
	,'Basic demographics- Tribal Affiliation is required'
	,11
	,'Basic demographics- Tribal Affiliation is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'CurrentlyHomeless'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CurrentlyHomeless,'''')='''' '
	,'Client Information – Client homeless status must be specified.'
	,12
	,'Client Information – Client homeless status must be specified.'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'Address1'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(CurrentlyHomeless,''N'')<>''N'' OR CurrentlyHomeless IS NULL) AND ISNULL(Address1,'''')='''' '
	,'Client Information – Address Line 1 is required'
	,13
	,'Client Information – Address Line 1 is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'City'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(CurrentlyHomeless,''N'')<>''N'' OR CurrentlyHomeless IS NULL) AND ISNULL(City,'''')='''' '
	,'Client Information – City is required'
	,14
	,'Client Information – City is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'State'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(CurrentlyHomeless,''N'')<>''N'' OR CurrentlyHomeless IS NULL) AND ISNULL(State,'''')='''' '
	,'Client Information – State is required'
	,15
	,'Client Information – State is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'ZipCode'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(CurrentlyHomeless,''N'')<>''N'' OR CurrentlyHomeless IS NULL) AND ISNULL(ZipCode,'''')='''' '
	,'Client Information – Zip Code is required'
	,16
	,'Client Information – Zip Code is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'ResidenceCounty'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(CurrentlyHomeless,''N'')<>''N'' OR CurrentlyHomeless IS NULL) AND ISNULL(ResidenceCounty,'''')='''' '
	,'Client Information – County of Residence is required'
	,17
	,'Client Information – County of Residence is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'CountyOfTreatment'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(CurrentlyHomeless,''N'')<>''N'' OR CurrentlyHomeless IS NULL) AND ISNULL(CountyOfTreatment,'''')='''' '
	,'Client Information – County of Financial Responsibility is required'
	,18
	,'Client Information – County of Financial Responsibility is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Demographics'
	,'1'
	,'CustomDocumentRegistrations'
	,'OtherPrimaryLanguage'
	,'FROM CustomDocumentRegistrations CR join GlobalCodes GC on GC.GlobalCodeId=CR.PrimaryLanguage
WHERE CR.DocumentVersionId=@DocumentVersionId AND LOWER(GC.CodeName)=LOWER(''Other'') AND ISNULL(CR.OtherPrimaryLanguage,'''')='''''
	,'Demographics-Basic demographics- Other language is required'
	,19
	,'Demographics-Basic demographics- Other language is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'RegisteredSexOffender'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RegisteredSexOffender,'''')='''' '
	,'Additional Information – Registered Sex Offender is required'
	,20
	,'Additional Information – Registered Sex Offender is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'NumberOfArrestsLast30Days'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfArrestsLast30Days,-1)<0 '
	,'Additional Information – # of Arrests in the last 30 days is required'
	,21
	,'Additional Information – # of Arrests in the last 30 days is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'NumberOfArrestPast12Months'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfArrestPast12Months,-1)<0 '
	,'Additional Information – # of Arrests in the last 12 months is required'
	,22
	,'Additional Information – # of Arrests in the last 12 months is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'SmokingStatus'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SmokingStatus,'''')='''' '
	,'Additional Information – Tobacco Use is required'
	,23
	,'Additional Information – Tobacco Use is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'EmploymentStatus'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EmploymentStatus,'''')='''' '
	,'Additional Information – Employment status is required'
	,24
	,'Additional Information – Employment status is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'ClientType'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ClientType,'''')='''' '
	,'Additional Information – Client Type is required'
	,25
	,'Additional Information – Client Type is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'EducationalLevel'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EducationalLevel,'''')='''' '
	,'Additional Information – Education Completed is required'
	,26
	,'Additional Information – Education Completed is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'AdvanceDirective'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AdvanceDirective,'''')='''' '
	,'Additional information – Mental Health Advance Directive is required'
	,27
	,'Additional information – Mental Health Advance Directive is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'SchoolAttendance'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SchoolAttendance,'''')='''' '
	,'Additional Information – School Attendance is required'
	,28
	,'Additional Information – School Attendance is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'EducationStatus'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(EducationStatus,'''')='''' '
	,'Additional Information – Education status is required'
	,29
	,'Additional Information – Education status is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'LivingArrangments'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(LivingArrangments,'''')='''' '
	,'Additional information – Living Arrangements is required'
	,30
	,'Additional information – Living Arrangements is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'IEP'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(IEP,'''')='''' '
	,'Additional Information – Does Client have IEP is required'
	,31
	,'Additional Information – Does Client have IEP is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'RegisteredVoter'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RegisteredVoter,'''')='''' '
	,'Additional Information – Client is registered voter is required'
	,32
	,'Additional Information – Client is registered voter is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'MilitaryService'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(MilitaryService,'''')='''' '
	,'Additional Information – Have you ever or are you currently serving in the military is required'
	,33
	,'Additional Information – Have you ever or are you currently serving in the military is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'VotingInformation'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RegisteredVoter,'''')=''N'' AND ISNULL(VotingInformation,'''')='''' '
	,'Additional Information – Client has been provided voting information is required'
	,34
	,'Additional Information – Client has been provided voting information is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'VocationalRehab'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(VocationalRehab,'''')='''' '
	,'Additional Information – Enrolled in vocational rehab is required'
	,35
	,'Additional Information – Enrolled in vocational rehab is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'NumberOfEmployersLast12Months'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberOfEmployersLast12Months,-1)<0 '
	,'Additional Information – Number of employers in the last 12months is required'
	,36
	,'Additional Information – Number of employers in the last 12months is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'PrimaryCarePhysician'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimaryCarePhysician,'''')='''' AND ISNULL(ClientWithOutPCP,'''')!=''Y''  '
	,'Current Treatment – Primary Care Physician is required'
	,37
	,'Current Treatment – Primary Care Physician is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'PreviousMentalHealthServices'
	,'FROM CustomDocumentRegistrations  CDR
 WHERE CDR.PrimaryProgramId not in (select IntegerCodeId from Recodes R
inner join RecodeCategories RC on R.RecodeCategoryId = RC.RecodeCategoryId
 where RC.CategoryCode = ''XFLEXCARE'') and  CDR.DocumentVersionId=@DocumentVersionId and ISNULL(CDR.PreviousMentalHealthServices,'''')='''' '
	,'Previous Treatment – Previous Mental Health Service is required'
	,38
	,'Previous Treatment – Previous Mental Health Service is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Additional Information'
	,'2'
	,'CustomDocumentRegistrations'
	,'VBHService'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(VBHService,'''')='''' OR ISNULL(VBHService,'''')=''N'') AND (ISNULL(StateHospitalService,'''')='''' OR ISNULL(StateHospitalService,'''')=''N'') AND  (ISNULL(PsychiatricHospitalService,'''')='''' OR ISNULL(PsychiatricHospitalService,'''')=''N'') AND (ISNULL(GeneralHospitalService,'''')='''' OR ISNULL(GeneralHospitalService,'''')=''N'') AND (ISNULL(OutPatientService,'''')='''' OR ISNULL(OutPatientService,'''')=''N'') AND (ISNULL(ResidentialService,'''')='''' OR ISNULL(ResidentialService,'''')=''N'') AND  (ISNULL(SubAbuseOutPatientService,'''')='''' OR ISNULL(SubAbuseOutPatientService,'''')=''N'') AND  (ISNULL(Civilcommitment,'''')='''' OR ISNULL(Civilcommitment,'''')=''N'') AND (PreviousMentalHealthServices = ''Y'' OR PreviousSubstanceAbuseServices = ''Y'') '
	,'Previous Treatment – Provider types are required'
	,40
	,'Previous Treatment – Provider types are required'
	)


INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'Medicaid'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Medicaid,'''')='''' '
	,'Funding – Coverage Information – Medicaid is required'
	,43
	,'Funding – Coverage Information – Medicaid is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'NumberInHousehold'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NumberInHousehold,'''')='''' '
	,'Funding – Income/Fee General – Number in household is required'
	,44
	,'Funding – Income/Fee General – Number in household is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'DependentsInHousehold'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DependentsInHousehold,'''')='''' '
	,'Funding – Income/Fee General – Number of dependents is required'
	,45
	,'Funding – Income/Fee General – Number of dependents is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'ClientAnnualIncome'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ClientAnnualIncome,'''')='''' '
	,'Funding – Income/Fee General – Client annual income is required'
	,46
	,'Funding – Income/Fee General – Client annual income is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'HouseholdAnnualIncome'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HouseholdAnnualIncome,'''')='''' '
	,'Funding – Income/Fee General – Gross Household Annual Income is required'
	,47
	,'Funding – Income/Fee General – Gross Household Annual Income is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'ClientMonthlyIncome'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ClientMonthlyIncome,'''')='''' '
	,'Funding – Income/Fee General –client monthly income is required'
	,48
	,'Funding – Income/Fee General –client monthly income is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Insurance'
	,'3'
	,'CustomDocumentRegistrations'
	,'PrimarySource'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimarySource,'''')='''' '
	,'Funding – Income/Fee General –Primary source is required'
	,49
	,'Funding – Income/Fee General –Primary source is required'
	)


--INSERT INTO [dbo].[DocumentValidations] (
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
--	'Y'
--	,'10500'
--	,NULL
--	,'Insurance'
--	,'3'
--	,'CustomDocumentRegistrations'
--	,'SpecialFeeBeginDate'
--	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SpecialFeeBeginDate,'''')='''' '
--	,'Funding – Income/Fee  Special Fee– Both charge client and begin date are required'
--	,50
--	,'Funding – Income/Fee  Special Fee– Both charge client and begin date are required'
--	)

--INSERT INTO [dbo].[DocumentValidations] (
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
--	'Y'
--	,'10500'
--	,NULL
--	,'Insurance'
--	,'3'
--	,'CustomDocumentRegistrations'
--	,'SlidingFeeStartDate'
--	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SlidingFeeStartDate,'''')='''' '
--	,'Funding – Income/Fee  Sliding Fee Determination – Start Date and End date are required'
--	,51
--	,'Funding – Income/Fee  Sliding Fee Determination- Start Date and End date are required'
--	)

--INSERT INTO [dbo].[DocumentValidations] (
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
--	'Y'
--	,'10500'
--	,NULL
--	,'Insurance'
--	,'3'
--	,'CustomDocumentRegistrations'
--	,'SlidingFeeEndDate'
--	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SlidingFeeEndDate,'''')='''' AND ISNULL(SlidingFeeStartDate,'''')!='''' '
--	,'Funding – Income/Fee - Sliding Fee Determination– Start Date and End date are required'
--	,52
--	,'Funding – Income/Fee - Sliding Fee Determination – Start Date and End date are required'
--	)

--INSERT INTO [dbo].[DocumentValidations] (
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
--	'Y'
--	,'10500'
--	,NULL
--	,'Insurance'
--	,'3'
--	,'CustomDocumentRegistrations'
--	,'IncomeVerified'
--	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(IncomeVerified,'''')='''' '
--	,'Funding – Income/Fee - Sliding Fee Determination- Income verified is required'
--	,53
--	,'Funding – Income/Fee - Sliding Fee Determination - Income verified is required'
--	)

--INSERT INTO [dbo].[DocumentValidations] (
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
--	'Y'
--	,'10500'
--	,NULL
--	,'Insurance'
--	,'3'
--	,'CustomDocumentRegistrations'
--	,'PerSessionFee'
--	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PerSessionFee,'''')='''' '
--	,'Funding – Income/Fee -  Sliding Fee Determination– Per session fee is required'
--	,54
--	,'Funding – Income/Fee - Sliding Fee Determination – Per session fee is required'
--	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Episode'
	,'4'
	,'CustomDocumentRegistrations'
	,'RegistrationDate'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RegistrationDate,'''')='''' '
	,'Case information – Admit Date is required'
	,55
	,'Case information – Admit Date is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Episode'
	,'4'
	,'CustomDocumentRegistrations'
	,'ReferralDate'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReferralDate,'''')='''' '
	,'Referral Resource – Referral Date is required'
	,56
	,'Referral Resource – Referral Date is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Episode'
	,'4'
	,'CustomDocumentRegistrations'
	,'ReferralType'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReferralType,'''')='''' '
	,'Referral Resource – Source of Referral is required'
	,57
	,'Referral Resource – Source of Referral is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Episode'
	,'4'
	,'CustomDocumentRegistrations'
	,'ReferralOrganization'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ReferralOrganization,'''')='''' AND (ISNULL(ReferrralFirstName,'''')='''' OR ISNULL(ReferrralLastName,'''')='''') AND (dbo.GetGlobalCodeName(ReferralType))!=''Family/Friend'' AND (dbo.GetGlobalCodeName(ReferralType))!=''Self''  '
	,'Referral Resource – Organization name  or first/last name  is required'
	,58
	,'Referral Resource – Organization name  or first/last name  is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Program Enrollment'
	,'5'
	,'CustomDocumentRegistrations'
	,'PrimaryProgramId'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PrimaryProgramId,'''')='''' '
	,'Primary program is required'
	,59
	,'Primary program is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Program Enrollment'
	,'5'
	,'CustomDocumentRegistrations'
	,'Facility'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Facility,'''')='''' '
	,'Facility is required'
	,60
	,'Facility is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Program Enrollment'
	,'5'
	,'CustomDocumentRegistrations'
	,'ProgramStatus'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProgramStatus,'''')='''''
	,'Status is required'
	,61
	,'Status is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Program Enrollment'
	,'5'
	,'CustomDocumentRegistrations'
	,'ProgramRequestedDate'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProgramRequestedDate,'''')='''' AND (dbo.GetGlobalCodeName(ProgramStatus))=''Requested'' '
	,'Requested date is required'
	,62
	,'Requested date is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Program Enrollment'
	,'5'
	,'CustomDocumentRegistrations'
	,'ProgramEnrolledDate'
	,'FROM CustomDocumentRegistrations WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProgramEnrolledDate,'''')=''''  AND (dbo.GetGlobalCodeName(ProgramStatus))=''Enrolled'' '
	,'Enrolled date is required'
	,63
	,'Enrolled date is required'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''AHDB'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please specify Individual Rights'
	,64
	,'please specify Individual Rights'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''CFA'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please Complaint and Grievance Process'
	,65
	,'please Complaint and Grievance Process'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''CT'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please specify Notice of Privacy Practices'
	,66
	,'please specify Notice of Privacy Practices'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''CRR'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please specify Mental Health Advance Directive Information'
	,67
	,'please specify Mental Health Advance Directive Information'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''MH'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please specify Rules associated with Substance Abuse/Gambling Treatment Enrollment'
	,68
	,'please specify Rules associated with Substance Abuse/Gambling Treatment Enrollment'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''PN'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please specify HIPAA'
	,69
	,'please specify HIPAA'
	)

INSERT INTO [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	'Y'
	,'10500'
	,NULL
	,'Forms and Agreements'
	,'6'
	,'CustomRegistrationFormsAndAgreements'
	,'Form'
	,'FROM GlobalCodes GC 
left outer join CustomRegistrationFormsAndAgreements CRFA on GC.GlobalCodeId = CRFA.form and ISNULL(CRFA.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId 
WHERE GC.Category =''XREGISTRATIONFORM'' AND GC.Code = ''CTT'' and CRFA.CustomRegistrationFormAndAgreementId is null'
	,'please specify Consent to Treatment'
	,70
	,'please specify Consent to Treatment'
	)
	--select * from DocumentValidations