  
  
CREATE PROCEDURE [dbo].[ssp_ValidateDocumentAudit]    
 @DocumentVersionId int      
AS    
     
/**************************************************************    
  
Description  : Used to Validate   
Called From  :   
/*  Date     Author      Description */  
/* 18/Apr/2018        Pradeep Y            Created (Ref: Task#10030 Porter Starke-Customizations */   
**************************************************************/  
BEGIN try   
  
-- Declare Variables    
DECLARE @DocumentType varchar(10)    
    
-- Get ClientId    
DECLARE @ClientId int    
    
    
SELECT @ClientId = d.ClientId    
FROM Documents d    
WHERE d.CurrentDocumentVersionId = @DocumentVersionId    
    
    
    
-- Set Variables sql text    
DECLARE @Variables varchar(max)      
SET @Variables = 'DECLARE @DocumentVersionId int    
      SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +    
     --'DECLARE @DocumentType varchar(10)    
     -- SET @DocumentType = ' +''''+ @DocumentType+'''' +    
     ' DECLARE @ClientId int    
      SET @ClientId = ' + convert(varchar(20), @ClientId)    
    
If Not Exists (Select * From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationid is null)      
Begin      
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 1652, @DocumentType, @Variables   
End    
  
  
END try   
  
BEGIN catch   
  DECLARE @Error VARCHAR(8000)   
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'   
               + CONVERT(VARCHAR(4000), Error_message())   
               + '*****'   
               + Isnull(CONVERT(VARCHAR, Error_procedure()),   
               'ssp_ValidateDocumentAudit')   
               + '*****' + CONVERT(VARCHAR, Error_line())   
               + '*****ERROR_SEVERITY='   
               + CONVERT(VARCHAR, Error_severity())   
               + '*****ERROR_STATE='   
               + CONVERT(VARCHAR, Error_state())   
  
  RAISERROR (@Error /* Message text*/,16 /*Severity*/,1 /*State*/)   
END catch   
  
  