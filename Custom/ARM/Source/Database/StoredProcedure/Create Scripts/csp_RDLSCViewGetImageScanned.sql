/****** Object:  StoredProcedure [dbo].[csp_RDLSCViewGetImageScanned]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCViewGetImageScanned]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSCViewGetImageScanned]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCViewGetImageScanned]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE  [dbo].[csp_RDLSCViewGetImageScanned]   
@ImageRecordItemId int             
As              
              
        
Begin                      
/*********************************************************************/                        
/* Stored Procedure: [csp_RDLSCGetScannedImage]      */              
                                                      
              
/* Copyright: 2007 Streamlin Healthcare Solutions           */                        
              
/* Creation Date:  18/09/2010                                   */                        
/*                                                                   */                        
/* Purpose: */                       
/*                                                                   */                      
/* Input Parameters: */                      
/*                                                                   */                         
/* Output Parameters:                                */                        
/*                                                                   */                        
/* Return:   */                        
/*                                                                   */                        
/* Called By: */                        
              
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                        
              
/*       Date              Author                          Purpose                                    */                        
/* 18/09/2010              Ashwani Kumar Angrish            Created                                    */                        
/*********************************************************************/                         
          
    select ItemImage from ImageRecordItems        
    where ImageRecordItemId=  @ImageRecordItemId   and Isnull(RecordDeleted,''N'')<>''Y''   
          

          
          
IF (@@error!=0)                          
 BEGIN                          
        RAISERROR  2001  ''[csp_RDLSCViewGetImageScanned]  : An Error Occured''                          
        RETURN                          
 END               
              
          
           
                
End
' 
END
GO
