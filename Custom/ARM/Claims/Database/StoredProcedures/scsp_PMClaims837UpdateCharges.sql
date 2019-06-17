IF OBJECT_ID('scsp_PMClaims837UpdateCharges','P') IS NOT NULL
	DROP PROCEDURE scsp_PMClaims837UpdateCharges
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[scsp_PMClaims837UpdateCharges] 
@CurrentUser VARCHAR(30), @ClaimBatchId INT, @FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837UpdateCharges                         */
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
/*  03/15/2017 MJensen	Set clinician to attend for certain plans/proc/degrees ARM task #590 */
/*	03/15/2017	MJensen	Removed code copied from another customer */
/*	08/23/2017	MJensen	Set clinician to attending for certain plans/proc ARM task #590.1	*/
/*	11/9/2017	MJensen	Added supervisor loop info. ARM enhancements task 19	*/
/*	11/14/2017	MJensen	Modified to call a separate sp for the supervisor loop update task #19*/
/*	07/10/2018	MJensen	MCO plans must use old electronic claims payer id for dos prior to cut over.	Arm Enhancements #40	*/
/*********************************************************************/

--Removed 3/15/2017 MJensen
-- For Medicaid set the clinician on service to Dr. Garaza (59) or Dr. Gajare (444)
--update c set
--   ClinicianId = case when datediff(day, c.DateOfService, '10/15/2010') > 0 then 59 else 444 end
--from #Charges as c
--where c.CoveragePlanId = 200

if @@error <> 0 goto error

-- For Medicare set the clinician id to the attending if the clinician does not have a Medicare provider id
--End Incident too claims per Mary Farington 06/27/2011
--Allow incident to for RN's

update a
set ClinicianId = a.AttendingId,
ClinicianLastName = c.LastName,
ClinicianFirstName = c.FirstName,
ClinicianMiddleName = c.MiddleName,
ClinicianSex = c.Sex
from #Charges a
JOIN Staff c ON (a.AttendingId = c.StaffId)
where a.CoveragePlanId in (165, 167, 202, 203)
and not exists ( 
	select * from  CoveragePlanProviderIds b
	where a.ClinicianId = b.StaffId
	and b.CoveragePlanId = a.CoveragePlanId
	and isnull(b.RecordDeleted,'N') = 'N' 
	)
and exists ( select * from staff s  
	where s.staffid = a.ClinicianId  
	and s.degree in (10144) --RN  
   )  


if @@error <> 0 goto error

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
IF @@error <> 0
	GOTO ERROR

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
	GOTO ERROR

-- for older MCO claims force in old electronic claims payer id
IF (
		SELECT ClaimFormatId
		FROM ClaimBatches
		WHERE ClaimBatchId = @ClaimBatchId
		) = 10016
BEGIN
	UPDATE C
	SET ElectronicClaimsPayerId = 'MMISODJFS'
	FROM #Charges c
	JOIN CustomBHRCoveragePlanClaimFormats bhr ON bhr.CoveragePlanId = c.CoveragePlanId
	WHERE Isnull(bhr.RecordDeleted, 'N') = 'N'
		AND bhr.ClaimFormatAfterMCO IS NOT NULL
		AND c.DateOfService < CAST((
				SELECT Value
				FROM SystemConfigurationKeys
				WHERE [Key] = 'XBHRedesignNPIMandatoryEffectiveDate'
					AND Isnull(RecordDeleted, 'N') = 'N'
				) AS DATE);
END;


-- add supervisor info 
BEGIN TRY
	IF EXISTS (
			SELECT cf.FormatName
			FROM ClaimBatches cb
			JOIN ClaimFormats cf ON cb.ClaimFormatId = cf.ClaimFormatId
			JOIN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent('XBHREDESIGNCLAIMFORMATS')
				) AS rc ON rc.integerCodeId = cf.ClaimFormatId
			WHERE cb.ClaimBatchId = @ClaimBatchId
			)
	BEGIN
		EXEC csp_PMClaims837UpdateCharges @CurrentUser = @CurrentUser
			,@ClaimBatchId = @ClaimBatchId
			,@FormatType = @FormatType
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_PMClaims837UpdateCharges') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.  
			16
			,-- Severity.  
			1 -- State.  
			);
END CATCH


error:

GO


