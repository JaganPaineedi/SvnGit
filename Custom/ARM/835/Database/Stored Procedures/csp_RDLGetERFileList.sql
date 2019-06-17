if object_id('csp_RDLGetERFileList', 'P') is not null
	drop procedure csp_RDLGetERFileList
go

create procedure csp_RDLGetERFileList
/******************************************************************************
**
**  Name: csp_RDLGetERFileList
**  Desc:
**  Provide a file list summary for imported 835 files.
**
**  Return values:
**
**  Parameters:   csp_RDLGetERFileList
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 10/1/2012 TER	  Created
** 2/2/2016   Dknewtson  Including error records from backend uploads
*******************************************************************************/
	@ImportFromDate datetime,
	@ImportToDate datetime
as

-- provide a simple file summary in a report format
select b.CheckNumber, 
f.ERFileId, 
f.[FileName], 
f.ImportDate, 
s.SenderName, 
b.CheckAmount, 
f.Processed,
(select sum(p.Amount)
	From dbo.Payments p 
	join dbo.ERBatchPayments bp on p.PaymentId = bp.PaymentId
	and isnull(bp.RecordDeleted,'N')='N'
	where isnull(p.RecordDeleted,'N')='N'
	and bp.ERBatchId = b.ERBatchId
	) as [SC Payment Amount],
b.TotalProviderAdjustments,
b.ERBatchId
from dbo.ERFiles as f
join dbo.ERBatches as b on b.ERFileId = f.ERFileId
and isnull(b.RecordDeleted,'N')='N'
join dbo.ERSenders as s on s.ERSenderId = f.ERSenderId
and isnull(s.RecordDeleted,'N')='N'
where DATEDIFF(DAY, @ImportFromDate, f.ImportDate) >= 0
and DATEDIFF(DAY, @ImportToDate, f.ImportDate) <= 0
and isnull(f.RecordDeleted,'N')='N'
UNION ALL
SELECT efe.ErrorMessage AS CheckNumber
,NULL AS ERFIleId
,RIGHT(ef.FileName,CHARINDEX('\',REVERSE(ef.FileName))-1) AS FileName
,ef.CreatedDate AS ImportDate
,NULL AS SenderName
,NULL AS CheckAmount
,'N' AS Processed
,NULL AS [SC Payment Amount]
,NULL AS TotalProviderAdjustments
,NULL AS ERBatchId
from dbo.EDIFiles ef
     JOIN dbo.EDIFileErrors efe ON ef.EDIFileId = efe.EDIFileId
     JOIN dbo.CustomEDIFilesERFiles cefef ON ef.EDIFileId = cefef.EDIFileId
          AND ISNULL(cefef.RecordDeleted,'N') <> 'Y'
where DATEDIFF(DAY, @ImportFromDate, ef.CreatedDate) >= 0
and DATEDIFF(DAY, @ImportToDate, ef.CreatedDate) <= 0
AND ISNULL(efe.RecordDeleted,'N') <> 'Y'
AND ISNULL(ef.RecordDeleted,'N') <> 'Y'
order by 4,5,2

go
