CREATE  PROCEDURE [dbo].[ssp_SCMedicationGlobalCodeUnit]        
  
AS        
/*********************************************************************/          
/* Stored Procedure: dbo.[ssp_SCMedicationGlobalCodeUnit]                */          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */          
/* Creation Date:    21/Aug/07                                         */         
/*                                                                   */          
/* Purpose:  To populate MedicationUnit   */          
/*                                                                   */        
/* Input Parameters: none        @RouteId */        
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
    select * from globalcodes where category='Medicationunit'  
        
     IF (@@error!=0)          
    BEGIN          
        RAISERROR  20002 'ssp_SCMedicationGlobalCodeUnit : An error  occured'          
             
        RETURN(1)          
               
    END               
        
END   