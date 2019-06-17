
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLEmailConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLEmailConfiguration]
GO

/* Object:  StoredProcedure [dbo].[ssp_GetLEmailConfiguration]   Script Date: 09/Feb/2016 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO               
CREATE PROCEDURE [dbo].[ssp_GetLEmailConfiguration]  -- exec [ssp_GetLetterTemplatesDetail] @LetterTemplateId=30  
  
 @CustomerForgotUsernameMailCredentialId int  
 /********************************************************************************                                                    
-- Stored Procedure: dbo.ssp_GetLEmailConfiguration                                                   
--                                                    
-- Copyright: Streamline Healthcate Solutions                                                    
--                                                    
-- Purpose: used by LetterTemplates Detail page      
-- Called by: ssp_GetLetterTemplatesDetail    
--                
**  Date:       Author:       Description:                                      
**  8/27/2017  Vandana Ojha   Engineering Improvement Initiatives- NBL(I)#311               
*********************************************************************************/    
AS  
Begin  
Begin Try  
  
  set  @CustomerForgotUsernameMailCredentialId= (select top 1 CustomerForgotUsernameMailCredentialId from CustomerForgotUsernameMailCredentials where ISNULL(RecordDeleted, 'N') <> 'Y' order by 1 desc)

SELECT  
		CustomerForgotUsernameMailCredentialId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		EmailId,
		Username,
		UserPassword,
		ServerDetails,
		PortDetails,
		TimeoutPeriod,
		EmailExpiryPeriod,
		ForgotUsernameSubject,
		ForgotPasswordSubject,
		ForgotUsernameBody,
		ForgotPasswordBody
FROM   CustomerForgotUsernameMailCredentials    
WHERE ISNULL(RecordDeleted, 'N') <> 'Y'    
AND CustomerForgotUsernameMailCredentialId = @CustomerForgotUsernameMailCredentialId    
END TRY   
  
BEGIN CATCH  
DECLARE @Error varchar(8000)                                                                              
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetLEmailConfiguration')                                                                                                               
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                
  + '*****' + Convert(varchar,ERROR_STATE())                                                            
  RAISERROR                                                                                                               
  (                                                                                 
  @Error, -- Message text.             
  16, -- Severity.             
  1 -- State.                                                               
  );          
END CATCH  
END