  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCClaimDenialGetBillingCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCClaimDenialGetBillingCodes]
GO
CREATE  PROCEDURE  [dbo].[ssp_SCClaimDenialGetBillingCodes]  
As  
          
Begin          
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCClaimDenialGetBillingCodes                */   
  
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
  
/*       Date                 Author                      Purpose                                    */            
/*     22/07/2015             Shruthi.S                   Created                                    */            
/*********************************************************************/             
        
  
    
  Select BillingCodeId,BillingCode from BillingCodes where  isnull(RecordDeleted,'N')='N' and Active='Y' 
  
  
  --Checking For Errors  
  If (@@error!=0)  
  Begin  
   RAISERROR  20006   'ssp_SCClaimDenialGetBillingCodes: An Error Occured'   
   Return  
   End           
          
  
End  