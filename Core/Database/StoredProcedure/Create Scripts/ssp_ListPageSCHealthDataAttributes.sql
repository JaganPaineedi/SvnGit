/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCHealthDataAttributes]    Script Date: 19-09-2018 18:11:11 ******/
IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCHealthDataAttributes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	DROP PROCEDURE [dbo].[ssp_ListPageSCHealthDataAttributes]
END
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCHealthDataAttributes]    Script Date: 19-09-2018 18:11:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCHealthDataAttributes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_ListPageSCHealthDataAttributes] AS'
END
GO

ALTER PROCEDURE [dbo].[ssp_ListPageSCHealthDataAttributes] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@HealthDataCategory INT
	,@DataTypeId INT
	,@OtherFilter INT
	,@ElementName VARCHAR(100) = null
	/*********************************************************************************/
	/* Stored Procedure: ssp_ListPageSCHealthDataAttributes         */
	/* Copyright: Streamline Healthcare Solutions          */
	/* Creation Date:  16-AUG-2012               */
	/* Purpose: used by Health Data Attributes List Page For Staff        */
	/* Input Parameters:                */
	/* Output Parameters:PageNumber,PageSize,SortExpression,@HealthDataCategory,@DataTypeId  */
	/*      OtherFilter*/
	/* Return:                      */
	/* Called By:         */
	/* Calls:                   */
	/* Data Modifications:                */
	/* Updates:                   */
	/* Date              Author                  Purpose        */
	/* 16-AUG-2012       Rohit Katoch    Created        */
	/* 21-AUG-2012       Rohit Katoch    Modified  logic getting and sorting page     */
	/* 20-SEPT-2018      Neha            Added a new filter @ElementName to search based on Name and Description w.r.t Task EII 716. */
	/*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		--  
		--Declare table to get data if Other filter exists -------  
		--  
		CREATE TABLE #HealthDataAttributes (HealthDataAttributeId INT)

		--Get custom filters                                                  
		IF @OtherFilter > 10000
		BEGIN
			INSERT INTO #HealthDataAttributes
			EXEC scsp_ListPageSCHealthDataAttributes @OtherFilter = @OtherFilter
		END
				--                                 
				--Insert data in to temp table which is fetched below by appling filter.     
				--   
				;

		WITH TotalHealthDataAttributes
		AS (
			SELECT HDA.HealthDataAttributeId
				,dbo.csf_GetGlobalCodeNameById(HDA.Category) AS Category
				,HDA.Name
				,HDA.Description
				,dbo.csf_GetGlobalCodeNameById(HDA.DataType) AS DataType
			FROM HealthDataAttributes AS HDA
			WHERE ISNULL(HDA.RecordDeleted, 'N') = 'N'
				AND (
					HDA.Category = @HealthDataCategory
					OR ISNULL(@HealthDataCategory, 0) = 0
					)
				AND (
					HDA.DataType = @DataTypeId
					OR ISNULL(@DataTypeId, 0) = 0
					)
				AND (
					@ElementName IS NULL
					OR HDA.Name LIKE '%' + @ElementName + '%'
					OR HDA.Description LIKE '%' + @ElementName + '%'
					)
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalHealthDataAttributes
			)
			,LisHealthDataAttributes
		AS (
			SELECT HealthDataAttributeId
				,Category
				,Name
				,Description
				,DataType
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'Name'
								THEN Name
							END
						,CASE 
							WHEN @SortExpression = 'Name desc'
								THEN Name
							END DESC
						,CASE 
							WHEN @SortExpression = 'DataType'
								THEN DataType
							END
						,CASE 
							WHEN @SortExpression = 'DataType desc'
								THEN DataType
							END DESC
						,CASE 
							WHEN @SortExpression = 'Category'
								THEN Category
							END
						,CASE 
							WHEN @SortExpression = 'Category desc'
								THEN Category
							END DESC
						,CASE 
							WHEN @SortExpression = 'Description'
								THEN Description
							END
						,CASE 
							WHEN @SortExpression = 'Description desc'
								THEN Description
							END DESC
					) AS RowNumber
			FROM TotalHealthDataAttributes
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
				) HealthDataAttributeId
			,Category
			,Name
			,Description
			,DataType
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM LisHealthDataAttributes
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

		SELECT HealthDataAttributeId
			,Category
			,Name
			,Description
			,DataType
		FROM #FinalResultSet
		ORDER BY RowNumber

		DROP TABLE #FinalResultSet

		DROP TABLE #HealthDataAttributes
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageSCHealthDataAttributes') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


