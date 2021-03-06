/****** Object:  StoredProcedure [dbo].[csp_Report_month_end_report]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_month_end_report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_month_end_report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_month_end_report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_month_end_report]
	@start_date		date,
	@end_date		date

AS
--*/

/*
DECLARE	@start_date		date,
		@end_date		date

SELECT	@start_date = ''6/4/12'',
		@end_date = ''6/4/12''
--*/

/********************************************************************/
/* Stored Procedure: csp_Report_month_end_report					*/
/* Creation Date:    11/5/2012										*/
/* Copyright:        Harbor											*/
/*																	*/
/* Description:	Gives the total adjustments, payments, transfers	*/
/*	and grand totals for the various payer types for the inputted	*/
/*	time periods.													*/
/*																	*/
/* Updates:															*/
/*	Date		Author			Purpose								*/
/*	11/05/2012	Ryan Mapes		Created								*/
/********************************************************************/

DECLARE @Month_END Table
(
	CodeName	varchar (50),
	Adjustments money,
	Payments money,
	Transfers money 
)

INSERT INTO @Month_END
Select ISNULL(gc.CodeName,''Self Pay'') AS ''Self Pay'',
		SUM	(CASE WHEN ar.LedgerType = 4203 -- Adjustments Global Code
		     	THEN ar.Amount
				END)as Adjustments, --Adjustments
        
        SUM	(CASE WHEN ar.LedgerType = 4202 -- Payments Global Code
	            THEN ar.Amount
		        END)as Payments,	--Payments
        SUM	(CASE WHEN ar.LedgerType = 4204 -- Transfers Global Code
	            THEN ar.Amount
		        END)as Transfers	--Transfer

FROM dbo.ARLedger ar

LEFT Join dbo.CoveragePlans cp
ON ar.CoveragePlanId =cp.CoveragePlanId

and (ISNULL(cp.RecordDeleted,''N'')<>''Y'')

LEFT Join Payers p
ON cp.PayerId = p.PayerId
and (ISNULL(p.RecordDeleted,''N'')<>''Y'')

LEFT Join GlobalCodes gc
ON p.PayerType = gc.GlobalCodeId
and (ISNULL(gc.RecordDeleted,''N'')<>''Y'')

JOIN dbo.AccountingPeriods ap
ON ar.AccountingPeriodId = ap.AccountingPeriodId
and (ISNULL(ap.RecordDeleted,''N'')<>''Y'')

--WHERE ap.StartDate >=@start_date AND ap.EndDate >=@start_date AND ap.StartDate < DATEADD(dd, 1, @end_date)AND ap.EndDate < DATEADD(dd, 1, @end_date)
WHERE ap.StartDate < DATEADD(dd, 1, @end_date) AND ap.EndDate >=@start_date
and (ISNULL(ar.RecordDeleted,''N'')<>''Y'')
GROUP BY gc.CodeName
--ORDER BY gc.CodeName


UPDATE @Month_END
SET	adjustments = 0
WHERE adjustments is NULL

UPDATE @Month_END
SET	payments = 0
WHERE payments is NULL

UPDATE @Month_END 
SET	Transfers = 0
WHERE Transfers is NULL

DELETE @Month_END
WHERE Adjustments + Payments + transfers = 0

SELECT * 
FROM @Month_END
		        




' 
END
GO
