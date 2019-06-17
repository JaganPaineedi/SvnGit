
/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentValidations]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomDocumentValidations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomDocumentValidations]
GO


/****** Object:  StoredProcedure [dbo].[csp_CustomDocumentValidations]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_CustomDocumentValidations]  
	@DocumentVersionId int    
AS 
	/****************************************************************/
	/* Name:		csp_CustomDocumentValidations					*/
	/* Createdby:	JJN												*/
	/* Createddate:	12/3/2012										*/
	/* Purpose:		Basic validation procedure for custom documents	*/
	/*																*/
	/* Modifications:												*/
	/* Author			Date		Purpose							*/
	/*																*/
	/****************************************************************/
 
BEGIN 

-- Declare Variables  
DECLARE @DocumentType varchar(10), @ClientId int, @DocumentCodeId int
  
-- Set ClientId  
SELECT @ClientId = d.ClientId, @DocumentCodeId = d.DocumentCodeId
FROM Documents d  
WHERE d.InProgressDocumentVersionId = @DocumentVersionId  

-- Set Variables sql text  
DECLARE @Variables varchar(max)    
SET @Variables = 'DECLARE @DocumentVersionId int, @ClientId int' + CHAR(13) + CHAR(10) + 
	'SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) +  CHAR(13) + CHAR(10) + 
     'SET @ClientId = ' + convert(varchar(20), @ClientId)

-- Exec csp_validateDocumentsTableSelect to determine validation list    
IF NOT EXISTS (SELECT * FROM CustomDocumentValidationExceptions WHERE DocumentVersionId = @DocumentVersionId AND DocumentValidationid IS NULL)    
BEGIN
	EXEC csp_validateDocumentsTableSelect @DocumentVersionId, @DocumentCodeId, @DocumentType, @Variables    
	
	if @@error <> 0 goto error    
END
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror 50000 'csp_CustomDocumentValidations failed.  Please contact your system administrator. We apologize for the inconvenience.'  

END

GO


