/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCUnitsRoomsBedsData]    Script Date: 08/31/2017 05:16:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCUnitsRoomsBedsData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageSCUnitsRoomsBedsData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCUnitsRoomsBedsData]    Script Date: 08/31/2017 05:16:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCUnitsRoomsBedsData] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@Active INT
	,@UnitId INT
	,@RoomId INT
	,@BedId INT
	,@OtherFilter INT
	,@LoggedInStaffId INT
	,@StaffId INT
	/*********************************************************************************/
	/* Stored Procedure: ssp_ListPageSCUnitsRoomsBedsData							 */
	/* Copyright: Streamline Healthcare Solutions									 */
	/* Creation Date:  06-June-2012													 */
	/* Purpose: used by Bed Census Main List Page For Staff							 */
	/* Input Parameters:SessionId,InstanceId,PageNumber,PageSize,SortExpression,	 */
	/*					 @Active,@UnitId,@RoomId,@BedId,@LoggedInStaffId,@StaffId    */
	/* Return:																	     */
	/* Called By: BedCensus.cs , GetMainBedCensusListPageData()						 */
	/* Calls:																		 */
	/* Data Modifications:															 */
	/* Updates:																		 */
	/* Date              Author                  Purpose							 */
	/* 06June2012		 Shifali				  Created						 */
	/* 14June2012		 Shifali				  Modified - Add RecorDeleted Filter in where clause as well along with joins	*/
	/* 18June2012		 Shifali				  Modified - Rectified Active Check Field value in listing*/
	/* 26June2012		 Vikas Kashyap			Modified - Rectified Active/Inactive Logic Check Field value in ListPage*/
	/* 2 JUN,2016		 Ravichandra			Removed the physical table  from SP
											Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
											108 - Do NOT use list page tables for remaining list pages (refer #107)	               */
											
	/* 31 Aug 2017		 Shankha				Woods - SGL # 604 (Added check EndDate in BedAvailabilityHistory join)		*/				
	/*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @ApplyFilterClicked AS CHAR(1)

		SET @ApplyFilterClicked = 'N'

		DECLARE @CustomFiltersApplied CHAR(1)

		SET @CustomFiltersApplied = 'N'
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'UnitName desc'

		CREATE TABLE #ResultSet (
			ListPageSCUnitsRoomsBedsId INT IDENTITY(1, 1) NOT NULL
			,UnitId INT
			,UnitName VARCHAR(50)
			,RoomId INT
			,RoomName VARCHAR(50)
			,BedId INT
			,BedName VARCHAR(50)
			,Active CHAR(5)
			,ProgramId INT
			,ProgramName VARCHAR(100)
			)

		DECLARE @CustomFilters TABLE (
			UnitId INT
			,RoomId INT
			,BedId INT
			)

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (
				UnitId
				,RoomId
				,BedId
				)
			EXEC scsp_ListPageSCUnitsRoomsBedsData @UnitId = @UnitId
				,@RoomId = @RoomId
				,@BedId = @BedId
				,@LoggedInStaffId = @LoggedInStaffId
		END

		INSERT INTO #ResultSet (
			UnitId
			,UnitName
			,RoomId
			,RoomName
			,BedId
			,BedName
			,Active
			,ProgramId
			,ProgramName
			)
		SELECT U.UnitId
			,U.DisplayAs
			,R.RoomId
			,R.DisplayAs
			,B.BedId
			,B.DisplayAs
			,
			--'Y',  
			CASE 
				WHEN (@Active = 5001)
					THEN 'Yes'
				WHEN (@Active = 5003)
					THEN 'No'
				WHEN (
						(
							@Active IN (
								0
								,5002
								)
							)
						AND (
							U.Active = 'Y'
							AND (
								R.UnitId IS NULL
								OR R.Active = 'Y'
								)
							AND (
								B.RoomId IS NULL
								OR B.Active = 'Y'
								)
							)
						)
					THEN 'Yes'
				ELSE 'No'
				END AS Active
			,P.ProgramId
			,P.ProgramCode
		FROM Units U
		LEFT JOIN Rooms R ON U.UnitId = R.UnitId
			AND ISNULL(U.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(R.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Beds B ON B.RoomId = R.RoomId
			AND ISNULL(R.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(B.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN BedAvailabilityHistory BAH ON B.BedId = BAH.BedId
			AND ISNULL(B.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(BAH.RecordDeleted, 'N') <> 'Y'
			AND isnull(BAH.EndDate, '12/31/2999') >= CAST(GETDATE() AS DATE)
		LEFT JOIN Programs P ON P.ProgramId = BAH.ProgramId
			AND ISNULL(BAH.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		WHERE (
				@CustomFiltersApplied = 'Y'
				AND EXISTS (
					SELECT *
					FROM @CustomFilters cf
					WHERE cf.UnitId = U.UnitId
						AND cf.RoomId = R.RoomId
						AND cf.BedId = B.BedId
					)
				)
			OR (
				@CustomFiltersApplied = 'N'
				AND ISNULL(U.RecordDeleted, 'N') <> 'Y'
				AND
				--AND ISNULL(R.RecordDeleted,'N')<>'Y'  
				--AND ISNULL(B.RecordDeleted,'N')<>'Y'  
				--AND ISNULL(BAH.RecordDeleted,'N')<>'Y'  
				--AND ISNULL(P.RecordDeleted,'N')<>'Y'   
				(
					@UnitId = - 1
					OR U.UnitId = @UnitId
					)
				AND (
					@RoomId = - 1
					OR R.RoomId = @RoomId
					)
				AND (
					@BedId = - 1
					OR B.BedId = @BedId
					)
				AND (
					@Active IN (
						0
						,5002
						)
					OR
					/*(@Active = 5001 AND U.Active = 'Y' AND R.Active = 'Y' AND B.Active = 'Y')OR  
		   (@Active = 5003 AND ISNULL(U.Active,'N') = 'N' AND ISNULL(R.Active,'N') = 'N' AND ISNULL(B.Active,'N') = 'N')*/
					(
						@Active = 5001
						AND U.Active = 'Y'
						AND (
							R.UnitId IS NULL
							OR R.Active = 'Y'
							)
						AND (
							B.RoomId IS NULL
							OR B.Active = 'Y'
							)
						)
					OR
					--(@Active = 5003 AND U.Active = 'N' AND (R.UnitId IS NULL OR R.Active = 'N') AND (B.RoomId iS NULL OR B.Active = 'N'))  
					(
						@Active = 5003
						AND (
							(U.Active = 'N')
							OR (R.Active = 'N')
							OR (B.Active = 'N')
							)
						)
					)
				)
		ORDER BY U.DisplayAs
			,R.DisplayAs
			,B.DisplayAs
			,P.ProgramCode;

		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT UnitId
				,UnitName
				,RoomId
				,RoomName
				,BedId
				,BedName
				,Active
				,ProgramId
				,ProgramName
				,Count(*) OVER () AS TotalCount
				,row_number() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'UnitName'
								THEN UnitName
							END
						,CASE 
							WHEN @SortExpression = 'UnitName desc'
								THEN UnitName
							END DESC
						,CASE 
							WHEN @SortExpression = 'RoomName'
								THEN RoomName
							END
						,CASE 
							WHEN @SortExpression = 'RoomName desc'
								THEN RoomName
							END DESC
						,CASE 
							WHEN @SortExpression = 'BedName'
								THEN BedName
							END
						,CASE 
							WHEN @SortExpression = 'BedName desc'
								THEN BedName
							END DESC
						,CASE 
							WHEN @SortExpression = 'Active'
								THEN Active
							END
						,CASE 
							WHEN @SortExpression = 'Active desc'
								THEN Active
							END DESC
						,CASE 
							WHEN @SortExpression = 'ProgramName'
								THEN ProgramName
							END
						,CASE 
							WHEN @SortExpression = 'ProgramName desc'
								THEN ProgramName
							END DESC
						,ListPageSCUnitsRoomsBedsId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT Isnull(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) UnitId
			,UnitName
			,RoomId
			,RoomName
			,BedId
			,BedName
			,Active
			,ProgramId
			,ProgramName
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT Isnull(Count(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT UnitId
			,UnitName
			,RoomId
			,RoomName
			,BedId
			,BedName
			,Active
			,ProgramId
			,ProgramName
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageSCUnitsRoomsBedsData') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, 
				ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


