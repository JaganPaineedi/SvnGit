IF EXISTS ( SELECT *
				FROM sys.objects
				WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[csp_ReportGetERFileDetails]')
					AND TYPE IN (N'P', N'PC') ) 
	DROP PROCEDURE [dbo].[csp_ReportGetERFileDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_ReportGetERFileDetails] /******************************************************************************
**
**  Name: csp_ReportGetERFileDetails
**  Desc:
**  Provide a file list summary for imported 835 files.
**
**  Return values:
**
**  Parameters:   csp_ReportGetERFileDetails @ERFileId, @UserId, @AccountingPeriodId
**
**  Auth:
**  Date:
*******************************************************************************
**  Change History
*******************************************************************************
**  Date:     Author:   Description:
** 10/1/2012 TER		Created
** 12/2/2013 MDK		Removed UserId and AccountingPeriodId filters for Standardization.
						Removed Processing logic - only results viewing.
*******************************************************************************/ 
	@ERFileId INT
  --, @UserId INT
  --, @AccountingPeriodId int
AS 
	BEGIN TRY

		DECLARE @ProcessedStatus CHAR(1)
		DECLARE @ErrorMessage NVARCHAR(4000)
		DECLARE @tabErrorMessages TABLE (
			  ErrorMessage NVARCHAR(4000)
			)

	--	SELECT @ProcessedStatus = ISNULL(Processed, 'N')
	--		FROM ERFiles
	--		WHERE ERFileId = @ERFileId 
	--	IF @ProcessedStatus = 'N' 
	--		BEGIN
	---- pre-process sanity checks
	---- cannot process without accounting date and user id
	--			IF (@AccountingPeriodId IS NULL)
	--				OR (@UserId IS NULL) 
	--				RAISERROR('User and accounting period must be specified for unprocessed files.', 16, 1)

	--			IF EXISTS ( SELECT *
	--							FROM dbo.AccountingPeriods
	--							WHERE AccountingPeriodId = @AccountingPeriodId
	--								AND OpenPeriod = 'N' ) 
	--				RAISERROR('Cannot post to closed accounting period.', 16, 1)
	
	--			BEGIN TRAN

	---- errors are returned by the proc in a single-column result set
	--			INSERT INTO @TabErrorMessages
	--					(ErrorMessage
	--					)
	--					EXEC ssp_PMElectronicProcessERFile @ERFileId, @UserId
	
	--			SELECT TOP 1 @ErrorMessage = ErrorMessage
	--				FROM @tabErrorMessages
	
	--			IF @ErrorMessage IS NOT NULL 
	--				RAISERROR(@ErrorMessage, 16, 1)
	
	---- update the accounting period id on affected ARLedger entries
	--			DECLARE @tabFinancialActivities TABLE (
	--				  FinancialActivityId INT
	--				)
	
	--			INSERT INTO @tabFinancialActivities
	--					(FinancialActivityId
	--					)
	--					SELECT DISTINCT fal.FinancialActivityId
	--						FROM dbo.FinancialActivityLines AS fal
	--							JOIN dbo.ARLedger AS ar
	--								ON ar.FinancialActivityLineId = fal.FinancialActivityLineId
	--							JOIN dbo.Payments AS p
	--								ON p.PaymentId = ar.PaymentId
	--							JOIN dbo.ERBatchPayments AS bp
	--								ON bp.PaymentId = p.PaymentId 
	--							JOIN dbo.ERBatches AS b
	--								ON b.ERBatchId = bp.ERBatchId
	--						WHERE b.ERFileId = @ERFileId

	---- this should not happen but I'm paranoid
	--			IF EXISTS ( SELECT *
	--							FROM dbo.ARLedger AS ar
	--								JOIN dbo.FinancialActivityLines AS fal
	--									ON fal.FinancialActivityLineId = ar.FinancialActivityLineId
	--								JOIN @tabFinancialActivities AS fa
	--									ON fa.FinancialActivityId = fal.FinancialActivityId 
	--								JOIN dbo.AccountingPeriods AS ap
	--									ON ap.AccountingPeriodId = ar.AccountingPeriodId
	--							WHERE ap.OpenPeriod = 'N' ) 
	--				BEGIN
	--					RAISERROR('Attempted to change accounting periods on ledgers that were previously assigned to closed periods.  Aborting process.', 16, 1)
	--				END
	
	---- Update ledgers based on affected financial activities
	--			UPDATE ar
	--				SET	AccountingPeriodId = @AccountingPeriodId
	--				FROM dbo.ARLedger AS ar
	--					JOIN dbo.FinancialActivityLines AS fal
	--						ON fal.FinancialActivityLineId = ar.FinancialActivityLineId 
	--					JOIN @tabFinancialActivities AS fa
	--						ON fa.FinancialActivityId = fal.FinancialActivityId

	---- they want the "date received" on the check to also match the accounting period selection
	--			UPDATE p
	--				SET	DateReceived = ap.StartDate
	--				FROM dbo.Payments AS p
	--					JOIN dbo.ERBatchPayments AS bp
	--						ON bp.PaymentId = p.PaymentId
	--					JOIN dbo.ERBatches AS b
	--						ON b.ERBatchId = bp.ERBatchId 
	--					CROSS JOIN dbo.AccountingPeriods AS ap
	--				WHERE b.ERFileId = @ERFileId
	--					AND ap.AccountingPeriodId = @AccountingPeriodId

	--			SET @ErrorMessage = 'File was successfully processed.  Posting results are shown.'
	--			COMMIT TRAN
	--		END
	--	ELSE 
			--BEGIN
			--	SET @ErrorMessage = 'File was processed earlier.  Posting results are shown.'
			--END
	
	SET @ErrorMessage = 'ER File Payment Posting Results'
	
		SELECT a.ERBatchId
			  , b.CheckDate
			  , b.CheckNumber
			  , b.Amount AS Amount
			  , b.PaymentId
			  , b.DateCreated
			  , c.DisplayAs
			  , CASE WHEN b.PaymentId IS NOT NULL THEN p.UnpostedAmount
					 ELSE b.Amount
				END AS UnpostedAmount
			  , @ErrorMessage AS ErrorMessage
			FROM ERBatches a
				LEFT JOIN ERBatchPayments b
					ON (a.ERBatchId = b.ERBatchId)
				JOIN dbo.ERFiles AS f
					ON f.ERFileId = a.ERFileId
				LEFT JOIN CoveragePlans c
					ON (b.CoveragePlanId = c.CoveragePlanId) 
				LEFT JOIN dbo.Payments AS p
					ON p.PaymentId = b.PaymentId
			WHERE a.ERFileId = @ERFileId

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRAN

		SET @ErrorMessage = ERROR_MESSAGE()

-- send results back to the RDL
		SELECT NULL AS ERBatchId
			  , NULL AS CheckDate
			  , NULL AS CheckNumber
			  , NULL AS Amount
			  , NULL AS PaymentId
			  , NULL AS DateCreated
			  , NULL AS DisplayAs
			  , NULL AS UnpostedAmount
			  , @ErrorMessage AS ErrorMessage


	END CATCH
go
