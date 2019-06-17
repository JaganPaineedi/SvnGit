-- Insert script for SystemConfigurationKeys SetDaysToDisplayProvidersAfterContractEndDate   SWMBH - Support #1393
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SetDaysToDisplayProvidersAfterContractEndDate'
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
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SetDaysToDisplayProvidersAfterContractEndDate'
		,'365'
		,'Any positive number, i.e. 0 or above'
		,'Read Key as --- "Set days to display Providers after contract End date". Default Value = 365 Days. The system will display the 
		list of providers upto the number of days specified in the System configuration key even after the contract end date.'
		,'Y'
		,NULL
		)
END






