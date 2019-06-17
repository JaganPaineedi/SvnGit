
/****** Object:  StoredProcedure [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]    Script Date: 02/03/2015 13:31:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]    Script Date: 02/03/2015 13:31:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment] (  
 @DocumentVersionId INT  
 ,@InitializeDefaultValues CHAR(1)  
 ,@AssessmentType CHAR(1)  
 )  
AS  
/* Stored Procedure: [csp_SCHRMAssessmentIntializeTablesForReassessment]   */  
/* Copyright: 2006 Streamline SmartCare            */  
/* Creation Date:  24/Feb/2010               */  
/*                      */  
/* Purpose: To Initialize CustomPAAssessments Documents     */  
/*                      */  
/* Input Parameters: @DocumentVersionId, @InitializeDefaultValues, @AssessmentType  eg:- 14309,92,'N'    */  
/* Output Parameters:              */  
/* Return:                 */  
/* Called By:CustomDocuments Class Of DataService       */  
/* Calls:                 */  
/*                      */  
/* Data Modifications:                 */  
/*                      */  
/*   Updates:                   */  
/*       Date              Author                Purpose                            */  
/*       Sandeep Singh        */  
/*********************************************************************/  
BEGIN  
 BEGIN TRY  
  --CustomCAFAS2     
  IF EXISTS (  
    SELECT DocumentVersionId  
    FROM CustomCAFAS2  
    WHERE DocumentVersionId = @DocumentVersionId  
    )  
   AND (@InitializeDefaultValues = 'N')  
  BEGIN  
   SELECT 'CustomCAFAS2' AS TableName  
    ,- 1 AS 'DocumentVersionId'  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN NULL  
     ELSE [CAFASDate]  
     END AS [CAFASDate]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN NULL  
     ELSE [RaterClinician]  
     END AS [RaterClinician]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN NULL  
     ELSE [CAFASInterval]  
     END AS [CAFASInterval]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [SchoolPerformance]  
     END AS [SchoolPerformance]  
    ,[SchoolPerformanceComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [HomePerformance]  
     END AS [HomePerformance]  
    ,[HomePerfomanceComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [CommunityPerformance]  
     END AS [CommunityPerformance]  
    ,[CommunityPerformanceComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [BehaviorTowardsOther]  
     END AS [BehaviorTowardsOther]  
    ,[BehaviorTowardsOtherComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [MoodsEmotion]  
     END AS [MoodsEmotion]  
    ,[MoodsEmotionComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [SelfHarmfulBehavior]  
     END AS [SelfHarmfulBehavior]  
    ,[SelfHarmfulBehaviorComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [SubstanceUse]  
     END AS [SubstanceUse]  
    ,[SubstanceUseComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [Thinkng]  
     END AS [Thinkng]  
    ,[ThinkngComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [YouthTotalScore]  
     END AS [YouthTotalScore]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [PrimaryFamilyMaterialNeeds]  
     END AS [PrimaryFamilyMaterialNeeds]  
    ,[PrimaryFamilyMaterialNeedsComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [PrimaryFamilySocialSupport]  
     END AS [PrimaryFamilySocialSupport]  
    ,[PrimaryFamilySocialSupportComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [NonCustodialMaterialNeeds]  
     END AS [NonCustodialMaterialNeeds]  
    ,[NonCustodialMaterialNeedsComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [NonCustodialSocialSupport]  
     END AS [NonCustodialSocialSupport]  
    ,[NonCustodialSocialSupportComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [SurrogateMaterialNeeds]  
     END AS [SurrogateMaterialNeeds]  
    ,[SurrogateMaterialNeedsComment]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN 0  
     ELSE [SurrogateSocialSupport]  
     END AS [SurrogateSocialSupport]  
    ,[SurrogateSocialSupportComment]  
    ,CC2.[CreatedDate]  
    ,CC2.[CreatedBy]  
    ,CC2.[ModifiedDate]  
    ,CC2.[ModifiedBy]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM CustomCAFAS2 CC2  
   WHERE DocumentVersionId = @DocumentVersionId  
  END  
  ELSE  
  BEGIN  
   SELECT 'CustomCAFAS2' AS TableName  
    ,- 1 AS 'DocumentVersionId'  
    ,[CAFASDate]  
    ,[RaterClinician]  
    ,[CAFASInterval]  
    ,0 AS [SchoolPerformance]  
    ,[SchoolPerformanceComment]  
    ,0 AS [HomePerformance]  
    ,[HomePerfomanceComment]  
    ,0 AS [CommunityPerformance]  
    ,[CommunityPerformanceComment]  
    ,0 AS [BehaviorTowardsOther]  
    ,[BehaviorTowardsOtherComment]  
    ,0 AS [MoodsEmotion]  
    ,[MoodsEmotionComment]  
    ,0 AS [SelfHarmfulBehavior]  
    ,[SelfHarmfulBehaviorComment]  
    ,0 AS [SubstanceUse]  
    ,[SubstanceUseComment]  
    ,0 AS [Thinkng]  
    ,[ThinkngComment]  
    ,[YouthTotalScore]  
    ,0 AS [PrimaryFamilyMaterialNeeds]  
    ,[PrimaryFamilyMaterialNeedsComment]  
    ,0 AS [PrimaryFamilySocialSupport]  
    ,[PrimaryFamilySocialSupportComment]  
    ,0 AS [NonCustodialMaterialNeeds]  
    ,[NonCustodialMaterialNeedsComment]  
    ,0 AS [NonCustodialSocialSupport]  
    ,[NonCustodialSocialSupportComment]  
    ,0 AS [SurrogateMaterialNeeds]  
    ,[SurrogateMaterialNeedsComment]  
    ,0 AS [SurrogateSocialSupport]  
    ,[SurrogateSocialSupportComment]  
    ,CC2.[CreatedDate]  
    ,CC2.[CreatedBy]  
    ,CC2.[ModifiedDate]  
    ,CC2.[ModifiedBy]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM SystemConfigurations AS S  
   LEFT OUTER JOIN CustomCAFAS2 CC2 ON S.DatabaseVersion = - 1  
  END  
  
  -- CustomSubstanceUseHistory2         
  SELECT 'CustomSubstanceUseHistory2' AS TableName  
   ,Convert(INT, 0 - Row_Number() OVER (  
     ORDER BY [CustomSubstanceUseHistory2].[SubstanceUseHistoryId] ASC  
     )) AS [SubstanceUseHistoryId]  
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
   ,'SpecificCase_mdiv' AS ParentChildName  
  FROM [CustomSubstanceUseHistory2]  
  WHERE DocumentVersionId = @DocumentVersionId  
  
  ---- CustomHRMAssessmentRAPScores                                        
  --IF @AssessmentType = 'U'  
  --BEGIN  
  -- SELECT 'CustomHRMAssessmentRAPScores' AS TableName  
  --  ,Convert(INT, 0 - Row_Number() OVER (  
  --    ORDER BY [HRMAssessmentRAPQuestionId] DESC  
  --    )) AS [HRMAssessmentRAPQuestionId]  
  --  ,[DocumentVersionId]  
  --  ,[HRMRAPQuestionId]  
  --  ,[RAPAssessedValue]  
  --  ,[AddToNeedsList]  
  --  ,[RowIdentifier]  
  --  ,[CreatedBy]  
  --  ,[CreatedDate]  
  --  ,[ModifiedBy]  
  --  ,[ModifiedDate]  
  --  ,[RecordDeleted]  
  --  ,[DeletedDate]  
  --  ,[DeletedBy]  
  -- FROM [CustomHRMAssessmentRAPScores]  
  -- WHERE DocumentVersionId = @DocumentVersionId  
  --END  
  
  --CustomMentalStatuses2    
  IF EXISTS (  
    SELECT DocumentVersionId  
    FROM CustomMentalStatuses2  
    WHERE DocumentVersionId = @DocumentVersionId  
    )  
   AND @AssessmentType = 'U'  
  BEGIN  
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
    ,'N' AS 'OrientationAddToNeedsList'  
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
    ,CMS.[CreatedBy]  
    ,CMS.[CreatedDate]  
    ,CMS.[ModifiedBy]  
    ,CMS.[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM CustomMentalStatuses2 CMS  
   WHERE DocumentVersionId = @DocumentVersionId  
  END  
  ELSE --If record does't exists in CustomMentalStatus2 table get data from   
  BEGIN  
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
    ,'N' AS 'OrientationAddToNeedsList'  
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
    ,CM2.[CreatedBy]  
    ,CM2.[CreatedDate]  
    ,CM2.[ModifiedBy]  
    ,CM2.[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
   FROM SystemConfigurations AS S  
   LEFT OUTER JOIN CustomMentalStatuses2 CM2 ON S.DatabaseVersion = - 1  
  END  
  
  --CustomDailyLivingActivityScores                                         
  IF @AssessmentType = 'A'  
  BEGIN  
   SELECT 'CustomDailyLivingActivityScores' AS TableName  
    ,Convert(INT, 0 - Row_Number() OVER (  
      ORDER BY CustomDailyLivingActivityScores.DailyLivingActivityScoreId ASC  
      )) AS [DailyLivingActivityScoreId]  
    ,[DocumentVersionId]  
    ,[HRMActivityId]  
    ,[ActivityComment]  
    ,[CreatedBy]  
    ,[CreatedDate]  
    ,[ModifiedBy]  
    ,[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
    ,'SpecificCase_DivActivityContent' AS ParentChildName  
   FROM CustomDailyLivingActivityScores  
   WHERE DocumentVersionId = @DocumentVersionId  
  END  
  ELSE  
  BEGIN  
   SELECT 'CustomDailyLivingActivityScores' AS TableName  
    ,Convert(INT, 0 - Row_Number() OVER (  
      ORDER BY CustomDailyLivingActivityScores.DailyLivingActivityScoreId ASC  
      )) AS [DailyLivingActivityScoreId]  
    ,[DocumentVersionId]  
    ,[HRMActivityId]  
    ,CASE   
     WHEN @AssessmentType IN (  
       'A'  
       ,'I'  
       ,'S'  
       )  
      THEN NULL  
     ELSE [ActivityScore]  
     END AS [ActivityScore]  
    ,[ActivityComment]  
    ,[CreatedBy]  
    ,[CreatedDate]  
    ,[ModifiedBy]  
    ,[ModifiedDate]  
    ,[RecordDeleted]  
    ,[DeletedDate]  
    ,[DeletedBy]  
    ,'SpecificCase_DivActivityContent' AS ParentChildName  
   FROM CustomDailyLivingActivityScores  
   WHERE DocumentVersionId = @DocumentVersionId  
  END  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), '[csp_SCHRMAssessmentIntializeTablesForReassessment]') + '*****' + Convert(VARCHAR, ERROR_LINE()) +
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


