--Validation scripts for Task #10 Camino Customization
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       13-11-2015	    Lakshmi Kanth 	    Created                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 60000 and TableName = 'CustomDocumentPsychiatricNoteExams'

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','GeneralAppearance','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND GeneralAppearance=''A''  AND 
ISNULL(GeneralPoorlyAddresses,''N'')=''N'' And
ISNULL(GeneralPoorlyGroomed,''N'')=''N'' And
ISNULL(GeneralDisheveled,''N'')=''N'' And
ISNULL(GeneralOdferous,''N'')=''N'' And
ISNULL(GeneralDeformities,''N'')=''N'' And
ISNULL(GeneralPoorNutrion,''N'')=''N'' And
ISNULL(GeneralPsychometer,''N'')=''N'' And
ISNULL(GeneralHyperActive,''N'')=''N'' And
ISNULL(GeneralEvasive,''N'')=''N'' And
ISNULL(GeneralInAttentive,''N'')=''N'' And
ISNULL(GeneralPoorEyeContact,''N'')=''N'' And
ISNULL(GeneralHostile,''N'')=''N'' And
ISNULL(GeneralRestless,''N'')=''N'' and ISNULL(GeneralAppearanceOthers,''N'')=''N''','Mental Status Exam - General Appearance – at least one check box is required ','10','Mental Status Exam - General Appearance – at least one check box is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','Speech','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND Speech=''A''  AND 
ISNULL(SpeechIncreased,''N'')=''N'' And
ISNULL(SpeechDecreased,''N'')=''N'' And
ISNULL(SpeechPaucity,''N'')=''N'' And
ISNULL(SpeechHyperverbal,''N'')=''N'' And
ISNULL(SpeechPoorArticulations,''N'')=''N'' And
ISNULL(SpeechLoud,''N'')=''N'' And
ISNULL(SpeechSoft,''N'')=''N'' And
ISNULL(SpeechMute,''N'')=''N'' And
ISNULL(SpeechStuttering,''N'')=''N'' And
ISNULL(SpeechImpaired,''N'')=''N'' And
ISNULL(SpeechPressured,''N'')=''N'' And
ISNULL(SpeechFlight,''N'')=''N'' and ISNULL(SpeechOthers,''N'')=''N'' ','Mental Status Exam – Speech - at least one check box  is required ','11','Mental Status Exam – Speech - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','Language','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND PsychiatricNoteExamLanguage=''A''  AND 
ISNULL(LanguageDifficultyNaming,''N'')=''N'' And
ISNULL(LanguageDifficultyRepeating,''N'')=''N'' and ISNULL(LanguageOthers,''N'')=''N''','Mental Status Exam – Language - at least one check box  is required ','12','Mental Status Exam – Language - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)



INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','MoodHappy','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND MoodAndAffect=''A''  AND 
ISNULL(MoodHappy,''N'')=''N'' And
ISNULL(MoodSad,''N'')=''N'' And
ISNULL(MoodAnxious,''N'')=''N'' And
ISNULL(MoodAngry,''N'')=''N'' And
ISNULL(MoodIrritable,''N'')=''N'' And
ISNULL(MoodElation,''N'')=''N'' And
ISNULL(MoodNormal,''N'')=''N'' and ISNULL(MoodOthers,''N'')=''N''','Mental Status Exam – Mood - at least one check box  is required','13','Mental Status Exam – Mood - at least one check box  is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)

INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','AffectEuthymic','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND MoodAndAffect=''A'' AND 
ISNULL(AffectEuthymic,''N'')=''N'' And
ISNULL(AffectDysphoric,''N'')=''N'' And
ISNULL(AffectAnxious,''N'')=''N'' And
ISNULL(AffectIrritable,''N'')=''N'' And
ISNULL(AffectBlunted,''N'')=''N'' And
ISNULL(AffectLabile,''N'')=''N'' And
ISNULL(AffectEuphoric,''N'')=''N'' And
ISNULL(AffectCongruent,''N'')=''N'' and ISNULL(AffectOthers,''N'')=''N'' ','Mental Status Exam – Affect - at least one check box  is required','14','Mental Status Exam – Affect - at least one check box  is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','AttensionSpanAndConcentration','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND AttensionSpanAndConcentration=''A''  AND 
ISNULL(AttensionPoorConcentration,''N'')=''N'' And
ISNULL(AttensionDistractible,''N'')=''N'' And
ISNULL(AttensionPoorAttension,''N'')=''N'' and ISNULL(AttentionSpanOthers,''N'')=''N''','Mental Status Exam – Attension Span and Concentration - at least one check box  is required','15','Mental Status Exam – Attension Span and Concentration - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)



INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','ThoughtContentCognision','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND ThoughtContentCognision=''A''  AND 
ISNULL(TPDisOrganised,''N'')=''N'' And
ISNULL(TPBlocking,''N'')=''N'' And
ISNULL(TPPersecution,''N'')=''N'' And
ISNULL(TPBroadCasting,''N'')=''N'' And
ISNULL(TPDetrailed,''N'')=''N'' And
ISNULL(TPThoughtinsertion,''N'')=''N'' And
ISNULL(TPIncoherent,''N'')=''N'' And
ISNULL(TPRacing,''N'')=''N'' And
ISNULL(TPIllogical,''N'')=''N'' And
ISNULL(TCDelusional,''N'')=''N'' And
ISNULL(TCParanoid,''N'')=''N'' And
ISNULL(TCIdeas,''N'')=''N'' And
ISNULL(TCThoughtInsertion,''N'')=''N'' And
ISNULL(TCThoughtWithdrawal,''N'')=''N'' And
ISNULL(TCThoughtBroadcasting,''N'')=''N'' And
ISNULL(TCReligiosity,''N'')=''N'' And
ISNULL(TCGrandiosity,''N'')=''N'' And
ISNULL(TCPerserveration,''N'')=''N'' And
ISNULL(TCObsessions,''N'')=''N'' And
ISNULL(TCWorthlessness,''N'')=''N'' And
ISNULL(TCGuilt,''N'')=''N'' And
ISNULL(TCHopelessness,''N'')=''N'' And
ISNULL(TCHelplessness,''N'')=''N'' And
ISNULL(CAPoorKnowledget,''N'')=''N'' And
ISNULL(CAConcrete,''N'')=''N'' And
ISNULL(CAUnable,''N'')=''N'' And
ISNULL(CAPoorComputation,''N'')=''N'' And
ISNULL(TCLoneliness,''N'')=''N'' and ISNULL(ThoughtProcessOthers,''N'')=''N'' and ISNULL(ThoughtContentOthers,''N'')=''N'' and ISNULL(CognitiveAbnormalitiesOthers,''N'')=''N'' ','Mental Status Exam – Thought Content and Process; Cognition - at least one check box  is required ','16','Mental Status Exam – Thought Content and Process; Cognition - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','Associations','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND Associations=''A''  AND 
ISNULL(AssociationsLoose,''N'')=''N'' And
ISNULL(AssociationsClanging,''N'')=''N'' And
ISNULL(AssociationsCircumstantial,''N'')=''N'' And
ISNULL(AssociationsTangential,''N'')=''N'' And
ISNULL(AssociationsWordsalad,''N'')=''N'' and ISNULL(AssociationsOthers,''N'')=''N''','Mental Status Exam – Associations - at least one check box  is required ','17','Mental Status Exam – Associations - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam',2,'CustomDocumentPsychiatricNoteExams','AbnormalorPsychoticThoughts','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND PsychosisOrDisturbanceOfPerception=''P''  AND 
ISNULL(PDAuditoryHallucinations,''N'')=''N'' And
ISNULL(PDVisualHallucinations,''N'')=''N'' And
ISNULL(PDCommandHallucinations,''N'')=''N'' And
ISNULL(PDDelusions,''N'')=''N'' And
ISNULL(PDPreoccupation,''N'')=''N'' And
ISNULL(PDOlfactoryHallucinations,''N'')=''N'' And
ISNULL(PDGustatoryHallucinations,''N'')=''N'' And
ISNULL(PDTactileHallucinations,''N'')=''N'' And
ISNULL(PDSomaticHallucinations,''N'')=''N'' And
ISNULL(PDIllusions,''N'')=''N'' and ISNULL(AbnormalPsychoticOthers,''N'')=''N'' ','Mental Status Exam – Abnormal/Psychotic Thoughts - When present is selected, at least one check box  is required ','18','Mental Status Exam – Abnormal/Psychotic Thoughts - When present is selected, at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)



INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDCurrentSuicideIdeation','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDCurrentSuicideIdeation is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Current suicide ideation  is required','19','Mental Status Exam – Current suicide ideation  is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDCurrentSuicidalPlan','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDCurrentSuicidalPlan is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Current suicidal plan   is required','20','Mental Status Exam – Current suicidal plan   is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDCurrentSuicidalIntent','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDCurrentSuicidalIntent is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Current suicidal intent   is required','21','Mental Status Exam – Current suicidal intent   is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDMeanstocarry','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDMeanstocarry is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Means to carry out attempt   is required','22','Mental Status Exam – Means to carry out attempt   is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDCurrentHomicidalIdeation','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDCurrentHomicidalIdeation is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Current homicidal ideation  is required','23','Mental Status Exam – Current homicidal ideation  is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDCurrentHomicidalPlans','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDCurrentHomicidalPlans is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Current homicidal plans   is required','24','Mental Status Exam – Current homicidal plans   is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDCurrentHomicidalIntent','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDCurrentHomicidalIntent is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Current homicidal intent  is required','25','Mental Status Exam – Current homicidal intent  is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','PDMeansToCarryNew','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId AND    PDMeansToCarryNew is null AND  AbnormalorPsychoticThoughts=''A''','Mental Status Exam – Means to carry out attempt   is required','26','Mental Status Exam – Means to carry out attempt   is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','Orientation','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND Orientation=''A''  AND 
ISNULL(OrientationPerson,''N'')=''N'' And
ISNULL(OrientationPlace,''N'')=''N'' And
ISNULL(OrientationTime,''N'')=''N'' And
ISNULL(OrientationSituation,''N'')=''N''  and ISNULL(OrientationOthers,''N'')=''N''','Mental Status Exam – Orientation  - at least one check box  is required ','27','Mental Status Exam – Orientation  - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','FundOfKnowledge','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND FundOfKnowledge=''A''  AND 
ISNULL(FundOfKnowledgeCurrentEvents,''N'')=''N'' And
ISNULL(FundOfKnowledgePastHistory,''N'')=''N'' And
ISNULL(FundOfKnowledgeVocabulary,''N'')=''N''  and ISNULL(FundOfKnowledgeOthers,''N'')=''N''','Mental Status Exam – Fund of Knowledge - at least one check box  is required ','28','Mental Status Exam – Fund of Knowledge  - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','InsightAndJudgement','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND InsightAndJudgement=''A''  AND 
ISNULL(InsightAndJudgementStatus,'''')='''''
,'Mental Status Exam – Insight and Judgement - When Assessed is selected, below radio button selection is required ','29','Mental Status Exam – Insight and Judgement  - When Assessed is selected, below radio button selection is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','Memory','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND Memory=''A''  AND 
ISNULL(MemoryImmediate,'''')=''''' 
,'Mental Status Exam – Memory - Immediate radio button selection is required','30','Mental Status Exam – Memory  - Immediate radio button selection is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','MemoryRecent','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND Memory=''A''  AND 
ISNULL(MemoryRecent,'''')=''''' 
,'Mental Status Exam – Memory - Recent radio button selection is required','31','Mental Status Exam – Memory  - Recent radio button selection is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','Memory','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND Memory=''A''  AND 
ISNULL(MemoryRemote,'''')=''''' 
,'Mental Status Exam – Memory - Remote radio button selection is required','32','Mental Status Exam – Memory  - Remote radio button selection is required','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)


INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','MuscleStrengthorTone','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND MuscleStrengthorTone=''A''  AND 
ISNULL(MuscleStrengthorToneAtrophy,''N'')=''N'' And
ISNULL(MuscleStrengthorToneAbnormal,''N'')=''N'' and ISNULL(MuscleStrengthOthers,''N'')=''N''','Mental Status Exam – Muscle Strength/Tone  - at least one check box  is required ','33','Mental Status Exam – Muscle Strength/Tone  - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)



INSERT INTO [dbo].[DocumentValidations]( [Active],[DocumentCodeId],[DocumentType],[TabName],[TabOrder],[TableName],[ColumnName],[ValidationLogic],[ValidationDescription],[ValidationOrder],[ErrorMessage],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedBy],[DeletedDate],[SectionName]) 
VALUES( 'Y','60000',Null,'Exam','2','CustomDocumentPsychiatricNoteExams','GaitandStation','FROM CustomDocumentPsychiatricNoteExams WHERE DocumentVersionId=@DocumentVersionId  AND GaitandStation=''A''  AND 
ISNULL(GaitandStationRestlessness,''N'')=''N'' And
ISNULL(GaitandStationStaggered,''N'')=''N'' And
ISNULL(GaitandStationShuffling,''N'')=''N'' And
ISNULL(GaitandStationUnstable,''N'')=''N''  and ISNULL(GaitAndStationOthers,''N'')=''N''','Mental Status Exam – Gait and Station  - at least one check box  is required ','34','Mental Status Exam – Gait and Station  - at least one check box  is required ','admin',GETDATE(),'admin',GETDATE(),Null,Null,Null,Null)



