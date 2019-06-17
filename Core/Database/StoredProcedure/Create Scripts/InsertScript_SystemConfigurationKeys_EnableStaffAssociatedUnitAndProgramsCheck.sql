--ListDataBasedOnStaffsAccessToProgramsAndUnits
-- Bradford - Enhancements #400.2
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [Key] = 'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]
		)
	VALUES (
		'FilterDataBasedOnStaffAssociatedToProgramsAndUnits'
		,'No'
		,'This key configuration is used to show the data based on Staff''s associated Programs and Units. This logic will be used in "Bed Board/Whiteboard/Bed Census/Bed Assignment Detail/Bed Search/Program Assignment List Page/Program Assignment Detail"
		  Yes - System will only display the result based on the programs and Units associated to the Staff. 
		  No -   System will display all the records based on the existing implementation.'
		)
END
