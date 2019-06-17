DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10018 and TableName = 'CustomHRMAssessments'

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Referral Source is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'ReferralType'
		,'From #CustomHRMAssessments where isnull(ReferralType,'''')='''''
		,''
		,1
		,'General section- Referral Source is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Presenting Problem is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'PresentingProblem'
		,'From #CustomHRMAssessments where isnull(PresentingProblem,'''')='''''
		,''
		,2
		,'General section- Presenting Problem is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Presence or absence of relevant legal issues of the client and/or family is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'LegalIssues'
		,'From #CustomHRMAssessments where isnull(LegalIssues,'''')='''''
		,''
		,2
		,'General section- Presence or absence of relevant legal issues of the client and/or family is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Current Primary Care Physician is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'CurrentPrimaryCarePhysician'
		,'From #CustomHRMAssessments where isnull(CurrentPrimaryCarePhysician,'''')='''''
		,''
		,3
		,'General section- Current Primary Care Physician is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Desired Outcomes is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'DesiredOutcomes'
		,'From #CustomHRMAssessments where isnull(DesiredOutcomes,'''')='''''
		,''
		,4
		,'General section- Desired Outcomes is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Reason for Update textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'ReasonForUpdate'
		,'From #CustomHRMAssessments  where isnull(AssessmentType,''X'')=''U''  and isnull(convert(varchar(8000), ReasonForUpdate),'''')='''''
		,''
		,5
		,'General section- Reason for Update textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Summary of Progress textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'ReasonForUpdate'
		,'From #CustomHRMAssessments  where isnull(AssessmentType,''X'')=''A''  and isnull(convert(varchar(8000), ReasonForUpdate),'''')='''''
		,''
		,6
		,'General section- Summary of Progress textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Current Living Arrangement is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'CurrentLivingArrangement'
		,'From #CustomHRMAssessments where isnull(CurrentLivingArrangement,0)=0'
		,''
		,2
		,'General section- Current Living Arrangement is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Current Employment status is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'EmploymentStatus'
		,'From #CustomHRMAssessments where isnull(EmploymentStatus,0)=0'
		,''
		,2
		,'General section- Current Employment status is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Assessment date must is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,1
		,'CustomHRMAssessments'
		,'CurrentAssessmentDate'
		,'From #CustomHRMAssessments a   where isnull(a.CurrentAssessmentDate, ''1/1/1900'') = ''1/1/1900''     and Isnull(AssessmentType,''I'') != ''S'''
		,NULL
		,0
		,'General section- Assessment date must is required'
		,NULL
		)
END

--UNCOPE
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10018
	AND TabName = 3
	AND TableName = 'CustomDocumentAssessmentSubstanceUses'

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Alcohol is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfAlcohol'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where ISNULL(UseOfAlcohol,'''')='''' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId and ISNULL(CDA.RecordDeleted,''N'') = ''N'' '
		,N'Uncope - Substance Use – Use of Alcohol is required'
		,1
		,N'Uncope - Substance Use – Use of Alcohol is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Tobacco/Nicotine is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotine'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where ISNULL(UseOfTobaccoNicotine,'''')='''' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'' '
		,N'Uncope - Substance Use – Use of Tobacco/Nicotine is required'
		,2
		,N'Uncope - Substance Use – Use of Tobacco/Nicotine is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Illicit Drugs is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfIllicitDrugs'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId  where isnull(UseOfIllicitDrugs,'''')='''' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'' '
		,N'Uncope - Substance Use – Use of Illicit Drugs is required'
		,3
		,N'Uncope - Substance Use – Use of Illicit Drugs is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Prescription/OTC Drugs is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'PrescriptionOTCDrugs'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(PrescriptionOTCDrugs,'''')='''' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId and ISNULL(CDA.RecordDeleted,''N'') = ''N'' '
		,N'Uncope - Substance Use – Use of Prescription/OTC Drugs is required'
		,4
		,N'Uncope - Substance Use – Use of Prescription/OTC Drugs is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Tobacco/Nicotine Date is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotineQuit'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfTobaccoNicotineQuit,'''')='''' and isnull(UseOfTobaccoNicotine,''N'')=''P'' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId and ISNULL(CDA.RecordDeleted,''N'') = ''N'' '
		,N'Uncope - Substance Use – Use of Tobacco/Nicotine Date is required.'
		,5
		,N'Uncope - Substance Use – Use of Tobacco/Nicotine Date is required.'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Tobacco/Nicotine Type/Frequency is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotineTypeOfFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId  where isnull(UseOfTobaccoNicotineTypeOfFrequency,'''')='''' and isnull(UseOfTobaccoNicotine,''N'')=''T'' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Uncope - Substance Use – Use of Tobacco/Nicotine Type/Frequency is required'
		,6
		,N'Uncope - Substance Use – Use of Tobacco/Nicotine Type/Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Illicit Drugs Type/Frequency is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfIllicitDrugsTypeFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfIllicitDrugsTypeFrequency,'''')='''' and isnull(UseOfIllicitDrugs,''N'')=''Y'' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Uncope - Substance Use – Use of Illicit Drugs Textbox is required'
		,7
		,N'Uncope - Substance Use – Use of Illicit Drugs Type/Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Substance Use – Use of Prescription/OTC Drugs Type/Frequency is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'PrescriptionOTCDrugsTypeFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId  where isnull(PrescriptionOTCDrugsTypeFrequency,'''')='''' and isnull(PrescriptionOTCDrugs,''N'')=''Y'' and AdultOrChild = ''A'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Uncope - Substance Use – Use of Prescription/OTC Drugs Textbox is required'
		,8
		,N'Uncope - Substance Use – Use of Prescription/OTC Drugs Type/Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Is UNCOPE applicable is required'
			AND TableName = '#CustomHRMAssessments'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'CustomHRMAssessments'
		,N'UncopeApplicable'
		,N'From #CustomHRMAssessments  where @Age >= 12 and isnull(UncopeApplicable,'''')='''' and AdultOrChild = ''A'' and ISNULL(RecordDeleted,''N'') = ''N'' '
		,N''
		,9
		,N'Uncope - Is UNCOPE applicable is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - UNCOPE applicable reason is required'
			AND TableName = '#CustomHRMAssessments'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'CustomHRMAssessments'
		,N'UncopeApplicableReason'
		,N'From #CustomHRMAssessments a  where UncopeApplicable = ''N'' and isnull(UncopeApplicableReason,'''')='''' and AdultOrChild = ''A'' and ISNULL(RecordDeleted,''N'') = ''N'' '
		,N''
		,10
		,N'Uncope - UNCOPE applicable reason is required'
		)
END

---Uncope Type/Frequency---
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'A diagnosis is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotineTypeOfFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId join DocumentDiagnosisCodes DDC on DDC.DocumentVersionId = CDA.DocumentVersionId join Recodes R on R.CodeName = DDC.ICD10Code where ISNULL(CDA.UseOfTobaccoNicotineTypeOfFrequency,'''')='''' and AdultOrChild = ''A'' and CDA.DocumentVersionId = @DocumentVersionId and ISNULL(CDA.RecordDeleted,''N'') = ''N'' '
		,N'A diagnosis is required'
		,11
		,N'A diagnosis is required'
		)
END

----Crafft------
IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Alcohol is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfAlcohol'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfAlcohol,'''')='''' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Alcohol is required'
		,1
		,N'Crafft - Substance Use – Use of Alcohol is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Tobacco/Nicotine is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotine'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfTobaccoNicotine,'''')='''' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Tobacco/Nicotine is required'
		,2
		,N'Crafft - Substance Use – Use of Tobacco/Nicotine is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Illicit Drugs is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfIllicitDrugs'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfIllicitDrugs,'''')='''' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Illicit Drugs is required'
		,3
		,N'Crafft - Substance Use – Use of Illicit Drugs is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Prescription/OTC Drugs is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'PrescriptionOTCDrugs'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(PrescriptionOTCDrugs,'''')='''' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Prescription/OTC Drugs is required'
		,4
		,N'Crafft - Substance Use – Use of Prescription/OTC Drugs is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Tobacco/Nicotine Date is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotineQuit'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfTobaccoNicotineQuit,'''')='''' and isnull(UseOfTobaccoNicotine,''N'')=''P'' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Tobacco/Nicotine Date is required'
		,5
		,N'Crafft - Substance Use – Use of Tobacco/Nicotine Date is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Tobacco/Nicotine Type/Frequency is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfTobaccoNicotineTypeOfFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(UseOfTobaccoNicotineTypeOfFrequency,'''')='''' and isnull(UseOfTobaccoNicotine,''N'')=''T'' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Tobacco/Nicotine Type/Frequency is required'
		,6
		,N'Crafft - Substance Use – Use of Tobacco/Nicotine Type/Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Illicit Drugs Type/Frequency is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'UseOfIllicitDrugsTypeFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId  where isnull(UseOfIllicitDrugsTypeFrequency,'''')='''' and isnull(UseOfIllicitDrugs,''N'')=''Y'' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Illicit Drugs Textbox is required'
		,7
		,N'Crafft - Substance Use – Use of Illicit Drugs Type/Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Substance Use – Use of Prescription/OTC Drugs Type/Frequency is required'
			AND TableName = '#CustomDocumentAssessmentSubstanceUses'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'#CustomDocumentAssessmentSubstanceUses'
		,N'PrescriptionOTCDrugsTypeFrequency'
		,N'from #CustomDocumentAssessmentSubstanceUses CDA join CustomHRMAssessments CHRM on CDA.DocumentVersionId = CHRM.DocumentVersionId where isnull(PrescriptionOTCDrugsTypeFrequency,'''')='''' and isnull(PrescriptionOTCDrugs,''N'')=''Y'' and AdultOrChild = ''C'' and CDA.DocumentVersionId=@DocumentVersionId AND ISNULL(CDA.RecordDeleted,''N'') = ''N'''
		,N'Crafft - Substance Use – Use of Prescription/OTC Drugs Textbox is required'
		,8
		,N'Crafft - Substance Use – Use of Prescription/OTC Drugs Type/Frequency is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Crafft - Is CRAFFT Applicable selection required'
			AND TableName = '#CustomDocumentCRAFFTs'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'CustomDocumentCRAFFTs'
		,N'CrafftApplicable'
		,N'From CustomHRMAssessments a join CustomDocumentCRAFFTs b on a.DocumentVersionId = b.DocumentVersionId WHERE ISNULL(b.CrafftApplicable,'''') = '''' AND ISNULL(a.AdultOrChild,'''') = ''C'' AND ISNULL(b.RecordDeleted,''N'') = ''N'' and a.DocumentVersionId=@DocumentVersionId'
		,N'Crafft - Is CRAFFT Applicable is required'
		,9
		,N'Crafft - Is CRAFFT Applicable is required'
		)
END

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Uncope - Is Crafft applicable Reason required'
			AND TableName = '#CustomDocumentCRAFFTs'
		)
BEGIN
	INSERT [dbo].[DocumentValidations] (
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
		N'Y'
		,10018
		,NULL
		,NULL
		,3
		,N'CustomDocumentCRAFFTs'
		,N'CrafftApplicableReason'
		,N'From CustomHRMAssessments a join CustomDocumentCRAFFTs b on a.DocumentVersionId = b.DocumentVersionId   where  CrafftApplicable=''N'' and isnull(b.CrafftApplicableReason,'''')='''' and ISNULL(a.AdultOrChild,'''') = ''C'' and ISNULL(b.RecordDeleted,''N'') = ''N'' and a.DocumentVersionId = @DocumentVersionId'
		,N'Crafft - Crafft Applicable Reason is required'
		,10
		,N'Crafft - Crafft Applicable Reason is required'
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Referral Source is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'ReferralType'
		,'From #CustomHRMAssessments where isnull(ReferralType,'''')='''''
		,''
		,1
		,'General section- Referral Source is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Presenting Problem is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'PresentingProblem'
		,'From #CustomHRMAssessments where isnull(PresentingProblem,'''')='''''
		,''
		,2
		,'General section- Presenting Problem is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Presence or absence of relevant legal issues of the client and/or family is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'LegalIssues'
		,'From #CustomHRMAssessments where isnull(LegalIssues,'''')='''''
		,''
		,2
		,'General section- Presence or absence of relevant legal issues of the client and/or family is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Current Primary Care Physician is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'CurrentPrimaryCarePhysician'
		,'From #CustomHRMAssessments where isnull(CurrentPrimaryCarePhysician,'''')='''''
		,''
		,3
		,'General section- Current Primary Care Physician is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Desired Outcomes is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'DesiredOutcomes'
		,'From #CustomHRMAssessments where isnull(DesiredOutcomes,'''')='''''
		,''
		,4
		,'General section- Desired Outcomes is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Reason for Update textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'ReasonForUpdate'
		,'From #CustomHRMAssessments  where isnull(AssessmentType,''X'')=''U''  and isnull(convert(varchar(8000), ReasonForUpdate),'''')='''''
		,''
		,5
		,'General section- Reason for Update textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Summary of Progress textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'ReasonForUpdate'
		,'From #CustomHRMAssessments  where isnull(AssessmentType,''X'')=''A''  and isnull(convert(varchar(8000), ReasonForUpdate),'''')='''''
		,''
		,6
		,'General section- Summary of Progress textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Current Living Arrangement is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'CurrentLivingArrangement'
		,'From #CustomHRMAssessments where isnull(CurrentLivingArrangement,0)=0'
		,''
		,2
		,'General section- Current Living Arrangement is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Current Employment status is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'EmploymentStatus'
		,'From #CustomHRMAssessments where isnull(EmploymentStatus,0)=0'
		,''
		,2
		,'General section- Current Employment status is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General section- Assessment date must is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Initial'
		,0
		,'CustomHRMAssessments'
		,'CurrentAssessmentDate'
		,'From #CustomHRMAssessments a   where isnull(a.CurrentAssessmentDate, ''1/1/1900'') = ''1/1/1900''     and Isnull(AssessmentType,''I'') != ''S'''
		,NULL
		,0
		,'General section- Assessment date must is required'
		,NULL
		)
END

--CustomSubstanceUseAssessments
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,104
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,105
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,106
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,107
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 1     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,109
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Alcohol: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,114
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,115
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,116
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,117
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 2     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,119
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Heroin: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,124
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,125
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,126
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,127
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 3     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,129
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methadone (illicit): Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,134
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,135
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,136
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,137
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 4     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,139
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Opiates or synthetics: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,164
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,165
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,166
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,167
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 7     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,169
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other tranquilizers: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,174
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,175
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,176
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,177
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 8     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,179
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Benzodiazepines: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,184
		,'SU Assessment-Hx and Current Use of Substances –  GHB,GBL: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,185
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,186
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,187
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 9     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,189
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  GHB,GBL: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,194
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,195
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,196
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,197
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 10     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,199
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Cocaine: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,204
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,205
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,206
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,207
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 11     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,209
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Crack Cocaine: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,214
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,215
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,216
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,217
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 12     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,219
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methamphetamines: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,224
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,225
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,226
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,227
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 13     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,229
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other Amphetamines: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,234
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,235
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,236
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,237
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 14     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,239
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Methcathinone: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,244
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,245
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,246
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,247
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 15     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,249
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Hallucinogens: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,254
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,255
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,256
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,257
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 16     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,259
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  PCP: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,264
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,265
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,266
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,267
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 17     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,269
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Marijuana/hashish: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,274
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,275
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,276
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,277
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 18     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,279
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ecstasy (MDMA,MDA): Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,284
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,285
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,286
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,287
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 19     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,289
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Ketamine: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,294
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,295
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,296
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,297
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 20     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,299
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Inhalants: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,304
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,305
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,306
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,307
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 21     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,309
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Antidepressants: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,314
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,315
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,316
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,317
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 22     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,319
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Over-the-counter: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,324
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,325
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,326
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,327
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 23     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,329
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Steroids: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,334
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,335
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,336
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,337
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 24     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,339
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Talwin and PBZ: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,344
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,345
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,346
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,347
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 25     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,349
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Bath Salts: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,344
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,345
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,346
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,347
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 26     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,349
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Spice: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Age Of First Use is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.AgeOfFirstUse,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,344
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Age Of First Use is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Frequency is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.Frequency,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,345
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Frequency is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Route is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.Route,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,346
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Route is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Last Used is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.LastUsed,'''')=''''     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,347
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Last Used is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Preference is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments ca    where (isnull(ClientSAHistory,''N'')=''Y''    OR isnull(CurrentSubstanceAbuse,''N'')=''Y'')    and exists (Select 1 From CustomSubstanceUseHistory2 suh     Where suh.DocumentVersionId = ca.DocumentVersionId     and suh.SUDrugId = 27     and isnull(suh.Preference,0)=0     and isnull(suh.recorddeleted, ''N'')=''N'' ) '
		,''
		,349
		,'Substance Abuse Assessment-Hx and Current Use of Substances –  Other: Preference is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- Previous substance use treatment is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments   where isnull(PreviousTreatment,'''')='''' and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,404
		,'Substance Abuse Assessment- Previous/Current Treatment- Previous substance use treatment is required.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- Current substance use treatment is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments   where isnull(CurrentSubstanceAbuseTreatment,'''') ='''' and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,405
		,'Substance Abuse Assessment- Previous/Current Treatment- Current substance use treatment is required.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- Previous medication assisted treatment is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments   where isnull(PreviousMedication,'''') not in (''N'',''Y'')  and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,406
		,'Substance Abuse Assessment- Previous/Current Treatment- Previous medication assisted treatment is required.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- Current medication assisted treatment is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments   where isnull(CurrentSubstanceAbuseMedication,'''') not in (''N'',''Y'') and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,407
		,'Substance Abuse Assessment- Previous/Current Treatment- Current medication assisted treatment is required.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- If current substance use symptoms, referral to SU or co-occurring Tx is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments   where isnull(CurrentSubstanceAbuseReferralToSAorTX,'''') not in (''N'',''Y'') and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,408
		,'Substance Abuse Assessment- Previous/Current Treatment- If current substance use symptoms, referral to SU or co-occurring Tx is required.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- If yes, where referred. If no, provide reasons.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments    where isnull(Convert(varchar(max), CurrentSubstanceAbuseRefferedReason),'''')='''' and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,409
		,'Substance Abuse Assessment- Previous/Current Treatment- If yes, where referred. If no, provide reasons.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- Is the client interested in medication assisted treatment? Is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'DeletedBy'
		,'from #CustomSUAssessments where isnull(MedicationAssistedTreatment,'''')=''''  and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,410
		,'Substance Abuse Assessment- Previous/Current Treatment- Is the client interested in medication assisted treatment? Is required.'
		,NULL
		)
END

--IF NOT EXISTS (
		--SELECT *
		--FROM DocumentValidations
		--WHERE DocumentCodeId = 10018
		--	AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- If yes, where referred. If no, provide reasons.'
		--	AND ColumnName = 'MedicationAssistedTreatmentRefferedReason'
--		)
DELETE FROM  DocumentValidations WHERE DocumentCodeId = 10018 AND ErrorMessage = 'Substance Abuse Assessment- Previous/Current Treatment- If yes, where referred. If no, provide reasons.' AND ColumnName = 'MedicationAssistedTreatmentRefferedReason'
		
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,4
		,'CustomSubstanceUseAssessments'
		,'MedicationAssistedTreatmentRefferedReason'
		,'from #CustomSUAssessments where isnull(MedicationAssistedTreatmentRefferedReason,'''') = '''' and MedicationAssistedTreatment <> ''A'' and isnull(@RunSUAssessmentValidations,''N'')=''Y'''
		,''
		,412
		,'Substance Abuse Assessment- Previous/Current Treatment- If yes, where referred. If no, provide reasons.'
		,NULL
		)
END

--support
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Support- At least one current support is required.'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Support'
		,7
		,'CustomHRMAssessmentSupports2'
		,'DeletedBy'
		,'From #CustomHRMAssessmentSupports2  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull([Current],'''')=''''    and @AssessmentType <> ''S'''
		,''
		,1
		,'Support- At least one current support is required.'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Support- Support Description narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Support'
		,7
		,'CustomHRMAssessmentSupports2'
		,'SupportDescription'
		,'From #CustomHRMAssessmentSupports2  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')=''''    and @AssessmentType <> ''S'''
		,''
		,1
		,'Support- Support Description narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Support- Current/Not Current selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Support'
		,7
		,'CustomHRMAssessmentSupports2'
		,'Current'
		,'From #CustomHRMAssessmentSupports2  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull([Current],'''')='''''
		,''
		,2
		,'Support- Current/Not Current selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Support- Paid/Unpaid selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Support'
		,7
		,'CustomHRMAssessmentSupports2'
		,'DeletedBy'
		,'From #CustomHRMAssessmentSupports2  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull(PaidSupport,'''')=''''  and isnull(UnpaidSupport,'''')=''''  and isnull([Current],'''')=''Y'''
		,''
		,3
		,'Support- Paid/Unpaid selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Support- Clinically Recommended/Customer Desired selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'Support'
		,7
		,'CustomHRMAssessmentSupports2'
		,'DeletedBy'
		,'From #CustomHRMAssessmentSupports2  Where DocumentVersionId = @DocumentVersionId  and isnull(SupportDescription,'''')<>''''  and isnull(ClinicallyRecommended,'''')=''''  and isnull(CustomerDesired,'''')=''''  and isnull([Current],'''')=''N'''
		,''
		,4
		,'Support- Clinically Recommended/Customer Desired selection is required'
		,NULL
		)
END

--MentalStatus
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Severe/Profound Disability narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomHRMAssessments'
		,'SevereProfoundDisabilityComment'
		,'From #CustomHRMAssessments  Where DocumentVersionId = @DocumentVersionId  and isnull(@SevereProfoundDisability,''N'')=''Y''  and isnull(SevereProfoundDisabilityComment,'''')='''''
		,''
		,1
		,'Severe/Profound Disability narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General Appearance selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Appearance'
		,'From #CustomMentalStatuses2  Where isnull(AppearanceAppropriatelyDressed,''N'')=''N''   and isnull(AppearanceEccentric,''N'')=''N''   and isnull(AppearanceNeatClean,''N'')=''N''   and isnull(AppearanceOlderThanStatedAge,''N'')=''N''   and isnull(AppearanceOther,''N'')=''N''   and isnull(AppearanceOverweight,''N'')=''N''   and isnull(AppearancePoorHygiene,''N'')=''N''   and isnull(AppearanceSeductive,''N'')=''N''   and isnull(AppearanceUnderweight,''N'')=''N''   and isnull(AppearanceUnkemptDisheveled,''N'')=''N''   and isnull(AppearanceWellGroomed,''N'')=''N''   and isnull(AppearanceYoungerThanStatedAge,''N'')=''N''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,2
		,'General Appearance selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'General Appearance narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Appearance Comment'
		,'From #CustomMentalStatuses2  Where isnull(AppearanceOther,''N'')=''Y''   and isnull(AppearanceComment,'''')=''''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,3
		,'General Appearance narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Intellectual Assessment selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Intellectual'
		,'From #CustomMentalStatuses2  Where isnull(IntellectualAboveAverage,''N'')=''N''   and isnull(IntellectualAverage,''N'')=''N''   and isnull(IntellectualBelowAverage,''N'')=''N''   and isnull(IntellectualPossibleMR,''N'')=''N''   and isnull(IntellectualDocumentedMR,''N'')=''N''   and isnull(IntellectualOther,''N'')=''N''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,4
		,'Intellectual Assessment selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Intellectual Assessment narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Intellectual'
		,'From #CustomMentalStatuses2  Where isnull(IntellectualOther,''N'')=''Y''   and isnull(IntellectualComment,'''')=''''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,5
		,'Intellectual Assessment narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Communication selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Communication'
		,'From #CustomMentalStatuses2  Where isnull(CommunicationNormal,''N'')=''N''   and isnull(CommunicationUsesSignLanguage,''N'')=''N''   and isnull(CommunicationUnableToRead,''N'')=''N''   and isnull(CommunicationNeedForBraille,''N'')=''N''   and isnull(CommunicationHearingImpaired,''N'')=''N''   and isnull(CommunicationDoesLipReading,''N'')=''N''   and isnull(CommunicationEnglishIsSecondLanguage,''N'')=''N''   and isnull(CommunicationTranslatorNeeded,''N'')=''N''   and isnull(CommunicationOther,''N'')=''N''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,6
		,'Communication selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Communication narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Communication'
		,'From #CustomMentalStatuses2  Where isnull(CommunicationOther,''N'')=''Y''   and isnull(CommunicationComment,'''')=''''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,7
		,'Communication narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Affect selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Affect'
		,'From #CustomMentalStatuses2  Where isnull(AffectPrimarilyAppropriate,''N'')=''N''   and isnull(AffectRestricted,''N'')=''N''   and isnull(AffectBlunted,''N'')=''N''   and isnull(AffectFlattened,''N'')=''N''   and isnull(AffectDetached,''N'')=''N''   and isnull(AffectPrimarilyInappropriate,''N'')=''N''   and isnull(AffectOther,''N'')=''N''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,8
		,'Affect selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Mood selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Mood'
		,'From #CustomMentalStatuses2  Where isnull(MoodUnremarkable,''N'')=''N''   and isnull(MoodCooperative,''N'')=''N''   and isnull(MoodAnxious,''N'')=''N''   and isnull(MoodTearful,''N'')=''N''   and isnull(MoodCalm,''N'')=''N''   and isnull(MoodLabile,''N'')=''N''   and isnull(MoodPessimistic,''N'')=''N''   and isnull(MoodCheerful,''N'')=''N''   and isnull(MoodGuilty,''N'')=''N''   and isnull(MoodEuphoric,''N'')=''N''   and isnull(MoodDepressed,''N'')=''N''   and isnull(MoodHostile,''N'')=''N''   and isnull(MoodIrritable,''N'')=''N''   and isnull(MoodDramatized,''N'')=''N''   and isnull(MoodFearful,''N'')=''N''   and isnull(MoodSupicious,''N'')=''N''   and isnull(MoodOther,''N'')=''N''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,8
		,'Mood selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Affect narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Affect'
		,'From #CustomMentalStatuses2  Where isnull(AffectOther,''N'')=''Y''   and isnull(AffectComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,9
		,'Affect narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Mood narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Mood'
		,'From #CustomMentalStatuses2  Where isnull(MoodOther,''N'')=''Y''   and isnull(MoodComment,'''')=''''   and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,9
		,'Mood narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Speech selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Speech'
		,'From #CustomMentalStatuses2  Where isnull(SpeechNormal,''N'')=''N''   and isnull(SpeechLogicalCoherent,''N'')=''N''   and isnull(SpeechTangential,''N'')=''N''   and isnull(SpeechSparseSlow,''N'')=''N''   and isnull(SpeechRapidPressured,''N'')=''N''   and isnull(SpeechSoft,''N'')=''N''   and isnull(SpeechCircumstantial,''N'')=''N''   and isnull(SpeechLoud,''N'')=''N''   and isnull(SpeechRambling,''N'')=''N''   and isnull(SpeechOther,''N'')=''N''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,10
		,'Speech selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Speech narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Speech'
		,'From #CustomMentalStatuses2  Where isnull(SpeechOther,''N'')=''Y''   and isnull(SpeechComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,11
		,'Speech narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Thought/Content/Perceptions selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Thought'
		,'From #CustomMentalStatuses2  Where isnull(ThoughtUnremarkable,''N'')=''N''   and isnull(ThoughtParanoid,''N'')=''N''   and isnull(ThoughtGrandiose,''N'')=''N''   and isnull(ThoughtObsessive,''N'')=''N''   and isnull(ThoughtBizarre,''N'')=''N''   and isnull(ThoughtFlightOfIdeas,''N'')=''N''   and isnull(ThoughtDisorganized,''N'')=''N''   and isnull(ThoughtAuditoryHallucinations,''N'')=''N''   and isnull(ThoughtVisualHallucinations,''N'')=''N''   and isnull(ThoughtTactileHallucinations,''N'')=''N''   and isnull(ThoughtOther,''N'')=''N''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,12
		,'Thought/Content/Perceptions selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Thought/Content/Perceptions narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Thought'
		,'From #CustomMentalStatuses2  Where isnull(ThoughtOther,''N'')=''Y''   and isnull(ThoughtComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,13
		,'Thought/Content/Perceptions narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Behavior/Motor Activity selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Behavior'
		,'From #CustomMentalStatuses2  Where isnull(BehaviorNormal,''N'')=''N''   and isnull(BehaviorRestless,''N'')=''N''   and isnull(BehaviorTremors,''N'')=''N''   and isnull(BehaviorPoorEyeContact,''N'')=''N''   and isnull(BehaviorAgitated,''N'')=''N''   and isnull(BehaviorPeculiar,''N'')=''N''   and isnull(BehaviorSelfDestructive,''N'')=''N''   and isnull(BehaviorSlowed,''N'')=''N''   and isnull(BehaviorDestructiveToOthers,''N'')=''N''   and isnull(BehaviorCompulsive,''N'')=''N''   and isnull(BehaviorOther,''N'')=''N''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,14
		,'Behavior/Motor Activity selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Behavior/Motor Activity narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Behavior'
		,'From #CustomMentalStatuses2  Where isnull(BehaviorOther,''N'')=''Y''   and isnull(BehaviorComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,15
		,'Behavior/Motor Activity narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Orientation selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Orientation'
		,'From #CustomMentalStatuses2  Where isnull(OrientationToPersonPlaceTime,''N'')=''N''   and isnull(OrientationNotToPerson,''N'')=''N''   and isnull(OrientationNotToPlace,''N'')=''N''   and isnull(OrientationNotToTime,''N'')=''N''   and isnull(OrientationOther,''N'')=''N''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,16
		,'Orientation selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Orientation narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Orientation'
		,'From #CustomMentalStatuses2  Where isnull(OrientationOther,''N'')=''Y''   and isnull(OrientationComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,17
		,'Orientation narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Insight selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Insight'
		,'From #CustomMentalStatuses2  Where isnull(InsightGood,''N'')=''N''   and isnull(InsightFair,''N'')=''N''   and isnull(InsightPoor,''N'')=''N''   and isnull(InsightLacking,''N'')=''N''   and isnull(InsightOther,''N'')=''N''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,18
		,'Insight selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Memory selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Memory'
		,'From #CustomMentalStatuses2  Where isnull(MemoryGoodNormal,''N'')=''N''   and isnull(MemoryImpairedShortTerm,''N'')=''N''   and isnull(MemoryImpairedLongTerm,''N'')=''N''   and isnull(MemoryOther,''N'')=''N''     and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,18
		,'Memory selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Insight narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Insight'
		,'From #CustomMentalStatuses2  Where isnull(InsightOther,''N'')=''Y''   and isnull(InsightComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,19
		,'Insight narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Memory narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'Memory'
		,'From #CustomMentalStatuses2  Where isnull(MemoryOther,''N'')=''Y''   and isnull(MemoryComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,19
		,'Memory narrative is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Reality Orientation selection is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'RealityOrientation'
		,'From #CustomMentalStatuses2  Where isnull(RealityOrientationAddToNeedsList,''N'')=''N''   and isnull(RealityOrientationIntact,''N'')=''N''   and isnull(RealityOrientationTenuous,''N'')=''N''   and isnull(RealityOrientationPoor,''N'')=''N''   and isnull(RealityOrientationOther,''N'')=''N''   and isnull(RealityOrientationComment,''N'')=''N''     and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,20
		,'Reality Orientation selection is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Reality Orientation narrative is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,'MentalStatus'
		,8
		,'CustomMentalStatuses2'
		,'RealityOrientation'
		,'From #CustomMentalStatuses2  Where isnull(RealityOrientationOther,''N'')=''Y''   and isnull(RealityOrientationComment,'''')=''''    and isnull(@SevereProfoundDisability,''N'')=''N'''
		,''
		,21
		,'Reality Orientation narrative is required'
		,NULL
		)
END

--Risk Assessment
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10018
	AND TableName = 'CustomHRMAssessments'
	AND taborder = 9

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment-Suicidality /other risk to self- Details textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'AdvanceDirectiveNarrative'
		,'From #CustomHRMAssessments   where ((isnull(SuicideCurrent,''N'')=''Y'' OR isnull(SuicidePriorAttempt,''N'')=''Y'')) and isnull(SuicideNotPresent,''N'')=''N''
		  and SuicideBehaviorsPastHistory is null'
		,''
		,2
		,'Risk Assessment-Suicidality /other risk to self- Details textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment- Physical aggression/other risk factors- Details textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'DeletedBy'
		,'From #CustomHRMAssessments   where (isnull(HomicideCurrent,''N'')=''Y'' or isnull(HomicidePriorAttempt,''N'')=''Y'' or isnull(HomicideMeans,''N'')=''Y'') and isnull(HomicideNotPresent,''N'')=''N''
		  and HomicideBehaviorsPastHistory is null'
		,''
		,3
		,'Risk Assessment- Physical aggression/other risk factors- Details textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment- Other Risk Factors- Describe Risk Factors is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'RiskOtherFactors'
		,'From #CustomHRMAssessments  where isnull(RiskOtherFactors,'''')='''' and (select COUNT(*) from CustomOtherRiskFactors where DocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted,''N'') = ''N'' AND ISNULL(OtherRiskFactor,0) > 0) > 0'
		,''
		,4
		,'Risk Assessment- Other Risk Factors- Describe Risk Factors is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment- Advance Directive- Does client have a mental health advance directive is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'DeletedBy'
		,'From #CustomHRMAssessments   where isnull(AdvanceDirectiveClientHasDirective,'''')='''' and AdultOrChild=''A'''
		,''
		,5
		,'Risk Assessment- Advance Directive- Does client have a mental health advance directive is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment- Advance Directive- Does client desire a mental health advance directive plan is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'DeletedBy'
		,'From #CustomHRMAssessments   where isnull(AdvanceDirectiveDesired,'''')='''' and AdultOrChild=''A'''
		,''
		,6
		,'Risk Assessment- Advance Directive- Does client desire a mental health advance directive plan is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment- Advance Directive- Would client like more information about mental health advance directive planning is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'DeletedBy'
		,'From #CustomHRMAssessments   where isnull(AdvanceDirectiveMoreInfo,'''')='''' and AdultOrChild=''A'''
		,''
		,7
		,'Risk Assessment- Advance Directive- Would client like more information about mental health advance directive planning is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Risk Assessment- Advance Directive- What information was the client given regarding mental health advance directive is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,9
		,'CustomHRMAssessments'
		,'AdvanceDirectiveNarrative'
		,'From #CustomHRMAssessments   where isnull(AdvanceDirectiveNarrative,'''')='''' and AdultOrChild=''A'''
		,''
		,8
		,'Risk Assessment- Advance Directive- What information was the client given regarding mental health advance directive is required'
		,NULL
		)
END

--Summary/Level of Care
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 10018
	AND TableName = 'CustomHRMAssessments'
	AND taborder = 18

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC-Treatment- Does client meet criteria for services is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'ClientIsAppropriateForTreatment'
		,'From #CustomHRMAssessments a  where ClientIsAppropriateForTreatment is null'
		,''
		,1
		,'Summary/LOC-Treatment- Does client meet criteria for services is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC-Treatment- If client does not meet criteria, was referral or other options offered is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'SecondOpinionNoticeProvided'
		,'From #CustomHRMAssessments a  where SecondOpinionNoticeProvided is null  and ClientIsAppropriateForTreatment = ''N'''
		,''
		,2
		,'Summary/LOC-Treatment- If client does not meet criteria, was referral or other options offered is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC-Treatment- Discuss treatment focus and client preferences is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'TreatmentNarrative'
		,'From #CustomHRMAssessments a    where isnull(TreatmentNarrative,'''')=''''    and isnull(ClientIsAppropriateForTreatment,'''') = ''''    and isnull(SecondOpinionNoticeProvided,'''') = '''''
		,''
		,3
		,'Summary/LOC-Treatment- Discuss treatment focus and client preferences is required'
		,NULL
		)
END

--IF NOT EXISTS (
--		SELECT *
--		FROM DocumentValidations
--		WHERE DocumentCodeId = 10018
--			AND ErrorMessage = 'Summary/LOC- Level of Care-textbox is required'
--		)
--BEGIN
--	INSERT INTO DocumentValidations (
--		Active
--		,DocumentCodeId
--		,DocumentType
--		,TabName
--		,TabOrder
--		,TableName
--		,ColumnName
--		,ValidationLogic
--		,ValidationDescription
--		,ValidationOrder
--		,ErrorMessage
--		,RecordDeleted
--		)
--	VALUES (
--		'Y'
--		,10018
--		,NULL
--		,NULL
--		,18
--		,'CustomHRMAssessments'
--		,'LevelOfCare'
--		,'From #CustomHRMAssessments a    where isnull(LOCId,'''')='''''
--		,''
--		,4
--		,'Summary/LOC- Level of Care-textbox is required'
--		,NULL
--		)
--END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC- Clinical Interpretative summary-textbox is required '
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'ClinicalSummary'
		,'From #CustomHRMAssessments  Where isnull(ClinicalSummary,'''')='''''
		,''
		,5
		,'Summary/LOC- Clinical Interpretative summary-textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC- LOC textbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'TransitionLevelOfCare'
		,'From #CustomHRMAssessments  Where isnull(TransitionLevelOfCare,'''')='''''
		,''
		,6
		,'Summary/LOC- LOC textbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC- Transition/LOC/Discharge Plan checkbox is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'ReductionInSymptoms'
		,'From #CustomHRMAssessments  Where isnull(ReductionInSymptoms,''N'')=''N'' and isnull(TreatmentNotNecessary,''N'')=''N'' and isnull(AttainmentOfHigherFunctioning,''N'')='''' and isnull(OtherTransitionCriteria,''N'')='''''
		,''
		,7
		,'Summary/LOC- Transition/LOC/Discharge Plan checkbox is required'
		,NULL
		)
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 10018
			AND ErrorMessage = 'Summary/LOC – Transition/LOC/Discharge Plan Estimated Discharge Date is required'
		)
BEGIN
	INSERT INTO DocumentValidations (
		Active
		,DocumentCodeId
		,DocumentType
		,TabName
		,TabOrder
		,TableName
		,ColumnName
		,ValidationLogic
		,ValidationDescription
		,ValidationOrder
		,ErrorMessage
		,RecordDeleted
		)
	VALUES (
		'Y'
		,10018
		,NULL
		,NULL
		,18
		,'CustomHRMAssessments'
		,'EstimatedDischargeDate'
		,'From #CustomHRMAssessments  Where isnull(EstimatedDischargeDate,'''')='''''
		,''
		,8
		,'Summary/LOC – Transition/LOC/Discharge Plan Estimated Discharge Date is required'
		,NULL
		)
END

--Psychosocial - Section 1
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsCurrentHealthIssues'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsCurrentHealthIssues,'''')='''' '
	,'Health - Current or past health issues - radio button selection is required'
	,1
	,'Health - Current or past health issues - radio button selection is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsCurrentHealthIssuesComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ((AdultOrChild = ''A'' AND (PsCurrentHealthIssues = ''Y'' OR PsCurrentHealthIssues = ''U'')) OR (AdultOrChild = ''C'' AND (PsCurrentHealthIssues = ''N'' OR PsCurrentHealthIssues = ''U'' OR PsSexuality = ''N'' OR PsSexuality = ''U'' OR PsImmunizations = ''N'' OR PsImmunizations = ''U''))) and ISNULL(PsCurrentHealthIssuesComment,'''')='''''
	,'Health - Current or past health issues - textbox is required'
	,4
	,'Health - Current or past health issues - textbox is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsMedications'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND  ISNULL(PsMedications,'''')='''' '
	,'Medications - Textbox is required'
	,5
	,'Medications - Textbox is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsMedicationsListToBeModified'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsMedications = ''L'' AND  ISNULL(PsMedicationsListToBeModified,'''')='''' '
	,'Medications - List has been reviewed with client is required'
	,6
	,'Medications - List has been reviewed with client is required'
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
	'N'
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsMedicationsComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND PsCurrentHealthIssues IS NOT NULL AND ISNULL(PsMedicationsComment,'''')='''' '
	,'Medications - Note efficacy of current and historical medications textbox is required'
	,7
	,'Medications - Note efficacy of current and historical medications textbox is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsClientAbuseIssues'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsClientAbuseIssues,'''')='''' '
	,'Client experienced abuse or neglect - Radio button selection is required'
	,29
	,'Client experienced abuse or neglect - Radio button selection is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'SexualityComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(SexualityComment,'''')='''' '
	,'Sexuality –Please discuss any client concerns  textbox is required'
	,29
	,'Sexuality –Please discuss any client concerns  textbox is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsClientAbuesIssuesComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND (PsClientAbuseIssues = ''Y'' OR PsClientAbuseIssues = ''U'') AND ISNULL(PsClientAbuesIssuesComment,'''')='''' '
	,'Client experienced abuse or neglect - Textbox is required'
	,30
	,'Client experienced abuse or neglect - Textbox is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsCulturalEthnicIssues'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PsCulturalEthnicIssues,'''')='''' '
	,'Culture/Ethnicity/Spirituality - Are there cultural/ethinic issues that are of concerns – Radio button selection is required'
	,31
	,'Culture/Ethnicity/Spirituality - Are there cultural/ethinic issues that are of concerns – Radio button selection is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsCulturalEthnicIssuesComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND (PsCulturalEthnicIssues =''Y'' OR PsCulturalEthnicIssues = ''U'') AND ISNULL(PsCulturalEthnicIssuesComment,'''')='''' '
	,'Culture/Ethnicity/Spirituality - Current or past health issues textbox is required'
	,32
	,'Culture/Ethnicity/Spirituality - Current or past health issues textbox is required'
	)

--INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage]) Values('Y','10018',Null,'Psychosocial','7','CustomHRMAssessments','SecondaryLanguage','FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SecondaryLanguage,'''')='''' ', ' ',33,'Education Status-dropdown selection is required') -- Veena this is not found in the design (Education Status-dropdown) I see only checkbox in this section, but it is there in the requirement table 
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'HistMentalHealthTx'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HistMentalHealthTx,'''')='''' '
	,'Mental health treatment history - Radio button selection is required'
	,34
	,'Mental health treatment history - Radio button selection is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'HistMentalHealthTxComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(HistMentalHealthTxComment,'''')='''' AND HistMentalHealthTx = ''Y'' AND AdultOrChild = ''C'' '
	,'Mental health treatment history - Mental Health Treatment History textbox  is required'
	,34
	,'Mental health treatment history - Mental Health Treatment History textbox  is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'AutisticallyImpaired'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AutisticallyImpaired,''N'')=''N'' AND ISNULL(CognitivelyImpaired,''N'')=''N'' AND ISNULL(EmotionallyImpaired,''N'')=''N'' AND ISNULL(BehavioralConcern,''N'')=''N'' AND ISNULL(LearningDisabilities,''N'')=''N'' AND ISNULL(PhysicalImpaired,''N'')=''N'' AND ISNULL(IEP,''N'')=''N'' AND ISNULL(ChallengesBarrier,''N'')=''N''  '
	,'Education-Education Status is required '
	,34
	,'Education-Education Status is required '
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
--	,'10018'
--	,NULL
--	,'Psychosocial'
--	,'7'
--	,'CustomHRMAssessments'
--	,'PsRiskLossOfPlacementDueTo'
--	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ((PsRiskLossOfPlacement = ''Y'' AND PsRiskLossOfPlacementDueTo IS NULL) OR
--(PsRiskLossOfSupport = ''Y'' AND PsRiskLossOfSupportDueTo IS NULL) OR
--(PsRiskExpulsionFromSchool = ''Y'' AND PsRiskExpulsionFromSchoolDueTo IS NULL) OR
--(PsRiskHospitalization = ''Y'' AND PsRiskHospitalizationDueTo IS NULL) OR
--(PsRiskCriminalJusticeSystem = ''Y'' AND PsRiskCriminalJusticeSystemDueTo IS NULL) OR
--(PsRiskElopementFromHome = ''Y'' AND PsRiskElopementFromHomeDueTo IS NULL) OR
--(PsRiskHigherLevelOfCare = ''Y'' AND PsRiskHigherLevelOfCareDueTo IS NULL) OR
--(PsRiskOutOfCountryPlacement = ''Y'' AND PsRiskOutOfCountryPlacementDueTo IS NULL) OR
--(PsRiskOutOfHomePlacement = ''Y'' AND PsRiskOutOfHomePlacementDueTo IS NULL) OR
--(PsRiskLossOfFinancialStatus = ''Y'' AND PsRiskLossOfFinancialStatusDueTo IS NULL))'

--	,'Client is at risk of - Dropdown is required'
--	,35
--	,'Client is at risk of - Dropdown is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'CommunicableDiseaseAssessed'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CommunicableDiseaseAssessed,'''')='''''
	,'Client has been assessed for communicable disease - Dropdown is required'
	,35
	,'Client has been assessed for communicable disease - Dropdown is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'CommunicableDiseaseFurtherInfo'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(CommunicableDiseaseFurtherInfo,'''')='''''
	,'Further information and justification is required'
	,35
	,'Further information and justification is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'FamilyFriendFeelingsCausedDistress'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FamilyFriendFeelingsCausedDistress,'''')='''' '
	,'Anxiety - Have your feelings caused you distress or interested with your ability to get along - Radio button selection is required'
	,36
	,'Anxiety - Have your feelings caused you distress or interested with your ability to get along - Radio button selection is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'FeltNervousAnxious'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(FeltNervousAnxious,'''')='''' '
	,'Anxiety - How often have you felt nervous, anxious, or on edge – Dropdown is required'
	,37
	,'Anxiety - How often have you felt nervous, anxious, or on edge – Dropdown is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'NotAbleToStopWorrying'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(NotAbleToStopWorrying,'''')='''' '
	,'Anxiety - How often were you not able to stop worrying or controlling your worry - Dropdown is required'
	,38
	,'Anxiety - How often were you not able to stop worrying or controlling your worry - Dropdown is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'StressPeoblemForHandlingThing'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(StressPeoblemForHandlingThing,'''')='''' '
	,'Anxiety - How often is stress a problem - Dropdown  is required'
	,39
	,'Anxiety - How often is stress a problem - Dropdown  is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'SocialAndEmotionalNeed'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SocialAndEmotionalNeed,'''')='''' '
	,'Anxiety - How often do you get the social and emotional support you need - Dropdown is required'
	,40
	,'Anxiety - How often do you get the social and emotional support you need - Dropdown is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PleasureInDoingThings'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(PleasureInDoingThings,'''')='''' '
	,'PHQ9 - Little interest or pleasure in doing things - is required'
	,41
	,'PHQ9 - Little interest or pleasure in doing things - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'DepressedHopelessFeeling'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DepressedHopelessFeeling,'''')='''' '
	,'PHQ9 - Feeling down, depressed or hopeless - is required'
	,42
	,'PHQ9 - Feeling down, depressed or hopeless - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'AsleepSleepingFalling'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(AsleepSleepingFalling,'''')='''' '
	,'PHQ9 - Trouble falling or staying asleep or sleeping to much - is required'
	,43
	,'PHQ9 - Trouble falling or staying asleep or sleeping to much - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'TiredFeeling'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TiredFeeling,'''')='''' '
	,'PHQ9 - Feeling tired or having little energy - is required'
	,44
	,'PHQ9 - Feeling tired or having little energy - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'OverEating'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(OverEating,'''')='''' '
	,'PHQ9 - Poor appetite or overeating - is required'
	,45
	,'PHQ9 - Poor appetite or overeating - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'BadAboutYourselfFeeling'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(BadAboutYourselfFeeling,'''')='''' '
	,'PHQ9 - Feeling bad about yourself or that you are a failure or have let yourself or your family down - is required'
	,46
	,'PHQ9 - Feeling bad about yourself or that you are a failure or have let yourself or your family down - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'TroubleConcentratingOnThings'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(TroubleConcentratingOnThings,'''')='''' '
	,'PHQ9 - Trouble concentrating on things such as reading the newspaper or watching television - is required'
	,47
	,'PHQ9 - Trouble concentrating on things such as reading the newspaper or watching television - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'SpeakingSlowlyOrOpposite'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(SpeakingSlowlyOrOpposite,'''')='''' '
	,'PHQ9 - Moving or speaking so slowly that other people could have noticed - is required'
	,48
	,'PHQ9 - Moving or speaking so slowly that other people could have noticed - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'BetterOffDeadThought'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(BetterOffDeadThought,'''')='''' '
	,'PHQ9 - Thoughts that you would be better off dead or of hurting yourself in some way - is required'
	,49
	,'PHQ9 - Thoughts that you would be better off dead or of hurting yourself in some way - is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'DifficultProblem'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DifficultProblem,'''')='''' '
	,'PHQ9 - If you checked off any problems - is required'
	,50
	,'PHQ9 - If you checked off any problems - is required'
	)

---for child
--Psychosocial - Section 1
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsSexuality'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsSexuality,'''')=''''  AND (PsCurrentHealthIssues =''Y'' OR PsCurrentHealthIssues =''U'') '
	,'Are there any issues around current or past sexual behaviors is required '
	,2
	,'Are there any issues around current or past sexual behaviors is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsImmunizations'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsImmunizations,'''')=''''  '
	,'Health-are immunizations current is required '
	,3
	,'Health-are immunizations current is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsLanguageFunctioning'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsLanguageFunctioning,'''')=''''  '
	,'Functioning-Are there concerns with  language functioning is required '
	,8
	,'Functioning-Are there concerns with  language functioning is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsVisualFunctioning'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsVisualFunctioning,'''')=''''  '
	,'Functioning- Are there concerns with visual functioning is required '
	,9
	,'Functioning- Are there concerns with visual functioning is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsIntellectualFunctioning'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsIntellectualFunctioning,'''')=''''  '
	,'Functioning- Are there concerns with intellectual functioning is required '
	,10
	,'Functioning- Are there concerns with intellectual functioning is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsLearningAbility'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsLearningAbility,'''')=''''  '
	,'Functioning- Are there concerns with learning ability is required '
	,11
	,'Functioning- Are there concerns with learning ability is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsFunctioningConcernComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsFunctioningConcernComment,'''')=''''  AND (PsLanguageFunctioning =''Y'' OR PsVisualFunctioning =''Y'' OR PsIntellectualFunctioning =''Y'' OR PsLearningAbility =''Y'') '
	,'functioning –please address all of the above items that have been identified is required '
	,12
	,'functioning –please address all of the above items that have been identified is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'ReceivePrenatalCare'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ReceivePrenatalCare,'''')=''''  '
	,'Developmental/Attachment History-Did mother receive prenatal care is required  '
	,13
	,'Developmental/Attachment History-Did mother receive prenatal care is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'ProblemInPregnancy'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ProblemInPregnancy,'''')=''''  '
	,'Developmental/Attachment History-Were there any issues or problems during pregnancy  is required '
	,14
	,'Developmental/Attachment History-Were there any issues or problems during pregnancy  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PrenatalExposer'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PrenatalExposer,'''')=''''  '
	,'Developmental/Attachment History- Prenatal exposer to substances  is required '
	,15
	,'Developmental/Attachment History- Prenatal exposer to substances  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'WhereMedicationUsed'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(WhereMedicationUsed,'''')=''''  '
	,'Developmental/Attachment History-Where medications used during pregnancy  is required '
	,16
	,'Developmental/Attachment History-Where medications used during pregnancy  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'IssueWithDelivery'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(IssueWithDelivery,'''')=''''  '
	,'Developmental/Attachment History-Where there any issues during delivery  is required'
	,17
	,'Developmental/Attachment History-Where there any issues during delivery  is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'ChildDevelopmentalMilestones'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ChildDevelopmentalMilestones,'''')=''''  '
	,'Developmental/Attachment History-Has the child met developmental milestones  is required '
	,18
	,'Developmental/Attachment History-Has the child met developmental milestones  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'WhenTheyWalk'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND (ISNULL(WhenTheyWalk,'''')='''' and IsNull(WhenTheyWalkUnknown,''N'')<>''Y'') '
	,'Developmental/Attachment History-When did they walk  is required '
	,19
	,'Developmental/Attachment History-When did they walk  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'TalkBefore'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(TalkBefore,'''')=''''  '
	,'Developmental/Attachment History-Did they talk before they walked  is required '
	,20
	,'Developmental/Attachment History-Did they talk before they walked  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'WhenTheyTalk'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND (ISNULL(WhenTheyTalk,'''')='''' and IsNull(WhenTheyTalkUnknown,''N'')<>''Y'')'
	,'Developmental/Attachment History-When did they talk-single words  is required '
	,21
	,'Developmental/Attachment History-When did they talk-single words  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'WhenTheyTalkSentences'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId  AND AdultOrChild = ''C'' AND (ISNULL(WhenTheyTalkSentences,'''')='''' and IsNull(WhenTheyTalkSentenceUnknown,''N'')<>''Y'')'
	,'Developmental/Attachment History-When did they talk in sentences  is required '
	,22
	,'Developmental/Attachment History-When did they talk in sentences  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'DevelopmentalAttachmentComments'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(DevelopmentalAttachmentComments,'''')='''' AND (ReceivePrenatalCare =''Y'' OR ProblemInPregnancy =''Y'' OR PrenatalExposer =''Y'' OR WhereMedicationUsed =''Y'' OR IssueWithDelivery =''Y'' OR ChildDevelopmentalMilestones =''Y'' OR TalkBefore =''Y'')'
	,'Development/Attachment History –please address all of the above items that have been identified is required'
	,23
	,'Development/Attachment History –please address all of the above items that have been identified is required'
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'ParentChildRelationshipIssue'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(ParentChildRelationshipIssue,'''')=''''  '
	,'Family Functioning- Are there any parent/child relationship issues that are of concern  is required '
	,24
	,'Family Functioning- Are there any parent/child relationship issues that are of concern  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsChildHousingIssues'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsChildHousingIssues,'''')=''''  '
	,'Family Functioning-Are there current housing issues for the child  is required '
	,25
	,'Family Functioning-Are there current housing issues for the child  is required  '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsParentalParticipation'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsParentalParticipation,'''')=''''  '
	,'Family Functioning-Are parents/guardians willing to participate in treatment  is required '
	,26
	,'Family Functioning-Are parents/guardians willing to participate in treatment  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'FamilyRelationshipIssues'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(FamilyRelationshipIssues,'''')=''''  '
	,'Family Functioning-Are there any other family relationship issues that are of concerns  is required '
	,27
	,'Family Functioning-Are there any other family relationship issues that are of concerns  is required '
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
	,'10018'
	,NULL
	,'Psychosocial'
	,'7'
	,'CustomHRMAssessments'
	,'PsFamilyConcernsComment'
	,'FROM CustomHRMAssessments WHERE DocumentVersionId=@DocumentVersionId AND AdultOrChild = ''C'' AND ISNULL(PsFamilyConcernsComment,'''')='''' AND (ParentChildRelationshipIssue =''Y'' OR PsChildHousingIssues =''Y'' OR FamilyRelationshipIssues =''Y'' OR PsParentalParticipation =''Y'')'
	,'Family Functioning-Family functioning textbox  is required '
	,28
	,'Family Functioning-Family functioning textbox  is required '
	)