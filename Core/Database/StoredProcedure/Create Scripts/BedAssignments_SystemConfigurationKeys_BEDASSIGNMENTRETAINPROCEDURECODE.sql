DELETE
FROM SystemConfigurationKeys
WHERE [Key] = 'BEDASSIGNMENTRETAINPROCEDURECODE'

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'RETAINBEDASSIGNMENTPROCEDURECODE'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'RETAINBEDASSIGNMENTPROCEDURECODE'
		,'Y'
		,'Y,NULL'
		)
END
ELSE
BEGIN
	UPDATE SystemConfigurationKeys
	SET ModifiedDate = CURRENT_TIMESTAMP
		,ModifiedBy = SYSTEM_USER
		,[Key] = 'RETAINBEDASSIGNMENTPROCEDURECODE'
		,Value = 'Y'
		,AcceptedValues = 'Y,NULL'
	WHERE [Key] = 'RETAINBEDASSIGNMENTPROCEDURECODE'
END