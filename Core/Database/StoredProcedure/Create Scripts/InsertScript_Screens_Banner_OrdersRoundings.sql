-------------------------------------------------
--Author : Seema Thakur
--Date   : 10th Feb 2016
--Purpose: To Insert Screen entry, Banner entry for task#316 Philhaven Development
-------------------------------------------------

/*Screens Entry*/
IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1182
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO Screens (
		ScreenId
		,ScreenName
		,ScreenType
		,ScreenURL
		,DocumentCodeId
		,TabId
		,InitializationStoredProcedure
		,ScreenToolbarUrl
		,HelpURL
		)
	VALUES (
		1182
		,'Orders/Rounding'
		,5762
		,'/Orders/Office/ListPages/OrdersRoundingList.ascx'
		,NULL
		,1
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END

/*Banners Entry*/
IF NOT EXISTS (
		SELECT BannerId
		FROM Banners
		WHERE ScreenId = 1182
		)
BEGIN

	INSERT INTO Banners (
		BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ScreenId
		)
	VALUES (
		'Orders/Rounding'
		,'Orders/Rounding'
		,'Y'
		,1
		,'N'
		,1
		,1182
		)

END
