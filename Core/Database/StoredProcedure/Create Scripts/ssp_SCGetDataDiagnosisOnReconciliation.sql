/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataDiagnosisOnReconciliation]    Script Date: 06/08/2015 10:31:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataDiagnosisOnReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataDiagnosisOnReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetDataDiagnosisOnReconciliation]    Script Date: 06/08/2015 10:31:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE  PROCEDURE [dbo].[ssp_SCGetDataDiagnosisOnReconciliation]  
    (  
      @DocumentVersionId INT                                                                     
    )  
AS /*********************************************************************/                                                                                            
 /* Stored Procedure:[ssp_SCGetDataDiagnosisOnReconciliation]*/                                                                        
 /* Creation Date: 19 May 2014                                         */                                                                                            
 /*                                                                    */                                                                                            
 /* Purpose: To Initialize                                             */                                                                                           
 /*                                                                    */                                                                                            
 /* Created By: Bernardin                                              */                                                                                  
 /*                                                                    */                                                                                            
 /*   Updates:                                                         */                                                                                            
 /*       Date              Author                  Purpose            */                                                                                            
         
 /*********************************************************************/                                                    
                                                   
    BEGIN                                                              
                          
        BEGIN TRY                                                   
  
          
            SELECT  D.DocumentDiagnosisCodeId ,  
                    D.CreatedBy ,  
                    D.CreatedDate ,  
                    D.ModifiedBy ,  
                    D.ModifiedDate ,  
                    D.RecordDeleted ,  
                    D.DeletedDate ,  
                    D.DeletedBy ,  
                    D.DocumentVersionId ,  
                    D.ICD10CodeId ,  
                    ISNULL(D.ICD10Code, '') AS ICD10Code ,  
                    ISNULL(D.ICD9Code, '') AS ICD9Code ,  
                    D.DiagnosisType ,  
                    D.RuleOut ,  
                    D.Billable ,  
                    D.Severity ,  
                    D.DiagnosisOrder ,  
                    D.Specifier ,  
                    D.Remission ,  
                    D.[Source] ,  
                    DSM.ICDDescription ,  
                    CASE D.RuleOut  
                      WHEN 'Y' THEN 'R/O'  
                      ELSE ''  
                    END AS RuleOutText ,  
                    dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) AS 'DiagnosisTypeText' ,  
                    dbo.csf_GetGlobalCodeNameById(D.Severity) AS 'SeverityText'  
            FROM    DocumentDiagnosisCodes AS D  
                    INNER JOIN DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId
            WHERE   ( D.DocumentVersionId = @DocumentVersionId )  
                    AND ( ISNULL(D.RecordDeleted, 'N') = 'N' )  
            ORDER BY D.DiagnosisOrder   
  
        END TRY                                                                    
                                                                                                             
        BEGIN CATCH                        
            DECLARE @Error VARCHAR(8000)                                                                     
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetDataDiagnosisOnReconciliation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*
****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                                
            RAISERROR                                                                                                   
 (                                         
  @Error, -- Message text.                                                                                                  
  16, -- Severity.                                                                                                  
  1 -- State.                                                                             
 );                                                                                                
        END CATCH                                               
    END   
GO


