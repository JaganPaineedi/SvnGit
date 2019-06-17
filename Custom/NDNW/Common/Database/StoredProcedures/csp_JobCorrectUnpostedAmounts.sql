IF EXISTS 
(
	SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCorrectUnpostedAmounts]')
		AND type IN (N'P', N'PC')
)
	DROP PROCEDURE [dbo].[csp_JobCorrectUnpostedAmounts]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_JobCorrectUnpostedAmounts] 
(
	@CutOff DATETIME = NULL
)
AS
/***********************************************************************************************************************
	Stored Procedure:	csp_JobCorrectUnpostedAmounts
	Created Date:		02/26/2018
	Created By:			Ting-Yu Mu
========================================================================================================================
	Modification Date
========================================================================================================================
	[Date]			[Author]		[Purpose]
	-------------	--------------	----------------------------------------------------------------
	02/26/2018		Ting-Yu Mu		What: Created
									Why: New Directions - Support Go Live # 791
***********************************************************************************************************************/
/** Unposted Amount Correction **/
BEGIN TRY
	INSERT INTO dbo.CustomBugTracking 
	(
		ClientId,
		DocumentId,
		ServiceId,
		DESCRIPTION,
		CreatedDate,
		DocumentVersionId
	)
	SELECT	pay.ClientId,
			NULL,
			NULL,
			'Mismatch on payment unposted amount for paymentid ' + CAST(pay.paymentId AS VARCHAR(MAX)) + 
				': Expected ' + CAST(pay.Amount - ISNULL(ar.PostedAmount, 0) - ISNULL(ref.RefundedAmount, 0) AS VARCHAR(MAX)) + 
				' but value is: ' + CAST(ISNULL(pay.UnpostedAmount, 0) AS VARCHAR(MAX)),
			GETDATE(),
			NULL
	FROM	dbo.Payments pay
	LEFT JOIN 
	(
		SELECT	PaymentId,
				SUM(Amount) AS RefundedAmount
		FROM	dbo.Refunds
		WHERE	PaymentId IS NOT NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
		GROUP BY PaymentId
	) ref ON pay.PaymentId = ref.PaymentId
	LEFT JOIN 
	(
		SELECT	PaymentId,
				- 1 * SUM(Amount) AS PostedAmount
		FROM	dbo.ARLedger
		WHERE	PaymentId IS NOT NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
		GROUP BY PaymentId
	) ar ON pay.PaymentId = ar.PaymentId
	WHERE pay.Amount - ISNULL(ar.PostedAmount, 0) - ISNULL(ref.RefundedAmount, 0) <> pay.UnpostedAmount
		--AND ar.PostedAmount > 0
		AND ISNULL(pay.RecordDeleted, 'N') = 'N'
		AND 
		(
			pay.CreatedDate > @CutOff
			OR @CutOff IS NULL
		)
	ORDER BY pay.CreatedDate DESC

	BEGIN TRAN

	UPDATE	pay
	SET		pay.UnpostedAmount = pay.Amount - ISNULL(ar.PostedAmount, 0) - ISNULL(ref.RefundedAmount, 0) -- AS SuggestedUnpostedAmount
	FROM	dbo.Payments pay
	LEFT JOIN 
	(
		SELECT	PaymentId,
				SUM(Amount) AS RefundedAmount
		FROM	dbo.Refunds
		WHERE	PaymentId IS NOT NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
		GROUP BY PaymentId
	) ref ON pay.PaymentId = ref.PaymentId
	LEFT JOIN 
	(
		SELECT	PaymentId,
				- 1 * SUM(Amount) AS PostedAmount
		FROM	dbo.ARLedger
		WHERE	PaymentId IS NOT NULL
			AND ISNULL(RecordDeleted, 'N') = 'N'
		GROUP BY PaymentId
	) ar ON pay.PaymentId = ar.PaymentId
	WHERE pay.Amount - ISNULL(ar.PostedAmount, 0) - ISNULL(ref.RefundedAmount, 0) <> pay.UnpostedAmount
		--AND ar.PostedAmount > 0
		AND ISNULL(pay.RecordDeleted, 'N') = 'N'
		AND 
		(
			pay.CreatedDate > @CutOff
			OR @CutOff IS NULL
		)

	COMMIT
END TRY

BEGIN CATCH
	IF @@trancount > 1
		ROLLBACK TRAN
END CATCH
GO


