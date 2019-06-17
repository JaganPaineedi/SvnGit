/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Adding Screen, Banner and DocumentCodes items for New document called Registration Document.
   
-- Author:  Alok Kumar
-- Date:    12 January 2018


*********************************************************************************/ 
----------------------------------------   DocumentCodes Table   -----------------------------------  

-- Declaration of variable
DECLARE @DocumentCodeId INT
DECLARE @DocumentName VARCHAR(100)
DECLARE @DocumentDescription VARCHAR(250)
DECLARE @DocumentType INT 
DECLARE @Active CHAR(1) 
DECLARE @ServiceNote CHAR(1)
DECLARE @PatientConsent CHAR(1)
DECLARE @ViewDocument binary
DECLARE @OnlyAvailableOnline  CHAR(1)
DECLARE @ImageFormatType INT
DECLARE @DefaultImageFolderId INT
DECLARE @ImageFormat VARCHAR(1000)
DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)
DECLARE @StoredProcedure VARCHAR(100)
DECLARE @TableList VARCHAR(500)
DECLARE @RequiresSignature CHAR(1)
DECLARE @ViewOnlyDocument CHAR(1)
DECLARE @DocumentSchema VARCHAR(500)
DECLARE @DocumentHTML VARCHAR(500)
DECLARE @DocumentURL VARCHAR(1000)
DECLARE @ToBeInitialized CHAR(1)
DECLARE @InitializationProcess INT
DECLARE @InitializationStoredProcedure VARCHAR(100)
DECLARE @FormCollectionId INT
DECLARE @ValidationStoredProcedure VARCHAR(100)
DECLARE @ViewStoredProcedure VARCHAR(100)
DECLARE @MetadataFormId INT
DECLARE @TextTemplate varchar(1000)
DECLARE @RequiresLicensedSignature CHAR(1)
DECLARE @ReviewFormId INT
DECLARE @MedicationReconciliationDocument CHAR(1)
DECLARE @NewValidationStoredProcedure varchar(100)
DECLARE @AllowEditingByNonAuthors CHAR(1)
DECLARE @EnableEditValidationStoredProcedure CHAR(1)
DECLARE @MultipleCredentials varchar(100)
DECLARE @RecreatePDFOnClientSignature CHAR(1)
DECLARE @DiagnosisDocument CHAR(1)
DECLARE @RegenerateRDLOnCoSignature CHAR(1)
DECLARE @DefaultCoSigner CHAR(1)
DECLARE @DefaultGuardian CHAR(1)
DECLARE @Need5Columns CHAR(1)
DECLARE @SignatureDateAsEffectiveDate CHAR(1)
DECLARE @FamilyHistoryDocument CHAR(1)
DECLARE @DocumentCode VARCHAR(100)


--Select NewId()
-- Setting value to the variables
--SET @DocumentCodeId = 1650
SET @DocumentCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @DocumentName = 'Registration Document(C)'
SET @DocumentDescription ='Registration Document(C)'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = 'N'	
SET @PatientConsent = NULL
SET @ViewDocument = NULL
SET @OnlyAvailableOnline ='N'		--'Y' in valley Reg.
SET @ImageFormatType = NULL
SET @DefaultImageFolderId = NULL
SET @ImageFormat = NULL
SET @ViewDocumentURL ='RDLReportRegistraionMain'		--Not Created yet
SET @ViewDocumentRDL ='RDLReportRegistraionMain'		--Not Created yet
SET @StoredProcedure ='ssp_SCGetDocumentRegistrations'			
SET @TableList ='DocumentRegistrations,DocumentRegistrationDemographics,DocumentRegistrationAdditionalInformations,DocumentRegistrationEpisodes,DocumentRegistrationProgramEnrollments,DocumentRegistrationDemographicDeclines,DocumentRegistrationClientEthnicities,DocumentRegistrationClientRaces,DocumentRegistrationClientPictures,DocumentRegistrationClientPhones,DocumentRegistrationClientAddresses,DocumentRegistrationCoverageInformations,ClientContacts,CustomDocumentRegistrations,DocumentRegistrationFormAndAgreement'
SET @RequiresSignature ='Y'
SET @ViewOnlyDocument = NULL
SET @DocumentSchema = NULL
SET @DocumentHTML = NULL
SET @DocumentURL = NULL
SET @ToBeInitialized = NULL
SET @InitializationProcess = NULL
SET @InitializationStoredProcedure = 'ssp_InitDocumentRegistrations'
SET @FormCollectionId = NULL
SET @ValidationStoredProcedure = NULL
SET @ViewStoredProcedure = 'ssp_RDLReportRegistraions'
SET @MetadataFormId = NULL
SET @TextTemplate = NULL
SET @RequiresLicensedSignature = NULL			--'Y' in valley Reg.
SET @ReviewFormId = NULL
SET @MedicationReconciliationDocument = NULL
SET @NewValidationStoredProcedure = NULL
SET @AllowEditingByNonAuthors  = 'N'			--NULL in valley Reg.
SET @EnableEditValidationStoredProcedure = NULL
SET @MultipleCredentials = NULL
SET @RecreatePDFOnClientSignature = 'Y'
SET @DiagnosisDocument = NULL
SET @RegenerateRDLOnCoSignature = 'Y'
SET @DefaultCoSigner = 'N'						--NULL in valley Reg.
SET @DefaultGuardian = 'Y'						--NULL in valley Reg.
SET @Need5Columns = NULL
SET @SignatureDateAsEffectiveDate = NULL
SET @FamilyHistoryDocument = NULL


IF NOT EXISTS (SELECT DocumentCodeId 
               FROM   DocumentCodes 
               WHERE  Code = @DocumentCode) 
               
                 BEGIN 
     --SET IDENTITY_INSERT [dbo].[DocumentCodes] ON 
     INSERT INTO [dbo].[DocumentCodes] ([Code], [DocumentName], [DocumentDescription], [DocumentType], [Active], [ServiceNote], [PatientConsent], [ViewDocument], [OnlyAvailableOnline], [ImageFormatType], [DefaultImageFolderId], [ImageFormat], [ViewDocumentURL], [ViewDocumentRDL], [StoredProcedure], [TableList], [RequiresSignature], [ViewOnlyDocument], [DocumentSchema], [DocumentHTML], [DocumentURL], [ToBeInitialized], [InitializationProcess], [InitializationStoredProcedure], [FormCollectionId], [ValidationStoredProcedure], [ViewStoredProcedure], [MetadataFormId], [TextTemplate], [RequiresLicensedSignature], [ReviewFormId], [MedicationReconciliationDocument], [NewValidationStoredProcedure], [AllowEditingByNonAuthors], [EnableEditValidationStoredProcedure], [MultipleCredentials], [RecreatePDFOnClientSignature], [DiagnosisDocument], [RegenerateRDLOnCoSignature], [DefaultCoSigner], [DefaultGuardian], [Need5Columns], [SignatureDateAsEffectiveDate], [FamilyHistoryDocument]) VALUES 
										(@DocumentCode,@DocumentName,  @DocumentDescription,   @DocumentType, @Active,  @ServiceNote,  @PatientConsent,  @ViewDocument,  @OnlyAvailableOnline,  @ImageFormatType, @DefaultImageFolderId,   @ImageFormat,  @ViewDocumentURL,   @ViewDocumentRDL, @StoredProcedure,  @TableList,  @RequiresSignature,  @ViewOnlyDocument,  @DocumentSchema,  @DocumentHTML,  @DocumentURL,  @ToBeInitialized,  @InitializationProcess,  @InitializationStoredProcedure,  @FormCollectionId,  @ValidationStoredProcedure,  @ViewStoredProcedure,  @MetadataFormId,  @TextTemplate,  @RequiresLicensedSignature,  @ReviewFormId,  @MedicationReconciliationDocument, @NewValidationStoredProcedure,   @AllowEditingByNonAuthors,  @EnableEditValidationStoredProcedure,  @MultipleCredentials,  @RecreatePDFOnClientSignature,  @DiagnosisDocument,   @RegenerateRDLOnCoSignature, @DefaultCoSigner,  @DefaultGuardian,   @Need5Columns,  @SignatureDateAsEffectiveDate,  @FamilyHistoryDocument)
     
     
      
    --SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF 
  END 
--ELSE 
--BEGIN
--UPDATE [dbo].[DocumentCodes] 
--SET		[DocumentName] = @DocumentName, 
--		[DocumentDescription] = @DocumentDescription, 
--		[DocumentType] = @DocumentType, 
--		[Active] = @Active, 
--		[ServiceNote] = @ServiceNote, 
--		[PatientConsent] = @PatientConsent, 
--		[ViewDocument] = @ViewDocument, 
--		[OnlyAvailableOnline] = @OnlyAvailableOnline, 
--		[ImageFormatType] = @ImageFormatType, 
--		[DefaultImageFolderId] = @DefaultImageFolderId, 
--		[ImageFormat] = @ImageFormat, 
--		[ViewDocumentURL] = @ViewDocumentURL, 
--		[ViewDocumentRDL] = @ViewDocumentRDL, 
--		[StoredProcedure] = @StoredProcedure, 
--		[TableList] = @TableList, 
--		[RequiresSignature] = @RequiresSignature, 
--		[ViewOnlyDocument] = @ViewOnlyDocument, 
--		[DocumentSchema] = @DocumentSchema, 
--		[DocumentHTML] = @DocumentHTML, 
--		[DocumentURL] = @DocumentURL, 
--		[ToBeInitialized] = @ToBeInitialized, 
--		[InitializationProcess] = @InitializationProcess, 
--		[InitializationStoredProcedure] = @InitializationStoredProcedure, 
--		[FormCollectionId] = @FormCollectionId, 
--		[ValidationStoredProcedure] = @ValidationStoredProcedure, 
--		[ViewStoredProcedure] = @ViewStoredProcedure, 
--		[MetadataFormId] = @MetadataFormId, 
--		[TextTemplate] = @TextTemplate, 
--		[RequiresLicensedSignature] = @RequiresLicensedSignature, 
--		[ReviewFormId] = @ReviewFormId, 
--		[MedicationReconciliationDocument] = @MedicationReconciliationDocument, 
--		[NewValidationStoredProcedure] = @NewValidationStoredProcedure,
--		[AllowEditingByNonAuthors] = @AllowEditingByNonAuthors, 
--		[EnableEditValidationStoredProcedure] = @EnableEditValidationStoredProcedure, 
--		[MultipleCredentials] = @MultipleCredentials, 
--		[RecreatePDFOnClientSignature] = @RecreatePDFOnClientSignature, 
--		[DiagnosisDocument] = @DiagnosisDocument, 
--		[RegenerateRDLOnCoSignature] = @RegenerateRDLOnCoSignature, 
--		[DefaultCoSigner] = @DefaultCoSigner, 
--		[DefaultGuardian] = @DefaultGuardian, 
--		[Need5Columns] = @Need5Columns, 
--		[SignatureDateAsEffectiveDate] = @SignatureDateAsEffectiveDate, 
--		[FamilyHistoryDocument] = @FamilyHistoryDocument
	 
-- where  Code = @DocumentCode  
--   END 
   
   
   -----------------------------------------------END--------------------------------------------  
   
   
----------------------------------------   Screens Table   -----------------------------------  
/*   
  Please change these variables for supporting a new page/document/widget   
  Screen Types:   
    None:               0,   
        Detail:             5761,   
        List:               5762,   
        Document:           5763,   
        Summary:            5764,   
        Custom:             5765,   
        ExternalScreen:     5766   
*/


DECLARE @ScreenId INT
DECLARE @ScreenName VARCHAR(100) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(200) 
DECLARE @ScreenToolbarURL VARCHAR(200) 
DECLARE @TabId INT 
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 
DECLARE @ScreenCode VARCHAR(100)


SET @ScreenCode = 'BDE62873-41E5-4842-AB04-C7E4D6D32C8D'
SET @ScreenName = 'Registration Document(C)' 
SET @ScreenType = 5763 
SET @ScreenURL = '/Modules/Registration/WebPages/RegistrationDocument.ascx'			
SET @ScreenToolbarURL = NULL
SET @TabId = 2 
SET @InitializationStoredProcedure = 'ssp_InitDocumentRegistrations'
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete=  'ssp_ValidateDocumentRegistrations'
SET @WarningStoredProcedureComplete= NULL
SET @PostUpdateStoredProcedure=  'ssp_SCPostSignatureUpdateRegistrations'
SET @RefreshPermissionsAfterUpdate= NULL 
SET @DocumentCodeId = (Select  top 1 DocumentCodeId from DocumentCodes WHERE  Code = @DocumentCode)


IF NOT EXISTS (SELECT ScreenId 
               FROM   Screens 
               WHERE  Code = @ScreenCode) 
  BEGIN 

      INSERT INTO [Screens] 
                  ([Code], 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId]) 
      VALUES      ( @ScreenCode, 
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate, 
                    @DocumentCodeId) 

  END 
--ELSE 
--  BEGIN 
--      UPDATE Screens 
--      SET    ScreenName = @ScreenName, 
--             ScreenType = @ScreenType, 
--             ScreenURL = @ScreenURL, 
--             TabId = @TabId, 
--             InitializationStoredProcedure = @InitializationStoredProcedure, 
--             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
--             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
--             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
--             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
--             DocumentCodeId = @DocumentCodeId
--      WHERE  Code = @ScreenCode	
--  END 
  
  
  -----------------------------------------------END--------------------------------------------  



  ----------------------------------------   Banner Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @DisplayAs VARCHAR(100) 
DECLARE @BannerActive CHAR(1)
DECLARE @DefaultOrder INT
DECLARE @IsCustom CHAR(1)
DECLARE @ParentBannerId INT
DECLARE @ParentBannerIdForNavigation INT
DECLARE @BHTEDSBannerId INT

SET @ScreenId = (Select  top 1 ScreenId from Screens WHERE  Code = @ScreenCode)
SET @BannerName = 'Registration Document(C)'
SET @DisplayAs = 'Registration Document(C)'
SET @BannerActive = 'Y'
SET @DefaultOrder = 1
SET @IsCustom = 'N'
SET @ParentBannerId = 21


IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'Registration Document(C)')

	BEGIN	
		INSERT dbo.Banners
				( 
				  BannerName ,
				  DisplayAs ,
				  Active ,
				  DefaultOrder ,
				  Custom ,
				  TabId ,
				  ParentBannerId,
				  ScreenId		  
				)
		VALUES  ( @BannerName , -- BannerName - varchar(100)
				  @DisplayAs , -- DisplayAs - varchar(100)
				  @BannerActive , -- Active - type_Active
				  @DefaultOrder , -- DefaultOrder - int
				  @IsCustom , -- Custom - type_YOrN
				  @TabId , -- TabId - int
				  @ParentBannerId,
				  @ScreenId
				)		
	END	
--ELSE
--	BEGIN
--		UPDATE Banners 
--		SET		BannerName = @BannerName,
--				DisplayAs = @DisplayAs,
--				Active = @BannerActive,
--				DefaultOrder = @DefaultOrder,
--				Custom = @IsCustom,
--				TabId = @TabId,
--				ParentBannerId = @ParentBannerId,
--				ScreenId = @ScreenId
--		WHERE	ScreenId = @ScreenId
--	END
	
-----------------------------------------------END-------------------------------------------- 

  
----------------------------------------   Document Navigation   -----------------------------------  

DECLARE @NavigationName VARCHAR(500)
--DECLARE @DisplayAs VARCHAR(500)
DECLARE @ParentDocumentNavigationId INT
DECLARE @BannerId INT
 
SET @NavigationName = 'Registration Document(C)' 
SET @DisplayAs =  'Registration Document(C)' 
SET @ParentDocumentNavigationId = NULL
SET @BannerId = (SELECT top 1 BannerId FROM dbo.Banners WHERE ScreenId = @ScreenId ) 
SET @Active = 'Y' 

IF NOT EXISTS (select DocumentNavigationId from DocumentNavigations where BannerId =@BannerId) 
  BEGIN 

      INSERT INTO [DocumentNavigations] 
                  (NavigationName, 
                   DisplayAs, 
                   ParentDocumentNavigationId, 
                   BannerId,
                   [Active], 
                   ScreenId) 
      VALUES      (
                    @NavigationName, 
                    @DisplayAs, 
                    @ParentDocumentNavigationId,
                    @BannerId, 
                    @Active,
                    @ScreenId
                   ) 

 
  END 
--ELSE 
--  BEGIN 
--      UPDATE [DocumentNavigations] 
--      SET    NavigationName = @NavigationName, 
--             DisplayAs = @DisplayAs, 
--             Active = @Active, 
--             ParentDocumentNavigationId = @ParentDocumentNavigationId, 
--             BannerId = @BannerId, 
--             screenId = @ScreenId             
--      WHERE  BannerId =@BannerId
--  END 
-----------------------------------------------END-------------------------------------------- 