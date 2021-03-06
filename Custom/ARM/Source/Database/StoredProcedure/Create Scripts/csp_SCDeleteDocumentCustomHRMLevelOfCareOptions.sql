/****** Object:  StoredProcedure [dbo].[csp_SCDeleteDocumentCustomHRMLevelOfCareOptions]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomHRMLevelOfCareOptions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteDocumentCustomHRMLevelOfCareOptions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteDocumentCustomHRMLevelOfCareOptions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCDeleteDocumentCustomHRMLevelOfCareOptions]    
(                                                                                                    
 @DocumentVersionId as int,                                                                                                    
 @DeletedBy as varchar(100)                                                                                                  
)                                                                                                    
AS                                                                                                    
/*********************************************************************/                                                                                                      
/* Stored Procedure: dbo.[csp_SCDeleteDocumentCustomHRMLevelOfCareOptions]*/   
/* Creation By:  Ashwani Kumar Angrish        */                                                                                                     
/* Creation Date:    15/02/2010                                    */                                                                                                      
/*                                                                   */                                                                                                      
/* Purpose:   This  is dummy procedure and used for architechture purpose because nothing is inserted into  
  CustomHRMLevelOfCareOptions   Table ,we only get data to display from this table in Service Lookup of Recommended  
  services tab in Periodic review.*/  
   
/*                                                                   */                                                                                                    
/* Input Parameters: @DocumentVersionId,@DeletedBy                   */                                                                                                    
/*                                                                   */                                                                                                      
/* Output Parameters:        */                                                                                                      
/*                                                                   */                                                                                                      
/* Return:                      */                                                                                                      
/*                                                                   */                                                                                                      
/* Called By:                                                        */                                                                                                      
/*                                                                   */                                                                                                      
/* Calls:                                                            */                                                                                                      
/*                                                                   */                                                                                                      
/* Data Modifications:                                               */                                                                                                      
/*                                                                   */                                                                                                      
/* Updates:                                                          */         
/*********************************************************************/                                                                  
                                                            
Begin                                                
  print ''A''                        
END
' 
END
GO
