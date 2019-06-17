IF NOT EXISTS (
		SELECT [key]
		FROM SystemConfigurationKeys
		WHERE [key] = 'RemoveUnchangedTablesFromAutoSaveXML'
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
		,AcceptedValues
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'RemoveUnchangedTablesFromAutoSaveXML'
		,'N'
		,'This key is used to determine whether we need to remove unchanged table nodes from AutoSaveXML before save/autosave'
		,'Y,N'
		)
END
