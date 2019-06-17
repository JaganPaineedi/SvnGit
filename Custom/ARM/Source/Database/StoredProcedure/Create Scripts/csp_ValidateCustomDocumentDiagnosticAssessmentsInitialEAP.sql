DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialEAP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialEAP] 
(
	@DocumentVersionId INT
)
AS
/***********************************************************************************************************************
DATE		 USER		TASK					COMMENT
------------ ---------	---------------------	----------------------------------------------------
08/29/2017	 Ting-Yu	ARM - Support # 695		There are multiple instances of error message "Substance use: Other 
												substance name required.", which is causing the system throws 
												JavaScript error "Saved successfully.Error occured while loading screen.
												Please reopen this screen again." 
												Re-phrased the error message to make sure there are unique.
***********************************************************************************************************************/
INSERT INTO #validationReturnTable (
	TableName
	,ColumnName
	,ErrorMessage
	,TabOrder
	,ValidationOrder
	)
SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Presenting problem: Presenting problem is required'
	,1
	,1
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(PresentingProblem, '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Abilities, Interests, Skills entry is required', 2, 1
--from #CustomDocumentDiagnosticAssessments
--where LEN(LTRIM(RTRIM(ISNULL([AbilitiesInterestsSkills], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Family History entry is required', 2, 2
--from #CustomDocumentDiagnosticAssessments
--where LEN(LTRIM(RTRIM(ISNULL([FamilyHistory], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Ethnicity, cultural background and beliefs entry is required', 2, 3
--from #CustomDocumentDiagnosticAssessments
--where LEN(LTRIM(RTRIM(ISNULL([EthnicityCulturalBackground], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Sexual orientation and gender expression entry is required', 2, 4
--from #CustomDocumentDiagnosticAssessments
--where LEN(LTRIM(RTRIM(ISNULL([SexualOrientationGenderExpression], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', '"Psychosocial: Is the client''s gender expression consistent..." entry is required', 2, 5
--from #CustomDocumentDiagnosticAssessments
--where [GenderExpressionConsistent] is null

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Support systems entry is required'
	,2
	,6
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([SupportSystems], '')))) = 0
----union
----select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Client strengths entry is required', 2, 7
----from #CustomDocumentDiagnosticAssessments
----where LEN(LTRIM(RTRIM(ISNULL([ClientStrengths], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Living situation entry is required', 2, 8
--from #CustomDocumentDiagnosticAssessments
--where LEN(LTRIM(RTRIM(ISNULL([LivingSituation], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Client employment/military history entry is required'
	,2
	,9
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([ClientEmploymentMilitaryHistory], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Legal involvement indicator is required'
	,2
	,10
FROM #CustomDocumentDiagnosticAssessments
WHERE [LegalInvolvement] IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Legal involvement details required'
	,2
	,11
FROM #CustomDocumentDiagnosticAssessments
WHERE [LegalInvolvement] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([LegalInvolvementComment], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: History of emotional/behavioral problems entry is required'
	,2
	,12
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([HistoryEmotionalProblemsClient], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Reported prior diagnosis is required'
	,2
	,13
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasReceivedTreatment] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([ClientPriorTreatmentDiagnosis], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: At least one type of prior treatment is required'
	,2
	,14
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasReceivedTreatment] = 'Y'
	AND ISNULL([PriorTreatmentCounseling], 'N') <> 'Y'
	AND ISNULL([PriorTreatmentCaseManagement], 'N') <> 'Y'
	AND ISNULL([PriorTreatmentOther], 'N') <> 'Y'
	AND ISNULL([PriorTreatmentMedication], 'N') <> 'Y'

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Types of Medication and Results entry is required'
	,2
	,15
FROM #CustomDocumentDiagnosticAssessments
WHERE [PriorTreatmentMedication] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([TypesOfMedicationResults], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Psychosocial: Adjustment to/acceptance of prior diagnosis is required', 2, 16
--from #CustomDocumentDiagnosticAssessments
--where [ClientHasReceivedTreatment] = 'Y'
--and ISNULL([ClientResponsePastTreatmentNA], 'N') <> 'Y'
--and [ClientResponsePastTreatment] is null

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: History of abuse selection is required'
	,2
	,17
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL([AbuseNotApplicable], 'N') <> 'Y'
	AND ISNULL([AbuseEmotionalVictim], 'N') <> 'Y'
	AND ISNULL([AbuseEmotionalOffender], 'N') <> 'Y'
	AND ISNULL([AbuseVerbalVictim], 'N') <> 'Y'
	AND ISNULL([AbuseVerbalOffender], 'N') <> 'Y'
	AND ISNULL([AbusePhysicalVictim], 'N') <> 'Y'
	AND ISNULL([AbusePhysicalOffender], 'N') <> 'Y'
	AND ISNULL([AbuseSexualVictim], 'N') <> 'Y'
	AND ISNULL([AbuseSexualOffender], 'N') <> 'Y'
	AND ISNULL([AbuseNeglectVictim], 'N') <> 'Y'
	AND ISNULL([AbuseNeglectOffender], 'N') <> 'Y'

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Psychosocial: Abuse comments required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		[AbuseEmotionalVictim] = 'Y'
		OR [AbuseEmotionalOffender] = 'Y'
		OR [AbuseVerbalVictim] = 'Y'
		OR [AbuseVerbalOffender] = 'Y'
		OR [AbusePhysicalVictim] = 'Y'
		OR [AbusePhysicalOffender] = 'Y'
		OR [AbuseSexualVictim] = 'Y'
		OR [AbuseSexualOffender] = 'Y'
		OR [AbuseNeglectVictim] = 'Y'
		OR [AbuseNeglectOffender] = 'Y'
		)
	AND LEN(LTRIM(RTRIM(ISNULL([AbuseComment], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Alcohol info is incomplete.'
	,2
	,21
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		AlcoholUseWithin30Days = 'Y'
		AND AlcoholUseCurrentFrequency IS NULL
		)
	OR (
		AlcoholUseWithinLifetime = 'Y'
		AND AlcoholUsePastFrequency IS NULL
		)
	OR (
		(
			AlcoholUseWithin30Days = 'Y'
			OR AlcoholUseWithinLifetime = 'Y'
			)
		AND (AlcoholUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Cocaine info is incomplete.'
	,2
	,22
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		CocaineUseWithin30Days = 'Y'
		AND CocaineUseCurrentFrequency IS NULL
		)
	OR (
		CocaineUseWithinLifetime = 'Y'
		AND CocaineUsePastFrequency IS NULL
		)
	OR (
		(
			CocaineUseWithin30Days = 'Y'
			OR CocaineUseWithinLifetime = 'Y'
			)
		AND (CocaineUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Sedative info is incomplete.'
	,2
	,23
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		SedtativeUseWithin30Days = 'Y'
		AND SedtativeUseCurrentFrequency IS NULL
		)
	OR (
		SedtativeUseWithinLifetime = 'Y'
		AND SedtativeUsePastFrequency IS NULL
		)
	OR (
		(
			SedtativeUseWithin30Days = 'Y'
			OR SedtativeUseWithinLifetime = 'Y'
			)
		AND (SedtativeUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Hallucinogen info is incomplete.'
	,2
	,24
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		HallucinogenUseWithin30Days = 'Y'
		AND HallucinogenUseCurrentFrequency IS NULL
		)
	OR (
		HallucinogenUseWithinLifetime = 'Y'
		AND HallucinogenUsePastFrequency IS NULL
		)
	OR (
		(
			HallucinogenUseWithin30Days = 'Y'
			OR HallucinogenUseWithinLifetime = 'Y'
			)
		AND (HallucinogenUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Stimulant info is incomplete.'
	,2
	,25
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		StimulantUseWithin30Days = 'Y'
		AND StimulantUseCurrentFrequency IS NULL
		)
	OR (
		StimulantUseWithinLifetime = 'Y'
		AND StimulantUsePastFrequency IS NULL
		)
	OR (
		(
			StimulantUseWithin30Days = 'Y'
			OR StimulantUseWithinLifetime = 'Y'
			)
		AND (StimulantUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Narcotic info is incomplete.'
	,2
	,26
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		NarcoticUseWithin30Days = 'Y'
		AND NarcoticUseCurrentFrequency IS NULL
		)
	OR (
		NarcoticUseWithinLifetime = 'Y'
		AND NarcoticUsePastFrequency IS NULL
		)
	OR (
		(
			NarcoticUseWithin30Days = 'Y'
			OR NarcoticUseWithinLifetime = 'Y'
			)
		AND (NarcoticUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Marijuana info is incomplete.'
	,2
	,27
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		MarijuanaUseWithin30Days = 'Y'
		AND MarijuanaUseCurrentFrequency IS NULL
		)
	OR (
		MarijuanaUseWithinLifetime = 'Y'
		AND MarijuanaUsePastFrequency IS NULL
		)
	OR (
		(
			MarijuanaUseWithin30Days = 'Y'
			OR MarijuanaUseWithinLifetime = 'Y'
			)
		AND (MarijuanaUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Inhalants info is incomplete.'
	,2
	,28
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		InhalantsUseWithin30Days = 'Y'
		AND InhalantsUseCurrentFrequency IS NULL
		)
	OR (
		InhalantsUseWithinLifetime = 'Y'
		AND InhalantsUsePastFrequency IS NULL
		)
	OR (
		(
			InhalantsUseWithin30Days = 'Y'
			OR InhalantsUseWithinLifetime = 'Y'
			)
		AND (InhalantsUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Other substance info is incomplete.'
	,2
	,29
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		OtherUseWithin30Days = 'Y'
		AND OtherUseCurrentFrequency IS NULL
		)
	OR (
		OtherUseWithinLifetime = 'Y'
		AND OtherUsePastFrequency IS NULL
		)
	OR (
		(
			OtherUseWithin30Days = 'Y'
			OR OtherUseWithinLifetime = 'Y'
			)
		AND (OtherUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Other substance use frequency required.' -- TMU modified on 08/29/2017 ============================
	,2
	,30
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		OtherUseWithin30Days = 'Y'
		AND OtherUseCurrentFrequency IS NULL
		)
	OR (
		OtherUseWithinLifetime = 'Y'
		AND OtherUsePastFrequency IS NULL
		)
	OR (
		(
			OtherUseWithin30Days = 'Y'
			OR OtherUseWithinLifetime = 'Y'
			)
		AND (OtherUseReceivedTreatment IS NULL)
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: Other substance use type required.' -- TMU modified on 08/29/2017 ============================
	,2
	,31
FROM #CustomDocumentDiagnosticAssessments
WHERE (
		OtherUseWithin30Days = 'Y'
		AND OtherUseType IS NULL
		)
	OR (
		OtherUseWithinLifetime = 'Y'
		AND OtherUseType IS NULL
		)

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance use: At least one substance from the list must be specified.'
	,2
	,32
FROM #CustomDocumentDiagnosticAssessments
WHERE [FurtherSubstanceAssessmentIndicated] = 'Y'
	AND ISNULL(AlcoholUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(AlcoholUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(CocaineUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(CocaineUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(SedtativeUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(SedtativeUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(HallucinogenUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(HallucinogenUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(StimulantUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(StimulantUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(NarcoticUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(NarcoticUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(MarijuanaUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(MarijuanaUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(InhalantsUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(InhalantsUseWithinLifetime, 'N') <> 'Y'
	AND ISNULL(OtherUseWithin30Days, 'N') <> 'Y'
	AND ISNULL(OtherUseWithinLifetime, 'N') <> 'Y'

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Ideation comment is required'
	,2
	,33
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskSuicideIdeation = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIdeationComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Suicide intent comment is required'
	,2
	,34
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskSuicideIntent = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIntentComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Suicide prior attempts comment is required'
	,2
	,35
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskSuicidePriorAttempts = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskSuicidePriorAttemptsComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Prior hospitalization comment is required'
	,2
	,36
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskPriorHospitalization = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskPriorHospitalizationComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Physical agression to self comment is required'
	,2
	,37
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskPhysicalAggressionSelf = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionSelfComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Verbal agression to others comment is required'
	,2
	,38
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskVerbalAggressionOthers = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskVerbalAggressionOthersComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Physical agression to objects comment is required'
	,2
	,39
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskPhysicalAggressionObjects = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionObjectsComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: Physical agression to people comment is required'
	,2
	,40
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskPhysicalAggressionPeople = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionPeopleComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: risk taking/agressive behaviors comment is required'
	,2
	,41
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskReportRiskTaking = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskReportRiskTakingComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Risk: threats to client''s personal safety comment is required'
	,2
	,42
FROM #CustomDocumentDiagnosticAssessments
WHERE RiskThreatClientPersonalSafety = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(RiskThreatClientPersonalSafetyComment, '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: "Current risk identified" must be answered.', 2, 43
--from #CustomDocumentDiagnosticAssessments
--where [RiskCurrentRiskIdentified] is null
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Triggers for dangerous behaviors required', 2, 44
--from #CustomDocumentDiagnosticAssessments
--where [RiskCurrentRiskIdentified] = 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([RiskTriggersDangerousBehaviors], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Coping skills required', 2, 45
--from #CustomDocumentDiagnosticAssessments
--where [RiskCurrentRiskIdentified] = 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([RiskCopingSkills], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Interventions preferred by client/guardian for personal safety required', 2, 46
--from #CustomDocumentDiagnosticAssessments
--where ISNULL([RiskInterventionsPersonalSafetyNA], 'N') <> 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPersonalSafety], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Risk - Safety Plan: Interventions preferred by client/guardian for public safety required', 2, 47
--from #CustomDocumentDiagnosticAssessments
--where ISNULL([RiskInterventionsPublicSafetyNA], 'N') <> 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPublicSafety], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Physical Health: Health assessment comment required'
	,2
	,48
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL([PhysicalProblemsNoneReported], 'N') <> 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([PhysicalProblemsComment], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Recommended Svcs: Client''s preferences for treatment required'
	,2
	,51
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([ClientPreferencesForTreatment], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Recommended Svcs: External supports or referrals required'
	,2
	,51
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([ExternalSupportsReferrals], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Mental status: A selection is required'
	,2
	,52
FROM #CustomDocumentDiagnosticAssessments
WHERE [EAPMentalStatus] IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Mental Status: Comments regarding MSE required'
	,2
	,53
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([DiagnosticImpressionsSummary], '')))) = 0
GO
