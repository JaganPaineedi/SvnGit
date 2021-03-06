/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomTablesNursingHome]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomTablesNursingHome]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomTablesNursingHome]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomTablesNursingHome]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomTablesNursingHome]             
(                
  @DocumentId int,                                          
  @DocumentVersionId int                                                                                                                              
)                
As      
/******************************************************************************        
**  File: MSDE.cs        
**  Name: csp_SCWebGetServiceNoteCustomTables        
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
**  DocumentID,DocumentVersionId    Result Set containing values from Service Note Custom Tables      
**        
**  Auth: Mohit        
**  Date: 11-Feb-10       
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:    Author:    Description:        
**  --------   --------   -------------------------------------------        
      
*******************************************************************************/        
BEGIN TRY        
       
SELECT [DocumentVersionId]    
      ,[GoalsAddressed]      
      ,[CurrentDiagnosis]      
      ,[CurrentTreatmentPlan]      
      ,[StaffConsultation]      
      ,[ChartReview]      
      ,[VisitNoted]      
      ,[VisitNotedNote]      
      ,[Intervention]      
      ,[AxisV]      
      ,[MedicationInformation]      
      ,[CreatedBy]      
      ,[CreatedDate]      
      ,[ModifiedBy]      
      ,[ModifiedDate]      
      ,[RecordDeleted]      
      ,[DeletedDate]      
      ,[DeletedBy]      
  FROM CustomNursingHomes      
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                       
      
      
SELECT [DocumentVersionId]  
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
  FROM MentalStatus      
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId                                                       
      
      
SELECT     
       CustomMedications.[MedicationId]      
      ,CustomMedications.[DocumentVersionId]  
      ,CustomMedications.[DrugId]      
      ,CustomMedications.[Dose]      
      ,CustomMedications.[Frequency]      
      ,CustomMedications.[Route]      
      ,CustomMedications.[Comment]      
      ,CustomMedications.[Prescriber]      
      ,CustomMedications.[Strength]      
      ,CustomMedications.[ServiceId]            
      ,CustomMedications.[CreatedBy]      
      ,CustomMedications.[CreatedDate]      
      ,CustomMedications.[ModifiedBy]      
      ,CustomMedications.[ModifiedDate]      
      ,CustomMedications.[RecordDeleted]      
      ,CustomMedications.[DeletedDate]      
      ,CustomMedications.[DeletedBy]    
    ,GC1.CodeName AS FrequencyName, GC2.CodeName AS RouteName, NULL AS CheckBox,Drugs.DrugName                                                                                                                  
  FROM         CustomMedications INNER JOIN                                                                                           
         Drugs ON CustomMedications.DrugId = Drugs.DrugId                                                                                                                  
   left JOIN     GlobalCodes GC1 ON GC1.GlobalCodeId = CustomMedications.Frequency AND GC1.Active = ''Y'' AND ISNULL(GC1.RecordDeleted, ''N'') = ''N''                                       
   left JOIN     GlobalCodes GC2 ON GC2.GlobalCodeId = CustomMedications.Route AND GC2.Active = ''Y'' AND ISNULL(GC2.RecordDeleted, ''N'') = ''N''                                                                                                 
  WHERE   (ISNull(CustomMedications.RecordDeleted,''N'')=''N'' AND CustomMedications.DocumentVersionId=@DocumentVersionId  ) AND                                                                       --(ISNULL(CustomMedications.RecordDeleted, ''N'') = ''N'') AND  
        
          (ISNULL(Drugs.RecordDeleted, ''N'') = ''N'')                                          
  ORDER BY Drugs.DrugName DESC, CustomMedications.MedicationId        
      
      
          
       
END TRY        
      
BEGIN CATCH        
 declare @Error varchar(8000)        
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomTablesNursingHome'')         
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
