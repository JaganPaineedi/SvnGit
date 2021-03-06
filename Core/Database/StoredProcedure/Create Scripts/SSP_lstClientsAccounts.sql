/****** Object:  StoredProcedure [dbo].[SSP_lstClientsAccounts]    Script Date: 11/18/2011 16:25:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_lstClientsAccounts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_lstClientsAccounts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_lstClientsAccounts]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SSP_lstClientsAccounts] @ProgramId INT = NULL
	,@InformationComplete VARCHAR(25) = NULL
	,@LastName CHAR(1) = NULL
	,@TotalBalance INT = NULL
	,@PrimaryClinicianId INT = NULL
	,@StaffId INT
	,-- Bhupinder Bajwa 28 Feb 2007 REF Task # 267       
	--Added by Priya on 6th March ''08 reference ticket # 895    
	@ClientStatusId INT = NULL
	,@EpisodeStatusId INT = NULL
	,@BalanceFlag INT = NULL
	--End            
	/* Param List */
AS
SET NOCOUNT ON

/******************************************************************************              
**  File:               
**  Name: Stored_Procedure_Name              
**  Desc:               
**              
**  This template can be customized:              
**                            
**  Return values:              
**               
**  Called by:                 
**                            
**  Parameters:              
**  Input       Output              
**     ----------       -----------              
**              
**  Auth:               
**  Date:               
*******************************************************************************              
**  Change History              
*******************************************************************************              
**  Date:  Author:    Description:              
**  --------  --------    -------------------------------------------              
**  04/17/08 Ryan Noble Modified conditional logic relating to @BalanceFlag.    
**  Rather than inserting all records and then deleting them, the script now  
**  only inserts records into the temporary table based upon the flag.  
** 16 Oct 2015	Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. 
  								why:task #609, Network180 Customization    
*******************************************************************************/
DECLARE @TempAllAcc TABLE (
	ClientId INT
	,UserName VARCHAR(100)
	,LastName VARCHAR(100)
	,LastStatement VARCHAR(100)
	,ClientBalance MONEY
	,DisCurrentBalance VARCHAR(100)
	,serviceCount INT
	,ThirdPartyBalance MONEY
	,PrimaryPlan VARCHAR(100)
	,CoveragePlanId INT
	,InformationComplete VARCHAR(5)
	,PaymentId INT
	,LastCltPaymentAndDate VARCHAR(100)
	,FinancialActivityId INT
	,ProgramId VARCHAR(200)
	,CurrentBalance FLOAT
	)
DECLARE @TempClients TABLE (
	ClientId INT
	,InformationComplete VARCHAR(1)
	,PrimaryClinicianId INT
	)
DECLARE @TotalBalanceTable TABLE (
	ClientId INT NULL
	,TotalBalance MONEY NULL
	)
DECLARE @TotalBalanceAmount MONEY

IF @TotalBalance IS NOT NULL
BEGIN
	SELECT @TotalBalanceAmount = convert(MONEY, isnull(ExternalCode1, 0))
	FROM GlobalCodes
	WHERE GlobalCodeId = @TotalBalance
END

INSERT INTO @TempClients (
	ClientId
	,InformationComplete
	,PrimaryClinicianId
	)
SELECT a.ClientId
	,a.InformationComplete
	,a.PrimaryClinicianId
FROM clients a
LEFT JOIN ClientPrograms b ON a.ClientId = b.ClientId
LEFT JOIN ClientEpisodes c ON a.ClientId = c.ClientId
	AND a.CurrentEpisodeNumber = c.episodenumber
WHERE isnull(a.Active, ''N'') = CASE 
		WHEN @ClientStatusId = 0
			THEN isnull(a.Active, ''N'')
		WHEN @ClientStatusId = 1
			THEN ''Y''
		WHEN @ClientStatusId = 2
			THEN ''N''
		END
	AND -- All Episode Statuses  
	(
		@EpisodeStatusId = 0
		-- Not Discharged   
		OR (
			@EpisodeStatusId = 1
			AND c.STATUS <> 102
			)
		-- In Treatment or Registered  
		OR (
			@EpisodeStatusId NOT IN (
				0
				,1
				)
			AND c.STATUS = @EpisodeStatusId
			)
		)
	AND -- Clients Not Enrolled  
	(
		(
			@ProgramId = - 1
			AND NOT EXISTS (
				SELECT *
				FROM clientPrograms cp1
				WHERE cp1.ClientId = a.ClientId
					AND cp1.STATUS = 4
					AND isnull(cp1.RecordDeleted, ''N'') <> ''Y''
				)
			)
		-- Clients Enrolled in a Program  
		OR @ProgramId IS NULL
		OR (
			b.ProgramId = @ProgramId
			AND @ProgramId IS NOT NULL
			)
		)
	AND -- Complete and Incomplete Financial Information  
	(
		@InformationComplete IS NULL
		-- Incomplete Financial Information  
		OR (
			@InformationComplete = ''INCOMPLETE''
			AND (isnull(a.InformationComplete, ''N'') = ''N'')
			)
		-- Incomplete Financial Information at least 1 visit  
		OR (
			@InformationComplete = ''INCOMPLETE1VISIT''
			AND (isnull(a.InformationComplete, ''N'') = ''N'')
			AND EXISTS (
				SELECT *
				FROM Services s
				WHERE s.ClientId = a.ClientId
					AND s.STATUS IN (
						71
						,75
						) -- Show/Complete       
					AND isnull(s.RecordDeleted, ''N'') = ''N''
				)
			)
		-- Monthly Deductible not updated last month  
		OR (
			@InformationComplete = ''NOTMETLASTMONTH''
			AND EXISTS (
				SELECT *
				FROM ClientCoveragePlans cp
				WHERE cp.ClientId = a.ClientId
					AND cp.ClientHasMonthlyDeductible = ''Y''
					AND IsNull(cp.RecordDeleted, ''N'') = ''N''
					AND NOT EXISTS (
						SELECT *
						FROM ClientMonthlyDeductibles cmd
						WHERE cmd.ClientCoveragePlanID = cp.ClientCoveragePlanID
							AND cmd.DeductibleMet IN (
								''Y''
								,''N''
								) -- Condition added to check for ''Never'' (Bhupinder Bajwa REF Task # 336)             
							AND cmd.DeductibleYear = Year(DateAdd(mm, - 1, GetDate()))
							AND cmd.DeductibleMonth = Month(DateAdd(mm, - 1, GetDate()))
							AND IsNull(cmd.RecordDeleted, ''N'') = ''N''
						)
					AND EXISTS (
						SELECT *
						FROM ClientEpisodes CE
						WHERE c.ClientId = CE.ClientId
							AND CE.STATUS IN (
								100
								,101
								)
							AND IsNull(CE.RecordDeleted, ''N'') = ''N''
						)
				)
			)
		)
	AND -- All Clinicians (Including clients without primary Clinicians)  
	(
		@PrimaryClinicianId IS NULL
		OR
		-- Clients without PrimaryClinician  
		(
			@PrimaryClinicianId = - 1
			AND isnull(a.PrimaryClinicianId, '''') = ''''
			)
		-- Specified Primary Clinician  
		OR @PrimaryClinicianId IS NOT NULL
		AND isnull(a.PrimaryClinicianId, '''') = @PrimaryClinicianId
		)
	AND -- All Clients Last Names  
	(
		@LastName IS NULL
		-- Only Clients starting with selected letter  
		OR a.LastName LIKE @LastName + ''%''
		)
	AND isnull(a.RecordDeleted, ''N'') = ''N''
GROUP BY a.ClientId
	,a.InformationComplete
	,a.PrimaryClinicianId

-- Balance Section  
IF @TotalBalance IS NULL
BEGIN
	INSERT INTO @TotalBalanceTable (
		ClientId
		,TotalBalance
		)
	SELECT a.ClientId
		,isnull(sum(d.Balance), 0)
	FROM @TempClients a
	LEFT JOIN Services b ON (a.ClientId = b.ClientId)
	LEFT JOIN Charges c ON (b.ServiceId = c.ServiceId)
	LEFT JOIN OpenCharges d ON (c.ChargeId = d.ChargeId)
	GROUP BY a.ClientId
END
ELSE
BEGIN
	INSERT INTO @TotalBalanceTable (
		ClientId
		,TotalBalance
		)
	SELECT a.ClientId
		,isnull(sum(d.Balance), 0)
	FROM @TempClients a
	LEFT JOIN Services b ON (a.ClientId = b.ClientId)
	LEFT JOIN Charges c ON (b.ServiceId = c.ServiceId)
	LEFT JOIN OpenCharges d ON (c.ChargeId = d.ChargeId)
	GROUP BY a.ClientId
	HAVING sum(d.balance) > 0
END

INSERT INTO @TempAllAcc (
	ClientId
	,UserName
	,LastName
	,LastStatement
	,ClientBalance
	,DisCurrentBalance
	,serviceCount
	,ThirdPartyBalance
	,PrimaryPlan
	,CoveragePlanId
	,InformationComplete
	,PaymentId
	,LastCltPaymentAndDate
	,FinancialActivityId
	,ProgramId
	,CurrentBalance
	)
SELECT a.ClientId
	,
	--Added by Revathi  16 Oct 2015  
	CASE 
		WHEN ISNULL(C.ClientType, ''I'') = ''I''
			THEN ISNULL(c.LastName, '''') + '', '' + ISNULL(c.FIrstName, '''')
		ELSE ISNULL(C.OrganizationName, '''')
		END
	,c.LastName
	,convert(VARCHAR, c.LastStatementDate, 101)
	,c.CurrentBalance
	,''$'' + convert(VARCHAR, c.CurrentBalance)
	,NULL
	,-- serviceCount              
	isnull(b.TotalBalance, 0) - isnull(c.CurrentBalance, 0)
	,NULL
	,-- PrimaryPlan              
	NULL
	,-- CoveragePlanId              
	CASE c.InformationComplete
		WHEN ''Y''
			THEN ''No''
		WHEN ''N''
			THEN ''Yes''
		END
	,c.LastPaymentId
	,isnull(''$'' + convert(VARCHAR, d.Amount) + '' '' + convert(VARCHAR, DateReceived, 101), '''')
	,d.FinancialActivityId
	,NULL
	,-- ProgramId              
	b.TotalBalance
FROM @TempClients a
LEFT JOIN @TotalBalanceTable b ON (a.ClientId = b.ClientId)
INNER JOIN Clients c ON (a.ClientId = c.ClientId)
LEFT JOIN Payments d ON (c.LastPaymentId = d.PaymentId)
-- Bhupinder Bajwa 28 Feb 2007 REF Task # 267            
WHERE NOT EXISTS (
		SELECT sbc.ClientId
		FROM StaffBlockedClients sbc
		WHERE sbc.StaffId = @StaffId
			AND sbc.ClientId = c.ClientId
			AND IsNull(sbc.RecordDeleted, ''N'') = ''N''
		)
	AND (
		(
			isnull(@BalanceFlag, 0) = 1
			AND isnull(c.CurrentBalance, 0) > 0
			)
		OR isnull(@BalanceFlag, 0) <> 1
		)

UPDATE a
SET serviceCount = (
		SELECT count(*)
		FROM Services b
		WHERE a.ClientId = b.ClientId
			AND isnull(b.RecordDeleted, ''N'') <> ''Y''
			AND b.STATUS IN (
				71
				,75
				)
		)
FROM @TempAllAcc a

UPDATE a
SET PrimaryPlan = d.DisplayAs
	,CoveragePlanId = b.ClientCoveragePlanId
FROM @TempAllAcc a
INNER JOIN ClientCoveragePlans b ON (a.ClientId = b.ClientId)
INNER JOIN ClientCoverageHistory c ON (b.ClientCoveragePlanId = c.ClientCoveragePlanId)
INNER JOIN CoveragePlans d ON (b.CoveragePlanId = d.CoveragePlanId)
WHERE isnull(b.RecordDeleted, ''N'') <> ''Y''
	AND c.StartDate <= getdate()
	AND (
		c.EndDate IS NULL
		OR c.EndDate > dateadd(dd, 1, getdate())
		)
	AND c.COBOrder = 1

SELECT *
	,0 AS CheckBox
	,'''' AS Blank1
	,'''' AS Blank2
FROM @TempAllAcc
ORDER BY UserName
' 
END
GO
