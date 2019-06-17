If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.ssp_RDLCustomDiagnosesICD10') 
                  And Type In ( N'P', N'PC' )) 
 Drop Procedure dbo.ssp_RDLCustomDiagnosesICD10
Go
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    


CREATE PROCEDURE  [dbo].[ssp_RDLCustomDiagnosesICD10]          
(                                                      
@DocumentVersionId INT                                                                   
)                                                                              
As                                                                                
 /*********************************************************************/                                                                                          
 /* Stored Procedure:[ssp_RDLCustomDiagnosesICD10]*/                                                                      
 /* Creation Date: 19 May 2014                                         */                                                                                          
 /*                                                                    */                                                                                          
 /* Purpose: To Initialize                                             */                                                                                         
 /*                                                                    */                                                                                          
 /* Created By: Bernardin                                              */                                                                                
 /*                                                                    */                                                                                          
 /*   Updates:                                                         */                                                                                          
 /*       Date              Author                  Purpose            */                                                                                          
 /*    19/09/2015          Bernardin             Added column "Comments" in "DocumentDiagnosisCodes" table */      
 /*    05/16/2016	       Govind				 Added Recorddelete Check for Document Diagnosis*/ 
 /*	   02/20/2017		   Munish Sood			Added Distinct key and RecordDeleted checks as per Allegan - Support Task # 826 */ 
 /*********************************************************************/                                                  
                                            
Begin                                                            
                        
Begin try                                                 

  -- Msood 2/20/2017      
 SELECT Distinct D.DocumentDiagnosisCodeId,D.CreatedBy,D.DocumentVersionId,  D.ICD10Code, D.ICD9Code,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS DiagnosisType,case D.Billable when 'Y' then 'Yes' else 'No' end as Billable, dbo.csf_GetGlobalCodeNameById(D.Severity) AS Severity,D.DiagnosisOrder,                 
       D.Specifier,dbo.csf_GetGlobalCodeNameById(D.Remission) AS Remission,D.[Source], DSM.ICDDescription AS DSMDescription, case D.RuleOut when 'Y' then 'Yes' else 'No' end as RuleOutText,DD.NoDiagnosis,D.Comments,SNMED.SNOMEDCTCode,SNMED.SNOMEDCTDescription
 FROM  DocumentDiagnosisCodes AS D INNER JOIN              
       DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId   INNER JOIN
       DocumentDiagnosis AS DD ON DD.DocumentVersionId = D.DocumentVersionId LEFT JOIN
       SNOMEDCTCodes AS SNMED ON D.SNOMEDCODE = SNMED.SNOMEDCTCode
 WHERE     (D.DocumentVersionId = @DocumentVersionId) AND (ISNULL(D.RecordDeleted, 'N') = 'N') 
 --  -- Msood 2/20/2017 
 and isnull(dd.RecordDeleted,'N') ='N'
 and ISNULL(DSM.RecordDeleted,'N')='N'
 and ISNULL(SNMED.RecordDeleted,'N')='N'

 Order by d.DiagnosisOrder 
 
 end try                                                                  
                                                                                                           
BEGIN CATCH                      
DECLARE @Error varchar(8000)                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLCustomDiagnosesICD10')                                                                                                 
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
GO


