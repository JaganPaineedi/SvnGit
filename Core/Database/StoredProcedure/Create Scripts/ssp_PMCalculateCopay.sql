DROP PROCEDURE [dbo].[ssp_PMCalculateCopay]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMCalculateCopay]
( 
	@ServiceId INT,
	@ClientCoveragePlanId INT,-- ClientCoveragePlanId of the related coverage (primary billable coverage while completion)
	@OnComplete CHAR(1) -- Set Y while completing the service
)
/***********************************************************************************************************************
	Stored Procedure:	dbo.ssp_PMCalculateCopay
	Created Date:		9/22/06
	Purpose:			Calculate the client co-payment
========================================================================================================================
	Modification Log
========================================================================================================================
	Date			Author			Purpose
	-------------	--------------	----------------------------------------------------------------
	9/22/06			JHB				Created
	06/13/2012		MSuma			Replaced null with 0 to check Monthly,	weekly cap
	3/6/2013		Pralyankar		Modified to resolving copayment Deduction Issue (3.5x Issues)
	12/05/2017		Ting-Yu Mu		What: When calculate Earliest Starting date and latest end date to check used 
									amounts, the logic doesn't cover @WeeklyCap. We need to cover weekly cap so that the
									client's co-payment can be correctly calculated
***********************************************************************************************************************/
AS
DECLARE @Copay MONEY
DECLARE @DateOfService DATETIME
DECLARE @ClientId INT,
		@ProcedureCodeId INT
DECLARE @TotalCopay MONEY
DECLARE @ClientCopaymentId INT,
		@CopayCollectUpfront CHAR(1)
DECLARE @IncludeOrExcludeProcedures CHAR(1)
DECLARE @ProcedureCap MONEY,
		@DailyCap MONEY,
		@WeeklyCap MONEY

DECLARE @MonthlyCap MONEY,
		@YearlyCap MONEY
DECLARE @DailyUsed MONEY,
		@WeeklyUsed MONEY
DECLARE @MonthlyUsed MONEY,
		@YearlyUsed MONEY
DECLARE @DayStartDate DATETIME,
		@DayEndDate DATETIME
DECLARE @WeekStartDate DATETIME,
		@WeekEndDate DATETIME
DECLARE @MonthStartDate DATETIME,
		@MonthEndDate DATETIME
DECLARE @YearStartDate DATETIME,
		@YearEndDate DATETIME
DECLARE @StartDate DATETIME,
		@EndDate DATETIME

SELECT	@DateOfService = DateOfService,
		@ClientId = ClientId,
		@ProcedureCodeId = ProcedureCodeId
FROM	Services
WHERE	ServiceId = @ServiceId

IF @@error <> 0
	GOTO error

-- Find Copay Information
SELECT	@ClientCopaymentId = b.ClientCopaymentId
		,@CopayCollectUpfront = a.CopayCollectUpfront
		,@IncludeOrExcludeProcedures = b.IncludeOrExcludeProcedures
		,@ProcedureCap = b.ProcedureCap
		,@DailyCap = b.DailyCap
		,@WeeklyCap = b.WeeklyCap
		,@MonthlyCap = b.MonthlyCap
		,@YearlyCap = b.YearlyCap
FROM	ClientCoveragePlans a
JOIN	ClientCopayments b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
WHERE	a.ClientCoveragePlanId = @ClientCoveragePlanId
	AND b.StartDate <= @DateOfService
	-- JHB 6/7/07
	AND 
	(
		DATEADD(dd, 1, b.EndDate) > @DateOfService
		OR b.EndDate IS NULL
	)
	AND ISNULL(b.RecordDeleted, 'N') = 'N'

IF @@error <> 0
	GOTO error

-- Return if no copay record is found
IF @ClientCopaymentId IS NULL
	GOTO Results

----- Below code Added by Pralyanker On March 6, 2013 for Fixing Copayment Deducting issue for Interact(REf task 176)
IF @IncludeOrExcludeProcedures = 'I'
	OR @IncludeOrExcludeProcedures = 'E'
BEGIN
	SET @ClientCopaymentId = NULL

	SELECT	@ClientCopaymentId = b.ClientCopaymentId
			,@CopayCollectUpfront = a.CopayCollectUpfront
			,@IncludeOrExcludeProcedures = b.IncludeOrExcludeProcedures
			,@ProcedureCap = b.ProcedureCap
			,@DailyCap = b.DailyCap
			,@WeeklyCap = b.WeeklyCap
			,@MonthlyCap = b.MonthlyCap
			,@YearlyCap = b.YearlyCap
	FROM	ClientCoveragePlans a
	JOIN	ClientCopayments b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
	JOIN	ClientCopaymentProcedures CP ON CP.ClientCopaymentId = b.ClientCopaymentId
		AND CP.ProcedureCodeId = @ProcedureCodeId
	WHERE	a.ClientCoveragePlanId = @ClientCoveragePlanId
		AND b.StartDate <= @DateOfService
		-- JHB 6/7/07
		AND 
		(
			DATEADD(dd, 1, b.EndDate) > @DateOfService
			OR b.EndDate IS NULL
		)
		AND ISNULL(b.RecordDeleted, 'N') = 'N'
END

IF @@error <> 0
	GOTO error

-- Check conditions for including or excluding procedures
IF @IncludeOrExcludeProcedures = 'I'
	AND NOT EXISTS 
	(
		SELECT	*
		FROM	ClientCopaymentProcedures
		WHERE	ClientCopaymentId = @ClientCopaymentId
			AND ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	)
	GOTO Results

IF @IncludeOrExcludeProcedures = 'E'
	AND EXISTS 
	(
		SELECT	*
		FROM	ClientCopaymentProcedures
		WHERE	ClientCopaymentId = @ClientCopaymentId
			AND ProcedureCodeId = @ProcedureCodeId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	)
	GOTO Results

IF @@error <> 0
	GOTO error

-- Return is collect up front is not set and calculation is done 
-- while completing the service
IF ISNULL(@CopayCollectUpfront, 'N') = 'N'
	AND @OnComplete = 'Y'
	GOTO results

IF @@error <> 0
	GOTO error

-- Calculate start and end dates for computing used
IF @YearlyCap > 0
BEGIN
	SET @YearStartDate = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@DateOfService)))
	SET @YearEndDate = DATEADD(yy, 1, @YearStartDate)
END

IF @MonthlyCap > 0
BEGIN
	SET @MonthStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@DateOfService)) + '/1/' + CONVERT(VARCHAR, YEAR(@DateOfService)))
	SET @MonthEndDate = DATEADD(mm, 1, @MonthStartDate)
END

IF @WeeklyCap > 0
BEGIN
	SET @WeekStartDate = DATEADD(dd, CASE DATENAME(dw, @DateOfService)
				WHEN 'Sunday'
					THEN 0
				WHEN 'Monday'
					THEN - 1
				WHEN 'Tuesday'
					THEN - 2
				WHEN 'Wednesday'
					THEN - 3
				WHEN 'Thursday'
					THEN - 4
				WHEN 'Friday'
					THEN - 5
				WHEN 'Saturday'
					THEN - 6
				END, CONVERT(VARCHAR, @DateOfService, 101))
	SET @WeekEndDate = DATEADD(dd, 7, @WeekStartDate)
END

IF @DailyCap > 0
BEGIN
	SET @DayStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, @DateOfService, 101))
	SET @DayEndDate = DATEADD(dd, 1, @DayStartDate)
END

-- Calculate Earliest Starting date and latest end date to check used amounts
-- This will reduce the number of Services to check
IF @YearlyCap > 0
BEGIN
	SET @StartDate = @YearStartDate
	SET @EndDate = @YearEndDate
END
ELSE IF @MonthlyCap > 0
BEGIN
	SET @StartDate = @MonthStartDate
	SET @EndDate = @MonthEndDate
END
-- ==== TMU modified on 12/05/2017 =============================================
ELSE IF @WeeklyCap > 0
BEGIN
	SET @StartDate = @WeekStartDate
	SET @EndDate = @WeekEndDate
END
-- ==== End of TMU modification ================================================
-- Start and End Dates 
ELSE
BEGIN
	SET @StartDate = @DayStartDate
	SET @EndDate = @DayEndDate
END

IF @WeeklyCap > 0
BEGIN
	IF @WeekStartDate < @StartDate
		SET @StartDate = @WeekStartDate

	IF @WeekEndDate > @EndDate
		SET @EndDate = @WeekEndDate
END

-- Calculate Used (sum of expected payments)
SELECT	@DailyUsed = isnull(sum(CASE 
				WHEN a.DateOfService >= @DayStartDate
					AND a.DateOfService < @DayEndDate
					THEN c.Amount
				ELSE 0
				END), 0)
		,@WeeklyUsed = isnull(sum(CASE 
				WHEN a.DateOfService >= @WeekStartDate
					AND a.DateOfService < @WeekEndDate
					THEN c.Amount
				ELSE 0
				END), 0)
		,@MonthlyUsed = isnull(sum(CASE 
				WHEN a.DateOfService >= @MonthStartDate
					AND a.DateOfService < @MonthEndDate
					THEN c.Amount
				ELSE 0
				END), 0)
		,@YearlyUsed = isnull(sum(CASE 
				WHEN a.DateOfService >= @YearStartDate
					AND a.DateOfService < @YearEndDate
					THEN c.Amount
				ELSE 0
				END), 0)
FROM	Services a
JOIN	Charges b ON (a.ServiceId = b.ServiceId)
JOIN	ARLedger c ON (b.ChargeId = c.ChargeId)
WHERE	a.ClientId = @ClientId
	AND a.DateOfService >= @StartDate
	AND a.DateOfService < @EndDate
	AND a.ServiceId <> @ServiceId
	AND isnull(a.RecordDeleted, 'N') = 'N'
	AND c.LedgerType <> 4202
	AND b.Priority = 0

IF @@error <> 0
	GOTO error

-- Set maximum value of copay
IF @ProcedureCap > 0
	SET @Copay = @ProcedureCap
ELSE IF @DailyCap > 0
	SET @Copay = @DailyCap
ELSE IF @WeeklyCap > 0
	SET @Copay = @WeeklyCap
ELSE IF @MonthlyCap > 0
	SET @Copay = @MonthlyCap
ELSE IF @YearlyCap > 0
	SET @Copay = @YearlyCap

-- Apply caps
IF @DailyCap > 0
	AND (@DailyUsed + ISNULL(@Copay, 0) > @DailyCap)
	SET @Copay = @DailyCap - @DailyUsed

IF @WeeklyCap > 0
	AND (@WeeklyUsed + ISNULL(@Copay, 0) > @WeeklyCap)
	SET @Copay = @WeeklyCap - @WeeklyUsed

IF @MonthlyCap > 0
	AND (@MonthlyUsed + ISNULL(@Copay, 0) > @MonthlyCap)
	SET @Copay = @MonthlyCap - @MonthlyUsed

IF @YearlyCap > 0
	AND (@YearlyUsed + ISNULL(@Copay, 0) > @YearlyCap)
	SET @Copay = @YearlyCap - @YearlyUsed

IF @Copay < 0
	SET @Copay = 0

/*
-- Bhupinder Bajwa REF Task # 357 (02-Mar-07)
select @TotalCopay=sum(Amount) from ARLedger ar
Join Charges ch on ch.ChargeId=ar.ChargeId
Join Services s on s.ServiceId=ch.ServiceId
where ar.CoveragePlanId is null and ar.ClientId=@ClientId
and ar.LedgerType<>4202 and year(s.DateOfService)=year(@DateOfService)
--and exists (Select ClientCoveragePlanId from Charges c where c.ServiceId=s.ServiceId and c.ClientCoveragePlanId=@ClientCoveragePlanId)

if @@error <> 0 goto error

select @Copay = case when isnull(@OnComplete,'N') = 'Y' 
and isnull(CopayCollectUpfront, 'N') = 'N' then 0 when IsNull(b.YearlyCap,0)>0 then b.YearlyCap-@TotalCopay else b.ProcedureCap end     -- Changed for YearlyCap 02-Mar-07 (Bhupinder Bajwa)
from ClientCoveragePlans a
JOIN ClientCopayments b ON (a.ClientCoveragePlanId = b.ClientCoveragePlanId)
where a.ClientCoveragePlanId = @ClientCoveragePlanId
and (b.StartDate <= @DateOfService or b.StartDate is null)
and (b.EndDate >= convert(datetime, convert(varchar, @DateOfService, 101)) or b.EndDate is null)
and isnull(b.RecordDeleted,'N') = 'N'

if @@error <> 0 goto error

if (@Copay<0)               -- Bhupinder Bajwa REF Task # 357 (02-Mar-07)
  set @Copay=0
*/
Results:

SELECT @Copay AS Copay

RETURN 0

error:

RETURN - 1
GO


