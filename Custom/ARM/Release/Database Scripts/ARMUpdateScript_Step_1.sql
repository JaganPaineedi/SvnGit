--DELETE FROM banners WHERE BannerId = 2000267 AND  DisplayAs = 'ASAM'
UPDATE Banners SET RecordDeleted = 'Y' , Active = 'N' WHERE BannerId = 2000267

IF(NOT(EXISTS(SELECT BannerId FROM Banners WHERE BannerId=1000429 )))
	BEGIN
		SET IDENTITY_INSERT [dbo].[Banners] ON
		INSERT INTO [Banners] ([BannerId],[CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [BannerName], [DisplayAs], [Active], [DefaultOrder], [Custom], [TabId], [ParentBannerId], [ScreenId], [ScreenParameters])
		VALUES(1000429, 'shstest', GETDATE(), 'shstest' , GETDATE(),NULL , NULL, NULL, 'Level of Care', 'Level of Care', 'Y', 37, 'N', '2', 855, 10029, NULL)
		SET IDENTITY_INSERT [dbo].[Banners] OFF
	END
GO
	
----------------------------------------------Banner End---------------------------------------------

IF(NOT(EXISTS(SELECT DocumentNavigationId FROM DocumentNavigations WHERE BannerId=1000429)))
 BEGIN
  SET IDENTITY_INSERT [dbo].[DocumentNavigations] ON
   INSERT INTO [DocumentNavigations]([DocumentNavigationId],[NavigationName],[DisplayAs],[Active],[ParentDocumentNavigationId],[BannerId],[ScreenId])
   VALUES (10738,'Level of Care','Level of Care','Y',5,1000429,10029)
  SET IDENTITY_INSERT [dbo].[DocumentNavigations] OFF 
 END
GO

-----------------------------------------------DocumentNavigations End-----------------------------------------------------------

UPDATE documentCodes SET RecordDeleted='Y' WHERE DocumentCodeId=1039	

--new record into documentcodes for ASAM
IF(NOT(EXISTS(SELECT DocumentCodeId FROM documentCodes WHERE DocumentCodeId=1000407)))
	BEGIN
		SET IDENTITY_INSERT [dbo].[DocumentCodes] ON
			INSERT INTO [DocumentCodes] (DocumentCodeId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, DocumentName, DocumentDescription, DocumentType, Active, ServiceNote, PatientConsent, ViewDocument, OnlyAvailableOnline, ImageFormatType, DefaultImageFolderId, ImageFormat, ViewDocumentURL, ViewDocumentRDL, StoredProcedure, TableList, RequiresSignature, ViewOnlyDocument, DocumentSchema, DocumentHTML, DocumentURL, ToBeInitialized, InitializationProcess, InitializationStoredProcedure, FormCollectionId, ValidationStoredProcedure, ViewStoredProcedure, MetadataFormId, TextTemplate, RequiresLicensedSignature, ReviewFormId, MedicationReconciliationDocument, NewValidationStoredProcedure, AllowEditingByNonAuthors, EnableEditValidationStoredProcedure, MultipleCredentials, RecreatePDFOnClientSignature, DiagnosisDocument, RegenerateRDLOnCoSignature, DefaultCoSigner, DefaultGuardian, Need5Columns)
			VALUES(1000407, 'shstest', getdate(), 'shstest', getdate(), NULL, NULL, NULL, 'Level of Care', 'Level of Care', 10, 'Y', 'N', NULL, NULL, 'Y', NULL, NULL, NULL, 'Report_ASAM', 'Report_ASAM', 'csp_PAGetDataForASAM', 'CustomDocumentEventInformations,CustomASAMPlacements', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csp_RDLPAASAM', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
		SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF
	END
GO

-----------------------------------------------documentCodes End-----------------------------------------------------------

UPDATE Screens set DocumentCodeId = 1000407,  ScreenName= 'Level of Care', ScreenURL= '/Custom/WebPages/ASAM.ascx' WHERE ScreenId = 10029
GO

-----------------------------------------------Screens End-----------------------------------------------------------
