INSERT INTO Observations (
	CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,ObservationName
	,ObservationMethodIdentifier
	)
SELECT HDA.CreatedBy
	,HDA.CreatedDate
	,HDA.ModifiedBy
	,HDA.ModifiedDate
	,HDA.NAME
	,HDA.LoincCode
FROM HealthDataAttributes HDA
WHERE HDA.LoincCode IS NOT NULL
	AND NOT EXISTS (
		SELECT 1
		FROM Observations O
		WHERE O.ObservationMethodIdentifier = HDA.LoincCode
		)
