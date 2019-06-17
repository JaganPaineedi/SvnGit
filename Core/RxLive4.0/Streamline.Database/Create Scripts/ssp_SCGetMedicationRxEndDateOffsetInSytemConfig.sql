Create PROCEDURE  [dbo].[ssp_SCGetMedicationRxEndDateOffsetInSytemConfig]  
 
  
As  
          
Begin          
/*********************************************************************/            
/* Stored Procedure: dbo.ssp_SCGetMedicationRxEndDateOffsetInSytemConfig                */   
  
/* Copyright: 2005 Provider Claim Management System             */            
  
/* Creation Date:  12/10/2009                                 */            
/*                                                                   */            
/* Purpose: Get MedicationRxEndDateOffset from System Configuration Table*/           
/*                                                                   */          
/* Input Parameters:  */          
/*                                                                   */             
/* Output Parameters:                                */            
/*                                                                   */            
/* Return:   */            
/*                                                                   */            
/* Called By:   */  
/*      */  
  
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/*                                                                   */            
/*   Updates:                                                          */            
  
/*   Date              Author                  Purpose                                    */            
/*  12/10/2009		   Loveena           Created                                    */            
/*********************************************************************/             
        
  Select  ISNULL(MedicationRxEndDateOffset,0) as 'MedicationRxEndDateOffset' from SystemConfigurations 
  
  --Checking For Errors  
  If (@@error!=0)  
  Begin  
   RAISERROR  20006   'ssp_SCGetMedicationRxEndDateOffsetInSytemConfig: An Error Occured'   
   Return  
   End           
          
  
End  
  
  
  
  
  
  