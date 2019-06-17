/*********************************************************************/  
/*       */  
/* Date              Author                  Purpose                 */  
/* 5/25/2015		 Sunil.D	            SC: Treatment Episode New Screen and Banner not Client Episode
											Thresholds - Support  #828
*/  
/*********************************************************************/  
/**  Change History **/                                                                           
/********************************************************************************/                                                                             
/**  Date:    Author:     Description: **/                                                                           
/**  --------  --------    ------------------------------------------- */    

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
DECLARE @TableList VARCHAR(MAX)
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
DECLARE @DSMV CHAR(1)


-- Setting value to the variables
SET @DocumentCodeId = null
SET @DocumentName = 'Treatment Episode'
SET @DocumentDescription ='Treatment Episode'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = 'N'	
SET @PatientConsent = NULL
SET @ViewDocument = NULL
SET @OnlyAvailableOnline ='N'
SET @ImageFormatType = NULL
SET @DefaultImageFolderId = NULL
SET @ImageFormat = NULL
SET @ViewDocumentURL ='RDLTreatmentEpisode'
SET @ViewDocumentRDL ='RDLTreatmentEpisode'
SET @StoredProcedure =null
SET @TableList ='TreatmentEpisodes'
SET @RequiresSignature ='Y'
SET @ViewOnlyDocument = NULL
SET @DocumentSchema = NULL
SET @DocumentHTML = NULL
SET @DocumentURL = NULL
SET @ToBeInitialized = NULL
SET @InitializationProcess = 5849
SET @InitializationStoredProcedure = null
SET @FormCollectionId = NULL
SET @ValidationStoredProcedure = null
SET @ViewStoredProcedure = null
SET @MetadataFormId = NULL
SET @TextTemplate = NULL
SET @RequiresLicensedSignature = NULL
SET @ReviewFormId = NULL
SET @MedicationReconciliationDocument = NULL
SET @NewValidationStoredProcedure = null
SET @AllowEditingByNonAuthors  = NULL
SET @EnableEditValidationStoredProcedure = NULL
SET @MultipleCredentials = NULL
SET @RecreatePDFOnClientSignature = 'Y'
SET @DiagnosisDocument = NULL
SET @RegenerateRDLOnCoSignature = 'Y'
SET @DefaultCoSigner = 'Y'
SET @DefaultGuardian = 'Y'
SET @Need5Columns = NULL
SET @SignatureDateAsEffectiveDate = NULL
SET @FamilyHistoryDocument = NULL
SET @DSMV = NULL

 
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


SET @ScreenId = 1226
SET @ScreenName = 'Treatment Episode' 
SET @ScreenType = 5762 
SET @ScreenURL = '/Modules/TreatmentEpisode/ActivityPages/Office/ListPages/TreatmentEpisodeListOffice.ascx'
SET @ScreenToolbarURL = NULL
SET @TabId = 1
SET @InitializationStoredProcedure = null 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete= null
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
                    @DocumentCodeId) 

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
             DocumentCodeId = @DocumentCodeId
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

SET @BannerName = 'Treatment Episode'
SET @dispalyAs = 'Treatment Episode'
SET @BannerActive = 'Y'
SET @DefaultOrder = 1
SET @IsCustom = 'Y'
--SET @ParentBannerId = (SELECT top 1 BannerId FROM dbo.Banners WHERE BannerName = 'Assessments' ) 
SET @ParentBannerId =null
IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'Treatment Episode')

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


----------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @BannerId INT=(SELECT TOP 1 BannerID FROM Banners WHERE BannerName=@ScreenName AND DisplayAs=@ScreenName AND ISNULL(RecordDeleted,'N')<>'Y' AND Active='Y' AND ScreenId=@ScreenId)

IF NOT EXISTS (SELECT 1 FROM DocumentNavigations WHERE NavigationName=@ScreenName AND BannerId=@BannerId AND ScreenId=@ScreenId)
BEGIN
	INSERT INTO DocumentNavigations(NavigationName,DisplayAs,Active,ParentDocumentNavigationId,BannerId,ScreenId)
	VALUES (@ScreenName,@ScreenName,'Y',NULL,@BannerId,@ScreenId)
END
ELSE
BEGIN
	UPDATE DocumentNavigations
	SET DisplayAs=@ScreenName,Active='Y',ParentDocumentNavigationId=NULL
	WHERE NavigationName=@ScreenName AND BannerId=@BannerId AND ScreenId=@ScreenId
END

------------------------------------------------------------------------------------------------------------------------------------------------------


  
 
