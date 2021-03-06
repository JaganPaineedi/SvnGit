/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomCrisisInterventionNotes]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomCrisisInterventionNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomCrisisInterventionNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomCrisisInterventionNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_SCGetCustomCrisisInterventionNotes]
@DocumentVersionId INT
AS
BEGIN

 BEGIN TRY

 SELECT
	DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedDate,
	ModifiedBy,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	PresentingCrisisImmediateNeeds,
	UseOfAlcholDrugsImpactingCrisis,
	CrisisInThePast,
	CrisisInThePastHowPreviouslyStabilized,
	CrisisInThePastIssuesSinceStabilization,
	PastAttemptsHarmNone,
	PastAttemptsHarmSelf,
	PastAttemptsHarmOthers,
	PastAttemptsHarmComment,
	CurrentRiskHarmSelf,
	CurrentRiskHarmSelfComment,
	CurrenRiskHarmOthers,
	CurrentRiskHarmOthersComment,
	MedicalConditionsImpactingCrisis,
	ClientCurrentlyPrescribedMedications,
	ClientComplyingWithMedications,
	CurrentLivingSituationAndSupportSystems,
	ClientStrengthsDealingWithCrisis,
	CrisisDeEscalationInterventionsProvided,
	CrisisPlanTreatmentRecommended,
	WishesPreferencesOfIndividual,
	ReferredVoluntaryHospitalization,
	ReferredInvoluntaryHospitalization,
	ReferralHarborServicesType,
	ReferralHarborServicesComment,
	ReferralExternalServicesType,
	ReferralExternalServicesComment,
	FollowUpInstructions,
	CrisisWasResolved,
	PlanToAvoidCrisisRecurrence
 FROM       [dbo].[CustomDocumentCrisisInterventionNotes]
 WHERE     (ISNULL(RecordDeleted, ''N'') = ''N'') AND ([DocumentVersionId] = @DocumentVersionId)

 SELECT
	DocumentVersionId,
	CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	RecordDeleted,
	DeletedBy,
	DeletedDate,
	ConsciousnessNA,
	ConsciousnessAlert,
	ConsciousnessObtunded,
	ConsciousnessSomnolent,
	ConsciousnessOrientedX3,
	ConsciousnessAppearsUnderInfluence,
	ConsciousnessComment,
	EyeContactNA,
	EyeContactAppropriate,
	EyeContactStaring,
	EyeContactAvoidant,
	EyeContactComment,
	AppearanceNA,
	AppearanceClean,
	AppearanceNeatlyDressed,
	AppearanceAppropriate,
	AppearanceDisheveled,
	AppearanceMalodorous,
	AppearanceUnusual,
	AppearancePoorlyGroomed,
	AppearanceComment,
	AgeNA,
	AgeAppropriate,
	AgeOlder,
	AgeYounger,
	AgeComment,
	BehaviorNA,
	BehaviorPleasant,
	BehaviorGuarded,
	BehaviorAgitated,
	BehaviorImpulsive,
	BehaviorWithdrawn,
	BehaviorUncooperative,
	BehaviorAggressive,
	BehaviorComment,
	PsychomotorNA,
	PsychomotorNoAbnormalMovements,
	PsychomotorAgitation,
	PsychomotorAbnormalMovements,
	PsychomotorRetardation,
	PsychomotorComment,
	MoodNA,
	MoodEuthymic,
	MoodDysphoric,
	MoodIrritable,
	MoodDepressed,
	MoodExpansive,
	MoodAnxious,
	MoodElevated,
	MoodComment,
	ThoughtContentNA,
	ThoughtContentWithinLimits,
	ThoughtContentExcessiveWorries,
	ThoughtContentOvervaluedIdeas,
	ThoughtContentRuminations,
	ThoughtContentPhobias,
	ThoughtContentComment,
	DelusionsNA,
	DelusionsNone,
	DelusionsBizarre,
	DelusionsReligious,
	DelusionsGrandiose,
	DelusionsParanoid,
	DelusionsComment,
	ThoughtProcessNA,
	ThoughtProcessLogical,
	ThoughtProcessCircumferential,
	ThoughtProcessFlightIdeas,
	ThoughtProcessIllogical,
	ThoughtProcessDerailment,
	ThoughtProcessTangential,
	ThoughtProcessSomatic,
	ThoughtProcessCircumstantial,
	ThoughtProcessComment,
	HallucinationsNA,
	HallucinationsNone,
	HallucinationsAuditory,
	HallucinationsVisual,
	HallucinationsTactile,
	HallucinationsOlfactory,
	HallucinationsComment,
	IntellectNA,
	IntellectAverage,
	IntellectAboveAverage,
	IntellectBelowAverage,
	IntellectComment,
	SpeechNA,
	SpeechRate,
	SpeechTone,
	SpeechVolume,
	SpeechArticulation,
	SpeechComment,
	AffectNA,
	AffectCongruent,
	AffectReactive,
	AffectIncongruent,
	AffectLabile,
	AffectComment,
	RangeNA,
	RangeBroad,
	RangeBlunted,
	RangeFlat,
	RangeFull,
	RangeConstricted,
	RangeComment,
	InsightNA,
	InsightExcellent,
	InsightGood,
	InsightFair,
	InsightPoor,
	InsightImpaired,
	InsightUnknown,
	InsightComment,
	JudgmentNA,
	JudgmentExcellent,
	JudgmentGood,
	JudgmentFair,
	JudgmentPoor,
	JudgmentImpaired,
	JudgmentUnknown,
	JudgmentComment,
	MemoryNA,
	MemoryShortTerm,
	MemoryLongTerm,
	MemoryAttention,
	MemoryComment,
	BodyHabitusNA,
	BodyHabitusAverage,
	BodyHabitusThin,
	BodyHabitusUnderweight,
	BodyHabitusOverweight,
	BodyHabitusObese,
	BodyHabitusComment
FROM [dbo].[CustomDocumentMentalStatuses]
WHERE     ([DocumentVersionId] = @DocumentVersionId)




END TRY

BEGIN CATCH
 DECLARE @Error VARCHAR(8000)
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
			+ ''*****'' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),''csp_SCGetCustomCrisisInterventionNotes'')
			+ ''*****'' + CONVERT(VARCHAR,ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR,ERROR_SEVERITY())
			+ ''*****'' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
END
' 
END
GO
