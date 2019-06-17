IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateDocumentRegistrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ValidateDocumentRegistrations]
GO

CREATE PROCEDURE [dbo].[ssp_ValidateDocumentRegistrations]  
	@DocumentVersionId INT    
AS
/*********************************************************************/                                                                                        
 /* Stored Procedure: [ssp_ValidateDocumentRegistrations]               */                                                                               
 /* Data Modifications:												*/                                                                                        
 /*   Updates:														*/                                                                                        
 /*	  Date				Author			Purpose    */    
 /*  -------------------------------------------------------------- */    
/* Data Modifications:                */ 
/* Updates:                   */ 
/*  Date           Author             Purpose            */ 
/* 12/Jan/2018    Alok Kumar          Created. Ref: Task#618 Engineering Improvement Initiatives- NBL(I)  */ 
  /************************************************************************************/ 
  BEGIN 
      BEGIN try 
      
	DECLARE @DocumentCodeId INT
	DECLARE @DocumentCode VARCHAR(100)

	SET @DocumentCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
	SET @DocumentCodeId = (SELECT Top 1 DocumentCodeId FROM DocumentCodes WHERE Code = @DocumentCode)
	      
	  
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
	
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateDocumentsTableSelect]') AND type in (N'P', N'PC')) 
		Begin
		
			Exec csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables 
			
		End
	End
	      


  END try 

BEGIN CATCH                                            
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ValidateDocumentRegistrations')                                                                                                                       
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