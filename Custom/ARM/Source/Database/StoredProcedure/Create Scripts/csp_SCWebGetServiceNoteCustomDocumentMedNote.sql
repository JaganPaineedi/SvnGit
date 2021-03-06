/****** Object:  StoredProcedure [dbo].[csp_SCWebGetServiceNoteCustomDocumentMedNote]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDocumentMedNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCWebGetServiceNoteCustomDocumentMedNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCWebGetServiceNoteCustomDocumentMedNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCWebGetServiceNoteCustomDocumentMedNote]                       
(                          
 @DocumentVersionId  int                                                                                                                                             
)                          
As                
/******************************************************************************                  
**  Name: [csp_SCWebGetServiceNoteCustomDocumentMedNote]                  
**  Desc: This fetches data for Service Note Custom Tables                 
**                  
**  This template can be customized:                  
**                                
**  Return values:                  
**                   
**  Parameters:                  
**  Input       Output                  
**     ----------      -----------                  
**  DocumentVersionId    Result Set containing values from Service Note Custom Tables                
**                  
**  Auth: Jagdeep             
**  Date: 20-7-11                  
*******************************************************************************                  
**  Change History                  
*******************************************************************************                  
**  Date:    Author:    Description:                  
**  --------   --------   -------------------------------------------                  
*******************************************************************************/                  
BEGIN TRY                  
DECLARE @ClientId int                                                                                                                                                                                         
SELECT @ClientId = ClientId from Documents where                                                                                                                                                                                         
CurrentDocumentVersionId = @DocumentVersionId and IsNull(RecordDeleted,''N'')= ''N''        

       
Select [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[ClientName]
      ,[ClientAge]
      ,[ClientGender]
      ,[DateOfService]
      ,[CurrentMedications]
      ,[PreviousTreatmentRecommendationAndOrders]
      ,[ChangesSinceLastVisit]
      ,[MedicationsPrescribed]
      ,[MedEducationSideEffectsDiscussed]
      ,[MedEducationAlternativesReviewed]
      ,[MedEducationAgreedRegimen]
      ,[MedEducationAwareOfSubstanceUseRisks]
      ,[MedEducationAwareEmergencySymptoms]
      ,[TreatmentRecommendationAndOrders]
      ,[OtherInstructions]
  FROM [CustomDocumentMedNote]    
  WHERE ISNull(RecordDeleted,''N'')=''N'' AND [DocumentVersionId]=@DocumentVersionId      
    
   -----For DiagnosesIII-----                                                                                                   
   SELECT DocumentVersionId                                         
		  ,CreatedBy                                                                                                  
		  ,CreatedDate                                                                                
		  ,ModifiedBy                                                                                                  
		  ,ModifiedDate                                                                                                  
		  ,RecordDeleted                                                                                                  
		  ,DeletedDate                                                                                                  
		  ,DeletedBy                                                                                                  
		  ,Specification                                                                                                                                                                              
   FROM DiagnosesIII                                                                                                                                                                 
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                                                                                                                       
                                                                                                                                                                                                               
   -----For DiagnosesIV-----                                                                     
   SELECT DocumentVersionId                                                           
		  ,PrimarySupport                                                                                                              
		  ,SocialEnvironment                                                                     
		  ,Educational                                
		  ,Occupational                                                                               
		  ,Housing                                                                                                                                                                 
		  ,Economic                                 
		  ,HealthcareServices                                                                                                                                                        
		  ,Legal                                                                            
		  ,Other                                                                                                    
		  ,Specification                                                           
		  ,CreatedBy                                                                                                                                   
		  ,CreatedDate                                                          
		  ,ModifiedBy                                                                                 
		  ,ModifiedDate                                                                                                                                                                               
		  ,RecordDeleted                                                                
		  ,DeletedDate                                                                                                                                                                            
		  ,DeletedBy                                                                                          
   FROM DiagnosesIV                                                                                        
   WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                                          
   -----For DiagnosesV-----                                                                                    
 SELECT DocumentVersionId                           
		,AxisV                                                                                                                                                                                                                            
		,CreatedBy                                                                                                                               
		,CreatedDate                                                                                       
		,ModifiedBy                                                                                                                                          
		,ModifiedDate                                                                                                                                                                                                     
		,RecordDeleted                                                                             
		,DeletedDate                                                                                                                                                 
		,DeletedBy                                                                                                        
 FROM DiagnosesV                                                                                                                        
 WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(RecordDeleted,''N'')=''N''                                                                        
 -----For DiagnosesIAndII-----                                                                                                                                   
   SELECT D.DocumentVersionId                                                                                                                                                                          
		  ,D.DiagnosisId                       
		  ,D.Axis                                                                        
		  ,D.DSMCode                                                                    
		  ,D.DSMNumber                                                                                                                                                                                                    
		  ,D.DiagnosisType                                                                                                                      
		  ,D.RuleOut                                                                                               
		  ,D.Billable                                                                                                                     
		  ,D.Severity                                                                                                                               
		  ,D.DSMVersion                                                                                                
		  ,D.DiagnosisOrder                                                                                           
		  ,D.Specifier                                                        
		  ,D.Remission                                   
		  ,D.Source                                                                                             
		  ,D.CreatedBy                                                                                                                                                                                    
		  ,D.CreatedDate                                                              
		  ,D.ModifiedBy                                                                                                              
		  ,D.ModifiedDate                                                            
		  ,D.RecordDeleted                                                         
		  ,D.DeletedDate                                                          
		  ,D.DeletedBy                                                                                                                           
		  ,DSM.DSMDescription                                                                                      
          ,case D.RuleOut when ''Y'' then ''R/O'' else '''' end as RuleOutText                                                                                                                                                                     
  FROM DiagnosesIAndII  D                                                                               
  INNER JOIN DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                                        
  AND DSM.DSMNumber = D.DSMNumber                                                                                                                                                          
  WHERE DocumentVersionId=@DocumentVersionId   AND ISNULL(RecordDeleted,''N'')=''N''                                                                          
  --DiagnosesIIICodes                                            
 SELECT DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy  
 FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode                                                                   
 WHERE (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')                                                                     
                                                  
 ---DiagnosesMaxOrder                                                                    
   SELECT  top 1 max(DiagnosisOrder) as DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,                                                                    
   RecordDeleted,DeletedBy,DeletedDate from  DiagnosesIAndII                                                                     
   where DocumentVersionId=@DocumentVersionId                                      
   and  IsNull(RecordDeleted,''N'')=''N'' group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate                         
   order by DiagnosesMaxOrder desc        
  --For Mental Status Tab --                  
    Select DocumentVersionId              
		  ,CreatedBy                                    
		  ,CreatedDate                                    
		  ,ModifiedBy                                    
		  ,ModifiedDate                                    
		  ,RecordDeleted                                    
		  ,DeletedBy                                    
		  ,DeletedDate ,ConsciousnessNA                                    
		  ,ConsciousnessAlert                                    
		  ,ConsciousnessObtunded                                    
		  ,ConsciousnessSomnolent                            
		  ,ConsciousnessOrientedX3                                   
		  ,ConsciousnessAppearsUnderInfluence                                    
		  ,ConsciousnessComment                                    
		  ,EyeContactNA                                    
		  ,EyeContactAppropriate                                  
		  ,EyeContactStaring                                    
		  ,EyeContactAvoidant      
		  ,EyeContactComment                                    
		  ,AppearanceNA                                    
		  ,AppearanceClean                                    
		  ,AppearanceNeatlyDressed                                    
		  ,AppearanceAppropriate                                    
		  ,AppearanceDisheveled                                    
		  ,AppearanceMalodorous                                    
		  ,AppearanceUnusual                                    
		  ,AppearancePoorlyGroomed                                    
		  ,AppearanceComment                                    
		  ,AgeNA                                    
		  ,AgeAppropriate                                    
		  ,AgeOlder                                    
		  ,AgeYounger                                    
		  ,AgeComment                                    
		  ,BehaviorNA                                    
		  ,BehaviorPleasant                                    
		  ,BehaviorGuarded                                    
		  ,BehaviorAgitated                                    
		  ,BehaviorImpulsive                                    
		  ,BehaviorWithdrawn                                    
		  ,BehaviorUncooperative                                    
		  ,BehaviorAggressive                                    
		  ,BehaviorComment                                    
		  ,PsychomotorNA                                    
		  ,PsychomotorNoAbnormalMovements                                    
		  ,PsychomotorAgitation                                    
		  ,PsychomotorAbnormalMovements                                    
		  ,PsychomotorRetardation                                    
		  ,PsychomotorComment                                    
		  ,MoodNA                                    
		  ,MoodEuthymic                                    
		  ,MoodDysphoric                                    
		  ,MoodIrritable                                    
		  ,MoodDepressed                                    
		  ,MoodExpansive                                    
		  ,MoodAnxious                                    
		  ,MoodElevated               
		  ,MoodComment                                    
		  ,ThoughtContentNA                                    
		  ,ThoughtContentWithinLimits                                    
		  ,ThoughtContentExcessiveWorries                                    
		  ,ThoughtContentOvervaluedIdeas                                    
		  ,ThoughtContentRuminations                                    
		  ,ThoughtContentPhobias                                    
		  ,ThoughtContentComment                                    
		  ,DelusionsNA                                    
		  ,DelusionsNone                                    
		  ,DelusionsBizarre                                    
		  ,DelusionsReligious                               
		  ,DelusionsGrandiose                                    
		  ,DelusionsParanoid                                    
		  ,DelusionsComment                                    
		  ,ThoughtProcessNA                                    
		  ,ThoughtProcessLogical                                    
		  ,ThoughtProcessCircumferential                                    
		  ,ThoughtProcessFlightIdeas                                    
		  ,ThoughtProcessIllogical                                    
		  ,ThoughtProcessDerailment                                    
		  ,ThoughtProcessTangential                                    
		  ,ThoughtProcessSomatic                                    
		  ,ThoughtProcessCircumstantial                                    
		  ,ThoughtProcessComment                                    
		  ,HallucinationsNA                                    
		  ,HallucinationsNone                                    
		  ,HallucinationsAuditory                                    
		  ,HallucinationsVisual                                    
		  ,HallucinationsTactile                                    
		  ,HallucinationsOlfactory                                    
		  ,HallucinationsComment                                    
		  ,IntellectNA                                    
		  ,IntellectAverage                                    
		  ,IntellectAboveAverage                                    
		  ,IntellectBelowAverage                                  
		  ,IntellectComment                                    
		  ,SpeechNA                                    
		  ,SpeechRate                                    
		  ,SpeechTone                                    
		  ,SpeechVolume                                    
		  ,SpeechArticulation                               
		  ,SpeechComment                                    
		  ,AffectNA                                    
		  ,AffectCongruent                                    
		  ,AffectReactive                                
		  ,AffectIncongruent                                    
		  ,AffectLabile                                    
		  ,AffectComment                                    
		  ,RangeNA                                    
		  ,RangeBroad                                    
		  ,RangeBlunted                                    
		  ,RangeFlat                                    
		  ,RangeFull                                    
		  ,RangeConstricted                                    
		  ,RangeComment                                    
		  ,InsightNA                                    
		  ,InsightExcellent                                    
		  ,InsightGood                                    
		  ,InsightFair                                    
		  ,InsightPoor                                    
		  ,InsightImpaired                                   
		  ,InsightUnknown                                    
		  ,InsightComment                                    
		  ,JudgmentNA                                    
		  ,JudgmentExcellent                                    
		  ,JudgmentGood                                    
		  ,JudgmentFair                                    
		  ,JudgmentPoor                                    
		  ,JudgmentImpaired                                    
		  ,JudgmentUnknown                                    
		  ,JudgmentComment                                    
		  ,MemoryNA                                    
		  ,MemoryShortTerm                                    
		  ,MemoryLongTerm                                    
		  ,MemoryAttention                                    
		  ,MemoryComment                
          ,BodyHabitusNA                                       
		  ,BodyHabitusAverage                                   
		  ,BodyHabitusThin                                       
		  ,BodyHabitusUnderweight                                
		  ,BodyHabitusOverweight                 
		  ,BodyHabitusObese                                     
		  ,BodyHabitusComment                       
      From CustomDocumentMentalStatuses                  
      WHERE DocumentVersionId=@DocumentVersionId  AND    ISNULL(RecordDeleted,''N'')=''N''       
    
Exec csp_SCWebGetServiceNoteDiagnosesTables @DocumentVersionId            
                 
END TRY                  
                
BEGIN CATCH                  
 declare @Error varchar(8000)                  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCWebGetServiceNoteCustomDocumentMedNote'')                   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                    
    + ''*****'' + Convert(varchar,ERROR_STATE())                  
 RAISERROR                   
 (                  
  @Error, -- Message text.                  
  16,  -- Severity.                  
  1  -- State.                  
 );               
END CATCH ' 
END
GO
