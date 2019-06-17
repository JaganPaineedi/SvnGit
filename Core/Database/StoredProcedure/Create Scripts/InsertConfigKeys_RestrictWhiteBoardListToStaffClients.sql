-- Insert script for SystemConfigurationKeys RestrictWhiteBoardListToStaffClients   (Engineering Improvement Initiatives- NBL(I) : #77)

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'RestrictWhiteBoardListToStaffClients'
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
		,Screens
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'RestrictWhiteBoardListToStaffClients'
		,'No'
		,'Yes/No'
		,'Read Key as -- Restrict White Board List To Staff Clients.
		When the key value  is set as “Yes”,  the whiteboard list page will restrict / allow staff to only view those clients to whom they have access to. When the Value is set as “No”, the whiteboard list page will display the clients regardless of the Staff Client access.'
		,'Y'
		,'Whiteboard'
		,'Whiteboard'
		)
END

