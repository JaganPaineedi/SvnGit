/****** Object:  StoredProcedure [dbo].[SSP_SCSendOrderMessageToPharmacy]    Script Date: 01/13/2016 10:33:32 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCSendOrderMessageToPharmacy]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCSendOrderMessageToPharmacy]
GO

/****** Object:  StoredProcedure [dbo].[SSP_SCSendOrderMessageToPharmacy]    Script Date: 01/13/2016 10:33:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_SCSendOrderMessageToPharmacy] @DocumentVersionId INT
	,@UserCode type_CurrentUser
AS
-- =====================================================
-- Author :Pradeep
-- Create Date : 02/25/2014
-- Description : Initiate the Pharmacy Interface and Lab Interface functionality
-- History : 
-- 02/25/2014	Pradeep		Modified the Logic to get the VendorId from SystemConfigurationKeys table and implemented Lab Interface module.
-- 03/12/2014	Pradeep		Modified to have VendorId selected for Medication OrderType.
-- 07/12/2014	Pradeep		Modified to have @ClientOrderId in SSP_SCProcess_HL7_ADT_OutboundMessage to handle HL7CPQueueMessageLinks Table.
-- 29/04/2015   Shankha     Modified the logic to process Orders which are discontinued 
-- 12/01/2016   Shankha     Modified the logic to process Orders which are discontinued 
-- =====================================================
BEGIN
	BEGIN TRY
		DECLARE @VendorId INT
		DECLARE @ClientId INT
		DECLARE @EventType INT
		DECLARE @ClientOrderId INT
		DECLARE @OrderType INT
		DECLARE @OrderId INT

		CREATE TABLE #tempClientOrders (
			ClientId INT
			,ClientOrderId INT
			,OrderType INT
			,OrderId INT
			);

		WITH ClientOrderResults (
			ClientId
			,ClientOrderId
			,OrderType
			,OrderId
			)
		AS (
			SELECT D.ClientId
				,CO.ClientOrderId
				,O.OrderType
				,O.OrderId
			FROM ClientOrders CO
			JOIN Orders O ON O.OrderId = CO.OrderId
			JOIN DocumentVersions DV ON Dv.DocumentVersionId = CO.DocumentVersionId
			JOIN Documents D ON D.DocumentId = DV.DocumentId
			WHERE CO.DocumentVersionId = @DocumentVersionId
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
				AND ISNULL(DV.RecordDeleted, 'N') = 'N'
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
			
			UNION
			
			SELECT Co.ClientId
				,CO.ClientOrderId
				,O.OrderType
				,O.OrderId
			FROM ClientOrders CO
			JOIN Orders O ON O.OrderId = CO.OrderId
			JOIN DocumentVersions DV ON Dv.DocumentVersionId = CO.DocumentVersionId
			JOIN Documents D ON D.DocumentId = DV.DocumentId
			WHERE CO.ClientOrderId IN (
					SELECT newCO.PreviousClientOrderId
					FROM ClientOrders newCO
					WHERE newCO.DocumentVersionId = @DocumentVersionId						
					)
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
			)
		INSERT INTO #tempClientOrders (
			ClientId
			,ClientOrderId
			,OrderType
			,OrderId
			)
		SELECT ClientId
			,ClientOrderId
			,OrderType
			,OrderId
		FROM ClientOrderResults

		DECLARE ClientOrdersCRSR CURSOR LOCAL SCROLL STATIC
		FOR
		SELECT ClientId
			,ClientOrderId
			,OrderType
			,OrderId
		FROM #tempClientOrders

		OPEN ClientOrdersCRSR

		FETCH NEXT
		FROM ClientOrdersCRSR
		INTO @ClientId
			,@ClientOrderId
			,@OrderType
			,@OrderId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @OrderType = 8501 --Medication
			BEGIN
				-- Get the Active VendorId For Med Order.
				SELECT @VendorId = [dbo].[ssf_GetSystemConfigurationKeyValue]('MedOrderVendorId')

				IF ISNULL(@VendorId, '') <> ''
				BEGIN
					SET @EventType = 8745 --'O09' 

					EXEC SSP_SCProcess_HL7_Order_OutboundMessages @VendorId
						,@ClientId
						,@EventType
						,@ClientOrderId
						,@UserCode
				END
			END
			ELSE IF @OrderType = 6481 --Lab
			BEGIN
				-- Get the Active VendorId For Lab Order.				
				SELECT @VendorId = [dbo].[ssf_GetSystemConfigurationKeyValue]('LabOrderVendorId')

				IF ISNULL(@VendorId, '') <> ''
				BEGIN
					SET @EventType = 8746 --'O01'						

					EXEC SSP_SCProcess_HL7_ORM_OutboundMessage @VendorId
						,@ClientId
						,@EventType
						,@ClientOrderId
						,@UserCode
				END
			END
			ELSE IF @OrderType = 8503
			BEGIN
				SELECT @VendorId = [dbo].[ssf_GetSystemConfigurationKeyValue]('MedOrderVendorId')

				IF ISNULL(@VendorId, '') <> ''
				BEGIN
					IF EXISTS (
							SELECT 1
							FROM dbo.Orders AS O
							JOIN dbo.ssf_RecodeValuesCurrent('ADT_ADMISSION') AS cd ON cd.IntegerCodeId = O.OrderId
							WHERE O.OrderId = @OrderId
							)
					BEGIN
						SET @EventType = 8742 --'A01'
					END

					IF EXISTS (
							SELECT 1
							FROM dbo.Orders AS O
							JOIN dbo.ssf_RecodeValuesCurrent('ADT_TRANSFER') AS cd ON cd.IntegerCodeId = O.OrderId
							WHERE O.OrderId = @OrderId
							)
					BEGIN
						SET @EventType = 8743 --'A02'
					END

					IF EXISTS (
							SELECT 1
							FROM dbo.Orders AS O
							JOIN dbo.ssf_RecodeValuesCurrent('ADT_DISCHARGE') AS cd ON cd.IntegerCodeId = O.OrderId
							WHERE O.OrderId = @OrderId
							)
					BEGIN
						SET @EventType = 8744 --'A03'
					END

					IF ISNULL(@EventType, '') <> ''
						EXEC SSP_SCProcess_HL7_ADT_OutboundMessage @VendorId
							,@ClientId
							,@EventType
							,@UserCode
							,@ClientOrderId
				END
			END

			FETCH NEXT
			FROM ClientOrdersCRSR
			INTO @ClientId
				,@ClientOrderId
				,@OrderType
				,@OrderId
		END

		CLOSE ClientOrdersCRSR

		DEALLOCATE ClientOrdersCRSR
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCSendOrderMessageToPharmacy') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


