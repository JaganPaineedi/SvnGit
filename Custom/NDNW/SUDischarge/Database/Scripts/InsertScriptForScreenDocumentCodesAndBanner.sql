---------------------------DocumentCodes-----------------------------------------------------

-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization
IF (
		NOT (
			EXISTS (
				SELECT DocumentCodeId
				FROM documentCodes
				WHERE DocumentCodeId = 46221
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
		)
	VALUES (
		46221
		,'SU Discharge'
		,'SU Discharge'
		,10
		,'Y'
		,'N'
		,NULL
		,NULL
		,'N'
		,NULL
		,NULL
		,'RDLCustomSUDischarges'
		,'RDLCustomSUDischarges'
		,'csp_SCGetCustomSUDischarges'
		,'CustomDocumentSUDischarges'
		,'Y'
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,'csp_InitCustomSUDischarges'
		,NULL
		,NULL
		,'csp_validateCustomSUDischarges'
		,NULL
		,'Y'
		,'Y'
		,'Y'
		,'Y'
		,'csp_ValidateCustomDocumentNewSUDischarges'
		)

	SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF
END
ELSE
BEGIN
	UPDATE DocumentCodes
	SET DocumentName = 'SU Discharge'
		,DocumentDescription = 'SU Discharge'
		,DocumentType = 10
		,Active = 'Y'
		,ServiceNote = 'N'
		,ViewDocumentURL = 'RDLCustomSUDischarges'
		,ViewDocumentRDL = 'RDLCustomSUDischarges'
		,StoredProcedure = 'csp_SCGetCustomSUDischarges'
		,TableList = 'CustomDocumentSUDischarges'
		,RequiresSignature = 'Y'
		,InitializationStoredProcedure = 'csp_InitCustomSUDischarges'
		,ValidationStoredProcedure = 'csp_validateCustomSUDischarges'
		,DefaultCoSigner = 'Y'
		,DefaultGuardian = 'Y'
		,RegenerateRDLOnCoSignature = 'Y'
		,RecreatePDFOnClientSignature = 'Y'
		,NewValidationStoredProcedure = 'csp_ValidateCustomDocumentNewSUDischarges'
	WHERE DocumentCodeId = 46221
END
GO

---------------------------End---------------------------------------------------------------
---------------------------Screens-----------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM screens
				WHERE screenId = 46221
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
		46221
		,'SU Discharge'
		,5763
		,'/Custom/SUDischarge/WebPages/SUDischarge.ascx'
		,NULL
		,2
		,'csp_InitCustomSUDischarges'
		,NULL
		,'csp_validateCustomSUDischarges'
		,'csp_SCPostUpdateSUDischargeDocument'
		,NULL
		,46221
		,NULL
		)

	SET IDENTITY_INSERT [dbo].[Screens] OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET ScreenName = 'SU Discharge'
		,ScreenType = 5763
		,ScreenURL = '/Custom/SUDischarge/WebPages/SUDischarge.ascx'
		,TabId = 2
		,InitializationStoredProcedure = 'csp_InitCustomSUDischarges'
		,ValidationStoredProcedureComplete = 'csp_validateCustomSUDischarges'
		,PostUpdateStoredProcedure = 'csp_SCPostUpdateSUDischargeDocument'
		,DocumentCodeId = 46221
	WHERE ScreenId = 46221
END
GO

---------------------------End----------------------------------------------------------------------
---------------------------Banners------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT screenId
				FROM Banners
				WHERE screenId = 46221
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
		'SU Discharge'
		,'SU Discharge'
		,'Y'
		,1
		,'N'
		,'2'
		,46221
		,21
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = 'SU Discharge'
		,DisplayAs = 'SU Discharge'
		,Active = 'Y'
		,DefaultOrder = 1
		,Custom = 'N'
		,TabId = '2'
		,ParentBannerId = 21
	WHERE ScreenId = 46221
END
GO

---------------------------End----------------------------------------------------------------------

---------------------------DocumentNavigations------------------------------------------------------------------
IF (
		NOT (
			EXISTS (
				SELECT ScreenId
				FROM DocumentNavigations
				WHERE ScreenId = 46221
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
		'SU Discharge'
		,'SU Discharge'
		,'Y'
		,NULL
		,(SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46221)
		,46221
		,SYSTEM_USER
		,GETDATE()
		,SYSTEM_USER
		,GETDATE()
		)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET [NavigationName] = 'SU Discharge'
		,[DisplayAs] = 'SU Discharge'
		,[Active] = 'Y'
		,[ParentDocumentNavigationId] = NULL
		,[BannerId] = (SELECT TOP 1 BannerId FROM Banners WHERE screenId = 46221)
		,[ScreenId] = 46221
		,[ModifiedBy] = SYSTEM_USER
		,[ModifiedDate] = GETDATE()
	WHERE ScreenId = 46221
END
---------------------------End----------------------------------------------------------------------
