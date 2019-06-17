IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [key] = 'SHOWORGANIZATIONNAMEONCAREPLANRDL'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[key]
		,Value
		)
	VALUES (
		'SHOWORGANIZATIONNAMEONCAREPLANRDL'
		,'N'
		)
END
