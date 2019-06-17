
delete FROM DocumentValidations
	WHERE DocumentCodeId = 10018 and TableName='CustomDocumentGambling'
	
	--select *  FROM DocumentValidations WHERE DocumentCodeId = 10018 and TableName='CustomDocumentGambling'
---Gambling
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Date is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'GamblingDate'
		,'From CustomDocumentGambling  where  DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(GamblingDate,'''')<='''''
		,''
		,1
		,'Demographics section- Date is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Estimated total monthly household income before taxes is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'TotalMonthlyHousehold'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(TotalMonthlyHousehold,'''')='''''
		,''
		,2
		,'Demographics section- Estimated total monthly household income before taxes is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Total number of dependents living with you including yourself is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'TotalNumberOfDependents'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(TotalNumberOfDependents,'''')='''''
		,''
		,3
		,'Demographics section- Total number of dependents living with you including yourself is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Health Insurance is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'HealthInsurance'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(HealthInsurance,'''')='''''
		,''
		,4
		,'Demographics section- Health Insurance is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Last grade completed is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'LastGradeCompleted'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(LastGradeCompleted,'''')='''''
		,''
		,5
		,'Demographics section- Last grade completed is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Primary source of household income is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'PrimarySourceOfIncome'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(PrimarySourceOfIncome,'''')='''''
		,''
		,6
		,'Demographics section- Primary source of household income is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Demographics section- Total estimated debt related to gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'TotalEstimatedGamblingDebt'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId  AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(TotalEstimatedGamblingDebt,'''')='''''
		,''
		,7
		,'Demographics section- Total estimated debt related to gambling is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Life in general is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'LifeInGeneral'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(LifeInGeneral,-1)<=0'
		,''
		,8
		,'Satisfaction section- Life in general is required'
		,NULL
		)
END


IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Overall physical health is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'OverallPhysicalHealth'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(OverallPhysicalHealth,-1)<=0'
		,''
		,9
		,'Satisfaction section- Overall physical health is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Overall emotional wellbeing is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'OverallEmotionalWellbeing'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(OverallEmotionalWellbeing,-1)<=0'
		,''
		,10
		,'Satisfaction section- Overall emotional wellbeing is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Relationship with my spouse or significant other is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'RelationshipWithSpouse'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId  AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(RelationshipWithSpouse,-1)<=0'
		,''
		,11
		,'Satisfaction section- Relationship with my spouse or significant other is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Relationship with my children is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'RelationshipWithChildren'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(RelationshipWithChildren,-1)<=0'
		,''
		,13
		,'Satisfaction section-Relationship with my children is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Relationship with my friends is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'RelationshipWithFriends'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(RelationshipWithFriends,-1)<=0'
		,''
		,14
		,'Satisfaction section- Relationship with my friends is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Relationship with other family members is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'RelationshipWithOtherFamilyMembers'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(RelationshipWithOtherFamilyMembers,-1)<=0'
		,''
		,14
		,'Satisfaction section- Relationship with other family members is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Job is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'Job'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(Job,-1)<=0'
		,''
		,15
		,'Satisfaction section- Job is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- School is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'School'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(School,-1)<=0'
		,''
		,16
		,'Satisfaction section- School is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Satisfaction section- Spiritual wellbeing is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'SpiritualWellbeing'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(SpiritualWellbeing,-1)<=0'
		,''
		,17
		,'Satisfaction section- Spiritual wellbeing is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Accomplish responsibilities at work is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AccomplishedResponsibilitiesAtWork'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(AccomplishedResponsibilitiesAtWork,-1)<=0'
		,''
		,18
		,'Acitvities section- Accomplish responsibilities at work is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Pay bills on time is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'PaidBillsOnTime'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(PaidBillsOnTime,-1)<=0'
		,''
		,19
		,'Acitvities section- Pay bills on time is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Accomplish responsibilities at home is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AccomplishedResponsibilitiesAtHome'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(AccomplishedResponsibilitiesAtHome,-1)<=0'
		,''
		,20
		,'Acitvities section- Accomplish responsibilities at home is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Have thoughts of suicide is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'HaveThoughtsOfSuicide'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(HaveThoughtsOfSuicide,-1)<=0'
		,''
		,21
		,'Acitvities section- Have thoughts of suicide is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Attempt to commit suicide is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AttemptToCommitSuicide'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(AttemptToCommitSuicide,-1)<=0'
		,''
		,22
		,'Acitvities section- Attempt to commit suicide is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Drink alcohol is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'DrinkAlcohol'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(DrinkAlcohol,-1)<=0'
		,''
		,23
		,'Acitvities section- Drink alcohol is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Have problems associated with my use of alcohol is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ProblemsAssociatedWithAlcohol'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(ProblemsAssociatedWithAlcohol,-1)<=0'
		,''
		,24
		,'Acitvities section- Have problems associated with my use of alcohol is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Use illegal drugs is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'UseOfIllegalDrugs'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(UseOfIllegalDrugs,-1)<=0'
		,''
		,25
		,'Acitvities section- Use illegal drugs is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Have problems associated with my use of illegal drugs is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ProblemsAssociatedWithIllegalDrugs'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'' )  AND isnull(ProblemsAssociatedWithIllegalDrugs,-1)<=0'
		,''
		,26
		,'Acitvities section- Have problems associated with my use of illegal drugs is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Use tobacco – smoked or chewed is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'UseOfTobacco'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(UseOfTobacco,-1)<=0'
		,''
		,27
		,'Acitvities section- Use tobacco – smoked or chewed is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Commit illegal acts to get money to gamble with is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'CommitIllegalActs'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(CommitIllegalActs,-1)<=0'
		,''
		,28
		,'Acitvities section- Commit illegal acts to get money to gamble with is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Maintain a supportive network of family and/or friends is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'MaintainSupportiveNetworkOfFamily'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND  EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(MaintainSupportiveNetworkOfFamily,-1)<=0'
		,''
		,29
		,'Acitvities section- Maintain a supportive network of family and/or friends is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Take time off to relax and rest is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'TakeTimeToRelax'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(TakeTimeToRelax,-1)<=0'
		,''
		,30
		,'Acitvities section- Take time off to relax and rest is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Eat healthy foods is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'EatHealthyFood'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId  AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(EatHealthyFood,-1)<=0'
		,''
		,31
		,'Acitvities section- Eat healthy foods is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Exercise is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'Exercise'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(Exercise,-1)<=0'
		,''
		,32
		,'Acitvities section- Exercise is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Acitvities section- Attend community support (GA, NA, AA, etc.) is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AttendCommunitySupport'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND  isnull(AttendCommunitySupport,-1)<=0'
		,''
		,33
		,'Acitvities section- Attend community support (GA, NA, AA, etc.) is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage = 'Gambling section- Often find yourself thinking about gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ThinkingAboutGambling'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(ThinkingAboutGambling,-1)<=0'
		,''
		,34
		, 'Gambling section- Often find yourself thinking about gambling is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Need to gamble with more and more money to get the amount of excitement you were looking for is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'GamblingWithMoreMoney'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId  AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(GamblingWithMoreMoney,-1)<=0'
		,''
		,35
		,'Gambling section- Need to gamble with more and more money to get the amount of excitement you were looking for is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Make repeated unsuccessful attempts to control, cut back or stop gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'UnsuccessfulAttemptsToControlGambling'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId  AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(UnsuccessfulAttemptsToControlGambling,-1)<=0'
		,''
		,36
		,'Gambling section- Make repeated unsuccessful attempts to control, cut back or stop gambling is required'
		,NULL
		)
END


IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Become restless or irritable when trying to cut down or stop gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'RestlessOrIrritable'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(RestlessOrIrritable,-1)<=0'
		,''
		,37
		,'Gambling section- Become restless or irritable when trying to cut down or stop gambling is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Gamble to escape from problems or when you were feeling depressed, anxious, or bad about yourself is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'GambleToEscapeFromProblems'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(GambleToEscapeFromProblems,-1)<=0'
		,''
		,38
		,'Gambling section- Gamble to escape from problems or when you were feeling depressed, anxious, or bad about yourself is required'
		,NULL
		)
END


IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- After losing money gambling, return another day in order to get even is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ReturningAfterLosingGamblingMoney'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND  isnull(ReturningAfterLosingGamblingMoney,-1)<=0'
		,''
		,39
		,'Gambling section- After losing money gambling, return another day in order to get even is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Lie to your family or others to hide the extent of your gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'LieToFamily'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(LieToFamily,-1)<=0'
		,''
		,40
		,'Gambling section- Lie to your family or others to hide the extent of your gambling is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Go beyond what is strictly legal in order to finance gambling or to pay gambling debts is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'GoBeyondLegalGambling'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND  isnull(GoBeyondLegalGambling,-1)<=0'
		,''
		,41
		,'Gambling section- Go beyond what is strictly legal in order to finance gambling or to pay gambling debts is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Risk or lose a significant relationship, job, educational or career opportunity because of gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'LoseSignificantRelationship'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(LoseSignificantRelationship,-1)<=0'
		,''
		,42
		,'Gambling section- Risk or lose a significant relationship, job, educational or career opportunity because of gambling is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Risk or lose a significant relationship, job, educational or career opportunity because of gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'SeekHelpFromOthers'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND isnull(SeekHelpFromOthers,-1)<=0'
		,''
		,43
		,'Gambling section- Risk or lose a significant relationship, job, educational or career opportunity because of gambling is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Seek help from others to provide money to relieve a desperate financial situation caused by gambling is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'SeekHelpFromOthers'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(SeekHelpFromOthers,-1)<=0'
		,''
		,44
		,'Gambling section- Seek help from others to provide money to relieve a desperate financial situation caused by gambling is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Number of days gambled during the last 30 days is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'NumberOfDaysGambled'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(NumberOfDaysGambled,-1)<=0'
		,''
		,45
		,'Gambling section- Number of days gambled during the last 30 days is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Average amount gambled for each day that you gambled during the last 30 days is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AverageAmountGambled'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(AverageAmountGambled,-1)<=0'
		,''
		,46
		,'Gambling section- Average amount gambled for each day that you gambled during the last 30 days is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- What was the primary gambling activity (game) played during the past 30 days is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'PrimaryGamblingActivity'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(PrimaryGamblingActivity,'''')='''''
		,''
		,47
		,'Gambling section- What was the primary gambling activity (game) played during the past 30 days is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Where did you primarily gamble in the past 30 days is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'PrimarilyGamblingPlace'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId  AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(PrimarilyGamblingPlace,'''')='''''
		,''
		,48
		,'Gambling section- Where did you primarily gamble in the past 30 days is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Number of times in the past 6 months that you went to an emergency room or urgent care center is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'NumberOfTimesEnteredEmergencyRoom'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(NumberOfTimesEnteredEmergencyRoom,-1)<0'
		,''
		,49
		,'Gambling section- Number of times in the past 6 months that you went to an emergency room or urgent care center is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Did you enroll in a treatment program for the treatment of alcohol and/or drug abuse problems? is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'EnrolledInTreatmentProgramForAlcohol'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(EnrolledInTreatmentProgramForAlcohol,-1)<=0'
		,''
		,50
		,'Gambling section- Did you enroll in a treatment program for the treatment of alcohol and/or drug abuse problems? is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Number of times in the past 6 months that you went to an emergency room or urgent care center is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'NumberOfTimesEnteredEmergencyRoom'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(NumberOfTimesEnteredEmergencyRoom,-1)<=0'
		,''
		,51
		,'Gambling section- Number of times in the past 6 months that you went to an emergency room or urgent care center is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Treatment of alcohol Inpatient A&D is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AlcoholInpatientAAndD'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(EnrolledInTreatmentProgramForAlcohol,0)IN (SELECT GlobalCodeId from GlobalCodes where Category=''XGAMBLING'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(AlcoholInpatientAAndD,'''')='''''
		,''
		,52
		,'Gambling section- Treatment of alcohol Inpatient A&D is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Treatment of alcohol Outpatient A&D is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AlcoholOutpatientAAndD'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(EnrolledInTreatmentProgramForAlcohol,0)IN (SELECT GlobalCodeId from GlobalCodes where Category=''XGAMBLING'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(AlcoholOutpatientAAndD,'''')='''''
		,''
		,53
		,'Gambling section- Treatment of alcohol Outpatient A&D is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Did you enroll in a treatment program for mental health problems is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'EnrolledInTreatmentProgramForMentalHealth'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(EnrolledInTreatmentProgramForMentalHealth,-1)<=0'
		,''
		,54
		,'Gambling section- Did you enroll in a treatment program for mental health problems is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Mental health problem Inpatient A&D is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'MentalHealthInpatientAAndD'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(EnrolledInTreatmentProgramForMentalHealth,0) IN (SELECT GlobalCodeId from GlobalCodes where Category=''XGAMBLING'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(MentalHealthInpatientAAndD,'''')='''''
		,''
		,55
		,'Gambling section- Mental health problem Inpatient A&D is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Mental health problem Outpatient A&D is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'MentalHealthOutpatientAAndD'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(EnrolledInTreatmentProgramForMentalHealth,0)IN (SELECT GlobalCodeId from GlobalCodes where Category=''XGAMBLING'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(MentalHealthOutpatientAAndD,'''')='''''
		,''
		,56
		,'Gambling section- Mental health problem Outpatient A&D is required'
		,NULL
		)
END

IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- Did you enroll in another gambling treatment program, or see another therapist or doctor outside the staff of the gambling program you attended is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'EnrolledInAnotherGamblingProgram'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(EnrolledInAnotherGamblingProgram,-1)<=0'
		,''
		,57
		,'Gambling section- Did you enroll in another gambling treatment program, or see another therapist or doctor outside the staff of the gambling program you attended is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- gambling treatment program Inpatient A&D is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'GamblingInpatientAAndD'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(EnrolledInAnotherGamblingProgram,0) IN (SELECT GlobalCodeId from GlobalCodes where Category=''XGAMBLING'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(GamblingInpatientAAndD,'''')='''''
		,''
		,58
		,'Gambling section- gambling treatment program Inpatient A&D is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- gambling treatment program Outpatient A&D is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'GamblingOutpatientAAndD'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND ISNULL(EnrolledInAnotherGamblingProgram,0) IN (SELECT GlobalCodeId from GlobalCodes where Category=''XGAMBLING'' AND CodeName=''Yes'' AND ISNULL(RecordDeleted,''N'')=''N'')  AND isnull(GamblingOutpatientAAndD,'''')='''''
		,''
		,59
		,'Gambling section- gambling treatment program Outpatient A&D is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- In the past 6 months, have you filed for bankruptcy is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'FiledForBankruptcy'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(FiledForBankruptcy,'''')='''''
		,''
		,60
		,'Gambling section- In the past 6 months, have you filed for bankruptcy is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- In the past 6 months, have you been convicted of any gambling related crime is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ConvictedOfGambling'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(ConvictedOfGambling,'''')='''''
		,''
		,61
		,'Gambling section- In the past 6 months, have you been convicted of any gambling related crime is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- In the past 6 months, have you experienced physical violence in a relationship is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ExperiencedPhysicalViolence'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(ExperiencedPhysicalViolence,'''')='''''
		,''
		,62
		,'Gambling section- In the past 6 months, have you experienced physical violence in a relationship is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- In the past 6 months, have you experienced verbal, emotional, or psychological abuse in a relationship is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'AbuseInRelationship'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(AbuseInRelationship,'''')='''''
		,''
		,63
		,'Gambling section- In the past 6 months, have you experienced verbal, emotional, or psychological abuse in a relationship is required'
		,NULL
		)
END
IF NOT EXISTS (
	SELECT *
	FROM DocumentValidations
	WHERE DocumentCodeId = 10018
		AND ErrorMessage ='Gambling section- In the past 6 months, have you felt controlled, trapped or manipulated by a significant other is required'
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
		,'Gambling'
		,2
		,'CustomDocumentGambling'
		,'ControlloedManipulatedByOther'
		,'From CustomDocumentGambling  where DocumentVersionId=@DocumentVersionId AND EXISTS(SELECT 1 FROM CustomHRMAssessments WHERE  DocumentVersionId=@DocumentVersionId AND  ISNULL(ClientInAutsimPopulation,''N'')=''Y'' AND ISNULL(RecordDeleted,''N'')=''N'') AND isnull(ControlloedManipulatedByOther,'''')='''''
		,''
		,64
		,'Gambling section- In the past 6 months, have you felt controlled, trapped or manipulated by a significant other is required'
		,NULL
		)
END

