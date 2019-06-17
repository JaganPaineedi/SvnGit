IF NOT EXISTS (
		SELECT *
		FROM dbo.Screens
		WHERE ScreenId = 22309
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO [Screens] (
		ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		)
	VALUES (
		22309
		,'Scale'
		,5765
		,'Custom/DLA-20/WebPages/DLAScalePopup.ascx'
		,2
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET [ScreenName] = 'Scale'
		,[ScreenType] = 5765
		,[ScreenURL] = 'Custom/DLA-20/WebPages/DLAScalePopup.ascx'
		,[TabId] = 2
		,[DocumentCodeId] = NULL
	WHERE ScreenId = 22309
END
