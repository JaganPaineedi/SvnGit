IF OBJECT_ID('csp_ReportGetERClaimLineDetails') IS NOT NULL
	DROP PROCEDURE dbo.csp_ReportGetERClaimLineDetails
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

--[csp_ReportGetERClaimLineErrors] 2

CREATE PROCEDURE [dbo].csp_ReportGetERClaimLineDetails @ERFileId INT

/********************************************************************************
-- Stored Procedure: csp_ReportGetERClaimLineDetails
--
-- Copyright: 2016 Streamline Healthcate Solutions
--
-- Purpose: Use for claim line details
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 02.02.2016  dknewtson   Created
-- 03.07.2017  David K	   Dynamic SQL To support different ERClaimLineItemCharges tables.
*********************************************************************************/
AS
	BEGIN
		DECLARE @sql VARCHAR(MAX)

		SELECT	ecli.ClaimLineItemId
			  , STUFF(serv.ServiceIds, 1, 2, '') AS ServiceIds
		INTO	#ERClaimLineItemServices
		FROM	dbo.ERClaimLineItems ecli
		JOIN	dbo.ERBatches eb ON ecli.ERBatchId = eb.ERBatchId
		CROSS APPLY ( SELECT (	SELECT	', ' + CAST(s.ServiceId AS VARCHAR)
								FROM	dbo.Services s
								WHERE	EXISTS ( SELECT	1
												 FROM	dbo.Charges c
												 JOIN	dbo.ClaimLineItemCharges clic ON clic.ChargeId = c.ChargeId
																						 AND clic.ClaimLineItemId = ecli.ClaimLineItemId
												 WHERE	c.ServiceId = s.ServiceId
														AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
														AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
														AND ISNULL(clic.RecordDeleted, 'N') <> 'Y' )
								ORDER BY s.ServiceId
					  FOR		XML	PATH('')
								  , TYPE).value('.', 'NVARCHAR(MAX)') AS ServiceIds
					) serv
		WHERE	eb.ERFileId = @ERFileId
				AND ISNULL(ecli.RecordDeleted, 'N') <> 'Y'
				AND ISNULL(eb.RecordDeleted, 'N') <> 'Y'
		GROUP BY serv.ServiceIds
			  , ecli.ClaimLineItemId

		CREATE TABLE #ERClaimLineItemClinicians
			(
			  ERClaimLineItemId INT
			, ClinicianId INT
			)

		IF OBJECT_ID('ERClaimLineItemCharges') IS NOT NULL
				BEGIN
				SET @SQL = '
					INSERT	INTO #ERClaimLineItemClinicians
							( ERClaimLineItemId
							, ClinicianId
							)
							SELECT	ecli.ERClaimLineItemId
								  , MAX(s.ClinicianId) AS ClinicianId
							FROM	dbo.ERClaimLineItems AS ecli
							JOIN	dbo.ERBatches AS eb ON eb.ERBatchId = ecli.ERBatchId
														   AND eb.ERFileId = '+ CAST(@ERFileId AS VARCHAR) + '
							JOIN	dbo.ERClaimLineItemCharges AS ceclic ON ceclic.ERClaimLineItemId = ecli.ERClaimLineItemId
							JOIN	dbo.Charges AS c ON c.ChargeId = ceclic.ChargeId
							JOIN	dbo.Services AS s ON s.ServiceId = c.ServiceId
							GROUP BY ecli.ERClaimLineItemId
					'
				EXEC(@SQL)
				END
			ELSE
		IF OBJECT_ID('CustomERClaimLineItemCharges') IS NOT NULL
			BEGIN
				SET @SQL = '
				INSERT	INTO #ERClaimLineItemClinicians
						( ERClaimLineItemId
						, ClinicianId
						)
						SELECT	ecli.ERClaimLineItemId
							  , MAX(s.ClinicianId) AS ClinicianId
						FROM	dbo.ERClaimLineItems AS ecli
						JOIN	dbo.ERBatches AS eb ON eb.ERBatchId = ecli.ERBatchId
													   AND eb.ERFileId = '+ CAST(@ERFileId AS VARCHAR) + '
						JOIN	dbo.CustomERClaimLineItemCharges AS ceclic ON ceclic.ERClaimLineItemId = ecli.ERClaimLineItemId
						JOIN	dbo.Charges AS c ON c.ChargeId = ceclic.ChargeId
						JOIN	dbo.Services AS s ON s.ServiceId = c.ServiceId
						GROUP BY ecli.ERClaimLineItemId
						'
				EXEC(@SQL)
			END
		ELSE

				BEGIN
					INSERT	INTO #ERClaimLineItemClinicians
							( ERClaimLineItemId
							, ClinicianId
							)
							SELECT	ecli.ERClaimLineItemId
								  , MAX(s.ClinicianId) AS ClinicianId
							FROM	dbo.ERClaimLineItems AS ecli
							JOIN	dbo.ERBatches AS eb ON eb.ERBatchId = ecli.ERBatchId
														   AND eb.ERFileId = @ERFileId
							JOIN	dbo.ClaimLineItemCharges AS ceclic ON ceclic.ClaimLineItemId = ecli.ClaimLineItemId
							JOIN	dbo.Charges AS c ON c.ChargeId = ceclic.ChargeId
							JOIN	dbo.Services AS s ON s.ServiceId = c.ServiceId
							GROUP BY ecli.ERClaimLineItemId
				END

		SELECT	b.ClientName
			  , b.DateOfService
			  , b.BillingCode
			  , b.ChargeAmount
			  , b.PaidAmount
			  , b.ClientIdentifier
			  , b.LineItemControlNumber
			  , b.PayerClaimNumber
			  , erbp.CheckNumber
			  , eclis.ServiceIds
			  , clinician.LastName + ', ' + clinician.FirstName AS Clinician
			  , b.AdjustmentGroupCode11
			  , b.AdjustmentReason11
			  , b.AdjustmentAmount11
			  , b.AdjustmentQuantity11
			  , b.AdjustmentGroupCode12
			  , b.AdjustmentReason12
			  , b.AdjustmentAmount12
			  , b.AdjustmentQuantity12
			  , b.AdjustmentGroupCode13
			  , b.AdjustmentReason13
			  , b.AdjustmentAmount13
			  , b.AdjustmentQuantity13
			  , b.AdjustmentGroupCode14
			  , b.AdjustmentReason14
			  , b.AdjustmentAmount14
			  , b.AdjustmentQuantity14
			  , b.AdjustmentGroupCode21
			  , b.AdjustmentReason21
			  , b.AdjustmentAmount21
			  , b.AdjustmentQuantity21
			  , b.AdjustmentGroupCode22
			  , b.AdjustmentReason22
			  , b.AdjustmentAmount22
			  , b.AdjustmentQuantity22
			  , b.AdjustmentGroupCode23
			  , b.AdjustmentReason23
			  , b.AdjustmentAmount23
			  , b.AdjustmentQuantity23
			  , b.AdjustmentGroupCode24
			  , b.AdjustmentReason24
			  , b.AdjustmentAmount24
			  , b.AdjustmentQuantity24
			  , b.AdjustmentGroupCode31
			  , b.AdjustmentReason31
			  , b.AdjustmentAmount31
			  , b.AdjustmentQuantity31
			  , b.AdjustmentQuantity32
			  , b.AdjustmentGroupCode32
			  , b.AdjustmentReason32
			  , b.AdjustmentAmount32
			  , b.AdjustmentGroupCode33
			  , b.AdjustmentReason33
			  , b.AdjustmentAmount33
			  , b.AdjustmentQuantity33
			  , b.AdjustmentGroupCode34
			  , b.AdjustmentReason34
			  , b.AdjustmentAmount34
			  , b.AdjustmentQuantity34
			  , b.AdjustmentGroupCode41
			  , b.AdjustmentReason41
			  , b.AdjustmentAmount41
			  , b.AdjustmentQuantity41
			  , b.AdjustmentGroupCode42
			  , b.AdjustmentReason42
			  , b.AdjustmentAmount42
			  , b.AdjustmentQuantity42
			  , b.AdjustmentGroupCode43
			  , b.AdjustmentReason43
			  , b.AdjustmentAmount43
			  , b.AdjustmentQuantity43
			  , b.AdjustmentGroupCode44
			  , b.AdjustmentReason44
			  , b.AdjustmentAmount44
			  , b.AdjustmentQuantity44
			  , b.AdjustmentGroupCode51
			  , b.AdjustmentReason51
			  , b.AdjustmentAmount51
			  , b.AdjustmentQuantity51
			  , b.AdjustmentGroupCode52
			  , b.AdjustmentReason52
			  , b.AdjustmentAmount52
			  , b.AdjustmentQuantity52
			  , b.AdjustmentGroupCode53
			  , b.AdjustmentReason53
			  , b.AdjustmentAmount53
			  , b.AdjustmentQuantity53
			  , b.AdjustmentGroupCode54
			  , b.AdjustmentReason54
			  , b.AdjustmentAmount54
			  , b.AdjustmentQuantity54
		FROM	dbo.ERClaimLineItems b
		LEFT JOIN dbo.ERBatchPayments AS erbp ON erbp.ERBatchPaymentId = b.ERBatchPaymentId
		JOIN	dbo.ERBatches c ON ( b.ERBatchId = c.ERBatchId )
		LEFT JOIN #ERClaimLineItemServices eclis ON eclis.ClaimLineItemId = b.ClaimLineItemId
		LEFT JOIN #ERClaimLineItemClinicians eclicl ON eclicl.ERClaimLineItemId = b.ERClaimLineItemId
		LEFT JOIN dbo.Staff AS clinician ON clinician.StaffId = eclicl.ClinicianId
		WHERE	c.ERFileId = @ERFileId
     -- AND b.PaidAmount = 0.00
      --AND NOT EXISTS (SELECT 1 FROM dbo.ERClaimLineItems ecli 
      --                              JOIN ERBatches eb ON (eb.ERBatchId = ecli.ERBatchId)
      --                                       AND eb.ERFileId = @ERFileId
      --                         WHERE b.ClaimLineItemId = ecli.ClaimLineItemId
      --                              AND ecli.ERClaimLineItemId <> b.ERClaimLineItemId
      --                              AND ISNULL(ecli.RecordDeleted,'N') <> 'Y'
      --                              AND ecli.PaidAmount > 0.00
      --               )


	END


GO
