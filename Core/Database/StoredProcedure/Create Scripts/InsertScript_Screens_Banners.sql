IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1211
		)
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		screenid
		,ScreenName
		,ScreenType
		,screenurl
		,ScreenToolbarURL
		,TabId
		)
	VALUES (
		1211
		,'Group Service Entry'
		,5761
		,'/Modules/GroupServiceEntry/WebPages/GroupServiceEntry.ascx'
		,''
		,1
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
IF NOT EXISTS (
		SELECT *
		FROM banners
		WHERE screenid = 1211
			AND BannerName = 'Group Service Entry'
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
		'Group Service Entry'
		,'Group Service Entry'
		,'Y'
		,1
		,'N'
		,1
		,1211
		,NULL
		,NULL
		)
END