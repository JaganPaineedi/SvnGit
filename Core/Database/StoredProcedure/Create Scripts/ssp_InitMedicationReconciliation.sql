IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitMedicationReconciliation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitMedicationReconciliation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  
    
 CREATE Procedure [dbo].[ssp_InitMedicationReconciliation]            
 @ClientID INT,                                              
 @StaffID INT,                                            
 @CustomParameters XML                
AS                
 /*********************************************************************/                                                                                                      
 /* Stored Procedure: ssp_InitMedicationReconciliation                */                                                                                             
 /* Creation Date:  21/August/2017                                    */    
 /* Author : Arjun K R                                                */                                                                                                                                          
 /* Purpose: To Initialized MedicationReconciliation                  */                                                                                                                          
 /*                                                                   */                                                                                                      
 /* Data Modifications:                                               */                                                                                                      
 /* Updates:                                                          */                                                                                                      
 /* Date              Author                  Purpose                 */                                  
 /*********************************************************************/                   
                  
Begin                                            
Begin TRY                             
                
SELECT TOP 1 'DocumentMedicationReconciliations' AS TableName     
      ,-1 AS [DocumentVersionId]         
      ,DMR.[CreatedBy]
      ,DMR.[CreatedDate]
      ,DMR.[ModifiedBy]
      ,DMR.[ModifiedDate]
      ,DMR.[RecordDeleted]
      ,DMR.[DeletedBy]
      ,DMR.[DeletedDate]
      ,DMR.[ClientCCDId]
      ,DMR.[ReconciliationType]
      ,DMR.[Comment]
  FROM  SystemConfigurations s            
 LEFT OUTER JOIN  [DocumentMedicationReconciliations] DMR ON s.Databaseversion = -1                


END TRY                                                                                        
BEGIN CATCH                                            
If (@@error!=0)            
  Begin            
   RAISERROR ('ssp_InitMedicationReconciliation: An Error Occured',16,1)           
   Return            
   End                                                                                                                 
END CATCH                                                                   
END 