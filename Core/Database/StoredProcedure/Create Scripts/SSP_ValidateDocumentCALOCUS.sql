if object_id('dbo.SSP_ValidateDocumentCALOCUS') IS NOT NULL 
  DROP PROCEDURE dbo.SSP_ValidateDocumentCALOCUS
GO  
/******************************************************************************                                   
**  File: SSP_ValidateDocumentCALOCUS                                            
**  Name: SSP_ValidateDocumentCALOCUS                        
**  Desc: Validate LoCALOCUScus Document
**  Auth:  Kaushal Pandey                              
**  Date:  Nov 26 2018
/* What/Whay : created new copy of LOCUS TO CALOCUS for task#21 	MHP - Enhancements - CALOCUS                             */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:       Author:       Description:                                    
*******************************************************************************/  
CREATE PROCEDURE [dbo].[SSP_ValidateDocumentCALOCUS]    
 @DocumentVersionId int      
AS    
     
-- Declare Variables    
DECLARE @DocumentType varchar(10)    
    
-- Get ClientId    
DECLARE @ClientId int  

--GET DocumentCodeId
DECLARE @DocumentCodeId INT 
SELECT @DocumentCodeId = DocumentCodeId FROM DOCUMENTCODES WHERE CODE = 'FB823686-2E4B-4350-A8C0-8F4B47EC4712'
    
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
	Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables   
End

IF ( @@error != 0 ) 
        BEGIN 
            DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_ValidateDocumentCALOCUS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);

            RETURN( 1 ) 
        END 

      RETURN( 0 ) 

GO
