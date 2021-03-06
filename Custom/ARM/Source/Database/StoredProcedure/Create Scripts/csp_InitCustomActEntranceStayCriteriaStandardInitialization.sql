/****** Object:  StoredProcedure [dbo].[csp_InitCustomActEntranceStayCriteriaStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomActEntranceStayCriteriaStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomActEntranceStayCriteriaStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomActEntranceStayCriteriaStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomActEntranceStayCriteriaStandardInitialization]     
(                                            
 @ClientID int,            
 @StaffID int,          
 @CustomParameters xml                                           
)                                                                      
As                                                                        
 /*********************************************************************/                                                                                  
 /* Stored Procedure: csp_InitCustomActEntranceStayCriteriaStandardInitialization  10991             */                                                                         
                                                                         
 /* Copyright: 2007 Streamline SmartCare*/                                                                                  
                                                                         
 /* Creation Date:  8/September/2007                                    */                                                                                  
 /*                                                                   */                                                                                  
 /* Purpose: Gets Fields of DCH3803 last signed Document Corresponding to clientd */                                                                                 
 /*                                                                   */                                                                                
 /* Input Parameters:  */                                                                                
 /*                                                                   */                                                                                   
 /* Output Parameters:                                */                                                                                  
 /*                                                                   */                                                                                  
 /* Return:   */                                                                                  
 /*                                                                   */                                                                                  
 /* Called By:CustomDocuments Class Of DataService    */                                                                        
 /*      */                                                                        
                                                                         
 /*                                                                   */                                                                                  
 /* Calls:                                                            */                                                                                  
 /*                                                                   */                                                                                  
 /* Data Modifications:                                               */                                                                                  
 /*                                                                   */                                                                                  
 /*   Updates:                                                          */                                                                                  
                                                                         
 /*       Date                Author                  Purpose                                    */                                                                                  
 /*       18/Nov/2009        Ankesh Bharti     Modify according to DataModel 3.0*/    
 /*       16/Jul/2010        Mahesh S          Removed initilization of this column B''coz it is addign white space / blank value in table        */                                                                           
 /***********************************************************************************************/             
Begin                              
              
Begin try          
DECLARE @CurrentAddress VARCHAR(MAX)           
DECLARE @CurrentDiagnosis VARCHAR(MAX)            
DECLARE @CurrentDocumentVersionId INT            
            
-- Fetch Current Address using Client Id            
-- Fetch Current Address using Client Id        
     
SET @CurrentAddress = (SELECT Top 1   (ISNULL( [Address],'''') + ''\r\n''+ ISNULL([City],'''') + '', ''       
+  ISNULL([State],'''') + '' '' +ISNULL([Zip],''''))      
FROM         ClientAddresses        
WHERE (ClientId = @ClientID) and  isNull(RecordDeleted,''N'')<>''Y'' )               
            
-- Fetch Current DocumentVersionId            
            
set @CurrentDocumentVersionId = (select top 1 CurrentDocumentVersionId            
from Documents a                                
where a.ClientId = @ClientID                                
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                
and a.Status = 22                                
and isNull(a.RecordDeleted,''N'')<>''Y''                                   
and a.DocumentCodeId =5                                
order by a.EffectiveDate desc,a.ModifiedDate desc )            
            
            
-- Fetch Current Diagnosis          
     
set @CurrentDiagnosis =  ''Axis I-II^DSM Code^Type^Version\r\n^''          
-- Fetch Current Diagnosis            
--set @CurrentDiagnosis = @CurrentDiagnosis + (select top 1 convert(varchar(10),ISNULL(a.Axis,'' ''))  + ''^'' + convert(varchar(10),ISNULL(a.DSMCODE, '' ''))+ ''^'' + ISNULL(b.CodeName,'' '')  + ''^'' + ISNULL(a.DSMVersion, '' '')            
--from DiagnosesIAndII a                                  
--Join GlobalCodes b on a.DiagnosisType=b.GlobalCodeid                                  
--where DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId = @CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')                               
--and isNull(a.RecordDeleted,''N'')<>''Y'' and a.billable=''Y'') 

select @CurrentDiagnosis = @CurrentDiagnosis + convert(varchar(10),ISNULL(a.Axis,'' ''))  + ''^'' + convert(varchar(10),ISNULL(a.DSMCODE, '' ''))+ ''^'' + ISNULL(b.CodeName,'' '')  + ''^'' + ISNULL(a.DSMVersion, '' '') + ''\r\n^''           
from DiagnosesIAndII a                                  
Join GlobalCodes b on a.DiagnosisType=b.GlobalCodeid                                  
where DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId = @CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')                               
and isNull(a.RecordDeleted,''N'')<>''Y'' and a.billable=''Y''      
                                                                                  
if(exists(Select * from CustomActEntranceStayCriteria C,Documents D ,            
 DocumentVersions V                                       
    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId and D.ClientId=@ClientID                     
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                                
BEGIN               
            
            
SELECT     TOP (1) ''CustomActEntranceStayCriteria'' AS TableName, C.DocumentVersionId, @CurrentAddress AS CurrentAddress, @CurrentDiagnosis AS CurrentDiagnosis,     
                      C.HasSeverePsychoticSymptoms, C.SymptomThoughtProcess, C.SymptomPanicReactions, C.SymptomQuestionableJudgment, C.SymptomPerception,     
                      C.SymptomAgitation, C.SymptomPsychomotor, C.SymptomMemory, C.SymptomAffect, C.SymptomObsessionsRuminations, C.SymptomWithdrawalorAvoidance,     
                      C.SymptomImpairmentsinRolePerformance, C.SymptomCompulsionsRituals, C.SymptomImpairmentsinFunctioning, C.SymptomHallucinations,     
                      C.SymptomDisorderedAberrantConduct, C.SymptomPhobias, C.SymptomConsciousness, C.SymptomDepression, C.SymptomDelusions, C.SymtpomImpulseControl,     
                      C.HasDisruptionsSelfCare, C.SelfCareUnableWithoutMonitoring, C.SelfCareIncapacityResponsibilities, C.SelfCareSeriousNeglect, C.SelfCareAdequateNutrition,     
                      C.SelfCareHousekeeping, C.SelfCareShopping, C.SelfCarePayingBills, C.SelfCareMealPreparation, C.SelfCareInterpersonalRelationships,     
     C.SelfCareAccessingSupports, C.HasRiskToSelfOthers, C.RiskHistoryAssaultThreat, C.RiskVerbalized, C.RiskMinorPropertyDestruction, C.RiskHarmToSelf,     
                      C.RiskSelfMutilation, C.RiskPotentialSelf, C.RiskPotentialOthers, C.HasMedicationIssues, C.MedicationComplianceMonitoring, C.MedicationManagingSupport,     
                      C.MedicationPsychoticSymptoms, C.MedicationCoexistingCondition, C.HasCoOccuringSubstanceDisorder, C.HasFrequentInaptientServices,     
                      C.MostRecentHospitalizationDate, C.AdditionalComments, C.CreatedBy, C.CreatedDate, C.ModifiedBy, C.ModifiedDate    
FROM         CustomActEntranceStayCriteria AS C INNER JOIN    
                      DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN    
                      Documents AS D ON V.DocumentId = D.DocumentId    
WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')    
ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC, V.DocumentVersionId DESC             
                            
END                                
else                                
BEGIN          
        
         
--sp_help CustomActEntranceStayCriteria     
-- select * from CustomActEntranceStayCriteria order by 1 desc                           
Select TOP 1 ''CustomActEntranceStayCriteria'' AS TableName, -1 as ''DocumentVersionId''            
                   
,@CurrentAddress as CurrentAddress            
,@CurrentDiagnosis as CurrentDiagnosis            
           
,GETDATE() AS MostRecentHospitalizationDate            
--,'''' AS AdditionalComments  Removed initilization of this column B''coz it is addign white space / blank value in table  15 July,2010               
,'''' as CreatedBy            
,getdate() as CreatedDate            
,'''' as ModifiedBy            
,getdate() ModifiedDate                        
from systemconfigurations s left outer join CustomActEntranceStayCriteria            
on s.Databaseversion = -1          
END                                 
end try                                                        
                                                                                                 
BEGIN CATCH            
DECLARE @Error varchar(8000)                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())     
+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),    
''csp_InitCustomActEntranceStayCriteriaStandardInitialization'')                                                                                       
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
