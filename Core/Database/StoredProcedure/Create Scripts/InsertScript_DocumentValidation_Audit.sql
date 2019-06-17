DELETE FROM DocumentValidations WHERE DocumentCodeId = 1652 AND TableName = 'DocumentAssessmentAudits'


INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'ContainingAlcohol'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') = '''' '
	,'Audit-Alc. Disorder-How often do you drink is required'
	,1
	,'Audit-Alc. Disorder-How often do you drink is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'DrinkingAlcohol'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(DrinkingAlcohol,'''') = '''''
	,'Audit-Alc. Disorder-How many drinks is required'
	,2
	,'Audit-Alc. Disorder-How many drinks is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'DrinkOnOccasion'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(DrinkOnOccasion,'''') = '''' '
	,'Audit-Alc. Disorder-How often six or more is required'
	,3
	,'Audit-Alc. Disorder-How often six or more is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'PastYearFoundMoreThanOnce'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(PastYearFoundMoreThanOnce,'''') = '''' '
	,'Audit-Alc. Disorder-How often have you drank more than intended is required'
	,4
	,'Audit-Alc. Disorder-How often have you drank more than intended is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'LastYearFailedToDo'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(LastYearFailedToDo,'''') = '''' '
	,'Audit-Alc. Disorder-How often have you failed to do What Was normally expected of you is required'
	,5
	,'Audit-Alc. Disorder-How often have you failed to do What Was normally expected of you is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'HeavyDrinkingSession'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(HeavyDrinkingSession,'''') = '''''
	,'Audit-Alc. Disorder-How often have you needed a first drink in the morning is required'
	,6
	,'Audit-Alc. Disorder-How often have you needed a first drink in the morning is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'FeltGuiltyAfterDrinking'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(FeltGuiltyAfterDrinking,'''') = '''' '
	,'Audit-Alc. Disorder-How often have you felt guilty or remorseful is required'
	,7
	,'Audit-Alc. Disorder-How often have you felt guilty or remorseful is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'UnableToRemember'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(ContainingAlcohol,'''') != (SELECT GlobalCodeId FROM GlobalCodes WHERE Category = ''XWRATTESTNUMBER'' AND Code = ''0- Never'') AND ISNULL(UnableToRemember,'''') = '''''
	,'Audit-Alc. Disorder-How often have you been unable to remember is required'
	,8
	,'Audit-Alc. Disorder-How often have you been unable to remember is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'InjuredBecauseOfDrinking'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(InjuredBecauseOfDrinking,'''') = '''''
	,'Audit-Alc. Disorder-Have you or someone else been injured is required'
	,9
	,'Audit-Alc. Disorder-Have you or someone else been injured is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'RelativeSuggestedToQuit'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(RelativeSuggestedToQuit,'''') = '''' '
	,'Audit-Alc. Disorder-Has a relative, friend, doctor, or other health care worker been concerned about your drinking is required'
	,10
	,'Audit-Alc. Disorder-Has a relative, friend, doctor, or other health care worker been concerned about your drinking is required'
	,NULL
	)

INSERT INTO [documentvalidations] (
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
	,[SectionName]
	)
VALUES (
	'Y'
	,1652
	,NULL
	,'AUDIT'
	,1
	,'DocumentAssessmentAudits'
	,'Score'
	,'FROM DocumentAssessmentAudits WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DeclinesToAnswer,'''') <> ''Y'' AND ISNULL(Score,'''') = '''' '
	,'Audit-Alc. Disorder - Score is required'
	,11
	,'Audit-Alc. Disorder - Score is required'
	,NULL
	)