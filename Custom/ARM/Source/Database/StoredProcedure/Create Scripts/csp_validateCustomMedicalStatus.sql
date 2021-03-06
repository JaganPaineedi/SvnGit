/****** Object:  StoredProcedure [dbo].[csp_validateCustomMedicalStatus]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicalStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMedicalStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicalStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        PROCEDURE [dbo].[csp_validateCustomMedicalStatus]
@DocumentVersionId	Int
as


--Not validated for Riverwood

Return

/*


--Load the document data into a temporary table to prevent multiple seeks on the document table
CREATE TABLE #MedicalStatus
(
AbnormalThoughts char(2),
AbnormalThoughtsAuditory char(2),
AbnormalThoughtsBizarre char(2),
AbnormalThoughtsDelusional char(2),
AbnormalThoughtsGrandiosity char(2),
AbnormalThoughtsImpoverished char(2),
AbnormalThoughtsOthers char(2),
AbnormalThoughtsOtherText varchar(max),
AbnormalThoughtsVisual char(2),
AppetiteDecreased char(2),
AppetiteIncreased char(2),
AppetiteNormal char,
AppetiteOther char(2),
AppetiteOtherText varchar(max),
AssociationsFlight char(2),
AssociationsLoose char(2),
AssociationsNormal char,
AssociationsOther char(2),
AssociationsOtherText varchar(max),
AttentionDistracted char(2),
AttentionFollowsDirections char(2),
AttentionImpulsive char(2),
AttentionNormal char,
AttentionOther char(2),
AttentionOtherText varchar(max),
AttentionPoorImpulseControl char(2),
CreatedBy char(20),
CreatedDate datetime,
DeletedBy char(20),
DeletedDate datetime,
DocumentVersionId int,
FundofKnowledgeNormal char,
FundofKnowledgeText varchar(max),
GaitAtaxia char(2),
GaitFestinating char(2),
GaitNormal char,
GaitOther char(2),
GaitOtherText varchar(max),
GaitPropelling char(2),
GaitShuffling char(2),
GaitSteady char(2),
GaitUnsteady char(2),
GaitWeakness char(2),
GaitWideBased char(2),
JudgementDifficultyConsequenceActions char(2),
JudgementDifficultyProblemSolving char(2),
JudgementFair char(2),
JudgementGrosslyImpaired char(2),
JudgementIncreasedRisk char(2),
JudgementNormal char,
JudgementOther char(2),
JudgementOtherText varchar(max),
JudgementPoor char(2),
LanguageInappropriate char(2),
LanguageNormal char,
LanguageOther char(2),
LanguageOtherText varchar(max),
LanguageRepetitive char(2),
ModifiedBy char(20),
ModifiedDate datetime,
MoodAffectAlogia char(2),
MoodAffectAnxious char(2),
MoodAffectAppropriate char(2),
MoodAffectBroad char(2),
MoodAffectCooperative char(2),
MoodAffectEuthymic char(2),
MoodAffectFlat char(2),
MoodAffectIrritable char(2),
MoodAffectNormal char,
MoodAffectOther char(2),
MoodAffectOtherText varchar(max),
MoodAffectRestricted char(2),
MoodAffectSad char(2),
MoodAffectTearful char(2),
MuscleInvoluntaryMovement char(2),
MuscleNormal char,
MuscleOther char(2),
MuscleOtherText varchar(max),
MuscleRestlessness char(2),
MuscleTics char(2),
MuscleTremorsShaking char(2),
OrientationNormal char,
OrientationPerson char(2),
OrientationPlace char(2),
OrientationPurposeOtherText varchar(max),
OrientationTime char(2),
PainAching char(2),
PainNormal char,
PainOther char(2),
PainOtherText varchar(max),
PainStabbing char(2),
RecordDeleted char(2),
RRMemoryAbstracting char(2),
RRMemoryLongTerm char(2),
RRMemoryNormal char,
RRMemoryOrganizing char(2),
RRMemoryOther char(2),
RRMemoryOtherText varchar(max),
RRMemoryPlanning char(2),
RRMemorySequencing char(2),
RRMemoryShortTerm char(2),
RRMemoryThinking char(2),
SleepAbnormal char(2),
SleepDifficultyFalling char(2),
SleepDifficultyMaintaining char(2),
SleepHoursPerDay int,
SleepNightmares char(2),
SleepNonRestorative char(2),
SleepNormal char,
SleepOther char(2),
SleepOtherText varchar(max),
SpeechAphasic char(2),
SpeechDisorganized char(2),
SpeechIncomprehensible char(2),
SpeechNonVerbal char(2),
SpeechNormal char,
SpeechOther char(2),
SpeechOtherText varchar(max),
SpeechPressured char(2),
SpeechSlurred char(2),
ThoughtProcessCircumstantial char(2),
ThoughtProcessNormal char,
ThoughtProcessOther char(2),
ThoughtProcessOtherText varchar(max),
ThoughtProcessRacing char(2),
ThoughtProcessTangential char(2)
)
insert into #MedicalStatus
(
AbnormalThoughts ,
AbnormalThoughtsAuditory ,
AbnormalThoughtsBizarre ,
AbnormalThoughtsDelusional ,
AbnormalThoughtsGrandiosity ,
AbnormalThoughtsImpoverished ,
AbnormalThoughtsOthers ,
AbnormalThoughtsOtherText ,
AbnormalThoughtsVisual ,
AppetiteDecreased ,
AppetiteIncreased ,
AppetiteNormal ,
AppetiteOther ,
AppetiteOtherText ,
AssociationsFlight ,
AssociationsLoose ,
AssociationsNormal ,
AssociationsOther ,
AssociationsOtherText ,
AttentionDistracted ,
AttentionFollowsDirections ,
AttentionImpulsive ,
AttentionNormal ,
AttentionOther ,
AttentionOtherText ,
AttentionPoorImpulseControl ,
CreatedBy ,
CreatedDate ,
DeletedBy ,
DeletedDate ,
DocumentVersionId ,
FundofKnowledgeNormal ,
FundofKnowledgeText ,
GaitAtaxia ,
GaitFestinating ,
GaitNormal ,
GaitOther ,
GaitOtherText ,
GaitPropelling ,
GaitShuffling ,
GaitSteady ,
GaitUnsteady ,
GaitWeakness ,
GaitWideBased ,
JudgementDifficultyConsequenceActions ,
JudgementDifficultyProblemSolving ,
JudgementFair ,
JudgementGrosslyImpaired ,
JudgementIncreasedRisk ,
JudgementNormal ,
JudgementOther ,
JudgementOtherText ,
JudgementPoor ,
LanguageInappropriate ,
LanguageNormal ,
LanguageOther ,
LanguageOtherText ,
LanguageRepetitive ,
ModifiedBy ,
ModifiedDate ,
MoodAffectAlogia ,
MoodAffectAnxious ,
MoodAffectAppropriate ,
MoodAffectBroad ,
MoodAffectCooperative ,
MoodAffectEuthymic ,
MoodAffectFlat ,
MoodAffectIrritable ,
MoodAffectNormal ,
MoodAffectOther ,
MoodAffectOtherText ,
MoodAffectRestricted ,
MoodAffectSad ,
MoodAffectTearful ,
MuscleInvoluntaryMovement ,
MuscleNormal ,
MuscleOther ,
MuscleOtherText ,
MuscleRestlessness ,
MuscleTics ,
MuscleTremorsShaking ,
OrientationNormal ,
OrientationPerson ,
OrientationPlace ,
OrientationPurposeOtherText ,
OrientationTime ,
PainAching ,
PainNormal ,
PainOther ,
PainOtherText ,
PainStabbing ,
RecordDeleted ,
RRMemoryAbstracting ,
RRMemoryLongTerm ,
RRMemoryNormal ,
RRMemoryOrganizing ,
RRMemoryOther ,
RRMemoryOtherText ,
RRMemoryPlanning ,
RRMemorySequencing ,
RRMemoryShortTerm ,
RRMemoryThinking ,
SleepAbnormal ,
SleepDifficultyFalling ,
SleepDifficultyMaintaining ,
SleepHoursPerDay ,
SleepNightmares ,
SleepNonRestorative ,
SleepNormal ,
SleepOther ,
SleepOtherText ,
SpeechAphasic ,
SpeechDisorganized ,
SpeechIncomprehensible ,
SpeechNonVerbal ,
SpeechNormal ,
SpeechOther ,
SpeechOtherText ,
SpeechPressured ,
SpeechSlurred ,
ThoughtProcessCircumstantial ,
ThoughtProcessNormal ,
ThoughtProcessOther ,
ThoughtProcessOtherText ,
ThoughtProcessRacing ,
ThoughtProcessTangential 
)

select
a.AbnormalThoughts ,
a.AbnormalThoughtsAuditory ,
a.AbnormalThoughtsBizarre ,
a.AbnormalThoughtsDelusional ,
a.AbnormalThoughtsGrandiosity ,
a.AbnormalThoughtsImpoverished ,
a.AbnormalThoughtsOthers ,
a.AbnormalThoughtsOtherText ,
a.AbnormalThoughtsVisual ,
a.AppetiteDecreased ,
a.AppetiteIncreased ,
a.AppetiteNormal ,
a.AppetiteOther ,
a.AppetiteOtherText ,
a.AssociationsFlight ,
a.AssociationsLoose ,
a.AssociationsNormal ,
a.AssociationsOther ,
a.AssociationsOtherText ,
a.AttentionDistracted ,
a.AttentionFollowsDirections ,
a.AttentionImpulsive ,
a.AttentionNormal ,
a.AttentionOther ,
a.AttentionOtherText ,
a.AttentionPoorImpulseControl ,
a.CreatedBy ,
a.CreatedDate ,
a.DeletedBy ,
a.DeletedDate ,
a.DocumentVersionId ,
a.FundofKnowledgeNormal ,
a.FundofKnowledgeText ,
a.GaitAtaxia ,
a.GaitFestinating ,
a.GaitNormal ,
a.GaitOther ,
a.GaitOtherText ,
a.GaitPropelling ,
a.GaitShuffling ,
a.GaitSteady ,
a.GaitUnsteady ,
a.GaitWeakness ,
a.GaitWideBased ,
a.JudgementDifficultyConsequenceActions ,
a.JudgementDifficultyProblemSolving ,
a.JudgementFair ,
a.JudgementGrosslyImpaired ,
a.JudgementIncreasedRisk ,
a.JudgementNormal ,
a.JudgementOther ,
a.JudgementOtherText ,
a.JudgementPoor ,
a.LanguageInappropriate ,
a.LanguageNormal ,
a.LanguageOther ,
a.LanguageOtherText ,
a.LanguageRepetitive ,
a.ModifiedBy ,
a.ModifiedDate ,
a.MoodAffectAlogia ,
a.MoodAffectAnxious ,
a.MoodAffectAppropriate ,
a.MoodAffectBroad ,
a.MoodAffectCooperative ,
a.MoodAffectEuthymic ,
a.MoodAffectFlat ,
a.MoodAffectIrritable ,
a.MoodAffectNormal ,
a.MoodAffectOther ,
a.MoodAffectOtherText ,
a.MoodAffectRestricted ,
a.MoodAffectSad ,
a.MoodAffectTearful ,
a.MuscleInvoluntaryMovement ,
a.MuscleNormal ,
a.MuscleOther ,
a.MuscleOtherText ,
a.MuscleRestlessness ,
a.MuscleTics ,
a.MuscleTremorsShaking ,
a.OrientationNormal ,
a.OrientationPerson ,
a.OrientationPlace ,
a.OrientationPurposeOtherText ,
a.OrientationTime ,
a.PainAching ,
a.PainNormal ,
a.PainOther ,
a.PainOtherText ,
a.PainStabbing ,
a.RecordDeleted ,
a.RRMemoryAbstracting ,
a.RRMemoryLongTerm ,
a.RRMemoryNormal ,
a.RRMemoryOrganizing ,
a.RRMemoryOther ,
a.RRMemoryOtherText ,
a.RRMemoryPlanning ,
a.RRMemorySequencing ,
a.RRMemoryShortTerm ,
a.RRMemoryThinking ,
a.SleepAbnormal ,
a.SleepDifficultyFalling ,
a.SleepDifficultyMaintaining ,
a.SleepHoursPerDay ,
a.SleepNightmares ,
a.SleepNonRestorative ,
a.SleepNormal ,
a.SleepOther ,
a.SleepOtherText ,
a.SpeechAphasic ,
a.SpeechDisorganized ,
a.SpeechIncomprehensible ,
a.SpeechNonVerbal ,
a.SpeechNormal ,
a.SpeechOther ,
a.SpeechOtherText ,
a.SpeechPressured ,
a.SpeechSlurred ,
a.ThoughtProcessCircumstantial ,
a.ThoughtProcessNormal ,
a.ThoughtProcessOther ,
a.ThoughtProcessOtherText ,
a.ThoughtProcessRacing ,
a.ThoughtProcessTangential 
from CustomMedicalStatus a
where a.DocumentVersionId = @DocumentVersionId

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage



SELECT ''CustomMedicalStatus'', ''MuscleOtherText'', ''Medical Status - Muscle other detail must be specified.''
FROM #MedicalStatus
WHERE MuscleOther = ''Y''
and isnull(MuscleOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''GaitOtherText'', ''Medical Status - Gait other detail must be specified.''
FROM #MedicalStatus
WHERE GaitOther = ''Y''
and isnull(GaitOtherText,'''')=''''


UNION
SELECT ''CustomMedicalStatus'', ''SpeechOtherText'', ''Medical Status - Speech other detail must be specified.''
FROM #MedicalStatus
WHERE SpeechOther = ''Y''
and isnull(SpeechOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''PainOtherText'', ''Medical Status - Pain other detail must be specified.''
FROM #MedicalStatus
WHERE PainOther = ''Y''
and isnull(PainOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''ThoughtProcessOtherText'', ''Medical Status - Thought Processing other detail must be specified.''
FROM #MedicalStatus
WHERE ThoughtProcessOther = ''Y''
and isnull(ThoughtProcessOtherText,'''')=''''


UNION
SELECT ''CustomMedicalStatus'', ''AssociationsOtherText'', ''Medical Status - Associations other detail must be specified.''
FROM #MedicalStatus
WHERE AssociationsOther = ''Y''
and isnull(AssociationsOtherText,'''')=''''


UNION
SELECT ''CustomMedicalStatus'', ''JudgementOtherText'', ''Medical Status - Judgement other detail must be specified.''
FROM #MedicalStatus
WHERE JudgementOther = ''Y''
and isnull(JudgementOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''AbnormalThoughtsOtherText'', ''Medical Status - Abnormal Thoughts detail must be specified.''
FROM #MedicalStatus
WHERE AbnormalThoughts = ''Y''
and isnull(AbnormalThoughtsOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''FundOfKnowledgeText'', ''Medical Status - Fund of Knowledge detail must be specified.''
FROM #MedicalStatus
WHERE FundOfKnowledgeNormal = ''A''
and isnull(FundOfKnowledgeText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''RRMemoryOtherText'', ''Medical Status - Memory other detail must be specified.''
FROM #MedicalStatus
WHERE RRMemoryOther = ''Y''
and isnull(RRMemoryOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''AttentionOtherText'', ''Medical Status - Attention detail must be specified.''
FROM #MedicalStatus
WHERE AttentionOther = ''Y''
and isnull(AttentionOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''LanguageOtherText'', ''Medical Status - Language other detail must be specified.''
FROM #MedicalStatus
WHERE LanguageOther = ''Y''
and isnull(LanguageOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''MoodAffectOtherText'', ''Medical Status - Mood / Affect other detail must be specified.''
FROM #MedicalStatus
WHERE MoodAffectOther = ''Y''
and isnull(MoodAffectOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''SleepOtherText'', ''Medical Status - Sleep other detail must be specified.''
FROM #MedicalStatus
WHERE SleepOther = ''Y''
and isnull(SleepOtherText,'''')=''''

UNION
SELECT ''CustomMedicalStatus'', ''AppetiteOtherText'', ''Medical Status - Appetite other detail must be specified.''
FROM #MedicalStatus
WHERE AppetiteOther = ''Y''
and isnull(AppetiteOtherText,'''')=''''


UNION 
SELECT ''CustomMedicalStatus'', ''DeletedBy'', ''Medical Status selection must be specified.''
FROM #MedicalStatus
WHERE isnull(MuscleNormal, '''') = ''''
OR isnull(GaitNormal, '''') = ''''
OR isnull(SpeechNormal, '''') = ''''
OR isnull(PainNormal, '''') = ''''
OR isnull(ThoughtProcessNormal, '''') = ''''
OR isnull(AssociationsNormal, '''') = ''''
OR isnull(JudgementNormal, '''') = ''''
OR isnull(AbnormalThoughts, '''') = ''''
OR isnull(OrientationNormal, '''') = ''''
OR isnull(FundofKnowledgeNormal, '''') = ''''
OR isnull(RRMemoryNormal, '''') = ''''
OR isnull(AttentionNormal, '''') = ''''
OR isnull(LanguageNormal, '''') = ''''
OR isnull(MoodAffectNormal, '''') = ''''
OR isnull(SleepNormal, '''') = ''''
OR isnull(AppetiteNormal, '''') = ''''

UNION
SELECT ''CustomMedicalStatus'', ''RecordDeleted'', ''Please select proper "99" Procedure Code on Service Tab.''
FROM #MedicalStatus m
join documents d on d.CurrentDocumentVersionId = m.DocumentVersionId
join services sr on sr.serviceid = d.serviceid
join staff s on s.staffid = d.authorid
where sr.procedurecodeid in (319, 714, 747)
and isnull(d.recorddeleted, ''N'') = ''N''
and isnull(sr.recorddeleted, ''N'') = ''N''
and isnull(s.recorddeleted, ''N'') = ''N''








if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomMedicalStatus failed.  Contact your system administrator.''


*/
' 
END
GO
