-- Insert script for SystemConfigurationKeys SHOWREASONFORNEWVERSIONRDL, task #1160in Renaissance - Dev Items.
IF NOT EXISTS (			
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'SHOWREASONFORNEWVERSIONRDL'
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
		,ShowKeyForViewingAndEditing
		,Modules
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'SHOWREASONFORNEWVERSIONRDL'
		,'Y'
		,'Y,N'
		,'This key is used to show/hide the "Reason for new version" RDL in Documents and Service Note signature RDL'
		,'Y'
		,'Documents and Service Note signature RDL.'
		,NULL
		)
END


