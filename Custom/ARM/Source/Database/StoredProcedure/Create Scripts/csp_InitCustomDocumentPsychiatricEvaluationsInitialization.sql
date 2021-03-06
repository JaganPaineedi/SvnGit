/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentPsychiatricEvaluationsInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentPsychiatricEvaluationsInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentPsychiatricEvaluationsInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentPsychiatricEvaluationsInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentPsychiatricEvaluationsInitialization]
(
 @ClientID int,
 @StaffID int,
 @CustomParameters xml
)
As
 /*********************************************************************/
 /* Stored Procedure: [csp_InitCustomDocumentPsychiatricEvaluationsInitialization]               */
 /* Creation Date:  11/July/2011                                    */
 /*                                                                   */
 /* Purpose: To Initialize */
 /*                                                                   */
 /* Input Parameters:  */
 /*                                                                   */
 /* Output Parameters:                                */
 /*                                                                   */
 /* Return:   */
 /*                                                                   */
 /* Called By:CustomDocuments Class Of DataService    */
 /*      */
 /*                                                                   */
 /* Calls:                                                            */
 /*                                                                   */
 /* Data Modifications:                                               */
 /*                                                                   */
 /*   Updates:                                                          */

 /*       Date              Author                  Purpose    */
 /*  11/July/2011   Jagdeep     Creation  */
 /*  July 21, 2012	Pralyankar	Modified for implementing the Placeholder Concept*/
 /*********************************************************************/
Begin
Begin try
DECLARE @LatestDocumentVersionID int
DECLARE @clientDOB varchar(50)
DECLARE @clientAge varchar(10)
DECLARE @clientGender char(1)
DECLARE @index int
DECLARE @Age int
DECLARE @AdultOrChild char(1)
DECLARE @LatestDAVersionId int
declare @LatestDxVersionId int



SET @clientDOB = (Select CONVERT(VARCHAR(10), DOB, 101) from Clients
    where ClientId=@ClientID and IsNull(RecordDeleted,''N'')=''N'')
Exec csp_CalculateAge @ClientId, @clientAge out

SET @clientDOB=''DOB: ''+@clientDOB+'' (Age: '' +@clientAge+'')''

set @index=(select CHARINDEX('' '', @clientAge ))
set @Age = substring(@clientAge,0,@index)

SET @clientGender = (Select  Sex from Clients
    where ClientId=@ClientID and IsNull(RecordDeleted,''N'')=''N'')

  if(@Age>=18)
   set @AdultOrChild=''A''
   else
    set @AdultOrChild=''C''




--declare @defaultPatientInstructions varchar(MAX)
--set @defaultPatientInstructions = ''• If you experience a psychiatric or medical emergency, call 911.

--• If thoughts of harming yourself or someone else occur:
--       o Call 911
--       o Call Rescue Crisis – 24 hours/day 7 days/week at 419-255-9585
--       o Call the National Suicide Prevention Hotline at 1-800-273-TALK (8255)
--       o Call Harbor after hours at 419-475-4449
--       o Seek help at the nearest emergency room

--• Take all medications as prescribed. Should you have questions or concerns regarding your medication, or if you experience side effects to your medication, call the Harbor location where you see your prescriber.

--• If you need refills before your next appointment, contact the Harbor location at which you attend at least 5 days before running out of medications.

--• Obtain all medical tests including lab work if ordered by your prescriber.

--• Pay special attention to instructions for your particular medications, such as whether to take with food, if you should take special precautions in the sunlight, etc.

--• Do not take any prescription medications that are not prescribed to you by your provider(s).

--• Do not give your prescription medication to others.

--• Make sure that at every appointment you let the medical staff know of any changes in your medication, herbs and supplements including those provided by prescribers not at Harbor.
--''

SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocumentPsychiatricEvaluations C,Documents D
  where C.DocumentVersionId=D.CurrentDocumentVersionId and D.ClientId=@ClientID
 and D.Status=22 and DocumentCodeId =1489 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''
 ORDER BY D.EffectiveDate DESC,D.ModifiedDate desc   )

 SET @LatestDAVersionId =(
	SELECT TOP 1 D.CurrentDocumentVersionId 
	from CustomDocumentDiagnosticAssessments C
	join Documents D on D.CurrentDocumentVersionId = c.DocumentVersionId
  where D.ClientId=@ClientID
  and ((D.Status=22 ) or (D.Status = 21 and D.DocumentShared = ''Y''))
  and IsNull(C.RecordDeleted,''N'')=''N'' 
  and IsNull(D.RecordDeleted,''N'')=''N''
  ORDER BY D.EffectiveDate DESC,D.ModifiedDate desc)

SELECT top 1 Placeholder.TableName,ISNULL(CDPE.DocumentVersionId,-1) AS DocumentVersionId
,CDPE.[CreatedBy]
,CDPE.[CreatedDate]
,CDPE.[ModifiedBy]
,CDPE.[ModifiedDate]
,CDPE.[RecordDeleted]
,CDPE.[DeletedBy]
,CDPE.[DeletedDate]
,@AdultOrChild as [AdultOrChild]
,isnull(da.PresentingProblem, CDPE.[ChiefComplaint]) as ChiefComplaint
,CDPE.[PresentIllnessHistory]
,isnull(da.ClientPriorTreatmentDiagnosis, CDPE.[PastPsychiatricHistory]) as PastPsychiatricHistory
,CDPE.[FamilyHistory]
,isnull(ISNULL(da.ClientHistorySubstanceUseComment, da.ClientReportDrugUseComment), CDPE.[SubstanceAbuseHistory]) as SubstanceAbuseHistory
,CDPE.[GeneralMedicalHistory]
,CDPE.[CurrentBirthControlMedications]
,CDPE.[CurrentBirthControlMedicationRisks]
,CDPE.[MedicationSideEffects]
,CDPE.PyschosocialHistory
,isnull(da.ClientEmploymentMilitaryHistory, CDPE.[OccupationalMilitaryHistory]) as OccupationalMilitaryHistory
,isnull(da.LegalInvolvementComment, CDPE.[LegalHistory]) as LegalHistory
,isnull(da.SupportSystems, CDPE.[SupportSystems]) as SupportSystems
,isnull(da.EthnicityCulturalBackground, CDPE.[EthnicityAndCulturalBackground]) as EthnicityAndCulturalBackground
,isnull(da.LivingSituation, CDPE.[LivingArrangement]) as LivingArrangement
,isnull(da.AbuseNotApplicable, CDPE.[AbuseNotApplicable]) as AbuseNotApplicable
,isnull(da.AbuseEmotionalVictim, CDPE.[AbuseEmotionalVictim]) as AbuseEmotionalVictim
,isnull(da.AbuseEmotionalOffender, CDPE.[AbuseEmotionalOffender]) as AbuseEmotionalOffender
,isnull(da.AbuseVerbalVictim, CDPE.[AbuseVerbalVictim]) as AbuseVerbalVictim
,isnull(da.AbuseVerbalOffender, CDPE.[AbuseVerbalOffender]) as AbuseVerbalOffender
,isnull(da.AbusePhysicalVictim, CDPE.[AbusePhysicalVictim]) as AbusePhysicalVictim
,isnull(da.AbusePhysicalOffender, CDPE.[AbusePhysicalOffender]) as AbusePhysicalOffender
,isnull(da.AbuseSexualVictim, CDPE.[AbuseSexualVictim]) as AbuseSexualVictim
,isnull(da.AbuseSexualOffender, CDPE.[AbuseSexualOffender]) as AbuseSexualOffender
,isnull(da.AbuseNeglectVictim, CDPE.[AbuseNeglectVictim]) as AbuseNeglectVictim
,isnull(da.AbuseNeglectOffender, CDPE.[AbuseNeglectOffender]) as AbuseNeglectOffender
,isnull(da.AbuseComment, CDPE.[AbuseComment]) as AbuseComment
,CDPE.[AppetiteNormal]
,CDPE.[AppetiteSurpressed]
,CDPE.[AppetiteExcessive]
,CDPE.[SleepHygieneNormal]
,CDPE.[SleepHygieneFrequentWaking]
,CDPE.[SleepHygieneProblemsFallingAsleep]
,CDPE.[SleepHygieneProblemsStayingAsleep]
,isnull(case when da.SleepNightmares = ''Y'' or da.SleepTerrors = ''Y'' then ''Y'' else null end, CDPE.[SleepHygieneNightmares]) as SleepHygieneNightmares
,CDPE.[SleepHygieneOther]
,CDPE.[SleepHygieneComment]
,isnull(da.MilestoneUnderstandingLanguage, CDPE.[MilestoneUnderstandingLanguage]) as MilestoneUnderstandingLanguage
,isnull(da.MilestoneVocabulary, CDPE.[MilestoneVocabulary]) as MilestoneVocabulary
,isnull(da.MilestoneFineMotor, CDPE.[MilestoneFineMotor]) as MilestoneFineMotor
,isnull(da.MilestoneGrossMotor, CDPE.[MilestoneGrossMotor]) as MilestoneGrossMotor
,isnull(da.MilestoneIntellectual, CDPE.[MilestoneIntellectual]) as MilestoneIntellectual
,isnull(da.MilestoneMakingFriends, CDPE.[MilestoneMakingFriends]) as MilestoneMakingFriends
,isnull(da.MilestoneSharingInterests, CDPE.[MilestoneSharingInterests]) as MilestoneSharingInterests
,isnull(da.MilestoneEyeContact, CDPE.[MilestoneEyeContact]) as MilestoneEyeContact
,isnull(da.MilestoneToiletTraining, CDPE.[MilestoneToiletTraining]) as MilestoneToiletTraining
,isnull(da.MilestoneCopingSkills, CDPE.[MilestoneCopingSkills]) as MilestoneCopingSkills
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
,isnull(da.RiskSuicideIdeation, CDPE.[RiskSuicideIdeation]) as RiskSuicideIdeation
,isnull(da.RiskSuicideIdeationComment, CDPE.[RiskSuicideIdeationComment]) as RiskSuicideIdeationComment
,isnull(da.RiskSuicideIntent, CDPE.[RiskSuicideIntent]) as RiskSuicideIntent
,isnull(da.RiskSuicideIntentComment, CDPE.[RiskSuicideIntentComment]) as RiskSuicideIntentComment
,isnull(da.RiskSuicidePriorAttempts, CDPE.[RiskSuicidePriorAttempts]) as RiskSuicidePriorAttempts
,isnull(da.RiskSuicidePriorAttemptsComment, CDPE.[RiskSuicidePriorAttemptsComment]) as RiskSuicidePriorAttemptsComment
,isnull(da.RiskPriorHospitalization, CDPE.[RiskPriorHospitalization]) as RiskPriorHospitalization
,isnull(da.RiskPriorHospitalizationComment, CDPE.[RiskPriorHospitalizationComment]) as RiskPriorHospitalizationComment
,isnull(da.RiskPhysicalAggressionSelf, CDPE.[RiskPhysicalAggressionSelf]) as RiskPhysicalAggressionSelf
,isnull(da.RiskPhysicalAggressionSelfComment, CDPE.[RiskPhysicalAggressionSelfComment]) as RiskPhysicalAggressionSelfComment
,isnull(da.RiskVerbalAggressionOthers, CDPE.[RiskVerbalAggressionOthers]) as RiskVerbalAggressionOthers
,isnull(da.RiskVerbalAggressionOthersComment, CDPE.[RiskVerbalAggressionOthersComment]) as RiskVerbalAggressionOthersComment
,isnull(da.RiskPhysicalAggressionObjects, CDPE.[RiskPhysicalAggressionObjects]) as RiskPhysicalAggressionObjects
,isnull(da.RiskPhysicalAggressionObjectsComment, CDPE.[RiskPhysicalAggressionObjectsComment]) as RiskPhysicalAggressionObjectsComment
,isnull(da.RiskPhysicalAggressionPeople, CDPE.[RiskPhysicalAggressionPeople]) as RiskPhysicalAggressionPeople
,isnull(da.RiskPhysicalAggressionPeopleComment, CDPE.[RiskPhysicalAggressionPeopleComment]) as RiskPhysicalAggressionPeopleComment
,isnull(da.RiskReportRiskTaking, CDPE.[RiskReportRiskTaking]) as RiskReportRiskTaking
,isnull(da.RiskReportRiskTakingComment, CDPE.[RiskReportRiskTakingComment]) as RiskReportRiskTakingComment
,isnull(da.RiskThreatClientPersonalSafety, CDPE.[RiskThreatClientPersonalSafety]) as RiskThreatClientPersonalSafety
,isnull(da.RiskThreatClientPersonalSafetyComment, CDPE.[RiskThreatClientPersonalSafetyComment]) as RiskThreatClientPersonalSafetyComment
,isnull(da.RiskPhoneNumbersProvided, CDPE.[RiskPhoneNumbersProvided]) as RiskPhoneNumbersProvided
,isnull(da.RiskCurrentRiskIdentified, CDPE.[RiskCurrentRiskIdentified]) as RiskCurrentRiskIdentified
,isnull(da.RiskTriggersDangerousBehaviors, CDPE.[RiskTriggersDangerousBehaviors]) as RiskTriggersDangerousBehaviors
,isnull(da.RiskCopingSkills, CDPE.[RiskCopingSkills]) as RiskCopingSkills
,isnull(da.RiskInterventionsPersonalSafetyNA, CDPE.[RiskInterventionsPersonalSafetyNA]) as RiskInterventionsPersonalSafetyNA
,isnull(da.RiskInterventionsPersonalSafety, CDPE.[RiskInterventionsPersonalSafety]) as RiskInterventionsPersonalSafety
,isnull(da.RiskInterventionsPublicSafetyNA, CDPE.[RiskInterventionsPublicSafetyNA]) as RiskInterventionsPublicSafetyNA
,isnull(da.RiskInterventionsPublicSafety, CDPE.[RiskInterventionsPublicSafety]) as RiskInterventionsPublicSafety
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
,@clientDOB as [ClientDOB]
,CDPE.[DifferentialDiagnosisFormulation]
,@clientGender as [ClientGender]
FROM (SELECT ''CustomDocumentPsychiatricEvaluations'' AS TableName) AS Placeholder
LEFT JOIN CustomDocumentPsychiatricEvaluations CDPE ON (CDPE.DocumentVersionId = @LatestDocumentVersionID) 
LEFT join dbo.CustomDocumentDiagnosticAssessments as da on da.DocumentVersionId = @LatestDAVersionId

select @LatestDxVersionId = d.CurrentDocumentVersionId
from dbo.Documents as d
where d.ClientId = @ClientId
and d.DocumentCodeId = 5
and d.Status = 22
and ISNULL(d.RecordDeleted, ''N'') <> ''Y''
and not exists (
	select *
	from dbo.Documents as d2
	where d2.ClientId = d.ClientId
	and d2.DocumentCodeId = d.DocumentCodeId
	and d2.Status = d.Status
	and ((d2.EffectiveDate > d.EffectiveDate) or (d2.EffectiveDate = d.EffectiveDate and d2.DocumentId > d.DocumentId))
	and ISNULL(d2.RecordDeleted, ''N'') <> ''Y''
)

 --   ------For DiagnosesIII----
 --  SELECT Placeholder.TableName, ISNULL(DIII.DocumentVersionId,-1) AS DocumentVersionId
 --     ,DIII.CreatedBy
 --     ,DIII.CreatedDate
 --     ,DIII.ModifiedBy
 --     ,DIII.ModifiedDate
 --     ,DIII.RecordDeleted
 --     ,DIII.DeletedDate
 --     ,DIII.DeletedBy
 --     ,DIII.Specification
 -- FROM (SELECT ''DiagnosesIII'' AS TableName) AS Placeholder
 -- LEFT JOIN DiagnosesIII DIII ON ( DIII.DocumentVersionId = @LatestDxVersionId
 -- AND ISNULL(DIII.RecordDeleted,''N'') <> ''Y'' )

 --    -----For DiagnosesIV-----
 --  SELECT Placeholder.TableName, ISNULL(DIV.DocumentVersionId,-1) AS DocumentVersionId
 --     ,DIV.PrimarySupport                                                                                                  ,SocialEnvironment
 --  ,DIV.Educational
 --  ,DIV.Occupational
 --  ,DIV.Housing
 --  ,DIV.Economic
 --  ,DIV.HealthcareServices
 --  ,DIV.Legal
 --  ,DIV.Other
 --  ,DIV.Specification
 --  ,DIV.CreatedBy
 --  ,DIV.CreatedDate
 --  ,DIV.ModifiedBy
 --  ,DIV.ModifiedDate
 --  ,DIV.RecordDeleted
 --  ,DIV.DeletedDate
 --  ,DIV.DeletedBy
 -- FROM (SELECT ''DiagnosesIV'' AS TableName) AS Placeholder
 -- LEFT JOIN DiagnosesIV DIV ON ( DIV.DocumentVersionId = @LatestDxVersionId
 -- AND ISNULL(DIV.RecordDeleted,''N'') <> ''Y'' )

 --  -----For DiagnosesV-----
 --SELECT Placeholder.TableName, ISNULL(DV.DocumentVersionId,-1) AS DocumentVersionId
 --     ,DV.AxisV
 --  ,DV.CreatedBy
 --  ,DV.CreatedDate
 --  ,DV.ModifiedBy
 --  ,DV.ModifiedDate
 --  ,DV.RecordDeleted
 --  ,DV.DeletedDate
 --  ,DV.DeletedBy
 -- FROM (SELECT ''DiagnosesV'' AS TableName) AS Placeholder
 -- LEFT JOIN DiagnosesV DV ON ( DV.DocumentVersionId = @LatestDxVersionId
 -- AND ISNULL(DV.RecordDeleted,''N'') <> ''Y'' )

 --  -----For DiagnosesIAndII-----
 --SELECT Placeholder.TableName, ISNULL(DIandII.DocumentVersionId,-1) AS DocumentVersionId
 --     ,DIandII.DiagnosisId
 --  ,DIandII.Axis
 --  ,DIandII.DSMCode
 --  ,DIandII.DSMNumber
 --  ,DIandII.DiagnosisType
 --  ,DIandII.RuleOut
 --  ,DIandII.Billable
 --  ,DIandII.Severity
 --  ,DIandII.DSMVersion
 --  ,DIandII.DiagnosisOrder
 --  ,DIandII.Specifier
 --  ,DIandII.Remission
 --  ,DIandII.Source
 --  ,DIandII.RowIdentifier
 --  ,DIandII.CreatedBy
 --  ,DIandII.CreatedDate
 --  ,DIandII.ModifiedBy
 --  ,DIandII.ModifiedDate
 --  ,DIandII.RecordDeleted
 --  ,DIandII.DeletedDate
 --  ,DIandII.DeletedBy
 --  ,DSM.DSMDescription
 --     ,case DIandII.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText

 -- FROM (SELECT ''DiagnosesIAndII'' AS TableName) AS Placeholder
 -- LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestDxVersionId
 -- AND ISNULL(DIandII.RecordDeleted,''N'') <> ''Y'' )
 -- INNER JOIN DiagnosisDSMDescriptions DSM ON(DSM.DSMCode = DIandII.DSMCode
 -- AND DSM.DSMNumber = DIandII.DSMNumber)

 -- --DiagnosesIIICodes
 --SELECT ''DiagnosesIIICodes'' as TableName,DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,
 --DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,
 --DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy
 --FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode
 --WHERE (DIIICod.DocumentVersionId = @LatestDxVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')

 -----DiagnosesMaxOrder
	---- Below Select Statement Modified by Pralyankar On July 21, 2012 for Implementing the Placeholder concept.
 --  SELECT  top 1 Placeholder.TableName --''DiagnosesIANDIIMaxOrder'' as TableName
	--	,max(DiagnosisOrder) as DiagnosesMaxOrder  
	--	,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate
	--	,RecordDeleted,DeletedBy,DeletedDate 
 --  from (SELECT ''DiagnosesIANDIIMaxOrder'' AS TableName) AS Placeholder
	--Left Join DiagnosesIAndII On DocumentVersionId = @LatestDxVersionId
 --  where IsNull(RecordDeleted,''N'')=''N'' 
 --  group by Placeholder.TableName, CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate
 --  order by DiagnosesMaxOrder desc

   -- Mental Status --
   SELECT Placeholder.TableName, ISNULL(CDMS.DocumentVersionId,-1) AS DocumentVersionId
      ,CDMS.CreatedBy
      ,CDMS.CreatedDate
      ,CDMS.ModifiedBy
      ,CDMS.ModifiedDate
      ,CDMS.RecordDeleted
      ,CDMS.DeletedBy
      ,CDMS.DeletedDate
      ,CDMS.ConsciousnessNA
      ,CDMS.ConsciousnessAlert
      ,CDMS.ConsciousnessObtunded
      ,CDMS.ConsciousnessSomnolent
      ,CDMS.ConsciousnessOrientedX3
      ,CDMS.ConsciousnessAppearsUnderInfluence
      ,CDMS.ConsciousnessComment
      ,CDMS.EyeContactNA
      ,CDMS.EyeContactAppropriate
      ,CDMS.EyeContactStaring
      ,CDMS.EyeContactAvoidant
      ,CDMS.EyeContactComment
      ,CDMS.AppearanceNA
      ,CDMS.AppearanceClean
      ,CDMS.AppearanceNeatlyDressed
      ,CDMS.AppearanceAppropriate
      ,CDMS.AppearanceDisheveled
      ,CDMS.AppearanceMalodorous
      ,CDMS.AppearanceUnusual
      ,CDMS.AppearancePoorlyGroomed
      ,CDMS.AppearanceComment
      ,CDMS.AgeNA
      ,CDMS.AgeAppropriate
      ,CDMS.AgeOlder
      ,CDMS.AgeYounger
      ,CDMS.AgeComment
      ,CDMS.BehaviorNA
      ,CDMS.BehaviorPleasant
      ,CDMS.BehaviorGuarded
      ,CDMS.BehaviorAgitated
      ,CDMS.BehaviorImpulsive
      ,CDMS.BehaviorWithdrawn
      ,CDMS.BehaviorUncooperative
      ,CDMS.BehaviorAggressive
      ,CDMS.BehaviorComment
      ,CDMS.PsychomotorNA
      ,CDMS.PsychomotorNoAbnormalMovements
      ,CDMS.PsychomotorAgitation
      ,CDMS.PsychomotorAbnormalMovements
      ,CDMS.PsychomotorRetardation
      ,CDMS.PsychomotorComment
      ,CDMS.MoodNA
      ,CDMS.MoodEuthymic
      ,CDMS.MoodDysphoric
      ,CDMS.MoodIrritable
      ,CDMS.MoodDepressed
      ,CDMS.MoodExpansive
      ,CDMS.MoodAnxious
      ,CDMS.MoodElevated
      ,CDMS.MoodComment
      ,CDMS.ThoughtContentNA
      ,CDMS.ThoughtContentWithinLimits
      ,CDMS.ThoughtContentExcessiveWorries
      ,CDMS.ThoughtContentOvervaluedIdeas
      ,CDMS.ThoughtContentRuminations
      ,CDMS.ThoughtContentPhobias
      ,CDMS.ThoughtContentComment
      ,CDMS.DelusionsNA
      ,CDMS.DelusionsNone
      ,CDMS.DelusionsBizarre
      ,CDMS.DelusionsReligious
      ,CDMS.DelusionsGrandiose
      ,CDMS.DelusionsParanoid
      ,CDMS.DelusionsComment
      ,CDMS.ThoughtProcessNA
      ,CDMS.ThoughtProcessLogical
      ,CDMS.ThoughtProcessCircumferential
      ,CDMS.ThoughtProcessFlightIdeas
      ,CDMS.ThoughtProcessIllogical
      ,CDMS.ThoughtProcessDerailment
      ,CDMS.ThoughtProcessTangential
      ,CDMS.ThoughtProcessSomatic
      ,CDMS.ThoughtProcessCircumstantial
      ,CDMS.ThoughtProcessComment
      ,CDMS.HallucinationsNA
      ,CDMS.HallucinationsNone
      ,CDMS.HallucinationsAuditory
      ,CDMS.HallucinationsVisual
      ,CDMS.HallucinationsTactile
      ,CDMS.HallucinationsOlfactory
      ,CDMS.HallucinationsComment
      ,CDMS.IntellectNA
      ,CDMS.IntellectAverage
      ,CDMS.IntellectAboveAverage
      ,CDMS.IntellectBelowAverage
      ,CDMS.IntellectComment
      ,CDMS.SpeechNA
      ,CDMS.SpeechRate
      ,CDMS.SpeechTone
      ,CDMS.SpeechVolume
      ,CDMS.SpeechArticulation
      ,CDMS.SpeechComment
      ,CDMS.AffectNA
      ,CDMS.AffectCongruent
      ,CDMS.AffectReactive
      ,CDMS.AffectIncongruent
      ,CDMS.AffectLabile
      ,CDMS.AffectComment
      ,CDMS.RangeNA
      ,CDMS.RangeBroad
      ,CDMS.RangeBlunted
      ,CDMS.RangeFlat
      ,CDMS.RangeFull
      ,CDMS.RangeConstricted
      ,CDMS.RangeComment
      ,CDMS.InsightNA
      ,CDMS.InsightExcellent
      ,CDMS.InsightGood
      ,CDMS.InsightFair
      ,CDMS.InsightPoor
      ,CDMS.InsightImpaired
      ,CDMS.InsightUnknown
      ,CDMS.InsightComment
      ,CDMS.JudgmentNA
      ,CDMS.JudgmentExcellent
      ,CDMS.JudgmentGood
      ,CDMS.JudgmentFair
      ,CDMS.JudgmentPoor
      ,CDMS.JudgmentImpaired
      ,CDMS.JudgmentUnknown
      ,CDMS.JudgmentComment
      ,CDMS.MemoryNA
      ,CDMS.MemoryShortTerm
      ,CDMS.MemoryLongTerm
      ,CDMS.MemoryAttention
      ,CDMS.MemoryComment
      ,CDMS.BodyHabitusNA
   ,CDMS.BodyHabitusAverage
   ,CDMS.BodyHabitusThin
   ,CDMS.BodyHabitusUnderweight
   ,CDMS.BodyHabitusOverweight
   ,CDMS.BodyHabitusObese
   ,CDMS.BodyHabitusComment
  FROM (SELECT ''CustomDocumentMentalStatuses'' AS TableName) AS Placeholder
  LEFT JOIN CustomDocumentMentalStatuses CDMS ON ( CDMS.DocumentVersionId = @LatestDocumentVersionID AND ISNULL(CDMS.RecordDeleted,''N'') <> ''Y'' )
  
 exec ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters 
END TRY
BEGIN CATCH
DECLARE @Error varchar(8000)
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentPsychiatricEvaluationsInitialization'')
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
    + ''*****'' + Convert(varchar,ERROR_STATE())
 RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );
END CATCH
END


' 
END
GO
