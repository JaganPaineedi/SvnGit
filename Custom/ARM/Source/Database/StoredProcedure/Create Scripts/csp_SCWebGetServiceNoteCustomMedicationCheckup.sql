/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomMedicationCheckup]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomMedicationCheckup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomMedicationCheckup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomMedicationCheckup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomMedicationCheckup]                 
(                    
  @DocumentVersionId int         
)                    
As          
/******************************************************************************            
**  Name: csp_SCWebGetServiceNoteCustomMedicationCheckup            
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
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables          
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
      ,[Diagnosis]          
      ,[BloodPressure]          
      ,[Height]          
      ,[Respiratory]          
      ,[Waist]          
      ,[Pulse]          
      ,[Weight]          
      ,[BloodSugar]          
      ,[Temperature]          
      ,[ChiefComplaint]          
      ,[PastHistory]          
      ,[Summary]          
      ,[PlanOtherText]          
      ,[AxisV]          
      ,[MuscleNormal]          
      ,[MuscleTics]          
      ,[MuscleInvoluntaryMovement]          
      ,[MuscleRestlessness]          
      ,[MuscleTremorsShaking]          
      ,[MuscleOther]          
      ,[MuscleOtherText]          
      ,[GaitNormal]          
      ,[GaitShuffling]          
      ,[GaitWideBased]          
      ,[GaitFestinating]          
      ,[GaitAtaxia]          
      ,[GaitWeakness]          
      ,[GaitSteady]          
      ,[GaitUnsteady]          
      ,[GaitPropelling]          
      ,[GaitOther]          
      ,[GaitOtherText]          
      ,[SpeechNormal]          
      ,[SpeechSlurred]          
      ,[SpeechIncomprehensible]          
      ,[SpeechNonVerbal]          
      ,[SpeechDisorganized]          
      ,[SpeechPressured]          
      ,[SpeechAphasic]          
      ,[SpeechOther]          
      ,[SpeechOtherText]          
      ,[PainNormal]          
      ,[PainAching]          
      ,[PainStabbing]          
      ,[PainOther]          
      ,[PainOtherText]          
      ,[ThoughtProcessNormal]          
      ,[ThoughtProcessTangential]          
      ,[ThoughtProcessCircumstantial]          
      ,[ThoughtProcessRacing]          
      ,[ThoughtProcessOther]          
      ,[ThoughtProcessOtherText]          
      ,[AssociationsNormal]          
      ,[AssociationsLoose]          
      ,[AssociationsFlight]          
      ,[AssociationsOther]          
      ,[AssociationsOtherText]          
      ,[JudgementNormal]          
      ,[JudgementPoor]          
      ,[JudgementFair]          
      ,[JudgementGrosslyImpaired]          
      ,[JudgementDifficultyProblemSolving]          
      ,[JudgementDifficultyConsequenceActions]          
      ,[JudgementOther]          
      ,[JudgementOtherText]          
      ,[AbnormalThoughts]          
      ,[AbnormalThoughtsOtherText]          
      ,[OrientationNormal]          
      ,[OrientationPerson]          
      ,[OrientationPlace]          
      ,[OrientationTime]         
      ,[OrientationPurposeOtherText]          
      ,[FundofKnowledgeNormal]          
  ,[FundofKnowledgeText]          
      ,[RRMemoryNormal]          
      ,[RRMemoryShortTerm]          
      ,[RRMemoryAbstracting]          
      ,[RRMemorySequencing]          
      ,[RRMemoryOrganizing]          
      ,[RRMemoryLongTerm]          
      ,[RRMemoryPlanning]          
      ,[RRMemoryThinking]          
      ,[RRMemoryOther]          
      ,[RRMemoryOtherText]          
      ,[AttentionNormal]          
      ,[AttentionFollowsDirections]          
      ,[AttentionDistracted]          
      ,[AttentionImpulsive]          
      ,[AttentionPoorImpulseControl]          
      ,[AttentionOther]          
      ,[AttentionOtherText]          
      ,[LanguageNormal]          
      ,[LanguageRepetitive]          
      ,[LanguageInappropriate]          
      ,[LanguageOther]          
      ,[LanguageOtherText]          
      ,[MoodAffectNormal]          
      ,[MoodAffectAppropriate]          
      ,[MoodAffectEuthymic]          
      ,[MoodAffectRestricted]          
      ,[MoodAffectBroad]          
      ,[MoodAffectAlogia]          
      ,[MoodAffectIrritable]          
      ,[MoodAffectSad]          
      ,[MoodAffectTearful]          
      ,[MoodAffectAnxious]          
      ,[MoodAffectCooperative]          
      ,[MoodAffectFlat]          
      ,[MoodAffectOther]          
      ,[MoodAffectOtherText]          
      ,[SleepNormal]          
      ,[SleepHoursPerDay]          
      ,[SleepDifficultyMaintaining]          
      ,[SleepDifficultyFalling]          
      ,[SleepNonRestorative]          
      ,[SleepAbnormal]          
      ,[SleepNightmares]          
      ,[SleepOther]          
      ,[SleepOtherText]          
      ,[AppetiteNormal]          
      ,[AppetiteIncreased]          
      ,[AppetiteDecreased]          
      ,[AppetiteOther]          
      ,[AppetiteOtherText]      
      ,AIMS      
      ,AIMSText          
      ,[MedicationInformation]          
      ,[MedicationReviewGiven]          
      ,[MedicationReviewDetail]          
      ,[AbnormalThoughtsDelusional]          
      ,[AbnormalThoughtsImpoverished]          
      ,[AbnormalThoughtsBizarre]          
      ,[AbnormalThoughtsVisual]          
      ,[AbnormalThoughtsAuditory]          
      ,[AbnormalThoughtsGrandiosity]          
      ,[AbnormalThoughtsOthers]          
      ,[JudgementIncreasedRisk]          
      ,[CreatedBy]          
      ,[CreatedDate]          
      ,[ModifiedBy]          
      ,[ModifiedDate]          
      ,[RecordDeleted]          
      ,[DeletedDate]          
      ,[DeletedBy]          
  FROM [CustomMedicationCheckups]          
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND DocumentVersionId=@DocumentVersionId      
 
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
            

	--SELECT     CustomMedications.MedicationId, CustomMedications.DocumentVersionId, CustomMedications.DrugId, CustomMedications.Dose, CustomMedications.Frequency, 
	--				  CustomMedications.Route, CustomMedications.Comment, CustomMedications.Prescriber, CustomMedications.Strength, CustomMedications.ServiceId, 
	--				  CustomMedications.RowIdentifier, CustomMedications.CreatedBy, CustomMedications.CreatedDate, CustomMedications.ModifiedBy, 
	--				  CustomMedications.ModifiedDate, CustomMedications.RecordDeleted, CustomMedications.DeletedDate, CustomMedications.DeletedBy, 
	--				  GC1.CodeName AS FrequencyText, GC2.CodeName AS RouteText, NULL AS CheckBox, Drugs.DrugName as DrugIdText
	--FROM         CustomMedications INNER JOIN
	--				  GlobalCodes AS GC1 ON GC1.GlobalCodeId = CustomMedications.Frequency AND GC1.Active = ''Y'' AND ISNULL(GC1.RecordDeleted, ''N'') = ''N'' INNER JOIN
	--				  GlobalCodes AS GC2 ON GC2.GlobalCodeId = CustomMedications.Route AND GC2.Active = ''Y'' AND ISNULL(GC2.RecordDeleted, ''N'') = ''N'' INNER JOIN
	--				  Drugs ON CustomMedications.DrugId = Drugs.DrugId
	--WHERE     (CustomMedications.DocumentVersionId = @DocumentVersionId) AND  (ISNULL(CustomMedications.RecordDeleted, ''N'') = ''N'') AND 
	--				  (ISNULL(Drugs.RecordDeleted, ''N'') = ''N'') AND (ISNULL(GC1.RecordDeleted, ''N'') = ''N'') AND (ISNULL(GC2.RecordDeleted, ''N'') = ''N'') AND (GC1.Active = ''Y'') AND 
	--				  (GC2.Active = ''Y'')
	--ORDER BY Drugs.DrugName DESC, CustomMedications.MedicationId          
           
END TRY            
          
BEGIN CATCH            
 declare @Error varchar(8000)            
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomMedicationCheckup'')             
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
