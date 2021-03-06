/****** Object:  StoredProcedure [dbo].[csp_SCGetServiceNoteCustomTables6]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetServiceNoteCustomTables6]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetServiceNoteCustomTables6]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetServiceNoteCustomTables6]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCGetServiceNoteCustomTables6]                 
(                    
 --@DocumentId as int,                    
 --@Version as int                                                                                                                                       
 @DocumentVersionId as int        
)                    
As          
/******************************************************************************            
**  File: MSDE.cs            
**  Name: csp_SCGetServiceNoteCustomTables6            
**  Desc: This fetches data for Service Note Custom Tables           
**  Copyright: 2006 Streamline SmartCare                                      
**            
**  This template can be customized:            
**                          
**  Return values:            
**             
**  Called by:   DownloadReqServiceData function in MSDE Class in DataServices            
**                          
**  Parameters:            
**  Input       Output            
**     ----------      -----------            
**  DocumentID,Version    Result Set containing values from Service Note Custom Tables          
**            
**  Auth: Balvinder Singh            
**  Date: 24-April-08            
*******************************************************************************            
**  Change History            
*******************************************************************************            
**  Date:    Author:    Description:            
**  --------   --------   -------------------------------------------            
          
*******************************************************************************/            
BEGIN TRY            
           
SELECT [DocumentVersionId]          
      --,[DocumentId]          
      --,[Version]          
      ,[PurposeAssessing]          
      ,[PurposePrePlanning]          
      ,[PurposeImplementingPCP]          
      ,[PurposeLinking]          
      ,[PurposeCrisisIntervention]          
      ,[PurposeConsultation]          
      ,[PurposePersonCenteredPlanning]          
      ,[PurposeMonitoring]          
      ,[PurposeOther]          
      ,[PurposeOtherDescription]          
      ,[GoalsAddressed]          
      ,[NoteData]          
      ,[NotePlan]          
      ,[ClientResponseToIntervention]          
      ,[AxisV]          
      ,[ChangesToPlanNeeded]          
      ,[ReferralNeeded]          
      ,[NotifyStaffId1]          
      ,[NotifyStaffId2]          
      ,[NotifyStaffId3]          
      ,[NotifyStaffId4]          
      ,[NotificationMessage]          
      ,[Diagnosis]          
      ,[CurrentTreatmentPlan]          
      ,[ServiceType]          
      ,[DBT]          
      ,[CBT]          
      ,[MET]          
      ,[Nureobiofeedback]          
      ,[Family]          
      ,[InsightOriented]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
  FROM [Notes]           
where DocumentVersionId=@DocumentVersionId --DocumentID=@DocumentId and Version=@Version           
          
          
SELECT [DocumentVersionId]          
      --,[DocumentId]          
      --,[Version]          
      ,[UnableToAssess]          
      ,[AppearanceDressed]          
      ,[AppearanceAge]          
      ,[AppearanceAverageWeight]          
      ,[AppearanceAverageHeight]          
      ,[AppearanceGroomed]          
      ,[AppearanceHygiene]          
      ,[ApprearanceOther]          
      ,[AppearanceOtherText]          
      ,[BehaviorGait]          
      ,[BehaviorEyeContact]          
      ,[BehaviorTics]          
      ,[BehaviorTremors]          
      ,[BehaviorTwitches]          
      ,[BehaviorAgitated]          
      ,[BehaviorActivity]          
      ,[BehaviorLethargic]          
      ,[BehaviorAggressive]          
      ,[BehaviorNormalActivity]          
      ,[BehaviorOther]          
   ,[BehaviorOtherText]          
      ,[AttitudeCooperative]          
      ,[AttitudeDefensive]          
      ,[AttitudeReserved]          
      ,[AttitudeMistrustful]          
      ,[AttitudeOther]          
      ,[AttitudeOtherText]          
      ,[AffectBlunted]          
      ,[AffectCongruent]          
      ,[AffectUnremarkable]          
      ,[AffectUnableToAssess]          
      ,[AffectFlat]          
      ,[AffectRestricted]          
      ,[AffectExpansive]          
      ,[AffectAngry]          
      ,[AffectSad]          
      ,[AffectIrritable]          
      ,[AffectFearful]          
      ,[AffectMood]          
      ,[AffectOther]          
      ,[AffectOtherText]          
      ,[SpeechCoherent]          
      ,[SpeechSpeed]          
      ,[SpeechVerbal]          
      ,[SpeechClear]          
      ,[SpeechVolume]          
      ,[SpeechPressured]          
      ,[SpeechRepetitive]          
      ,[SpeechSpontaneous]          
      ,[SpeechSlurred]          
      ,[SpeechMonotonous]          
      ,[SpeechTalkative]          
      ,[SpeechEcholalia]          
      ,[SpeechOther]          
      ,[SpeechOtherText]          
      ,[ThoughtLucid]          
      ,[ThoughtParanoid]          
      ,[ThoughtDelusional]          
      ,[ThoughtTangential]          
      ,[ThoughtLoose]          
      ,[ThoughtPsychosis]          
      ,[ThoughtImpoverished]          
      ,[ThoughtConfused]          
      ,[ThoughtObsessive]          
      ,[ThoughtObsessiveText]          
      ,[ThoughtProcessingOther]          
      ,[MoodNeutral]          
      ,[MoodFriendly]          
      ,[MoodLabile]          
      ,[MoodAnxious]          
      ,[MoodGuilty]          
      ,[MoodIrritable]          
      ,[MoodFearful]          
      ,[MoodSad]          
      ,[MoodTearful]          
      ,[MoodAppropriate]          
      ,[MoodIncongruent]          
      ,[MoodOtherMoods]          
      ,[MoodOtherMoodsText]          
      ,[CognitionNormal]          
      ,[CognitionLimited]          
      ,[CognitionPhobias]          
      ,[CognitionObsessions]          
      ,[CognitionPreoccupation]          
      ,[CognitionOther]          
      ,[CognitionOtherText]          
      ,[AttentionAppropriate]          
      ,[AttentionGood]          
      ,[AttentionImpaired]          
      ,[AttentionOther]          
      ,[AttentionOtherText]          
      ,[LevelAlert]          
      ,[LevelSedate]          
      ,[LevelLethargic]          
      ,[LevelObtuned]          
      ,[LevelOther]          
      ,[LevelOtherText]          
      ,[PerceptualNo]          
      ,[PerceptualDelusions]          
      ,[PerceptualAuditory]          
      ,[PerceptualVisual]          
      ,[PerceptualOlfactory]          
      ,[PerceptualTactile]          
      ,[PerceptualDepersonalization]          
      ,[PerceptualIdeas]          
      ,[PerceptualParanoia]          
      ,[PerceptualOther]          
      ,[PerceptualOtherText]          
      ,[MemoryIntact]          
      ,[MemoryShortTerm]          
      ,[MemoryLongTerm]          
      ,[MemoryOther]          
      ,[MemoryOtherText]          
      ,[JudgementAware]          
      ,[JudgementUnderstandsOutcomes]          
      ,[JudgementUnderstandsNeed]          
      ,[JudgementRiskyBehavior]          
      ,[JudgementIntact]          
      ,[JudgementImpaired]          
      ,[JudgementImpairedText]          
      ,[JudgementOther]          
      ,[JudgementOtherText]          
      ,[OtherPx]          
      ,[OtherNotMedication]          
      ,[OtherEating]          
      ,[OtherEatingText]          
      ,[OtherSleep]          
      ,[OtherSleepText]          
      ,[OrientationPerson]          
      ,[OrientationPlace]          
      ,[OrientationTime]          
      ,[OrientationCircumstance]          
      ,[OrientationText]          
      ,[DisturbanceNoneNoted]          
      ,[DisturbanceDelusions]          
      ,[DisturbanceAuditory]          
      ,[DisturbanceVisual]       
      ,[DisturbanceOlfactory]          
      ,[DisturbanceTactile]          
      ,[DisturbanceDepersonalization]          
      ,[DisturbanceDerealization]          
      ,[DisturbanceIdeas]          
      ,[DisturbanceParanoia]          
      ,[DisturbanceOther]          
      ,[DisturbanceOtherText]          
      ,[RiskSuicideNotPresent]          
      ,[RiskSuicideIdeation]          
      ,[RiskSuicideActive]          
      ,[RiskSuicidePassive]     
      ,[RiskSuicideMeans]          
      ,[RiskSuicidePlan]          
      ,[RiskSuicideAttempt]          
      ,[RiskSuicideTxPlan]          
      ,[RiskHomicideNotPresent]          
      ,[RiskHomicideIdeation]          
      ,[RiskHomicideActive]          
      ,[RiskHomicidePassive]          
      ,[RiskHomicideMeans]          
      ,[RiskHomicidePlan]          
      ,[RiskHomicideAttempt]          
      ,[RiskHomicideTxPlan]          
      ,[RiskOther]          
      ,[RiskIntervention]          
      ,[ThoughtGrandiose]          
      ,[ThoughtFlightOfIdeas]          
      ,[ThoughtDisorganized]          
      ,[ThoughtBizarre]          
      ,[BehaviorCompulsive]          
      ,[BehaviorPeculiar]          
      ,[BehaviorManipulative]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
  FROM [MentalStatus]          
where DocumentVersionId= @DocumentVersionId --DocumentID=@DocumentId and Version=@Version           
              
          
           
           
END TRY            
          
BEGIN CATCH            
 declare @Error varchar(8000)            
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCGetServiceNoteCustomTables6'')             
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
