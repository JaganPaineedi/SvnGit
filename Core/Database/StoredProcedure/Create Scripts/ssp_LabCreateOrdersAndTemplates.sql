/****** Object:  StoredProcedure [dbo].[ssp_LabCreateOrdersAndTemplates]    Script Date: 12/18/2018 7:17:46 AM ******/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_LabCreateOrdersAndTemplates]') AND type in (N'P', N'PC'))
BEGIN
DROP PROCEDURE [dbo].[ssp_LabCreateOrdersAndTemplates]
END
GO

/****** Object:  StoredProcedure [dbo].[ssp_LabCreateOrdersAndTemplates]    Script Date: 12/18/2018 7:17:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_LabCreateOrdersAndTemplates] @MessageXML XML
	,@HL7CPQueueMessageID INT
AS
-- =============================================      
-- Author:  Gautam      
-- Create date: 10/31/2018  
-- Description: Create Order & Template from messages
/*      
 Author			Modified Date			Reason      
 Gautam			10/31/2018				Created,Gulf Bend - Implementation > Tasks#166 > Lab Setup

*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LabId INT
		DECLARE @OrderCode VARCHAR(200)
		DECLARE @OrderTestName VARCHAR(200)
		DECLARE @UserCode VARCHAR(200)
		DECLARE @HealthDataTemplateId INT
			,@HealthDataSubTemplateId INT
			,@HealthDataAttributeId INT
		DECLARE @OrderId INT
			,@FrequencyId INT
			,@OrderTemplateFrequencyId INT
			,@OBRSeqNo INT
			,@AttributeSeq INT
		DECLARE @LOINCCode VARCHAR(200)
			,@AttributeName VARCHAR(200)
		DECLARE @FieldChar CHAR
		DECLARE @CompChar CHAR
		DECLARE @RepeatChar CHAR
		DECLARE @HL7EncChars CHAR
		DECLARE @SubCompChar CHAR
		DECLARE @HL7EncodingChars NVARCHAR(5)='|^~\&'

		EXEC SSP_SCGetHL7_EncChars @HL7EncodingChars
			,@FieldChar OUTPUT
			,@CompChar OUTPUT
			,@RepeatChar OUTPUT
			,@HL7EncChars OUTPUT
			,@SubCompChar OUTPUT

		-- Get LabId based on @HL7CPQueueMessageID Input 
		SELECT TOP 1 @LabId = l.LaboratoryId
		FROM Laboratories l
		JOIN HL7CPQueueMessages m ON l.VendorId = m.CPVendorConnectorID
		WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID
		
		-- If LabId does not exist then don't do any thing
		IF isnull(@LabId, 0) = 0
		BEGIN
			RETURN
		END

		SELECT TOP 1 @UserCode = UserCode
		FROM Staff
		WHERE usercode = 'HL7 Lab Interface'
      
      -- Create all master entry in GlobalCode & related tables
		IF NOT EXISTS (
				SELECT Category
				FROM GlobalCodeCategories
				WHERE Category = 'XOrderFrequency'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			INSERT INTO GlobalCodeCategories (
				Category
				,CategoryName
				,Active
				,AllowAddDelete
				,AllowCodeNameEdit
				,AllowSortOrderEdit
				,[Description]
				,UserDefinedCategory
				,HasSubcodes
				,UsedInCareManagement
				)
			VALUES (
				'XOrderFrequency'
				,'XOrderFrequency'
				,'Y'
				,'Y'
				,'Y'
				,'Y'
				,NULL
				,'Y'
				,'N'
				,'Y'
				)
		END

		IF NOT EXISTS (
				SELECT GlobalCodeId
				FROM GlobalCodes
				WHERE Category = 'XOrderFrequency'
					AND CodeName = 'Once'
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			INSERT INTO GlobalCodes (
				Category
				,CodeName
				,Code
				,Description
				,Active
				,CannotModifyNameOrDelete
				,SortOrder
				,ExternalCode1
				,ExternalSource1
				,ExternalCode2
				,ExternalSource2
				,Bitmap
				)
			VALUES (
				'XOrderFrequency'
				,'Once'
				,'Once'
				,'Once value for Order frequency'
				,'Y'
				,'Y'
				,1
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				)
		END

		SELECT TOP 1 @FrequencyId = GlobalCodeId
		FROM GlobalCodes
		WHERE Category = 'XOrderFrequency'
			AND CodeName = 'Once'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF NOT EXISTS (
				SELECT 1
				FROM OrderTemplateFrequencies
				WHERE [FrequencyId] = @FrequencyId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
		BEGIN
			INSERT INTO [OrderTemplateFrequencies] (
				[CreatedBy]
				,[CreatedDate]
				,[ModifiedBy]
				,[ModifiedDate]
				,[RecordDeleted]
				,[DeletedDate]
				,[DeletedBy]
				,[TimesPerDay]
				,[DispenseTime1]
				,[DispenseTime2]
				,[DispenseTime3]
				,[DispenseTime4]
				,[DispenseTime5]
				,[DispenseTime6]
				,[FrequencyId]
				,[IsPRN]
				,[DispenseTime7]
				,[DispenseTime8]
				,[RxFrequencyId]
				,[DisplayName]
				)
			VALUES (
				@UserCode
				,GETDATE()
				,@UserCode
				,GETDATE()
				,NULL
				,NULL
				,NULL
				,1
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,@FrequencyId
				,'N'
				,NULL
				,NULL
				,4861
				,'Once'
				)

			SET @OrderTemplateFrequencyId = (
					SELECT TOP 1 [OrderTemplateFrequencyId]
					FROM OrderTemplateFrequencies
					WHERE [FrequencyId] = @FrequencyId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
		END
		ELSE
		BEGIN
			SET @OrderTemplateFrequencyId = (
					SELECT TOP 1 [OrderTemplateFrequencyId]
					FROM OrderTemplateFrequencies
					WHERE [FrequencyId] = @FrequencyId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
		END
		-- Get Value form OBR and Create entry in HealthDataTemplates and related tables
		DECLARE Cursor_HealthDataOBROrder CURSOR LOCAL FAST_FORWARD
		FOR
				SELECT dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars)
					,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.1[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars)
				FROM @MessageXML.nodes('HL7Message/OBR') AS T(item)
				where dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.1[1]/ITEM[1]', 'VARCHAR(100)'), @HL7EncChars) is not null
					or dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars) <> 'PDF'
		  
		OPEN Cursor_HealthDataOBROrder
		
		FETCH NEXT
			FROM Cursor_HealthDataOBROrder
			INTO @OrderCode
				,@OrderTestName
				

			WHILE @@Fetch_status = 0
			BEGIN
				-- Insert into HealthDataTemplates
				IF NOT EXISTS (
						SELECT 1
						FROM HealthDataTemplates
						WHERE TemplateName = @OrderTestName
							AND OrderCode = @OrderCode
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO HealthDataTemplates (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,TemplateName
						,Active
						,NumberOfColumns
						,IsLabOrder
						,LoincCode
						,OrderCode
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderTestName
						,'Y'
						,1
						,'Y'
						,''
						,@OrderCode
						)

					SET @HealthDataTemplateId = (
							SELECT TOP 1 HealthDataTemplateId
							FROM HealthDataTemplates
							WHERE TemplateName = @OrderTestName
								AND OrderCode = @OrderCode
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
				END
				ELSE
				BEGIN
					SET @HealthDataTemplateId = (
							SELECT TOP 1 HealthDataTemplateId
							FROM HealthDataTemplates
							WHERE TemplateName = @OrderTestName
								AND OrderCode = @OrderCode
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
				END
				
				IF NOT EXISTS (
						SELECT 1
						FROM HealthDataSubTemplates
						WHERE Name = @OrderTestName
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO HealthDataSubTemplates (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,Name
						,Active
						,IsHeading
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderTestName
						,'Y'
						,NULL
						)
						
						SET @HealthDataSubTemplateId = (
							SELECT max(HealthDataSubTemplateId)
							FROM HealthDataSubTemplates
							WHERE Name = @OrderTestName
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
				END
				ELSE
				BEGIN
					SET @HealthDataSubTemplateId = (
							SELECT max(HealthDataSubTemplateId)
							FROM HealthDataSubTemplates
							WHERE Name = @OrderTestName
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
				END
				
				IF NOT EXISTS (
						SELECT 1
						FROM HealthDataTemplateAttributes
						WHERE HealthDataSubTemplateId = @HealthDataSubTemplateId
							AND HealthDataTemplateId = @HealthDataTemplateId
						)
				BEGIN
					INSERT INTO HealthDataTemplateAttributes (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,HealthDataSubTemplateId
						,HealthDataTemplateId
						,HealthDataGroup
						,EntryDisplayOrder
						,ShowCompletedCheckBox
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@HealthDataSubTemplateId
						,@HealthDataTemplateId
						,0
						,1
						,'N'
						)
				END

				-- Insert into Orders and related tables
				IF NOT EXISTS (
						SELECT 1
						FROM Orders
						WHERE OrderName = @OrderTestName
							AND LabId = @HealthDataTemplateId
							AND AlternateOrderName1 = @OrderCode
							AND isnull(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO Orders (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,OrderName
						,OrderType
						,CanBeCompleted
						,CanBePended
						,HasRationale
						,HasComments
						,Active
						,MedicationNameId
						,ProcedureCodeId
						,ShowOnWhiteBoard
						,NeedsDiagnosis
						,LabId
						,AlternateOrderName1
						,AlternateOrderName2
						,DualSignRequired
						,OrderLevelRequired
						,LegalStatusRequired
						,IsSelfAdministered
						,AdhocOrder
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderTestName
						,6481
						,'N'
						,'N'
						,'N'
						,'N'
						,'Y'
						,NULL
						,NULL
						,'N'
						,'Y'
						,@HealthDataTemplateId
						,@OrderCode
						,NULL
						,NULL
						,NULL
						,NULL
						,NULL
						,NULL
						)
				END

				SET @OrderId = (
						SELECT TOP 1 OrderId
						FROM Orders
						WHERE OrderName = @OrderTestName
							AND LabId = @HealthDataTemplateId
							AND AlternateOrderName1 = @OrderCode
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)

				IF NOT EXISTS (
						SELECT 1
						FROM OrderLabs
						WHERE OrderId = @OrderId
							AND LaboratoryId = @LabId
							AND isnull(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO OrderLabs (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,OrderId
						,LaboratoryId
						,OrderCode
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderId
						,@LabId
						,@OrderCode
						)
				END

				IF NOT EXISTS (
						SELECT 1
						FROM OrderFrequencies
						WHERE OrderId = @OrderId
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO OrderFrequencies (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,OrderId
						,OrderTemplateFrequencyId
						,IsDefault
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderId
						,@OrderTemplateFrequencyId
						,'Y'
						)
				END

				IF NOT EXISTS (
						SELECT 1
						FROM OrderPriorities
						WHERE OrderId = @OrderId
							AND PriorityId = 8510
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO OrderPriorities (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,OrderId
						,PriorityId
						,IsDefault
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderId
						,8510
						,'Y'
						)
				END

				IF NOT EXISTS (
						SELECT 1
						FROM OrderSchedules
						WHERE OrderId = @OrderId
							AND ScheduleId = 8512
							AND ISNULL(RecordDeleted, 'N') = 'N'
						)
				BEGIN
					INSERT INTO OrderSchedules (
						CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						,OrderId
						,ScheduleId
						,IsDefault
						)
					VALUES (
						@UserCode
						,GETDATE()
						,@UserCode
						,GETDATE()
						,@OrderId
						,8512
						,'Y'
						)
				END

				--------------------
				-- Get Value of OBX inside OBR header and Create entry in HealthDataAttributes and related tables
				DECLARE Cursor_HealthAttrOBXOrder CURSOR LOCAL FAST_FORWARD
				FOR
					SELECT m.c.value('OBX.3[1]/OBX.3.0[1]/ITEM[1]', 'nvarchar(max)') AS LOINCCode
					,m.c.value('OBX.3[1]/OBX.3.1[1]/ITEM[1]', 'nvarchar(max)') AS AttributeName
					,m.c.value('OBX.1[1]/OBX.1.0[1]/ITEM[1]', 'VARCHAR(200)') as SequenceNo
					FROM @MessageXML.nodes('HL7Message/OBR[OBR.4/OBR.4.0/ITEM =sql:variable("@OrderCode")]/OBX') AS m(c)
					Where 
					(isnull(m.c.value('OBX.5[1]/OBX.5.2[1]/ITEM[1]', 'VARCHAR(200)'),'') <> 'PDF'	
					and isnull(m.c.value('OBX.5[1]/OBX.5.3[1]/ITEM[1]', 'VARCHAR(200)'),'') <> 'Base64') or
					(isnull(m.c.value('OBX.5[1]/OBX.5.0[1]/ITEM[1]', 'VARCHAR(200)'),'') <> 'PDF'	
					and isnull(m.c.value('OBX.5[1]/OBX.5.1[1]/ITEM[1]', 'VARCHAR(200)'),'') <> 'Base64')

				OPEN Cursor_HealthAttrOBXOrder
					
					FETCH NEXT
					FROM Cursor_HealthAttrOBXOrder
					INTO @LOINCCode
						,@AttributeName
						,@AttributeSeq

					WHILE @@Fetch_status = 0
					BEGIN
						IF NOT EXISTS (
								SELECT 1
								FROM HealthDataAttributes
								WHERE Name = @AttributeName
									AND LOINCCode = @LOINCCode
									AND ISNULL(RecordDeleted, 'N') = 'N'
								)
						BEGIN
							INSERT INTO HealthDataAttributes (
								CreatedBy
								,CreatedDate
								,ModifiedBy
								,ModifiedDate
								,Category
								,DataType
								,Name
								,[Description]
								,Units
								,NumberOfParameters
								,Formula
								,NumbersAfterDecimal
								,DropDownCategory
								,IsSingleLineTextBox
								,LOINCCode
								,AlternativeName1
								,AlternativeName2
								,AlternativeName3
								,AlternativeName4
								,AlternativeName5
								,AlternativeName6
								)
							VALUES (
								@UserCode
								,GETDATE()
								,@UserCode
								,GETDATE()
								,8229
								,8084
								,@AttributeName
								,@AttributeName
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,@LOINCCode
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								,NULL
								)
						END

						SET @HealthDataAttributeId = (
								SELECT max(HealthDataAttributeId)
								FROM HealthDataAttributes
								WHERE Name = @AttributeName
									AND LOINCCode = @LOINCCode
									AND ISNULL(RecordDeleted, 'N') = 'N'
								)

						IF NOT EXISTS (
								SELECT 1
								FROM HealthDataSubTemplateAttributes
								WHERE HealthDataSubTemplateId = @HealthDataSubTemplateId
									AND HealthDataAttributeId = @HealthDataAttributeId
									AND ISNULL(RecordDeleted, 'N') = 'N'
								)
						BEGIN
							INSERT INTO HealthDataSubTemplateAttributes (
								CreatedBy
								,CreatedDate
								,ModifiedBy
								,ModifiedDate
								,HealthDataSubTemplateId
								,HealthDataAttributeId
								,DisplayInFlowSheet
								,OrderInFlowSheet
								,IsSingleLineDisplay
								)
							VALUES (
								@UserCode
								,GETDATE()
								,@UserCode
								,GETDATE()
								,@HealthDataSubTemplateId
								,@HealthDataAttributeId
								,'Y'
								,@AttributeSeq
								,'N'
								)
						END

						FETCH NEXT
						FROM Cursor_HealthAttrOBXOrder
						INTO @LOINCCode
							,@AttributeName
							,@AttributeSeq
					END
				

				CLOSE Cursor_HealthAttrOBXOrder

				DEALLOCATE Cursor_HealthAttrOBXOrder

				FETCH NEXT
				FROM Cursor_HealthDataOBROrder
				INTO @OrderCode
					,@OrderTestName
			END

		CLOSE Cursor_HealthDataOBROrder

		DEALLOCATE Cursor_HealthDataOBROrder

		INSERT INTO Observations (
			CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,ObservationName
			,ObservationMethodIdentifier
			)
		SELECT HDA.CreatedBy
			,HDA.CreatedDate
			,HDA.ModifiedBy
			,HDA.ModifiedDate
			,HDA.NAME
			,HDA.LOINCCode
		FROM HealthDataAttributes HDA
		WHERE HDA.LOINCCode IS NOT NULL
			AND NOT EXISTS (
				SELECT 1
				FROM Observations O
				WHERE O.ObservationMethodIdentifier = HDA.LOINCCode
				)
	END TRY

	BEGIN CATCH
		

		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_LabCreateOrdersAndTemplates') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END
GO

