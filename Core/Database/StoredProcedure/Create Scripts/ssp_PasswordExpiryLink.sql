IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_PasswordExpiryLink')
BEGIN
	DROP  PROCEDURE ssp_PasswordExpiryLink 
END

GO
CREATE PROCEDURE  [dbo].ssp_PasswordExpiryLink 
(               
@GUID varchar(250)
                  
)                                                                            
AS  
 /*   Date				Author                  Purpose	 		      */ 
 /*-------------------------------------------------------------------*/
 /*   Vandana	   07-08-2017 	   Engineering Improvement-#311     										*/        
 /*********************************************************************/
 
 BEGIN                          
	BEGIN TRY 

	SELECT EmailTime,TokenExpire  from CustomerEmailLinkExpiry where  GUIId=@GUID and ISNULL(RecordDeleted,'N')='N'
	SELECT top 1 EmailExpiryPeriod  from CustomerForgotUsernameMailCredentials where  ISNULL(RecordDeleted,'N')='N' order by createddate  desc
	
	 
                
	END TRY                                                                      
	BEGIN CATCH                          
		DECLARE @Error VARCHAR(8000)                                                                       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                 
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PasswordExpiryLink')                                                                                                     
					+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                      
					+ '*****' + CONVERT(VARCHAR,ERROR_STATE())                                                  
		RAISERROR                                                                                                     
		(                                                                       
			@Error,                                                                                                     
			16, -                                                                                                    
			1                                                                                                  
		);                                                                                                  
	END CATCH                                                 
END  