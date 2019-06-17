/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* ROIContact */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ROIContact'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ROIContact'
		,'ROIContact'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIContact'
			AND CodeName = 'Organization / Provider'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIContact'
		,'Organization / Provider'
		,'OrganizationProvider'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIContact'
			AND CodeName = 'Personal Contact'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIContact'
		,'Personal Contact'
		,'PersonalContact'
		,'Y'
		,'Y'
		,2
		)
END


/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* ROIPURPOSEOFDISCLOSU */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ROIPURPOSEOFDISCLOSU'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ROIPURPOSEOFDISCLOSU'
		,'ROIPURPOSEOFDISCLOSU'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIPURPOSEOFDISCLOSU'
			AND CodeName = 'Process insurance/third part claims(Substance Abuse Remittance Only)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIPURPOSEOFDISCLOSU'
		,'Process insurance/third part claims(Substance Abuse Remittance Only)'
		,'ProcessInsuranceThirdPartyCalims'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIPURPOSEOFDISCLOSU'
			AND CodeName = 'Care Coordination'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIPURPOSEOFDISCLOSU'
		,'Care Coordination'
		,'CareCoordination'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIPURPOSEOFDISCLOSU'
			AND CodeName = 'HIE(Health Information Exchange)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIPURPOSEOFDISCLOSU'
		,'HIE(Health Information Exchange)'
		,'HIE'
		,'Y'
		,'Y'
		,3
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIPURPOSEOFDISCLOSU'
			AND CodeName = 'Other'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIPURPOSEOFDISCLOSU'
		,'Other'
		,'Other'
		,'Y'
		,'Y'
		,4
		)
END



/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* ROIEXPIRATION */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ROIEXPIRATION'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ROIEXPIRATION'
		,'ROIEXPIRATION'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIEXPIRATION'
			AND CodeName = '1 time disclosure'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIEXPIRATION'
		,'1 time disclosure'
		,'OneTimeDisclosure'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIEXPIRATION'
			AND CodeName = '6 months'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIEXPIRATION'
		,'6 months'
		,'SixMonths'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIEXPIRATION'
			AND CodeName = 'End of Agency Treatment'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIEXPIRATION'
		,'End of Agency Treatment'
		,'EndAgencyTreatment'
		,'Y'
		,'Y'
		,3
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIEXPIRATION'
			AND CodeName = 'Revoke'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIEXPIRATION'
		,'Revoke'
		,'Revoke'
		,'Y'
		,'Y'
		,4
		)
END


/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* ROITYPE */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ROITYPE'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ROITYPE'
		,'ROITYPE'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROITYPE'
			AND CodeName = 'MH'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROITYPE'
		,'MH'
		,'MH'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROITYPE'
			AND CodeName = 'SUD'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROITYPE'
		,'SUD'
		,'SUD'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROITYPE'
			AND CodeName = 'General'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROITYPE'
		,'General'
		,'General'
		,'Y'
		,'Y'
		,3
		)
END




/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* ROIINFORMATIONUSED */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ROIINFORMATIONUSED'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'ROIINFORMATIONUSED'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Acknowledgement of Treatment'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Acknowledgement of Treatment'
		,'AcknowledgementTreatment'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Billing &/OR Insurance Information'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Billing &/OR Insurance Information'
		,'BillingInsuranceInformation'
		,'Y'
		,'Y'
		,2
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Intake/Admission Information'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Intake/Admission Information'
		,'IntakeAdmissionInformation'
		,'Y'
		,'Y'
		,3
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Psychological Evaluation(s) Reports'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Psychological Evaluation(s) Reports'
		,'PsychologicalEvaluationReports'
		,'Y'
		,'Y'
		,4
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Medications Prescribed'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Medications Prescribed'
		,'MedicationsPrescribed'
		,'Y'
		,'Y'
		,5
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Discharge Summary/Plan'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Discharge Summary/Plan'
		,'DischargeSummaryPlan'
		,'Y'
		,'Y'
		,6
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Progress Review/Summary'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Progress Review/Summary'
		,'ProgressReviewSummary'
		,'Y'
		,'Y'
		,7
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Screening Assessment(s)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Screening Assessment(s)'
		,'ScreeningAssessments'
		,'Y'
		,'Y'
		,8
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'KCPC (only with permissions of SUD counselors)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'KCPC (only with permissions of SUD counselors)'
		,'KCPCPermissionOfSUDCounselors'
		,'Y'
		,'Y'
		,9
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'AAPS Eligibility Documents'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'AAPS Eligibility Documents'
		,'AAPSEligibilityDocuments'
		,'Y'
		,'Y'
		,10
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'School Records/Reports/IEPs'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'School Records/Reports/IEPs'
		,'SchoolRecords'
		,'Y'
		,'Y'
		,11
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Medical History, Lab Results, Immunizations Records'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Medical History, Lab Results, Immunizations Records'
		,'MedicalHistoryLab'
		,'Y'
		,'Y'
		,12
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Treatment Plan(s)/Waiver PIC(All documents)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Treatment Plan(s)/Waiver PIC(All documents)'
		,'TreatmentPlanWaiverPIC'
		,'Y'
		,'Y'
		,13
		)
END




IF NOT EXISTS (
	SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Progress Notes'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Progress Notes'
		,'ProgressNotes'
		,'Y'
		,'Y'
		,14
		)
END




IF NOT EXISTS (
	SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'KCPC'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'KCPC'
		,'KCPC'
		,'Y'
		,'Y'
		,15
		)
END



IF NOT EXISTS (
	SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIINFORMATIONUSED'
			AND CodeName = 'Legal Documents(specify)'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIINFORMATIONUSED'
		,'Legal Documents(specify)'
		,'LegalDocuments'
		,'Y'
		,'Y'
		,16
		)
END





/* Category :  */
/*Insert Into GlobalCodes */
/*Insert Into GlobalCodeCategories */
/* ROIIDVerify */

IF NOT EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'ROIIDVerify'
		)
		BEGIN
	INSERT INTO [GlobalCodeCategories] (
		Category
		,CategoryName
		,Active
		,AllowAddDelete
		,AllowCodeNameEdit
		,AllowSortOrderEdit
		,UserDefinedCategory
		,HasSubcodes
		)
	VALUES (
		'ROIIDVerify'
		,'ROIIDVerify'
		,'Y'
		,'N'
		,'N'
		,'N'
		,'N'
		,'N'
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIIDVerify'
			AND CodeName = 'Driver''s License'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIIDVerify'
		,'Driver''s License'
		,'DriverLicense'
		,'Y'
		,'Y'
		,1
		)
END


IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIIDVerify'
			AND CodeName = 'Other Picture ID'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIIDVerify'
		,'Other Picture ID'
		,'OtherPictureID'
		,'Y'
		,'Y'
		,2
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM [GlobalCodes]
		WHERE Category = 'ROIIDVerify'
			AND CodeName = 'Known to Agency'
		)
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Active]
		,[CannotModifyNameOrDelete]
		,[SortOrder]
		)
	VALUES (
		'ROIIDVerify'
		,'Known to Agency'
		,'KnownAgency'
		,'Y'
		,'Y'
		,3
		)
END
