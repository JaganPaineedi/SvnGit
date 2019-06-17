/****** Object:  StoredProcedure [dbo].[SSP_ListLabSoftMessageInterface]    Script Date: 03/02/2016 18:02:16 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_ListLabSoftMessageInterface]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_ListLabSoftMessageInterface]
GO

/****** Object:  StoredProcedure [dbo].[SSP_ListLabSoftMessageInterface]    Script Date: 03/02/2016 18:02:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_ListLabSoftMessageInterface]
	/********************************************************************************                                                            
-- Stored Procedure: SSP_ListLabSoftMessageInterface          
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: Query to return data for HL7 Message from HL7CPQueueMessages        
--          
-- Author:  PradeepA          
-- Date:    Aug 08 2014          
--           
-- *****History****          
-- Author:    Date			Reason          
-- PradeepA   Feb 25 2016   Created for LabSoft implementation    
*********************************************************************************/
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@MessageStatus INT
	,@ProcessingStatus INT
	,@ClientId INT
	,@OtherFilter INT
AS
BEGIN
	BEGIN TRY
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'LabSoftMessageId'
		SET NOCOUNT ON;

		PRINT @SortExpression

		CREATE TABLE #LabSoftMessages (LabSoftMessageId INT)

		IF @OtherFilter > 10000
		BEGIN
			INSERT INTO #LabSoftMessages (LabSoftMessageId)
			EXEC Scsp_ListMessageInterface @OtherFilter = @OtherFilter
		END;

		WITH TotalMessages
		AS (
			SELECT DISTINCT LSM.LabSoftMessageId AS LabSoftMessageId
				,C.LastName + ', ' + C.FirstName AS ClientName
				,O.OrderName AS OrderName
				,GCS.CodeName AS MessageStatus
				,GCPS.CodeName AS MessageProcessingState
			FROM LabSoftMessages LSM
			INNER JOIN LabSoftMessageLinks LSML ON LSML.LabSoftMessageId = LSM.LabSoftMessageId
			LEFT JOIN ClientOrders CO ON CO.ClientOrderId = LSM.ClientOrderId
			LEFT JOIN Clients C ON C.ClientId = CO.ClientId
			LEFT JOIN Orders O ON O.OrderId = CO.OrderId
			LEFT JOIN GlobalCodes GCS ON GCS.GlobalCodeId = LSM.MessageStatus
			LEFT JOIN GlobalCodes GCPS ON GCPS.GlobalCodeId = LSM.MessageProcessingState
			WHERE (
					LSM.MessageStatus = @MessageStatus
					OR ISNULL(@MessageStatus, - 1) = - 1
					)
				AND (
					LSM.MessageProcessingState = @ProcessingStatus
					OR ISNULL(@ProcessingStatus, - 1) = - 1
					)
				AND (
					CO.ClientId = @ClientId
					OR ISNULL(@ClientId, - 1) = - 1
					)
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND ISNULL(LSM.RecordDeleted, 'N') = 'N'
				AND ISNULL(CO.RecordDeleted, 'N') = 'N'
				AND ISNULL(O.RecordDeleted, 'N') = 'N'
				AND ISNULL(LSML.RecordDeleted, 'N') = 'N'
				AND ISNULL(GCS.RecordDeleted, 'N') = 'N'
				AND ISNULL(GCPS.RecordDeleted, 'N') = 'N'
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalMessages
			)
			,ListHl7Messages
		AS (
			SELECT LabSoftMessageId
				,ClientName
				,OrderName
				,MessageStatus
				,MessageProcessingState
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'LabSoftMessageId'
								THEN LabSoftMessageId
							END
						,CASE 
							WHEN @SortExpression = 'LabSoftMessageId DESC'
								THEN LabSoftMessageId
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
				) LabSoftMessageId
			,ClientName
			,OrderName
			,MessageStatus
			,MessageProcessingState
			,TotalCount
			,RowNumber
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

		SELECT LabSoftMessageId
			,ClientName
			,OrderName
			,MessageStatus
			,MessageProcessingState
		FROM #FinalResultSet

		DROP TABLE #FinalResultSet

		DROP TABLE #LabSoftMessages
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_ListLabSoftMessageInterface') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


