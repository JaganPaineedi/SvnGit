
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientNamefromClientId]' 
                              ) 
                  AND type in ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetClientNamefromClientId] 

GO 

CREATE PROCEDURE [dbo].[ssp_SCGetClientNamefromClientId]                      
 @ClientId int              
AS              
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientNamefromClientId]    Script Date: 05/04/2015  ******/
/* Creation By:    Suneel Nadavati    */    
/* Purpose: To Get Client Names of Client Type "Individual". */    
/* Input Parameters: @ClientId     */    
/* Output Parameters:            */    
    /*  Date                Author               Purpose   */    
    /*  05April2016         Suneel N      Created      */    
	/*											 What : To Get Client Names of Client Type "Individual".*/
	/*											 Why : Network 180 - Customizations task #608.6 */
	/* 14/02/2018            Sunil.D      Modified      */    
	/*											 What : Reverted changes addaed by suneel.N as part this task Network 180 - Customizations task #608.6 */
	/*											 Why : Spring River-Support Go Live #30 */
/***********************************************************************************************************/      
BEGIN           
   BEGIN try        
 select LastName+','+FirstName as ClientName,Active from Clients where ClientId=@ClientId  and ISNULL(RecordDeleted,'N')='N'           
 
                                
                                
          
          end try                
    begin catch                                                                                           
        declare @Error varchar(8000)                                                               
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'  
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
                     'ssp_SCGetClientNamefromClientId') + '*****'  
            + CONVERT(varchar, ERROR_LINE()) + '*****'  
            + CONVERT(varchar, ERROR_SEVERITY()) + '*****'  
            + CONVERT(varchar, ERROR_STATE())                                                                                            
        raiserror                                                                                             
  (                                                               
   @Error, -- Message text.                                                                                            
   16, -- Severity.                                                                                            
   1 -- State.                                                                                            
  ) ;                                                                                            
    end catch                  
end   


