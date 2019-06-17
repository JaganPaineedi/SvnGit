/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMRefunds]    Script Date: 04/29/2014 13:41:37 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMRefunds]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageCMRefunds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageCMRefunds]    Script Date: 04/29/2014 13:41:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCMRefunds] @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@OtherFilter INT
	,@InsurerId INT
	,@ProviderId INT
	,@ReceivedDateFrom VARCHAR(50)
	,@ReceivedDateTo VARCHAR(50)
	,@HaveBalance INT
	,@StaffId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_ListPageCMRefunds             */
/* Copyright: 2014 Provider Claim Management System             */
/* Creation Date:  04/14/2014                                    */
/*                                                                   */
/* Purpose: retuns list of refunds by providers             */
/*                                                                   */
/* Input Parameters:                                    */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return: returns list of refunds by providers          */
/*                                                                         */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date               Author                   Purpose                         */
/* 10/01/2006    John Sudhakar  				Created                         */
/* 05-Nov-2014 Modified by SuryaBalan Task# 86 CM Environment Issues */
--	14.May.2015	Rohith Uppin	Constraint added for @HaveBalance section. Task#341 SWMBH Support.
--  14.Feb.2017  Pradeep Tripathi     What:Modified to check if @ReceivedDateFrom and @ReceivedDateTo
---                                        is null or empty then it should pull refunds regardless of ProviderRefunds.DateOfRefund 
---                                   Why: AlleganSupport-#687.17 
/* 20 Feb 2019 Vishnu Narayanan       What: ISNULL check was not present in RecordDeleted column
                                      Why :  KCMHSAS - Support - #1289*/
/*********************************************************************/
BEGIN
	BEGIN TRY
		CREATE TABLE #CustomFilters (ProviderRefundId INT NULL)

		DECLARE @ApplyFilterClicked CHAR(1)
		DECLARE @CustomFiltersApplied CHAR(1)
		DECLARE @AllProviders VARCHAR(1)
		DECLARE @AllInsurers VARCHAR(1)

		SET @AllProviders = (
				SELECT TOP 1 ISNULL(AllProviders, 'N')
				FROM staff
				WHERE StaffId = @StaffId
				)
		SET @AllInsurers = (
				SELECT TOP 1 ISNULL(AllInsurers, 'N')
				FROM staff
				WHERE StaffId = @StaffId
				)
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'ProviderName'
		SET @ApplyFilterClicked = 'Y'
		SET @CustomFiltersApplied = 'N'

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (ProviderRefundId)
			EXEC scsp_ListPageCMRefunds @SessionId = @SessionId
				,@InstanceId = @InstanceId
				,@PageNumber = @PageNumber
				,@PageSize = @PageSize
				,@SortExpression = @SortExpression
				,@OtherFilter = @OtherFilter
				,@InsurerId = @InsurerId
				,@ProviderId = @ProviderId
				,@ReceivedDateFrom = @ReceivedDateFrom
				,@ReceivedDateTo = @ReceivedDateTo
				,@HaveBalance = @HaveBalance
				,@StaffId = @StaffId
		END;

		WITH ListPageCMRefunds
		AS (
			SELECT pr.DateofRefund
				,pr.CheckNumber
				,p.ProviderName
				,pr.Amount
				,pr.BalanceAmount
				,i.InsurerName
				,pr.ProviderId
				,pr.InsurerId
				,pr.ProviderRefundId
				,'Y' AS AllRows
				,Pr.TaxId AS TaxId
			FROM ProviderRefunds pr
			INNER JOIN Providers p ON pr.ProviderId = p.ProviderId
			INNER JOIN Insurers i ON pr.InsurerId = i.InsurerId
			WHERE ISNULL(pr.RecordDeleted, 'N') <> 'Y'
				AND ISNULL(p.RecordDeleted, 'N') <> 'Y'
				AND ISNULL(i.RecordDeleted, 'N') <> 'Y'
				AND (
					@InsurerId = - 1
					OR @InsurerId = Pr.InsurerId
					)
				AND (
					EXISTS (
						SELECT InsurerId
						FROM StaffInsurers
						WHERE ISNULL(RecordDeleted, 'N') = 'N'
							AND staffid = @StaffId
							AND Pr.InsurerId = InsurerId
							AND @AllInsurers = 'N'
						)
					OR EXISTS (
						SELECT InsurerId
						FROM Insurers
						WHERE isnull(RecordDeleted, 'N') <> 'Y'
							AND Pr.InsurerId = InsurerId
							AND @AllInsurers = 'Y'
						)
					)
				AND (
					@ProviderId = - 1
					OR @ProviderId = Pr.ProviderId
					)
				AND (
					EXISTS (
						SELECT ProviderId
						FROM staffproviders
						WHERE ISNULL(RecordDeleted, 'N') = 'N'
							AND staffid = @StaffId
							AND Pr.ProviderId = ProviderId
							AND @AllProviders = 'N'
						)
					OR EXISTS (
						SELECT ProviderId
						FROM Providers
						WHERE isnull(RecordDeleted, 'N') <> 'Y'
							AND Pr.ProviderId = ProviderId
							AND @AllProviders = 'Y'
						)
					)
		
			 AND----14.Feb.2017 Pradeep Tripathi
			   (
			     (ISNULL(@ReceivedDateFrom,'')='' OR cast(pr.DateOfRefund as DATE)>=CAST(@ReceivedDateFrom  as date))
			     AND (ISNULL(@ReceivedDateTo,'')='' OR cast(pr.DateOfRefund as DATE)<=CAST(@ReceivedDateTo as Date))
			   )
			 
				AND (
					(
						@HaveBalance = 1
						AND EXISTS (
							SELECT pr1.BalanceAmount
							FROM ProviderRefunds pr1
							WHERE pr1.BalanceAmount > 0	AND pr.ProviderRefundId = PR1.ProviderRefundId
							)
						)
					OR (
						@HaveBalance = 0
						AND EXISTS (
							SELECT pr2.BalanceAmount
							FROM ProviderRefunds pr2
							WHERE pr2.BalanceAmount <= 0 AND pr.ProviderRefundId = pr2.ProviderRefundId
							)
						)
					)
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM ListPageCMRefunds
			)
			,RankResultSet
		AS (
			SELECT DateofRefund
				,CheckNumber
				,ProviderName
				,Amount
				,BalanceAmount
				,InsurerName
				,ProviderId
				,InsurerId
				,ProviderRefundId
				,'Y' AS AllRows
				,TaxId
				,COUNT(*) OVER () AS TotalCount
				,RANK() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'DateofRefund'
								THEN DateofRefund
							END
						,CASE 
							WHEN @SortExpression = 'CheckNumber'
								THEN CheckNumber
							END
						,CASE 
							WHEN @SortExpression = 'ProviderName'
								THEN ProviderName
							END
						,CASE 
							WHEN @SortExpression = 'Amount'
								THEN Amount
							END
						,CASE 
							WHEN @SortExpression = 'BalanceAmount'
								THEN BalanceAmount
							END
						,CASE 
							WHEN @SortExpression = 'InsurerName'
								THEN InsurerName
							END
						,CASE 
							WHEN @SortExpression = 'ProviderId'
								THEN ProviderId
							END
						,CASE 
							WHEN @SortExpression = 'InsurerId'
								THEN InsurerId
							END
						,CASE 
							WHEN @SortExpression = 'ProviderRefundId'
								THEN ProviderRefundId
							END
						,ProviderRefundId
					) AS RowNumber
			FROM ListPageCMRefunds
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
				) DateofRefund
			,CheckNumber
			,ProviderName
			,Amount
			,BalanceAmount
			,InsurerName
			,ProviderId
			,InsurerId
			,ProviderRefundId
			,'Y' AS AllRows
			,TaxId
			,TotalCount
			,RowNumber
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

		SELECT DateofRefund
			,CheckNumber
			,ProviderName
			,Amount
			,BalanceAmount
			,InsurerName
			,ProviderId
			,InsurerId
			,ProviderRefundId
			,'Y' AS AllRows
			,TaxId
		FROM #FinalResultSet

		DROP TABLE #CustomFilters
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCMRefunds') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.  
				16
				,-- Severity.  
				1 -- State.  
				);
	END CATCH
END
GO

