
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientNamefromClientIdClaimBundles]' 
                              ) 
                  AND type in ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetClientNamefromClientIdClaimBundles] 

GO 

CREATE PROCEDURE [dbo].[ssp_SCGetClientNamefromClientIdClaimBundles]                      
 @ClientId int              
AS              
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientNamefromClientIdClaimBundles]    Script Date: 05/04/2015  ******/
/* Creation By:    Sunil Dasari   */    
/* Purpose:  */    
/* Input Parameters: @ClientId     */    
/* Output Parameters:            */    
    /*  Date                 Author               Purpose   */    
    /*  14/02/2018           Sunil.D              Created      */    
	/*											 What : Moved from 3.5 to 4.0 And changed Name Of the SSP because already another SSP Created with same Name(As part of task  Network 180 - Customizations task #608.6).*/
	/*											 Why : Spring River-Support Go Live #30*/
/***********************************************************************************************************/      
BEGIN           
    begin try                
       
                 
 select LastName+','+FirstName as ClientName,Active,ClientType from Clients where ClientId=@ClientId  and ISNULL(RecordDeleted,'N')='N' and ClientType='I'             

  
   
   end try                
    begin catch                                                                                           
        declare @Error varchar(8000)                                                               
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'  
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
                     'ssp_SCGetClientNamefromClientIdClaimBundles') + '*****'  
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


