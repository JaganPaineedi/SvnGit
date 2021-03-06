/****** Object:  StoredProcedure [dbo].[csp_SCHRMGetRecentSignedAssessmentAnnual]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMGetRecentSignedAssessmentAnnual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCHRMGetRecentSignedAssessmentAnnual]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMGetRecentSignedAssessmentAnnual]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_SCHRMGetRecentSignedAssessmentAnnual]    
/****************************************************************************/                  
/* csp_SCHRMGetRecentSignedAssessmentAnnual          */                  
/*   Initializes values for new assessments         */                  
/* Called by: ssp_SCHRMGetRecentSignedAssessment       */                  
/*                   */                  
/* Created: 26/06/2010              */                  
/* Created by: Sahil Bhagat           */                  
/* Modification Log:              */                  
/****************************************************************************/                  
 @ClientId int,                  
 @LatestDocumentVersionID int,   
 @AssessmentTypeCheck varchar(10)             
               
as                  
set nocount on                   
          
           
Begin            
--Get AxisI and AxisII for Initial Tab                                                                                        
DECLARE @AxisIAxisIIOut nvarchar(1100)                                                                                        
                                                                                        
EXEC [dbo].[csp_HRMGetAxisIAxisII]                                                                                        
  @ClientID,                                                                                        
  @AxisIAxisIIOut OUTPUT          
 -----For CustomHRMAssessments-----                                                                                                  
   SELECT  ''CustomHRMAssessments'' AS TableName,  [DocumentVersionId]           
     ,[ClientName]          
     , @AssessmentTypeCheck as [AssessmentType]          
      ,[CurrentAssessmentDate]          
      ,[PreviousAssessmentDate]          
      ,[ClientDOB]          
      ,[AdultOrChild]          
      ,[ChildHasNoParentalConsent]          
      ,[ClientHasGuardian]          
      ,[GuardianName]          
      ,[GuardianAddress]          
      ,[GuardianPhone]          
      ,[GuardianType]          
      ,[ClientInDDPopulation]          
      ,[ClientInSAPopulation]          
      ,[ClientInMHPopulation]          
      ,[PreviousDiagnosisText]          
      ,[ReferralType]          
      ,[PresentingProblem]          
      ,[CurrentLivingArrangement]          
      ,[CurrentPrimaryCarePhysician]          
      ,[ReasonForUpdate]          
      ,[DesiredOutcomes]          
      ,[PsMedicationsComment]          
      ,[PsEducationComment]          
      ,[IncludeFunctionalAssessment]          
      ,[IncludeSymptomChecklist]          
      ,[IncludeUNCOPE]          
      ,[ClientIsAppropriateForTreatment]          
      ,[SecondOpinionNoticeProvided]          
      ,[TreatmentNarrative]          
      ,[RapCiDomainIntensity]          
      ,[RapCbDomainIntensity]          
      ,[RapCaDomainIntensity]          
      ,[RapHhcDomainIntensity]          
      ,[OutsideReferralsGiven]          
      ,[ReferralsNarrative]          
      ,[ServiceOther]          
      ,[ServiceOtherDescription]          
      ,[AssessmentAddtionalInformation]          
      ,[TreatmentAccomodation]          
      ,[Participants]          
      ,[Facilitator]          
      ,[TimeLocation]          
      ,[AssessmentsNeeded]          
      ,[CommunicationAccomodations]          
      ,[IssuesToAvoid]          
      ,[IssuesToDiscuss]          
      ,[SourceOfPrePlanningInfo]          
      ,[SelfDeterminationDesired]          
      ,[FiscalIntermediaryDesired]          
      ,[PamphletGiven]          
      ,[PamphletDiscussed]          
      ,[PrePlanIndependentFacilitatorDiscussed]          
      ,[PrePlanIndependentFacilitatorDesired]          
      ,[PrePlanGuardianContacted]          
      ,[CommunityActivitiesCurrentDesired]          
      ,[CommunityActivitiesIncreaseDesired]          
       ,CASE WHEN [CommunityActivitiesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [CommunityActivitiesNeedsList]          
      ,[PsCurrentHealthIssues]          
      ,[PsCurrentHealthIssuesComment]          
      ,CASE WHEN [PsCurrentHealthIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsCurrentHealthIssuesNeedsList]          
      ,[HistMentalHealthTx]          
      ,[HistMentalHealthTxComment]          
      ,[HistFamilyMentalHealthTx]          
      ,[HistFamilyMentalHealthTxComment]          
      ,[PsClientAbuseIssues]          
      ,[PsClientAbuesIssuesComment]          
      ,CASE WHEN [PsClientAbuseIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsClientAbuseIssuesNeedsList]          
      ,[PsDevelopmentalMilestones]          
      ,[PsDevelopmentalMilestonesComment]          
      ,CASE WHEN [PsDevelopmentalMilestonesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsDevelopmentalMilestonesNeedsList]          
      ,[PsChildEnvironmentalFactors]          
      ,[PsChildEnvironmentalFactorsComment]          
      ,CASE WHEN [PsChildEnvironmentalFactorsNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
     [PsChildEnvironmentalFactorsNeedsList]          
      ,[PsLanguageFunctioning]          
      ,[PsLanguageFunctioningComment]          
      ,CASE WHEN [PsLanguageFunctioningNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
     [PsLanguageFunctioningNeedsList]          
      ,[PsVisualFunctioning]          
      ,[PsVisualFunctioningComment]          
      ,CASE WHEN [PsVisualFunctioningNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsVisualFunctioningNeedsList]          
      ,[PsPrenatalExposure]          
      ,[PsPrenatalExposureComment]          
      ,CASE WHEN [PsPrenatalExposureNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsPrenatalExposureNeedsList]          
      ,[PsChildMentalHealthHistory]          
      ,[PsChildMentalHealthHistoryComment]          
      ,CASE WHEN [PsChildMentalHealthHistoryNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsChildMentalHealthHistoryNeedsList]          
      ,[PsIntellectualFunctioning]          
      ,[PsIntellectualFunctioningComment]          
      ,CASE WHEN [PsIntellectualFunctioningNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsIntellectualFunctioningNeedsList]          
      ,[PsLearningAbility]          
      ,[PsLearningAbilityComment]          
      ,CASE WHEN [PsLearningAbilityNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsLearningAbilityNeedsList]          
      ,[PsPeerInteraction]          
      ,[PsPeerInteractionComment]          
      ,CASE WHEN [PsPeerInteractionNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsPeerInteractionNeedsList]          
      ,[PsParentalParticipation]          
      ,[PsParentalParticipationComment]          
      ,CASE WHEN [PsParentalParticipationNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsParentalParticipationNeedsList]          
      ,[PsSchoolHistory]          
      ,[PsSchoolHistoryComment]          
      ,CASE WHEN [PsSchoolHistoryNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsSchoolHistoryNeedsList]          
      ,[PsImmunizations]          
      ,[PsImmunizationsComment]          
      ,CASE WHEN [PsImmunizationsNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsImmunizationsNeedsList]          
      ,[PsChildHousingIssues]          
      ,[PsChildHousingIssuesComment]          
      ,CASE WHEN [PsChildHousingIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsChildHousingIssuesNeedsList]          
      ,[PsSexuality]          
      ,[PsSexualityComment]          
      ,CASE WHEN [PsSexualityNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsSexualityNeedsList]          
      ,[PsFamilyFunctioning]          
      ,[PsFamilyFunctioningComment]          
      ,CASE WHEN [PsFamilyFunctioningNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END           
      [PsFamilyFunctioningNeedsList]          
      ,[PsTraumaticIncident]          
      ,[PsTraumaticIncidentComment]          
        ,CASE WHEN [PsTraumaticIncidentNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsTraumaticIncidentNeedsList]          
      ,[HistDevelopmental]          
      ,[HistDevelopmentalComment]          
      ,[HistResidential]          
      ,[HistResidentialComment]          
      ,[HistOccupational]          
      ,[HistOccupationalComment]          
      ,[HistLegalFinancial]          
      ,[HistLegalFinancialComment]          
      ,[SignificantEventsPastYear]          
      ,[PsGrossFineMotor]          
      ,[PsGrossFineMotorComment]          
        ,CASE WHEN [PsGrossFineMotorNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsGrossFineMotorNeedsList]          
      ,[PsSensoryPerceptual]          
      ,[PsSensoryPerceptualComment]          
        ,CASE WHEN [PsSensoryPerceptualNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsSensoryPerceptualNeedsList]          
      ,[PsCognitiveFunction]          
      ,[PsCognitiveFunctionComment]          
        ,CASE WHEN [PsCognitiveFunctionNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsCognitiveFunctionNeedsList]          
      ,[PsCommunicativeFunction]          
      ,[PsCommunicativeFunctionComment]          
        ,CASE WHEN [PsCommunicativeFunctionNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsCommunicativeFunctionNeedsList]          
      ,[PsCurrentPsychoSocialFunctiion]          
      ,[PsCurrentPsychoSocialFunctiionComment]          
        ,CASE WHEN [PsCurrentPsychoSocialFunctiionNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsCurrentPsychoSocialFunctiionNeedsList]          
      ,[PsAdaptiveEquipment]          
      ,[PsAdaptiveEquipmentComment]          
        ,CASE WHEN [PsAdaptiveEquipmentNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsAdaptiveEquipmentNeedsList]          
      ,[PsSafetyMobilityHome]          
      ,[PsSafetyMobilityHomeComment]          
        ,CASE WHEN [PsSafetyMobilityHomeNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsSafetyMobilityHomeNeedsList]          
      ,[PsHealthSafetyChecklistComplete]          
      ,[PsAccessibilityIssues]          
      ,[PsAccessibilityIssuesComment]          
        ,CASE WHEN [PsAccessibilityIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsAccessibilityIssuesNeedsList]          
      ,[PsEvacuationTraining]          
      ,[PsEvacuationTrainingComment]          
        ,CASE WHEN [PsEvacuationTrainingNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsEvacuationTrainingNeedsList]          
      ,[Ps24HourSetting]          
      ,[Ps24HourSettingComment]          
        ,CASE WHEN [Ps24HourSettingNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [Ps24HourSettingNeedsList]          
      ,[Ps24HourNeedsAwakeSupervision]          
      ,[PsSpecialEdEligibility]          
      ,[PsSpecialEdEligibilityComment]          
        ,CASE WHEN [PsSpecialEdEligibilityNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsSpecialEdEligibilityNeedsList]          
      ,[PsSpecialEdEnrolled]          
      ,[PsSpecialEdEnrolledComment]          
        ,CASE WHEN [PsSpecialEdEnrolledNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsSpecialEdEnrolledNeedsList]          
      ,[PsEmployer]          
      ,[PsEmployerComment]      
        ,CASE WHEN [PsEmployerNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsEmployerNeedsList]          
      ,[PsEmploymentIssues]          
      ,[PsEmploymentIssuesComment]          
        ,CASE WHEN [PsEmploymentIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsEmploymentIssuesNeedsList]          
      ,[PsRestrictionsOccupational]          
      ,[PsRestrictionsOccupationalComment]          
        ,CASE WHEN [PsRestrictionsOccupationalNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
       [PsRestrictionsOccupationalNeedsList]          
      ,[PsFunctionalAssessmentNeeded]          
      ,[PsAdvocacyNeeded]          
      ,[PsPlanDevelopmentNeeded]          
      ,[PsLinkingNeeded]          
      ,[PsDDInformationProvidedBy]          
      ,[HistPreviousDx]          
      ,[HistPreviousDxComment]          
      ,[PsLegalIssues]       
      ,[PsLegalIssuesComment]          
        ,CASE WHEN [PsLegalIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
       [PsLegalIssuesNeedsList]          
      ,[PsCulturalEthnicIssues]          
      ,[PsCulturalEthnicIssuesComment]          
        ,CASE WHEN [PsCulturalEthnicIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsCulturalEthnicIssuesNeedsList]          
      ,[PsSpiritualityIssues]          
      ,[PsSpiritualityIssuesComment]          
        ,CASE WHEN [PsSpiritualityIssuesNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsSpiritualityIssuesNeedsList]          
      ,[SuicideNotPresent]          
      ,[SuicideIdeation]          
      ,[SuicideActive]          
      ,[SuicidePassive]          
      ,[SuicideMeans]          
      ,[SuicidePlan]          
      ,[SuicidePriorAttempt]          
        ,CASE WHEN [SuicideNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [SuicideNeedsList]          
      ,[SuicideBehaviorsPastHistory]          
      ,[SuicideOtherRiskSelf]          
      ,[SuicideOtherRiskSelfComment]          
      ,[HomicideNotPresent]          
      ,[HomicideIdeation]          
      ,[HomicideActive]          
      ,[HomicidePassive]          
      ,[HomicideMeans]          
      ,[HomicidePlan]          
      ,[HomicidePriorAttempt]          
        ,CASE WHEN [HomicideNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
       [HomicideNeedsList]          
      ,[HomicideBehaviorsPastHistory]          
      ,[HomicdeOtherRiskOthers]          
      ,[HomicideOtherRiskOthersComment]          
      ,[PhysicalAgressionNotPresent]          
      ,[PhysicalAgressionSelf]          
      ,[PhysicalAgressionOthers]          
      ,[PhysicalAgressionCurrentIssue]          
        ,CASE WHEN [PhysicalAgressionNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
       [PhysicalAgressionNeedsList]          
      ,[PhysicalAgressionBehaviorsPastHistory]          
      ,[RiskAccessToWeapons]          
      ,[RiskAppropriateForAdditionalScreening]          
      ,[RiskClinicalIntervention]          
      ,[RiskOtherFactors]          
      ,[StaffAxisV]          
      ,[StaffAxisVReason]          
      ,[ClientStrengthsNarrative]          
      ,[CrisisPlanningClientHasPlan]          
      ,[CrisisPlanningNarrative]          
      ,[CrisisPlanningDesired]          
        ,CASE WHEN [CrisisPlanningNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [CrisisPlanningNeedsList]          
      ,[CrisisPlanningMoreInfo]          
      ,[AdvanceDirectiveClientHasDirective]          
      ,[AdvanceDirectiveDesired]          
      ,[AdvanceDirectiveNarrative]          
        ,CASE WHEN [AdvanceDirectiveNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [AdvanceDirectiveNeedsList]          
      ,[AdvanceDirectiveMoreInfo]          
      ,[NaturalSupportSufficiency]          
        ,CASE WHEN [NaturalSupportNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [NaturalSupportNeedsList]          
      ,[NaturalSupportIncreaseDesired]          
      ,[ClinicalSummary]          
      ,[UncopeQuestionU]          
      ,[UncopeApplicable]          
      ,[UncopeApplicableReason]          
      ,[UncopeQuestionN]          
      ,[UncopeQuestionC]          
      ,[UncopeQuestionO]          
      ,[UncopeQuestionP]          
      ,[UncopeQuestionE]          
        ,CASE WHEN [SubstanceUseNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [SubstanceUseNeedsList]          
        ,CASE WHEN [DecreaseSymptomsNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [DecreaseSymptomsNeedsList]          
      ,[DDEPreviouslyMet]          
   ,[DDAttributableMentalPhysicalLimitation]          
      ,[DDDxAxisI]          
      ,[DDDxAxisII]          
      ,[DDDxAxisIII]          
      ,[DDDxAxisIV]          
      ,[DDDxAxisV]          
      ,[DDDxSource]          
      ,[DDManifestBeforeAge22]          
      ,[DDContinueIndefinitely]          
      ,[DDLimitSelfCare]          
      ,[DDLimitLanguage]          
      ,[DDLimitLearning]          
      ,[DDLimitMobility]          
      ,[DDLimitSelfDirection]          
      ,[DDLimitEconomic]          
      ,[DDLimitIndependentLiving]          
      ,[DDNeedMulitpleSupports]          
      ,[CAFASDate]          
      ,[RaterClinician]          
      ,[CAFASInterval]          
      ,[SchoolPerformance]          
      ,[SchoolPerformanceComment]          
      ,[HomePerformance]          
      ,[HomePerfomanceComment]          
      ,[CommunityPerformance]          
      ,[CommunityPerformanceComment]          
      ,[BehaviorTowardsOther]          
      ,[BehaviorTowardsOtherComment]          
      ,[MoodsEmotion]          
      ,[MoodsEmotionComment]          
      ,[SelfHarmfulBehavior]          
      ,[SelfHarmfulBehaviorComment]          
      ,[SubstanceUse]          
      ,[SubstanceUseComment]          
      ,[Thinkng]          
      ,[ThinkngComment]          
      ,[PrimaryFamilyMaterialNeeds]          
      ,[PrimaryFamilyMaterialNeedsComment]          
      ,[PrimaryFamilySocialSupport]          
      ,[PrimaryFamilySocialSupportComment]          
      ,[NonCustodialMaterialNeeds]          
      ,[NonCustodialMaterialNeedsComment]          
      ,[NonCustodialSocialSupport]          
      ,[NonCustodialSocialSupportComment]          
      ,[SurrogateMaterialNeeds]          
      ,[SurrogateMaterialNeedsComment]          
      ,[SurrogateSocialSupport]          
      ,[SurrogateSocialSupportComment]          
      ,[DischargeCriteria]          
      ,[PrePlanFiscalIntermediaryComment]          
      ,[StageOfChange]          
      ,[PsEducation]          
        ,CASE WHEN [PsEducationNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
      [PsEducationNeedsList]          
      ,[PsMedications]          
        ,CASE WHEN [PsMedicationsNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END          
       [PsMedicationsNeedsList]  
      ,[PhysicalConditionQuadriplegic]  
      ,[PhysicalConditionMultipleSclerosis]  
      ,[PhysicalConditionBlindness]  
      ,[PhysicalConditionDeafness]  
      ,[PhysicalConditionParaplegic]  
      ,[PhysicalConditionCerebral]  
      ,[PhysicalConditionMuteness]  
      ,[PhysicalConditionOtherHearingImpairment]            
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]                          
      ,@AxisIAxisIIOut as AxisIAxisII                                                                            
  FROM CustomHRMAssessments                                                                                 
  WHERE  (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)              
 -----For DiagnosesIII-----                           
   SELECT ''DiagnosesIII'' AS TableName,                                                                                                               
    [DocumentVersionId]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
      ,[Specification]                                                                                                           
   FROM DiagnosesIII                                                       
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                            
                                                                                                              
   -----For DiagnosesIV-----                                                                       
   SELECT  ''DiagnosesIV'' AS TableName,                                                                                                    
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
  ,CreatedBy                                                           
  ,CreatedDate                                                
  ,ModifiedBy                                                                                                              
  ,ModifiedDate                                                                             
  ,RecordDeleted                                                                                                              
  ,DeletedDate                                                                                                       
  ,DeletedBy                                                                                                              
   FROM DiagnosesIV                                                                                                              
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                                              
                                                                                                
   -----For DiagnosesV-----                                                              
 SELECT  ''DiagnosesV'' AS TableName,                                              
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
 WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                      
                                                
                                                            
  ---CustomPsychosocialAdult2---                                                              
 SELECT ''CustomPsychosocialAdult2'' AS TableName,  [DocumentVersionId]                                                      
      ,[HealthIssues]          
                
  ,CASE WHEN [HealthIssuesAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                      
      [HealthIssuesAddToNeedsList]                                              
      ,[HealthIssuesDescription]                                                      
      ,[Medications]          
                
  ,CASE WHEN [MedicationsAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                      
       [MedicationsAddToNeedsList]                                                      
      ,[MedicationsListToBeModified]                                                      
      ,[MedicationsDescription]                                                      
      ,[AbuseNeglect]          
                
  ,CASE WHEN [AbuseNeglectAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                             
     [AbuseNeglectAddToNeedsList]                                                      
      ,[AbuseNeglectDescription]                                                      
      ,[CulturalEthnic]          
                
  ,CASE WHEN [CulturalEthnicAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                      
       [CulturalEthnicAddToNeedsList]                                                      
      ,[CulturalEthnicDescription]                                                
      ,[Spirituality]           
                
  ,CASE WHEN [SpiritualityAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                     
       [SpiritualityAddToNeedsList]                                                      
      ,[SpiritualityDescription]          
                
  ,CASE WHEN [EducationStatusAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                      
       [EducationStatusAddToNeedsList]                                                      
      ,[EducationStatusDescription]                                                      
      ,[MentalHealth]           
                
  ,CASE WHEN [MentalHealthAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                     
       [MentalHealthAddToNeedsList]                                                      
      ,[MentalHealthDescription]                                                      
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                                      
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                      
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                                      
    ,[DeletedBy]                            
  FROM CustomPsychosocialAdult2                                               
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                             
                                                        
 ---CustomAssessments2---                                                            
 SELECT ''CustomAssessments2'' AS TableName,  [DocumentVersionId]                                                      
      ,[AssessmentType]                                                      
      ,[AdultOrChild]                                                      
      ,[CurrentAssessmentDate]                                                      
      ,[ClientHasGuardian]                                                      
      ,[GuardianName]                                                      
      ,[GuardianAddress]                                                      
      ,[GuardianPhone]                                                      
      ,[GuardianType]                                                      
      ,[ClientInDDPopulation]                                                      
      ,[ClientInSAPopulation]                                                      
      ,[ClientInMHPopulation]                                                      
      ,[PreviousDiagnosisText]                                                      
      ,[ReferralType]                                                      
      ,[PresentingProblem]                                                      
      ,[CurrentLivingArrangement]                               
      ,[CurrentPrimaryCarePhysician]                                     
      ,[DesiredOutcomes]                                                      
      ,[UncopeApplicable]                                                      
      ,[UncopeApplicableReason]                                                      
      ,[UncopeQuestionU]                                                      
      ,[UncopeQuestionN]                                                      
      ,[UncopeQuestionC]                                                      
      ,[UncopeQuestionO]                                                      
      ,[UncopeQuestionP]                                             
      ,[UncopeQuestionE]                                                      
      ,[UncopeStageOfChange]                                                 
      ,[UncopeCompleteFullSUAssessment]                                                      
      ,[IsClientAppropriateForTreatment]                                                      
      ,[WasSecondOpinionProvided]                                                      
      ,[SummaryTreatmentComment]                           
      ,[SummaryOutsideReferralsGiven]                                                      
      ,[SummaryReferralComment]                                                      
      ,[SummaryAccomodationsComment]                                                
      ,[SummaryAdditionalInformation]                                                      
      ,[SummaryInterpretiveSummary]                                                      
  ,[SummaryCriteriaForDischarge]                                                      
      ,[PreplanSeperateDocument]                                                
      ,[PreplanParticipants]         
      ,[PreplanTimeLocation]                                                      
      ,[PreplanIssueToAvoid]                                                      
      ,[PreplanClientWishToDiscuss]                                                      
      ,[PreplanSelfDetermination]                                                      
      ,[PreplanFiscalDetermination]                     
      ,[PreplanSelfFiscalDeterminationComment]    
      ,[PreplanIndependentFacilitation]                                                      
      ,[PreplanRequestIndependentFacilitator]                                                      
      ,[PreplanFacilitatorComment]                                                      
      ,[PreplanCommunicationComment]                                                      
      ,[PreplanSourceComment]                                                      
      ,[PreplanSourcePamphletGiven]                                                      
      ,[PreplanSourceDiscussed]                                                      
      ,ca.CreatedBy                                                      
      ,ca.CreatedDate                                                      
      ,ca.ModifiedBy                                                      
      ,ca.ModifiedDate                                                      
      ,ca.RecordDeleted                                                    
      ,ca.DeletedDate                                                      
      ,ca.DeletedBy                                              
     -- ,c.LOCCategoryName +'' ''+ ''/''+'' '' + l.LOCName  ''LevelofCare'' ,                                            
   --,c.DeterminationDescription,                                            
  -- l.[Description],                                            
  --l.ADTCriteria,                                            
   --l.ProviderQualifications                                            
                         
    FROM  CustomAssessments2 ca                                            
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                         
                                           
  --FROM CustomAssessments2 ca ,CustomLOCCategories c,CustomLOCs l                                                     
                                    
  --WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ca.RecordDeleted,''N'')=''N''                                               
  --and ca.LOCId=l.LOCId  and c.LOCCategoryId=l.LOCCategoryId                                                     
                                                       
 ---CustomRiskAssessments2---                                                      
 SELECT ''CustomRiskAssessments2'' AS TableName,  [DocumentVersionId]                                                      
      ,[CurrentSuicidality]                                                      
      ,[SuicidalityPreviousAttempts]                                                      
      ,[NoCurrentOrPastSuicidality]                                                      
      ,[CurrentSuicidalityIdeation]                                                      
      ,[CurrentSuicidalityActive]                                                      
      ,[CurrentSuicidalityPassive]                                                      
      ,[CurrentSuicidalityMeans]                                                      
      ,[CurrentSuicidalityPlans]                         
      ,[SuicidalityDetails]        
       ,CASE WHEN [SuicidalityAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                   
     [SuicidalityAddToNeedsList]                                    ,[CurrentHomicidality]                                                      
      ,[HomicidalityPreviousAttempts]                                                      
  ,[NoCurrentOrPastHomicidality]                                                     
      ,[CurrentHomicidalityIdeation]                                                      
      ,[CurrentHomicidalityActive]                                                      
      ,[CurrentHomicidalityPassive]                                                      
      ,[CurrentHomicidalityMeans]       
      ,[CurrentHomicidalityPlans]                                                      
      ,[HomicidalityDetails]           
                
  ,CASE WHEN [HomicidalityAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                     
     [HomicidalityAddToNeedsList]                                                      
      ,[OtherRiskFactorsNone]                                                      
      ,[OtherRiskFactorDetails]           
                
  ,CASE WHEN [OtherRiskFactorsAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                     
      [OtherRiskFactorsAddToNeedsList]                                          
      ,[CrisisPlanningClientHasPlan]                                                      
      ,[CrisisPlanningClientDesiresPlan]                                                     
      ,[CrisisPlanningClientLikesMoreInformation]                                                      
 ,[CrisisPlanningInformationGiven]           
           
  ,CASE WHEN [CrisisPlanningAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                     
      [CrisisPlanningAddToNeedsList]                                                      
      ,[AdvanceDirectiveClientHas]                                                      
      ,[AdvanceDirectiveClientDesires]                                                      
      ,[AdvanceDirectiveClientLikesMoreInformation]                                                 
      ,[AdvanceDirectiveMoreInformationGiven]           
                
  ,CASE WHEN [AdvanceDirectiveAddToNeedsList] = ''O'' THEN ''NULL''          
       ELSE NULL END                                                     
       [AdvanceDirectiveAddToNeedsList]                                                      
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                                      
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                      
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                                      
      ,[DeletedBy]                                                      
  FROM CustomRiskAssessments2                                                      
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                      
                                                      
                                                       
        ---CustomHRMAssessmentActivityScores---   
        --- CustomDailyLivingActivityScores ---                                      
  SELECT ''CustomDailyLivingActivityScores''  AS TableName,  [DailyLivingActivityScoreId]                                                      
      ,[DocumentVersionId]                                                      
      ,[HRMActivityId]                                                      
      ,[ActivityScore]                                                      
      ,[ActivityComment]                                                      
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                     
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                          
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                          
      ,[DeletedBy]                                                      
  FROM CustomDailyLivingActivityScores                                               
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                      
                                                              
   ---CustomSubstanceUseHistory2---                                                      
  SELECT ''CustomSubstanceUseHistory2'' AS TableName,  [SubstanceUseHistoryId]                                                      
      ,[DocumentVersionId]                                                      
      ,[SUDrugId]                                                      
      ,[AgeOfFirstUse]                                                      
      ,[Frequency]                                       
      ,[Route]                                                      
      ,[LastUsed]                                                      
      ,[InitiallyPrescribed]                                                   
      ,[Preference]                                                      
      ,[FamilyHistory]                              
      ,[CreatedBy]                                                      
      ,[CreatedDate]                                                      
      ,[ModifiedBy]                                                      
      ,[ModifiedDate]                                                      
      ,[RecordDeleted]                                                      
      ,[DeletedDate]                                                      
      ,[DeletedBy]                                                      
  FROM CustomSubstanceUseHistory2                                                      
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                     
                                    
  ---CustomHRMAssessmentLevelOfCareOptions---                                                               
 SELECT ''CustomHRMAssessmentLevelOfCareOptions'' AS TableName,  [HRMAssessmentLevelOfCareOptionId]                                                              
 ,[DocumentVersionId]                                                              
      ,[HRMLevelOfCareOptionId]                                                              
      ,[OptionSelected]                                                              
      ,[CreatedBy]                                                              
     ,[CreatedDate]                                                              
      ,[ModifiedBy]                                                              
      ,[ModifiedDate]                              
   ,[RecordDeleted]                                                              
      ,[DeletedDate]                                                              
      ,[DeletedBy]                                                            
   --,(select ServiceChoiceLabel from CustomHRMLevelOfCareOptions  where isnull(RecordDeleted,''N'')=''N''                                                                         
   -- and HRMLevelOfCareOptionId = isnull(HRMLevelOfCareOptionId,'''')) as ServiceChoiceLabel                                                            
  FROM CustomHRMAssessmentLevelOfCareOptions                                                        
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                            
                                                            
  ---CustomOtherRiskFactors---                                                           
  SELECT ''CustomOtherRiskFactors'' AS TableName,  [OtherRiskFactorId]                                                          
      ,[DocumentVersionId]                    
      ,[OtherRiskFactor]                                                          
      ,[CreatedBy]                                                          
      ,[CreatedDate]                                                          
      ,[ModifiedBy]                                            
      ,[ModifiedDate]                                                          
      ,[RecordDeleted]                                                          
      ,[DeletedDate]                                                   
      ,[DeletedBy]                                                          
      ,(select CodeName from GlobalCodes  where isnull(RecordDeleted,''N'')=''N''                                                                   
  and GlobalCodeId = isnull(OtherRiskFactor,'''')) as CodeName                                                          
  FROM CustomOtherRiskFactors                                                           
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                     
                                                       
 ---CustomSupports2---                                                               
  SELECT ''CustomSupports2'' AS TableName,  [SupportId]                                                        
      ,[DocumentVersionId]                                                        
      ,[SupportDescription]                                                        
      ,[Current]                                                        
      ,[PaidSupport]                                                        
      ,[UnpaidSupport]                                                        
      ,[ClinicallyRecommended]                                                        
      ,[CustomerDesired]                                                        
      ,[CreatedBy]                                                        
      ,[CreatedDate]                                                        
      ,[ModifiedBy]                                                        
      ,[ModifiedDate]                              
      ,[RecordDeleted]                                                        
      ,[DeletedDate]                                    ,[DeletedBy]                                           
  FROM CustomSupports2                                                        
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                        
                                                   
                                                               
 -- CustomHRMActivities---                                                      
                                                                        
   SELECT  ''CustomHRMActivities'' AS TableName,  [HRMActivityId]                                                                    
      ,[HRMActivityDescription]                         
      ,[SortOrder]                                                                    
      ,[Active]                                                                    
      ,[AssociatedHRMNeedId]                                           
      ,[Example]                                                                    
      ,[CreatedBy]                                                                    
      ,[CreatedDate]                                                                    
      ,[ModifiedBy]                                                                    
      ,[ModifiedDate]                                                                   
      ,[RecordDeleted]                                                                 
    ,[DeletedDate]                                     
      ,[DeletedBy]                                                                    
      from  CustomHRMActivities where                                                                             
 Active=''Y'' and  isnull(RecordDeleted,''N'')<>''Y''                                                        
                                            
                                                                 
  ---CustomCAFAS2---                                                        
  SELECT ''CustomCAFAS2'' AS TableName,  [DocumentVersionId]                                     
      ,[CAFASDate]                                                        
      ,[RaterClinician]           
      ,[CAFASInterval]                                                        
      ,[SchoolPerformance]                                                        
      ,[SchoolPerformanceComment]                                                        
      ,[HomePerformance]                                                        
      ,[HomePerfomanceComment]                                                        
      ,[CommunityPerformance]                                                        
      ,[CommunityPerformanceComment]                                                        
      ,[BehaviorTowardsOther]                                                        
      ,[BehaviorTowardsOtherComment]                                                        
      ,[MoodsEmotion]                                                        
      ,[MoodsEmotionComment]                                                        
      ,[SelfHarmfulBehavior]                                                  
      ,[SelfHarmfulBehaviorComment]                                                        
      ,[SubstanceUse]                                                        
      ,[SubstanceUseComment]                                                        
      ,[Thinkng]                                                     
      ,[ThinkngComment]                                                        
      ,[PrimaryFamilyMaterialNeeds]                                                        
      ,[PrimaryFamilyMaterialNeedsComment]                                                        
      ,[PrimaryFamilySocialSupport]                                                        
      ,[PrimaryFamilySocialSupportComment]                                                        
      ,[NonCustodialMaterialNeeds]                                                        
      ,[NonCustodialMaterialNeedsComment]                                                        
      ,[NonCustodialSocialSupport]                                                        
      ,[NonCustodialSocialSupportComment]                                                        
      ,[SurrogateMaterialNeeds]                                                        
      ,[SurrogateMaterialNeedsComment]                                                        
      ,[SurrogateSocialSupport]                                                        
      ,[SurrogateSocialSupportComment]                                                        
      ,[CreatedDate]                                                        
      ,[CreatedBy]                          
      ,[ModifiedDate]                     
      ,[ModifiedBy]          ,[RecordDeleted]                                                        
      ,[DeletedDate]                                                        
      ,[DeletedBy]                                                        
  FROM CustomCAFAS2                                                         
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                 
                                                          
  ---CustomPsychosocialChild2---                                     
  SELECT ''CustomPsychosocialChild2'' AS TableName,  [DocumentVersionId]                                                        
      ,[HealthPhysicalHealth]         
       ,CASE WHEN [HealthPhysicalHealthAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [HealthPhysicalHealthAddToNeedsList]                                                        
      ,[HealthMetMilestones]        
       ,CASE WHEN [HealthMetMilestonesAddtoNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                        
       [HealthMetMilestonesAddtoNeedsList]                                                        
      ,[HealthPrenatalSubstances]         
       ,CASE WHEN [HealthPrenatalSubstancesAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [HealthPrenatalSubstancesAddToNeedsList]                                             
      ,[HealthSexualityIssues]         
       ,CASE WHEN [HealthSexualityIssuesAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
     [HealthSexualityIssuesAddToNeedsList]                                                   
      ,[Medications]          
       ,CASE WHEN [MedicationsAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                      
       [MedicationsAddToNeedsList]                                                        
      ,[MedicationsListToBeModified]                                                        
      ,[MedicationsDescription]                                                        
      ,[FunctioningLanguage]         
       ,CASE WHEN [FunctioningLanguageAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [FunctioningLanguageAddToNeedsList]                                                        
      ,[FunctioningVisual]         
       ,CASE WHEN [FunctioningVisualAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [FunctioningVisualAddToNeedsList]                                                        
      ,[FunctioningIntellectual]         
       ,CASE WHEN [FunctioningIntellectualAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [FunctioningIntellectualAddToNeedsList]                                                        
      ,[FunctioningLearning]          
       ,CASE WHEN [FunctioningLearningAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                      
       [FunctioningLearningAddToNeedsList]                                                        
      ,[FunctioningConcerns]                                                        
      ,[CultureEthnic]          
       ,CASE WHEN [CultureEthnicAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                      
       [CultureEthnicAddToNeedsList]                                  
      ,[CultureSpirituality]          
       ,CASE WHEN [CultureSpiritualityAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                      
       [CultureSpiritualityAddToNeedsList]                                                        
      ,[CultureEthnicConcerns]                                                        
      ,[FamilyMentalHistory]        
       ,CASE WHEN [FamilyMentalHistoryAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                        
       [FamilyMentalHistoryAddToNeedsList]         
      ,[FamilyHousing]        
       ,CASE WHEN [FamilyHousingAddToNeedsList] = ''O'' THEN ''NULL''        
   ELSE NULL END                                                        
       [FamilyHousingAddToNeedsList]                                           
      ,[FamilyParticipate]         
       ,CASE WHEN [FamilyParticipateAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
      [FamilyParticipateAddToNeedsList]                                                        
      ,[FamilyLearning]         
       ,CASE WHEN [FamilyLearningAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                     
      [FamilyLearningAddToNeedsList]                                                        
      ,[FamilyAbuse]         
       ,CASE WHEN [FamilyAbuseAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [FamilyAbuseAddToNeedsList]                                                        
      ,[FamilyConcerns]                                                        
      ,[Spirituality]         
       ,CASE WHEN [SpiritualityAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
       [SpiritualityAddToNeedsList]                                                        
      ,[SpiritualityDescription]        
       ,CASE WHEN [EducationStatusAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                        
       [EducationStatusAddToNeedsList]                                                        
      ,[EducationStatusDescription]                                                        
      ,[MentalHealth]         
       ,CASE WHEN [MentalHealthAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                                       
      [MentalHealthAddToNeedsList]                                                        
      ,[MentalHealthDescription]                                                        
      ,CPC2.[CreatedBy]                                                      
      ,CPC2.[CreatedDate]                                                        
      ,CPC2.[ModifiedBy]             
      ,CPC2.[ModifiedDate]                                                        
      ,CPC2.[RecordDeleted]                                   
      ,[DeletedDate]                                                     
      ,[DeletedBy]                                                        
                                                        
    FROM CustomPsychosocialChild2 CPC2                                                         
    WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                          
                                                               
  ---CustomPsychosocialDD2---                                                         
  SELECT ''CustomPsychosocialDD2'' AS TableName,  [DocumentVersionId]                                                        
      ,[MentalHealth]        
       ,CASE WHEN [MentalHealthAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                        
       [MentalHealthAddToNeedsList]                                        
      ,[MentalHealthDescription]                                        
      ,[CulturalEthnic]         
       ,CASE WHEN [CulturalEthnicAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                       
       [CulturalEthnicAddToNeedsList]                                        
      ,[CulturalEthnicDescription]                                        
      ,[Spirituality]          
       ,CASE WHEN [SpiritualityAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                      
       [SpiritualityAddToNeedsList]                                 
      ,[SpiritualityDescription]                                        
      ,[AbuseNeglect]         
       ,CASE WHEN [AbuseNeglectAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                       
       [AbuseNeglectAddToNeedsList]                                        
      ,[AbuseNeglectDescription]                      
      ,[RiskLossOfPlacement]                                        
      ,[RiskLossOfPlacementDueTo]                                        
      ,[RiskSensoryMotorFunction]                                        
      ,[RiskSensoryMotorFunctionDueTo]                                        
      ,[RiskEmploymentIssues]                                        
      ,[RiskEmploymentIssuesDueTo]                                        
      ,[RiskCognitiveFunction]                                        
      ,[RiskCognitiveFunctionDueTo]                                        
      ,[RiskSafety]                                        
      ,[RiskSafetyDueTo]                                        
      ,[CreatedBy]                                        
      ,[CreatedDate]                                        
      ,[ModifiedBy]                                        
      ,[ModifiedDate]                                        
      ,[RecordDeleted]                                        
      ,[DeletedDate]                                        
      ,[DeletedBy]                         
  FROM    CustomPsychosocialDD2 CPDD2                                                       
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                          
                                                       
       ---CustomSubstanceUseAssessments2---                                                     
   SELECT ''CustomSubstanceUseAssessments2'' AS TableName, [DocumentVersionId]                  
      ,[SuspectedSubstanceUse]                  
      ,[ClientSAHistory]                  
      ,[FamilySAHistory]                  
      ,[ClientAdmitsSubstanceUse]                  
      ,[CurrentSubstanceUseSuspected]                  
      ,[SubstanceUseTxPlan]                  
      ,[Comment]                  
      ,[OdorOfSubstance]                  
      ,[SlurredSpeech]                  
      ,[WithdrawalSymptoms]                  
      ,[IncreasedTolerance]                  
      ,[Blackouts]                  
      ,[LossOfControl]                  
      ,[RelatedArrests]                  
      ,[RelatedSocialProblems]                  
      ,[FrequentJobSchoolAbsence]                  
      ,[NoneSynptomsReportedOrObserved]                  
      ,[DUI30Days]                  
      ,[DUI5Years]                  
      ,[DWI30Days]                  
      ,[DWI5Years]                  
      ,[Possession30Days]                  
      ,[Possession5Years]                  
      ,[SubstanceAbuseSymptomsComments]                  
      ,[PreviousSubstanceAbuseTreatment]                  
      ,[CurrentSubstanceAbuseTreatment]                  
      ,[CurrentTreatmentProvider]                  
      ,[CurrentSubstanceUseSymptoms]                  
      ,[CurrentSubstanceAbuseRefferedReason]                  
      ,[ToxicologicalResults]                  
      ,[VoluntaryAbstinenceTrial]                  
      ,[RiskOfRelapse]        
       ,CASE WHEN [SUIssuesAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                  
       [SUIssuesAddToNeedsList]                  
      ,[RowIdentifier]                  
      ,[CreatedBy]                  
      ,[CreatedDate]                  
      ,[ModifiedBy]                  
      ,[ModifiedDate]                  
      ,[RecordDeleted]                  
      ,[DeletedDate]                  
      ,[DeletedBy]                                            
  FROM                                           
                                                    
  CustomSubstanceUseAssessments2 CSUA2                                                       
  WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                           
                       
       -- CustomHRMAssessmentRAPScores --            
       SELECT ''CustomHRMAssessmentRAPScores'' AS TableName,  [HRMAssessmentRAPQuestionId]            
      ,[DocumentVersionId]            
      ,[HRMRAPQuestionId]            
      ,[RAPAssessedValue]            
      ,[RowIdentifier]            
      ,[CreatedBy]            
      ,[CreatedDate]            
      ,[ModifiedBy]            
      ,[ModifiedDate]            
      ,[RecordDeleted]            
      ,[DeletedDate]            
      ,[DeletedBy]            
  FROM CustomHRMAssessmentRAPScores             
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                
                                        
                                        
   --- CustomSubstanceUseAssessments ----                                                                                                     
    select  ''CustomSubstanceUseAssessments'' AS TableName,  [DocumentVersionId]                                             
      ,[VoluntaryAbstinenceTrial]                                                                  
      ,[Comment]                                                                  
      ,[HistoryOrCurrentDUI]                                                                  
      ,[NumberOfTimesDUI]                                                                  
      ,[HistoryOrCurrentDWI]                                                                  
      ,[NumberOfTimesDWI]                                                                  
      ,[HistoryOrCurrentMIP]                                                                  
      ,[NumberOfTimeMIP]                                      
      ,[HistoryOrCurrentBlackOuts]                                                                  
      ,[NumberOfTimesBlackOut]                                                                  
      ,[HistoryOrCurrentDomesticAbuse]                                        
      ,[NumberOfTimesDomesticAbuse]                                                                  
      ,[LossOfControl]                                                                  
      ,[IncreasedTolerance]                                                                  
     ,[OtherConsequence]                                                    
      ,[OtherConsequenceDescription]                                                                  
      ,[RiskOfRelapse]                                                                  
      ,[PreviousTreatment]                                                
      ,[CurrentSubstanceAbuseTreatment]                                                                  
      ,[CurrentTreatmentProvider]                                                                  
      ,[CurrentSubstanceAbuseReferralToSAorTx]                                                                  
      ,[CurrentSubstanceAbuseRefferedReason]                                                          
      ,[ToxicologyResults]                                                                  
      ,[ClientSAHistory]                                                                  
      ,[FamilySAHistory]                                                                  
      ,[NoSubstanceAbuseSuspected]                                                                  
      ,[CurrentSubstanceAbuse]                                                                  
      ,[SuspectedSubstanceAbuse]                                                          
      ,[SubstanceAbuseDetail]                           
      ,[SubstanceAbuseTxPlan]                                                                  
      ,[OdorOfSubstance]                                                                  
      ,[SlurredSpeech]                                                                  
      ,[WithdrawalSymptoms]                                                                  
      ,[DTOther]                                                                  
      ,[DTOtherText]                               
    ,[Blackouts]                                                                  
      ,[RelatedArrests]                                                                  
      ,[RelatedSocialProblems]                                                                  
      ,[FrequentJobSchoolAbsence]                                                                  
      ,[NoneSynptomsReportedOrObserved]                                                                  
      ,cs.[RowIdentifier]                                                    
      ,cs.[CreatedBy]                                  
    ,cs.[CreatedDate]                                                                  
      ,cs.[ModifiedBy]                                                                  
      ,cs.[ModifiedDate]                                                                  
      ,cs.[RecordDeleted]                                                                  
      ,cs.[DeletedDate]                                                                  
      ,cs.[DeletedBy]                                                                                                 
  FROM CustomSubstanceUseAssessments cs                                                                                                     
  WHERE (ISNULL(cs.RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                                           
                                                     
                                      
      ------Added By Ashwani Kumar Angrish                                
------1 june 2010                                
------For Initailization of Needs from TXPlan                                
select ClientNeedId,ClientEpisodeId,NeedName,NeedDescription,NeedStatus,AssociatedHRMNeedId,SourceDocumentVersionId,                                
AssessmentUpdateType,DiagnosisUpdateRequired,NeedCreatedByName,RowIdentifier,CreatedBy,CreatedDate,                                
ModifiedBy,ModifiedDate,RecordDeleted,DeletedDate,DeletedBy,(select NeedId from CustomTPNeedsClientNeeds where CustomTPNeedsClientNeeds.ClientNeedId=CustomClientNeeds.ClientNeedId) as AssociatedGoalId from CustomClientNeeds where SourceDocumentVersionId 
in       
                            
(select  CurrentDocumentVersionId from Documents where ClientId=@ClientId                               
and (DocumentCodeId=352 or DocumentCodeId=503 or DocumentCodeId=350) and ISNULL(RecordDeleted,''N'')=''N'')and ISNULL(RecordDeleted,''N'')=''N''                                
                     
  -- CustomRAP2--                           
  select  ''CustomRAP2'' AS TableName,  [DocumentVersionId]                                  
      ,[RapCiDomainIntensity]                                  
      ,[CommunityInclusionSummary]        
       ,CASE WHEN [CommunityInclusionSummaryAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                  
       [CommunityInclusionSummaryAddToNeedsList]                                  
      ,[RapCbDomainIntensity]                                  
      ,[ChallengingBehaviorsSummary]        
      ,CASE WHEN [ChallengingBehaviorsSummaryAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                             
       [ChallengingBehaviorsSummaryAddToNeedsList]                                  
      ,[RapCaDomainIntensity]                                  
      ,[CurrentAbilitiesSummary]        
       ,CASE WHEN [CurrentAbilitiesSummaryAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                  
       [CurrentAbilitiesSummaryAddToNeedsList]                                  
      ,[RapHhcDomainIntensity]                                  
      ,[HealthIssuesMedications]        
       ,CASE WHEN [HealthIssuesMedicationsAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                              
       [HealthIssuesMedicationsAddToNeedsList]                                  
      ,[HealthIssuesMedicationsModified]                                  
      ,[HealthIssuesMedicationsList]                                  
      ,[HealthIssuesSummary]        
       ,CASE WHEN [HealthIssuesSummaryAddToNeedsList] = ''O'' THEN ''NULL''        
       ELSE NULL END                                  
       [HealthIssuesSummaryAddToNeedsList]                                  
      ,[RowIdentifier]                                  
      ,[CreatedBy]                                  
      ,[CreatedDate]                                  
      ,[ModifiedBy]                                  
      ,[ModifiedDate]                                  
      ,[RecordDeleted]                                  
      ,[DeletedDate]                                  
     from CustomRAP2 CR2                                  
     WHERE (ISNULL(CR2.RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                  
                     
     -------CustomHRMAssessmentNeeds                
     -------Added By Ashwani Kumar Angrish                
     -------June 11 2010                
     select HRMAssessmentNeedId,DocumentVersionId,HRMNeedId,NeedName,NeedStatus,NeedDate,NeedDescription,                
     ClientNeedId,RowIdentifier,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,RecordDeleted,                
     DeletedDate,DeletedBy from CustomHRMAssessmentNeeds where (ISNULL(RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @LatestDocumentVersionID)                 
                   
     -----For DiagnosesIAndII-----                                              
  SELECT  ''DiagnosesIAndII'' AS TableName,                                                                                                                  
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
  ,D.RowIdentifier                                                                               
  ,D.CreatedBy                                                                      
  ,D.CreatedDate                                            
  ,D.ModifiedBy                           
  ,D.ModifiedDate                                                                                                                  
  ,D.RecordDeleted                                                                                      
  ,D.DeletedDate                                                                                                                  
  ,D.DeletedBy                                                                                             
  ,DSM.DSMDescription                                                                                                             
   FROM DiagnosesIAndII  D                                                                                                      
  inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                                                                                                      
  and DSM.DSMNumber = D.DSMNumber                                            
   WHERE                                                     
  DocumentVersionId=@LatestDocumentVersionID   AND ISNULL(RecordDeleted,''N'')=''N''                 
                     
                  
End
' 
END
GO
