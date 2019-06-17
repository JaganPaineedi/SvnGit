/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose:   Adding Screen and DocumentCodes items for New Service Note called Psychiatric Note .
   
-- Author:  Varun
-- Date:    24 May 2016    


*********************************************************************************/ 
----------------------------------------   DocumentCodes Table   ----------------------------------- 
DECLARE @documentCodeId INT
 
DECLARE @TableList VARCHAR(500)
DECLARE @GetDataSp VARCHAR(500)
DECLARE @ViewStoredProcedure VARCHAR(500)
DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)
DECLARE @InitializationStoredProcedure VARCHAR(500)
DECLARE @DocumentName VARCHAR(500) 
DECLARE @InitializationProcess INT 
DECLARE @DocumentType INT 
DECLARE @Active CHAR(1) 
DECLARE @ServiceNote CHAR(1) 
DECLARE @PatientConsent CHAR(1) 
DECLARE @OnlyAvailableOnline CHAR(1) 
DECLARE @RequiresSignature CHAR(1) 
DECLARE @ViewOnlyDocument CHAR(1) 
DECLARE @DocumentURL CHAR(1) 
DECLARE @ToBeInitialized CHAR(1) 
DECLARE @TabId INT 
DECLARE @ValidationStoredProcedure VARCHAR(500)
DECLARE @RequiresLicensedSignature CHAR(1) 

SET @documentCodeId = 1639
SET @DocumentName = 'Syndromic Surveillance' 
SET @DocumentType = 10  
SET @Active = 'Y' 
SET @ServiceNote = 'N' --For ServiceNote set this to 'Y'
SET @PatientConsent = NULL 
SET @OnlyAvailableOnline = 'N' 
SET @ViewDocumentURL = 'RDLSyndromicSurveillances'
SET @ViewDocumentRDL = 'RDLSyndromicSurveillances'
SET @GetDataSp =  'ssp_SCGetDocumentSyndromicSurveillance'
SET @TableList = 'DocumentSyndromicSurveillances,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors'
SET @RequiresSignature = 'Y' 
SET @ViewOnlyDocument= NULL 
SET @DocumentURL= NULL 
SET @ToBeInitialized= NULL
SET @InitializationProcess = NULL 
SET @InitializationStoredProcedure='ssp_InitDocumentSyndromicSurveillance'
SET @ValidationStoredProcedure=''
SET @ViewStoredProcedure = 'ssp_RDLSyndromicSurveillance'
SET @RequiresLicensedSignature = NULL


IF NOT EXISTS (SELECT DocumentCodeId 
               FROM   DocumentCodes 
               WHERE  DocumentCodeId = @documentCodeId) 
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
                   [OnlyAvailableOnline], 
                   [StoredProcedure], 
                   [TableList], 
                   [RequiresSignature], 
                   [ViewOnlyDocument], 
                   [DocumentURL], 
                   [ToBeInitialized],
                   [ViewStoredProcedure],
                   [ViewDocumentURL],
				   [ViewDocumentRDL],
                   [InitializationProcess],
                   InitializationStoredProcedure,
                   ValidationStoredProcedure,
                   RequiresLicensedSignature) 
      VALUES      ( @documentCodeId, 
                    @DocumentName, 
                    @DocumentName, 
                    @DocumentType, 
                    @Active, 
                    @ServiceNote, 
                    @PatientConsent, 
                    @OnlyAvailableOnline, 
                    @GetDataSp, 
                    @TableList, 
                    @RequiresSignature, 
                    @ViewOnlyDocument, 
                    @DocumentURL, 
                    @ToBeInitialized, 
                    @ViewStoredProcedure,
                    @ViewDocumentURL,
                    @ViewDocumentRDL,
                    @InitializationProcess,
                    @InitializationStoredProcedure,
                    @ValidationStoredProcedure,
                    @RequiresLicensedSignature) 

      SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF 
  END 
ELSE 
  BEGIN 
      UPDATE [DocumentCodes] 
      SET    DocumentName = @DocumentName, 
             DocumentDescription = @DocumentName, 
             DocumentType = @DocumentType, 
             Active = @Active, 
             ServiceNote = @ServiceNote, 
             PatientConsent = @PatientConsent, 
             OnlyAvailableOnline = @OnlyAvailableOnline,
             StoredProcedure = @GetDataSp, 
             TableList = @TableList, 
             RequiresSignature = @RequiresSignature, 
             ViewOnlyDocument = @ViewOnlyDocument, 
             DocumentURL = @DocumentURL, 
             ToBeInitialized = @ToBeInitialized, 
             ViewStoredProcedure = @ViewStoredProcedure,
             ViewDocumentURL = @ViewDocumentURL,
			 ViewDocumentRDL = @ViewDocumentRDL,
             InitializationProcess = @InitializationProcess,
             InitializationStoredProcedure= @InitializationStoredProcedure,
             ValidationStoredProcedure=@ValidationStoredProcedure,
             RequiresLicensedSignature = @RequiresLicensedSignature
      WHERE  DocumentCodeId = @documentCodeId 
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
DECLARE @ScreenName VARCHAR(500) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(500) 
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 

SET @TabId = 2 

SET @ScreenId = 1195
SET @ScreenName = 'Syndromic Surveillance' 
SET @ScreenType = 5763 
SET @ScreenURL = '/Modules/SyndromicSurveillance/WebPages/SyndromicSurveillance.ascx' 
SET @InitializationStoredProcedure = 'ssp_InitDocumentSyndromicSurveillance' 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete=  '' 
SET @WarningStoredProcedureComplete= NULL
SET @PostUpdateStoredProcedure= NULL
SET @RefreshPermissionsAfterUpdate= NULL 
SET @documentCodeId = 1639

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
                   [DocumentCodeId]) 
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
                    @documentCodeId) 

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
             DocumentCodeId = @documentCodeId 
      WHERE  ScreenId = @ScreenId 
  END 


----------------------------------------   Banner Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @dispalyAs VARCHAR(100) 
DECLARE @BannerActive CHAR(1)
DECLARE @DefaultOrder INT
DECLARE @IsCustom CHAR(1)
DECLARE @ParentBannerId INT
DECLARE @ParentBannerIdForNavigation INT

SET @BannerName = 'Syndromic Surveillance'
SET @dispalyAs = 'Syndromic Surveillance'
SET @BannerActive = 'Y'
SET @DefaultOrder = 6
SET @IsCustom = 'N'
SET @ParentBannerId = 21

IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'Syndromic Surveillance')

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
				  @dispalyAs , -- DisplayAs - varchar(100)
				  @BannerActive , -- Active - type_Active
				  @DefaultOrder , -- DefaultOrder - int
				  @IsCustom , -- Custom - type_YOrN
				  @TabId , -- TabId - int
				  @ParentBannerId,
				  @ScreenId
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
				ScreenId = @ScreenId
		WHERE	ScreenId = @ScreenId
	END


  
  ----------------------------------------   Document Navigation   -----------------------------------  

DECLARE @NavigationName VARCHAR(500)
DECLARE @DisplayAs VARCHAR(500)
DECLARE @ParentDocumentNavigationId INT
DECLARE @BannerId INT
 
SET @NavigationName = 'Syndromic Surveillance' 
SET @DisplayAs =  'Syndromic Surveillance' 
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
ELSE 
  BEGIN 
      UPDATE [DocumentNavigations] 
      SET    NavigationName = @NavigationName, 
             DisplayAs = @DisplayAs, 
             Active = @Active, 
             ParentDocumentNavigationId = @ParentDocumentNavigationId, 
             BannerId = @BannerId, 
             screenId = @ScreenId             
      WHERE  BannerId =@BannerId
  END 
-----------------------------------------------END-------------------------------------------- 

