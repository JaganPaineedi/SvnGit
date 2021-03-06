IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentDischarges]
GO
/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentDischarges]    Script Date: 04/29/2013 16:57:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
Create PROCEDURE  [dbo].[csp_SCGetCustomDocumentDischarges]  
(  
 @DocumentVersionId INT  
)          
AS    

/*********************************************************************/                        
/* Stored Procedure: dbo.csp_SCGetCustomDocumentDischarges                */               
/* Copyright: 2011 Streamline SmartCare*/                        
/* Creation Date:  29/04/2011                                    */                        
/* Purpose: Gets Data for CustomDocumentDischarges*/                       
/* Input Parameters: DocumentVersionID */                      
/* Output Parameters:                                */                        
/* Return:   */                        
/* Calls:                                                            */                        
/* Data Modifications:                                               */                        
/*  Updates:                                                          */                        
/*  Date                  Author                  Purpose                                    */                        
/*  29/04/2011            Pradeep                 Created                         */
/*  09/28/2011            Rohit Katoch            Modified - added column 'ReasonForDischargeCode'      */ 
/*  25/04/2013            Aravinda halemane       Modified - added columns 'DASTScore', 'MASTScore','InitialLevelofCare', 'DischargeLevelofCare' */                                                              
/*********************************************************************/                  
BEGIN                      
 SELECT [DocumentVersionId],    
  [CreatedBy],    
  [CreatedDate],     
  [ModifiedBy],     
  [ModifiedDate],    
  [RecordDeleted],    
  [DeletedBy],    
  [DeletedDate], 
  [ClientAddress], 
  [HomePhone],  
  [ParentGuardianName],  
  [AdmissionDate],  
  [LastServiceDate],  
  [DischargeDate],  
  [DischargeTransitionCriteria],  
  [ServicesParticpated],  
  [MedicationsPrescribed],  
  [PresentingProblem],  
  [ReasonForDischarge],
  [ReasonForDischargeCode],  
  [ClientParticpation],  
  [ClientStatusLastContact],  
  [ClientStatusComment],  
  [ReferralPreference1],  
  [ReferralPreference2],  
  [ReferralPreference3],  
  [ReferralPreferenceOther],  
  [ReferralPreferenceComment],  
  [InvoluntaryTermination],  
  [ClientInformedRightAppeal],  
  [StaffMemberContact72Hours],
  [DASTScore],
  [MASTScore],
  [InitialLevelofCare],
  [DischargeLevelofCare]    
    FROM [CustomDocumentDischarges]   
 WHERE     (isnull(RecordDeleted,'N')='N') AND (DocumentVersionId = @DocumentVersionId)   
   
 SELECT   
  [DischargeGoalId],
  [DocumentVersionId],    
  [CreatedBy],    
  [CreatedDate],     
  [ModifiedBy],     
  [ModifiedDate],    
  [RecordDeleted],    
  [DeletedBy],    
  [DeletedDate],  
  [GoalNumber],  
  [GoalText],  
  [GoalRatingProgress]  
  FROM [CustomDocumentDischargeGoals]    
  WHERE     (isnull(RecordDeleted,'N')='N') AND (DocumentVersionId = @DocumentVersionId) order by [GoalNumber]      
             
  --Checking For Errors              
 If (@@error!=0)              
 BEGIN              
  RAISERROR  20006   'csp_SCGetCustomDocumentDischarges: An Error Occured'               
  Return              
 END                      
END
GO
/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDischarges]    Script Date: 04/29/2013 16:57:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[csp_ValidateCustomDocumentDischarges]
	@DocumentVersionId int

as

create Table #CustomDocumentDischarges ( 
	[DocumentVersionId] [int] ,
	[CreatedBy] varchar(30) ,
	[CreatedDate] datetime ,
	[ModifiedBy] varchar(30) ,
	[ModifiedDate] datetime ,
	[RecordDeleted] char(1) ,
	[DeletedBy] varchar(30) ,
	[DeletedDate] [datetime] ,
	[ClientAddress] [varchar](max) ,
	[HomePhone] varchar(100) ,
	[ParentGuardianName] [varchar](250) ,
	[AdmissionDate] [datetime] ,
	[LastServiceDate] [datetime] ,
	[DischargeDate] [datetime] ,
	[DischargeTransitionCriteria] varchar(max) ,
	[ServicesParticpated] varchar(max) ,
	[MedicationsPrescribed] varchar(max) ,
	[PresentingProblem] varchar(max) ,
	[ReasonForDischarge] varchar(max) ,
	[ReasonForDischargeCode] int ,
	[ClientParticpation] int ,
	[ClientStatusLastContact] int ,
	[ClientStatusComment] varchar(max) ,
	[ReferralPreference1] int ,
	[ReferralPreference2] int ,
	[ReferralPreference3] int ,
	[ReferralPreferenceOther] char(1) ,
	[ReferralPreferenceComment] varchar(max) ,
	[InvoluntaryTermination] char(1) ,
	[ClientInformedRightAppeal] char(1) ,
	[StaffMemberContact72Hours] char(1),
	[DASTScore] int ,
	[MASTScore] int ,
	[InitialLevelofCare] int ,
	[DischargeLevelofCare] int  
)

--***INSERT LIST***--
insert into #CustomDocumentDischarges
(
DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,ClientAddress
,HomePhone
,ParentGuardianName
,AdmissionDate
,LastServiceDate
,DischargeDate
,DischargeTransitionCriteria
,ServicesParticpated
,MedicationsPrescribed
,PresentingProblem
,ReasonForDischarge
,ReasonForDischargeCode
,ClientParticpation
,ClientStatusLastContact
,ClientStatusComment
,ReferralPreference1
,ReferralPreference2
,ReferralPreference3
,ReferralPreferenceOther
,ReferralPreferenceComment
,InvoluntaryTermination
,ClientInformedRightAppeal
,StaffMemberContact72Hours
,DASTScore
,MASTScore 
,InitialLevelofCare
,DischargeLevelofCare  
)
select 
DocumentVersionId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedBy
,DeletedDate
,ClientAddress
,HomePhone
,ParentGuardianName
,AdmissionDate
,LastServiceDate
,DischargeDate
,DischargeTransitionCriteria
,ServicesParticpated
,MedicationsPrescribed
,PresentingProblem
,ReasonForDischarge
,ReasonForDischargeCode
,ClientParticpation
,ClientStatusLastContact
,ClientStatusComment
,ReferralPreference1
,ReferralPreference2
,ReferralPreference3
,ReferralPreferenceOther
,ReferralPreferenceComment
,InvoluntaryTermination
,ClientInformedRightAppeal
,StaffMemberContact72Hours
,DASTScore
,MASTScore 
,InitialLevelofCare
,DischargeLevelofCare  

from CustomDocumentDischarges
where DocumentVersionId = @DocumentVersionId


insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Date of admission required', 1, 1
from #CustomDocumentDischarges
where AdmissionDate is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Last date of service required', 1, 2
from #CustomDocumentDischarges
where LastServiceDate is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Date of discharge required', 1, 3
from #CustomDocumentDischarges
where DischargeDate is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Discharge/transition criteria required', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(DischargeTransitionCriteria, '')))) = 0
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - "Services client has participated in..." required', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(ServicesParticpated, '')))) = 0
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - "Medications currently prescribed..." required', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(MedicationsPrescribed, '')))) = 0
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Presenting problem required', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(PresentingProblem, '')))) = 0
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Reason for discharge required', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull(ReasonForDischarge, '')))) = 0
and ReasonForDischargeCode is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Client participation selection required', 1, 3
from #CustomDocumentDischarges
where ClientParticpation is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Client status at last contact selection required', 1, 3
from #CustomDocumentDischarges
where ClientStatusLastContact is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Client status at last contact comment required', 1, 3
from #CustomDocumentDischarges
where ClientStatusLastContact = 2
and len(ltrim(rtrim(isnull(ClientStatusComment, '')))) = 0
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge - Referral comment required', 1, 3
from #CustomDocumentDischarges
where len(ltrim(rtrim(isnull([ReferralPreferenceComment], '')))) = 0
and isnull([ReferralPreferenceOther], 'N') = 'Y'
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Discharge date cannot occurr before admission date', 1, 3
from #CustomDocumentDischarges
where datediff(DAY, AdmissionDate, DischargeDate) < 0
union
select 'CustomDocumentDischargeGoals', 'DeletedBy', 'Progress toward Goal # ' + cast(GoalNumber as varchar) + ' - rating of progress required', 1, 3
from CustomDocumentDischargeGoals
where DocumentVersionId = @DocumentVersionId
and isnull(RecordDeleted, 'N') <> 'Y'
and GoalRatingProgress is null
union
select 'CustomDocumentDischarges', 'DeletedBy', 'Cannot complete discharge because future, mental health service appointments exist.', 1, 4
where exists (
	select *
	from dbo.DocumentVersions as dv
	join dbo.Documents as d on d.DocumentId = dv.DocumentId
	join dbo.Services as s on s.ClientId = d.ClientId
	join dbo.Programs as pg on pg.ProgramId = s.ProgramId
	where dv.DocumentVersionId = @DocumentVersionId
	and s.Status = 70
	and pg.ServiceAreaId = 3	-- Mental Health
	and DATEDIFF(DAY, s.DateOfService, GETDATE()) <= 0
	and ISNULL(d.RecordDeleted, 'N') = 'N'
	and ISNULL(s.RecordDeleted, 'N') = 'N'
)

UNION 
      SELECT 'CustomDocumentDischarges'  ,'InitialLevelofCare' ,'Should Select Initial Level of Care', 1,5
      FROM   #CustomDocumentDischarges
      WHERE   InitialLevelofCare is  null
                    
 UNION 
      SELECT 'CustomDocumentDischarges'  ,'DischargeLevelofCare' ,'Should Select Discharge Level of Care', 1,6
      FROM   #CustomDocumentDischarges
      WHERE   DischargeLevelofCare is  null
GO
/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]    Script Date: 04/29/2013 16:57:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentDiagnosticAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[csp_ValidateCustomDocumentDiagnosticAssessments] 
 @DocumentVersionId int    
AS    
    
/*    
avoss 08.06.2012  corrected EAP_MD_AST procedure code 
Maninder : 31/Aug/2012   Corrected Column varchar(250) to varchar(max)
*/    
    
declare @InitialOrUpdate char(1)    
    
-- Take a snapshot of the assessment    
CREATE TABLE #CustomDocumentDiagnosticAssessments (    
 [DocumentVersionId] [int] ,    
 [CreatedBy] varchar(35) ,    
 [CreatedDate] datetime ,    
 [ModifiedBy] varchar(35) ,    
 [ModifiedDate] datetime ,    
 [RecordDeleted] char(1) ,    
 [DeletedBy] varchar(35) ,    
 [DeletedDate] [datetime] ,    
 [TypeOfAssessment] [char](1) ,    
 [InitialOrUpdate] [char](1) ,    
 [ReasonForUpdate] varchar(max) ,    
 [UpdatePsychoSocial] char(1) ,    
 [UpdateSubstanceUse] char(1) ,    
 [UpdateRiskIndicators] char(1) ,    
 [UpdatePhysicalHealth] char(1) ,    
 [UpdateEducationHistory] char(1) ,    
 [UpdateDevelopmentalHistory] char(1) ,    
 [UpdateSleepHygiene] char(1) ,    
 [UpdateFamilyHistory] char(1) ,    
 [UpdateHousing] char(1) ,    
 [UpdateVocational] char(1) ,    
 [TransferReceivingStaff] [int] ,    
 [TransferReceivingProgram] int ,    
 [TransferAssessedNeed] [varchar](250) ,    
 [TransferClientParticipated] char(1) ,    
 [PresentingProblem] varchar(max) ,    
 [OptionsAlreadyTried] varchar(max) ,    
 [ClientHasLegalGuardian] char(1) ,    
 [LegalGuardianInfo] varchar(max) ,    
 [AbilitiesInterestsSkills] varchar(max) ,    
 [FamilyHistory] varchar(max) ,    
 [EthnicityCulturalBackground] varchar(max) ,    
 [SexualOrientationGenderExpression] varchar(max) ,    
 [GenderExpressionConsistent] char(1) ,    
 [SupportSystems] varchar(max) ,    
 [ClientStrengths] varchar(max) ,    
 [LivingSituation] varchar(max) ,    
 [IncludeHousingAssessment] char(1) ,    
 [ClientEmploymentNotApplicable] char(1) ,    
 [ClientEmploymentMilitaryHistory] varchar(max) ,    
 [IncludeVocationalAssessment] char(1) ,    
 [HighestEducationCompleted] int ,    
 [EducationComment] varchar(max) ,    
 [LiteracyConcerns] [char](1) ,    
 [LegalInvolvement] char(1) ,    
 [LegalInvolvementComment] varchar(max) ,    
 [HistoryEmotionalProblemsClient] varchar(max) ,    
 [ClientHasReceivedTreatment] char(1) ,    
 [ClientPriorTreatmentDiagnosis] varchar(max) ,    
 [PriorTreatmentCounseling] char(1) ,    
 [PriorTreatmentCounselingDates] [varchar](250) ,    
 [PriorTreatmentCounselingComment] varchar(max) ,    
 [PriorTreatmentCaseManagement] char(1) ,    
 [PriorTreatmentCaseManagementDates] [varchar](250) ,    
 [PriorTreatmentCaseManagementComment] varchar(max) ,    
 [PriorTreatmentOther] char(1) ,    
 [PriorTreatmentOtherDates] [varchar](250) ,    
 [PriorTreatmentOtherComment] varchar(max) ,    
 [PriorTreatmentMedication] char(1) ,    
 [PriorTreatmentMedicationDates] [varchar](250) ,    
 [PriorTreatmentMedicationComment] varchar(max) ,    
 [TypesOfMedicationResults] varchar(max) ,    
 [ClientResponsePastTreatment] [char](1) ,    
 [ClientResponsePastTreatmentNA] char(1) ,    
 [AbuseNotApplicable] char(1) ,    
 [AbuseEmotionalVictim] char(1) ,    
 [AbuseEmotionalOffender] char(1) ,    
 [AbuseVerbalVictim] char(1) ,    
 [AbuseVerbalOffender] char(1) ,    
 [AbusePhysicalVictim] char(1) ,    
 [AbusePhysicalOffender] char(1) ,    
 [AbuseSexualVictim] char(1) ,    
 [AbuseSexualOffender] char(1) ,    
 [AbuseNeglectVictim] char(1) ,    
 [AbuseNeglectOffender] char(1) ,    
 [AbuseComment] varchar(max) ,    
 [FamilyPersonalHistoryLossTrauma] varchar(max) ,    
 [BiologicalMotherUseNoneReported] char(1) ,    
 [BiologicalMotherUseAlcohol] char(1) ,    
 [BiologicalMotherTobacco] char(1) ,    
 [BiologicalMotherUseOther] char(1) ,    
 [BiologicalMotherUseOtherType] [varchar](250) ,    
 [ClientReportAlcoholTobaccoDrugUse] char(1) ,    
 [ClientReportDrugUseComment] varchar(max) ,    
 [FurtherSubstanceAssessmentIndicated] char(1) ,    
 [ClientHasHistorySubstanceUse] char(1) ,    
 [ClientHistorySubstanceUseComment] varchar(max) ,    
 [AlcoholUseWithin30Days] char(1) ,    
 [AlcoholUseCurrentFrequency] int ,    
 [AlcoholUseWithinLifetime] char(1) ,    
 [AlcoholUsePastFrequency] int ,    
 [AlcoholUseReceivedTreatment] char(1) ,    
 [CocaineUseWithin30Days] char(1) ,    
 [CocaineUseCurrentFrequency] int ,    
 [CocaineUseWithinLifetime] char(1) ,    
 [CocaineUsePastFrequency] int ,    
 [CocaineUseReceivedTreatment] char(1) ,    
 [SedtativeUseWithin30Days] char(1) ,    
 [SedtativeUseCurrentFrequency] int ,    
 [SedtativeUseWithinLifetime] char(1) ,    
 [SedtativeUsePastFrequency] int ,    
 [SedtativeUseReceivedTreatment] char(1) ,    
 [HallucinogenUseWithin30Days] char(1) ,    
 [HallucinogenUseCurrentFrequency] int ,    
 [HallucinogenUseWithinLifetime] char(1) ,    
 [HallucinogenUsePastFrequency] int ,    
 [HallucinogenUseReceivedTreatment] char(1) ,    
 [StimulantUseWithin30Days] char(1) ,    
 [StimulantUseCurrentFrequency] int ,    
 [StimulantUseWithinLifetime] char(1) ,    
 [StimulantUsePastFrequency] int ,    
 [StimulantUseReceivedTreatment] char(1) ,    
 [NarcoticUseWithin30Days] char(1) ,    
 [NarcoticUseCurrentFrequency] int ,    
 [NarcoticUseWithinLifetime] char(1) ,    
 [NarcoticUsePastFrequency] int ,    
 [NarcoticUseReceivedTreatment] char(1) ,    
 [MarijuanaUseCurrentFrequency] int ,    
 [MarijuanaUsePastFrequency] int ,    
 [MarijuanaUseWithin30Days] char(1) ,    
 [MarijuanaUseWithinLifetime] char(1) ,    
 [MarijuanaUseReceivedTreatment] char(1) ,    
 [InhalantsUseWithin30Days] char(1) ,    
 [InhalantsUseCurrentFrequency] int ,    
 [InhalantsUseWithinLifetime] char(1) ,    
 [InhalantsUsePastFrequency] int ,    
 [InhalantsUseReceivedTreatment] char(1) ,    
 [OtherUseWithin30Days] char(1) ,    
 [OtherUseCurrentFrequency] int ,    
 [OtherUseWithinLifetime] char(1) ,    
 [OtherUsePastFrequency] int ,    
 [OtherUseReceivedTreatment] char(1) ,    
 [OtherUseType] [varchar](250) ,    
 [DASTScore] [int] ,    
 [MASTScore] [int] ,    
 [ClientReferredSubstanceTreatment] [char](1) ,    
 [ClientReferredSubstanceTreatmentWhere] [varchar](250) ,    
 [RiskSuicideIdeation] char(1) ,    
 [RiskSuicideIdeationComment] varchar(max) ,    
 [RiskSuicideIntent] char(1) ,    
 [RiskSuicideIntentComment] varchar(max) ,    
 [RiskSuicidePriorAttempts] char(1) ,    
 [RiskSuicidePriorAttemptsComment] varchar(max) ,    
 [RiskPriorHospitalization] char(1) ,    
 [RiskPriorHospitalizationComment] varchar(max) ,    
 [RiskPhysicalAggressionSelf] char(1) ,    
 [RiskPhysicalAggressionSelfComment] varchar(max) ,    
 [RiskVerbalAggressionOthers] char(1) ,    
 [RiskVerbalAggressionOthersComment] varchar(max) ,    
 [RiskPhysicalAggressionObjects] char(1) ,    
 [RiskPhysicalAggressionObjectsComment] varchar(max) ,    
 [RiskPhysicalAggressionPeople] char(1) ,    
 [RiskPhysicalAggressionPeopleComment] varchar(max) ,    
 [RiskReportRiskTaking] char(1) ,    
 [RiskReportRiskTakingComment] varchar(max) ,    
 [RiskThreatClientPersonalSafety] char(1) ,    
 [RiskThreatClientPersonalSafetyComment] varchar(max) ,    
 [RiskPhoneNumbersProvided] char(1) ,    
 [RiskCurrentRiskIdentified] char(1) ,    
 [RiskTriggersDangerousBehaviors] varchar(max) ,    
 [RiskCopingSkills] varchar(max) ,    
 [RiskInterventionsPersonalSafetyNA] char(1) ,    
 [RiskInterventionsPersonalSafety] varchar(max) ,    
 [RiskInterventionsPublicSafetyNA] char(1) ,    
 [RiskInterventionsPublicSafety] varchar(max) ,    
 [PhysicalProblemsNoneReported] char(1) ,    
 [PhysicalProblemsComment] varchar(max) ,    
 [SpecialNeedsNoneReported] char(1) ,    
 [SpecialNeedsVisualImpairment] char(1) ,    
 [SpecialNeedsHearingImpairment] char(1) ,    
 [SpecialNeedsSpeechImpairment] char(1) ,    
 [SpecialNeedsOtherPhysicalImpairment] char(1) ,    
 [SpecialNeedsOtherPhysicalImpairmentComment] varchar(max) ,    
 [EducationSchoolName] [varchar](250) ,    
 [EducationPreviousExpulsions] varchar(max) ,    
 [EducationClassification] [char](1) ,    
 [EducationEmotionalDisturbance] char(1) ,    
 [EducationPreschoolersDisability] char(1) ,    
 [EducationTraumaticBrainInjury] char(1) ,    
 [EducationCognitiveDisability] char(1) ,    
 [EducationCurrent504] char(1) ,    
 [EducationOtherMajorHealthImpaired] char(1) ,    
 [EducationSpecificLearningDisability] char(1) ,    
 [EducationAutism] char(1) ,    
 [EducationOtherMinorHealthImpaired] char(1) ,    
 [EdcuationClassificationComment] varchar(max) ,    
 [EducationPreviousRetentions] varchar(max) ,    
 [EducationClientIsHomeSchooled] char(1) ,    
 [EducationClientAttendedPreschool] char(1) ,    
 [EducationFrequencyOfAttendance] varchar(max) ,    
 [EducationReceivedServicesAsToddler] char(1) ,    
 [EducationReceivedServicesAsToddlerComment] varchar(max) ,    
 [ClientPreferencesForTreatment] varchar(max) ,    
 [ExternalSupportsReferrals] varchar(max) ,    
 [PrimaryClinicianTransfer] char(1) ,    
 [EAPMentalStatus] [char](1) ,    
 [DiagnosticImpressionsSummary] varchar(max) ,    
 [MilestoneUnderstandingLanguage] [char](1) ,    
 [MilestoneVocabulary] [char](1) ,    
 [MilestoneFineMotor] [char](1) ,    
 [MilestoneGrossMotor] [char](1) ,    
 [MilestoneIntellectual] [char](1) ,    
 [MilestoneMakingFriends] [char](1) ,    
 [MilestoneSharingInterests] [char](1) ,    
 [MilestoneEyeContact] [char](1) ,    
 [MilestoneToiletTraining] [char](1) ,    
 [MilestoneCopingSkills] [char](1) ,    
 [MilestoneComment] varchar(max) ,    
 [SleepConcernSleepHabits] char(1) ,    
 [SleepTimeGoToBed] [varchar](250) ,    
 [SleepTimeFallAsleep] [varchar](250) ,    
 [SleepThroughNight] char(1) ,    
 [SleepNightmares] char(1) ,    
 [SleepNightmaresHowOften] [varchar](250) ,    
 [SleepTerrors] char(1) ,    
 [SleepTerrorsHowOften] [varchar](250) ,    
 [SleepWalking] char(1) ,    
 [SleepWalkingHowOften] [varchar](250) ,    
 [SleepTimeWakeUp] [varchar](250) ,    
 [SleepWhere] [varchar](250) ,    
 [SleepShareRoom] char(1) ,    
 [SleepShareRoomWithWhom] [varchar](250) ,    
 [SleepTakeNaps] char(1) ,    
 [SleepTakeNapsHowOften] [varchar](250) ,    
 [FamilyPrimaryCaregiver] [varchar](250) ,    
 [FamilyPrimaryCaregiverType] [char](1) ,    
 [FamilyPrimaryCaregiverEducation] [char](1) ,    
 [FamilyPrimaryCaregiverAge] [varchar](250) ,    
 [FamilyAdditionalCareGivers] varchar(max) ,    
 [FamilyEmploymentFirstCareGiver] int ,    
 [FamilyEmploymentSecondCareGiver] int ,    
 [FamilyStatusParentsRelationship] varchar(max) ,    
 [FamilyNonCustodialContact] [char](1) ,    
 [FamilyNonCustodialHowOften] varchar(max) , 
 [FamilyNonCustodialTypeOfVisit] varchar(max) ,  
 [FamilyNonCustodialConsistency] varchar(max) ,    
 [FamilyNonCustodialLegalInvolvement] varchar(max) ,    
 [FamilyClientMovedResidences] char(1) ,    
 [FamilyClientMovedResidencesComment] varchar(max) ,    
 [FamilyClientHasSiblings] char(1) ,    
 [FamilyClientSiblingsComment] varchar(max) ,    
 [FamilyQualityRelationships] varchar(max) ,    
 [FamilySupportSystems] varchar(max) ,    
 [FamilyClientAbilitiesNA] char(1) ,    
 [FamilyClientAbilitiesComment] varchar(max) ,    
 [ChildHistoryLegalInvolvement] char(1) ,    
 [ChildHistoryLegalInvolvementComment] varchar(max) ,    
 [ChildHistoryBehaviorInFamily] char(1) ,    
 [ChildHistoryBehaviorInFamilyComment] varchar(max) ,    
 [ChildAbuseReported] char(1) ,    
 [ChildProtectiveServicesInvolved] char(1) ,    
 [ChildProtectiveServicesReason] varchar(max) ,    
 [ChildProtectiveServicesCounty] varchar(max) ,    
 [ChildProtectiveServicesCaseWorker] varchar(max) ,    
 [ChildProtectiveServicesDates] varchar(max) ,    
 [ChildProtectiveServicesPlacements] char(1) ,    
 [ChildProtectiveServicesPlacementsComment] varchar(max) ,    
 [ChildHistoryOfViolence] char(1) ,    
 [ChildHistoryOfViolenceComment] varchar(max) ,    
 [ChildCTESComplete] char(1) ,    
 [ChildCTESResults] varchar(max) ,    
 [ChildWitnessedSubstances] char(1) ,    
 [ChildWitnessedSubstancesComment] varchar(max) ,    
 [ChildBornFullTermPreTerm] [char](1) ,    
 [ChildBornFullTermPreTermComment] varchar(max) ,    
 [ChildPostPartumDepression] char(1) ,    
 [ChildMotherUsedDrugsPregnancy] char(1) ,    
 [ChildMotherUsedDrugsPregnancyComment] varchar(max) ,    
 [ChildConcernsNutrition] char(1) ,    
 [ChildConcernsNutritionComment] varchar(max) ,    
 [ChildConcernsAbilityUnderstand] char(1) ,    
 [ChildUsingWordsPhrases] char(1) ,    
 [ChildReceivedSpeechEval] char(1) ,    
 [ChildReceivedSpeechEvalComment] varchar(max) ,    
 [ChildConcernMotorSkills] char(1) ,    
 [ChildGrossMotorSkillsProblem] char(1) ,    
 [ChildWalking14Months] char(1) ,    
 [ChildFineMotorSkillsProblem] char(1) ,    
 [ChildPickUpCheerios] char(1) ,    
 [ChildConcernSocialSkills] char(1) ,    
 [ChildConcernSocialSkillsComment] varchar(max) ,    
 [ChildToiletTraining] char(1) ,    
 [ChildToiletTrainingComment] varchar(max) ,    
 [ChildSensoryAversions] char(1) ,    
 [ChildSensoryAversionsComment] varchar(max) ,    
 [HousingHowStable] varchar(max) ,    
 [HousingAbleToStay] varchar(max) ,    
 [HousingEvictionsUnpaidUtilities] varchar(max) ,    
 [HousingAbleGetUtilities] varchar(max) ,    
 [HousingAbleSignLease] varchar(max) ,    
 [HousingSpecializedProgram] varchar(max) ,    
 [HousingHasPets] varchar(max) ,    
 [VocationalUnemployed] char(1) ,    
 [VocationalInterestedWorking] char(1) ,    
 [VocationalInterestedWorkingComment] varchar(max) ,    
 [VocationalTimeSinceEmployed] varchar(max) ,    
 [VocationalTimeJobHeld] varchar(max) ,    
 [VocationalBarriersGainingEmployment] varchar(max) ,    
 [VocationalEmployed] char(1) ,    
 [VocationalTimeCurrentJob] varchar(max) ,    
 [VocationalBarriersMaintainingEmployment] varchar(max) ,
 [LevelofCare] [int]     
)    
    
insert into #CustomDocumentDiagnosticAssessments    
(    
 [DocumentVersionId],    
 [CreatedBy],    
 [CreatedDate],    
 [ModifiedBy],    
 [ModifiedDate],    
 [RecordDeleted],    
 [DeletedBy],    
 [DeletedDate],    
 [TypeOfAssessment],    
 [InitialOrUpdate],    
 [ReasonForUpdate],    
 [UpdatePsychoSocial],    
 [UpdateSubstanceUse],    
 [UpdateRiskIndicators],    
 [UpdatePhysicalHealth],    
 [UpdateEducationHistory],    
 [UpdateDevelopmentalHistory],    
 [UpdateSleepHygiene],    
 [UpdateFamilyHistory],    
 [UpdateHousing],    
 [UpdateVocational],    
 [TransferReceivingStaff],    
 [TransferReceivingProgram],    
 [TransferAssessedNeed],    
 [TransferClientParticipated],    
 [PresentingProblem],    
 [OptionsAlreadyTried],    
 [ClientHasLegalGuardian],    
 [LegalGuardianInfo],    
 [AbilitiesInterestsSkills],    
 [FamilyHistory],    
 [EthnicityCulturalBackground],    
 [SexualOrientationGenderExpression],    
 [GenderExpressionConsistent],    
 [SupportSystems],    
 [ClientStrengths],    
 [LivingSituation],    
 [IncludeHousingAssessment],    
 [ClientEmploymentNotApplicable],    
 [ClientEmploymentMilitaryHistory],    
 [IncludeVocationalAssessment],    
 [HighestEducationCompleted],    
 [EducationComment],    
 [LiteracyConcerns],    
 [LegalInvolvement],    
 [LegalInvolvementComment],    
 [HistoryEmotionalProblemsClient],    
 [ClientHasReceivedTreatment],    
 [ClientPriorTreatmentDiagnosis],    
 [PriorTreatmentCounseling],    
 [PriorTreatmentCounselingDates],    
 [PriorTreatmentCounselingComment],    
 [PriorTreatmentCaseManagement],    
 [PriorTreatmentCaseManagementDates],    
 [PriorTreatmentCaseManagementComment],    
 [PriorTreatmentOther],    
 [PriorTreatmentOtherDates],    
 [PriorTreatmentOtherComment],    
 [PriorTreatmentMedication],    
 [PriorTreatmentMedicationDates],    
 [PriorTreatmentMedicationComment],    
 [TypesOfMedicationResults],    
 [ClientResponsePastTreatment],    
 [ClientResponsePastTreatmentNA],    
 [AbuseNotApplicable],    
 [AbuseEmotionalVictim],    
 [AbuseEmotionalOffender],    
 [AbuseVerbalVictim],    
 [AbuseVerbalOffender],    
 [AbusePhysicalVictim],    
 [AbusePhysicalOffender],    
 [AbuseSexualVictim],    
 [AbuseSexualOffender],    
 [AbuseNeglectVictim],    
 [AbuseNeglectOffender],    
 [AbuseComment],    
 [FamilyPersonalHistoryLossTrauma],    
 [BiologicalMotherUseNoneReported],    
 [BiologicalMotherUseAlcohol],    
 [BiologicalMotherTobacco],    
 [BiologicalMotherUseOther],    
 [BiologicalMotherUseOtherType],    
 [ClientReportAlcoholTobaccoDrugUse],    
 [ClientReportDrugUseComment],    
 [FurtherSubstanceAssessmentIndicated],   
 [ClientHasHistorySubstanceUse],    
 [ClientHistorySubstanceUseComment],    
 [AlcoholUseWithin30Days],    
 [AlcoholUseCurrentFrequency],    
 [AlcoholUseWithinLifetime],    
 [AlcoholUsePastFrequency],    
 [AlcoholUseReceivedTreatment],    
 [CocaineUseWithin30Days],    
 [CocaineUseCurrentFrequency],    
 [CocaineUseWithinLifetime],    
 [CocaineUsePastFrequency],    
 [CocaineUseReceivedTreatment],    
 [SedtativeUseWithin30Days],    
 [SedtativeUseCurrentFrequency],    
 [SedtativeUseWithinLifetime],    
 [SedtativeUsePastFrequency],    
 [SedtativeUseReceivedTreatment],    
 [HallucinogenUseWithin30Days],    
 [HallucinogenUseCurrentFrequency],    
 [HallucinogenUseWithinLifetime],    
 [HallucinogenUsePastFrequency],    
 [HallucinogenUseReceivedTreatment],    
 [StimulantUseWithin30Days],    
 [StimulantUseCurrentFrequency],    
 [StimulantUseWithinLifetime],    
 [StimulantUsePastFrequency],    
 [StimulantUseReceivedTreatment],    
 [NarcoticUseWithin30Days],    
 [NarcoticUseCurrentFrequency],    
 [NarcoticUseWithinLifetime],    
 [NarcoticUsePastFrequency],    
 [NarcoticUseReceivedTreatment],    
 [MarijuanaUseCurrentFrequency],    
 [MarijuanaUsePastFrequency],    
 [MarijuanaUseWithin30Days],    
 [MarijuanaUseWithinLifetime],    
 [MarijuanaUseReceivedTreatment],    
 [InhalantsUseWithin30Days],    
 [InhalantsUseCurrentFrequency],    
 [InhalantsUseWithinLifetime],    
 [InhalantsUsePastFrequency],    
 [InhalantsUseReceivedTreatment],    
 [OtherUseWithin30Days],    
 [OtherUseCurrentFrequency],    
 [OtherUseWithinLifetime],    
 [OtherUsePastFrequency],    
 [OtherUseReceivedTreatment],    
 [OtherUseType],    
 [DASTScore],    
 [MASTScore],    
 [ClientReferredSubstanceTreatment],    
 [ClientReferredSubstanceTreatmentWhere],    
 [RiskSuicideIdeation],    
 [RiskSuicideIdeationComment],    
 [RiskSuicideIntent],    
 [RiskSuicideIntentComment],    
 [RiskSuicidePriorAttempts],    
 [RiskSuicidePriorAttemptsComment],    
 [RiskPriorHospitalization],    
 [RiskPriorHospitalizationComment],    
 [RiskPhysicalAggressionSelf],    
 [RiskPhysicalAggressionSelfComment],    
 [RiskVerbalAggressionOthers],    
 [RiskVerbalAggressionOthersComment],    
 [RiskPhysicalAggressionObjects],    
 [RiskPhysicalAggressionObjectsComment],    
 [RiskPhysicalAggressionPeople],    
 [RiskPhysicalAggressionPeopleComment],    
 [RiskReportRiskTaking],    
 [RiskReportRiskTakingComment],    
 [RiskThreatClientPersonalSafety],    
 [RiskThreatClientPersonalSafetyComment],    
 [RiskPhoneNumbersProvided],    
 [RiskCurrentRiskIdentified],    
 [RiskTriggersDangerousBehaviors],    
 [RiskCopingSkills],    
 [RiskInterventionsPersonalSafetyNA],    
 [RiskInterventionsPersonalSafety],    
 [RiskInterventionsPublicSafetyNA],    
 [RiskInterventionsPublicSafety],    
 [PhysicalProblemsNoneReported],    
 [PhysicalProblemsComment],    
 [SpecialNeedsNoneReported],    
 [SpecialNeedsVisualImpairment],    
 [SpecialNeedsHearingImpairment],    
 [SpecialNeedsSpeechImpairment],    
 [SpecialNeedsOtherPhysicalImpairment],    
 [SpecialNeedsOtherPhysicalImpairmentComment],    
 [EducationSchoolName],    
 [EducationPreviousExpulsions],    
 [EducationClassification],    
 [EducationEmotionalDisturbance],    
 [EducationPreschoolersDisability],    
 [EducationTraumaticBrainInjury],    
 [EducationCognitiveDisability],    
 [EducationCurrent504],    
 [EducationOtherMajorHealthImpaired],    
 [EducationSpecificLearningDisability],    
 [EducationAutism],    
 [EducationOtherMinorHealthImpaired],    
 [EdcuationClassificationComment],    
 [EducationPreviousRetentions],    
 [EducationClientIsHomeSchooled],    
 [EducationClientAttendedPreschool],    
 [EducationFrequencyOfAttendance],    
 [EducationReceivedServicesAsToddler],    
 [EducationReceivedServicesAsToddlerComment],    
 [ClientPreferencesForTreatment],    
 [ExternalSupportsReferrals],    
 [PrimaryClinicianTransfer],    
 [EAPMentalStatus],    
 [DiagnosticImpressionsSummary],    
 [MilestoneUnderstandingLanguage],    
 [MilestoneVocabulary],    
 [MilestoneFineMotor],    
 [MilestoneGrossMotor],    
 [MilestoneIntellectual],    
 [MilestoneMakingFriends],    
 [MilestoneSharingInterests],    
 [MilestoneEyeContact],    
 [MilestoneToiletTraining],    
 [MilestoneCopingSkills],    
 [MilestoneComment],    
 [SleepConcernSleepHabits],    
 [SleepTimeGoToBed],    
 [SleepTimeFallAsleep],    
 [SleepThroughNight],    
 [SleepNightmares],    
 [SleepNightmaresHowOften],    
 [SleepTerrors],    
 [SleepTerrorsHowOften],    
 [SleepWalking],    
 [SleepWalkingHowOften],    
 [SleepTimeWakeUp],    
 [SleepWhere],    
 [SleepShareRoom],    
 [SleepShareRoomWithWhom],    
 [SleepTakeNaps],    
 [SleepTakeNapsHowOften],    
 [FamilyPrimaryCaregiver],    
 [FamilyPrimaryCaregiverType],    
 [FamilyPrimaryCaregiverEducation],    
 [FamilyPrimaryCaregiverAge],    
 [FamilyAdditionalCareGivers],    
 [FamilyEmploymentFirstCareGiver],    
 [FamilyEmploymentSecondCareGiver],    
 [FamilyStatusParentsRelationship],    
 [FamilyNonCustodialContact],    
 [FamilyNonCustodialHowOften],    
 [FamilyNonCustodialTypeOfVisit],    
 [FamilyNonCustodialConsistency],    
 [FamilyNonCustodialLegalInvolvement],    
 [FamilyClientMovedResidences],    
 [FamilyClientMovedResidencesComment],    
 [FamilyClientHasSiblings],    
 [FamilyClientSiblingsComment],    
 [FamilyQualityRelationships],    
 [FamilySupportSystems],    
 [FamilyClientAbilitiesNA],    
 [FamilyClientAbilitiesComment],    
 [ChildHistoryLegalInvolvement],    
 [ChildHistoryLegalInvolvementComment],    
 [ChildHistoryBehaviorInFamily],    
 [ChildHistoryBehaviorInFamilyComment],    
 [ChildAbuseReported],    
 [ChildProtectiveServicesInvolved],    
 [ChildProtectiveServicesReason],    
 [ChildProtectiveServicesCounty],    
 [ChildProtectiveServicesCaseWorker],    
 [ChildProtectiveServicesDates],    
 [ChildProtectiveServicesPlacements],    
 [ChildProtectiveServicesPlacementsComment],    
 [ChildHistoryOfViolence],    
 [ChildHistoryOfViolenceComment],    
 [ChildCTESComplete],    
 [ChildCTESResults],    
 [ChildWitnessedSubstances],    
 [ChildWitnessedSubstancesComment],    
 [ChildBornFullTermPreTerm],    
 [ChildBornFullTermPreTermComment],    
 [ChildPostPartumDepression],    
 [ChildMotherUsedDrugsPregnancy],    
 [ChildMotherUsedDrugsPregnancyComment],    
 [ChildConcernsNutrition],    
 [ChildConcernsNutritionComment],    
 [ChildConcernsAbilityUnderstand],    
 [ChildUsingWordsPhrases],    
 [ChildReceivedSpeechEval],    
 [ChildReceivedSpeechEvalComment],    
 [ChildConcernMotorSkills],    
 [ChildGrossMotorSkillsProblem],    
 [ChildWalking14Months],    
 [ChildFineMotorSkillsProblem],    
 [ChildPickUpCheerios],    
 [ChildConcernSocialSkills],    
 [ChildConcernSocialSkillsComment],    
 [ChildToiletTraining],    
 [ChildToiletTrainingComment],    
 [ChildSensoryAversions],    
 [ChildSensoryAversionsComment],    
 [HousingHowStable],    
 [HousingAbleToStay],    
 [HousingEvictionsUnpaidUtilities],    
 [HousingAbleGetUtilities],    
 [HousingAbleSignLease],    
 [HousingSpecializedProgram],    
 [HousingHasPets],    
 [VocationalUnemployed],    
 [VocationalInterestedWorking],    
 [VocationalInterestedWorkingComment],    
 [VocationalTimeSinceEmployed],    
 [VocationalTimeJobHeld],    
 [VocationalBarriersGainingEmployment],    
 [VocationalEmployed],    
 [VocationalTimeCurrentJob],    
 [VocationalBarriersMaintainingEmployment],
 [LevelofCare]    
)    
select    
 [DocumentVersionId],    
 [CreatedBy],    
 [CreatedDate],    
 [ModifiedBy],    
 [ModifiedDate],    
 [RecordDeleted],    
 [DeletedBy],    
 [DeletedDate],    
 [TypeOfAssessment],    
 [InitialOrUpdate],    
 [ReasonForUpdate],    
 [UpdatePsychoSocial],    
 [UpdateSubstanceUse],    
 [UpdateRiskIndicators],    
 [UpdatePhysicalHealth],    
 [UpdateEducationHistory],    
 [UpdateDevelopmentalHistory],    
 [UpdateSleepHygiene],    
 [UpdateFamilyHistory],    
 [UpdateHousing],    
 [UpdateVocational],    
 [TransferReceivingStaff],    
 [TransferReceivingProgram],    
 [TransferAssessedNeed],    
 [TransferClientParticipated],    
 [PresentingProblem],    
 [OptionsAlreadyTried],    
 [ClientHasLegalGuardian],    
 [LegalGuardianInfo],    
 [AbilitiesInterestsSkills],    
 [FamilyHistory],    
 [EthnicityCulturalBackground],    
 [SexualOrientationGenderExpression],    
 [GenderExpressionConsistent],    
 [SupportSystems],    
 [ClientStrengths],    
 [LivingSituation],    
 [IncludeHousingAssessment],    
 [ClientEmploymentNotApplicable],    
 [ClientEmploymentMilitaryHistory],    
 [IncludeVocationalAssessment],    
 [HighestEducationCompleted],    
 [EducationComment],    
 [LiteracyConcerns],    
 [LegalInvolvement],    
 [LegalInvolvementComment],    
 [HistoryEmotionalProblemsClient],    
 [ClientHasReceivedTreatment],    
 [ClientPriorTreatmentDiagnosis],    
 [PriorTreatmentCounseling],    
 [PriorTreatmentCounselingDates],    
 [PriorTreatmentCounselingComment],    
 [PriorTreatmentCaseManagement],    
 [PriorTreatmentCaseManagementDates],    
 [PriorTreatmentCaseManagementComment],    
 [PriorTreatmentOther],    
 [PriorTreatmentOtherDates],    
 [PriorTreatmentOtherComment],    
 [PriorTreatmentMedication],    
 [PriorTreatmentMedicationDates],    
 [PriorTreatmentMedicationComment],    
 [TypesOfMedicationResults],    
 [ClientResponsePastTreatment],    
 [ClientResponsePastTreatmentNA],    
 [AbuseNotApplicable],    
 [AbuseEmotionalVictim],    
 [AbuseEmotionalOffender],    
 [AbuseVerbalVictim],    
 [AbuseVerbalOffender],    
 [AbusePhysicalVictim],    
 [AbusePhysicalOffender],    
 [AbuseSexualVictim],    
 [AbuseSexualOffender],    
 [AbuseNeglectVictim],    
 [AbuseNeglectOffender],    
 [AbuseComment],    
 [FamilyPersonalHistoryLossTrauma],    
 [BiologicalMotherUseNoneReported],    
 [BiologicalMotherUseAlcohol],    
 [BiologicalMotherTobacco],    
 [BiologicalMotherUseOther],    
 [BiologicalMotherUseOtherType],    
 [ClientReportAlcoholTobaccoDrugUse],    
 [ClientReportDrugUseComment],    
 [FurtherSubstanceAssessmentIndicated],    
 [ClientHasHistorySubstanceUse],    
 [ClientHistorySubstanceUseComment],    
 [AlcoholUseWithin30Days],    
 [AlcoholUseCurrentFrequency],    
 [AlcoholUseWithinLifetime],    
 [AlcoholUsePastFrequency],    
 [AlcoholUseReceivedTreatment],    
 [CocaineUseWithin30Days],    
 [CocaineUseCurrentFrequency],    
 [CocaineUseWithinLifetime],    
 [CocaineUsePastFrequency],    
 [CocaineUseReceivedTreatment],    
 [SedtativeUseWithin30Days],    
 [SedtativeUseCurrentFrequency],    
 [SedtativeUseWithinLifetime],    
 [SedtativeUsePastFrequency],    
 [SedtativeUseReceivedTreatment],    
 [HallucinogenUseWithin30Days],    
 [HallucinogenUseCurrentFrequency],    
 [HallucinogenUseWithinLifetime],    
 [HallucinogenUsePastFrequency],    
 [HallucinogenUseReceivedTreatment],    
 [StimulantUseWithin30Days],    
 [StimulantUseCurrentFrequency],    
 [StimulantUseWithinLifetime],    
 [StimulantUsePastFrequency],    
 [StimulantUseReceivedTreatment],    
 [NarcoticUseWithin30Days],    
 [NarcoticUseCurrentFrequency],    
 [NarcoticUseWithinLifetime],    
 [NarcoticUsePastFrequency],    
 [NarcoticUseReceivedTreatment],    
 [MarijuanaUseCurrentFrequency],    
 [MarijuanaUsePastFrequency],    
 [MarijuanaUseWithin30Days],    
 [MarijuanaUseWithinLifetime],    
 [MarijuanaUseReceivedTreatment],    
 [InhalantsUseWithin30Days],    
 [InhalantsUseCurrentFrequency],    
 [InhalantsUseWithinLifetime],    
 [InhalantsUsePastFrequency],    
 [InhalantsUseReceivedTreatment],    
 [OtherUseWithin30Days],    
 [OtherUseCurrentFrequency],    
 [OtherUseWithinLifetime],    
 [OtherUsePastFrequency],    
 [OtherUseReceivedTreatment],    
 [OtherUseType],    
 [DASTScore],    
 [MASTScore],    
 [ClientReferredSubstanceTreatment],    
 [ClientReferredSubstanceTreatmentWhere],    
 [RiskSuicideIdeation],    
 [RiskSuicideIdeationComment],    
 [RiskSuicideIntent],    
 [RiskSuicideIntentComment],    
 [RiskSuicidePriorAttempts],    
 [RiskSuicidePriorAttemptsComment],    
 [RiskPriorHospitalization],    
 [RiskPriorHospitalizationComment],    
 [RiskPhysicalAggressionSelf],    
 [RiskPhysicalAggressionSelfComment],    
 [RiskVerbalAggressionOthers],    
 [RiskVerbalAggressionOthersComment],    
 [RiskPhysicalAggressionObjects],    
 [RiskPhysicalAggressionObjectsComment],    
 [RiskPhysicalAggressionPeople],    
 [RiskPhysicalAggressionPeopleComment],    
 [RiskReportRiskTaking],    
 [RiskReportRiskTakingComment],    
 [RiskThreatClientPersonalSafety],    
 [RiskThreatClientPersonalSafetyComment],    
 [RiskPhoneNumbersProvided],    
 [RiskCurrentRiskIdentified],    
 [RiskTriggersDangerousBehaviors],    
 [RiskCopingSkills],    
 [RiskInterventionsPersonalSafetyNA],    
 [RiskInterventionsPersonalSafety],    
 [RiskInterventionsPublicSafetyNA],    
 [RiskInterventionsPublicSafety],    
 [PhysicalProblemsNoneReported],    
 [PhysicalProblemsComment],    
 [SpecialNeedsNoneReported],    
 [SpecialNeedsVisualImpairment],    
 [SpecialNeedsHearingImpairment],    
 [SpecialNeedsSpeechImpairment],    
 [SpecialNeedsOtherPhysicalImpairment],    
 [SpecialNeedsOtherPhysicalImpairmentComment],    
 [EducationSchoolName],    
 [EducationPreviousExpulsions],    
 [EducationClassification],    
 [EducationEmotionalDisturbance],    
 [EducationPreschoolersDisability],    
 [EducationTraumaticBrainInjury],    
 [EducationCognitiveDisability],    
 [EducationCurrent504],    
 [EducationOtherMajorHealthImpaired],    
 [EducationSpecificLearningDisability],    
 [EducationAutism],    
 [EducationOtherMinorHealthImpaired],    
 [EdcuationClassificationComment],    
 [EducationPreviousRetentions],    
 [EducationClientIsHomeSchooled],    
 [EducationClientAttendedPreschool],    
 [EducationFrequencyOfAttendance],    
 [EducationReceivedServicesAsToddler],    
 [EducationReceivedServicesAsToddlerComment],    
 [ClientPreferencesForTreatment],    
 [ExternalSupportsReferrals],    
 [PrimaryClinicianTransfer],    
 [EAPMentalStatus],    
 [DiagnosticImpressionsSummary],    
 [MilestoneUnderstandingLanguage],    
 [MilestoneVocabulary],    
 [MilestoneFineMotor],    
 [MilestoneGrossMotor],    
 [MilestoneIntellectual],    
 [MilestoneMakingFriends],    
 [MilestoneSharingInterests],    
 [MilestoneEyeContact],    
 [MilestoneToiletTraining],    
 [MilestoneCopingSkills],    
 [MilestoneComment],    
 [SleepConcernSleepHabits],    
 [SleepTimeGoToBed],    
 [SleepTimeFallAsleep],    
 [SleepThroughNight],    
 [SleepNightmares],    
 [SleepNightmaresHowOften],    
 [SleepTerrors],    
 [SleepTerrorsHowOften],    
 [SleepWalking],    
 [SleepWalkingHowOften],    
 [SleepTimeWakeUp],    
 [SleepWhere],    
 [SleepShareRoom],    
 [SleepShareRoomWithWhom],    
 [SleepTakeNaps],    
 [SleepTakeNapsHowOften],    
 [FamilyPrimaryCaregiver],    
 [FamilyPrimaryCaregiverType],    
 [FamilyPrimaryCaregiverEducation],    
 [FamilyPrimaryCaregiverAge],    
 [FamilyAdditionalCareGivers],    
 [FamilyEmploymentFirstCareGiver],    
 [FamilyEmploymentSecondCareGiver],    
 [FamilyStatusParentsRelationship],    
 [FamilyNonCustodialContact],    
 [FamilyNonCustodialHowOften],    
 [FamilyNonCustodialTypeOfVisit],    
 [FamilyNonCustodialConsistency],    
 [FamilyNonCustodialLegalInvolvement],    
 [FamilyClientMovedResidences],    
 [FamilyClientMovedResidencesComment],    
 [FamilyClientHasSiblings],    
 [FamilyClientSiblingsComment],    
 [FamilyQualityRelationships],    
 [FamilySupportSystems],    
 [FamilyClientAbilitiesNA],    
 [FamilyClientAbilitiesComment],    
 [ChildHistoryLegalInvolvement],    
 [ChildHistoryLegalInvolvementComment],    
 [ChildHistoryBehaviorInFamily],    
 [ChildHistoryBehaviorInFamilyComment],    
 [ChildAbuseReported],    
 [ChildProtectiveServicesInvolved],    
 [ChildProtectiveServicesReason],    
 [ChildProtectiveServicesCounty],    
 [ChildProtectiveServicesCaseWorker],    
 [ChildProtectiveServicesDates],    
 [ChildProtectiveServicesPlacements],    
 [ChildProtectiveServicesPlacementsComment],    
 [ChildHistoryOfViolence],    
 [ChildHistoryOfViolenceComment],    
 [ChildCTESComplete],    
 [ChildCTESResults],    
 [ChildWitnessedSubstances],    
 [ChildWitnessedSubstancesComment],    
 [ChildBornFullTermPreTerm],    
 [ChildBornFullTermPreTermComment],    
 [ChildPostPartumDepression],    
 [ChildMotherUsedDrugsPregnancy],    
 [ChildMotherUsedDrugsPregnancyComment],    
 [ChildConcernsNutrition],    
 [ChildConcernsNutritionComment],    
 [ChildConcernsAbilityUnderstand],    
 [ChildUsingWordsPhrases],    
 [ChildReceivedSpeechEval],    
 [ChildReceivedSpeechEvalComment],    
 [ChildConcernMotorSkills],    
 [ChildGrossMotorSkillsProblem],    
 [ChildWalking14Months],    
 [ChildFineMotorSkillsProblem],    
 [ChildPickUpCheerios],    
 [ChildConcernSocialSkills],    
 [ChildConcernSocialSkillsComment],    
 [ChildToiletTraining],    
 [ChildToiletTrainingComment],    
 [ChildSensoryAversions],    
 [ChildSensoryAversionsComment],    
 [HousingHowStable],    
 [HousingAbleToStay],    
 [HousingEvictionsUnpaidUtilities],    
 [HousingAbleGetUtilities],    
 [HousingAbleSignLease],    
 [HousingSpecializedProgram],    
 [HousingHasPets],    
 [VocationalUnemployed],    
 [VocationalInterestedWorking],    
 [VocationalInterestedWorkingComment],    
 [VocationalTimeSinceEmployed],    
 [VocationalTimeJobHeld],    
 [VocationalBarriersGainingEmployment],    
 [VocationalEmployed],    
 [VocationalTimeCurrentJob],    
 [VocationalBarriersMaintainingEmployment] ,
 [LevelofCare]   
from CustomDocumentDiagnosticAssessments    
where DocumentVersionId = @DocumentVersionId    
    
-- Initial / Adult BH    
if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'A' and [InitialOrUpdate] = 'I')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialAdult @DocumentVersionId    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 -- determine whether the treatment goals need to be validated    
 if exists (    
  select *    
  from CustomDocumentAssessmentReferrals as cdar    
  where cdar.DocumentVersionId = @DocumentVersionId    
  -- need logic to exclude evals    
  and cdar.ServiceRecommended not in (10, 14, 15) -- DP Consult, Psych Testing, Psych Eval    
  and ISNULL(cdar.RecordDeleted, 'N') <> 'Y'    
 )    
 or exists (    
  select *    
  from dbo.CustomTPGoals as tpg    
  where tpg.DocumentVersionId = @DocumentVersionId    
  and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '')))) > 0    
  and ISNULL(tpg.RecordDeleted, 'N') <> 'Y'    
 )    
 begin    
  exec csp_ValidateCustomDocumentDiagnosticAssessmentsTreatmentPlan @DocumentVersionId, 8    
 end    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Update / Adult BH    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'A' and [InitialOrUpdate] = 'U')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialAdult @DocumentVersionId    
 -- exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Initial / Minor BH    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'M' and [InitialOrUpdate] = 'I')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor @DocumentVersionId    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 -- determine whether the treatment goals need to be validated    
 if exists (    
  select *    
  from CustomDocumentAssessmentReferrals as cdar    
  where cdar.DocumentVersionId = @DocumentVersionId    
  -- need logic to exclude evals    
  and cdar.ServiceRecommended not in (10, 14, 15) -- DP Consult, Psych Testing, Psych Eval    
  and ISNULL(cdar.RecordDeleted, 'N') <> 'Y'    
 )    
 or exists (    
  select *    
  from dbo.CustomTPGoals as tpg    
  where tpg.DocumentVersionId = @DocumentVersionId    
  and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '')))) > 0    
  and ISNULL(tpg.RecordDeleted, 'N') <> 'Y'    
 )    
 begin    
  exec csp_ValidateCustomDocumentDiagnosticAssessmentsTreatmentPlan @DocumentVersionId, 8    
 end    
    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Update / Minor BH    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'M' and [InitialOrUpdate] = 'U')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialMinor @DocumentVersionId    
 -- exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Initial / Early Child/DP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'C' and [InitialOrUpdate] = 'I')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP @DocumentVersionId    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
 -- determine whether the treatment goals need to be validated    
 if exists (    
  select *    
  from CustomDocumentAssessmentReferrals as cdar    
  where cdar.DocumentVersionId = @DocumentVersionId    
  and cdar.ServiceRecommended not in (10, 14, 15) -- DP Consult, Psych Testing, Psych Eval    
  and ISNULL(cdar.RecordDeleted, 'N') <> 'Y'    
 )    
 or exists (    
  select *    
  from dbo.CustomTPGoals as tpg    
  where tpg.DocumentVersionId = @DocumentVersionId    
  and LEN(LTRIM(RTRIM(ISNULL(tpg.GoalText, '')))) > 0    
  and ISNULL(tpg.RecordDeleted, 'N') <> 'Y'    
 )    
 begin    
  exec csp_ValidateCustomDocumentDiagnosticAssessmentsTreatmentPlan @DocumentVersionId, 8   end    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Update / Early Child / DP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'C' and [InitialOrUpdate] = 'U')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialDP @DocumentVersionId    
 -- exec csp_ValidateCustomDocumentDiagnosticAssessmentsNeeds @DocumentVersionId, 6    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentReferralServices @DocumentVersionid, 7    
    
    
 exec dbo.csp_ValidateCustomDocumentMentalStatuses @DocumentVersionId, 9    
 exec dbo.csp_validateDiagnosis @DocumentVersionId, 10    
    
end    
-- Initial / EAP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'E' and [InitialOrUpdate] = 'I')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialEAP @DocumentVersionId    
    
end    
-- Update / EAP    
else if exists (select * from #CustomDocumentDiagnosticAssessments where [TypeOfAssessment] = 'E' and [InitialOrUpdate] = 'U')    
begin    
    
 exec csp_ValidateCustomDocumentDiagnosticAssessmentsInitialEAP @DocumentVersionId    
    
end    
 
-- check for an "assessment" service on the same day for the same client.    
if not exists (    
 select *    
 from dbo.DocumentVersions as dv    
 join dbo.Documents as d on d.DocumentId = dv.DocumentId    
 join dbo.Services as s on s.ClientId = d.ClientId    
 where dv.DocumentVersionId = @DocumentVersionId    
 and s.ProcedureCodeId in (    
  24,  --ASSESSMENT    
  26,  --ASSMT_UPD     
  258, --EAP_ASSESS    
  269, --EAPPHON_AS    
  277, --EQ_ASSESS     
  318, --ASSMT_HOSP    
  509, --V_RSCASSMT    
  532, --V_SIT_ASST    
  --617, --WELL_ASSES    
  241, --EAP_MD_AST    
  267, --EAP_MD_AST  avoss 08.06.2012    
  159  --OWF_NB_AST    
 )    
 and s.Status in (71, 75) -- show complete    
 and DATEDIFF(DAY, d.EffectiveDate, s.DateOfService) = 0    
 and ISNULL(s.RecordDeleted, 'N') <> 'Y'    
 and ISNULL(d.RecordDeleted, 'N') <> 'Y'    
)    
begin    
 Insert into #validationReturnTable (    
  TableName,      
  ColumnName,      
  ErrorMessage,      
  TabOrder,      
  ValidationOrder      
 ) values (    
  'CustomDocumentDiagnosticAssessments',    
  'DeletedBy',    
  'A show/complete "Assessment" service must exist for this document effective date.',    
  11,    
  1    
 )    
end    
    
    
  
-- check for an "LevelofCare" in CustomDocumentDiagnosticAssessments. 
declare @levelofcare int
select  @levelofcare = LevelofCare from #CustomDocumentDiagnosticAssessments as da   
 where da.DocumentVersionId = @DocumentVersionId  and ISNULL(da.RecordDeleted, 'N') <> 'Y'  
if (@levelofcare is null )
begin    
 Insert into #validationReturnTable (    
  TableName,      
  ColumnName,      
  ErrorMessage,      
  TabOrder,      
  ValidationOrder      
 ) values (    
  'CustomDocumentDiagnosticAssessments',    
  'LevelofCare',    
  'Level of Care is required',    
  12,    
  1    
 )    
end
GO
/****** Object:  StoredProcedure [dbo].[csp_GetCustomDocumentTransfer]    Script Date: 04/29/2013 16:57:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomDocumentTransfer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomDocumentTransfer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_GetCustomDocumentTransfer]      
(
	@DocumentVersionId INT = NULL
)
AS  
/******************************************************************************                        
**  Name: [csp_GetCustomDocumentTransfer]                        
**  Desc:      
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:          Author:          Description:                        
**  20-june-2012   RohitK    AuthorizationCodeName field Change into DisplayAs aginst task no:81(Services Drop-Downs) Harbor Go Live Issues 
**  29-Apr -2013   Veena     Added LevelofCare for ARM Customization
*******************************************************************************/ 
	SELECT  [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[TransferStatus]
      ,[TransferringStaff]
      ,[AssessedNeedForTransfer]
      ,[ReceivingStaff]
      ,[ReceivingProgram]
      ,[ClientParticpatedWithTransfer]
      ,[TransferSentDate]
      ,[ReceivingComment]
      ,[ReceivingAction]
      ,[ReceivingActionDate]
      ,[LevelofCare]
    FROM [dbo].[CustomDocumentTransfers]
	WHERE
		[DocumentVersionId] = @DocumentVersionId
		
	SELECT TOP 1000 [TransferServiceId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[DocumentVersionId]
      ,[AuthorizationCodeId],
       (SELECT DisplayAs FROM AuthorizationCodes WHERE AuthorizationCodeId = [CustomDocumentTransferServices].AuthorizationCodeId) AS AuthorizationCodeIdText
	FROM [dbo].[CustomDocumentTransferServices]
	WHERE
		DocumentVersionId = @DocumentVersionId
GO
/****** Object:  StoredProcedure [dbo].[csp_ValidateCustomDocumentTransfers]    Script Date: 04/29/2013 16:57:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentTransfers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentTransfers]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[csp_ValidateCustomDocumentTransfers]
	@DocumentVersionId int
/****************************************************************/
-- PROCEDURE: [csp_ValidateCustomDocumentTransfers]
-- PURPOSE: Handles the validation for custom transfer documents.
-- CALLED BY: SmartCare on post-update (signature)
-- REVISION HISTORY:
--		2011.07.19 - T. Remisoski - Created.
--Modified by Veena  added validation for LevelOfCare for ARM Customization
/****************************************************************/

as

declare @StatusNotSent int, @StatusSent int, @StatusComplete int
declare @ActionAccept int, @ActionReject int, @ActionForward int

-- We keep getting burned by having different code-ids between systems so we will init these each time based on category/codename
select @StatusNotSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Not Sent'
select @StatusSent = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Sent'
select @StatusComplete = GlobalCodeId from GlobalCodes where Category = 'REFERRALSTATUS' and CodeName = 'Complete'

select @ActionAccept = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Accept'
select @ActionReject = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Reject'
select @ActionForward = GlobalCodeId from GlobalCodes where Category = 'RECEIVINGACTION' and CodeName = 'Forward'

declare @CurrentStatus int, @ReceivingStaffId int, @ReceivingAction int, @TransferringStaffId int

select
	@CurrentStatus = r.TransferStatus,
	@ReceivingStaffId = r.ReceivingStaff,
	@ReceivingAction = r.ReceivingAction,
	@TransferringStaffId = r.TransferringStaff
from CustomDocumentTransfers as r
where r.DocumentVersionId = @DocumentVersionId

-- Required when sending
if @CurrentStatus = @StatusNotSent
begin
	Insert into #validationReturnTable (
		TableName,  
		ColumnName,  
		ErrorMessage,  
		TabOrder,  
		ValidationOrder  
	)
	select 'CustomDocumentTransfers', 'TransferringStaff', 'Transferring staff selection required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferringStaff is null
	union
	select 'CustomDocumentTransfers', 'ReceivingStaff', 'Receiving staff selection required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null
	union
	select 'CustomDocumentTransfers', 'AssessedNeedForTransfer', 'Assessed need for transfer required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForTransfer)), '')) = 0
	union
	select 'CustomDocumentTransfers', 'ClientParticpatedWithTransfer', 'Client particpation required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithTransfer, 'N') <> 'Y'
	union
	select 'CustomDocumentTransfers', 'DeletedBy', 'Receiving staff cannot be RN or LPN', '', ''
	from dbo.CustomDocumentTransfers as a
	join dbo.Staff as s on s.StaffId = a.ReceivingStaff
	where DocumentVersionId = @DocumentVersionId 
	and s.Degree in (20940,20969)
	union
	select 'CustomDocumentTransfers', 'LevelofCare', 'Current Level of Care is required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LevelofCare is null
end
else if @CurrentStatus = @StatusSent
begin
	Insert into #validationReturnTable (
		TableName,  
		ColumnName,  
		ErrorMessage,  
		TabOrder,  
		ValidationOrder  
	)
	select 'CustomDocumentTransfers', 'TransferringStaff', 'Transferring staff selection required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and TransferringStaff is null
	union
	select 'CustomDocumentTransfers', 'ReceivingStaff', 'Receiving staff selection required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingStaff is null
	union
	select 'CustomDocumentTransfers', 'AssessedNeedForTransfer', 'Assessed need for transfer required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(AssessedNeedForTransfer)), '')) = 0
	union
	select 'CustomDocumentTransfers', 'ClientParticpatedWithTransfer', 'Client particpation required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ISNULL(ClientParticpatedWithTransfer, 'N') <> 'Y'
	union
	select 'CustomDocumentTransfers', 'ReceivingAction', 'Receiving action must be selected', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and ReceivingAction is null
	union
	select 'CustomDocumentTransfers', 'ReceivingComment', 'Comment required when rejecting a transfer', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LEN(ISNULL(LTRIM(RTRIM(ReceivingComment)), '')) = 0
	and ReceivingAction = @ActionReject
	union
	select 'CustomDocumentTransfers', 'DeletedBy', 'Receiving staff cannot be RN or LPN', '', ''
	from dbo.CustomDocumentTransfers as a
	join dbo.Staff as s on s.StaffId = a.ReceivingStaff
	where DocumentVersionId = @DocumentVersionId 
	and s.Degree in (20940,20969)
	--Added by Veena on 25/04/13 for ARM customization
	union
	select 'CustomDocumentTransfers', 'LevelofCare', 'Current Level of Care is required', '', ''
	from dbo.CustomDocumentTransfers where DocumentVersionId = @DocumentVersionId and LevelofCare is null
	

end
GO
/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDiagnosticAssessment]    Script Date: 04/29/2013 16:57:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDiagnosticAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDiagnosticAssessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[csp_SCGetCustomDiagnosticAssessment]                                                                                                                                                                                                  
        
(                                                                                                                                                                                                                                                              
   
  @DocumentVersionId int,                                                                                                                                                                       
  @StaffId as int                                                                                                                                                                                                                                              
       
)                                                                                                                                                                                                                                                              
           
As                                                                                                                                                                                                                              
 /*********************************************************************/                                                                                                                                                                
/* Stored Procedure: csp_SCGetCustomDiagnosticAssessment               */                                                                                                                                                                
/* Copyright: 2009 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                                
/* Creation Date: 27 May,2011                                       */                                                                                                                                                                
/*                                                                   */                                                                                                                                                                
/* Purpose:  Get Data for CustomDiagnosticAssessments Pages  */                                                                                                                                                              
/*                                                                   */                                                                                                                                                              
/* Input Parameters:   @DocumentVersionId,@StaffId  */                                                                                                                                                              
/*                                                                   */                                                                                                                                                                
/* Output Parameters:   None                   */                                                                                                                                                                
/*                                                                   */                            
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                                
/*                                                                   */                                       
/* Called By:  DiagnosticAssessment         */               
/*                 */                               
/* Calls:         */                                                 
/*                         */                                                   
/* Data Modifications:                   */                                                                                
/*      */                                                                                                               
/* Updates:               */                                                                                                        
/*   Date   Author      Purpose                                */                                                                                   
/*  27 May,2011    AshwaniK  Get Data for CustomDiagnosticAssessments Pages */                                                                                           
/* 06-June-2012   Jagdeep         Commented table CustomTPQuickObjectives,CustomTPGlobalQuickTransitionPlans,CustomTPGlobalQuickGoals Now they are directly being updated into database  */      
                                                                                                                                     
/*********************************************************************/          
        
           
BEGIN                                                                                                                                                                                
                                                                                                                                                                                                
declare @ClientId int                                                                                                                                                                                                 
                                                                                                                                                                                                  
select @ClientId = ClientId from Documents where                                                                                                                                                                                                 
 CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,'N')= 'N'                                                                                                                  
                                                                                                                 
                                                                                          
declare @LatestDocumentVersionID int                                                                                                                                                                                  
declare @clientDOB varchar(10)                                                                              
declare @clientAge varchar(50)                              
                                    
Declare @ReferralTransferReferenceURL varchar(1000)                                      
set @ReferralTransferReferenceURL= (Select ReferralTransferReferenceUrl from CustomConfigurations)                                 
                                                                                                                        
set @clientDOB = (Select CONVERT(VARCHAR(10), DOB, 101) from Clients          
    where ClientId=@ClientID and IsNull(RecordDeleted,'N')='N')              
Exec csp_CalculateAge @ClientId, @clientAge out                                                            
                                                          
 --DECLARE @VersionDIAG AS int;          
  -- SELECT TOP 1 @VersionDIAG = a.CurrentDocumentVersionId                                                                       
  --FROM Documents a WHERE a.ClientId = @ClientId                                                                       
  --and a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(),101))                                                                       
  --and a.Status = 22                                                                                                        
  --and a.DocumentCodeId =1486                                                                       
  --and ISNULL(a.RecordDeleted,'N')<>'Y'                                                                       
  --ORDER BY a.EffectiveDate DESC,ModifiedDate DESC             
          
  --DECLARE @DocmentVersionId AS int;          
  DECLARE @Diagnosis VARCHAR(MAX)                                                
          
  SET @Diagnosis='AxisI-II'+ CHAR(9) + 'DSM Code'  + CHAR(9) + 'Type' + CHAR(9) + 'Version' + CHAR(13)                                                
                                                
  SELECT @Diagnosis = @Diagnosis + ISNULL(CAST(a.Axis AS VARCHAR),CHAR(9)) + CHAR(9)+ ISNULL(CAST(a.DSMCode AS VARCHAR),CHAR(9)) + CHAR(9)+ CHAR(9) + ISNULL(CAST(b.CodeName AS VARCHAR),CHAR(9)) + CHAR(9) + ISNULL(CAST(a.DSMVersion AS VARCHAR),' ') + CHAR
(13)--,a.DSMNumber                                                 
  FROM DiagnosesIAndII a                                         
  Join GlobalCodes b ON a.DiagnosisType=b.GlobalCodeid                                                    
  --WHERE DiagnosisId in (SELECT DiagnosisId FROM dbo.DiagnosesIAndII WHERE DocumentVersionId =@VersionDIAG  and ISNULL(RecordDeleted,'N')<>'Y')      
  WHERE DiagnosisId in (SELECT DiagnosisId FROM dbo.DiagnosesIAndII WHERE DocumentVersionId =@DocumentVersionId  and ISNULL(RecordDeleted,'N')<>'Y')                                                                   
  and ISNULL(a.RecordDeleted,'N')<>'Y'  and a.billable ='Y' ORDER BY Axis                       

   BEGIN TRY                                                               
                                                                                   
                                                                                   
    -----For CustomDocumentDiagnosticAssessments-----                                                                                                                                                                                                          
 
    
       
        
         
             
              
       SELECT DocumentVersionId                                            
      ,CreatedBy                                            
      ,CreatedDate                                            
      ,ModifiedBy                                            
      ,ModifiedDate                                            
      ,RecordDeleted                                            
      ,DeletedBy                                            
      ,DeletedDate                                            
      ,TypeOfAssessment                                            
      ,PresentingProblem                                            
      ,OptionsAlreadyTried                                            
      ,ClientHasLegalGuardian                                            
      ,LegalGuardianInfo                                            
      ,AbilitiesInterestsSkills                                            
      ,FamilyHistory                                            
      ,EthnicityCulturalBackground                                            
      ,SexualOrientationGenderExpression                                            
      ,GenderExpressionConsistent                                            
,SupportSystems                                            
      ,ClientStrengths                                            
      ,LivingSituation                                            
      ,IncludeHousingAssessment                                            
      ,ClientEmploymentNotApplicable                                            
      ,ClientEmploymentMilitaryHistory                                            
      ,IncludeVocationalAssessment                                            
      ,HighestEducationCompleted                                            
      ,EducationComment                                            
      ,LiteracyConcerns                                            
      ,LegalInvolvement                                            
      ,LegalInvolvementComment                                            
      ,HistoryEmotionalProblemsClient                                            
      ,ClientHasReceivedTreatment                                            
      ,ClientPriorTreatmentDiagnosis                                            
      ,PriorTreatmentCounseling                                            
      ,PriorTreatmentCounselingDates                                            
      ,PriorTreatmentCounselingComment                                            
      ,PriorTreatmentCaseManagement                                            
 ,PriorTreatmentCaseManagementDates                                            
      ,PriorTreatmentCaseManagementComment                                            
      ,PriorTreatmentOther                                            
      ,PriorTreatmentOtherDates                                            
      ,PriorTreatmentOtherComment                                            
      ,PriorTreatmentMedication                                        
      ,PriorTreatmentMedicationDates                                            
      ,PriorTreatmentMedicationComment                                            
      ,TypesOfMedicationResults                                     
      ,ClientResponsePastTreatment                                            
      ,AbuseNotApplicable                                          
      ,AbuseEmotionalVictim                                            
      ,AbuseEmotionalOffender                                            
      ,AbuseVerbalVictim                       
      ,AbuseVerbalOffender                                            
      ,AbusePhysicalVictim                                            
      ,AbusePhysicalOffender                            
      ,AbuseSexualVictim                                            
      ,AbuseSexualOffender                                            
      ,AbuseNeglectVictim                                        ,AbuseNeglectOffender                                            
      ,AbuseComment                                           
      ,FamilyPersonalHistoryLossTrauma                                            
      ,BiologicalMotherUseNoneReported                                            
      ,BiologicalMotherUseAlcohol                                            
      ,BiologicalMotherTobacco                                         
      ,BiologicalMotherUseOther                                            
      ,BiologicalMotherUseOtherType                                            
 ,ClientReportAlcoholTobaccoDrugUse                                            
      ,ClientReportDrugUseComment                                            
      ,FurtherSubstanceAssessmentIndicated                                            
      ,ClientHasHistorySubstanceUse                                            
      ,ClientHistorySubstanceUseComment                                            
      ,AlcoholUseWithin30Days                                            
      ,AlcoholUseCurrentFrequency                                            
      ,AlcoholUseWithinLifetime                                            
      ,AlcoholUsePastFrequency                                            
      ,AlcoholUseReceivedTreatment                                            
      ,CocaineUseWithin30Days                                            
      ,CocaineUseCurrentFrequency                                            
      ,CocaineUseWithinLifetime                                            
      ,CocaineUsePastFrequency                                            
      ,CocaineUseReceivedTreatment                                            
      ,SedtativeUseWithin30Days                                            
      ,SedtativeUseCurrentFrequency                                            
      ,SedtativeUseWithinLifetime                                            
      ,SedtativeUsePastFrequency                                            
      ,SedtativeUseReceivedTreatment                                            
      ,HallucinogenUseWithin30Days                                            
      ,HallucinogenUseCurrentFrequency                                            
      ,HallucinogenUseWithinLifetime                                            
      ,HallucinogenUsePastFrequency                                            
      ,HallucinogenUseReceivedTreatment                                            
      ,StimulantUseWithin30Days                                            
      ,StimulantUseCurrentFrequency                                            
      ,StimulantUseWithinLifetime                                            
      ,StimulantUsePastFrequency                                            
      ,StimulantUseReceivedTreatment                                            
      ,NarcoticUseWithin30Days                                            
      ,NarcoticUseCurrentFrequency                                            
      ,NarcoticUseWithinLifetime                                            
      ,NarcoticUsePastFrequency                                            
      ,NarcoticUseReceivedTreatment                                            
      ,MarijuanaUseWithin30Days                                            
      ,MarijuanaUseWithinLifetime                                     
      ,MarijuanaUseReceivedTreatment                                            
      ,InhalantsUseWithin30Days                        
      ,InhalantsUseCurrentFrequency                                            
      ,InhalantsUseWithinLifetime                                            
      ,InhalantsUsePastFrequency                                            
      ,InhalantsUseReceivedTreatment                                            
      ,OtherUseWithin30Days                                            
      ,OtherUseCurrentFrequency                                            
      ,OtherUseWithinLifetime                                            
      ,OtherUsePastFrequency                                            
      ,OtherUseReceivedTreatment                                            
      ,OtherUseType                                            
      ,DASTScore                                            
      ,MASTScore                                      
      ,ClientReferredSubstanceTreatment                                            
      ,ClientReferredSubstanceTreatmentWhere                                            
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
      ,PhysicalProblemsNoneReported                                            
      ,PhysicalProblemsComment                                            
      ,SpecialNeedsNoneReported                                            
      ,SpecialNeedsVisualImpairment                                            
      ,SpecialNeedsHearingImpairment                                            
      ,SpecialNeedsSpeechImpairment                                            
      ,SpecialNeedsOtherPhysicalImpairment                                       
      ,SpecialNeedsOtherPhysicalImpairmentComment                                            
      ,EducationSchoolName                                            
      ,EducationPreviousExpulsions                                            
      ,EducationClassification                                            
      ,EducationEmotionalDisturbance                                            
      ,EducationPreschoolersDisability             
      ,EducationTraumaticBrainInjury                                            
      ,EducationCognitiveDisability                                            
      ,EducationCurrent504                                            
      ,EducationOtherMajorHealthImpaired                                            
      ,EducationSpecificLearningDisability                                            
      ,EducationAutism                           
      ,EducationOtherMinorHealthImpaired                                            
      ,EdcuationClassificationComment                                            
      ,EducationPreviousRetentions                                            
      ,EducationClientIsHomeSchooled                                            
      ,EducationClientAttendedPreschool                                            
      ,EducationFrequencyOfAttendance                                            
      ,EducationReceivedServicesAsToddler                                            
      ,EducationReceivedServicesAsToddlerComment                                            
      ,ClientPreferencesForTreatment                                            
      ,ExternalSupportsReferrals                                            
      ,PrimaryClinicianTransfer                                            
 ,EAPMentalStatus      
      ,DiagnosticImpressionsSummary                                            
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
      ,MilestoneComment                                            
      ,SleepConcernSleepHabits                                            
      ,SleepTimeGoToBed                                            
      ,SleepTimeFallAsleep                                            
      ,SleepThroughNight                         
      ,SleepNightmares                                            
      ,SleepNightmaresHowOften                                            
      ,SleepTerrors                                            
      ,SleepTerrorsHowOften                                            
      ,SleepWalking                                            
      ,SleepWalkingHowOften                                            
      ,SleepTimeWakeUp        
      ,SleepWhere                                            
      ,SleepShareRoom                                            
      ,SleepShareRoomWithWhom                                            
      ,SleepTakeNaps                                         
      ,SleepTakeNapsHowOften                                            
      ,FamilyPrimaryCaregiver                                            
      ,FamilyPrimaryCaregiverType                                            
      ,FamilyPrimaryCaregiverEducation                                            
      ,FamilyPrimaryCaregiverAge                                            
      ,FamilyAdditionalCareGivers                                            
      ,FamilyEmploymentFirstCareGiver                                            
      ,FamilyEmploymentSecondCareGiver                                            
      ,FamilyStatusParentsRelationship                           
      ,FamilyNonCustodialContact                                            
      ,FamilyNonCustodialHowOften                                            
      ,FamilyNonCustodialTypeOfVisit                                            
      ,FamilyNonCustodialConsistency                                            
      ,FamilyNonCustodialLegalInvolvement                                            
      ,FamilyClientMovedResidences                                            
      ,FamilyClientMovedResidencesComment                                            
      ,FamilyClientHasSiblings                                            
      ,FamilyClientSiblingsComment                                            
      ,FamilyQualityRelationships                                            
      ,FamilySupportSystems                                            
      ,FamilyClientAbilitiesNA                                            
      ,FamilyClientAbilitiesComment                                            
      ,ChildHistoryLegalInvolvement                                            
      ,ChildHistoryLegalInvolvementComment                                            
      ,ChildHistoryBehaviorInFamily                                            
      ,ChildHistoryBehaviorInFamilyComment                                            
      ,ChildAbuseReported                                            
      ,ChildProtectiveServicesInvolved                            
 ,ChildProtectiveServicesReason                                            
      ,ChildProtectiveServicesCounty                                            
      ,ChildProtectiveServicesCaseWorker                                            
      ,ChildProtectiveServicesDates                                            
      ,ChildProtectiveServicesPlacements                                            
      ,ChildProtectiveServicesPlacementsComment                                            
      ,ChildHistoryOfViolence                                            
      ,ChildCTESComplete                       
      ,ChildCTESResults                                            
      ,ChildWitnessedSubstances                                            
      ,ChildWitnessedSubstancesComment                                            
      ,ChildBornFullTermPreTerm                                            
      ,ChildBornFullTermPreTermComment                                            
      ,ChildMotherUsedDrugsPregnancy                   
      ,ChildMotherUsedDrugsPregnancyComment                                            
      ,ChildConcernsNutrition                                            
      ,ChildConcernsNutritionComment                                            
      ,ChildConcernsAbilityUnderstand                                            
      ,ChildUsingWordsPhrases                                            
      ,ChildReceivedSpeechEval                                            
      ,ChildReceivedSpeechEvalComment                         
      ,ChildConcernMotorSkills                                            
      ,ChildGrossMotorSkillsProblem                                            
      ,ChildWalking14Months                                            
      ,ChildFineMotorSkillsProblem                                            
      ,ChildPickUpCheerios                                            
      ,ChildConcernSocialSkills                                            
      ,ChildConcernSocialSkillsComment                                            
      ,ChildToiletTraining                                            
      ,ChildToiletTrainingComment                                            
      ,ChildSensoryAversions                                            
      ,ChildSensoryAversionsComment                                            
      ,HousingHowStable                                            
      ,HousingAbleToStay                                            
      ,HousingEvictionsUnpaidUtilities                         
      ,HousingAbleGetUtilities                                            
      ,HousingAbleSignLease                                            
      ,HousingSpecializedProgram                                            
      ,HousingHasPets                                            
      ,VocationalUnemployed                                            
      ,VocationalInterestedWorking                                            
      ,VocationalInterestedWorkingComment                                            
      ,VocationalTimeSinceEmployed                                            
      ,VocationalTimeJobHeld                                            
      ,VocationalBarriersGainingEmployment                                            
      ,VocationalEmployed                                            
      ,VocationalTimeCurrentJob                                            
      ,VocationalBarriersMaintainingEmployment                                          
       ,InitialOrUpdate                                           
      ,ReasonForUpdate                                          
 ,UpdatePsychoSocial                                          
 ,UpdateSubstanceUse                                          
 ,UpdateRiskIndicators                                          
 ,UpdatePhysicalHealth                                          
 ,UpdateEducationHistory             
 ,UpdateDevelopmentalHistory                                          
 ,UpdateSleepHygiene                                          
 ,UpdateFamilyHistory                                          
 ,UpdateHousing                               
 ,UpdateVocational                                          
 ,TransferReceivingStaff                                          
 ,TransferReceivingProgram                                          
 ,TransferAssessedNeed                                          
 ,TransferClientParticipated                                          
 ,ClientResponsePastTreatmentNA                                          
 ,MarijuanaUseCurrentFrequency                                          
 ,MarijuanaUsePastFrequency                                          
 ,ChildHistoryOfViolenceComment                                          
 ,ChildPostPartumDepression                                                
 ,@clientAge as clientAge                            
 ,@ReferralTransferReferenceURL as ReferralTransferReferenceURL
 ,LevelofCare                                                     
       FROM CustomDocumentDiagnosticAssessments                                                                                        
      WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                          
                                   
   -----For DiagnosesIII-----                                                                                                           
   SELECT                                                                    
  DocumentVersionId                                                 
      ,CreatedBy                                                                                                          
      ,CreatedDate                                                                                                          
      ,ModifiedBy                                                                                                          
      ,ModifiedDate                                                                                                          
      ,RecordDeleted                                                                                                          
      ,DeletedDate                                                                                                          
      ,DeletedBy                                                                                                          
 ,Specification                                                                                                                                                  
   FROM DiagnosesIII                                                                                                                                                                         
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                               
                                                                                                                                                                                                 
   -----For DiagnosesIV-----                                                                             
   SELECT                                                                                                                                                                                                   
  DocumentVersionId                                                                   
  ,PrimarySupport                                                                                                                      
  ,SocialEnvironment                                                                       
  ,Educational                          
  ,Occupational                                                                                       
  ,Housing                                                                                                                                                                         
  ,Economic                                         
  ,HealthcareServices                                                                                                                                                                
  ,Legal                                                                                    
  ,Other                                                                  
  ,Specification
  ,DiagnosisAxisIVShowNone                                                                   
  ,CreatedBy                                                                                                                                           
  ,CreatedDate                                                                  
  ,ModifiedBy                                                                                         
  ,ModifiedDate                                                                                                                                                                                       
  ,RecordDeleted                                                                            
  ,DeletedDate                                                                                                                                                                                    
  ,DeletedBy                                                                                                  
   FROM DiagnosesIV                                                                                                
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                                                                               
  
    
     
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                                                                                             
   -----For DiagnosesV-----                                                                                            
 SELECT                                               
 DocumentVersionId                                   
 ,AxisV                                                                                                                                                                                                                                    
 ,CreatedBy                                                                                                                                       
 ,CreatedDate                                                                                               
 ,ModifiedBy                                                                                                                         
 ,ModifiedDate                                                                                                                                                                                                             
 ,RecordDeleted                                                                                     
 ,DeletedDate                                                                                                                                                         
 ,DeletedBy                                                                                                                
 FROM DiagnosesV                                                 
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                
                                   
                                                                                 
 -----For DiagnosesIAndII-----                                                                                                                                           
   SELECT                                                                                                                                                  
   D.DocumentVersionId                                   
  ,D.DiagnosisId                               
  ,D.Axis                                                                                
  ,D.DSMCode                                                                            
  ,D.DSMNumber                                                                                                                                                                                                            
  ,D.DiagnosisType                                                                                                                              
  ,D.RuleOut                                                                                                       
  ,D.Billable                                                                                                                                 
  ,D.Severity                                                                                                                                       
  ,D.DSMVersion                                                                                                        
  ,D.DiagnosisOrder                                                                                                   
  ,D.Specifier                                                                
  ,D.Remission                                           
  ,D.Source
  ,D.RowIdentifier                                                                                                     
  ,D.CreatedBy                                                                                                                                                                                            
  ,D.CreatedDate                                                                                    
  ,D.ModifiedBy                                                                                                                      
  ,D.ModifiedDate                                                         
  ,D.RecordDeleted                                                                 
  ,D.DeletedDate                                                                  
  ,D.DeletedBy                                                                                                                                   
,DSM.DSMDescription                                                                                              
  ,case D.RuleOut when 'Y' then 'R/O' else '' end as RuleOutText                                                
   FROM DiagnosesIAndII  D                                                                                       
  inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                                                
                       
                          
                            
                              
                                
  and DSM.DSMNumber = D.DSMNumber                                                                                                                                                                  
   WHERE                                                                                 
  DocumentVersionId=@DocumentVersionId   AND ISNULL(RecordDeleted,'N')='N'              
                                                  
  --DiagnosesIIICodes                                                    
 SELECT DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy   
 
    
      
        
          
            
              
                
                  
                    
 FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode                                                                           
 WHERE (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, 'N') = 'N')                                                                             
                                                          
 ---DiagnosesMaxOrder                                                                            
   SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,                                                                            
   RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII                                                                             
   where DocumentVersionId=@DocumentVersionId                                              
   and  IsNull(RecordDeleted,'N')='N' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate                                     
   order by DiagnosesMaxOrder desc                                                                  
                                                    
                                                    
  ---Table CustomDocumentAssessmentNeeds-----Added By jagdeep                                                  
  SELECT AssessmentNeedId                                                 
        ,DocumentVersionId                                              
        ,NeedName                                       
        ,NeedDescription                                      
        ,NeedStatus                                                 
        ,CreatedBy                                                  
        ,CreatedDate                                          
        ,ModifiedBy                                                  
        ,ModifiedDate                                                  
        ,RecordDeleted                                                  
        ,DeletedDate                                      
        ,DeletedBy                                                      
  FROM   CustomDocumentAssessmentNeeds                                          
  WHERE  DocumentVersionId=@DocumentVersionId                                                     
  AND    ISNULL(RecordDeleted,'N')='N'                                                             
                                        
    --CustomDocumentAssessmentReferrals                                      
     SELECT AssessmentReferralId                                       
      ,R.CreatedBy                                      
      ,R.CreatedDate                                      
      ,R.ModifiedBy                                      
      ,R.ModifiedDate                                      
      ,R.RecordDeleted                                      
      ,R.DeletedBy                                      
      ,R.DeletedDate                                      
      ,DocumentVersionId                                      
      ,ReceivingStaffId                                      
      ,ServiceRecommended                                      
      ,ServiceAmount                                      
      ,ServiceUnitType                                      
      ,ServiceFrequency                                      
      ,AssessedNeedForReferral                                      
    ,ClientParticipatedReferral                                
      ,AuthorizationCodeName as  ServiceRecommendedText                                 
      ,G.CodeName as ServiceFrequencyText                                
      ,S.LastName + ', ' +S.FirstName as ReceivingStaffIdText              
      ,Convert(Varchar,ServiceAmount) + ' ' + Unit.CodeName as ServiceUnitTypeText                                      
  FROM CustomDocumentAssessmentReferrals R                                
  inner join authorizationCodes A                                  
  on R.ServiceRecommended=A.AuthorizationCodeId                                 
  left join GlobalCodes G                                 
  on G.GlobalCodeID = R.ServiceFrequency                                
  left join GlobalCodes Unit                                
  on Unit.GlobalCodeID = R.ServiceUnitType                                
  left join Staff S                                
  On S.StaffId =R.ReceivingStaffId                                                                            
  where DocumentVersionId=@DocumentVersionId and IsNull(R.RecordDeleted,'N')='N'                                  
                     
  --CustomDocumentAssessmentTransferServices                                               
  SELECT AssessmentTransferServiceId                                    
      ,C.CreatedBy                                    
      ,C.CreatedDate                                    
      ,C.ModifiedBy                                    
      ,C.ModifiedDate                                    
      ,C.RecordDeleted                                    
      ,C.DeletedBy                                    
      ,C.DeletedDate                                    
      ,C.DocumentVersionId                                    
      ,C.TransferService                                   
      ,AuthorizationCodeName as  TransferServiceText                                  
  FROM CustomDocumentAssessmentTransferServices C                                   
  inner join authorizationCodes A                                  
  on C.TransferService=A.AuthorizationCodeId                    
  WHERE  DocumentVersionId=@DocumentVersionId                                   
  AND    ISNULL(C.RecordDeleted,'N')='N'                                   
                                
     --For Mental Status Tab --                          
     Select DocumentVersionId,                      
      CreatedBy                                            
      ,CreatedDate                                            
      ,ModifiedBy                                            
      ,ModifiedDate                                            
      ,RecordDeleted                                            
      ,DeletedBy                                            
      ,DeletedDate ,ConsciousnessNA                                            
      ,ConsciousnessAlert                                            
      ,ConsciousnessObtunded                                            
      ,ConsciousnessSomnolent                                    
      ,ConsciousnessOrientedX3                                           
      ,ConsciousnessAppearsUnderInfluence                                            
      ,ConsciousnessComment                                            
      ,EyeContactNA                                            
      ,EyeContactAppropriate                                          
      ,EyeContactStaring                                            
      ,EyeContactAvoidant                                            
      ,EyeContactComment                                        
      ,AppearanceNA                                            
      ,AppearanceClean                                            
      ,AppearanceNeatlyDressed                                            
      ,AppearanceAppropriate                                            
      ,AppearanceDisheveled                                   
      ,AppearanceMalodorous                                            
      ,AppearanceUnusual                                            
      ,AppearancePoorlyGroomed                                            
      ,AppearanceComment                                            
      ,AgeNA                                            
      ,AgeAppropriate                                            
      ,AgeOlder                                            
      ,AgeYounger                                            
      ,AgeComment                                            
      ,BehaviorNA                                            
      ,BehaviorPleasant                                            
      ,BehaviorGuarded                                            
      ,BehaviorAgitated                                            
      ,BehaviorImpulsive                                            
      ,BehaviorWithdrawn                                            
      ,BehaviorUncooperative                                            
      ,BehaviorAggressive                                            
      ,BehaviorComment                                            
      ,PsychomotorNA                                            
      ,PsychomotorNoAbnormalMovements                                            
      ,PsychomotorAgitation                                            
      ,PsychomotorAbnormalMovements                                            
      ,PsychomotorRetardation                                            
      ,PsychomotorComment                                            
      ,MoodNA                                            
      ,MoodEuthymic                                            
      ,MoodDysphoric                                            
      ,MoodIrritable                                            
      ,MoodDepressed                                            
      ,MoodExpansive                                            
      ,MoodAnxious                                            
      ,MoodElevated                       
      ,MoodComment                                            
      ,ThoughtContentNA                                            
      ,ThoughtContentWithinLimits                                            
      ,ThoughtContentExcessiveWorries                                            
      ,ThoughtContentOvervaluedIdeas                                            
      ,ThoughtContentRuminations                                            
      ,ThoughtContentPhobias                                            
      ,ThoughtContentComment                                            
      ,DelusionsNA                                            
      ,DelusionsNone                                            
      ,DelusionsBizarre                                            
      ,DelusionsReligious                                           ,DelusionsGrandiose                                            
      ,DelusionsParanoid                                            
      ,DelusionsComment                                            
      ,ThoughtProcessNA                                            
      ,ThoughtProcessLogical                                            
      ,ThoughtProcessCircumferential                                            
      ,ThoughtProcessFlightIdeas                                            
      ,ThoughtProcessIllogical                                            
      ,ThoughtProcessDerailment                                            
      ,ThoughtProcessTangential                                            
      ,ThoughtProcessSomatic                                            
      ,ThoughtProcessCircumstantial                                            
      ,ThoughtProcessComment                                
      ,HallucinationsNA                                            
      ,HallucinationsNone                                            
      ,HallucinationsAuditory                                            
      ,HallucinationsVisual                                            
      ,HallucinationsTactile                                            
      ,HallucinationsOlfactory                                            
      ,HallucinationsComment                                            
      ,IntellectNA                                            
      ,IntellectAverage                                            
      ,IntellectAboveAverage                                            
      ,IntellectBelowAverage                                          
      ,IntellectComment                                            
      ,SpeechNA                                            
      ,SpeechRate                                            
      ,SpeechTone                                            
      ,SpeechVolume                                            
      ,SpeechArticulation                 
      ,SpeechComment                                            
      ,AffectNA                                            
      ,AffectCongruent                                            
      ,AffectReactive                                        
      ,AffectIncongruent                                            
      ,AffectLabile                                            
      ,AffectComment                                            
      ,RangeNA                                            
      ,RangeBroad                                            
      ,RangeBlunted                                            
      ,RangeFlat                                            
      ,RangeFull                                            
      ,RangeConstricted                                            
      ,RangeComment                                            
      ,InsightNA                                            
      ,InsightExcellent                                            
      ,InsightGood                                            
      ,InsightFair                                            
      ,InsightPoor                                            
      ,InsightImpaired                                           
      ,InsightUnknown                                            
      ,InsightComment                                            
      ,JudgmentNA                                            
      ,JudgmentExcellent                                            
      ,JudgmentGood                                            
      ,JudgmentFair                                            
      ,JudgmentPoor                                            
      ,JudgmentImpaired                                            
      ,JudgmentUnknown                                            
      ,JudgmentComment                                            
      ,MemoryNA                                            
      ,MemoryShortTerm                                            
      ,MemoryLongTerm                          
      ,MemoryAttention                                            
      ,MemoryComment                        
       ,BodyHabitusNA                                               
  ,BodyHabitusAverage                                           
  ,BodyHabitusThin                                               
  ,BodyHabitusUnderweight                                        
  ,BodyHabitusOverweight                             
  ,BodyHabitusObese                                             
  ,BodyHabitusComment                               
      From CustomDocumentMentalStatuses                          
      WHERE DocumentVersionId=@DocumentVersionId  AND    ISNULL(RecordDeleted,'N')='N'                     
                     
   --exec  ssp_ScWebGetTreatmentPlanInitial  @DocumentVersionId,@StaffId                
     SELECT                 
    DocumentVersionId                
   ,CreatedBy                
      ,CreatedDate                
      ,ModifiedBy                
      ,ModifiedDate                
      ,RecordDeleted                
      ,DeletedDate                
      ,DeletedBy                
      --,CurrentDiagnosis                
      ,ClientStrengths                
      ,DischargeTransitionCriteria                
      ,ClientParticipatedAndIsInAgreement                
      ,ReasonForUpdate  
      ,ClientDidNotParticipate
     ,ClientDidNotParticpateComment
     ,ClientParticpatedPreviousDocumentation
      ,@Diagnosis as  CurrentDiagnosis                 
 FROM CustomTreatmentPlans                
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                
               
 --CustomTPNeed                
                 
 --SELECT                 
 --   NeedId                
 --     ,CreatedBy                
 --     ,CreatedDate                
 --     ,ModifiedBy                
 --     ,ModifiedDate                
 --     ,RecordDeleted                
 --     ,DeletedDate                
 --     ,DeletedBy                
 --     ,ClientId                
 --     ,NeedText                
 --FROM CustomTPNeeds                
 --WHERE ClientId=@ClientId AND ISNULL(RecordDeleted,'N')='N'                
              
 --CustomTPGoals                
                
 SELECT                 
    TPGoalId                
      ,CreatedBy                
      ,CreatedDate                
      ,ModifiedBy                
      ,ModifiedDate                
      ,RecordDeleted                
      ,DeletedDate                
      ,DeletedBy                
      ,DocumentVersionId                
      ,CAST( GoalNumber as integer) as GoalNumber                
      ,GoalText                
      ,TargeDate                
      ,Active                
      ,ProgressTowardsGoal                
      ,DeletionNotAllowed              
 FROM CustomTPGoals                
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                
        
        
---------------CustomTPNeeds          
  SELECT            
      NeedId            
      ,CreatedBy            
      ,CreatedDate            
      ,ModifiedBy            
      ,ModifiedDate            
      ,RecordDeleted            
      ,DeletedDate            
      ,DeletedBy            
      ,ClientId            
      ,NeedText          
      ,(Case when (select count(1) from CustomTPGoalNeeds where NeedId =CustomTPNeeds.NeedId and isnull(CustomTPGoalNeeds.RecordDeleted ,'N')<>'Y')>=1 then 'Y' else 'N' end) as LinkedInDb          
      ,'N' as LinkedInSession         
    FROM CustomTPNeeds            
    WHERE ClientId=@ClientId AND ISNULL(RecordDeleted,'N')='N'        
        
              
 --CustomTPGoalNeeds                
                
 SELECT                 
    CTGN.TPGoalNeeds                
      ,CTGN.CreatedBy                
      ,CTGN.CreatedDate                
      ,CTGN.ModifiedBy                
      ,CTGN.ModifiedDate                
      ,CTGN.RecordDeleted                
      ,CTGN.DeletedDate                
      ,CTGN.DeletedBy                
      ,CTGN.TPGoalId                
      ,CTGN.NeedId                
      ,CTGN.DateNeedAddedToPlan          
      ,CTN.NeedText as NeedText                
 FROM CustomTPGoalNeeds CTGN                 
 LEFT JOIN CustomTPGoals CTG on CTGN.TPGoalId=CTG.TPGoalId                
 LEFT JOIN CustomTPNeeds CTN on CTGN.NeedId=CTN.NeedId                
 WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTGN.RecordDeleted,'N')='N'  AND ISNULL(CTG.RecordDeleted,'N')='N'               
 AND ISNULL(CTN.RecordDeleted,'N')='N' 
 
--------------CustomTPObjectives                
                 
 SELECT                 
    CTO.TPObjectiveId                
      ,CTO.CreatedBy                
      ,CTO.CreatedDate                
      ,CTO.ModifiedBy                
      ,CTO.ModifiedDate                
      ,CTO.RecordDeleted                
      ,CTO.DeletedDate                
      ,CTO.DeletedBy                
      ,CTO.TPGoalId                
     ,CTO.ObjectiveNumber                
      ,CTO.ObjectiveText                
      ,CTO.TargetDate               
      ,CTO.DeletionNotAllowed              
      FROM CustomTPObjectives CTO                
      LEFT JOIN CustomTPGoals CTG on CTO.TPGoalId=CTG.TPGoalId
      WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTO.RecordDeleted,'N')='N'    AND ISNULL(CTG.RecordDeleted,'N')='N'                             
               
--------------CustomTPServices                
                      
      SELECT                 
    CTS.TPServiceId                
      ,CTS.CreatedBy                
      ,CTS.CreatedDate                
      ,CTS.ModifiedBy                
      ,CTS.ModifiedDate                
      ,CTS.RecordDeleted                
      ,CTS.DeletedDate                
      ,CTS.DeletedBy                
      ,CTS.TPGoalId                
      ,CTS.ServiceNumber                
      ,CTS.AuthorizationCodeId                
      ,CTS.Units                
      ,CTS.FrequencyType               
      ,CTS.DeletionNotAllowed               
      ,(select GC.codename from GlobalCodes GC where exists (select Unittype from AuthorizationCodes where   GC.GlobalCodeId=UnitType and AuthorizationCodeId=CTS.AuthorizationCodeId)) as  UnitType              
  FROM CustomTPServices CTS                
  LEFT JOIN CustomTPGoals CTG ON CTS.TPGoalId= CTG.TPGoalId               
  LEFT JOIN AuthorizationCodes AC ON CTS.AuthorizationCodeId=AC.AuthorizationCodeId 
  WHERE CTG.DocumentVersionId=@DocumentVersionId AND ISNULL(CTS.RecordDeleted,'N')='N'  AND ISNULL(CTG.RecordDeleted,'N')='N'               
  AND ISNULL(AC.RecordDeleted,'N')='N' AND ISNULL(AC.RecordDeleted,'N')='N'                
 /*                    
-----------CustomTPGlobalQuickGoals                
                
 SELECT                 
    TPQuickId                
      ,CreatedBy                
      ,CreatedDate                
      ,ModifiedBy                
      ,ModifiedDate                
      ,RecordDeleted                
      ,DeletedDate                
      ,DeletedBy                
      ,TPElementTitle                
      ,TPElementOrder                
      ,TPElementText                
 FROM CustomTPGlobalQuickGoals                
 WHERE ISNULL(RecordDeleted,'N')='N'                
                   
---------CustomTPQuickObjectives                
                      
      SELECT                 
  TPQuickId                
  ,CreatedBy                
  ,CreatedDate                
  ,ModifiedBy                
  ,ModifiedDate                
  ,RecordDeleted                
  ,DeletedDate                
  ,DeletedBy                
  ,StaffId                
  ,TPElementTitle                
  ,TPElementOrder                
  ,TPElementText                
   FROM CustomTPQuickObjectives                
   WHERE StaffId=@StaffId AND ISNULL(RecordDeleted,'N')='N'                
                
  --CustomTPGlobalQuickTransitionPlans              
  SELECT [TPQuickId]              
      ,[CreatedBy]              
      ,[CreatedDate]              
      ,[ModifiedBy]              
      ,[ModifiedDate]              
      ,[RecordDeleted]              
      ,[DeletedDate]              
      ,[DeletedBy]              
      ,[TPElementTitle]              
      ,[TPElementOrder]              
      ,[TPElementText]              
  FROM CustomTPGlobalQuickTransitionPlans              
  where ISNULL(RecordDeleted,'N')='N'  
  */
   SELECT     DocumentVersionId,
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
FROM         CustomDocumentCrisisInterventionNotes 
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'           
                                                                                                    
 END TRY                                                                           
                                                                                                                                                                      
 BEGIN CATCH                        
    
      
         
         
            
              
   DECLARE @Error varchar(8000)                                                                                                                                                                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                          
                                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_SCGetCustomDiagnosticAssessment')                                                                                                                  
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                        
                                                                                                                             
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                         
   RAISERROR (@Error  /* Message text*/,                                                    
     16  /*Severity*/,                                                     
              1  /*State*/   )                                                                                                                                         
 END CATCH                                                          
End
GO
/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentTransferForm]    Script Date: 04/29/2013 16:57:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentTransferForm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentTransferForm]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentTransferForm]  
(  
@DocumentVersionId  int   
)  
AS  
  
--select * from CustomDocumentReferrals  
  
--select * from Programs where ProgramId = 5  
  
--select * from globalcodes where category like '%rec%'  
  
Begin  
  
BEGIN TRY  
  
SELECT  SystemConfig.OrganizationName,  
  C.LastName + ', ' + C.FirstName as ClientName,  
  S2.LastName + ', ' + S2.Firstname as ReceivingStaff2,  
  S3.LastName + ', ' + S3.FirstName as ReferringStaff2,  
  Documents.ClientID,  
  P.ProgramName as ReceingProgram2,  
  GC3.CodeName as Status,  
  CONVERT(VARCHAR(10), DOCUMENTS.EffectiveDate, 101) as EffectiveDate,  
  
--  Modified by Jess 1/23/13  
--  S.LastName + ', ' + S.FirstName +' '+ ISNull(GC.CodeName,'') as ClinicianName,     
  S.LastName + ', ' + S.FirstName + ' ' + S.SigningSuffix as ClinicianName,     
  
  CASE DS.VerificationMode   
  WHEN 'P' THEN  
  ''  
  WHEN 'S' THEN   
  (SELECT PhysicalSignature FROM DocumentSignatures DS WHERE dv.DocumentId=DS.DocumentId)   
  END as [Signature],  
  LTRIM(RIGHT(CONVERT(VARCHAR(20), SE.DateOfService, 100), 7)) as BeginTime,  
     --convert(varchar(5),(SE.EndDateOfService-SE.DateOfService),108) +' '+ GC2.CodeName  as Duration,  
     convert(varchar(10),SE.Unit)+' '+GC2.CodeName  as Duration,  
     L.LocationName as Location,  
     DS.VerificationMode as VerificationStyle,  
     CDT.TransferStatus ,  
     CDT.TransferringStaff,  
     CDT.AssessedNeedForTransfer,  
     CDT.ReceivingStaff,  
     CDT.ReceivingProgram,  
     CDT.ClientParticpatedWithTransfer,  
     CDT.TransferSentDate,  
     CDT.ReceivingAction,  
     CDT.ReceivingComment,  
     CDT.ReceivingActionDate,  
     GC4.Codename as Action,
     GC5.Codename as LevelofCare  
FROM CustomDocumentTransfers CDT  
join DocumentVersions as dv on dv.DocumentVersionId = CDT.DocumentVersionId  
join Documents ON  Documents.DocumentId = dv.DocumentId  
join Staff S on Documents.AuthorId= S.StaffId   
join Clients C on Documents.ClientId= C.ClientId   
left join Programs P on P.ProgramId = CDT.ReceivingProgram   
left join Staff S2 on S2.StaffId = CDT.ReceivingStaff  
left join Staff S3 on S3.StaffId = CDT.TransferringStaff   
--Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId -- Removed by Jess 1/23/13   
left join Services SE on Documents.ServiceId=SE.ServiceId   
left join GlobalCodes GC2 on SE.UnitType = GC2.GlobalCodeId    
left join DocumentSignatures DS on dv.DocumentId=DS.DocumentId   
left join Locations L on SE.LocationId=L.LocationId  
left join GlobalCodes GC3 on GC3.GlobalCodeId = CDT.TransferStatus   
left join GlobalCodes GC4 on GC4.GlobalCodeId = CDT.ReceivingAction  
left join GlobalCodes GC5 on GC5.GlobalCodeId = CDT.LevelofCare  
 
Cross Join SystemConfigurations as SystemConfig  
where CDT.DocumentVersionId=@DocumentVersionId   
and isnull(Documents.RecordDeleted,'N')='N'  
and isnull(S.RecordDeleted,'N')='N'  
and isnull(C.RecordDeleted,'N')='N'  
--and isNull(GC.RecordDeleted,'N')='N'  -- Removed by Jess 1/23/13   
--and isNull(GC.RecordDeleted,'N')='N'  -- Removed by Jess 1/23/13   
and isNull(GC2.RecordDeleted,'N')='N'  
and isNull(DS.RecordDeleted,'N')='N'  
  
END TRY  
  
BEGIN CATCH  
  
   DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_RDLCustomDocumentPreventionServicesNotes')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
END CATCH  
End
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDischarges]    Script Date: 04/30/2013 19:14:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDischarges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[csp_RDLCustomDocumentDischarges]
	@DocumentVersionId int
/****************************************************************************/
 --Stored Procedure: dbo.csp_RDLCustomDocumentDischarges
 --Copyright: 2007-2012 Streamline Healthcare Solutions,  LLC
 --Creation Date: 2012.01.18

 --Purpose:  Main stored procedure for the Harbor discharge RDL.

 --Output Parameters: None

 --Return:   data tables:
 
 --Called By: SmartCare

 --Calls:

 --Data Modifications: None

 --Updates:
 --  Date			Author			Purpose
 --  2012.01.18		T. Remisoski	Created.
 --  2013.04.25     Aravinda halemane Modified:for Task # 3,Discharge Document, A Renewed Mind - Customizations

 /****************************************************************************/
as

select
	sc.OrganizationName,
	c.LastName + ', ' + c.FirstName as ClientName,
	c.ClientId,
	d.EffectiveDate,
	cdd.ClientAddress,
	cdd.HomePhone,
	cdd.ParentGuardianName,
	cdd.AdmissionDate,
	cdd.LastServiceDate,
	cdd.DischargeDate,
	cdd.DischargeTransitionCriteria,
	cdd.ServicesParticpated,
	cdd.MedicationsPrescribed,
	cdd.PresentingProblem,
	cdd.ReasonForDischarge,
	gcReason.CodeName as ReasonForDischargeCode,
	case cdd.ClientParticpation when '1' then 'Agree' when '2' then 'Disagree' when '3' then 'N/A Client dropped out of treatment' end as ClientParticpation,
	case cdd.ClientStatusLastContact when '1' then 'Stable' when '2' then 'Unstable' end as ClientStatusLastContact,
	cdd.ClientStatusComment,
	gcPref1.CodeName as ReferralPreference1,
	gcPref2.CodeName as ReferralPreference2,
	gcPref3.CodeName as ReferralPreference3,
	cdd.ReferralPreferenceOther,
	cdd.ReferralPreferenceComment,
	cdd.InvoluntaryTermination,
	cdd.ClientInformedRightAppeal,
	cdd.StaffMemberContact72Hours,
	cdd.DASTScore,
	cdd.MASTScore,
	dbo.GetGlobalCodeName(InitialLevelofCare) AS [InitialLevelofCare],
	dbo.GetGlobalCodeName(DischargeLevelofCare) AS [DischargeLevelofCare]
from CustomDocumentDischarges as cdd
join dbo.DocumentVersions as dv on dv.DocumentVersionId = cdd.DocumentVersionId
join dbo.Documents as d on d.DocumentId = dv.DocumentId
join dbo.Clients as c on c.ClientId = d.ClientId
cross join dbo.SystemConfigurations as sc
LEFT join dbo.GlobalCodes as gcReason on gcReason.GlobalCodeId = cdd.ReasonForDischargeCode
LEFT join dbo.GlobalCodes as gcPref1 on gcPref1.GlobalCodeId = cdd.ReferralPreference1
LEFT join dbo.GlobalCodes as gcPref2 on gcPref2.GlobalCodeId = cdd.ReferralPreference2
LEFT join dbo.GlobalCodes as gcPref3 on gcPref3.GlobalCodeId = cdd.ReferralPreference3

where cdd.DocumentVersionId = @DocumentVersionId
GO
/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDiagnosticAssessments]    Script Date: 04/29/2013 16:57:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentDiagnosticAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentDiagnosticAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[csp_RDLCustomDocumentDiagnosticAssessments]                 
(                                                                                                                                                                                                  
  @DocumentVersionId int                                                                                                                                                                        
)                                                                                                                                                                                                  
As            
--[csp_RDLCustomDocumentDiagnosticAssessments] 837021                                                                                                                                         
/*********************************************************************/                                                                                                                                                
/* Stored Procedure: dbo.[csp_RDLCustomDocumentDiagnosticAssessments]                */                                                                                                                                                
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                                
/* Creation Date:  20 June,2011                                        */                                                                                                                                                
/* Created By  Jagdeep Hundal                                                                  */                                                                                                                                                
/* Purpose:  Get Data for CustomDocumentDiagnosticAssessments Pages */                                                                                                                                              
/*                                                                   */                                                                                                                                              
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                              
/*                                                                   */                                                                                                                                                
/* Output Parameters:   None                   */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Return:  0=success, otherwise an error number                     */                                                                                                                                                
/*                                                                   */                                                                                                                                                
/* Called By:                                                        */                                                                                                                                                
/*                                                                   */                            
/* Calls:             */         
/* */                  
/* Data Modifications:   */                                               
/* */                                                                                               
/* Updates:               */                                                            
/* Date     Author            Purpose                             */                                                                   
                                                                                                                 
/*********************************************************************/                                                                                                                                           
BEGIN
                                                                                                             
BEGIN TRY                               
BEGIN          
  
                                       
SELECT CDDA.[DocumentVersionId]         
      ,(Select OrganizationName from SystemConfigurations) as OrganizationName                                
      ,Documents.ClientId                                
      ,Clients.LastName + ', ' + Clients.FirstName as ClientName  
      ,dbo.GetAge(Clients.DOB, Documents.EffectiveDate) as ClientAge        
      ,Documents.EffectiveDate                                    
      ,CDDA.[TypeOfAssessment]    
      ,CDDA.[InitialOrUpdate]    
      ,CDDA.[ReasonForUpdate]    
      ,CDDA.[UpdatePsychoSocial]    
      ,CDDA.[UpdateSubstanceUse]    
      ,CDDA.[UpdateRiskIndicators]    
      ,CDDA.[UpdatePhysicalHealth]    
      ,CDDA.[UpdateEducationHistory]    
      ,CDDA.[UpdateDevelopmentalHistory]    
      ,CDDA.[UpdateSleepHygiene]    
      ,CDDA.[UpdateFamilyHistory]    
      ,CDDA.[UpdateHousing]    
      ,CDDA.[UpdateVocational]    
      ,CDDA.[TransferReceivingStaff]    
      ,CDDA.[TransferReceivingProgram]    
      ,CDDA.[TransferAssessedNeed]    
      ,CDDA.[TransferClientParticipated]    
      ,CDDA.[PresentingProblem]    
      ,CDDA.[OptionsAlreadyTried]    
      ,CDDA.[ClientHasLegalGuardian]    
      ,CDDA.[LegalGuardianInfo]    
      ,CDDA.[AbilitiesInterestsSkills]    
      ,CDDA.[FamilyHistory]    
      ,CDDA.[EthnicityCulturalBackground]    
      ,CDDA.[SexualOrientationGenderExpression]    
      ,CDDA.[GenderExpressionConsistent]    
      ,CDDA.[SupportSystems]    
      ,CDDA.[ClientStrengths]    
      ,CDDA.[LivingSituation]    
      ,CDDA.[IncludeHousingAssessment]    
      ,CDDA.[ClientEmploymentNotApplicable]    
      ,CDDA.[ClientEmploymentMilitaryHistory]    
      ,CDDA.[IncludeVocationalAssessment]    
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[HighestEducationCompleted]) as HighestEducationCompleted  
      ,CDDA.[EducationComment]    
      ,CDDA.[LiteracyConcerns]    
      ,CDDA.[LegalInvolvement]    
      ,CDDA.[LegalInvolvementComment]    
      ,CDDA.[HistoryEmotionalProblemsClient]    
      ,CDDA.[ClientHasReceivedTreatment]    
      ,CDDA.[ClientPriorTreatmentDiagnosis]    
      ,CDDA.[PriorTreatmentCounseling]    
      ,CDDA.[PriorTreatmentCounselingDates]    
      ,CDDA.[PriorTreatmentCounselingComment]    
      ,CDDA.[PriorTreatmentCaseManagement]    
      ,CDDA.[PriorTreatmentCaseManagementDates]    
      ,CDDA.[PriorTreatmentCaseManagementComment]    
      ,CDDA.[PriorTreatmentOther]    
      ,CDDA.[PriorTreatmentOtherDates]    
      ,CDDA.[PriorTreatmentOtherComment]    
      ,CDDA.[PriorTreatmentMedication]    
      ,CDDA.[PriorTreatmentMedicationDates]    
      ,CDDA.[PriorTreatmentMedicationComment]    
      ,CDDA.[TypesOfMedicationResults]    
      ,CDDA.[ClientResponsePastTreatment]    
      ,CDDA.[ClientResponsePastTreatmentNA]    
      ,CDDA.[AbuseNotApplicable]    
      ,CDDA.[AbuseEmotionalVictim]    
      ,CDDA.[AbuseEmotionalOffender]    
      ,CDDA.[AbuseVerbalVictim]    
      ,CDDA.[AbuseVerbalOffender]    
      ,CDDA.[AbusePhysicalVictim]    
      ,CDDA.[AbusePhysicalOffender]    
      ,CDDA.[AbuseSexualVictim]    
      ,CDDA.[AbuseSexualOffender]    
      ,CDDA.[AbuseNeglectVictim]    
      ,CDDA.[AbuseNeglectOffender]    
      ,CDDA.[AbuseComment]    
      ,CDDA.[FamilyPersonalHistoryLossTrauma]    
      ,CDDA.[BiologicalMotherUseNoneReported]    
      ,CDDA.[BiologicalMotherUseAlcohol]    
      ,CDDA.[BiologicalMotherTobacco]    
      ,CDDA.[BiologicalMotherUseOther]    
      ,CDDA.[BiologicalMotherUseOtherType]    
      ,CDDA.[ClientReportAlcoholTobaccoDrugUse]    
      ,CDDA.[ClientReportDrugUseComment]    
      ,CDDA.[FurtherSubstanceAssessmentIndicated]    
      ,CDDA.[ClientHasHistorySubstanceUse]    
      ,CDDA.[ClientHistorySubstanceUseComment]    
      ,CDDA.[AlcoholUseWithin30Days]    
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[AlcoholUseCurrentFrequency]) as AlcoholUseCurrentFrequency  
      ,CDDA.[AlcoholUseWithinLifetime]    
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[AlcoholUsePastFrequency]) as AlcoholUsePastFrequency  
      ,CDDA.[AlcoholUseReceivedTreatment]    
      ,CDDA.[CocaineUseWithin30Days]   
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[CocaineUseCurrentFrequency]) as CocaineUseCurrentFrequency   
      ,CDDA.[CocaineUseWithinLifetime]   
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[CocaineUsePastFrequency]) as CocaineUsePastFrequency   
      ,CDDA.[CocaineUseReceivedTreatment]    
      ,CDDA.[SedtativeUseWithin30Days]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[SedtativeUseCurrentFrequency]) as SedtativeUseCurrentFrequency   
      ,CDDA.[SedtativeUseWithinLifetime]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[SedtativeUsePastFrequency]) as SedtativeUsePastFrequency    
      ,CDDA.[SedtativeUseReceivedTreatment]    
      ,CDDA.[HallucinogenUseWithin30Days]    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[HallucinogenUseCurrentFrequency]) as HallucinogenUseCurrentFrequency   
      ,CDDA.[HallucinogenUseWithinLifetime]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[HallucinogenUsePastFrequency]) as HallucinogenUsePastFrequency    
      ,CDDA.[HallucinogenUseReceivedTreatment]    
      ,CDDA.[StimulantUseWithin30Days]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[StimulantUseCurrentFrequency]) as StimulantUseCurrentFrequency    
      ,CDDA.[StimulantUseWithinLifetime]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[StimulantUsePastFrequency]) as StimulantUsePastFrequency    
      ,CDDA.[StimulantUseReceivedTreatment]    
      ,CDDA.[NarcoticUseWithin30Days]    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[NarcoticUseCurrentFrequency]) as NarcoticUseCurrentFrequency   
      ,CDDA.[NarcoticUseWithinLifetime]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[NarcoticUsePastFrequency]) as NarcoticUsePastFrequency    
      ,CDDA.[NarcoticUseReceivedTreatment]   
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[MarijuanaUseCurrentFrequency]) as MarijuanaUseCurrentFrequency    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[MarijuanaUsePastFrequency]) as MarijuanaUsePastFrequency   
      ,CDDA.[MarijuanaUseWithin30Days]    
      ,CDDA.[MarijuanaUseWithinLifetime]    
      ,CDDA.[MarijuanaUseReceivedTreatment]    
      ,CDDA.[InhalantsUseWithin30Days]    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[InhalantsUseCurrentFrequency]) as InhalantsUseCurrentFrequency   
      ,CDDA.[InhalantsUseWithinLifetime]    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[InhalantsUsePastFrequency]) as InhalantsUsePastFrequency   
      ,CDDA.[InhalantsUseReceivedTreatment]    
      ,CDDA.[OtherUseWithin30Days]    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[OtherUseCurrentFrequency]) as OtherUseCurrentFrequency   
      ,CDDA.[OtherUseWithinLifetime]    
       ,dbo.csf_GetGlobalCodeNameById(CDDA.[OtherUsePastFrequency]) as OtherUsePastFrequency   
      ,CDDA.[OtherUseReceivedTreatment]    
      ,CDDA.[OtherUseType]    
      ,CDDA.[DASTScore]    
      ,CDDA.[MASTScore]    
      ,CDDA.[ClientReferredSubstanceTreatment]    
      ,CDDA.[ClientReferredSubstanceTreatmentWhere]    
      ,CDDA.[RiskSuicideIdeation]    
      ,CDDA.[RiskSuicideIdeationComment]    
      ,CDDA.[RiskSuicideIntent]    
      ,CDDA.[RiskSuicideIntentComment]    
      ,CDDA.[RiskSuicidePriorAttempts]    
      ,CDDA.[RiskSuicidePriorAttemptsComment]    
      ,CDDA.[RiskPriorHospitalization]    
      ,CDDA.[RiskPriorHospitalizationComment]    
      ,CDDA.[RiskPhysicalAggressionSelf]    
      ,CDDA.[RiskPhysicalAggressionSelfComment]    
      ,CDDA.[RiskVerbalAggressionOthers]    
      ,CDDA.[RiskVerbalAggressionOthersComment]    
      ,CDDA.[RiskPhysicalAggressionObjects]    
      ,CDDA.[RiskPhysicalAggressionObjectsComment]    
      ,CDDA.[RiskPhysicalAggressionPeople]    
      ,CDDA.[RiskPhysicalAggressionPeopleComment]    
      ,CDDA.[RiskReportRiskTaking]    
      ,CDDA.[RiskReportRiskTakingComment]    
      ,CDDA.[RiskThreatClientPersonalSafety]    
      ,CDDA.[RiskThreatClientPersonalSafetyComment]    
      ,CDDA.[RiskPhoneNumbersProvided]    
      ,CDDA.[RiskCurrentRiskIdentified]    
      ,CDDA.[RiskTriggersDangerousBehaviors]    
      ,CDDA.[RiskCopingSkills]    
      ,CDDA.[RiskInterventionsPersonalSafetyNA]    
      ,CDDA.[RiskInterventionsPersonalSafety]    
      ,CDDA.[RiskInterventionsPublicSafetyNA]    
      ,CDDA.[RiskInterventionsPublicSafety]    
      ,CDDA.[PhysicalProblemsNoneReported]    
      ,CDDA.[PhysicalProblemsComment]    
      ,CDDA.[SpecialNeedsNoneReported]    
      ,CDDA.[SpecialNeedsVisualImpairment]    
      ,CDDA.[SpecialNeedsHearingImpairment]    
      ,CDDA.[SpecialNeedsSpeechImpairment]    
      ,CDDA.[SpecialNeedsOtherPhysicalImpairment]    
      ,CDDA.[SpecialNeedsOtherPhysicalImpairmentComment]    
      ,CDDA.[EducationSchoolName]    
      ,CDDA.[EducationPreviousExpulsions]    
      ,CDDA.[EducationClassification]    
      ,CDDA.[EducationEmotionalDisturbance]    
      ,CDDA.[EducationPreschoolersDisability]    
      ,CDDA.[EducationTraumaticBrainInjury]    
      ,CDDA.[EducationCognitiveDisability]    
      ,CDDA.[EducationCurrent504]    
      ,CDDA.[EducationOtherMajorHealthImpaired]    
      ,CDDA.[EducationSpecificLearningDisability]    
      ,CDDA.[EducationAutism]    
      ,CDDA.[EducationOtherMinorHealthImpaired]    
      ,CDDA.[EdcuationClassificationComment]    
      ,CDDA.[EducationPreviousRetentions]    
      ,CDDA.[EducationClientIsHomeSchooled]    
      ,CDDA.[EducationClientAttendedPreschool]    
      ,CDDA.[EducationFrequencyOfAttendance]    
      ,CDDA.[EducationReceivedServicesAsToddler]    
      ,CDDA.[EducationReceivedServicesAsToddlerComment]    
      ,CDDA.[ClientPreferencesForTreatment]    
      ,CDDA.[ExternalSupportsReferrals]    
      ,CDDA.[PrimaryClinicianTransfer]    
      ,CDDA.[EAPMentalStatus]    
      ,CDDA.[DiagnosticImpressionsSummary]    
      ,CDDA.[MilestoneUnderstandingLanguage]    
      ,CDDA.[MilestoneVocabulary]    
      ,CDDA.[MilestoneFineMotor]    
      ,CDDA.[MilestoneGrossMotor]    
      ,CDDA.[MilestoneIntellectual]    
      ,CDDA.[MilestoneMakingFriends]    
      ,CDDA.[MilestoneSharingInterests]    
      ,CDDA.[MilestoneEyeContact]    
      ,CDDA.[MilestoneToiletTraining]    
      ,CDDA.[MilestoneCopingSkills]    
      ,CDDA.[MilestoneComment]    
      ,CDDA.[SleepConcernSleepHabits]    
      ,CDDA.[SleepTimeGoToBed]    
      ,CDDA.[SleepTimeFallAsleep]    
      ,CDDA.[SleepThroughNight]    
      ,CDDA.[SleepNightmares]    
      ,CDDA.[SleepNightmaresHowOften]    
      ,CDDA.[SleepTerrors]    
      ,CDDA.[SleepTerrorsHowOften]    
      ,CDDA.[SleepWalking]    
      ,CDDA.[SleepWalkingHowOften]    
      ,CDDA.[SleepTimeWakeUp]    
      ,CDDA.[SleepShareRoom]    
      ,CDDA.[SleepShareRoomWithWhom]    
      ,CDDA.[SleepTakeNaps]    
      ,CDDA.[SleepTakeNapsHowOften]    
      ,CDDA.[FamilyPrimaryCaregiver]    
      ,CDDA.[FamilyPrimaryCaregiverType]    
      ,CDDA.[FamilyPrimaryCaregiverEducation]    
      ,CDDA.[FamilyPrimaryCaregiverAge]    
      ,CDDA.[FamilyAdditionalCareGivers]          ,dbo.csf_GetGlobalCodeNameById(CDDA.[FamilyEmploymentFirstCareGiver]) as FamilyEmploymentFirstCareGiver   
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[FamilyEmploymentSecondCareGiver]) as FamilyEmploymentSecondCareGiver   
      ,CDDA.[FamilyStatusParentsRelationship]    
      ,CDDA.[FamilyNonCustodialContact]    
      ,CDDA.[FamilyNonCustodialHowOften]    
      ,CDDA.[FamilyNonCustodialTypeOfVisit]    
      ,CDDA.[FamilyNonCustodialConsistency]    
      ,CDDA.[FamilyNonCustodialLegalInvolvement]    
      ,CDDA.[FamilyClientMovedResidences]    
      ,CDDA.[FamilyClientMovedResidencesComment]    
      ,CDDA.[FamilyClientHasSiblings]    
      ,CDDA.[FamilyClientSiblingsComment]    
      ,CDDA.[FamilyQualityRelationships]    
      ,CDDA.[FamilySupportSystems]    
      ,CDDA.[FamilyClientAbilitiesNA]    
      ,CDDA.[FamilyClientAbilitiesComment]    
      ,CDDA.[ChildHistoryLegalInvolvement]    
      ,CDDA.[ChildHistoryLegalInvolvementComment]    
      ,CDDA.[ChildHistoryBehaviorInFamily]    
      ,CDDA.[ChildHistoryBehaviorInFamilyComment]    
      ,CDDA.[ChildAbuseReported]    
      ,CDDA.[ChildProtectiveServicesInvolved]    
      ,CDDA.[ChildProtectiveServicesReason]    
      ,CDDA.[ChildProtectiveServicesCounty]    
      ,CDDA.[ChildProtectiveServicesCaseWorker]    
      ,CDDA.[ChildProtectiveServicesDates]    
      ,CDDA.[ChildProtectiveServicesPlacements]    
      ,CDDA.[ChildProtectiveServicesPlacementsComment]    
      ,CDDA.[ChildHistoryOfViolence]    
      ,CDDA.[ChildHistoryOfViolenceComment]    
      ,CDDA.[ChildCTESComplete]    
      ,CDDA.[ChildCTESResults]    
      ,CDDA.[ChildWitnessedSubstances]    
      ,CDDA.[ChildWitnessedSubstancesComment]    
      ,CDDA.[ChildBornFullTermPreTerm]    
      ,CDDA.[ChildBornFullTermPreTermComment]    
      ,CDDA.[ChildPostPartumDepression]    
      ,CDDA.[ChildMotherUsedDrugsPregnancy]    
      ,CDDA.[ChildMotherUsedDrugsPregnancyComment]    
      ,CDDA.[ChildConcernsNutrition]    
      ,CDDA.[ChildConcernsNutritionComment]    
      ,CDDA.[ChildConcernsAbilityUnderstand]    
      ,CDDA.[ChildUsingWordsPhrases]    
      ,CDDA.[ChildReceivedSpeechEval]    
      ,CDDA.[ChildReceivedSpeechEvalComment]    
      ,CDDA.[ChildConcernMotorSkills]    
      ,CDDA.[ChildGrossMotorSkillsProblem]    
      ,CDDA.[ChildWalking14Months]    
      ,CDDA.[ChildFineMotorSkillsProblem]    
      ,CDDA.[ChildPickUpCheerios]    
      ,CDDA.[ChildConcernSocialSkills]    
      ,CDDA.[ChildConcernSocialSkillsComment]    
      ,CDDA.[ChildToiletTraining]    
      ,CDDA.[ChildToiletTrainingComment]    
      ,CDDA.[ChildSensoryAversions]    
      ,CDDA.[ChildSensoryAversionsComment]    
      ,CDDA.[HousingHowStable]    
      ,CDDA.[HousingAbleToStay]    
      ,CDDA.[HousingEvictionsUnpaidUtilities]    
      ,CDDA.[HousingAbleGetUtilities]    
      ,CDDA.[HousingAbleSignLease]    
      ,CDDA.[HousingSpecializedProgram]    
      ,CDDA.[HousingHasPets]    
      ,CDDA.[VocationalUnemployed]    
      ,CDDA.[VocationalInterestedWorking]    
      ,CDDA.[VocationalInterestedWorkingComment]    
      ,CDDA.[VocationalTimeSinceEmployed]    
      ,CDDA.[VocationalTimeJobHeld]    
      ,CDDA.[VocationalBarriersGainingEmployment]    
      ,CDDA.[VocationalEmployed]    
      ,CDDA.[VocationalTimeCurrentJob]    
      ,CDDA.[VocationalBarriersMaintainingEmployment]    
      ,dbo.csf_GetGlobalCodeNameById(CDDA.[LevelofCare]) as LevelofCare     
          
                                   
                               
INTO  #CustomDocumentDiagnosticAssessments                                
From Documents                  
join DocumentVersions  on Documents.DocumentId = DocumentVersions.DocumentId               
Left Join CustomDocumentDiagnosticAssessments as CDDA on CDDA.DocumentVersionId = DocumentVersions.DocumentVersionId             
            
Join Clients on Clients.ClientId = Documents.ClientId                                  
                                
Where CDDA.DocumentVersionId =@DocumentVersionId           
and ISNULL(Documents.RecordDeleted,'N')='N'                
and ISNULL(DocumentVersions.RecordDeleted,'N')='N'                             
and ISNULL(CDDA.RecordDeleted,'N')='N'                               
and ISNULL(Clients.RecordDeleted,'N')='N'         
    
    
    
    
--CustomDocumentMentalStatuses    
   Select [DocumentVersionId]       
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
      ,CDMS.[ThoughtContentExcessiveWorries]        ,CDMS.[ThoughtContentOvervaluedIdeas]    
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
    
  into #CustomDocumentMentalStatuses                            
  FROM CustomDocumentMentalStatuses as CDMS                                                                  
  WHERE CDMS.DocumentVersionId = @DocumentVersionId and ISNULL(RecordDeleted, 'N') = 'N'         
    
    
    
                          
                                      
SELECT CDDA.DocumentVersionId                              
   ,ClientName         
   ,ClientId  
   ,ClientAge        
   ,OrganizationName                              
   ,EffectiveDate                                  
      ,CDDA.[TypeOfAssessment]    
      ,CDDA.[InitialOrUpdate]    
      ,CDDA.[ReasonForUpdate]    
      ,CDDA.[UpdatePsychoSocial]    
      ,CDDA.[UpdateSubstanceUse]    
      ,CDDA.[UpdateRiskIndicators]    
      ,CDDA.[UpdatePhysicalHealth]    
      ,CDDA.[UpdateEducationHistory]    
      ,CDDA.[UpdateDevelopmentalHistory]    
      ,CDDA.[UpdateSleepHygiene]    
      ,CDDA.[UpdateFamilyHistory]    
      ,CDDA.[UpdateHousing]    
      ,CDDA.[UpdateVocational]    
      ,CDDA.[TransferReceivingStaff]    
      ,CDDA.[TransferReceivingProgram]    
      ,CDDA.[TransferAssessedNeed]    
      ,CDDA.[TransferClientParticipated]    
      ,CDDA.[PresentingProblem]    
      ,CDDA.[OptionsAlreadyTried]    
      ,CDDA.[ClientHasLegalGuardian]    
      ,CDDA.[LegalGuardianInfo]    
      ,CDDA.[AbilitiesInterestsSkills]    
      ,CDDA.[FamilyHistory]    
      ,CDDA.[EthnicityCulturalBackground]    
      ,CDDA.[SexualOrientationGenderExpression]    
      ,CDDA.[GenderExpressionConsistent]    
      ,CDDA.[SupportSystems]    
      ,CDDA.[ClientStrengths]    
      ,CDDA.[LivingSituation]    
      ,CDDA.[IncludeHousingAssessment]    
      ,CDDA.[ClientEmploymentNotApplicable]    
      ,CDDA.[ClientEmploymentMilitaryHistory]    
      ,CDDA.[IncludeVocationalAssessment]    
      ,CDDA.[HighestEducationCompleted]    
      ,CDDA.[EducationComment]    
      ,CDDA.[LiteracyConcerns]    
      ,CDDA.[LegalInvolvement]    
      ,CDDA.[LegalInvolvementComment]    
      ,CDDA.[HistoryEmotionalProblemsClient]    
      ,CDDA.[ClientHasReceivedTreatment]    
      ,CDDA.[ClientPriorTreatmentDiagnosis]    
      ,CDDA.[PriorTreatmentCounseling]    
      ,CDDA.[PriorTreatmentCounselingDates]    
      ,CDDA.[PriorTreatmentCounselingComment]    
      ,CDDA.[PriorTreatmentCaseManagement]    
      ,CDDA.[PriorTreatmentCaseManagementDates]    
      ,CDDA.[PriorTreatmentCaseManagementComment]    
      ,CDDA.[PriorTreatmentOther]    
      ,CDDA.[PriorTreatmentOtherDates]    
      ,CDDA.[PriorTreatmentOtherComment]    
      ,CDDA.[PriorTreatmentMedication]    
      ,CDDA.[PriorTreatmentMedicationDates]    
      ,CDDA.[PriorTreatmentMedicationComment]    
      ,CDDA.[TypesOfMedicationResults]    
      ,CDDA.[ClientResponsePastTreatment]    
      ,CDDA.[ClientResponsePastTreatmentNA]    
      ,CDDA.[AbuseNotApplicable]    
      ,CDDA.[AbuseEmotionalVictim]    
      ,CDDA.[AbuseEmotionalOffender]    
      ,CDDA.[AbuseVerbalVictim]    
      ,CDDA.[AbuseVerbalOffender]    
      ,CDDA.[AbusePhysicalVictim]    
      ,CDDA.[AbusePhysicalOffender]    
      ,CDDA.[AbuseSexualVictim]    
      ,CDDA.[AbuseSexualOffender]    
      ,CDDA.[AbuseNeglectVictim]    
      ,CDDA.[AbuseNeglectOffender]    
      ,CDDA.[AbuseComment]    
      ,CDDA.[FamilyPersonalHistoryLossTrauma]    
      ,CDDA.[BiologicalMotherUseNoneReported]    
      ,CDDA.[BiologicalMotherUseAlcohol]    
      ,CDDA.[BiologicalMotherTobacco]    
      ,CDDA.[BiologicalMotherUseOther]    
      ,CDDA.[BiologicalMotherUseOtherType]    
      ,CDDA.[ClientReportAlcoholTobaccoDrugUse]    
      ,CDDA.[ClientReportDrugUseComment]    
      ,CDDA.[FurtherSubstanceAssessmentIndicated]    
      ,CDDA.[ClientHasHistorySubstanceUse]    
      ,CDDA.[ClientHistorySubstanceUseComment]    
      ,CDDA.[AlcoholUseWithin30Days]    
      ,CDDA.[AlcoholUseCurrentFrequency]    
      ,CDDA.[AlcoholUseWithinLifetime]    
      ,CDDA.[AlcoholUsePastFrequency]    
      ,CDDA.[AlcoholUseReceivedTreatment]    
      ,CDDA.[CocaineUseWithin30Days]    
      ,CDDA.[CocaineUseCurrentFrequency]    
      ,CDDA.[CocaineUseWithinLifetime]    
      ,CDDA.[CocaineUsePastFrequency]    
      ,CDDA.[CocaineUseReceivedTreatment]    
      ,CDDA.[SedtativeUseWithin30Days]    
      ,CDDA.[SedtativeUseCurrentFrequency]    
      ,CDDA.[SedtativeUseWithinLifetime]    
      ,CDDA.[SedtativeUsePastFrequency]    
      ,CDDA.[SedtativeUseReceivedTreatment]    
      ,CDDA.[HallucinogenUseWithin30Days]    
      ,CDDA.[HallucinogenUseCurrentFrequency]    
      ,CDDA.[HallucinogenUseWithinLifetime]    
      ,CDDA.[HallucinogenUsePastFrequency]    
      ,CDDA.[HallucinogenUseReceivedTreatment]    
      ,CDDA.[StimulantUseWithin30Days]    
      ,CDDA.[StimulantUseCurrentFrequency]    
      ,CDDA.[StimulantUseWithinLifetime]    
      ,CDDA.[StimulantUsePastFrequency]    
      ,CDDA.[StimulantUseReceivedTreatment]    
      ,CDDA.[NarcoticUseWithin30Days]    
      ,CDDA.[NarcoticUseCurrentFrequency]    
      ,CDDA.[NarcoticUseWithinLifetime]    
      ,CDDA.[NarcoticUsePastFrequency]    
      ,CDDA.[NarcoticUseReceivedTreatment]    
      ,CDDA.[MarijuanaUseCurrentFrequency]    
      ,CDDA.[MarijuanaUsePastFrequency]    
      ,CDDA.[MarijuanaUseWithin30Days]    
      ,CDDA.[MarijuanaUseWithinLifetime]    
      ,CDDA.[MarijuanaUseReceivedTreatment]    
      ,CDDA.[InhalantsUseWithin30Days]    
      ,CDDA.[InhalantsUseCurrentFrequency]    
      ,CDDA.[InhalantsUseWithinLifetime]    
      ,CDDA.[InhalantsUsePastFrequency]    
      ,CDDA.[InhalantsUseReceivedTreatment]    
      ,CDDA.[OtherUseWithin30Days]    
      ,CDDA.[OtherUseCurrentFrequency]    
      ,CDDA.[OtherUseWithinLifetime]    
      ,CDDA.[OtherUsePastFrequency]    
      ,CDDA.[OtherUseReceivedTreatment]    
      ,CDDA.[OtherUseType]    
      ,CDDA.[DASTScore]    
      ,CDDA.[MASTScore]    
      ,CDDA.[ClientReferredSubstanceTreatment]    
      ,CDDA.[ClientReferredSubstanceTreatmentWhere]    
      ,CDDA.[RiskSuicideIdeation]    
      ,CDDA.[RiskSuicideIdeationComment]    
      ,CDDA.[RiskSuicideIntent]    
      ,CDDA.[RiskSuicideIntentComment]    
      ,CDDA.[RiskSuicidePriorAttempts]    
      ,CDDA.[RiskSuicidePriorAttemptsComment]    
      ,CDDA.[RiskPriorHospitalization]    
      ,CDDA.[RiskPriorHospitalizationComment]    
      ,CDDA.[RiskPhysicalAggressionSelf]    
      ,CDDA.[RiskPhysicalAggressionSelfComment]    
      ,CDDA.[RiskVerbalAggressionOthers]    
      ,CDDA.[RiskVerbalAggressionOthersComment]    
      ,CDDA.[RiskPhysicalAggressionObjects]    
      ,CDDA.[RiskPhysicalAggressionObjectsComment]    
      ,CDDA.[RiskPhysicalAggressionPeople]    
      ,CDDA.[RiskPhysicalAggressionPeopleComment]    
      ,CDDA.[RiskReportRiskTaking]    
      ,CDDA.[RiskReportRiskTakingComment]    
      ,CDDA.[RiskThreatClientPersonalSafety]    
      ,CDDA.[RiskThreatClientPersonalSafetyComment]    
      ,CDDA.[RiskPhoneNumbersProvided]    
      ,CDDA.[RiskCurrentRiskIdentified]    
      ,CDDA.[RiskTriggersDangerousBehaviors]    
      ,CDDA.[RiskCopingSkills]    
      ,CDDA.[RiskInterventionsPersonalSafetyNA]    
      ,CDDA.[RiskInterventionsPersonalSafety]    
      ,CDDA.[RiskInterventionsPublicSafetyNA]    
      ,CDDA.[RiskInterventionsPublicSafety]    
      ,CDDA.[PhysicalProblemsNoneReported]    
      ,CDDA.[PhysicalProblemsComment]    
      ,CDDA.[SpecialNeedsNoneReported]    
      ,CDDA.[SpecialNeedsVisualImpairment]    
      ,CDDA.[SpecialNeedsHearingImpairment]    
      ,CDDA.[SpecialNeedsSpeechImpairment]    
      ,CDDA.[SpecialNeedsOtherPhysicalImpairment]    
      ,CDDA.[SpecialNeedsOtherPhysicalImpairmentComment]    
      ,CDDA.[EducationSchoolName]    
      ,CDDA.[EducationPreviousExpulsions]    
      ,CDDA.[EducationClassification]    
      ,CDDA.[EducationEmotionalDisturbance]    
      ,CDDA.[EducationPreschoolersDisability]    
      ,CDDA.[EducationTraumaticBrainInjury]    
      ,CDDA.[EducationCognitiveDisability]    
      ,CDDA.[EducationCurrent504]    
      ,CDDA.[EducationOtherMajorHealthImpaired]    
      ,CDDA.[EducationSpecificLearningDisability]    
      ,CDDA.[EducationAutism]    
      ,CDDA.[EducationOtherMinorHealthImpaired]    
      ,CDDA.[EdcuationClassificationComment]    
      ,CDDA.[EducationPreviousRetentions]    
      ,CDDA.[EducationClientIsHomeSchooled]    
      ,CDDA.[EducationClientAttendedPreschool]    
      ,CDDA.[EducationFrequencyOfAttendance]    
      ,CDDA.[EducationReceivedServicesAsToddler]    
      ,CDDA.[EducationReceivedServicesAsToddlerComment]    
      ,CDDA.[ClientPreferencesForTreatment]    
      ,CDDA.[ExternalSupportsReferrals]    
      ,CDDA.[PrimaryClinicianTransfer]    
      ,CDDA.[EAPMentalStatus]    
      ,CDDA.[DiagnosticImpressionsSummary]    
      ,CDDA.[MilestoneUnderstandingLanguage]    
      ,CDDA.[MilestoneVocabulary]    
      ,CDDA.[MilestoneFineMotor]    
      ,CDDA.[MilestoneGrossMotor]    
      ,CDDA.[MilestoneIntellectual]    
      ,CDDA.[MilestoneMakingFriends]    
      ,CDDA.[MilestoneSharingInterests]    
      ,CDDA.[MilestoneEyeContact]    
      ,CDDA.[MilestoneToiletTraining]    
      ,CDDA.[MilestoneCopingSkills]    
      ,CDDA.[MilestoneComment]    
      ,CDDA.[SleepConcernSleepHabits]    
      ,CDDA.[SleepTimeGoToBed]    
      ,CDDA.[SleepTimeFallAsleep]    
      ,CDDA.[SleepThroughNight]    
      ,CDDA.[SleepNightmares]    
      ,CDDA.[SleepNightmaresHowOften]    
      ,CDDA.[SleepTerrors]    
      ,CDDA.[SleepTerrorsHowOften]    
      ,CDDA.[SleepWalking]    
      ,CDDA.[SleepWalkingHowOften]    
      ,CDDA.[SleepTimeWakeUp]    
      ,CDDA.[SleepShareRoom]    
      ,CDDA.[SleepShareRoomWithWhom]    
      ,CDDA.[SleepTakeNaps]    
      ,CDDA.[SleepTakeNapsHowOften]    
      ,CDDA.[FamilyPrimaryCaregiver]    
      ,CDDA.[FamilyPrimaryCaregiverType]    
      ,CDDA.[FamilyPrimaryCaregiverEducation]    
      ,CDDA.[FamilyPrimaryCaregiverAge]    
      ,CDDA.[FamilyAdditionalCareGivers]    
      ,CDDA.[FamilyEmploymentFirstCareGiver]    
      ,CDDA.[FamilyEmploymentSecondCareGiver]    
      ,CDDA.[FamilyStatusParentsRelationship]    
      ,CDDA.[FamilyNonCustodialContact]    
      ,CDDA.[FamilyNonCustodialHowOften]    
      ,CDDA.[FamilyNonCustodialTypeOfVisit]    
      ,CDDA.[FamilyNonCustodialConsistency]    
      ,CDDA.[FamilyNonCustodialLegalInvolvement]    
      ,CDDA.[FamilyClientMovedResidences]    
      ,CDDA.[FamilyClientMovedResidencesComment]    
      ,CDDA.[FamilyClientHasSiblings]    
      ,CDDA.[FamilyClientSiblingsComment]    
      ,CDDA.[FamilyQualityRelationships]    
      ,CDDA.[FamilySupportSystems]    
      ,CDDA.[FamilyClientAbilitiesNA]    
      ,CDDA.[FamilyClientAbilitiesComment]    
      ,CDDA.[ChildHistoryLegalInvolvement]    
      ,CDDA.[ChildHistoryLegalInvolvementComment]    
      ,CDDA.[ChildHistoryBehaviorInFamily]    
      ,CDDA.[ChildHistoryBehaviorInFamilyComment]    
      ,CDDA.[ChildAbuseReported]    
      ,CDDA.[ChildProtectiveServicesInvolved]    
      ,CDDA.[ChildProtectiveServicesReason]    
      ,CDDA.[ChildProtectiveServicesCounty]    
      ,CDDA.[ChildProtectiveServicesCaseWorker]    
      ,CDDA.[ChildProtectiveServicesDates]    
      ,CDDA.[ChildProtectiveServicesPlacements]    
      ,CDDA.[ChildProtectiveServicesPlacementsComment]    
      ,CDDA.[ChildHistoryOfViolence]    
      ,CDDA.[ChildHistoryOfViolenceComment]    
      ,CDDA.[ChildCTESComplete]    
      ,CDDA.[ChildCTESResults]    
      ,CDDA.[ChildWitnessedSubstances]    
      ,CDDA.[ChildWitnessedSubstancesComment]    
      ,CDDA.[ChildBornFullTermPreTerm]    
      ,CDDA.[ChildBornFullTermPreTermComment]    
      ,CDDA.[ChildPostPartumDepression]    
      ,CDDA.[ChildMotherUsedDrugsPregnancy]    
      ,CDDA.[ChildMotherUsedDrugsPregnancyComment]    
      ,CDDA.[ChildConcernsNutrition]    
      ,CDDA.[ChildConcernsNutritionComment]    
      ,CDDA.[ChildConcernsAbilityUnderstand]    
      ,CDDA.[ChildUsingWordsPhrases]    
      ,CDDA.[ChildReceivedSpeechEval]    
      ,CDDA.[ChildReceivedSpeechEvalComment]    
      ,CDDA.[ChildConcernMotorSkills]    
      ,CDDA.[ChildGrossMotorSkillsProblem]    
      ,CDDA.[ChildWalking14Months]    
      ,CDDA.[ChildFineMotorSkillsProblem]    
      ,CDDA.[ChildPickUpCheerios]    
      ,CDDA.[ChildConcernSocialSkills]    
      ,CDDA.[ChildConcernSocialSkillsComment]    
      ,CDDA.[ChildToiletTraining]    
      ,CDDA.[ChildToiletTrainingComment]    
      ,CDDA.[ChildSensoryAversions]    
      ,CDDA.[ChildSensoryAversionsComment]    
      ,CDDA.[HousingHowStable]    
      ,CDDA.[HousingAbleToStay]    
      ,CDDA.[HousingEvictionsUnpaidUtilities]    
      ,CDDA.[HousingAbleGetUtilities]    
      ,CDDA.[HousingAbleSignLease]    
      ,CDDA.[HousingSpecializedProgram]    
      ,CDDA.[HousingHasPets]    
      ,CDDA.[VocationalUnemployed]    
      ,CDDA.[VocationalInterestedWorking]    
      ,CDDA.[VocationalInterestedWorkingComment]    
      ,CDDA.[VocationalTimeSinceEmployed]    
      ,CDDA.[VocationalTimeJobHeld]    
      ,CDDA.[VocationalBarriersGainingEmployment]    
      ,CDDA.[VocationalEmployed]    
      ,CDDA.[VocationalTimeCurrentJob]    
      ,CDDA.[VocationalBarriersMaintainingEmployment]    
      ,CDDA.[LevelofCare]
      
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
          
          
FROM #CustomDocumentDiagnosticAssessments CDDA                          
left join #CustomDocumentMentalStatuses CDMS on CDDA.DocumentVersionId = CDMS.DocumentVersionId                          
                              

drop table #CustomDocumentDiagnosticAssessments                                 
drop table #CustomDocumentMentalStatuses                          


 END                                                                                  
 END TRY                                                                                           
                
                              
                                                                                 
 BEGIN CATCH                                             
   DECLARE @Error varchar(8000)                                                                                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_CustomDocumentDiagnosticAssessments')               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                
    
      
        
          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                                      
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                               
                                                                                                                          
 END CATCH     
END
GO
