IF OBJECT_ID('csp_PMClaims837UpdateCharges', 'P') IS NOT NULL
	DROP PROCEDURE csp_PMClaims837UpdateCharges
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[csp_PMClaims837UpdateCharges] @CurrentUser VARCHAR(30)
	,@ClaimBatchId INT
	,@FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837UpdateCharges                         */
/*                                        */
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
/*	11/9/2017	MJensen	created to add supervisor loop info. ARM enhancements task 19	*/
/*	12/1/2017	MJensen	added NPI mandatory effective date	ARM support #754		*/
/*	01/11/2018	MJensen	Remove attending id if it is the same ase clinician ARM Enhancements #19.13	*/
/*********************************************************************/

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
		-- do not allow clinician to select themselves as attending
		UPDATE #Charges
		SET AttendingId = NULL
		WHERE AttendingId = ClinicianId

		-- add supervisor info 
		UPDATE c
		SET SupervisingProvider2310DLastName = Sup.LastName
			,SupervisingProvider2310DFirstName = Sup.FirstName
			,SupervisingProvider2310DMiddleName = Sup.MiddleName
			,SupervisingProvider2310DId = sld2.LicenseNumber
			,SupervisingProvider2310DIdType = CASE 
				WHEN sld2.LicenseNumber IS NOT NULL
					THEN 'XX'
				ELSE NULL
				END
		FROM #Charges c
		JOIN dbo.Staff AS s2 ON c.ClinicianId = s2.StaffId
		JOIN StaffLicenseDegrees sld ON s2.StaffId = sld.StaffId
			AND ISNULL(sld.RecordDeleted, 'N') = 'N'
			AND sld.Billing = 'Y'
			AND (
				sld.StartDate IS NULL
				OR sld.StartDate <= c.DateOfService
				)
			AND (
				sld.EndDate IS NULL
				OR sld.EndDate >= c.DateOfService
				)
		LEFT JOIN Staff Sup ON Sup.StaffId = c.AttendingId
		LEFT JOIN StaffLicenseDegrees sld2 ON sld2.StaffId = c.AttendingId
			AND ISNULL(sld2.RecordDeleted, 'N') = 'N'
			AND sld2.LicenseTypeDegree = 9408
			AND (
				sld2.StartDate IS NULL
				OR sld2.StartDate <= c.DateOfService
				)
			AND (
				sld2.EndDate IS NULL
				OR sld2.EndDate >= c.DateOfService
				)
		WHERE sld.LicenseTypeDegree IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesAsOfDate('XSupervisionRequired', c.DateOfService)
				)
			AND CAST(c.DateOfService AS DATE) >= (
				SELECT CAST(Value AS DATE)
				FROM SystemConfigurationKeys
				WHERE [Key] = 'XBHRedesignBillingDegreeLogicEffectiveDate'
				)
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
GO

