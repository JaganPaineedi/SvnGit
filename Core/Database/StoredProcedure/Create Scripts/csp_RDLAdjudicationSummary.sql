IF OBJECT_ID('csp_RDLAdjudicationSummary', 'P') IS NOT NULL
	DROP PROC csp_RDLAdjudicationSummary
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE csp_RDLAdjudicationSummary (
	@BatchId INT
	,@ExecutedByStaffId INT
	,@BatchNumber INT
	)
AS
/*************************************************************************/
/* Stored Procedure: csp_RDLAdjudicationSummary							 */
/* Creation Date:  19 Apr 2017											 */
/* Purpose: Gets data for adjudication summary report				     */
/*																		 */
/*																		 */
/*	19APR2017	MJensen	Created for Allegan task #687.52				 */
/*************************************************************************/
BEGIN TRY
	-- Batch selected FROM dropdown has PRIORITY over entered batch number
	DECLARE @SelectedBatch INT

	IF @BatchNumber < 1
		OR @BatchNumber IS NULL
	BEGIN
		SET @SelectedBatch = @BatchId
	END
	ELSE
	BEGIN
		SET @SelectedBatch = @BatchNumber
	END

	--	Validate batch #
	IF @SelectedBatch IS NULL
		OR @SelectedBatch < 1
		OR NOT EXISTS (
			SELECT 1
			FROM AdjudicationBatches
			WHERE BatchId = @SelectedBatch
			)
	BEGIN
		SELECT NULL AS ClaimLineId
			,NULL AS ClientName
			,NULL AS PROVIDER
			,NULL AS SiteName
			,NULL AS FromDate
			,NULL AS BillingCode
			,NULL AS RevenueCode
			,NULL AS Units
			,NULL AS StatusName
			,NULL AS InsurerName
			,NULL AS ClaimedAmount
			,NULL AS PayableAmount
			,NULL AS Reason
			,'Batch Number ' + CAST(@SelectedBatch AS VARCHAR(10)) + ' is not valid' AS Header

		RETURN
	END

	-- validate staff access to this batch
	IF EXISTS (
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
			WHERE a.BatchId = @SelectedBatch
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
	BEGIN
		SELECT NULL AS ClaimLineId
			,NULL AS ClientName
			,NULL AS PROVIDER
			,NULL AS SiteName
			,NULL AS FromDate
			,NULL AS BillingCode
			,NULL AS RevenueCode
			,NULL AS Units
			,NULL AS StatusName
			,NULL AS InsurerName
			,NULL AS ClaimedAmount
			,NULL AS PayableAmount
			,NULL AS Reason
			,'Not Authorized to Batch Number ' + CAST(@SelectedBatch AS VARCHAR(10)) AS Header

		RETURN
	END

	SELECT cl.ClaimLineId
		,LTRIM(RTRIM(cli.LastName)) + ', ' + LTRIM(RTRIM(Cli.FirstName)) AS ClientName
		,ISNULL(p.ProviderName, ISNULL(c.RenderingProviderName, '')) AS PROVIDER
		,ISNULL(s.SiteName, '') AS SiteName
		,cl.FromDate
		,bc.BillingCode + CASE 
			WHEN ISNULL(cl.Modifier1, '') != ''
				THEN ':' + cl.Modifier1
			ELSE + ''
			END + CASE 
			WHEN ISNULL(cl.Modifier2, '') != ''
				THEN ':' + cl.Modifier2
			ELSE + ''
			END + CASE 
			WHEN ISNULL(cl.Modifier3, '') != ''
				THEN ':' + cl.Modifier3
			ELSE + ''
			END + CASE 
			WHEN ISNULL(cl.Modifier4, '') != ''
				THEN ':' + cl.Modifier4
			ELSE + ''
			END AS BillingCode
		,ISNULL(cl.RevenueCode, '') AS RevenueCode
		,ad.UnitsClaimed AS Units
		,dbo.csf_GetGlobalCodeNameById(ad.STATUS) AS StatusName
		,i.InsurerName AS InsurerName
		,ISNULL(ad.ClaimedAmount, 0.00) AS ClaimedAmount
		,ISNULL(ad.ApprovedAmount, 0.00) AS PayableAmount
		,CASE 
			WHEN ad.STATUS IN (
					2024
					,2025
					,2027
					)
				THEN ISNULL(dbo.csf_GetGlobalCodeNameById(ad.PendedReason), '') + ' ' + ISNULL(dbo.csf_GetGlobalCodeNameById(ad.DenialReason), '')
			ELSE ''
			END AS Reason
		,'Batch Number: ' + CAST(Ab.BatchId AS VARCHAR(10)) + '   Date Run: ' + CONVERT(VARCHAR(20), ab.DateOfRun, 100) + '   Total Approved: $' + CONVERT(VARCHAR(Max), ab.ApprovedAmount, 1) AS Header
	FROM AdjudicationBatches ab
	JOIN Adjudications ad ON ab.BatchId = ad.BatchId
	JOIN ClaimLines cl ON ad.ClaimLineId = cl.ClaimLineId
	JOIN Claims c ON cl.ClaimId = c.ClaimId
	LEFT JOIN Clients cli ON c.ClientId = cli.ClientId
	LEFT JOIN Sites s ON c.SiteId = s.SiteId
		AND ISNULL(s.RecordDeleted, 'N') = 'N'
	LEFT JOIN BillingCodes bc ON cl.BillingCodeId = bc.BillingCodeId
		AND ISNULL(bc.RecordDeleted, 'N') = 'N'
	LEFT JOIN Insurers i ON c.InsurerId = i.InsurerId
		AND ISNULL(i.RecordDeleted, 'N') = 'N'
	LEFT JOIN Providers p ON s.ProviderId = p.ProviderId
		AND ISNULL(p.RecordDeleted, 'N') = 'N'
	WHERE ab.BatchId = @SelectedBatch
		AND ISNULL(ad.RecordDeleted, 'N') = 'N'
		AND ISNULL(cl.RecordDeleted, 'N') = 'N'
		AND ISNULL(c.RecordDeleted, 'N') = 'N'
	ORDER BY provider
		,cl.ClaimLineId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLAdjudicationSummary ') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH
GO

