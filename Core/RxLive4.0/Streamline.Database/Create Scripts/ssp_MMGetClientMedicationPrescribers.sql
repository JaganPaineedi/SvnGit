Create  PROCEDURE [dbo].[ssp_MMGetClientMedicationPrescribers]      
  @ClientId  int                 
AS                            
/*********************************************************************/                              
/* Stored Procedure: dbo.[ssp_MMGetClientMedicationPrescribers]                */                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                              
/* Creation Date:    17/Dec/2008                                         */                             
/*                                                                   */                              
/* Purpose:  Populate Prescriber combobox   */                              
/*                                                                   */                            
/* Input Parameters: @ClientId       */                            
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
/*   Date		   Author       Purpose                                    */                              
/*   17-Dec-2008   Loveena      Created                                    */                              
/*********************************************************************/                                 
BEGIN                  
               
select distinct cm.PrescriberId, s.LastName + ', ' + s.FirstName + case when s.Degree is not null then ' ' + gc.CodeName else '' end
from ClientMedications as cm
join Staff as s on s.StaffId = cm.PrescriberId
left outer join GlobalCodes as gc on gc.GlobalCodeId = s.Degree
where cm.ClientId = @ClientId
and isnull(cm.RecordDeleted, 'N') <>'Y'
      
                   
                            
 IF (@@error!=0)                              
BEGIN                              
    RAISERROR  20002 'ssp_MMGetClientMedicationPrescribers : An error  occured'                              
                             
    RETURN(1)                              
                               
END                                   
                            
END 


 