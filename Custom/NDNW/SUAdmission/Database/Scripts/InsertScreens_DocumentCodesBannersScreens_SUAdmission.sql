---------------------------DocumentCodes-----------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE DocumentCodeId = 46222
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
		46222
		,'SUAdmission'
		,'SUAdmission'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLCustomDocumentSUAdmissions'
		,'RDLCustomDocumentSUAdmissions'
		,'csp_SCGetCustomDocumentSUAdmissions'
		,'CustomDocumentSUAdmissions,CustomDocumentInfectiousDiseaseRiskAssessments'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,5849
		,'csp_InitCustomDocumentSUAdmissions'
		,NULL
		,NULL
		,'csp_validateCustomDocumentSUAdmissions'
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
	SET DocumentName = 'SUAdmission'
		,DocumentDescription = 'SUAdmission'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLCustomDocumentSUAdmissions'
		,ViewDocumentRDL = 'RDLCustomDocumentSUAdmissions'
		,StoredProcedure = 'csp_SCGetCustomDocumentSUAdmissions'
		,TableList = 'CustomDocumentSUAdmissions,CustomDocumentInfectiousDiseaseRiskAssessments'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = 'csp_InitCustomDocumentSUAdmissions'
		,ValidationStoredProcedure = 'csp_validateCustomDocumentSUAdmissions'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'
	WHERE DocumentCodeId = 46222
END
GO

---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE screenId = 46222
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
		46222
		,'SUAdmission'
		,5763
		,'/Custom/SUAdmission/WebPages/SUAdmission.ascx'
		,NULL
		,2
		,'csp_InitCustomDocumentSUAdmissions'
		,NULL
		,'csp_validateCustomDocumentSUAdmissions'
		,NULL
		,NULL
		,46222
		,NULL
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'SUAdmission'
		,ScreenType = 5763
		,ScreenURL = '/Custom/SUAdmission/WebPages/SUAdmission.ascx'
		,TabId = 2
		,InitializationStoredProcedure = 'csp_InitCustomDocumentSUAdmissions'
		,ValidationStoredProcedureComplete = 'csp_validateCustomDocumentSUAdmissions'
		,PostUpdateStoredProcedure = NULL
		,DocumentCodeId = 46222
	WHERE ScreenId = 46222
END
GO

---------------------------End----------------------------------------------------------------------
---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 46222
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
		'SUAdmission'
		,'SUAdmission'
		,'Y'
		,1
		,'N'
		,'2'
		,46222
		,21
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'SUAdmission'
		,DisplayAs = 'SUAdmission'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = 21
	WHERE ScreenId = 46222
END
GO

---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = 46222
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
		'SUAdmission'
		,'SUAdmission'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46222)
		,46222
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'SUAdmission'
		,[DisplayAs] = 'SUAdmission'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46222)
		,[ScreenId] = 46222
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = 46222
END
---------------------------End----------------------------------------------------------------------
