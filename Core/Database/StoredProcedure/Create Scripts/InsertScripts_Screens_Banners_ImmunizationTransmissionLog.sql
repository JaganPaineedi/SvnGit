-----------------------Screens

IF NOT EXISTS ( SELECT * FROM screens WHERE ScreenId = 1229 )
BEGIN
	SET IDENTITY_INSERT dbo.Screens ON

	INSERT INTO screens (
		screenid
		,ScreenName
		,ScreenType
		,screenurl
		,ScreenToolbarURL
		,TabId
		,DocumentCodeId
		,HelpURL
		)
	VALUES (
		1229
		,'Immunization Transmission Log'
		,5762
		,'/Modules/ImmunizationTransmissionLog/Client/ListPages/ImmunizationTransmissionLogList.ascx'
		,'/Modules/ImmunizationTransmissionLog/Client/ScreenToolBars/ImmunizationTransmissionLogToolBar.ascx'
		,2
		,NULL
		,''
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
		UPDATE Screens
		SET ScreenName = 'Immunization Transmission Log'
			,ScreenType = 5762
			,ScreenURL = '/Modules/ImmunizationTransmissionLog/Client/ListPages/ImmunizationTransmissionLogList.ascx'
			,ScreenToolbarURL = '/Modules/ImmunizationTransmissionLog/Client/ScreenToolBars/ImmunizationTransmissionLogToolBar.ascx'
			,TabId = 2
			,DocumentCodeId = NULL
			,CustomFieldFormId = NULL
		WHERE ScreenId = 1229
END

-----------------Banners
IF NOT EXISTS ( SELECT * FROM banners WHERE screenid = 1229 )
BEGIN
	INSERT INTO banners (BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ScreenId
		,ScreenParameters
		,ParentBannerId
		)
	VALUES ('Immunization Transmission Log'
		,'Immunization Transmission Log'
		,'Y'
		,1
		,'N'
		,2
		,1229
		,NULL
		,NULL
		)

END