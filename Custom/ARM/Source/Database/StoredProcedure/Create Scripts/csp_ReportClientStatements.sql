/****** Object:  StoredProcedure [dbo].[csp_ReportClientStatements]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientStatements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientStatements]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientStatements]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE   PROCEDURE [dbo].[csp_ReportClientStatements]
@ClientStatementId	Int = Null,
@ClientStatementBatchId	Int = Null
AS
BEGIN

--Check for FMTOnly
DECLARE @FMTOnlyOn bit = 0
IF (1=0)
	SET @FMTOnlyOn = 1
	
SET FMTONLY OFF

Create Table #clientPayments
	(
	ClientStatementId int,
	ClientId int,
	PaymentDateRange varchar(25),
	Amount decimal(10,2),
	)

Create Table #ClientOpenCharges
	(
	ClientStatementId int,
	ClientId int,
	ChargeDateRange varchar(25),
	Amount decimal(10,2)
	)

Create Table #ClientHistory
	(
	ClientStatementId int,
	ClientId int,
	Payment30 int,
	Payment60 int,
	Payment90 int,
	OpenCharge30 int,
	OpenCharge60 int
	)


Create Table #clientStatements
	(
	ClientStatementId		Int,
	AgencyName			Varchar(100),
	AgencyAddress			Varchar(250),
	AgencyCityStateZip		Varchar(250),
	AgencyMainPhone			Varchar(20),
	ResponsiblePartyName		Varchar(50),
	ResponsiblePartyAddress		Varchar(250),
	InsuranceBalanceForward		Money,
	ClientBalanceForward		Money,
	SortOrder			Varchar(50),
	ClientName			Varchar(100),
	ClientId			Int,
	StatementDate			Varchar(10),
	DateOfService			Varchar(10),
	ProcedureDescription		Varchar(250),
	Clinician			Varchar(25),
	Charge				Money,
	InsurancePayment		Money,
	Adjustment			Money,
	ClientPayment			Money,
	InsuranceBalance		Money,
	ClientBalance			Money,
	OverDue60			int,
	OverDue30			int,
	PaymentPrior3			int,
	OrganizationName        Varchar(100)
	)

--Payments within the last 30 days
INSERT INTO #clientPayments (ClientStatementId, ClientId, PaymentDateRange, Amount)
SELECT cs.ClientStatementId, p.ClientId, ''30 Days'', SUM(p.Amount)
FROM Payments p
JOIN ClientStatements cs ON cs.ClientId = p.ClientId
WHERE (cs.ClientStatementId = @ClientStatementId
	OR cs.ClientStatementBatchId = @ClientStatementBatchId)
AND (p.DateReceived >= DATEADD("d",-30,cs.CreatedDate) 
	AND p.DateReceived <= cs.CreatedDate)
AND ISNULL(p.RecordDeleted,''N'')<>''Y''
AND ISNULL(cs.RecordDeleted,''N'')<>''Y''
GROUP BY cs.ClientStatementId, p.ClientId

--Payments between 60 and 30 days ago
INSERT INTO #clientPayments (ClientStatementId, ClientId, PaymentDateRange, Amount)
SELECT cs.ClientStatementId, p.ClientId, ''60 Days'', SUM(p.Amount)
FROM Payments p
JOIN ClientStatements cs ON cs.ClientId = p.ClientId
WHERE (cs.ClientStatementId = @ClientStatementId
	OR cs.ClientStatementBatchId = @ClientStatementBatchId)
AND (DateReceived >= DATEADD("d",-60,cs.CreatedDate) 
	AND p.DateReceived < DATEADD("d",-30,cs.CreatedDate))
AND ISNULL(p.RecordDeleted,''N'')<>''Y''
AND ISNULL(cs.RecordDeleted,''N'')<>''Y''
GROUP BY cs.ClientStatementId, p.ClientId

--Payments between 90 and 60 days ago
INSERT INTO #clientPayments (ClientStatementId, ClientId, PaymentDateRange, Amount)
SELECT cs.ClientStatementId, p.ClientId, ''90 Days'', SUM(p.Amount)
FROM Payments p
JOIN ClientStatements cs ON cs.ClientId = p.ClientId
WHERE (cs.ClientStatementId = @ClientStatementId
	OR cs.ClientStatementBatchId = @ClientStatementBatchId)
AND (DateReceived >= DATEADD("d",-90,cs.CreatedDate) 
	AND p.DateReceived < DATEADD("d",-60,cs.CreatedDate))
AND ISNULL(p.RecordDeleted,''N'')<>''Y''
AND ISNULL(cs.RecordDeleted,''N'')<>''Y''
GROUP BY cs.ClientStatementId, p.ClientId

--Open Charges older than 60 days
INSERT INTO #ClientOpenCharges (ClientStatementId, ClientId, ChargeDateRange, Amount)
SELECT cs.ClientStatementId, s.ClientId, ''60 Days'', 1
FROM OpenCharges oc
JOIN Charges c ON c.ChargeId = oc.ChargeId
JOIN Services s ON s.ServiceId = c.ServiceId
JOIN ClientStatements cs ON cs.ClientId = s.ClientId
WHERE (cs.ClientStatementId = @ClientStatementId
	OR cs.ClientStatementBatchId = @ClientStatementBatchId)
AND c.FirstBilledDate < DATEADD(dd,-60,cs.CreatedDate)
AND ISNULL(oc.RecordDeleted,''N'')<>''Y''
AND ISNULL(c.RecordDeleted,''N'')<>''Y''
AND ISNULL(s.RecordDeleted,''N'')<>''Y''
AND ISNULL(cs.RecordDeleted,''N'')<>''Y''

--Open Charges older than 30 days
INSERT INTO #ClientOpenCharges (ClientStatementId, ClientId, ChargeDateRange, Amount)
SELECT cs.ClientStatementId, s.ClientId, ''30 Days'', 1
FROM OpenCharges oc
JOIN Charges c ON c.ChargeId = oc.ChargeId
JOIN Services s ON s.ServiceId = c.ServiceId
JOIN ClientStatements cs ON cs.ClientId = s.ClientId
WHERE (cs.ClientStatementId = @ClientStatementId
	OR cs.ClientStatementBatchId = @ClientStatementBatchId)
AND c.FirstBilledDate < DATEADD(dd,-30,cs.CreatedDate)
AND ISNULL(oc.RecordDeleted,''N'')<>''Y''
AND ISNULL(c.RecordDeleted,''N'')<>''Y''
AND ISNULL(s.RecordDeleted,''N'')<>''Y''
AND ISNULL(cs.RecordDeleted,''N'')<>''Y''


--Add a record for each clientstatement
INSERT INTO #ClientHistory (ClientStatementId, ClientId, Payment30, Payment60, Payment90, OpenCharge30, OpenCharge60)
SELECT ClientStatementId, ClientId, 0, 0, 0, 23, 0
FROM ClientStatements
WHERE (ClientStatementId = @ClientStatementId
	OR ClientStatementBatchId = @ClientStatementBatchId)
AND ISNULL(RecordDeleted,''N'')<>''Y''

--Update Payments and charges by date range
UPDATE a SET
	Payment30 = 1
FROM #ClientHistory a
JOIN #ClientPayments b ON b.ClientStatementId = a.ClientStatementId
WHERE b.PaymentDateRange = ''30 Days'' and Amount > 0

UPDATE a SET
	Payment60 = 1
FROM #ClientHistory a
JOIN #ClientPayments b ON b.ClientStatementId = a.ClientStatementId
WHERE b.PaymentDateRange = ''60 Days'' and Amount > 0

UPDATE a SET
	Payment90 = 1
FROM #ClientHistory a
JOIN #ClientPayments b ON b.ClientStatementId = a.ClientStatementId
WHERE b.PaymentDateRange = ''90 Days'' and Amount > 0

UPDATE a SET
	OpenCharge30 = 1
FROM #ClientHistory a
JOIN #ClientOpenCharges b ON b.ClientStatementId = a.ClientStatementId
WHERE b.ChargeDateRange = ''30 Days'' AND Amount <> 0 

UPDATE a SET
	OpenCharge60 = 1
FROM #ClientHistory a
JOIN #ClientOpenCharges b ON b.ClientStatementId = a.ClientStatementId
WHERE b.ChargeDateRange = ''60 Days'' AND Amount <> 0 

--Create client statements
Insert Into #clientStatements
Select
	b.ClientStatementId,
	a.AgencyName,
	a.PaymentAddress,--a.PaymentAddressDisplay,
	a.City + '', '' + a.State + '' '' + a.ZipCode,
	''(''+LEFT(a.BillingPhone,3)+'')''+RIGHT(LEFT(a.BillingPhone,6),3)+''-''+RIGHT(a.BillingPhone,4),--a.MainPhone,
	b.ResponsiblePartyName,
	b.ResponsiblePartyAddress,
	b.InsuranceBalanceForward,
	b.ClientBalanceForward,
	b.SortOrder,
	c.FirstName + '' '' + c.LastName,
	b.ClientId,
	Convert(Varchar(10),b.CreatedDate,101),
	Convert(Varchar(10),d.DateOfService,101),
	d.ProcedureDescription,
	d.Clinician,
	d.Charge,
	d.InsurancePayment,
	d.Adjustment,
	d.ClientPayment,
	d.InsuranceBalance,
	d.ClientBalance,
	OverDue60 = CASE WHEN (e.OpenCharge60 <> 0) AND (e.Payment60 = 0 AND e.Payment30 = 0) THEN 1 ELSE 0 END,
	OverDue30 = CASE WHEN (e.OpenCharge60 = 0 AND e.OpenCharge30 <> 0) AND (e.Payment30 = 0) THEN 1 ELSE 0 END,
	PaymentPrior3 = CASE WHEN (e.OpenCharge60 =0 AND e.OpenCharge30 <> 0) AND (e.Payment90 <> 0 AND e.Payment60 <> 0 AND e.Payment30 <>0) THEN 1 ELSE 0 End,
	s.OrganizationName 
From ClientStatements b
JOIN Clients c On c.ClientId = b.ClientId
JOIN #clientHistory e on e.ClientStatementId = b.ClientStatementId
LEFT JOIN ClientStatementDetails d On d.ClientStatementId = b.ClientStatementId
CROSS JOIN SystemConfigurations s
CROSS JOIN Agency a
WHERE (b.ClientStatementId = @ClientStatementId
	OR b.ClientStatementBatchId = @ClientStatementBatchId)
AND ISNULL(b.RecordDeleted,''N'')<>''Y''
AND ISNULL(c.RecordDeleted,''N'')<>''Y''
AND ISNULL(d.RecordDeleted,''N'')<>''Y''

IF @FMTOnlyOn <> 0
	SET FMTOnly On

--Dataset:
Select 
	b.ClientStatementId AS [ClientStatementId],
	AgencyName = b.AgencyName,
	AgencyAddress = b.AgencyAddress,
	AgencyCityStateZip = b.AgencyCityStateZip,
	AgencyMainPhone = b.AgencyMainPhone,
	ResponsiblePartyName = b.ResponsiblePartyName,
	ResponsiblePartyAddress = b.ResponsiblePartyAddress,
	InsuranceBalanceForward = b.InsuranceBalanceForward,
	ClientBalanceForward = b.ClientBalanceForward,
	SortOrder = b.SortOrder,
	ClientName = b.ClientName,
	ClientId = b.ClientId,
	StatementDate = b.StatementDate,
	DateOfService = b.DateOfService,
	ProcedureDescription = b.ProcedureDescription,
	Clinician = b.Clinician,
	Charge = b.Charge,
	InsurancePayment = b.InsurancePayment,
	Adjustment = b.Adjustment,
	ClientPayment = b.ClientPayment,
	InsuranceBalance = b.InsuranceBalance,
	ClientBalance = b.ClientBalance,
	OverDue60 = b.OverDue60,
	OverDue30 = b.OverDue30,
	PaymentPrior3 = b.PaymentPrior3,
	OrganizationName = a.OrganizationName
FROM SystemConfigurations a
CROSS JOIN #clientStatements b
Order By DateofService

END
' 
END
GO
