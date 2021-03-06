/****** Object:  StoredProcedure [dbo].[csp_RDLSCGetScannedImage]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetScannedImage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSCGetScannedImage]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetScannedImage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE  [dbo].[csp_RDLSCGetScannedImage]    
@ImageRecordItemId int             
As              
              
        
Begin                      
/*********************************************************************/                        
/* Stored Procedure: [csp_RDLSCGetScannedImage]      */              
                                                      
              
/* Copyright: 2007 Streamlin Healthcare Solutions           */                        
              
/* Creation Date:  28/02/2009                                   */                        
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
              
/*       Date              Author                  Purpose                                    */                        
/* 28/02/2009               Vikas Vyas              Created                                    */                        
/*********************************************************************/                         
          
    select ItemImage from ImageRecordItems        
    where ImageRecordItemId=  @ImageRecordItemId   and Isnull(RecordDeleted,''N'')<>''Y''   
          

          
          
IF (@@error!=0)                          
 BEGIN                          
        RAISERROR  2001  ''[ssp_ScGetImageScanned]  : An Error Occured''                          
        RETURN                          
 END               
              
          
           
                
End
' 
END
GO
