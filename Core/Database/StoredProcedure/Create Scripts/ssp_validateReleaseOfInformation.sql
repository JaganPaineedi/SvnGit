IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_validateReleaseOfInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_validateReleaseOfInformation]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_validateReleaseOfInformation]  
 @DocumentVersionId int    
AS  
   
/**************************************************************  

Description  : Used to Validate 
Called From  : 
/*  Date			  Author				  Description */
/* 22/Nov/2017        Ponnin		          Created	(Ref: Task#2013 Spring River - Customizations) */ 
**************************************************************/
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
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 1648, @DocumentType, @Variables 
      

   
if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
--raiserror 50000 'ssp_validateReleaseOfInformation failed.  Please contact your system administrator. We apologize for the inconvenience.'  
RAISERROR ('ssp_validateReleaseOfInformation failed.  Please contact your system administrator. We apologize for the inconvenience.',16,1)
GO


