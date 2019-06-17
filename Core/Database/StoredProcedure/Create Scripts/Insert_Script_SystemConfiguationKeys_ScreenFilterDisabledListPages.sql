--Created By Vamsi     5/9/2016     Inserting new systemconfigurationkey 
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [key] = 'ScreenFilterDisabledListPages'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[key]
		,Value
		,Description
		)
	VALUES (
		'ScreenFilterDisabledListPages'
		,'368'
		,'Screen Ids of list pages(Saparated by '','') for which we don''t want to insert Filters'
		)
END
