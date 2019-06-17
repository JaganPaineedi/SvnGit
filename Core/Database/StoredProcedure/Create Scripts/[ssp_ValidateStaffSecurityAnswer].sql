IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ValidateStaffSecurityAnswer')
BEGIN
	DROP  PROCEDURE ssp_ValidateStaffSecurityAnswer
END

GO
CREATE PROCEDURE  [dbo].[ssp_ValidateStaffSecurityAnswer] 
(               
 @EmailID varchar(max),   
 @SecurityQues varchar(max),
 @SecurityAnsEnc varchar(20) ,
 @SecurityAns varchar(20)                             
)                                                                            
AS  
 /*   Date				Author                  Purpose	 		      */ 
 /*-------------------------------------------------------------------*/
 /*   Vandana	   07-08-2017 	   Engineering Improvement-#311  */  
  /*   Sachin	   07-December-2017 	  What :  On Forgot Username Screen, When Clicking on Send Button After adding the Email id in TextBox, 
                                                  It was throwing  subquery returned more than(globalcodes table returning more than one record) hence added IN condion and Top 1 
                                          Why   :  SWMBH - Support #1351      */  
  /*   Sunil.Dasari	   19/04/2018 	  What :  The application refuses to accept the answer to my first security question, even though it is correct.  I’ve reset it and it still fails to accept it.
                                      Why  : Harbor - Support #1564.1     */     
 /*********************************************************************/
 
 BEGIN                          
	BEGIN TRY  
 
		SELECT * FROM staffsecurityquestions WHERE
		securityquestion in (select globalcodeid from globalcodes WHERE codename=@SecurityQues and ISNULL(RecordDeleted,'N')='N') 
		and staffid=(select top 1 staffid from staff WHERE email=@EmailID and ISNULL(RecordDeleted,'N')='N' AND Active='Y' )
		--and(securityanswer=@SecurityAnsEnc or SecurityAnswer=@SecurityAns
		 and ISNULL(RecordDeleted,'N')='N'
	END TRY                                                                      
	BEGIN CATCH                          
		DECLARE @Error VARCHAR(8000)                                                                       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                 
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ValidateStaffSecurityAnswer')                                                                                                     
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