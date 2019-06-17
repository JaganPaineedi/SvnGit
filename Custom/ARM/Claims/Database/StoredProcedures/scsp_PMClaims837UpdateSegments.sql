IF OBJECT_ID('scsp_PMClaims837UpdateSegments','P') IS NOT NULL 
DROP PROC scsp_PMClaims837UpdateSegments
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[scsp_PMClaims837UpdateSegments] 
@CurrentUser VARCHAR(30), @ClaimBatchId INT, @FormatType CHAR(1) = 'P'
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_PMClaims837UpdateSegments                         */
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
/*	11/10/2017	MJensen		Added BH Redesign change ARM Enhancements Task 19.01	*/
/*	11/30/2017	mjensen		modify referring loop to be ordering provider for OH Medicaid when clinician has specific degree ARM support #754 */
/*	12/27/2017	MJensen		move BH redesign changes to separate proc */
/*********************************************************************/

DECLARE @CurrentDate DATETIME

SET @CurrentDate = GETDATE()

DECLARE @ComponentElementSeparator CHAR(1)
		,@SegmentTerminator VarCHAR(2)

UPDATE #837Claims
SET RenderingRefSegment = NULL
FROM #837Claims a
JOIN #Charges AS b ON b.ClaimLineId = a.ClaimLineId
IF @@error <> 0 GOTO error


UPDATE #837Claims
SET RenderingRef2Segment = NULL
FROM #837Claims a
JOIN #Charges AS b ON b.ClaimLineId = a.ClaimLineId
IF @@error <> 0 GOTO error


UPDATE #837Claims
SET ReferringRefSegment = NULL
IF @@error <> 0 GOTO error


UPDATE #837Claims
SET ReferringRef2Segment = NULL
IF @@error <> 0 GOTO error


UPDATE #837Claims
SET FacilityRefSegment = NULL
IF @@error <> 0 GOTO error


UPDATE #837Claims
SET FacilityRef2Segment = NULL
IF @@error <> 0 GOTO error


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
	EXEC csp_PMClaims837UpdateSegments @CurrentUser = @CurrentUser
		,@ClaimBatchId = @ClaimBatchId
		,@FormatType = @FormatType
END
		--
		-- End BH Redesign Changes
		--



error:





GO


