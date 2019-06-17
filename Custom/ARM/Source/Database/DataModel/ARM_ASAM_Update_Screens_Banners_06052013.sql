--new record into banner for ASAM
insert into banners (CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate, BannerName, DisplayAs, Active, DefaultOrder, Custom, TabId, ParentBannerId, ScreenId, ScreenParameters) 
values	('shstest', GETDATE(), 'shstest' , GETDATE(),NULL , NULL, NULL, 'ASAM', 'ASAM', 'Y', 37, 'N', '2', 21, 10029, NULL )

GO

----------------------------------------------------1---------------------------------------------

--new record into documentcodes for ASAM
IF(NOT(EXISTS(SELECT DocumentCodeId FROM documentCodes WHERE DocumentCodeId=1039)))
	BEGIN
		SET IDENTITY_INSERT [dbo].[DocumentCodes] ON
			INSERT INTO [DocumentCodes] (DocumentCodeId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, DocumentName, DocumentDescription, DocumentType, Active, ServiceNote, PatientConsent, ViewDocument, OnlyAvailableOnline, ImageFormatType, DefaultImageFolderId, ImageFormat, ViewDocumentURL, ViewDocumentRDL, StoredProcedure, TableList, RequiresSignature, ViewOnlyDocument, DocumentSchema, DocumentHTML, DocumentURL, ToBeInitialized, InitializationProcess, InitializationStoredProcedure, FormCollectionId, ValidationStoredProcedure, ViewStoredProcedure, MetadataFormId, TextTemplate, RequiresLicensedSignature, ReviewFormId, MedicationReconciliationDocument, NewValidationStoredProcedure, AllowEditingByNonAuthors, EnableEditValidationStoredProcedure, MultipleCredentials, RecreatePDFOnClientSignature, DiagnosisDocument, RegenerateRDLOnCoSignature, DefaultCoSigner, DefaultGuardian, Need5Columns)
			VALUES(1039, 'shstest', getdate(), 'shstest',  getdate(), NULL, NULL, NULL, 'ASAM', 'ASAM', 10, 'Y', 'N', NULL, NULL, 'Y', NULL, NULL, NULL, 'Report_ASAM', 'Report_ASAM', 'csp_PAGetDataForASAM', 'CustomDocumentEventInformations,CustomASAMPlacements', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'csp_RDLPAASAM', NULL, NULL, NULL, NULL, NULL, NULL, 'N', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
		SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF
	END
GO

----------------------------------------------------2---------------------------------------------

--updating the screenurl & screenname for  ASAM
update Screens set DocumentCodeId = 1039,  ScreenName= 'Level of Care', ScreenURL= '/Custom/WebPages/ASAM.ascx' where  ScreenId = 10029


GO

----------------------------------------------------3---------------------------------------------