IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PMClaims837Validations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_PMClaims837Validations]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[scsp_PMClaims837Validations] 
@CurrentUser VARCHAR(30), @ClaimBatchId INT, @FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837Validations                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   */

/* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*   Date     Author      Purpose                                    */
/*  9/25/06   JHB	  Created                                    */
/*	3/15/2017	MJensen	Arm Support #590 Validate signature/co-signer */
/*	7/19/2017	MJensen	Arm Enhancements #590 Remove signature validation*/
/*	11/9/2017	MJensen		Add charge warning for secondary claim billing code <> primary claim billing code ARM enhancements task 19 */
/*********************************************************************/

declare @CurrentDate datetime

set @CurrentDate = getdate()

INSERT INTO ChargeErrors (
	ChargeId
	,ErrorType
	,ErrorDescription
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	)
SELECT b.ChargeId
	,4556
	,'Modifer1 required for MACSIS billing.'
	,@CurrentUser
	,@CurrentDate
	,@CurrentUser
	,@CurrentDate
FROM #ClaimLines a
INNER JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)
CROSS JOIN ClaimBatches AS cb
WHERE cb.ClaimBatchId = @ClaimBatchId
AND cb.ClaimFormatId = 10003	-- MACSIS
AND LEN(ISNULL(a.Modifier1, '')) = 0

-- arm support #590 - this validation removed per customer request ARM-Enhancements #590
--INSERT INTO ChargeErrors (
--	ChargeId
--	,ErrorType
--	,ErrorDescription
--	,CreatedBy
--	,CreatedDate
--	,ModifiedBy
--	,ModifiedDate
--	)
--SELECT b.ChargeId
--	,4556
--	,'Attending does not equal cosigner.'
--	,@CurrentUser
--	,@CurrentDate
--	,@CurrentUser
--	,@CurrentDate
--FROM #ClaimLines a
--JOIN #Charges b ON (a.ClaimLineId = b.ClaimLineId)
--JOIN ClientCoveragePlans ccp ON b.clientcoverageplanid = ccp.ClientCoveragePlanId
--JOIN Services s ON s.ServiceId = b.ServiceId
--LEFT JOIN StaffLicenseDegrees sld ON s.ClinicianId = sld.StaffId
--	AND ISNULL(sld.RecordDeleted, 'N') = 'N'
--	AND (
--		sld.StartDate IS NULL
--		OR CAST(sld.StartDate AS DATE) <= CAST(b.DateOfService AS DATE)
--		)
--	AND (
--		sld.EndDate IS NULL
--		OR CAST(sld.EndDate AS DATE) >= CAST(b.DateOfService AS DATE)
--		)
--	AND sld.Billing = 'Y'
--LEFT JOIN documents doc ON doc.ServiceId = b.serviceid
--	AND ISNULL(doc.RecordDeleted, 'N') = 'N'
--LEFT JOIN DocumentSignatures ds ON ds.DocumentId = doc.DocumentId
--	AND ISNULL(s.AttendingId, - 1) = ds.StaffId
--	AND ISNULL(ds.RecordDeleted, 'N') = 'N'
--WHERE sld.LicenseTypeDegree IN (
--		20941
--		,25203
--		,20928
--		,20955
--		)
--	AND sld.Billing = 'Y'
--	AND ds.SignedDocumentVersionId IS NULL
--	AND EXISTS (
--		SELECT 1
--		FROM dbo.ssf_RecodeValuesAsOfDate('AttendingAsClinicianCoveragePlans', b.DateOfService) r1
--		WHERE r1.IntegerCodeId = ccp.CoveragePlanId
--		)
--	AND EXISTS (
--		SELECT 1
--		FROM dbo.ssf_RecodeValuesAsOfDate('AttendingAsClinicianProcedureCodes', b.DateOfService) r2
--		WHERE r2.IntegerCodeId = b.ProcedureCodeId
--		)

-- For Medicaid do not allow secondary billing code <> primary billing code
IF exists (
		SELECT cf.FormatName
		FROM ClaimBatches cb
		JOIN ClaimFormats cf ON cb.ClaimFormatId = cf.ClaimFormatId
		join (select IntegerCodeId from dbo.ssf_RecodeValuesCurrent('XBHREDESIGNCLAIMFORMATS')) as rc on rc.integerCodeId = cf.ClaimFormatId 
		WHERE cb.ClaimBatchId = @ClaimBatchId
		) 
BEGIN
	INSERT INTO ChargeErrors (
		ChargeId
		,ErrorType
		,ErrorDescription
		,CreatedBy
		,CreatedDate
		,ModifiedBy
		,ModifiedDate
		)
	SELECT DISTINCT cl.ChargeId
		,4556
		,'Charge billing code does not match prior billed charges.'
		,@CurrentUser
		,@CurrentDate
		,@CurrentUser
		,@CurrentDate
	FROM #ClaimLines cl
	JOIN #OtherInsured oi ON oi.ClaimLineId = cl.claimLineId
		AND cl.ChargeId = oi.ChargeId
	WHERE oi.BillingCode != cl.BillingCode
		OR ISNULL(oi.Modifier1, '') != ISNULL(cl.Modifier1, '')
		OR ISNULL(oi.Modifier2, '') != ISNULL(cl.Modifier2, '')
		OR ISNULL(oi.Modifier3, '') != ISNULL(cl.Modifier3, '')
		OR ISNULL(oi.Modifier4, '') != ISNULL(cl.Modifier4, '')
END


error:

GO


