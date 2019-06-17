--Validation scripts for Task #822 in Woods - Customizations (Psychiatric Evaluation Service Note)
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       09/JAN/2015	Akwinass			Created                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 21400

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
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'IdentifyingInformation'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(IdentifyingInformation,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Identifying Information/Reason for Visit is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'History - Identifying Information/Reason for Visit is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'FamilyHistory'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(FamilyHistory,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Family History is required.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'History - Family History is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'PastPsychiatricHistory'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(PastPsychiatricHistory,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Past Psychiatric History is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'History - Past Psychiatric History is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'DevelopmentalHistory'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(DevelopmentalHistory,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Developmental History is required.'
	,CAST(4 AS DECIMAL(18, 0))
	,N'History - Developmental History is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'SubstanceAbuseHistory'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SubstanceAbuseHistory,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Substance Abuse History is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'History - Substance Abuse History is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'MedicalHistory'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(MedicalHistory,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Medical History is required.'
	,CAST(6 AS DECIMAL(18, 0))
	,N'History - Medical History is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'HistoryofPresentIllness'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(HistoryofPresentIllness,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - History of Present Illness is required.'
	,CAST(7 AS DECIMAL(18, 0))
	,N'History - History of Present Illness is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,1
	,N'CustomDocumentPsychiatricEvaluations'
	,N'HistoryofPresentIllness'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(SocialHistory,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'History - Social History is required.'
	,CAST(8 AS DECIMAL(18, 0))
	,N'History - Social History is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'AppropriatelyDressed'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(AppropriatelyDressed,''N'') = ''N'' AND ISNULL(GeneralAppearanceUnkept,''N'') = ''N'' AND ISNULL(GeneralAppearanceOther,''N'') = ''N'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - General Appearance and Manner - At least one checkbox is required.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Exam - General Appearance and Manner - At least one checkbox is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'GeneralAppearanceOtherText'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(GeneralAppearanceOther,''N'') = ''Y'' AND ISNULL(GeneralAppearanceOtherText,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - General Appearance and Manner - Other text is required.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Exam - General Appearance and Manner - Other text is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'MuscleStrengthNormal'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(MuscleStrengthNormal,''N'') = ''N'' AND ISNULL(MuscleStrengthAbnormal,''N'') = ''N'' AND ISNULL(MusculoskeletalTone,''N'') = ''N'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Musculoskeletal - At least one checkbox is required.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Exam - Musculoskeletal - At least one checkbox is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'GaitNormal'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(GaitNormal,''N'') = ''N'' AND ISNULL(GaitAbnormal,''N'') = ''N'' AND ISNULL(TicsTremorsAbnormalMovements,''N'') = ''N'' AND ISNULL(EPS,''N'') = ''N'' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Gait and Station - At least one checkbox is required.'
	,CAST(4 AS DECIMAL(18, 0))
	,N'Exam - Gait and Station - At least one checkbox is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'Suicidal'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Suicidal,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Suicidal/Homicidal - Suicidal is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Exam - Suicidal/Homicidal - Suicidal is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'Homicidal'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Homicidal,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Suicidal/Homicidal - Homicidal is required.'
	,CAST(6 AS DECIMAL(18, 0))
	,N'Exam - Suicidal/Homicidal - Homicidal is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'IndicateIdeation'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(IndicateIdeation,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Suicidal/Homicidal - Indicate ideation, active, passive, intent and plan is required.'
	,CAST(7 AS DECIMAL(18, 0))
	,N'Exam - Suicidal/Homicidal - Indicate ideation, active, passive, intent and plan is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'AppearanceBehavior'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(AppearanceBehavior,''N'') = ''Y'' AND ISNULL(AppearanceBehaviorComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Appearance and Behavior comments is required.'
	,CAST(8 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Appearance and Behavior comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'Speech'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Speech,''N'') = ''Y'' AND ISNULL(SpeechComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Speech comments is required.'
	,CAST(9 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Speech comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'ThoughtProcess'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(ThoughtProcess,''N'') = ''Y'' AND ISNULL(ThoughtProcessComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Thought Process comments is required.'
	,CAST(10 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Thought Process comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'Associations'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Associations,''N'') = ''Y'' AND ISNULL(AssociationsComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Associations comments is required.'
	,CAST(11 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Associations comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'AbnormalPsychoticThoughts'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(AbnormalPsychoticThoughts,''N'') = ''Y'' AND ISNULL(AbnormalPsychoticThoughtsComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Abnormal/Psychotic Thoughts comments is required.'
	,CAST(12 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Abnormal/Psychotic Thoughts comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'JudgmentAndInsight'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(JudgmentAndInsight,''N'') = ''Y'' AND ISNULL(JudgmentAndInsightComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Judgment and Insight comments is required.'
	,CAST(13 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Judgment and Insight comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'Orientation'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Orientation,''N'') = ''Y'' AND ISNULL(OrientationComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Orientation comments is required.'
	,CAST(14 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Orientation comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'RecentRemoteMemory'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(RecentRemoteMemory,''N'') = ''Y'' AND ISNULL(RecentRemoteMemoryComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Recent and Remote Memory comments is required.'
	,CAST(15 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Recent and Remote Memory comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'AttentionConcentration'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(AttentionConcentration,''N'') = ''Y'' AND ISNULL(AttentionConcentrationComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Attention and Concentration comments is required.'
	,CAST(16 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Attention and Concentration comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'Language'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Language,''N'') = ''Y'' AND ISNULL(LanguageCommments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Language comments is required.'
	,CAST(17 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Language comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'FundOfKnowledge'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(FundOfKnowledge,''N'') = ''Y'' AND ISNULL(FundOfKnowledgeComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Fund of Knowledge comments is required.'
	,CAST(18 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Fund of Knowledge comments is required.'
	)
	,(
	N'Y'
	,21400
	,NULL
	,'Note'
	,3
	,N'CustomDocumentPsychiatricEvaluations'
	,N'MoodAndAffect'
	,N'FROM CustomDocumentPsychiatricEvaluations WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(MoodAndAffect,''N'') = ''Y'' AND ISNULL(MoodAndAffectComments,'''') = '''' and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Exam - Psychiatric - Mood and Affect comments is required.'
	,CAST(19 AS DECIMAL(18, 0))
	,N'Exam - Psychiatric - Mood and Affect comments is required.'
	)