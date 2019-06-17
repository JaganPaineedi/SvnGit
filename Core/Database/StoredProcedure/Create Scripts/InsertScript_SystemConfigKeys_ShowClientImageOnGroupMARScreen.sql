-- SysetmConfigurationKeys 'ShowClientImageOnGroupMARScreen' .
-- AHN - Support Go Live #511
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'ShowClientImageOnGroupMARScreen'
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
		,AcceptedValues
		,[Description]
		,AllowEdit
		,Modules
		,Screens
		)
	SELECT suser_sname()
		,GETDATE()
		,suser_sname()
		,GETDATE()
		,NULL
		,NULL
		,NULL
		,'ShowClientImageOnGroupMARScreen'
		,'Yes'
		,'Yes, No'
		,'Reads as --- "Show Client Image On Group MAR Screen"
		  When the value of the key ''ShowClientImageOnGroupMARScreen'' is set to "Yes", the system will show the client image on Group MAR Screen.
		  This is the current behavior. When the value of the key ''ShowClientImageOnGroupMARScreen'' is set to "No”, the system will not show the
		  client image on Group MAR Screen.'
		,'Y'
		,'Group MAR'
		,NULL
END
