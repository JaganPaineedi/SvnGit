Create procedure [dbo].[ssp_MMGetPharmacies]  
                                                                                        
as                                                                                        
/*********************************************************************/                                                                                                
/* Stored Procedure: dbo.[ssp_MMGetPharmacies]                */                                                                                                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                                
/* Creation Date:    22/Dec/08                                         */                                                                                               
/*                                                                   */                                                                                                
/* Purpose:  To retrieve Pharmacies   */                                                                                                
/*                                                                   */                                                                                              
/* Input Parameters: none        */                                                                                              
/*                                                                   */                                                                                                
/* Output Parameters:   None                           */                                                                                                
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
/*   Date     Author       Purpose                                */                                                                                                
/*  22/Dec/08 Loveena    Created      */   
  
/*********************************************************************/                                                 
begin                                                                        
               
                          
select PharmacyId,PharmacyName from Pharmacies where isnull(RecordDeleted, 'N') <> 'Y' and Active = 'Y'  
                                                                                    
IF (@@error!=0)                                                                               
    BEGIN                                                                                                
        RAISERROR  20002 'ssp_MMGetPharmacies : An error  occured'                                                                                                
                                                                                                   
        RETURN(1)                                                                                                
                                                          
    END                                                                                                     
                                                                                              
end         
        
        
  
  
  
  
  
  
  
 