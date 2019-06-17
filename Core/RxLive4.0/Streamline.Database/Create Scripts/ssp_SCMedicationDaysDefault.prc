CREATE  PROCEDURE [dbo].[ssp_SCMedicationDaysDefault]        
@staffid int    
AS        
/*********************************************************************/          
/* Stored Procedure: dbo.[ssp_SCMedicationDaysDefault]                */          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */          
/* Creation Date:    21/Aug/07                                         */         
/*                                                                   */          
/* Purpose:  Populate the list of MedicationDaysDefault    */          
/*                                                                   */        
/* Input Parameters: none        @staffid */        
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
    SELECT  StaffId, MedicationDaysDefault FROM staff where staffid=@staffid    
        
     IF (@@error!=0)          
    BEGIN          
        RAISERROR  20002 'ssp_SCMedicationDaysDefault : An error  occured'          
             
        RETURN(1)          
               
    END               
        
END        
        
        
        
         