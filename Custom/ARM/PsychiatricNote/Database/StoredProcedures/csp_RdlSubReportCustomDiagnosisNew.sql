/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDiagnosisNew]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDiagnosisNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomDiagnosisNew] 
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDiagnosisNew]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RdlSubReportCustomDiagnosisNew]                  
(                                                        
@DocumentVersionId INT                                                                     
)                                                                                
As                                                                                  
 /*********************************************************************/                                                                                            
 /* Stored Procedure:[csp_RdlSubReportCustomDiagnosisNew]*/                                                                        
 /* Creation Date: 19 May 2014                                         */                                                                                            
 /*                                                                    */                                                                                            
 /* Purpose: To Initialize                                             */                                                                                           
 /*                                                                    */                                                                                            
 /* Created By:                                               */                                                                                  
 /*                                                                    */                                                                                            
 /*   Updates:                                                         */                                                                                            
 /*       Date              Author                  Purpose            */                                                                                            
         
      
 /*********************************************************************/                                                    
                                                   
Begin                                                              
                          
Begin try         
  
SELECT 
DDICD10.ScreeeningTool  
,DDICD10.OtherMedicalCondition  
,DDICD10.FactorComments  
,DDICD10.GAFScore  
,DDICD10.WHODASScore  
,DDICD10.CAFASScore   
,DDICD10.NoDiagnosis  
FROM DocumentDiagnosis DDICD10  
  JOIN Documents D ON DDICD10.DocumentVersionId = D.CurrentDocumentVersionId 
  JOIN DocumentCodes DC ON D.DocumentCodeId = DC.DocumentCodeId  
  WHERE DDICD10.DocumentVersionId = @DocumentVersionId 
   AND ISNull(D.RecordDeleted, 'N') = 'N'  
   AND ISNull(DC.RecordDeleted, 'N') = 'N'  
   AND ISNull(DDICD10.RecordDeleted, 'N') = 'N'                                        
       
end try                                                                    
                                                                                                             
BEGIN CATCH                        
DECLARE @Error varchar(8000)                                                                     
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RdlSubReportCustomDiagnosisNew')   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                   
    + '*****' + Convert(varchar,ERROR_STATE())                                                
 RAISERROR                                                                                                   
 (                                         
  @Error, -- Message text.                                                                                                  
  16, -- Severity.                                                                                                  
  1 -- State.                                                                             
 );                                                                                                
END CATCH                                               
END 