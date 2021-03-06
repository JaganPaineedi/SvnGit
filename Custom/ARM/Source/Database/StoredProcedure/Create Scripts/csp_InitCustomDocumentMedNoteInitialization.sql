/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentMedNoteInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentMedNoteInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentMedNoteInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentMedNoteInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE  [dbo].[csp_InitCustomDocumentMedNoteInitialization]                    
(                                            
 @ClientID int,                      
 @StaffID int,                    
 @CustomParameters xml                                            
)                                                                    
As                                                                            
 /*********************************************************************/                                                                                
 /* Stored Procedure: [csp_InitCustomDocumentMedNoteInitialization]               */                                                                       
 /* Creation Date:  11/July/2011                                    */                                                                                
 /* Purpose: To Initialize */                                                                               
 /* Input Parameters:  */                                                                              
 /* Output Parameters:                                */                                                                                
 /* Return:   */                                                                                
 /* Called By:CustomDocuments Class Of DataService    */                                                                      
 /* Calls:                                                            */                                                                                
 /*                                                                   */                                                                                
 /* Data Modifications:                                               */                                                                                
 /*   Updates:                                                          */                                                                                
 /*       Date              Author                  Purpose    */  
 /*     20/July/2011        Jagdeep                 Creation  */                                                                                
 /*********************************************************************/                                                                                 
Begin                  
Begin try       
    
DECLARE @LatestDocumentVersionID int      
DECLARE @clientName varchar(110)                                                                      
DECLARE @clientAge varchar(10)  
DECLARE @clientGender varchar(1)

SET @clientName = (Select  (LastName+'' ''+ FirstName) from Clients                                                                                   
    where ClientId=19 and IsNull(RecordDeleted,''N'')=''N'')  
SET @clientGender = (Select  Sex from Clients                                                                                   
    where ClientId=@ClientID and IsNull(RecordDeleted,''N'')=''N'')   
      
Exec csp_CalculateAge @ClientId, @clientAge out 
  
SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomDocumentMedNote C,Documents D                                                                           
  where C.DocumentVersionId=D.CurrentDocumentVersionId and D.ClientId=@ClientID                                                                                                                              
 and D.Status=22 and DocumentCodeId =1490 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                               
 ORDER BY D.EffectiveDate DESC,D.ModifiedDate desc                                                    
)     
if(exists(SELECT * FROM CustomMDNotes M,Documents D ,             
 DocumentVersions V                                               
    WHERE M.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId                 
     and D.ClientId=@ClientID                                
and D.Status=22 and DocumentCodeId =1490 and IsNull(M.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                                                
BEGIN                               
                
SELECT TOP 1 ''CustomDocumentMedNote'' AS TableName ,CDMN.[DocumentVersionId]      
      ,CDMN.[CreatedBy]  
      ,CDMN.[CreatedDate]  
      ,CDMN.[ModifiedBy]  
      ,CDMN.[ModifiedDate]  
      ,CDMN.[RecordDeleted]  
      ,CDMN.[DeletedBy]  
      ,CDMN.[DeletedDate]  
      ,CDMN.[ClientName]
      ,CDMN.[ClientAge]
      ,CDMN.[ClientGender]
      ,CDMN.[DateOfService]
      ,CDMN.[CurrentMedications]
      ,CDMN.[PreviousTreatmentRecommendationAndOrders]
      ,CDMN.[ChangesSinceLastVisit]
      ,CDMN.[MedicationsPrescribed]
      ,CDMN.[MedEducationSideEffectsDiscussed]
      ,CDMN.[MedEducationAlternativesReviewed]
      ,CDMN.[MedEducationAgreedRegimen]
      ,CDMN.[MedEducationAwareOfSubstanceUseRisks]
      ,CDMN.[MedEducationAwareEmergencySymptoms]
      ,CDMN.[TreatmentRecommendationAndOrders]
      ,CDMN.[OtherInstructions]
     
FROM [CustomDocumentMedNote]                   
CDMN INNER JOIN DocumentVersions DV ON CDMN.DocumentVersionId=DV.DocumentVersionId  
INNER JOIN Documents D ON  DV.DocumentId=D.DocumentId  
WHERE  
D.ClientId=@ClientID                    
AND D.Status=22  AND IsNull(CDMN.RecordDeleted,''N'')=''N'' AND IsNull(D.RecordDeleted,''N'')=''N''                                                 
ORDER BY D.EffectiveDate Desc,D.ModifiedDate Desc                                                
      ------For DiagnosesIII----                                                                
  SELECT ''DiagnosesIII'' as TableName,                                                                                                                                                                                                 
  DocumentVersionId                                                                         
      ,CreatedBy                                                                                                    
      ,CreatedDate                                                                                                    
      ,ModifiedBy                                             
      ,ModifiedDate                                          
      ,RecordDeleted                                                                                                    
      ,DeletedDate                          
      ,DeletedBy                                                                                                    
      ,Specification                                                             
   FROM DiagnosesIII                                                                                                                                                                   
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                                                         
                                                                                                                                                                                                       
   -----For DiagnosesIV-----                                                          
   SELECT    ''DiagnosesIV'' as TableName,                             
   DocumentVersionId                                                                                                                       
  ,PrimarySupport                                                                                                  ,SocialEnvironment                                                                       
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
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                                                                                                     
    -----For DiagnosesV-----                                                                
   SELECT  ''DiagnosesV'' as TableName
     ,DocumentVersionId                                                                                                                              
     ,AxisV                                                                                                                                                     
	 ,CreatedBy                                                                                                                                 
	 ,CreatedDate                                                                                         
	 ,ModifiedBy                                                              
	 ,ModifiedDate                                                                                                                                                                                                       
	 ,RecordDeleted                                                                                                               
	 ,DeletedDate                                            
	 ,DeletedBy                                                           
   FROM DiagnosesV                                                               
   WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                                                                                                                                                                       
 -----For DiagnosesIAndII-----                                                                                                                                     
   SELECT ''DiagnosesIAndII'' as TableName,    
   D.DocumentVersionId                                                                                                                                                                            
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
  ,D.RowIdentifier                                                                                                                                                                                           
  ,D.CreatedBy                                                         
  ,D.CreatedDate                                       
  ,D.ModifiedBy                                                                                                                
  ,D.ModifiedDate                                                              
  ,D.RecordDeleted                                                                                                                                       
  ,D.DeletedDate                                                            
  ,D.DeletedBy                                                                                                                      
  ,DSM.DSMDescription                                                                                        
  ,CASE D.RuleOut WHEN ''Y'' THEN ''R/O'' ELSE '''' END AS RuleOutText                                                
   FROM DiagnosesIAndII  D                                                                                                                                                                                          
  inner join DiagnosisDSMDescriptions DSM on  DSM.DSMCode = D.DSMCode                                          
  and DSM.DSMNumber = D.DSMNumber                  
  WHERE DocumentVersionId=@LatestDocumentVersionID   AND ISNULL(RecordDeleted,''N'')=''N''                                                                            
  --DiagnosesIIICodes              
 IF exists (Select DocumentVersionId from DiagnosesIIICodes where DocumentVersionId=@LatestDocumentVersionID)            
 BEGIN                
 SELECT ''DiagnosesIIICodes'' as TableName,DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,DIIICod.RecordDeleted,      
         DIIICod.DeletedDate,DIIICod.DeletedBy                
 FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode                                                                     
 WHERE (DIIICod.DocumentVersionId = @LatestDocumentVersionID) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')                                                  
 END             
 ---DiagnosesMaxOrder                                                                      
   SELECT  top 1 max(DiagnosisOrder) AS DiagnosesMaxOrder  ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,                                                                      
   RecordDeleted,DeletedBy,DeletedDate FROM  DiagnosesIAndII                                                                       
   WHERE DocumentVersionId=@LatestDocumentVersionID                                                                                
   and  IsNull(RecordDeleted,''N'')=''N'' GROUP BY CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate                                                                      
   ORDER BY DiagnosesMaxOrder DESC                                                            
       
   SELECT ''CustomDocumentMentalStatuses'' AS TableName,DocumentVersionId,              
       CreatedBy                                      
      ,CreatedDate                                      
      ,ModifiedBy                                      
      ,ModifiedDate                                      
      ,RecordDeleted                                      
      ,DeletedBy                                      
      ,DeletedDate               
      ,ConsciousnessNA                                  
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
      FROM CustomDocumentMentalStatuses                
      WHERE DocumentVersionId=@LatestDocumentVersionID AND ISNULL(RecordDeleted,''N'')=''N''                           
END                     
ELSE                                                
BEGIN                                                
SELECT TOP 1 ''CustomDocumentMedNote'' AS TableName, -1 as ''DocumentVersionId''                                  
--Custom data                                
      
      ,CDMN.[RecordDeleted]  
      ,CDMN.[DeletedBy]  
      ,CDMN.[DeletedDate]
      ,@clientName as [ClientName]  
      ,@clientAge  as [ClientAge]  
      ,@clientGender as [ClientGender]    
      ,CDMN.[DateOfService]
      ,CDMN.[CurrentMedications]
      ,CDMN.[PreviousTreatmentRecommendationAndOrders]
      ,CDMN.[ChangesSinceLastVisit]
      ,CDMN.[MedicationsPrescribed]
      ,CDMN.[MedEducationSideEffectsDiscussed]
      ,CDMN.[MedEducationAlternativesReviewed]
      ,CDMN.[MedEducationAgreedRegimen]
      ,CDMN.[MedEducationAwareOfSubstanceUseRisks]
      ,CDMN.[MedEducationAwareEmergencySymptoms]
      ,CDMN.[TreatmentRecommendationAndOrders]
      ,CDMN.[OtherInstructions]  
      ,'''' as CreatedBy                                  
      , getdate() as CreatedDate                                  
      , '''' as ModifiedBy                                  
      , getdate() as ModifiedDate
                                           
 FROM systemconfigurations s LEFT OUTER JOIN CustomDocumentMedNote CDMN                   
 ON s.Databaseversion = -1               
                     
  SELECT                                                                                                                                                           
    ''DiagnosesIII'' as TableName,-1 as DocumentVersionId,                                                                             
    '''' as CreatedBy                                                                                                            ,getdate() as CreatedDate                                                                                          
    ,'''' as ModifiedBy                                                                                         
    ,getdate() as ModifiedDate                                                                                                        
    ,RecordDeleted                                                                                                        
    ,DeletedDate                                                                                                        
    ,DeletedBy                                                                                                        
    ,Specification                                                                                  
   FROM systemconfigurations s left outer join DiagnosesIII                                                     
   on s.Databaseversion = -1                                      
                                          
    -- -----For DiagnosesIV-----                                                                                                                             
  SELECT                                                                   
    ''DiagnosesIV'' as TableName,-1 as DocumentVersionId                                                            
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
   ,'''' as CreatedBy                                                           
   ,getdate() as CreatedDate                                                               
   ,'''' as ModifiedBy                                                                                                        
   ,getdate() as ModifiedDate                                              
   ,RecordDeleted                                                                          
   ,DeletedDate                                                                                                                 
   ,DeletedBy                                                                             
   FROM systemconfigurations s left outer join DiagnosesIV                                                     
   on s.Databaseversion = -1                                      
                                       
   -- -----For DiagnosesV-----                                                                                          
  SELECT                                                                                                                                            
  ''DiagnosesV'' as TableName,-1 as DocumentVersionId                                                                                                                                
  ,AxisV                                                                                                                                                                                                              
  ,'''' as CreatedBy                                                                                                                                     
  ,getdate() as CreatedDate                                                                                             
  ,'''' as ModifiedBy                                                                                                                                              
  ,getdate() as ModifiedDate                                                                                         
  ,RecordDeleted                                                                                                                   
  ,DeletedDate                                                                          
  ,DeletedBy                                                                                                              
  FROM systemconfigurations s left outer join DiagnosesV                                                     
  on s.Databaseversion = -1                                     
                                    
    --Diagnosis I and II                                             
  SELECT ''DiagnosesIAndII'' as TableName                                                           
    ,Convert(int,0 - Row_Number() Over (Order by  DiagnosesIAndII.DiagnosisId asc))                                                                                   
     as  DiagnosisId                                            
    ,DocumentVersionId                                            
    ,Axis                                            
    ,DSMCode                                            
    ,DSMNumber                                            
    ,DiagnosisType                                            
    ,RuleOut                                            
    ,Billable                                            
    ,Severity                                            
    ,DSMVersion                                            
    ,DiagnosisOrder                                            
    ,Specifier                                            
    ,Remission                                            
    ,Source                                            
    ,RowIdentifier                                            
    ,CreatedBy                                            
    ,CreatedDate                                            
    ,ModifiedBy                                            
    ,ModifiedDate                                            
    ,RecordDeleted                                            
    ,DeletedDate                                            
    ,DeletedBy                                            
    ,''CustomGrid'' as ParentChildName                                               
    FROM dbo.DiagnosesIAndII               
    where DocumentVersionId=@LatestDocumentVersionID and IsNull(RecordDeleted,''N'')=''N''                                    
                      
                                                    
    --DiagnosesIIICodes                                                         
   SELECT ''DiagnosesIIICodes'' as TableName, DIIICod.DiagnosesIIICodeId, DIIICod.DocumentVersionId,DIIICod.ICDCode,DICD.ICDDescription,                                      
   DIIICod.Billable,DIIICod.CreatedBy,DIIICod.CreatedDate,DIIICod.ModifiedBy,DIIICod.ModifiedDate,                                    
   DIIICod.RecordDeleted,DIIICod.DeletedDate,DIIICod.DeletedBy                                          
   FROM    DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode                                                             
   WHERE (DIIICod.DocumentVersionId = @LatestDocumentVersionID) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')                                         
                                           
    --DiagnosesIANDIIMaxOrder                                                    
   SELECT  top 1 ''DiagnosesIANDIIMaxOrder'' as TableName,max(DiagnosisOrder) as DiagnosesMaxOrder   ,CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate                                                   
   from  DiagnosesIAndII                                                   
   where DocumentVersionId=@LatestDocumentVersionID                                                           
   and  IsNull(RecordDeleted,''N'')=''N''                                    
   group by CreatedBy,ModifiedBy,CreatedDate,ModifiedDate,RecordDeleted,DeletedBy,DeletedDate order by DiagnosesMaxOrder desc                                                    
                   
  -- Mental Status --                
    SELECT     
   ''CustomDocumentMentalStatuses'' as TableName                                 
   ,-1 as DocumentVersionId               
    ,'''' as CreatedBy,                                                                
   getdate() as CreatedDate,                                                                
   '''' as ModifiedBy,                                                                
   getdate() as ModifiedDate                                                    
   from systemconfigurations s left outer join CustomDocumentMentalStatuses                                                     
  on s.Databaseversion = -1      
    
END                                              
end try                                                              
BEGIN CATCH                  
DECLARE @Error varchar(8000)                                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentMedNoteInitialization'')                                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                                          
 RAISERROR                                                                                             
 (                                                               
  @Error, -- Message text.                                                                                            
  16, -- Severity.                                                                                            
  1 -- State.                                                                                            
 );                                                                                          
END CATCH                                         
END ' 
END
GO
