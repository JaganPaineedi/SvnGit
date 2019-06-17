IF OBJECT_ID('scsp_PMClaimsHCFA1500UpdateCharges', 'P') IS NOT NULL
	DROP PROC scsp_PMClaimsHCFA1500UpdateCharges
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[scsp_PMClaimsHCFA1500UpdateCharges] @CurrentUser VARCHAR(30)
	,@ClaimBatchId INT
	,@FormatType CHAR(1) = 'P'
AS
/***********************************************************************************************************************/
/* Stored Procedure: dbo.scsp_PMClaimsHCFA1500UpdateCharges																*/
/* Creation Date:    9/25/06																							*/
/*																														*/
/* Purpose:																												*/
/*																														*/
/* Input Parameters:																									*/
/*																														*/
/* Output Parameters:																									*/
/*																														*/
/* Return Status:																										*/
/*																														*/
/* Called By:																											*/
/*																														*/
/* Calls:																												*/
/*																														*/
/* Data Modifications:																									*/
/*																														*/
/* Updates:																												*/
/*   Date     Author      Purpose																						*/
/*  9/25/06   JHB         Created																						*/
/*  5 Aug     Pradeep     Made changes to join Documents.CurrentDocumentVersionId=CustomDBTGroupNotes.DocumentVersionId */
/*	27 Jul 2017	MJensen		Removed code from another customer & set clinician = attending for select services ARM enhancements 590 */
/*	08/23/2017	MJensen	Set clinician to attending for certain plans/proc ARM task #590.1	*/
/************************************************************************************/
-- ARM task #590
UPDATE a
SET Clinicianid = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.StaffId
		ELSE a.ClinicianId
		END
	,ClinicianLastName = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.LastName
		ELSE a.ClinicianLastName
		END
	,ClinicianFirstName = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.FirstName
		ELSE a.ClinicianFirstName
		END
	,ClinicianMiddleName = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.MiddleName
		ELSE a.ClinicianMiddleName
		END
	,ClinicianSex = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.Sex
		ELSE a.ClinicianSex
		END
FROM #Charges a
JOIN ClientCoveragePlans ccp ON a.clientcoverageplanid = ccp.ClientCoveragePlanId
JOIN Staff st ON a.ClinicianId = st.staffid
LEFT JOIN Staff sta ON a.AttendingId = sta.StaffId
	AND ISNULL(sta.recorddeleted, 'N') = 'N'
LEFT JOIN StaffLicenseDegrees sld ON st.StaffId = sld.StaffId
	AND ISNULL(sld.RecordDeleted, 'N') = 'N'
	AND (
		sld.StartDate IS NULL
		OR CAST(sld.StartDate AS DATE) <= CAST(a.DateOfService AS DATE)
		)
	AND (
		sld.EndDate IS NULL
		OR CAST(sld.EndDate AS DATE) >= CAST(a.DateOfService AS DATE)
		)
WHERE sld.LicenseTypeDegree IN (
		20941
		,25203
		,20928
		,20955
		)
	AND sld.Billing = 'Y'
	AND EXISTS (
		SELECT 1
		FROM dbo.ssf_RecodeValuesAsOfDate('AttendingAsClinicianCoveragePlans', a.DateOfService) r1
		WHERE r1.IntegerCodeId = ccp.CoveragePlanId
		)
	AND EXISTS (
		SELECT 1
		FROM dbo.ssf_RecodeValuesAsOfDate('AttendingAsClinicianProcedureCodes', a.DateOfService) r2
		WHERE r2.IntegerCodeId = a.ProcedureCodeId
		)

-- ARM task #590.1
UPDATE a
SET Clinicianid = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.StaffId
		ELSE a.ClinicianId
		END
	,ClinicianLastName = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.LastName
		ELSE a.ClinicianLastName
		END
	,ClinicianFirstName = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.FirstName
		ELSE a.ClinicianFirstName
		END
	,ClinicianMiddleName = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.MiddleName
		ELSE a.ClinicianMiddleName
		END
	,ClinicianSex = CASE 
		WHEN sta.staffid IS NOT NULL
			THEN sta.Sex
		ELSE a.ClinicianSex
		END
FROM #Charges a
JOIN ClientCoveragePlans ccp ON a.clientcoverageplanid = ccp.ClientCoveragePlanId
JOIN Staff st ON a.ClinicianId = st.staffid
LEFT JOIN Staff sta ON a.AttendingId = sta.StaffId
	AND ISNULL(sta.recorddeleted, 'N') = 'N'
WHERE EXISTS (
		SELECT 1
		FROM dbo.ssf_RecodeValuesAsOfDate('AttendingAsClinicianCoveragePlansForUA', a.DateOfService) r1
		WHERE r1.IntegerCodeId = ccp.CoveragePlanId
		)
	AND a.ProcedureCodeId = 290		

IF @@error <> 0
	GOTO error

error:
GO

