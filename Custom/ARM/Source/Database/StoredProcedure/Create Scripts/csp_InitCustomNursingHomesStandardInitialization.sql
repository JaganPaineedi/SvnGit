/****** Object:  StoredProcedure [dbo].[csp_InitCustomNursingHomesStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomNursingHomesStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomNursingHomesStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomNursingHomesStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomNursingHomesStandardInitialization]              
(                                                
 @ClientID int,                
 @StaffID int,              
 @CustomParameters xml                                               
)                                                                          
As                                                                            
 /*********************************************************************/                                                                                      
 /* Stored Procedure: csp_InitCustomNursingHomesStandardInitialization               */              
                                                                             
 /* Creation Date:  12/April/2010                                    */                                                                                      
 /*                                                                   */                                                                                      
 /* Purpose: Gets Fields of CustomNursingHomes last signed Document Corresponding to clientd */                                                                                     
 /*                                                                   */                                                                                    
 /* Input Parameters:  */                                                                                    
 /*                                                                   */                                                                                       
 /* Output Parameters:                                */                                                                                      
 /*                                                                   */                                                                                      
 /* Return:   */                                                                                      
 /*                                                                   */                                                                                      
 /* Called By:CustomDocuments Class Of DataService    */                                                                            
 /*                                                                   */                                                                                      
 /* Calls:                                                            */                                                                                      
 /*                                                                   */                                                                                      
 /* Data Modifications:                                               */                                                                                      
 /*                                                                   */                                                                                      
 /*   Updates:                                                          */                                                                                      
                                                                             
 /*       Date                Author                  Purpose                                    */                                                                                      
 /***********************************************************************************************/                 
Begin                                  
                  
Begin try              
--DECLARE @CurrentAddress VARCHAR(MAX)               
DECLARE @CurrentDiagnosis VARCHAR(MAX)                
DECLARE @CurrentDocumentVersionId INT                
                
                
-- Fetch Current DocumentVersionId                
                
set @CurrentDocumentVersionId = (select top 1 CurrentDocumentVersionId                
from Documents a                      
where a.ClientId = @ClientID                                    
and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                    
and a.Status = 22                                    
and isNull(a.RecordDeleted,''N'')<>''Y''                                       
and a.DocumentCodeId =5                                    
order by a.EffectiveDate desc,a.ModifiedDate desc )                
                
                
          
set @CurrentDiagnosis =  ''Axis I-II^DSM Code^Type\r\nVersion\r\n^''              
-- Fetch Current Diagnosis                
set @CurrentDiagnosis = @CurrentDiagnosis + (select top 1 convert(varchar(10),ISNULL(a.Axis,'' ''))  + ''^'' + convert(varchar(10),ISNULL(a.DSMCODE, '' ''))+ ''^'' + ISNULL(b.CodeName,'' '') + ''^'' + ISNULL(a.DSMVersion, '' '')                
from DiagnosesIAndII a                                      
Join GlobalCodes b on a.DiagnosisType=b.GlobalCodeid                                      
where a.DiagnosisId in (select DiagnosisId from dbo.DiagnosesIAndII  where DocumentVersionId = @CurrentDocumentVersionId and isNull(RecordDeleted,''N'')<>''Y'')                                   
and isNull(a.RecordDeleted,''N'')<>''Y'' and a.billable=''Y'')         
        
set @CurrentDiagnosis =@CurrentDiagnosis +  ''\r\n\r\nAxisV  ^  Source^Type\r\n''         
             
set @CurrentDiagnosis =@CurrentDiagnosis +  ''1'' + ''^'' + ''^'' +(Select Top 1 CONVERT(varchar(10),IsNull(d.AxisV,'' '') ) + ''^'' + ''Current''         
from DiagnosesV d         
where d.DocumentVersionId =@CurrentDocumentVersionId and  isNull(RecordDeleted,''N'')<>''Y''        
)      
        
         
                                                                                      
if(exists(Select * from CustomNursingHomes C,Documents D ,                
 DocumentVersions V                                           
    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId and D.ClientId=@ClientID                         
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                                    
BEGIN                   
                
                
Select TOP 1 ''CustomNursingHomes'' AS TableName,      
       C.DocumentVersionId        
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
,C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate                        
from CustomNursingHomes C,Documents D,                
 DocumentVersions V                        
where C.DocumentVersionId=V.DocumentVersionId and V.DocumentId=D.DocumentId  and D.ClientId=@ClientID                                        
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                      
order by D.EffectiveDate Desc,D.ModifiedDate Desc  ,V.DocumentVersionId DESC                  
                                
END                                    
else                                    
BEGIN              
            
             
                                  
Select TOP 1 ''CustomNursingHomes'' AS TableName,      
-1 as ''DocumentVersionId''  
,'''' as GoalsAddressed    
,@CurrentDiagnosis as CurrentDiagnosis        
,'''' as CreatedBy                
,getdate() as CreatedDate                
,'''' as ModifiedBy                
,getdate() ModifiedDate                            
from systemconfigurations s left outer join CustomNursingHomes                
on s.Databaseversion = -1              
END                                     
end try                                                            
           
BEGIN CATCH                
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomNursingHomesStandardInitialization'')                                                                                           
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
