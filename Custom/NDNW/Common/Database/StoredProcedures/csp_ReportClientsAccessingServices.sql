IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientsAccessingServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientsAccessingServices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/***********************************************************************************************************************
Created by tmu 
Ace # 399 New Directions is requesting a report for clients who are accessing services


MODIFICATIONS:
	Date		User		Description
	--------	-------		------------------------------
	08-01-2016	tmu			Created
	08-29-2016	tmu			Modified to add more filter options as requested by New Directions
	
***********************************************************************************************************************/

CREATE PROCEDURE [dbo].[csp_ReportClientsAccessingServices]
(
	@StartDate DATE,
	@EndDate DATE,
	@LocationId INT,
	@ProgramId INT,
	@InsuranceTypeId INT,	-- 08-29-16 tmu
	@ServiceAreaId INT,		-- 08-29-16 tmu
	@FromAge INT,			-- 08-29-16 tmu
	@ToAge INT				-- 08-29-16 tmu
)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Title VARCHAR(max)
DECLARE @SubTitle VARCHAR(max)
DECLARE @Comment VARCHAR(max)

SET @Title = 'New Directions Northwest - Clients Accessing Services Report'
SET @SubTitle = 'Subtitle'
SET @Comment = 'Ace # 399 New Directions is requesting a report for clients who are accessing services'

DECLARE @StoredProcedure VARCHAR(300)
SET @StoredProcedure = object_name(@@procid)

IF @StartDate IS NULL
	SET @StartDate = DATEADD(DAY, - 1, GETDATE())
	
IF @EndDate IS NULL
	SET @EndDate = @StartDate

-- Now that @StartDate and @EndDate are declared, craft the SubTitle
IF @StartDate = @EndDate
	SET @SubTitle = CONVERT(VARCHAR, @StartDate, 101)
ELSE
	SET @SubTitle = 'Date of Service Range: ' + CONVERT(VARCHAR, @StartDate, 101) + ' - ' + CONVERT(VARCHAR, @EndDate, 101)
	
-- Updates the CustomReportParts table
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

--==================================================================================================
-- Get the services with specified filter values
--==================================================================================================

IF OBJECT_ID('tempdb..#ServicesInfo') IS NOT NULL
	DROP TABLE #ServicesInfo
	
CREATE TABLE #ServicesInfo
(
	ServiceId INT,
	ClientId INT,
	DateOfService DATETIME,
	LocationCode VARCHAR(150),
	ProgramCode VARCHAR(150),
	ProcedureCode VARCHAR(100),
	ServiceAreaName VARCHAR(100)
)
INSERT INTO #ServicesInfo
        ( ServiceId ,
          ClientId ,
          DateOfService ,
          LocationCode ,
          ProgramCode,
          ProcedureCode,
          ServiceAreaName
        )
SELECT	S.ServiceId,
		S.ClientId,
		S.DateOfService,
		L.LocationCode,
		P.ProgramCode,
		PC.DisplayAs,
		SA.ServiceAreaName
FROM	dbo.Services S
JOIN	dbo.Locations L ON S.LocationId = L.LocationId AND ISNULL(L.RecordDeleted, 'N') <> 'Y'
JOIN	dbo.Programs P ON S.ProgramId = P.ProgramId AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
JOIN	dbo.ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId AND ISNULL(PC.RecordDeleted, 'N') <> 'Y'
JOIN	dbo.ServiceAreas SA ON P.ServiceAreaId = SA.ServiceAreaId AND ISNULL(SA.RecordDeleted, 'N') <> 'Y'
WHERE	S.Status <> 72 -- Excludes the "No Show" services
AND		(@LocationId IS NULL OR S.LocationId = @LocationId)
AND		(@ProgramId IS NULL OR S.ProgramId = @ProgramId)
AND		(@ServiceAreaId IS NULL OR P.ServiceAreaId = @ServiceAreaId)
AND		DATEDIFF(DAY, @StartDate, S.DateOfService) >= 0
AND		DATEDIFF(DAY, S.DateOfService, @EndDate) >= 0
AND		ISNULL(S.RecordDeleted, 'N') <> 'Y'

--==================================================================================================
-- Get the Client detail information that ties to services
--==================================================================================================

IF OBJECT_ID('tempdb..#ClientInfo') IS NOT NULL
	DROP TABLE #ClientInfo

DECLARE @ClientId INT
	
CREATE TABLE #ClientInfo
(
	ClientId INT,
	ClientName VARCHAR(150),
	DateOfBirth DATE,
	Age INT,
	InsuranceType VARCHAR(50)
)

DECLARE ClientId_Cursor CURSOR
FOR SELECT DISTINCT ClientId FROM #ServicesInfo
OPEN ClientId_Cursor
FETCH NEXT FROM ClientId_Cursor INTO @ClientId
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRAN
		-- Inserts clients info from Clients table
		INSERT INTO	#ClientInfo
				( ClientId ,
				  ClientName ,
				  DateOfBirth ,
				  Age ,
				  InsuranceType
				)
		SELECT	ClientId,
				LastName + ', ' + FirstName,
				DOB,
				dbo.GetAge(DOB, GETDATE()),
				NULL
		FROM	dbo.Clients
		WHERE	ClientId = @ClientId
		
		-- Updates the clients' coverage info from ClientCoveragePlans table
		UPDATE	#ClientInfo
		SET		InsuranceType = CASE WHEN TP.CodeName = 'Commercial' THEN 'Private'
					 WHEN TP.CodeName = 'Medicaid' THEN 'Medicaid'
					 WHEN TP.CodeName = 'Medicare' THEN 'Medicare'
					 WHEN TP.CodeName = 'Self Pay' THEN 'Self Pay'
					 ELSE 'None'
				END 
		FROM	#ClientInfo CI
		JOIN	dbo.Clients C ON CI.ClientId = C.ClientId
		JOIN	dbo.ClientCoveragePlans CCP ON C.ClientId = CCP.ClientId AND ISNULL(CCP.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.ClientCoverageHistory CCH ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId AND ISNULL(CCH.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId AND ISNULL(CP.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.Payers P ON CP.PayerId = P.PayerId AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
		JOIN	dbo.GlobalCodes TP ON P.PayerType = TP.GlobalCodeId AND TP.Active = 'Y'
		WHERE	C.ClientId = @ClientId
		AND		(CCH.EndDate IS NULL OR CCH.EndDate >= GETDATE())
		AND		(@InsuranceTypeId IS NULL OR P.PayerId = @InsuranceTypeId)
		AND		CCH.COBOrder = 1
		
		-- Updates the clients' coverage info from CustomClients table
		UPDATE	#ClientInfo
		SET		InsuranceType = CASE WHEN TP.CodeName = 'Commercial' THEN 'Private'
					 WHEN TP.CodeName = 'Medicaid' THEN 'Medicaid'
					 WHEN TP.CodeName = 'Medicare' THEN 'Medicare'
					 WHEN TP.CodeName = 'Self Pay' THEN 'Self Pay'
					 ELSE 'None'
				END 
		FROM	#ClientInfo CI
		JOIN	dbo.CustomClients C ON CI.ClientId = C.ClientId
		JOIN	dbo.GlobalCodes TP ON C.InsuranceType = TP.GlobalCodeId AND TP.Active = 'Y'
		WHERE	C.ClientId = @ClientId
	COMMIT
	
	FETCH NEXT FROM ClientId_Cursor INTO @ClientId
END
CLOSE ClientId_Cursor
DEALLOCATE ClientId_Cursor

--==================================================================================================
-- Get the report contents
--==================================================================================================

IF OBJECT_ID('tempdb..#Report') IS NOT NULL
	DROP TABLE #Report
	
CREATE TABLE #Report
(
	ClientId INT,
	ServiceId INT,
	ProcedureCode VARCHAR(100),
	ClientName VARCHAR(150),
	ProgramCode VARCHAR(150),
	InsuranceType VARCHAR(50),
	DateOfService DATETIME,
	ClientAge INT,
	ServiceArea VARCHAR(100),
	NumberOfServiced INT
)
INSERT INTO #Report
        ( ClientId ,
		  ServiceId ,
		  ProcedureCode ,
		  ClientName ,
          ProgramCode ,
          InsuranceType ,
          DateOfService ,
          ClientAge,
          ServiceArea
        )
SELECT	S.ClientId,
		S.ServiceId,
		S.ProcedureCode,
		C.ClientName,
		S.ProgramCode,
		ISNULL(C.InsuranceType, 'None'),
		S.DateOfService,
		C.Age,
		S.ServiceAreaName
FROM	#ServicesInfo S
LEFT JOIN #ClientInfo C ON S.ClientId = C.ClientId
WHERE	(@FromAge IS NULL OR C.Age >= @FromAge)
AND		(@ToAge IS NULL OR C.Age <= @ToAge)

--==================================================================================================
-- Final select
--==================================================================================================

IF EXISTS (SELECT 1 FROM #Report)
	BEGIN
		SELECT *, @StoredProcedure AS StoredProcedure, @Title AS Title, @SubTitle AS SubTitle FROM #Report
		ORDER BY ClientName
	END
ELSE
	SELECT @StoredProcedure AS StoredProcedure
	
DROP TABLE #ServicesInfo
DROP TABLE #ClientInfo

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO