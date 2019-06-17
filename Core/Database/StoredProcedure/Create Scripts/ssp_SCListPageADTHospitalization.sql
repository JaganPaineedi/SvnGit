/****** Object:  StoredProcedure [dbo].[ssp_SCListPageADTHospitalization]    Script Date: 05/11/2017 16:39:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageADTHospitalization]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCListPageADTHospitalization]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageADTHospitalization]    Script Date: 05/11/2017 16:39:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageADTHospitalization] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@MessageType INT
	,@AdmissionStatus INT
	,@Hospitals VARCHAR(100)
	,@Program INT
	,@AssignedReviewer INT
	,@ClientId INT
	,@ClientName VARCHAR(100)
	,@Search VARCHAR(100)
	,@CMH INT
	,@HealthLink INT
	,@loggedInUserId INT
	,@OtherFilter INT
	/*********************************************************************               
** Stored Procedure: dbo.ssp_SCListPageADTHospitalization               
** Created By: Chethan N  
** Creation Date:  02/09/2017  
**               
** Purpose: retrieves data for ADTHospitalization screen under My Office and Client Tab.  
**               
** Updates:                
**  Date         Author      Purpose   
**********************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1)
		DECLARE @SearchLike VARCHAR(100)

		SET @SearchLike = '%' + @Search + '%'

		DECLARE @CustomFilters TABLE (ADTHospitalizationId INT)

		SET @CustomFiltersApplied = 'N'

		--SET @ToDate= DATEADD(DD,1,@ToDate)  
		CREATE TABLE #ResultSet (
			ADTHospitalizationId INT
			,ClientId INT
			,ClientName VARCHAR(100)
			,AdmissionDate DATETIME
			,DischargeDate DATETIME
			,Hospital VARCHAR(100)
			,Program VARCHAR(100)
			,AssignedReviewer VARCHAR(100)
			,
			)

		--GET CUSTOM FILTERS             
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (ADTHospitalizationId)
			EXEC scsp_SCListPageADTHospitalization @FromDate = @FromDate
				,@ToDate = @ToDate
				,@MessageType = @MessageType
				,@AdmissionStatus = @AdmissionStatus
				,@Hospitals = @Hospitals
				,@Program = @Program
				,@AssignedReviewer = @AssignedReviewer
				,@ClientId = @ClientId
				,@ClientName = @ClientName
				,@Search = @Search
				,@loggedInUserId = @loggedInUserId
				,@OtherFilter = @OtherFilter
		END

		INSERT INTO #ResultSet (
			ADTHospitalizationId
			,ClientId
			,ClientName
			,AdmissionDate
			,DischargeDate
			,Hospital
			,Program
			,AssignedReviewer
			)
		SELECT DISTINCT AH.ADTHospitalizationId
			,AH.ClientId
			,C.LastName + ', ' + C.FirstName + ' (' + CAST(AH.ClientId AS VARCHAR(MAX)) + ')' AS ClientName
			,AH.AdmissionDateTime AS AdmissionDate
			,AH.DischargeDateTime AS DischargeDate
			,AHD.Hospital AS Hospital
			,P.ProgramCode AS Program
			,st.DisplayAs AS AssignedReviewer
		FROM ADTHospitalizations AH
		JOIN ADTHospitalizationDetails AHD ON AHD.ADTHospitalizationId = AH.ADTHospitalizationId
			AND ISNULL(AHD.RecordDeleted, 'N') = 'N'
		JOIN Clients C ON C.ClientId = AH.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		JOIN StaffClients sc ON sc.ClientId = c.ClientId
			AND sc.StaffId = @loggedInUserId
		LEFT JOIN Staff st ON st.StaffId = AH.AssignedReviewerId
		LEFT JOIN ClientPrograms AS CP ON CP.ClientId = AH.ClientId
			AND CP.PrimaryAssignment = 'Y'
			AND ISNULL(CP.RecordDeleted, 'N') = 'N'
		LEFT JOIN Programs AS P ON P.ProgramId = CP.ProgramId
			AND ISNULL(P.RecordDeleted, 'N') = 'N'
		WHERE ISNULL(AH.RecordDeleted, 'N') = 'N'
			AND (isnull(@ClientName,'')=''
				OR (C.LastName LIKE '%' + @ClientName + '%')
				OR (C.FirstName LIKE '%' + @ClientName + '%')
				)
			AND (
				@ClientId = - 1
				OR C.ClientId = @ClientId
				)
			AND (
				([dbo].[ssf_IsOverlapDates](AHD.AdmissionDateTime, AHD.AdmissionDateTime, ISNULL(@FromDate, AHD.AdmissionDateTime), ISNULL(@ToDate, AHD.AdmissionDateTime)) = 1)
				OR ([dbo].[ssf_IsOverlapDates](AHD.DischargeDateTime, AHD.DischargeDateTime, ISNULL(@FromDate, AHD.DischargeDateTime), ISNULL(@ToDate, AHD.DischargeDateTime)) = 1)
				OR ([dbo].[ssf_IsOverlapDates](AHD.UpdateDateTime, AHD.UpdateDateTime, ISNULL(@FromDate, AHD.UpdateDateTime), ISNULL(@ToDate, AHD.UpdateDateTime)) = 1)
				OR ([dbo].[ssf_IsOverlapDates](AHD.TransferDateTime, AHD.TransferDateTime, ISNULL(@FromDate, AHD.TransferDateTime), ISNULL(@ToDate, AHD.TransferDateTime)) = 1)
				)
			AND (
				@MessageType = - 1
				OR AHD.MessageType = @MessageType
				)
			AND (
				@AdmissionStatus = - 1
				OR (
					AH.ADTHospitalizationId IN (
						SELECT ADTHospitalizationId
						FROM ADTHospitalizations
						WHERE DischargeDateTime IS NULL
							AND @AdmissionStatus = 1
						)
					)
				OR (
					AH.ADTHospitalizationId IN (
						SELECT ADTHospitalizationId
						FROM ADTHospitalizations
						WHERE DischargeDateTime IS NOT NULL
							AND @AdmissionStatus = 2
						)
					)
				)
			AND (
				@Hospitals = '-1'
				OR (AHD.Hospital = @Hospitals)
				)
			AND (
				@AssignedReviewer = - 1
				OR AH.AssignedReviewerId = @AssignedReviewer
				)
			AND (
				@CustomFiltersApplied = 'N'
				OR (
					@CustomFiltersApplied = 'Y'
					AND AH.ADTHospitalizationId IN (
						SELECT ADTHospitalizationId
						FROM @CustomFilters
						)
					)
				)
			AND (
				@Program = - 1
				OR CP.ProgramId = @Program
				)
			AND (
				@Search = ''
				OR (AHD.PatientAddress LIKE @SearchLike)
				OR (AHD.DischargeDisposition LIKE @SearchLike)
				OR (AHD.Hospital LIKE @SearchLike)
				OR (AHD.InsuranceCompany LIKE @SearchLike)
				OR (AHD.PresentingProblem LIKE @SearchLike)
				OR (AHD.PrimaryLanguage LIKE @SearchLike)
				OR (AHD.Race LIKE @SearchLike)
				OR (AHD.VisitType LIKE @SearchLike)
				);

		WITH counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT ADTHospitalizationId
				,ClientId
				,ClientName
				,AdmissionDate
				,DischargeDate
				,Hospital
				,Program
				,AssignedReviewer
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'ClientName'
								THEN ClientName
							END
						,CASE 
							WHEN @SortExpression = 'ClientName desc'
								THEN ClientName
							END DESC
						,CASE 
							WHEN @SortExpression = 'AdmissionDate'
								THEN AdmissionDate
							END
						,CASE 
							WHEN @SortExpression = 'AdmissionDate desc'
								THEN AdmissionDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'DischargeDate'
								THEN DischargeDate
							END
						,CASE 
							WHEN @SortExpression = 'DischargeDate desc'
								THEN DischargeDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'Hospital'
								THEN Hospital
							END
						,CASE 
							WHEN @SortExpression = 'Hospital desc'
								THEN Hospital
							END DESC
						,CASE 
							WHEN @SortExpression = 'Program'
								THEN Program
							END
						,CASE 
							WHEN @SortExpression = 'Program desc'
								THEN Program
							END DESC
						,CASE 
							WHEN @SortExpression = 'AssignedReviewer'
								THEN AssignedReviewer
							END
						,CASE 
							WHEN @SortExpression = 'AssignedReviewer desc'
								THEN AssignedReviewer
							END DESC
						,ADTHospitalizationId
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
				) ADTHospitalizationId
			,ClientId
			,ClientName
			,AdmissionDate
			,DischargeDate
			,Hospital
			,Program
			,AssignedReviewer
			,'' AS CMH
			,'' AS HealthLink
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

		SELECT ADTHospitalizationId
			,ClientId
			,ClientName
			,CONVERT(VARCHAR(10), CAST(AdmissionDate AS DATE), 101) AS AdmissionDate
			,CONVERT(VARCHAR(10), CAST(DischargeDate AS DATE), 101) AS DischargeDate
			,Hospital
			,Program
			,'' AS CMH
			,'' AS HealthLink
			,AssignedReviewer
		FROM #FinalResultSet
		ORDER BY Rownumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageADTHospitalization') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


