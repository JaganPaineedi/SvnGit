
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CSP_SCGetAgencyNameDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CSP_SCGetAgencyNameDetails] 
GO


CREATE  PROCEDURE  [dbo].[CSP_SCGetAgencyNameDetails]  
  
As  
          
Begin  
BEGIN TRY        
/*********************************************************************/            
/* Stored Procedure: dbo.CSP_SCGetAgencyNameDetails                */   
  
/* Copyright: 2017Streamline Healthcare Solutions           */            
  
/* Creation Date:  3rd mar 2017                                   */            
/*                                                                   */            
/* Purpose: Gets Agency Name      */           
/*                                                                   */          
/* Input Parameters: None*/          
/*                                                                   */             
/* Output Parameters:                                */            
/*                                                                   */            
/* Return:   */            
/*                                                                   */            
/* Called By: GetAgencyName Method in Auhtorization Class Of DataService  in "SmartClient Application"    */            
  
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/*                                                                   */            
/*   Updates:                                                          */            
  
/*       Date        Author                  Purpose                                    */            
/*7 April 2017        Pabitra                Texas Customizations#58     */            
/*********************************************************************/             
        
  
  Select AgencyName,AbbreviatedAgencyName From Agency  
     
 
END TRY
  BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'CSP_SCGetAgencyNameDetails') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
    
  
End  
  
  
  
  