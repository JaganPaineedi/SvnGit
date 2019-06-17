/****** Object:  StoredProcedure [dbo].[ssp_PMARByPlan]    Script Date: 5/8/2018 12:23:04 PM ******/
DROP PROCEDURE [dbo].[ssp_PMARByPlan]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMARByPlan]    Script Date: 5/8/2018 12:23:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_PMARByPlan]
	/****************************************************************************** 
** File: ssp_PMARByPlan.sql
** Name: ssp_PMARByPlan
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values -  A/R By Plan List Page
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** N/A   Dropdown values
** Auth: Mary Suma
** Date: 03/25/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 03/25/2011		Mary Suma			Query to return values for the grid in A/R By Plan List Page
-------- 			-------- 			--------------- 
** 23/11/2011		Mary Suma			Included additional filter criteria as per Charges and Claims to match the total UnBilled Amount
** 24/11/2011		Mary Suma			Included PaymentId and FinancialActivityId
-- 28 Mar 2012      PSelvan		        Performance Tuning.	 
-- 4.04.2012        Ponnin Selvan       Conditions added for Export
-- 13.04.2012       PSelvan             Added Conditions for NumberOfPages. 
-- 17.Apr.2015		Revathi				what:FinancialAssignment filter added 
										why:task #950 Valley - Customizations
-- 16.Oct.2017		Neelima				what:Added temp table #TableLastBilledDate to get the LastBilledDate based on either payers or Coverageplans
										why:task #190 MFS - Support Go Live
-- 08.May.2018		mraymond			Woods SGL 853 - Changes for Financial Assignment filter to fix filtering by Financial Assignment Plans
*******************************************************************************/
	@SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@PayerType INT
	,@PayerId INT
	,@ActivePlans VARCHAR(2)
	,@CoveragePlanId INT
	,@PlanTotalBalance INT
	,@ARBucket VARCHAR(15)
	,@OtherFilter INT
	,@StaffId INT
	,@FinancialAssignmentId INT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		CREATE TABLE #ResultSet (
			RowNumber INT
			,PageNumber INT
			,CoveragePlanId INT NULL
			,CoveragePlanName VARCHAR(250) NULL
			,CoveragePlanId2 INT NULL
			,TotalBalance MONEY NULL
			,LastBilledDate DATETIME NULL
			,PastDays MONEY NULL
			,NotBilled MONEY NULL
			,DateReceived DATETIME NULL
			,Contact VARCHAR(100) NULL
			,PayerType INT NULL
			,PayerId INT NULL
			,Active CHAR(1) NULL
			,FinancialActivityId INT NULL
			,PaymentId INT NULL
			)

		DECLARE @CustomFilters TABLE (CoveragePlanId INT)
		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFiltersApplied CHAR(1)
		DECLARE @Past180Date DATETIME
		DECLARE @TotalBalanceAmount MONEY
		DECLARE @ARBucketStart DATETIME
			,@ARBucketEnd DATETIME

		SELECT @Past180Date = DATEADD(dd, - 180, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))

		SELECT @TotalBalanceAmount = CONVERT(MONEY, ExternalCode1)
		FROM GlobalSubCodes
		WHERE GlobalSubCodeId = @PlanTotalBalance

		-- Calculate AR Bucket Start and End        
		IF @ARBucket IS NOT NULL
		BEGIN
			SELECT @ARBucketEnd = CASE @ARBucket
					WHEN 532
						THEN NULL
					WHEN 533
						THEN DATEADD(dd, - 30, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 534
						THEN DATEADD(dd, - 60, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 535
						THEN DATEADD(dd, - 90, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 536
						THEN DATEADD(dd, - 120, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 537
						THEN DATEADD(dd, - 150, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 538
						THEN DATEADD(dd, - 180, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 539
						THEN DATEADD(dd, - 365, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					END
				,@ARBucketStart = CASE @ARBucket
					WHEN 532
						THEN DATEADD(dd, - 30, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 533
						THEN DATEADD(dd, - 60, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 534
						THEN DATEADD(dd, - 90, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 535
						THEN DATEADD(dd, - 120, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 536
						THEN DATEADD(dd, - 150, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 537
						THEN DATEADD(dd, - 180, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 538
						THEN DATEADD(dd, - 365, CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101)))
					WHEN 539
						THEN NULL
					END
		END

		SET FORCEPLAN ON
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'CoveragePlanName'
		-- 
		-- New retrieve - the request came by clicking on the Apply Filter button                   
		--
		SET @ApplyFilterClicked = 'Y'
		SET @CustomFiltersApplied = 'N'

		--SET @PageNumber = 1
		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO @CustomFilters (CoveragePlanId)
			EXEC scsp_PMARByPlan @PayerType = @PayerType
				,@PayerId = @PayerId
				,@ActivePlans = @ActivePlans
				,@CoveragePlanId = @CoveragePlanId
				,@PlanTotalBalance = @PlanTotalBalance
				,@ARBucket = @ARBucket
				,@OtherFilter = @OtherFilter
				,@StaffId = @StaffId
		END

		-- Get Balance        
		INSERT INTO #ResultSet (
			CoveragePlanId
			,CoveragePlanName
			,CoveragePlanId2
			,TotalBalance
			,PastDays
			,NotBilled
			,Contact
			,PayerType
			,PayerId
			,Active
			)
		SELECT e.CoveragePlanId
			,e.DisplayAs
			,e.CoveragePlanId
			,SUM(z.amount)
			,
			--a.Balance,
			SUM(CASE 
					WHEN c.DateOfService < @Past180Date
						THEN z.amount
					ELSE 0
					END)
			,
			--SUM(CASE WHEN b.LastBilledDate IS NULL and ISNULL(e.Capitated, 'N') <> 'Y' THEN z.amount ELSE 0 END),        
			SUM(CASE 
					WHEN b.LastBilledDate IS NULL
						AND ISNULL(e.Capitated, 'N') <> 'Y'
						AND b.Priority <> 0
						AND a.Balance > 0
						THEN z.Amount
					ELSE 0
					END)
			,ISNULL(e.ContactName, RTRIM('')) + ' ' + ISNULL(e.ContactPhone, RTRIM(''))
			,f.PayerType
			,f.PayerId
			,e.Active
		FROM OpenCharges a
		INNER JOIN Charges b ON (a.ChargeId = b.ChargeId)
			AND ISNULL(b.RecordDeleted, 'N') = 'N'
		INNER JOIN Services c ON (b.ServiceId = c.ServiceId)
			AND ISNULL(c.RecordDeleted, 'N') = 'N'
		INNER JOIN ARLedger z ON (b.ChargeId = z.ChargeId)
			AND ISNULL(z.RecordDeleted, 'N') = 'N'
		INNER JOIN ClientCoveragePlans d ON (d.ClientCoveragePlanId = b.ClientCoveragePlanId)
			AND ISNULL(d.RecordDeleted, 'N') = 'N'
		INNER JOIN CoveragePlans e ON (e.CoveragePlanId = d.CoveragePlanId)
			AND ISNULL(e.RecordDeleted, 'N') = 'N'
		INNER JOIN Payers f ON (f.PayerId = e.PayerId)
			AND ISNULL(f.RecordDeleted, 'N') = 'N'
		INNER JOIN Clients cl ON cl.ClientId = c.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = c.ProcedureCodeId
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		WHERE (
				(
					@CustomFiltersApplied = 'Y'
					AND EXISTS (
						SELECT *
						FROM @CustomFilters cf
						WHERE cf.CoveragePlanId = e.CoveragePlanId
						)
					)
				OR (
					@CustomFiltersApplied = 'N'
					AND (
						
							(@PayerType = - 1
							AND
							( ISNULL(@FinancialAssignmentId, - 1) = - 1 OR
								  EXISTS (
										SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargePayerType,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									)						
							)
						OR (
							f.PayerType = @PayerType							
							OR(
							EXISTS (
										SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargePayerType,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPayerTypes FAPT
								WHERE FAPT.FinancialAssignmentId = @FinancialAssignmentId
									AND FAPT.PayerTypeId = f.PayerType
									AND FAPT.AssignmentType = 8979
									AND ISNULL(FAPT.RecordDeleted, 'N') = 'N'
								)
								)
							)
						)
					AND (
						(
							@PayerId = - 1
							AND
							( ISNULL(@FinancialAssignmentId, - 1) = - 1 OR
								  EXISTS (
										SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargePayer,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
									)
										
							)
						OR (
							f.PayerId = @PayerId
							
							OR(
							
							 EXISTS (
										SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargePayer,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
										)
							OR EXISTS (
								SELECT 1
								FROM FinancialAssignmentPayers FAP
								WHERE FAP.FinancialAssignmentId = @FinancialAssignmentId
									AND FAP.PayerId = f.PayerId
									AND FAP.AssignmentType = 8979
									AND ISNULL(FAP.RecordDeleted, 'N') = 'N'
								)
								)
							)
						)
					AND (
						(
							@CoveragePlanId = - 1							
							AND ( ISNULL(@FinancialAssignmentId, - 1) = - 1 
								OR
								 EXISTS (
									SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargePlan,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								AND	--- mraymond 5/8/18 Changed OR to AND 
								 EXISTS (
									SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargeServiceArea,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
									)
								)
							
							)
						OR (
							e.CoveragePlanId = @CoveragePlanId
							OR (
							
							(EXISTS (
									SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargePlan,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
									) OR
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentPlans FACP
									WHERE FACP.FinancialAssignmentId = @FinancialAssignmentId
										AND FACP.CoveragePlanId = e.CoveragePlanId
										AND FACP.AssignmentType = 8979
										AND ISNULL(FACP.RecordDeleted, 'N') = 'N'
									)
									)
								AND (	--- mraymond 5/8/18 Changed OR to AND 
								EXISTS (
									SELECT 1
										FROM FinancialAssignments
										WHERE FinancialAssignmentId = @FinancialAssignmentId
											AND ISNULL(AllChargeServiceArea,'N') = 'Y'
											AND ISNULL(RecordDeleted, 'N') = 'N'
									) OR
								EXISTS (
									SELECT 1
									FROM FinancialAssignmentServiceAreas FAS
									INNER JOIN CoveragePlanServiceAreas CPS ON FAS.ServiceAreaId = CPS.ServiceAreaId
									WHERE FAS.FinancialAssignmentId = @FinancialAssignmentId
										AND CPS.CoveragePlanId = e.CoveragePlanId
										AND FAS.AssignmentType = 8979
										AND ISNULL(FAS.RecordDeleted, 'N') = 'N'
										AND ISNULL(CPS.RecordDeleted, 'N') = 'N'
									)
									)
								)
							)
						)
					AND (
						@ActivePlans = '-1'
						OR (
							@ActivePlans = '1'
							AND e.Active = 'Y'
							)
						OR (
							@ActivePlans = '2'
							AND e.Active = 'N'
							)
						)
					AND (
						@ARBucket = 531
						OR (
							(
								@ARBucketStart IS NULL
								OR c.DateOfService >= @ARBucketStart
								)
							AND (
								@ARBucketEnd IS NULL
								OR c.DateOfService < @ARBucketEnd
								)
							)
						)
					)
				)
		--AND (z.RecordDeleted = 'N' OR z.RecordDeleted IS NULL )        
		--AND z.CoveragePlanId is not Null    
		GROUP BY e.CoveragePlanId
			,e.DisplayAs
			,e.CoveragePlanId
			,ISNULL(e.ContactName, RTRIM('')) + ' ' + ISNULL(e.ContactPhone, RTRIM(''))
			,f.PayerType
			,f.PayerId
			,e.Active

		SET FORCEPLAN OFF
		
		
		--Added by Neelima to get most recent LastBilledDate
  
    CREATE TABLE #TableLastBilledDate ( 
    RowNumber INT  
   ,CoveragePlanId INT NULL  
   ,CoveragePlanName VARCHAR(250) NULL 
   ,LastBilledDate DATETIME NULL 
   )  
  
  INSERT INTO #TableLastBilledDate (
  RowNumber,  
   CoveragePlanId  
   ,CoveragePlanName  
   ,LastBilledDate
   )     
    SELECT 
     ROW_NUMBER() OVER (  
    PARTITION BY a.coveragePlanId
    ORDER BY a.coveragePlanId  
    )  as RRank,
    a.CoveragePlanId ,
	a.CoveragePlanName ,
	MAX(b.BilledDate)
	FROM dbo.CoveragePlans a
	JOIN dbo.ClaimBatches b ON b.CoveragePlanId = a.CoveragePlanId
	WHERE b.BilledDate IS NOT NULL
	AND ISNULL(b.RecordDeleted, 'N') = 'N'
	GROUP BY a.CoveragePlanId ,
	CoveragePlanName
	UNION
	SELECT 
	ROW_NUMBER() OVER (  
    PARTITION BY a.coveragePlanId
    ORDER BY a.coveragePlanId  
    )  as RRank,
	a.CoveragePlanId ,
	a.CoveragePlanName ,
	MAX(c.BilledDate)
	FROM dbo.CoveragePlans a
	JOIN dbo.Payers b ON b.PayerId = a.PayerId
	JOIN dbo.ClaimBatches c ON c.PayerId = a.PayerId
	JOIN dbo.ClaimBatchCharges d ON d.ClaimBatchId = c.ClaimBatchId
	JOIN dbo.Charges e ON e.ChargeId = d.ChargeId
	JOIN dbo.ClientCoveragePlans f ON f.ClientCoveragePlanId = e.ClientCoveragePlanId
	AND f.CoveragePlanId = a.CoveragePlanId
	WHERE c.BilledDate IS NOT NULL
	AND ISNULL(c.RecordDeleted, 'N') = 'N'
	AND ISNULL(d.RecordDeleted, 'N') = 'N'
	GROUP BY a.CoveragePlanId ,
	a.CoveragePlanName
	ORDER BY a.CoveragePlanId ,
	a.CoveragePlanName
    

		-- Apply Total Balance condition        
		IF @TotalBalanceAmount IS NOT NULL
			DELETE a
			FROM #ResultSet a
			WHERE TotalBalance <= @TotalBalanceAmount

		-- Compute Last Billed Date        
		--UPDATE a
		--SET LastBilledDate = b.BilledDate
		--FROM #ResultSet a
		--INNER JOIN ClaimBatches b ON (a.CoveragePlanId = b.CoveragePlanId)
		--WHERE NOT EXISTS (
		--		SELECT *
		--		FROM ClaimBatches c
		--		WHERE b.CoveragePlanId = c.CoveragePlanId
		--			AND c.BilledDate > b.BilledDate
		--		)
		
		UPDATE a  
		SET LastBilledDate = b.LastBilledDate  
		FROM #ResultSet a  
		JOIN (Select CoveragePlanId,LastBilledDate From #TableLastBilledDate where RowNumber = 1) b ON (a.CoveragePlanId = b.CoveragePlanId)  
		WHERE a.LastBilledDate is null or a.LastBilledDate=''

		UPDATE a
		SET DateReceived = b.DateReceived
			,FinancialActivityId = b.FinancialActivityId
			,PaymentId = b.PaymentId
		FROM #ResultSet a
		INNER JOIN Payments b ON (a.CoveragePlanId = b.CoveragePlanId)
		INNER JOIN (
			SELECT CoveragePlanId
				,MAX(DateReceived) AS DateReceived
			FROM Payments
			GROUP BY CoveragePlanId
			) c ON c.CoveragePlanId = b.CoveragePlanId
			AND c.DateReceived = b.DateReceived

		--  Get Last Payment in case payment made by payer        
		UPDATE a
		SET DateReceived = b.DateReceived
			,FinancialActivityId = b.FinancialActivityId
			,PaymentId = b.PaymentId
		FROM #ResultSet a
		INNER JOIN Payments b ON (a.PayerId = b.PayerId)
		WHERE b.DateReceived > a.DateReceived
			AND NOT EXISTS (
				SELECT *
				FROM Payments c
				WHERE b.PayerId = c.PayerId
					AND c.DateReceived > a.DateReceived
					AND c.DateReceived > b.DateReceived
				)
			-- Format data    is moved to Code to avoid sorting issue    
			/*	UPDATE #ResultSet        
	SET TotalBalanceFormated	=	'$' + CONVERT (varchar,TotalBalance,25),        
		LastBilledDateFormated	=	CONVERT(VARCHAR,LastBilledDate,101),        
		PastDaysFormatted		=	'$' + CONVERT (VARCHAR,PastDays,25),        
		NotBilledFormatted		=	'$' + CONVERT (VARCHAR,NotBilled,10),        
		DateReceivedFormatted	=	CONVERT(VARCHAR,DateReceived,101)        
 */
			;

		WITH counts
		AS (
			SELECT count(*) AS totalrows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT CoveragePlanId
				,CoveragePlanName
				,TotalBalance
				,LastBilledDate
				,PastDays
				,NotBilled
				,DateReceived
				,Contact
				,PaymentId
				,FinancialActivityId
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'CoveragePlanName'
								THEN CoveragePlanName
							END
						,CASE 
							WHEN @SortExpression = 'CoveragePlanName desc'
								THEN CoveragePlanName
							END DESC
						,CASE 
							WHEN @SortExpression = 'TotalBalance'
								THEN TotalBalance
							END
						,CASE 
							WHEN @SortExpression = 'TotalBalance desc'
								THEN TotalBalance
							END DESC
						,CASE 
							WHEN @SortExpression = 'LastBilledDate'
								THEN LastBilledDate
							END
						,CASE 
							WHEN @SortExpression = 'LastBilledDate desc'
								THEN LastBilledDate
							END DESC
						,CASE 
							WHEN @SortExpression = 'PastDays'
								THEN PastDays
							END
						,CASE 
							WHEN @SortExpression = 'PastDays desc'
								THEN PastDays
							END DESC
						,CASE 
							WHEN @SortExpression = 'NotBilled'
								THEN NotBilled
							END
						,CASE 
							WHEN @SortExpression = 'NotBilled desc'
								THEN NotBilled
							END DESC
						,CASE 
							WHEN @SortExpression = 'DateReceived'
								THEN DateReceived
							END
						,CASE 
							WHEN @SortExpression = 'DateReceived desc'
								THEN DateReceived
							END DESC
						,CASE 
							WHEN @SortExpression = 'Contact'
								THEN Contact
							END
						,CASE 
							WHEN @SortExpression = 'Contact desc'
								THEN Contact
							END DESC
						,CoveragePlanId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) CoveragePlanId
			,CoveragePlanName
			,TotalBalance
			,LastBilledDate
			,PastDays
			,NotBilled
			,DateReceived
			,Contact
			,TotalCount
			,RowNumber
			,PaymentId
			,FinancialActivityId
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT CoveragePlanId
			,CoveragePlanName
			,TotalBalance
			,LastBilledDate
			,PastDays
			,NotBilled
			,DateReceived
			,Contact
			,PaymentId
			,FinancialActivityId
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMARByPlan') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


GO


