/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomMedicationHistory]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetDataCustomMedicationHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLGetDataCustomMedicationHistory]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetDataCustomMedicationHistory]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
      
CREATE PROCEDURE [dbo].[csp_RDLGetDataCustomMedicationHistory]        
(                                                                  
  @DocumentVersionId int                                      
)                                                                  
                                                                  
AS                                                        
/***************************************************************************/                                                               
/* Stored Procedure: [csp_RDLGetDataCustomMedicationHistory] */                                                                                                               
/* Copyright: 2006 Streamline SmartCare               */                                                                                                                        
/* Creation Date:  14-July-2009                 */                                                                                                                        
/* Purpose: Gets Data [csp_RDLGetDataCustomMedicationHistory] */                                                                                                                       
/* Input Parameters: @DocumentVersionId            */                                                                                                                      
/* Output Parameters:                   */                                                                                                                        
/* Return:  0=success, otherwise an error number                           */                                                         
/* Purpose to show the RDL for Venture PreScren          */                                                                                                              
/* Calls:                                                                  */                                                                              
/* Data Modifications:                                                     */                                                                              
/* Updates:                                                                */                                                                              
/* Date                 Author           Purpose        */                                                                              
/* 14-July-2009         Umesh sharma     Created        */                   
           
/***************************************************************************/                                                                  
                                                        
BEGIN                                                                                 
                                       
 BEGIN TRY                                                        
                  
      SELECT [MedicationHistoryId]          
      ,CustomMedicationHistory.[DocumentVersionId]          
      ,[MedicationName]          
      ,[DosageFrequency]          
      ,[Purpose]          
      ,[PrescribingPhysician]          
      ,CustomMedicationHistory.[RecordDeleted]          
               
  FROM [CustomMedicationHistory]     
  join DocumentVersions  ON        
  CustomMedicationHistory.DocumentVersionId = DocumentVersions.DocumentVersionId and isnull(DocumentVersions.RecordDeleted,'N')<>'Y'    
  and isnull(CustomMedicationHistory.RecordDeleted,'N')<>'Y'              
  join Documents  on Documents.DocumentId = DocumentVersions.DocumentId      
  and isnull(Documents.RecordDeleted,'N')<>'Y'      
  where ISNull(CustomMedicationHistory.RecordDeleted,'N')='N' AND CustomMedicationHistory.DocumentVersionId=@DocumentVersionId                    
                                                         
 END TRY                                                        
 BEGIN CATCH                                                                             
  DECLARE @Error varchar(8000)                                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_RDLGetDataCustomMedicationHistory]')                                                                                                         
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


