  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCClaimDenialGetAuthorizationNumbers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCClaimDenialGetAuthorizationNumbers]
GO
CREATE  PROCEDURE  [dbo].[ssp_SCClaimDenialGetAuthorizationNumbers]
 @ClientId int     
As  
    
Begin          
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCClaimDenialGetAuthorizationNumbers                */   
  
/* Copyright: 2006 Streamlin Healthcare Solutions           */            
  
/* Creation Date:  22/07/2015                                    */            
/*                                                                   */            
/* Purpose: Gets Billing Code From BillingCodes Table */           
/*                                                                   */          
/* Input Parameters: None*/          
/*                                                                   */             
/* Output Parameters:                                */            
/*                                                                   */            
/* Return:   */            
/*                                                                   */                 
  
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/*                                                                   */            
/*   Updates:                                                          */            
  
/*     Date                 Author                      Purpose                                    */            
/*     22/07/2015           Shruthi.S                   Created                                   
       13/01/2015           Shruthi.S                   Added null condition for Aut Number.Ref : #603.1 Network180 Env Issues.*/            
/*********************************************************************/             
        
  
    
  Select ProviderAuthorizationId,AuthorizationNumber from ProviderAuthorizations  where  isnull(RecordDeleted,'N')='N' and isnull(AuthorizationNumber,'') <> '' and Active='Y' and ClientId=@ClientId
  
  
  --Checking For Errors  
	IF (@@error != 0)
	BEGIN
		  RAISERROR ('ssp_SCClaimDenialGetAuthorizationNumbers: An Error Occured While Updating ',16,1);
	END
  
  
End  