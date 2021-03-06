IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP]
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
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Presenting problem is required', 1, 1
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(PresentingProblem, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', '"Options already tried" is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(OptionsAlreadyTried, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Guardian info is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where [ClientHasLegalGuardian] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([LegalGuardianInfo], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep habit concerns answer is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Time child goes to bed is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepTimeGoToBed, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Time child falls asleep is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepTimeFallAsleep, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', '"Does the child sleep through the night" answer is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepThroughNight is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Nightmares yes/no is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepNightmares is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Nightmares how often is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepNightmares = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepNightmaresHowOften, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Night terrors yes/no is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepTerrors is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Night terrors how often is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepTerrors = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepTerrorsHowOften, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep walking yes/no is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepWalking is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep walking how often is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepWalking = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepWalkingHowOften, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep: Time of waking is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepTimeWakeUp is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep: Where child wakes up is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepWhere is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep: Sharing a room yes/no is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepShareRoom is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep: Child shares room with whom is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepShareRoom = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepShareRoomWithWhom, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep: Does the child take naps yes/no is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepTakeNaps is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Sleep: Child takes naps how often is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where SleepConcernSleepHabits = 'Y'
and SleepTakeNaps = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(SleepTakeNapsHowOften, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Primary caregiver info is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(FamilyPrimaryCaregiver, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Primary caregiver type is required', 1, 2
from #CustomDocumentDiagnosticAssessments
where FamilyPrimaryCaregiverType is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Ethnicity, cultural background/languages spoken entry is required', 2, 3
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([EthnicityCulturalBackground], '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Status of biological parents'' relationship is required', 2, 3
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(FamilyStatusParentsRelationship, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Non-custodial contact yes/no/NA required', 2, 3
from #CustomDocumentDiagnosticAssessments
where FamilyNonCustodialContact is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Non-custodial contact how often required', 2, 3
from #CustomDocumentDiagnosticAssessments
where FamilyNonCustodialContact = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialHowOften, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Non-custodial type of visit required', 2, 3
from #CustomDocumentDiagnosticAssessments
where FamilyNonCustodialContact = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialTypeOfVisit, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Non-custodial contact consistency required', 2, 3
from #CustomDocumentDiagnosticAssessments
where FamilyNonCustodialContact = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialConsistency, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Non-custodial legal involvement entry required', 2, 3
from #CustomDocumentDiagnosticAssessments
where FamilyNonCustodialContact = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(FamilyNonCustodialLegalInvolvement, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Siblings yes/no answer required', 2, 3
from #CustomDocumentDiagnosticAssessments
where FamilyClientHasSiblings is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Quality of relationships required', 2, 3
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(FamilyQualityRelationships, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Support systems required', 2, 3
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL(FamilySupportSystems, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Family History: Client abilities (or N/A) required', 2, 3
from #CustomDocumentDiagnosticAssessments
where ISNULL(FamilyClientAbilitiesNA, 'N') <> 'Y'
and LEN(LTRIM(RTRIM(ISNULL(FamilyClientAbilitiesComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Legal involvement required', 2, 3
from #CustomDocumentDiagnosticAssessments
where ChildHistoryLegalInvolvement is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Legal involvement details required', 2, 3
from #CustomDocumentDiagnosticAssessments
where ChildHistoryLegalInvolvement = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildHistoryLegalInvolvementComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: History of family emotional/behavior problems yes/no required', 2, 3
from #CustomDocumentDiagnosticAssessments
where ChildHistoryBehaviorInFamily is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: History of family emotional/behavior problems details required', 2, 3
from #CustomDocumentDiagnosticAssessments
where ChildHistoryBehaviorInFamily = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildHistoryBehaviorInFamilyComment, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'History of emotional/behavioral problems entry is required', 2, 12
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([HistoryEmotionalProblemsClient], '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Has client received treatment yes/no required', 2, 13
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Reported diagnosis is required', 2, 13
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientPriorTreatmentDiagnosis], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'At least one type of prior treatment is required', 2, 14
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and isnull([PriorTreatmentCounseling], 'N') <> 'Y'
and isnull([PriorTreatmentCaseManagement], 'N') <> 'Y'
and isnull([PriorTreatmentOther], 'N') <> 'Y'
and isnull([PriorTreatmentMedication], 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Types of Medication and Results entry is required', 2, 15
from #CustomDocumentDiagnosticAssessments
where [PriorTreatmentMedication] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([TypesOfMedicationResults], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'History of abuse selection is required', 2, 17
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
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Abuse comments required', 2, 18
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
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Protective services involvement yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildProtectiveServicesInvolved is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Protective services reason required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildProtectiveServicesInvolved = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesReason, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Protective services county required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildProtectiveServicesInvolved = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesCounty, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Protective services case worker required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildProtectiveServicesInvolved = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesCaseWorker, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Protective services duration required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildProtectiveServicesInvolved = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildProtectiveServicesDates, '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Protective services duration required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildProtectiveServicesInvolved = 'Y'
and ChildProtectiveServicesPlacements is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: History of violence required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildHistoryOfViolence is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: History of violence details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildHistoryOfViolence = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildHistoryOfViolenceComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Witnessed substance use yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildWitnessedSubstances is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Witnessed substance use details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildWitnessedSubstances = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildWitnessedSubstancesComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Child born pre-term/full-term required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildBornFullTermPreTerm is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Child born pre-term/full-term required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildBornFullTermPreTerm is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: post-partum depression yes/no/unknown required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildPostPartumDepression is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Mother used tobacco/drugs during pregnancy yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildMotherUsedDrugsPregnancy is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Mother used tobacco/drugs during pregnancy details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildMotherUsedDrugsPregnancy = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildMotherUsedDrugsPregnancyComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Appetite, feeding, nutrition concerns yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildConcernsNutrition is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Appetite, feeding, nutrition concerns details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildConcernsNutrition = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildConcernsNutritionComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Client''s ability to understand concerns yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildConcernsAbilityUnderstand is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Ability to use words and phrases yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildUsingWordsPhrases is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Has client received speech or language eval yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildReceivedSpeechEval is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Speech or language eval details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildReceivedSpeechEval = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildReceivedSpeechEvalComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Has anyone expressed motor skills concerns yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildConcernMotorSkills is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Gross motor skills problem yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildGrossMotorSkillsProblem is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Walking by 14 months yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildWalking14Months is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Fine motor skills problem yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildFineMotorSkillsProblem is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Can child pick up cheerios yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildPickUpCheerios is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Has caregiver expressed concerns with social skills yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildConcernSocialSkills is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Social skills concerns details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildConcernSocialSkills = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildConcernSocialSkillsComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Difficulty with toilet training yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildToiletTraining is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Toilet training details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildToiletTraining = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildToiletTrainingComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Sensory/perceptual aversions or interests yes/no required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildSensoryAversions is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Child Psychosocial: Sensory/perceptual aversions or interests details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where ChildSensoryAversions = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildSensoryAversionsComment, '')))) = 0





union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Has client received treatment in the past yes/no required', 2, 13
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Reported diagnosis is required', 2, 13
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientPriorTreatmentDiagnosis], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'At least one type of prior treatment is required', 2, 14
from #CustomDocumentDiagnosticAssessments
where [ClientHasReceivedTreatment] = 'Y'
and isnull([PriorTreatmentCounseling], 'N') <> 'Y'
and isnull([PriorTreatmentCaseManagement], 'N') <> 'Y'
and isnull([PriorTreatmentOther], 'N') <> 'Y'
and isnull([PriorTreatmentMedication], 'N') <> 'Y'
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Types of Medication and Results entry is required', 2, 15
from #CustomDocumentDiagnosticAssessments
where [PriorTreatmentMedication] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([TypesOfMedicationResults], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'History of abuse selection is required', 2, 17
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
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Biological mother substance use during pregnancy entry required', 2, 18
from #CustomDocumentDiagnosticAssessments
where DocumentVersionId = @DocumentVersionId
and ChildMotherUsedDrugsPregnancy is null

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Biological mother substance use during pregnancy details required', 2, 18
from #CustomDocumentDiagnosticAssessments
where DocumentVersionId = @DocumentVersionId
and ISNULL(ChildMotherUsedDrugsPregnancy, 'N') = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(ChildMotherUsedDrugsPregnancyComment, '')))) = 0

union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Explanation of substance use is required', 2, 19
from #CustomDocumentDiagnosticAssessments
where [ClientReportAlcoholTobaccoDrugUse] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientReportDrugUseComment], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Explanation of substance use is required', 2, 20
from #CustomDocumentDiagnosticAssessments
where [ClientReportAlcoholTobaccoDrugUse] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([ClientReportDrugUseComment], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Alcohol info is incomplete.', 2, 21
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (AlcoholUseWithin30Days = 'Y' and AlcoholUseCurrentFrequency is null)
	or (AlcoholUseWithinLifetime = 'Y' and AlcoholUsePastFrequency is null)
	or ((AlcoholUseWithin30Days = 'Y' or AlcoholUseWithinLifetime = 'Y') and (AlcoholUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Cocaine info is incomplete.', 2, 22
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (CocaineUseWithin30Days = 'Y' and CocaineUseCurrentFrequency is null)
	or (CocaineUseWithinLifetime = 'Y' and CocaineUsePastFrequency is null)
	or ((CocaineUseWithin30Days = 'Y' or CocaineUseWithinLifetime = 'Y') and (CocaineUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Sedative info is incomplete.', 2, 23
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (SedtativeUseWithin30Days = 'Y' and SedtativeUseCurrentFrequency is null)
	or (SedtativeUseWithinLifetime = 'Y' and SedtativeUsePastFrequency is null)
	or ((SedtativeUseWithin30Days = 'Y' or SedtativeUseWithinLifetime = 'Y') and (SedtativeUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Hallucinogen info is incomplete.', 2, 24
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (HallucinogenUseWithin30Days = 'Y' and HallucinogenUseCurrentFrequency is null)
	or (HallucinogenUseWithinLifetime = 'Y' and HallucinogenUsePastFrequency is null)
	or ((HallucinogenUseWithin30Days = 'Y' or HallucinogenUseWithinLifetime = 'Y') and (HallucinogenUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Stimulant info is incomplete.', 2, 25
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (StimulantUseWithin30Days = 'Y' and StimulantUseCurrentFrequency is null)
	or (StimulantUseWithinLifetime = 'Y' and StimulantUsePastFrequency is null)
	or ((StimulantUseWithin30Days = 'Y' or StimulantUseWithinLifetime = 'Y') and (StimulantUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Narcotic info is incomplete.', 2, 26
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (NarcoticUseWithin30Days = 'Y' and NarcoticUseCurrentFrequency is null)
	or (NarcoticUseWithinLifetime = 'Y' and NarcoticUsePastFrequency is null)
	or ((NarcoticUseWithin30Days = 'Y' or NarcoticUseWithinLifetime = 'Y') and (NarcoticUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Marijuana info is incomplete.', 2, 27
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (MarijuanaUseWithin30Days = 'Y' and MarijuanaUseCurrentFrequency is null)
	or (MarijuanaUseWithinLifetime = 'Y' and MarijuanaUsePastFrequency is null)
	or ((MarijuanaUseWithin30Days = 'Y' or MarijuanaUseWithinLifetime = 'Y') and (MarijuanaUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Inhalants info is incomplete.', 2, 28
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (InhalantsUseWithin30Days = 'Y' and InhalantsUseCurrentFrequency is null)
	or (InhalantsUseWithinLifetime = 'Y' and InhalantsUsePastFrequency is null)
	or ((InhalantsUseWithin30Days = 'Y' or InhalantsUseWithinLifetime = 'Y') and (InhalantsUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Other substance info is incomplete.', 2, 29
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (OtherUseWithin30Days = 'Y' and OtherUseCurrentFrequency is null)
	or (OtherUseWithinLifetime = 'Y' and OtherUsePastFrequency is null)
	or ((OtherUseWithin30Days = 'Y' or OtherUseWithinLifetime = 'Y') and (OtherUseReceivedTreatment is null))
	
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Other substance name required.', 2, 30
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (OtherUseWithin30Days = 'Y' and OtherUseCurrentFrequency is null)
	or (OtherUseWithinLifetime = 'Y' and OtherUsePastFrequency is null)
	or ((OtherUseWithin30Days = 'Y' or OtherUseWithinLifetime = 'Y') and (OtherUseReceivedTreatment is null))
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: Other substance name required.', 2, 31
from #CustomDocumentDiagnosticAssessments
where @ClientAge >= 10
and (OtherUseWithin30Days = 'Y' and OtherUseType is null)
	or (OtherUseWithinLifetime = 'Y' and OtherUseType is null)
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Substance Use: At least one substance from the list must be specified.', 2, 32
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
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Safety Plan: "Current risk identified" must be answered.', 2, 43
--from #CustomDocumentDiagnosticAssessments
--where [RiskCurrentRiskIdentified] is null
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Safety Plan: Triggers for dangerous behaviors required', 2, 44
from #CustomDocumentDiagnosticAssessments
where [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskTriggersDangerousBehaviors], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Safety Plan: Coping skills required', 2, 45
from #CustomDocumentDiagnosticAssessments
where [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskCopingSkills], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Safety Plan: Interventions preferred by client/guardian for personal safety required', 2, 46
from #CustomDocumentDiagnosticAssessments
where ISNULL([RiskInterventionsPersonalSafetyNA], 'N') <> 'Y' and [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPersonalSafety], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Safety Plan: Interventions preferred by client/guardian for public safety required', 2, 47
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
-- not checking this until the application is fixed to save the deault value
--union
--select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Recommended Svcs: Assessed need for transfer required', 2, 55
--from #CustomDocumentDiagnosticAssessments
--where [PrimaryClinicianTransfer] = 'Y'
--and LEN(LTRIM(RTRIM(ISNULL([TransferAssessedNeed], '')))) = 0
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Mental Status: Diagnostic impressions / clinical summary required', 2, 53
from #CustomDocumentDiagnosticAssessments
where LEN(LTRIM(RTRIM(ISNULL([DiagnosticImpressionsSummary], '')))) = 0
-- Strengths are stored in CustomTreatmentPlans
union
select 'CustomDocumentDiagnosticAssessments', 'DeletedBy', 'Initial treatment plan: Strengths required', 2, 54
from dbo.CustomTreatmentPlans as tp
where tp.DocumentVersionId = @DocumentVersionId
and LEN(LTRIM(RTRIM(ISNULL(tp.ClientStrengths, '')))) = 0
and ISNULL(tp.RecordDeleted, 'N') <> 'Y'



