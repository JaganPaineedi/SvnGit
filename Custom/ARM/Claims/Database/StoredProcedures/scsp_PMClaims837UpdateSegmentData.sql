/****** Object:  StoredProcedure [dbo].[scsp_PMClaims837UpdateSegmentData]    Script Date: 8/8/2018 3:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('scsp_PMClaims837UpdateSegmentData', 'P') is not null
	drop procedure scsp_PMClaims837UpdateSegmentData
go

CREATE PROCEDURE [dbo].[scsp_PMClaims837UpdateSegmentData] @CURRENTUSER VARCHAR(30)
	,@ClaimBatchId INT
	,@FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837UpdateSegmentData                         */
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
/*
	9/14/2009	avoss	remove additinonal legacy iedntifiers for select coverages
	--06/16/2015	tremisoski	keep the additional legacy identifiers only for MACSIS and MITS claim formats
	--06/26/2017	mjensen		remove the identifier changes for non MACSIS & MITS claim formats ARM support #660
	--12/01/2017	mjensen		Remove rendering loop if not allowed b4 7/1/18.  ARM support #754
	--12/04/2017	mjensen		Corrected alias  ARM support #754
	--12/11/2017	mjensen		Modifed join to #ClaimLines_temp.  Arm support #754
	--07/09/2018	MJensen		Remove billing provider secondary Id when NPI.  A Renewed Mind support #930
	--08/08/2018	tremisoski	Change how pay-to-provider loop is forced into the file.  Now it is based on a payer-specific recode.  ARM SGL #959
*/
/*********************************************************************/
DECLARE @CurrentDate DATETIME

SET @CurrentDate = getdate()

--
-- 6/18/2015 - explicitly set NPI fro MACSIS claims
--
UPDATE a
SET BillingProviderId = '1902084528'
	,BillingProviderIdQualifier = 'XX'
FROM #837BillingProviders a
CROSS JOIN ClaimBatches AS b
WHERE b.ClaimBatchId = @ClaimBatchId
	AND b.ClaimFormatId = 10003 -- MACSIS

--
-- 06/16/2015	tremisoski	keep the additional legacy 2 identifiers only for MACSIS claim format
--
--UPDATE a
--SET BillingProviderAdditionalId2 = NULL
--	,BillingProviderAdditionalIdQualifier2 = NULL
--FROM #837BillingProviders a
--CROSS JOIN ClaimBatches AS b
--WHERE b.ClaimBatchId = @ClaimBatchId
--	AND b.ClaimFormatId not in (10008, 10003) -- MACSIS

--IF @@error <> 0
--	GOTO error


----
---- 06/16/2015	tremisoski	keep the additional legacy 1 identifiers only for MITS/MACSIS claim format
----
--UPDATE a
--SET BillingProviderAdditionalId = NULL
--	,BillingProviderAdditionalIdQualifier = NULL
--FROM #837BillingProviders a
--CROSS JOIN ClaimBatches AS b
--WHERE b.ClaimBatchId = @ClaimBatchId
--	AND b.ClaimFormatId NOT IN (
--		10008
--		,10003
--		) -- MITS and MACSIS


--
-- New code to apply the pay-to-provider loop based on PayerId instead of Claim Format
--

UPDATE a SET
	PayToProviderLastName = a.BillingProviderLastName,
	PayToProviderIdQualifier = 'XX',
	PayToProviderId = 'FORCE IN FILE',
	PayToProviderAddress1 = a.BillingProviderAddress1,
	PayToProviderCity = a.BillingProviderCity,
	PayToProviderState = a.BillingProviderState,
	PayToProviderZip = a.BillingProviderZip,
	PayToProviderSecondaryQualifier = NULL,
	PayToProviderSecondaryId = NULL,
	PayToProviderSecondaryQualifier2 = NULL,
	PayToProviderSecondaryId2 = NULL
FROM #837BillingProviders a
JOIN #ClaimLines_Temp b ON (a.BillingProviderAdditionalId = b.BillingProviderId)
JOIN Charges AS chg ON chg.ChargeId = b.ChargeId
JOIN ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = chg.ClientCoveragePlanId
JOIN CoveragePlans AS cp ON cp.CoveragePlanId = ccp.CoveragePlanId
JOIN dbo.ssf_RecodeValuesCurrent('X837PAYERSPAYTOREQ') as  rc on rc.IntegerCodeId = cp.PayerId

--
-- BH Redesign Changes
--
IF EXISTS (
	SELECT *
	FROM ClaimBatches AS cb
	JOIN dbo.ssf_RecodeValuesCurrent('XBHREDESIGNCLAIMFORMATS') AS rc ON rc.IntegerCodeId = cb.ClaimFormatId
	WHERE cb.ClaimBatchId = @ClaimBatchId
)
BEGIN

	-- Task 754 - remove rendering loop if super loop required and b4 7/1/18 
	UPDATE clm 
	SET clm.RenderingId = Null
	FROM #837Claims clm
	JOIN #ClaimLines_Temp cl ON cl.ClaimLineId = clm.ClaimLineId
	JOIN Staff s ON cl.ClinicianId = s.StaffId
	JOIN StaffLicenseDegrees sld ON s.StaffId = sld.StaffId
			AND ISNULL(sld.RecordDeleted, 'N') = 'N'
			AND sld.Billing = 'Y'
			AND (
				sld.StartDate IS NULL
				OR sld.StartDate <= cl.DateOfService
				)
			AND (
				sld.EndDate IS NULL
				OR sld.EndDate >= cl.DateOfService
				)
	WHERE sld.LicenseTypeDegree IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesAsOfDate('XSupervisionRequired', cl.DateOfService)
				)
    AND CAST(cl.DateOfService AS DATE) < (
				SELECT CAST(Value AS DATE)
				FROM SystemConfigurationKeys
				WHERE [Key] = 'XBHRedesignNPIMandatoryEffectiveDate'
				)

	-- Task 754 - remove rendering loop if not allowed b4 7/1/18 
	UPDATE clm 
	SET clm.RenderingId = Null
	FROM #837Claims clm
	JOIN #ClaimLines_temp cl ON cl.ClaimLineId = clm.ClaimLineId
	JOIN Staff s ON cl.ClinicianId = s.StaffId
	JOIN StaffLicenseDegrees sld ON s.StaffId = sld.StaffId
			AND ISNULL(sld.RecordDeleted, 'N') = 'N'
			AND sld.Billing = 'Y'
			AND (
				sld.StartDate IS NULL
				OR sld.StartDate <= cl.DateOfService
				)
			AND (
				sld.EndDate IS NULL
				OR sld.EndDate >= cl.DateOfService
				)
	WHERE sld.LicenseTypeDegree IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesAsOfDate('XBHRedesignNoNPI', cl.DateOfService)
				)
    AND CAST(cl.DateOfService AS DATE) < (
				SELECT CAST(Value AS DATE)
				FROM SystemConfigurationKeys
				WHERE [Key] = 'XBHRedesignNPIMandatoryEffectiveDate'
				)

END

-- getting a REF*NP segment in billing provider loop as a side effect of using NPI in CoveragePlans.ProviderId
UPDATE #837BillingProviders
SET BillingProviderAdditionalId = NULL
WHERE BillingProviderAdditionalIdQualifier = 'NP'


IF @@error <> 0
	GOTO error

RETURN

error:

