IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentInvoluntaryServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentInvoluntaryServices]
GO

CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentInvoluntaryServices]  
	@DocumentVersionId INT    
AS
/*********************************************************************/                                                                                        
 /* Stored Procedure: [csp_ValidateCustomDocumentInvoluntaryServices]               */                                                                               
 /* Data Modifications:												*/                                                                                        
 /* Updates:														*/       
 /*	Purpose : New Directions - Customizations: Task#36 Involuntary Services */ 
                                                                                
 /*	  Date				Author			Purpose    */    
 /*  -------------------------------------------------------------- */    
 /*   05 May 2015		Malathi Shiva		Validate SP	 */  
 /*********************************************************************/       

-- Declare Variables  
DECLARE @DocumentType varchar(10)  
  
-- Set ClientId  
DECLARE @ClientId int  
SELECT @ClientId = d.ClientId  
FROM Documents d  
WHERE d.CurrentDocumentVersionId = @DocumentVersionId  
  
-- Set StaffId  
DECLARE @StaffId int  
SELECT @StaffId = d.AuthorId  
FROM Documents d  
WHERE d.CurrentDocumentVersionId = @DocumentVersionId  
  
-- Set EffectiveDate  
DECLARE @EffectiveDate datetime  
SET @EffectiveDate = CONVERT(datetime, convert(varchar, getdate(), 101))  
  
-- Set DocumentId  
DECLARE @DocumentId int  
SELECT @DocumentId = DocumentId   
FROM Documents   
WHERE CurrentDocumentVersionId = @DocumentVersionId  
  
  
 
---- Only run validation if UnableToCompleteAssessment is not checked  

  
	-- Set Variables sql text  
	DECLARE @Variables VARCHAR(MAX)    
	SET @Variables = 'DECLARE @DocumentVersionId int  
	SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +  
	--'DECLARE @DocumentType varchar(10)  
	-- SET @DocumentType = ' +''''+ @DocumentType+'''' +  
	' DECLARE @ClientId int  
	SET @ClientId = ' + convert(varchar(20), @ClientId) +  
	'DECLARE @EffectiveDate datetime  
	SET @EffectiveDate = ''' + CONVERT(varchar(20), @EffectiveDate, 101) + '''' +  
	'DECLARE @StaffId int  
	SET @StaffId = ' + CONVERT(varchar(20), @StaffId) +  
	'DECLARE @DocumentId int  
	SET @DocumentId = ' + CONVERT(varchar(20), @DocumentId)  
  
	-- Exec csp_validateDocumentsTableSelect to determine validation list    
	IF NOT EXISTS (SELECT * FROM CustomDocumentValidationExceptions WHERE DocumentVersionId = @DocumentVersionId AND DocumentValidationid IS NULL)    
	BEGIN    
		EXEC csp_validateDocumentsTableSelect @DocumentVersionId, 28812, @DocumentType, @Variables  
	
		-------------Remove from #validationReturnTable based on program selection ------
		
		
		
		IF @@error <> 0 GOTO ERROR    
	END


IF @@error <> 0 GOTO error
RETURN
ERROR:    
RAISERROR 50000 'csp_ValidateCustomDocumentRegistration failed.  Please contact your system administrator. We apologize for the inconvenience.'  
GO