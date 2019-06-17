CREATE PROCEDURE [dbo].[ssp_SCDiscontinueMedication]                                             
(                                              
 @ClientMedicationId as int,          
 @Discontinue as char(1),                                              
 @ModifiedBy as varchar(100),        
 @DiscontinueReason as varchar(1000)                                            
)                                              
AS                                              
/*********************************************************************/                                                
/* Stored Procedure: [dbo].[ssp_SCDiscontinueMedication]                */                                                
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                
/* Creation Date:    6/23/06                                         */                                                
/*                                                                   */                                                
/* Purpose:   This procedure is used to Discontinue the Medication for the passed MedicationId  */                                              
/*                                                                   */                                              
/* Input Parameters: @ClientMedicationId,@ModifiedBy              */                                              
/*                                                                   */                                                
/* Output Parameters:        */                                                
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
/*  Date     Author               Purpose                                    */                                                
                             
/* 15/11/07  Sonia Dhamija        Created     */                                    
/*********************************************************************/                                                 
               
                                            
                                             
BEGIN TRAN                                                
                                
Begin                                            
                                           
Update ClientMedications set Discontinued=@Discontinue,DiscontinueDate=getdate(),ModifiedDate=getdate(),ModifiedBy=@ModifiedBy,           
DiscontinuedReason=@DiscontinueReason        
where ClientMedicationId=@ClientMedicationId        
    
    
    
    
                                       
End                                     
                                
                                            
COMMIT TRAN                       
Return  (0)                   
                                             
error:                                          
 rollback tran                                                
 RAISERROR('Unable To Discontinue Medication in ssp_SCDiscontinueMedication.Contact tech support.', 16, 1)  