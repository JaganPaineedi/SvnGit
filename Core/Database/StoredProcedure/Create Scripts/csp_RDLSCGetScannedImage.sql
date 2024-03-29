IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetScannedImage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSCGetScannedImage]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[csp_RDLSCGetScannedImage]    
@ImageRecordItemId int             
as              

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
/* 28/02/2009               Vikas Vyas              Created                                    
   11/14/2018    jcarlson	  Fixed RAISERROR syntax	*/                        
/*********************************************************************/                         
Begin                      

    select ItemImage from ImageRecordItems        
    where ImageRecordItemId=  @ImageRecordItemId   and Isnull(RecordDeleted,'N')<>'Y'   
          
	IF (@@error!=0)                          
	 BEGIN                          
			RAISERROR  ('[csp_RDLSCGetScannedImage]  : An Error Occured',16,1)
			RETURN                          
	 END               
              
End
