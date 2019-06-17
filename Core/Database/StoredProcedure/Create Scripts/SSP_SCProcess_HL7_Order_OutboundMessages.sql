/****** Object:  StoredProcedure [dbo].[SSP_SCProcess_HL7_Order_OutboundMessages]    Script Date: 09/13/2013 12:43:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCProcess_HL7_Order_OutboundMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCProcess_HL7_Order_OutboundMessages]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCProcess_HL7_Order_OutboundMessages]    Script Date: 09/13/2013 12:43:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCProcess_HL7_Order_OutboundMessages]
	@VendorId int,
	@ClientId Int,
	@EventType Int,
	@ClientOrderId int,
	@UserCode type_CurrentUser
AS
-- ================================================================
-- Stored Procedure: SSP_SCProcess_HL7_Order_OutboundMessages
-- Create Date : Dec 13 2014
-- Purpose : Inserts a new OMP Message to HL7CPQueueMessages
-- Created By : Pradeep.A
-- EXEC SSP_SCProcess_HL7_Order_OutboundMessages 471
-- ================================================================
-- History --
-- Jan-30-2014		Pradeep: @UserCode parameter is passed into storedProcedure.
-- Jul 11 2014	    Pradeep: Passed new parameters ClientId,MessageType,
--							 EventType to SSP_SCInsertHL7_MessageForProcessing
-- Jul 12 2014      Pradeep: Insert New Record on HL7CPQueueMessageLinks Table
-- Sep 08 2015      Shankha: Modified the logic to not Raise Error
-- ================================================================
BEGIN
	BEGIN TRY
		Declare @Direction	Int
		Declare @MessageRaw nVarchar(max)
		DECLARE @StoredProcedureName nVarchar(200)
		DECLARE @MessageType nVarchar(3) = 'OMP'
		DECLARE @MessageTypeId Int = 6346 
		Declare @EntityType Int
		Declare @EntityId Int

		Set @Direction =8610
		SELECT @StoredProcedureName=StoredProcedureName
		FROM HL7CPMessageConfigurations
		WHERE MessageType=@MessageType 
		AND VendorId= @VendorId
		AND ISNULL(RecordDeleted,'N')='N'
	    
		IF ISNULL(@StoredProcedureName,'') !='' 
		BEGIN
			DECLARE @OutputString nVarchar(max)
			DECLARE @SPName nvarchar(max)
					
			DECLARE @ParamDef nvarchar(max)				

			SET @SPName='EXEC '+@StoredProcedureName+' @VendorId,@ClientId,@EventType,@ClientOrderId, @MessageRaw OUTPUT'
			SET @ParamDef = N'@VendorId int, @ClientId int,@EventType INT,@ClientOrderId INT,@MessageRaw nvarchar(max) OUTPUT'	
			EXECUTE sp_executesql @SPName,@ParamDef,@VendorId,@ClientId,@EventType,@ClientOrderId,@OutputString OUTPUT
			SET @MessageRaw=@OutputString	

			-- Insert messages to Queue table
			IF Isnull(@MessageRaw,'')!=''
			BEGIN			
				Set @EntityType = 8747 -- GlobalCodeId for ClientOrders
				SET @EntityId = @ClientOrderId
				Exec SSP_SCInsertHL7_MessageForProcessing @VendorId,@Direction,@MessageRaw,@UserCode,@ClientId,@MessageTypeId,@EventType,@EntityType,@EntityId
			END	
			ELSE
			Begin
				-- Raise error if message came back blank
				DECLARE @ErrorRaiseEmpty varchar(8000)    
				SET @ErrorRaiseEmpty = 'SSP_SCProcess_HL7_Order_OutboundMessages generated empty message for vendor: ' + CAST(@VendorId AS nvarchar(8))
				
				RAISERROR                                                                       
				(                                                            
					@ErrorRaiseEmpty, -- Message text.                                                                      
					16, -- Severity.                                                                      
					1 -- State.                                                                      
				);	
			END				
		END				
	END TRY
	BEGIN CATCH
		DECLARE @Error varchar(8000)                                                                      
		 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                       
		 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'SSP_SCProcess_HL7_Order_OutboundMessages')                                            
		 + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                        
		 + '*****' + Convert(varchar,ERROR_STATE())                                                                      
		 
		 Insert into ErrorLog (ErrorMessage, VerboseInfo, DataSetInfo, ErrorType, CreatedBy, CreatedDate)
		 values(@Error,NULL,NULL,'HL7 Procedure Error','SmartCare',GetDate())
		                                                              
		 RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 );  
	END CATCH
END

GO


