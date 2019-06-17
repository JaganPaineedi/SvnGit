IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_GetStaffSecurityQuestions')
BEGIN
	DROP  PROCEDURE ssp_GetStaffSecurityQuestions
END

GO
CREATE PROCEDURE  [dbo].[ssp_GetStaffSecurityQuestions] --'a@a.com',1
(               
 @EmailID varchar(max), 
 @SecurityQues int  
                           
)                                                                            
AS  
 /*   Date				Author                  Purpose	 		      */ 
 /*-------------------------------------------------------------------*/
 /*   Vandana	   07-08-2017 	   Engineering Improvement-#311     										*/        
 /*********************************************************************/
 
 BEGIN                          
	BEGIN TRY   
	declare @result int;
	declare @count int;

	If NOT Exists(Select 1 From Staff where Email=@EmailID And Active='Y' And ISNULL(RecordDeleted,'N')='N')
	BEGIN
		Select 0 as codename
	END
	ELSE If EXISTS(SELECT
							1
							FROM Staff
							where ISNULL(RecordDeleted,'N')='N' AND Active='Y' AND Email=@EmailID 
							GROUP BY email
							HAVING COUNT(*)>1)
	BEGIN
		Select 1 as codename
	END
	ELSE IF Not Exists(Select 1 From StaffSecurityQuestions St 
							Inner Join  Staff S ON S.StaffId=St.StaffId 
							WHERE S.Email=@EmailID AND S.Active='Y' AND ISNULL(S.RecordDeleted,'N')='N' AND ISNULL(St.RecordDeleted,'N')='N' )
	BEGIN  
		Select 2 as codename
	END
	ELSE IF Exists(SELECT
							1
							FROM Staff
							where AccessSmartCare='N' AND ISNULL(RecordDeleted,'N')='N' AND Active='Y' AND Email=@EmailID 
							)
	BEGIN  
		Select 3 as codename
	END
	ELSE
	BEGIN
		;with cte as
		(
			select codename ,
			ROW_NUMBER() over (order by globalcodeid) as rn
			from globalcodes where globalcodeid in (select securityquestion from staffsecurityquestions where ISNULL(RecordDeleted,'N')='N' AND staffid=(select staffid from staff where Email = @EmailID AND ISNULL(RecordDeleted,'N')='N' AND Active='Y'))
		) 
		select codename from cte where rn=@SecurityQues
	END
	
	

	END TRY                                                                      
	BEGIN CATCH                          
		DECLARE @Error VARCHAR(8000)                                                                       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                 
					+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetStaffSecurityQuestions')                                                                                                     
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