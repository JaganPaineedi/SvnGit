IF NOT EXISTS (
		SELECT 1
		FROM ScreenPermissionControls
		WHERE ScreenId = 29
			AND ControlName = 'CheckBox_Services_NoteReplacement'
		)
BEGIN
	INSERT INTO [ScreenPermissionControls] (
		[ScreenId]
		,[ControlName]
		,[DisplayAs]
		,[Active]
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		)
	VALUES (
		29
		,'CheckBox_Services_NoteReplacement'
		,'CheckBox_Services_NoteReplacement'
		,'Y'
		,'EII 589.1'
		,GETDATE()
		,'EII 589.1'
		,GETDATE()
		)
END

IF NOT EXISTS (
		SELECT 1
		FROM ScreenPermissionControls
		WHERE ScreenId = 207
			AND ControlName = 'CheckBox_Services_NoteReplacement'
		)
BEGIN
	INSERT INTO [ScreenPermissionControls] (
		[ScreenId]
		,[ControlName]
		,[DisplayAs]
		,[Active]
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		)
	VALUES (
		207
		,'CheckBox_Services_NoteReplacement'
		,'CheckBox_Services_NoteReplacement'
		,'Y'
		,'EII 589.1'
		,GETDATE()
		,'EII 589.1'
		,GETDATE()
		)
END