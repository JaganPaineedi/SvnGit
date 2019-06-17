CREATE procedure [dbo].[ssp_SCGetClientMedicationmonographtext]                                              
(                                              
  @druginteractionmonographid int                         
)                                              
as               
Begin Try                                         
/*********************************************************************/                                                      
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationmonographtext]                */                                                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                      
/* Creation Date:    6/Dec/07                                      */                                                     
/*                                                                   */                                                      
/* Purpose:  To retrieve monographtext from MDDrugDrugInteractionMonographText */                                                      
/*                                                                   */                                                    
/* Input Parameters: none        @druginteractionmonographid */                                                    
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
/*  6/Dec/07    Rishu    Created                                    */                                                      
/*********************************************************************/                                                     
        
select monographtext,LineIdentifier from MDDrugDrugInteractionMonographText where druginteractionmonographid=@druginteractionmonographid order by textsequencenumber      
        
          
end try          
          
BEGIN CATCH                  
 declare @Error varchar(8000)                  
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                   
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientMedicationmonographtext')                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                    
    + '*****' + Convert(varchar,ERROR_STATE())                  
                    
 RAISERROR                   
 (                  
  @Error, -- Message text.               
  16, -- Severity.                  
  1 -- State.                  
 );         
                  
END CATCH   