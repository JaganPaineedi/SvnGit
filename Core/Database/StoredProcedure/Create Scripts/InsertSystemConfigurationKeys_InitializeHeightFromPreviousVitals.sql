-- Insert script for SystemConfigurationKeys InitializeHeightFromPreviousVitals   task #1120 -Valley - Enhancements
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'InitializeHeightFromPreviousVitals'
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
		,'InitializeHeightFromPreviousVitals'
		,'No'
		,'Yes,No'
		,'IF Yes This key will pull(Initialize) the height field in a new med note from the previous med note (if available) and pre-populate this field.'
		,'Y'
		,'MedicalNote'
		,'Flow-Sheet'
		)
END


