--
-- Core Bugs 2423
-- Update Ledgers and Posted Amounts to Correct Values.
--
BEGIN TRY

	BEGIN TRAN

	UPDATE AR
	SET ar.CoveragePlanId = ccp.CoveragePlanId
		,ar.ModifiedBy = 'SA Core Bugs #2423'
		,ar.ModifiedDate = GETDATE()
	FROM ARLedger ar
	JOIN Charges c ON c.ChargeId = ar.ChargeId
	JOIN ClientCoveragePlans ccp ON ccp.ClientCoveragePlanId = c.ClientCoveragePlanId
	WHERE Ar.PaymentId IS NULL
	AND ISNULL(ar.CoveragePlanId,-1) != ISNULL(ccp.CoveragePlanId,-1)



	UPDATE ar
	SET ar.PaymentId = p.PaymentId
		,ar.CoverageplanId = P.CoveragePlanId
		,ar.ModifiedBy = 'SA Core Bugs #2423'
		,ar.ModifiedDate = GETDATE()
	FROM ARLedger AS ar
	JOIN AccountingPeriods AS ap ON ap.AccountingPeriodId = ar.AccountingPeriodId
	JOIN FinancialActivityLines AS fal ON fal.FinancialActivityLineId = ar.FinancialActivityLineId
	JOIN FinancialActivities AS fa ON fa.FinancialActivityId = fal.FinancialActivityId
	JOIN Payments AS p ON p.FinancialActivityId = fa.FinancialActivityId
	WHERE ar.LedgerType = 4202
		AND ar.PaymentId IS NULL

	-- Fix UnpostedAmount

	update p set
		UnpostedAmount = p.Amount + isnull(arp.AmountPosted, 0.0) - isnull(rfp.AmountRefunded, 0.0),
		ModifiedBy = 'SA Core Bugs #2423'
	from Payments as p
	left join (
		select ar.PaymentId, sum(Amount) as AmountPosted
		from ARLedger as ar
		where isnull(ar.RecordDeleted, 'N') <> 'Y'
		group by ar.PaymentId
	) as arp on arp.PaymentId = p.PaymentId
	left join (
		select rf.PaymentId, sum(rf.Amount) as AmountRefunded
		from Refunds as rf
		where isnull(rf.RecordDeleted, 'N') <> 'Y'
		group by rf.PaymentId
	) as rfp on rfp.PaymentId = p.PaymentId
	where ( p.Amount + isnull(arp.AmountPosted, 0.0) - isnull(rfp.AmountRefunded, 0.0) ) <> isnull(p.UnpostedAmount, 0.0)
	and isnull(p.RecordDeleted, 'N') <> 'Y'

	COMMIT TRAN

END TRY
BEGIN CATCH
	DECLARE @Error_Message nvarchar(4000)
	set @Error_Message = ERROR_MESSAGE()
	set @Error_Message = LEFT('<<<Task 2423 Upgrade Script Failed with Error: ' + @Error_Message + '.>>>', 4000)
	RAISERROR(@Error_Message, 16, 1)
END CATCH
GO
