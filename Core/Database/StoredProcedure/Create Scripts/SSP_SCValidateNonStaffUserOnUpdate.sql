/****** Object:  StoredProcedure [dbo].[SSP_SCValidateNonStaffUserOnUpdate]    Script Date: 06/17/2015 05:55:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCValidateNonStaffUserOnUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCValidateNonStaffUserOnUpdate]
GO


GO

/****** Object:  StoredProcedure [dbo].[SSP_SCValidateNonStaffUserOnUpdate]    Script Date: 06/17/2015 05:55:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SSP_SCValidateNonStaffUserOnUpdate]
 @ClientID int,                            
 @StaffID int,                          
 @CustomParameters xml    
AS    
/*********************************************************************                                                                                                          
-- Stored Procedure: dbo.SSP_SCValidateNonStaffUserOnUpdate                                                                                                          
--                                                                                                          
-- Copyright: 2014                                                                                                        
--                                                                                                          
-- Creation Date:  05/22/2014                                                                                                          
--                                                                                                          
-- Purpose: Created for validating the ClientId with the existing NonStaffUser.                                                                                                          
--                                                                                                                                                                                                         
-- Data Modifications:                                                                                                          
--                                                                                                          
-- Updates:                                                                                                          
-- Date				Author              Purpose 
16 Jun 2014			Pradeep A			What : Changed ClientId to TempClientId for releasing PPA. 
28 Jul 2014			Chethan N			What : Validation for USERCODE. Why : Staffs should have unique USERCODE
06 Nov 2014			Varun			    What : Validation for Client Contacts
30 Nov 2016         Arjun K R           What : Remove Validation "Client Id is already linked to another Non Staff User". Task #447 AspenPointe Customization 
27 Nov 2018			Irfan				What : Added condition to check if there is a new staff creating from a Staff Details then system should allow user to save
											   and create a new staff and should not appear validations related to the custom fields tab, and added call of
											   scsp in SSP to show validations related to Custom Fields tab on StaffDetails screen and removed the commented code.  
										Why  : Customer requested to display these validations 'Job Code is required' and 'Pay Class is required' once the staff is created as part of the task
											   ViaQuest - Customizations -#6200.2*/
/**********************************************************************/

BEGIN	
	BEGIN TRY
	 Declare @NonStaffClientId Int
	 SET @NonStaffClientId = @CustomParameters.value('(/Root/Parameters/@ClientId)[1]', 'int' )
	 
	 Declare @NonStaffClientContactId Int
	 SET @NonStaffClientContactId = @CustomParameters.value('(/Root/Parameters/@ClientContactId)[1]', 'int' )  
	 	 
	 Declare @StaffUserCode varchar(30) 
	 SET @StaffUserCode = @CustomParameters.value('(/Root/Parameters/@StaffUserCode)[1]', 'varchar(30)' )	
	    
	 Declare @CurrentStaffId INT   
	 SET @CurrentStaffId = @CustomParameters.value('(/Root/Parameters/@CurrentStaffId)[1]', 'int' )  	 	         
	 
	 DECLARE @validationReturnTable TABLE                  
	 (                    
	  TableName varchar(200),                        
	  ColumnName varchar(200),                        
	  ErrorMessage varchar(1000)                    
	 )   
	 
	 ----Added on 16/Nov/2018 by Irfan
	 
		IF (@CurrentStaffId>0) 
		AND EXISTS(
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_SCValidateNonStaffUserOnUpdate]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
		
		BEGIN
		
		INSERT INTO @validationReturnTable                    
		( TableName,                          
		 ColumnName,                          
		 ErrorMessage )        
		
		 EXEC [dbo].[SCSP_SCValidateNonStaffUserOnUpdate] @StaffId 
		 
		 END	
	---- End of the execution of SCSP----- 
	
      IF (ISNULL(@StaffUserCode,'N')!='N' )
	 BEGIN               
		 IF EXISTS(SELECT 1 FROM Staff S WHERE ISNULL(S.RecordDeleted,'N')='N' And S.UserCode=@StaffUserCode And S.StaffId <>@StaffID) 
		 BEGIN
			 INSERT INTO @validationReturnTable                  
			 ( TableName,                        
			  ColumnName,                        
			  ErrorMessage 
			  )             
		     SELECT '', '', 'Username is already taken, please choose a new Username.' 
		END		       
     END
	 SELECT TableName, ColumnName, ErrorMessage from @validationReturnTable   
           
	 IF EXISTS (SELECT * FROM @validationReturnTable)                  
	 BEGIN                   
		SELECT 1 AS ValidationStatus 
	 END                  
	 ELSE                  
	 BEGIN         
		SELECT 0 AS ValidationStatus                  
	 END                    
       
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                       
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                     
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[SSP_SCValidateNonStaffUserOnUpdate]')                                                                                                     
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                      
		+ '*****' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                                     
		(                  
		 @Error, -- Message text.                                                                                                    
		 16, -- Severity.                                                                                                    
		 1 -- State.                                                                                                    
		);  
	END CATCH
END

GO

