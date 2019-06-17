if object_id('csp_ReportGetERFileSummary', 'P') is not null
	drop procedure csp_ReportGetERFileSummary
go

create procedure csp_ReportGetERFileSummary
/******************************************************************************        
**   
**  Name: csp_ReportGetERFileSummary        
**  Desc:         
**  Report used for sub-report on 835 file information      
**        
**  Return values:        
**         
**  Called by:   My Reports and used as a subreport
**                      
**  Parameters:   csp_ReportGetERFileSummary @ERFileId
**        
**  Auth:         
**  Date:         
*******************************************************************************        
**  Change History        
*******************************************************************************        
**  Date:     Author:   Description:        
** 9/27/2012  TER  Created    
** 12/4/2015  Jcarlson  1) Added In Coverage Plan name to CheckNumber
				    2) Changed logic of check amount
				    #) added in the total amount posted to SC as a new column
*******************************************************************************/      

	@ERFileId int
as

/*select a.ERFileId, a.FileName, a.ImportDate, s.SenderName, b.ERBatchId, b.CheckNumber, b.CheckAmount, b.CheckDate
from dbo.ERFiles as a
join dbo.ERBatches as b on b.ERFileId = a.ERFileId
LEFT join dbo.ERSenders as s on s.ERSenderId = a.ERSenderId
where a.ERFileId = 42--@ERFileId
and ISNULL(b.RecordDeleted, 'N') <> 'Y'
and ISNULL(s.RecordDeleted, 'N') <> 'Y'
*/
BEGIN
SELECT erf.ERFileId,
 erf.[FileName], 
 erf.ImportDate, 
 ers.SenderName, 
 erb.ERBatchId, 
 CASE
    WHEN  cp.PayerName IS NULL 
	   THEN 'No Payer Found - ' + erbp.CheckNumber
    WHEN cp.PayerName IS NOT NULL
	   THEN cp.PayerName + ' - ' + erbp.CheckNumber
	 END AS CoveragePlanAndCheckNumber, 
 erbp.Amount AS [835 Amount], 
 CAST(ISNULL(p.Amount,'0.00') AS MONEY) AS [SC Payment Total],
 CAST(ISNULL(p.Amount - p.UnpostedAmount,'0.00') AS MONEY) AS [SC Payment], 
 erb.CheckDate,
erb.TotalProviderAdjustments
FROM ERBatchPayments erbp
JOIN ERBatches erb ON erbp.ERBatchId = erb.ERBatchId
AND ISNULL(erb.RecordDeleted,'N')='N'
JOIN ERFiles erf ON erb.ERFileId = erf.ERFileId
AND ISNULL(erf.RecordDeleted,'N')='N'
JOIN ERSenders ers ON erf.ERSenderId = ers.ERSenderId
AND ISNULL(ers.RecordDeleted,'N')='N'
LEFT JOIN dbo.Payers cp ON erbp.PayerId = cp.PayerId
AND ISNULL(cp.RecordDeleted,'N')='N'
LEFT JOIN Payments p ON erbp.PaymentId = p.PaymentId
AND ISNULL(p.RecordDeleted,'N')='N'
WHERE erf.ERFileId = @ERFileId
END
GO
