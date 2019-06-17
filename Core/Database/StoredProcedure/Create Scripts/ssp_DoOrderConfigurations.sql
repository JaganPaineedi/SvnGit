/****** Object:  StoredProcedure [dbo].[ssp_DoOrderConfigurations]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_DoOrderConfigurations]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_DoOrderConfigurations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_DoOrderConfigurations]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_DoOrderConfigurations] @OrderId BIGINT
	,@DefaultOrderPriorityId INT
	,@DefaultOrderScheduleId INT
	,@DefaultOrderTemplateFrequencyId INT
	,@CreatedBy VARCHAR(50)
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Apr 25 2016   
-- Description: Order Configurations based on the Recodes entries      
/*      
 Author			Modified Date			Reason      
 Pradeep		Jan/10/2017				Modified to Set the DefaultTempalteFrequencyId.
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @IntegerCodeId INT
		DECLARE @ISDefault CHAR(1) = 'N'
		DECLARE @OrderTemplateFrequencyId INT
		DECLARE @PriorityId INT
		DECLARE @ScheduleId INT

		-- =================================================
		-- Order Frequencies
		-- =================================================
		DECLARE RecodeFrequencies CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT IntegerCodeId
		FROM dbo.ssf_RecodeValuesCurrent('ORDERFREQUENCIES')

		OPEN RecodeFrequencies

		WHILE 1 = 1
		BEGIN
			FETCH RecodeFrequencies
			INTO @IntegerCodeId

			IF @@fetch_status <> 0
				BREAK

			IF NOT EXISTS (
					SELECT 1
					FROM OrderFrequencies
					WHERE OrderTemplateFrequencyId = @IntegerCodeId
						AND OrderId = @OrderId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				IF @IntegerCodeId = @DefaultOrderTemplateFrequencyId
					SET @ISDefault = 'Y'
				ELSE
					SET @ISDefault = 'N'

				INSERT INTO OrderFrequencies (
					OrderId
					,OrderTemplateFrequencyId
					,IsDefault
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT @OrderId
					,@IntegerCodeId
					,@ISDefault
					,@CreatedBy
					,GetDate()
					,@CreatedBy
					,GetDate()
			END
			ELSE
			BEGIN
				SELECT @OrderTemplateFrequencyId = OrderTemplateFrequencyId
				FROM OrderFrequencies
				WHERE OrderTemplateFrequencyId = @IntegerCodeId
					AND OrderId = @OrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'

				IF @OrderTemplateFrequencyId = @DefaultOrderTemplateFrequencyId
					SET @ISDefault = 'Y'
				ELSE
					SET @ISDefault = 'N'

				UPDATE OrderFrequencies
				SET IsDefault = @ISDefault
				WHERE OrderTemplateFrequencyId = @IntegerCodeId
					AND OrderId = @OrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END

		CLOSE RecodeFrequencies

		DEALLOCATE RecodeFrequencies

		-- =================================================
		-- Order Priorities
		-- =================================================
		DECLARE RecodePriorities CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT IntegerCodeId
		FROM dbo.ssf_RecodeValuesCurrent('ORDERPRIORITIES')

		OPEN RecodePriorities

		WHILE 1 = 1
		BEGIN
			FETCH RecodePriorities
			INTO @IntegerCodeId

			IF @@fetch_status <> 0
				BREAK

			IF NOT EXISTS (
					SELECT 1
					FROM OrderPriorities
					WHERE PriorityId = @IntegerCodeId
						AND OrderId = @OrderId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				IF @IntegerCodeId = @DefaultOrderPriorityId
					SET @ISDefault = 'Y'
				ELSE
					SET @ISDefault = 'N'

				INSERT INTO OrderPriorities (
					OrderId
					,PriorityId
					,IsDefault
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT @OrderId
					,@IntegerCodeId
					,@ISDefault
					,@CreatedBy
					,GetDate()
					,@CreatedBy
					,GetDate()
			END
			ELSE
			BEGIN
				SELECT @PriorityId = PriorityId
				FROM OrderPriorities
				WHERE PriorityId = @IntegerCodeId
					AND OrderId = @OrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'

				IF @PriorityId = @DefaultOrderPriorityId
					SET @ISDefault = 'Y'
				ELSE
					SET @ISDefault = 'N'

				UPDATE OrderPriorities
				SET IsDefault = @ISDefault
				WHERE PriorityId = @IntegerCodeId
					AND OrderId = @OrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END

		CLOSE RecodePriorities

		DEALLOCATE RecodePriorities

		-- =================================================
		-- Order Schedules
		-- =================================================
		DECLARE RecodeSchedules CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT IntegerCodeId
		FROM dbo.ssf_RecodeValuesCurrent('ORDERSCHEDULES')

		OPEN RecodeSchedules

		WHILE 1 = 1
		BEGIN
			FETCH RecodeSchedules
			INTO @IntegerCodeId

			IF @@fetch_status <> 0
				BREAK

			IF NOT EXISTS (
					SELECT 1
					FROM OrderSchedules
					WHERE ScheduleId = @IntegerCodeId
						AND OrderId = @OrderId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				IF @IntegerCodeId = @DefaultOrderScheduleId
				BEGIN
					SET @ISDefault = 'Y'

					INSERT INTO OrderSchedules (
						OrderId
						,ScheduleId
						,IsDefault
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					SELECT @OrderId
						,@IntegerCodeId
						,@ISDefault
						,@CreatedBy
						,GetDate()
						,@CreatedBy
						,GetDate()
				END
				ELSE
				BEGIN
					SET @ISDefault = 'N'

					INSERT INTO OrderSchedules (
						OrderId
						,ScheduleId
						,IsDefault
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					SELECT @OrderId
						,@IntegerCodeId
						,@ISDefault
						,@CreatedBy
						,GetDate()
						,@CreatedBy
						,GetDate()
				END
			END
			ELSE
			BEGIN
				SELECT @ScheduleId = ScheduleId
				FROM OrderSchedules
				WHERE ScheduleId = @IntegerCodeId
					AND OrderId = @OrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'

				IF @ScheduleId = @DefaultOrderScheduleId
					SET @ISDefault = 'Y'
				ELSE
					SET @ISDefault = 'N'

				UPDATE OrderSchedules
				SET IsDefault = @ISDefault
				WHERE ScheduleId = @IntegerCodeId
					AND OrderId = @OrderId
					AND ISNULL(RecordDeleted, 'N') = 'N'
			END
		END

		CLOSE RecodeSchedules

		DEALLOCATE RecodeSchedules

		-- =================================================
		-- Order Acknowledgement Roles
		-- =================================================
		DECLARE RecodeOrderAcknowledgmentRoles CURSOR LOCAL FAST_FORWARD
		FOR
		SELECT IntegerCodeId
		FROM dbo.ssf_RecodeValuesCurrent('ORDERACKNOWLEDGMENTROLES')

		OPEN RecodeOrderAcknowledgmentRoles

		WHILE 1 = 1
		BEGIN
			FETCH RecodeOrderAcknowledgmentRoles
			INTO @IntegerCodeId

			IF @@fetch_status <> 0
				BREAK

			IF NOT EXISTS (
					SELECT 1
					FROM OrderAcknowledgments
					WHERE RoleId = @IntegerCodeId
						AND OrderId = @OrderId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					)
			BEGIN
				INSERT INTO OrderAcknowledgments (
					OrderId
					,RoleId
					,NeedsToAcknowledge
					,CanAcknowledge
					,CanPendingRelease
					,NeedsSignature
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					)
				SELECT @OrderId
					,@IntegerCodeId
					,'N'
					,'N'
					,'Y'
					,'N'
					,@CreatedBy
					,GetDate()
					,@CreatedBy
					,GetDate()
			END
		END

		CLOSE RecodeOrderAcknowledgmentRoles

		DEALLOCATE RecodeOrderAcknowledgmentRoles
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_DoOrderConfigurations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


