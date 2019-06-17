IF NOT EXISTS (
			SELECT 1
			FROM SystemConfigurationKeys
			WHERE [Key] = 'SETTABSVISIBLEINPRIVATEWINDOW'
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
		,[Description]
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SETTABSVISIBLEINPRIVATEWINDOW'
		,'2'
		,'1,2,3,4,5'
		,'To Set Which Tabs to Show in PrivateWindow'
		)
END
