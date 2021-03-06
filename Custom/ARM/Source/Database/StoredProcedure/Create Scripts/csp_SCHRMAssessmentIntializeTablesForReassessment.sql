/****** Object:  StoredProcedure [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_SCHRMAssessmentIntializeTablesForReassessment]                                                                       
(                                                                                       
 @DocumentVersionId int,                                  
 @InitializeDefaultValues char(1),                                  
 @AssessmentType char(1)                                  
)                                                                                                            
AS                                        
 /* Stored Procedure: [csp_SCHRMAssessmentIntializeTablesForReassessment]   */                                                                                                                                                                                 
 /* Copyright: 2006 Streamline SmartCare								    */                                                                                                                                                                                                         
 /* Creation Date:  24/Feb/2010											    */                                                                                                                                                                                                               
 /*																		    */                                                                                                                                                                                                                     
 /* Purpose: To Initialize CustomPAAssessments Documents					*/                                                                                                                                                                                             
 /*																		    */                                                                                                                                                                                                                     
 /* Input Parameters: @DocumentVersionId, @InitializeDefaultValues, @AssessmentType  eg:- 14309,92,''N''    */                                                                       
 /* Output Parameters:														*/                                                                                                      
 /* Return:																	*/                                                                                                              
 /* Called By:CustomDocuments Class Of DataService							*/                                                                                                          
 /* Calls:																	*/                                                                                      
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
if exists (Select DocumentVersionId from CustomCAFAS2 where DocumentVersionId=@DocumentVersionId)and (@InitializeDefaultValues=''N'')     
begin                                                                               
                                                                                            
	SELECT ''CustomCAFAS2'' AS TableName,-1 as ''DocumentVersionId''                                                                                            
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then NULL else [CAFASDate] end as [CAFASDate]                                                                                                       
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then NULL else[RaterClinician] end as [RaterClinician]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then NULL else[CAFASInterval] end as [CAFASInterval]                                                     
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [SchoolPerformance] end as  [SchoolPerformance]                                                                                                     
      ,[SchoolPerformanceComment]                                                                                                   
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [HomePerformance] end as [HomePerformance]                                                      
      ,[HomePerfomanceComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [CommunityPerformance]  end as [CommunityPerformance]                                                                                                     
      ,[CommunityPerformanceComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [BehaviorTowardsOther] end as [BehaviorTowardsOther]                                                                                                       
      ,[BehaviorTowardsOtherComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [MoodsEmotion] end as [MoodsEmotion]                                                                                                        
      ,[MoodsEmotionComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [SelfHarmfulBehavior] end as [SelfHarmfulBehavior]                                                                                                    
      ,[SelfHarmfulBehaviorComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [SubstanceUse] end as [SubstanceUse]                                                                                                        
      ,[SubstanceUseComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [Thinkng] end as [Thinkng]                                                                                                     
      ,[ThinkngComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [YouthTotalScore] end as [YouthTotalScore]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [PrimaryFamilyMaterialNeeds]  end as [PrimaryFamilyMaterialNeeds]                                                                      
      ,[PrimaryFamilyMaterialNeedsComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [PrimaryFamilySocialSupport] end as [PrimaryFamilySocialSupport]                                                                                                        
      ,[PrimaryFamilySocialSupportComment]                                                                                                        
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [NonCustodialMaterialNeeds] end as [NonCustodialMaterialNeeds]                                                                                                        
      ,[NonCustodialMaterialNeedsComment]                                                              
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [NonCustodialSocialSupport] end as [NonCustodialSocialSupport]                                                                      
      ,[NonCustodialSocialSupportComment]                                                                         
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [SurrogateMaterialNeeds] end as [SurrogateMaterialNeeds]                                                              
      ,[SurrogateMaterialNeedsComment]                                                                    
      ,Case When @AssessmentType in (''A'', ''I'', ''S'') then 0 else [SurrogateSocialSupport] end as [SurrogateSocialSupport]                                                                        
      ,[SurrogateSocialSupportComment]                                            
      ,CC2.[CreatedDate]                                                    
      ,CC2.[CreatedBy]                                                                                                 
      ,CC2.[ModifiedDate]                                                                 
      ,CC2.[ModifiedBy]                                                                                   
      ,[RecordDeleted]                                                                                                        
      ,[DeletedDate]                                                                        
      ,[DeletedBy]                                  
       FROM CustomCAFAS2  CC2                                      
       where DocumentVersionId=@DocumentVersionId       
 END
 ELSE
 
 BEGIN
 
 SELECT ''CustomCAFAS2'' AS TableName,-1 as ''DocumentVersionId''                                                                                            
     ,[CAFASDate]                                                                                                       
      ,[RaterClinician]                                                                                                        
      ,[CAFASInterval]                                                     
      ,0 as [SchoolPerformance]                                                                                                        
      ,[SchoolPerformanceComment]                                                                                                   
      ,0 as [HomePerformance]                                                       
      ,[HomePerfomanceComment]                                                                                                        
      ,0 as [CommunityPerformance]                                                                                                        
      ,[CommunityPerformanceComment]                                                                                                        
      ,0 as [BehaviorTowardsOther]                                                                                                        
      ,[BehaviorTowardsOtherComment]                                                                                                        
      ,0 as [MoodsEmotion]                                                                                                        
      ,[MoodsEmotionComment]                                                                                                        
      ,0 as [SelfHarmfulBehavior]                                                                                                     
      ,[SelfHarmfulBehaviorComment]                                                                                                        
      ,0 as [SubstanceUse]                                                                                                        
      ,[SubstanceUseComment]                                                                                                        
      ,0 as [Thinkng]                                                                                                     
      ,[ThinkngComment]                                                                                                        
      ,[YouthTotalScore]                                                                                                        
      ,0 as [PrimaryFamilyMaterialNeeds]                                                                       
      ,[PrimaryFamilyMaterialNeedsComment]                                                                                                        
      ,0 as [PrimaryFamilySocialSupport]                                                                                                        
      ,[PrimaryFamilySocialSupportComment]                                                                                                        
      ,0 as [NonCustodialMaterialNeeds]                                                                                                        
      ,[NonCustodialMaterialNeedsComment]                                                              
      ,0 as [NonCustodialSocialSupport]                                                                      
      ,[NonCustodialSocialSupportComment]                                                                         
      ,0 as [SurrogateMaterialNeeds]                                                              
      ,[SurrogateMaterialNeedsComment]                                                                    
      ,0 as [SurrogateSocialSupport]                                                                        
      ,[SurrogateSocialSupportComment]                                            
      ,CC2.[CreatedDate]                                                    
      ,CC2.[CreatedBy]                                                                                                 
      ,CC2.[ModifiedDate]                                                                 
      ,CC2.[ModifiedBy]                                                                                   
      ,[RecordDeleted]                                                                                                        
      ,[DeletedDate]                                                                        
      ,[DeletedBy]                                  
       FROM SystemConfigurations  as S                                      
	  LEFT OUTER JOIN CustomCAFAS2  CC2  ON  S.DatabaseVersion = - 1
 
 END
 
 
         
 -- CustomSubstanceUseHistory2       
     SELECT                   
     ''CustomSubstanceUseHistory2'' AS TableName                  
    ,Convert(int,0 - Row_Number() Over (Order by  [CustomSubstanceUseHistory2].[SubstanceUseHistoryId] asc)) as [SubstanceUseHistoryId]                                 
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
    ,''SpecificCase_mdiv'' As ParentChildName            
   FROM [CustomSubstanceUseHistory2]                  
   where DocumentVersionId=@DocumentVersionId                                   
                                   

-- CustomHRMAssessmentRAPScores                                      
 If @AssessmentType = ''U''
 Begin                                      
       SELECT                                 
       ''CustomHRMAssessmentRAPScores'' as TableName                                
      ,Convert(int,0 - Row_Number() Over (Order by  [HRMAssessmentRAPQuestionId] desc))  as [HRMAssessmentRAPQuestionId]                                 
      ,[DocumentVersionId]                                
      ,[HRMRAPQuestionId]                                
      ,[RAPAssessedValue]                                
      ,[AddToNeedsList]                                
      ,[CreatedBy]                                
      ,[CreatedDate]                                
      ,[ModifiedBy]                                
      ,[ModifiedDate]                                
      ,[RecordDeleted]                                
      ,[DeletedDate]                           
      ,[DeletedBy]                         
  FROM [CustomHRMAssessmentRAPScores]                                
  where DocumentVersionId=@DocumentVersionId    
   
 end 
    
--CustomMentalStatuses2  
  if exists (Select DocumentVersionId from CustomMentalStatuses2 where DocumentVersionId=@DocumentVersionId) and @AssessmentType = ''U''
  begin                    
                                       
		SELECT 
		''CustomMentalStatuses2'' AS TableName,                                                                 
       -1 as ''DocumentVersionId''                                                                
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
      ,''N'' as ''OrientationAddToNeedsList''                                                               
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
 FROM    CustomMentalStatuses2 CMS  where DocumentVersionId=@DocumentVersionId   
 end
 else  --If record does''t exists in CustomMentalStatus2 table get data from 
 BEGIN
	   SELECT ''CustomMentalStatuses2'' AS TableName,                                                                 
       -1 as ''DocumentVersionId''                                                                
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
      ,''N'' as ''OrientationAddToNeedsList''                                                               
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
   FROM SystemConfigurations  as S                                      
	  LEFT OUTER JOIN CustomMentalStatuses2  CM2  ON  S.DatabaseVersion = - 1
 
 END
 
 

 
 --CustomDailyLivingActivityScores                                       
 If @AssessmentType = ''A''
 Begin                                        
                                        
 SELECT ''CustomDailyLivingActivityScores'' AS TableName,                                  
       Convert(int,0 - Row_Number() Over (Order by  CustomDailyLivingActivityScores.DailyLivingActivityScoreId asc))   as [DailyLivingActivityScoreId]                                 
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
       ,''SpecificCase_DivActivityContent'' As ParentChildName                                                    
  FROM CustomDailyLivingActivityScores                                                                    
  where DocumentVersionId=@DocumentVersionId        
  end 
  else 
  begin
 SELECT ''CustomDailyLivingActivityScores'' AS TableName,                                  
       Convert(int,0 - Row_Number() Over (Order by  CustomDailyLivingActivityScores.DailyLivingActivityScoreId asc))                                           
    as [DailyLivingActivityScoreId]                                 
      ,[DocumentVersionId]                                  
      ,[HRMActivityId]                                  
      ,Case When @AssessmentType in (''A'', ''I'', ''S'')  then NULL else [ActivityScore]  end as [ActivityScore]                                 
      ,[ActivityComment]                                  
      ,[CreatedBy]                                  
      ,[CreatedDate]                                  
     ,[ModifiedBy]                                  
      ,[ModifiedDate]                                  
      ,[RecordDeleted]                                  
      ,[DeletedDate]                  
      ,[DeletedBy]   
       ,''SpecificCase_DivActivityContent'' As ParentChildName                                                   
  FROM CustomDailyLivingActivityScores                                                                    
  where DocumentVersionId=@DocumentVersionId   
  end                             

                               
 END TRY                              
                               
 BEGIN CATCH                                                                 
DECLARE @Error varchar(8000)                                                                                                                    
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                                
  
    
      
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCHRMAssessmentIntializeTablesForReassessment]'')                                                                                                                                                
  
    
      
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
