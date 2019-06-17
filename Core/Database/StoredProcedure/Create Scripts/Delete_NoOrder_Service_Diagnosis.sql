-- Added by Akwinass : 16 FEB 2016
---To remove Service Diagnosis which does not has Order
UPDATE ServiceDiagnosis
SET RecordDeleted = 'Y'
	,DeletedBy = SYSTEM_USER
	,DeletedDate = GETDATE()
WHERE [Order] IS NULL
	AND ISNULL(RecordDeleted, 'N') = 'N'