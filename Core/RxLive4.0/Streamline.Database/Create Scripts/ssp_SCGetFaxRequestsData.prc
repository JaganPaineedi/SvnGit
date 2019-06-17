CREATE procedure [dbo].[ssp_SCGetFaxRequestsData]              
       
             
as                      
/*********************************************************************/                              
   
/* Stored Procedure: dbo.ssp_SCGetFaxRequestsData                */                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                              
   
/* Creation Date:    08/Feb/08                                         */                            
    
/*                                                                   */                              
   
/* Purpose:  To retrieve FaxRequestsDetails   */                              
/*                                                                   */                            
/* Input Parameters: none         */                            
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
    
/*  08/Feb/08    Sonia    Created                                    */                              
   
/*********************************************************************/                         
begin                      
               
          
select * from ClientMedicationScriptActivities CM        
where  ISNULL(CM.RecordDeleted,'N')='N'  
and CM.FaxStatus='QUEUED'  
                  
IF (@@error!=0)                              
    BEGIN                              
        RAISERROR  20002 'ssp_SCGetFaxRequestsData : An error  occured'                            
     
                                 
        RETURN(1)                              
                                   
    END                                   
                            
end   