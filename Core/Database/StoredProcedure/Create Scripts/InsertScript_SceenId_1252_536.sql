IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1252
		)
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		ScreenId
		,ScreenName
		,ScreenType
		,ScreenURL
		,ScreenToolbarURL
		,TabId
		,InitializationStoredProcedure
		,ValidationStoredProcedureUpdate
		,ValidationStoredProcedureComplete
		,WarningStoredProcedureComplete
		,PostUpdateStoredProcedure
		,RefreshPermissionsAfterUpdate
		,DocumentCodeId
		,CustomFieldFormId
		,HelpURL
		,MessageReferenceType
		,PrimaryKeyName
		,WarningStoreProcedureUpdate
		)
	VALUES (
		1252
		,'Action Template'
		,5761
		,'/Modules/ActionTemplate/Admin/Detail/PreferredActions.ascx'
		,NULL
		,4
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET ScreenName = 'Action Template'
		,ScreenType = 5761
		,ScreenURL = '/Modules/ActionTemplate/Admin/Detail/PreferredActions.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 4
		,InitializationStoredProcedure = NULL
		,ValidationStoredProcedureUpdate = NULL
		,ValidationStoredProcedureComplete = NULL
		,WarningStoredProcedureComplete = NULL
		,PostUpdateStoredProcedure = NULL
		,RefreshPermissionsAfterUpdate = NULL
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
		,HelpURL = NULL
		,MessageReferenceType = NULL
		,PrimaryKeyName = NULL
		,WarningStoreProcedureUpdate = NULL
	WHERE ScreenId = 1252
END


---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 1252
				)
			)
		)
BEGIN
	INSERT INTO [Banners] (
		[BannerName]
		,[DisplayAs]
		,[Active]
		,[DefaultOrder]
		,[Custom]
		,[TabId]
		,[ScreenId]		
		)
	VALUES (
		'Action Template'
		,'Action Template'
		,'Y'
		,1
		,'N'
		,'4'
		,1252
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'Action Template'
		,DisplayAs = 'Action Template'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '4'
	WHERE ScreenId = 1252
END