/****** Object:  StoredProcedure [dbo].[csp_InitCustomCrisisInterventionNotesInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrisisInterventionNotesInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomCrisisInterventionNotesInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrisisInterventionNotesInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomCrisisInterventionNotesInitialization]            
 (                                  
 @ClientID int,            
 @StaffID int,          
 @CustomParameters xml                                  
)                                                              
As                                                          
                                                                                                                                                      
Begin                                                  
        
Begin try    
                              
Select TOP 1 ''CustomDocumentCrisisInterventionNotes'' AS TableName, -1 as ''DocumentVersionId'',                        
                                                     
'''' as CreatedBy,                      
getdate() as CreatedDate,                      
'''' as ModifiedBy,                      
getdate() as ModifiedDate     
from systemconfigurations s left outer join CustomDocumentCrisisInterventionNotes C                                                                           
on s.Databaseversion = -1   

Select TOP 1 ''CustomDocumentmentalstatuses'' AS TableName, -1 as ''DocumentVersionId'' ,
'''' as CreatedBy,                        
getdate() as CreatedDate,                        
'''' as ModifiedBy,                        
getdate() as ModifiedDate 
,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[ConsciousnessNA]
      ,[ConsciousnessAlert]
      ,[ConsciousnessObtunded]
      ,[ConsciousnessSomnolent]
      ,[ConsciousnessOrientedX3]
      ,[ConsciousnessAppearsUnderInfluence]
      ,[ConsciousnessComment]
      ,[EyeContactNA]
      ,[EyeContactAppropriate]
      ,[EyeContactStaring]
      ,[EyeContactAvoidant]
      ,[EyeContactComment]
      ,[AppearanceNA]
      ,[AppearanceClean]
      ,[AppearanceNeatlyDressed]
      ,[AppearanceAppropriate]
      ,[AppearanceDisheveled]
      ,[AppearanceMalodorous]
      ,[AppearanceUnusual]
      ,[AppearancePoorlyGroomed]
      ,[AppearanceComment]
      ,[AgeNA]
      ,[AgeAppropriate]
      ,[AgeOlder]
      ,[AgeYounger]
      ,[AgeComment]
      ,[BehaviorNA]
      ,[BehaviorPleasant]
      ,[BehaviorGuarded]
      ,[BehaviorAgitated]
      ,[BehaviorImpulsive]
      ,[BehaviorWithdrawn]
      ,[BehaviorUncooperative]
      ,[BehaviorAggressive]
      ,[BehaviorComment]
      ,[PsychomotorNA]
      ,[PsychomotorNoAbnormalMovements]
      ,[PsychomotorAgitation]
      ,[PsychomotorAbnormalMovements]
      ,[PsychomotorRetardation]
      ,[PsychomotorComment]
      ,[MoodNA]
      ,[MoodEuthymic]
      ,[MoodDysphoric]
      ,[MoodIrritable]
      ,[MoodDepressed]
      ,[MoodExpansive]
      ,[MoodAnxious]
      ,[MoodElevated]
      ,[MoodComment]
      ,[ThoughtContentNA]
      ,[ThoughtContentWithinLimits]
      ,[ThoughtContentExcessiveWorries]
      ,[ThoughtContentOvervaluedIdeas]
      ,[ThoughtContentRuminations]
      ,[ThoughtContentPhobias]
      ,[ThoughtContentComment]
      ,[DelusionsNA]
      ,[DelusionsNone]
      ,[DelusionsBizarre]
      ,[DelusionsReligious]
      ,[DelusionsGrandiose]
      ,[DelusionsParanoid]
      ,[DelusionsComment]
      ,[ThoughtProcessNA]
      ,[ThoughtProcessLogical]
      ,[ThoughtProcessCircumferential]
      ,[ThoughtProcessFlightIdeas]
      ,[ThoughtProcessIllogical]
      ,[ThoughtProcessDerailment]
      ,[ThoughtProcessTangential]
      ,[ThoughtProcessSomatic]
      ,[ThoughtProcessCircumstantial]
      ,[ThoughtProcessComment]
      ,[HallucinationsNA]
      ,[HallucinationsNone]
      ,[HallucinationsAuditory]
      ,[HallucinationsVisual]
      ,[HallucinationsTactile]
      ,[HallucinationsOlfactory]
      ,[HallucinationsComment]
      ,[IntellectNA]
      ,[IntellectAverage]
      ,[IntellectAboveAverage]
      ,[IntellectBelowAverage]
      ,[IntellectComment]
      ,[SpeechNA]
      ,[SpeechRate]
      ,[SpeechTone]
      ,[SpeechVolume]
      ,[SpeechArticulation]
      ,[SpeechComment]
      ,[AffectNA]
      ,[AffectCongruent]
      ,[AffectReactive]
      ,[AffectIncongruent]
      ,[AffectLabile]
      ,[AffectComment]
      ,[RangeNA]
      ,[RangeBroad]
      ,[RangeBlunted]
      ,[RangeFlat]
      ,[RangeFull]
      ,[RangeConstricted]
      ,[RangeComment]
      ,[InsightNA]
      ,[InsightExcellent]
      ,[InsightGood]
      ,[InsightFair]
      ,[InsightPoor]
      ,[InsightImpaired]
      ,[InsightUnknown]
      ,[InsightComment]
      ,[JudgmentNA]
      ,[JudgmentExcellent]
      ,[JudgmentGood]
      ,[JudgmentFair]
      ,[JudgmentPoor]
      ,[JudgmentImpaired]
      ,[JudgmentUnknown]
      ,[JudgmentComment]
      ,[MemoryNA]
      ,[MemoryShortTerm]
      ,[MemoryLongTerm]
      ,[MemoryAttention]
      ,[MemoryComment]
      ,[BodyHabitusNA]
      ,[BodyHabitusAverage]
      ,[BodyHabitusThin]
      ,[BodyHabitusUnderweight]
      ,[BodyHabitusOverweight]
      ,[BodyHabitusObese]
      ,[BodyHabitusComment]       
from systemconfigurations s left outer join CustomDocumentmentalstatuses CD                                                                           
on s.Databaseversion = -1 
                                       
End try                                                  
                                                                                           
  BEGIN CATCH      
    DECLARE @Error varchar(8000)                                                   
    SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomCrisisInterventionNotesInitialization'')                                                                                 
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
