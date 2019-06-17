/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Adding Screen, Banner and DocumentCodes items for New document called LOCUS.
   
-- Author:  Ponnin
-- Date:    8 March 2016
-- 03/05/2016 Shruthi.S  Added Validation sp.Ref : #41 Netowrk180-Customziations.

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
DECLARE @RecordDeleted CHAR(1)


-- Setting value to the variables
SET @DocumentCodeId = 1638
SET @DocumentName = 'LOCUS'
SET @DocumentDescription ='LOCUS'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = 'N'	
SET @PatientConsent = NULL
SET @ViewDocument = NULL
SET @OnlyAvailableOnline ='N'
SET @ImageFormatType = NULL
SET @DefaultImageFolderId = NULL
SET @ImageFormat = NULL
SET @ViewDocumentURL ='RDLDocumentLOCUS'
SET @ViewDocumentRDL ='RDLDocumentLOCUS'
SET @StoredProcedure ='ssp_SCGetDocumentLOCUS'
SET @TableList ='DocumentLOCUS'
SET @RequiresSignature ='Y'
SET @ViewOnlyDocument = NULL
SET @DocumentSchema = NULL
SET @DocumentHTML = NULL
SET @DocumentURL = NULL
SET @ToBeInitialized = NULL
SET @InitializationProcess = NULL
SET @InitializationStoredProcedure = 'ssp_InitDocumentLOCUS'
SET @FormCollectionId = NULL
SET @ValidationStoredProcedure = NULL
SET @ViewStoredProcedure = 'ssp_RDLDocumentLOCUS'
SET @MetadataFormId = NULL
SET @TextTemplate = NULL
SET @RequiresLicensedSignature = NULL
SET @ReviewFormId = NULL
SET @MedicationReconciliationDocument = NULL
SET @NewValidationStoredProcedure = NULL
SET @AllowEditingByNonAuthors  = NULL
SET @EnableEditValidationStoredProcedure = NULL
SET @MultipleCredentials = NULL
SET @RecreatePDFOnClientSignature = NULL
SET @DiagnosisDocument = 'N'
SET @RegenerateRDLOnCoSignature = NULL
SET @DefaultCoSigner = NULL
SET @DefaultGuardian = NULL
SET @Need5Columns = NULL
SET @SignatureDateAsEffectiveDate = NULL
SET @FamilyHistoryDocument = NULL
SET @RecordDeleted = 'N'


IF NOT EXISTS (SELECT DocumentCodeId 
               FROM   DocumentCodes 
               WHERE  DocumentCodeId = @DocumentCodeId) 
               
                 BEGIN 
     SET IDENTITY_INSERT [dbo].[DocumentCodes] ON 
     INSERT INTO [dbo].[DocumentCodes] ([DocumentCodeId],[DocumentName], [DocumentDescription], [DocumentType], [Active], [ServiceNote], [PatientConsent], [ViewDocument], [OnlyAvailableOnline], [ImageFormatType], [DefaultImageFolderId], [ImageFormat], [ViewDocumentURL], [ViewDocumentRDL], [StoredProcedure], [TableList], [RequiresSignature], [ViewOnlyDocument], [DocumentSchema], [DocumentHTML], [DocumentURL], [ToBeInitialized], [InitializationProcess], [InitializationStoredProcedure], [FormCollectionId], [ValidationStoredProcedure], [ViewStoredProcedure], [MetadataFormId], [TextTemplate], [RequiresLicensedSignature], [ReviewFormId], [MedicationReconciliationDocument], [NewValidationStoredProcedure], [AllowEditingByNonAuthors], [EnableEditValidationStoredProcedure], [MultipleCredentials], [RecreatePDFOnClientSignature], [DiagnosisDocument], [RegenerateRDLOnCoSignature], [DefaultCoSigner], [DefaultGuardian], [Need5Columns], [SignatureDateAsEffectiveDate], [FamilyHistoryDocument], [RecordDeleted]) VALUES 
										(@DocumentCodeId,@DocumentName,  @DocumentDescription,   @DocumentType, @Active,  @ServiceNote,  @PatientConsent,  @ViewDocument,  @OnlyAvailableOnline,  @ImageFormatType, @DefaultImageFolderId,   @ImageFormat,  @ViewDocumentURL,   @ViewDocumentRDL, @StoredProcedure,  @TableList,  @RequiresSignature,  @ViewOnlyDocument,  @DocumentSchema,  @DocumentHTML,  @DocumentURL,  @ToBeInitialized,  @InitializationProcess,  @InitializationStoredProcedure,  @FormCollectionId,  @ValidationStoredProcedure,  @ViewStoredProcedure,  @MetadataFormId,  @TextTemplate,  @RequiresLicensedSignature,  @ReviewFormId,  @MedicationReconciliationDocument, @NewValidationStoredProcedure,   @AllowEditingByNonAuthors,  @EnableEditValidationStoredProcedure,  @MultipleCredentials,  @RecreatePDFOnClientSignature,  @DiagnosisDocument,   @RegenerateRDLOnCoSignature, @DefaultCoSigner,  @DefaultGuardian,   @Need5Columns,  @SignatureDateAsEffectiveDate,  @FamilyHistoryDocument, @RecordDeleted)
     
     
      
    SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF 
  END 
ELSE 
BEGIN
UPDATE [dbo].[DocumentCodes] 
SET		[DocumentName] = @DocumentName, 
		[DocumentDescription] = @DocumentDescription, 
		[DocumentType] = @DocumentType, 
		[Active] = @Active, 
		[ServiceNote] = @ServiceNote, 
		[PatientConsent] = @PatientConsent, 
		[ViewDocument] = @ViewDocument, 
		[OnlyAvailableOnline] = @OnlyAvailableOnline, 
		[ImageFormatType] = @ImageFormatType, 
		[DefaultImageFolderId] = @DefaultImageFolderId, 
		[ImageFormat] = @ImageFormat, 
		[ViewDocumentURL] = @ViewDocumentURL, 
		[ViewDocumentRDL] = @ViewDocumentRDL, 
		[StoredProcedure] = @StoredProcedure, 
		[TableList] = @TableList, 
		[RequiresSignature] = @RequiresSignature, 
		[ViewOnlyDocument] = @ViewOnlyDocument, 
		[DocumentSchema] = @DocumentSchema, 
		[DocumentHTML] = @DocumentHTML, 
		[DocumentURL] = @DocumentURL, 
		[ToBeInitialized] = @ToBeInitialized, 
		[InitializationProcess] = @InitializationProcess, 
		[InitializationStoredProcedure] = @InitializationStoredProcedure, 
		[FormCollectionId] = @FormCollectionId, 
		[ValidationStoredProcedure] = @ValidationStoredProcedure, 
		[ViewStoredProcedure] = @ViewStoredProcedure, 
		[MetadataFormId] = @MetadataFormId, 
		[TextTemplate] = @TextTemplate, 
		[RequiresLicensedSignature] = @RequiresLicensedSignature, 
		[ReviewFormId] = @ReviewFormId, 
		[MedicationReconciliationDocument] = @MedicationReconciliationDocument, 
		[NewValidationStoredProcedure] = @NewValidationStoredProcedure,
		[AllowEditingByNonAuthors] = @AllowEditingByNonAuthors, 
		[EnableEditValidationStoredProcedure] = @EnableEditValidationStoredProcedure, 
		[MultipleCredentials] = @MultipleCredentials, 
		[RecreatePDFOnClientSignature] = @RecreatePDFOnClientSignature, 
		[DiagnosisDocument] = @DiagnosisDocument, 
		[RegenerateRDLOnCoSignature] = @RegenerateRDLOnCoSignature, 
		[DefaultCoSigner] = @DefaultCoSigner, 
		[DefaultGuardian] = @DefaultGuardian, 
		[Need5Columns] = @Need5Columns, 
		[SignatureDateAsEffectiveDate] = @SignatureDateAsEffectiveDate, 
		[FamilyHistoryDocument] = @FamilyHistoryDocument,
		[RecordDeleted] = @RecordDeleted
 where  DocumentCodeId = @DocumentCodeId  
   END 
   
   
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


SET @ScreenId = 1191
SET @ScreenName = 'LOCUS' 
SET @ScreenType = 5763 
SET @ScreenURL = '/Modules/LOCUS/WebPages/LOCUSMain.ascx'
SET @ScreenToolbarURL = NULL
SET @TabId = 2 
SET @InitializationStoredProcedure = 'ssp_InitDocumentLOCUS' 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete=  'SSP_ValidateDocumentLOCUS'
SET @WarningStoredProcedureComplete= NULL
SET @PostUpdateStoredProcedure= NULL
SET @RefreshPermissionsAfterUpdate= NULL 


IF NOT EXISTS (SELECT ScreenId 
               FROM   Screens 
               WHERE  ScreenId = @ScreenId) 
  BEGIN 
      SET IDENTITY_INSERT [dbo].[Screens] ON 

      INSERT INTO [Screens] 
                  ([ScreenId], 
                   [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureUpdate], 
                   [ValidationStoredProcedureComplete], 
                   [PostUpdateStoredProcedure], 
                   [RefreshPermissionsAfterUpdate], 
                   [DocumentCodeId],
                   [RecordDeleted]) 
      VALUES      ( @ScreenId, 
                    @ScreenName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureUpdate, 
                    @ValidationStoredProcedureComplete, 
                    @PostUpdateStoredProcedure, 
                    @RefreshPermissionsAfterUpdate, 
                    @DocumentCodeId,
                    @RecordDeleted) 

      SET IDENTITY_INSERT [dbo].[Screens] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = @ScreenName, 
             ScreenType = @ScreenType, 
             ScreenURL = @ScreenURL, 
             TabId = @TabId, 
             InitializationStoredProcedure = @InitializationStoredProcedure, 
             ValidationStoredProcedureUpdate = @ValidationStoredProcedureUpdate, 
             ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
             DocumentCodeId = @DocumentCodeId,
             RecordDeleted = @RecordDeleted
      WHERE  ScreenId = @ScreenId
  END 
  
  
  -----------------------------------------------END--------------------------------------------  

  ----------------------------------------   Banner Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @dispalyAs VARCHAR(100) 
DECLARE @BannerActive CHAR(1)
DECLARE @DefaultOrder INT
DECLARE @IsCustom CHAR(1)
DECLARE @ParentBannerId INT
DECLARE @ParentBannerIdForNavigation INT
DECLARE @BHTEDSBannerId INT

SET @BannerName = 'LOCUS'
SET @dispalyAs = 'LOCUS'
SET @BannerActive = 'Y'
SET @DefaultOrder = 5
SET @IsCustom = 'N'
SET @ParentBannerId = 21

IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'LOCUS')

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
				  ScreenId,
				  RecordDeleted		  
				)
		VALUES  ( @BannerName , -- BannerName - varchar(100)
				  @dispalyAs , -- DisplayAs - varchar(100)
				  @BannerActive , -- Active - type_Active
				  @DefaultOrder , -- DefaultOrder - int
				  @IsCustom , -- Custom - type_YOrN
				  @TabId , -- TabId - int
				  @ParentBannerId,
				  @ScreenId,
				  @RecordDeleted 
				)		
	END	
ELSE
	BEGIN
		UPDATE Banners 
		SET		BannerName = @BannerName,
				DisplayAs = @dispalyAs,
				Active = @BannerActive,
				DefaultOrder = @DefaultOrder,
				Custom = @IsCustom,
				TabId = @TabId,
				ParentBannerId = @ParentBannerId,
				ScreenId = @ScreenId,
				RecordDeleted = @RecordDeleted
		WHERE	ScreenId = @ScreenId
	END


  
  ----------------------------------------   Document Navigation   -----------------------------------  

DECLARE @NavigationName VARCHAR(500)
DECLARE @DisplayAs VARCHAR(500)
DECLARE @ParentDocumentNavigationId INT
DECLARE @BannerId INT
 
SET @NavigationName = 'LOCUS' 
SET @DisplayAs =  'LOCUS' 
SET @ParentDocumentNavigationId = NULL
SET @BannerId = (SELECT top 1 BannerId FROM dbo.Banners WHERE ScreenId = @screenId ) 
SET @Active = 'Y' 

IF NOT EXISTS (select DocumentNavigationId from DocumentNavigations where BannerId =@BannerId) 
  BEGIN 

      INSERT INTO [DocumentNavigations] 
                  (NavigationName, 
                   DisplayAs, 
                   ParentDocumentNavigationId, 
                   BannerId,
                   [Active], 
                   ScreenId,
                   RecordDeleted) 
      VALUES      (
                    @NavigationName, 
                    @DisplayAs, 
                    @ParentDocumentNavigationId,
                    @BannerId, 
                    @Active,
                    @screenId,
                    @RecordDeleted
                   ) 

 
  END 
ELSE 
  BEGIN 
      UPDATE [DocumentNavigations] 
      SET    NavigationName = @NavigationName, 
             DisplayAs = @DisplayAs, 
             Active = @Active, 
             ParentDocumentNavigationId = @ParentDocumentNavigationId, 
             BannerId = @BannerId, 
             screenId = @screenId             
      WHERE  BannerId =@BannerId
  END 
-----------------------------------------------END-------------------------------------------- 