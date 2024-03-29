IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSCGetImageRecordData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSCGetImageRecordData]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[csp_RDLSCGetImageRecordData]         
	@ImageRecordId int          
As            
            
/*********************************************************************/                      
/* Stored Procedure: dbo.csp_RDLSCGetImageRecordData      */            
                                                    
            
/* Copyright: 2007 Streamlin Healthcare Solutions           */                      
            
/* Creation Date:  24/12/2008                                   */                      
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
/* 24/12/2008              Vikas Vyas              Created                                    
   11/14/2018    jcarlson	  Fixed RAISERROR syntax	*/                      
/*********************************************************************/                       
      
Begin                    
        
    select ImageRecordItemId from ImageRecordItems      
    where ImageRecordId=  @ImageRecordId and Isnull(RecordDeleted,'N')<>'Y'      
    order by ItemNumber Asc   
     
	IF (@@error!=0)                        
	 BEGIN                        
			RAISERROR  (  'csp_RDLSCGetImageRecordData  : An Error Occured',16,1)
			RETURN                        
	 END             
            
End
