IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDiagnosticAssessment]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_SCGetCustomDiagnosticAssessment] 
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
 --  SELECT                                                                    
 -- DocumentVersionId                                                 
 --     ,CreatedBy                                                                                                          
 --     ,CreatedDate                                                                                                          
 --     ,ModifiedBy                                                                                                          
 --     ,ModifiedDate                                                                                                          
 --     ,RecordDeleted                                                                                                          
 --     ,DeletedDate                                                                                                          
 --     ,DeletedBy                                                                                                          
 --,Specification                                                                                                                                                  
 --  FROM DiagnosesIII                                                                                                                                                                         
 --  WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                               
                                                                                                                                                                                                 
   -----For DiagnosesIV-----                                                                             
  -- SELECT                                                                                                                                                                                                   
  --DocumentVersionId                                                                   
  --,PrimarySupport                                                                                                                      
  --,SocialEnvironment                                                                       
  --,Educational                          
  --,Occupational                                                                                       
  --,Housing                                                                                                                                                                         
  --,Economic                                         
  --,HealthcareServices                                                                                                                                                                
  --,Legal                                                                                    
  --,Other                                                                  
  --,Specification
  --,DiagnosisAxisIVShowNone                                                                   
  --,CreatedBy                                                                                                                                           
  --,CreatedDate                                                                  
  --,ModifiedBy                                                                                         
  --,ModifiedDate                                                                                                                                                                                       
  --,RecordDeleted                                                                            
  --,DeletedDate                                                                                                                                                                                    
  --,DeletedBy                                                                                                  
  -- FROM DiagnosesIV                                                                                                
  -- WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                                                                                                               
  
    
     
                
                  
                    
                      
                        
                          
                            
                              
                                
                                  
                                                                                                             
   -----For DiagnosesV-----                                                                                            
 --SELECT                                               
 --DocumentVersionId                                   
 --,AxisV                                                                                                                                                                                                                                    
 --,CreatedBy                                                                                                                                       
 --,CreatedDate                                                                                               
 --,ModifiedBy                                                                                                                         
 --,ModifiedDate                                                                                                                                                                                                             
 --,RecordDeleted                                                                                     
 --,DeletedDate                                                                                                                                                         
 --,DeletedBy                                                                                                                
 --FROM DiagnosesV                                                 
 --WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'                                                                                
                                   
                                                                                 
 -----For DiagnosesIAndII-----                                                                                                                                           
--   SELECT                                                                                                                                                  
--   D.DocumentVersionId                                   
--  ,D.DiagnosisId                               
--  ,D.Axis                                                                                
--  ,D.DSMCode                                                                            
--  ,D.DSMNumber                                                                                                                                                                                                            
--  ,D.DiagnosisType                                                                                                                              
--  ,D.RuleOut                                                                                                       
--  ,D.Billable                                                                                                                                 
--  ,D.Severity                                                                                                                                       
--  ,D.DSMVersion                                                                                                        
--  ,D.DiagnosisOrder                                                                                                   
--  ,D.Specifier                                                                
--  ,D.Remission                                           
--  ,D.Source
--  ,D.RowIdentifier                                                                                                     
--  ,D.CreatedBy                                                                                                                                                                                            
--  ,D.CreatedDate                                                                                    
--  ,D.ModifiedBy                                                                                                                      
--  ,D.ModifiedDate                                                         
--  ,D.RecordDeleted                                                                 
--  ,D.DeletedDate                                                                  
--  ,D.DeletedBy                                                                                                                                   
--,DSM.DSMDescription                                                                                              
--  ,case D.RuleOut when 'Y' then 'R/O' else '' end as RuleOutText                                                
--   FROM DiagnosesIAndII  D                                                                                       
--  inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                                                
                       
                          
                            
                              
                                
  --and DSM.DSMNumber = D.DSMNumber                                                                                                                                                                  
  -- WHERE                                                                                 
  --DocumentVersionId=@DocumentVersionId   AND ISNULL(RecordDeleted,'N')='N'              
                                                  
  --DiagnosesIIICodes                                                    
 --SELECT DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy   
 
    
      
        
          
            
              
                
                  
                    
 --FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode                                                                           
 --WHERE (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, 'N') = 'N')                                                                             
                                                          
 ---DiagnosesMaxOrder                                                                            
   --SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,                                                                            
   --RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII                                                                             
   --where DocumentVersionId=@DocumentVersionId                                              
   --and  IsNull(RecordDeleted,'N')='N' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate                                     
   --order by DiagnosesMaxOrder desc                                                                  
                                                    
                                                    
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
 
 exec ssp_SCGetDataDiagnosisNew  @DocumentVersionId             
                                                                                                    
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
