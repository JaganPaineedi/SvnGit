/****** Object:  StoredProcedure [dbo].[csp_ReportPrintEAP]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintEAP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintEAP]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintEAP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_ReportPrintEAP]

@ClaimBatchId  int = NULL,
@ClaimProcessId int = NULL
/*
Purpose: Selects data to print on EAP claim form based on HCFA1500 claim form data.
      Either @ClaimBatchId or @ClaimProcessId has to be passed in.  InvoiceId is the ClaimLineItemGroupId from
      ClaimsNPIHCFA1500s

Updates: 
Date         Author       Purpose
2013.02.24	T.Remisoski		Add column to sort by billing month

*/                 

as
BEGIN

	CREATE TABLE #Months (
		ID int,
		Name varchar(20)
		)

	CREATE TABLE #ServiceInfo (
		ClaimLineItemGroupId int,
		ClientId int,
		ClientName varchar(100),
		ServiceId int,
		DateofService varchar(25),
		ProcedureCode varchar(100),
		ProgramName varchar(100),
		DateofServiceList varchar(max),
		ProcedureCodeList varchar(max),
		ProgramNameList varchar(max),
		BillingMonth varchar(6)
		)

	INSERT INTO #Months (ID, Name)
	SELECT 1,''January'' UNION
	SELECT 2,''February'' UNION
	SELECT 3,''March'' UNION
	SELECT 4,''April'' UNION
	SELECT 5,''May'' UNION
	SELECT 6,''June'' UNION
	SELECT 7,''July'' UNION
	SELECT 8,''August'' UNION
	SELECT 9,''September'' UNION
	SELECT 10,''October'' UNION
	SELECT 11,''November'' UNION
	SELECT 12,''December''

	INSERT INTO #ServiceInfo (ClaimLineItemGroupId,ClientId,ClientName,ServiceId,DateofService,ProcedureCode,ProgramName,
		DateofServiceList,ProcedureCodeList,ProgramNameList, BillingMonth)
	SELECT clig.ClaimLineItemGroupId,CONVERT(varchar,s.ClientId),cl.LastName+'', ''+cl.FirstName,s.ServiceId,CONVERT(varchar,s.DateofService,101),pc.ProcedureCodeName,p.ProgramName,
		'''','''','''',
		CAST(DATEPART(YEAR, s.DateOfService) as varchar(4)) + RIGHT(''0'' + CAST(DATEPART(MONTH, s.DateOfService) as varchar(2)),  2)
	FROM ClaimLineItemCharges clic
	JOIN ClaimLineItems cli ON cli.ClaimLineItemId = clic.ClaimLineItemId
	JOIN ClaimLineItemGroups clig ON clig.ClaimLineItemGroupId = cli.ClaimLineItemGroupId
	JOIN ClaimBatches cb ON cb.ClaimBatchId = clig.ClaimBatchId
	JOIN Charges c ON c.ChargeId = clic.ChargeId
	JOIN Services s ON s.ServiceId = c.ServiceId
	JOIN Clients cl ON cl.ClientId = s.ClientId
	JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
	JOIN Programs p ON p.ProgramId = s.ProgramId
	WHERE (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
		AND ISNULL(clic.RecordDeleted,''N'')<>''Y''
		AND ISNULL(cli.RecordDeleted,''N'')<>''Y''
		AND ISNULL(clig.RecordDeleted,''N'')<>''Y''
		AND ISNULL(cb.RecordDeleted,''N'')<>''Y''
		AND ISNULL(c.RecordDeleted,''N'')<>''Y''
		AND ISNULL(s.RecordDeleted,''N'')<>''Y''
		AND ISNULL(cl.RecordDeleted,''N'')<>''Y''
		AND ISNULL(pc.RecordDeleted,''N'')<>''Y''
		AND ISNULL(p.RecordDeleted,''N'')<>''Y''

	UPDATE a SET
		DateofServiceList = REPLACE(c.DateofServiceList,''*'',CHAR(13)+CHAR(10)),
		ProcedureCodeList = REPLACE(c.ProcedureCodeList,''*'',CHAR(13)+CHAR(10)),
		ProgramNameList = REPLACE(c.ProgramNameList,''*'',CHAR(13)+CHAR(10))
	FROM #ServiceInfo a
	JOIN (
		SELECT
			ClaimLineItemGroupId,
			STUFF((SELECT ''* '' + DateofServiceList + CAST(DateofService AS VARCHAR(MAX)) 
				FROM #ServiceInfo
				WHERE ClaimLineItemGroupId = b.ClaimLineItemGroupId
				FOR XML PATH ('''')),1,2,'''') AS DateofServiceList,
			STUFF((SELECT ''* '' + ProcedureCodeList + CAST(ProcedureCode AS VARCHAR(MAX)) 
				FROM #ServiceInfo
				WHERE ClaimLineItemGroupId = b.ClaimLineItemGroupId
				FOR XML PATH ('''')),1,2,'''') AS ProcedureCodeList,
			STUFF((SELECT ''* '' + ProgramNameList + CAST(ProgramName AS VARCHAR(MAX)) 
				FROM #ServiceInfo
				WHERE ClaimLineItemGroupId = b.ClaimLineItemGroupId
				FOR XML PATH ('''')),1,2,'''') AS ProgramNameList
		FROM #ServiceInfo b
		GROUP BY ClaimLineItemGroupId
		) c ON c.ClaimLineItemGroupId = a.ClaimLineItemGroupId

	SELECT a.ClaimLineItemGroupId, a.ClientId, TodayDate=d.Name + '' '' + CONVERT(varchar,DATEPART(dd,a.TodayDate)) + '', '' +CONVERT(varchar,DATEPART(yyyy,a.TodayDate)), 
		a.ProgramName, ProgramAddress, BillingMonth=e.Name + '' '' + LEFT(s.BillingMonth,4),
		UnitRate, NumberCharges, TotalCharges, PaymentAddress, TaxId,
		s.ClientName,s.DateofServiceList,s.ProcedureCodeList,s.ProgramNameList, s.BillingMonth as BillingMonthSort
	FROM CustomClaimEAPS a
	JOIN ClaimLineItemGroups b on b.ClaimLineItemGroupId = a.ClaimLineItemGroupId
	JOIN ClaimBatches cb on cb.ClaimBatchId = b.ClaimBatchId
	JOIN #Months d on d.ID = CONVERT(int,DATEPART(mm,a.TodayDate))
	JOIN #ServiceInfo s ON s.ClaimLineItemGroupId = a.ClaimLineItemGroupId
	LEFT JOIN #Months e on e.ID = CAST(RIGHT(s.BillingMonth,2) as int)
	WHERE (cb.ClaimBatchId = @ClaimBatchId or cb.ClaimProcessId = @ClaimProcessId)
	AND IsNull(a.RecordDeleted,''N'') <> ''Y''
	AND IsNull(b.RecordDeleted,''N'') <> ''Y''
	AND IsNull(cb.RecordDeleted,''N'') <> ''Y''
	--order by s.ClientId, s.BillingMonth

--*/
END
' 
END
GO
