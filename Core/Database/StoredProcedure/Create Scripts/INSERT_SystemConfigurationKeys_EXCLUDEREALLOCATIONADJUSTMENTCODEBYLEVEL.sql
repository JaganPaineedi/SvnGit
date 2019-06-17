-- Insert script for SystemConfigurationKeys EXCLUDEREALLOCATIONADJUSTMENTCODEBYLEVEL task #454 in CEI - Support Go Live
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'EXCLUDEREALLOCATIONADJUSTMENTCODEBYLEVEL'
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
		,AllowEdit
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'EXCLUDEREALLOCATIONADJUSTMENTCODEBYLEVEL'
		,'Charge'
		,'Service,Charge'
		,'When set to Service, the system will exclude services from reallocation where one of the charges on the service has adjustment code that is listed in ReallocationExcludeAdjustmentTransferCodes. When set to Charge, the system will exclude at the charge level instead of the service level.'
		,'Y'
		,'Reallocation'
		,NULL
		)
END
