/****** Object:  StoredProcedure [dbo].[Csp_MapRMLObservationsWithFlowSheet]    Script Date: 02/17/2014 12:03:44 ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[Csp_MapRMLObservationsWithFlowSheet]')
					AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE [dbo].[Csp_MapRMLObservationsWithFlowSheet]
GO

/****** Object:  StoredProcedure [dbo].[Csp_MapRMLObservationsWithFlowSheet]    Script Date: 02/17/2014 12:03:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Csp_MapRMLObservationsWithFlowSheet]
	@ClientOrderId INT,
	@LoincCode VARCHAR(100),
	@ClientId INT,
	@InboundMessage XML,
	@CollectionDateTime NVARCHAR(MAX),
	@HL7CPQueueMessageID INT
AS 
--=======================================
/* 
Description : Used to update the Lab order Observation to Flowsheet      

-- Jun 26 2014		PradeepA	Fetched NTE segment as Note to receive Observation.
-- Jul 16 2014		PradeepA	Added New Parameters @Range,@Flag,@Comment,@IsCorrected,@ResultStatus AND @HL7CPQueueMessageID to csp_CreateLabOrderFlowsheet
*/
--=======================================
	BEGIN	
		DECLARE	@TranName VARCHAR(20);
		SET @TranName = 'UpdateObservations'
		BEGIN TRY
			DECLARE	@Error VARCHAR(8000) 	
	-- Steps to Execute For FlowSheet with ClientOrderId Match.
			IF EXISTS ( SELECT	1
						FROM	ClientOrders Co
								JOIN Orders O ON Co.OrderId = O.OrderId
								JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
						WHERE	Co.ClientOrderId = @ClientOrderId
								AND HDT.OrderCode = @LoincCode
								AND HDT.Active = 'Y'
								AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
								AND ISNULL(Co.RecordDeleted, 'N') = 'N'
								AND ISNULL(O.RecordDeleted, 'N') = 'N'
								AND ISNULL(@LoincCode, '') <> '' ) 
				BEGIN
					BEGIN TRAN @TranName
		-- Loop through OBX segment
					DECLARE	@Identifier NVARCHAR(MAX)
					DECLARE	@value NVARCHAR(MAX)
					DECLARE	@Unit NVARCHAR(MAX)
					DECLARE @Status NVARCHAR(1)
					DECLARE @ResultDateTime NVARCHAR(MAX)
					DECLARE @Range NVARCHAR(MAX)
					DECLARE @Flag NVARCHAR(MAX)
					DECLARE @Comment NVARCHAR(MAX)
					DECLARE @EntityType INT
					DECLARE @EntityId INT
					DECLARE @IsCorrected type_YorN
					DECLARE @UserCode type_currentUser
					DECLARE @ResultStatus INT
					DECLARE @IsCorrectionFound type_YorN
					
					SET @UserCode = CURRENT_USER
					
					Set @EntityType = 8747 -- GlobalCodeId for ClientOrders
					Set @EntityId = @ClientOrderId -- ClientOrderId.
		
					Exec SSP_SCInsertHL7CPQueueMessageLink @UserCode,@HL7CPQueueMessageID,@EntityType,@EntityId	
					
					DECLARE observation CURSOR LOCAL FAST_FORWARD
					FOR
						SELECT	m.c.value('OBX.3[1]/OBX.3.0[1]/ITEM[1]',
										  'nvarchar(max)') AS Identifier,
								m.c.value('OBX.5[1]/OBX.5.0[1]/ITEM[1]',
										  'nvarchar(max)') AS Value,
								m.c.value('OBX.6[1]/OBX.6.0[1]/ITEM[1]',
										  'nvarchar(max)') AS Unit,
								m.c.value('OBX.11[1]/OBX.11.0[1]/ITEM[1]',
										  'nvarchar(max)') AS ResultStatus,
								m.c.value('OBX.14[1]/OBX.14.0[1]/ITEM[1]',
										  'nvarchar(max)') AS ResultDateTime,
								m.c.value('OBX.7[1]/OBX.7.0[1]/ITEM[1]',
										  'nvarchar(max)') AS [Range],
								m.c.value('OBX.8[1]/OBX.8.0[1]/ITEM[1]',
										  'nvarchar(max)') AS Flag	,
								CONVERT(nvarchar(max),m.c.query('.//NTE.3.0[1]/ITEM[1]/text()')) AS Comment	  
						FROM	@InboundMessage.nodes('HL7Message/OBX') AS m ( c )
					OPEN observation

					FETCH NEXT FROM observation INTO @Identifier, @value,@Unit, @Status, @ResultDateTime,@Range,@Flag,@Comment

					WHILE @@FETCH_STATUS = 0 
						BEGIN
			-- Get Observation Result Status Id from GlobalCodes based on the mapping done.
							SELECT @ResultStatus = dbo.GetHL7ResultStatus(@Status)
							IF @Status = 'C'
								BEGIN
									SET @IsCorrected = 'Y'
									SET @IsCorrectionFound ='Y'
								END	
							ELSE 
								SET @IsCorrected = NULL
			-- ==============================================			
			-- Call Flowsheet for mapping Individual Observations.
							EXEC csp_CreateLabOrderFlowsheet 
								@Identifier,
								@value,
								@ClientId,
								@LoincCode,
								@ResultDateTime,
								@CollectionDateTime,
								@Range,
								@Flag,
								@Comment,
								@IsCorrected,
								@ResultStatus,
								@HL7CPQueueMessageID
							FETCH NEXT FROM observation INTO @Identifier,@value, @Unit, @Status, @ResultDateTime,@Range,@Flag,@Comment
						END
			-- ==============================================				
					CLOSE observation
					DEALLOCATE observation
					
					IF ISNULL(@IsCorrectionFound,'N') = 'Y'
					BEGIN
						IF Exists (SELECT 1 FROM HL7CPQueueMessageLinks HQML 
									JOIN HL7CPQueueMessages HQM ON HQML.HL7CPQueueMessageID = HQML.HL7CPQueueMessageId
									Where HQML.HL7CPQueueMessageId != @HL7CPQueueMessageID 
									AND HQM.Direction = 8609
									AND HQML.EntityType=8747 AND HQML.EntityId = @ClientOrderId AND ISNULL(HQML.RecordDeleted,'N')!='Y')
						BEGIN
							DECLARE @HL7CPQueueMId INT
							DECLARE @HL7CPQueueMLId INT
							
							SELECT TOP 1 @HL7CPQueueMId = HQML.HL7CPQueueMessageId,
								   @HL7CPQueueMLId=HQML.HL7CPQueueMessageLinkId 
							FROM HL7CPQueueMessageLinks HQML 
							JOIN HL7CPQueueMessages HQM ON HQML.HL7CPQueueMessageID = HQML.HL7CPQueueMessageId
							Where HQML.HL7CPQueueMessageId != @HL7CPQueueMessageID 
							AND HQM.Direction = 8609
							AND HQML.EntityType=8747 
							AND HQML.EntityId = @ClientOrderId 
							AND ISNULL(HQML.RecordDeleted,'N')!='Y'
							ORDER BY HL7CPQueueMessageLinkId DESC
								
							UPDATE HL7CPQueueMessageLinks 
								SET RecordDeleted ='Y',
									DeletedBy=@UserCode,
									DeletedDate=GetDate()
								WHERE HL7CPQueueMessageLinkId= @HL7CPQueueMLId
								AND EntityType=8747 --CLIENTORDERS
								AND ISNULL(RecordDeleted,'N')='N'
								
							UPDATE 	ClientHealthDataAttributes 
								SET RecordDeleted ='Y',
									DeletedBy=@UserCode,
									DeletedDate=GetDate()
								WHERE ClientHealthDataAttributeId IN (SELECT EntityId FROM HL7CPQueueMessageLinks
																	  WHERE HL7CPQueueMessageId= @HL7CPQueueMId 
																	  AND EntityType=8749 --CLIENTHEALTHDATAATTRIBUTES
																	  AND ISNULL(RecordDeleted,'N')='N')	
							
							UPDATE HL7CPQueueMessageLinks
								SET RecordDeleted ='Y',
									DeletedBy=@UserCode,
									DeletedDate=GetDate()
								WHERE HL7CPQueueMessageId= @HL7CPQueueMId 
								AND EntityType=8749 --CLIENTHEALTHDATAATTRIBUTES
								AND ISNULL(RecordDeleted,'N')='N'
						END
					END
					
		-- Update ClientOrder With its Status (Results Obtained)
					UPDATE	ClientOrders
					SET		OrderStatus = 6504,
							FlowSheetDateTime= CONVERT(DATETIME, CONVERT(CHAR(35), STUFF(STUFF(STUFF(@CollectionDateTime,
															  9, 0, ' '), 12,
															  0, ':'), 15, 0,
															  ':'), 120)) 
					WHERE	ClientOrderId = @ClientOrderId						
					COMMIT TRAN @TranName			
				END	
			ELSE 
				BEGIN
		--Error Out
					SET @Error = 'The LOINC Code ' + @LoincCode
						+ ' is not associated with the ClientOrder with the ClientOrderId='
						+ CONVERT(VARCHAR(100), @ClientOrderId)
					RAISERROR                                                                       
		(                                                            
		@Error,                                                                     
		16, -- Severity.                                                                      
		1 -- State.                                                                      
		);
				END		
		END TRY
		BEGIN CATCH
			IF EXISTS ( SELECT	1
						FROM	Sys.dm_tran_active_transactions
						WHERE	Name = @TranName ) 
				ROLLBACK TRAN @TranName
		
			SET @Error = CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'Csp_MapRMLObservationsWithFlowSheet')
		 
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
		                                                         
			RAISERROR                                                                       
		 (                                                            
		 @Error, -- Message text.                                                                      
		 16, -- Severity.                                                                      
		 1 -- State.                                                                      
		 ); 
		END CATCH
	END	
GO


