
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'AllowLabResultsToShowOnClientPrimaryClinicianWidget'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[KEY]
		,[Value]
		,[Description]
		,AcceptedValues
		)
	VALUES (
		'AllowLabResultsToShowOnClientPrimaryClinicianWidget'
		,'No'
		,'This key is used to show Lab Results on widget for Primary Clinician (in Client Information )for client they are assigned.'
		,'Yes, No'
		)
END
ELSE
BEGIN
	UPDATE SystemConfigurationKeys
	SET [value] = 'No'
		,[Description] = 'This key is used to show Lab Results on widget for Primary Clinician (in Client Information )for client they are assigned.'
		,AcceptedValues = 'Yes, No'
	WHERE [KEY] = 'AllowLabResultsToShowOnClientPrimaryClinicianWidget'
END
