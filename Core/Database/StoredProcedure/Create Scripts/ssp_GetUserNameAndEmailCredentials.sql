IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_GetUserNameAndEmailCredentials')
BEGIN
	DROP  PROCEDURE ssp_GetUserNameAndEmailCredentials 
END

GO
CREATE PROCEDURE  [dbo].ssp_GetUserNameAndEmailCredentials 
(               
 @EmailID varchar(max) ,
  @GUID    varchar(max),
  @typeofrequest char                     
)                                                                            
AS  
 /*   Date				Author                  Purpose	 		      */ 
 /*-------------------------------------------------------------------*/
 /*   Vandana	   07-08-2017 	   Engineering Improvement-#311     										*/        
 /*********************************************************************/
 
 BEGIN                          
	BEGIN TRY 

	DECLARE @staffid int
	SET @staffid=(select staffid from staff where email=@EmailID and ISNULL(RecordDeleted,'N')='N' and Active='Y')
	select top 1 * from CustomerForgotUsernameMailCredentials where  ISNULL(RecordDeleted,'N')='N'
	order by createddate desc
	select usercode,(Firstname +' '+ Lastname)as StaffName, staffid from staff where email=@EmailID and ISNULL(RecordDeleted,'N')='N' and Active='Y'
	select top 1 AgencyName from agency 

	Insert into CustomerEmailLinkExpiry
	(	GUIId,	
		staffid,
		TypeOfRquest,
		TokenExpire ,
		EmailTime	
	)	
	values
	(
		@GUID,
		@staffid,
		@typeofrequest,
		'N',
		getdate()
	)
   
	END TRY                                                                      
	BEGIN CATCH                          
		DECLARE @Error VARCHAR(8000)                                                                       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                 
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetUserNameAndEmailCredentials')                                                                                                     
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