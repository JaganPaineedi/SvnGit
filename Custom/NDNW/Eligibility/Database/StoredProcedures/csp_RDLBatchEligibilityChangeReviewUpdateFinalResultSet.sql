IF OBJECT_ID('csp_RDLBatchEligibilityChangeReviewUpdateFinalResultSet','P') IS NOT NULL
	DROP PROCEDURE csp_RDLBatchEligibilityChangeReviewUpdateFinalResultSet
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

create PROCEDURE csp_RDLBatchEligibilityChangeReviewUpdateFinalResultSet @BatchId INT 
AS
BEGIN
/**************************************************************************************
   Procedure: csp_RDLBatchEligibilityChangeReviewUpdateFinalResultSet
   
   Streamline Healthcare Solutions, LLC Copyright 10/11/2018

   Purpose: Custom Logic for final result set for csp_RDLBatchEligibilityChangeReview

   Parameters: 
      @BatchId - the batchid 

   Output: 
      

   Called By: 
*****************************************************************************************
   Revision History:
   10/11/2018 - Dknewtson - Created

*****************************************************************************************/


		-- remove "not eligible" records where the client is only "Not Eligible" the day after the response was sent.
		-- sometimes payers won't send "active" records for the future.
		DELETE frs
		FROM #FinalResultSet frs
			JOIN dbo.ElectronicEligibilityVerificationBatches b ON b.ElectronicEligibilityVerificationBatchId = @BatchId
		WHERE VerifiedResponseType = 'Not Eligible'
			AND DATEDIFF(DAY,b.CreatedDate,frs.StartDate) > 0

		-- we don't care about service area "General"

		DELETE FROM #FinalResultSet WHERE ServiceAreaId = 1

RETURN
END

GO

