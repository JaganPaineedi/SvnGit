 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCListPageBedCensusOverlappingPrograms')
	BEGIN
		DROP  Procedure  ssp_SCListPageBedCensusOverlappingPrograms
	END
GO
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageBedCensusOverlappingPrograms]
(
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)	
	,@ProgramId INT	
	,@OtherFilter INT	
	)
	/********************************************************************************                                                 
** Stored Procedure: ssp_SCListPageBedCensusOverlappingPrograms                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 22-DEC-2015	   Akwinass			   What:Get Overlapping Programs    
**									   Why:Task #50 in Woods - Customizations 
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
	
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'
		
		IF OBJECT_ID('tempdb..#FinalResultSet') IS NOT NULL
			DROP TABLE #FinalResultSet

		IF OBJECT_ID('tempdb..#OverlappingPrograms') IS NOT NULL
			DROP TABLE #OverlappingPrograms

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ProgramName ASC'
		    
		CREATE TABLE #OverlappingPrograms (BedAssignmentOverlappingProgramMappingId INT NOT NULL)

		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_GetClientFeeListData', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'
				
				INSERT INTO #OverlappingPrograms (BedAssignmentOverlappingProgramMappingId)
				EXEC scsp_GetClientFeeListData @PageNumber = @PageNumber
					,@PageSize = @PageSize
					,@SortExpression = @SortExpression
					,@ProgramId = @ProgramId
					,@OtherFilter = @OtherFilter

			END
		END;

		WITH TotalOverlappingPrograms
		AS (
				SELECT DISTINCT BAOPM.BedAssignmentOverlappingProgramMappingId
					,BAOPM.ProgramId
					,BAOPM.OverlappingProgramId	
					,P1.ProgramName
					,P2.ProgramName	AS OverlappingProgramName
				FROM BedAssignmentOverlappingProgramMappings BAOPM
				JOIN Programs P1 ON BAOPM.ProgramId = P1.ProgramId AND ISNULL(P1.RecordDeleted, 'N') = 'N' AND ISNULL(P1.Active, 'N') = 'Y'
				LEFT JOIN Programs P2 ON BAOPM.OverlappingProgramId = P2.ProgramId AND ISNULL(P2.RecordDeleted, 'N') = 'N' AND ISNULL(P2.Active, 'N') = 'Y'
				WHERE (
						(
							@CustomFiltersApplied = 'Y'
							AND EXISTS (
								SELECT *
								FROM #OverlappingPrograms OP
								WHERE OP.BedAssignmentOverlappingProgramMappingId = BAOPM.BedAssignmentOverlappingProgramMappingId
								)
							)
						OR (
							@CustomFiltersApplied = 'N'
							AND (ISNULL(@ProgramId, 0) = 0 OR BAOPM.ProgramId = @ProgramId)
							AND ISNULL(BAOPM.RecordDeleted, 'N') = 'N'
							)
						)


			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalOverlappingPrograms
			)
			,ClientFeeList
		AS (
			SELECT DISTINCT BedAssignmentOverlappingProgramMappingId
				,ProgramId
				,OverlappingProgramId	
				,ProgramName	
				,OverlappingProgramName						
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY
						CASE 
							WHEN @SortExpression = 'ProgramName'
								THEN ProgramName
							END					
						,CASE 
							WHEN @SortExpression = 'ProgramName desc'
								THEN ProgramName
							END DESC,
						CASE 
							WHEN @SortExpression = 'OverlappingProgramName'
								THEN OverlappingProgramName
							END					
						,CASE 
							WHEN @SortExpression = 'OverlappingProgramName desc'
								THEN OverlappingProgramName
							END DESC,BedAssignmentOverlappingProgramMappingId
					) AS RowNumber
			FROM TotalOverlappingPrograms
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
				) BedAssignmentOverlappingProgramMappingId
			,ProgramId
			,OverlappingProgramId
			,ProgramName	
			,OverlappingProgramName				
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM ClientFeeList
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)
		
		IF @PageSize=0 OR @PageSize=-1
		BEGIN
			SELECT @PageSize=COUNT(*) FROM #FinalResultSet
		END

		IF (SELECT ISNULL(COUNT(*), 0) FROM #FinalResultSet) < 1
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

		SELECT BedAssignmentOverlappingProgramMappingId
			,ProgramId
			,OverlappingProgramId
			,ProgramName	
			,OverlappingProgramName	
		FROM #FinalResultSet
		ORDER BY RowNumber
		
		IF OBJECT_ID('tempdb..#OverlappingPrograms') IS NOT NULL
			DROP TABLE #OverlappingPrograms			
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_SCListPageBedCensusOverlappingPrograms') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
 