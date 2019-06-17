IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1265
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
		1265
		,'Manage Roles & Modules'
		,5761
		,'/Modules/ModularRoleDefinition/Admin/Detail/ModularDefinitions.ascx'
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
	SET ScreenName = 'Manage Roles & Modules'
		,ScreenType = 5761
		,ScreenURL = '/Modules/ModularRoleDefinition/Admin/Detail/ModularDefinitions.ascx'
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
	WHERE ScreenId = 1265
END


---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 1265
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
		'Manage Roles & Modules'
		,'Manage Roles & Modules'
		,'Y'
		,1
		,'N'
		,'4'
		,1265
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'Manage Roles & Modules'
		,DisplayAs = 'Manage Roles & Modules'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '4'
	WHERE ScreenId = 1265
END