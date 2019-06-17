IF OBJECT_ID('csp_PMClaims837UpdateSegments', 'P') IS NOT NULL
	DROP PROC csp_PMClaims837UpdateSegments
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_PMClaims837UpdateSegments] @CurrentUser VARCHAR(30)
	,@ClaimBatchId INT
	,@FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.csp_PMClaims837UpdateSegments                */
/* Creation Date:   12/27/2017                                        */
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
/*	11/10/2017	MJensen		Added BH Redesign change ARM Enhancements Task 19.01	*/
/*	11/30/2017	mjensen		modify referring loop to be ordering provider for OH Medicaid when clinician has specific degree ARM support #754 */
/*********************************************************************/
DECLARE @CurrentDate DATETIME

SET @CurrentDate = GETDATE()

DECLARE @ComponentElementSeparator CHAR(1)
	,@SegmentTerminator VARCHAR(2)

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
	UPDATE #837BillingProviders
	SET BillingProviderRefSegment = NULL
		,
		--BillingProviderRef2Segment = NULL ,
		BillingProviderRef3Segment = NULL

	-- Task #754 if clinician is a nurse, force ordering provider into supervisor segment.
	SELECT @ComponentElementSeparator = ISNULL(cf.ComponentElementSeparator, '*')
		,@SegmentTerminator = ISNULL(cf.SegmentTerminator, '~')
	FROM dbo.ClaimFormats cf
	JOIN ClaimBatches cb ON cf.ClaimFormatId = cb.ClaimFormatId
	WHERE cb.ClaimBatchId = @ClaimBatchId

	UPDATE Srv
	SET srv.SupervisorNM1Segment = 'NM1' + @ComponentElementSeparator + 'DK' + @ComponentElementSeparator + '1' + @ComponentElementSeparator + 
	LTRIM(RTRIM(ISNULL(s2.LastName, ''))) + @ComponentElementSeparator + LTRIM(RTRIM(ISNULL(s2.FirstName, ''))) + @ComponentElementSeparator + 
	LTRIM(RTRIM(ISNULL(s2.MiddleName, ''))) + @ComponentElementSeparator + @ComponentElementSeparator + @ComponentElementSeparator + 'XX' + @ComponentElementSeparator + 
	LTRIM(RTRIM(ISNULL(s2.NationalProviderId, ''))) + @SegmentTerminator
	FROM #837Services AS srv
	JOIN #ClaimLines_Temp cl ON cl.ClaimLineId = srv.ClaimLineId
	JOIN Staff s ON cl.Clinicianid = s.StaffId
	JOIN dbo.ssf_RecodeValuesCurrent('XRequireOrderingPhysician') AS rc ON rc.IntegerCodeId = s.Degree
	JOIN Staff s2 ON cl.AttendingId = s2.StaffId
END

--
-- End BH Redesign Changes
--
error:
GO

