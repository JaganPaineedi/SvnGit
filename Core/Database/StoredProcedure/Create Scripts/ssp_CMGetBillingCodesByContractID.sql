IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_CMGetBillingCodesByContractID]') 
                  AND type IN ( N'P', N'PC' )) 
DROP PROCEDURE [dbo].[ssp_CMGetBillingCodesByContractID] 
GO

/* Copyright: 2005 Provider Claim Management System             */                    
/* Creation Date:  June 01/2016                                */                    
/*                                                                   */                    
/* Purpose: it will get Billing Codes associate to Contractid             */                   
/*                                                                   */                  
/* Input Parameters: @ContractId          */                  
/*                                                                   */                    
/* Output Parameters:                                */                    
/*                                                                   */                    
/* Return:Billing Codes based on the applied filer  */                    
/*                                                                   */                    
/* Called By:                                                        */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/* Date            Author      Purpose                                */                    
/* June  01/2014   Satheesh.S   #864                                */         
/*********************************************************************/         
CREATE  PROCEDURE [dbo].[ssp_CMGetBillingCodesByContractID]       
  ( @ContractID int) 
AS  
BEGIN TRY

Select distinct BC.BillingcodeId, BC.BillingCode
FROM Contracts C 
 Join ContractRates CR on CR.ContractId = C.ContractId
 Join BillingCodes BC on BC.BillingcodeId = CR.BillingcodeId
WHERE C.ContractId = @ContractId 
and BC.Active='Y' 
AND ISNULL(BC.RecordDeleted, 'N') = 'N'
AND ISNULL(C.RecordDeleted, 'N') = 'N'
AND ISNULL(CR.RecordDeleted, 'N') = 'N'

END TRY
Begin Catch                  
                 
declare @Error varchar(8000)                      
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CMGetBillingCodesByContractID')                       
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                        
  + '*****' + Convert(varchar,ERROR_STATE())                      
                        
 RAISERROR                       
 (                      
  @Error, -- Message text.                      
  16, -- Severity.                      
  1 -- State.                      
 )                                    
                
End Catch 