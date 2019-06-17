IF NOT EXISTS (SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='TwoFactorAuthenticationServiceURL')
BEGIN
	INSERT INTO SystemConfigurationKeys ([Key],Value,Description,ShowKeyForViewingAndEditing,Modules)
	VALUES ('TwoFactorAuthenticationServiceURL','https://scriptstaging.streamlinehealthcare.com/2FA/','TwoFactorAuthentication service URL','Y','TwoFactorAuthentication')
END

ELSE
BEGIN
	UPDATE SystemConfigurationKeys Set Value='https://scriptstaging.streamlinehealthcare.com/2FA/' WHERE [Key]='TwoFactorAuthenticationServiceURL'
END