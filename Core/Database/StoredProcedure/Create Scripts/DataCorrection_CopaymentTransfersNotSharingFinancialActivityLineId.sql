

UPDATE	al
SET		al.FinancialActivityLineId = fal2.FinancialActivityLineId
FROM	dbo.FinancialActivityLines AS fal
JOIN	dbo.FinancialActivities AS fa ON fa.FinancialActivityId = fal.FinancialActivityId
										 AND fa.ActivityType = 4321 -- service complete
JOIN	dbo.ARLedger AS al ON al.FinancialActivityLineId = fal.FinancialActivityLineId
JOIN	dbo.FinancialActivityLines AS fal2 ON fal.FinancialActivityId = fal2.FinancialActivityId
											  AND fal.FinancialActivityLineId <> fal2.FinancialActivityLineId
JOIN	dbo.ARLedger AS al3 ON al3.FinancialActivityLineId = fal2.FinancialActivityLineId
							   AND al3.LedgerType = 4204
WHERE	al.LedgerType = 4204
		AND EXISTS ( SELECT	1
					 FROM	dbo.ARLedger AS al2
					 WHERE	al2.FinancialActivityLineId = al.FinancialActivityLineId
							AND al2.LedgerType = 4201 )



--4321