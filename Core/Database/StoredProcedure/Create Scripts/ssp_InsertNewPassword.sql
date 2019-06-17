IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_InsertNewPassword')
BEGIN
	DROP  PROCEDURE ssp_InsertNewPassword -- 8924,3,null
END

GO
CREATE PROCEDURE  [dbo].ssp_InsertNewPassword --'5EEC7E52-B5C8-41C6-B313-3BF0F23D661B','94FK8UsggvQ='--,1--,'In what city did you meet your spouse/significant other?'         
(               
@GUID varchar(250) ,
 @NewPassword varchar(max)                         
)                                                                            
AS  
 /*   Date				Author                  Purpose	 		      */ 
 /*-------------------------------------------------------------------*/
 /*   Vandana	   07-08-2017 	   Engineering Improvement-#311     										*/        
 /*********************************************************************/
 
 BEGIN                          
	BEGIN TRY 

		Update staff set UserPassword=@NewPassword where staffid= (select staffid from CustomerEmailLinkExpiry where GUIId=@GUID)
		update CustomerEmailLinkExpiry set TokenExpire='Y' where GUIId=@GUID 
	
	            
	END TRY                                                                      
	BEGIN CATCH                          
		DECLARE @Error VARCHAR(8000)                                                                       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                 
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_InsertNewPassword')                                                                                                     
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