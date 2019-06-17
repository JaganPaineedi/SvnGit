---------------------------DocumentCodes-----------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE DocumentCodeId = 40034
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
		)
	VALUES (
		40034
		,'ASAM'
		,'ASAM'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLCustomASAMs'
		,'RDLCustomASAMs'
		,'csp_SCGetCustomASAMs'
		,'CustomDocumentASAMs'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'csp_InitCustomASAMs'
		,NULL
		,NULL
		,'csp_validateCustomASAMs'
		,NULL
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		)

	SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF
END
ELSE
BEGIN
	UPDATE DocumentCodes
	SET DocumentName = 'ASAM'
		,DocumentDescription = 'ASAM'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLCustomASAMs'
		,ViewDocumentRDL = 'RDLCustomASAMs'
		,StoredProcedure = 'csp_SCGetCustomASAMs'
		,TableList = 'CustomDocumentASAMs'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = 'csp_InitCustomASAMs'
		,ValidationStoredProcedure = 'csp_validateCustomASAMs'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'
	WHERE DocumentCodeId = 40034
END
GO

---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE screenId = 40034
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
		40034
		,'ASAM'
		,5763
		,'/Custom/ASAM/WebPages/ASAM.ascx'
		,NULL
		,2
		,'csp_InitCustomASAMs'
		,NULL
		,'csp_validateCustomASAMs'
		,NULL
		,NULL
		,40034
		,NULL
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'ASAM'
		,ScreenType = 5763
		,ScreenURL = '/Custom/ASAM/WebPages/ASAM.ascx'
		,TabId = 2
		,InitializationStoredProcedure = 'csp_InitCustomASAMs'
		,ValidationStoredProcedureComplete = 'csp_validateCustomASAMs'
		,PostUpdateStoredProcedure = NULL
		,DocumentCodeId = 40034
	WHERE ScreenId = 40034
END
GO

---------------------------End----------------------------------------------------------------------
---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 40034
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
		'ASAM'
		,'ASAM'
		,'Y'
		,1
		,'N'
		,'2'
		,40034
		,21
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'ASAM'
		,DisplayAs = 'ASAM'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = 21
	WHERE ScreenId = 40034
END
GO

---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = 40034
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
		'ASAM'
		,'ASAM'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = 40034)
		,40034
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'ASAM'
		,[DisplayAs] = 'ASAM'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 40034)
		,[ScreenId] = 40034
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = 40034
END
---------------------------End----------------------------------------------------------------------
