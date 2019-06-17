CREATE PROCEDURE [dbo].[ssp_SCUpdateMedicationOrderStatus]                                             
(                                              
 @MedicationidsToBeChanged as varchar(1000),          
 @MedicationidsToBeReorderd as varchar(1000),                                               
 @ModifiedBy as varchar(100)        
                                             
)                                              
AS                                              
/*********************************************************************/                                                
/* Stored Procedure: [dbo].[ssp_SCDiscontinueMedication]                */                                                
/* Copyright: 2006 Streamline Healthcare Solutions,  LLC             */                                                
/* Creation Date:    03/18/08                                         */                                                
/*                                                                   */                                                
/* Purpose:   This procedure is used to Update the Medication Order Status as C or R for the passed MedicationIds  */                                              
/*                                                                   */                                              
/* Input Parameters: @MedicationidsToBeChanged,@MedicationidsToBeReorderd,@ModifiedBy              */                                              
/*                                                                   */                                                
/* Output Parameters:        */                                                
/*                                                                   */                                                
/* Return:  0=success, otherwise an error number                     */                                                
/*                                                                   */                                                
/* Called By:Medication Management:ClientMedication.cs               */                                                
/*                                                                   */                                                
/* Calls:                                                            */                                                
/*                                                                   */                                                
/* Data Modifications:                                               */                                                
/*                                                                   */                                                
/* Updates:                                                          */                                                
/*  Date     Author               Purpose                                    */                                                
                             
/* 03/18/08  Sonia Dhamija        Created     */                                    
/*********************************************************************/                                                 
               
                                            
                                             
BEGIN TRAN                                                
declare @Query varchar(8000)                                
Begin                                            
                                           
set @Query='Update ClientMedications set OrderStatus=''C'',  
OrderStatusDate=getdate(),  
ModifiedBy=@ModifiedBy           
where ClientMedicationId in ( ' + @MedicationidsToBeChanged + ')'       
  
execute sp_executesql @Query  
    
set @Query='Update ClientMedications set OrderStatus=''R'',  
OrderStatusDate=getdate(),  
ModifiedBy=@ModifiedBy           
where ClientMedicationId in ( ' + @MedicationidsToBeReorderd + ')'  
  
execute sp_executesql @Query  
    
    
                                       
End                                     
                                
                                            
COMMIT TRAN                       
Return  (0)                   
                                             
error:                                                
 rollback tran                                                
 RAISERROR('Unable To Change Order Status of Medications.Contact tech support.', 16, 1)  