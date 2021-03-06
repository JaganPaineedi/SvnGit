/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomMANote]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomMANote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomMANote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomMANote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomMANote]               
(                  
 @DocumentVersionId  int                                                                                                                                     
)                  
As        
/******************************************************************************          
**  Name: csp_SCWebGetServiceNoteCustomMANote          
**  Desc: This fetches data for Service Note Custom Tables         
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
**  Auth: Mohit Madaan      
**  Date: 15-Feb-10          
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:    Author:    Description:          
**  --------   --------   -------------------------------------------          
*******************************************************************************/          
BEGIN TRY          
         
SELECT [DocumentVersionId]    
      ,[BloodPressure]        
      ,[Pulse]        
      ,[Respiratory]        
      ,[Weight]        
      ,[Intervention]        
      ,[ResponseToIntervention]        
      ,[AxisV]        
      ,[CreatedBy]        
      ,[CreatedDate]        
      ,[ModifiedBy]        
      ,[ModifiedDate]        
      ,[RecordDeleted]        
      ,[DeletedDate]        
      ,[DeletedBy]        
  FROM [CustomMedicationAdministrations]        
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId        
        
SELECT [DocumentVersionId]        
      ,[AbnormalThoughts]  
      ,[AbnormalThoughtsAuditory]  
      ,[AbnormalThoughtsBizarre]  
      ,[AbnormalThoughtsDelusional]  
      ,[AbnormalThoughtsGrandiosity]  
      ,[AbnormalThoughtsImpoverished]  
      ,[AbnormalThoughtsVisual]  
      ,[AbnormalThoughtsOthers]  
      ,[AbnormalThoughtsOtherText]  
      ,[AppetiteNormal]  
      ,[AppetiteDecreased]  
      ,[AppetiteIncreased]  
      ,[AppetiteOther]  
      ,[AppetiteOtherText]  
      ,[AssociationsNormal]  
      ,[AssociationsFlight]  
      ,[AssociationsLoose]  
      ,[AssociationsOther]  
      ,[AssociationsOtherText]  
      ,[AttentionNormal]  
      ,[AttentionDistracted]  
      ,[AttentionFollowsDirections]  
      ,[AttentionImpulsive]  
      ,[AttentionPoorImpulseControl]  
      ,[AttentionOther]  
      ,[AttentionOtherText]  
      ,[FundofKnowledgeNormal]  
      ,[FundofKnowledgeText]  
      ,[GaitNormal]  
      ,[GaitAtaxia]  
      ,[GaitFestinating]  
      ,[GaitPropelling]  
      ,[GaitShuffling]  
      ,[GaitSteady]  
      ,[GaitUnsteady]  
      ,[GaitWeakness]  
      ,[GaitWideBased]  
      ,[GaitOther]  
      ,[GaitOtherText]  
      ,[JudgementNormal]  
      ,[JudgementDifficultyConsequenceActions]  
      ,[JudgementDifficultyProblemSolving]  
      ,[JudgementFair]  
      ,[JudgementGrosslyImpaired]  
      ,[JudgementIncreasedRisk]  
      ,[JudgementPoor]  
      ,[JudgementOther]  
      ,[JudgementOtherText]  
      ,[LanguageNormal]  
      ,[LanguageInappropriate]  
      ,[LanguageRepetitive]  
      ,[LanguageOther]  
      ,[LanguageOtherText]  
      ,[MoodAffectNormal]  
      ,[MoodAffectAlogia]  
      ,[MoodAffectAnxious]  
      ,[MoodAffectAppropriate]  
      ,[MoodAffectBroad]  
      ,[MoodAffectCooperative]  
      ,[MoodAffectEuthymic]  
      ,[MoodAffectFlat]  
      ,[MoodAffectIrritable]  
      ,[MoodAffectRestricted]  
      ,[MoodAffectSad]  
      ,[MoodAffectTearful]  
      ,[MoodAffectOther]  
      ,[MoodAffectOtherText]  
     ,[MuscleNormal]  
      ,[MuscleInvoluntaryMovement]  
      ,[MuscleRestlessness]  
      ,[MuscleTics]  
      ,[MuscleTremorsShaking]  
      ,[MuscleOther]  
      ,[MuscleOtherText]  
      ,[OrientationNormal]  
      ,[OrientationPerson]  
      ,[OrientationPlace]  
      ,[OrientationTime]  
      ,[OrientationPurposeOtherText]  
      ,[PainNormal]  
      ,[PainAching]  
      ,[PainStabbing]  
      ,[PainOther]  
      ,[PainOtherText]  
      ,[RRMemoryNormal]  
      ,[RRMemoryAbstracting]  
      ,[RRMemoryLongTerm]  
      ,[RRMemoryOrganizing]  
      ,[RRMemoryPlanning]  
      ,[RRMemorySequencing]  
      ,[RRMemoryShortTerm]  
      ,[RRMemoryThinking]  
      ,[RRMemoryOther]  
      ,[RRMemoryOtherText]  
      ,[SleepNormal]  
      ,[SleepDifficultyFalling]  
      ,[SleepDifficultyMaintaining]  
      ,[SleepHoursPerDay]  
      ,[SleepNightmares]  
      ,[SleepNonRestorative]  
      ,[SleepAbnormal]  
      ,[SleepOther]  
      ,[SleepOtherText]  
      ,[SpeechNormal]  
      ,[SpeechAphasic]  
      ,[SpeechDisorganized]  
      ,[SpeechIncomprehensible]  
      ,[SpeechNonVerbal]  
      ,[SpeechPressured]  
      ,[SpeechSlurred]  
      ,[SpeechOther]  
      ,[SpeechOtherText]  
      ,[ThoughtProcessNormal]  
      ,[ThoughtProcessCircumstantial]  
      ,[ThoughtProcessRacing]  
      ,[ThoughtProcessTangential]  
      ,[ThoughtProcessOther]  
      ,[ThoughtProcessOtherText]  
      ,[CreatedBy]  
      ,[CreatedDate]  
      ,[ModifiedBy]  
      ,[ModifiedDate]  
      ,[RecordDeleted]  
      ,[DeletedDate]  
      ,[DeletedBy]  
  FROM [CustomMedicalStatus]        
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId        
    
--SELECT     CustomMedications.MedicationId, CustomMedications.DocumentVersionId, CustomMedications.DrugId, CustomMedications.Dose, CustomMedications.Frequency,   
--      CustomMedications.Route, CustomMedications.Comment, CustomMedications.Prescriber, CustomMedications.Strength, CustomMedications.ServiceId,   
--      CustomMedications.RowIdentifier, CustomMedications.CreatedBy, CustomMedications.CreatedDate, CustomMedications.ModifiedBy,   
--      CustomMedications.ModifiedDate, CustomMedications.RecordDeleted, CustomMedications.DeletedDate, CustomMedications.DeletedBy,   
--      GC1.CodeName AS FrequencyText, GC2.CodeName AS RouteText, NULL AS CheckBox, Drugs.DrugName as DrugIdText  
--FROM         CustomMedications INNER JOIN  
--      GlobalCodes AS GC1 ON GC1.GlobalCodeId = CustomMedications.Frequency AND GC1.Active = ''Y'' AND ISNULL(GC1.RecordDeleted, ''N'') = ''N'' INNER JOIN  
--      GlobalCodes AS GC2 ON GC2.GlobalCodeId = CustomMedications.Route AND GC2.Active = ''Y'' AND ISNULL(GC2.RecordDeleted, ''N'') = ''N'' INNER JOIN  
--      Drugs ON CustomMedications.DrugId = Drugs.DrugId  
--WHERE     (CustomMedications.DocumentVersionId = @DocumentVersionId) AND  (ISNULL(CustomMedications.RecordDeleted, ''N'') = ''N'') AND   
--      (ISNULL(Drugs.RecordDeleted, ''N'') = ''N'') AND (ISNULL(GC1.RecordDeleted, ''N'') = ''N'') AND (ISNULL(GC2.RecordDeleted, ''N'') = ''N'') AND (GC1.Active = ''Y'') AND   
--      (GC2.Active = ''Y'')  
--ORDER BY Drugs.DrugName DESC, CustomMedications.MedicationId           
       
  SELECT       
       CustomMedications.[MedicationId]  
      ,CustomMedications.[DocumentVersionId]  
      ,CustomMedications.[DrugId]  
      ,CustomMedications.[DrugName]  
      ,CustomMedications.[Dose]  
      ,CustomMedications.[Frequency]  
      ,CustomMedications.[Route]  
      ,CustomMedications.[OrderDate]  
      ,CustomMedications.[EndDate]  
      ,CustomMedications.[Status]  
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
      ,GC1.CodeName AS FrequencyText, GC2.CodeName AS RouteText, NULL AS CheckBox,Drugs.DrugName as DrugIdText                                                                                                                  
   FROM  CustomMedications INNER JOIN                                                                                             
         Drugs ON CustomMedications.DrugId = Drugs.DrugId                                                                                                                    
   left JOIN     GlobalCodes GC1 ON GC1.GlobalCodeId = CustomMedications.Frequency AND GC1.Active = ''Y'' AND ISNULL(GC1.RecordDeleted, ''N'') = ''N''                                         
   left JOIN     GlobalCodes GC2 ON GC2.GlobalCodeId = CustomMedications.Route AND GC2.Active = ''Y'' AND ISNULL(GC2.RecordDeleted, ''N'') = ''N''                                                                                                   
   WHERE ISNull(CustomMedications.RecordDeleted,''N'')=''N'' AND CustomMedications.DocumentVersionId=@DocumentVersionId    AND                                                                       --(ISNULL(CustomMedications.RecordDeleted, ''N'') = ''N'') AND    
  
   (ISNULL(Drugs.RecordDeleted, ''N'') = ''N'')                                            
   ORDER BY Drugs.DrugName DESC, CustomMedications.MedicationId        
            
         
END TRY          
        
BEGIN CATCH          
 declare @Error varchar(8000)          
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomMANote'')           
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
