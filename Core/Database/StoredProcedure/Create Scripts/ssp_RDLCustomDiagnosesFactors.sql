IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLCustomDiagnosesFactors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLCustomDiagnosesFactors]
GO
CREATE PROCEDURE  [dbo].[ssp_RDLCustomDiagnosesFactors]  
(                                                      
@DocumentVersionId INT                                                                   
)                                                                              
As                                                                                
 /*********************************************************************/                                                                                          
 /* Stored Procedure:[ssp_RDLCustomDiagnosesFactors]*/                                                                      
 /* Creation Date: 19 May 2014                                         */                                                                                          
 /*                                                                    */                                                                                          
 /* Purpose: To Initialize                                             */                                                                                         
 /*                                                                    */                                                                                          
 /* Created By: Bernardin                                              */                                                                                
 /*                                                                    */                                                                                          
 /*   Updates:                                                         */                                                                                          
 /*       Date              Author                  Purpose            */                                                                                          
 /*     04/Mar/2016			Seema					what : To fetch Factors from DocumentDiagnosis instead of DocumentDiagnosisFactors 
													Why :  Ionia - Support task #377 */
 /*     15/Mar/2016			Seema					what : To fetch Factors from  DocumentDiagnosisFactors instead of  DocumentDiagnosis
													Why :  Ionia - Support task #377 */	
 /*********************************************************************/                                                  
                                                 
Begin                                                            
                        
Begin try   
                                              
SELECT DocumentDiagnosisFactorId
,DocumentVersionId
,dbo.csf_GetGlobalCodeNameById(FactorId) AS Factors
FROM DocumentDiagnosisFactors
 WHERE (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, 'N') = 'N')  
 end try                                                                  
                                                                                                           
BEGIN CATCH                      
DECLARE @Error varchar(8000)                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLCustomDiagnosesFactors')                                                                                                 
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