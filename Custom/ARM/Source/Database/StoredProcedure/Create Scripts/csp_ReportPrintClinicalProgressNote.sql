/****** Object:  StoredProcedure [dbo].[csp_ReportPrintClinicalProgressNote]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintClinicalProgressNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintClinicalProgressNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintClinicalProgressNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

Create Procedure [dbo].[csp_ReportPrintClinicalProgressNote] (
	@DocumentVersionId int
	)
AS
BEGIN

SELECT b.[ClientId],
	a.[DocumentVersionId],a.[CreatedBy],a.[CreatedDate],
	a.[ModifiedBy],a.[ModifiedDate],a.[RecordDeleted],
	a.[DeletedBy],a.[DeletedDate],a.[PatientName],
	a.[DateOfService],a.[StaffName],a.[Degree],
	a.[BeginTime],a.[Duration],a.[DurationType],
	a.[ProcedureCode],a.[MannerOfContact],
	[MentalHealth] = CASE WHEN IsNull(a.[MentalHealth],''N'') = ''Y'' THEN ''Mental Health'' ELSE '''' END,
	[Vacation] = CASE WHEN IsNull(a.[Vacation],''N'') = ''Y'' THEN ''Vacation'' ELSE '''' END,
	[Housing] = CASE WHEN IsNull(a.[Housing],''N'') = ''Y'' THEN ''Housing'' ELSE '''' END,
	[CrisisPrevention] = CASE WHEN IsNull(a.[CrisisPrevention],''N'') = ''Y'' THEN ''Crisis Prevention'' ELSE '''' END,
	[Financial] = CASE WHEN IsNull(a.[Financial],''N'') = ''Y'' THEN ''Financial'' ELSE '''' END,
	[SocialSupport] = CASE WHEN IsNull(a.[SocialSupport],''N'') = ''Y'' THEN ''Social Support'' ELSE '''' END,
	[Leisure] = CASE WHEN IsNull(a.[Leisure],''N'') = ''Y'' THEN ''Leisure'' ELSE '''' END,
	[Guarded] = CASE WHEN IsNull(a.[Guarded],''N'') = ''Y'' THEN ''Guarded'' ELSE '''' END,
	[UnderInfluence] = CASE WHEN IsNull(a.[UnderInfluence],''N'') = ''Y'' THEN ''Under Influence'' ELSE '''' END,
	[Cooperative] = CASE WHEN IsNull(a.[Cooperative],''N'') = ''Y'' THEN ''Cooperative'' ELSE '''' END,
	[Hallucinations] = CASE WHEN IsNull(a.[Hallucinations],''N'') = ''Y'' THEN ''Hallucinations'' ELSE '''' END,
	[Withdrawn] = CASE WHEN IsNull(a.[Withdrawn],''N'') = ''Y'' THEN ''Withdrawn'' ELSE '''' END,
	[Provocative] = CASE WHEN IsNull(a.[Provocative],''N'') = ''Y'' THEN ''Provocative'' ELSE '''' END,
	[Pleasant] = CASE WHEN IsNull(a.[Pleasant],''N'') = ''Y'' THEN ''Pleasant'' ELSE '''' END,
	[Delusions] = CASE WHEN IsNull(a.[Delusions],''N'') = ''Y'' THEN ''Delusions'' ELSE '''' END,
	[NonCompliant] = CASE WHEN IsNull(a.[NonCompliant],''N'') = ''Y'' THEN ''Non Compliant'' ELSE '''' END,
	[Manipulative] = CASE WHEN IsNull(a.[Manipulative],''N'') = ''Y'' THEN ''Manipulative'' ELSE '''' END,
	[Hyperactive] = CASE WHEN IsNull(a.[Hyperactive],''N'') = ''Y'' THEN ''Hyperactive'' ELSE '''' END,
	[NotObservedBehavior] = CASE WHEN IsNull(a.[NotObservedBehavior],''N'') = ''Y'' THEN ''Not Observed Behavior'' ELSE '''' END,
	[Hostile] = CASE WHEN IsNull(a.[Hostile],''N'') = ''Y'' THEN ''Hostile'' ELSE '''' END,
	[Suspicious] = CASE WHEN IsNull(a.[Suspicious],''N'') = ''Y'' THEN ''Suspicious'' ELSE '''' END,
	[Hypoactive] = CASE WHEN IsNull(a.[Hypoactive],''N'') = ''Y'' THEN ''Hypoactive'' ELSE '''' END,
	[OtherBehavior] = CASE WHEN IsNull(a.[OtherBehavior],''N'') = ''Y'' THEN ''Other Behavior'' ELSE '''' END,
	[OtherBehaviorDescription] = CASE WHEN IsNull(a.[OtherBehaviorDescription],''N'') = ''Y'' THEN ''Other BehaviorDescription'' ELSE '''' END,
	[Appropriate] = CASE WHEN IsNull(a.[Appropriate],''N'') = ''Y'' THEN ''Appropriate'' ELSE '''' END,
	[Euphoric] = CASE WHEN IsNull(a.[Euphoric],''N'') = ''Y'' THEN ''Euphoric'' ELSE '''' END,
	[Angry] = CASE WHEN IsNull(a.[Angry],''N'') = ''Y'' THEN ''Angry'' ELSE '''' END,
	[Depressed] = CASE WHEN IsNull(a.[Depressed],''N'') = ''Y'' THEN ''Depressed'' ELSE '''' END,
	[Incongruent] = CASE WHEN IsNull(a.[Incongruent],''N'') = ''Y'' THEN ''Incongruent'' ELSE '''' END,
	[Flat] = CASE WHEN IsNull(a.[Flat],''N'') = ''Y'' THEN ''Flat'' ELSE '''' END,
	[Suicidal] = CASE WHEN IsNull(a.[Suicidal],''N'') = ''Y'' THEN ''Suicidal'' ELSE '''' END,
	[Fearful] = CASE WHEN IsNull(a.[Fearful],''N'') = ''Y'' THEN ''Fearful'' ELSE '''' END,
	[NotObservedMood] = CASE WHEN IsNull(a.[NotObservedMood],''N'') = ''Y'' THEN ''Not Observed Mood'' ELSE '''' END,
	[Anxious] = CASE WHEN IsNull(a.[Anxious],''N'') = ''Y'' THEN ''Anxious'' ELSE '''' END,
	[Irritable] = CASE WHEN IsNull(a.[Irritable],''N'') = ''Y'' THEN ''Irritable'' ELSE '''' END,
	[OtherMood] = CASE WHEN IsNull(a.[OtherMood],''N'') = ''Y'' THEN ''Other Mood'' ELSE '''' END,
	a.[OtherMoodDescription],a.[ISPReviewed],a.[OutcomesUsed],
	a.[Intervention],a.[ClientResponse],a.[ProgressRating],
	a.[VitalBP],a.[VitalP],a.[VitalR],
	a.[VitalHt],a.[VitalWt],a.[ClassroomNumber],
	a.[DACClassroomNumber],a.[QuaterOfYear],a.[WeekNumber],
	a.[Score],a.[SessionNumber],a.[Crisis],
	a.[MentalStatusSummary],a.[PastAttemptSelf],a.[PastAttemptOthers],
	a.[Past_Attempt_None],a.[PastAttemptComments],a.[CurrentRiskSelf],
	a.[Current_Risk_None],a.[CurrentRiskSelfComments],a.[CurrentRiskOthers],
	a.[CurrentRiskOthersComments],a.[Medications],a.[MedicationsNone],
	a.[OtherMentalHealthTreatmentHistory],a.[PrimarySupport],a.[DailyLiving],
	ISNULL(a.Intervention, a.[InterventionsProvided]) as InterventionsProvided,a.[TreatmentRecommendations],a.[WishesParent],
	a.[Stabilization],a.[AppropriateCare],a.[AssureSafety],
	a.[OtherGoal],a.[OtherGoalDescription],a.[AdultProtectiveServices],
	a.[ChildrenServices],a.[CommunityCupport],a.[DropInCenter],
	a.[DiagnosticAccessment],a.[EmergencyFollowUp],a.[MentalHealthCounseling],
	a.[PsychiatricEvaluation],a.[SubstanceAbuseCounseling],a.[ShelterHousing],
	a.[Other1],a.[Other1Description],a.[Other2],
	a.[Other2Description],a.[Other3],a.[Other3Description],
	a.[Other4],a.[Other4Description],a.[AdmitHospital],
	a.[HospitalName],a.[OtherHospital],a.[AdmitType],
	a.[AdmitHospitalComment],a.[AdmitCrisis],a.[AdmitCrisisName],
	a.[AdmitCrisisComment],a.[MedicalEvaluation],a.[MedicalEvaluationComment],
	a.[CommunityBehavioralHealthServices],a.[CommunityBehavioralHealthServicesComment],a.[ContractSafety],
	a.[ContractSafetyComment],a.[SelfHelpGroup],a.[SelfHelpGroupComment],
	a.[AbstainAlcohol],a.[AbstainAlcoholComment],a.[DutyToWarn],
	a.[DutyToWarnComment],a.[OtherInstructions],a.[OtherInstructionsComment],
	a.[ReferMSE],a.[CurrentRiskOthersNone],a.[Residential],
	a.[AdmitCrisisOther],a.[PartialHospitalizationClientWithdrawn],a.[PartialHospitalizationStartTime1],
	a.[PartialHospitalizationStartTimeAMPM1],a.[PartialHospitalizationEndTime1],a.[PartialHospitalizationEndTimeAMPM1],
	a.[OtherService1],a.[OtherServiceStartTime1],a.[OtherServiceStartTimeAMPM1],
	a.[OtherServiceEndTime1],a.[OtherServiceEndTimeAMPM1],a.[PartialHospitalizationStartTime2],
	a.[PartialHospitalizationStartTimeAMPM2],a.[PartialHospitalizationEndTime2],a.[PartialHospitalizationEndTimeAMPM2],
	a.[OtherService2],a.[OtherServiceStartTime2],a.[OtherServiceStartTimeAMPM2],
	a.[OtherServiceEndTime2],a.[OtherServiceEndTimeAMPM2],a.[PartialHospitalizationStartTime3],
	a.[PartialHospitalizationStartTimeAMPM3],a.[PartialHospitalizationEndTime3],a.[PartialHospitalizationEntTimeAMPM3],
	a.[OtherService3],a.[OtherServiceStartTime3],a.[OtherServiceStartTimeAMPM3],
	a.[OtherServiceEndTime3],a.[OtherServiceEndTimeAMPM3],a.[ParticipantsNumber],
	a.[SignificantEvents],a.[SignificantEventsNone],a.[SignificantEventsItem],
	a.[SignificantEventsImpact],a.[Wellness]
FROM CustomDocumentClinicalProgressNotes a
JOIN Documents b ON a.DocumentVersionId = b.CurrentDocumentVersionId
WHERE DocumentVersionId = @DocumentVersionId
AND IsNull(a.RecordDeleted,''N'') <> ''Y''
AND IsNull(b.RecordDeleted,''N'') <> ''Y''



END

' 
END
GO
