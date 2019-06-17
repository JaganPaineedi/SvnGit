
/****** Object:  StoredProcedure [dbo].[ssp_UpdateAdministeredDateTimeWithStatus]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateAdministeredDateTimeWithStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_UpdateAdministeredDateTimeWithStatus]
GO


/****** Object:  UserDefinedTableType [dbo].[MedicationDetails]    Script Date: 07/03/07 19:32:59 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'MedicationDetails' AND ss.name = N'dbo')
DROP TYPE [dbo].[MedicationDetails]
GO


/****** Object:  UserDefinedTableType [dbo].[MedicationDetails]    Script Date: 07/03/2017 19:32:59 ******/
CREATE TYPE [dbo].[MedicationDetails] AS TABLE(
	[ClientOrderId] [int] NULL,
	[MedAdminRecordId] [int] NULL,
	[Action] [int] NULL
)
GO



/****** Object:  StoredProcedure [dbo].[ssp_UpdateAdministeredDateTimeWithStatus]    Script Date: 07/03/2017 11:19:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_UpdateAdministeredDateTimeWithStatus] 
	 
	 @SelectedMedAdminrecords As [dbo].[MedicationDetails] Readonly  
	,@AdministeredDate DATE  
	,@AdministeredTime TIME  
	,@AdministeredBy INT  
	,@ModifiedBy VARCHAR(30) 
	,@ModifiedDate DATETIME
	
	 
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_UpdateAdministeredDateTimeWithStatus										*/
	/* Creation Date: 07/03/2017															*/
	/*																						*/
	/* Purpose: To Update MAR Administration														*/
	/*  exec ssp_UpdateAdministeredDateTimeWithStatus 275,'2017-05-20','2017-06-20'					        */
	/*                                                                                      */
/* Updates:                                                          */                  
/* Date			Author			Purpose                                   */                  
/* 07/03/2017   Alok Kumar		Created    Ref: AspenPointe-Customizations #103                                  */    
/*********************************************************************/
AS  
BEGIN  
  
 BEGIN TRY  
 
	Declare @MedAdminRecordIds Varchar(Max)
	
	Declare @ClientOrderId INT
	Declare @MedAdminRecordId INT
	Declare @Action INT
	
	DECLARE @AdministeredDose VARCHAR(25)  
	DECLARE @NoOfDosageForm VARCHAR(25)
	DECLARE @OrderFromRX BIT
		
		DECLARE Cursor_MedAdminRecords CURSOR FOR  
		SELECT [ClientOrderId],[MedAdminRecordId],[Action] FROM @SelectedMedAdminrecords  
		

		OPEN Cursor_MedAdminRecords   
		FETCH NEXT FROM Cursor_MedAdminRecords INTO @ClientOrderId,@MedAdminRecordId,@Action   

		WHILE @@FETCH_STATUS = 0   
		BEGIN   
		
				
			EXEC [dbo].[ssp_UpdateAdministeredDateTime] @MedAdminRecordId, @AdministeredDate, @AdministeredTime, @AdministeredBy, @ModifiedBy, @ModifiedDate, 0
			UPDATE MedAdminRecords
				SET STATUS = @Action
				WHERE MedAdminRecordId = @MedAdminRecordId
				
			 
			   FETCH NEXT FROM Cursor_MedAdminRecords INTO @ClientOrderId,@MedAdminRecordId,@Action  
		END   

		CLOSE Cursor_MedAdminRecords   
		DEALLOCATE Cursor_MedAdminRecords

		SET @MedAdminRecordIds = ( isnull(REPLACE(REPLACE(STUFF((SELECT DISTINCT ', ' +  CAST(ISNULL([MedAdminRecordId], '') as varchar)
									FROM @SelectedMedAdminrecords
									FOR XML PATH('')), 1, 1, ''), '<', '<'), '>', '>'), ''))
									
	   
		-- Update the ClientOrder table with Complete status if last schedule administration is given.
		EXEC ssp_UpdateClientOrderStatus @MedAdminRecordIds, @AdministeredBy 
		
					
		--Insert into Med Admin record history table
		EXEC ssp_InsertMedAdministrationHistory	@MedAdminRecordIds	 									
  
 END TRY  
  
 BEGIN catch 
        DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'ssp_UpdateAdministeredDateTimeWithStatus') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error,-- Message text.             
                    16,-- Severity.             
                    1 -- State.             
        ); 
    END catch 
END