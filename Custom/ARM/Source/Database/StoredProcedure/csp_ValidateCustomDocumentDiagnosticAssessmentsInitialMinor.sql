IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor]
	@DocumentVersionId int
as

/*
DATE		 USER		TASK					COMMENT
05/10/2013   DVeale		ARM Customization #16	Removed "current risk identified must be answered" and "primary clinician assignment section is required"  

*/

declare @ClientAge int
select @ClientAge = dbo.GetAge(c.dob, d.EffectiveDate)
from dbo.DocumentVersions as dv
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Clients as c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId


Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Presenting problem: Presenting problem is required', 1, 1
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(PresentingProblem, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Presenting problem: Guardian info is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where [ClientHasLegalGuardian] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([LegalGuardianInfo], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Abilities, Interests, Skills entry is required', 2, 1
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([AbilitiesInterestsSkills], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Family History entry is required', 2, 2
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([FamilyHistory], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Ethnicity, cultural background and beliefs entry is required', 2, 3
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([EthnicityCulturalBackground], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Sexual orientation and gender expression entry is required', 2, 4
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([SexualOrientationGenderExpression], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: "Is the client''s gender expression consistent..." entry is required', 2, 5
from #CustomDocumentDiagnosticAssessments
where [GenderExpressionConsistent] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Support systems entry is required', 2, 6
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([SupportSystems], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Living situation entry is required', 2, 8
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([LivingSituation], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Client employment/military history entry is required', 2, 9
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([ClientEmploymentMilitaryHistory], '')))) = 0 and ISNULL(ClientEmploymentNotApplicable, 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Legal involvement indicator is required', 2, 10
from #CustomDocumentDiagnosticAssessments
where [LegalInvolvement] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Legal involvement info is required', 2, 11
from #CustomDocumentDiagnosticAssessments
where [LegalInvolvement] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([LegalInvolvementComment], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: History of emotional/behavioral problems entry is required', 2, 12
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([HistoryEmotionalProblemsClient], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Reported prior diagnosis is required', 2, 13
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientPriorTreatmentDiagnosis], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: At least one type of prior treatment is required', 2, 14
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and isnull([PriorTreatmentCounseling], 'N') <> 'Y'
and isnull([PriorTreatmentCaseManagement], 'N') <> 'Y'
and isnull([PriorTreatmentOther], 'N') <> 'Y'
and isnull([PriorTreatmentMedication], 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Types of Medication and Results entry is required', 2, 15
from #CustomDocumentDiagnosticAssessments
where [PriorTreatmentMedication] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([TypesOfMedicationResults], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Adjustment to/acceptance of prior diagnosis is required', 2, 16
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and ISNULL([ClientResponsePastTreatmentNA], 'N') <> 'Y'
and [ClientResponsePastTreatment] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: History of abuse selection is required', 2, 17
from #CustomDocumentDiagnosticAssessments
where isnull([AbuseNotApplicable], 'N') <> 'Y' and
isnull([AbuseEmotionalVictim], 'N') <> 'Y' and
isnull([AbuseEmotionalOffender], 'N') <> 'Y' and
isnull([AbuseVerbalVictim], 'N') <> 'Y' and
isnull([AbuseVerbalOffender], 'N') <> 'Y' and
isnull([AbusePhysicalVictim], 'N') <> 'Y' and
isnull([AbusePhysicalOffender], 'N') <> 'Y' and
isnull([AbuseSexualVictim], 'N') <> 'Y' and
isnull([AbuseSexualOffender], 'N') <> 'Y' and
isnull([AbuseNeglectVictim], 'N') <> 'Y' and
isnull([AbuseNeglectOffender], 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Abuse comments required', 2, 18
from #CustomDocumentDiagnosticAssessments
where (
	[AbuseEmotionalVictim] = 'Y' or
	[AbuseEmotionalOffender] = 'Y' or
	[AbuseVerbalVictim] = 'Y' or
	[AbuseVerbalOffender] = 'Y' or
	[AbusePhysicalVictim] = 'Y' or
	[AbusePhysicalOffender] = 'Y' or
	[AbuseSexualVictim] = 'Y' or
	[AbuseSexualOffender] = 'Y' or
	[AbuseNeglectVictim] = 'Y' or
	[AbuseNeglectOffender] = 'Y'
)
and LEN(LTRIM(RTRIM(ISNULL([AbuseComment], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Explanation of substance use is required', 2, 19
from #CustomDocumentDiagnosticAssessments
where [ClientReportAlcoholTobaccoDrugUse] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientReportDrugUseComment], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Explanation of substance use is required', 2, 20
from #CustomDocumentDiagnosticAssessments
where [ClientReportAlcoholTobaccoDrugUse] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientReportDrugUseComment], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Alcohol info is incomplete.', 2, 21
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (AlcoholUseWithin30Days = 'Y' and AlcoholUseCurrentFrequency is null)
	or (AlcoholUseWithinLifetime = 'Y' and AlcoholUsePastFrequency is null)
	or ((AlcoholUseWithin30Days = 'Y' or AlcoholUseWithinLifetime = 'Y') and (AlcoholUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Cocaine info is incomplete.', 2, 22
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (CocaineUseWithin30Days = 'Y' and CocaineUseCurrentFrequency is null)
	or (CocaineUseWithinLifetime = 'Y' and CocaineUsePastFrequency is null)
	or ((CocaineUseWithin30Days = 'Y' or CocaineUseWithinLifetime = 'Y') and (CocaineUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Sedative info is incomplete.', 2, 23
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (SedtativeUseWithin30Days = 'Y' and SedtativeUseCurrentFrequency is null)
	or (SedtativeUseWithinLifetime = 'Y' and SedtativeUsePastFrequency is null)
	or ((SedtativeUseWithin30Days = 'Y' or SedtativeUseWithinLifetime = 'Y') and (SedtativeUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Hallucinogen info is incomplete.', 2, 24
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (HallucinogenUseWithin30Days = 'Y' and HallucinogenUseCurrentFrequency is null)
	or (HallucinogenUseWithinLifetime = 'Y' and HallucinogenUsePastFrequency is null)
	or ((HallucinogenUseWithin30Days = 'Y' or HallucinogenUseWithinLifetime = 'Y') and (HallucinogenUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Stimulant info is incomplete.', 2, 25
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (StimulantUseWithin30Days = 'Y' and StimulantUseCurrentFrequency is null)
	or (StimulantUseWithinLifetime = 'Y' and StimulantUsePastFrequency is null)
	or ((StimulantUseWithin30Days = 'Y' or StimulantUseWithinLifetime = 'Y') and (StimulantUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Narcotic info is incomplete.', 2, 26
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (NarcoticUseWithin30Days = 'Y' and NarcoticUseCurrentFrequency is null)
	or (NarcoticUseWithinLifetime = 'Y' and NarcoticUsePastFrequency is null)
	or ((NarcoticUseWithin30Days = 'Y' or NarcoticUseWithinLifetime = 'Y') and (NarcoticUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Marijuana info is incomplete.', 2, 27
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (MarijuanaUseWithin30Days = 'Y' and MarijuanaUseCurrentFrequency is null)
	or (MarijuanaUseWithinLifetime = 'Y' and MarijuanaUsePastFrequency is null)
	or ((MarijuanaUseWithin30Days = 'Y' or MarijuanaUseWithinLifetime = 'Y') and (MarijuanaUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Inhalants info is incomplete.', 2, 28
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (InhalantsUseWithin30Days = 'Y' and InhalantsUseCurrentFrequency is null)
	or (InhalantsUseWithinLifetime = 'Y' and InhalantsUsePastFrequency is null)
	or ((InhalantsUseWithin30Days = 'Y' or InhalantsUseWithinLifetime = 'Y') and (InhalantsUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Other substance info is incomplete.', 2, 29
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (OtherUseWithin30Days = 'Y' and OtherUseCurrentFrequency is null)
	or (OtherUseWithinLifetime = 'Y' and OtherUsePastFrequency is null)
	or ((OtherUseWithin30Days = 'Y' or OtherUseWithinLifetime = 'Y') and (OtherUseReceivedTreatment is null))
	
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Other substance name required.', 2, 30
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (OtherUseWithin30Days = 'Y' and OtherUseCurrentFrequency is null)
	or (OtherUseWithinLifetime = 'Y' and OtherUsePastFrequency is null)
	or ((OtherUseWithin30Days = 'Y' or OtherUseWithinLifetime = 'Y') and (OtherUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: Other substance name required.', 2, 31
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (OtherUseWithin30Days = 'Y' and OtherUseType is null)
	or (OtherUseWithinLifetime = 'Y' and OtherUseType is null)
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance use: At least one substance from the list must be specified.', 2, 32
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and [FurtherSubstanceAssessmentIndicated] = 'Y' and
isnull(AlcoholUseWithin30Days, 'N') <> 'Y' and
isnull(AlcoholUseWithinLifetime, 'N') <> 'Y' and
isnull(CocaineUseWithin30Days, 'N') <> 'Y' and
isnull(CocaineUseWithinLifetime, 'N') <> 'Y' and
isnull(SedtativeUseWithin30Days, 'N') <> 'Y' and
isnull(SedtativeUseWithinLifetime, 'N') <> 'Y' and
isnull(HallucinogenUseWithin30Days, 'N') <> 'Y' and
isnull(HallucinogenUseWithinLifetime, 'N') <> 'Y' and
isnull(StimulantUseWithin30Days, 'N') <> 'Y' and
isnull(StimulantUseWithinLifetime, 'N') <> 'Y' and
isnull(NarcoticUseWithin30Days, 'N') <> 'Y' and
isnull(NarcoticUseWithinLifetime, 'N') <> 'Y' and
isnull(MarijuanaUseWithin30Days, 'N') <> 'Y' and
isnull(MarijuanaUseWithinLifetime, 'N') <> 'Y' and
isnull(InhalantsUseWithin30Days, 'N') <> 'Y' and
isnull(InhalantsUseWithinLifetime, 'N') <> 'Y' and
isnull(OtherUseWithin30Days, 'N') <> 'Y' and
isnull(OtherUseWithinLifetime, 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Ideation comment is required', 2, 33
from #CustomDocumentDiagnosticAssessments
where RiskSuicideIdeation = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIdeationComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Suicide intent comment is required', 2, 34
from #CustomDocumentDiagnosticAssessments
where RiskSuicideIntent = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIntentComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Suicide prior attempts comment is required', 2, 35
from #CustomDocumentDiagnosticAssessments
where RiskSuicidePriorAttempts = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskSuicidePriorAttemptsComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Prior hospitalization comment is required', 2, 36
from #CustomDocumentDiagnosticAssessments
where RiskPriorHospitalization = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPriorHospitalizationComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Physical agression to self comment is required', 2, 37
from #CustomDocumentDiagnosticAssessments
where RiskPhysicalAggressionSelf = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionSelfComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Verbal agression to others comment is required', 2, 38
from #CustomDocumentDiagnosticAssessments
where RiskVerbalAggressionOthers = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskVerbalAggressionOthersComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Physical agression to objects comment is required', 2, 39
from #CustomDocumentDiagnosticAssessments
where RiskPhysicalAggressionObjects = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionObjectsComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: Physical agression to people comment is required', 2, 40
from #CustomDocumentDiagnosticAssessments
where RiskPhysicalAggressionPeople = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionPeopleComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: risk taking/agressive behaviors comment is required', 2, 41
from #CustomDocumentDiagnosticAssessments
where RiskReportRiskTaking = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskReportRiskTakingComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk: threats to client''s personal safety comment is required', 2, 42
from #CustomDocumentDiagnosticAssessments
where RiskThreatClientPersonalSafety = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskThreatClientPersonalSafetyComment, '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: "Current risk identified" must be answered.', 2, 43
--from #CustomDocumentDiagnosticAssessments
--where [RiskCurrentRiskIdentified] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Triggers for dangerous behaviors required', 2, 44
from #CustomDocumentDiagnosticAssessments
where [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskTriggersDangerousBehaviors], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Coping skills required', 2, 45
from #CustomDocumentDiagnosticAssessments
where [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskCopingSkills], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Interventions preferred by client/guardian for personal safety required', 2, 46
from #CustomDocumentDiagnosticAssessments
where ISNULL([RiskInterventionsPersonalSafetyNA], 'N') <> 'Y' and [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPersonalSafety], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Interventions preferred by client/guardian for public safety required', 2, 47
from #CustomDocumentDiagnosticAssessments
where ISNULL([RiskInterventionsPublicSafetyNA], 'N') <> 'Y' and [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPublicSafety], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Physical Health: Health assessment comment required', 2, 48
from #CustomDocumentDiagnosticAssessments
where ISNULL([PhysicalProblemsNoneReported], 'N') <> 'Y'
and LEN(LTRIM(RTRIM(ISNULL([PhysicalProblemsComment], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Physical Health: Please specify any special communication or accessibility needs', 2, 49
--from #CustomDocumentDiagnosticAssessments
--where ISNULL([SpecialNeedsNoneReported], 'N') <> 'Y'
--and ISNULL([SpecialNeedsVisualImpairment], 'N') <> 'Y'
--and ISNULL([SpecialNeedsHearingImpairment], 'N') <> 'Y'
--and ISNULL([SpecialNeedsSpeechImpairment], 'N') <> 'Y'
--and ISNULL([SpecialNeedsOtherPhysicalImpairment], 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Physical Health: Please specify any special communication or accessibility needs', 2, 50
from #CustomDocumentDiagnosticAssessments
where ISNULL([SpecialNeedsNoneReported], 'N') <> 'Y'
and ISNULL([SpecialNeedsVisualImpairment], 'N') <> 'Y'
and ISNULL([SpecialNeedsHearingImpairment], 'N') <> 'Y'
and ISNULL([SpecialNeedsSpeechImpairment], 'N') <> 'Y'
and ISNULL([SpecialNeedsOtherPhysicalImpairment], 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Client''s preferences for treatment required', 2, 51
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([ClientPreferencesForTreatment], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Primary clinician assignment selection required', 2, 53
--from #CustomDocumentDiagnosticAssessments
--where [PrimaryClinicianTransfer] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Primary clinician staff selection required', 2, 54
from #CustomDocumentDiagnosticAssessments
where [PrimaryClinicianTransfer] = 'Y'
and [TransferReceivingStaff] is null
-- commented out for now until the application is fixed
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Assessed need for transfer required', 2, 55
--from #CustomDocumentDiagnosticAssessments
--where [PrimaryClinicianTransfer] = 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([TransferAssessedNeed], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Mental Status: Diagnostic impressions / clinical summary required', 2, 56
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([DiagnosticImpressionsSummary], '')))) = 0
-- Strengths are stored in CustomTreatmentPlans
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Initial treatment plan: Strengths required', 2, 57
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL(tp.ClientStrengths, '')))) = 0
and ISNULL(tp.RecordDeleted, 'N') <> 'Y'



