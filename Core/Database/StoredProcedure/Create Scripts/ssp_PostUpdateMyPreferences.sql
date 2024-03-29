IF EXISTS ( SELECT  *
            FROM    sys.procedures
            WHERE   name = 'ssp_PostUpdateMyPreferences' )
    DROP PROCEDURE ssp_PostUpdateMyPreferences
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_PostUpdateMyPreferences]                      
    (
      @ScreenKeyId INT ,
      @StaffId INT ,
      @CurrentUser VARCHAR(30) ,
      @CustomParameters XML
    )
AS /****************************************************************************************************/ 
/* Stored Procedure: [ssp_PostUpdateMyPreferences]											          */ 
/* Creation Date:  28 Nov 2016																		  */ 
/* Author:  Arjun KR  																			      */ 
/* Purpose: To update data after save. Task #449 AspenPointe Customizations						      */ 
/* Data Modifications:																				  */ 
/* Date			Author			Details */
/* 12/27/18		Ponnin			Calling SCSP stored procedure "scsp_PostUpdateMyPreferences" to handle the custom logic. why: for task #1822 of Harbor - Support  */
/******************************************************************************************************/ 
    BEGIN 
        BEGIN TRY 
			DECLARE @ReminderPreference INT
			DECLARE @ClientEmail varchar(100)
			DECLARE @NonStaffUser Char(1)
			DECLARE @TempClientId INT		
		    
		    SET @TempClientId=(SELECT TempClientId FROM Staff WHERE StaffId=@StaffId AND ISNULL(RecordDeleted,'N')='N')
			SET @ReminderPreference = @CustomParameters.value('(/Root/Parameters/@ReminderPreference)[1]', 'Int')  
			SET @ClientEmail=@CustomParameters.value('(/Root/Parameters/@ClientEmail)[1]','varchar(max)')
			

			
			SET @NonStaffUser=(SELECT ISNULL(NonStaffUser,'N') From Staff WHERE StaffId=@StaffId AND ISNULL(RecordDeleted,'N')='N') 
			IF(@NonStaffUser='Y') 
				BEGIN			   
					UPDATE Clients SET ReminderPreference=@ReminderPreference WHERE ClientId=@TempClientId AND ISNULL(RecordDeleted,'N')='N'
					UPDATE Clients SET Email=@ClientEmail WHERE  ClientId=@TempClientId AND ISNULL(RecordDeleted,'N')='N'
				END
				
				
				
		IF EXISTS ( SELECT  *
                FROM    sys.procedures
                WHERE   name = 'scsp_PostUpdateMyPreferences' )
        BEGIN
	
            EXEC scsp_PostUpdateMyPreferences @ScreenKeyId, @StaffId, @CurrentUser, @CustomParameters 
		END
				
				
          
        END TRY 

        BEGIN CATCH 
            DECLARE @Error VARCHAR(8000) 

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateMyPreferences') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

            RAISERROR ( @Error, 
                      -- Message text.                                                                    
                      16, 
                      -- Severity.                                                           
                      1 
          -- State.                                                        
          ); 
        END CATCH 
    END 
 
