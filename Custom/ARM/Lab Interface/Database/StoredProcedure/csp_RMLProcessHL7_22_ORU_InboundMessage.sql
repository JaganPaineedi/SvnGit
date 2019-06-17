/****** Object:  StoredProcedure [dbo].[csp_RMLProcessHL7_22_ORU_InboundMessage]    Script Date: 09/13/2013 12:44:22 ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	OBJECT_ID = OBJECT_ID(N'[dbo].[csp_RMLProcessHL7_22_ORU_InboundMessage]')
					AND TYPE IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE [dbo].[csp_RMLProcessHL7_22_ORU_InboundMessage]
GO

/****** Object:  StoredProcedure [dbo].[csp_RMLProcessHL7_22_ORU_InboundMessage]    Script Date: 09/13/2013 12:44:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RMLProcessHL7_22_ORU_InboundMessage]
	@VendorId INT,
	@InboundMessage XML,
	@HL7CPQueueMessageID INT,
	@OutputParamter NVARCHAR(MAX) OUTPUT	
AS --======================================================
/*
Customize here for the order specific Inbound message processing.
Returns last inserted InboundMedicationId.

-- Jun 26 2014		PradeepA	Modified to get the Collection Date from OBX.14 instead of OBR.07 because 
								this data never change for the corrected Result.
-- Jul 12 2014      Pradeep.A	Insert New Record on HL7CPQueueMessageLinks Table for ClientOrders Entity and InboundMedications							
*/
--======================================================
	BEGIN
		BEGIN TRY
			DECLARE	@ClientOrderId INT
			DECLARE	@OrderId INT
			DECLARE	@ClientId INT
			DECLARE	@ClientIdString VARCHAR(MAX)
			DECLARE	@MessageControlId VARCHAR(20)
			DECLARE	@DrugNDCCode NVARCHAR(100)
			DECLARE	@DrugNDCDescription VARCHAR(250)
			DECLARE	@DrugCode VARCHAR(10)
			DECLARE	@AlternateDrugNDCCode NVARCHAR(100)
			DECLARE	@AlternateDrugNDCDescription VARCHAR(250)
			DECLARE	@AlternateDrugCode VARCHAR(10) 
			DECLARE	@DispensedDateTime DATETIME
			DECLARE	@DispensedPackageSize VARCHAR(20)
			DECLARE	@DispensedPackageSizeUnit VARCHAR(250)
			DECLARE	@ExplicitTime VARCHAR(20)
			DECLARE	@StartDateTime VARCHAR(24)
			DECLARE	@EndDateTime VARCHAR(24)
			DECLARE	@Route VARCHAR(MAX)
			DECLARE	@Frequency VARCHAR(MAX)
			DECLARE	@Dose VARCHAR(MAX)	
			DECLARE	@SpecialInstructions VARCHAR(MAX)
			DECLARE	@GiveStrength VARCHAR(MAX)
			DECLARE	@GiveUnit VARCHAR(MAX)
			DECLARE	@SubStatus CHAR(1)
			DECLARE	@DispensingPharmacy NVARCHAR(MAX)
			DECLARE	@Error VARCHAR(8000)   
		
			DECLARE	@StaffId INT
			
			DECLARE	@MessageType NVARCHAR(3)
	
		-- in order as defined by HL7 in MSH
			DECLARE	@HL7EncChars CHAR(5) = '|^~\&'
			SET @HL7EncChars = dbo.GetHL7EncodingCharactersFromMessage(@InboundMessage)
		
		-- Get the Message Type and Event Type
			SELECT	@MessageType = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.9[1]/MSH.9.0[1]/ITEM[1]',
															  'VARCHAR(15)'),
														 @HL7EncChars)
			FROM	@InboundMessage.nodes('HL7Message/MSH') AS T ( item )
		
		-- MSH
			SELECT	@MessageControlId = dbo.HL7_INBOUND_XFORM(T.item.value('MSH.10[1]/MSH.10.0[1]/ITEM[1]',
															  'VARCHAR(20)'),
															  @HL7EncChars)
			FROM	@InboundMessage.nodes('HL7Message/MSH') AS T ( item )
			
		-- PID
			SELECT	@ClientIdString = dbo.HL7_INBOUND_XFORM(T.item.value('PID.3[1]/PID.3.0[1]/ITEM[1]',
															  'VARCHAR(MAX)'),
															@HL7EncChars)
			FROM	@InboundMessage.nodes('HL7Message/PID') AS T ( item )	

		-- Look to see if client id has _NC or other items appended to the actual ID like 349_NC
			DECLARE	@UnderscorePos AS INTEGER = CHARINDEX('_', @ClientIdString)

			IF ( @UnderscorePos > 0 ) 
				BEGIN
			-- strip it out
					SET @ClientIdString = LEFT(@ClientIdString,
											   @UnderscorePos - 1)
				END
		
			SET @ClientId = @ClientIdString
				
			DECLARE	@CreatedBy type_CurrentUser
		-- check that this client  ID exists
		
			IF NOT EXISTS ( SELECT	1
							FROM	Clients C
							WHERE	ClientId = @ClientId
									AND ISNULL(C.RecordDeleted, 'N') = 'N'
									AND C.Active = 'Y' ) 
				BEGIN
			-- If not exists, throw an error..			
					RAISERROR                                                                       
				(                                                            
				'ClientID does not exist',                                                                     
				16, -- Severity.                                                                      
				1 -- State.                                                                      
				); 
				END		
	
		--ORC
		-- Select ClientOrderId from ORC segment as we decided to sent this value in Outbound Message
			SELECT	@ClientOrderId = dbo.HL7_INBOUND_XFORM(T.item.value('ORC.2[1]/ORC.2.0[1]/ITEM[1]',
															  'VARCHAR(20)'),
														   @HL7EncChars)
			FROM	@InboundMessage.nodes('HL7Message/ORC') AS T ( item )
		
			DECLARE	@LoincCode NVARCHAR(100)
			SELECT	@LoincCode = dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]',
															  'Varchar(100)'),
													   @HL7EncChars)
			FROM	@InboundMessage.nodes('HL7Message/OBR') AS T ( item )

			DECLARE @CollectionDateTime NVARCHAR(MAX)
			SELECT	@CollectionDateTime = dbo.HL7_INBOUND_XFORM(T.item.value('OBX.14[1]/OBX.14.0[1]/ITEM[1]',
															  'Varchar(MAX)'),
													   @HL7EncChars)
			FROM	@InboundMessage.nodes('HL7Message/OBX') AS T ( item )
	
		-- =======================================================================================================
		-- LOINC Code Exist check in RML inbound Message
		-- Yes - > 1 ) Check for CLient OrderId Exist
		--		   2 ) Update If exists
		-- No - >  Error Out.
		-- =======================================================================================================
		
			IF ISNULL(@LoincCode, '') = '' 
				BEGIN
					RAISERROR                                                                       
				(                                                            
				'LOINC Code does not exist in Inbound Messsage.',                                                                     
				16, -- Severity.                                                                      
				1 -- State.                                                                      
				); 
				END
			ELSE 
				BEGIN		
		-- check that this client order ID exists
					IF NOT EXISTS ( SELECT	1
									FROM	ClientOrders CO
									WHERE	CO.ClientOrderId = @ClientOrderId
											AND ISNULL(CO.RecordDeleted, 'N') = 'N' ) 
						BEGIN				
					-- ================================================================================================
					-- 1. Match the RML LOINC Code(OBR.4 (Observation Identifier)) from LOINCCodeOrders table 
					--    Yes -> Step 2
					--	  No ->  Error Out
					-- 2. Get all ClientOrders which is linked with the OrderId hav the LOINC code came from RML.
					--	  One -> Steps to Execute For FlowSheet with ClientOrderId Match. 
					--	  Multiple -> Error out
					--	  None -> create a new Client Order -> Steps to Execute For FlowSheet with ClientOrderId Match. 
					-- ================================================================================================	

					-- Step 1 Start --
							IF EXISTS ( SELECT	1
										FROM	LOINCCodeOrders LO
												JOIN Orders O ON O.OrderId = LO.OrderId
										WHERE	LO.LOINCCode = @LoincCode
												AND ISNULL(LO.RecordDeleted,
														   'N') = 'N'
												AND ISNULL(O.RecordDeleted,
														   'N') = 'N' ) 
								BEGIN
									SELECT	@OrderId = O.OrderId
									FROM	LOINCCodeOrders LO
											JOIN Orders O ON O.OrderId = LO.OrderId
									WHERE	LO.LOINCCode = @LoincCode
											AND ISNULL(LO.RecordDeleted, 'N') = 'N'
											AND ISNULL(O.RecordDeleted, 'N') = 'N'						
						
									DECLARE	@ClientOrderCount INT
						
									SELECT	@ClientOrderCount = COUNT(*)
									FROM	ClientOrders Co
											JOIN Orders O ON Co.OrderId = O.OrderId
									WHERE	O.OrderId = @OrderId
											AND ISNULL(O.RecordDeleted, 'N') = 'N'
											AND ISNULL(Co.RecordDeleted, 'N') = 'N'
											AND Co.OrderFlag = 'Y'
											AND Co.ClientId = @ClientId			
									IF @ClientOrderCount > 0
										BEGIN
											SELECT	@ClientOrderId = ClientOrderId
											FROM	ClientOrders
											WHERE	OrderId = @OrderId
													AND ClientId = @ClientId
														
											IF @ClientOrderId > 0 
												EXEC Csp_MapRMLObservationsWithFlowSheet 
													@ClientOrderId,
													@LoincCode,
													@ClientId,
													@InboundMessage,
													@CollectionDateTime						
										END
									ELSE 
							--			IF @ClientOrderCount <= 0
							--				BEGIN
							--					SET @Error = 'OrderId = '
							--						+ CONVERT(VARCHAR, @OrderId)
							--						+ ' Is not associated with any ClientOrders.'
							--					RAISERROR                                                                       
							--(                                                            
							--@Error,                                                                     
							--16, -- Severity.                                                                      
							--1 -- State.                                                                      
							--);
							--				END
							--			ELSE 
											IF @ClientOrderCount = 0 
												BEGIN
							-- Create New ClientOrder and update flowsheet.							
													EXEC @ClientOrderId = Csp_SCCreateNewClientOrder 
														@OrderId,
														@ClientId,
														@HL7EncChars,
														@InboundMessage
							
													IF @ClientOrderId > 0 
														EXEC Csp_MapRMLObservationsWithFlowSheet 
															@ClientOrderId,
															@LoincCode,
															@ClientId,
															@InboundMessage,
															@CollectionDateTime,
															@HL7CPQueueMessageID
													ELSE 
														BEGIN
															RAISERROR                                                                       
									(                                                            
									'Error in creating new Client Order.',                                                                     
									16, -- Severity.                                                                      
									1 -- State.                                                                      
									);	
														END																
												END						
								END
					-- Step 1 End --
							ELSE 
								BEGIN
									RAISERROR                                                                       
						(                                                            
						'LOINC Code is not associated to any Orders.',                                                                     
						16, -- Severity.                                                                      
						1 -- State.                                                                      
						);
								END
						END
					ELSE 
						BEGIN	
				-- =================================================================================================================
				-- Match the LoincCodeId in the InboundMessage with the HealthDataTemplateId defined for the ClientOrder
					-- Match the LOINC Code in HealthDataAttributes table if it doesn't match match with the altenative Names [1..6].
						-- Yes -> Update the ClientHealthDataAttributes table. -> Update Flowsheet Status.
						-- No  -> Log and Error Out.
					-- Else ErrorOut.
				-- =================================================================================================================
							EXEC Csp_MapRMLObservationsWithFlowSheet 
								@ClientOrderId,
								@LoincCode,
								@ClientId,
								@InboundMessage,
								@CollectionDateTime,
								@HL7CPQueueMessageID
						END
				END			 
		END TRY
		BEGIN CATCH	   
		 --*****************************************************************************************
         -- Set error message for .NET program to capture
         --*****************************************************************************************
			SET @OutputParamter = ERROR_MESSAGE()

         --*****************************************************************************************
         -- Log error
         --*****************************************************************************************
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_RMLProcessHL7_22_ORU_InboundMessage') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())                                                                      
          
			INSERT	INTO ErrorLog
					( ErrorMessage,
					  VerboseInfo,
					  DataSetInfo,
					  ErrorType,
					  CreatedBy,
					  CreatedDate
					)
			VALUES	( @Error,
					  NULL,
					  NULL,
					  'HL7 Procedure Error',
					  'SmartCare',
					  GETDATE()
					) 
		END CATCH
	END


GO


