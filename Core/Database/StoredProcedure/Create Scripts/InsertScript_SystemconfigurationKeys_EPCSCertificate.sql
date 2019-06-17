IF NOT EXISTS (
		SELECT [key]
		FROM SystemConfigurationKeys
		WHERE [key] = 'EPCSDigitalCertificate'
		)
BEGIN
	INSERT INTO [dbo].[SystemConfigurationKeys] (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,Description
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'EPCSDigitalCertificate'
		,'cn=rxhub.smartcarenet.com'
		,'Provide the Subject of the Certificate in value field Eg:cn=rxhub.smartcarenet.com'
		)
END
ELSE
BEGIN
	UPDATE SystemConfigurationKeys
	SET value = 'cn=rxhub.smartcarenet.com'
		,Description = 'Provide the Subject of the Certificate in value field Eg:cn=rxhub.smartcarenet.com'
	WHERE [key] = 'EPCSDigitalCertificate'
END