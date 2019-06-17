IF OBJECT_ID('csp_RDLGetAdjudicationBatchList', 'P') IS NOT NULL
	DROP PROC csp_RDLGetAdjudicationBatchList
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE csp_RDLGetAdjudicationBatchList (@ExecutedByStaffId INT)
AS
/*************************************************************************/
/* Stored Procedure: csp_RDLGetAdjudicationBatchList					 */
/* Creation Date:  19 Apr 2017											 */
/* Purpose: Gets list of adjudication batches for report selection       */
/*																		 */
/*	19APR2017	MJensen	Created for Allegan task #687.52				 */
/*************************************************************************/
BEGIN TRY
	DECLARE @StartDate DATE = DATEADD(DAY, - 90, GETDATE())

	SELECT NULL AS BatchNumber
		,NULL AS DateOfRun
		,'Select a Batch' AS BatchName
		,1 AS OrderPriority
	
	UNION
	
	SELECT DISTINCT ab.BatchId AS BatchNumber
		,ab.DateOfRun AS DateOfRun
		,'Batch Number: ' + CAST(Ab.BatchId AS VARCHAR(10)) + '   Date Run: ' + CONVERT(VARCHAR(20), ab.DateOfRun, 100) AS BatchName
		,2 AS OrderPriority
	FROM AdjudicationBatches ab
	WHERE NOT EXISTS (
			SELECT 1
			FROM Adjudications a
			JOIN Claimlines cl ON cl.ClaimLineId = a.ClaimLineId
			JOIN Claims c ON c.ClaimId = cl.ClaimId
			JOIN Sites s ON s.SiteId = c.SiteId
			JOIN Staff st ON st.StaffId = @ExecutedByStaffId
			LEFT JOIN StaffProviders sp ON s.ProviderId = sp.ProviderId
				AND sp.StaffId = @ExecutedByStaffId
				AND ISNULL(sp.RecordDeleted, 'N') = 'N'
			LEFT JOIN StaffInsurers si ON c.InsurerId = si.InsurerId
				AND si.StaffId = @ExecutedByStaffId
				AND ISNULL(si.RecordDeleted, 'N') = 'N'
				AND ISNULL(a.RecordDeleted, 'N') = 'N'
			WHERE a.BatchId = ab.BatchId
				AND (
					(
						ISNULL(st.AllProviders, 'N') = 'N'
						AND sp.StaffProviderId IS NULL
						)
					OR (
						ISNULL(st.AllInsurers, 'N') = 'N'
						AND si.StaffInsurerId IS NULL
						)
					)
				AND ISNULL(cl.RecordDeleted, 'N') = 'N'
				AND ISNULL(c.RecordDeleted, 'N') = 'N'
				AND ISNULL(s.RecordDeleted, 'N') = 'N'
			)
		AND ISNULL(ab.RecordDeleted, 'N') = 'N'
		AND Ab.DateOfRun > @StartDate
	ORDER BY OrderPriority
		,BatchNumber DESC
		,DateOfRun DESC
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLGetAdjudicationBatchList ') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH
GO

