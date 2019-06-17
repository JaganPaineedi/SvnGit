-------------------------------------------------
--Author : Alok Kumar
--Date   : 02/11/2016
--Purpose: To Insert Screen entry, Banner entry for task#601 SWMBH - Support
-------------------------------------------------


-- Provider Documents Screen Entry

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 8788
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
		8788
		,'Provider Documents'
		,5762
		,'/ActivityPages/Office/ListPages/ImageRecordsList.ascx'
		,NULL
		,6
		,NULL
		,'/ScreenToolBars/ImageRecordsListPageToolBar.ascx'
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END



-- Upload File Detail Screen Entry

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 8789
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
		8789
		,'Upload File Detail'
		,5765
		,'/ActivityPages/Office/Custom/UploadMedicalRecordDetail.ascx'
		,NULL
		,6
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END


-- Scanned Medical Record Detail Screen Entry

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 8790
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
		8790
		,'Scanned Medical Record Detail'
		,5765
		,'/ActivityPages/Office/Custom/ScannedImageMedicalRecordDetail.ascx'
		,NULL
		,6
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END


-- View Images Screen Entry

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = 8791
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
		8791
		,'View Images'
		,5765
		,'/ActivityPages/Office/Custom/ViewImageRecords.ascx'
		,NULL
		,6
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END

-- Provider Documents Banner Entry

IF NOT EXISTS (
		SELECT BannerId
		FROM Banners
		WHERE BannerId = 1397
		)
BEGIN
	SET IDENTITY_INSERT Banners ON

	INSERT INTO Banners (
		BannerId
		,BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ScreenId
		)
	VALUES (
		1397
		,'Provider Documents'
		,'Provider Documents'
		,'Y'
		,1
		,'N'
		,6
		,8788
		)

	SET IDENTITY_INSERT Banners OFF
END
