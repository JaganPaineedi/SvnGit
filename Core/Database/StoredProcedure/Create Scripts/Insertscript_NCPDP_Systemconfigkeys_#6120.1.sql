--------------------------------------------------------------------------------
--Author : Anto
--Date   : 11/July/2018
--Purpose : Created Systemconfiguraationkeys for FromQualifier,TertiaryIdentificationSender,TertiaryIdentificationReceiver values (Request XML)
--Project : #6120.1 Comprehensive-Customizations
                     
---------------------------------------------------------------------------------

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'FromQualifierValue'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]				
		)
	VALUES (
		'FromQualifierValue'
		,'7uycso03'
		,'This key configuration helps in managing the From Qualifier Value in the Request XML'				
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'TertiaryIdentificationSenderValue'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]				
		)
	VALUES (
		'TertiaryIdentificationSenderValue'
		,'PH12345'
		,'This key configuration helps in managing the TertiaryIdentificationSender Value in the Request XML'				
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'TertiaryIdentificationReceiverValue'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]				
		)
	VALUES (
		'TertiaryIdentificationReceiverValue'
		,'WA-OHP'
		,'This key configuration helps in managing the TertiaryIdentificationReceiver Value in the Request XML'				
		)
END



IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'TestmessageValue'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]				
		)
	VALUES (
		'TestmessageValue'
		,'1'
		,'This key configuration helps in managing the TestmessageValue Value in the Request XML'				
		)
END


GO


