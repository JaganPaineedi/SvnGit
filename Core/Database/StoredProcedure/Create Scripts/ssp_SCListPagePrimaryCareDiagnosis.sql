/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePrimaryCareDiagnosis]    Script Date: 02/21/2014 16:00:15 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPagePrimaryCareDiagnosis]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPagePrimaryCareDiagnosis]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPagePrimaryCareDiagnosis]    Script Date: 02/21/2014 16:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPagePrimaryCareDiagnosis] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientID INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@ICD9 VARCHAR(100)
	,@ICD10 VARCHAR(100)
	,@SNOMED VARCHAR(100)
	,@Description VARCHAR(1000)
	,@SNOMEDDescription VARCHAR(100)
	,@OtherFilter INT
	/*********************************************************************             
** Stored Procedure: dbo.ssp_SCListPagePrimaryCareDiagnosis             
** Created By: Chethan N
** Creation Date:  Jun 18 2014
**             
** Purpose: retrieves data for Primary Care Diagnosis List Page under My Client Tab.
**             
** Updates:              
**  Date         Author      Purpose 
/*2014-07-25	vkhare		Remove New problem Field from list page 	
/*2014-08-11	vkhare		Remove time form Data field  	*/		drop table 								*/  
**********************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1)
		DECLARE @CustomFilters TABLE (ClientProblemDiagnosisHistory INT)

		SET @CustomFiltersApplied = 'N'

		IF @Description = ''
			SET @Description = NULL

		--SET @ToDate= DATEADD(DD,1,@ToDate)
		CREATE TABLE #ResultSet (
			ClientProblemDiagnosisHistory INT
			,[Date] DATETIME
			,DSMCode CHAR(6)
			,ICD10Code VARCHAR(20)
			,SNOMEDCTCode VARCHAR(25)
			,ICDDescription VARCHAR(1000)
			,SNOMEDCTDescription VARCHAR(1000)
			)

		--GET CUSTOM FILTERS           
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (ClientProblemDiagnosisHistory)
			EXEC scsp__SCListPagePrimaryCareDiagnosis @ClientID = @ClientID
				,@FromDate = @FromDate
				,@ToDate = @ToDate
				,@ICD9 = @ICD9
				,@ICD10 = @ICD10
				,@SNOMED = @SNOMED
				,@Description = @Description
				,@SNOMEDDescription = @SNOMEDDescription
				,@OtherFilter=@OtherFilter
		END

		INSERT INTO #ResultSet (
			ClientProblemDiagnosisHistory
			,[Date]
			,DSMCode
			,ICD10Code
			,SNOMEDCTCode
			,ICDDescription
			,SNOMEDCTDescription
			)
		SELECT CPDH.ClientProblemDiagnosisHistory AS ClientProblemDiagnosisHistory
			,CONVERT(VARCHAR(10), CASE 
					WHEN CPDH.[Date] IS NULL
						THEN (
								SELECT d.EffectiveDate
								FROM Documents d
								WHERE CurrentDocumentVersionId = CPDH.DocumentVersionId
								)
					ELSE CPDH.[Date]
					END, 110) AS [Date]
			,CPDH.DSMCode AS ICD9
			,CPDH.ICD10Code AS ICD10
			,CPDH.SNOMEDCODE AS SNOMEDCODE
			,DICD.ICDDescription AS ICD10Description
			,SNC.SNOMEDCTDescription AS SNOMEDdescription
		FROM ClientProblemsDiagnosisHistory CPDH
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId = CPDH.DocumentVersionId
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
		INNER JOIN Documents D ON D.DocumentId = DV.DocumentId
			AND D.[ClientId] = @ClientID
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
		LEFT JOIN DiagnosisICD10Codes DICD ON DICD.ICD10CodeId = CPDH.ICD10CodeId
		
		--INNER JOIN DocumentDiagnosisCodes DDC on DDC.ICD10CodeId =  CPDH.ICD10CodeId
		LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CPDH.SNOMEDCODE
			
		WHERE ISNULL(CPDH.RecordDeleted, 'N') = 'N'
			AND (
				(DICD.ICDDescription LIKE '%' + @Description + '%')
				OR (@Description IS NULL)
				)
			AND (
				(SNC.SNOMEDCTDescription LIKE '%' + @SNOMEDDescription + '%')
				OR (@SNOMEDDescription IS NULL)
				)
			AND CAST(CASE 
					WHEN CPDH.[Date] IS NULL
						THEN (
								SELECT d.EffectiveDate
								FROM Documents d
								WHERE CurrentDocumentVersionId = CPDH.DocumentVersionId
								)
					ELSE CPDH.[Date]
					END AS DATE) >= @FromDate
			AND CAST(CASE 
					WHEN CPDH.[Date] IS NULL
						THEN (
								SELECT d.EffectiveDate
								FROM Documents d
								WHERE CurrentDocumentVersionId = CPDH.DocumentVersionId
								)
					ELSE CPDH.[Date]
					END AS DATE) <= @ToDate
			AND ISNULL(CPDH.NewProblem, 'N') = 'Y'
			AND (
				(CPDH.ICD10Code LIKE '%' + @ICD10 + '%')
				OR (@ICD10 IS NULL)
				)
			AND (
				(CPDH.DSMCode LIKE '%' + @ICD9 + '%')
				OR (@ICD9 IS NULL)
				)
			AND (
				(SNC.SNOMEDCTCode LIKE '%' + @SNOMED + '%')
				OR (@SNOMED IS NULL)
				)
			AND (
				@CustomFiltersApplied = 'N'
				OR (
					@CustomFiltersApplied = 'Y'
					AND CPDH.ClientProblemDiagnosisHistory IN (
						SELECT ClientProblemDiagnosisHistory
						FROM @CustomFilters
						)
					)
				);

		WITH counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT ClientProblemDiagnosisHistory
				,CONVERT(VARCHAR(10), [Date], 101) AS DATE
				
				,DSMCode
				,ICD10Code
				,SNOMEDCTCode
				,ICDDescription
				,SNOMEDCTDescription
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = '[Date]'
								THEN [Date]
							END
						,CASE 
							WHEN @SortExpression = '[Date] desc'
								THEN [Date]
							END DESC
						,CASE 
							WHEN @SortExpression = 'DSMCode'
								THEN DSMCode
							END
						,CASE 
							WHEN @SortExpression = 'DSMCode desc'
								THEN DSMCode
							END DESC
						,CASE 
							WHEN @SortExpression = 'ICD10Code'
								THEN ICD10Code
							END
						,CASE 
							WHEN @SortExpression = 'ICD10Code desc'
								THEN ICD10Code
							END DESC
						,CASE 
							WHEN @SortExpression = 'SNOMEDCTCode'
								THEN SNOMEDCTCode
							END
						,CASE 
							WHEN @SortExpression = 'SNOMEDCTCode desc'
								THEN SNOMEDCTCode
							END DESC
						,CASE 
							WHEN @SortExpression = 'ICDDescription'
								THEN ICDDescription
							END
						,CASE 
							WHEN @SortExpression = 'ICDDescription desc'
								THEN ICDDescription
							END DESC
						,CASE 
							WHEN @SortExpression = 'SNOMEDCTDescription'
								THEN SNOMEDCTDescription
							END
						,CASE 
							WHEN @SortExpression = 'SNOMEDCTDescription desc'
								THEN SNOMEDCTDescription
							END DESC
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(Totalrows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) ClientProblemDiagnosisHistory
			,[Date]
			,DSMCode
			,ICD10Code
			,SNOMEDCTCode
			,ICDDescription
			,SNOMEDCTDescription
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
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
					END NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT ClientProblemDiagnosisHistory
			,CONVERT(VARCHAR(10), [Date], 101) AS [Date]
			,DSMCode
			,ICD10Code
			,SNOMEDCTCode
			,ICDDescription
			,SNOMEDCTDescription
		FROM #FinalResultSet
		ORDER BY Rownumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPagePrimaryCareDiagnosis') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,
				-- Message text.                                            
				16
				,-- Severity.                                            
				1 -- State.                                            
				);
	END CATCH
END
GO


