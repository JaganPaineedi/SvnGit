/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateLabSoftTests]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateLabSoftTests]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCUpdateLabSoftTests] 
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateLabSoftTests]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCUpdateLabSoftTests] @LabSoftTestsXML XML
,@CreatedBy VARCHAR(50)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Nov 24, 2015      
-- Description: Update/Refresh LabSoft Tests in SmartCare
/*      
 Author			Modified Date			Reason      
 Pradeep		01/22/2016				NeedsDiagnosis is updated as 'Y'
 Pradeep		02/18/2016				Logic added for OrderAcknowledgments
 Pradeep 		11/17/2016				Modified to make entry in Orderlabs insted LoincCodeOrders
 Pradeep	     02/02/2017				Modified to handle incase of existing HealthDataTempaltes which was creatiing duplicate Orders
 Pradeep		11/07/2017			     Modified to Create HealthDataTemplates and Orders entry based on the Lab. 
								     So Orders and HealthDataTemplates table will have multiple entry against different lab
 Shankha		May 08 2018				Modified logic to identify whether HealthDataTempaltes exits for a given Lab's External Order Id and OrderCode combination
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @ReferenceLab VARCHAR(500)
		DECLARE @OrderCode VARCHAR(100)
		DECLARE @OrderTestName VARCHAR(500)
		DECLARE @Loinc VARCHAR(100)
		DECLARE @CPT VARCHAR(500)
		DECLARE @TestID VARCHAR(100)
		
		DECLARE @TranName VARCHAR(25) = 'CreateHealthDataTemplate'
		DECLARE @HealthDataTemplateId INT
		DECLARE @HealthDataSubTemplateId INT
		DECLARE @OrderId INT
		DECLARE @Active CHAR(1) = 'Y'
		DECLARE @LabId VARCHAR(100)
		
		DECLARE @DefaultOrderTemplateFrequencyId INT
		DECLARE @DefaultOrderPriorityId INT
		DECLARE @DefaultOrderScheduleId INT
		
		IF NOT EXISTS(SELECT 1
		FROM dbo.ssf_RecodeValuesCurrent('ORDERFREQUENCIES'))
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('ORDERFREQUENCIES Recode is not setup','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		IF NOT EXISTS(SELECT 1
		FROM dbo.ssf_RecodeValuesCurrent('ORDERPRIORITIES'))
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('ORDERPRIORITIES Recode is not setup','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		IF NOT EXISTS(SELECT 1
		FROM dbo.ssf_RecodeValuesCurrent('ORDERSCHEDULES'))
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('ORDERPRIORITIES Recode is not setup','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		IF NOT EXISTS(SELECT 1
		FROM dbo.ssf_RecodeValuesCurrent('ORDERACKNOWLEDGMENTROLES'))
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('ORDERACKNOWLEDGMENTROLES Recode is not setup','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		SELECT @DefaultOrderTemplateFrequencyId =  dbo.ssf_GetSystemConfigurationKeyValue('DEFAULTORDERTEMPLATEFREQUENCYID')
		SELECT @DefaultOrderPriorityId = dbo.ssf_GetSystemConfigurationKeyValue('DEFAULTORDERPRIORITYID')
		SELECT @DefaultOrderScheduleId = dbo.ssf_GetSystemConfigurationKeyValue('DEFAULTORDERSCHEDULEID')
		
		IF ISNULL(@DefaultOrderTemplateFrequencyId,'') = ''
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('DefaultOrderTemplateFrequencyId key/value is missing','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		IF ISNULL(@DefaultOrderPriorityId,'') = ''
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('DefaultOrderPriorityId key/value is missing','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		IF ISNULL(@DefaultOrderScheduleId,'') = ''
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('DefaultOrderScheduleId key/value is missing','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END
		
		IF NOT EXISTS(SELECT 1 FROM dbo.ssf_RecodeValuesCurrent('ORDERACKNOWLEDGMENTROLES'))
		BEGIN
			INSERT INTO LabSoftEventLog(ErrorMessage,VerboseInfo,ErrorType,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
			VALUES ('No Acknowledgement Roles are configured for releasing the Pended Orders','ssp_SCUpdateLabSoftTests','LabSoftStoredProcedureError',@CreatedBy,GetDate(),@CreatedBy,GetDate())
			RETURN;
		END		
		
		DECLARE labs CURSOR LOCAL FAST_FORWARD FOR
			SELECT LTRIM(RTRIM(LSLabs.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:ID)[1])', 'VARCHAR(100)')))
			,LTRIM(RTRIM(LSLabs.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:LabName)[1])', 'VARCHAR(500)')))	
			FROM @LabSoftTestsXML.nodes('/LabSoftTestAndAsks/RefLabs//RefLab') LSLabs(Col)
		OPEN labs
		WHILE 1 = 1
		BEGIN
			FETCH labs INTO @LabId,@ReferenceLab
			IF @@fetch_status <> 0 BREAK
			-- ======================================
			IF NOT EXISTS(SELECT 1 FROM Laboratories WHERE LaboratoryName = @ReferenceLab)
			BEGIN
				INSERT INTO Laboratories(LaboratoryName,ReferenceLabId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT @ReferenceLab,@LabId,@CreatedBy,GetDate(),@CreatedBy,GetDate()
			END
			ELSE
			BEGIN
				UPDATE Laboratories SET ReferenceLabId = @LabId, LaboratoryName = @ReferenceLab
				WHERE ReferenceLabId = @LabId
			END
			-- ======================================	
		END
		CLOSE labs
		DEALLOCATE labs
		
		DECLARE labtests CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT LTRIM(RTRIM(LSTests.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:ReferenceLab)[1])', 'VARCHAR(500)')))
			,LTRIM(RTRIM(LSTests.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:OrderCode)[1])', 'VARCHAR(100)')))
			,LTRIM(RTRIM(LSTests.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:OrderTestName)[1])', 'VARCHAR(500)')))
			,LTRIM(RTRIM(LSTests.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:Loinc)[1])', 'VARCHAR(100)')))
			,LTRIM(RTRIM(LSTests.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:CPT)[1])', 'VARCHAR(500)') ))
			,LTRIM(RTRIM(LSTests.Col.value('declare namespace x="https://www.mylabsync.com/webservices/eLink";data((x:TestID)[1])','VARCHAR(100)')))
		FROM @LabSoftTestsXML.nodes('/LabSoftTestAndAsks/RefLabTests//RefLabTest') LSTests(Col)

		OPEN labtests

		WHILE 1 = 1
		BEGIN
			FETCH labtests
			INTO @ReferenceLab
				,@OrderCode
				,@OrderTestName
				,@Loinc
				,@CPT
				,@TestID

			IF @@fetch_status <> 0
				BREAK

			-- =====================================================
			-- If Health data template not exists with the OrderCode
			-- =====================================================
			IF NOT EXISTS (
					SELECT 1
					FROM HealthDataTemplates HDT
					JOIN Orders O On O.LabId = HDT.HealthDataTemplateId
					JOIN OrderLabs OL On OL.OrderId = O.OrderId
					JOIN Laboratories L On L.LaboratoryId = OL.LaboratoryId
					WHERE LTRIM(RTRIM(TemplateName)) = LTRIM(RTRIM(@OrderTestName))
						AND LTRIM(RTRIM(OL.OrderCode)) = LTRIM(RTRIM(@OrderCode))
						AND LTRIM(RTRIM(L.LaboratoryName)) = LTRIM(RTRIM(@ReferenceLab))
						AND LTRIM(RTRIM(OL.ExternalOrderId)) = LTRIM(RTRIM(@TestID))						
						AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
						AND ISNULL(O.RecordDeleted, 'N') = 'N'
						AND ISNULL(OL.RecordDeleted, 'N') = 'N'	
						AND ISNULL(L.RecordDeleted, 'N') = 'N'
						AND HDT.Active = 'Y'
					)
			BEGIN
				BEGIN TRANSACTION @TranName
				
				INSERT INTO HealthDataTemplates(TemplateName,Active,NumberOfColumns,IsLabOrder,LoincCode,OrderCode,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT @OrderTestName,@Active,3,'Y',@Loinc,@OrderCode,@CreatedBy,GetDate(),@CreatedBy,GetDate()
				SET @HealthDataTemplateId = SCOPE_IDENTITY()
				
				INSERT INTO HealthDataSubTemplates(Name,Active,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT @OrderTestName,@Active,@CreatedBy,GetDate(),@CreatedBy,GetDate()
				SET @HealthDataSubTemplateId = SCOPE_IDENTITY()
				
				INSERT INTO HealthDataTemplateAttributes(HealthDataTemplateId,HealthDataSubTemplateId,HealthDataGroup,EntryDisplayOrder,ShowCompletedCheckBox,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT @HealthDataTemplateId,@HealthDataSubTemplateId,0,1,'N',@CreatedBy,GetDate(),@CreatedBy,GetDate()
				
				/*IF NOT EXISTS(SELECT 1 FROM Orders O WHERE O.OrderName = @OrderTestName AND ISNULL(O.RecordDeleted,'N')= 'N' AND Active = 'Y' AND LabId =@HealthDataTemplateId)
				BEGIN
					INSERT INTO Orders(OrderName,OrderType,Active,LabId,CanBePended,CanBeCompleted,HasRationale,HasComments,
					ShowOnWhiteBoard,NeedsDiagnosis,IsBillable,AddOrderToMAR,Prescription,Permissioned,Sensitive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
					SELECT @OrderTestName,6481,@Active,@HealthDataTemplateId,'Y','N','N','Y','N','Y','N','N','N','N','N',@CreatedBy,GETDATE(),@CreatedBy,GETDATE()
					SET @OrderId = SCOPE_IDENTITY()
					
					EXEC ssp_DoOrderConfigurations @OrderId,@DefaultOrderPriorityId,@DefaultOrderScheduleId,@DefaultOrderTemplateFrequencyId,@CreatedBy					
				END
				ELSE
				BEGIN
					SELECT @OrderId = OrderId 
					FROM Orders WHERE OrderName = @OrderTestName  AND LabId = @HealthDataTemplateId
					AND ISNULL(RecordDeleted,'N')= 'N' 
					AND Active = 'Y'
				END*/
				
				IF EXISTS(SELECT 1 FROM Orders O WHERE O.OrderName = @OrderTestName AND OrderType = 6481 AND ISNULL(O.RecordDeleted,'N')= 'N' AND Active = 'Y')
				BEGIN
					UPDATE Orders 
					SET LabId = @HealthDataTemplateId
					WHERE OrderName = @OrderTestName AND ISNULL(RecordDeleted,'N')= 'N' AND Active = 'Y' AND OrderType = 6481
					
					SELECT @OrderId = OrderId 
					FROM Orders WHERE OrderName = @OrderTestName  AND LabId = @HealthDataTemplateId
					AND ISNULL(RecordDeleted,'N')= 'N' 
					AND Active = 'Y'									
				END
				ELSE
				BEGIN
					INSERT INTO Orders(OrderName,OrderType,Active,LabId,CanBePended,CanBeCompleted,HasRationale,HasComments,
					ShowOnWhiteBoard,NeedsDiagnosis,IsBillable,AddOrderToMAR,Prescription,Permissioned,Sensitive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
					SELECT @OrderTestName,6481,@Active,@HealthDataTemplateId,'Y','N','N','Y','N','Y','N','N','N','N','N',@CreatedBy,GETDATE(),@CreatedBy,GETDATE()
					SET @OrderId = SCOPE_IDENTITY()
					
					EXEC ssp_DoOrderConfigurations @OrderId,@DefaultOrderPriorityId,@DefaultOrderScheduleId,@DefaultOrderTemplateFrequencyId,@CreatedBy	
				END	
							
				INSERT INTO OrderLabs(OrderId,LaboratoryId,ExternalOrderId,IsDefault,CPT,OrderCode,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
				SELECT @OrderId,(SELECT TOP 1 LaboratoryId FROM Laboratories L WHERE L.LaboratoryName = @ReferenceLab AND ISNULL(L.RecordDeleted,'N')='N'),@TestID,'Y',@CPT,@OrderCode,@CreatedBy,GetDate(),@CreatedBy,GetDate()
				
				COMMIT TRANSACTION @TranName
			END
			ELSE
			BEGIN
				BEGIN TRANSACTION @TranName
				IF EXISTS (SELECT 1 FROM HealthDataTemplates HDT 
						 JOIN Orders O On O.LabId = HDT.HealthDataTemplateId
						 JOIN OrderLabs OL On OL.OrderId = O.OrderId
						 JOIN Laboratories L On L.LaboratoryId = OL.LaboratoryId
					      WHERE LTRIM(RTRIM(TemplateName)) = LTRIM(RTRIM(@OrderTestName))
						 AND LTRIM(RTRIM(OL.OrderCode)) = LTRIM(RTRIM(@OrderCode))
						 AND LTRIM(RTRIM(L.LaboratoryName)) = LTRIM(RTRIM(@ReferenceLab))
						 AND LTRIM(RTRIM(OL.ExternalOrderId)) = LTRIM(RTRIM(@TestID))
						 AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
						 AND ISNULL(O.RecordDeleted, 'N') = 'N'
						 AND ISNULL(OL.RecordDeleted, 'N') = 'N'
						 AND ISNULL(L.RecordDeleted, 'N') = 'N'
						 AND HDT.Active = 'Y'
					)
				BEGIN
					SELECT @HealthDataTemplateId=HealthDataTemplateId FROM HealthDataTemplates HDT 
					      JOIN Orders O On O.LabId = HDT.HealthDataTemplateId
						 JOIN OrderLabs OL On OL.OrderId = O.OrderId
						 JOIN Laboratories L On L.LaboratoryId = OL.LaboratoryId
					WHERE LTRIM(RTRIM(TemplateName)) = LTRIM(RTRIM(@OrderTestName))
						AND LTRIM(RTRIM(OL.OrderCode)) = LTRIM(RTRIM(@OrderCode))
						AND LTRIM(RTRIM(L.LaboratoryName)) = LTRIM(RTRIM(@ReferenceLab))
						AND LTRIM(RTRIM(OL.ExternalOrderId)) = LTRIM(RTRIM(@TestID))
						AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
						AND ISNULL(O.RecordDeleted, 'N') = 'N'
						AND ISNULL(OL.RecordDeleted, 'N') = 'N'
						AND ISNULL(L.RecordDeleted, 'N') = 'N'
						AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
						AND HDT.Active = 'Y'
						
					IF NOT EXISTS(SELECT 1 FROM Orders O Where LabId = @HealthDataTemplateId AND ISNULL(O.RecordDeleted, 'N') = 'N'
						AND O.Active = 'Y'  AND LabId =@HealthDataTemplateId)
					BEGIN
					
						INSERT INTO Orders(OrderName,OrderType,Active,LabId,CanBePended,CanBeCompleted,HasRationale,HasComments,
						ShowOnWhiteBoard,NeedsDiagnosis,IsBillable,AddOrderToMAR,Prescription,Permissioned,Sensitive,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
						SELECT @OrderTestName,6481,@Active,@HealthDataTemplateId,'Y','N','N','Y','N','Y','N','N','N','N','N',@CreatedBy,GETDATE(),@CreatedBy,GETDATE()
						SET @OrderId = SCOPE_IDENTITY()
						
						IF NOT EXISTS(Select 1 FROM OrderLabs Where OrderId = @OrderId AND ISNULL(RecordDeleted,'N')= 'N')
						BEGIN
							INSERT INTO OrderLabs(OrderId,LaboratoryId,ExternalOrderId,IsDefault,CPT,OrderCode,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
							SELECT @OrderId,(SELECT TOP 1 LaboratoryId FROM Laboratories L WHERE L.LaboratoryName = @ReferenceLab AND ISNULL(L.RecordDeleted,'N')='N'),@TestID,'Y',@CPT,@OrderCode,@CreatedBy,GetDate(),@CreatedBy,GetDate()
						END
						EXEC ssp_DoOrderConfigurations @OrderId,@DefaultOrderPriorityId,@DefaultOrderScheduleId,@DefaultOrderTemplateFrequencyId,@CreatedBy		
					END
					ELSE
					BEGIN					
						SELECT TOP 1 @OrderId = OrderId 
						FROM Orders O 
						JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = O.LabId
						WHERE ISNULL(HDT.RecordDeleted,'N')= 'N' 
							AND HDT.HealthDataTemplateId = @HealthDataTemplateId
							AND HDT.Active = 'Y'
							AND ISNULL(O.RecordDeleted,'N')= 'N' 
							AND O.Active = 'Y'

						IF NOT EXISTS(Select 1 FROM OrderLabs Where OrderId = @OrderId AND ISNULL(RecordDeleted,'N')= 'N')
						BEGIN
							INSERT INTO OrderLabs(OrderId,LaboratoryId,ExternalOrderId,IsDefault,CPT,OrderCode,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
							SELECT @OrderId,(SELECT TOP 1 LaboratoryId FROM Laboratories L WHERE L.LaboratoryName = @ReferenceLab AND ISNULL(L.RecordDeleted,'N')='N'),@TestID,'Y',@CPT,@OrderCode,@CreatedBy,GetDate(),@CreatedBy,GetDate()
						END
						EXEC ssp_DoOrderConfigurations @OrderId,@DefaultOrderPriorityId,@DefaultOrderScheduleId,@DefaultOrderTemplateFrequencyId,@CreatedBy		
					END
				END
				COMMIT TRANSACTION @TranName
			END
		END

		CLOSE labtests

		DEALLOCATE labtests
	END TRY

	BEGIN CATCH
		IF EXISTS (
				SELECT 1
				FROM Sys.dm_tran_active_transactions
				WHERE NAME = @TranName
				)
		ROLLBACK TRANSACTION @TranName
		
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateLabSoftTests') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


