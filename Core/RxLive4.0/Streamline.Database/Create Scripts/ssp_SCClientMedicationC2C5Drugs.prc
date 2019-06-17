create procedure [dbo].[ssp_SCClientMedicationC2C5Drugs]                                  
(                                        
 @MedicationId int                                           
)                                        
as                                        
/*********************************************************************/                                                
/* Stored Procedure: dbo.[ssp_SCClientMedicationC2C5Drugs]                */                                                
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                
/* Creation Date:    9/Feb/08                                         */                                               
/*                                                                   */                                                
/* Purpose:  To retrieve Category of drug   */                                                
/*                                                                   */                                              
/* Input Parameters: none        @MedicationId */                                              
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
/*  9/Feb/08    Rishu    Created                                    */                                                
/*********************************************************************/        
    
    
select top 1 d.DEACode as Category   
from MDMedications as m    
join MDDrugs as d on d.ClinicalFormulationId = m.ClinicalFormulationId    
where m.MedicationId = @MedicationId    
and isnull(m.RecordDeleted, 'N') <>'Y'    
and isnull(d.RecordDeleted, 'N') <>'Y'    
                                
IF (@@error!=0)       
    BEGIN                                                
        RAISERROR  20002 'ssp_SCClientMedicationC2C5Drugs : An error  occured'                                                
                                                   
        RETURN(1)                                                
                                   
    END   