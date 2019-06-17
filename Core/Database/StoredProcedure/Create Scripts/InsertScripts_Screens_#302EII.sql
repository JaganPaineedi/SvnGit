IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1336
		)
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON

	INSERT INTO [Screens] (
		[ScreenId]
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,TabId
		)
	VALUES (
		1336
		,'Service Action Popup'
		,5765
		,'/Modules/Services/Office/WebPages/ServiceActionPopup.ascx'
		,1
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Service Action Popup'
		,ScreenType = 5765
		,ScreenURL = '/Modules/Services/Office/WebPages/ServiceActionPopup.ascx'
		,TabId = 1
	WHERE ScreenId = 1336
END

IF EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 357
		)
BEGIN
	UPDATE Screens
	SET ScreenToolbarURL = '/Modules/Services/Office/ScreenToolBars/ServicesToolBar.ascx'
	WHERE ScreenId = 357
END

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1337
		)
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON

	INSERT INTO [Screens] (
		[ScreenId]
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,TabId
		)
	VALUES (
		1337
		,'Bundled Services'
		,5761
		,'/Modules/Services/Office/WebPages/BundledServices.ascx'
		,1
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Bundled Services'
		,ScreenType = 5761
		,ScreenURL = '/Modules/Services/Office/WebPages/BundledServices.ascx'
		,TabId = 1
	WHERE ScreenId = 1337
END
