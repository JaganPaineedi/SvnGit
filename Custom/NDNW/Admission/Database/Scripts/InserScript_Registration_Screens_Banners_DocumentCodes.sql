-- ============================================= 
-- Author:    Aravind
-- Create date: Oct 1, 2014
-- Description:  Screens,Banners entry for Registraion Document. 

-- =============================================   

---------------------------DocumentCodes----------------------------------------------------- 
IF( NOT( EXISTS(SELECT DocumentCodeId 
                FROM   documentCodes 
                WHERE  DocumentCodeId = 10500) ) ) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[DocumentCodes] ON 

      INSERT INTO [DocumentCodes] 
                  ([DocumentCodeId], 
                   [DocumentName], 
                   [DocumentDescription], 
                   [DocumentType], 
                   [Active], 
                   [ServiceNote], 
                   [PatientConsent], 
                   [ViewDocument], 
                   [OnlyAvailableOnline], 
                   [ImageFormatType], 
                   [DefaultImageFolderId], 
                   [ViewDocumentURL], 
                   [ViewDocumentRDL], 
                   [StoredProcedure], 
                   [TableList], 
                   [RequiresSignature], 
                   [ViewOnlyDocument], 
                   [DocumentSchema], 
                   [DocumentHTML], 
                   [DocumentURL], 
                   [ToBeInitialized], 
                   [InitializationProcess], 
                   [InitializationStoredProcedure], 
                   [FormCollectionId], 
                   [ValidationStoredProcedure],
                   [RequiresLicensedSignature],
                   [RecreatePDFOnClientSignature],
                   [RegenerateRDLOnCoSignature],
                   [ViewStoredProcedure]) 
      VALUES     (10500, 
                  'Admission Document', 
                  'Admission Document', 
                  10, 
                  'Y', 
                  'N', 
                  NULL, 
                  NULL, 
                  'N', 
                  NULL, 
                  NULL, 
                  'RDLAdmission', 
                  'RDLAdmission', 
                  'csp_SCGetCustomDocumentRegistrations', 
                  'CustomDocumentRegistrations,ClientContacts,CustomRegistrationFormsAndAgreements,CustomRegistrationCoveragePlans', 
                  'Y', 
                  'N', 
                  NULL, 
                  NULL, 
                  NULL, 
                  NULL, 
                  NULL, 
                  NULL, 
                  NULL, 
                  NULL,
                  'Y', 
                  'Y', 
                  'Y',  
                  'csp_RDLCustomDocumentRegistrations') 

    SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF 
END 
ELSE 
  BEGIN 
      UPDATE [DocumentCodes] 
      SET    [DocumentName] = 'Admission Document', 
             [DocumentDescription] = 'Admission Document', 
             [DocumentType] = 10, 
             [Active] = 'Y', 
             [ServiceNote] = 'N', 
             [PatientConsent] = NULL, 
             [ViewDocument] = NULL, 
             [OnlyAvailableOnline] = 'Y', 
             [ImageFormatType] = NULL, 
             [DefaultImageFolderId] = NULL, 
             [ViewDocumentURL] = 'RDLAdmission', 
             [ViewDocumentRDL] = 'RDLAdmission', 
             [StoredProcedure] = 'csp_SCGetCustomDocumentRegistrations', 
             [TableList] =	'CustomDocumentRegistrations,ClientContacts,CustomRegistrationFormsAndAgreements,CustomRegistrationCoveragePlans', 
			[RequiresSignature] = 'Y', 
			[ViewOnlyDocument] = NULL, 
			[DocumentSchema] = NULL, 
			[DocumentHTML] = NULL, 
			[DocumentURL] = NULL, 
			[ToBeInitialized] = NULL, 
			[InitializationProcess] = NULL, 
			[InitializationStoredProcedure] = NULL, 
			[FormCollectionId] = NULL, 
			[ValidationStoredProcedure] = NULL, 
			[RequiresLicensedSignature]= 'Y',
            [RecreatePDFOnClientSignature] = 'Y',
            [RegenerateRDLOnCoSignature] = 'Y',
			[ViewStoredProcedure] = 'csp_RDLCustomDocumentRegistrations' 
	WHERE  DocumentCodeId = 10500 
END 

---------------------------End--------------------------------------------------------------- 
-------------------------Screens----------------------------------------------------------- 
IF( NOT( EXISTS(SELECT screenId 
                FROM   screens 
                WHERE  screenId = 10500) ) ) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Screens] ON 

      INSERT INTO [Screens] 
                  ([ScreenId], 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [ScreenToolbarURL], 
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId], 
                   [CustomFieldFormId]) 
      VALUES     (10500, 
                  'Admission Document', 
                  5763, 
                 'Custom/Admission/WebPages/RegistrationDocumentMainPage.ascx', 
                 NULL, 
                  2, 
                'csp_InitCustomDocumentRegistrations',
                 NULL, 
                'csp_ValidateCustomDocumentRegistrations', 
                'csp_SCPostUpdateRegistrationDocument', 
                 NULL, 
                 10500, 
                 NULL) 

      SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE SCREENS 
      SET    [ScreenName] = 'Admission Document', 
             [ScreenType] = 5763, 
             [ScreenURL] = 
            'Custom/Admission/WebPages/RegistrationDocumentMainPage.ascx'
             , 
             [ScreenToolbarURL] = NULL, 
             [TabId] = 2, 
             [InitializationStoredProcedure] = 
             'csp_InitCustomDocumentRegistrations'
             , 
             [ValidationStoredProcedureUpdate] = NULL, 
             [ValidationStoredProcedureComplete] = 'csp_ValidateCustomDocumentRegistrations' 
			 ,[PostUpdateStoredProcedure] = 'csp_SCPostUpdateRegistrationDocument'
             , 
             [RefreshPermissionsAfterUpdate] = NULL, 
             [DocumentCodeId] = 10500, 
             [CustomFieldFormId] = NULL 
      WHERE  SCREENID = 10500
  END 




---------------------------End---------------------------------------------------------------------- 
---------------------------Banners------------------------------------------------------------------ 
IF( NOT( EXISTS(SELECT bannerId 
                FROM   banners 
                WHERE  bannerId = 10500) ) ) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Banners] ON 

      INSERT INTO [Banners] 
                  ([BannerId], 
                   [BannerName], 
                   [DisplayAs], 
                   [Active], 
                   [DefaultOrder], 
                   [Custom], 
                   [TabId], 
                   [ScreenId], 
                   [ParentBannerId]) 
      VALUES      (10500, 
                   'Admission', 
                   'Admission', 
                   'Y', 
                   100, 
                   'N', 
                   '2', 
                   10500, 
                   21) 

      SET IDENTITY_INSERT [dbo].[Banners] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Banners 
      SET    [BannerName] = 'Admission', 
             [DisplayAs] = 'Admission', 
             [Active] = 'Y', 
             [DefaultOrder] = 100, 
             [Custom] = 'N', 
             [TabId] = 2, 
             [ScreenId] = 10500, 
             [ParentBannerId] = 21
      WHERE  BANNERID = 10500
  END 

GO 

