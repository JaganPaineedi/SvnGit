CREATE PROCEDURE [dbo].[SSP_SCUpdateFaxStatus]      
(    
 @varClientMedicationScriptActivityId int,    
 @varFaxStatus varchar(15),    
 @varFaxDetailedHistory text    
     
)    
    
AS      
      
/*********************************************************************/        
/* Stored Procedure: dbo.SSP_SCUpdateFaxStatus                */        
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */        
/* Creation Date:    02/10/08                                         */        
/*                                                                   */        
/* Purpose: It is used to change the Fax status, it @varType=1 then it update Fax Status as First    
Time otherwise Update through Scheduler      */       
/*                                                                   */      
/* Input Parameters: @varType                */      
/*                                                                   */        
/* Output Parameters:   None                               */        
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
/*  Date         Author          Purpose                             */        
/* 02/10/2008   Sonia Dhamija     Created                            */        
/*********************************************************************/         
BEGIN      
    BEGIN TRAN      
    
Begin      
 update ClientMedicationScriptActivities      
 set FaxStatusDate  =getdate(),    
 FaxStatus =@varFaxStatus,    
 FaxDetailedHistory=@varFaxDetailedHistory  
 where ClientMedicationScriptActivityId =@varClientMedicationScriptActivityId  and    
ISNULL(RecordDeleted,'N')='N'      
    
End      
    
    IF (@@error!=0)      
    BEGIN      
        RAISERROR  20002  '[SSP_SCUpdateFaxStatus]: An Error Occured While updating '      
        ROLLBACK TRAN      
        RETURN(1)      
    END      
    COMMIT TRAN      
    RETURN(0)      
END      
      
      
      
      
       