IF NOT EXISTS (
		SELECT 1
		FROM systemconfigurationkeys
		WHERE [Key] = 'SetCommonInterventionEndDateForAuthorizations'
		)
BEGIN
	INSERT INTO systemconfigurationkeys (
		[Key]
		,Value
		,AcceptedValues
		,[Description]
		,ShowKeyForViewingAndEditing
		,Modules
		,Screens
		)
	VALUES (
		'SetCommonInterventionEndDateForAuthorizations'
		,'Y'
		,'Y,NULL'
		,'This key is used to let the user apply the Intervention End Date to all authorizations'
		,'N'
		,'Authorizations'
		,'1007'
		)
END
ELSE
BEGIN
	UPDATE systemconfigurationkeys
	SET Value = 'Y'
		,AcceptedValues = 'Y,NULL'
		,[Description] = 'This key is used to let the user apply the Intervention End Date to all authorizations'
		,ShowKeyForViewingAndEditing = 'N'
		,Modules = 'Authorizations'
		,Screens = '1007'
	WHERE [Key] = 'SetCommonInterventionEndDateForAuthorizations';
END