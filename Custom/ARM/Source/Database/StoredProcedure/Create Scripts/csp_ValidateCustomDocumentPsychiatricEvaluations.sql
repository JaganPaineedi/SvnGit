IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentPsychiatricEvaluations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentPsychiatricEvaluations]
GO

CREATE procedure [dbo].[csp_ValidateCustomDocumentPsychiatricEvaluations]
	@DocumentVersionId int

-- 2012.08.01 - fixed validation for abuse type
-- 2012.10.09 - removed blanket validation requirement for pharm management
as

--begin                                  
--Create Table #validationReturnTable                                  
--(TableName  varchar(200),                                  
--ColumnName  varchar(200),                                  
--ErrorMessage    varchar(max),                                  
--PageIndex       int,      
--TabOrder int,      
--ValidationOrder int                              
--)          
--end 



CREATE TABLE #CustomDocumentPsychiatricEvaluations 
(
 DocumentVersionId int
,CreatedBy varchar(30)
,CreatedDate datetime
,ModifiedBy varchar(30)
,ModifiedDate datetime
,RecordDeleted char(1)
,DeletedBy varchar(30)
,DeletedDate datetime
,AdultOrChild varchar(MAX)
,ChiefComplaint varchar(max)
,PresentIllnessHistory varchar(max)
,PastPsychiatricHistory varchar(max)
,FamilyHistory varchar(max)
,SubstanceAbuseHistory varchar(max)
,GeneralMedicalHistory varchar(max)
,CurrentBirthControlMedications char(1)
,CurrentBirthControlMedicationRisks char(1)
,MedicationSideEffects varchar(max)
,PyschosocialHistory varchar(max)
,OccupationalMilitaryHistory varchar(max)
,LegalHistory varchar(max)
,SupportSystems varchar(max)
,EthnicityAndCulturalBackground varchar(max)
,LivingArrangement varchar(max)
,AbuseNotApplicable char(1)
,AbuseEmotionalVictim char(1)
,AbuseEmotionalOffender char(1)
,AbuseVerbalVictim char(1)
,AbuseVerbalOffender char(1)
,AbusePhysicalVictim char(1)
,AbusePhysicalOffender char(1)
,AbuseSexualVictim char(1)
,AbuseSexualOffender char(1)
,AbuseNeglectVictim char(1)
,AbuseNeglectOffender char(1)
,AbuseComment varchar(max)
,AppetiteNormal char(1)
,AppetiteSurpressed char(1)
,AppetiteExcessive char(1)
,SleepHygieneNormal char(1)
,SleepHygieneFrequentWaking char(1)
,SleepHygieneProblemsFallingAsleep char(1)
,SleepHygieneProblemsStayingAsleep char(1)
,SleepHygieneNightmares char(1)
,SleepHygieneOther char(1)
,SleepHygieneComment varchar(max)
,MilestoneUnderstandingLanguage char(1)
,MilestoneVocabulary char(1)
,MilestoneFineMotor char(1)
,MilestoneGrossMotor char(1)
,MilestoneIntellectual char(1)
,MilestoneMakingFriends char(1)
,MilestoneSharingInterests char(1)
,MilestoneEyeContact char(1)
,MilestoneToiletTraining char(1)
,MilestoneCopingSkills char(1)
,ChildPeerRelationshipHistory varchar(MAX)
,ChildEducationalHistorySchoolFunctioning varchar(MAX)
,ChildBiologicalMotherSubstanceUse char(1)
,ChildBornFullTermPreTerm char(1)
,ChildBirthWeight varchar(MAX)
,ChildBirthLength varchar(MAX)
,ChildApgarScore1 int
,ChildApgarScore2 int
,ChildApgarScore3 int
,ChildApgarScoreComment varchar(max)
,ChildMotherPrenatalCare char(1)
,ChildPregnancyComplications char(1)
,ChildPregnancyComplicationsComment varchar(max)
,ChildDeliveryComplications char(1)
,ChildDeliveryComplicationsComment varchar(max)
,ChildColic char(1)
,ChildColicComment varchar(max)
,ChildJaundice char(1)
,ChildJaundiceComment varchar(max)
,ChildHospitalStayAfterDelievery varchar(max)
,ChildBiologicalMotherPostPartumDepression char(1)
,ChildPhyscicalAppearanceNoAbnormalities char(1)
,ChildPhyscicalAppearanceLowSetEars char(1)
,ChildPhyscicalAppearanceLowForehead char(1)
,ChildPhyscicalAppearanceCleftLipPalate char(1)
,ChildPhyscicalAppearanceOther char(1)
,ChildPhyscicalAppearanceOtherComment varchar(max)
,ChildFineMotorSkillsNormal char(1)
,ChildFineMotorSkillsProblemsDrawingWriting char(1)
,ChildFineMotorSkillsProblemsScissors char(1)
,ChildFineMotorSkillsProblemsZipping char(1)
,ChildFineMotorSkillsProblemsTying char(1)
,ChildPlayNormal char(1)
,ChildPlayDangerous char(1)
,ChildPlayViolentTraumatic char(1)
,ChildPlayRepetitive char(1)
,ChildPlayEchopraxia char(1)
,ChildInteractionNormal char(1)
,ChildInteractionWithdrawn char(1)
,ChildInteractionIndiscriminateFriendliness char(1)
,ChildInteractionOther char(1)
,ChildInteractionOtherComment varchar(max)
,ChildVerbalNormal char(1)
,ChildVerbalDelayed char(1)
,ChildVerbalAdvanced char(1)
,ChildVerbalEcholalia char(1)
,ChildVerbalReducedComprehension char(1)
,ChildVerbalOther char(1)
,ChildVerbalOtherComment varchar(max)
,ChildNonVerbalNormal char(1)
,ChildNonVerbalOther char(1)
,ChildNonVerbalOtherComment varchar(max)
,ChildEaseOfSeperationNormal char(1)
,ChildEaseOfSeperationExcessiveWorry char(1)
,ChildEaseOfSeperationNoResponse char(1)
,ChildEaseOfSeperationOther char(1)
,ChildEaseOfSeperationOtherComment varchar(max)
,RiskSuicideIdeation char(1)
,RiskSuicideIdeationComment varchar(max)
,RiskSuicideIntent char(1)
,RiskSuicideIntentComment varchar(max)
,RiskSuicidePriorAttempts char(1)
,RiskSuicidePriorAttemptsComment varchar(max)
,RiskPriorHospitalization char(1)
,RiskPriorHospitalizationComment varchar(max)
,RiskPhysicalAggressionSelf char(1)
,RiskPhysicalAggressionSelfComment varchar(max)
,RiskVerbalAggressionOthers char(1)
,RiskVerbalAggressionOthersComment varchar(max)
,RiskPhysicalAggressionObjects char(1)
,RiskPhysicalAggressionObjectsComment varchar(max)
,RiskPhysicalAggressionPeople char(1)
,RiskPhysicalAggressionPeopleComment varchar(max)
,RiskReportRiskTaking char(1)
,RiskReportRiskTakingComment varchar(max)
,RiskThreatClientPersonalSafety char(1)
,RiskThreatClientPersonalSafetyComment varchar(max)
,RiskPhoneNumbersProvided char(1)
,RiskCurrentRiskIdentified char(1)
,RiskTriggersDangerousBehaviors varchar(max)
,RiskCopingSkills varchar(max)
,RiskInterventionsPersonalSafetyNA char(1)
,RiskInterventionsPersonalSafety varchar(max)
,RiskInterventionsPublicSafetyNA char(1)
,RiskInterventionsPublicSafety varchar(max)
,DifferentialDiagnosisFormulation varchar(max)
,LabTestsAndMonitoringOrdered varchar(max)
,TreatmentRecommendationsAndOrders varchar(max)
,MedicationsPrescribed varchar(max)
,OtherInstructions varchar(max)
,TransferReceivingStaff int
,TransferReceivingProgram int
,TransferAssessedNeed varchar(MAX)
,TransferClientParticipated char(1)
,CreateMedicatlTxPlan char(1)
,AddGoalsToTxPlan char(1)
)

insert into #CustomDocumentPsychiatricEvaluations (
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,AdultOrChild
,ChiefComplaint
,PresentIllnessHistory
,PastPsychiatricHistory
,FamilyHistory
,SubstanceAbuseHistory
,GeneralMedicalHistory
,CurrentBirthControlMedications
,CurrentBirthControlMedicationRisks
,MedicationSideEffects
,PyschosocialHistory
,OccupationalMilitaryHistory
,LegalHistory
,SupportSystems
,EthnicityAndCulturalBackground
,LivingArrangement
,AbuseNotApplicable
,AbuseEmotionalVictim
,AbuseEmotionalOffender
,AbuseVerbalVictim
,AbuseVerbalOffender
,AbusePhysicalVictim
,AbusePhysicalOffender
,AbuseSexualVictim
,AbuseSexualOffender
,AbuseNeglectVictim
,AbuseNeglectOffender
,AbuseComment
,AppetiteNormal
,AppetiteSurpressed
,AppetiteExcessive
,SleepHygieneNormal
,SleepHygieneFrequentWaking
,SleepHygieneProblemsFallingAsleep
,SleepHygieneProblemsStayingAsleep
,SleepHygieneNightmares
,SleepHygieneOther
,SleepHygieneComment
,MilestoneUnderstandingLanguage
,MilestoneVocabulary
,MilestoneFineMotor
,MilestoneGrossMotor
,MilestoneIntellectual
,MilestoneMakingFriends
,MilestoneSharingInterests
,MilestoneEyeContact
,MilestoneToiletTraining
,MilestoneCopingSkills
,ChildPeerRelationshipHistory
,ChildEducationalHistorySchoolFunctioning
,ChildBiologicalMotherSubstanceUse
,ChildBornFullTermPreTerm
,ChildBirthWeight
,ChildBirthLength
,ChildApgarScore1
,ChildApgarScore2
,ChildApgarScore3
,ChildApgarScoreComment
,ChildMotherPrenatalCare
,ChildPregnancyComplications
,ChildPregnancyComplicationsComment
,ChildDeliveryComplications
,ChildDeliveryComplicationsComment
,ChildColic
,ChildColicComment
,ChildJaundice
,ChildJaundiceComment
,ChildHospitalStayAfterDelievery
,ChildBiologicalMotherPostPartumDepression
,ChildPhyscicalAppearanceNoAbnormalities
,ChildPhyscicalAppearanceLowSetEars
,ChildPhyscicalAppearanceLowForehead
,ChildPhyscicalAppearanceCleftLipPalate
,ChildPhyscicalAppearanceOther
,ChildPhyscicalAppearanceOtherComment
,ChildFineMotorSkillsNormal
,ChildFineMotorSkillsProblemsDrawingWriting
,ChildFineMotorSkillsProblemsScissors
,ChildFineMotorSkillsProblemsZipping
,ChildFineMotorSkillsProblemsTying
,ChildPlayNormal
,ChildPlayDangerous
,ChildPlayViolentTraumatic
,ChildPlayRepetitive
,ChildPlayEchopraxia
,ChildInteractionNormal
,ChildInteractionWithdrawn
,ChildInteractionIndiscriminateFriendliness
,ChildInteractionOther
,ChildInteractionOtherComment
,ChildVerbalNormal
,ChildVerbalDelayed
,ChildVerbalAdvanced
,ChildVerbalEcholalia
,ChildVerbalReducedComprehension
,ChildVerbalOther
,ChildVerbalOtherComment
,ChildNonVerbalNormal
,ChildNonVerbalOther
,ChildNonVerbalOtherComment
,ChildEaseOfSeperationNormal
,ChildEaseOfSeperationExcessiveWorry
,ChildEaseOfSeperationNoResponse
,ChildEaseOfSeperationOther
,ChildEaseOfSeperationOtherComment
,RiskSuicideIdeation
,RiskSuicideIdeationComment
,RiskSuicideIntent
,RiskSuicideIntentComment
,RiskSuicidePriorAttempts
,RiskSuicidePriorAttemptsComment
,RiskPriorHospitalization
,RiskPriorHospitalizationComment
,RiskPhysicalAggressionSelf
,RiskPhysicalAggressionSelfComment
,RiskVerbalAggressionOthers
,RiskVerbalAggressionOthersComment
,RiskPhysicalAggressionObjects
,RiskPhysicalAggressionObjectsComment
,RiskPhysicalAggressionPeople
,RiskPhysicalAggressionPeopleComment
,RiskReportRiskTaking
,RiskReportRiskTakingComment
,RiskThreatClientPersonalSafety
,RiskThreatClientPersonalSafetyComment
,RiskPhoneNumbersProvided
,RiskCurrentRiskIdentified
,RiskTriggersDangerousBehaviors
,RiskCopingSkills
,RiskInterventionsPersonalSafetyNA
,RiskInterventionsPersonalSafety
,RiskInterventionsPublicSafetyNA
,RiskInterventionsPublicSafety
,DifferentialDiagnosisFormulation
,LabTestsAndMonitoringOrdered
,TreatmentRecommendationsAndOrders
,MedicationsPrescribed
,OtherInstructions
,TransferReceivingStaff
,TransferReceivingProgram
,TransferAssessedNeed
,TransferClientParticipated
,CreateMedicatlTxPlan
,AddGoalsToTxPlan
)


SELECT 
 DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,AdultOrChild
,ChiefComplaint
,PresentIllnessHistory
,PastPsychiatricHistory
,FamilyHistory
,SubstanceAbuseHistory
,GeneralMedicalHistory
,CurrentBirthControlMedications
,CurrentBirthControlMedicationRisks
,MedicationSideEffects
,PyschosocialHistory
,OccupationalMilitaryHistory
,LegalHistory
,SupportSystems
,EthnicityAndCulturalBackground
,LivingArrangement
,AbuseNotApplicable
,AbuseEmotionalVictim
,AbuseEmotionalOffender
,AbuseVerbalVictim
,AbuseVerbalOffender
,AbusePhysicalVictim
,AbusePhysicalOffender
,AbuseSexualVictim
,AbuseSexualOffender
,AbuseNeglectVictim
,AbuseNeglectOffender
,AbuseComment
,AppetiteNormal
,AppetiteSurpressed
,AppetiteExcessive
,SleepHygieneNormal
,SleepHygieneFrequentWaking
,SleepHygieneProblemsFallingAsleep
,SleepHygieneProblemsStayingAsleep
,SleepHygieneNightmares
,SleepHygieneOther
,SleepHygieneComment
,MilestoneUnderstandingLanguage
,MilestoneVocabulary
,MilestoneFineMotor
,MilestoneGrossMotor
,MilestoneIntellectual
,MilestoneMakingFriends
,MilestoneSharingInterests
,MilestoneEyeContact
,MilestoneToiletTraining
,MilestoneCopingSkills
,ChildPeerRelationshipHistory
,ChildEducationalHistorySchoolFunctioning
,ChildBiologicalMotherSubstanceUse
,ChildBornFullTermPreTerm
,ChildBirthWeight
,ChildBirthLength
,ChildApgarScore1
,ChildApgarScore2
,ChildApgarScore3
,ChildApgarScoreComment
,ChildMotherPrenatalCare
,ChildPregnancyComplications
,ChildPregnancyComplicationsComment
,ChildDeliveryComplications
,ChildDeliveryComplicationsComment
,ChildColic
,ChildColicComment
,ChildJaundice
,ChildJaundiceComment
,ChildHospitalStayAfterDelievery
,ChildBiologicalMotherPostPartumDepression
,ChildPhyscicalAppearanceNoAbnormalities
,ChildPhyscicalAppearanceLowSetEars
,ChildPhyscicalAppearanceLowForehead
,ChildPhyscicalAppearanceCleftLipPalate
,ChildPhyscicalAppearanceOther
,ChildPhyscicalAppearanceOtherComment
,ChildFineMotorSkillsNormal
,ChildFineMotorSkillsProblemsDrawingWriting
,ChildFineMotorSkillsProblemsScissors
,ChildFineMotorSkillsProblemsZipping
,ChildFineMotorSkillsProblemsTying
,ChildPlayNormal
,ChildPlayDangerous
,ChildPlayViolentTraumatic
,ChildPlayRepetitive
,ChildPlayEchopraxia
,ChildInteractionNormal
,ChildInteractionWithdrawn
,ChildInteractionIndiscriminateFriendliness
,ChildInteractionOther
,ChildInteractionOtherComment
,ChildVerbalNormal
,ChildVerbalDelayed
,ChildVerbalAdvanced
,ChildVerbalEcholalia
,ChildVerbalReducedComprehension
,ChildVerbalOther
,ChildVerbalOtherComment
,ChildNonVerbalNormal
,ChildNonVerbalOther
,ChildNonVerbalOtherComment
,ChildEaseOfSeperationNormal
,ChildEaseOfSeperationExcessiveWorry
,ChildEaseOfSeperationNoResponse
,ChildEaseOfSeperationOther
,ChildEaseOfSeperationOtherComment
,RiskSuicideIdeation
,RiskSuicideIdeationComment
,RiskSuicideIntent
,RiskSuicideIntentComment
,RiskSuicidePriorAttempts
,RiskSuicidePriorAttemptsComment
,RiskPriorHospitalization
,RiskPriorHospitalizationComment
,RiskPhysicalAggressionSelf
,RiskPhysicalAggressionSelfComment
,RiskVerbalAggressionOthers
,RiskVerbalAggressionOthersComment
,RiskPhysicalAggressionObjects
,RiskPhysicalAggressionObjectsComment
,RiskPhysicalAggressionPeople
,RiskPhysicalAggressionPeopleComment
,RiskReportRiskTaking
,RiskReportRiskTakingComment
,RiskThreatClientPersonalSafety
,RiskThreatClientPersonalSafetyComment
,RiskPhoneNumbersProvided
,RiskCurrentRiskIdentified
,RiskTriggersDangerousBehaviors
,RiskCopingSkills
,RiskInterventionsPersonalSafetyNA
,RiskInterventionsPersonalSafety
,RiskInterventionsPublicSafetyNA
,RiskInterventionsPublicSafety
,DifferentialDiagnosisFormulation
,LabTestsAndMonitoringOrdered
,TreatmentRecommendationsAndOrders
,MedicationsPrescribed
,OtherInstructions
,TransferReceivingStaff
,TransferReceivingProgram
,TransferAssessedNeed
,TransferClientParticipated
,CreateMedicatlTxPlan
,AddGoalsToTxPlan
From dbo.CustomDocumentPsychiatricEvaluations  
where DocumentVersionId = @DocumentVersionId


Create Table #DocumentDiagnosisCodes        
(        
 ICD10CodeId Varchar(20) NULL ,        
 ICD10Code Varchar(20) NULL ,        
 ICD9Code Varchar(20) NULL ,        
 DiagnosisType int,        
 RuleOut char(1),        
 Billable char(1),        
 Severity int,       
 DiagnosisOrder int NOT NULL ,        
 Specifier text NULL ,        
 CreatedBy varchar(100),        
 CreatedDate Datetime,        
 ModifiedBy varchar(100),        
 ModifiedDate Datetime,        
 RecordDeleted char(1),        
 DeletedDate datetime NULL ,        
 DeletedBy varchar(100) ,
 DocumentVersionId int       
)        
Insert into #DocumentDiagnosisCodes        
(        
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,        
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,        
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,         
RecordDeleted, DeletedDate, DeletedBy,DocumentVersionId)        
        
select        
ICD10CodeId, ICD10Code, ICD9Code, DiagnosisType,        
RuleOut, Billable, Severity, DiagnosisOrder, Specifier,        
CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,         
RecordDeleted, DeletedDate, DeletedBy,DocumentVersionId        
FROM DocumentDiagnosisCodes        
where documentversionId = @documentversionId        
and isnull(RecordDeleted,'N') = 'N'
    


declare @Sex char(1), @Age int, @EffectiveDate datetime, @ClientId int

select @Sex = isnull(c.Sex,'U'), @Age = dbo.GetAge(c.DOB,d.EffectiveDate), @EffectiveDate = d.EffectiveDate, @ClientId = d.ClientId
from DocumentVersions dv
join Documents d on d.DocumentId = dv.DocumentId 
join Clients c on c.ClientId = d.ClientId
where dv.DocumentVersionId = @DocumentVersionId
		
Insert into #validationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)

--***VALIDATIION SELECT/UNION***--

--SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Adult Or Child section required'
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE LEN(LTRIM(RTRIM(ISNULL(AdultOrChild, '')))) = 0

SELECT 'DocumentDiagnosisCodes','DiagnosisType','Only one primary type should be available',0,1 From #DocumentDiagnosisCodes where DocumentVersionId=@DocumentVersionId and((Select Count(*) AS RecordCount from #DocumentDiagnosisCodes WHERE DocumentVersionId = @DocumentVersionId AND DiagnosisType = 140 AND ISNULL(RecordDeleted,'N') = 'N') > 1) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = 'Y' and DocumentVersionId=@DocumentVersionId)
UNION
SELECT 'DocumentDiagnosisCodes','DiagnosisType','Primary Diagnosis must have a billing order of 1',0,1 From #DocumentDiagnosisCodes where exists (Select 1 from #DocumentDiagnosisCodes where (DiagnosisOrder <> 1 and DiagnosisType = 140) or (DiagnosisOrder = 1 and DiagnosisType <> 140)) and Not Exists (Select 1 from DocumentDiagnosis Where NoDiagnosis = 'Y' and DocumentVersionId=@DocumentVersionId)
UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Chief Complaint section required',1,1
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChiefComplaint, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Present Illness History section required',1,2
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(PresentIllnessHistory, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Past Psychiatric History section required',1,3
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(PastPsychiatricHistory, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Family History section required',1,4
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(FamilyHistory, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Substance Abuse History section required',1,5
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SubstanceAbuseHistory, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - General Medical History section required',1,6
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(GeneralMedicalHistory, '')))) = 0

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Current Birth Control Medications selection required',1,7
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE LEN(LTRIM(RTRIM(ISNULL(CurrentBirthControlMedications, '')))) = 0

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Current Birth Control Medications selection of N/A is required',1,8
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE ISNULL(CurrentBirthControlMedications, '') <> 'A'
--and CurrentBirthControlMedications is not null
--and @Sex = 'M'

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Current Birth Control Medication Risks selection required',1,9
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE LEN(LTRIM(RTRIM(ISNULL(CurrentBirthControlMedicationRisks, '')))) = 0
--and CurrentBirthControlMedications = 'N'
--and @Sex = 'F'

/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MedicationSideEffects section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MedicationSideEffects, '')))) = 0
*/

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Pyschosocial History section required',1,10
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(PyschosocialHistory, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Occupational/Military History section required',1,11
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(OccupationalMilitaryHistory, '')))) = 0
and @Age >= 18

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Legal History section required',1,12
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(LegalHistory, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Support Systems section required',1,13
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SupportSystems, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Ethnicity And Cultural Background section required',1,14
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(EthnicityAndCulturalBackground, '')))) = 0

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Living Arrangement section required',1,15
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(LivingArrangement, '')))) = 0


UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Abuse selection required',1,16
FROM #CustomDocumentPsychiatricEvaluations
WHERE  ( ISNULL(AbuseNotApplicable, 'N') = 'N'
and ISNULL(AbuseEmotionalVictim, 'N') = 'N'
and ISNULL(AbuseEmotionalOffender, 'N') = 'N'
and ISNULL(AbuseVerbalVictim, 'N') = 'N'
and ISNULL(AbuseVerbalOffender, 'N') = 'N'
and ISNULL(AbusePhysicalVictim, 'N') = 'N'
and ISNULL(AbusePhysicalOffender, 'N') = 'N'
and ISNULL(AbuseSexualVictim, 'N') = 'N'
and ISNULL(AbuseSexualOffender, 'N') = 'N'
and ISNULL(AbuseNeglectVictim, 'N') = 'N'
and ISNULL(AbuseNeglectOffender, 'N') = 'N'
)

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Abuse Comment section required',1,17
FROM #CustomDocumentPsychiatricEvaluations
WHERE ISNULL(AbuseNotApplicable, 'Y') <> 'Y'
and LEN(LTRIM(RTRIM(ISNULL(AbuseComment, '')))) = 0
and ( ISNULL(AbuseEmotionalVictim, 'N') = 'Y'
or ISNULL(AbuseEmotionalOffender, 'N') = 'Y'
or ISNULL(AbuseVerbalVictim, 'N') = 'Y'
or ISNULL(AbuseVerbalOffender, 'N') = 'Y'
or ISNULL(AbusePhysicalVictim, 'N') = 'Y'
or ISNULL(AbusePhysicalOffender, 'N') = 'Y'
or ISNULL(AbuseSexualVictim, 'N') = 'Y'
or ISNULL(AbuseSexualOffender, 'N') = 'Y'
or ISNULL(AbuseNeglectVictim, 'N') = 'Y'
or ISNULL(AbuseNeglectOffender, 'N') = 'Y'
)

UNION
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Abuse Type selection required',1,18
FROM #CustomDocumentPsychiatricEvaluations
WHERE ISNULL(AbuseNotApplicable, 'Y') <> 'Y'
and ( ISNULL(AbuseEmotionalVictim, 'N') = 'N'
and ISNULL(AbuseEmotionalOffender, 'N') = 'N'
and ISNULL(AbuseVerbalVictim, 'N') = 'N'
and ISNULL(AbuseVerbalOffender, 'N') = 'N'
and ISNULL(AbusePhysicalVictim, 'N') = 'N'
and ISNULL(AbusePhysicalOffender, 'N') = 'N'
and ISNULL(AbuseSexualVictim, 'N') = 'N'
and ISNULL(AbuseSexualOffender, 'N') = 'N'
and ISNULL(AbuseNeglectVictim, 'N') = 'N'
and ISNULL(AbuseNeglectOffender, 'N') = 'N'
)

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Appetite selection required',1,19
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE ISNULL(AppetiteNormal, 'N') ='N'
--and ISNULL(AppetiteSurpressed, 'N') = 'N'
--and ISNULL(AppetiteExcessive, 'N') = 'N'

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Appetite Section - Only Normal can be selected',1,20
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE ISNULL(AppetiteNormal, '')='Y'
--and ( ISNULL(AppetiteSurpressed, '') = 'Y'
--or ISNULL(AppetiteExcessive, '')= 'Y'
--)

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Sleep Hygiene selection required',1,21
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE ISNULL(SleepHygieneNormal, 'N') = 'N'
--and ISNULL(SleepHygieneFrequentWaking, 'N') = 'N'
--and ISNULL(SleepHygieneProblemsFallingAsleep, 'N') = 'N'
--and ISNULL(SleepHygieneProblemsStayingAsleep, 'N') = 'N'
--and ISNULL(SleepHygieneNightmares, 'N') = 'N'
--and ISNULL(SleepHygieneOther, 'N') = 'N'

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Sleep Hygiene - Only Normal can be selected',1,22
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE ISNULL(SleepHygieneNormal, 'N') = 'Y'
--and ( ISNULL(SleepHygieneFrequentWaking, 'N') = 'Y'
--or ISNULL(SleepHygieneProblemsFallingAsleep, 'N') = 'Y'
--or ISNULL(SleepHygieneProblemsStayingAsleep, 'N') = 'Y'
--or ISNULL(SleepHygieneNightmares, 'N') = 'Y'
--or ISNULL(SleepHygieneOther, 'N') = 'Y'
--)

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - Sleep Comment section required',1,23
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE ISNULL(SleepHygieneOther, 'N') = 'Y'
--and ISNULL(SleepHygieneNormal, 'N') <> 'Y'
--and LEN(LTRIM(RTRIM(ISNULL(SleepHygieneComment, '')))) = 0


--Risk
UNION
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Ideation comment is required', 2, 33
from #CustomDocumentPsychiatricEvaluations
where RiskSuicideIdeation = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIdeationComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Suicide intent comment is required', 2, 34
from #CustomDocumentPsychiatricEvaluations
where RiskSuicideIntent = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIntentComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Suicide prior attempts comment is required', 2, 35
from #CustomDocumentPsychiatricEvaluations
where RiskSuicidePriorAttempts = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskSuicidePriorAttemptsComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Prior hospitalization comment is required', 2, 36
from #CustomDocumentPsychiatricEvaluations
where RiskPriorHospitalization = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPriorHospitalizationComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Physical agression to self comment is required', 2, 37
from #CustomDocumentPsychiatricEvaluations
where RiskPhysicalAggressionSelf = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionSelfComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Verbal agression to others comment is required', 2, 38
from #CustomDocumentPsychiatricEvaluations
where RiskVerbalAggressionOthers = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskVerbalAggressionOthersComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Physical agression to objects comment is required', 2, 39
from #CustomDocumentPsychiatricEvaluations
where RiskPhysicalAggressionObjects = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionObjectsComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - Physical agression to people comment is required', 2, 40
from #CustomDocumentPsychiatricEvaluations
where RiskPhysicalAggressionPeople = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionPeopleComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - risk taking/agressive behaviors comment is required', 2, 41
from #CustomDocumentPsychiatricEvaluations
where RiskReportRiskTaking = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskReportRiskTakingComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Risk - threats to client''s personal safety comment is required', 2, 42
from #CustomDocumentPsychiatricEvaluations
where RiskThreatClientPersonalSafety = 'Y'
and LEN(LTRIM(RTRIM(ISNULL(RiskThreatClientPersonalSafetyComment, '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Safety Plan - "Current risk identified" must be answered.', 2, 43
from #CustomDocumentPsychiatricEvaluations
where [RiskCurrentRiskIdentified] is null
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Safety Plan - Triggers for dangerous behaviors required', 2, 44
from #CustomDocumentPsychiatricEvaluations
where [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskTriggersDangerousBehaviors], '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Safety Plan - Coping skills required', 2, 45
from #CustomDocumentPsychiatricEvaluations
where [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskCopingSkills], '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Safety Plan - Interventions preferred by client/guardian for personal safety required', 2, 46
from #CustomDocumentPsychiatricEvaluations
where ISNULL([RiskInterventionsPersonalSafetyNA], 'N') <> 'Y' and [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPersonalSafety], '')))) = 0
union
select 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Safety Plan - Interventions preferred by client/guardian for public safety required', 2, 47
from #CustomDocumentPsychiatricEvaluations
where ISNULL([RiskInterventionsPublicSafetyNA], 'N') <> 'Y' and [RiskCurrentRiskIdentified] = 'Y'
and LEN(LTRIM(RTRIM(ISNULL([RiskInterventionsPublicSafety], '')))) = 0

--UNION
--SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Recommendation  - Please recommend pharmacologic management services on the recommendation tab',3,1
--FROM #CustomDocumentPsychiatricEvaluations
--WHERE LEN(LTRIM(RTRIM(ISNULL(MedicationsPrescribed, '')))) <> 0
--and isnull(CreateMedicatlTxPlan,'N') <> 'Y'

--UNION
--SELECT 'Services', 'DeletedBy','Service  - Client must be present for this Service' ,0,1
--FROM #CustomDocumentPsychiatricEvaluations c
--join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
--join Documents d on d.DocumentId = dv.DocumentId
--join Services s on s.ServiceId = d.ServiceId
--where isnull(s.ClientWasPresent,'N')<>'Y'

union
SELECT 'CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'Recommendation  - Please recommend pharmacologic management services on the recommendation tab, client has med services today' ,3,1
FROM #CustomDocumentPsychiatricEvaluations pe
where isnull(CreateMedicatlTxPlan,'N') <> 'Y'
and exists (
	select 1 from Services s 
	where isnull(s.RecordDeleted,'N')<>'Y'
	and s.ClientId = @ClientId 
	and dbo.RemoveTimeStamp(s.DateOfService) = dbo.RemoveTimeStamp(@EffectiveDate)
	and s.ProcedureCodeId in ( 
		 390 --Med_Youth
		,391 --Med_Ind
		) --Select * from ProcedureCodes where displayAs like 'Med_%'
	and s.Status in ( 70, 71, 75 )
)

UNION
SELECT 'Services', 'DeletedBy','Service  - Assessment service start time must be before this service',0,1
FROM #CustomDocumentPsychiatricEvaluations c
join DocumentVersions dv on dv.DocumentVersionId = c.DocumentVersionId
join Documents d on d.DocumentId = dv.DocumentId
join Services s1 on s1.ServiceId = d.ServiceId
where exists (
	select 1 from Services s 
	where isnull(s.RecordDeleted,'N')<>'Y'
	and s.ClientId = @ClientId 
	and dbo.RemoveTimeStamp(s.DateOfService) = dbo.RemoveTimeStamp(s1.DateOfService)
	and s.DateOfService > s1.DateOfService
	and s.ProcedureCodeId in ( 
		 24 --Assessment
		) --Select * from ProcedureCodes where displayAs like 'Ass%'
	and s.Status in ( 70, 71, 75 )
)


exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId 

/*exec dbo.csp_validateDiagnosis @DocumentVersionId*/

exec dbo.csp_ValidateCustomDocumentPsychiatricEvaluationReferralServices @DocumentVersionId

/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AppetiteNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AppetiteNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AppetiteSurpressed selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AppetiteSurpressed, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AppetiteExcessive selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AppetiteExcessive, '')))) = 0
*/



/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseEmotionalVictim selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseEmotionalVictim, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseEmotionalOffender selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseEmotionalOffender, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseVerbalVictim selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseVerbalVictim, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseVerbalOffender selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseVerbalOffender, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbusePhysicalVictim selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbusePhysicalVictim, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbusePhysicalOffender selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbusePhysicalOffender, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseSexualVictim selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseSexualVictim, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseSexualOffender selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseSexualOffender, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseNeglectVictim selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseNeglectVictim, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseNeglectOffender selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseNeglectOffender, '')))) = 0


UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AbuseComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AbuseComment, '')))) = 0
*/



/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - SleepHygieneFrequentWaking selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SleepHygieneFrequentWaking, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - SleepHygieneProblemsFallingAsleep selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SleepHygieneProblemsFallingAsleep, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - SleepHygieneProblemsStayingAsleep selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SleepHygieneProblemsStayingAsleep, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - SleepHygieneNightmares selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SleepHygieneNightmares, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - SleepHygieneOther selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SleepHygieneOther, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - SleepHygieneComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(SleepHygieneComment, '')))) = 0
*/

/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneUnderstandingLanguage selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneUnderstandingLanguage, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneVocabulary selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneVocabulary, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneFineMotor selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneFineMotor, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneGrossMotor selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneGrossMotor, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneIntellectual selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneIntellectual, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneMakingFriends selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneMakingFriends, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneSharingInterests selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneSharingInterests, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneEyeContact selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneEyeContact, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneToiletTraining selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneToiletTraining, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MilestoneCopingSkills selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MilestoneCopingSkills, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPeerRelationshipHistory section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPeerRelationshipHistory, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildEducationalHistorySchoolFunctioning section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildEducationalHistorySchoolFunctioning, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildBiologicalMotherSubstanceUse selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildBiologicalMotherSubstanceUse, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildBornFullTermPreTerm selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildBornFullTermPreTerm, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildBirthWeight section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildBirthWeight, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildBirthLength section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildBirthLength, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildApgarScore1 section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildApgarScore1, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildApgarScore2 section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildApgarScore2, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildApgarScore3 section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildApgarScore3, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildApgarScoreComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildApgarScoreComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildMotherPrenatalCare selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildMotherPrenatalCare, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPregnancyComplications selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPregnancyComplications, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPregnancyComplicationsComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPregnancyComplicationsComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildDeliveryComplications selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildDeliveryComplications, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildDeliveryComplicationsComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildDeliveryComplicationsComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildColic selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildColic, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildColicComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildColicComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildJaundice selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildJaundice, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildJaundiceComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildJaundiceComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildHospitalStayAfterDelievery section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildHospitalStayAfterDelievery, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildBiologicalMotherPostPartumDepression selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildBiologicalMotherPostPartumDepression, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPhyscicalAppearanceNoAbnormalities selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPhyscicalAppearanceNoAbnormalities, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPhyscicalAppearanceLowSetEars selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPhyscicalAppearanceLowSetEars, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPhyscicalAppearanceLowForehead selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPhyscicalAppearanceLowForehead, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPhyscicalAppearanceCleftLipPalate selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPhyscicalAppearanceCleftLipPalate, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPhyscicalAppearanceOther selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPhyscicalAppearanceOther, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPhyscicalAppearanceOtherComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPhyscicalAppearanceOtherComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildFineMotorSkillsNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildFineMotorSkillsNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildFineMotorSkillsProblemsDrawingWriting selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildFineMotorSkillsProblemsDrawingWriting, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildFineMotorSkillsProblemsScissors selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildFineMotorSkillsProblemsScissors, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildFineMotorSkillsProblemsZipping selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildFineMotorSkillsProblemsZipping, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildFineMotorSkillsProblemsTying selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildFineMotorSkillsProblemsTying, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPlayNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPlayNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPlayDangerous selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPlayDangerous, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPlayViolentTraumatic selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPlayViolentTraumatic, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPlayRepetitive selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPlayRepetitive, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildPlayEchopraxia selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildPlayEchopraxia, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildInteractionNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildInteractionNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildInteractionWithdrawn selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildInteractionWithdrawn, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildInteractionIndiscriminateFriendliness selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildInteractionIndiscriminateFriendliness, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildInteractionOther selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildInteractionOther, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildInteractionOtherComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildInteractionOtherComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalDelayed selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalDelayed, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalAdvanced selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalAdvanced, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalEcholalia selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalEcholalia, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalReducedComprehension selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalReducedComprehension, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalOther selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalOther, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildVerbalOtherComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildVerbalOtherComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildNonVerbalNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildNonVerbalNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildNonVerbalOther selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildNonVerbalOther, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildNonVerbalOtherComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildNonVerbalOtherComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildEaseOfSeperationNormal selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildEaseOfSeperationNormal, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildEaseOfSeperationExcessiveWorry selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildEaseOfSeperationExcessiveWorry, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildEaseOfSeperationNoResponse selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildEaseOfSeperationNoResponse, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildEaseOfSeperationOther selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildEaseOfSeperationOther, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - ChildEaseOfSeperationOtherComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(ChildEaseOfSeperationOtherComment, '')))) = 0
*/


/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskSuicideIdeation selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIdeation, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskSuicideIdeationComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIdeationComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskSuicideIntent selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIntent, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskSuicideIntentComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskSuicideIntentComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskSuicidePriorAttempts selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskSuicidePriorAttempts, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskSuicidePriorAttemptsComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskSuicidePriorAttemptsComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPriorHospitalization selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPriorHospitalization, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPriorHospitalizationComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPriorHospitalizationComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhysicalAggressionSelf selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionSelf, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhysicalAggressionSelfComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionSelfComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskVerbalAggressionOthers selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskVerbalAggressionOthers, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskVerbalAggressionOthersComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskVerbalAggressionOthersComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhysicalAggressionObjects selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionObjects, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhysicalAggressionObjectsComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionObjectsComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhysicalAggressionPeople selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionPeople, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhysicalAggressionPeopleComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhysicalAggressionPeopleComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskReportRiskTaking selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskReportRiskTaking, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskReportRiskTakingComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskReportRiskTakingComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskThreatClientPersonalSafety selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskThreatClientPersonalSafety, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskThreatClientPersonalSafetyComment section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskThreatClientPersonalSafetyComment, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskPhoneNumbersProvided selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskPhoneNumbersProvided, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskCurrentRiskIdentified selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskCurrentRiskIdentified, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskTriggersDangerousBehaviors section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskTriggersDangerousBehaviors, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskCopingSkills section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskCopingSkills, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskInterventionsPersonalSafetyNA selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskInterventionsPersonalSafetyNA, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskInterventionsPersonalSafety section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskInterventionsPersonalSafety, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskInterventionsPublicSafetyNA selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskInterventionsPublicSafetyNA, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - RiskInterventionsPublicSafety section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(RiskInterventionsPublicSafety, '')))) = 0
*/

/*
UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - DifferentialDiagnosisFormulation section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(DifferentialDiagnosisFormulation, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - LabTestsAndMonitoringOrdered section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(LabTestsAndMonitoringOrdered, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - TreatmentRecommendationsAndOrders section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(TreatmentRecommendationsAndOrders, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - MedicationsPrescribed section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(MedicationsPrescribed, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - OtherInstructions section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(OtherInstructions, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - TransferReceivingStaff section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(TransferReceivingStaff, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - TransferReceivingProgram section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(TransferReceivingProgram, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - TransferAssessedNeed section required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(TransferAssessedNeed, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - TransferClientParticipated selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(TransferClientParticipated, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - CreateMedicatlTxPlan selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(CreateMedicatlTxPlan, '')))) = 0

UNION
SELECT '#CustomDocumentPsychiatricEvaluations', 'DeletedBy', 'General  - AddGoalsToTxPlan selection required'
FROM #CustomDocumentPsychiatricEvaluations
WHERE LEN(LTRIM(RTRIM(ISNULL(AddGoalsToTxPlan, '')))) = 0

*/


--select * from #validationReturnTable
--drop table #validationReturnTable





