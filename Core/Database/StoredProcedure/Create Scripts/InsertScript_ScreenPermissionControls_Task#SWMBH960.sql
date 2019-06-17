

-- Created insert script for delete icon.
-- Why : SWMBH - Support: #960

-- Service Detail on Client tab.
IF NOT EXISTS (
		SELECT 1
		FROM ScreenPermissionControls
		WHERE ControlName = 'imgDelete'
			AND Screenid = 333
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO ScreenPermissionControls (
		Screenid
		,ControlName
		,DisplayAs
		,Active
		)
	VALUES (
		333
		,'imgDelete'
		,'imgDelete'
		,'Y'
		)
END


