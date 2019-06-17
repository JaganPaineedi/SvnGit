---------------------------DocumentCodes-----------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE DocumentCodeId = 1653
				)
			)
		)
BEGIN
	SET IDENTITY_INSERT [dbo].[DocumentCodes] ON

	INSERT INTO [DocumentCodes] (
		[DocumentCodeId]
		,[DocumentName]
		,[DocumentDescription]
		,[DocumentType]
		,[Active]
		,[ServiceNote]
		,[PatientConsent]
		,[ViewDocument]
		,[OnlyAvailableOnline]
		,[ImageFormatType]
		,[DefaultImageFolderId]
		,[ViewDocumentURL]
		,[ViewDocumentRDL]
		,[StoredProcedure]
		,[TableList]
		,[RequiresSignature]
		,[ViewOnlyDocument]
		,[DocumentSchema]
		,[DocumentHTML]
		,[DocumentURL]
		,[ToBeInitialized]
		,[InitializationProcess]
		,[InitializationStoredProcedure]
		,[FormCollectionId]
		,[ValidationStoredProcedure]
		,[ViewStoredProcedure]
		,[RequiresLicensedSignature]
		,[DefaultCoSigner]
		,[DefaultGuardian]
		,[RegenerateRDLOnCoSignature]
		,[RecreatePDFOnClientSignature]
		,[NewValidationStoredProcedure] 
		,[ClientOrder]
		)
	VALUES (
		1653
		,'Quick Orders'
		,'Quick Orders'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLClientOrders'
		,'RDLClientOrders'
		,'ssp_SCGetQuickOrders'
		,'ClientOrders,ClientOrdersDiagnosisIIICodes,ClientOrderQnAnswers'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'ssp_validateQuickOrders'
		,NULL
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,NULL
		,'Y'
		)

	SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF
END
ELSE
BEGIN
	UPDATE DocumentCodes
	SET DocumentName = 'Quick Orders'
		,DocumentDescription = 'Quick Orders'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLClientOrders'
		,ViewDocumentRDL = 'RDLClientOrders'
		,StoredProcedure = 'ssp_SCGetQuickOrders'
		,TableList = 'ClientOrders,ClientOrdersDiagnosisIIICodes,ClientOrderQnAnswers'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = NULL
		,ValidationStoredProcedure = 'ssp_validateQuickOrders'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'
		,NewValidationStoredProcedure = NULL
		,ClientOrder = 'Y'
	WHERE DocumentCodeId = 1653
END
GO

---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE screenId = 1333
				)
			)
		)
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON

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
		,[PostUpdateStoredProcedure]
		,[RefreshPermissionsAfterUpdate]
		,[DocumentCodeId]
		,[CustomFieldFormId]
		)
	VALUES (
		1333
		,'Quick Orders'
		,5763
		,'/Modules/ClientOrderControl/WebPages/QuickOrders.ascx'
		,NULL
		,2
		,NULL
		,NULL
		,'ssp_validateQuickOrders'
		,NULL
		,NULL
		,1653
		,NULL
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Quick Orders'
		,ScreenType = 5763
		,ScreenURL = '/Modules/ClientOrderControl/WebPages/QuickOrders.ascx'
		,TabId = 2
		,InitializationStoredProcedure = NULL
		,ValidationStoredProcedureComplete = 'ssp_validateQuickOrders'
		,PostUpdateStoredProcedure = NULL
		,DocumentCodeId = 1653
	WHERE ScreenId = 1333
END
GO

---------------------------End----------------------------------------------------------------------


---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 1333
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
		,[ParentBannerId]
		)
	VALUES (
		'Quick Orders'
		,'Quick Orders'
		,'Y'
		,1
		,'N'
		,'2'
		,1333
		,(SELECT TOP 1 BannerId FROM Banners WHERE BannerName = 'Documents' AND ISNULL(Active,'N') = 'Y' AND ISNULL(RecordDeleted,'N') = 'N')
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'Quick Orders'
		,DisplayAs = 'Quick Orders'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = (SELECT TOP 1 BannerId FROM Banners WHERE BannerName = 'Documents' AND ISNULL(Active,'N') = 'Y' AND ISNULL(RecordDeleted,'N') = 'N')
	WHERE ScreenId = 1333
END
GO

---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = 1333
				)
			)
		)
BEGIN
	INSERT INTO [DocumentNavigations] (
		[NavigationName]
		,[DisplayAs]
		,[Active]
		,[ParentDocumentNavigationId]
		,[BannerId]
		,[ScreenId]
		,[CreatedBy]
		,[CreatedDate]
		,[ModifiedBy]
		,[ModifiedDate]
		)
	VALUES (
		'Quick Orders'
		,'Quick Orders'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = 1333)
		,1333
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'Quick Orders'
		,[DisplayAs] = 'Quick Orders'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 1333)
		,[ScreenId] = 1333
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = 1333
END
---------------------------End----------------------------------------------------------------------