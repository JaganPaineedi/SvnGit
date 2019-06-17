CREATE  PROCEDURE [dbo].[ssp_SCClientMedicationDrug]                  
@MedicationName varchar(30)=null            
AS                  
/*********************************************************************/                    
/* Stored Procedure: dbo.[ssp_SCClientMedicationDrug]                */                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                    
/* Creation Date:    20/Aug/07                                         */                   
/*                                                                   */                    
/* Purpose:  Populate the list of ClientMedicationDrug    */                    
/*                                                                   */                  
/* Input Parameters: @MedicationName         */                  
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
/*  20/Aug/07   Rishu    Created                                    */                    
/*********************************************************************/                       
Declare @SoundExSearchCriteria varchar(30)      
set @SoundExSearchCriteria=SoundEx(@MedicationName)      
BEGIN                 
  
Select MedicationName, MedicationNameId from MdMedicationNames Where        
(MedicationName Like (@MedicationName+'%') or MedicationNameSoundEx Like (@SoundExSearchCriteria+'%'))      
And IsNull(RecordDeleted,'N')<>'Y'Order By MedicationName        
            
          
     IF (@@error!=0)                    
    BEGIN                    
        RAISERROR  20002 'ssp_SCClientMedicationDrug : An error  occured'                    
                       
        RETURN(1)                    
                         
    END                         
                  
END   