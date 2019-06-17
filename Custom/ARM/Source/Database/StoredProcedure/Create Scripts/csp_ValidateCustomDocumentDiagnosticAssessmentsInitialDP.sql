DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP] 
(
	@DocumentVersionId INT
)
AS
/***********************************************************************************************************************
DATE		 USER		TASK					COMMENT
------------ ---------	---------------------	----------------------------------------------------
05/10/2013   DVeale		ARM Customization #16	Removed "current risk identified must be answered" and "primary 
												clinician assignment section is required" 
08/29/2017	 Ting-Yu	ARM - Support # 695		There are multiple instances of error message "Substance use: Other 
												substance name required.", which is causing the system throws 
												JavaScript error "Saved successfully.Error occured while loading screen.
												Please reopen this screen again." 
												Re-phrased the error message to make sure there are unique.
***********************************************************************************************************************/
DECLARE @ClientAge INT

SELECT @ClientAge = dbo.GetAge(c.dob, d.EffectiveDate)
FROM dbo.DocumentVersions AS dv
JOIN dbo.Documents AS d ON d.DocumentId = dv.DocumentId
JOIN dbo.Clients AS c ON c.ClientId = d.ClientId
WHERE dv.DocumentVersionId = @DocumentVersionId

INSERT INTO #validationReturnTable (
	TableName
	,ColumnName
	,ErrorMessage
	,TabOrder
	,ValidationOrder
	)
SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Presenting problem is required'
	,1
	,1
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(PresentingProblem, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'"Options already tried" is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(OptionsAlreadyTried, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Guardian info is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasLegalGuardian] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([LegalGuardianInfo], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep habit concerns answer is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Time child goes to bed is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepTimeGoToBed, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Time child falls asleep is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepTimeFallAsleep, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'"Does the child sleep through the night" answer is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepThroughNight IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Nightmares yes/no is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepNightmares IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Nightmares how often is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepNightmares = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepNightmaresHowOften, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Night terrors yes/no is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepTerrors IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Night terrors how often is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepTerrors = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepTerrorsHowOften, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep walking yes/no is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepWalking IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep walking how often is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepWalking = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepWalkingHowOften, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep: Time of waking is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepTimeWakeUp IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep: Where child wakes up is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepWhere IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep: Sharing a room yes/no is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepShareRoom IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep: Child shares room with whom is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepShareRoom = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepShareRoomWithWhom, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep: Does the child take naps yes/no is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepTakeNaps IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Sleep: Child takes naps how often is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE SleepConcernSleepHabits = 'Y'
	AND SleepTakeNaps = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(SleepTakeNapsHowOften, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Primary caregiver info is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(FamilyPrimaryCaregiver, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Primary caregiver type is required'
	,1
	,2
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyPrimaryCaregiverType IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Ethnicity, cultural background/languages spoken entry is required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([EthnicityCulturalBackground], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Status of biological parents'' relationship is required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(FamilyStatusParentsRelationship, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Non-custodial contact yes/no/NA required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyNonCustodialContact IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Non-custodial contact how often required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyNonCustodialContact = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialHowOften, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Non-custodial type of visit required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyNonCustodialContact = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialTypeOfVisit, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Non-custodial contact consistency required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyNonCustodialContact = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialConsistency, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Non-custodial legal involvement entry required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyNonCustodialContact = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialLegalInvolvement, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Siblings yes/no answer required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE FamilyClientHasSiblings IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Quality of relationships required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(FamilyQualityRelationships, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Support systems required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL(FamilySupportSystems, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Family History: Client abilities (or N/A) required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL(FamilyClientAbilitiesNA, 'N') <> 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(FamilyClientAbilitiesComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Legal involvement required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildHistoryLegalInvolvement IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Legal involvement details required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildHistoryLegalInvolvement = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildHistoryLegalInvolvementComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: History of family emotional/behavior problems yes/no required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildHistoryBehaviorInFamily IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: History of family emotional/behavior problems details required'
	,2
	,3
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildHistoryBehaviorInFamily = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildHistoryBehaviorInFamilyComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'History of emotional/behavioral problems entry is required'
	,2
	,12
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([HistoryEmotionalProblemsClient], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Has client received treatment yes/no required'
	,2
	,13
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasReceivedTreatment] IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Reported diagnosis is required'
	,2
	,13
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasReceivedTreatment] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([ClientPriorTreatmentDiagnosis], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'At least one type of prior treatment is required'
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
	,'Types of Medication and Results entry is required'
	,2
	,15
FROM #CustomDocumentDiagnosticAssessments
WHERE [PriorTreatmentMedication] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([TypesOfMedicationResults], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'History of abuse selection is required'
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
	,'Abuse comments required'
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
	,'Child Psychosocial: Protective services involvement yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildProtectiveServicesInvolved IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Protective services reason required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildProtectiveServicesInvolved = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesReason, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Protective services county required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildProtectiveServicesInvolved = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesCounty, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Protective services case worker required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildProtectiveServicesInvolved = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesCaseWorker, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Protective services duration required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildProtectiveServicesInvolved = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesDates, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Protective services duration required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildProtectiveServicesInvolved = 'Y'
	AND ChildProtectiveServicesPlacements IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: History of violence required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildHistoryOfViolence IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: History of violence details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildHistoryOfViolence = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildHistoryOfViolenceComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Witnessed substance use yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildWitnessedSubstances IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Witnessed substance use details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildWitnessedSubstances = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildWitnessedSubstancesComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Child born pre-term/full-term required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildBornFullTermPreTerm IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Child born pre-term/full-term required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildBornFullTermPreTerm IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: post-partum depression yes/no/unknown required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildPostPartumDepression IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Mother used tobacco/drugs during pregnancy yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildMotherUsedDrugsPregnancy IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Mother used tobacco/drugs during pregnancy details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildMotherUsedDrugsPregnancy = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildMotherUsedDrugsPregnancyComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Appetite, feeding, nutrition concerns yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildConcernsNutrition IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Appetite, feeding, nutrition concerns details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildConcernsNutrition = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildConcernsNutritionComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Client''s ability to understand concerns yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildConcernsAbilityUnderstand IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Ability to use words and phrases yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildUsingWordsPhrases IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Has client received speech or language eval yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildReceivedSpeechEval IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Speech or language eval details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildReceivedSpeechEval = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildReceivedSpeechEvalComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Has anyone expressed motor skills concerns yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildConcernMotorSkills IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Gross motor skills problem yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildGrossMotorSkillsProblem IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Walking by 14 months yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildWalking14Months IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Fine motor skills problem yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildFineMotorSkillsProblem IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Can child pick up cheerios yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildPickUpCheerios IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Has caregiver expressed concerns with social skills yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildConcernSocialSkills IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Social skills concerns details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildConcernSocialSkills = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildConcernSocialSkillsComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Difficulty with toilet training yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildToiletTraining IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Toilet training details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildToiletTraining = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildToiletTrainingComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Sensory/perceptual aversions or interests yes/no required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildSensoryAversions IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Child Psychosocial: Sensory/perceptual aversions or interests details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE ChildSensoryAversions = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildSensoryAversionsComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Has client received treatment in the past yes/no required'
	,2
	,13
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasReceivedTreatment] IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Reported diagnosis is required'
	,2
	,13
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientHasReceivedTreatment] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([ClientPriorTreatmentDiagnosis], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'At least one type of prior treatment is required'
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
	,'Types of Medication and Results entry is required'
	,2
	,15
FROM #CustomDocumentDiagnosticAssessments
WHERE [PriorTreatmentMedication] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([TypesOfMedicationResults], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'History of abuse selection is required'
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
	,'Biological mother substance use during pregnancy entry required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE DocumentVersionId = @DocumentVersionId
	AND ChildMotherUsedDrugsPregnancy IS NULL

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Biological mother substance use during pregnancy details required'
	,2
	,18
FROM #CustomDocumentDiagnosticAssessments
WHERE DocumentVersionId = @DocumentVersionId
	AND ISNULL(ChildMotherUsedDrugsPregnancy, 'N') = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL(ChildMotherUsedDrugsPregnancyComment, '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Explanation of substance use is required'
	,2
	,19
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientReportAlcoholTobaccoDrugUse] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([ClientReportDrugUseComment], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Explanation of substance use is required'
	,2
	,20
FROM #CustomDocumentDiagnosticAssessments
WHERE [ClientReportAlcoholTobaccoDrugUse] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([ClientReportDrugUseComment], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Substance Use: Alcohol info is incomplete.'
	,2
	,21
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Cocaine info is incomplete.'
	,2
	,22
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Sedative info is incomplete.'
	,2
	,23
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Hallucinogen info is incomplete.'
	,2
	,24
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Stimulant info is incomplete.'
	,2
	,25
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Narcotic info is incomplete.'
	,2
	,26
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Marijuana info is incomplete.'
	,2
	,27
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Inhalants info is incomplete.'
	,2
	,28
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Other substance info is incomplete.'
	,2
	,29
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Other substance use frequency required.' -- TMU modified on 08/29/2017 ============================
	,2
	,30
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: Other substance use type required.' -- TMU modified on 08/29/2017 ============================
	,2
	,31
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND (
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
	,'Substance Use: At least one substance from the list must be specified.'
	,2
	,32
FROM #CustomDocumentDiagnosticAssessments
WHERE @ClientAge >= 10
	AND [FurtherSubstanceAssessmentIndicated] = 'Y'
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
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Safety Plan: "Current risk identified" must be answered.', 2, 43
--from #CustomDocumentDiagnosticAssessments
--where [RiskCurrentRiskIdentified] is null

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Safety Plan: Triggers for dangerous behaviors required'
	,2
	,44
FROM #CustomDocumentDiagnosticAssessments
WHERE [RiskCurrentRiskIdentified] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([RiskTriggersDangerousBehaviors], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Safety Plan: Coping skills required'
	,2
	,45
FROM #CustomDocumentDiagnosticAssessments
WHERE [RiskCurrentRiskIdentified] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([RiskCopingSkills], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Safety Plan: Interventions preferred by client/guardian for personal safety required'
	,2
	,46
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL([RiskInterventionsPersonalSafetyNA], 'N') <> 'Y'
	AND [RiskCurrentRiskIdentified] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPersonalSafety], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Safety Plan: Interventions preferred by client/guardian for public safety required'
	,2
	,47
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL([RiskInterventionsPublicSafetyNA], 'N') <> 'Y'
	AND [RiskCurrentRiskIdentified] = 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPublicSafety], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Physical Health: Health assessment comment required'
	,2
	,48
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL([PhysicalProblemsNoneReported], 'N') <> 'Y'
	AND LEN(LTRIM(RTRIM(ISNULL([PhysicalProblemsComment], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Physical Health: Please specify any special communication or accessibility needs', 2, 49
--from #CustomDocumentDiagnosticAssessments
--where ISNULL([SpecialNeedsNoneReported], 'N') <> 'Y'
--and ISNULL([SpecialNeedsVisualImpairment], 'N') <> 'Y'
--and ISNULL([SpecialNeedsHearingImpairment], 'N') <> 'Y'
--and ISNULL([SpecialNeedsSpeechImpairment], 'N') <> 'Y'
--and ISNULL([SpecialNeedsOtherPhysicalImpairment], 'N') <> 'Y'

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Physical Health: Please specify any special communication or accessibility needs'
	,2
	,50
FROM #CustomDocumentDiagnosticAssessments
WHERE ISNULL([SpecialNeedsNoneReported], 'N') <> 'Y'
	AND ISNULL([SpecialNeedsVisualImpairment], 'N') <> 'Y'
	AND ISNULL([SpecialNeedsHearingImpairment], 'N') <> 'Y'
	AND ISNULL([SpecialNeedsSpeechImpairment], 'N') <> 'Y'
	AND ISNULL([SpecialNeedsOtherPhysicalImpairment], 'N') <> 'Y'

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Recommended Svcs: Client''s preferences for treatment required'
	,2
	,51
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([ClientPreferencesForTreatment], '')))) = 0
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Primary clinician assignment selection required', 2, 53
--from #CustomDocumentDiagnosticAssessments
--where [PrimaryClinicianTransfer] is null

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Recommended Svcs: Primary clinician staff selection required'
	,2
	,54
FROM #CustomDocumentDiagnosticAssessments
WHERE [PrimaryClinicianTransfer] = 'Y'
	AND [TransferReceivingStaff] IS NULL
-- not checking this until the application is fixed to save the deault value
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Assessed need for transfer required', 2, 55
--from #CustomDocumentDiagnosticAssessments
--where [PrimaryClinicianTransfer] = 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([TransferAssessedNeed], '')))) = 0

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Mental Status: Diagnostic impressions / clinical summary required'
	,2
	,53
FROM #CustomDocumentDiagnosticAssessments
WHERE LEN(LTRIM(RTRIM(ISNULL([DiagnosticImpressionsSummary], '')))) = 0
-- Strengths are stored in CustomTreatmentPlans

UNION

SELECT 'CustomDocumentDiagnosticAssessments'
	,'DeletedBy'
	,'Initial treatment plan: Strengths required'
	,2
	,54
FROM dbo.CustomTreatmentPlans AS tp
WHERE tp.DocumentVersionId = @DocumentVersionId
	AND LEN(LTRIM(RTRIM(ISNULL(tp.ClientStrengths, '')))) = 0
	AND ISNULL(tp.RecordDeleted, 'N') <> 'Y'
GO
