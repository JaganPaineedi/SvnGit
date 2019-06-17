/****** Object:  StoredProcedure [dbo].[ssp_SaveOveriddenDispenseTimes]    Script Date: 09/08/2015 14:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SaveOveriddenDispenseTimes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SaveOveriddenDispenseTimes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SaveOveriddenDispenseTimes]    Script Date: 09/08/2015 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*********************************************************************/                          
/* Stored Procedure: dbo.ssp_SaveOveriddenDispenseTimes     */           
/*	exec ssp_SaveOveriddenDispenseTimes 17, -1					*/               
/* Creation Date:  09/26/2018                                        */                          
/* Author: Chethan N                                                                  */                          
/* Purpose: To get Dispense Times of the Client Order Or Client Medication
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
CREATE Procedure [dbo].[ssp_SaveOveriddenDispenseTimes] 
@OrderTemplateFrequencyOverRideId INT,
@ClientId INT,
@MedicationId INT,
@RxFrequencyId INT,
@DispenseTime1 VARCHAR(20), 
@DispenseTime2 VARCHAR(20),
@DispenseTime3 VARCHAR(20),
@DispenseTime4 VARCHAR(20),
@DispenseTime5 VARCHAR(20),
@DispenseTime6 VARCHAR(20),
@DispenseTime7 VARCHAR(20),
@DispenseTime8 VARCHAR(20),    
@ClientOrderId INT, 
@ClientMedicationInstructionId INT,
@UserCode type_CurrentUser,
@OrderId INT
AS    
BEGIN    
BEGIN TRY 

SELECT @DispenseTime1 = CONVERT(TIME ,@DispenseTime1),
		@DispenseTime2 = CONVERT(TIME ,@DispenseTime2),
		@DispenseTime3 = CONVERT(TIME ,@DispenseTime3),
		@DispenseTime4 = CONVERT(TIME ,@DispenseTime4),
		@DispenseTime5 = CONVERT(TIME ,@DispenseTime5),
		@DispenseTime6 = CONVERT(TIME ,@DispenseTime6),
		@DispenseTime7 = CONVERT(TIME ,@DispenseTime7),
		@DispenseTime8 = CONVERT(TIME ,@DispenseTime8)

IF (@OrderTemplateFrequencyOverRideId > -1)
	BEGIN
		UPDATE OrderTemplateFrequencyOverRides
		SET DispenseTime1 = @DispenseTime1,
			DispenseTime2 = @DispenseTime2,
			DispenseTime3 = @DispenseTime3,
			DispenseTime4 = @DispenseTime4,
			DispenseTime5 = @DispenseTime5,
			DispenseTime6 = @DispenseTime6,
			DispenseTime7 = @DispenseTime7,
			DispenseTime8 = @DispenseTime8,
			ModifiedBy = @UserCode,
			ModifiedDate = GETDATE()
		WHERE OrderTemplateFrequencyOverRideId = @OrderTemplateFrequencyOverRideId
	END
ELSE
	BEGIN
		INSERT INTO OrderTemplateFrequencyOverRides (CreatedBy, ModifiedBy, ClientId, MedicationId, OrderId, RxFrequencyId, DispenseTime1, DispenseTime2, DispenseTime3, DispenseTime4, DispenseTime5, DispenseTime6, DispenseTime7, DispenseTime8)
		SELECT @UserCode, @UserCode, @ClientId, @MedicationId, @OrderId, @RxFrequencyId, @DispenseTime1, @DispenseTime2, @DispenseTime3, @DispenseTime4, @DispenseTime5, @DispenseTime6, @DispenseTime7, @DispenseTime8
	END
	
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
                    'ssp_SaveOveriddenDispenseTimes') 
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


