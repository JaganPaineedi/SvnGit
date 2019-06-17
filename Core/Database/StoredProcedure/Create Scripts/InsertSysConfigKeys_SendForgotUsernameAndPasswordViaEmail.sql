-- Insert script for SystemConfigurationKeys SendForgotUsernameAndPasswordViaEmail   Engineering Improvement Initiatives- NBL(I)  #311
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SendForgotUsernameAndPasswordViaEmail'
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
		,Comments
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SendForgotUsernameAndPasswordViaEmail'
		,'Yes'
		,'Yes/No'
		,'Reads as - "Send Forgot Username And Password Via Email". IF Value is "Yes" This key will enable sending the username/password through email. IF Value is "No" directly get their username/password on login screen.'
		,'Y'
		,'ForgotUsername page and ForgotPassword page'
		,'IF Value is "Yes" This key will enable sending the username/password through email. IF Value is "No" directly get their username/password on login screen.'
		)
END

