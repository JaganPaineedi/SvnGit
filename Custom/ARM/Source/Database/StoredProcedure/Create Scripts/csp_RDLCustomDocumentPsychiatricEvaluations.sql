/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentPsychiatricEvaluations]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentPsychiatricEvaluations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentPsychiatricEvaluations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentPsychiatricEvaluations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentPsychiatricEvaluations]
(
@DocumentVersionId  int
)
As

BEGIN TRY
BEGIN
/************************************************************************/
/* Stored Procedure: csp_RDLCustomDocumentPsychiatricEvaluations    */
/* Copyright: 2006 Streamline SmartCare         */
/* Creation Date:  July 13 ,2011          */
/*                  */
/* Purpose: Gets Data for CustomDocumentPsychiatricEvaluations       */
/*                  */
/* Input Parameters: @DocumentVersionId        */
/*                  */
/* Output Parameters:             */
/* Purpose Use For Rdl Report           */
/* Calls:                */
/*                  */
/* Author: Jagdeep Hundal             */
/* 2012.02.26 - T. Remisoski - Revisions for Child Evaluation.*/
/************************************************************************/
DECLARE @ClientDOB varchar(50)
DECLARE @ClientAge varchar(10)
DECLARE @ClientId int
declare @EffectiveDate datetime

SELECT @ClientId = ClientId, @EffectiveDate = EffectiveDate from Documents where
CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,''N'')= ''N''

SET @ClientDOB = (Select CONVERT(VARCHAR(10), DOB, 101) from Clients
    where ClientId=@ClientId and IsNull(RecordDeleted,''N'')=''N'')

SET @ClientDOB=''DOB: ''+@ClientDOB+ ISNULL('' (Age: '' + CAST(dbo.GetAge(@ClientDOB, @EffectiveDate) as varchar) +  '' years)'', '''')

DECLARE @StandardPatientInstructions varchar(max)

SET @StandardPatientInstructions=''• If you experience a psychiatric or medical emergency, call 911.

• If thoughts of harming yourself or someone else occur:
       o Call 911
       o Call Rescue Crisis – 24 hours/day 7 days/week at 419-255-9585
       o Call the National Suicide Prevention Hotline at 1-800-273-TALK (8255)
       o Call Harbor after hours at 419-475-4449
       o Seek help at the nearest emergency room

• Take all medications as prescribed. Should you have questions or concerns regarding your medication, or if you experience side effects to your medication, call the Harbor location where you see your prescriber.

• If you need refills before your next appointment, contact the Harbor location at which you attend at least 5 days before running out of medications.

• Obtain all medical tests including lab work if ordered by your prescriber.

• Pay special attention to instructions for your particular medications, such as whether to take with food, if you should take special precautions in the sunlight, etc.

• Do not take any prescription medications that are not prescribed to you by your provider(s). 

• Do not give your prescription medication to others.

• Make sure that at every appointment you let the medical staff know of any changes in your medication, herbs and supplements including those provided by prescribers not at Harbor.
''

SELECT CDPE.[DocumentVersionId]
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName
      ,Documents.ClientId
      ,Clients.LastName + '', '' + Clients.FirstName as ClientName
      ,S.LastName + '', '' + S.Firstname as ClinicianName
      ,LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as StartTime
      ,convert(varchar(10),SE.Unit)+'' ''+GC2.CodeName  as Duration
      ,GC3.CodeName as [Status]
      ,L.LocationName as Location
      ,PC.ProcedureCodeName as ProcedureName
      ,Documents.EffectiveDate
      ,SE.DiagnosisCode1 +'', ''+ SE.DiagnosisCode2 as AXISIANDII
      ,SE.OtherPersonsPresent as OtherPersonPresent
      ,SE.DiagnosisCode3 as AXISIII
      ,CDPE.[AdultOrChild]
      ,CDPE.[ChiefComplaint]
      ,CDPE.[PresentIllnessHistory]
      ,CDPE.[PastPsychiatricHistory]
      ,CDPE.[FamilyHistory]
      ,CDPE.[SubstanceAbuseHistory]
      ,CDPE.[GeneralMedicalHistory]
      ,CDPE.[CurrentBirthControlMedications]
      ,CDPE.[CurrentBirthControlMedicationRisks]
      ,CDPE.[MedicationSideEffects]
      ,CDPE.[PyschosocialHistory]
      ,CDPE.[OccupationalMilitaryHistory]
      ,CDPE.[LegalHistory]
      ,CDPE.[SupportSystems]
      ,CDPE.[EthnicityAndCulturalBackground]
      ,CDPE.[LivingArrangement]
      ,CDPE.[AbuseNotApplicable]
      ,CDPE.[AbuseEmotionalVictim]
      ,CDPE.[AbuseEmotionalOffender]
      ,CDPE.[AbuseVerbalVictim]
      ,CDPE.[AbuseVerbalOffender]
      ,CDPE.[AbusePhysicalVictim]
      ,CDPE.[AbusePhysicalOffender]
      ,CDPE.[AbuseSexualVictim]
      ,CDPE.[AbuseSexualOffender]
      ,CDPE.[AbuseNeglectVictim]
      ,CDPE.[AbuseNeglectOffender]
      ,CDPE.[AbuseComment]
      ,CDPE.[AppetiteNormal]
      ,CDPE.[AppetiteSurpressed]
      ,CDPE.[AppetiteExcessive]
      ,CDPE.[SleepHygieneNormal]
      ,CDPE.[SleepHygieneFrequentWaking]
      ,CDPE.[SleepHygieneProblemsFallingAsleep]
      ,CDPE.[SleepHygieneProblemsStayingAsleep]
      ,CDPE.[SleepHygieneNightmares]
      ,CDPE.[SleepHygieneOther]
      ,CDPE.[SleepHygieneComment]
      ,CDPE.[MilestoneUnderstandingLanguage]
      ,CDPE.[MilestoneVocabulary]
      ,CDPE.[MilestoneFineMotor]
      ,CDPE.[MilestoneGrossMotor]
      ,CDPE.[MilestoneIntellectual]
      ,CDPE.[MilestoneMakingFriends]
      ,CDPE.[MilestoneSharingInterests]
      ,CDPE.[MilestoneEyeContact]
      ,CDPE.[MilestoneToiletTraining]
      ,CDPE.[MilestoneCopingSkills]
      ,CDPE.[ChildPeerRelationshipHistory]
      ,CDPE.[ChildEducationalHistorySchoolFunctioning]
      ,CDPE.[ChildBiologicalMotherSubstanceUse]
      ,CDPE.[ChildBornFullTermPreTerm]
      ,CDPE.[ChildBirthWeight]
      ,CDPE.[ChildBirthLength]
      --,dbo.csf_GetGlobalCodeNameById(CDPE.[ChildApgarScore1]) as ChildApgarScore1
      --,dbo.csf_GetGlobalCodeNameById(CDPE.[ChildApgarScore2]) as ChildApgarScore2
      --,dbo.csf_GetGlobalCodeNameById(CDPE.[ChildApgarScore3]) as ChildApgarScore3
      ,cast(CDPE.[ChildApgarScore1] as varchar) as ChildApgarScore1
      ,cast(CDPE.[ChildApgarScore2] as varchar) as ChildApgarScore2
      ,cast(CDPE.[ChildApgarScore3] as varchar) as ChildApgarScore3
      ,CDPE.[ChildApgarScoreComment]
      ,CDPE.[ChildMotherPrenatalCare]
      ,CDPE.[ChildPregnancyComplications]
      ,CDPE.[ChildPregnancyComplicationsComment]
      ,CDPE.[ChildDeliveryComplications]
      ,CDPE.[ChildDeliveryComplicationsComment]
      ,CDPE.[ChildColic]
      ,CDPE.[ChildColicComment]
      ,CDPE.[ChildJaundice]
      ,CDPE.[ChildJaundiceComment]
      ,CDPE.[ChildHospitalStayAfterDelievery]
      ,CDPE.[ChildBiologicalMotherPostPartumDepression]
      ,CDPE.[ChildPhyscicalAppearanceNoAbnormalities]
      ,CDPE.[ChildPhyscicalAppearanceLowSetEars]
      ,CDPE.[ChildPhyscicalAppearanceLowForehead]
      ,CDPE.[ChildPhyscicalAppearanceCleftLipPalate]
      ,CDPE.[ChildPhyscicalAppearanceOther]
      ,CDPE.[ChildPhyscicalAppearanceOtherComment]
      ,CDPE.[ChildFineMotorSkillsNormal]
      ,CDPE.[ChildFineMotorSkillsProblemsDrawingWriting]
      ,CDPE.[ChildFineMotorSkillsProblemsScissors]
      ,CDPE.[ChildFineMotorSkillsProblemsZipping]
      ,CDPE.[ChildFineMotorSkillsProblemsTying]
      ,CDPE.[ChildPlayNormal]
      ,CDPE.[ChildPlayDangerous]
      ,CDPE.[ChildPlayViolentTraumatic]
      ,CDPE.[ChildPlayRepetitive]
      ,CDPE.[ChildPlayEchopraxia]
      ,CDPE.[ChildInteractionNormal]
      ,CDPE.[ChildInteractionWithdrawn]
      ,CDPE.[ChildInteractionIndiscriminateFriendliness]
      ,CDPE.[ChildInteractionOther]
      ,CDPE.[ChildInteractionOtherComment]
      ,CDPE.[ChildVerbalNormal]
      ,CDPE.[ChildVerbalDelayed]
      ,CDPE.[ChildVerbalAdvanced]
      ,CDPE.[ChildVerbalEcholalia]
      ,CDPE.[ChildVerbalReducedComprehension]
      ,CDPE.[ChildVerbalOther]
      ,CDPE.[ChildVerbalOtherComment]
      ,CDPE.[ChildNonVerbalNormal]
      ,CDPE.[ChildNonVerbalOther]
      ,CDPE.[ChildNonVerbalOtherComment]
      ,CDPE.[ChildEaseOfSeperationNormal]
      ,CDPE.[ChildEaseOfSeperationExcessiveWorry]
      ,CDPE.[ChildEaseOfSeperationNoResponse]
      ,CDPE.[ChildEaseOfSeperationOther]
      ,CDPE.[ChildEaseOfSeperationOtherComment]
      ,CDPE.[RiskSuicideIdeation]
      ,CDPE.[RiskSuicideIdeationComment]
      ,CDPE.[RiskSuicideIntent]
      ,CDPE.[RiskSuicideIntentComment]
      ,CDPE.[RiskSuicidePriorAttempts]
      ,CDPE.[RiskSuicidePriorAttemptsComment]
      ,CDPE.[RiskPriorHospitalization]
      ,CDPE.[RiskPriorHospitalizationComment]
      ,CDPE.[RiskPhysicalAggressionSelf]
      ,CDPE.[RiskPhysicalAggressionSelfComment]
      ,CDPE.[RiskVerbalAggressionOthers]
      ,CDPE.[RiskVerbalAggressionOthersComment]
      ,CDPE.[RiskPhysicalAggressionObjects]
      ,CDPE.[RiskPhysicalAggressionObjectsComment]
      ,CDPE.[RiskPhysicalAggressionPeople]
      ,CDPE.[RiskPhysicalAggressionPeopleComment]
      ,CDPE.[RiskReportRiskTaking]
      ,CDPE.[RiskReportRiskTakingComment]
      ,CDPE.[RiskThreatClientPersonalSafety]
      ,CDPE.[RiskThreatClientPersonalSafetyComment]
      ,CDPE.[RiskPhoneNumbersProvided]
      ,CDPE.[RiskCurrentRiskIdentified]
      ,CDPE.[RiskTriggersDangerousBehaviors]
      ,CDPE.[RiskCopingSkills]
      ,CDPE.[RiskInterventionsPersonalSafetyNA]
      ,CDPE.[RiskInterventionsPersonalSafety]
      ,CDPE.[RiskInterventionsPublicSafetyNA]
      ,CDPE.[RiskInterventionsPublicSafety]
      ,CDPE.[LabTestsAndMonitoringOrdered]
      ,CDPE.[TreatmentRecommendationsAndOrders]
      ,CDPE.[MedicationsPrescribed]
      ,CDPE.[OtherInstructions]
      ,CDPE.[TransferReceivingStaff]
      ,CDPE.[TransferReceivingProgram]
      ,CDPE.[TransferAssessedNeed]
      ,CDPE.[TransferClientParticipated]
      ,CDPE.[CreateMedicatlTxPlan]
      ,CDPE.[AddGoalsToTxPlan]
      ,@ClientDOB as [ClientDOB]
      ,ChildEval.ChildPhysicalAppearance
      ,ChildEval.ChildFineMotorSkills
      ,ChildEval.ChildPlay
      ,ChildEval.ChildInteraction
      ,ChildEval.ChildVerbal
      ,ChildEval.ChildNonVerbal
      ,ChildEval.ChildEaseOfSeparation
      ,@StandardPatientInstructions as StandardPatientInstructions
INTO  #CustomDocumentPsychiatricEvaluations
FROM Documents
JOIN DocumentVersions  ON Documents.DocumentId = DocumentVersions.DocumentId
LEFT JOIN CustomDocumentPsychiatricEvaluations AS CDPE ON CDPE.DocumentVersionId = DocumentVersions.DocumentVersionId
left join Services SE on Documents.ServiceId=SE.ServiceId
left join ProcedureCodes PC on  SE.ProcedureCodeId=PC.ProcedureCodeId
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId
left join GlobalCodes GC3 on SE.Status=GC3.GlobalCodeId
JOIN Clients ON Clients.ClientId = Documents.ClientId
left join Locations L on SE.LocationId=L.LocationId
join Staff S on Documents.AuthorId= S.StaffId
cross join (
	select
		case when RTRIM(a.ChildPhysicalAppearance) like ''%,'' then SUBSTRING(a.ChildPhysicalAppearance, 1, LEN(RTRIM(a.ChildPhysicalAppearance)) - 1) else a.ChildPhysicalAppearance end as ChildPhysicalAppearance,
		case when RTRIM(a.ChildFineMotorSkills) like ''%,'' then SUBSTRING(a.ChildFineMotorSkills, 1, LEN(RTRIM(a.ChildFineMotorSkills)) - 1) else a.ChildFineMotorSkills end as ChildFineMotorSkills,
		case when RTRIM(a.ChildPlay) like ''%,'' then SUBSTRING(a.ChildPlay, 1, LEN(RTRIM(a.ChildPlay)) - 1) else a.ChildPlay end as ChildPlay,
		case when RTRIM(a.ChildInteraction) like ''%,'' then SUBSTRING(a.ChildInteraction, 1, LEN(RTRIM(a.ChildInteraction)) - 1) else a.ChildInteraction end as ChildInteraction,
		case when RTRIM(a.ChildVerbal) like ''%,'' then SUBSTRING(a.ChildVerbal, 1, LEN(RTRIM(a.ChildVerbal)) - 1) else a.ChildVerbal end as ChildVerbal,
		case when RTRIM(a.ChildNonVerbal) like ''%,'' then SUBSTRING(a.ChildNonVerbal, 1, LEN(RTRIM(a.ChildNonVerbal)) - 1) else a.ChildNonVerbal end as ChildNonVerbal,
		case when RTRIM(a.ChildEaseOfSeparation) like ''%,'' then SUBSTRING(a.ChildEaseOfSeparation, 1, LEN(RTRIM(a.ChildEaseOfSeparation)) - 1) else a.ChildEaseOfSeparation end as ChildEaseOfSeparation
	from (
		select
		case when ChildPhyscicalAppearanceNoAbnormalities = ''Y'' then ''No Abnormalities, '' else '''' end
			+ case when ChildPhyscicalAppearanceLowSetEars = ''Y'' then ''Low Set Ears, '' else '''' end
			+ case when ChildPhyscicalAppearanceLowForehead = ''Y'' then ''Low Forehead, '' else '''' end
			+ case when ChildPhyscicalAppearanceCleftLipPalate = ''Y'' then ''Cleft Lip/Palate, '' else '''' end
			+ case when ChildPhyscicalAppearanceOther = ''Y'' then ''Other, '' else '''' end
		as ChildPhysicalAppearance,
		case when ChildFineMotorSkillsNormal = ''Y'' then ''Normal, '' else '''' end
			+ case when ChildFineMotorSkillsProblemsDrawingWriting = ''Y'' then ''Problems Drawing/Writing, '' else '''' end
			+ case when ChildFineMotorSkillsProblemsScissors = ''Y'' then ''Problems Using Scissors, '' else '''' end
			+ case when ChildFineMotorSkillsProblemsZipping = ''Y'' then ''Problems Zipping/Unzipping, '' else '''' end
			+ case when ChildFineMotorSkillsProblemsTying = ''Y'' then ''Problems Tying Shoes, '' else '''' end
		as ChildFineMotorSkills,
		case when ChildPlayNormal = ''Y'' then ''Normal, '' else '''' end
			+ case when ChildPlayDangerous = ''Y'' then ''Dangerous, '' else '''' end
			+ case when ChildPlayViolentTraumatic = ''Y'' then ''Violent/Traumatic, '' else '''' end
			+ case when ChildPlayRepetitive = ''Y'' then ''Repetitive, '' else '''' end
			+ case when ChildPlayEchopraxia = ''Y'' then ''ChildPlayEchopraxia, '' else '''' end
		as ChildPlay,
		case when ChildInteractionNormal = ''Y'' then ''Normal/Sociable, '' else '''' end
			+ case when ChildInteractionWithdrawn = ''Y'' then ''Withdrawn/Cold, '' else '''' end
			+ case when ChildInteractionIndiscriminateFriendliness = ''Y'' then ''Indiscriminate Friendliness/Affection, '' else '''' end
			+ case when ChildInteractionOther = ''Y'' then ''Abnormal/Other, '' else '''' end
		as ChildInteraction,
		case when ChildVerbalNormal = ''Y'' then ''Normal, '' else '''' end
			+ case when ChildVerbalDelayed = ''Y'' then ''Delayed, '' else '''' end
			+ case when ChildVerbalAdvanced = ''Y'' then ''Advanced, '' else '''' end
			+ case when ChildVerbalEcholalia = ''Y'' then ''Echolalia, '' else '''' end
			+ case when ChildVerbalReducedComprehension = ''Y'' then ''Reduced Comprehension, '' else '''' end
			+ case when ChildVerbalOther = ''Y'' then ''Abnormal/Other, '' else '''' end
		as ChildVerbal,
		case when ChildNonVerbalNormal = ''Y'' then ''Normal, '' else '''' end
			+ case when ChildNonVerbalOther = ''Y'' then ''Abnormal/Other, '' else '''' end
		as ChildNonVerbal,
		case when ChildEaseOfSeperationNormal = ''Y'' then ''Normal, '' else '''' end
			+ case when ChildEaseOfSeperationExcessiveWorry = ''Y'' then ''Excessive Worry/Hysteria, '' else '''' end
			+ case when ChildEaseOfSeperationNoResponse = ''Y'' then ''No Response, '' else '''' end
			+ case when ChildEaseOfSeperationOther = ''Y'' then ''Other, '' else '''' end
		as ChildEaseOfSeparation
		from dbo.CustomDocumentPsychiatricEvaluations where DocumentVersionId = @DocumentVersionId
	) as a
) as ChildEval
WHERE CDPE.DocumentVersionId =@DocumentVersionId
and ISNULL(Documents.RecordDeleted,''N'')=''N''
and ISNULL(DocumentVersions.RecordDeleted,''N'')=''N''
and ISNULL(CDPE.RecordDeleted,''N'')=''N''
and ISNULL(Clients.RecordDeleted,''N'')=''N''

--CustomDocumentMentalStatuses
SELECT CDMS.[DocumentVersionId]
      ,CDMS.[ConsciousnessNA]
      ,CDMS.[ConsciousnessAlert]
      ,CDMS.[ConsciousnessObtunded]
      ,CDMS.[ConsciousnessSomnolent]
      ,CDMS.[ConsciousnessOrientedX3]
      ,CDMS.[ConsciousnessAppearsUnderInfluence]
      ,CDMS.[ConsciousnessComment]
      ,CDMS.[EyeContactNA]
      ,CDMS.[EyeContactAppropriate]
      ,CDMS.[EyeContactStaring]
      ,CDMS.[EyeContactAvoidant]
      ,CDMS.[EyeContactComment]
      ,CDMS.[AppearanceNA]
      ,CDMS.[AppearanceClean]
      ,CDMS.[AppearanceNeatlyDressed]
      ,CDMS.[AppearanceAppropriate]
      ,CDMS.[AppearanceDisheveled]
      ,CDMS.[AppearanceMalodorous]
      ,CDMS.[AppearanceUnusual]
      ,CDMS.[AppearancePoorlyGroomed]
      ,CDMS.[AppearanceComment]
      ,CDMS.[AgeNA]
      ,CDMS.[AgeAppropriate]
      ,CDMS.[AgeOlder]
      ,CDMS.[AgeYounger]
      ,CDMS.[AgeComment]
      ,CDMS.[BehaviorNA]
      ,CDMS.[BehaviorPleasant]
      ,CDMS.[BehaviorGuarded]
      ,CDMS.[BehaviorAgitated]
      ,CDMS.[BehaviorImpulsive]
      ,CDMS.[BehaviorWithdrawn]
      ,CDMS.[BehaviorUncooperative]
      ,CDMS.[BehaviorAggressive]
      ,CDMS.[BehaviorComment]
      ,CDMS.[PsychomotorNA]
      ,CDMS.[PsychomotorNoAbnormalMovements]
      ,CDMS.[PsychomotorAgitation]
      ,CDMS.[PsychomotorAbnormalMovements]
      ,CDMS.[PsychomotorRetardation]
      ,CDMS.[PsychomotorComment]
      ,CDMS.[MoodNA]
      ,CDMS.[MoodEuthymic]
      ,CDMS.[MoodDysphoric]
      ,CDMS.[MoodIrritable]
      ,CDMS.[MoodDepressed]
      ,CDMS.[MoodExpansive]
      ,CDMS.[MoodAnxious]
      ,CDMS.[MoodElevated]
      ,CDMS.[MoodComment]
      ,CDMS.[ThoughtContentNA]
      ,CDMS.[ThoughtContentWithinLimits]
      ,CDMS.[ThoughtContentExcessiveWorries]
      ,CDMS.[ThoughtContentOvervaluedIdeas]
      ,CDMS.[ThoughtContentRuminations]
      ,CDMS.[ThoughtContentPhobias]
      ,CDMS.[ThoughtContentComment]
      ,CDMS.[DelusionsNA]
      ,CDMS.[DelusionsNone]
      ,CDMS.[DelusionsBizarre]
      ,CDMS.[DelusionsReligious]
      ,CDMS.[DelusionsGrandiose]
      ,CDMS.[DelusionsParanoid]
      ,CDMS.[DelusionsComment]
      ,CDMS.[ThoughtProcessNA]
      ,CDMS.[ThoughtProcessLogical]
      ,CDMS.[ThoughtProcessCircumferential]
      ,CDMS.[ThoughtProcessFlightIdeas]
      ,CDMS.[ThoughtProcessIllogical]
      ,CDMS.[ThoughtProcessDerailment]
      ,CDMS.[ThoughtProcessTangential]
      ,CDMS.[ThoughtProcessSomatic]
      ,CDMS.[ThoughtProcessCircumstantial]
      ,CDMS.[ThoughtProcessComment]
      ,CDMS.[HallucinationsNA]
      ,CDMS.[HallucinationsNone]
      ,CDMS.[HallucinationsAuditory]
      ,CDMS.[HallucinationsVisual]
      ,CDMS.[HallucinationsTactile]
      ,CDMS.[HallucinationsOlfactory]
      ,CDMS.[HallucinationsComment]
      ,CDMS.[IntellectNA]
      ,CDMS.[IntellectAverage]
      ,CDMS.[IntellectAboveAverage]
      ,CDMS.[IntellectBelowAverage]
      ,CDMS.[IntellectComment]
      ,CDMS.[SpeechNA]
      ,CDMS.[SpeechRate]
      ,CDMS.[SpeechTone]
      ,CDMS.[SpeechVolume]            ,CDMS.[SpeechArticulation]
      ,CDMS.[SpeechComment]
      ,CDMS.[AffectNA]
      ,CDMS.[AffectCongruent]
      ,CDMS.[AffectReactive]
      ,CDMS.[AffectIncongruent]
      ,CDMS.[AffectLabile]
      ,CDMS.[AffectComment]
      ,CDMS.[RangeNA]
      ,CDMS.[RangeBroad]
      ,CDMS.[RangeBlunted]
      ,CDMS.[RangeFlat]
      ,CDMS.[RangeFull]
      ,CDMS.[RangeConstricted]
      ,CDMS.[RangeComment]
      ,CDMS.[InsightNA]
      ,CDMS.[InsightExcellent]
      ,CDMS.[InsightGood]
      ,CDMS.[InsightFair]
      ,CDMS.[InsightPoor]
      ,CDMS.[InsightImpaired]
      ,CDMS.[InsightUnknown]
      ,CDMS.[InsightComment]
      ,CDMS.[JudgmentNA]
      ,CDMS.[JudgmentExcellent]
      ,CDMS.[JudgmentGood]
      ,CDMS.[JudgmentFair]
      ,CDMS.[JudgmentPoor]
      ,CDMS.[JudgmentImpaired]
      ,CDMS.[JudgmentUnknown]
      ,CDMS.[JudgmentComment]
      ,CDMS.[MemoryNA]
      ,CDMS.[MemoryShortTerm]
      ,CDMS.[MemoryLongTerm]
      ,CDMS.[MemoryAttention]
      ,CDMS.[MemoryComment]
      ,CDMS.[BodyHabitusNA]
      ,CDMS.[BodyHabitusAverage]
      ,CDMS.[BodyHabitusThin]
      ,CDMS.[BodyHabitusUnderweight]
      ,CDMS.[BodyHabitusOverweight]
      ,CDMS.[BodyHabitusObese]
      ,CDMS.[BodyHabitusComment]

INTO #CustomDocumentMentalStatuses
FROM CustomDocumentMentalStatuses AS CDMS
WHERE CDMS.DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted, ''N'') = ''N''

SELECT CDPE.[DocumentVersionId]
	  ,ClientName
	  ,ClinicianName
	  ,ClientId
	  ,OrganizationName
	  ,StartTime
	  ,ProcedureName
	  ,EffectiveDate
	  ,Location
	  ,Status
	  ,Duration
	  ,AXISIANDII
	  ,AXISIII
	  ,OtherPersonPresent
      ,CDPE.[AdultOrChild]
      ,CDPE.[ChiefComplaint]
      ,CDPE.[PresentIllnessHistory]
      ,CDPE.[PastPsychiatricHistory]
      ,CDPE.[FamilyHistory]
      ,CDPE.[SubstanceAbuseHistory]
      ,CDPE.[GeneralMedicalHistory]
      ,CDPE.[CurrentBirthControlMedications]
      ,CDPE.[CurrentBirthControlMedicationRisks]
      ,CDPE.[MedicationSideEffects]
      ,CDPE.[PyschosocialHistory]
      ,CDPE.[OccupationalMilitaryHistory]
   ,CDPE.[LegalHistory]
      ,CDPE.[SupportSystems]
      ,CDPE.[EthnicityAndCulturalBackground]
      ,CDPE.[LivingArrangement]
      ,CDPE.[AbuseNotApplicable]
      ,CDPE.[AbuseEmotionalVictim]
      ,CDPE.[AbuseEmotionalOffender]
      ,CDPE.[AbuseVerbalVictim]
      ,CDPE.[AbuseVerbalOffender]
      ,CDPE.[AbusePhysicalVictim]
      ,CDPE.[AbusePhysicalOffender]
      ,CDPE.[AbuseSexualVictim]
      ,CDPE.[AbuseSexualOffender]
      ,CDPE.[AbuseNeglectVictim]
      ,CDPE.[AbuseNeglectOffender]
      ,CDPE.[AbuseComment]
      ,CDPE.[AppetiteNormal]
      ,CDPE.[AppetiteSurpressed]
      ,CDPE.[AppetiteExcessive]
      ,CDPE.[SleepHygieneNormal]
      ,CDPE.[SleepHygieneFrequentWaking]
      ,CDPE.[SleepHygieneProblemsFallingAsleep]
      ,CDPE.[SleepHygieneProblemsStayingAsleep]
      ,CDPE.[SleepHygieneNightmares]
      ,CDPE.[SleepHygieneOther]
      ,CDPE.[SleepHygieneComment]
      ,CDPE.[MilestoneUnderstandingLanguage]
      ,CDPE.[MilestoneVocabulary]
      ,CDPE.[MilestoneFineMotor]
      ,CDPE.[MilestoneGrossMotor]
      ,CDPE.[MilestoneIntellectual]
      ,CDPE.[MilestoneMakingFriends]
      ,CDPE.[MilestoneSharingInterests]
      ,CDPE.[MilestoneEyeContact]
      ,CDPE.[MilestoneToiletTraining]
      ,CDPE.[MilestoneCopingSkills]
      ,CDPE.[ChildPeerRelationshipHistory]
      ,CDPE.[ChildEducationalHistorySchoolFunctioning]
      ,CDPE.[ChildBiologicalMotherSubstanceUse]
      ,CDPE.[ChildBornFullTermPreTerm]
      ,CDPE.[ChildBirthWeight]
      ,CDPE.[ChildBirthLength]
      ,CDPE.[ChildApgarScore1]
      ,CDPE.[ChildApgarScore2]
      ,CDPE.[ChildApgarScore3]
      ,CDPE.[ChildApgarScoreComment]
      ,CDPE.[ChildMotherPrenatalCare]
      ,CDPE.[ChildPregnancyComplications]
      ,CDPE.[ChildPregnancyComplicationsComment]
      ,CDPE.[ChildDeliveryComplications]
      ,CDPE.[ChildDeliveryComplicationsComment]
      ,CDPE.[ChildColic]
      ,CDPE.[ChildColicComment]
      ,CDPE.[ChildJaundice]
      ,CDPE.[ChildJaundiceComment]
      ,CDPE.[ChildHospitalStayAfterDelievery]
      ,CDPE.[ChildBiologicalMotherPostPartumDepression]
      ,CDPE.[ChildPhyscicalAppearanceNoAbnormalities]
      ,CDPE.[ChildPhyscicalAppearanceLowSetEars]
      ,CDPE.[ChildPhyscicalAppearanceLowForehead]
      ,CDPE.[ChildPhyscicalAppearanceCleftLipPalate]
      ,CDPE.[ChildPhyscicalAppearanceOther]
      ,CDPE.[ChildPhyscicalAppearanceOtherComment]
      ,CDPE.[ChildFineMotorSkillsNormal]
      ,CDPE.[ChildFineMotorSkillsProblemsDrawingWriting]
      ,CDPE.[ChildFineMotorSkillsProblemsScissors]
      ,CDPE.[ChildFineMotorSkillsProblemsZipping]
      ,CDPE.[ChildFineMotorSkillsProblemsTying]
      ,CDPE.[ChildPlayNormal]
      ,CDPE.[ChildPlayDangerous]
      ,CDPE.[ChildPlayViolentTraumatic]
      ,CDPE.[ChildPlayRepetitive]
      ,CDPE.[ChildPlayEchopraxia]
      ,CDPE.[ChildInteractionNormal]
      ,CDPE.[ChildInteractionWithdrawn]
      ,CDPE.[ChildInteractionIndiscriminateFriendliness]
      ,CDPE.[ChildInteractionOther]
      ,CDPE.[ChildInteractionOtherComment]
      ,CDPE.[ChildVerbalNormal]
      ,CDPE.[ChildVerbalDelayed]
      ,CDPE.[ChildVerbalAdvanced]
      ,CDPE.[ChildVerbalEcholalia]
      ,CDPE.[ChildVerbalReducedComprehension]
      ,CDPE.[ChildVerbalOther]
      ,CDPE.[ChildVerbalOtherComment]
      ,CDPE.[ChildNonVerbalNormal]
      ,CDPE.[ChildNonVerbalOther]
      ,CDPE.[ChildNonVerbalOtherComment]
      ,CDPE.[ChildEaseOfSeperationNormal]
      ,CDPE.[ChildEaseOfSeperationExcessiveWorry]
      ,CDPE.[ChildEaseOfSeperationNoResponse]
      ,CDPE.[ChildEaseOfSeperationOther]
      ,CDPE.[ChildEaseOfSeperationOtherComment]
      ,CDPE.[RiskSuicideIdeation]
      ,CDPE.[RiskSuicideIdeationComment]
      ,CDPE.[RiskSuicideIntent]
  ,CDPE.[RiskSuicideIntentComment]
      ,CDPE.[RiskSuicidePriorAttempts]
      ,CDPE.[RiskSuicidePriorAttemptsComment]
      ,CDPE.[RiskPriorHospitalization]
      ,CDPE.[RiskPriorHospitalizationComment]
      ,CDPE.[RiskPhysicalAggressionSelf]
      ,CDPE.[RiskPhysicalAggressionSelfComment]
      ,CDPE.[RiskVerbalAggressionOthers]
      ,CDPE.[RiskVerbalAggressionOthersComment]
      ,CDPE.[RiskPhysicalAggressionObjects]
      ,CDPE.[RiskPhysicalAggressionObjectsComment]
      ,CDPE.[RiskPhysicalAggressionPeople]
      ,CDPE.[RiskPhysicalAggressionPeopleComment]
      ,CDPE.[RiskReportRiskTaking]
      ,CDPE.[RiskReportRiskTakingComment]
      ,CDPE.[RiskThreatClientPersonalSafety]
      ,CDPE.[RiskThreatClientPersonalSafetyComment]
      ,CDPE.[RiskPhoneNumbersProvided]
      ,CDPE.[RiskCurrentRiskIdentified]
      ,CDPE.[RiskTriggersDangerousBehaviors]
      ,CDPE.[RiskCopingSkills]
      ,CDPE.[RiskInterventionsPersonalSafetyNA]
      ,CDPE.[RiskInterventionsPersonalSafety]
      ,CDPE.[RiskInterventionsPublicSafetyNA]
      ,CDPE.[RiskInterventionsPublicSafety]
      ,CDPE.[LabTestsAndMonitoringOrdered]
      ,CDPE.[TreatmentRecommendationsAndOrders]
      ,CDPE.[MedicationsPrescribed]
      ,CDPE.[OtherInstructions]
      ,CDPE.[TransferReceivingStaff]
      ,CDPE.[TransferReceivingProgram]
      ,CDPE.[TransferAssessedNeed]
      ,CDPE.[TransferClientParticipated]
      ,CDPE.[CreateMedicatlTxPlan]
      ,CDPE.[AddGoalsToTxPlan]
      ,CDMS.[ConsciousnessNA]
      ,CDMS.[ConsciousnessAlert]
      ,CDMS.[ConsciousnessObtunded]
      ,CDMS.[ConsciousnessSomnolent]
      ,CDMS.[ConsciousnessOrientedX3]
      ,CDMS.[ConsciousnessAppearsUnderInfluence]
      ,CDMS.[ConsciousnessComment]
      ,CDMS.[EyeContactNA]
      ,CDMS.[EyeContactAppropriate]
      ,CDMS.[EyeContactStaring]
      ,CDMS.[EyeContactAvoidant]
      ,CDMS.[EyeContactComment]
      ,CDMS.[AppearanceNA]
      ,CDMS.[AppearanceClean]
      ,CDMS.[AppearanceNeatlyDressed]
      ,CDMS.[AppearanceAppropriate]
      ,CDMS.[AppearanceDisheveled]
      ,CDMS.[AppearanceMalodorous]
      ,CDMS.[AppearanceUnusual]
      ,CDMS.[AppearancePoorlyGroomed]
      ,CDMS.[AppearanceComment]
      ,CDMS.[AgeNA]
      ,CDMS.[AgeAppropriate]
      ,CDMS.[AgeOlder]
      ,CDMS.[AgeYounger]
      ,CDMS.[AgeComment]
      ,CDMS.[BehaviorNA]
      ,CDMS.[BehaviorPleasant]
      ,CDMS.[BehaviorGuarded]
      ,CDMS.[BehaviorAgitated]
      ,CDMS.[BehaviorImpulsive]
      ,CDMS.[BehaviorWithdrawn]
      ,CDMS.[BehaviorUncooperative]
      ,CDMS.[BehaviorAggressive]
      ,CDMS.[BehaviorComment]
      ,CDMS.[PsychomotorNA]
      ,CDMS.[PsychomotorNoAbnormalMovements]
      ,CDMS.[PsychomotorAgitation]
      ,CDMS.[PsychomotorAbnormalMovements]
      ,CDMS.[PsychomotorRetardation]
      ,CDMS.[PsychomotorComment]
      ,CDMS.[MoodNA]
      ,CDMS.[MoodEuthymic]
      ,CDMS.[MoodDysphoric]
      ,CDMS.[MoodIrritable]
      ,CDMS.[MoodDepressed]
      ,CDMS.[MoodExpansive]
      ,CDMS.[MoodAnxious]
      ,CDMS.[MoodElevated]
      ,CDMS.[MoodComment]
      ,CDMS.[ThoughtContentNA]
      ,CDMS.[ThoughtContentWithinLimits]
      ,CDMS.[ThoughtContentExcessiveWorries]
      ,CDMS.[ThoughtContentOvervaluedIdeas]
      ,CDMS.[ThoughtContentRuminations]
      ,CDMS.[ThoughtContentPhobias]
      ,CDMS.[ThoughtContentComment]
      ,CDMS.[DelusionsNA]
      ,CDMS.[DelusionsNone]
      ,CDMS.[DelusionsBizarre]
      ,CDMS.[DelusionsReligious]
      ,CDMS.[DelusionsGrandiose]
      ,CDMS.[DelusionsParanoid]
      ,CDMS.[DelusionsComment]
      ,CDMS.[ThoughtProcessNA]
      ,CDMS.[ThoughtProcessLogical]
      ,CDMS.[ThoughtProcessCircumferential]
      ,CDMS.[ThoughtProcessFlightIdeas]
      ,CDMS.[ThoughtProcessIllogical]
      ,CDMS.[ThoughtProcessDerailment]
      ,CDMS.[ThoughtProcessTangential]
      ,CDMS.[ThoughtProcessSomatic]
      ,CDMS.[ThoughtProcessCircumstantial]
      ,CDMS.[ThoughtProcessComment]
      ,CDMS.[HallucinationsNA]
      ,CDMS.[HallucinationsNone]
      ,CDMS.[HallucinationsAuditory]
      ,CDMS.[HallucinationsVisual]
      ,CDMS.[HallucinationsTactile]
      ,CDMS.[HallucinationsOlfactory]
      ,CDMS.[HallucinationsComment]
      ,CDMS.[IntellectNA]
      ,CDMS.[IntellectAverage]
      ,CDMS.[IntellectAboveAverage]
      ,CDMS.[IntellectBelowAverage]
      ,CDMS.[IntellectComment]
      ,CDMS.[SpeechNA]
      ,CDMS.[SpeechRate]
      ,CDMS.[SpeechTone]
      ,CDMS.[SpeechVolume]
      ,CDMS.[SpeechArticulation]
      ,CDMS.[SpeechComment]
      ,CDMS.[AffectNA]
      ,CDMS.[AffectCongruent]
      ,CDMS.[AffectReactive]
      ,CDMS.[AffectIncongruent]
      ,CDMS.[AffectLabile]
      ,CDMS.[AffectComment]
      ,CDMS.[RangeNA]
      ,CDMS.[RangeBroad]
      ,CDMS.[RangeBlunted]
      ,CDMS.[RangeFlat]
      ,CDMS.[RangeFull]
      ,CDMS.[RangeConstricted]
      ,CDMS.[RangeComment]
      ,CDMS.[InsightNA]
      ,CDMS.[InsightExcellent]
      ,CDMS.[InsightGood]
      ,CDMS.[InsightFair]
      ,CDMS.[InsightPoor]
      ,CDMS.[InsightImpaired]
      ,CDMS.[InsightUnknown]
      ,CDMS.[InsightComment]
      ,CDMS.[JudgmentNA]
      ,CDMS.[JudgmentExcellent]
      ,CDMS.[JudgmentGood]
      ,CDMS.[JudgmentFair]
      ,CDMS.[JudgmentPoor]
      ,CDMS.[JudgmentImpaired]
      ,CDMS.[JudgmentUnknown]
      ,CDMS.[JudgmentComment]
      ,CDMS.[MemoryNA]
      ,CDMS.[MemoryShortTerm]
      ,CDMS.[MemoryLongTerm]
      ,CDMS.[MemoryAttention]
      ,CDMS.[MemoryComment]
      ,CDMS.[BodyHabitusNA]
      ,CDMS.[BodyHabitusAverage]
      ,CDMS.[BodyHabitusThin]
      ,CDMS.[BodyHabitusUnderweight]
      ,CDMS.[BodyHabitusOverweight]
      ,CDMS.[BodyHabitusObese]
      ,CDMS.[BodyHabitusComment]
      ,ClientDOB
      ,CDPE.ChildPhysicalAppearance
      ,CDPE.ChildFineMotorSkills
      ,CDPE.ChildPlay
      ,CDPE.ChildInteraction
      ,CDPE.ChildVerbal
      ,CDPE.ChildNonVerbal
      ,CDPE.ChildEaseOfSeparation
      ,CDPE.StandardPatientInstructions
FROM #CustomDocumentPsychiatricEvaluations CDPE
left join #CustomDocumentMentalStatuses CDMS on CDPE.DocumentVersionId = CDMS.DocumentVersionId

drop table #CustomDocumentPsychiatricEvaluations
drop table #CustomDocumentMentalStatuses


END
END TRY
--Checking For Errors
BEGIN CATCH
   DECLARE @Error varchar(8000)
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_CustomDocumentDiagnosticAssessments'')
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )

END CATCH
' 
END
GO
