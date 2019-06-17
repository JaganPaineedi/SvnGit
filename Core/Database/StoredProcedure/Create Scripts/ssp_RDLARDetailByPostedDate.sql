USE [40DemoSmartCare]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLARDetailByPostedDate]    Script Date: 1/30/2017 3:36:40 PM ******/
DROP PROCEDURE [dbo].[ssp_RDLARDetailByPostedDate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLARDetailByPostedDate]    Script Date: 1/30/2017 3:36:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[ssp_RDLARDetailByPostedDate]
 @PostedFromDate DATETIME
,@PostedEndDate DATETIME
,@ThruAccountingPeriodEnd DATETIME
AS

	-- Append time to ending dates
	-- 1. strip off time, if any; 
	-- 2. Add a day; 
	-- 3. Subtract 2 milliseconds (system rounds 1 ms to next day, so we have to subtract 2 ms)
	SET @PostedEndDate			 = DATEADD(ms, -2, DATEADD(dd, 1, CAST(CAST(@PostedEndDate           AS DATE) AS DATETIME)))
	SET @ThruAccountingPeriodEnd = DATEADD(ms, -2, DATEADD(dd, 1, CAST(CAST(@ThruAccountingPeriodEnd AS DATE) AS DATETIME)))

	SELECT s.ServiceId                                       
	,      s.ClientId
	,      ISNULL(pr.PayerName, 'CLIENT')                     AS PayerName                                        
	,      pc.DisplayAs                                       AS ProcedureCode
	,      pg.ProgramCode                                    
	,      ar.ARLedgerId                                     
	,      ar.PostedDate                                     
	,      ap.[Description]                                   AS AcctgPeriodName
	,      gc.CodeName                                        AS LedgerType
	,      ar.Amount                                         
	,      CASE ar.LedgerType WHEN 4201 THEN 'REVENUE'
	                          WHEN 4204 THEN 'REVENUE'
	                          WHEN 4202 THEN 'PAYMENT'
	                          WHEN 4203 THEN 'ADJUSTMENT' END AS RevenueOrPaymentOrAdj
	,      DATEPART(MONTH, ar.PostedDate)                     AS PostMonth
	,      DATEPART(DAY, ar.PostedDate)                       AS PostDay
	,      DATEPART(YEAR, ar.PostedDate)                      AS PostYear
	,      DATEPART(MONTH, ap.StartDate)                      AS AcctMonth
	,      DATEPART(YEAR, ap.StartDate)                       AS AcctYear

	FROM ARLedger				AS ar 
	JOIN AccountingPeriods		AS ap	ON ap.AccountingPeriodId = ar.AccountingPeriodId 
	JOIN Charges				AS chg	ON chg.ChargeId = ar.ChargeId 
	JOIN Services				AS s	ON s.ServiceId = chg.ServiceId 
	JOIN ProcedureCodes			AS pc	ON pc.ProcedureCodeId = s.ProcedureCodeId 
	JOIN Programs				AS pg	ON pg.ProgramId = s.ProgramId 
	LEFT JOIN GlobalCodes	AS gc	ON gc.GlobalCodeId = ar.LedgerType
	LEFT JOIN ClientCoveragePlans AS ccp ON ccp.ClientCoveragePlanId = chg.ClientCoveragePlanId
	LEFT JOIN CoveragePlans		AS cp	ON cp.CoveragePlanId = ccp.CoveragePlanId
	LEFT JOIN Payers			AS pr	ON pr.PayerId = cp.PayerId
	--where datediff(day, ar.PostedDate, @PostedFromDate) <= 0
	--	and datediff(day, ar.PostedDate, @PostedEndDate) >= 0
	--	and datediff(day, ap.EndDate, @ThruAccountingPeriodEnd) >= 0
	WHERE ar.PostedDate BETWEEN @PostedFromDate AND @PostedEndDate 
	AND ap.EndDate <= @ThruAccountingPeriodEnd 


GO


