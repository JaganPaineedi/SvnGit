-- A Renewed Mind - Support Task #776

IF NOT EXISTS (
		SELECT *
		FROM DocumentNavigations
		WHERE NavigationName = 'Diagnostic Assessment'
			AND BannerId = 268
			AND ScreenId = 10665
		)
BEGIN
	INSERT INTO DocumentNavigations (
		NavigationName
		,DisplayAs
		,Active
		,ParentDocumentNavigationId
		,BannerId
		,ScreenId
		)
	VALUES (
		'Diagnostic Assessment'
		,'Diagnostic Assessment'
		,'Y'
		,NULL
		,268
		,10665
		)
END
ELSE
	UPDATE DocumentNavigations
	SET Active = 'Y'
		,DisplayAs = 'Diagnostic Assessment'
	WHERE NavigationName = 'Diagnostic Assessment'
		AND BannerId = 268
		AND ScreenId = 10665
GO

