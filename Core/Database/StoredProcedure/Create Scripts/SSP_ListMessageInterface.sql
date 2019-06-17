/****** Object:  StoredProcedure [dbo].[SSP_ListMessageInterface]    Script Date: 08/24/2016 00:22:19 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_ListMessageInterface]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_ListMessageInterface]
GO

/****** Object:  StoredProcedure [dbo].[SSP_ListMessageInterface]    Script Date: 08/24/2016 00:22:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_ListMessageInterface]
	/********************************************************************************                                                        
-- Stored Procedure: SSP_ListMessageInterface      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to return data for HL7 Message from HL7CPQueueMessages    
--      
-- Author:  PradeepA      
-- Date:    Aug 08 2014      
--       
-- *****History****      
-- Author:    Date   Reason      
-- PradeepA   Aug 08 2014   Crated for #171 (Philhaven Development)  
-- Pavani      13-Jun-2016   Added Clientid column for the  Engineering Improvement Initiatives- NBL(I) task#362
-- Chathan N  Aug 26 2016	What : 1. Added date filter.2.Added a column for error reason.
--							Why : Bradford - Customizations: #269
-- MD		  03/27/2019    What: Added condition HCPQML.EntityType = 8747 (CLIENTORDERS) to display only Client Orders related result.
--							Why: Journey-Support Go Live #355.2	
*********************************************************************************/
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@MessageType INT
	,@EventType INT
	,@VendorId INT
	,@MessageStatus INT
	,@ProcessingStatus INT
	,@Direction INT
	,@ClientId INT
	,@FromDate DateTime
	,@ToDate DateTime
	,@OtherFilter INT
AS
BEGIN
	BEGIN TRY
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'HL7CPQueueMessageID'
		SET NOCOUNT ON;

		PRINT @SortExpression

		CREATE TABLE #MessageInterface (HL7CPQueueMessageID INT)

		IF @OtherFilter > 10000
		BEGIN
			INSERT INTO #MessageInterface (HL7CPQueueMessageID)
			EXEC Scsp_ListMessageInterface @OtherFilter = @OtherFilter
		END;

		WITH TotalMessages
		AS (
			SELECT DISTINCT HCPQM.HL7CPQueueMessageID AS HL7CPQueueMessageID
				,C.LastName + ', ' + C.FirstName + ' (' + Cast(C.ClientId AS VARCHAR(MAX)) + ')' AS ClientName
				,O.OrderName AS OrderName
				,HCPVC.VendorName AS VendorName
				,GCD.CodeName AS Direction
				,GCM.CodeName AS MessageType
				,GCE.CodeName AS EventType
				,GCS.CodeName AS MessageStatus
				,GCPS.CodeName AS MessageProcessingState
				--Pavani 13-Jun-2016 
				,C.ClientId
				,ErrorDescription
				,PC.LastName + ', ' + PC.FirstName + ' (' + Cast(PC.ClientId AS VARCHAR(MAX)) + ')' as PotentialClient
				,PC.ClientId as PotentialClientId
				,HCPQM.FivePointMatch
			FROM HL7CPQueueMessages HCPQM
			LEFT JOIN Clients C ON C.ClientId = HCPQM.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
			LEFT JOIN HL7CPQueueMessageLinks HCPQML ON HCPQML.HL7CPQueueMessageId = HCPQM.HL7CPQueueMessageID
				AND ISNULL(HCPQML.RecordDeleted, 'N') = 'N' 
				-- Added by MD on 03/27/2019
				AND HCPQML.EntityType = 8747 -- CLIENTORDERS
			LEFT JOIN ClientOrders CO ON CO.ClientOrderId = HCPQML.EntityId
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
			LEFT JOIN Orders O ON O.OrderId = CO.OrderId
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
			LEFT JOIN HL7CPVendorConfigurations HCPVC ON HCPVC.VendorId = HCPQM.CPVendorConnectorID
				AND ISNULL(HCPVC.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes GCD ON GCD.GlobalCodeId = HCPQM.Direction
				AND ISNULL(GCD.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes GCM ON GCM.GlobalCodeId = HCPQM.MessageType
				AND ISNULL(GCM.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes GCE ON GCE.GlobalCodeId = HCPQM.EventType
				AND ISNULL(GCE.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes GCS ON GCS.GlobalCodeId = HCPQM.MessageStatus
				AND ISNULL(GCS.RecordDeleted, 'N') = 'N'
			LEFT JOIN GlobalCodes GCPS ON GCPS.GlobalCodeId = HCPQM.MessageProcessingState
				AND ISNULL(GCPS.RecordDeleted, 'N') = 'N'
			LEFT JOIN Clients pc ON pc.ClientId = HCPQM.PotentialClientId 
				AND ISNULL(pc.RecordDeleted, 'N') = 'N'
			WHERE (
					HCPQM.MessageType = @MessageType
					OR ISNULL(@MessageType, - 1) = - 1
					)
				AND (
					HCPQM.EventType = @EventType
					OR ISNULL(@EventType, - 1) = - 1
					)
				AND (
					HCPQM.Direction = @Direction
					OR ISNULL(@Direction, - 1) = - 1
					)
				AND (
					HCPQM.CPVendorConnectorID = @VendorId
					OR ISNULL(@VendorId, - 1) = - 1
					)
				AND (
					HCPQM.MessageStatus = @MessageStatus
					OR ISNULL(@MessageStatus, - 1) = - 1
					)
				AND (
					HCPQM.MessageProcessingState = @ProcessingStatus
					OR ISNULL(@ProcessingStatus, - 1) = - 1
					)
				AND (
					HCPQM.ClientId = @ClientId
					OR ISNULL(@ClientId, - 1) = - 1
					)
				AND CAST(HCPQM.CreatedDate AS date) >= @FromDate
				AND CAST(HCPQM.CreatedDate AS date) <= @ToDate
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalMessages
			)
			,ListHl7Messages
		AS (
			SELECT HL7CPQueueMessageID
				,ClientName
				,OrderName
				,VendorName
				,Direction
				,MessageType
				,EventType
				,MessageStatus
				,MessageProcessingState
				--Pavani 13-Jun-2016
				,ClientId
				,ErrorDescription
				,PotentialClient
				,PotentialClientId
				,FivePointMatch
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'HL7CPQueueMessageID'
								THEN HL7CPQueueMessageID
							END
						,CASE 
							WHEN @SortExpression = 'HL7CPQueueMessageID DESC'
								THEN HL7CPQueueMessageID
							END DESC
						,CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName DESC'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'OrderName'
								THEN OrderName
							END
						,CASE 
							WHEN @SortExpression = 'OrderName DESC'
								THEN OrderName
							END DESC
						,CASE 
							WHEN @SortExpression = 'VendorName'
								THEN VendorName
							END
						,CASE 
							WHEN @SortExpression = 'VendorName DESC'
								THEN VendorName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Direction'
								THEN Direction
							END
						,CASE 
							WHEN @SortExpression = 'Direction DESC'
								THEN Direction
							END DESC
						,CASE 
							WHEN @SortExpression = 'MessageType'
								THEN MessageType
							END
						,CASE 
							WHEN @SortExpression = 'MessageType DESC'
								THEN MessageType
							END DESC
						,CASE 
							WHEN @SortExpression = 'EventType'
								THEN EventType
							END
						,CASE 
							WHEN @SortExpression = 'EventType DESC'
								THEN EventType
							END DESC
						,CASE 
							WHEN @SortExpression = 'MessageStatus'
								THEN MessageStatus
							END
						,CASE 
							WHEN @SortExpression = 'MessageStatus DESC'
								THEN MessageStatus
							END DESC
						,CASE 
							WHEN @SortExpression = 'MessageProcessingState'
								THEN MessageProcessingState
							END
						,CASE 
							WHEN @SortExpression = 'MessageProcessingState DESC'
								THEN MessageProcessingState
							END DESC
					    ,CASE 
							WHEN @SortExpression = 'PotentialClient'
								THEN PotentialClient
							END
						,CASE 
							WHEN @SortExpression = 'PotentialClient DESC'
								THEN PotentialClient
							END DESC
					) AS RowNumber
			FROM TotalMessages
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) HL7CPQueueMessageID
			,ClientName
			,OrderName
			,VendorName
			,Direction
			,MessageType
			,EventType
			,MessageStatus
			,MessageProcessingState
			,TotalCount
			,RowNumber
			--Pavani 13-Jun-2016
			,ClientId
			,ErrorDescription
			,PotentialClient
			,PotentialClientId
			,FivePointMatch
		INTO #FinalResultSet
		FROM ListHl7Messages
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT HL7CPQueueMessageID
			,ClientName
			,OrderName
			,VendorName
			,Direction
			,MessageType
			,EventType
			,MessageStatus
			,MessageProcessingState
			--Pavani 13-Jun-2016
			,ClientId
			,ErrorDescription
			,PotentialClient
			,PotentialClientId
			,FivePointMatch
		FROM #FinalResultSet

		DROP TABLE #FinalResultSet

		DROP TABLE #MessageInterface
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_ListMessageInterface') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


