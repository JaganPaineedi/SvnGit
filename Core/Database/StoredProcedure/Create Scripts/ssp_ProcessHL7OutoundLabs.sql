/****** Object:  StoredProcedure [dbo].[ssp_ProcessHL7OutoundLabs]    Script Date: 9/25/2018 8:56:31 AM ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ProcessHL7OutoundLabs]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ProcessHL7OutoundLabs]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ProcessHL7OutoundLabs]    Script Date: 9/25/2018 8:56:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ProcessHL7OutoundLabs] @DocumentVersionId INT
	,@CurrentUser VARCHAR(30)
	-- =============================================        
	-- Author:  Shankha        
	-- Create date: Mar 02, 2015       
	-- Description: Process ADT Outbound Message based on Client Allergy Updates
	-- ================================================================
	/*  Date            Author      Purpose								
	Oct 12 2018	    Gautam		Created , 	Gulf Bend - Enhancements, #211	
*/
	-- ================================================================
AS
BEGIN
	BEGIN TRY
		IF (@DocumentVersionId > 0)
		BEGIN
			DECLARE @ClientOrderId INT
				,@VendorId INT
				,@MessageRaw NVARCHAR(Max)
				,@UserCode VARCHAR(100) = 'HL7 Lab Interface'
				,@ClientId INT
				,@StoredProcedureName NVARCHAR(400)
				,@sqlStr NVARCHAR(max)
				,@SeparateMessagePerOrder VARCHAR(1)
				,@OrderNo VARCHAR(300)

			CREATE TABLE #VendorDetailsHL7 (
				Id INT identity(1, 1)
				,VendorId INT
				,StoredProcedureName VARCHAR(250)
				,SeparateMessagePerOrder VARCHAR(1)
				,OrderNo VARCHAR(300)

				)

			CREATE TABLE #LabOrderDetails (
				Id INT identity(1, 1)
				,ClientOrderId INT
				,ClientId INT
				,VendorId INT
				,StoredProcedureName VARCHAR(250)
				,SeparateMessagePerOrder VARCHAR(1)
				,OrderNo VARCHAR(300)
				)

			INSERT INTO #LabOrderDetails (
				ClientOrderId
				,ClientId
				,VendorId
				,StoredProcedureName
				,OrderNo
				)
			SELECT cO.ClientOrderId
				,cO.ClientId
				,l.VendorId
				,m.StoredProcedureName
				,CN.OrderNumber
			FROM ClientOrders CO
			--JOIN OrderLabs oL on cO.OrderId = oL.OrderId
			JOIN Laboratories l ON CO.LaboratoryId = l.LaboratoryId
			JOIN HL7CPMessageConfigurations m ON l.VendorId = m.VendorId
				AND m.MessageType = 'ORM'
			JOIN ClientOrderOrderNumbers CN ON CN.ClientOrderId = CO.ClientOrderId
				AND ISNULL(CN.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes G ON G.GlobalCodeId = l.InterfaceType
				AND G.Code <> 'LABSOFT' -- Select NonLabSoft order
			WHERE CO.DocumentVersionId = @DocumentVersionId
				AND cO.OrderType = 'Labs'
				AND cO.OrderStatus <> 6503
				AND ISNULL(cO.RecordDeleted, 'N') = 'N'
				--AND ISNULL(oL.RecordDeleted, 'N') = 'N'
				AND ISNULL(l.RecordDeleted, 'N') = 'N'
				AND ISNULL(m.RecordDeleted, 'N') = 'N'
				--and CAST(OrderStartDateTime AS DATE) >= cast(Getdate() as date)  
				AND CAST(OrderStartDateTime AS DATE) <= dateadd(d, ISNULL(l.SendRecurringOrdersNoOfDaysInAdvance, 7), cast(Getdate() AS DATE))
			ORDER BY l.VendorId

		
			UPDATE #LabOrderDetails
			SET SeparateMessagePerOrder = Isnull(H.SeparateMessagePerOrder, 'Y')
			FROM #LabOrderDetails L
			JOIN HL7CPVendorConfigurations H ON L.VendorId = H.VendorId

			INSERT INTO #VendorDetailsHL7 (
				VendorId
				,StoredProcedureName
				,SeparateMessagePerOrder
				,OrderNo				
				)
			SELECT DISTINCT VendorId
				,StoredProcedureName
				,SeparateMessagePerOrder
				,OrderNo
			FROM #LabOrderDetails

			IF EXISTS (
					SELECT 1
					FROM #LabOrderDetails
					WHERE SeparateMessagePerOrder = 'Y'
					)
			BEGIN
				DECLARE TempLabOrders CURSOR LOCAL SCROLL STATIC
				FOR
				SELECT ClientOrderId
					,ClientId
					,VendorId
					,StoredProcedureName
					,SeparateMessagePerOrder
				FROM #LabOrderDetails
				WHERE SeparateMessagePerOrder = 'Y'

				OPEN TempLabOrders

				FETCH NEXT
				FROM TempLabOrders
				INTO @ClientOrderId
					,@ClientId
					,@VendorId
					,@StoredProcedureName
					,@SeparateMessagePerOrder

				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @sqlStr = 'EXEC ' + @StoredProcedureName + ' ' + cast(@VendorId AS NVARCHAR(max)) + ',' + cast(@ClientOrderId AS NVARCHAR(max)) + ', 8746' + ' ,' + cast(@SeparateMessagePerOrder AS NVARCHAR(max)) + ',@outputMessage OUTPUT'

					PRINT @sqlStr

					EXECUTE sp_executesql @sqlStr
						,N'@outputMessage nvarchar(max) OUTPUT'
						,@MessageRaw OUTPUT

					IF Isnull(@MessageRaw, '') != ''
					BEGIN
						-- Insert the record in message queue    
						EXEC SSP_SCInsertHL7_MessageForProcessing @VendorId
							,8610
							,@MessageRaw
							,@UserCode
							,@ClientId
							,6347 -- ORM  
							,8746 -- O01  
							,8747 -- CLIENTORDERS  
							,@DocumentVersionId

						/*Update ClientOrder.OrderStatus = Sent To Lab */
						UPDATE ClientOrders
						SET OrderStatus = 6503
							,OrderFlag = 'Y'
							,ModifiedBy = @UserCode
							,ModifiedDate = GETDATE()
						WHERE ClientOrderId = @ClientOrderId
					END

					SET @MessageRaw = NULL

					FETCH NEXT
					FROM TempLabOrders
					INTO @ClientOrderId
						,@ClientId
						,@VendorId
						,@StoredProcedureName
						,@SeparateMessagePerOrder
				END

				CLOSE TempLabOrders

				DEALLOCATE TempLabOrders
			END


			Select * from #LabOrderDetails

			IF EXISTS (
					SELECT 1
					FROM #LabOrderDetails
					WHERE SeparateMessagePerOrder = 'N'
					)
			BEGIN
				DECLARE TempLabOrders1 CURSOR LOCAL SCROLL STATIC
				FOR
				SELECT VendorId
					,StoredProcedureName
					,SeparateMessagePerOrder
					,OrderNo					
				FROM #VendorDetailsHL7
				GROUP BY VendorId
					,StoredProcedureName
					,SeparateMessagePerOrder
					,OrderNo

				OPEN TempLabOrders1

				FETCH NEXT
				FROM TempLabOrders1
				INTO @VendorId
					,@StoredProcedureName
					,@SeparateMessagePerOrder
					,@OrderNo

				WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT TOP 1 @ClientOrderId = ClientOrderId
					FROM #LabOrderDetails
					WHERE VendorId = @VendorId
						AND OrderNo = @OrderNo

					SET @sqlStr = 'EXEC ' + @StoredProcedureName + ' ' + cast(@VendorId AS NVARCHAR(max)) + ',' + cast(@ClientOrderId AS NVARCHAR(max)) + ', 8746' + ' ,''' + cast(@SeparateMessagePerOrder AS NVARCHAR(max)) + ''',@outputMessage OUTPUT'

					PRINT @sqlStr

					EXECUTE sp_executesql @sqlStr
						,N'@outputMessage nvarchar(max) OUTPUT'
						,@MessageRaw OUTPUT

					IF Isnull(@MessageRaw, '') != ''
					BEGIN
						-- Insert the record in message queue    
						EXEC SSP_SCInsertHL7_MessageForProcessing @VendorId
							,8610
							,@MessageRaw
							,@UserCode
							,@ClientId
							,6347 -- ORM  
							,8746 -- O01  
							,8747 -- CLIENTORDERS  
							,@DocumentVersionId

						/*Update ClientOrder.OrderStatus = Sent To Lab */
						UPDATE C
						SET C.OrderStatus = 6503
							,C.OrderFlag = 'Y'
							,C.ModifiedBy = @UserCode
							,C.ModifiedDate = GETDATE()
						FROM ClientOrders C
						JOIN #LabOrderDetails L ON C.ClientOrderId = L.ClientOrderId
						WHERE L.VendorId = @VendorId
							AND OrderNo = @OrderNo
					END

					SET @MessageRaw = NULL

					FETCH NEXT
					FROM TempLabOrders1
					INTO @VendorId
						,@StoredProcedureName
						,@SeparateMessagePerOrder
						,@OrderNo
				END

				CLOSE TempLabOrders1

				DEALLOCATE TempLabOrders1
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ProcessHL7OutoundLabs') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		INSERT INTO ErrorLog (
			ErrorMessage
			,VerboseInfo
			,DataSetInfo
			,ErrorType
			,CreatedBy
			,CreatedDate
			)
		VALUES (
			@Error
			,NULL
			,NULL
			,'HL7 Procedure Error'
			,'SmartCare'
			,GetDate()
			)
	END CATCH
END
GO


