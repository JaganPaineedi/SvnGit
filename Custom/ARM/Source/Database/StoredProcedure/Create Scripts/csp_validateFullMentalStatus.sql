/****** Object:  StoredProcedure [dbo].[csp_validateFullMentalStatus]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateFullMentalStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateFullMentalStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateFullMentalStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        PROCEDURE [dbo].[csp_validateFullMentalStatus]
@DocumentVersionId	Int--,@documentCodeId INT
as


DECLARE @DocumentCodeId int
SET @DocumentCodeID = (Select DocumentCodeId From Documents Where CurrentDocumentVersionId=@DocumentVersionId)


CREATE TABLE #MentalStatus
(AffectAngry char(2),
AffectBlunted char(2),
AffectCongruent char(2),
AffectExpansive char(2),
AffectFearful char(2),
AffectFlat char(2),
AffectIrritable char(2),
AffectMood char(2),
AffectOther char(2),
AffectOtherText varchar(max),
AffectRestricted char(2),
AffectSad char(2),
AffectUnableToAssess char(2),
AffectUnremarkable char(2),
AppearanceAge char(2),
AppearanceAverageHeight char(2),
AppearanceAverageWeight char(2),
AppearanceDressed char(2),
AppearanceGroomed char(2),
AppearanceHygiene char(2),
AppearanceOtherText varchar(max),
ApprearanceOther char(2),
AttentionAppropriate char(2),
AttentionGood char(2),
AttentionImpaired char(2),
AttentionOther char(2),
AttentionOtherText varchar(max),
AttitudeCooperative char(2),
AttitudeDefensive char(2),
AttitudeMistrustful char(2),
AttitudeOther char(2),
AttitudeOtherText varchar(max),
AttitudeReserved char(2),
BehaviorActivity char(2),
BehaviorAggressive char(2),
BehaviorAgitated char(2),
BehaviorEyeContact char(2),
BehaviorGait char(2),
BehaviorLethargic char(2),
BehaviorNormalActivity char(2),
BehaviorOther char(2),
BehaviorOtherText varchar(max),
BehaviorTics char(2),
BehaviorTremors char(2),
BehaviorTwitches char(2),
CognitionLimited char(2),
CognitionNormal char(2),
CognitionObsessions char(2),
CognitionOther char(2),
CognitionOtherText varchar(max),
CognitionPhobias char(2),
CognitionPreoccupation char(2),
CreatedBy char(20),
CreatedDate datetime,
DeletedBy char(20),
DeletedDate datetime,
DisturbanceAuditory char(2),
DisturbanceDelusions char(2),
DisturbanceDepersonalization char(2),
DisturbanceDerealization char(2),
DisturbanceIdeas char(2),
DisturbanceNoneNoted char(2),
DisturbanceOlfactory char(2),
DisturbanceOther char(2),
DisturbanceOtherText varchar(max),
DisturbanceParanoia char(2),
DisturbanceTactile char(2),
DisturbanceVisual char(2),
DocumentVersionId int,
JudgementAware char(2),
JudgementImpaired char(2),
JudgementImpairedText varchar(max),
JudgementIntact char(2),
JudgementOther char(2),
JudgementOtherText varchar(max),
JudgementRiskyBehavior char(2),
JudgementUnderstandsNeed char(2),
JudgementUnderstandsOutcomes char(2),
LevelAlert char(2),
LevelLethargic char(2),
LevelObtuned char(2),
LevelOther char(2),
LevelOtherText varchar(max),
LevelSedate char(2),
MemoryIntact char(2),
MemoryLongTerm char(2),
MemoryOther char(2),
MemoryOtherText varchar(max),
MemoryShortTerm char(2),
ModifiedBy char(20),
ModifiedDate char(20),
MoodAnxious char(2),
MoodAppropriate char(2),
MoodFearful char(2),
MoodFriendly char(2),
MoodGuilty char(2),
MoodIncongruent char(2),
MoodIrritable char(2),
MoodLabile char(2),
MoodNeutral char(2),
MoodOtherMoods char(2),
MoodOtherMoodsText varchar(max),
MoodSad char(2),
MoodTearful char(2),
OrientationCircumstance char(2),
OrientationPerson char(2),
OrientationPlace char(2),
OrientationText varchar(max),
OrientationTime char(2),
OtherEating char(2),
OtherEatingText varchar(max),
OtherNotMedication char(2),
OtherPx char(2),
OtherSleep char(2),
OtherSleepText varchar(max),
PerceptualAuditory char(2),
PerceptualDelusions char(2),
PerceptualDepersonalization char(2),
PerceptualIdeas char(2),
PerceptualNo char(2),
PerceptualOlfactory char(2),
PerceptualOther char(2),
PerceptualOtherText varchar(max),
PerceptualParanoia char(2),
PerceptualTactile char(2),
PerceptualVisual char(2),
RecordDeleted char(2),
RiskHomicideActive char(2),
RiskHomicideAttempt char(2),
RiskHomicideIdeation char(2),
RiskHomicideMeans char(2),
RiskHomicideNotPresent char(2),
RiskHomicidePassive char(2),
RiskHomicidePlan char(2),
RiskHomicideTxPlan char(2),
RiskIntervention varchar(max),
RiskOther varchar(max),
RiskSuicideActive char(2),
RiskSuicideAttempt char(2),
RiskSuicideIdeation char(2),
RiskSuicideMeans char(2),
RiskSuicideNotPresent char(2),
RiskSuicidePassive char(2),
RiskSuicidePlan char(2),
RiskSuicideTxPlan char(2),
SpeechClear char(2),
SpeechCoherent char(2),
SpeechEcholalia char(2),
SpeechMonotonous char(2),
SpeechOther char(2),
SpeechOtherText varchar(max),
SpeechPressured char(2),
SpeechRepetitive char(2),
SpeechSlurred char(2),
SpeechSpeed char(2),
SpeechSpontaneous char(2),
SpeechTalkative char(2),
SpeechVerbal char(2),
SpeechVolume char(2),
ThoughtConfused char(2),
ThoughtDelusional char(2),
ThoughtImpoverished char(2),
ThoughtLoose char(2),
ThoughtLucid char(2),
ThoughtObsessive char(2),
ThoughtObsessiveText varchar(max),
ThoughtParanoid char(2),
ThoughtPsychosis char(2),
ThoughtTangential char(2),
ThoughtGrandiose char(2),
UnableToAssess char(2),
ThoughtDisorganized char(2),
ThoughtFlightOfIdeas char(2),
ThoughtBizarre char(2),
BehaviorCompulsive char(2),
BehaviorPeculiar char(2),
BehaviorManipulative char(2))

INSERT INTO #MentalStatus
Select 
a.AffectAngry,
a.AffectBlunted,
a.AffectCongruent,
a.AffectExpansive,
a.AffectFearful,
a.AffectFlat,
a.AffectIrritable,
a.AffectMood,
a.AffectOther,
a.AffectOtherText,
a.AffectRestricted,
a.AffectSad,
a.AffectUnableToAssess,
a.AffectUnremarkable,
a.AppearanceAge,
a.AppearanceAverageHeight,
a.AppearanceAverageWeight,
a.AppearanceDressed,
a.AppearanceGroomed,
a.AppearanceHygiene,
a.AppearanceOtherText,
a.ApprearanceOther,
a.AttentionAppropriate,
a.AttentionGood,
a.AttentionImpaired,
a.AttentionOther,
a.AttentionOtherText,
a.AttitudeCooperative,
a.AttitudeDefensive,
a.AttitudeMistrustful,
a.AttitudeOther,
a.AttitudeOtherText,
a.AttitudeReserved,
a.BehaviorActivity,
a.BehaviorAggressive,
a.BehaviorAgitated,
a.BehaviorEyeContact,
a.BehaviorGait,
a.BehaviorLethargic,
a.BehaviorNormalActivity,
a.BehaviorOther,
a.BehaviorOtherText,
a.BehaviorTics,
a.BehaviorTremors,
a.BehaviorTwitches,
a.CognitionLimited,
a.CognitionNormal,
a.CognitionObsessions,
a.CognitionOther,
a.CognitionOtherText,
a.CognitionPhobias,
a.CognitionPreoccupation,
a.CreatedBy,
a.CreatedDate,
a.DeletedBy,
a.DeletedDate,
a.DisturbanceAuditory,
a.DisturbanceDelusions,
a.DisturbanceDepersonalization,
a.DisturbanceDerealization,
a.DisturbanceIdeas,
a.DisturbanceNoneNoted,
a.DisturbanceOlfactory,
a.DisturbanceOther,
a.DisturbanceOtherText,
a.DisturbanceParanoia,
a.DisturbanceTactile,
a.DisturbanceVisual,
a.DocumentVersionId,
a.JudgementAware,
a.JudgementImpaired,
a.JudgementImpairedText,
a.JudgementIntact,
a.JudgementOther,
a.JudgementOtherText,
a.JudgementRiskyBehavior,
a.JudgementUnderstandsNeed,
a.JudgementUnderstandsOutcomes,
a.LevelAlert,
a.LevelLethargic,
a.LevelObtuned,
a.LevelOther,
a.LevelOtherText,
a.LevelSedate,
a.MemoryIntact,
a.MemoryLongTerm,
a.MemoryOther,
a.MemoryOtherText,
a.MemoryShortTerm,
a.ModifiedBy,
a.ModifiedDate,
a.MoodAnxious,
a.MoodAppropriate,
a.MoodFearful,
a.MoodFriendly,
a.MoodGuilty,
a.MoodIncongruent,
a.MoodIrritable,
a.MoodLabile,
a.MoodNeutral,
a.MoodOtherMoods,
a.MoodOtherMoodsText,
a.MoodSad,
a.MoodTearful,
a.OrientationCircumstance,
a.OrientationPerson,
a.OrientationPlace,
a.OrientationText,
a.OrientationTime,
a.OtherEating,
a.OtherEatingText,
a.OtherNotMedication,
a.OtherPx,
a.OtherSleep,
a.OtherSleepText,
a.PerceptualAuditory,
a.PerceptualDelusions,
a.PerceptualDepersonalization,
a.PerceptualIdeas,
a.PerceptualNo,
a.PerceptualOlfactory,
a.PerceptualOther,
a.PerceptualOtherText,
a.PerceptualParanoia,
a.PerceptualTactile,
a.PerceptualVisual,
a.RecordDeleted,
a.RiskHomicideActive,
a.RiskHomicideAttempt,
a.RiskHomicideIdeation,
a.RiskHomicideMeans,
a.RiskHomicideNotPresent,
a.RiskHomicidePassive,
a.RiskHomicidePlan,
a.RiskHomicideTxPlan,
a.RiskIntervention,
a.RiskOther,
a.RiskSuicideActive,
a.RiskSuicideAttempt,
a.RiskSuicideIdeation,
a.RiskSuicideMeans,
a.RiskSuicideNotPresent,
a.RiskSuicidePassive,
a.RiskSuicidePlan,
a.RiskSuicideTxPlan,
a.SpeechClear,
a.SpeechCoherent,
a.SpeechEcholalia,
a.SpeechMonotonous,
a.SpeechOther,
a.SpeechOtherText,
a.SpeechPressured,
a.SpeechRepetitive,
a.SpeechSlurred,
a.SpeechSpeed,
a.SpeechSpontaneous,
a.SpeechTalkative,
a.SpeechVerbal,
a.SpeechVolume,
a.ThoughtConfused,
a.ThoughtDelusional,
a.ThoughtImpoverished,
a.ThoughtLoose,
a.ThoughtLucid,
a.ThoughtObsessive,
a.ThoughtObsessiveText,
a.ThoughtParanoid,
a.ThoughtPsychosis,
a.ThoughtTangential,
a.ThoughtGrandiose,
a.UnableToAssess,
a.ThoughtDisorganized,
a.ThoughtFlightOfIdeas ,
a.ThoughtBizarre ,
a.BehaviorCompulsive ,
a.BehaviorPeculiar,
a.BehaviorManipulative
FROM MentalStatus a
where a.DocumentVersionId = @DocumentVersionId

/*
CREATE TABLE #validationReturnTable
	(TableName varchar(200),
	ColumnName varchar(200),
	ErrorMessage varchar(200)
	)
*/
-- Riverwood - If client is DD, do not require entry of the following:
-- speech
-- behavior
-- mood

declare @ClientIsDD char(1)
set @ClientIsDD = ''N''

select @ClientIsDD = ''Y''
from Documents as d
join ClientPrograms as cp on (cp.ClientId = d.ClientId) and isnull(cp.RecordDeleted, ''N'') <> ''Y''
where d.CurrentDocumentVersionId = @DocumentVersionId
and cp.ProgramId in (4, 18)  -- (DD, child-DD)
and cp.status = 4	-- enrolled


/******************************************************************/

-- Crisis Document Mental Status


/****************************************************************/
IF @documentcodeid in (116, 119, 122)
 BEGIN

	Insert into #validationReturnTable
	(TableName,
	ColumnName,
	ErrorMessage
	)
	


	 SELECT ''MentalStatus'', ''AppearanceDressed'', ''Mental Status - Appearance selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and AppearanceDressed is null
		and AppearanceAge is null
		and AppearanceAverageWeight is null
		and AppearanceAverageHeight is null
		and AppearanceGroomed is null
		and AppearanceHygiene is null
		and isnull(ApprearanceOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AppearanceOtherText), ''N'') = ''N''
	 
	 UNION
	 SELECT ''MentalStatus'', ''AppearanceOtherText'', ''Mental Status - Appearance Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ApprearanceOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AppearanceOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Behavior must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		-- TER change for Riverwood
		and (@ClientIsDD <> ''Y'')
		and (BehaviorGait is null
		or BehaviorEyeContact is null
		or BehaviorNormalActivity is null) 

/*		and isnull(BehaviorTics, ''N'') = ''N''
		and isnull(BehaviorTremors, ''N'') = ''N''
		and isnull(BehaviorTwitches, ''N'') = ''N''
		and isnull(BehaviorAgitated, ''N'') = ''N''
		and isnull(BehaviorLethargic, ''N'') = ''N''
		and isnull(BehaviorAggressive, ''N'') = ''N''
		and isnull(BehaviorNormalActivity, ''N'') = ''N''
*/
	
	 UNION
	 SELECT ''MentalStatus'', ''BehaviorOtherText'', ''Mental Status - Behavior Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(BehaviorOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), BehaviorOtherText), ''N'') = ''N''
		
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AttitudeCooperative'', ''Mental Status - Attitude selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and AttitudeCooperative is null
/*		and isnull(AttitudeDefensive, ''N'') = ''N''
		and isnull(AttitudeReserved, ''N'') = ''N''
		and isnull(AttitudeMistrustful, ''N'') = ''N''
		and isnull(AttitudeOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AttitudeOtherText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''AttitudeOtherText'', ''Mental Status - Attitude Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AttitudeOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AttitudeOtherText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AffectBlunted'', ''Mental Status - Affect selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectBlunted, ''N'') = ''N''
		and isnull(AffectCongruent, ''N'') = ''N''
		and isnull(AffectUnremarkable, ''N'') = ''N''
		and isnull(AffectUnableToAssess, ''N'') = ''N''
		and isnull(AffectFlat, ''N'') = ''N''
		and isnull(AffectRestricted, ''N'') = ''N''
		and isnull(AffectExpansive, ''N'') = ''N''
		and isnull(AffectAngry, ''N'') = ''N''
		and isnull(AffectSad, ''N'') = ''N''
		and isnull(AffectIrritable, ''N'') = ''N''
		and isnull(AffectFearful, ''N'') = ''N''
		and isnull(AffectMood, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AffectOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AffectOtherText'', ''Mental Status - Affect Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AffectOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Speech selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		-- TER change for Riverwood
		and (@ClientIsDD <> ''Y'')
		and (SpeechCoherent is null
		or SpeechSpeed is null
		or SpeechVerbal is null
		or SpeechVolume is null)
/*
		and isnull(SpeechClear, ''N'') = ''N''
		and isnull(SpeechVolume, ''N'') = ''N''
		and isnull(SpeechPressured, ''N'') = ''N''
		and isnull(SpeechRepetitive, ''N'') = ''N''
		and isnull(SpeechSpontaneous, ''N'') = ''N''
		and isnull(SpeechSlurred, ''N'') = ''N''
		and isnull(SpeechMonotonous, ''N'') = ''N''
		and isnull(SpeechTalkative, ''N'') = ''N''
		and isnull(SpeechEcholalia, ''N'') = ''N''
		and isnull(SpeechOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), SpeechOtherText), ''N'') = ''N''
*/		
	 UNION
	 SELECT ''MentalStatus'', ''SpeechOtherText'', ''Mental Status - Speech Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(SpeechOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), SpeechOtherText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''ThoughtLucid'', ''Mental Status - Thought selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtLucid, ''N'') = ''N''
		and isnull(ThoughtParanoid, ''N'') = ''N''
		and isnull(ThoughtDelusional, ''N'') = ''N''
		and isnull(ThoughtTangential, ''N'') = ''N''
		and isnull(ThoughtLoose, ''N'') = ''N''
		and isnull(ThoughtPsychosis, ''N'') = ''N''
		and isnull(ThoughtImpoverished, ''N'') = ''N''
		and isnull(ThoughtConfused, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''N''
		and isnull(ThoughtGrandiose, ''N'')= ''N''
		and isnull(ThoughtDisorganized, ''N'')= ''N''
		and isnull(ThoughtFlightOfIdeas, ''N'')= ''N''
		and isnull(ThoughtBizarre, ''N'')= ''N'' 
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''ThoughtObsessiveText'', ''Mental Status - Obsessive details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Mood selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (MoodNeutral is null
		or MoodFriendly is null) 
	-- TER change for Riverwood
	and (@ClientIsDD <> ''Y'')
/*
		and isnull(MoodLabile, ''N'') = ''N''
		and isnull(MoodAnxious, ''N'') = ''N''
		and isnull(MoodGuilty, ''N'') = ''N''
		and isnull(MoodIrritable, ''N'') = ''N''
		and isnull(MoodFearful, ''N'') = ''N''
		and isnull(MoodSad, ''N'') = ''N''
		and isnull(MoodTearful, ''N'') = ''N''
		and isnull(MoodAppropriate, ''N'') = ''N''
		and isnull(MoodIncongruent, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''N''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''MoodOtherMoodsText'', ''Mental Status - Mood Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''CognitionNormal'', ''Mental Status - Cognitioin selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(CognitionNormal, ''N'') = ''N''
		and isnull(CognitionLimited, ''N'') = ''N''
		and isnull(CognitionPhobias, ''N'') = ''N''
		and isnull(CognitionObsessions, ''N'') = ''N''
		and isnull(CognitionPreoccupation, ''N'') = ''N''
		and isnull(CognitionOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), CognitionOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''CognitionOtherText'', ''Mental Status - Cognition Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(CognitionOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), CognitionOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AttentionAppropriate'', ''Mental Status - Attention selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AttentionAppropriate, ''N'') = ''N''
		and isnull(AttentionGood, ''N'') = ''N''
		and isnull(AttentionImpaired, ''N'') = ''N''
		and isnull(AttentionOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AttentionOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AttentionOtherText'', ''Mental Status - Attention Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AttentionOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AttentionOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''LevelAlert'', ''Mental Status - Level of Consciousness selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(LevelAlert, ''N'') = ''N''
		and isnull(LevelSedate, ''N'') = ''N''
		and isnull(LevelLethargic, ''N'') = ''N''
		and isnull(LevelObtuned, ''N'') = ''N''
		and isnull(LevelOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), LevelOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''LevelOtherText'', ''Mental Status - Level of Consciousness Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(LevelOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), LevelOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''MemoryIntact'', ''Mental Status - Memory selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MemoryIntact, ''N'') = ''N''
		and isnull(MemoryShortTerm, ''N'') = ''N''
		and isnull(MemoryLongTerm, ''N'') = ''N''
		and isnull(MemoryOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), MemoryOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''MemoryOtherText'', ''Mental Status - Memory Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MemoryOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), MemoryOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Judgement selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (JudgementAware is null
		or JudgementUnderstandsOutcomes is null
		or JudgementUnderstandsNeed is null)
/*		and isnull(JudgementRiskyBehavior, ''N'') = ''N''
		and isnull(JudgementIntact, ''N'') = ''N''
		and isnull(JudgementImpaired, ''N'') = ''N''
		and isnull(convert(Varchar(2000), JudgementImpairedText), ''N'') = ''N''
		and isnull(JudgementOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), JudgementOtherText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''JudgementOtherText'', ''Mental Status - Judgement Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(JudgementOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), JudgementOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''OrientationText'', ''Mental Status - Oreintation selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(OrientationPerson, ''N'') = ''N''
		and isnull(OrientationPlace, ''N'') = ''N''
		and isnull(OrientationTime, ''N'') = ''N''
		and isnull(OrientationCircumstance, ''N'') = ''N''
		and isnull(convert(Varchar(2000), OrientationText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DisturbanceNoneNoted'', ''Mental Status - Perceptual Disturbance selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(DisturbanceNoneNoted, ''N'') = ''N''
		and isnull(DisturbanceDelusions, ''N'') = ''N''
		and isnull(DisturbanceAuditory, ''N'') = ''N''
		and isnull(DisturbanceVisual, ''N'') = ''N''
		and isnull(DisturbanceOlfactory, ''N'') = ''N''
		and isnull(DisturbanceTactile, ''N'') = ''N''
		and isnull(DisturbanceDepersonalization, ''N'') = ''N''
		and isnull(DisturbanceDerealization, ''N'') = ''N''
		and isnull(DisturbanceIdeas, ''N'') = ''N''
		and isnull(DisturbanceParanoia, ''N'') = ''N''
		and isnull(DisturbanceOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), DisturbanceOtherText), ''N'') = ''N''
	 UNION
	 SELECT ''MentalStatus'', ''DisturbanceOtherText'', ''Mental Status - Perceptual Disturbance Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(DisturbanceOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), DisturbanceOtherText), ''N'') = ''N''
	
 END
	
if @@error <> 0 goto error




/****************************************************************/
-- ASSESSMENT VALIDATION



/****************************************************************/
IF @documentcodeid in (101)
 BEGIN
	Insert into #validationReturnTable
	(TableName,
	ColumnName,
	ErrorMessage
	)
	
	 SELECT ''MentalStatus'', ''AppearanceDressed'', ''Mental Status - Appearance selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and AppearanceDressed is null
		and AppearanceAge is null
		and AppearanceAverageWeight is null
		and AppearanceAverageHeight is null
		and AppearanceGroomed is null
		and AppearanceHygiene is null
		and isnull(ApprearanceOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AppearanceOtherText), ''N'') = ''N''
	 
	 UNION
	 SELECT ''MentalStatus'', ''AppearanceOtherText'', ''Mental Status - Appearance Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ApprearanceOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AppearanceOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Behavior must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		-- TER change for Riverwood
		and (@ClientIsDD <> ''Y'')
		and (BehaviorGait is null
		or BehaviorEyeContact is null
		or BehaviorNormalActivity is null) 

/*		and isnull(BehaviorTics, ''N'') = ''N''
		and isnull(BehaviorTremors, ''N'') = ''N''
		and isnull(BehaviorTwitches, ''N'') = ''N''
		and isnull(BehaviorAgitated, ''N'') = ''N''
		and isnull(BehaviorLethargic, ''N'') = ''N''
		and isnull(BehaviorAggressive, ''N'') = ''N''
		and isnull(BehaviorNormalActivity, ''N'') = ''N''
*/
	
	 UNION
	 SELECT ''MentalStatus'', ''BehaviorOtherText'', ''Mental Status - Behavior Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(BehaviorOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), BehaviorOtherText), ''N'') = ''N''
		
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Attitude selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and AttitudeCooperative is null
/*		and isnull(AttitudeDefensive, ''N'') = ''N''
		and isnull(AttitudeReserved, ''N'') = ''N''
		and isnull(AttitudeMistrustful, ''N'') = ''N''
		and isnull(AttitudeOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AttitudeOtherText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''AttitudeOtherText'', ''Mental Status - Attitude Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AttitudeOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AttitudeOtherText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AffectBlunted'', ''Mental Status - Affect selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectBlunted, ''N'') = ''N''
		and isnull(AffectCongruent, ''N'') = ''N''
		and isnull(AffectUnremarkable, ''N'') = ''N''
		and isnull(AffectUnableToAssess, ''N'') = ''N''
		and isnull(AffectFlat, ''N'') = ''N''
		and isnull(AffectRestricted, ''N'') = ''N''
		and isnull(AffectExpansive, ''N'') = ''N''
		and isnull(AffectAngry, ''N'') = ''N''
		and isnull(AffectSad, ''N'') = ''N''
		and isnull(AffectIrritable, ''N'') = ''N''
		and isnull(AffectFearful, ''N'') = ''N''
		and isnull(AffectMood, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AffectOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AffectOtherText'', ''Mental Status - Affect Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AffectOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Speech selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		-- TER change for Riverwood
		and (@ClientIsDD <> ''Y'')
		and (SpeechCoherent is null
		or SpeechSpeed is null
		or SpeechVerbal is null
		or SpeechVolume is null)
/*
		and isnull(SpeechClear, ''N'') = ''N''
		and isnull(SpeechVolume, ''N'') = ''N''
		and isnull(SpeechPressured, ''N'') = ''N''
		and isnull(SpeechRepetitive, ''N'') = ''N''
		and isnull(SpeechSpontaneous, ''N'') = ''N''
		and isnull(SpeechSlurred, ''N'') = ''N''
		and isnull(SpeechMonotonous, ''N'') = ''N''
		and isnull(SpeechTalkative, ''N'') = ''N''
		and isnull(SpeechEcholalia, ''N'') = ''N''
		and isnull(SpeechOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), SpeechOtherText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''SpeechOtherText'', ''Mental Status - Speech Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(SpeechOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), SpeechOtherText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''ThoughtLucid'', ''Mental Status - Thought selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtLucid, ''N'') = ''N''
		and isnull(ThoughtParanoid, ''N'') = ''N''
		and isnull(ThoughtDelusional, ''N'') = ''N''
		and isnull(ThoughtTangential, ''N'') = ''N''
		and isnull(ThoughtLoose, ''N'') = ''N''
		and isnull(ThoughtPsychosis, ''N'') = ''N''
		and isnull(ThoughtImpoverished, ''N'') = ''N''
		and isnull(ThoughtConfused, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''N''
		and isnull(ThoughtGrandiose, ''N'')= ''N''
		and isnull(ThoughtDisorganized, ''N'')= ''N''
		and isnull(ThoughtFlightOfIdeas, ''N'')= ''N''
		and isnull(ThoughtBizarre, ''N'')= ''N'' 
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''ThoughtObsessiveText'', ''Mental Status - Obsessive details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Mood selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		-- TER change for Riverwood
		and (@ClientIsDD <> ''Y'')
		and (MoodNeutral is null
		or MoodFriendly is null)
/*
		and isnull(MoodLabile, ''N'') = ''N''
		and isnull(MoodAnxious, ''N'') = ''N''
		and isnull(MoodGuilty, ''N'') = ''N''
		and isnull(MoodIrritable, ''N'') = ''N''
		and isnull(MoodFearful, ''N'') = ''N''
		and isnull(MoodSad, ''N'') = ''N''
		and isnull(MoodTearful, ''N'') = ''N''
		and isnull(MoodAppropriate, ''N'') = ''N''
		and isnull(MoodIncongruent, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''N''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''MoodOtherMoodsText'', ''Mental Status - Mood Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''CognitionNormal'', ''Mental Status - Cognitioin selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(CognitionNormal, ''N'') = ''N''
		and isnull(CognitionLimited, ''N'') = ''N''
		and isnull(CognitionPhobias, ''N'') = ''N''
		and isnull(CognitionObsessions, ''N'') = ''N''
		and isnull(CognitionPreoccupation, ''N'') = ''N''
		and isnull(CognitionOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), CognitionOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''CognitionOtherText'', ''Mental Status - Cognition Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(CognitionOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), CognitionOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AttentionAppropriate'', ''Mental Status - Attention selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AttentionAppropriate, ''N'') = ''N''
		and isnull(AttentionGood, ''N'') = ''N''
		and isnull(AttentionImpaired, ''N'') = ''N''
		and isnull(AttentionOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AttentionOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AttentionOtherText'', ''Mental Status - Attention Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AttentionOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AttentionOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''LevelAlert'', ''Mental Status - Level of Consciousness selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(LevelAlert, ''N'') = ''N''
		and isnull(LevelSedate, ''N'') = ''N''
		and isnull(LevelLethargic, ''N'') = ''N''
		and isnull(LevelObtuned, ''N'') = ''N''
		and isnull(LevelOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), LevelOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''LevelOtherText'', ''Mental Status - Level of Consciousness Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(LevelOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), LevelOtherText), ''N'') = ''N''

	
	 UNION
	 SELECT ''MentalStatus'', ''MemoryIntact'', ''Mental Status - Memory selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MemoryIntact, ''N'') = ''N''
		and isnull(MemoryShortTerm, ''N'') = ''N''
		and isnull(MemoryLongTerm, ''N'') = ''N''
		and isnull(MemoryOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), MemoryOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''MemoryOtherText'', ''Mental Status - Memory Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MemoryOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), MemoryOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Judgement selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (JudgementAware is null
		or JudgementUnderstandsOutcomes is null
		or JudgementUnderstandsNeed is null)
/*		and isnull(JudgementRiskyBehavior, ''N'') = ''N''
		and isnull(JudgementIntact, ''N'') = ''N''
		and isnull(JudgementImpaired, ''N'') = ''N''
		and isnull(convert(Varchar(2000), JudgementImpairedText), ''N'') = ''N''
		and isnull(JudgementOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), JudgementOtherText), ''N'') = ''N''
*/
	 UNION
	 SELECT ''MentalStatus'', ''JudgementOtherText'', ''Mental Status - Judgement Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(JudgementOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), JudgementOtherText), ''N'') = ''N''


	 UNION
	 SELECT ''MentalStatus'', ''OrientationText'', ''Mental Status - Oreintation selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(OrientationPerson, ''N'') = ''N''
		and isnull(OrientationPlace, ''N'') = ''N''
		and isnull(OrientationTime, ''N'') = ''N''
		and isnull(OrientationCircumstance, ''N'') = ''N''
		and isnull(convert(Varchar(2000), OrientationText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DisturbanceNoneNoted'', ''Mental Status - Perceptual Disturbance selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(DisturbanceNoneNoted, ''N'') = ''N''
		and isnull(DisturbanceDelusions, ''N'') = ''N''
		and isnull(DisturbanceAuditory, ''N'') = ''N''
		and isnull(DisturbanceVisual, ''N'') = ''N''
		and isnull(DisturbanceOlfactory, ''N'') = ''N''
		and isnull(DisturbanceTactile, ''N'') = ''N''
		and isnull(DisturbanceDepersonalization, ''N'') = ''N''
		and isnull(DisturbanceDerealization, ''N'') = ''N''
		and isnull(DisturbanceIdeas, ''N'') = ''N''
		and isnull(DisturbanceParanoia, ''N'') = ''N''
		and isnull(DisturbanceOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), DisturbanceOtherText), ''N'') = ''N''
	 UNION
	 SELECT ''MentalStatus'', ''DisturbanceOtherText'', ''Mental Status - Perceptual Disturbance Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(DisturbanceOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), DisturbanceOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''RiskSuicideNotPresent'', ''Mental Status - Risk Assessment selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(RiskSuicideNotPresent, ''N'') = ''N''
		and isnull(RiskSuicideIdeation, ''N'') = ''N''
		and isnull(RiskSuicideActive, ''N'') = ''N''
		and isnull(RiskSuicidePassive, ''N'') = ''N''
		and isnull(RiskSuicideMeans, ''N'') = ''N''
		and isnull(RiskSuicidePlan, ''N'') = ''N''
		and isnull(RiskSuicideAttempt, ''N'') = ''N''
		and isnull(RiskSuicideTxPlan, ''N'') = ''N''
		and isnull(RiskHomicideNotPresent, ''N'') = ''N''
		and isnull(RiskHomicideIdeation, ''N'') = ''N''
		and isnull(RiskHomicideActive, ''N'') = ''N''
		and isnull(RiskHomicidePassive, ''N'') = ''N''
		and isnull(RiskHomicideMeans, ''N'') = ''N''
		and isnull(RiskHomicidePlan, ''N'') = ''N''
		and isnull(RiskHomicideAttempt, ''N'') = ''N''
		and isnull(RiskHomicideTxPlan, ''N'') = ''N''
		and isnull(convert(Varchar(2000), RiskOther), ''N'') = ''N''
		and isnull(convert(Varchar(2000), RiskIntervention), ''N'') = ''N''
	 END
	
	if @@error <> 0 goto error




/**************************************************************/

-- SERVICE NOTE

/**************************************************************/

IF @DocumentCodeId in (6)
-- DJH change for Riverwood
--IF @DocumentCodeId in (6, 109, 118)
BEGIN

	If exists (select UnableToAssess from #mentalStatus where isnull(UnableToAssess,''N'') = ''N'' and DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,''N'') = ''N'')
	Begin
	Insert into #validationReturnTable
	(TableName,
	ColumnName,
	ErrorMessage
	)
	
	
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Affect selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectBlunted, ''N'') = ''N''
		and isnull(AffectCongruent, ''N'') = ''N''
		and isnull(AffectUnremarkable, ''N'') = ''N''
		and isnull(AffectUnableToAssess, ''N'') = ''N''
		and isnull(AffectFlat, ''N'') = ''N''
		and isnull(AffectRestricted, ''N'') = ''N''
		and isnull(AffectExpansive, ''N'') = ''N''
		and isnull(AffectAngry, ''N'') = ''N''
		and isnull(AffectSad, ''N'') = ''N''
		and isnull(AffectIrritable, ''N'') = ''N''
		and isnull(AffectFearful, ''N'') = ''N''
		and isnull(AffectMood, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AffectOtherText), '''') = ''''

	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Affect Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AffectOtherText), '''') = ''''


	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Mood selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (MoodNeutral is null
		or MoodFriendly is null)
/*
		and isnull(MoodLabile, ''N'') = ''N''
		and isnull(MoodAnxious, ''N'') = ''N''
		and isnull(MoodGuilty, ''N'') = ''N''
		and isnull(MoodIrritable, ''N'') = ''N''
		and isnull(MoodFearful, ''N'') = ''N''
		and isnull(MoodSad, ''N'') = ''N''
		and isnull(MoodTearful, ''N'') = ''N''
		and isnull(MoodAppropriate, ''N'') = ''N''
		and isnull(MoodIncongruent, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''N''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
*/	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Mood Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), '''') = ''''
	

	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Thought Processing selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtLucid, ''N'') = ''N''
		and isnull(ThoughtParanoid, ''N'') = ''N''
		and isnull(ThoughtDelusional, ''N'') = ''N''
		and isnull(ThoughtTangential, ''N'') = ''N''
		and isnull(ThoughtLoose, ''N'') = ''N''
		and isnull(ThoughtPsychosis, ''N'') = ''N''
		and isnull(ThoughtImpoverished, ''N'') = ''N''
		and isnull(ThoughtConfused, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''N''
		and isnull(ThoughtGrandiose, ''N'') = ''N''
		and isnull(ThoughtFlightofIdeas, ''N'') = ''N''
		and isnull(ThoughtDisorganized, ''N'') = ''N''
		and isnull(ThoughtBizarre, ''N'') = ''N''
		and isnull(ThoughtProcessingOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), '''') = ''''
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Thought Processing other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtProcessingOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), '''') = ''''

	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Behavior must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (BehaviorGait is null
		or BehaviorEyeContact is null
		or BehaviorNormalActivity is null) 

/*		and isnull(BehaviorTics, ''N'') = ''N''
		and isnull(BehaviorTremors, ''N'') = ''N''
		and isnull(BehaviorTwitches, ''N'') = ''N''
		and isnull(BehaviorAgitated, ''N'') = ''N''
		and isnull(BehaviorLethargic, ''N'') = ''N''
		and isnull(BehaviorAggressive, ''N'') = ''N''
		and isnull(BehaviorNormalActivity, ''N'') = ''N''
*/
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Behavior Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(BehaviorOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), BehaviorOtherText), '''') = ''''	


	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Risk Assessment: Suicidality "Not Present/Ideation" selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(RiskSuicideNotPresent, ''N'') = ''N''
		and isnull(RiskSuicideIdeation, ''N'') = ''N''
 	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Risk Assessment: Suicidality "Active/Passive" selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(RiskSuicideIdeation, ''N'') = ''Y''
		and isnull(RiskSuicideActive, ''N'') = ''N''
		and isnull(RiskSuicidePassive, ''N'') = ''N''

 	
 	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Risk Assessment: Homicidality "Not Present/Ideation" selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(RiskHomicideNotPresent, ''N'') = ''N''
		and isnull(RiskHomicideIdeation, ''N'') = ''N''

 	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Risk Assessment: Homicidality "Active/Passive" selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(RiskHomicideIdeation, ''N'') = ''Y''
		and isnull(RiskHomicideActive, ''N'') = ''N''
		and isnull(RiskHomicidePassive, ''N'') = ''N''
 	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Risk Assessment: Clinical intervention for high risk client must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (isnull(RiskHomicideIdeation, ''N'') = ''Y''
		or isnull(RiskSuicideIdeation, ''N'') = ''Y'')
		and isnull(convert(varchar(8000), RiskIntervention), '''') = ''''
	
	
	
	-- DJH Change for Riverwood
/*
	 SELECT ''MentalStatus'', ''AppearanceDressed'', ''Mental Status - Appearance selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and AppearanceDressed is null
		and AppearanceAge is null
		and AppearanceAverageWeight is null
		and AppearanceAverageHeight is null
		and AppearanceGroomed is null
		and AppearanceHygiene is null
		and isnull(ApprearanceOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AppearanceOtherText), ''N'') = ''N''
	 
	 UNION
	 SELECT ''MentalStatus'', ''AppearanceOtherText'', ''Mental Status - Appearance Other Detail must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ApprearanceOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AppearanceOtherText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AffectBlunted'', ''Mental Status - Affect selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectBlunted, ''N'') = ''N''
		and isnull(AffectCongruent, ''N'') = ''N''
		and isnull(AffectUnremarkable, ''N'') = ''N''
		and isnull(AffectUnableToAssess, ''N'') = ''N''
		and isnull(AffectFlat, ''N'') = ''N''
		and isnull(AffectRestricted, ''N'') = ''N''
		and isnull(AffectExpansive, ''N'') = ''N''
		and isnull(AffectAngry, ''N'') = ''N''
		and isnull(AffectSad, ''N'') = ''N''
		and isnull(AffectIrritable, ''N'') = ''N''
		and isnull(AffectFearful, ''N'') = ''N''
		and isnull(AffectMood, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), AffectOtherText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''AffectOtherText'', ''Mental Status - Affect Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(AffectOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), AffectOtherText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''ThoughtLucid'', ''Mental Status - Thought selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtLucid, ''N'') = ''N''
		and isnull(ThoughtParanoid, ''N'') = ''N''
		and isnull(ThoughtDelusional, ''N'') = ''N''
		and isnull(ThoughtTangential, ''N'') = ''N''
		and isnull(ThoughtLoose, ''N'') = ''N''
		and isnull(ThoughtPsychosis, ''N'') = ''N''
		and isnull(ThoughtImpoverished, ''N'') = ''N''
		and isnull(ThoughtConfused, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''N''
		and isnull(ThoughtGrandiose, ''N'')= ''N''
		and isnull(ThoughtDisorganized, ''N'')= ''N''
		and isnull(ThoughtFlightOfIdeas, ''N'')= ''N''
		and isnull(ThoughtBizarre, ''N'')= ''N'' 
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''ThoughtObsessiveText'', ''Mental Status - Obsessive details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(ThoughtObsessive, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), ThoughtObsessiveText), ''N'') = ''N''
	
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DeletedBy'', ''Mental Status - Mood selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and (MoodNeutral is null
		or MoodFriendly is null)
/*
		and isnull(MoodLabile, ''N'') = ''N''
		and isnull(MoodAnxious, ''N'') = ''N''
		and isnull(MoodGuilty, ''N'') = ''N''
		and isnull(MoodIrritable, ''N'') = ''N''
		and isnull(MoodFearful, ''N'') = ''N''
		and isnull(MoodSad, ''N'') = ''N''
		and isnull(MoodTearful, ''N'') = ''N''
		and isnull(MoodAppropriate, ''N'') = ''N''
		and isnull(MoodIncongruent, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''N''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
*/
	 UNION
	 SELECT ''MentalStatus'', ''MoodOtherMoodsText'', ''Mental Status - Mood Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(MoodOtherMoods, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), MoodOtherMoodsText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''OrientationText'', ''Mental Status - Oreintation selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(OrientationPerson, ''N'') = ''N''
		and isnull(OrientationPlace, ''N'') = ''N''
		and isnull(OrientationTime, ''N'') = ''N''
		and isnull(OrientationCircumstance, ''N'') = ''N''
		and isnull(convert(Varchar(2000), OrientationText), ''N'') = ''N''
	
	
	 UNION
	 SELECT ''MentalStatus'', ''DisturbanceNoneNoted'', ''Mental Status - Perceptual Disturbance selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(DisturbanceNoneNoted, ''N'') = ''N''
		and isnull(DisturbanceDelusions, ''N'') = ''N''
		and isnull(DisturbanceAuditory, ''N'') = ''N''
		and isnull(DisturbanceVisual, ''N'') = ''N''
		and isnull(DisturbanceOlfactory, ''N'') = ''N''
		and isnull(DisturbanceTactile, ''N'') = ''N''
		and isnull(DisturbanceDepersonalization, ''N'') = ''N''
		and isnull(DisturbanceDerealization, ''N'') = ''N''
		and isnull(DisturbanceIdeas, ''N'') = ''N''
		and isnull(DisturbanceParanoia, ''N'') = ''N''
		and isnull(DisturbanceOther, ''N'') = ''N''
		and isnull(convert(Varchar(2000), DisturbanceOtherText), ''N'') = ''N''
	 UNION
	 SELECT ''MentalStatus'', ''DisturbanceOtherText'', ''Mental Status - Perceptual Disturbance Other details selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(DisturbanceOther, ''N'') = ''Y''
		and isnull(convert(Varchar(2000), DisturbanceOtherText), ''N'') = ''N''
	
	 UNION
	 SELECT ''MentalStatus'', ''RiskSuicideNotPresent'', ''Mental Status - Risk Assessment selection must be specified.''
	 FROM #MentalStatus
	 WHERE isnull(UnableToAssess, ''N'') = ''N''
		and isnull(RiskSuicideNotPresent, ''N'') = ''N''
		and isnull(RiskSuicideIdeation, ''N'') = ''N''
		and isnull(RiskSuicideActive, ''N'') = ''N''
		and isnull(RiskSuicidePassive, ''N'') = ''N''
		and isnull(RiskSuicideMeans, ''N'') = ''N''
		and isnull(RiskSuicidePlan, ''N'') = ''N''
		and isnull(RiskSuicideAttempt, ''N'') = ''N''
		and isnull(RiskSuicideTxPlan, ''N'') = ''N''
		and isnull(RiskHomicideNotPresent, ''N'') = ''N''
		and isnull(RiskHomicideIdeation, ''N'') = ''N''
		and isnull(RiskHomicideActive, ''N'') = ''N''
		and isnull(RiskHomicidePassive, ''N'') = ''N''
		and isnull(RiskHomicideMeans, ''N'') = ''N''
		and isnull(RiskHomicidePlan, ''N'') = ''N''
		and isnull(RiskHomicideAttempt, ''N'') = ''N''
		and isnull(RiskHomicideTxPlan, ''N'') = ''N''
		and isnull(convert(Varchar(2000), RiskOther), ''N'') = ''N''
		and isnull(convert(Varchar(2000), RiskIntervention), ''N'') = ''N''
*/

	
	 END
	End

if @@error <> 0 goto error





return

error:
raiserror 50000 ''csp_validateFullMentalStatus failed.  Contact your system administrator.''
' 
END
GO
