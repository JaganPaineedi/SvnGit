/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentMentalStatuses]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMentalStatuses]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentMentalStatuses]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentMentalStatuses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'                 
CREATE procedure [dbo].[csp_ValidateCustomDocumentMentalStatuses]
/******************************************************************************                                      
**  File: csp_ValidateCustomDocumentMentalStatuses                                  
**  Name: csp_ValidateCustomDocumentMentalStatuses              
**  Desc: For Validation  on CustomDocumentMentalStatuses document(For Prototype purpose, Need modification)              
**  Return values: Resultset having validation messages                                      
**  Called by:                                       
**  Parameters:                  
**  Auth:  Jagdeep Hundal                     
**  Date:  July 29 2011                                  
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:       Author:       Description:                                      
**  --------    --------        ----------------------------------------------------                                      
** 2012.02.08	TER				Revised based on Harbor''s rules
*******************************************************************************/                                    
	@DocumentVersionId int,
	@TabOrder int = 1
as

CREATE TABLE #CustomDocumentMentalStatuses (
	[DocumentVersionId] [int] ,
	[CreatedBy] varchar(35) ,
	[CreatedDate] datetime ,
	[ModifiedBy] varchar(35) ,
	[ModifiedDate] datetime ,
	[RecordDeleted] char(1) ,
	[DeletedBy] varchar(35) ,
	[DeletedDate] [datetime] ,
	[ConsciousnessNA] char(1) ,
	[ConsciousnessAlert] char(1) ,
	[ConsciousnessObtunded] char(1) ,
	[ConsciousnessSomnolent] char(1) ,
	[ConsciousnessOrientedX3] char(1) ,
	[ConsciousnessAppearsUnderInfluence] char(1) ,
	[ConsciousnessComment] varchar(max) ,
	[EyeContactNA] char(1) ,
	[EyeContactAppropriate] char(1) ,
	[EyeContactStaring] char(1) ,
	[EyeContactAvoidant] char(1) ,
	[EyeContactComment] varchar(max) ,
	[AppearanceNA] char(1) ,
	[AppearanceClean] char(1) ,
	[AppearanceNeatlyDressed] char(1) ,
	[AppearanceAppropriate] char(1) ,
	[AppearanceDisheveled] char(1) ,
	[AppearanceMalodorous] char(1) ,
	[AppearanceUnusual] char(1) ,
	[AppearancePoorlyGroomed] char(1) ,
	[AppearanceComment] varchar(max) ,
	[AgeNA] char(1) ,
	[AgeAppropriate] char(1) ,
	[AgeOlder] char(1) ,
	[AgeYounger] char(1) ,
	[AgeComment] varchar(max) ,
	[BehaviorNA] char(1) ,
	[BehaviorPleasant] char(1) ,
	[BehaviorGuarded] char(1) ,
	[BehaviorAgitated] char(1) ,
	[BehaviorImpulsive] char(1) ,
	[BehaviorWithdrawn] char(1) ,
	[BehaviorUncooperative] char(1) ,
	[BehaviorAggressive] char(1) ,
	[BehaviorComment] varchar(max) ,
	[PsychomotorNA] char(1) ,
	[PsychomotorNoAbnormalMovements] char(1) ,
	[PsychomotorAgitation] char(1) ,
	[PsychomotorAbnormalMovements] char(1) ,
	[PsychomotorRetardation] char(1) ,
	[PsychomotorComment] varchar(max) ,
	[MoodNA] char(1) ,
	[MoodEuthymic] char(1) ,
	[MoodDysphoric] char(1) ,
	[MoodIrritable] char(1) ,
	[MoodDepressed] char(1) ,
	[MoodExpansive] char(1) ,
	[MoodAnxious] char(1) ,
	[MoodElevated] char(1) ,
	[MoodComment] varchar(max) ,
	[ThoughtContentNA] char(1) ,
	[ThoughtContentWithinLimits] char(1) ,
	[ThoughtContentExcessiveWorries] char(1) ,
	[ThoughtContentOvervaluedIdeas] char(1) ,
	[ThoughtContentRuminations] char(1) ,
	[ThoughtContentPhobias] char(1) ,
	[ThoughtContentComment] varchar(max) ,
	[DelusionsNA] char(1) ,
	[DelusionsNone] char(1) ,
	[DelusionsBizarre] char(1) ,
	[DelusionsReligious] char(1) ,
	[DelusionsGrandiose] char(1) ,
	[DelusionsParanoid] char(1) ,
	[DelusionsComment] varchar(max) ,
	[ThoughtProcessNA] char(1) ,
	[ThoughtProcessLogical] char(1) ,
	[ThoughtProcessCircumferential] char(1) ,
	[ThoughtProcessFlightIdeas] char(1) ,
	[ThoughtProcessIllogical] char(1) ,
	[ThoughtProcessDerailment] char(1) ,
	[ThoughtProcessTangential] char(1) ,
	[ThoughtProcessSomatic] char(1) ,
	[ThoughtProcessCircumstantial] char(1) ,
	[ThoughtProcessComment] varchar(max) ,
	[HallucinationsNA] char(1) ,
	[HallucinationsNone] char(1) ,
	[HallucinationsAuditory] char(1) ,
	[HallucinationsVisual] char(1) ,
	[HallucinationsTactile] char(1) ,
	[HallucinationsOlfactory] char(1) ,
	[HallucinationsComment] varchar(max) ,
	[IntellectNA] char(1) ,
	[IntellectAverage] char(1) ,
	[IntellectAboveAverage] char(1) ,
	[IntellectBelowAverage] char(1) ,
	[IntellectComment] varchar(max) ,
	[SpeechNA] char(1) ,
	[SpeechRate] [char](1) ,
	[SpeechTone] [char](1) ,
	[SpeechVolume] [char](1) ,
	[SpeechArticulation] [char](1) ,
	[SpeechComment] varchar(max) ,
	[AffectNA] char(1) ,
	[AffectCongruent] char(1) ,
	[AffectReactive] char(1) ,
	[AffectIncongruent] char(1) ,
	[AffectLabile] char(1) ,
	[AffectComment] varchar(max) ,
	[RangeNA] char(1) ,
	[RangeBroad] char(1) ,
	[RangeBlunted] char(1) ,
	[RangeFlat] char(1) ,
	[RangeFull] char(1) ,
	[RangeConstricted] char(1) ,
	[RangeComment] varchar(max) ,
	[InsightNA] char(1) ,
	[InsightExcellent] char(1) ,
	[InsightGood] char(1) ,
	[InsightFair] char(1) ,
	[InsightPoor] char(1) ,
	[InsightImpaired] char(1) ,
	[InsightUnknown] char(1) ,
	[InsightComment] varchar(max) ,
	[JudgmentNA] char(1) ,
	[JudgmentExcellent] char(1) ,
	[JudgmentGood] char(1) ,
	[JudgmentFair] char(1) ,
	[JudgmentPoor] char(1) ,
	[JudgmentImpaired] char(1) ,
	[JudgmentUnknown] char(1) ,
	[JudgmentComment] varchar(max) ,
	[MemoryNA] char(1) ,
	[MemoryShortTerm] [char](1) ,
	[MemoryLongTerm] [char](1) ,
	[MemoryAttention] [char](1) ,
	[MemoryComment] varchar(max) ,
	[BodyHabitusNA] char(1) ,
	[BodyHabitusAverage] char(1) ,
	[BodyHabitusThin] char(1) ,
	[BodyHabitusUnderweight] char(1) ,
	[BodyHabitusOverweight] char(1) ,
	[BodyHabitusObese] char(1) ,
	[BodyHabitusComment] varchar(max) 
)

insert into #CustomDocumentMentalStatuses (
	[DocumentVersionId],
	[CreatedBy],
	[CreatedDate],
	[ModifiedBy],
	[ModifiedDate],
	[RecordDeleted],
	[DeletedBy],
	[DeletedDate],
	[ConsciousnessNA],
	[ConsciousnessAlert],
	[ConsciousnessObtunded],
	[ConsciousnessSomnolent],
	[ConsciousnessOrientedX3],
	[ConsciousnessAppearsUnderInfluence],
	[ConsciousnessComment],
	[EyeContactNA],
	[EyeContactAppropriate],
	[EyeContactStaring],
	[EyeContactAvoidant],
	[EyeContactComment],
	[AppearanceNA],
	[AppearanceClean],
	[AppearanceNeatlyDressed],
	[AppearanceAppropriate],
	[AppearanceDisheveled],
	[AppearanceMalodorous],
	[AppearanceUnusual],
	[AppearancePoorlyGroomed],
	[AppearanceComment],
	[AgeNA],
	[AgeAppropriate],
	[AgeOlder],
	[AgeYounger],
	[AgeComment],
	[BehaviorNA],
	[BehaviorPleasant],
	[BehaviorGuarded],
	[BehaviorAgitated],
	[BehaviorImpulsive],
	[BehaviorWithdrawn],
	[BehaviorUncooperative],
	[BehaviorAggressive],
	[BehaviorComment],
	[PsychomotorNA],
	[PsychomotorNoAbnormalMovements],
	[PsychomotorAgitation],
	[PsychomotorAbnormalMovements],
	[PsychomotorRetardation],
	[PsychomotorComment],
	[MoodNA],
	[MoodEuthymic],
	[MoodDysphoric],
	[MoodIrritable],
	[MoodDepressed],
	[MoodExpansive],
	[MoodAnxious],
	[MoodElevated],
	[MoodComment],
	[ThoughtContentNA],
	[ThoughtContentWithinLimits],
	[ThoughtContentExcessiveWorries],
	[ThoughtContentOvervaluedIdeas],
	[ThoughtContentRuminations],
	[ThoughtContentPhobias],
	[ThoughtContentComment],
	[DelusionsNA],
	[DelusionsNone],
	[DelusionsBizarre],
	[DelusionsReligious],
	[DelusionsGrandiose],
	[DelusionsParanoid],
	[DelusionsComment],
	[ThoughtProcessNA],
	[ThoughtProcessLogical],
	[ThoughtProcessCircumferential],
	[ThoughtProcessFlightIdeas],
	[ThoughtProcessIllogical],
	[ThoughtProcessDerailment],
	[ThoughtProcessTangential],
	[ThoughtProcessSomatic],
	[ThoughtProcessCircumstantial],
	[ThoughtProcessComment],
	[HallucinationsNA],
	[HallucinationsNone],
	[HallucinationsAuditory],
	[HallucinationsVisual],
	[HallucinationsTactile],
	[HallucinationsOlfactory],
	[HallucinationsComment],
	[IntellectNA],
	[IntellectAverage],
	[IntellectAboveAverage],
	[IntellectBelowAverage],
	[IntellectComment],
	[SpeechNA],
	[SpeechRate],
	[SpeechTone],
	[SpeechVolume],
	[SpeechArticulation],
	[SpeechComment],
	[AffectNA],
	[AffectCongruent],
	[AffectReactive],
	[AffectIncongruent],
	[AffectLabile],
	[AffectComment],
	[RangeNA],
	[RangeBroad],
	[RangeBlunted],
	[RangeFlat],
	[RangeFull],
	[RangeConstricted],
	[RangeComment],
	[InsightNA],
	[InsightExcellent],
	[InsightGood],
	[InsightFair],
	[InsightPoor],
	[InsightImpaired],
	[InsightUnknown],
	[InsightComment],
	[JudgmentNA],
	[JudgmentExcellent],
	[JudgmentGood],
	[JudgmentFair],
	[JudgmentPoor],
	[JudgmentImpaired],
	[JudgmentUnknown],
	[JudgmentComment],
	[MemoryNA],
	[MemoryShortTerm],
	[MemoryLongTerm],
	[MemoryAttention],
	[MemoryComment],
	[BodyHabitusNA],
	[BodyHabitusAverage],
	[BodyHabitusThin],
	[BodyHabitusUnderweight],
	[BodyHabitusOverweight],
	[BodyHabitusObese],
	[BodyHabitusComment]
)
select
	[DocumentVersionId],
	[CreatedBy],
	[CreatedDate],
	[ModifiedBy],
	[ModifiedDate],
	[RecordDeleted],
	[DeletedBy],
	[DeletedDate],
	[ConsciousnessNA],
	[ConsciousnessAlert],
	[ConsciousnessObtunded],
	[ConsciousnessSomnolent],
	[ConsciousnessOrientedX3],
	[ConsciousnessAppearsUnderInfluence],
	[ConsciousnessComment],
	[EyeContactNA],
	[EyeContactAppropriate],
	[EyeContactStaring],
	[EyeContactAvoidant],
	[EyeContactComment],
	[AppearanceNA],
	[AppearanceClean],
	[AppearanceNeatlyDressed],
	[AppearanceAppropriate],
	[AppearanceDisheveled],
	[AppearanceMalodorous],
	[AppearanceUnusual],
	[AppearancePoorlyGroomed],
	[AppearanceComment],
	[AgeNA],
	[AgeAppropriate],
	[AgeOlder],
	[AgeYounger],
	[AgeComment],
	[BehaviorNA],
	[BehaviorPleasant],
	[BehaviorGuarded],
	[BehaviorAgitated],
	[BehaviorImpulsive],
	[BehaviorWithdrawn],
	[BehaviorUncooperative],
	[BehaviorAggressive],
	[BehaviorComment],
	[PsychomotorNA],
	[PsychomotorNoAbnormalMovements],
	[PsychomotorAgitation],
	[PsychomotorAbnormalMovements],
	[PsychomotorRetardation],
	[PsychomotorComment],
	[MoodNA],
	[MoodEuthymic],
	[MoodDysphoric],
	[MoodIrritable],
	[MoodDepressed],
	[MoodExpansive],
	[MoodAnxious],
	[MoodElevated],
	[MoodComment],
	[ThoughtContentNA],
	[ThoughtContentWithinLimits],
	[ThoughtContentExcessiveWorries],
	[ThoughtContentOvervaluedIdeas],
	[ThoughtContentRuminations],
	[ThoughtContentPhobias],
	[ThoughtContentComment],
	[DelusionsNA],
	[DelusionsNone],
	[DelusionsBizarre],
	[DelusionsReligious],
	[DelusionsGrandiose],
	[DelusionsParanoid],
	[DelusionsComment],
	[ThoughtProcessNA],
	[ThoughtProcessLogical],
	[ThoughtProcessCircumferential],
	[ThoughtProcessFlightIdeas],
	[ThoughtProcessIllogical],
	[ThoughtProcessDerailment],
	[ThoughtProcessTangential],
	[ThoughtProcessSomatic],
	[ThoughtProcessCircumstantial],
	[ThoughtProcessComment],
	[HallucinationsNA],
	[HallucinationsNone],
	[HallucinationsAuditory],
	[HallucinationsVisual],
	[HallucinationsTactile],
	[HallucinationsOlfactory],
	[HallucinationsComment],
	[IntellectNA],
	[IntellectAverage],
	[IntellectAboveAverage],
	[IntellectBelowAverage],
	[IntellectComment],
	[SpeechNA],
	[SpeechRate],
	[SpeechTone],
	[SpeechVolume],
	[SpeechArticulation],
	[SpeechComment],
	[AffectNA],
	[AffectCongruent],
	[AffectReactive],
	[AffectIncongruent],
	[AffectLabile],
	[AffectComment],
	[RangeNA],
	[RangeBroad],
	[RangeBlunted],
	[RangeFlat],
	[RangeFull],
	[RangeConstricted],
	[RangeComment],
	[InsightNA],
	[InsightExcellent],
	[InsightGood],
	[InsightFair],
	[InsightPoor],
	[InsightImpaired],
	[InsightUnknown],
	[InsightComment],
	[JudgmentNA],
	[JudgmentExcellent],
	[JudgmentGood],
	[JudgmentFair],
	[JudgmentPoor],
	[JudgmentImpaired],
	[JudgmentUnknown],
	[JudgmentComment],
	[MemoryNA],
	[MemoryShortTerm],
	[MemoryLongTerm],
	[MemoryAttention],
	[MemoryComment],
	[BodyHabitusNA],
	[BodyHabitusAverage],
	[BodyHabitusThin],
	[BodyHabitusUnderweight],
	[BodyHabitusOverweight],
	[BodyHabitusObese],
	[BodyHabitusComment]
from dbo.CustomDocumentMentalStatuses
where DocumentVersionId = @DocumentVersionId

Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Consciousness selection is required'', @TabOrder, 1
from #CustomDocumentMentalStatuses
where
isnull([ConsciousnessNA], ''N'') <> ''Y'' and
isnull([ConsciousnessAlert], ''N'') <> ''Y'' and
isnull([ConsciousnessObtunded], ''N'') <> ''Y'' and
isnull([ConsciousnessSomnolent], ''N'') <> ''Y'' and
isnull([ConsciousnessOrientedX3], ''N'') <> ''Y'' and
isnull([ConsciousnessAppearsUnderInfluence], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Eye contact selection is required'', @TabOrder, 2
from #CustomDocumentMentalStatuses
where
isnull([EyeContactNA], ''N'') <> ''Y'' and
isnull([EyeContactAppropriate], ''N'') <> ''Y'' and
isnull([EyeContactStaring], ''N'') <> ''Y'' and
isnull([EyeContactAvoidant], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Appearance selection is required'', @TabOrder, 3
from #CustomDocumentMentalStatuses
where
isnull([AppearanceNA], ''N'') <> ''Y'' and
isnull([AppearanceClean], ''N'') <> ''Y'' and
isnull([AppearanceNeatlyDressed], ''N'') <> ''Y'' and
isnull([AppearanceAppropriate], ''N'') <> ''Y'' and
isnull([AppearanceDisheveled], ''N'') <> ''Y'' and
isnull([AppearanceMalodorous], ''N'') <> ''Y'' and
isnull([AppearanceUnusual], ''N'') <> ''Y'' and
isnull([AppearancePoorlyGroomed], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Age selection is required'', @TabOrder, 4
from #CustomDocumentMentalStatuses
where
isnull([AgeNA], ''N'') <> ''Y'' and
isnull([AgeAppropriate], ''N'') <> ''Y'' and
isnull([AgeOlder], ''N'') <> ''Y'' and
isnull([AgeYounger], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Behavior selection is required'', @TabOrder, 5
from #CustomDocumentMentalStatuses
where
isnull([BehaviorNA], ''N'') <> ''Y'' and
isnull([BehaviorPleasant], ''N'') <> ''Y'' and
isnull([BehaviorGuarded], ''N'') <> ''Y'' and
isnull([BehaviorAgitated], ''N'') <> ''Y'' and
isnull([BehaviorImpulsive], ''N'') <> ''Y'' and
isnull([BehaviorWithdrawn], ''N'') <> ''Y'' and
isnull([BehaviorUncooperative], ''N'') <> ''Y'' and
isnull([BehaviorAggressive], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Psychomotor selection is required'', @TabOrder, 6
from #CustomDocumentMentalStatuses
where
isnull([PsychomotorNA], ''N'') <> ''Y'' and
isnull([PsychomotorNoAbnormalMovements], ''N'') <> ''Y'' and
isnull([PsychomotorAgitation], ''N'') <> ''Y'' and
isnull([PsychomotorAbnormalMovements], ''N'') <> ''Y'' and
isnull([PsychomotorRetardation], ''N'') <> ''Y'' 
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Mood selection is required'', @TabOrder, 7
from #CustomDocumentMentalStatuses
where
isnull([MoodNA], ''N'') <> ''Y'' and
isnull([MoodEuthymic], ''N'') <> ''Y'' and
isnull([MoodDysphoric], ''N'') <> ''Y'' and
isnull([MoodIrritable], ''N'') <> ''Y'' and
isnull([MoodDepressed], ''N'') <> ''Y'' and
isnull([MoodExpansive], ''N'') <> ''Y'' and
isnull([MoodAnxious], ''N'') <> ''Y'' and
isnull([MoodElevated], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Thought content selection is required'', @TabOrder, 8
from #CustomDocumentMentalStatuses
where
isnull([ThoughtContentNA], ''N'') <> ''Y'' and
isnull([ThoughtContentWithinLimits], ''N'') <> ''Y'' and
isnull([ThoughtContentExcessiveWorries], ''N'') <> ''Y'' and
isnull([ThoughtContentOvervaluedIdeas], ''N'') <> ''Y'' and
isnull([ThoughtContentRuminations], ''N'') <> ''Y'' and
isnull([ThoughtContentPhobias], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Delusions selection is required'', @TabOrder, 9
from #CustomDocumentMentalStatuses
where
isnull([DelusionsNA], ''N'') <> ''Y'' and
isnull([DelusionsNone], ''N'') <> ''Y'' and
isnull([DelusionsBizarre], ''N'') <> ''Y'' and
isnull([DelusionsReligious], ''N'') <> ''Y'' and
isnull([DelusionsGrandiose], ''N'') <> ''Y'' and
isnull([DelusionsParanoid], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Thought process selection is required'', @TabOrder, 10
from #CustomDocumentMentalStatuses
where
isnull([ThoughtProcessNA], ''N'') <> ''Y'' and
isnull([ThoughtProcessLogical], ''N'') <> ''Y'' and
isnull([ThoughtProcessCircumferential], ''N'') <> ''Y'' and
isnull([ThoughtProcessFlightIdeas], ''N'') <> ''Y'' and
isnull([ThoughtProcessIllogical], ''N'') <> ''Y'' and
isnull([ThoughtProcessDerailment], ''N'') <> ''Y'' and
isnull([ThoughtProcessTangential], ''N'') <> ''Y'' and
isnull([ThoughtProcessSomatic], ''N'') <> ''Y'' and
isnull([ThoughtProcessCircumstantial], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Hallucinations selection is required'', @TabOrder, 11
from #CustomDocumentMentalStatuses
where
isnull([HallucinationsNA], ''N'') <> ''Y'' and
isnull([HallucinationsNone], ''N'') <> ''Y'' and
isnull([HallucinationsAuditory], ''N'') <> ''Y'' and
isnull([HallucinationsVisual], ''N'') <> ''Y'' and
isnull([HallucinationsTactile], ''N'') <> ''Y'' and
isnull([HallucinationsOlfactory], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Intellect selection is required'', @TabOrder, 12
from #CustomDocumentMentalStatuses
where
isnull([IntellectNA], ''N'') <> ''Y'' and
isnull([IntellectAverage], ''N'') <> ''Y'' and
isnull([IntellectAboveAverage], ''N'') <> ''Y'' and
isnull([IntellectBelowAverage], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Speech selections required'', @TabOrder, 13
from #CustomDocumentMentalStatuses
where
isnull([SpeechNA], ''N'') <> ''Y'' and
(
	[SpeechRate] is null or
	[SpeechTone] is null or
	[SpeechVolume] is null or
	[SpeechArticulation] is null
)
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Affect selection is required'', @TabOrder, 14
from #CustomDocumentMentalStatuses
where
isnull([AffectNA], ''N'') <> ''Y'' and
isnull([AffectCongruent], ''N'') <> ''Y'' and
isnull([AffectReactive], ''N'') <> ''Y'' and
isnull([AffectIncongruent], ''N'') <> ''Y'' and
isnull([AffectLabile], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Range selection is required'', @TabOrder, 15
from #CustomDocumentMentalStatuses
where
isnull([RangeNA], ''N'') <> ''Y'' and
isnull([RangeBroad], ''N'') <> ''Y'' and
isnull([RangeBlunted], ''N'') <> ''Y'' and
isnull([RangeFlat], ''N'') <> ''Y'' and
isnull([RangeFull], ''N'') <> ''Y'' and
isnull([RangeConstricted], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Insight selection is required'', @TabOrder, 16
from #CustomDocumentMentalStatuses
where
isnull([InsightNA], ''N'') <> ''Y'' and
isnull([InsightExcellent], ''N'') <> ''Y'' and
isnull([InsightGood], ''N'') <> ''Y'' and
isnull([InsightFair], ''N'') <> ''Y'' and
isnull([InsightPoor], ''N'') <> ''Y'' and
isnull([InsightImpaired], ''N'') <> ''Y'' and
isnull([InsightUnknown], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Judgement selection is required'', @TabOrder, 17
from #CustomDocumentMentalStatuses
where
isnull([JudgmentNA], ''N'') <> ''Y'' and
isnull([JudgmentExcellent], ''N'') <> ''Y'' and
isnull([JudgmentGood], ''N'') <> ''Y'' and
isnull([JudgmentFair], ''N'') <> ''Y'' and
isnull([JudgmentPoor], ''N'') <> ''Y'' and
isnull([JudgmentImpaired], ''N'') <> ''Y'' and
isnull([JudgmentUnknown], ''N'') <> ''Y''
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Memory selections required'', @TabOrder, 18
from #CustomDocumentMentalStatuses
where
isnull([MemoryNA], ''N'') <> ''Y'' and
(
	[MemoryShortTerm] is null or
	[MemoryLongTerm] is null or
	[MemoryAttention] is null
)
union
select ''CustomDocumentMentalStatuses'', ''DeletedBy'', ''Mental Status - Body Habitus selection is required'', @TabOrder, 19
from #CustomDocumentMentalStatuses
where
isnull([BodyHabitusNA], ''N'') <> ''Y'' and
isnull([BodyHabitusAverage], ''N'') <> ''Y'' and
isnull([BodyHabitusThin], ''N'') <> ''Y'' and
isnull([BodyHabitusUnderweight], ''N'') <> ''Y'' and
isnull([BodyHabitusOverweight], ''N'') <> ''Y'' and
isnull([BodyHabitusObese], ''N'') <> ''Y''


' 
END
GO
