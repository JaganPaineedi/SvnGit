 ------------------------------------------------------------
 --Author :Varun
 --Date   :06/03/2015
 --Purpose:Screen and Banner for Group MAR.
 ------------------------------------------------------------
IF NOT EXISTS (
		SELECT *
		FROM [Screens]
		WHERE [ScreenId] = 1133
		)
BEGIN
	SET IDENTITY_INSERT [Screens] ON

	INSERT INTO [Screens] (
		[ScreenId]
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[ScreenToolbarURL]
		,[TabId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureUpdate]
		,[ValidationStoredProcedureComplete]
		,[WarningStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		,[RefreshPermissionsAfterUpdate]
		,[DocumentCodeId]
		,[CustomFieldFormId]
		,[HelpURL]
		,[MessageReferenceType]
		,[PrimaryKeyName]
		,[WarningStoreProcedureUpdate]
		,[KeyPhraseCategory]
		,[ScreenParamters]
		)
	VALUES (
		1133
		,'Group MAR'
		,5762
		,'/MAR/Office/ListPages/MAR.ascx'
		,NULL
		,1
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
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT [Screens] OFF
END

IF NOT EXISTS (
		SELECT *
		FROM [Screens]
		WHERE [ScreenId] = 1177
		)
BEGIN
	SET IDENTITY_INSERT [Screens] ON

	INSERT INTO [Screens] (
		[ScreenId]
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[ScreenToolbarURL]
		,[TabId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureUpdate]
		,[ValidationStoredProcedureComplete]
		,[WarningStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		,[RefreshPermissionsAfterUpdate]
		,[DocumentCodeId]
		,[CustomFieldFormId]
		,[HelpURL]
		,[MessageReferenceType]
		,[PrimaryKeyName]
		,[WarningStoreProcedureUpdate]
		,[KeyPhraseCategory]
		,[ScreenParamters]
		)
	VALUES (
		1177
		,'Give All'
		,5765
		,'/MAR/Office/Custom/GiveAllPopup.ascx'
		,NULL
		,1
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
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT [Screens] OFF
END

IF NOT EXISTS (
		SELECT *
		FROM banners
		WHERE ScreenId = 1133
			AND BannerName = 'Group MAR'
		)
BEGIN
	INSERT INTO banners (
		BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ScreenId
		,ScreenParameters
		,ParentBannerId
		)
	VALUES (
		'Group MAR'
		,'Group MAR'
		,'Y'
		,1
		,'N'
		,1
		,1133
		,NULL
		,NULL
		)
END
 

 
 
 
 

 
 