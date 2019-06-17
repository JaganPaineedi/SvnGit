SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ValidateCustomDocumentCANS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ValidateCustomDocumentCANS]
GO


CREATE PROCEDURE [dbo].[csp_ValidateCustomDocumentCANS]  --2353   
  @DocumentVersionId Int            
as            
/**********************************************************************/                                                                                            
 /* Stored Procedure:csp_ValidateCustomDocumentCANS   */                                                                                   
 /* Creation Date: 06/06/2013                                          */                                                                                            
  /* Author: Md Hussain Khusro  */                
/* Purpose:To validate 'CANS' document    */  
/* Input Parameters:  @DocumentVersionId      */             
/* Output Parameters:               */ 
      
/* Updates:                                                          */    
/*   Date		  Author				Purpose                                    */    
 /* 20-Nov-2013  Md Hussain Khusro  Added 13 New Validation for Life Domain Section wrt task #120 Philhaven Development*/ 
 /*	25/Nov/2013	 Md Hussain Khusro	Added 3 New Columns and removed 6 existing columns wrt task #120 Philhaven Developement	*/
 /* 12/17/2013   Nimesh Jain        Updated the SP to use Document Validations table*/

/*********************************************************************/ 
 /*********************************************************************/                                                           
            
           
          
-- Set Variables sql text  
DECLARE @Variables varchar(max)    
SET @Variables = 'DECLARE @DocumentVersionId int SET @DocumentVersionId = ' + convert(varchar(20), @DocumentVersionId) 


-- Exec csp_validateDocumentsTableSelect to determine validation list    
If Not Exists (Select * From CustomDocumentValidationExceptions where DocumentVersionId = @DocumentVersionId and DocumentValidationId is null)    
Begin    
Exec csp_validateDocumentsTableSelect @DocumentVersionId, 12500, '10', @Variables    

if @@error <> 0 goto error    
End    
   
if @@error <> 0 goto error    
    
return   
  
error:    
raiserror 50000 'csp_ValidateCustomDocumentCANS failed.  Please contact your system administrator. We apologize for the inconvenience.'  
GO

