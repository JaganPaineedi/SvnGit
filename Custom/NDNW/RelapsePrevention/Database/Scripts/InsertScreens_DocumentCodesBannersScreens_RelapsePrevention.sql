---------------------------DocumentCodes-----------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE DocumentCodeId = 22188
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
		22188
		,'Relapse Prevention Plan'
		,'Relapse Prevention Plan'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLCustomDocumentRelapsePreventions'
		,'RDLCustomDocumentRelapsePreventions'
		,'csp_SCGetCustomDocumentRelapsePreventions'
		, 'CustomDocumentRelapsePreventionPlans,CustomRelapseLifeDomains,CustomRelapseGoals,CustomRelapseObjectives,CustomRelapseActionSteps'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,5849
		,'csp_InitCustomDocumentRelapsePreventions'
		,NULL
		,NULL
		,'csp_validateCustomDocumentRelapsePreventions'
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
	SET DocumentName = 'Relapse Prevention Plan'
		,DocumentDescription = 'Relapse Prevention Plan'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLCustomDocumentRelapsePreventions'
		,ViewDocumentRDL = 'RDLCustomDocumentRelapsePreventions'
		,StoredProcedure = 'csp_SCGetCustomDocumentRelapsePreventions'
		,TableList = 'CustomDocumentRelapsePreventionPlans,CustomRelapseLifeDomains,CustomRelapseGoals,CustomRelapseObjectives,CustomRelapseActionSteps'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = 'csp_InitCustomDocumentRelapsePreventions'
		,ValidationStoredProcedure = 'csp_validateCustomDocumentRelapsePreventions'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'
	WHERE DocumentCodeId = 22188
END
GO

---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE screenId = 22188
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
		22188
		,'Relapse Prevention Plan'
		,5763
		,'/Custom/RelapsePrevention/WebPages/RelapsePrevention.ascx'
		,NULL
		,2
		,'csp_InitCustomDocumentRelapsePreventions'
		,NULL
		,'csp_validateCustomDocumentRelapsePreventions'
		,NULL
		,NULL
		,22188
		,NULL
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'Relapse Prevention Plan'
		,ScreenType = 5763
		,ScreenURL = '/Custom/RelapsePrevention/WebPages/RelapsePrevention.ascx'
		,TabId = 2
		,InitializationStoredProcedure = 'csp_InitCustomDocumentRelapsePreventions'
		,ValidationStoredProcedureComplete = 'csp_validateCustomDocumentRelapsePreventions'
		,PostUpdateStoredProcedure = NULL
		,DocumentCodeId = 22188
	WHERE ScreenId = 22188
END
GO

---------------------------End----------------------------------------------------------------------
---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 22188
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
		'Relapse Prevention Plan'
		,'Relapse Prevention Plan'
		,'Y'
		,1
		,'N'
		,'2'
		,22188
		,21
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'Relapse Prevention Plan'
		,DisplayAs = 'Relapse Prevention Plan'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = 21
	WHERE ScreenId = 22188
END
GO

---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = 22188
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
		'Relapse Prevention Plan'
		,'Relapse Prevention Plan'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = 22188)
		,22188
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'Relapse Prevention Plan'
		,[DisplayAs] = 'Relapse Prevention Plan'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 22188)
		,[ScreenId] = 22188
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = 22188
END
---------------------------End----------------------------------------------------------------------
