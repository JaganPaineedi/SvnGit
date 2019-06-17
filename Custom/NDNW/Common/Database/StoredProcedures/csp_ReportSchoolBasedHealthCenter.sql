/****** Object:  StoredProcedure [dbo].[csp_ReportSchoolBasedHealthCenter]    Script Date: 02/25/2016 16:06:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportSchoolBasedHealthCenter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportSchoolBasedHealthCenter]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportSchoolBasedHealthCenter]    Script Date: 02/25/2016 16:06:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************
Created by tmu 
Ace # 255 New Directions is requesting a report to capture School Based Health Center Data

MODIFICATIONS:
	Date		User		Description
	--------	-------		------------------------------
	02-25-2016	tmu			Added StartDate and EndDate, and All Sites option for the parameter
	02-29-2016  tmu			Modified to fetch BillingCodes instead of ProcedureCodes
	03-28-2016	tmu			Modified to pull race record from ClientRaces table instead of ClientsSADemographics table
							Modified insurance type to be further classified into few categories, not just by CodeName
							Modified to check for ClientCoverageHistory table to fetch valid coverage plans
	06-14-2016	tmu			Modified to pull the Insurance information from the CustomClients table
	06-20-2016	tmu			Modified to pull the payer name from the Charges table instead just CustomClients table
							(Payer Name of the CustomClients table is not used by ND)
	
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[csp_ReportSchoolBasedHealthCenter] 
(
	@LocationId INT
	,@StartDate DATE
	,@EndDate DATE
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Title VARCHAR(max)
DECLARE @SubTitle VARCHAR(max)
DECLARE @Comment VARCHAR(max)

SET @Title = 'New Directions Northwest - School Based Health Center'
SET @SubTitle = 'Subtitle'
SET @Comment = 'Ace # 255 New Directions is requesting a report to capture School Based Health Center Data'

DECLARE @StoredProcedure VARCHAR(300)
SET @StoredProcedure = object_name(@@procid)

IF @StartDate IS NULL
	SET @StartDate = DATEADD(DAY, - 1, GETDATE())

IF @EndDate IS NULL
	SET @EndDate = @StartDate
	
--  Now that @StartDate and @EndDate are declared, craft the SubTitle
IF @StartDate = @EndDate
	SET @SubTitle = CONVERT(VARCHAR, @StartDate, 101)
ELSE
	SET @SubTitle = 'Visit Date Period: ' + CONVERT(VARCHAR, @StartDate, 101) + ' - ' + CONVERT(VARCHAR, @EndDate, 101)

IF @StoredProcedure IS NOT NULL
	AND NOT EXISTS 
	(
		SELECT 1
		FROM CustomReportParts
		WHERE StoredProcedure = @StoredProcedure
	)
BEGIN
	INSERT INTO CustomReportParts 
	(
		StoredProcedure
		,ReportName
		,Title
		,SubTitle
		,Comment
	)
	SELECT @StoredProcedure
		,@Title
		,@Title
		,@SubTitle
		,@Comment
END
ELSE
BEGIN
	UPDATE CustomReportParts
	SET ReportName = @Title
		,Title = @Title
		,SubTitle = @SubTitle
		,Comment = @Comment
	WHERE StoredProcedure = @StoredProcedure
END

--==============================================================================
-- Get the services with Program = 162 and LocationId = user specified
--==============================================================================
IF OBJECT_ID('tempdb..#SchoolBasedServices') IS NOT NULL
	DROP TABLE #SchoolBasedServices
	
CREATE TABLE #SchoolBasedServices
(
	ServiceId INT,
	ClientId INT,
	ProcedureCodeId INT,
	ProcedureRateId INT,
	DateOfService DATETIME,
	ClinicianId INT,
	Status INT,
	Location VARCHAR(100)
)
INSERT INTO #SchoolBasedServices (ServiceId, ClientId, ProcedureCodeId, ProcedureRateId, DateOfService, ClinicianId, Status, Location)
SELECT	s.ServiceId, 
		s.ClientId, 
		s.ProcedureCodeId,
		s.ProcedureRateId, 
		s.DateOfService, 
		s.ClinicianId, 
		s.Status,
		l.LocationName
FROM Services s
JOIN Locations l ON s.LocationId = l.LocationId
WHERE s.ProgramId = 162 -- NDBHW - School Based Health Services
AND (@LocationId IS NULL OR s.LocationId = @LocationId)
--AND (ClientId = @ClientId OR @ClientId IS NULL)
AND DATEDIFF(DAY, @StartDate, s.DateOfService) >= 0
AND DATEDIFF(DAY, s.DateOfService, @EndDate) >= 0
AND ISNULL(s.RecordDeleted, 'N') <> 'Y'
AND s.Status IN (70, 71, 72, 75) -- Scheduled, Show, No Show, Complete

--==============================================================================
-- Get the Client detail information that ties to the school based services
--==============================================================================
IF OBJECT_ID('tempdb..#ClientInfo') IS NOT NULL
	DROP TABLE #ClientInfo
	
CREATE TABLE #ClientInfo
(
	ClientId INT,
	ClientName VARCHAR(100),
	DateOfBirth DATE,
	Gender CHAR(1),
	Ethnicity VARCHAR(100),
	Language VARCHAR(50),
	Race1 VARCHAR(50),
	Race2 VARCHAR(50),
	Race3 VARCHAR(50),
	Race4 VARCHAR(50),
	Race5 VARCHAR(50),
	PrimaryClinicianId INT
)
INSERT INTO #ClientInfo
SELECT	c.ClientId,
		c.FirstName + ' ' + c.LastName, 
		c.DOB, 
		c.Sex, 
		eth.CodeName, 
		lan.CodeName,
		race.CodeName,
		race.CodeName,
		race.CodeName,
		race.CodeName,
		race.CodeName,
		c.PrimaryClinicianId
FROM Clients c
--JOIN ClientsSADemographics cd ON cd.ClientId = c.ClientId
JOIN ClientRaces cr ON c.ClientId = cr.ClientId
JOIN GlobalCodes eth ON c.HispanicOrigin = eth.GlobalCodeId
JOIN GlobalCodes lan ON c.PrimaryLanguage = lan.GlobalCodeId
JOIN GlobalCodes race ON cr.RaceId = race.GlobalCodeId
WHERE c.ClientId IN (SELECT ClientId FROM #SchoolBasedServices)
AND c.Active = 'Y'
AND ISNULL(c.RecordDeleted, 'N') <> 'Y'

--==============================================================================
-- Get the provider type information that ties to the clients
--==============================================================================
IF OBJECT_ID('tempdb..#ProviderType') IS NOT NULL
	DROP TABLE #ProviderType

CREATE TABLE #ProviderType
(
	StaffId INT,
	StaffName VARCHAR(100),
	StaffDegree VARCHAR(50)
)
INSERT INTO #ProviderType
SELECT	s.StaffId, 
		s.FirstName + ' ' + s.LastName,
		dg.CodeName
FROM Staff s
JOIN GlobalCodes dg ON s.Degree = dg.GlobalCodeId
WHERE s.StaffId IN (SELECT PrimaryClinicianId FROM #ClientInfo)

--==============================================================================
-- Get the insurance type information that ties to the clients
--==============================================================================
IF OBJECT_ID('tempdb..#InsuranceInfo') IS NOT NULL
	DROP TABLE #InsuranceInfo
	
CREATE TABLE #InsuranceInfo
(
	--ClientCoveragePlanId INT,
	ClientId INT,
	--CoveragePlanId INT,
	--CoveragePlanName VARCHAR(100),
	InsuranceType VARCHAR(50),
	PayerName VARCHAR(200)
)
INSERT INTO #InsuranceInfo (ClientId, InsuranceType, PayerName)
SELECT	DISTINCT
		cc.ClientId,
		--ccp.ClientId,
		--cp.CoveragePlanId,
		--cp.CoveragePlanName,
		--tp.CodeName
		CASE WHEN tp.CodeName = 'Commercial' THEN 'Private'
			 WHEN tp.CodeName = 'Medicaid' THEN 'Medicaid'
			 WHEN tp.CodeName = 'Medicare' THEN 'Medicare'
			 WHEN tp.CodeName = 'Self Pay' THEN 'Self Pay'
			 ELSE 'None'
		END AS InsuranceType,
		p.PayerName
FROM dbo.CustomClients cc
JOIN dbo.GlobalCodes tp ON tp.GlobalCodeId = cc.InsuranceType AND ISNULL(tp.RecordDeleted, 'N') <> 'Y'
JOIN #SchoolBasedServices sbs ON cc.ClientId = sbs.ClientId
JOIN dbo.Charges c ON c.ServiceId = sbs.ServiceId AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
JOIN dbo.ClientCoveragePlans ccp ON c.ClientCoveragePlanId = ccp.ClientCoveragePlanId AND ISNULL(ccp.RecordDeleted, 'N') <> 'Y'
JOIN CoveragePlans cp ON ccp.CoveragePlanId = cp.CoveragePlanId AND ISNULL(cp.RecordDeleted, 'N') <> 'Y'
JOIN Payers p ON cp.PayerId = p.PayerId AND cc.InsuranceType = p.PayerType
WHERE cc.ClientId IN (SELECT ClientId FROM #ClientInfo)
AND ISNULL(cc.RecordDeleted, 'N') <> 'Y'
--AND (cch.EndDate IS NULL OR cch.EndDate >= @EndDate)

--==============================================================================
-- Get the payment information that ties to the services
--==============================================================================
IF OBJECT_ID('tempdb..#PaymentInfo') IS NOT NULL
	DROP TABLE #PaymentInfo
	
CREATE TABLE #PaymentInfo
(
	ServiceId INT,
	AmtCharged MONEY,
	AmtPaid MONEY
)
INSERT INTO #PaymentInfo (ServiceId, AmtCharged)
SELECT ServiceId, Charge
FROM Services
WHERE ServiceId IN (SELECT ServiceId FROM #SchoolBasedServices)

UPDATE #PaymentInfo
SET AmtPaid = ABS(ar.Amount)
FROM #SchoolBasedServices sbs
INNER JOIN Charges c ON sbs.ServiceId = c.ServiceId
INNER JOIN ARLedger ar ON c.ChargeId = ar.ChargeId AND ISNULL(ar.MarkedAsError, 'N') <> 'Y'
WHERE ar.LedgerType = 4202 -- Payment 
--AND ar.PaymentId IS NOT NULL
AND #PaymentInfo.ServiceId = sbs.ServiceId

--==============================================================================
-- Get the Dx/CPT information that ties to the services
--==============================================================================
IF OBJECT_ID('tempdb..#DxCPTInfo') IS NOT NULL
	DROP TABLE #DxCPTInfo
	
CREATE TABLE #DxCPTInfo
(
	ServiceId INT,
	ProcedureCodeId INT,
	CPT1 VARCHAR(10),
	CPT2 VARCHAR(10),
	CPT3 VARCHAR(10),
	CPT4 VARCHAR(10),
	CPT5 VARCHAR(10),
	CPT6 VARCHAR(10),
	DX1 VARCHAR(10),
	DX2 VARCHAR(10),
	DX3 VARCHAR(10),
	DX4 VARCHAR(10),
	DX5 VARCHAR(10),
	DX6 VARCHAR(10)
)
INSERT INTO #DxCPTInfo
SELECT	sbs.ServiceId, 
		sbs.ProcedureCodeId,  
		ISNULL(pr.BillingCode, 'N/A'),
		ISNULL(pr.BillingCode, 'N/A'),
		ISNULL(pr.BillingCode, 'N/A'),
		ISNULL(pr.BillingCode, 'N/A'),
		ISNULL(pr.BillingCode, 'N/A'),
		ISNULL(pr.BillingCode, 'N/A'),
		sd.ICD10Code,
		sd.ICD10Code,
		sd.ICD10Code,
		sd.ICD10Code,
		sd.ICD10Code,
		sd.ICD10Code
FROM #SchoolBasedServices sbs
JOIN ServiceDiagnosis sd ON sbs.ServiceId = sd.ServiceId
--JOIN ProcedureCodes pc ON sbs.ProcedureCodeId = pc.ProcedureCodeId
JOIN ProcedureRates pr ON sbs.ProcedureRateId = pr.ProcedureRateId -- tmu modification @ 02-29-2016

--==============================================================================
-- Get the report contents
--==============================================================================
IF OBJECT_ID('tempdb..#Report') IS NOT NULL
	DROP TABLE #Report
	
CREATE TABLE #Report
(
	SiteLocation VARCHAR(100),
	VisitDate DATE,
	ClientId INT,
	DateOfBirth DATE,
	Gender CHAR(1),
	Ethnicity VARCHAR(100),
	Language VARCHAR(50),
	Race1 VARCHAR(50),
	Race2 VARCHAR(50),
	Race3 VARCHAR(50),
	Race4 VARCHAR(50),
	Race5 VARCHAR(50),
	ProviderType VARCHAR(50),
	InsuranceType VARCHAR(50),
	PayerName VARCHAR(100),
	AmtCharged MONEY,
	AmtPaid MONEY,
	ProcedureCodeId INT,
	CPT1 VARCHAR(10),
	CPT2 VARCHAR(10),
	CPT3 VARCHAR(10),
	CPT4 VARCHAR(10),
	CPT5 VARCHAR(10),
	CPT6 VARCHAR(10),
	DX1 VARCHAR(10),
	DX2 VARCHAR(10),
	DX3 VARCHAR(10),
	DX4 VARCHAR(10),
	DX5 VARCHAR(10),
	DX6 VARCHAR(10)
)
INSERT INTO #Report
SELECT	DISTINCT sbs.Location, 
		sbs.DateOfService,
		sbs.ClientId,
		c.DateOfBirth,
		c.Gender,
		c.Ethnicity,
		c.Language,
		c.Race1,
		c.Race2,
		c.Race3,
		c.Race4,
		c.Race5,
		pt.StaffDegree,
		ISNULL(info.InsuranceType, 'None'),
		ISNULL(info.PayerName, 'None'),
		pay.AmtCharged,
		pay.AmtPaid,
		dx.ProcedureCodeId,
		dx.CPT1,
		dx.CPT2,
		dx.CPT3,
		dx.CPT4,
		dx.CPT5,
		dx.CPT6,
		dx.DX1,
		dx.DX2,
		dx.DX3,
		dx.DX4,
		dx.DX5,
		dx.DX6
FROM #SchoolBasedServices sbs
JOIN #ClientInfo c ON sbs.ClientId = c.ClientId
JOIN #ProviderType pt ON pt.StaffId = c.PrimaryClinicianId
LEFT JOIN #InsuranceInfo info ON c.ClientId = info.ClientId
JOIN #PaymentInfo pay ON sbs.ServiceId = pay.ServiceId
JOIN #DxCPTInfo dx ON sbs.ServiceId = dx.ServiceId

--==============================================================================
-- Final select
--==============================================================================
IF EXISTS (SELECT 1 FROM #Report)
BEGIN
	SELECT *, @StoredProcedure AS StoredProcedure FROM #Report
	ORDER BY VisitDate
END
ELSE
	SELECT @StoredProcedure AS StoredProcedure

DROP TABLE #SchoolBasedServices
DROP TABLE #ClientInfo
DROP TABLE #ProviderType
DROP TABLE #InsuranceInfo
DROP TABLE #PaymentInfo
DROP TABLE #DxCPTInfo

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO
