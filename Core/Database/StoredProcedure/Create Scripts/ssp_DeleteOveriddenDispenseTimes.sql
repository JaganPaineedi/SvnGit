/****** Object:  StoredProcedure [dbo].[ssp_DeleteOveriddenDispenseTimes]    Script Date: 09/08/2015 14:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DeleteOveriddenDispenseTimes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_DeleteOveriddenDispenseTimes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_DeleteOveriddenDispenseTimes]    Script Date: 09/08/2015 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*********************************************************************/                          
/* Stored Procedure: dbo.ssp_DeleteOveriddenDispenseTimes     */           
/*	exec ssp_DeleteOveriddenDispenseTimes 17, -1					*/               
/* Creation Date:  09/26/2018                                        */                          
/* Author: Chethan N                                                                  */                          
/* Purpose: Delete Overidden Dispense Times
                  */                         
/*                                                                   */                        
/* Input Parameters:             */                        
/*                                                                   */                          
/* Output Parameters:             */                          
/*                                                                   */
/*  Date			Author			Purpose							*/
/*	09-25-2018		Chethan N		Created - CCC-Customizations task #74								
	01-16-2019		Chethan N	    What : Rescheduling the medications which are in current hour and future date and time.
									Why : WestBridge - Support Go Live task #32*/                  
/*********************************************************************/     
CREATE Procedure [dbo].[ssp_DeleteOveriddenDispenseTimes]
@OrderTemplateFrequencyOverRideId INT,   
@ClientId INT, 
@ClientOrderId INT, 
@ClientMedicationInstructionId INT,  
@UserCode type_CurrentUser 
AS    
BEGIN    
BEGIN TRY 

	UPDATE OrderTemplateFrequencyOverRides
		SET RecordDeleted = 'Y',
			DeletedBy = @UserCode,
			DeletedDate = GETDATE(),
			ModifiedBy = @UserCode,
			ModifiedDate = GETDATE()
		WHERE OrderTemplateFrequencyOverRideId = @OrderTemplateFrequencyOverRideId 
		
	IF (@ClientMedicationInstructionId > -1)
	BEGIN
		UPDATE MedAdminRecords
			SET RecordDeleted = 'Y',
				DeletedBy = @UserCode,
				DeletedDate = GETDATE(),
				ModifiedBy = @UserCode,
				ModifiedDate = GETDATE(),
				Comment = 'Delete by OrderTemplateFrequencyOverRides'
			WHERE ClientMedicationInstructionId = @ClientMedicationInstructionId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND Status IS NULL
				AND CAST(CONVERT(DATETIME, CONVERT(CHAR(8), ScheduledDate, 112) + ' ' + CONVERT(CHAR(8), ScheduledTime, 108)) AS DATETIME ) >=
				CAST(DATEADD(HH,DATEPART(HH,GETDATE()),CAST(CAST(GETDATE() AS DATE) AS DATETIME)) AS DATETIME)
				
		EXEC ssp_InsertRXMedToMAR @ClientId = @ClientId, @ClientMedicationInstructionId = @ClientMedicationInstructionId
	END
	ELSE
	BEGIN
		UPDATE MedAdminRecords
			SET RecordDeleted = 'Y',
				DeletedBy = @UserCode,
				DeletedDate = GETDATE(),
				ModifiedBy = @UserCode,
				ModifiedDate = GETDATE(),
				Comment = 'Delete by OrderTemplateFrequencyOverRides'
			WHERE ClientOrderId = @ClientOrderId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				AND Status IS NULL
				AND CAST(CONVERT(DATETIME, CONVERT(CHAR(8), ScheduledDate, 112) + ' ' + CONVERT(CHAR(8), ScheduledTime, 108)) AS DATETIME ) >=
				CAST(DATEADD(HH,DATEPART(HH,GETDATE()),CAST(CAST(GETDATE() AS DATE) AS DATETIME)) AS DATETIME)

		EXEC ssp_CreateMARDetails @ClientOrderId = @ClientOrderId
	END

END TRY                  
 BEGIN CATCH                
  DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'ssp_DeleteOveriddenDispenseTimes') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error,-- Message text.             
                    16,-- Severity.             
                    1 -- State.             
        );                   
 END CATCH     
    
END    
GO


