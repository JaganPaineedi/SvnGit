CREATE  PROCEDURE  [dbo].[ssp_SCSetLastVisitInStaff]      
      
(      
 @varUserName varchar(50)      
)      
      
As      
              
Begin              
/*********************************************************************/                
/* Stored Procedure: dbo.[ssp_SCSetLastVisitInStaff]                */       
      
/* Copyright: 2005 Smart Care Management System             */                
      
/* Creation Date:  June 22,2009                                    */                
/*                                                                   */                
/* Purpose: Updates Staff Table by seting LastVisit */               
/*                                                                   */              
/* Input Parameters: @varUserName */              
/*                                                                   */                 
/* Output Parameters:                                */                
/*                                                                   */                
/* Return:   */                
/*                                                                   */                
     
        
      
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/*   Updates:                                                          */                
      
/*       Date              Author                  Purpose                                    */                
/*  June 22,2009   Sahil Bhagat           Created                                    */                
/*********************************************************************/                 
            
  Update Staff SET LastVisit = getdate() WHERE UserCode = rtrim(ltrim(@varUserName))and Active='Y' and isNull(RecordDeleted,'N')='N'              
      
  --Checking For Errors      
  If (@@error!=0)      
  Begin      
   RAISERROR  20006   'ssp_SCSetLastVisitInStaff: An Error Occured'       
   Return      
   End               
              
      
End  