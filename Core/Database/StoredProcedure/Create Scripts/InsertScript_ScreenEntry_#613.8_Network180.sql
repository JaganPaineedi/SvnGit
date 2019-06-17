-------------------------------------------------
--Author : Lakshmi kanth
--Date   : 25/03/2016
--Purpose: To Insert Screen entry,  for task#613.8 Network 180
-------------------------------------------------

-- Disclosure Screen Entry

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 1192
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
		1192
		,'DisclosuresTo'
		,5761
		,'/ActivityPages/Client/Detail/DisclosureToPopup.ascx'
		,NULL
		,2
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END