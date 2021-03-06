/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportMentalStatus]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportMentalStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportMentalStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportMentalStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure [dbo].[csp_RDLSubReportMentalStatus]
/*********************************************************************/                                                                                                                                                          
/* Stored Procedure: csp_RDLSubReportMentalStatus              */                                                                                                                                                          
/*                                                                   */                                                                                                                                                          
/* Purpose:  Get report data for the mental status use in any document  */                                                                                                                                                        
/*                                                                   */                                                                                                                                                        
/* Input Parameters:   @DocumentVersionId int  */                                                                                                                                                        
/*                                                                   */                                                                                                                                                          
/* Output Parameters:   None                   */                                                                                                                                                          
/*                                                                   */                                                                                                                                                          
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                          
/*                                                                   */                                 
/* Called By:  Reporting Services									*/         
/*																	*/                         
/*********************************************************************/   
                                                     
	@DocumentVersionId int
as	
	declare @ss varchar(max)
	set @ss=(select DiagnosticImpressionsSummary from CustomDocumentDiagnosticAssessments where DocumentVersionId = @DocumentVersionId)

select
	case when RTRIM(a.Consciousness) like ''%,'' then SUBSTRING(a.Consciousness, 1, LEN(RTRIM(a.Consciousness)) - 1) else a.Consciousness end as Consciousness,
	case when RTRIM(a.EyeContact) like ''%,'' then SUBSTRING(a.EyeContact, 1, LEN(RTRIM(a.EyeContact)) - 1) else a.EyeContact end as EyeContact,
	case when RTRIM(a.Appearance) like ''%,'' then SUBSTRING(a.Appearance, 1, LEN(RTRIM(a.Appearance)) - 1) else a.Appearance end as Appearance,
	case when RTRIM(a.Age) like ''%,'' then SUBSTRING(a.Age, 1, LEN(RTRIM(a.Age)) - 1) else a.Age end as Age,
	case when RTRIM(a.Behavior) like ''%,'' then SUBSTRING(a.Behavior, 1, LEN(RTRIM(a.Behavior)) - 1) else a.Behavior end as Behavior,
	case when RTRIM(a.Psychommotor) like ''%,'' then SUBSTRING(a.Psychommotor, 1, LEN(RTRIM(a.Psychommotor)) - 1) else a.Psychommotor end as Psychommotor,
	case when RTRIM(a.Mood) like ''%,'' then SUBSTRING(a.Mood, 1, LEN(RTRIM(a.Mood)) - 1) else a.Mood end as Mood,
	case when RTRIM(a.ThoughtContent) like ''%,'' then SUBSTRING(a.ThoughtContent, 1, LEN(RTRIM(a.ThoughtContent)) - 1) else a.ThoughtContent end as ThoughtContent,
	case when RTRIM(a.Delusions) like ''%,'' then SUBSTRING(a.Delusions, 1, LEN(RTRIM(a.Delusions)) - 1) else a.Delusions end as Delusions,
	case when RTRIM(a.ThoughtProcess) like ''%,'' then SUBSTRING(a.ThoughtProcess, 1, LEN(RTRIM(a.ThoughtProcess)) - 1) else a.ThoughtProcess end as ThoughtProcess,
	case when RTRIM(a.Hallucinations) like ''%,'' then SUBSTRING(a.Hallucinations, 1, LEN(RTRIM(a.Hallucinations)) - 1) else a.Hallucinations end as Hallucinations,
	case when RTRIM(a.Intellect) like ''%,'' then SUBSTRING(a.Intellect, 1, LEN(RTRIM(a.Intellect)) - 1) else a.Intellect end as Intellect,
	case when RTRIM(a.Speech) like ''%,'' then SUBSTRING(a.Speech, 1, LEN(RTRIM(a.Speech)) - 1) else a.Speech end as Speech,
	case when RTRIM(a.Affect) like ''%,'' then SUBSTRING(a.Affect, 1, LEN(RTRIM(a.Affect)) - 1) else a.Affect end as Affect,
	case when RTRIM(a.[Range]) like ''%,'' then SUBSTRING(a.[Range], 1, LEN(RTRIM(a.[Range])) - 1) else a.[Range] end as [Range],
	case when RTRIM(a.Insight) like ''%,'' then SUBSTRING(a.Insight, 1, LEN(RTRIM(a.Insight)) - 1) else a.Insight end as Insight,
	case when RTRIM(a.Judgment) like ''%,'' then SUBSTRING(a.Judgment, 1, LEN(RTRIM(a.Judgment)) - 1) else a.Judgment end as Judgment,
	case when RTRIM(a.Memory) like ''%,'' then SUBSTRING(a.Memory, 1, LEN(RTRIM(a.Memory)) - 1) else a.Memory end as Memory,
	case when RTRIM(a.BodyHabitus) like ''%,'' then SUBSTRING(a.BodyHabitus, 1, LEN(RTRIM(a.BodyHabitus)) - 1) else a.BodyHabitus end as BodyHabitus,
	ConsciousnessComment,
	EyeContactComment,
	AppearanceComment,
	AgeComment,
	BehaviorComment,
	PsychomotorComment,
	MoodComment,
	ThoughtContentComment,
	DelusionsComment,
	ThoughtProcessComment,
	HallucinationsComment,
	IntellectComment,
	SpeechComment,
	AffectComment,
	RangeComment,
	InsightComment,
	JudgmentComment,
	MemoryComment,
	BodyHabitusComment,
	@ss as DiagnosticImpressionsSummary
from (
	select case when ConsciousnessNA = ''Y'' then ''N/A, '' else '''' end
		+ case when ConsciousnessAlert = ''Y'' then ''Alert, '' else '''' end
		+ case when ConsciousnessObtunded = ''Y'' then ''Lethargic, '' else '''' end	-- label change
		+ case when ConsciousnessSomnolent = ''Y'' then ''Drowsy, '' else '''' end	-- label change
		+ case when ConsciousnessOrientedX3 = ''Y'' then ''Oriented X 3, '' else '''' end
		+ case when ConsciousnessAppearsUnderInfluence = ''Y'' then ''Appears Under the Influence / Impaired, '' else '''' end as Consciousness,
	case when EyeContactNA = ''Y'' then ''N/A, '' else '''' end
		+ case when EyeContactAppropriate = ''Y'' then ''Appropriate, '' else '''' end
		+ case when EyeContactStaring = ''Y'' then ''Staring, '' else '''' end
		+ case when EyeContactAvoidant = ''Y'' then ''Avoidant'' else '''' end as EyeContact,
	case when AppearanceNA = ''Y'' then ''N/A, '' else '''' end
		+ case when AppearanceClean = ''Y'' then ''Clean, '' else '''' end
		+ case when AppearanceNeatlyDressed = ''Y'' then ''Neatly Dressed, '' else '''' end
		+ case when AppearanceAppropriate = ''Y'' then ''Appropriate, '' else '''' end
		+ case when AppearanceDisheveled = ''Y'' then ''Disheveled, '' else '''' end
		+ case when AppearanceMalodorous = ''Y'' then ''Malodorous, '' else '''' end
		+ case when AppearanceUnusual = ''Y'' then ''Unusual, '' else '''' end
		+ case when AppearancePoorlyGroomed = ''Y'' then ''Poorly Groomed'' else '''' end as Appearance,
	case when AgeNA = ''Y'' then ''N/A, '' else '''' end
		+ case when AgeAppropriate = ''Y'' then ''Appropriate, '' else '''' end
		+ case when AgeOlder = ''Y'' then ''Older, '' else '''' end
		+ case when AgeYounger = ''Y'' then ''Younger, '' else '''' end as Age,
	case when BehaviorNA = ''Y'' then ''N/A, '' else '''' end
		+ case when BehaviorPleasant = ''Y'' then ''Pleasant, '' else '''' end
		+ case when BehaviorGuarded = ''Y'' then ''Guarded, '' else '''' end
		+ case when BehaviorAgitated = ''Y'' then ''Agitated, '' else '''' end
		+ case when BehaviorImpulsive = ''Y'' then ''Impulsive, '' else '''' end
		+ case when BehaviorWithdrawn = ''Y'' then ''Withdrawn, '' else '''' end
		+ case when BehaviorUncooperative = ''Y'' then ''Uncooperative, '' else '''' end
		+ case when BehaviorAggressive = ''Y'' then ''Aggressive'' else '''' end as Behavior,
	case when PsychomotorNA = ''Y'' then ''N/A, '' else '''' end
		+ case when PsychomotorNoAbnormalMovements = ''Y'' then ''No abnormal movements observed, '' else '''' end
		+ case when PsychomotorAgitation = ''Y'' then ''Agitation, '' else '''' end
		+ case when PsychomotorAbnormalMovements = ''Y'' then ''AbnormalMovements, '' else '''' end
		+ case when PsychomotorRetardation = ''Y'' then ''Retardation'' else '''' end as Psychommotor,
	case when MoodNA = ''Y'' then ''N/A, '' else '''' end
		+ case when MoodEuthymic = ''Y'' then ''Euthymic, '' else '''' end
		+ case when MoodDysphoric = ''Y'' then ''Dysphoric, '' else '''' end
		+ case when MoodIrritable = ''Y'' then ''Irritable, '' else '''' end
		+ case when MoodDepressed = ''Y'' then ''Depressed, '' else '''' end
		+ case when MoodExpansive = ''Y'' then ''Expansive, '' else '''' end
		+ case when MoodAnxious = ''Y'' then ''Anxious, '' else '''' end
		+ case when MoodElevated = ''Y'' then ''Elevated'' else '''' end as Mood,
	case when ThoughtContentNA = ''Y'' then ''N/A, '' else '''' end
		+ case when ThoughtContentWithinLimits = ''Y'' then ''Within normal limits, '' else '''' end
		+ case when ThoughtContentExcessiveWorries = ''Y'' then ''Excessive worries, '' else '''' end
		+ case when ThoughtContentOvervaluedIdeas = ''Y'' then ''Overvalued ideas, '' else '''' end
		+ case when ThoughtContentRuminations = ''Y'' then ''Ruminations, '' else '''' end
		+ case when ThoughtContentPhobias = ''Y'' then ''Phobias'' else '''' end as ThoughtContent,
	case when DelusionsNA = ''Y'' then ''N/A, '' else '''' end
		+ case when DelusionsNone = ''Y'' then ''None, '' else '''' end
		+ case when DelusionsBizarre = ''Y'' then ''Bizarre, '' else '''' end
		+ case when DelusionsReligious = ''Y'' then ''Religious, '' else '''' end
		+ case when DelusionsGrandiose = ''Y'' then ''Grandiose, '' else '''' end
		+ case when DelusionsParanoid = ''Y'' then ''Paranoid'' else '''' end as Delusions,
	case when ThoughtProcessNA = ''Y'' then ''N/A, '' else '''' end
		+ case when ThoughtProcessLogical = ''Y'' then ''Logical, '' else '''' end
		+ case when ThoughtProcessCircumferential = ''Y'' then ''Circumferential, '' else '''' end
		+ case when ThoughtProcessFlightIdeas = ''Y'' then ''FlightIdeas, '' else '''' end
		+ case when ThoughtProcessIllogical = ''Y'' then ''Illogical, '' else '''' end
		+ case when ThoughtProcessDerailment = ''Y'' then ''Derailment, '' else '''' end
		+ case when ThoughtProcessTangential = ''Y'' then ''Tangential, '' else '''' end
		+ case when ThoughtProcessSomatic = ''Y'' then ''Somatic, '' else '''' end
		+ case when ThoughtProcessCircumstantial = ''Y'' then ''Circumstantial'' else '''' end as ThoughtProcess,
	case when HallucinationsNA = ''Y'' then ''N/A, '' else '''' end
		+ case when HallucinationsNone = ''Y'' then ''None, '' else '''' end
		+ case when HallucinationsAuditory = ''Y'' then ''Auditory, '' else '''' end
		+ case when HallucinationsVisual = ''Y'' then ''Visual, '' else '''' end
		+ case when HallucinationsTactile = ''Y'' then ''Tactile, '' else '''' end
		+ case when HallucinationsOlfactory = ''Y'' then ''Olfactory'' else '''' end as Hallucinations,
	case when IntellectNA = ''Y'' then ''N/A, '' else '''' end
		+ case when IntellectAverage = ''Y'' then ''Average, '' else '''' end
		+ case when IntellectAboveAverage = ''Y'' then ''Above average, '' else '''' end
		+ case when IntellectBelowAverage = ''Y'' then ''Below average'' else '''' end as Intellect,
	case when SpeechNA = ''Y'' then ''N/A, '' else '''' end 
		+ case SpeechArticulation when ''N'' then ''Normal articulation, '' when ''A'' then ''Abnormal articulation, '' else '''' end
		+ case SpeechRate when ''N'' then ''Normal rate, '' when ''A'' then ''Abnormal rate, '' else '''' end
		+ case SpeechTone when ''N'' then ''Normal tone, '' when ''A'' then ''Abnormal tone, '' else '''' end
		+ case SpeechVolume when ''N'' then ''Normal volume, '' when ''A'' then ''Abnormal volume, '' else '''' end as Speech,
	case when AffectNA = ''Y'' then ''N/A, '' else '''' end
		+ case when AffectCongruent = ''Y'' then ''Congruent, '' else '''' end
		+ case when AffectReactive = ''Y'' then ''Reactive, '' else '''' end
		+ case when AffectIncongruent = ''Y'' then ''Incongruent, '' else '''' end
		+ case when AffectLabile = ''Y'' then ''Labile'' else '''' end as Affect,
	case when RangeNA = ''Y'' then ''N/A, '' else '''' end
		+ case when RangeBroad = ''Y'' then ''Broad, '' else '''' end
		+ case when RangeBlunted = ''Y'' then ''Blunted, '' else '''' end
		+ case when RangeFlat = ''Y'' then ''Flat, '' else '''' end
		+ case when RangeFull = ''Y'' then ''Full, '' else '''' end
		+ case when RangeConstricted = ''Y'' then ''Constricted'' else '''' end as [Range],
	case when InsightNA = ''Y'' then ''N/A, '' else '''' end
		+ case when InsightExcellent = ''Y'' then ''Excellent, '' else '''' end
		+ case when InsightGood = ''Y'' then ''Good, '' else '''' end
		+ case when InsightFair = ''Y'' then ''Fair, '' else '''' end
		+ case when InsightPoor = ''Y'' then ''Poor, '' else '''' end
		+ case when InsightImpaired = ''Y'' then ''Impaired, '' else '''' end
		+ case when InsightUnknown = ''Y'' then ''Unknown'' else '''' end as Insight,
	case when JudgmentNA = ''Y'' then ''N/A, '' else '''' end
		+ case when JudgmentExcellent = ''Y'' then ''Excellent, '' else '''' end
		+ case when JudgmentGood = ''Y'' then ''Good, '' else '''' end
		+ case when JudgmentFair = ''Y'' then ''Fair, '' else '''' end
		+ case when JudgmentPoor = ''Y'' then ''Poor, '' else '''' end
		+ case when JudgmentImpaired = ''Y'' then ''Impaired, '' else '''' end
		+ case when JudgmentUnknown = ''Y'' then ''Unknown'' else '''' end as Judgment,
	case when MemoryNA = ''Y'' then ''N/A, '' else '''' end 
		+ case MemoryAttention when ''I'' then ''Attention intact, '' when ''M'' then ''Attention impaired, '' else '''' end
		+ case MemoryLongTerm when ''I'' then ''Long-term memory intact, '' when ''M'' then ''Long-term memory impaired, '' else '''' end
		+ case MemoryShortTerm when ''I'' then ''Short-term memory intact, '' when ''M'' then ''Short-term memory impaired, '' else '''' end
	as Memory,
	case when BodyHabitusNA = ''Y'' then ''N/A, '' else '''' end
		+ case when BodyHabitusAverage = ''Y'' then ''Average, '' else '''' end
		+ case when BodyHabitusThin = ''Y'' then ''Thin, '' else '''' end
		+ case when BodyHabitusUnderweight = ''Y'' then ''Underweight, '' else '''' end
		+ case when BodyHabitusOverweight = ''Y'' then ''Overweight, '' else '''' end
		+ case when BodyHabitusObese = ''Y'' then ''Obese'' else '''' end as BodyHabitus,
		ConsciousnessComment,
		EyeContactComment,
		AppearanceComment,
		AgeComment,
		BehaviorComment,
		PsychomotorComment,
		MoodComment,
		ThoughtContentComment,
		DelusionsComment,
		ThoughtProcessComment,
		HallucinationsComment,
		IntellectComment,
		SpeechComment,
		AffectComment,
		RangeComment,
		InsightComment,
		JudgmentComment,
		MemoryComment,
		BodyHabitusComment	
	from CustomDocumentMentalStatuses where  DocumentVersionId = @DocumentVersionId
) as a		
	

' 
END
GO
