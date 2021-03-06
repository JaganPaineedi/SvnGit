/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportHospitalPrescreen]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportHospitalPrescreen]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportHospitalPrescreen]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportHospitalPrescreen]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportHospitalPrescreen]    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010 
AS           
Begin    
/*          
** Object Name:  [csp_RdlSubReportHospitalPrescreen]          
**          
**          
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set           
**    which matches those parameters.           
**          
** Programmers Log:          
** Date  Programmer  Description          
**------------------------------------------------------------------------------------------          
** Get Data From Mental Status       
** Oct 10 2007 Ranjeetb            
*/          
      
--SELECT [DocumentId]
--      ,[Version]
SELECT [DocumentVersionId]  --Modified by Anuj Dated 03-May-2010 
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
 -- FROM [MentalStatus] where ISNull(RecordDeleted,''N'')=''N'' and DocumentId=@DocumentID and Version=@Version 
  FROM [MentalStatus] where ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010 

  
      

    --Checking For Errors            
  If (@@error!=0)            
  Begin            
   RAISERROR  20006   ''csp_RdlSubReportHospitalPrescreen : An Error Occured''             
   Return            
   End            
     
          

End
' 
END
GO
