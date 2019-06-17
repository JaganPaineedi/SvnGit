IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_SCGetCoSignerListNotHavingRegistrationApprovalRole]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetCoSignerListNotHavingRegistrationApprovalRole] 

GO 
CREATE    PROCEDURE [dbo].[ssp_SCGetCoSignerListNotHavingRegistrationApprovalRole]  
 @DocumentCodeID int       
as        
/************************************************************************/     
                                            
/*       Date              Author                  Purpose              */                                                      
/*       23/05/2016        Shruthi.S               Get the Co-signer list for Registration document.Ref #671 Network180-Cust.
         07/09/2016        Shruhti.S               Added new functionality as per recent comments by Katie.Ref #671 Network180-Cust.*/                                                  
/************************************************************************/           
        
Begin     
 
 BEGIN TRY 
 
     exec ssp_SCGetStaffDetailsEHR       
  
 END TRY  
 BEGIN CATCH                                                                
                                         
  DECLARE @Error varchar(8000)                                                           
                                          
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                  
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCGetCoSignerListNotHavingRegistrationApprovalRole]')                                                                                                   
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                                  
  + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                  
                                          
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                                                          
                                                               
 END CATCH                    
    
End      
      

