--System configuration key 'ADDSCREENIDTOSHOWFAVICONONTOOLBAR' for task #554 in Engineering Improvement Initiatives- NBL(I).

--To configure Show/Hide "Favorites" toolbar icon

IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ADDSCREENIDTOSHOWFAVICONONTOOLBAR'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,RecordDeleted
		,DeletedDate
		,DeletedBy
		,[Key]
		,Value
		,[Description]
		,AcceptedValues
		,AllowEdit
		,Modules
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'ADDSCREENIDTOSHOWFAVICONONTOOLBAR'
		,',29,207,'
		,'This key is used to show/hide the "Favorites" toolbar icon.'
		,'Details/Documents page ScreenIds with comma separated.'
		,'Y'
		,'Documents and Details page'
END
