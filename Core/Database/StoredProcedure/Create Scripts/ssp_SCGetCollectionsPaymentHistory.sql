/****** Object:  StoredProcedure [dbo].[ssp_SCGetCollectionsPaymentHistory]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCollectionsPaymentHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCollectionsPaymentHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCollectionsPaymentHistory]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetCollectionsPaymentHistory] @PageNumber INT = 1
	,@ClientId INT
AS
-- =============================================    
-- Author      : Akwinass.D 
-- Date        : 07/JULY/2015  
-- Purpose     : To Get Payment Records. 
-- Date              Author                  Purpose                   */
-- ============================================= 
BEGIN
	BEGIN TRY		
		DECLARE @PageSize INT = 100
		DECLARE @SortExpression VARCHAR(100) = 'PaymentDate'
		DECLARE @ActivityType INT = 4325
		DECLARE @NumberOfDaysOld INT
		SELECT TOP 1 @NumberOfDaysOld = CAST(Value AS INT) FROM SystemConfigurationKeys WHERE [Key] = 'Payment#OfDaysOld'
		SET @NumberOfDaysOld = ISNULL(@NumberOfDaysOld,90);

		WITH TotalPayments
		AS (
			SELECT  Payments.DateReceived AS PaymentDate
				,'$' + convert(VARCHAR, Payments.Amount, 10) AS PaymentAmount
				,Payments.PaymentId
				,Payments.FinancialActivityId
				,[dbo].[ssf_SCGetCollectionPayments] (Payments.PaymentId,Payments.FinancialActivityId) AS AppliedTo
			FROM Payments
			LEFT JOIN Payers ON Payments.PayerId = Payers.PayerId
			LEFT JOIN CoveragePlans ON Payments.CoveragePlanId = CoveragePlans.CoveragePlanId
			LEFT JOIN Payers Payer2 ON CoveragePlans.PayerId = Payer2.PayerId
			LEFT JOIN Clients ON Payments.ClientId = Clients.ClientId
			LEFT JOIN FinancialActivities ON FinancialActivities.FinancialActivityId = Payments.FinancialActivityId
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = Payments.LocationId
			LEFT JOIN ErBatches erb ON ERB.PaymentiD = Payments.PAYMENTID
			LEFT JOIN Staff S ON Payments.CreatedBy = S.UserCode
			WHERE ISNULL(Payments.RecordDeleted, 'N') = 'N'
				AND FinancialActivities.ActivityType = @ActivityType
				AND Payments.ClientId = @ClientId
				AND DATEDIFF(dd, Payments.DateReceived, GETDATE()) <= @NumberOfDaysOld
			)
			,counts
		AS (
			SELECT COUNT(*) AS totalrows
			FROM TotalPayments
			)
			,InternalCollections
		AS (
			SELECT PaymentId
				,FinancialActivityId
				,PaymentDate
				,PaymentAmount
				,AppliedTo
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'PaymentDate'
								THEN PaymentDate
							END
						,CASE 
							WHEN @SortExpression = 'PaymentDate DESC'
								THEN PaymentDate
							END DESC
					) AS RowNumber
			FROM TotalPayments
			)
		SELECT TOP (CASE  WHEN (@PageNumber = - 1) THEN (SELECT ISNULL(totalrows, 0) FROM counts) ELSE (@PageSize) END) PaymentId
			,FinancialActivityId
			,PaymentDate
			,PaymentAmount
			,AppliedTo
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM InternalCollections
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(COUNT(*), 0) FROM #FinalResultSet) < 1
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

		SELECT PaymentId
			,FinancialActivityId
			,CONVERT(VARCHAR(10), PaymentDate, 101) AS PaymentDate
			,PaymentAmount
			,AppliedTo
		FROM #FinalResultSet
		ORDER BY RowNumber

	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetCollectionsPaymentHistory: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


