IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1188
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
		,DocumentCodeId
		,HelpURL
		)
	VALUES (
		1188
		,'LabSoft Message Interface Detail'
		,5761
		,'/Modules/LabSoftMessageInterface/ActivityPages/Admin/Detail/LabSoftMessageInterfaceDetail.ascx'
		,'/Modules/LabSoftMessageInterface/ScreenToolBars/LabSoftMessageInterface.ascx'
		,4
		,NULL
		,''
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'LabSoft Message Interface Detail'
		,ScreenType = 5761
		,ScreenURL = '/Modules/LabSoftMessageInterface/ActivityPages/Admin/Detail/LabSoftMessageInterfaceDetail.ascx'
		,ScreenToolbarURL = '/Modules/LabSoftMessageInterface/ScreenToolBars/LabSoftMessageInterface.ascx'
		,TabId = 4
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
	WHERE ScreenId = 1188
END

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1187
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO screens (
		screenid
		,ScreenName
		,ScreenType
		,screenurl
		,ScreenToolbarURL
		,TabId
		,InitializationStoredProcedure
		,ValidationStoredProcedureComplete
		,PostUpdateStoredProcedure
		,DocumentCodeId
		)
	VALUES (
		1187
		,'Labsoft Messages Interface'
		,5762
		,'/Modules/LabSoftMessageInterface/ActivityPages/Admin/ListPages/LabSoftMessagesInterface.ascx'
		,NULL
		,4
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END

IF NOT EXISTS (
		SELECT *
		FROM banners
		WHERE BannerName = 'LabSoft Messages Interface'
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
		)
	VALUES (
		'LabSoft Messages Interface'
		,'LabSoft Messages Interface'
		,'Y'
		,521
		,'N'
		,4
		,1187
		,NULL
		)
END
