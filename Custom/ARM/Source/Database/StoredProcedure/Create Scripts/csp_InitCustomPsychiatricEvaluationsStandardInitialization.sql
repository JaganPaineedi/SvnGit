/****** Object:  StoredProcedure [dbo].[csp_InitCustomPsychiatricEvaluationsStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPsychiatricEvaluationsStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomPsychiatricEvaluationsStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomPsychiatricEvaluationsStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomPsychiatricEvaluationsStandardInitialization]                
(                                        
 @ClientID int,                  
 @StaffID int,                
 @CustomParameters xml                                        
)                                                                
As                                                                        
 /*********************************************************************/                                                                            
 /* Stored Procedure: [csp_InitCustomPsychiatricEvaluationsStandardInitialization]               */                                                                   
 /* Creation Date:  5/April/2010                                    */                                                                            
 /*                                                                   */                                                                            
 /* Purpose: To Initialize */                                                                           
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
                                                                   
 /*       Date              Author                  Purpose                                    */                                                                            
 /*********************************************************************/                                                                             
Begin              
Begin try   

declare @LatestDocumentVersionID int          
set @LatestDocumentVersionID =(select top 1 CurrentDocumentVersionId                                
								from Documents a                                                    
								where a.ClientId = @ClientID                                                    
								and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                    
								and a.Status = 22                
								and a.DocumentCodeId=5                                                     
								and isNull(a.RecordDeleted,''N'')<>''Y''                                                                                       
								order by a.EffectiveDate desc,a.ModifiedDate desc )                                                                                                             
                                                                                        
                                            
   
Select TOP 1 ''CustomPsychiatricEvaluations'' AS TableName, -1 as ''DocumentVersionId''                              
--Custom data                            
      ,[IdentifyingData]  
      ,[ChiefComplaint]  
      ,[HistoryofPresentIllness]  
      ,[PastPsychiatricHistory]  
      ,[MedicalHistory]  
      ,[SocialHistory]  
      ,[MentalStatusExam]  
      ,[Prognosis]  
      ,[OtherTherapyInterventionsPlanned1]  
      ,[OtherTherapyInterventionsPlanned2]  
      ,[MedicationCompliance]  
      ,[OtherConcernsNotAddressed]  
      ,[OtherIndividuals]  
      ,[PlanReviewFrequency],       
--Custom Data                            
  '''' as CreatedBy,                              
  getdate() as CreatedDate,                              
  '''' as ModifiedBy,                              
  getdate() as ModifiedDate                                
 from systemconfigurations s left outer join CustomPsychiatricEvaluations C               
 on s.Databaseversion = -1           
                 
SELECT TOP 1 ''DiagnosesIII'' AS TableName,DocumentVersionId,Specification                                                          
      ,DiagnosesIII.CreatedBy,DiagnosesIII.CreatedDate                                                          
      ,DiagnosesIII.ModifiedBy,DiagnosesIII.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                                             
      FROM systemconfigurations s left outer join DiagnosesIII                                                                      
      on s.Databaseversion=-1                      
      ----For DiagnosesIV--                                                            
      SELECT TOP 1 ''DiagnosesIV'' AS TableName,DocumentVersionId,PrimarySupport,SocialEnvironment,Educational                                                   
      ,Occupational,Housing,Economic,HealthcareServices,Legal,Other,Specification,DiagnosesIV.CreatedBy                                                            
      ,DiagnosesIV.CreatedDate,DiagnosesIV.ModifiedBy                                                          
      ,DiagnosesIV.ModifiedDate,DiagnosesIV.RecordDeleted,DeletedDate,DeletedBy                                                             
      FROM systemconfigurations s left outer join DiagnosesIV                                                                                          
      on s.Databaseversion=-1                                                                
      -----For DiagnosesV---                                      
      SELECT TOP 1 ''DiagnosesV'' AS TableName,DocumentVersionId,AxisV                                                          
      ,DiagnosesV.CreatedBy,DiagnosesV.CreatedDate                                                          
      ,DiagnosesV.ModifiedBy                        
      ,DiagnosesV.ModifiedDate,RecordDeleted,DeletedDate,DeletedBy                                               
      FROM systemconfigurations s left outer join DiagnosesV                                                                                          
      on s.Databaseversion=-1       
                                        
end try                                                          
BEGIN CATCH              
DECLARE @Error varchar(8000)                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomPsychiatricEvaluationsStandardInitialization'')                                                                                         
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
