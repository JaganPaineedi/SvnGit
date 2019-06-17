
/****** Object:  StoredProcedure [dbo].[csp_GetRecentSignedHRMAsssessment]    Script Date: 02/03/2015 13:30:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetRecentSignedHRMAsssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetRecentSignedHRMAsssessment]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetRecentSignedHRMAsssessment]    Script Date: 02/03/2015 13:30:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_GetRecentSignedHRMAsssessment] (  
 @ClientID INT  
 ,@AxisIAxisIIOut VARCHAR(100)  
 ,@ClientAge VARCHAR(50)  
 ,@AssessmentType CHAR(1)  
 ,@LatestDocumentVersionId INT  
 ,@InitialRequestDate DATETIME  
 ,@ClientDOB VARCHAR(50)  
 ,@CurrentAuthorId INT  
 )  
AS  
/* Stored Procedure: [csp_GetRecentSignedHRMAsssessment]   */  
/* Copyright: 2006 Streamline SmartCare            */  
/* Creation Date:  24/Feb/2010               */  
/* Purpose: To Initialize CustomPAAssessments Documents        */  
/* Input Parameters: @ClientID, @AxisIAxisIIOut, @ClientAge,@AssessmentType,@LatestDocumentVersionId    eg:- 14309,92,'N'    */  
/* Output Parameters:                 */  
/* Return:                    */  
/* Called By:CustomDocuments Class Of DataService          */  
/* Calls:                 */  
/*               */  
/* Data Modifications:                 */  
/*                 */  
/*   Updates:               */  
/*       Date       Author                Purpose                            */  
/*       Sandeep Singh                 */  
/*  avoss 1.8.2011 do not pull in assessmentdate for initializaion...     
 /* Modified by vikas kashyup- Ref Task 354 25/Nov/2011-  To get hidden tabs needs from database where recordDeleted='Y'        */                                                                                                         
 /* Hemant     2/23/2015    commented 0 AS 'SubstanceUseHistoryId'  why:#1001 Valley Client Acceptance Testing Issues*/
 /* Hemant     3/5/2015     Added three tables CustomDocumentCSSRSAdultScreeners,CustomDocumentCSSRSAdultSinceLastVisits,CustomDocumentCSSRSChildSinceLastVisits why:955.2 Valley - Customizations*/      
    Manikandan 12/24/2015	WHAT:Added UNCODE TAP initializations/rules  WHY:Task#6.08-New Directions - Customizations
    Veena      04/25/2019   What:removed initalization logic of LocId New Directions - Support Go Live #929
 */  
/*********************************************************************/  
BEGIN  
 -- For GuardianTypeText                  
 DECLARE @GuardianTypeText VARCHAR(250)  
  
 BEGIN TRY  
  DECLARE @ClientHasGuardian CHAR(1) = NULL
  DECLARE @GuardianName VARCHAR(150) = NULL
  DECLARE @GuardianAddress VARCHAR(100) = NULL
  DECLARE @ClientContactId INT = NULL
  DECLARE @MaritalStatus VARCHAR(100)                                                                                                            
  DECLARE @GamblingEmploymentStatus VARCHAR(100) 
   
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
  
    SELECT @MaritalStatus=dbo.csf_GetGlobalCodeNameById(c.MaritalStatus) 
  ,@GamblingEmploymentStatus=dbo.csf_GetGlobalCodeNameById(c.EmploymentStatus) 
  FROM Clients C  
  WHERE C.ClientId =@ClientID   
   AND isnull(C.RecordDeleted, 'N') = 'N'
   DECLARE @ClientAgeNum VARCHAR(50)  
  
   SET @ClientAgeNum = Substring(@ClientAge, 1, CHARINDEX(' ', @ClientAge))  
  
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
    
   IF (@AssessmentType = 'I')  
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
    ORDER BY InquiryId DESC --Get Information For Last Completed Inquiry   
  
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
  END
    DECLARE @EpsiodeRegistrationDate AS DATETIME  
   DECLARE  @SameEpisode char(1)
   DECLARE @PrevEffectiveDate AS DateTime
   SELECT @EpsiodeRegistrationDate = CE.RegistrationDate ,@REFERRALSOURCE = ReferralType
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
     AND d.DocumentCodeId = 10018  ORDER BY d.EffectiveDate DESC  
     ,d.ModifiedDate DESC 
     --AND d.EffectiveDate <= @EpsiodeRegistrationDate  
   --END  
    -- END  
    IF(@EpsiodeRegistrationDate IS NOT NULL and @EpsiodeRegistrationDate <=@PrevEffectiveDate)
    SET @SameEpisode='Y'
  DECLARE @ExistLatestSignedDocumentVersion CHAR  
  
  IF (@LatestDocumentVersionID > 0)  
   SET @ExistLatestSignedDocumentVersion = 'Y'  
  ELSE  
   SET @ExistLatestSignedDocumentVersion = 'N'  
  
   --- CustomHRMAssessments --          
   SELECT 'CustomHRMAssessments' AS TableName  
    ,[DocumentVersionId]  
    ,[ClientName]  
    ,@AssessmentType AS [AssessmentType]  
    --AV CUSTOM FOR BARRY     
    --[CurrentAssessmentDate]                                                                                                                          
    ,getdate() AS [CurrentAssessmentDate]  
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
     ,CASE WHEN  @SameEpisode='Y' THEN DesiredOutcomes ELSE NULL END AS [DesiredOutcomes]  
    --,CASE   
    -- WHEN @AssessmentType IN (  
    --    'U','A'   
    --   ,'I'  
    --   )  AND adultorchild = 'C' 
    --  THEN [PsMedicationsComment]   ELSE NULL END AS [PsMedicationsComment]  
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
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [ClientIsAppropriateForTreatment]  
     ELSE NULL  
     END AS [ClientIsAppropriateForTreatment]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SecondOpinionNoticeProvided]  
     ELSE NULL  
     END AS [SecondOpinionNoticeProvided]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [TreatmentNarrative]  
     ELSE NULL  
     END AS [TreatmentNarrative]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [RapCiDomainIntensity]  
     ELSE NULL  
     END AS [RapCiDomainIntensity]  
    ,[RapCiDomainComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [RapCiDomainNeedsList]  
     ELSE NULL  
     END AS [RapCiDomainNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [RapCbDomainIntensity]  
     ELSE NULL  
     END AS [RapCbDomainIntensity]  
    ,[RapCbDomainComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [RapCbDomainNeedsList]  
     ELSE NULL  
     END AS [RapCbDomainNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [RapCaDomainIntensity]  
     ELSE NULL  
     END AS [RapCaDomainIntensity]  
    ,[RapCaDomainComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [RapCaDomainNeedsList]  
     ELSE NULL  
     END AS [RapCaDomainNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [RapHhcDomainIntensity]  
     ELSE NULL  
     END AS [RapHhcDomainIntensity]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [OutsideReferralsGiven]  
     ELSE NULL  
     END AS [OutsideReferralsGiven]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [ReferralsNarrative]  
     ELSE NULL  
     END AS [ReferralsNarrative]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [ServiceOther]  
     ELSE NULL  
     END AS [ServiceOther]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [ServiceOtherDescription]  
     ELSE NULL  
     END AS [ServiceOtherDescription]  
    ,[AssessmentAddtionalInformation]  
     ,CASE WHEN  @SameEpisode='Y' THEN TreatmentAccomodation ELSE NULL END AS [TreatmentAccomodation] 
    ,CASE   
     WHEN @AssessmentType = 'I'  
      THEN @AccomationNeededInquiryValues  
     ELSE [TreatmentAccomodation]  
     END AS [TreatmentAccomodation] -- Added by Rakesh w.rf to task 135                              
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [Participants]  
     ELSE NULL  
     END AS [Participants]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [Facilitator]  
     ELSE NULL  
     END AS [Facilitator]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [TimeLocation]  
     ELSE NULL  
     END AS [TimeLocation]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [AssessmentsNeeded]  
     ELSE NULL  
     END AS [AssessmentsNeeded]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [CommunicationAccomodations]  
     ELSE NULL  
     END AS [CommunicationAccomodations]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [IssuesToAvoid]  
     ELSE NULL  
     END AS [IssuesToAvoid]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [IssuesToDiscuss]  
     ELSE NULL  
     END AS [IssuesToDiscuss]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SourceOfPrePlanningInfo]  
     ELSE NULL  
     END AS [SourceOfPrePlanningInfo]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SelfDeterminationDesired]  
     ELSE NULL  
     END AS [SelfDeterminationDesired]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [FiscalIntermediaryDesired]  
     ELSE NULL  
     END AS [FiscalIntermediaryDesired]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PamphletGiven]  
     ELSE NULL  
     END AS [PamphletGiven]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PamphletDiscussed]  
     ELSE NULL  
     END AS [PamphletDiscussed]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PrePlanIndependentFacilitatorDiscussed]  
     ELSE NULL  
     END AS [PrePlanIndependentFacilitatorDiscussed]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PrePlanIndependentFacilitatorDesired]  
     ELSE NULL  
     END AS [PrePlanIndependentFacilitatorDesired]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PrePlanGuardianContacted]  
     ELSE NULL  
     END AS [PrePlanGuardianContacted]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PrePlanSeparateDocument]  
     ELSE NULL  
     END AS [PrePlanSeparateDocument]  
    ,[CommunityActivitiesCurrentDesired]  
    ,[CommunityActivitiesIncreaseDesired]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [CommunityActivitiesNeedsList]  
     ELSE NULL  
     END AS [CommunityActivitiesNeedsList]  
    ,CASE WHEN adultorchild = 'A' THEN [PsCurrentHealthIssues] ELSE NULL END AS [PsCurrentHealthIssues]  
    ,[PsCurrentHealthIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsCurrentHealthIssuesNeedsList]  
     ELSE NULL  
     END AS [PsCurrentHealthIssuesNeedsList]  
     ,CASE WHEN adultorchild = 'A' THEN PsMedicationsSideEffects ELSE NULL END AS PsMedicationsSideEffects  
    ,[HistMentalHealthTx]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [HistMentalHealthTxNeedsList]  
     ELSE NULL  
     END AS [HistMentalHealthTxNeedsList]  
    ,[HistMentalHealthTxComment]  
    ,[HistFamilyMentalHealthTx]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [HistFamilyMentalHealthTxNeedsList]  
     ELSE NULL  
     END AS [HistFamilyMentalHealthTxNeedsList]  
    ,[HistFamilyMentalHealthTxComment]  
    ,[PsClientAbuseIssues]  
    ,[PsClientAbuesIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsClientAbuseIssuesNeedsList]  
     ELSE NULL  
     END AS [PsClientAbuseIssuesNeedsList]  
    ,[PsFamilyConcernsComment]  
    ,[PsRiskLossOfPlacement]  
    ,[PsRiskLossOfPlacementDueTo]  
    ,[PsRiskSensoryMotorFunction]  
    ,[PsRiskSensoryMotorFunctionDueTo]  
    ,[PsRiskSafety]  
    ,[PsRiskSafetyDueTo]  
    ,[PsRiskLossOfSupport]  
    ,[PsRiskLossOfSupportDueTo]  
    ,[PsRiskExpulsionFromSchool]  
    ,[PsRiskExpulsionFromSchoolDueTo]  
    ,[PsRiskHospitalization]  
    ,[PsRiskHospitalizationDueTo]  
    ,[PsRiskCriminalJusticeSystem]  
    ,[PsRiskCriminalJusticeSystemDueTo]  
    ,[PsRiskElopementFromHome]  
    ,[PsRiskElopementFromHomeDueTo]  
    ,[PsRiskLossOfFinancialStatus]  
    ,[PsRiskLossOfFinancialStatusDueTo]  
    ,[PsDevelopmentalMilestones]  
    ,[PsDevelopmentalMilestonesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsDevelopmentalMilestonesNeedsList]  
     ELSE NULL  
     END AS [PsDevelopmentalMilestonesNeedsList]  
    ,[PsChildEnvironmentalFactors]  
    ,[PsChildEnvironmentalFactorsComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsChildEnvironmentalFactorsNeedsList]  
     ELSE NULL  
     END AS [PsChildEnvironmentalFactorsNeedsList]  
    ,[PsLanguageFunctioning]  
    ,[PsLanguageFunctioningComment]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [PsLanguageFunctioningNeedsList]  
    -- ELSE NULL  
    -- END AS [PsLanguageFunctioningNeedsList]  
    ,[PsVisualFunctioning]  
    ,[PsVisualFunctioningComment]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [PsVisualFunctioningNeedsList]  
    -- ELSE NULL  
    -- END AS [PsVisualFunctioningNeedsList]  
    ,[PsPrenatalExposure]  
    ,[PsPrenatalExposureComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsPrenatalExposureNeedsList]  
     ELSE NULL  
     END AS [PsPrenatalExposureNeedsList]  
    ,[PsChildMentalHealthHistory]  
    ,[PsChildMentalHealthHistoryComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsChildMentalHealthHistoryNeedsList]  
     ELSE NULL  
     END AS [PsChildMentalHealthHistoryNeedsList]  
    ,[PsIntellectualFunctioning]  
    ,[PsIntellectualFunctioningComment]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [PsIntellectualFunctioningNeedsList]  
    -- ELSE NULL  
    -- END AS [PsIntellectualFunctioningNeedsList]  
    ,[PsLearningAbility]  
    ,[PsLearningAbilityComment]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [PsLearningAbilityNeedsList]  
    -- ELSE NULL  
    -- END AS [PsLearningAbilityNeedsList]  
    ,[PsFunctioningConcernComment]  
    ,[PsPeerInteraction]  
    ,[PsPeerInteractionComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsPeerInteractionNeedsList]  
     ELSE NULL  
     END AS [PsPeerInteractionNeedsList]  
     ,case when @SameEpisode='Y' then PsParentalParticipation ELSE NULL end as [PsParentalParticipation] 
      ,case when @SameEpisode='Y' then FamilyRelationshipIssues ELSE NULL end as FamilyRelationshipIssues
    ,[PsParentalParticipationComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsParentalParticipationNeedsList]  
     ELSE NULL  
     END AS [PsParentalParticipationNeedsList]  
    ,[PsSchoolHistory]  
    ,[PsSchoolHistoryComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSchoolHistoryNeedsList]  
     ELSE NULL  
     END AS [PsSchoolHistoryNeedsList]  
    --,[PsImmunizations]  
    ,[PsImmunizationsComment]  
    --,CASE   
    -- WHEN @AssessmentType IN ('U') 
    --  THEN [PsImmunizationsNeedsList]  
    -- ELSE NULL  
    -- END AS [PsImmunizationsNeedsList]  
    ,case when @SameEpisode='Y' then PsChildHousingIssues else null end as [PsChildHousingIssues]  
    ,[PsChildHousingIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsChildHousingIssuesNeedsList]  
     ELSE NULL  
     END AS [PsChildHousingIssuesNeedsList]  
    --,[PsSexuality]  
    ,[PsSexualityComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSexualityNeedsList]  
     ELSE NULL  
     END AS [PsSexualityNeedsList]  
    ,[PsFamilyFunctioning]  
    ,[PsFamilyFunctioningComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsFamilyFunctioningNeedsList]  
     ELSE NULL  
     END AS [PsFamilyFunctioningNeedsList]  
    ,[PsTraumaticIncident]  
    ,[PsTraumaticIncidentComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsTraumaticIncidentNeedsList]  
     ELSE NULL  
     END AS [PsTraumaticIncidentNeedsList]  
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
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsGrossFineMotorNeedsList]  
     ELSE NULL  
     END AS [PsGrossFineMotorNeedsList]  
    ,[PsSensoryPerceptual]  
    ,[PsSensoryPerceptualComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSensoryPerceptualNeedsList]  
     ELSE NULL  
     END AS [PsSensoryPerceptualNeedsList]  
    ,[PsCognitiveFunction]  
    ,[PsCognitiveFunctionComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsCognitiveFunctionNeedsList]  
     ELSE NULL  
     END AS [PsCognitiveFunctionNeedsList]  
    ,[PsCommunicativeFunction]  
    ,[PsCommunicativeFunctionComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsCommunicativeFunctionNeedsList]  
     ELSE NULL  
     END AS [PsCommunicativeFunctionNeedsList]  
    ,[PsCurrentPsychoSocialFunctiion]  
    ,[PsCurrentPsychoSocialFunctiionComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsCurrentPsychoSocialFunctiionNeedsList]  
     ELSE NULL  
     END AS [PsCurrentPsychoSocialFunctiionNeedsList]  
    ,[PsAdaptiveEquipment]  
    ,[PsAdaptiveEquipmentComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsAdaptiveEquipmentNeedsList]  
     ELSE NULL  
     END AS [PsAdaptiveEquipmentNeedsList]  
    ,[PsSafetyMobilityHome]  
    ,[PsSafetyMobilityHomeComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSafetyMobilityHomeNeedsList]  
     ELSE NULL  
     END AS [PsSafetyMobilityHomeNeedsList]  
    ,[PsHealthSafetyChecklistComplete]  
    ,[PsAccessibilityIssues]  
    ,[PsAccessibilityIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsAccessibilityIssuesNeedsList]  
     ELSE NULL  
     END AS [PsAccessibilityIssuesNeedsList]  
    ,[PsEvacuationTraining]  
    ,[PsEvacuationTrainingComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsEvacuationTrainingNeedsList]  
     ELSE NULL  
     END AS [PsEvacuationTrainingNeedsList]  
    ,[Ps24HourSetting]  
    ,[Ps24HourSettingComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [Ps24HourSettingNeedsList]  
     ELSE NULL  
     END AS [Ps24HourSettingNeedsList]  
    ,[Ps24HourNeedsAwakeSupervision]  
    ,[PsSpecialEdEligibility]  
    ,[PsSpecialEdEligibilityComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSpecialEdEligibilityNeedsList]  
     ELSE NULL  
     END AS [PsSpecialEdEligibilityNeedsList]  
    ,[PsSpecialEdEnrolled]  
    ,[PsSpecialEdEnrolledComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSpecialEdEnrolledNeedsList]  
     ELSE NULL  
     END AS [PsSpecialEdEnrolledNeedsList]  
    ,[PsEmployer]  
    ,[PsEmployerComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsEmployerNeedsList]  
     ELSE NULL  
     END AS [PsEmployerNeedsList]  
    ,[PsEmploymentIssues]  
    ,[PsEmploymentIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsEmploymentIssuesNeedsList]  
     ELSE NULL  
     END AS [PsEmploymentIssuesNeedsList]  
    ,[PsRestrictionsOccupational]  
    ,[PsRestrictionsOccupationalComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsRestrictionsOccupationalNeedsList]  
     ELSE NULL  
     END AS [PsRestrictionsOccupationalNeedsList]  
    ,[PsFunctionalAssessmentNeeded]  
    ,[PsAdvocacyNeeded]  
    ,[PsPlanDevelopmentNeeded]  
    ,[PsLinkingNeeded]  
    ,[PsDDInformationProvidedBy]  
    ,[HistPreviousDx]  
    ,[HistPreviousDxComment]  
    ,[PsLegalIssues]  
    ,[PsLegalIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsLegalIssuesNeedsList]  
     ELSE NULL  
     END AS [PsLegalIssuesNeedsList]  
    ,[PsCulturalEthnicIssues]  
    ,[PsCulturalEthnicIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsCulturalEthnicIssuesNeedsList]  
     ELSE NULL  
     END AS [PsCulturalEthnicIssuesNeedsList]  
    ,[PsSpiritualityIssues]  
    ,[PsSpiritualityIssuesComment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsSpiritualityIssuesNeedsList]  
     ELSE NULL  
     END AS [PsSpiritualityIssuesNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicideNotPresent]  
     ELSE NULL  
     END AS [SuicideNotPresent]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicideIdeation]  
     ELSE NULL  
     END AS [SuicideIdeation]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicideActive]  
     ELSE NULL  
     END AS [SuicideActive]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicidePassive]  
     ELSE NULL  
     END AS [SuicidePassive]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicideMeans]  
     ELSE NULL  
     END AS [SuicideMeans]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicidePlan]  
     ELSE NULL  
     END AS [SuicidePlan]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicideCurrent]  
     ELSE NULL  
     END AS [SuicideCurrent]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [SuicidePriorAttempt]  
     ELSE NULL  
     END AS [SuicidePriorAttempt]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [SuicideNeedsList]  
    -- ELSE NULL  
    -- END AS [SuicideNeedsList]  
    ,[SuicideBehaviorsPastHistory]  
    ,[SuicideOtherRiskSelf]  
    ,[SuicideOtherRiskSelfComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicideNotPresent]  
     ELSE NULL  
     END AS [HomicideNotPresent]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicideIdeation]  
     ELSE NULL  
     END AS [HomicideIdeation]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicideActive]  
     ELSE NULL  
     END AS [HomicideActive]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicidePassive]  
     ELSE NULL  
     END AS [HomicidePassive]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicideMeans]  
     ELSE NULL  
     END AS [HomicideMeans]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicidePlan]  
     ELSE NULL  
     END AS [HomicidePlan]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicideCurrent]  
     ELSE NULL  
     END AS [HomicideCurrent]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [HomicidePriorAttempt]  
     ELSE NULL  
     END AS [HomicidePriorAttempt]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [HomicideNeedsList]  
    -- ELSE NULL  
    -- END AS [HomicideNeedsList]  
    ,[HomicideBehaviorsPastHistory]  
    ,[HomicdeOtherRiskOthers]  
    ,[HomicideOtherRiskOthersComment]  
    ,[PhysicalAgressionNotPresent]  
    ,[PhysicalAgressionSelf]  
    ,[PhysicalAgressionOthers]  
    ,[PhysicalAgressionCurrentIssue]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PhysicalAgressionNeedsList]  
     ELSE NULL  
     END AS [PhysicalAgressionNeedsList]  
    ,[PhysicalAgressionBehaviorsPastHistory]  
    ,[RiskAccessToWeapons]  
    ,[RiskAppropriateForAdditionalScreening]  
    ,[RiskClinicalIntervention]  
    ,[RiskOtherFactorsNone]  
    ,[RiskOtherFactors]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [RiskOtherFactorsNeedsList]  
     ELSE NULL  
     END AS [RiskOtherFactorsNeedsList]  
    ,[StaffAxisV]  
    ,[StaffAxisVReason]  
    ,[ClientStrengthsNarrative]  
    ,[CrisisPlanningClientHasPlan]  
    ,[CrisisPlanningNarrative]  
    ,[CrisisPlanningDesired]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [CrisisPlanningNeedsList]  
     ELSE NULL  
     END AS [CrisisPlanningNeedsList]  
    ,[CrisisPlanningMoreInfo]  
    ,[AdvanceDirectiveClientHasDirective]  
    --,[AdvanceDirectiveDesired]  
    ,[AdvanceDirectiveNarrative]  
    --,CASE   
    -- WHEN @AssessmentType IN ( 'U','A' )
    --  THEN [AdvanceDirectiveNeedsList]  
    -- ELSE NULL  
    -- END AS [AdvanceDirectiveNeedsList]  
    --,[AdvanceDirectiveMoreInfo]  
    ,[NaturalSupportSufficiency]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [NaturalSupportNeedsList]  
     ELSE NULL  
     END AS [NaturalSupportNeedsList]  
    ,[NaturalSupportIncreaseDesired]  
      ,CASE WHEN  @SameEpisode='Y' THEN ClinicalSummary ELSE NULL END AS [ClinicalSummary]               
    ,CASE   
     WHEN @AssessmentType IN('U','A')
      THEN [ClinicalSummary]  
     WHEN @AssessmentType = 'I'  
      THEN @DispostionComment  
     ELSE NULL  
     END AS [ClinicalSummary]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeQuestionU]  
     ELSE NULL  
     END AS [UncopeQuestionU]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeApplicable]  
     ELSE NULL  
     END AS [UncopeApplicable]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeApplicableReason]  
     ELSE NULL  
     END AS [UncopeApplicableReason]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeQuestionN]  
     ELSE NULL  
     END AS [UncopeQuestionN]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeQuestionC]  
     ELSE NULL  
     END AS [UncopeQuestionC]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeQuestionO]  
     ELSE NULL  
     END AS [UncopeQuestionO]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeQuestionP]  
     ELSE NULL  
     END AS [UncopeQuestionP]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeQuestionE]  
     ELSE NULL  
     END AS [UncopeQuestionE]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [UncopeCompleteFullSUAssessment]  
     ELSE NULL  
     END AS [UncopeCompleteFullSUAssessment]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [SubstanceUseNeedsList]  
     ELSE NULL  
     END AS [SubstanceUseNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [DecreaseSymptomsNeedsList]  
     ELSE NULL  
     END AS [DecreaseSymptomsNeedsList]  
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
    ,[YouthTotalScore]  
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
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [DischargeCriteria]  
     ELSE NULL  
     END AS [DischargeCriteria]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PrePlanFiscalIntermediaryComment]  
     ELSE NULL  
     END AS [PrePlanFiscalIntermediaryComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [StageOfChange]  
     ELSE NULL  
     END AS [StageOfChange]  
    ,[PsEducation]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsEducationNeedsList]  
     ELSE NULL  
     END AS [PsEducationNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PsMedications]  
     ELSE NULL  
     END AS [PsMedications]  
    ,CASE   
     WHEN @AssessmentType IN ( 'U','A' )
      THEN [PsMedicationsNeedsList]  
     ELSE NULL  
     END AS [PsMedicationsNeedsList]  
    ,CASE   
     WHEN @AssessmentType IN (  
        'U','A'   
       ,'I'  
       )  
      THEN [PsMedicationsListToBeModified]  
     ELSE NULL  
     END AS [PsMedicationsListToBeModified]  
    ,[PhysicalConditionQuadriplegic]  
    ,[PhysicalConditionMultipleSclerosis]  
    ,[PhysicalConditionBlindness]  
    ,[PhysicalConditionDeafness]  
    ,[PhysicalConditionParaplegic]  
    ,[PhysicalConditionCerebral]  
    ,[PhysicalConditionMuteness]  
    ,[PhysicalConditionOtherHearingImpairment]  
    ,[TestingReportsReviewed]  
    ,NULL as [LOCId]  
    ,[PreplanSeparateDocument]  
    --,[UncopeCompleteFullSUAssessment]  
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
    ,ClientInAutsimPopulation
	,CASE WHEN  @SameEpisode='Y' THEN LegalIssues ELSE NULL END AS [LegalIssues]
	--,CSSRSAdultOrChild  
	,CASE WHEN  @SameEpisode='Y' THEN Strengths ELSE NULL END AS [Strengths]
	,CASE WHEN  @SameEpisode='Y' THEN TransitionLevelOfCare ELSE NULL END AS [TransitionLevelOfCare] 
	,CASE WHEN  @SameEpisode='Y' THEN ReductionInSymptoms ELSE NULL END AS [ReductionInSymptoms] 
	,CASE WHEN  @SameEpisode='Y' THEN AttainmentOfHigherFunctioning ELSE NULL END AS [AttainmentOfHigherFunctioning] 
	,CASE WHEN  @SameEpisode='Y' THEN TreatmentNotNecessary ELSE NULL END AS [TreatmentNotNecessary] 
	,CASE WHEN  @SameEpisode='Y' THEN OtherTransitionCriteria ELSE NULL END AS [OtherTransitionCriteria] 
	,CASE WHEN  @SameEpisode='Y' THEN EstimatedDischargeDate ELSE NULL END AS [EstimatedDischargeDate] 
	,ReductionInSymptomsDescription
	,AttainmentOfHigherFunctioningDescription
	,TreatmentNotNecessaryDescription
	,OtherTransitionCriteriaDescription 
	,PsRiskHigherLevelOfCare
,case when @SameEpisode='Y' then PsRiskHigherLevelOfCareDueTo ELSE NULL end as  PsRiskHigherLevelOfCareDueTo
,case when @SameEpisode='Y' then PsRiskOutOfCountryPlacement ELSE NULL end as  PsRiskOutOfCountryPlacement
,case when @SameEpisode='Y' then PsRiskOutOfCountryPlacementDueTo ELSE NULL end as  PsRiskOutOfCountryPlacementDueTo
,case when @SameEpisode='Y' then PsRiskOutOfHomePlacement ELSE NULL end as  PsRiskOutOfHomePlacement
,case when @SameEpisode='Y' then PsRiskOutOfHomePlacementDueTo ELSE NULL end as  PsRiskOutOfHomePlacementDueTo
,CommunicableDiseaseAssessed
,CommunicableDiseaseFurtherInfo   
   FROM CustomHRMAssessments CHA  
   LEFT OUTER JOIN GlobalCodes G ON CHA.GuardianType = G.GlobalCodeId  
   WHERE (ISNULL(CHA.RecordDeleted, 'N') = 'N')  
    AND (CHA.DocumentVersionId = @LatestDocumentVersionID)  
    AND IsNull(G.RecordDeleted, 'N') = 'N'  
  
 
   
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
   --FROM CustomCAFAS2 CC2  
   --WHERE CC2.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
   
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
    , CASE WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
     THEN [HistoryOrCurrentDomesticAbuse]  
      ELSE NULL  END AS [HistoryOrCurrentDomesticAbuse]   
    ,[NumberOfTimesDomesticAbuse]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [LossOfControl]  
      ELSE NULL  
      END AS [LossOfControl]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [IncreasedTolerance]  
      ELSE NULL  
      END AS [IncreasedTolerance]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [OtherConsequence]  
      ELSE NULL  
      END AS [OtherConsequence]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [OtherConsequenceDescription]  
      ELSE NULL  
      END AS [OtherConsequenceDescription]  
    -- ,NULL as [RiskOfRelapse]  
     ,[PreviousTreatment]  
     --,NULL as [CurrentSubstanceAbuseTreatment]  
     --,NULL as [CurrentTreatmentProvider]  
     --,NULL as [CurrentSubstanceAbuseReferralToSAorTx]  
     --,NULL as [CurrentSubstanceAbuseRefferedReason]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [ToxicologyResults]  
      ELSE NULL  
      END AS [ToxicologyResults]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [SubstanceAbuseAdmittedOrSuspected]  
      ELSE NULL  
      END AS [SubstanceAbuseAdmittedOrSuspected]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [ClientSAHistory]  
      ELSE NULL  
      END AS [ClientSAHistory]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [FamilySAHistory]  
      ELSE NULL  
      END AS [FamilySAHistory]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [NoSubstanceAbuseSuspected]  
      ELSE NULL  
      END AS [NoSubstanceAbuseSuspected]  
     ,NULL as [DUI30Days]  
     ,NULL as[DUI5Years]  
     ,NULL as [DWI30Days]  
     ,NULL as [DWI5Years]  
     ,NULL as [Possession30Days]  
     ,NULL as [Possession5Years]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [CurrentSubstanceAbuse]  
      ELSE NULL  
      END AS [CurrentSubstanceAbuse]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [SuspectedSubstanceAbuse]  
      ELSE NULL  
      END AS [SuspectedSubstanceAbuse]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [SubstanceAbuseDetail]  
      ELSE NULL  
      END AS [SubstanceAbuseDetail]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [SubstanceAbuseTxPlan]  
      ELSE NULL  
      END AS [SubstanceAbuseTxPlan]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [OdorOfSubstance]  
      ELSE NULL  
      END AS [OdorOfSubstance]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [SlurredSpeech]  
      ELSE NULL  
      END AS [SlurredSpeech]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [WithdrawalSymptoms]  
      ELSE NULL  
      END AS [WithdrawalSymptoms]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [DTOther]  
      ELSE NULL  
      END AS [DTOther]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [DTOtherText]  
      ELSE NULL  
      END AS [DTOtherText]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [Blackouts]  
      ELSE NULL  
      END AS [Blackouts]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [RelatedArrests]  
      ELSE NULL  
      END AS [RelatedArrests]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [RelatedSocialProblems]  
      ELSE NULL  
      END AS [RelatedSocialProblems]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [FrequentJobSchoolAbsence]  
      ELSE NULL  
      END AS [FrequentJobSchoolAbsence]  
     ,CASE   
      WHEN @AssessmentType IN (  
         'U','A'   
        ,'I'  
        )  
       THEN [NoneSynptomsReportedOrObserved]  
      ELSE NULL  
      END AS [NoneSynptomsReportedOrObserved] 
     -- ,Comment 
    ,CSUA.[CreatedBy]  
    ,CSUA.[CreatedDate]  
    ,CSUA.[ModifiedBy]  
    ,CSUA.[ModifiedDate]  
     ,[RecordDeleted]  
     ,[DeletedDate]  
     ,[DeletedBy]  
  ,PreviousMedication  
    --,CurrentSubstanceAbuseMedication  
    --,CSUA.MedicationAssistedTreatment
    --,NULL as [MedicationAssistedTreatmentRefferedReason]
   FROM CustomSubstanceUseAssessments CSUA  
   WHERE CSUA.DocumentVersionId = @LatestDocumentVersionID  
     AND IsNull(RecordDeleted, 'N') = 'N'  
 
   SELECT 'CustomSubstanceUseHistory2' AS TableName  
    --,0 AS 'SubstanceUseHistoryId' --commented by hemant 
    ,CSUA.[CreatedBy]  
    ,CSUA.[CreatedDate]  
    ,CSUA.[ModifiedBy]  
    ,CSUA.[ModifiedDate]  
     ,[RecordDeleted]  
     ,[DeletedDate]  
     ,[DeletedBy]  
    ,- 1 AS DocumentVersionId
	,SUDrugId
	,AgeOfFirstUse
	,Frequency
	,Route
	,LastUsed
	,InitiallyPrescribed
	,Preference
	,FamilyHistory
	FROM CustomSubstanceUseHistory2 CSUA  
   WHERE CSUA.DocumentVersionId = @LatestDocumentVersionID  
     AND IsNull(RecordDeleted, 'N') = 'N' 

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
  
   
      -- CustomMentalStatuses2--                                                                     
   SELECT 'CustomMentalStatuses2' AS TableName  
    ,- 1 AS 'DocumentVersionId'  
    --,[AppearanceAddToNeedsList]  
    --,[AppearanceNeatClean]  
    --,[AppearancePoorHygiene]  
    --,[AppearanceWellGroomed]  
    --,[AppearanceAppropriatelyDressed]  
    --,[AppearanceYoungerThanStatedAge]  
    --,[AppearanceOlderThanStatedAge]  
    --,[AppearanceOverweight]  
    --,[AppearanceUnderweight]  
    --,[AppearanceEccentric]  
    --,[AppearanceSeductive]  
    --,[AppearanceUnkemptDisheveled]  
    --,[AppearanceOther]  
    --,[AppearanceComment]  
    --,[IntellectualAddToNeedsList]  
    --,[IntellectualAboveAverage]  
    --,[IntellectualAverage]  
    --,[IntellectualBelowAverage]  
    --,[IntellectualPossibleMR]  
    --,[IntellectualDocumentedMR]  
    --,[IntellectualOther]  
    --,[IntellectualComment]  
    --,[CommunicationAddToNeedsList]  
    --,[CommunicationNormal]  
    --,[CommunicationUsesSignLanguage]  
    --,[CommunicationUnableToRead]  
    --,[CommunicationNeedForBraille]  
    --,[CommunicationHearingImpaired]  
    --,[CommunicationDoesLipReading]  
    --,[CommunicationEnglishIsSecondLanguage]  
    --,[CommunicationTranslatorNeeded]  
    --,[CommunicationOther]  
    --,[CommunicationComment]  
    --,[MoodAddToNeedsList]  
    --,[MoodUnremarkable]  
    --,[MoodCooperative]  
    --,[MoodAnxious]  
    --,[MoodTearful]  
    --,[MoodCalm]  
    --,[MoodLabile]  
    --,[MoodPessimistic]  
    --,[MoodCheerful]  
    --,[MoodGuilty]  
    --,[MoodEuphoric]  
    --,[MoodDepressed]  
    --,[MoodHostile]  
    --,[MoodIrritable]  
    --,[MoodDramatized]  
    --,[MoodFearful]  
    --,[MoodSupicious]  
    --,[MoodOther]  
    --,[MoodComment]  
    --,[AffectAddToNeedsList]  
    --,[AffectPrimarilyAppropriate]  
    --,[AffectRestricted]  
    --,[AffectBlunted]  
    --,[AffectFlattened]  
    --,[AffectDetached]  
    --,[AffectPrimarilyInappropriate]  
    --,[AffectOther]  
    --,[AffectComment]  
    --,[SpeechAddToNeedsList]  
    --,[SpeechNormal]  
    --,[SpeechLogicalCoherent]  
    --,[SpeechTangential]  
    --,[SpeechSparseSlow]  
    --,[SpeechRapidPressured]  
    --,[SpeechSoft]  
    --,[SpeechCircumstantial]  
    --,[SpeechLoud]  
    --,[SpeechRambling]  
    --,[SpeechOther]  
    --,[SpeechComment]  
    --,[ThoughtAddToNeedsList]  
    --,[ThoughtUnremarkable]  
    --,[ThoughtParanoid]  
    --,[ThoughtGrandiose]  
    --,[ThoughtObsessive]  
    --,[ThoughtBizarre]  
    --,[ThoughtFlightOfIdeas]  
    --,[ThoughtDisorganized]  
    --,[ThoughtAuditoryHallucinations]  
    --,[ThoughtVisualHallucinations]  
    --,[ThoughtTactileHallucinations]  
    --,[ThoughtOther]  
    --,[ThoughtComment]  
    --,[BehaviorAddToNeedsList]  
    --,[BehaviorNormal]  
    --,[BehaviorRestless]  
    --,[BehaviorTremors]  
    --,[BehaviorPoorEyeContact]  
    --,[BehaviorAgitated]  
    --,[BehaviorPeculiar]  
    --,[BehaviorSelfDestructive]  
    --,[BehaviorSlowed]  
    --,[BehaviorDestructiveToOthers]  
    --,[BehaviorCompulsive]  
    --,[BehaviorOther]  
    --,[BehaviorComment]  
    --,[OrientationAddToNeedsList]  
    --,[OrientationToPersonPlaceTime]  
    --,[OrientationNotToPerson]  
    --,[OrientationNotToPlace]  
    --,[OrientationNotToTime]  
    --,[OrientationOther]  
    --,[OrientationComment]  
    --,[InsightAddToNeedsList]  
    --,[InsightGood]  
    --,[InsightFair]  
    --,[InsightPoor]  
    --,[InsightLacking]  
    --,[InsightOther]  
    --,[InsightComment]  
    --,[MemoryAddToNeedsList]  
    --,[MemoryGoodNormal]  
    --,[MemoryImpairedShortTerm]  
    --,[MemoryImpairedLongTerm]  
    --,[MemoryOther]  
    --,[MemoryComment]  
    --,[RealityOrientationAddToNeedsList]  
    --,[RealityOrientationIntact]  
    --,[RealityOrientationTenuous]  
    --,[RealityOrientationPoor]  
    --,[RealityOrientationOther]  
    --,[RealityOrientationComment]  
    ----,[RowIdentifier]  
    ,CMS.[CreatedBy]  
    ,CMS.[CreatedDate]  
    ,CMS.[ModifiedBy]  
    ,CMS.[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM CustomMentalStatuses2 CMS  
   WHERE CMS.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
 
    --- Added by Rakesh to Intialiaze Default Rows CustomDocumentCRAFFTs      
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
   LEFT OUTER JOIN CustomDocumentCRAFFTs CDC ON s.DatabaseVersion = - 1  
  
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
     ,- 1 AS DocumentVersionId  
    ,CASE WHEN  @SameEpisode='Y' THEN Disposition ELSE NULL END AS Disposition  
   FROM CustomDispositions CD  
   WHERE CD.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
   
  
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
    ,CASE WHEN  @SameEpisode='Y' THEN ServiceType ELSE NULL END AS ServiceType  
    ,- 1 AS CustomDispositionId 
    FROM  CustomServiceDispositions CSD JOIN 
    CustomDispositions CD  ON CSD.CustomDispositionId=CD.CustomDispositionId
    WHERE CD.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
   --FROM SystemConfigurations AS s  
   --LEFT OUTER JOIN CustomServiceDispositions CSD ON s.DatabaseVersion = - 1  
  
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
    ,CASE WHEN  @SameEpisode='Y' THEN ProgramId ELSE NULL END AS ProgramId  
     ,- 1 AS CustomServiceDispositionId 
    FROM CustomProviderServices CPS JOIN
    CustomServiceDispositions CSD ON CPS.CustomServiceDispositionId = CSD.CustomServiceDispositionId
    JOIN 
    CustomDispositions CD  ON CSD.CustomDispositionId=CD.CustomDispositionId
    WHERE CD.DocumentVersionId = @LatestScreeenTypeDocumentVersionId 
   --FROM SystemConfigurations AS s  
   --LEFT OUTER JOIN CustomProviderServices CPS ON s.DatabaseVersion = - 1  
  
   --- CustomASAMPlacements ----   
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
   FROM CustomASAMPlacements b  
   WHERE b.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
 
  
  --Changes end here          
  ---CustomDocumentAssessmentSubstanceUses---        

   SELECT 'CustomDocumentAssessmentSubstanceUses' AS TableName  
    -- ,ISNULL(CDA.DocumentVersionId, - 1) AS DocumentVersionId            
    ,- 1 AS 'DocumentVersionId'  
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
   --FROM SystemConfigurations AS s            
   --  LEFT OUTER JOIN CustomDocumentAssessmentSubstanceUses CDA ON s.DatabaseVersion = - 1         
   FROM CustomDocumentAssessmentSubstanceUses CDA  
   WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
 
  -----DocumentFamilyHistory---         
  --SELECT 'DocumentFamilyHistory' AS TableName  
  -- ,DocumentFamilyHistoryId  
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
  --  WHEN  'U'
  --   THEN 'Unknown'  
  --  END  
  -- ,OtherComment  
  --FROM DocumentFamilyHistory  
  --WHERE DocumentVersionId = @LatestDocumentVersionID  
  -- AND ISNULL(DocumentFamilyHistory.RecordDeleted, 'N') = 'N'  
  

   --SELECT 'CustomDocumentPreEmploymentActivities' AS TableName  
   -- ,- 1 AS DocumentVersionId  
   -- ,CDP.CreatedBy  
   -- ,CDP.CreatedDate  
   -- ,CDP.ModifiedBy  
   -- ,CDP.ModifiedDate  
   -- ,RecordDeleted  
   -- ,DeletedBy  
   -- ,DeletedDate  
   -- --,EducationTraining  
   -- --,EducationTrainingNeeds  
   -- --,EducationTrainingNeedsComments  
   -- --,PersonalCareerPlanning  
   -- --,PersonalCareerPlanningNeeds  
   -- --,PersonalCareerPlanningNeedsComments  
   -- --,EmploymentOpportunities  
   -- --,EmploymentOpportunitiesNeeds  
   -- --,EmploymentOpportunitiesNeedsComments  
   -- --,SupportedEmployment  
   -- --,SupportedEmploymentNeeds  
   -- --,SupportedEmploymentNeedsComments  
   -- --,WorkHistory  
   -- --,WorkHistoryNeeds  
   -- --,WorkHistoryNeedsComments  
   -- --,GainfulEmploymentBenefits  
   -- --,GainfulEmploymentBenefitsNeeds  
   -- --,GainfulEmploymentBenefitsNeedsComments  
   -- --,GainfulEmployment  
   -- --,GainfulEmploymentNeeds  
   -- --,GainfulEmploymentNeedsComments  
   --FROM CustomDocumentPreEmploymentActivities CDP  
   --WHERE DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
 
  
  --SELECT 'CustomDocumentSafetyCrisisPlans' AS TableName  
  -- ,ISNULL(CDSCP.DocumentVersionId, - 1) AS DocumentVersionId  
  -- ,CDSCP.CreatedBy  
  -- ,CDSCP.CreatedDate  
  -- ,CDSCP.ModifiedBy  
  -- ,CDSCP.ModifiedDate  
  -- ,CDSCP.RecordDeleted  
  -- ,CDSCP.DeletedBy  
  -- ,CDSCP.DeletedDate  
  -- --,ClientHasCurrentCrisis  
  -- --,WarningSignsCrisis  
  -- --,CopingStrategies  
  -- --,ThreeMonths  
  -- --,TwelveMonths  
  ----,DateOfCrisis    
  ----,(SELECT DOB FROM clients WHERE Clientid = @ClientId) AS DOB   
  ----,ProgramId    
  ----,StaffId    
  ----,SignificantOther    
  ----,CurrentCrisisDescription    
  ----,CurrentCrisisSpecificactions    
  --FROM SystemConfigurations AS s  
  --LEFT JOIN CustomDocumentSafetyCrisisPlans CDSCP ON CDSCP.DocumentVersionId = @LatestScreeenTypeDocumentVersionId  
  
  
  
 
  
  -----CustomDailyLivingActivityScores---    
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
  --WHERE CDL.DocumentVersionId = @LatestDocumentVersionId 
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
   ,0  ;
   
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
   
   --CustomDocumentCSSRSAdultScreeners,CustomDocumentCSSRSAdultSinceLastVisits,CustomDocumentCSSRSChildSinceLastVisits
 -- SELECT 'CustomDocumentCSSRSAdultScreeners' AS TableName  
 --  ,DocumentVersionId
	--,CreatedBy
	--,CreatedDate
	--,ModifiedBy
	--,ModifiedDate
	--,RecordDeleted
	--,DeletedBy
	--,DeletedDate
	--,WishToBeDead
	--,SuicidalThoughts
	--,SuicidalThoughtsWithMethods
	--,SuicidalIntentWithoutSpecificPlan
	--,SuicidalIntentWithSpecificPlan
	--,SuicidalBehaviorQuestion
	--,HowLongAgoSuicidalBehavior
 -- FROM CustomDocumentCSSRSAdultScreeners CDCAS  
 -- WHERE CDCAS.DocumentVersionId = @LatestDocumentVersionId 
 --  AND ISNULL(CDCAS.RecordDeleted, 'N') = 'N'
   
   
 --  	--CustomDocumentCSSRSAdultSinceLastVisits
	--	SELECT 'CustomDocumentCSSRSAdultSinceLastVisits' AS TableName 
	--	,DocumentVersionId
	--	,CreatedBy
	--	,CreatedDate
	--	,ModifiedBy
	--	,ModifiedDate
	--	,RecordDeleted
	--	,DeletedBy
	--	,DeletedDate
	--	,WishToBeDead
	--	,SuicidalThoughts
	--	,SuicidalThoughtsWithMethods
	--	,SuicidalIntentWithoutSpecificPlan
	--	,SuicidalIntentWithSpecificPlan
	--	,SuicidalBehaviorQuestion
	--FROM CustomDocumentCSSRSAdultSinceLastVisits
	--WHERE DocumentVersionId = @LatestDocumentVersionId
	--	AND ISNULL(RecordDeleted, 'N') <> 'Y'
 -- --CustomDocumentCSSRSChildSinceLastVisits
 --     SELECT 'CustomDocumentCSSRSChildSinceLastVisits' AS TableName  
 --     ,DocumentVersionId
	--	,[CreatedBy]
	--	,[CreatedDate]
	--	,ModifiedBy
	--	,ModifiedDate
	--	,RecordDeleted
	--	,DeletedBy
	--	,DeletedDate
	--	,WishToBeDead
	--	,WishToBeDeadDescription
	--	,NonSpecificActiveSuicidalThoughts
	--	,NonSpecificActiveSuicidalThoughtsDescription
	--	,ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToAct
	--	,ActiveSuicidalIdeationWithAnyMethodsWithoutIntentToActDescription
	--	,ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlan
	--	,ActiveSuicidalIdeationWithSomeIntentToActWithoutSpecificPlanDescription
	--	,AciveSuicidalIdeationWithSpecificPlanAndIntent
	--	,AciveSuicidalIdeationWithSpecificPlanAndIntentDescription
	--	,MostSevereIdeation
	--	,MostSevereIdeationDescription
	--	,Frequency
	--	,ActualAttempt
	--	,TotalNumberOfAttempts
	--	,ActualAttemptDescription
	--	,HasSubjectEngagedInNonSuicidalSelfInjuriousBehavior
	--	,HasSubjectEngagedInSelfInjuriousBehaviorIntentUnknown
	--	,InterruptedAttempt
	--	,TotalNumberOfAttemptsInterrupted
	--	,InterruptedAttemptDescription
	--	,AbortedOrSelfInterruptedAttempt
	--	,TotalNumberAttemptsAbortedOrSelfInterrupted
	--	,AbortedOrSelfInterruptedAttemptDescription
	--	,PreparatoryActsOrBehavior
	--	,TotalNumberOfPreparatoryActs
	--	,PreparatoryActsOrBehaviorDescription
	--	,SuicidalBehavior
	--	,MostLethalAttemptDate
	--	,ActualLethalityMedicalDamage
	--	,PotentialLethality
	--FROM CustomDocumentCSSRSChildSinceLastVisits
	--WHERE DocumentVersionId = @LatestDocumentVersionId
	--	AND ISNULL(RecordDeleted, 'N') <> 'Y'   
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
GO


