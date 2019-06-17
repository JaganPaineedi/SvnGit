CREATE procedure [dbo].[ssp_SCGetMedicationOrderDetails]            
(                
 @ClientMedicationId int  =0                
)                
as                
/*********************************************************************/                        
/* Stored Procedure: dbo.ssp_SCGetMedicationOrderDetails                */                        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                        
/* Creation Date:    12/Sep/07                                         */                       
/*                                                                   */                        
/* Purpose:  To retrieve ClientMedicationOrderDetails   */                        
/*                                                                   */                      
/* Input Parameters: none        @ClientMedicationId */                      
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
/*  12/Sep/07    Balvinder    Created                                    */                        
/*********************************************************************/                   
begin                
         
select * from clientmedications where clientmedicationid=@ClientMedicationId and ISNULL(RecordDeleted,'N')='N'  
  
      
select * from clientmedicationinstructions CMI inner Join ClientMedications CM on CMI.clientmedicationid=CM.clientmedicationid  
 where  CM.clientmedicationid=@ClientMedicationId and ISNULL(CM.RecordDeleted,'N')='N'  
            
            
                     
            
            
IF (@@error!=0)                        
    BEGIN                        
        RAISERROR  20002 'ssp_SCGetMedicationOrderDetails : An error  occured'                        
                           
        RETURN(1)                        
                             
    END                             
                      
end  