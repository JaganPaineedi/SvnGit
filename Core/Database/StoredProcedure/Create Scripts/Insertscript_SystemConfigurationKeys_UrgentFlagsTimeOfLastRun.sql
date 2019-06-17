IF NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [Key]='UrgentFlagsTimeOfLastRun')
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,[Value]
		,[Description]
		,[Modules]
		,[Screens]
		,[Comments]
		)
	VALUES (
		'UrgentFlagsTimeOfLastRun'
		,NULL
		,'This is used to track the last time the ProviderAuthorizationFlags job was run'
		,'IndividualServiceNote'
		,NULL
		,'This key is updated every time the ssp_UpdateCMAuthorizationFlags is ran. If this key doesn''t exist, or has a null value then the job runs against the entire ProviderAuthorizations table.'
		)
END