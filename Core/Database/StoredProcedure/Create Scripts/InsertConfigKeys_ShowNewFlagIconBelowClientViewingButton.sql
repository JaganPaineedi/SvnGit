-- Insert script for SystemConfigurationKeys ShowNewFlagIconBelowClientViewingButton    Task:  New Directions - Support Go Live #678
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowNewFlagIconBelowClientViewingButton'
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
		,'ShowNewFlagIconBelowClientViewingButton'
		,'Yes'
		,'Yes,No'
		,'This key is used to either show or hide the "create new client flag" icon that appears below the "Client Viewing" button on the left panel of our application (after login).If the value is Yes, the new flag icon is visible to users If the value of the key is No, the new flag icon will not be visible'
		,'Y'
		,'ClientFlag'
		,'Client Viewing '
		)
END


