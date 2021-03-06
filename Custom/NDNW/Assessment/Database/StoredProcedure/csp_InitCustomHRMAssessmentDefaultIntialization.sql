IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_InitCustomHRMAssessmentDefaultIntialization')
	BEGIN
		DROP  Procedure  csp_InitCustomHRMAssessmentDefaultIntialization --139,'','','I','',444,'',1
	END

GO
Create PROCEDURE [dbo].[csp_InitCustomHRMAssessmentDefaultIntialization] (  
 @ClientID INT  
 ,@AxisIAxisIIOut VARCHAR(100)  
 ,@clientAge VARCHAR(100)  
 --,@DocumentVersionId int                                                            
 ,@AssessmentType CHAR(1)  
 ,@InitialRequestDate DATETIME  
 ,@LatestDocumentVersionID INT  
 ,@ClientDOB VARCHAR(50)  
 ,@CurrentAuthorId INT  
 )  
AS  
/*********************************************************************/  
/* Stored Procedure: [csp_InitCustomHRMAssessmentDefaultIntialization]   */  
/* Copyright: 2006 Streamline SmartCare            */  
/* Purpose: To Initialize CustomPAAssessments Documents        */  
/* Input Parameters: @ClientID, @AxisIAxisIIOut, @clientAge,@DocumentVersionId,@AssessmentType    eg:- 14309,92,'N'    */  
/* Output Parameters:                 */  
/* Return:          */  
/* Called By:CustomDocuments Class Of DataService          */  
/* Calls:                    */  
/*                      */  
/* Data Modifications:                 */  
/*         */  
/*   Updates:                  */  
/*   Date              Author                Purpose      */  

/*********************************************************************/  
--- CustomHRMAssessments --                                                                                                                                     
BEGIN  
 BEGIN TRY  
  DECLARE @ClientHasGuardian CHAR(1) = NULL
  DECLARE @GuardianName VARCHAR(150) = NULL
  DECLARE @GuardianAddress VARCHAR(100) = NULL
  DECLARE @ClientContactId INT = NULL
  declare @MaritalStatus varchar(100)                                                                                                            
declare @GamblingEmploymentStatus varchar(100)   

  IF EXISTS(SELECT * FROM ClientContacts WHERE ClientId = @ClientID and isnull(Guardian,'N') = 'Y' and isnull(Active,'N') = 'Y')
  BEGIN
	SET @ClientHasGuardian = 'Y'	
	SELECT TOP 1 @ClientContactId = ClientContactId FROM ClientContacts WHERE ClientId = @ClientID AND ISNULL(Guardian,'N') = 'Y' AND ISNULL(Active,'N') = 'Y' AND ISNULL(RecordDeleted,'N') = 'N' ORDER BY ModifiedDate DESC
	IF @ClientContactId IS NOT NULL
	BEGIN
		SELECT TOP 1 @GuardianName = ListAs FROM ClientContacts WHERE ClientContactId = @ClientContactId
		SELECT TOP 1 @GuardianAddress = Display FROM ClientContactAddresses WHERE ClientContactId = @ClientContactId
	END
  END
  --if(@AssessmentType='')                                                      
  --set @AssessmentType=null                  
  DECLARE @ClientAgeNum VARCHAR(50)  
  
  SELECT @MaritalStatus=dbo.csf_GetGlobalCodeNameById(c.MaritalStatus) 
  ,@GamblingEmploymentStatus=dbo.csf_GetGlobalCodeNameById(c.EmploymentStatus) 
  FROM Clients C  
  WHERE C.ClientId =@ClientID   
   AND isnull(C.RecordDeleted, 'N') = 'N'
   
  SET @ClientAgeNum = Substring(@clientAge, 1, CHARINDEX(' ', @clientAge))  
  
  DECLARE @CafasURL VARCHAR(1024)  
  
  SET @CafasURL = (  
    SELECT CafasURL  
    FROM CustomConfigurations  
    )  
  
  --Added by Rakesh w.rf to task 135 in General Implementation Initialize the Inquiry Disposition Comments field from the last completed Inquiry. Only for Screen and Initial Assessment types              
  DECLARE @DispostionComment AS VARCHAR(max)  
  DECLARE @PresentingProblem AS VARCHAR(max)  
  DECLARE @AccomationNeeded AS VARCHAR(10)  
  DECLARE @AccomationNeededInquiryValues VARCHAR(200)  
  DECLARE @LatestScreeenTypeDocumentVersionId AS INT  
  DECLARE @ReferralSubType AS INT  
  DECLARE @Living AS INT  
  DECLARE @EmploymentStatus AS INT  
  DECLARE @HASGUARDIAN AS VARCHAR(10)
  DECLARE @GUARDIANAME AS VARCHAR(100)
  DECLARE @GUARDIANNADDRESS AS VARCHAR(max)
  DECLARE @REFERRALSOURCE INT
  DECLARE @CONTACTID INT
  DECLARE @CLIENTPHONE VARCHAR(500)
  DECLARE @CurrentLiving INT
  DECLARE @EmpStatus INT
  DECLARE @PrimaryPhysicianID INT 
  DECLARE @INQUIRYDATE DATETIME
  DECLARE @REGISTRATIONDATE DATETIME
  DECLARE @PrimaryPhysician VARCHAR(500)
 Select 
@CurrentLiving = livingArrangement,
@EmpStatus = EmploymentStatus,
@PrimaryPhysicianID=PrimaryPhysicianId
From Clients where ClientId=@ClientID

select @PrimaryPhysician = isnull(LastName,'') + case when LastName is not null then  ', ' else '' end + isnull(FirstName,'')  
from Staff where Staffid=@PrimaryPhysicianID

  select top 1 
 @GUARDIANAME= isnull(CC.LastName,'') + case when LastName is not null then  ', ' else '' end +isnull(CC.FirstName,''),
 @HASGUARDIAN = CC.Guardian,
 @GUARDIANNADDRESS=CCA.Display,
--CCA.Address,
--CCA.City,
 @CONTACTID=CC.ClientContactId
from 
clientcontacts CC join
ClientContactsAddressHistory CCA on CC.ClientContactId=CCA.ClientContactId
where CC.ClientId=@ClientID and Isnull(CC.Guardian,'N')='Y' Order By CC.modifieddate DESC
  IF (@CONTACTID IS NOT NULL)
  BEGIN
  SET @CLIENTPHONE=(SELECT TOP ( 1 )  
                        PhoneNumber  
              FROM      ClientContactPhones  
              WHERE     ( ClientContactId = @CONTACTID )  
                        AND ( PhoneNumber IS NOT NULL )  
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' )  
              ORDER BY  PhoneType)
              
              END
              
    SELECT TOP 1 @REFERRALSOURCE = CR.ReferralType,
    @REGISTRATIONDATE=d.EffectiveDate
    FROM CustomDocumentRegistrations CR  
    INNER JOIN Documents d ON CR.DocumentVersionId = d.CurrentDocumentVersionId  
     AND d.ClientId = @ClientID  
     AND Isnull(d.RecordDeleted, 'N') = 'N'  
     AND Isnull(CR.RecordDeleted, 'N') = 'N'  
     AND d.[Status] = 22  
     AND d.DocumentCodeId = 10500  Order by d.CurrentDocumentVersionId desc
     
    IF @REGISTRATIONDATE IS NOT NULL
    BEGIN
		Select top 1 @INQUIRYDATE = InquiryStartDateTime from CustomInquiries where cast(Createddate as Date)<=cast(@REGISTRATIONDATE as Date) AND ClientId = @ClientID
		order by  Createddate Desc
	END
	
 SELECT @REFERRALSOURCE = ReferralType 
   FROM ClientEpisodes CE  
   INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]  
   WHERE ClientId = @ClientID  
    AND ISNULL(CE.RecordDeleted, 'N') = 'N'  
    AND CE.DischargeDate IS NULL  
    AND GC.GlobalCodeId IN (  
     100  
     ,101  
     )  
  IF (  
    @AssessmentType = 'I'  
    OR @AssessmentType = 'S'  
    )  
  BEGIN  
   SELECT TOP 1 @DispostionComment = CI.DispositionComment  
    ,@PresentingProblem = CI.PresentingProblem  
    ,@AccomationNeeded = CI.AccomodationNeeded  
    ,@ReferralSubType = ReferralSubtype  
    ,@Living = Living  
    ,@EmploymentStatus = EmploymentStatus  
   FROM CustomInquiries CI  
   LEFT JOIN GlobalCodes gc ON CI.InquiryStatus = gc.GlobalCodeId  
   WHERE CI.ClientId = @ClientID  
    AND ISNULL(CI.RecordDeleted, 'N') = 'N'  
    AND gc.Category = 'XINQUIRYSTATUS'  
    AND gc.CodeName = 'COMPLETE'  
   ORDER BY InquiryId DESC --Get DispositionComment For Last Completed Inquiry               
  
   IF (@AccomationNeeded IS NOT NULL)  
   BEGIN  
    SELECT @AccomationNeededInquiryValues = COALESCE(@AccomationNeededInquiryValues + ', ', '') + CASE   
      WHEN item = 0  
       THEN 'Interpreter'  
      WHEN item = 1  
       THEN 'Reading Assistance'  
      WHEN item = 2  
       THEN 'Sign Language'  
      END  
    FROM dbo.fnSplit(@AccomationNeeded, ',') -- Need to hardocode values as in database only 0,1,2 values saves for this & there is no globalcodeId for this              
  
    SET @AccomationNeededInquiryValues = 'Accommodation Needed-' + @AccomationNeededInquiryValues  
   END  
  
   --End               
   -- Get Registration date for Current Episode with Status Registrer or In treatment              
   --if (@AssessmentType = 'I' or @AssessmentType = 'S')              
   --begin              
   DECLARE @EpsiodeRegistrationDate AS DATETIME  
   DECLARE  @SameEpisode char(1)
   DECLARE @PrevEffectiveDate AS DateTime
   SELECT @EpsiodeRegistrationDate = CE.RegistrationDate  
   FROM ClientEpisodes CE  
   INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.[Status]  
   WHERE ClientId = @ClientID  
    AND ISNULL(CE.RecordDeleted, 'N') = 'N'  
    AND CE.DischargeDate IS NULL  
    AND GC.GlobalCodeId IN (  
     100  
     ,101  
     )  
   -- Select the latest document version Id for previous signeed Screen type assessment before Client Episiode registration              
   --IF (@EpsiodeRegistrationDate IS NOT NULL)  
   --BEGIN  
    SELECT TOP 1 @LatestScreeenTypeDocumentVersionId = d.CurrentDocumentVersionId 
    ,@PrevEffectiveDate=d.EffectiveDate
    FROM CustomHRMAssessments CHA  
    INNER JOIN Documents d ON CHA.DocumentVersionId = d.CurrentDocumentVersionId  
     AND d.ClientId = @ClientID  
     AND Isnull(d.RecordDeleted, 'N') = 'N'  
     AND Isnull(CHA.RecordDeleted, 'N') = 'N'  
     --AND CHA.AssessmentType = 'S'  
     AND d.[Status] = 22  
     AND d.DocumentCodeId = 10018  Order by d.CurrentDocumentVersionId desc
     --AND d.EffectiveDate <= @EpsiodeRegistrationDate  
   --END  
  END  
    IF(@EpsiodeRegistrationDate IS NOT NULL and @EpsiodeRegistrationDate <=@PrevEffectiveDate)
    SET @SameEpisode='Y'

  --Changes End here              
  DECLARE @ExistLatestSignedDocumentVersion CHAR  
  
  IF (@LatestDocumentVersionID > 0)  
   SET @ExistLatestSignedDocumentVersion = 'Y'  
  ELSE  
   SET @ExistLatestSignedDocumentVersion = 'N'  
  
--  IF (  
--    (  
--     @AssessmentType = 'I'  
--     OR @AssessmentType = 'S'  
--     )  
--    AND @LatestScreeenTypeDocumentVersionId > 0  
--    )  
--  BEGIN  
--   SELECT 'CustomHRMAssessments' AS TableName  
--     ,- 1 AS 'DocumentVersionId'  
--    ,[ClientName]  
--    ,@AssessmentType AS [AssessmentType]  
--    -- ,getdate() as [CurrentAssessmentDate]                                                                                                                                    
--    ,[PreviousAssessmentDate]  
--    ,@ClientDOB AS [ClientDOB]  
--    ,CASE   
--     WHEN @ClientAgeNum >= 18  
--      THEN 'A'  
--     ELSE 'C'  
--     END AS [AdultOrChild]  
--    ,[ChildHasNoParentalConsent]  
--    ,CASE WHEN @HASGUARDIAN='Y' THEN @HASGUARDIAN ELSE NULL END AS [ClientHasGuardian]  
--    ,CASE WHEN @GUARDIANAME IS NOT NULL THEN @GUARDIANAME  ELSE NULL END AS [GuardianName]
--    ,CASE WHEN @GUARDIANAME IS NOT NULL THEN @GUARDIANADDRESS  ELSE NULL END AS [GuardianAddress]  
--    ,CASE WHEN @CLIENTPHONE IS NOT NULL THEN @CLIENTPHONE ELSE NULL END AS [GuardianPhone]  
--    ,[GuardianType]  
--    ,[ClientInDDPopulation]                                                                                                                                    
--    ,[ClientInSAPopulation]                                                                                                    
--    ,[ClientInMHPopulation]     
--    ,[PreviousDiagnosisText]  
--    ,CASE WHEN @REFERRALSOURCE IS NOT NULL THEN @REFERRALSOURCE ELSE NULL END AS  [ReferralType]  
--    ,CASE WHEN  @SameEpisode='Y' THEN PresentingProblem ELSE '' END AS [PresentingProblem] 
--    ,CASE WHEN @CurrentLiving IS NOT NULL THEN @CurrentLiving ELSE NULL END AS [CurrentLivingArrangement]  
--    ,CASE WHEN @PrimaryPhysician IS NOT NULL THEN @PrimaryPhysician ELSE NULL END AS [CurrentPrimaryCarePhysician]  
--    --,[CurrentPrimaryCarePhysician]
--    ,[ReasonForUpdate]  
--    ,'N' AS DxTabDisabled  
--    ,CASE WHEN  @SameEpisode='Y' THEN DesiredOutcomes ELSE '' END AS [DesiredOutcomes] 
--    ,[PsMedicationsComment]  
--    ,AutisticallyImpaired  
--,CognitivelyImpaired  
--,EmotionallyImpaired  
--,BehavioralConcern  
--,LearningDisabilities  
--,PhysicalImpaired  
--,IEP  
--,ChallengesBarrier  
--,UnProtectedSexualRelationMoreThenOnePartner  
--,SexualRelationWithHIVInfected  
--,SexualRelationWithDrugInject  
--,InjectsDrugsSharedNeedle  
--,ReceivedAnyFavorsForSexualRelation  
--,FamilyFriendFeelingsCausedDistress  
--,FeltNervousAnxious  
--,NotAbleToStopWorrying  
--,StressPeoblemForHandlingThing  
--,SocialAndEmotionalNeed  
--,ReceivePrenatalCare  
--,ProblemInPregnancy  
--,SexualityComment  
--,PrenatalExposer  
--,WhereMedicationUsed  
--,IssueWithDelivery  
--,ChildDevelopmentalMilestones  
--,WhenTheyWalk  
--,TalkBefore  
--,WhenTheyTalk  
--,WhenTheyTalkSentences  
  
  
--,ParentChildRelationshipIssue  
--    ,[PsEducationComment]  
--    ,[IncludeFunctionalAssessment]  
--    ,[IncludeSymptomChecklist]  
--    ,[IncludeUNCOPE]  
--    ,[ClientIsAppropriateForTreatment]  
--    ,[SecondOpinionNoticeProvided]  
--    ,[TreatmentNarrative]  
--    ,[RapCiDomainIntensity]  
--    ,[RapCbDomainIntensity]  
--    ,[RapCaDomainIntensity]  
--    ,[RapHhcDomainIntensity]  
--    ,[OutsideReferralsGiven]  
--    ,[ReferralsNarrative]  
--    ,[ServiceOther]  
--    ,[ServiceOtherDescription]  
--    ,[AssessmentAddtionalInformation]  
--    ,CASE WHEN  @SameEpisode='Y' THEN TreatmentAccomodation ELSE '' END AS [TreatmentAccomodation] 
--    ,[Participants]  
--    ,[Facilitator]  
--    ,[TimeLocation]  
--    ,[AssessmentsNeeded]  
--    ,[CommunicationAccomodations]  
--    ,[IssuesToAvoid]  
--    ,[IssuesToDiscuss]  
--    ,[SourceOfPrePlanningInfo]  
--    ,[SelfDeterminationDesired]  
--    ,[FiscalIntermediaryDesired]  
--    ,[PamphletGiven]  
--    ,[PamphletDiscussed]  
--    ,[PrePlanIndependentFacilitatorDiscussed]  
--    ,[PrePlanIndependentFacilitatorDesired]  
--    ,[PrePlanGuardianContacted]  
--    ,[CommunityActivitiesCurrentDesired]  
--    ,[CommunityActivitiesIncreaseDesired]  
--    ,[CommunityActivitiesNeedsList]  
--    ,[PsCurrentHealthIssues]  
--    ,[PsCurrentHealthIssuesComment]  
--    --,[PsCurrentHealthIssuesNeedsList]  
--    ,PsMedicationsSideEffects  
--    ,[HistMentalHealthTx]  
--    ,[HistMentalHealthTxComment]  
--    ,[HistFamilyMentalHealthTx]  
--    ,[HistFamilyMentalHealthTxComment]  
--    ,[PsClientAbuseIssues]  
--    ,[PsClientAbuesIssuesComment]  
--    ,[PsClientAbuseIssuesNeedsList]  
--    ,[PsDevelopmentalMilestones]  
--    ,[PsDevelopmentalMilestonesComment]  
--    ,[PsDevelopmentalMilestonesNeedsList]  
--    ,[PsChildEnvironmentalFactors]  
--    ,[PsChildEnvironmentalFactorsComment]  
--    ,[PsChildEnvironmentalFactorsNeedsList]  
--    ,[PsLanguageFunctioning]  
--    ,[PsLanguageFunctioningComment]  
--    ,[PsLanguageFunctioningNeedsList]  
--    ,[PsVisualFunctioning]  
--    ,[PsVisualFunctioningComment]  
--    ,[PsVisualFunctioningNeedsList]  
--    ,[PsPrenatalExposure]  
--    ,[PsPrenatalExposureComment]  
--    ,[PsPrenatalExposureNeedsList]  
--    ,[PsChildMentalHealthHistory]  
--    ,[PsChildMentalHealthHistoryComment]  
--    ,[PsChildMentalHealthHistoryNeedsList]  
--    ,[PsIntellectualFunctioning]  
--    ,[PsIntellectualFunctioningComment]  
--    ,[PsIntellectualFunctioningNeedsList]  
--    ,[PsLearningAbility]  
--    ,[PsLearningAbilityComment]  
--    ,[PsLearningAbilityNeedsList]  
--    ,[PsPeerInteraction]  
--    ,[PsPeerInteractionComment]  
--    ,[PsPeerInteractionNeedsList]  
--    ,case when @SameEpisode='Y' then PsParentalParticipation else '' end as [PsParentalParticipation]  
--    ,case when @SameEpisode='Y' then FamilyRelationshipIssues else '' end as FamilyRelationshipIssues
--    ,[PsParentalParticipationComment]  
--    ,[PsParentalParticipationNeedsList]  
--    ,[PsSchoolHistory]  
--    ,[PsSchoolHistoryComment]  
--    ,[PsSchoolHistoryNeedsList]  
--    ,[PsImmunizations]  
--    ,[PsImmunizationsComment]  
--    ,[PsImmunizationsNeedsList]  
--    ,case when @SameEpisode='Y' then PsChildHousingIssues else null end as [PsChildHousingIssues]  
--    ,[PsChildHousingIssuesComment]  
--    ,[PsChildHousingIssuesNeedsList]  
--    ,[PsSexuality]  
--    ,[PsSexualityComment]  
--    ,[PsSexualityNeedsList]  
--    ,[PsFamilyFunctioning]  
--    ,[PsFamilyFunctioningComment]  
--    ,[PsFamilyFunctioningNeedsList]  
--    ,[PsTraumaticIncident]  
--    ,[PsTraumaticIncidentComment]  
--    ,[PsTraumaticIncidentNeedsList]  
--    ,[HistDevelopmental]  
--    ,[HistDevelopmentalComment]  
--    ,[HistResidential]  
--    ,[HistResidentialComment]  
--    ,[HistOccupational]  
--    ,[HistOccupationalComment]  
--    ,[HistLegalFinancial]  
--    ,[HistLegalFinancialComment]  
--    ,[SignificantEventsPastYear]  
--    ,[PsGrossFineMotor]  
--    ,[PsGrossFineMotorComment]  
--    ,[PsGrossFineMotorNeedsList]  
--    ,[PsSensoryPerceptual]  
--    ,[PsSensoryPerceptualComment]  
--    ,[PsSensoryPerceptualNeedsList]  
--    ,[PsCognitiveFunction]  
--    ,[PsCognitiveFunctionComment]  
--    ,[PsCognitiveFunctionNeedsList]  
--    ,[PsCommunicativeFunction]  
--    ,[PsCommunicativeFunctionComment]  
--    ,[PsCommunicativeFunctionNeedsList]  
--    ,[PsCurrentPsychoSocialFunctiion]  
--    ,[PsCurrentPsychoSocialFunctiionComment]  
--    ,[PsCurrentPsychoSocialFunctiionNeedsList]  
--    ,[PsAdaptiveEquipment]  
--    ,[PsAdaptiveEquipmentComment]  
--    ,[PsAdaptiveEquipmentNeedsList]  
--    ,[PsSafetyMobilityHome]  
--    ,[PsSafetyMobilityHomeComment]  
--    ,[PsSafetyMobilityHomeNeedsList]  
--    ,[PsHealthSafetyChecklistComplete]  
--    ,[PsAccessibilityIssues]  
--    ,[PsAccessibilityIssuesComment]  
--    ,[PsAccessibilityIssuesNeedsList]  
--    ,[PsEvacuationTraining]  
--    ,[PsEvacuationTrainingComment]  
--    ,[PsEvacuationTrainingNeedsList]  
--    ,[Ps24HourSetting]  
--    ,[Ps24HourSettingComment]  
--    ,[Ps24HourSettingNeedsList]  
--    ,[Ps24HourNeedsAwakeSupervision]  
--    ,[PsSpecialEdEligibility]  
--    ,[PsSpecialEdEligibilityComment]  
--    ,[PsSpecialEdEligibilityNeedsList]  
--    ,[PsSpecialEdEnrolled]  
--    ,[PsSpecialEdEnrolledComment]  
--    ,[PsSpecialEdEnrolledNeedsList]  
--    ,[PsEmployer]  
--    ,[PsEmployerComment]  
--    ,[PsEmployerNeedsList]  
--    ,[PsEmploymentIssues]  
--    ,[PsEmploymentIssuesComment]  
--    ,[PsEmploymentIssuesNeedsList]  
--    ,[PsRestrictionsOccupational]  
--    ,[PsRestrictionsOccupationalComment]  
--    ,[PsRestrictionsOccupationalNeedsList]  
--    ,[PsFunctionalAssessmentNeeded]  
--    ,[PsAdvocacyNeeded]  
--    ,[PsPlanDevelopmentNeeded]  
--    ,[PsLinkingNeeded]  
--    ,[PsDDInformationProvidedBy]  
--    ,[HistPreviousDx]  
--    ,[HistPreviousDxComment]  
--    ,[PsLegalIssues]  
--    ,[PsLegalIssuesComment]  
--    ,[PsLegalIssuesNeedsList]  
--    ,[PsCulturalEthnicIssues]  
--    ,[PsCulturalEthnicIssuesComment]  
--    ,[PsCulturalEthnicIssuesNeedsList]  
--    ,[PsSpiritualityIssues]  
--    ,[PsSpiritualityIssuesComment]  
--    ,[PsSpiritualityIssuesNeedsList]  
--    ,[SuicideNotPresent]  
--    ,[SuicideIdeation]  
--    ,[SuicideActive]  
--    ,[SuicidePassive]  
--    ,[SuicideMeans]  
--    ,[SuicidePlan]  
--    ,[SuicidePriorAttempt]  
--    ,[SuicideNeedsList]  
--    ,[SuicideBehaviorsPastHistory]  
--    ,[SuicideOtherRiskSelf]  
--    ,[SuicideOtherRiskSelfComment]  
--    ,[HomicideNotPresent]  
--    ,[HomicideIdeation]  
--    ,[HomicideActive]  
--    ,[HomicidePassive]  
--    ,[HomicideMeans]  
--    ,[HomicidePlan]  
--    ,[HomicidePriorAttempt]  
--    ,[HomicideNeedsList]  
--    ,[HomicideBehaviorsPastHistory]  
--    ,[HomicdeOtherRiskOthers]  
--    ,[HomicideOtherRiskOthersComment]  
--    ,[PhysicalAgressionNotPresent]  
--    ,[PhysicalAgressionSelf]  
--    ,[PhysicalAgressionOthers]  
--    ,[PhysicalAgressionCurrentIssue]  
--    ,[PhysicalAgressionNeedsList]  
--    ,[PhysicalAgressionBehaviorsPastHistory]  
--    ,[RiskAccessToWeapons]  
--    ,[RiskAppropriateForAdditionalScreening]  
--    ,[RiskClinicalIntervention]  
--    ,[RiskOtherFactors]  
--    ,[StaffAxisV]  
--    ,[StaffAxisVReason]  
--    ,[ClientStrengthsNarrative]  
--    ,[CrisisPlanningClientHasPlan]  
--    ,[CrisisPlanningNarrative]  
--    ,[CrisisPlanningDesired]  
--    ,[CrisisPlanningNeedsList]  
--    ,[CrisisPlanningMoreInfo]  
--    ,[AdvanceDirectiveClientHasDirective]  
--    ,[AdvanceDirectiveDesired]  
--    ,[AdvanceDirectiveNarrative]  
--    ,[AdvanceDirectiveNeedsList]  
--    ,[AdvanceDirectiveMoreInfo]  
--    ,[NaturalSupportSufficiency]  
--    ,[NaturalSupportNeedsList]  
--    ,[NaturalSupportIncreaseDesired]  
--    ,CASE WHEN  @SameEpisode='Y' THEN ClinicalSummary ELSE '' END AS [ClinicalSummary] 
--    ,[UncopeQuestionU]  
--    ,[UncopeApplicable]  
--    ,[UncopeApplicableReason]  
--    ,[UncopeQuestionN]  
--    ,[UncopeQuestionC]  
--    ,[UncopeQuestionO]  
--    ,[UncopeQuestionP]  
--    ,[UncopeQuestionE]  
--    ,[SubstanceUseNeedsList]  
--    ,[DecreaseSymptomsNeedsList]  
--    ,[DDEPreviouslyMet]  
--    ,[DDAttributableMentalPhysicalLimitation]  
--    ,[DDDxAxisI]  
--    ,[DDDxAxisII]  
--    ,[DDDxAxisIII]  
--    ,[DDDxAxisIV]  
--    ,[DDDxAxisV]  
--    ,[DDDxSource]  
--    ,[DDManifestBeforeAge22]  
--    ,[DDContinueIndefinitely]  
--    ,[DDLimitSelfCare]  
--    ,[DDLimitLanguage]  
--    ,[DDLimitLearning]  
--    ,[DDLimitMobility]  
--    ,[DDLimitSelfDirection]  
--    ,[DDLimitEconomic]  
--    ,[DDLimitIndependentLiving]  
--    ,[DDNeedMulitpleSupports]  
--    ,[CAFASDate]  
--    ,[RaterClinician]  
--    ,[CAFASInterval]  
--    ,[SchoolPerformance]  
--    ,[SchoolPerformanceComment]  
--    ,[HomePerformance]  
--    ,[HomePerfomanceComment]  
--    ,[CommunityPerformance]  
--    ,[CommunityPerformanceComment]  
--    ,[BehaviorTowardsOther]  
--    ,[BehaviorTowardsOtherComment]  
--    ,[MoodsEmotion]  
--    ,[MoodsEmotionComment]  
--    ,[SelfHarmfulBehavior]  
--    ,[SelfHarmfulBehaviorComment]  
--    ,[SubstanceUse]  
--    ,[SubstanceUseComment]  
--    ,[Thinkng]  
--    ,[ThinkngComment]  
--    ,[PrimaryFamilyMaterialNeeds]  
--    ,[PrimaryFamilyMaterialNeedsComment]  
--    ,[PrimaryFamilySocialSupport]  
--    ,[PrimaryFamilySocialSupportComment]  
--    ,[NonCustodialMaterialNeeds]  
--    ,[NonCustodialMaterialNeedsComment]  
--    ,[NonCustodialSocialSupport]  
--    ,[NonCustodialSocialSupportComment]  
--    ,[SurrogateMaterialNeeds]  
--    ,[SurrogateMaterialNeedsComment]  
--    ,[SurrogateSocialSupport]  
--    ,[SurrogateSocialSupportComment]  
--    ,[DischargeCriteria]  
--    ,[PrePlanFiscalIntermediaryComment]  
--    ,[StageOfChange]  
--    ,[PsEducation]  
--    ,[PsEducationNeedsList]  
--    ,[PsMedications]  
--    ,[PsMedicationsNeedsList]  
--    ,[PsMedicationsNeedsList]  
--    ,[PhysicalConditionQuadriplegic]  
--    ,[PhysicalConditionMultipleSclerosis]  
--    ,[PhysicalConditionBlindness]  
--    ,[PhysicalConditionDeafness]  
--    ,[PhysicalConditionParaplegic]  
--    ,[PhysicalConditionCerebral]  
--    ,[PhysicalConditionMuteness]  
--    ,[PhysicalConditionOtherHearingImpairment]  
--    ,[TestingReportsReviewed]  
--    ,[LOCId]  
--    ,[PreplanSeparateDocument]  
--    ,[UncopeCompleteFullSUAssessment]  
--    ,SevereProfoundDisability  
--    ,SevereProfoundDisabilityComment  
--    ,CASE WHEN @EmpStatus IS NOT NULL THEN @EmpStatus ELSE NULL END AS EmploymentStatus  
--    ,@CafasURL AS CafasURL  
--    --Below columns are missing added by Rakesh w.rf to task 159 in  General Implementation              
--    ,case when @SameEpisode='Y' then PsRiskLossOfPlacement else '' end as  PsRiskLossOfPlacement
--    ,case when @SameEpisode='Y' then PsRiskLossOfSupport else '' end as PsRiskLossOfSupport  
--    ,case when @SameEpisode='Y' then PsRiskExpulsionFromSchool else '' end as PsRiskExpulsionFromSchool  
--    ,case when @SameEpisode='Y' then PsRiskHospitalization else '' end as PsRiskHospitalization  
--    ,case when @SameEpisode='Y' then PsRiskCriminalJusticeSystem else '' end as PsRiskCriminalJusticeSystem  
--    ,case when @SameEpisode='Y' then PsRiskElopementFromHome else '' end as PsRiskElopementFromHome  
--    ,case when @SameEpisode='Y' then PsRiskLossOfFinancialStatus else '' end as PsRiskLossOfFinancialStatus  
--    ,case when @SameEpisode='Y' then PsRiskLossOfPlacementDueTo else '' end as PsRiskLossOfPlacementDueTo  
--    ,case when @SameEpisode='Y' then PsRiskLossOfSupportDueTo else '' end as PsRiskLossOfSupportDueTo  
--    ,case when @SameEpisode='Y' then PsRiskExpulsionFromSchoolDueTo else '' end as PsRiskExpulsionFromSchoolDueTo  
--    ,case when @SameEpisode='Y' then PsRiskHospitalizationDueTo else '' end as PsRiskHospitalizationDueTo  
--    ,case when @SameEpisode='Y' then PsRiskCriminalJusticeSystemDueTo else '' end as PsRiskCriminalJusticeSystemDueTo  
--    ,case when @SameEpisode='Y' then PsRiskElopementFromHomeDueTo else '' end as PsRiskElopementFromHomeDueTo  
--    ,case when @SameEpisode='Y' then PsRiskLossOfFinancialStatusDueTo else '' end as PsRiskLossOfFinancialStatusDueTo  
--    ,case when @SameEpisode='Y' then PsFamilyConcernsComment else '' end as PsFamilyConcernsComment  
--    ,PsFunctioningConcernComment  
--    -- End here                                                                                                                        
--    --,newid() AS [RowIdentifier]  
--    ,'' AS [CreatedBy]  
--    ,getdate() AS [CreatedDate]  
--    ,'' AS [ModifiedBy]  
--    ,getdate() AS [ModifiedDate]  
--    ,CHA.[RecordDeleted]  
--    ,CHA.[DeletedDate]  
--    ,CHA.[DeletedBy]  
--    ,@AxisIAxisIIOut AS AxisIAxisII  
--    ,@clientAge AS clientAge  
--    ,CASE WHEN @INQUIRYDATE IS NOT NULL THEN @INQUIRYDATE ELSE NULL END AS InitialRequestDate  
--    ,@ExistLatestSignedDocumentVersion AS ExistLatestSignedDocumentVersion  
--    ,ClientInAutsimPopulation
--	,CASE WHEN  @SameEpisode='Y' THEN LegalIssues ELSE '' END AS [LegalIssues]
--	,CSSRSAdultOrChild  
--	,CASE WHEN  @SameEpisode='Y' THEN Strengths ELSE '' END AS [Strengths]
--	,CASE WHEN  @SameEpisode='Y' THEN TransitionLevelOfCare ELSE '' END AS [TransitionLevelOfCare] 
--	,CASE WHEN  @SameEpisode='Y' THEN ReductionInSymptoms ELSE '' END AS [ReductionInSymptoms] 
--	,CASE WHEN  @SameEpisode='Y' THEN AttainmentOfHigherFunctioning ELSE '' END AS [AttainmentOfHigherFunctioning] 
--	,CASE WHEN  @SameEpisode='Y' THEN TreatmentNotNecessary ELSE '' END AS [TreatmentNotNecessary] 
--	,CASE WHEN  @SameEpisode='Y' THEN OtherTransitionCriteria ELSE '' END AS [OtherTransitionCriteria] 
--	,CASE WHEN  @SameEpisode='Y' THEN EstimatedDischargeDate ELSE '' END AS [EstimatedDischargeDate] 
--	,ReductionInSymptomsDescription
--	,AttainmentOfHigherFunctioningDescription
--	,TreatmentNotNecessaryDescription
--	,OtherTransitionCriteriaDescription 
--   FROM CustomHRMAssessments CHA  
--   WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
--  END  
--  ELSE  
--  BEGIN  
   SELECT 'CustomHRMAssessments' AS TableName  
       ,- 1 AS 'DocumentVersionId'  
    ,[ClientName]  
    ,@AssessmentType AS [AssessmentType]  
    ,[CurrentAssessmentDate]  
    ,[PreviousAssessmentDate]  
    ,@ClientDOB AS [ClientDOB]  
    ,CASE   
     WHEN @ClientAgeNum >= 18  
      THEN 'A'  
     ELSE 'C'  
     END AS [AdultOrChild]  
    ,[ChildHasNoParentalConsent]  
    ,@ClientHasGuardian AS ClientHasGuardian
    ,@GuardianName AS GuardianName 
    ,@GuardianAddress AS GuardianAddress
    ,CASE WHEN @CLIENTPHONE IS NOT NULL THEN @CLIENTPHONE ELSE NULL END AS [GuardianPhone]  
    ,[GuardianType]  
    ,[ClientInDDPopulation]  
    ,[ClientInSAPopulation]  
    ,[ClientInMHPopulation]  
    ,[PreviousDiagnosisText]  
      ,CASE WHEN @REFERRALSOURCE IS NOT NULL THEN @REFERRALSOURCE ELSE NULL END AS  [ReferralType]               
    ,CASE WHEN  @SameEpisode='Y' THEN PresentingProblem ELSE NULL END AS [PresentingProblem] 
    ,CASE WHEN @CurrentLiving IS NOT NULL THEN @CurrentLiving ELSE NULL END AS [CurrentLivingArrangement]  
    ,CASE WHEN @PrimaryPhysician IS NOT NULL THEN @PrimaryPhysician ELSE NULL END AS [CurrentPrimaryCarePhysician]  
     
    ,[ReasonForUpdate]  
    ,'N' AS DxTabDisabled  
    ,CASE WHEN  @SameEpisode='Y' THEN DesiredOutcomes ELSE NULL END AS [DesiredOutcomes]  
    ,[PsMedicationsComment]  
    ,AutisticallyImpaired  
,CognitivelyImpaired  
,EmotionallyImpaired  
,BehavioralConcern  
,LearningDisabilities  
,PhysicalImpaired  
,IEP  
,ChallengesBarrier  
,UnProtectedSexualRelationMoreThenOnePartner  
,SexualRelationWithHIVInfected  
,SexualRelationWithDrugInject  
,InjectsDrugsSharedNeedle  
,ReceivedAnyFavorsForSexualRelation  
,FamilyFriendFeelingsCausedDistress  
,FeltNervousAnxious  
,NotAbleToStopWorrying  
,StressPeoblemForHandlingThing  
,SocialAndEmotionalNeed  
,ReceivePrenatalCare  
,ProblemInPregnancy  
,SexualityComment  
,PrenatalExposer  
,WhereMedicationUsed  
,IssueWithDelivery  
,ChildDevelopmentalMilestones  
,WhenTheyWalk  
,TalkBefore  
,WhenTheyTalk  
,WhenTheyTalkSentences  
  
  
,ParentChildRelationshipIssue  
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
    --,[TreatmentAccomodation]                                                                                                                                    
    ,CASE WHEN  @SameEpisode='Y' THEN TreatmentAccomodation ELSE NULL END AS [TreatmentAccomodation]              
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
    ,[CommunityActivitiesNeedsList]  
    ,[PsCurrentHealthIssues]  
    ,[PsCurrentHealthIssuesComment]  
    --,[PsCurrentHealthIssuesNeedsList]  
    ,PsMedicationsSideEffects  
    ,[HistMentalHealthTx]  
    ,[HistMentalHealthTxComment]  
    ,[HistFamilyMentalHealthTx]  
    ,[HistFamilyMentalHealthTxComment]  
    ,[PsClientAbuseIssues]  
    ,[PsClientAbuesIssuesComment]  
    ,[PsClientAbuseIssuesNeedsList]  
    ,[PsDevelopmentalMilestones]  
    ,[PsDevelopmentalMilestonesComment]  
    ,[PsDevelopmentalMilestonesNeedsList]  
    ,[PsChildEnvironmentalFactors]  
    ,[PsChildEnvironmentalFactorsComment]  
    ,[PsChildEnvironmentalFactorsNeedsList]  
    ,[PsLanguageFunctioning]  
    ,[PsLanguageFunctioningComment]  
    ,[PsLanguageFunctioningNeedsList]  
    ,[PsVisualFunctioning]  
    ,[PsVisualFunctioningComment]  
    ,[PsVisualFunctioningNeedsList]  
    ,[PsPrenatalExposure]  
    ,[PsPrenatalExposureComment]  
    ,[PsPrenatalExposureNeedsList]  
    ,[PsChildMentalHealthHistory]  
    ,[PsChildMentalHealthHistoryComment]  
    ,[PsChildMentalHealthHistoryNeedsList]  
    ,[PsIntellectualFunctioning]  
    ,[PsIntellectualFunctioningComment]  
    ,[PsIntellectualFunctioningNeedsList]  
    ,[PsLearningAbility]  
    ,[PsLearningAbilityComment]  
    ,[PsLearningAbilityNeedsList]  
    ,[PsPeerInteraction]  
    ,[PsPeerInteractionComment]  
    ,[PsPeerInteractionNeedsList]  
    ,case when @SameEpisode='Y' then PsParentalParticipation ELSE NULL end as [PsParentalParticipation]  
    ,case when @SameEpisode='Y' then FamilyRelationshipIssues ELSE NULL end as FamilyRelationshipIssues
    ,[PsParentalParticipationComment]  
    ,[PsParentalParticipationNeedsList]  
    ,[PsSchoolHistory]  
    ,[PsSchoolHistoryComment]  
    ,[PsSchoolHistoryNeedsList]  
    ,[PsImmunizations]  
    ,[PsImmunizationsComment]  
    ,[PsImmunizationsNeedsList]  
    ,case when @SameEpisode='Y' then PsChildHousingIssues else null end as [PsChildHousingIssues]  
    ,[PsChildHousingIssuesComment]  
    ,[PsChildHousingIssuesNeedsList]  
    ,[PsSexuality]  
    ,[PsSexualityComment]  
    ,[PsSexualityNeedsList]  
    ,[PsFamilyFunctioning]  
    ,[PsFamilyFunctioningComment]  
    ,[PsFamilyFunctioningNeedsList]  
    ,[PsTraumaticIncident]  
    ,[PsTraumaticIncidentComment]  
    ,[PsTraumaticIncidentNeedsList]  
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
    ,[PsGrossFineMotorNeedsList]  
    ,[PsSensoryPerceptual]  
    ,[PsSensoryPerceptualComment]  
    ,[PsSensoryPerceptualNeedsList]  
    ,[PsCognitiveFunction]  
    ,[PsCognitiveFunctionComment]  
    ,[PsCognitiveFunctionNeedsList]  
    ,[PsCommunicativeFunction]  
    ,[PsCommunicativeFunctionComment]  
    ,[PsCommunicativeFunctionNeedsList]  
    ,[PsCurrentPsychoSocialFunctiion]  
    ,[PsCurrentPsychoSocialFunctiionComment]  
    ,[PsCurrentPsychoSocialFunctiionNeedsList]  
    ,[PsAdaptiveEquipment]  
    ,[PsAdaptiveEquipmentComment]  
    ,[PsAdaptiveEquipmentNeedsList]  
    ,[PsSafetyMobilityHome]  
    ,[PsSafetyMobilityHomeComment]  
    ,[PsSafetyMobilityHomeNeedsList]  
    ,[PsHealthSafetyChecklistComplete]  
    ,[PsAccessibilityIssues]  
    ,[PsAccessibilityIssuesComment]  
    ,[PsAccessibilityIssuesNeedsList]  
    ,[PsEvacuationTraining]  
    ,[PsEvacuationTrainingComment]  
    ,[PsEvacuationTrainingNeedsList]  
    ,[Ps24HourSetting]  
    ,[Ps24HourSettingComment]  
    ,[Ps24HourSettingNeedsList]  
    ,[Ps24HourNeedsAwakeSupervision]  
    ,[PsSpecialEdEligibility]  
    ,[PsSpecialEdEligibilityComment]  
    ,[PsSpecialEdEligibilityNeedsList]  
    ,[PsSpecialEdEnrolled]  
    ,[PsSpecialEdEnrolledComment]  
    ,[PsSpecialEdEnrolledNeedsList]  
    ,[PsEmployer]  
    ,[PsEmployerComment]  
    ,[PsEmployerNeedsList]  
    ,[PsEmploymentIssues]  
    ,[PsEmploymentIssuesComment]  
    ,[PsEmploymentIssuesNeedsList]  
    ,[PsRestrictionsOccupational]  
    ,[PsRestrictionsOccupationalComment]  
    ,[PsRestrictionsOccupationalNeedsList]  
    ,[PsFunctionalAssessmentNeeded]  
    ,[PsAdvocacyNeeded]  
    ,[PsPlanDevelopmentNeeded]  
    ,[PsLinkingNeeded]  
    ,[PsDDInformationProvidedBy]  
    ,[HistPreviousDx]  
    ,[HistPreviousDxComment]  
    ,[PsLegalIssues]  
    ,[PsLegalIssuesComment]  
    ,[PsLegalIssuesNeedsList]  
    ,[PsCulturalEthnicIssues]  
    ,[PsCulturalEthnicIssuesComment]  
    ,[PsCulturalEthnicIssuesNeedsList]  
    ,[PsSpiritualityIssues]  
    ,[PsSpiritualityIssuesComment]  
    ,[PsSpiritualityIssuesNeedsList]  
    ,[SuicideNotPresent]  
    ,[SuicideIdeation]  
    ,[SuicideActive]  
    ,[SuicidePassive]  
    ,[SuicideMeans]  
    ,[SuicidePlan]  
    ,[SuicidePriorAttempt]  
    ,[SuicideNeedsList]  
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
    ,[HomicideNeedsList]  
    ,[HomicideBehaviorsPastHistory]  
    ,[HomicdeOtherRiskOthers]  
    ,[HomicideOtherRiskOthersComment]  
    ,[PhysicalAgressionNotPresent]  
    ,[PhysicalAgressionSelf]  
    ,[PhysicalAgressionOthers]  
    ,[PhysicalAgressionCurrentIssue]  
    ,[PhysicalAgressionNeedsList]  
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
    ,[CrisisPlanningNeedsList]  
    ,[CrisisPlanningMoreInfo]  
    ,[AdvanceDirectiveClientHasDirective]  
    ,[AdvanceDirectiveDesired]  
    ,[AdvanceDirectiveNarrative]  
    ,[AdvanceDirectiveNeedsList]  
    ,[AdvanceDirectiveMoreInfo]  
    ,[NaturalSupportSufficiency]  
    ,[NaturalSupportNeedsList]  
    ,[NaturalSupportIncreaseDesired]  
    ,CASE WHEN  @SameEpisode='Y' THEN ClinicalSummary ELSE NULL END AS [ClinicalSummary]  -- Added by Rakesh w.rf to task 135                                                                                                               
    -- ,[ClinicalSummary] Initialize the Inquiry Disposition Comments field from the last completed Inquiry. Only for Screen and Initial Assessment types               
    ,[UncopeQuestionU]  
    ,[UncopeApplicable]  
    ,[UncopeApplicableReason]  
    ,[UncopeQuestionN]  
    ,[UncopeQuestionC]  
    ,[UncopeQuestionO]  
    ,[UncopeQuestionP]  
    ,[UncopeQuestionE]  
    ,[SubstanceUseNeedsList]  
    ,[DecreaseSymptomsNeedsList]  
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
    ,[PsEducationNeedsList]  
    ,[PsMedications]  
    ,[PsMedicationsNeedsList]  
    ,[PsMedicationsNeedsList]  
    ,[PhysicalConditionQuadriplegic]  
    ,[PhysicalConditionMultipleSclerosis]  
    ,[PhysicalConditionBlindness]  
    ,[PhysicalConditionDeafness]  
    ,[PhysicalConditionParaplegic]  
    ,[PhysicalConditionCerebral]  
    ,[PhysicalConditionMuteness]  
    ,[PhysicalConditionOtherHearingImpairment]  
    ,[TestingReportsReviewed]  
    ,[LOCId]  
    ,[PreplanSeparateDocument]  
    ,[UncopeCompleteFullSUAssessment]  
    ,SevereProfoundDisability  
    ,SevereProfoundDisabilityComment  
    ,CASE WHEN @EmpStatus IS NOT NULL THEN @EmpStatus ELSE NULL END AS EmploymentStatus  
    ,@CafasURL AS CafasURL  
    --Below columns are missing added by Rakesh w.rf to task 159 in  General Implementation              
    ,case when @SameEpisode='Y' then PsRiskLossOfPlacement ELSE NULL end as  PsRiskLossOfPlacement
    ,case when @SameEpisode='Y' then PsRiskLossOfSupport ELSE NULL end as PsRiskLossOfSupport  
    ,case when @SameEpisode='Y' then PsRiskExpulsionFromSchool ELSE NULL end as PsRiskExpulsionFromSchool  
    ,case when @SameEpisode='Y' then PsRiskHospitalization ELSE NULL end as PsRiskHospitalization  
    ,case when @SameEpisode='Y' then PsRiskCriminalJusticeSystem ELSE NULL end as PsRiskCriminalJusticeSystem  
    ,case when @SameEpisode='Y' then PsRiskElopementFromHome ELSE NULL end as PsRiskElopementFromHome  
    ,case when @SameEpisode='Y' then PsRiskLossOfFinancialStatus ELSE NULL end as PsRiskLossOfFinancialStatus  
    ,case when @SameEpisode='Y' then PsRiskLossOfPlacementDueTo ELSE NULL end as PsRiskLossOfPlacementDueTo  
    ,case when @SameEpisode='Y' then PsRiskLossOfSupportDueTo ELSE NULL end as PsRiskLossOfSupportDueTo  
    ,case when @SameEpisode='Y' then PsRiskExpulsionFromSchoolDueTo ELSE NULL end as PsRiskExpulsionFromSchoolDueTo  
    ,case when @SameEpisode='Y' then PsRiskHospitalizationDueTo ELSE NULL end as PsRiskHospitalizationDueTo  
    ,case when @SameEpisode='Y' then PsRiskCriminalJusticeSystemDueTo ELSE NULL end as PsRiskCriminalJusticeSystemDueTo  
    ,case when @SameEpisode='Y' then PsRiskElopementFromHomeDueTo ELSE NULL end as PsRiskElopementFromHomeDueTo  
    ,case when @SameEpisode='Y' then PsRiskLossOfFinancialStatusDueTo ELSE NULL end as PsRiskLossOfFinancialStatusDueTo  
    ,case when @SameEpisode='Y' then PsFamilyConcernsComment ELSE NULL end as PsFamilyConcernsComment  
    ,PsFunctioningConcernComment  
    -- End here                                                                                                                        
    --,newid() AS [RowIdentifier]  
    ,'' AS [CreatedBy]  
    ,getdate() AS [CreatedDate]  
    ,'' AS [ModifiedBy]  
    ,getdate() AS [ModifiedDate]  
    ,CHA.[RecordDeleted]  
    ,CHA.[DeletedDate]  
    ,CHA.[DeletedBy]  
    ,@AxisIAxisIIOut AS AxisIAxisII  
    ,@clientAge AS clientAge  
    ,CASE WHEN @INQUIRYDATE IS NOT NULL THEN @INQUIRYDATE ELSE NULL END AS InitialRequestDate  
    ,@ExistLatestSignedDocumentVersion AS ExistLatestSignedDocumentVersion    
   FROM SystemConfigurations AS s  
   LEFT JOIN CustomHRMAssessments CHA ON s.DatabaseVersion = - 1  
 -- END  
  
  --CustomCAFAS2 --               
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- SELECT 'CustomCAFAS2' AS TableName  
  --  ,- 1 AS 'DocumentVersionId'  
  --  ,[CAFASDate]  
  --  ,[RaterClinician]  
  --  ,[CAFASInterval]  
  --  ,0 AS [SchoolPerformance]  
  --  ,[SchoolPerformanceComment]  
  --  ,0 AS [HomePerformance]  
  --  ,[HomePerfomanceComment]  
  --  ,0 AS [CommunityPerformance]  
  --  ,[CommunityPerformanceComment]  
  --  ,0 AS [BehaviorTowardsOther]  
  --  ,[BehaviorTowardsOtherComment]  
  --  ,0 AS [MoodsEmotion]  
  --  ,[MoodsEmotionComment]  
  --  ,0 AS [SelfHarmfulBehavior]  
  --  ,[SelfHarmfulBehaviorComment]  
  --  ,0 AS [SubstanceUse]  
  --  ,[SubstanceUseComment]  
  --  ,0 AS [Thinkng]  
  --  ,[ThinkngComment]  
  --  ,[YouthTotalScore]  
  --  ,0 AS [PrimaryFamilyMaterialNeeds]  
  --  ,[PrimaryFamilyMaterialNeedsComment]  
  --  ,0 AS [PrimaryFamilySocialSupport]  
  --  ,[PrimaryFamilySocialSupportComment]  
  --  ,0 AS [NonCustodialMaterialNeeds]  
  --  ,[NonCustodialMaterialNeedsComment]  
  --  ,0 AS [NonCustodialSocialSupport]  
  --  ,[NonCustodialSocialSupportComment]  
  --  ,0 AS [SurrogateMaterialNeeds]  
  --  ,[SurrogateMaterialNeedsComment]  
  --  ,0 AS [SurrogateSocialSupport]  
  --  ,[SurrogateSocialSupportComment]  
  --  ,CC2.[CreatedDate]  
  --  ,CC2.[CreatedBy]  
  --  ,CC2.[ModifiedDate]  
  --  ,CC2.[ModifiedBy]  
  --  ,CC2.[RecordDeleted]  
  --  ,CC2.[DeletedDate]  
  --  ,CC2.[DeletedBy]  
  -- FROM CustomCAFAS2 CC2  
  -- WHERE CC2.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
   --SELECT 'CustomCAFAS2' AS TableName  
   -- ,- 1 AS 'DocumentVersionId'  
   -- ,[CAFASDate]  
   -- ,[RaterClinician]  
   -- ,[CAFASInterval]  
   -- ,0 AS [SchoolPerformance]  
   -- ,[SchoolPerformanceComment]  
   -- ,0 AS [HomePerformance]  
   -- ,[HomePerfomanceComment]  
   -- ,0 AS [CommunityPerformance]  
   -- ,[CommunityPerformanceComment]  
   -- ,0 AS [BehaviorTowardsOther]  
   -- ,[BehaviorTowardsOtherComment]  
   -- ,0 AS [MoodsEmotion]  
   -- ,[MoodsEmotionComment]  
   -- ,0 AS [SelfHarmfulBehavior]  
   -- ,[SelfHarmfulBehaviorComment]  
   -- ,0 AS [SubstanceUse]  
   -- ,[SubstanceUseComment]  
   -- ,0 AS [Thinkng]  
   -- ,[ThinkngComment]  
   -- ,[YouthTotalScore]  
   -- ,0 AS [PrimaryFamilyMaterialNeeds]  
   -- ,[PrimaryFamilyMaterialNeedsComment]  
   -- ,0 AS [PrimaryFamilySocialSupport]  
   -- ,[PrimaryFamilySocialSupportComment]  
   -- ,0 AS [NonCustodialMaterialNeeds]  
   -- ,[NonCustodialMaterialNeedsComment]  
   -- ,0 AS [NonCustodialSocialSupport]  
   -- ,[NonCustodialSocialSupportComment]  
   -- ,0 AS [SurrogateMaterialNeeds]  
   -- ,[SurrogateMaterialNeedsComment]  
   -- ,0 AS [SurrogateSocialSupport]  
   -- ,[SurrogateSocialSupportComment]  
   -- ,CC2.[CreatedDate]  
   -- ,CC2.[CreatedBy]  
   -- ,CC2.[ModifiedDate]  
   -- ,CC2.[ModifiedBy]  
   -- ,CC2.[RecordDeleted]  
   -- ,CC2.[DeletedDate]  
   -- ,CC2.[DeletedBy]  
   --FROM SystemConfigurations AS s  
   --LEFT JOIN CustomCAFAS2 CC2 ON s.DatabaseVersion = - 1  
  --END  
  
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- SELECT 'CustomSubstanceUseAssessments' AS TableName  
  --  ,- 1 AS [DocumentVersionId]  
  --  ,[VoluntaryAbstinenceTrial]  
  --  ,[Comment]  
  --  ,[HistoryOrCurrentDUI]  
  --  ,[NumberOfTimesDUI]  
  --  ,[HistoryOrCurrentDWI]  
  --  ,[NumberOfTimesDWI]  
  --  ,[HistoryOrCurrentMIP]  
  --  ,[NumberOfTimeMIP]  
  --  ,[HistoryOrCurrentBlackOuts]  
  --  ,[NumberOfTimesBlackOut]  
  --  ,[HistoryOrCurrentDomesticAbuse]  
  --  ,[NumberOfTimesDomesticAbuse]  
  --  ,[LossOfControl]  
  --  ,[IncreasedTolerance]  
  --  ,[OtherConsequence]  
  --  ,[OtherConsequenceDescription]  
  --  ,[RiskOfRelapse]  
  --  ,[PreviousTreatment]  
  --  ,[CurrentSubstanceAbuseTreatment]  
  --  ,[CurrentTreatmentProvider]  
  --  ,[CurrentSubstanceAbuseReferralToSAorTx]  
  --  ,[CurrentSubstanceAbuseRefferedReason]  
  --  ,[ToxicologyResults]  
  --  ,[SubstanceAbuseAdmittedOrSuspected]  
  --  ,[ClientSAHistory]  
  --  ,[FamilySAHistory]  
  --  ,[NoSubstanceAbuseSuspected]  
  --  ,[DUI30Days]  
  --  ,[DUI5Years]  
  --  ,[DWI30Days]  
  --  ,[DWI5Years]  
  --  ,[Possession30Days]  
  --  ,[Possession5Years]  
  --  ,[CurrentSubstanceAbuse]  
  --  ,[SuspectedSubstanceAbuse]  
  --  ,[SubstanceAbuseDetail]  
  --  ,[SubstanceAbuseTxPlan]  
  --  ,[OdorOfSubstance]  
  --  ,[SlurredSpeech]  
  --  ,[WithdrawalSymptoms]  
  --  ,[DTOther]  
  --  ,[DTOtherText]  
  --  ,[Blackouts]  
  --  ,[RelatedArrests]  
  --  ,[RelatedSocialProblems]  
  --  ,[FrequentJobSchoolAbsence]  
  --  ,[NoneSynptomsReportedOrObserved]  
  --  ,[RowIdentifier]  
  --  ,CSUA.[CreatedBy]  
  --  ,CSUA.[CreatedDate]  
  --  ,CSUA.[ModifiedBy]  
  --  ,CSUA.[ModifiedDate]  
  --  ,[RecordDeleted]  
  --  ,[DeletedDate]  
  --  ,[DeletedBy]  
  --  ,PreviousMedication  
  --  ,CurrentSubstanceAbuseMedication  
  --  ,CSUA.MedicationAssistedTreatment
  --  ,CSUA.MedicationAssistedTreatmentRefferedReason
  -- FROM CustomSubstanceUseAssessments CSUA  
  -- WHERE CSUA.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
   SELECT 'CustomSubstanceUseAssessments' AS TableName  
    ,- 1 AS [DocumentVersionId]  
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
    ,[SubstanceAbuseAdmittedOrSuspected]  
    ,[ClientSAHistory]  
    ,[FamilySAHistory]  
    ,[NoSubstanceAbuseSuspected]  
    ,[DUI30Days]  
    ,[DUI5Years]  
    ,[DWI30Days]  
    ,[DWI5Years]  
    ,[Possession30Days]  
    ,[Possession5Years]  
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
    --,[RowIdentifier]  
    ,CSUA.[CreatedBy]  
    ,CSUA.[CreatedDate]  
    ,CSUA.[ModifiedBy]  
    ,CSUA.[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM SystemConfigurations AS s  
   LEFT JOIN CustomSubstanceUseAssessments CSUA ON s.DatabaseVersion = - 1  
  --END  
  
  -- CustomHRMAssessmentSupports2--               
  SELECT 'CustomHRMAssessmentSupports2' AS TableName  
   ,0 AS 'HRMAssessmentSupportId'  
   ,- 1 AS 'DocumentVersionId'  
   ,[SupportDescription]  
   ,[Current]  
   ,[PaidSupport]  
   ,[UnpaidSupport]  
   ,[ClinicallyRecommended]  
   ,[CustomerDesired]  
   --,[RowIdentifier]  
   ,CS2.[CreatedBy]  
   ,CS2.[CreatedDate]  
   ,CS2.[ModifiedBy]  
   ,CS2.[ModifiedDate]  
   ,[RecordDeleted]  
   ,[DeletedDate]  
   ,[DeletedBy]  
  FROM SystemConfigurations AS s  
  LEFT JOIN CustomHRMAssessmentSupports2 CS2 ON s.DatabaseVersion = - 1  
  
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- -- CustomMentalStatuses2--                                                                     
  -- SELECT 'CustomMentalStatuses2' AS TableName  
  --  ,- 1 AS 'DocumentVersionId'  
  --  ,[AppearanceAddToNeedsList]  
  --  ,[AppearanceNeatClean]  
  --  ,[AppearancePoorHygiene]  
  --  ,[AppearanceWellGroomed]  
  --  ,[AppearanceAppropriatelyDressed]  
  --  ,[AppearanceYoungerThanStatedAge]  
  --  ,[AppearanceOlderThanStatedAge]  
  --  ,[AppearanceOverweight]  
  --  ,[AppearanceUnderweight]  
  --  ,[AppearanceEccentric]  
  --  ,[AppearanceSeductive]  
  --  ,[AppearanceUnkemptDisheveled]  
  --  ,[AppearanceOther]  
  --  ,[AppearanceComment]  
  --  ,[IntellectualAddToNeedsList]  
  --  ,[IntellectualAboveAverage]  
  --  ,[IntellectualAverage]  
  --  ,[IntellectualBelowAverage]  
  --  ,[IntellectualPossibleMR]  
  --  ,[IntellectualDocumentedMR]  
  --  ,[IntellectualOther]  
  --  ,[IntellectualComment]  
  --  ,[CommunicationAddToNeedsList]  
  --  ,[CommunicationNormal]  
  --  ,[CommunicationUsesSignLanguage]  
  --  ,[CommunicationUnableToRead]  
  --  ,[CommunicationNeedForBraille]  
  --  ,[CommunicationHearingImpaired]  
  --  ,[CommunicationDoesLipReading]  
  --  ,[CommunicationEnglishIsSecondLanguage]  
  --  ,[CommunicationTranslatorNeeded]  
  --  ,[CommunicationOther]  
  --  ,[CommunicationComment]  
  --  ,[MoodAddToNeedsList]  
  --  ,[MoodUnremarkable]  
  --  ,[MoodCooperative]  
  --  ,[MoodAnxious]  
  --  ,[MoodTearful]  
  --  ,[MoodCalm]  
  --  ,[MoodLabile]  
  --  ,[MoodPessimistic]  
  --  ,[MoodCheerful]  
  --  ,[MoodGuilty]  
  --  ,[MoodEuphoric]  
  --  ,[MoodDepressed]  
  --  ,[MoodHostile]  
  --  ,[MoodIrritable]  
  --  ,[MoodDramatized]  
  --  ,[MoodFearful]  
  --  ,[MoodSupicious]  
  --  ,[MoodOther]  
  --  ,[MoodComment]  
  --  ,[AffectAddToNeedsList]  
  --  ,[AffectPrimarilyAppropriate]  
  --  ,[AffectRestricted]  
  --  ,[AffectBlunted]  
  --  ,[AffectFlattened]  
  --  ,[AffectDetached]  
  --  ,[AffectPrimarilyInappropriate]  
  --  ,[AffectOther]  
  --  ,[AffectComment]  
  --  ,[SpeechAddToNeedsList]  
  --  ,[SpeechNormal]  
  --  ,[SpeechLogicalCoherent]  
  --  ,[SpeechTangential]  
  --  ,[SpeechSparseSlow]  
  --  ,[SpeechRapidPressured]  
  --  ,[SpeechSoft]  
  --  ,[SpeechCircumstantial]  
  --  ,[SpeechLoud]  
  --  ,[SpeechRambling]  
  --  ,[SpeechOther]  
  --  ,[SpeechComment]  
  --  ,[ThoughtAddToNeedsList]  
  --  ,[ThoughtUnremarkable]  
  --  ,[ThoughtParanoid]  
  --  ,[ThoughtGrandiose]  
  --  ,[ThoughtObsessive]  
  --  ,[ThoughtBizarre]  
  --  ,[ThoughtFlightOfIdeas]  
  --  ,[ThoughtDisorganized]  
  --  ,[ThoughtAuditoryHallucinations]  
  --  ,[ThoughtVisualHallucinations]  
  --  ,[ThoughtTactileHallucinations]  
  --  ,[ThoughtOther]  
  --  ,[ThoughtComment]  
  --  ,[BehaviorAddToNeedsList]  
  --  ,[BehaviorNormal]  
  --  ,[BehaviorRestless]  
  --  ,[BehaviorTremors]  
  --  ,[BehaviorPoorEyeContact]  
  --  ,[BehaviorAgitated]  
  --  ,[BehaviorPeculiar]  
  --  ,[BehaviorSelfDestructive]  
  --  ,[BehaviorSlowed]  
  --  ,[BehaviorDestructiveToOthers]  
  --  ,[BehaviorCompulsive]  
  --  ,[BehaviorOther]  
  --  ,[BehaviorComment]  
  --  ,[OrientationAddToNeedsList]  
  --  ,[OrientationToPersonPlaceTime]  
  --  ,[OrientationNotToPerson]  
  --  ,[OrientationNotToPlace]  
  --  ,[OrientationNotToTime]  
  --  ,[OrientationOther]  
  --  ,[OrientationComment]  
  --  ,[InsightAddToNeedsList]  
  --  ,[InsightGood]  
  --  ,[InsightFair]  
  --  ,[InsightPoor]  
  --  ,[InsightLacking]  
  --  ,[InsightOther]  
  --  ,[InsightComment]  
  --  ,[MemoryAddToNeedsList]  
  --  ,[MemoryGoodNormal]  
  --  ,[MemoryImpairedShortTerm]  
  --  ,[MemoryImpairedLongTerm]  
  --  ,[MemoryOther]  
  --  ,[MemoryComment]  
  --  ,[RealityOrientationAddToNeedsList]  
  --  ,[RealityOrientationIntact]  
  --  ,[RealityOrientationTenuous]  
  --  ,[RealityOrientationPoor]  
  --  ,[RealityOrientationOther]  
  --  ,[RealityOrientationComment]  
  --  --,[RowIdentifier]  
  --  ,CMS.[CreatedBy]  
  --  ,CMS.[CreatedDate]  
  --  ,CMS.[ModifiedBy]  
  --  ,CMS.[ModifiedDate]  
  --  ,[RecordDeleted]  
  --  ,[DeletedDate]  
  --  ,[DeletedBy]  
  -- FROM CustomMentalStatuses2 CMS  
  -- WHERE CMS.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
   SELECT 'CustomMentalStatuses2' AS TableName  
    ,- 1 AS 'DocumentVersionId'  
    ,[AppearanceAddToNeedsList]  
    ,[AppearanceNeatClean]  
    ,[AppearancePoorHygiene]  
    ,[AppearanceWellGroomed]  
    ,[AppearanceAppropriatelyDressed]  
    ,[AppearanceYoungerThanStatedAge]  
    ,[AppearanceOlderThanStatedAge]  
    ,[AppearanceOverweight]  
    ,[AppearanceUnderweight]  
    ,[AppearanceEccentric]  
    ,[AppearanceSeductive]  
    ,[AppearanceUnkemptDisheveled]  
    ,[AppearanceOther]  
    ,[AppearanceComment]  
    ,[IntellectualAddToNeedsList]  
    ,[IntellectualAboveAverage]  
    ,[IntellectualAverage]  
    ,[IntellectualBelowAverage]  
    ,[IntellectualPossibleMR]  
    ,[IntellectualDocumentedMR]  
    ,[IntellectualOther]  
    ,[IntellectualComment]  
    ,[CommunicationAddToNeedsList]  
    ,[CommunicationNormal]  
    ,[CommunicationUsesSignLanguage]  
    ,[CommunicationUnableToRead]  
    ,[CommunicationNeedForBraille]  
    ,[CommunicationHearingImpaired]  
    ,[CommunicationDoesLipReading]  
    ,[CommunicationEnglishIsSecondLanguage]  
    ,[CommunicationTranslatorNeeded]  
    ,[CommunicationOther]  
    ,[CommunicationComment]  
    ,[MoodAddToNeedsList]  
    ,[MoodUnremarkable]  
    ,[MoodCooperative]  
    ,[MoodAnxious]  
    ,[MoodTearful]  
    ,[MoodCalm]  
    ,[MoodLabile]  
    ,[MoodPessimistic]  
    ,[MoodCheerful]  
    ,[MoodGuilty]  
    ,[MoodEuphoric]  
    ,[MoodDepressed]  
    ,[MoodHostile]  
    ,[MoodIrritable]  
    ,[MoodDramatized]  
    ,[MoodFearful]  
    ,[MoodSupicious]  
    ,[MoodOther]  
    ,[MoodComment]  
    ,[AffectAddToNeedsList]  
    ,[AffectPrimarilyAppropriate]  
    ,[AffectRestricted]  
    ,[AffectBlunted]  
    ,[AffectFlattened]  
    ,[AffectDetached]  
    ,[AffectPrimarilyInappropriate]  
    ,[AffectOther]  
    ,[AffectComment]  
    ,[SpeechAddToNeedsList]  
    ,[SpeechNormal]  
    ,[SpeechLogicalCoherent]  
    ,[SpeechTangential]  
    ,[SpeechSparseSlow]  
    ,[SpeechRapidPressured]  
    ,[SpeechSoft]  
    ,[SpeechCircumstantial]  
    ,[SpeechLoud]  
    ,[SpeechRambling]  
    ,[SpeechOther]  
    ,[SpeechComment]  
    ,[ThoughtAddToNeedsList]  
    ,[ThoughtUnremarkable]  
    ,[ThoughtParanoid]  
    ,[ThoughtGrandiose]  
    ,[ThoughtObsessive]  
    ,[ThoughtBizarre]  
    ,[ThoughtFlightOfIdeas]  
    ,[ThoughtDisorganized]  
    ,[ThoughtAuditoryHallucinations]  
    ,[ThoughtVisualHallucinations]  
    ,[ThoughtTactileHallucinations]  
    ,[ThoughtOther]  
    ,[ThoughtComment]  
    ,[BehaviorAddToNeedsList]  
    ,[BehaviorNormal]  
    ,[BehaviorRestless]  
    ,[BehaviorTremors]  
    ,[BehaviorPoorEyeContact]  
    ,[BehaviorAgitated]  
    ,[BehaviorPeculiar]  
    ,[BehaviorSelfDestructive]  
    ,[BehaviorSlowed]  
    ,[BehaviorDestructiveToOthers]  
    ,[BehaviorCompulsive]  
    ,[BehaviorOther]  
    ,[BehaviorComment]  
    ,[OrientationAddToNeedsList]  
    ,[OrientationToPersonPlaceTime]  
    ,[OrientationNotToPerson]  
    ,[OrientationNotToPlace]  
    ,[OrientationNotToTime]  
    ,[OrientationOther]  
    ,[OrientationComment]  
    ,[InsightAddToNeedsList]  
    ,[InsightGood]  
    ,[InsightFair]  
    ,[InsightPoor]  
    ,[InsightLacking]  
    ,[InsightOther]  
    ,[InsightComment]  
    ,[MemoryAddToNeedsList]  
    ,[MemoryGoodNormal]  
    ,[MemoryImpairedShortTerm]  
    ,[MemoryImpairedLongTerm]  
    ,[MemoryOther]  
    ,[MemoryComment]  
    ,[RealityOrientationAddToNeedsList]  
    ,[RealityOrientationIntact]  
    ,[RealityOrientationTenuous]  
    ,[RealityOrientationPoor]  
    ,[RealityOrientationOther]  
    ,[RealityOrientationComment]  
    --,[RowIdentifier]  
    ,CMS.[CreatedBy]  
    ,CMS.[CreatedDate]  
    ,CMS.[ModifiedBy]  
    ,CMS.[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM SystemConfigurations AS s  
   LEFT JOIN CustomMentalStatuses2 CMS ON s.DatabaseVersion = - 1  
  --END  
  
  --Added by Saurav Pande on 8th june 2012 with ref. to task# 159 in General Implementaion              
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- SELECT 'DiagnosesIAndII' AS TableName  
  --  ,DIandII.DiagnosisId  
  --  ,DIandII.DocumentVersionId  
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
  --  ,CASE DIandII.RuleOut  
  --   WHEN 'Y'  
  --    THEN 'R/O'  
  --   ELSE NULL  
  --   END AS RuleOutText  
  -- FROM DiagnosesIAndII AS DIandII  
  -- INNER JOIN DiagnosisDSMDescriptions DSM ON DSM.DSMCode = DIandII.DSMCode  
  --  AND DSM.DSMNumber = DIandII.DSMNumber  
  -- WHERE DIandII.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --  AND IsNull(RecordDeleted, 'N') = 'N'  
  
  -- -----For DiagnosesIII-----                                                                         
  -- SELECT 'DiagnosesIII' AS TableName  
  --  ,- 1 AS DocumentVersionId  
  --  ,[CreatedBy]  
  --  ,[CreatedDate]  
  --  ,[ModifiedBy]  
  --  ,[ModifiedDate]  
  --  ,[RecordDeleted]  
  --  ,[DeletedDate]  
  --  ,[DeletedBy]  
  --  ,[Specification]  
  -- FROM DiagnosesIII  
  -- WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --  AND ISNULL(RecordDeleted, 'N') = 'N'  
  
  -- -----For DiagnosesIV-----                                                                                             
  -- SELECT 'DiagnosesIV' AS TableName  
  --  ,- 1 AS DocumentVersionId  
  --  ,PrimarySupport  
  --  ,SocialEnvironment  
  --  ,Educational  
  --  ,Occupational  
  --  ,Housing  
  --  ,Economic  
  --  ,HealthcareServices  
  --  ,Legal  
  --  ,Other  
  --  ,Specification  
  --  ,CreatedBy  
  --  ,CreatedDate  
  --  ,ModifiedBy  
  --  ,ModifiedDate  
  --  ,RecordDeleted  
  --  ,DeletedDate  
  --  ,DeletedBy  
  -- FROM DiagnosesIV  
  -- WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --  AND ISNULL(RecordDeleted, 'N') = 'N'  
  
  -- -----For DiagnosesV-----                                                          
  -- SELECT 'DiagnosesV' AS TableName  
  --  ,- 1 AS DocumentVersionId  
  --  ,AxisV  
  --  ,CreatedBy  
  --  ,CreatedDate  
  --  ,ModifiedBy  
  --  ,ModifiedDate  
  --  ,RecordDeleted  
  --  ,DeletedDate  
  --  ,DeletedBy  
  -- FROM DiagnosesV  
  -- WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --  AND ISNULL(RecordDeleted, 'N') = 'N'  
  --  --Changes by Saurav end here--              
  --END  
  --ELSE  
  --BEGIN  
  -- EXEC csp_InitCustomHRMAssessmentDiagnosisIntialization - 1  
  --  ,'Y'  
  --  ,@AssessmentType  
  --  ,@CurrentAuthorId  
  --END  
  
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- --- CustomDocumentCRAFFTs                
  -- SELECT 'CustomDocumentCRAFFTs' AS TableName  
  --  ,- 1 AS DocumentVersionId  
  --  ,CDC.CreatedBy  
  --  ,CDC.CreatedDate  
  --  ,CDC.ModifiedBy  
  --  ,CDC.ModifiedDate  
  --  ,CDC.RecordDeleted  
  --  ,CDC.DeletedBy  
  --  ,CDC.DeletedDate  
  --  ,CrafftApplicable  
  --  ,CrafftApplicableReason  
  --  ,CrafftQuestionC  
  --  ,CrafftQuestionR  
  --  ,CrafftQuestionA  
  --  ,CrafftQuestionF  
  --  ,CrafftQuestionFR  
  --  ,CrafftQuestionT  
  --  ,CrafftCompleteFullSUAssessment  
  --  ,CrafftStageOfChange  
  -- FROM CustomDocumentCRAFFTs CDC  
  -- WHERE CDC.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
   SELECT 'CustomDocumentCRAFFTs' AS TableName  
    ,- 1 AS DocumentVersionId  
    ,CDC.CreatedBy  
    ,CDC.CreatedDate  
    ,CDC.ModifiedBy  
    ,CDC.ModifiedDate  
    ,CDC.RecordDeleted  
    ,CDC.DeletedBy  
    ,CDC.DeletedDate  
    ,CrafftApplicable  
    ,CrafftApplicableReason  
    ,CrafftQuestionC  
    ,CrafftQuestionR  
    ,CrafftQuestionA  
    ,CrafftQuestionF  
    ,CrafftQuestionFR  
    ,CrafftQuestionT  
    ,CrafftCompleteFullSUAssessment  
    ,CrafftStageOfChange  
   FROM SystemConfigurations AS s  
   LEFT JOIN CustomDocumentCRAFFTs CDC ON s.DatabaseVersion = - 1  
  --END  
  
  --- CustomDispositions                
  SELECT 'CustomDispositions' AS TableName  
   ,- 1 AS CustomDispositionId  
   ,CD.CreatedBy  
   ,CD.CreatedDate  
   ,CD.ModifiedBy  
   ,CD.ModifiedDate  
   ,CD.RecordDeleted  
   ,CD.DeletedBy  
   ,CD.DeletedDate  
   ,InquiryId  
   ,DocumentVersionId  
   ,Disposition  
  FROM SystemConfigurations AS s  
  LEFT JOIN CustomDispositions CD ON s.DatabaseVersion = - 1  
  
  --- CustomServiceDispositions                
  SELECT 'CustomServiceDispositions' AS TableName  
   ,- 1 AS CustomServiceDispositionId  
   ,CSD.CreatedBy  
   ,CSD.CreatedDate  
   ,CSD.ModifiedBy  
   ,CSD.ModifiedDate  
   ,CSD.RecordDeleted  
   ,CSD.DeletedBy  
   ,CSD.DeletedDate  
   ,ServiceType  
   ,- 1 AS CustomDispositionId  
  FROM SystemConfigurations AS s  
  LEFT JOIN CustomServiceDispositions CSD ON s.DatabaseVersion = - 1  
  
  --- CustomProviderServices                
  SELECT 'CustomProviderServices' AS TableName  
   ,- 1 AS CustomProviderServiceId  
   ,CPS.CreatedBy  
   ,CPS.CreatedDate  
   ,CPS.ModifiedBy  
   ,CPS.ModifiedDate  
   ,CPS.RecordDeleted  
   ,CPS.DeletedBy  
   ,CPS.DeletedDate  
   ,ProgramId  
   ,- 1 AS CustomServiceDispositionId  
  FROM SystemConfigurations AS s  
  LEFT JOIN CustomProviderServices CPS ON s.DatabaseVersion = - 1  
  
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- SELECT 'CustomASAMPlacements' AS TableName  
  --  ,ISNULL(b.DocumentVersionId, - 1) AS DocumentVersionId  
  --  ,b.Dimension1LevelOfCare  
  --  ,b.Dimension1Need  
  --  ,b.Dimension2LevelOfCare  
  --  ,b.Dimension2Need  
  --  ,b.Dimension3LevelOfCare  
  --  ,b.Dimension3Need  
  --  ,b.Dimension4LevelOfCare  
  --  ,b.Dimension4Need  
  --  ,b.Dimension5LevelOfCare  
  --  ,b.Dimension5Need  
  --  ,b.Dimension6LevelOfCare  
  --  ,b.Dimension6Need  
  --  ,b.SuggestedPlacement  
  --  ,b.FinalPlacement  
  --  ,b.FinalPlacementComment  
  --  ,b.CreatedBy  
  --  ,b.CreatedDate  
  --  ,b.ModifiedBy  
  --  ,b.ModifiedDate  
  --  --,b.RowIdentifier  
  --  ,b.RecordDeleted  
  --  ,b.DeletedDate  
  --  ,b.DeletedBy  
  -- FROM CustomASAMPlacements b  
  -- WHERE b.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
   --- CustomASAMPlacements              
   SELECT 'CustomASAMPlacements' AS TableName  
    ,ISNULL(b.DocumentVersionId, - 1) AS DocumentVersionId  
    ,b.Dimension1LevelOfCare  
    ,b.Dimension1Need  
    ,b.Dimension2LevelOfCare  
    ,b.Dimension2Need  
    ,b.Dimension3LevelOfCare  
    ,b.Dimension3Need  
    ,b.Dimension4LevelOfCare  
    ,b.Dimension4Need  
    ,b.Dimension5LevelOfCare  
    ,b.Dimension5Need  
    ,b.Dimension6LevelOfCare  
    ,b.Dimension6Need  
    ,b.SuggestedPlacement  
    ,b.FinalPlacement  
    ,b.FinalPlacementComment  
    ,b.CreatedBy  
    ,b.CreatedDate  
    ,b.ModifiedBy  
    ,b.ModifiedDate  
    --,b.RowIdentifier  
    ,b.RecordDeleted  
    ,b.DeletedDate  
    ,b.DeletedBy  
   FROM SystemConfigurations AS s  
   LEFT JOIN CustomASAMPlacements b ON s.DatabaseVersion = - 1  
 -- END  
  
  --Added by Saurav Pande on 8th june 2012 with ref. to task# 159 in General Implementaion              
  ---CustomOtherRiskFactors---                 
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
   SELECT 'CustomOtherRiskFactors' AS TableName  
    -- ,-1 As OtherRiskFactorId              
    ,- 1 AS [DocumentVersionId]  
    ,[OtherRiskFactor]  
    --,c.[RowIdentifier]  
    ,c.[CreatedBy]  
    ,c.[CreatedDate]  
    ,c.[ModifiedBy]  
    ,c.[ModifiedDate]  
    ,c.[RecordDeleted]  
    ,c.[DeletedDate]  
    ,c.[DeletedBy]  
    ,CodeName 
      FROM SystemConfigurations AS s  
   LEFT JOIN CustomOtherRiskFactors c ON s.DatabaseVersion = - 1  
   LEFT JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = c.OtherRiskFactor 
  -- FROM CustomOtherRiskFactors c  
  -- INNER JOIN GlobalCodes ON GlobalCodes.GlobalCodeId = c.OtherRiskFactor  
  -- WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --  AND ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N'  
  --  AND ISNULL(c.RecordDeleted, 'N') = 'N'  
  --END  
  
  --Changes end here          
  ---CustomDocumentAssessmentSubstanceUses---        
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- SELECT 'CustomDocumentAssessmentSubstanceUses' AS TableName  
  --  -- ,ISNULL(CDA.DocumentVersionId, - 1) AS DocumentVersionId            
  --  ,- 1 AS 'DocumentVersionId'  
  --  ,CDA.CreatedBy  
  --  ,CDA.CreatedDate  
  --  ,CDA.ModifiedBy  
  --  ,CDA.ModifiedDate  
  --  ,CDA.RecordDeleted  
  --  ,CDA.DeletedBy  
  --  ,CDA.DeletedDate  
  --  ,CDA.UseOfAlcohol  
  --  ,CDA.AlcoholAddToNeedsList  
  --  ,CDA.UseOfTobaccoNicotine  
  --  ,CDA.UseOfTobaccoNicotineQuit  
  --  ,CDA.UseOfTobaccoNicotineTypeOfFrequency  
  --  ,CDA.UseOfTobaccoNicotineAddToNeedsList  
  --  ,CDA.UseOfIllicitDrugs  
  --  ,CDA.UseOfIllicitDrugsTypeFrequency  
  --  ,CDA.UseOfIllicitDrugsAddToNeedsList  
  --  ,CDA.PrescriptionOTCDrugs  
  --  ,CDA.PrescriptionOTCDrugsTypeFrequency  
  --  ,CDA.PrescriptionOTCDrugsAddtoNeedsList  
  -- --FROM SystemConfigurations AS s            
  -- --  LEFT OUTER JOIN CustomDocumentAssessmentSubstanceUses CDA ON s.DatabaseVersion = - 1         
  -- FROM CustomDocumentAssessmentSubstanceUses CDA  
  -- WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
   SELECT 'CustomDocumentAssessmentSubstanceUses' AS TableName  
    ,ISNULL(CDA.DocumentVersionId, - 1) AS DocumentVersionId  
    ,CDA.CreatedBy  
    ,CDA.CreatedDate  
    ,CDA.ModifiedBy  
    ,CDA.ModifiedDate  
    ,CDA.RecordDeleted  
    ,CDA.DeletedBy  
    ,CDA.DeletedDate  
    ,CDA.UseOfAlcohol  
    ,CDA.AlcoholAddToNeedsList  
    ,CDA.UseOfTobaccoNicotine  
    ,CDA.UseOfTobaccoNicotineQuit  
    ,CDA.UseOfTobaccoNicotineTypeOfFrequency  
    ,CDA.UseOfTobaccoNicotineAddToNeedsList  
    ,CDA.UseOfIllicitDrugs  
    ,CDA.UseOfIllicitDrugsTypeFrequency  
    ,CDA.UseOfIllicitDrugsAddToNeedsList  
    ,CDA.PrescriptionOTCDrugs  
    ,CDA.PrescriptionOTCDrugsTypeFrequency  
    ,CDA.PrescriptionOTCDrugsAddtoNeedsList  
   FROM SystemConfigurations AS s  
   LEFT JOIN CustomDocumentAssessmentSubstanceUses CDA ON s.DatabaseVersion = - 1  
  --END  
  
  ---DocumentFamilyHistory---         
  --SELECT 'DocumentFamilyHistory' AS TableName  
  -- ,FamilyHistoryId  
  -- ,CreatedBy  
  -- ,CreatedDate  
  -- ,ModifiedBy  
  -- ,ModifiedDate  
  -- ,RecordDeleted  
  -- ,DeletedBy  
  -- ,DeletedDate  
  -- ,DocumentVersionId  
  -- ,FamilyMemberType  
  -- ,IsLiving  
  -- ,CurrentAge  
  -- ,CauseOfDeath  
  -- ,Hypertension  
  -- ,Hyperlipidemia  
  -- ,Diabetes  
  -- ,DiabetesType1  
  -- ,DiabetesType2  
  -- ,Alcoholism  
  -- ,COPD  
  -- ,Depression  
  -- ,ThyroidDisease  
  -- ,CoronaryArteryDisease  
  -- ,Cancer  
  -- ,Other  
  -- ,CancerType  
  -- ,DiseaseConditionDXCode  
  -- ,DiseaseConditionDXCodeDescription  
  -- ,STUFF((  
  --   CASE   
  --    WHEN isnull(Hypertension, 'N') = 'Y'  
  --     THEN ',Hypertension'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(Hyperlipidemia, 'N') = 'Y'  
  --     THEN ',Hyperlipidemia'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(Diabetes, 'N') = 'Y'  
  --     THEN ',Diabetes '  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(DiabetesType1, 'N') = 'Y'  
  --     THEN CASE   
  --       WHEN isnull(DiabetesType2, 'N') = 'Y'  
  --        THEN '(Type1,Type2)'  
  --       ELSE '(Type1)'  
  --       END  
  --    ELSE CASE   
  --      WHEN isnull(DiabetesType2, 'N') = 'Y'  
  --       THEN '(Type2)'  
  --      ELSE ''  
  --      END  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(Alcoholism, 'N') = 'Y'  
  --     THEN ',Alcoholism'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(COPD, 'N') = 'Y'  
  --     THEN ',COPD'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(Depression, 'N') = 'Y'  
  --     THEN ',Depression'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(ThyroidDisease, 'N') = 'Y'  
  --     THEN ',ThyroidDisease'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(CoronaryArteryDisease, 'N') = 'Y'  
  --     THEN ',CoronaryArteryDisease'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN ISNULL(Cancer, 'N') = 'y'  
  --     THEN ',Cancer (' + (  
  --       SELECT CodeName  
  --       FROM GlobalCodes  
  --       WHERE Category = 'FamilyHistoryCancer'  
  --        AND GlobalCodeId = CancerType  
  --       ) + ')'  
  --    ELSE ''  
  --    END  
  --   ) + (  
  --   CASE   
  --    WHEN isnull(Other, 'N') = 'Y'  
  --     THEN ',Other' + '(' + convert(VARCHAR(max), OtherComment) + ')'  
  --    ELSE ''  
  --    END  
  --   ), 1, 1, '') AS DiseaseCondition  
  -- ,dbo.csf_GetGlobalCodeNameById(FamilyMemberType) AS 'FamilyMemberTypeText'  
  -- ,IsLivingValue = CASE IsLiving  
  --  WHEN 'Y'  
  --   THEN 'Yes'  
  --  WHEN 'N'  
  --   THEN 'No'  
  --  WHEN 'U'  
  --   THEN 'Unknown'  
  --  END  
  -- ,OtherComment 
  -- FROM DocumentFamilyHistory  
  -- WHERE DocumentVersionId = @LatestDocumentVersionID  
  -- AND ISNULL(DocumentFamilyHistory.RecordDeleted, 'N') = 'N'
  --FROM DocumentFamilyHistory  
  --WHERE DocumentVersionId = @LatestDocumentVersionID  
  -- AND ISNULL(DocumentFamilyHistory.RecordDeleted, 'N') = 'N'  
  
  --CustomDocumentPreEmploymentActivities--        
  --IF (  
  --  (  
  --   @AssessmentType = 'I'  
  --   OR @AssessmentType = 'S'  
  --   )  
  --  AND @LatestScreeenTypeDocumentVersionId > 0  
  --  )  
  --BEGIN  
  -- SELECT 'CustomDocumentPreEmploymentActivities' AS TableName  
  --  ,- 1 AS DocumentVersionId  
  --  ,CDP.CreatedBy  
  --  ,CDP.CreatedDate  
  --  ,CDP.ModifiedBy  
  --  ,CDP.ModifiedDate  
  --  ,RecordDeleted  
  --  ,DeletedBy  
  --  ,DeletedDate  
  --  ,EducationTraining  
  --  ,EducationTrainingNeeds  
  --  ,EducationTrainingNeedsComments  
  --  ,PersonalCareerPlanning  
  --  ,PersonalCareerPlanningNeeds  
  --  ,PersonalCareerPlanningNeedsComments  
  --  ,EmploymentOpportunities  
  --  ,EmploymentOpportunitiesNeeds  
  --  ,EmploymentOpportunitiesNeedsComments  
  --  ,SupportedEmployment  
  --  ,SupportedEmploymentNeeds  
  --  ,SupportedEmploymentNeedsComments  
  --  ,WorkHistory  
  --  ,WorkHistoryNeeds  
  --  ,WorkHistoryNeedsComments  
  --  ,GainfulEmploymentBenefits  
  --  ,GainfulEmploymentBenefitsNeeds  
  --  ,GainfulEmploymentBenefitsNeedsComments  
  --  ,GainfulEmployment  
  --  ,GainfulEmploymentNeeds  
  --  ,GainfulEmploymentNeedsComments  
  -- FROM CustomDocumentPreEmploymentActivities CDP  
  -- WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  --END  
  --ELSE  
  --BEGIN  
 --  SELECT 'CustomDocumentPreEmploymentActivities' AS TableName  
 --   ,ISNULL(CDP.DocumentVersionId, - 1) AS DocumentVersionId  
 --   ,CDP.CreatedBy  
 --   ,CDP.CreatedDate  
 --   ,CDP.ModifiedBy  
 --   ,CDP.ModifiedDate  
 --   ,RecordDeleted  
 --   ,DeletedBy  
 --   ,DeletedDate  
 --   ,EducationTraining  
 --   ,EducationTrainingNeeds  
 --   ,EducationTrainingNeedsComments  
 --   ,PersonalCareerPlanning  
 --   ,PersonalCareerPlanningNeeds  
 --   ,PersonalCareerPlanningNeedsComments  
 --   ,EmploymentOpportunities  
 --   ,EmploymentOpportunitiesNeeds  
 --   ,EmploymentOpportunitiesNeedsComments  
 --   ,SupportedEmployment  
 --   ,SupportedEmploymentNeeds  
 --   ,SupportedEmploymentNeedsComments  
 --   ,WorkHistory  
 --   ,WorkHistoryNeeds  
 --   ,WorkHistoryNeedsComments  
 --   ,GainfulEmploymentBenefits  
 --   ,GainfulEmploymentBenefitsNeeds  
 --   ,GainfulEmploymentBenefitsNeedsComments  
 --   ,GainfulEmployment  
 --   ,GainfulEmploymentNeeds  
 --   ,GainfulEmploymentNeedsComments  
 --  FROM SystemConfigurations AS s  
 --  LEFT JOIN CustomDocumentPreEmploymentActivities CDP ON s.DatabaseVersion = - 1  
 ---- END  
  
  SELECT 'CustomDocumentSafetyCrisisPlans' AS TableName  
   ,ISNULL(CDSCP.DocumentVersionId, - 1) AS DocumentVersionId  
   ,CDSCP.CreatedBy  
   ,CDSCP.CreatedDate  
   ,CDSCP.ModifiedBy  
   ,CDSCP.ModifiedDate  
   ,CDSCP.RecordDeleted  
   ,CDSCP.DeletedBy  
   ,CDSCP.DeletedDate  
   ,ClientHasCurrentCrisis  
   ,WarningSignsCrisis  
   ,CopingStrategies  
   ,ThreeMonths  
   ,TwelveMonths  
  --,DateOfCrisis    
  --,(SELECT DOB FROM clients WHERE Clientid = @ClientId) AS DOB   
  --,ProgramId    
  --,StaffId    
  --,SignificantOther    
  --,CurrentCrisisDescription    
  --,CurrentCrisisSpecificactions    
  FROM SystemConfigurations AS s  
  LEFT JOIN CustomDocumentSafetyCrisisPlans CDSCP ON s.DatabaseVersion = - 1  
  
  --SELECT 'CustomSupportContacts' AS TableName  
  -- ,- 1 AS DocumentVersionId  
  -- ,'' AS CreatedBy  
  -- ,GETDATE() AS CreatedDate  
  -- ,'' AS ModifiedBy  
  -- ,GETDATE() AS ModifiedDate  
  -- ,CSC.ClientContactId  
  -- ,CSC.NAME  
  -- ,CSC.Relationship  
  -- ,CSC.[Address]  
  -- ,CSC.Phone  
  --FROM systemconfigurations s  
  --INNER JOIN CustomSupportContacts CSC ON CSC.DocumentVersionId = @LatestDocumentVersionId  
  --WHERE ISNULL(CSC.RecordDeleted, 'N') = 'N'  
  --ORDER BY CSC.SupportContactId ASC  
  
  --SELECT 'CustomSafetyCrisisPlanReviews' AS TableName  
  -- ,- 1 AS DocumentVersionId  
  -- ,'' AS CreatedBy  
  -- ,GETDATE() AS CreatedDate  
  -- ,'' AS ModifiedBy  
  -- ,GETDATE() AS ModifiedDate  
  -- ,CSCPR.SafetyCrisisPlanReviewed  
  -- ,CSCPR.DateReviewed  
  -- ,CSCPR.ReviewEveryXDays  
  -- ,CSCPR.DescribePlanReview  
  -- ,CSCPR.CrisisDisposition  
  -- ,CAST(CSCPR.ReviewEveryXDays AS VARCHAR(5)) + ' Days' AS ReviewEveryDaysText
  -- ,CSCPR.CrisisResolved
  -- ,CSCPR.NextSafetyPlanReviewDate   
  --FROM systemconfigurations s  
  --INNER JOIN CustomSafetyCrisisPlanReviews CSCPR ON CSCPR.DocumentVersionId = @LatestDocumentVersionId  
  --WHERE ISNULL(CSCPR.RecordDeleted, 'N') = 'N'  
  --ORDER BY CSCPR.SafetyCrisisPlanReviewId ASC  
  
  ---CustomDailyLivingActivityScores---    
  --SELECT 'CustomDailyLivingActivityScores' AS TableName  
  -- ,DailyLivingActivityScoreId  
  -- ,[DocumentVersionId]  
  -- ,[HRMActivityId]  
  -- ,[ActivityScore]  
  -- ,[ActivityComment]  
  -- --,[RowIdentifier]  
  -- ,CDL.[CreatedBy]  
  -- ,CDL.[CreatedDate]  
  -- ,CDL.[ModifiedBy]  
  -- ,CDL.[ModifiedDate]  
  -- ,CDL.[RecordDeleted]  
  -- ,CDL.[DeletedDate]  
  -- ,CDL.[DeletedBy]  
  --FROM CustomDailyLivingActivityScores CDL  
  --WHERE CDL.DocumentVersionId = @LatestDocumentVersionID  
  -- AND ISNULL(CDL.RecordDeleted, 'N') = 'N'
   
   
  -- 	SELECT 'CustomDocumentAdultLTs' AS TableName
		--	,- 1 AS [DocumentVersionId]
		--	,CPS.CreatedBy
		--	,CPS.CreatedDate
		--	,CPS.ModifiedBy
		--	,CPS.ModifiedDate
		--	,CPS.RecordDeleted
		--	,CPS.DeletedBy
		--	,CPS.DeletedDate
		--FROM SystemConfigurations AS s
		--LEFT JOIN CustomDocumentAdultLTs CPS ON s.DatabaseVersion = - 1 
		
		--SELECT 'CustomDocumentChildLTs' AS TableName
		--	,- 1 AS [DocumentVersionId]
		--	,CPS.CreatedBy
		--	,CPS.CreatedDate
		--	,CPS.ModifiedBy
		--	,CPS.ModifiedDate
		--	,CPS.RecordDeleted
		--	,CPS.DeletedBy
		--	,CPS.DeletedDate
		--FROM SystemConfigurations AS s
		--LEFT JOIN CustomDocumentChildLTs CPS ON s.DatabaseVersion = - 1  
		
		 --For CarePlanDomains      
  SELECT 'CarePlanDomains' AS TableName  
   ,CPD.[CarePlanDomainId]  
   ,CPD.[CreatedBy]  
   ,CPD.[CreatedDate]  
   ,CPD.[ModifiedBy]  
   ,CPD.[ModifiedDate]  
   ,CPD.[RecordDeleted]  
   ,CPD.[DeletedBy]  
   ,CPD.[DeletedDate]  
   ,CPD.[DomainName]  
  FROM CarePlanDomains AS CPD  
  WHERE ISNull(CPD.RecordDeleted, 'N') = 'N'  
  ORDER BY CPD.DomainName  
  
  --CarePlanDomainNeeds      
  SELECT 'CarePlanDomainNeeds' AS TableName  
   ,CPDN.CarePlanDomainNeedId  
   ,CPDN.CreatedBy  
   ,CPDN.CreatedDate  
   ,CPDN.ModifiedBy  
   ,CPDN.ModifiedDate  
   ,CPDN.RecordDeleted  
   ,CPDN.DeletedBy  
   ,CPDN.DeletedDate  
   ,CPDN.NeedName  
   ,CPDN.CarePlanDomainId  
   ,CPDN.MHAFieldIdentifierCode  
   ,CPDN.MHANeedDescription  
  FROM CarePlanDomainNeeds AS CPDN  
  WHERE ISNull(CPDN.RecordDeleted, 'N') = 'N'  
  
  EXEC csp_InitCarePlanNeedsAssessments @ClientID  
   ,-1  
   ,0;  
   
     SELECT 'CustomDocumentGambling' AS TableName  
       ,- 1 AS 'DocumentVersionId'  
       ,CDG.CreatedBy
       ,CDG.CreatedDate
       ,CDG.ModifiedBy
       ,CDG.ModifiedDate
       ,CDG.RecordDeleted
       ,CDG.DeletedBy
       ,CDG.DeletedDate
       ,CDG.GamblingDate
       ,CDG.TotalMonthlyHousehold
       ,CDG.HealthInsurance
       ,CDG.PrimarySourceOfIncome
       ,CDG.TotalNumberOfDependents
       ,CDG.LastGradeCompleted
       ,CDG.TotalEstimatedGamblingDebt
       ,CDG.LifeInGeneral
       ,CDG.OverallPhysicalHealth
       ,CDG.OverallEmotionalWellbeing
       ,CDG.RelationshipWithSpouse
       ,CDG.RelationshipWithFriends
       ,CDG.RelationshipWithOtherFamilyMembers
       ,CDG.RelationshipWithChildren
       ,CDG.Job
       ,CDG.School
       ,CDG.SpiritualWellbeing
       ,CDG.AccomplishedResponsibilitiesAtWork
       ,CDG.PaidBillsOnTime
       ,CDG.AccomplishedResponsibilitiesAtHome
       ,CDG.HaveThoughtsOfSuicide
       ,CDG.AttemptToCommitSuicide
       ,CDG.DrinkAlcohol
       ,CDG.ProblemsAssociatedWithAlcohol
       ,CDG.UseOfIllegalDrugs
       ,CDG.ProblemsAssociatedWithIllegalDrugs
       ,CDG.UseOfTobacco
       ,CDG.CommitIllegalActs
       ,CDG.MaintainSupportiveNetworkOfFamily
       ,CDG.TakeTimeToRelax
       ,CDG.EatHealthyFood
       ,CDG.Exercise
       ,CDG.AttendCommunitySupport
       ,CDG.ThinkingAboutGambling
       ,CDG.GamblingWithMoreMoney
       ,CDG.UnsuccessfulAttemptsToControlGambling
       ,CDG.RestlessOrIrritable
       ,CDG.GambleToEscapeFromProblems
       ,CDG.ReturningAfterLosingGamblingMoney
       ,CDG.LieToFamily
       ,CDG.GoBeyondLegalGambling
       ,CDG.LoseSignificantRelationship
       ,CDG.SeekHelpFromOthers
       ,CDG.NumberOfDaysGambled
       ,CDG.AverageAmountGambled
       ,CDG.PrimaryGamblingActivity
       ,CDG.PrimarilyGamblingPlace
       ,CDG.NumberOfTimesEnteredEmergencyRoom
       ,CDG.EnrolledInTreatmentProgramForAlcohol
       ,CDG.AlcoholInpatientAAndD
       ,CDG.AlcoholOutpatientAAndD
       ,CDG.EnrolledInTreatmentProgramForMentalHealth
       ,CDG.MentalHealthInpatientAAndD
       ,CDG.MentalHealthOutpatientAAndD
       ,CDG.EnrolledInAnotherGamblingProgram
       ,CDG.GamblingInpatientAAndD
       ,CDG.GamblingOutpatientAAndD
       ,CDG.FiledForBankruptcy
       ,CDG.ConvictedOfGambling
       ,CDG.ExperiencedPhysicalViolence
       ,CDG.AbuseInRelationship
       ,CDG.ControlloedManipulatedByOther
       ,'Marital Status: '+ @MaritalStatus as MaritalStatus
       ,'Employment Status: '+ @GamblingEmploymentStatus as EmploymentStatus
        FROM SystemConfigurations AS s  
   LEFT JOIN CustomDocumentGambling CDG ON s.DatabaseVersion = - 1  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomHRMAssessmentsStandardInitialization') + '*****' + Convert(VARCHAR, ERROR_LINE()) +
 '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                                                                              
    16  
    ,-- Severity.                                                                                                                                                                                                                                              
  
    1 -- State.                                                         
    );  
 END CATCH  
END