/****** Object:  StoredProcedure [dbo].[SSP_GetPotentialMatchingClientOrders]    Script Date: 08/24/2016 00:22:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetPotentialMatchingClientOrders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetPotentialMatchingClientOrders]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetPotentialMatchingClientOrders]    Script Date: 08/24/2016 00:22:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetPotentialMatchingClientOrders] @HL7CPQueueMessageID INT
	,@ClientId INT
	/********************************************************************************                                                        
-- Stored Procedure: SSP_GetPotentialMatchingClientOrders      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to return order information   
--      
-- Author:  Neha      
-- Date:    Oct 15 2018      

*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @InboundMessage XML
			,@HL7EncChars CHAR(5) = '|^~\&'

		--,@HL7CPQueueMessageID INT = 29092
		--,@ClientId INT = 31761
		SELECT @InboundMessage = MessageXML
		FROM HL7CPQueueMessages
		WHERE HL7CPQueueMessageID = @HL7CPQueueMessageID

		CREATE TABLE #IncomingOrderInformation (
			ClientOrderId INT
			,OrderName VARCHAR(500)
			,OrderCode VARCHAR(200)
			,OrderDateTime VARCHAR(20)
			,OrderingPhysicianNPI VARCHAR(250)
			,OrderingPhysicianLastName VARCHAR(250)
			,OrderingPhysicianFirstName VARCHAR(250)
			)

		INSERT INTO #IncomingOrderInformation
		SELECT Cast(dbo.HL7_INBOUND_XFORM(T.item.value('OBR.2[1]/OBR.2.0[1]/ITEM[1]', 'VARCHAR(20)'), @HL7EncChars) AS INT) AS ClientOrderId
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.1[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderName
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.4[1]/OBR.4.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS LoincCode
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.7[1]/OBR.7.0[1]/ITEM[1]', 'Varchar(MAX)'), @HL7EncChars) AS OrderStartDateTime
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.0[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderingPhysicianNPI
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.1[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderingPhysicianLastName
			,dbo.HL7_INBOUND_XFORM(T.item.value('OBR.16[1]/OBR.16.2[1]/ITEM[1]', 'Varchar(100)'), @HL7EncChars) AS OrderingPhysicianFirstName
		FROM @InboundMessage.nodes('HL7Message/OBR') AS T(item)

		--SELECT *
		--FROM #IncomingOrderInformation
		CREATE TABLE #ExistingOrderInformation (
			ClientOrderId INT
			,OrderName VARCHAR(500)
			,OrderCode VARCHAR(200)
			,OrderDateTime VARCHAR(20)
			,OrderingPhysicianNPI VARCHAR(250)
			,OrderingPhysicianLastName VARCHAR(250)
			,OrderingPhysicianFirstName VARCHAR(250)
			,OrderStatus VARCHAR(50)
			)

		INSERT INTO #ExistingOrderInformation
		SELECT CO.ClientOrderId
			,O.OrderName
			,HDT.OrderCode
			,CAST(CO.OrderStartDateTime AS VARCHAR(20))
			,sl.LicenseNumber
			,S.LastName
			,S.FirstName
			,CO.OrderStatus
		FROM ClientOrders CO
		INNER JOIN Orders O ON O.OrderId = CO.OrderId
			AND ISNULL(O.RecordDeleted, 'N') = 'N'
		INNER JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
			AND ISNULL(HDT.RecordDeleted, 'N') = 'N'
		INNER JOIN staff s ON s.StaffId = CO.OrderingPhysician
		INNER JOIN StaffLicenseDegrees sl ON s.StaffId = sl.StaffId
			AND SL.LicenseTypeDegree = 9408
		WHERE dbo.ssf_GetGlobalCodeNameById(O.OrderType) = 'Labs'
			AND CO.ClientId = @ClientId

		--SELECT *
		--FROM #ExistingOrderInformation
		SELECT e.ClientOrderId AS ClientOrderId
			,e.OrderName AS OrderName
			,e.OrderCode AS OrderCode
			,e.OrderDateTime AS OrderDateTime
			,e.OrderingPhysicianLastName + ', ' + e.OrderingPhysicianFirstName + ' (' + e.OrderingPhysicianNPI + ')' AS OrderingPhysician
			,dbo.ssf_GetGlobalCodeNameById(e.OrderStatus) AS OrderStatus
			,CASE e.OrderStatus
				WHEN 6504 -- Results Obtained
					THEN 'N'
				ELSE 'Y'
				END AS PotentialOrderMatch
		FROM #ExistingOrderInformation e
		LEFT JOIN #IncomingOrderInformation i ON e.OrderCode = i.OrderCode
		ORDER BY ClientOrderId

		DROP TABLE #IncomingOrderInformation

		DROP TABLE #ExistingOrderInformation
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetPotentialMatchingClientOrders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


