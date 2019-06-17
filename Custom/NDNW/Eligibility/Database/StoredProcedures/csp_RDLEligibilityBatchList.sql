IF OBJECT_ID('csp_RDLEligibilityBatchList') IS NOT NULL
	DROP PROCEDURE csp_RDLEligibilityBatchList
GO

SET ANSI_NULLS on 
SET QUOTED_IDENTIFIER ON 
GO

CREATE PROCEDURE csp_RDLEligibilityBatchList @FromDate DATETIME 
,@ToDate DATETIME = NULL
AS
BEGIN
/**************************************************************************************
   Procedure: csp_RDLEligibilityBatchList
   
   Streamline Healthcare Solutions, LLC Copyright 8/16/2018

   Purpose: List batches sent between certain dates

   Parameters: 
      @FromDate
	  @ToDate

   Output: 
      Table list

   Called By: 
*****************************************************************************************
   Revision History:
   8/16/2018 - Dknewtson - Created

*****************************************************************************************/

SELECT   eevb.ElectronicEligibilityVerificationBatchId
		,eevb.BatchName
		,eevp.ElectronicPayerName
		,CASE eevb.Status WHEN 0 THEN 'Not Yet Processed' 
						  WHEN 1 THEN 'Processed Not approved for Update'
						  WHEN 2 THEN 'Queued for Update'
						  WHEN 3 THEN 'Client Coverage Updated'
		 END AS Status
		,COUNT(DISTINCT eevr.EligibilityVerificationRequestId) AS NumberRequests
		,COUNT(DISTINCT eevr.ClientId) AS NumberClients
FROM     dbo.ElectronicEligibilityVerificationBatches AS eevb
		 LEFT JOIN dbo.ElectronicEligibilityVerificationRequests AS eevr ON eevr.ElectronicEligibilityVerificationBatchId = eevb.ElectronicEligibilityVerificationBatchId
			AND ISNULL(eevr.RecordDeleted,'N') <> 'Y'
		 LEFT JOIN dbo.ElectronicEligibilityVerificationPayers AS eevp ON eevp.ElectronicEligibilityVerificationPayerId = eevr.ElectronicEligibilityVerificationPayerId
		
WHERE DATEDIFF(DAY,@FromDate,eevb.CreatedDate) >=0
	AND (@ToDate IS NULL OR DATEDIFF(DAY,eevb.CreatedDate,@ToDate) >= 0)
		-- intentionally checking record delete on left join here to exclude batches where the payer is deleted
		AND ISNULL(eevp.RecordDeleted,'N') <> 'Y'
		AND ISNULL(eevb.RecordDeleted,'N') <> 'Y'
GROUP BY eevb.ElectronicEligibilityVerificationBatchId
		,eevb.BatchName
		,eevp.ElectronicPayerName
		,eevb.Status


RETURN
END
GO
