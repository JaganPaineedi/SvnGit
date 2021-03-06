/****** Object:  StoredProcedure [dbo].[csp_ReportPrintBVR]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBVR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintBVR]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBVR]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

--select top 100 * from dbo.ClaimBatches where CreatedBy = ''javed'' order by CreatedDate desc
--[csp_ReportPrintBVR] 3691

CREATE PROCEDURE [dbo].[csp_ReportPrintBVR]
@ClaimBatchId  int = null,
@ClaimProcessId int = null
/*
Purpose: Selects data to print on BVR claim form based on HCFA1500 claim form data.
      Either @ClaimBatchId or @ClaimProcessId has to be passed in.

Updates: 
Date		Author		Purpose
5/29/12		JJN			Created
8/02/12		JJN			Changed Client Address to Plan Address
3/11/13		TER			Harbor no longer needs auth-to-note link

*/  

AS
Begin

-- 3/11/13 - comented this call
--EXEC dbo.csp_JobUpdateVocationalNotesWithMissingAuthNum

SELECT TodayDate1=Convert(varchar(25),GetDate(),107), 
	TodayDate2=Convert(varchar(11),GetDate(),101),
	PlanAddress=cp.Address, 
	PlanCityStateZip=cp.City+'', ''+cp.State+'' ''+cp.ZipCode, 
	AgAddress=ag.Address, 
	AgCSZ=ag.City+'', ''+ag.State+'' ''+ag.ZipCode,
	AgPhone=Left(ag.BillingPhone,3)+''.''+Right(Left(ag.BillingPhone,6),3)+''.''+Right(ag.BillingPhone,4),
	AgFax=''419.479.3230'',
	AgWebsite=''www.harbor.org'',
	ClientName=cl.LastName+'', ''+cl.FirstName+Coalesce('' ''+Left(cl.MiddleName,1)+''.'',''''),
	ClientSSN=''XXX-XX-''+Right(cl.SSN,4),	
	cl.ClientId,
	ClaimBatchId=cb.ClaimBatchId,
	AuthorizationNumber=a.AuthorizationNumber,
	sa.AuthorizationId,
	ir.ImageRecordId
FROM ClaimBatches cb
JOIN ClaimBatchCharges cbc ON cbc.ClaimBatchId = cb.ClaimBatchId
JOIN Charges c ON c.ChargeId = cbc.ChargeId
JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
JOIN Services s ON s.ServiceId = c.ServiceId
LEFT JOIN ServiceAuthorizations sa ON sa.ServiceId = s.ServiceId
LEFT JOIN Authorizations a ON a.AuthorizationId = sa.AuthorizationId
JOIN Clients cl ON cl.ClientId = s.ClientId
CROSS JOIN Agency ag
LEFT join dbo.Documents as doc on doc.DocumentCodeId = 1000403 and doc.ClientId = s.ClientId and DATEDIFF(MONTH, s.DateOfService, doc.EffectiveDate) = 0 and ISNULL(doc.RecordDeleted, ''N'') <> ''Y''
LEFT join dbo.ImageRecords as ir on ir.DocumentVersionId = doc.CurrentDocumentVersionId
WHERE (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
AND ISNULL(cb.RecordDeleted,''N'') <> ''Y''
AND ISNULL(cbc.RecordDeleted,''N'') <> ''Y''
AND ISNULL(c.RecordDeleted,''N'') <> ''Y''
AND ISNULL(ccp.RecordDeleted,''N'') <> ''Y''
AND ISNULL(cp.RecordDeleted,''N'') <> ''Y''
AND ISNULL(s.RecordDeleted,''N'') <> ''Y''
AND ISNULL(sa.RecordDeleted,''N'') <> ''Y''
AND ISNULL(a.RecordDeleted,''N'') <> ''Y''
AND ISNULL(cl.RecordDeleted,''N'') <> ''Y''
ORDER BY ClientName

End



' 
END
GO
