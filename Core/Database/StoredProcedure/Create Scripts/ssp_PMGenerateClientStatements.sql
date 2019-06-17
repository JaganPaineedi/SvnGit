IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_PMGenerateClientStatements')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PMGenerateClientStatements]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMGenerateClientStatements] @CurrentUser VARCHAR(30)
	,@ClientStatementBatchId INT
	,@DetailsFrom DATETIME
	,@DetailsTo DATETIME
AS /****************************************************************************************************/
/* Procedure: [ssp_PMGenerateClientStatements]              */
/*                         */
/* Purpose: Calculate details of client statement for a given ClientStatementBatchId.    */
/*                         */
/* Created By: SmartData                   */
/*                         */
/* Modifications:                     */
/* TER - 01/22/2008 - Removed delete from #ClientStatements logic.         */
/* SRF - 3/20/2008 - Changed ResponsiblePartyZip to 10 characters      */
/* Rohit Verma 09/16/2008 added the condition to limit 50 characters of Clients.FirstName + Clients.FirstName to store into */
/*  ClientStatements.ResponsiblePartyName column*/
--  04/11/2012  MSuma  Added Statement Count  
--	JAN-22-2014	dharvey		Added RecordDeleted checks on Services, Charges, ARLedger tables to prevent invalid totals
--	03/19/2018	Jess (Harbor)	Added RecordDeleted check on ClientAddresses table.  Harbor support, #1663
/****************************************************************************************************/
CREATE TABLE #ClientStatements (
	ClientStatementId INT NOT NULL
	,ClientId INT NOT NULL
	)

CREATE TABLE #ActivityServices (
	ClientStatementId INT NOT NULL
	,ServiceId INT NOT NULL
	)

IF @@error <> 0
	GOTO error

CREATE TABLE #BalanceForward (
	ClientStatementId INT NOT NULL
	,InsuranceBalance MONEY NULL
	,ClientBalance MONEY NULL
	)

IF @@error <> 0
	GOTO error

CREATE TABLE #ActivityClientBalances (
	ClientStatementId INT NOT NULL
	,ClientBalance MONEY NULL
	)

IF @@error <> 0
	GOTO error

CREATE TABLE #SortOrders (
	ClientStatementId INT NOT NULL
	,LastName VARCHAR(51) NULL
	,FirstName VARCHAR(51) NULL
	,ClientId INT NOT NULL
	,ResponsiblePartyZip CHAR(10) NULL
	,SortOrder VARCHAR(50) NULL
	)

IF @@error <> 0
	GOTO error

DECLARE @StatementCount INT

-- get list of client Statements      
INSERT INTO #ClientStatements (
	ClientStatementId
	,ClientId
	)
SELECT ClientStatementId
	,ClientId
FROM ClientStatements
WHERE ClientStatementBatchId = @ClientStatementBatchId

IF @@error <> 0
	GOTO error

SELECT @StatementCount = COUNT(*)
FROM #ClientStatements

IF @@error <> 0
	GOTO error

DECLARE @CurrentDate DATETIME
--DECLARE @ErrorNumber INT
--	,@ErrorMessage VARCHAR(500)

SET @CurrentDate = GETDATE()

-- Activity start date is current date - 30      
DECLARE @ActivityStartDate DATETIME
DECLARE @ActivityEndDate DATETIME

-- In case printing a single patient statement print all transactions if details_from is null      
IF @DetailsFrom IS NULL
	SET @DetailsFrom = DATEADD(dd, - 30, CONVERT(DATETIME, CONVERT(VARCHAR, ISNULL(@DetailsTo, GETDATE()), 101)))
SET @ActivityStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, @DetailsFrom, 101))
SET @ActivityEndDate = DATEADD(dd, + 1, CONVERT(DATETIME, CONVERT(VARCHAR, ISNULL(@DetailsTo, GETDATE()), 101)))

SELECT @ActivityStartDate
	,@ActivityEndDate
	,@StatementCount AS NumberOfStatementsPrinted

-- Get a list of clinical transaction where there has been any activity since activity start date      
INSERT INTO #ActivityServices (
	ClientStatementId
	,ServiceId
	)
SELECT DISTINCT a.ClientStatementId
	,d.ServiceId
FROM #ClientStatements a
JOIN ARLedger b ON (a.ClientId = b.ClientId)
JOIN Charges c ON (b.ChargeId = c.ChargeId)
JOIN Services d ON (c.ServiceId = d.ServiceId)
WHERE d.STATUS <> 76
	AND ISNULL(b.MarkedAsError, 'N') = 'N'
	AND ISNULL(b.ErrorCorrection, 'N') = 'N'
	AND ISNULL(b.RecordDeleted, 'N') = 'N'
	AND ISNULL(c.RecordDeleted, 'N') = 'N'
	AND ISNULL(d.RecordDeleted, 'N') = 'N'
	AND b.PostedDate >= @ActivityStartDate
	AND b.PostedDate < @ActivityEndDate
	-- Exclude 1 cent services
	AND d.Charge > .01

IF @@error <> 0
	GOTO error

-- Compute balance forward      
-- Default to balance for all transactions      
-- The balance for detail transactions will be subtracted later      
INSERT INTO #BalanceForward (
	ClientStatementId
	,InsuranceBalance
	,ClientBalance
	)
SELECT a.ClientStatementId
	,ISNULL(SUM(CASE 
				WHEN c.Priority <> 0
					THEN d.Amount
				ELSE 0
				END), 0)
	,ISNULL(SUM(CASE 
				WHEN c.Priority = 0
					THEN d.Amount
				ELSE 0
				END), 0)
FROM #ClientStatements a
JOIN Services b ON (a.ClientId = b.ClientId)
JOIN Charges c ON (b.ServiceId = c.ServiceId)
JOIN ARLedger d ON (c.ChargeId = d.ChargeId)
WHERE b.STATUS <> 76
	AND d.PostedDate < @ActivityEndDate
	AND ISNULL(b.RecordDeleted, 'N') = 'N'
	AND ISNULL(c.RecordDeleted, 'N') = 'N'
	AND ISNULL(d.RecordDeleted, 'N') = 'N'
	AND NOT EXISTS (
		SELECT *
		FROM #ActivityServices z
		WHERE b.ServiceId = z.ServiceId
		)
GROUP BY a.ClientStatementId

IF @@error <> 0
	GOTO error

-- Get Activity Client Balance      
INSERT INTO #ActivityClientBalances (
	ClientStatementId
	,ClientBalance
	)
SELECT a.ClientStatementId
	,SUM(c.Amount)
FROM #ActivityServices a
JOIN Charges b ON (a.ServiceId = b.ServiceId)
JOIN ARLedger c ON (b.ChargeId = c.ChargeId)
WHERE b.Priority = 0
	AND ISNULL(b.RecordDeleted, 'N') = 'N'
	AND ISNULL(c.RecordDeleted, 'N') = 'N'
GROUP BY a.ClientStatementId

IF @@error <> 0
	GOTO error

-- Delete Client Statements without balance      
-- TER 01/22/2008 - Disabled.  This logic does not suppress the ClientStatment from printing and causes missing data due to #SortOrders missing.      
--delete b      
--from #ClientStatements a      
--JOIN ClientStatements b ON (a.ClientStatementId = b.ClientStatementId)      
--where not exists      
--(select * from      
--#ActivityServices c      
--where a.ClientStatementId = c.ClientStatementId)      
--and not exists      
--(select * from      
--#BalanceForward c      
--where a.ClientStatementId = c.ClientStatementId      
--and isnull(c.ClientBalance,0) <> 0)      
--      
--if @@error <> 0 goto error      
--      
--delete a      
--from #ClientStatements a      
--where not exists      
--(select * from      
--#ActivityClientBalances c      
--where a.ClientStatementId = c.ClientStatementId)      
--and not exists      
--(select * from      
--#BalanceForward c      
--where a.ClientStatementId = c.ClientStatementId      
--and isnull(c.ClientBalance,0) <> 0)      
--      
--if @@error <> 0 goto error      
SELECT @StatementCount = COUNT(*)
FROM #ClientStatements

IF @@error <> 0
	GOTO error

-- Set Sort Order      
-- Get Sort Fields      
INSERT INTO #SortOrders (
	ClientStatementId
	,LastName
	,FirstName
	,ClientId
	,ResponsiblePartyZip
	)
SELECT a.ClientStatementId
	,e.LastName
	,e.FirstName
	,e.ClientId
	,CASE 
		WHEN ISNULL(e.FinanciallyResponsible, 'N') = 'Y'
			THEN f.Zip
		ELSE h.Zip
		END
FROM #ClientStatements a
JOIN Clients e ON (a.ClientId = e.ClientId)
LEFT JOIN ClientAddresses f ON (
		e.ClientId = f.ClientId
		AND f.Billing = 'Y'
		AND ISNULL(f.RecordDeleted, 'N') = 'N' -- Added by Jess (Harbor) 3/19/18
		)
LEFT JOIN ClientContacts g ON (
		e.ClientId = g.ClientId
		AND ISNULL(g.FinanciallyResponsible, 'N') = 'Y'
		AND ISNULL(g.RecordDeleted, 'N') = 'N'
		)
LEFT JOIN ClientContactAddresses h ON (
		g.ClientContactId = h.ClientContactId
		AND h.Mailing = 'Y'
		AND ISNULL(h.RecordDeleted, 'N') = 'N'
		)

IF @@error <> 0
	GOTO error

DECLARE @SortOrder1 INT
	,@SortOrder2 INT

SELECT @SortOrder1 = ClientStatementSort1
	,@SortOrder2 = ClientStatementSort2
FROM SystemConfigurations

IF @@error <> 0
	GOTO error

UPDATE #SortOrders
SET SortOrder = CASE @SortOrder1
		WHEN 4701
			THEN CONVERT(CHAR(20), LastName)
		WHEN 4702
			THEN CONVERT(CHAR(20), FirstName)
		WHEN 4703
			THEN SUBSTRING(SPACE(10 - LEN(CONVERT(VARCHAR, ClientId))) + CONVERT(VARCHAR, ClientId), 1, 10)
		WHEN 4703
			THEN CONVERT(CHAR(20), ISNULL(ResponsiblePartyZip, ' '))
		ELSE CONVERT(CHAR(20), LastName)
		END + CASE @SortOrder2
		WHEN 4701
			THEN CONVERT(CHAR(20), LastName)
		WHEN 4702
			THEN CONVERT(CHAR(20), FirstName)
		WHEN 4703
			THEN SUBSTRING(SPACE(10 - LEN(CONVERT(VARCHAR, ClientId))) + CONVERT(VARCHAR, ClientId), 1, 10)
		WHEN 4703
			THEN CONVERT(CHAR(20), ISNULL(ResponsiblePartyZip, ' '))
		ELSE CASE 
				WHEN @SortOrder1 IS NULL
					THEN CONVERT(CHAR(20), FirstName)
				ELSE RTRIM('')
				END
		END

IF @@error <> 0
	GOTO error

-- Update Client Statements      
UPDATE b
SET InsuranceBalanceForward = ISNULL(c.InsuranceBalance, 0)
	,ClientBalanceForward = ISNULL(c.ClientBalance, 0)
	,ClientBalance = ISNULL(c.ClientBalance, 0) + ISNULL(d.ClientBalance, 0)
	,ResponsiblePartyName = CASE 
		WHEN ISNULL(e.FinanciallyResponsible, 'N') = 'Y'
			THEN CASE 
					WHEN LEN(e.FirstName + e.LastName) >= 50
						THEN LEFT(e.FirstName + ' ' + e.LastName, 47) + '...'
					ELSE e.FirstName + ' ' + e.LastName
					END
		ELSE CASE 
				WHEN LEN(g.FirstName + g.LastName) >= 50
					THEN LEFT(g.FirstName + ' ' + g.LastName, 47) + '...'
				ELSE g.FirstName + ' ' + g.LastName
				END
		END
	,ResponsiblePartyAddress = CASE 
		WHEN ISNULL(e.FinanciallyResponsible, 'N') = 'Y'
			THEN ISNULL(f.Address, RTRIM('')) + CHAR(13) + CHAR(10) + ISNULL(f.City, RTRIM('')) + ISNULL(', ' + f.STATE, RTRIM('')) + ' ' + ISNULL(f.Zip, RTRIM(''))
		ELSE ISNULL(h.Address, RTRIM('')) + CHAR(13) + CHAR(10) + ISNULL(h.City, RTRIM('')) + ISNULL(', ' + h.STATE, RTRIM('')) + ' ' + ISNULL(h.Zip, RTRIM(''))
		END
	,SortOrder = i.SortOrder
	,ModifiedBy = @CurrentUser
	,ModifiedDate = @CurrentDate
FROM #ClientStatements a
JOIN ClientStatements b ON (a.ClientStatementId = b.ClientStatementId)
LEFT JOIN #BalanceForward c ON (a.ClientStatementId = c.ClientStatementId)
LEFT JOIN #ActivityClientBalances d ON (a.ClientStatementId = d.ClientStatementId)
JOIN Clients e ON (a.ClientId = e.ClientId)
LEFT JOIN ClientAddresses f ON (
		e.ClientId = f.ClientId
		AND f.Billing = 'Y'
		AND ISNULL(f.RecordDeleted, 'N') = 'N' -- Added by Jess (Harbor) 3/19/18
		)
LEFT JOIN ClientContacts g ON (
		e.ClientId = g.ClientId
		AND ISNULL(g.FinanciallyResponsible, 'N') = 'Y'
		AND ISNULL(g.RecordDeleted, 'N') = 'N'
		)
LEFT JOIN ClientContactAddresses h ON (
		g.ClientContactId = h.ClientContactId
		AND h.Mailing = 'Y'
		AND ISNULL(h.RecordDeleted, 'N') = 'N'
		)
JOIN #SortOrders i ON (a.ClientStatementId = i.ClientStatementId)

IF @@error <> 0
	GOTO error

-- Update Client Statement Details      
DELETE a
FROM ClientStatementDetails a
JOIN ClientStatements b ON (a.ClientStatementId = b.ClientStatementId)
WHERE b.ClientStatementBatchId = @ClientStatementBatchId

IF @@error <> 0
	GOTO error

-- Get revenue information for activity transactions      
INSERT INTO ClientStatementDetails (
	ClientStatementId
	,DateOfService
	,ProcedureDescription
	,Clinician
	,Charge
	,InsurancePayment
	,Adjustment
	,ClientPayment
	,InsuranceBalance
	,ClientBalance
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	)
SELECT a.ClientStatementId
	,b.DateOfService
	,CASE 
		WHEN b.STATUS = 73
			THEN 'Appointment Cancelled'
		WHEN b.STATUS = 72
			THEN 'No Show'
		ELSE f.DisplayAs + ' ' + CONVERT(VARCHAR, Unit)
		END
	,c.LastName
	,b.Charge
	,SUM(CASE 
			WHEN e.LedgerType = 4202
				AND d.Priority <> 0
				THEN - e.Amount
			ELSE 0
			END)
	,SUM(CASE 
			WHEN e.LedgerType = 4203
				THEN - e.Amount
			ELSE 0
			END)
	,SUM(CASE 
			WHEN e.LedgerType = 4202
				AND d.Priority = 0
				THEN - e.Amount
			ELSE 0
			END)
	,SUM(CASE 
			WHEN d.Priority <> 0
				THEN e.Amount
			ELSE 0
			END)
	,SUM(CASE 
			WHEN d.Priority = 0
				THEN e.Amount
			ELSE 0
			END)
	,@CurrentUser
	,@CurrentDate
	,@CurrentUser
	,@CurrentDate
FROM #ActivityServices a
JOIN Services b ON (a.ServiceId = b.ServiceId)
JOIN Staff c ON (b.ClinicianId = c.StaffId)
JOIN Charges d ON (b.ServiceId = d.ServiceId)
JOIN ARLedger e ON (d.ChargeId = e.ChargeId)
JOIN ProcedureCodes f ON (b.ProcedureCodeId = f.ProcedureCodeId)
WHERE e.PostedDate < @ActivityEndDate
	AND ISNULL(b.RecordDeleted, 'N') = 'N'
	AND ISNULL(d.RecordDeleted, 'N') = 'N'
	AND ISNULL(e.RecordDeleted, 'N') = 'N'
GROUP BY a.ClientStatementId
	,b.DateOfService
	,CASE 
		WHEN b.STATUS = 73
			THEN 'Appointment Cancelled'
		WHEN b.STATUS = 72
			THEN 'No Show'
		ELSE f.DisplayAs + ' ' + CONVERT(VARCHAR, Unit)
		END
	,c.LastName
	,b.Charge
ORDER BY a.ClientStatementId
	,b.DateOfService

IF @@error <> 0
	GOTO error

UPDATE ClientStatementBatches
SET STATUS = 4723
	,ProcessedDate = CONVERT(VARCHAR, @CurrentDate, 101)
	,ModifiedBy = @CurrentUser
	,ModifiedDate = @CurrentDate
	,NumberOfStatementsPrinted = @StatementCount
WHERE ClientStatementBatchId = @ClientStatementBatchId

IF @@error <> 0
	GOTO error

RETURN

error:

DECLARE @Error VARCHAR(8000)

SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMGenerateClientStatements') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

RAISERROR (
		@Error
		,-- Message text.                
		16
		,-- Severity.                
		1 -- State.                
		)

GO


