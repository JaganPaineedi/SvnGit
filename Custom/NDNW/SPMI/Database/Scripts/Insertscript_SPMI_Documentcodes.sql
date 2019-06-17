---------------------------DocumentCodes-----------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE DocumentCodeId = 46226
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
		46226
		,'SPMI'
		,'SPMI'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLCustomSPMI'
		,'RDLCustomSPMI'
		,'csp_SCGetCustomSPMI'
		,'CustomDocumentSPMIs'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'csp_InitCustomSPMI'
		,NULL
		,NULL
		,'csp_validateCustomSPMI'
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
	SET DocumentName = 'SPMI'
		,DocumentDescription = 'SPMI'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLCustomSPMI'
		,ViewDocumentRDL = 'RDLCustomSPMI'
		,StoredProcedure = 'csp_SCGetCustomSPMI'
		,TableList = 'CustomDocumentSPMIs'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = 'csp_InitCustomSPMI'
		,ValidationStoredProcedure = 'csp_validateCustomSPMI'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'		
	WHERE DocumentCodeId = 46226
END
GO

---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE screenId = 46226
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
		46226
		,'SPMI'
		,5763
		,'/Custom/SPMI/WebPages/SPMI.ascx'
		,NULL
		,2
		,'csp_InitCustomSPMI'
		,NULL
		,'csp_validateCustomSPMI'
		,NULL
		,NULL
		,46226
		,NULL
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'SPMI'
		,ScreenType = 5763
		,ScreenURL = '/Custom/SPMI/WebPages/SPMI.ascx'
		,TabId = 2
		,InitializationStoredProcedure = 'csp_InitCustomSPMI'
		,ValidationStoredProcedureComplete = 'csp_validateCustomSPMI'
		,PostUpdateStoredProcedure = NULL
		,DocumentCodeId = 46226
	WHERE ScreenId = 46226
END
GO

---------------------------End----------------------------------------------------------------------
---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 46226
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
		'SPMI'
		,'SPMI'
		,'Y'
		,1
		,'N'
		,'2'
		,46226
		,21
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'SPMI'
		,DisplayAs = 'SPMI'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = 21
	WHERE ScreenId = 46226
END
GO

---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = 46226
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
		'SPMI'
		,'SPMI'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46226)
		,46226
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'SPMI'
		,[DisplayAs] = 'SPMI'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46226)
		,[ScreenId] = 46226
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = 46226
END
---------------------------End----------------------------------------------------------------------
