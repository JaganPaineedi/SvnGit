------------------------------Document Codes
IF NOT EXISTS ( SELECT * FROM DocumentCodes WHERE DocumentCodeId = 1641
		)
BEGIN
	SET IDENTITY_INSERT dbo.documentcodes ON

	INSERT INTO documentcodes (
		DocumentCodeId
		,DocumentName
		,DocumentDescription
		,DocumentType
		,Active
		,ServiceNote
		,PatientConsent
		,OnlyAvailableOnline
		,ImageFormatType
		,DefaultImageFolderId
		,ViewDocumentURL
		,ViewDocumentRDL
		,StoredProcedure
		,TableList
		,RequiresSignature
		,ViewOnlyDocument
		,DocumentSchema
		,DocumentHTML
		,DocumentURL
		,ToBeInitialized
		,InitializationProcess
		,InitializationStoredProcedure
		,FormCollectionId
		,ValidationStoredProcedure
		,ViewStoredProcedure
		,MetadataFormId
		,TextTemplate
		,RequiresLicensedSignature
		,ReviewFormId
		,MedicationReconciliationDocument
		)
	VALUES (
		1641
		,'ADT'
		,'ADT'
		,10
		,'Y'
		,'N'
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLADTHospitalizations'
		,'RDLADTHospitalizations'
		,'ssp_RDLADTHospitalizations'
		,NULL
		,'Y'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ssp_RDLADTHospitalizations'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.documentcodes OFF
END

-----------------------Screens

IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = 1216 )
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
		1216
		,'ADT'
		,5762
		,'/Modules/ADTHospitalization/Office/ListPages/ADTHospitalizationList.ascx'
		,''
		,1
		,NULL
		,''
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'ADT'
		,ScreenType = 5762
		,ScreenURL = '/Modules/ADTHospitalization/Office/ListPages/ADTHospitalizationList.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 1
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
	WHERE ScreenId = 1216
END

IF NOT EXISTS ( SELECT * FROM screens WHERE ScreenId = 1217 )
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
		1217
		,'ADT'
		,5762
		,'/Modules/ADTHospitalization/Client/ListPages/ClientADTHospitalizationList.ascx'
		,''
		,2
		,NULL
		,''
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
		UPDATE Screens
		SET ScreenName = 'ADT'
			,ScreenType = 5762
			,ScreenURL = '/Modules/ADTHospitalization/Client/ListPages/ClientADTHospitalizationList.ascx'
			,ScreenToolbarURL = NULL
			,TabId = 2
			,DocumentCodeId = NULL
			,CustomFieldFormId = NULL
		WHERE ScreenId = 1217
END

IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = 1218 )
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
		1218
		,'ADT Detail'
		,5761
		,'/Modules/ADTHospitalization/Client/Detail/ClientADTHospitalizationDetailMain.ascx'
		,''
		,2
		,NULL
		,''
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'ADT'
		,ScreenType = 5761
		,ScreenURL = '/Modules/ADTHospitalization/Client/Detail/ClientADTHospitalizationDetailMain.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 2
		,DocumentCodeId = NULL
		,CustomFieldFormId = NULL
	WHERE ScreenId = 1218
END

IF NOT EXISTS ( SELECT * FROM screens WHERE ScreenId = 1227 )
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
		1227
		,'ADT'
		,5763
		,'/ActivityPages/Client/Detail/Documents/ViewDocument.ascx'
		,''
		,2
		,1641
		,''
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'ADT'
		,ScreenType = 5763
		,ScreenURL = '/ActivityPages/Client/Detail/Documents/ViewDocument.ascx'
		,ScreenToolbarURL = NULL
		,TabId = 2
		,DocumentCodeId = 1641
		,CustomFieldFormId = NULL
	WHERE ScreenId = 1227
END

-----------------Banners
IF NOT EXISTS ( SELECT * FROM banners WHERE screenid = 1216 )
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
	VALUES ('ADT'
		,'ADT'
		,'Y'
		,1
		,'N'
		,1
		,1216
		,NULL
		,NULL
		)

END
ELSE 
BEGIN
	UPDATE Banners SET BannerName = 'ADT', DisplayAs = 'ADT' WHERE screenid = 1216

END

IF NOT EXISTS ( SELECT * FROM banners WHERE screenid = 1217 )
BEGIN

	INSERT INTO banners ( BannerName
		,DisplayAs
		,Active
		,DefaultOrder
		,Custom
		,TabId
		,ScreenId
		,ScreenParameters
		,ParentBannerId
		)
	VALUES ( 'ADT'
		,'ADT'
		,'Y'
		,1
		,'N'
		,2
		,1217
		,NULL
		,NULL
		)
END
ELSE 
BEGIN
	UPDATE Banners SET BannerName = 'ADT', DisplayAs = 'ADT' WHERE screenid = 1217

END


