IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1214
		)
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON

	INSERT INTO [Screens] (
		[ScreenId]
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,TabId
		,ScreenToolbarURL
		)
	VALUES (
		1214
		,'External Collections'
		,5762
		,'/Modules/Collections/Office/ListPages/ExternalCollections.ascx'
		,1,
		'/Modules/Collections/ScreenToolBars/ExternalCollectionsToolBar.ascx'
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'External Collections'
		,ScreenType = 5762
		,ScreenURL = '/Modules/Collections/Office/ListPages/ExternalCollections.ascx'
		,TabId = 1
		,ScreenToolbarURL='/Modules/Collections/ScreenToolBars/ExternalCollectionsToolBar.ascx'
	WHERE ScreenId = 1214
END

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1215
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
		1215
		,'External Collections Pop up'
		,5765
		,'/Modules/Collections/Office/ListPages/ExternalCollectionsPopup.ascx'
		,1
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'External Collections Pop up'
		,ScreenType = 5765
		,ScreenURL = '/Modules/Collections/Office/ListPages/ExternalCollectionsPopup.ascx'
		,TabId = 1
	WHERE ScreenId = 1215
END

IF NOT EXISTS (
		SELECT *
		FROM Banners
		WHERE ScreenId = 1214
		)
	INSERT INTO Banners (
		BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,TabId
		,Custom
		,ScreenId
		)
	VALUES (
		'External Collections'
		,'External Collections'
		,'Y'
		,1
		,1
		,'N'
		,1214
		)
