-- Data correction script for OpenCharges
DECLARE @UserCode type_UserId = 'Data Correction Task #424.1';

UPDATE oc
SET oc.Balance = tot.bal
	,oc.ModifiedBy = @UserCode
	,oc.ModifiedDate = GETDATE()
FROM OpenCharges oc
CROSS APPLY (
	SELECT SUM(ar.Amount) AS bal
	FROM dbo.ARLedger ar
	WHERE ar.ChargeId = oc.chargeid
		AND ISNULL(ar.RecordDeleted, 'N') = 'N'
	) tot
WHERE oc.Balance <> tot.bal;

GO

DELETE
FROM OpenCharges
WHERE balance = 0.00;

GO
