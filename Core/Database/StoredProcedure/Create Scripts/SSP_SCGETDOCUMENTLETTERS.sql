IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGETDOCUMENTLETTERS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGETDOCUMENTLETTERS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
         
CREATE PROCEDURE [DBO].[SSP_SCGETDOCUMENTLETTERS]     
 @DocumentVersionId INT      
as      

       
/************************************************************************/                                                                  
/* Stored Procedure: SSP_SCGETDOCUMENTLETTERS        */                                                         
/*        */                                                                  
/* Creation Date:             */                                                                  
/*                  */                                                                  
/* Purpose: Gets Data for SSP_SCGETDOCUMENTLETTERS       */                                                                 
/* Input Parameters: DocumentVersionId        */                                                                
/* Output Parameters:             */                                                                  
/* Purpose: Use For Rdl Report           */                                                        
/* Calls:                */                                                                  
/*                  */                                                                  
/* Author:             
History
12/04/2018		Moved from 3.5x Repository

 */          
                                                           
/*********************************************************************/  
      
SELECT       
 DocumentVersionId,      
 CreatedBy,      
 CreatedDate,      
 ModifiedBy,      
 ModifiedDate,      
 RecordDeleted,      
 DeletedDate,      
 DeletedBy,      
 TextData      
FROM TextDocuments      
WHERE DocumentVersionId = @DocumentVersionId 