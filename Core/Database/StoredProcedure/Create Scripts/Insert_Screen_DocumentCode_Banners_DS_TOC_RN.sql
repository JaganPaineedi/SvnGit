IF NOT EXISTS (
		SELECT *
		FROM DocumentCodes
		WHERE DocumentCodeId = 1644
		)
BEGIN
	SET IDENTITY_INSERT dbo.documentcodes ON

	INSERT INTO documentcodes (
		DocumentCodeId
		,CreatedBy
		,ModifiedBy
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
		1644
		,'sa'
		,'sa'
		,'Transition Of Care'
		,'Transition Of Care'
		,10
		,'Y'
		,'N'
		,NULL
		,'N'
		,NULL
		,NULL
		,'TransitionCareSummaryMain'
		,'TransitionCareSummaryMain'
		,'ssp_SCGetDocumentTransitionOfCare'
		,'TransitionOfCareDocuments'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ssp_InitTransitionOfCareDocuments'
		,NULL
		,NULL
		,'ssp_RDLTransitionCareSummaryMain'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.documentcodes OFF
END


IF NOT EXISTS (
		SELECT *
		FROM DocumentCodes
		WHERE DocumentCodeId = 1645
		)
BEGIN
	SET IDENTITY_INSERT dbo.documentcodes ON

	INSERT INTO documentcodes (
		DocumentCodeId
		,CreatedBy
		,ModifiedBy
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
		1645
		,'sa'
		,'sa'
		,'Discharge Summary'
		,'Discharge Summary'
		,10
		,'Y'
		,'N'
		,NULL
		,'N'
		,NULL
		,NULL
		,'TransitionCareSummaryMain'
		,'TransitionCareSummaryMain'
		,'ssp_SCGetDocumentTransitionOfCare'
		,'TransitionOfCareDocuments'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ssp_InitTransitionOfCareDocuments'
		,NULL
		,NULL
		,'ssp_RDLTransitionCareSummaryMain'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.documentcodes OFF
END

IF NOT EXISTS (
		SELECT *
		FROM DocumentCodes
		WHERE DocumentCodeId = 1646
		)
BEGIN
	SET IDENTITY_INSERT dbo.documentcodes ON

	INSERT INTO documentcodes (
		DocumentCodeId
		,CreatedBy
		,ModifiedBy
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
		1646
		,'sa'
		,'sa'
		,'Referral Note'
		,'Referral Note'
		,10
		,'Y'
		,'N'
		,NULL
		,'N'
		,NULL
		,NULL
		,'TransitionCareSummaryMain'
		,'TransitionCareSummaryMain'
		,'ssp_SCGetDocumentTransitionOfCare'
		,'TransitionOfCareDocuments'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ssp_InitTransitionOfCareDocuments'
		,NULL
		,NULL
		,'ssp_RDLTransitionCareSummaryMain'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)

	SET IDENTITY_INSERT dbo.documentcodes OFF
END

-- SCREENS

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1293
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
		,InitializationStoredProcedure
		,DocumentCodeId
		)
	VALUES (
		1293
		,'Transition Of Care'
		,5763
		,'/CommonUserControls/DFASingleTabDocuments.ascx'
		,''
		,2
		,'ssp_InitTransitionOfCareDocuments'
		,1644
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1294
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
		,InitializationStoredProcedure
		,DocumentCodeId
		)
	VALUES (
		1294
		,'Discharge Summary'
		,5763
		,'/CommonUserControls/DFASingleTabDocuments.ascx'
		,''
		,2
		,'ssp_InitTransitionOfCareDocuments'
		,1645
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END

IF NOT EXISTS (
		SELECT *
		FROM screens
		WHERE ScreenId = 1295
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
		,InitializationStoredProcedure
		,DocumentCodeId
		)
	VALUES (
		1295
		,'Referral Note'
		,5763
		,'/CommonUserControls/DFASingleTabDocuments.ascx'
		,''
		,2
		,'ssp_InitTransitionOfCareDocuments'
		,1646
		)

	SET IDENTITY_INSERT dbo.Screens OFF
END

-- BANNERS
IF NOT EXISTS (
		SELECT *
		FROM banners
		WHERE screenid = 1293
			AND BannerName = 'Transition Of Care'
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
		'Transition Of Care'
		,'Transition Of Care'
		,'Y'
		,2
		,'N'
		,2
		,1293
		,NULL
		,21
		)
END

IF NOT EXISTS (
		SELECT *
		FROM banners
		WHERE screenid = 1294
			AND BannerName = 'Discharge Summary'
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
		'Discharge Summary'
		,'Discharge Summary'
		,'Y'
		,2
		,'N'
		,2
		,1294
		,NULL
		,21
		)
END

IF NOT EXISTS (
		SELECT *
		FROM banners
		WHERE screenid =1295
			AND BannerName = 'Referral Note'
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
		'Referral Note'
		,'Referral Note'
		,'Y'
		,2
		,'N'
		,2
		,1295
		,NULL
		,21
		)
END



