
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_PopulateUserName')
BEGIN
	DROP  PROCEDURE ssp_PopulateUserName 
END

GO
CREATE PROCEDURE  [dbo].ssp_PopulateUserName 
(               

  @token    varchar(max)
                  
)                                                                            
AS  
 /*   Date				Author                  Purpose	 		      */ 
 /*-------------------------------------------------------------------*/
 /*   Vandana	   07-08-2017 	   Engineering Improvement-#311     										*/        
 /*********************************************************************/
 
 BEGIN                          
	BEGIN TRY
	SELECT s.usercode, ce.EmailTime , ce.TokenExpire FROM staff s 
	JOIN CustomerEmailLinkExpiry ce 
	on s.staffid=ce.staffid  where ce.GUIId=@token and ISNULL(s.RecordDeleted,'N')='N' and ISNULL(ce.RecordDeleted,'N')='N' and s.Active='Y'
	 
	SELECT top 1 EmailExpiryPeriod  from CustomerForgotUsernameMailCredentials where ISNULL(RecordDeleted,'N')='N' order by CreatedDate desc
	
	UPDATE CustomerEmailLinkExpiry SET TokenExpire='Y' where GUIId=@token
                
	END TRY                                                                      
	BEGIN CATCH                          
		DECLARE @Error VARCHAR(8000)                                                                       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                 
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PopulateUserName')                                                                                                     
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