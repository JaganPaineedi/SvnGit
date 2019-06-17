if object_id('dbo.SSP_ValidateDocumentLOCUS') IS NOT NULL 
  DROP PROCEDURE dbo.SSP_ValidateDocumentLOCUS
GO  
/******************************************************************************                                   
**  File: SSP_ValidateDocumentLOCUS                                            
**  Name: SSP_ValidateDocumentLOCUS                        
**  Desc: Validate Locus Document
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Shruthi.S                              
**  Date:  May 3rd 2016
/* What :  Implemented changes.				*/
/* whay : Task #41 Network 180 - Customizations                              */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                    
*******************************************************************************/  
CREATE PROCEDURE [dbo].[SSP_ValidateDocumentLOCUS]    
 @DocumentVersionId int      
AS    
     
-- Declare Variables    
DECLARE @DocumentType varchar(10)    
    
-- Get ClientId    
DECLARE @ClientId int    
    
    
SELECT @ClientId = d.ClientId    
FROM Documents d    
WHERE d.InProgressDocumentVersionId = @DocumentVersionId    
    
    
    
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
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 1638, @DocumentType, @Variables   
  
--INSERT INTO #validationReturnTable (TableName,ColumnName,ErrorMessage,TabOrder,ValidationOrder)  
--EXEC [csp_ValidateProgressNoteProblemsSection]   @DocumentVersionId  
     
if @@error <> 0 goto error      
End      
     
if @@error <> 0 goto error      
      
return     
    
error:      
raiserror 50000 'SSP_ValidateDocumentLOCUS failed.  Please contact your system administrator. We apologize for the inconvenience.'    