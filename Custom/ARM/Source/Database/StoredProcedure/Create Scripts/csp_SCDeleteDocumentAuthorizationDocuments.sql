/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentAuthorizationDocuments]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentAuthorizationDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentAuthorizationDocuments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentAuthorizationDocuments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCDeleteDocumentAuthorizationDocuments]    
(                                                                                                    
 @DocumentVersionId as int,                                                                                                    
 @DeletedBy as varchar(100)                                                                                                  
)                                                                                                    
AS                                                                                                    
/*********************************************************************/                                                                                                      
/* Stored Procedure: dbo.[csp_SCDeleteDocumentAuthorizationDocuments]*/                                                                                                      
/* Creation Date:    07/12/2009                                      */                                                                                                      
/*                                                                   */                                                                                                      
/* Purpose:   This procedure is used to Delete the Treatment Plan     
Addendum HRM documents for the passed DocumentVersionId and DeletedBy */                                                                                                    
/*                                                                   */                                                                                                    
/* Input Parameters: @DocumentVersionId,@DeletedBy                   */                                                                                                    
/*                                                                   */                                                                                                      
/* Output Parameters:        */                                                                                                      
/*                                                                   */                                                                                                      
/* Return:  0=success, otherwise an error number                     */                                                                                                      
/*                                                                   */                                                                                                      
/* Called By:                                                        */                                                                                                      
/*                                                                   */                                                                                                      
/* Calls:                                                            */                                                                                                      
/*                                                                   */                                                                                                      
/* Data Modifications:                                               */                                                                                                      
/*                                                                   */                                                                                                      
/* Updates:                                                          */         
/*  Date         Author               Purpose                             */                                                               /*  12/12/2009   Vikas Vyas           Use for dummy purpose as when we delete document as per custom procedure it wi
ll take a  
     list from tablelist and delete row from associated table but in case we don''t want to delete then we need to prepare dummy procedure(Need to discuss)*/                                                                   
/*********************************************************************/                                                                                                       
                                                            
Begin                                                
  print ''A''                        
END
' 
END
GO
