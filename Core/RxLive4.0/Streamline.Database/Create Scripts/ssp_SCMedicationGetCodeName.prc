  
  
CREATE  PROCEDURE [dbo].[ssp_SCMedicationGetCodeName]                
  @globalcodeid  as int       
AS                
/*********************************************************************/                  
/* Stored Procedure: dbo.[ssp_SCMedicationGetCodeName]                */                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date:    21/Aug/07                                         */                 
/*                                                                   */                  
/* Purpose:  Populate Strength combobox   */                  
/*                                                                   */                
/* Input Parameters: none       */                
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
/*   Date     Author       Purpose                                    */                  
/*  21/Aug/07   Rishu    Created                                    */                  
/*********************************************************************/                     
BEGIN        
   select globalcodeid,codename from globalcodes where globalcodeid=@globalcodeid  
       
                
     IF (@@error!=0)                  
    BEGIN                  
        RAISERROR  20002 'ssp_SCMedicationGetCodeName : An error  occured'                  
                     
        RETURN(1)                  
                       
    END                       
                
END                 