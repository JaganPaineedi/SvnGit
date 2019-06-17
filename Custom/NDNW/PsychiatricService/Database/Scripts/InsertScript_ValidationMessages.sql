
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 21300

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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'AppropriatelyDressed'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(AppropriatelyDressed, ''N'') = ''N'' and isnull(GeneralAppearanceUnkept, ''N'') = ''N'' and isnull(GeneralAppearanceOther, ''N'') = ''N'' '
	,N'Appearance and manner – at least one checkbox is required'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Appearance and manner – at least one checkbox is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'GeneralAppearanceOtherText'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(GeneralAppearanceOther, ''N'') = ''Y'' and isnull(GeneralAppearanceOtherText,'''')='''' '
	,N'Appearance and manner – Other Text Box is Required'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Appearance and manner – Other Text Box is Required'
	)

	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'MuscleStrengthNormal'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(MuscleStrengthNormal, ''N'') = ''N'' and isnull(MuscleStrengthAbnormal, ''N'') = ''N'' and isnull(MusculoskeletalTone, ''N'') = ''N'' '
	,N'Musculoskeletal – at least one checkbox is required'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Musculoskeletal – at least one checkbox is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'GaitNormal'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(GaitNormal, ''N'') = ''N'' and isnull(GaitAbnormal, ''N'') = ''N'' and isnull(TicsTremorsAbnormalMovements, ''N'') = ''N'' and isnull(EPS, ''N'') = ''N'' '
	,N'Gait and Station – at least one checkbox is required'
	,CAST(4 AS DECIMAL(18, 0))
	,N'Gait and Station– at least one checkbox is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'AppearanceBehaviorComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(AppearanceBehavior, ''N'') = ''Y'' and isnull(AppearanceBehaviorComments,'''')='''' '
	,N'Appearance and behavior thoughts is required'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Examination-psychiatric- Appearance and behavior thoughts is required '
	)
	

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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'SpeechComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(Speech, ''N'') = ''Y'' and isnull(SpeechComments,'''')='''' '
	,N'Speech comment is required'
	,CAST(6 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Speech comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'ThoughtProcessComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(ThoughtProcess, ''N'') = ''Y'' and isnull(ThoughtProcessComments,'''')='''' '
	,N'Thought process comment is required'
	,CAST(7 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Thought process comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'AssociationsComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(Associations, ''N'') = ''Y'' and isnull(AssociationsComments,'''')='''' '
	,N'Associations comment is required'
	,CAST(8 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Associations comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'AbnormalPsychoticThoughtsComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(AbnormalPsychoticThoughts, ''N'') = ''Y'' and isnull(AbnormalPsychoticThoughtsComments,'''')='''' '
	,N'Abnormal/psychotic thoughts is required'
	,CAST(9 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Abnormal/psychotic thoughts is required'
	)
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'JudgmentAndInsightComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(JudgmentAndInsight, ''N'') = ''Y'' and isnull(JudgmentAndInsightComments,'''')='''' '
	,N'Judgment & insight comment is required'
	,CAST(10 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Judgment & insight comment is required'
	)
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'OrientationComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(Orientation, ''N'') = ''Y'' and isnull(OrientationComments,'''')='''' '
	,N'Orientation comment is required'
	,CAST(11 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Orientation comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'RecentRemoteMemoryComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(RecentRemoteMemory, ''N'') = ''Y'' and isnull(RecentRemoteMemoryComments,'''')='''' '
	,N'Recent & remote memory comment is required'
	,CAST(12 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Recent & remote memory comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'AttentionConcentrationComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(AttentionConcentration, ''N'') = ''Y'' and isnull(AttentionConcentrationComments,'''')='''' '
	,N'-Attention & concentration comment is required'
	,CAST(13 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Attention & concentration comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'LanguageCommments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(Language, ''N'') = ''Y'' and isnull(LanguageCommments,'''')='''' '
	,N'-Language comment is required'
	,CAST(14 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Language comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'FundOfKnowledgeComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(FundOfKnowledge, ''N'') = ''Y'' and isnull(FundOfKnowledgeComments,'''')='''' '
	,N'-Fund of knowledge comment is required'
	,CAST(15 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Fund of knowledge comment is required'
	)
	
	
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
	,21300
	,NULL
	,'Exam'
	,3
	,N'CustomDocumentPsychiatricServiceNoteExams'
	,N'MoodAndAffectComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteExams WHERE DocumentVersionId=@DocumentVersionId AND isnull(MoodAndAffect, ''N'') = ''Y'' and isnull(MoodAndAffectComments,'''')='''' '
	,N'-Mood & affect comment is required'
	,CAST(16 AS DECIMAL(18, 0))
	,N'Examination-psychiatric-Mood & affect comment is required'
	)
	
	
		
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
	,21300
	,NULL
	,'Diagnosis'
	,5
	,N'CustomDocumentPsychiatricServiceNoteGenerals'
	,N'DocumentVersionId'
	,N'FROM CustomDocumentPsychiatricServiceNoteGenerals CD where (select count(documentversionid) from DocumentDiagnosisCodes dc where documentversionid = @DocumentVersionId and IsNull(dc.RecordDeleted, ''N'') = ''N'' ) = 0  '
	,N'Please specify a diagnosis code and description'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Please specify a diagnosis code and description'
	)
	
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
	,21300
	,NULL
	,'Diagnosis'
	,5
	,N'DocumentDiagnosisCodes'
	,N'DiagnosisOrder'
	,N'FROM DocumentDiagnosisCodes dc where dc.documentversionid = @DocumentVersionId and IsNull(dc.RecordDeleted,''N'') = ''N''  and DiagnosisOrder is null  '
	,N'Please specify an order'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Please specify an order'
	)
	
	
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
	,21300
	,NULL
	,'Diagnosis'
	,5
	,N'DocumentDiagnosisCodes'
	,N'Billable'
	,N'FROM DocumentDiagnosisCodes dc where dc.documentversionid = @DocumentVersionId and IsNull(dc.RecordDeleted,''N'') = ''N''  and Billable is null  '
	,N'Please specify billable'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Please specify billable'
	)
	
	
	DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 21300
	AND TabName = 'History'
	AND TabOrder = 2
	AND TableName IN (
		'CustomDocumentPsychiatricServiceNoteHistory'
		,'CustomPsychiatricServiceNoteProblems'
		)

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
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'ChiefComplaint'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(ChiefComplaint,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Soap - Chief Complaint is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Soap - Chief Complaint is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'SubjectiveAndObjective'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SubjectiveAndObjective,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Soap - Subjective and Objective for visit is required.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Soap - Subjective and Objective for visit is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'AssessmentAndPlan'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(AssessmentAndPlan,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Soap - Assessment and Plan for visit is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Soap - Assessment and Plan for visit is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'MedicalHistoryReviewedWithChanges'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(MedicalHistoryReviewedWithChanges,'''') = '''' AND ISNULL(MedicalHistoryReviewedWithChanges,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Medical History Radio Button is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'History - Medical History Radio Button is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'MedicalHistoryComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(MedicalHistoryComments,'''') = '''' AND ISNULL(MedicalHistoryReviewedWithChanges,''N'') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Medical History textbox is required.'
	,CAST(4 AS DECIMAL(18, 0))
	,N'History - Medical History textbox is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'FamilyHistoryReviewedWithChanges'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(FamilyHistoryReviewedWithChanges,'''') = '''' AND ISNULL(FamilyHistoryReviewedWithChanges,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Family History Radio Button is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'History - Family History Radio Button is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'FamilyHistoryComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(FamilyHistoryComments,'''') = '''' AND ISNULL(FamilyHistoryReviewedWithChanges,''N'') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Family History textbox is required.'
	,CAST(6 AS DECIMAL(18, 0))
	,N'History - Family History textbox is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'SocialHistoryReviewedNoChanges'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SocialHistoryReviewedWithChanges,'''') = '''' AND ISNULL(SocialHistoryReviewedWithChanges,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Social History Radio Button is required.'
	,CAST(7 AS DECIMAL(18, 0))
	,N'History - Social History Radio Button is required.'
	)
	,(
	N'Y'
	,21300
	,NULL
	,'History'
	,2
	,N'CustomDocumentPsychiatricServiceNoteHistory'
	,N'SocialHistoryComments'
	,N'FROM CustomDocumentPsychiatricServiceNoteHistory WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SocialHistoryComments,'''') = '''' AND ISNULL(SocialHistoryReviewedWithChanges,''N'') = ''Y''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Social History textbox is required.'
	,CAST(8 AS DECIMAL(18, 0))
	,N'History - Social History textbox is required.'
	)
