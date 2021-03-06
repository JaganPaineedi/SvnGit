/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteSubstanceUseTables]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteSubstanceUseTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteSubstanceUseTables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteSubstanceUseTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteSubstanceUseTables]                 
(                    
  @DocumentVersionId int             
)                    
As          
/******************************************************************************            
**  File:            
**  Name: csp_SCWebGetServiceNoteSubstanceUseTables            
**  Desc: This fetches data for Service Note SubstanceUse Tables           
**            
**  This template can be customized:            
**                          
**  Return values:            
**             
**  Called by:   csp_SCWebGetServiceNoteCustomTables* Stored Procedures          
**                          
**  Parameters:            
**  Input       Output            
**     ----------      -----------            
**  DocumentVersionId    Result Set containing values from Service Note SubstanceUse Tables          
**            
**  Auth: Mohit Madaan      
**  Date: 15-Feb-10            
*******************************************************************************            
**  Change History            
*******************************************************************************            
**  Date:    Author:    Description:            
**  --------   --------   -------------------------------------------            
          
*******************************************************************************/            
BEGIN TRY            
SELECT [DocumentVersionId]      
      ,[AssessmentType]          
      ,[TeamGeneral]          
      ,[Population]          
      ,[ReferralSource]          
      ,[PresentingProblem]          
      ,[PresentingProblemDetails]          
      ,[PrimaryCarePhysician]          
      ,[CurrentHealth]          
      ,[FamilyMedicalHistory]          
      ,[EatingHabits]          
      ,[EatingHabitsTxPlan]          
      ,[SleepingHabits]          
      ,[SleepingHabitsTxPlan]          
      ,[NKMA]          
      ,[MedicalIssues]          
      ,[MedicalIssuesTxPlan]          
      ,[CurrentMedications]          
      ,[OtherMedications]          
      ,[Pharmacy]          
      ,[TxHistoryTherapy]          
      ,[TxHistoryOutpatient]          
      ,[TxHistoryInpatient]          
      ,[TxHistoryCrisis]          
      ,[TxHistoryResidential]          
      ,[TxHistoryCaseManagement]          
      ,[TxHistorySA]          
      ,[TxHistoryHome]          
      ,[TxHistoryOther]          
      ,[TxHistoryOtherText]          
      ,[TxHistoryDetail]          
      ,[TxHistoryHopitalization]          
      ,[PreviousDiagnosis]          
      ,[NaturalSupportSufficiency]          
      ,[IncreasedSupport]          
      ,[NaturalSupportTxPlan]          
      ,[ClientStrengths]          
      ,[SocialHistory]          
      ,[SocialHistoryTxPlan]          
      ,[Relationships]          
      ,[RelationshipsTxPlan]          
      ,[LeisureIssues]          
      ,[LeisureIssuesTxPlan]          
      ,[FinancialIssues]          
      ,[FinancialIssuesTxPlan]          
      ,[ClientHasSSI]          
      ,[ClientHasSSDI]          
      ,[LegalIssuesGuardian]          
      ,[LegalIssuesProbation]          
      ,[LegalIssuesHistory]          
      ,[LegalIssuesCourtCase]          
      ,[LegalIssuesOther]          
      ,[LegalIssuesOtherText]          
      ,[LegalIssuesParole]          
      ,[LegalIssuesPending]          
      ,[LegalCourtOrdered]          
      ,[LegalEmancipatedMinor]          
      ,[LegalWithoutParentalKnowledge]          
      ,[LegalIssuesDivorce]          
      ,[LegalIssuesProtective]          
      ,[LegalIssuesCustody]          
      ,[LegalWardOfCourt]          
      ,[LegalUnderJointCustody]          
      ,[LegalUnderSoleCustody]          
      ,[LegalTherapeuticVisitations]          
      ,[LegalPreAdoptionAgreement]          
      ,[LegalIssues]          
      ,[LegalIssuesTxPlan]          
      ,[Education]          
      ,[EducationTxPlan]          
      ,[Employment]          
      ,[EmploymentTxPlan]          
      ,[Sexuality]          
      ,[SexualityTxPlan]          
      ,[Ethnicity]          
      ,[EthnicityTxPlan]          
 ,[LivingArrangement]          
      ,[LivingArrangementTxPlan]          
      ,[TypeOfLivingSituation]          
      ,[Abuse]          
      ,[AbuseTxPlan]          
      ,[AbusePhysicalVictim]          
      ,[AbusePhysicalPerpatrator]          
      ,[AbuseSexualVictim]          
      ,[AbuseSexualPerpatrator]          
      ,[AbuseEmotionalVictim]          
      ,[AbuseEmotionalPerpatrator]          
      ,[NoSafetyConcerns]          
      ,[SafetyFire]          
      ,[SafetyPedestrian]          
      ,[SafetyStrangers]          
      ,[SafetyCleanEnvironment]          
      ,[SafetyRulesLaws]          
      ,[SafetyUnstableLiving]          
      ,[SafetyHeatUtility]          
      ,[SafetyImpulsive]          
      ,[SafetyHarmSelf]          
      ,[SafetyUnsafeLocation]          
      ,[SafetyEmergencyServices]          
      ,[SafetyWeaponsAccess]          
      ,[Safety]          
      ,[SafetyTxPlan]          
      ,[LOF]          
      ,[LOFTxPlan]          
      ,[MentalHealthFamilyHistory]          
      ,[ClinicalSummary]          
      ,[SummaryAppropriate]          
      ,[SummaryAppropriateText]          
      ,[SummaryReferrals]          
      ,[SummaryReferralsText]          
      ,[CrisisPlanClientDesire]          
      ,[CrisisPlanMoreInfo]          
      ,[CrisisPlan]          
      ,[CrisisPlanTxPlan]          
      ,[ServicesIndividual]          
      ,[ServicesConjoint]          
      ,[ServicesFamily]          
      ,[ServicesMedicationI]          
      ,[ServicesMedicationII]          
      ,[ServicesCaseManagement]          
      ,[ServicesSupportedEmployment]          
      ,[ServicesACT]          
      ,[ServicesSBH]          
      ,[ServicesOther]          
      ,[ServicesOtherText]          
      ,[TreatmentFrequency]          
      ,[ClientAccommodation]          
      ,[AssignedTeam]          
      ,[AssignedClinician]          
      ,[NotifyStaff1]          
      ,[NotifyStaff2]          
      ,[NotifyStaff3]          
      ,[NotifyStaff4]          
      ,[NotificationMessage]          
      ,[NotificationSent]          
      ,[PrePlanParticipants]          
      ,[PrePlanFacilitator]          
      ,[PrePlanAssessments]          
      ,[PrePlanTimeLocation]          
      ,[PrePlanIssuesAvoid]          
      ,[PrePlanSource]          
      ,[AuthorizationTeam]          
      ,[ProceduresComment]          
      ,[AuthorizationSent]          
      ,[ExistingAdvanceDirective]          
      ,[CopyAdvanceDirective]          
      ,[MoreInformationAdvanceDirective]          
      ,[SymptomAnger]          
      ,[SymptomDisruption]          
      ,[SymptomGrief]          
      ,[SymptomIrritability]          
      ,[SymptomAnxiousness]          
      ,[SymptomGuilt]          
      ,[SymptomObsession]          
      ,[SymptomConcomitantMedical]          
      ,[SymptomDissociativeState]          
      ,[SymptomHallucinations]          
      ,[SymptomOppositionalism]          
      ,[SymptomDecreasedEnergy]          
      ,[SymptomEmotionalTraumaVictim]          
      ,[SymptomHopelessness]          
      ,[SymptomPanicAttacks]          
      ,[SymptomDelusions]          
      ,[SymptomEmotionalTraumaPerpetrator]          
      ,[SymptomHyperactivity]          
      ,[SymptomParanoia]          
      ,[SymptomDepressedMood]          
      ,[SymptomElevatedMood]          
      ,[SymptomImpulsiveness]          
      ,[SymptomSomaticComplaints]          
      ,[SymptomWorthlessness]          
      ,[Changeeatinghabits]          
      ,[Changesleepinghabits]          
      ,[SpiritualityTx]          
      ,[SpiritualityText]          
      ,[AssistanceWithNone]          
      ,[AssistanceWithShowering]          
      ,[AssistanceWithToileting]          
      ,[AssistanceWithBrushingTeeth]          
      ,[AssistanceWithDressing]          
      ,[AssistanceWithFeedingSelf]          
      ,[AssistanceWithPreparingMeals]          
      ,[AssistanceWithMobility]          
      ,[AssistanceWithParticipatingActivites]          
      ,[AssistanceWithArrangingTransportation]          
      ,[AssistanceWithCommunicatingPeople]          
      ,[AssistanceWithSelfDirection]          
      ,[AssistanceWithFinancialIndependence]     
      ,[AssistanceWithPlanningActivities]          
      ,[AssistanceWithReading]          
      ,[AssistanceWithOther]          
      ,[AssistanceWithOtherText]          
      ,[ConcernNone]          
      ,[ConcernReading]          
      ,[ConcernSpeech]          
      ,[ConcernMotorSkills]          
      ,[ConcernSchoolPerformanceGrades]          
      ,[ConcernSchoolBehavior]          
      ,[ConcernToileting]          
      ,[ConcernSocializationSkills]          
      ,[ConcernAttentionTask]          
      ,[ConcernHomeBehavior]          
      ,[ConcernPsychomotorSkills]          
      ,[ConcernDevelopmentalMilestones]          
      ,[ConcernOther]          
      ,[ConcernOtherText]          
      ,[AssistanceWithGrooming]          
      ,[AssistanceWithMealPrep]          
      ,[AssistanceWithLaundry]          
      ,[AssistanceWithShopping]          
      ,[AssistanceWithHousecleaning]          
      ,[AssistanceWithTelephoneUse]          
      ,[DiagnosisDocumentId]          
      ,[MaladaptiveBehaviorsTxPlan]          
      ,[MaladaptiveBehaviors]          
      ,[ReasonForUpdate]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
  FROM [CustomAssessments]          
  WHERE            
  DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''      
            
Exec ssp_SCWebAssessmentSUDetails @DocumentVersionId        
          
END TRY            
          
BEGIN CATCH            
 declare @Error varchar(8000)            
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteSubstanceUseTables'')             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())              
    + ''*****'' + Convert(varchar,ERROR_STATE())            
              
 RAISERROR             
 (            
  @Error, -- Message text.            
  16,  -- Severity.            
  1  -- State.            
 );            
            
END CATCH
' 
END
GO
