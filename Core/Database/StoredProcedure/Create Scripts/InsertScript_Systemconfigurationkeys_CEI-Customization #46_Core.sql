--Created By: bdsahu
--Created Date:30-03-2016
-- Project Name:CEI - Customizations
--Task #46
-- turn off validation for duplicate NPI in CEI
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowNPIProviderValidation'
			AND Value = 'Y'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		)
	VALUES (
		'ShowNPIProviderValidation'
		,'Y'
		)
END