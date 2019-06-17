IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_DeleteTempTables]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_DeleteTempTables] 

GO
CREATE procedure [dbo].[ssp_DeleteTempTables]    
(    
 @SessionId varchar(24)    
)    
As    
/*********************************************************************/       
/* Stored Procedure: dbo.[ssp_DeleteTempTables]       */       
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */       
/* Creation Date:    08th Dec 2008                                       */       
/*                                                                   */       
/* Purpose:  Delete Temporary tables if exists (For Show RDL Report   */                                  
/*                                                                   */       
/* Input Parameters: none        */                 
/*                                                                   */       
/* Output Parameters:   None           */                                     
/*                                                                   */       
/* Return:  0=success, otherwise an error number                     */       
/*                                                                   */       
/* Called From: UpdateTempDocuments  method on Mediaction web service*/       
/* Data Modifications:                                               */       
/*                                                                   */       
/* Created:                                                          */       
/*   Date        Author      Purpose                                 */       
/* 08th Dec 08   Chandan     Created                                 */ 
/* 26th July 16  Anto        Added delete query to clear data from ClientMedicationScriptDrugStrengthsPreview table. KCMHSAS – Support #556*/
/*********************************************************************/                 
    
Begin Try   

 Delete from ClientMedicationScriptDrugStrengthsPreview where ClientMedicationId in
 ( SELECT ClientMedicationId from ClientMedicationsPreview where SessionId=@SessionId)
 
 Delete from ClientMedicationsPreview where SessionId=@SessionId    
 Delete from ClientMedicationInstructionsPreview where SessionId=@SessionId    
 Delete from ClientMedicationScriptsPreview where SessionId=@SessionId    
 Delete from ClientMedicationScriptDrugsPreview where SessionId=@SessionId    

End Try    
    
Begin catch    
 declare @Error varchar(8000)                        
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_DeleteTempTables')                         
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
  + '*****' + Convert(varchar,ERROR_STATE())                        
                           
  RAISERROR                         
  (                        
   @Error, -- Message text.                        
   16, -- Severity.                        
   1 -- State.                        
  );                        
                        
End Catch  