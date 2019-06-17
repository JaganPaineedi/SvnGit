/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Commercial Individual Service Note"
-- Purpose: Script to add entries in Screens and DocumentCodes table for  New Directions - Support Go Live, Task #286. 
--  
-- Author:  K.Soujanya
-- Date:    19-Jan-2017
--  
-- *****History****  
*********************************************************************************/
DECLARE @DocumentCodeId INT
DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @DocumentType INT
DECLARE @Active CHAR(1)
DECLARE @ScreenName VARCHAR(64)
DECLARE @DocumentName VARCHAR(64)
DECLARE @ScreenURL VARCHAR(200)
DECLARE @DetailScreenPostUpdateSP VARCHAR(64)
DECLARE @TableList VARCHAR(600)
DECLARE @RDLName VARCHAR(64)
DECLARE @ViewStoredProcedure VARCHAR(64)
DECLARE @GetDataSp VARCHAR(64)
DECLARE @InitializationStoredProcedure VARCHAR(64)
DECLARE @ValidationStoredProcedureComplete VARCHAR(64)
DECLARE @WarningStoredProcedureComplete VARCHAR(64)
DECLARE @PostUpdateStoredProcedure VARCHAR(64)
DECLARE @TabId INT
DECLARE @ServiceNote CHAR(1)
DECLARE @OnlyAvailableOnline CHAR(1)
DECLARE @RequiresSignature CHAR(1)
DECLARE @AllowEditingByNonAuthors CHAR(1)
DECLARE @DefaultCoSigner CHAR(1)
DECLARE @DefaultGuardian CHAR(1)
DECLARE @DiagnosisDocument CHAR(1)
DECLARE @NewValidationStoredProcedure VARCHAR(64)
DECLARE @ValidationStoredProcedure VARCHAR(64)
DECLARE @RegenerateRDLOnCoSignature CHAR(1)
DECLARE @RecreatePDFOnClientSignature CHAR(1)
DECLARE @DSMV CHAR(1)

SET @DocumentCodeId = 10115
SET @ScreenId = 10115
SET @ScreenType = 5763
SET @DocumentType = 10
SET @Active = 'Y'
SET @ScreenName = 'DLA-20'
SET @DocumentName = 'DLA-20'
SET @ScreenURL = '/Custom/DLA-20/WebPages/DLA.ascx'
SET @TableList = 'CustomDocumentDLA20s,CustomDailyLivingActivityScores,CustomYouthDLAScores'
SET @RDLName = 'RDLCustomDocumentDLA20'
SET @ViewStoredProcedure = 'csp_RDLCustomDocumentDLA20'
SET @GetDataSp = 'csp_SCGetCustomDocumentDLA20'
SET @InitializationStoredProcedure = 'csp_InitCustomDocumentDLA20'
SET @ValidationStoredProcedureComplete = 'csp_ValidateCustomDocumentDLA20';
SET @WarningStoredProcedureComplete = NULL
SET @PostUpdateStoredProcedure = NULL
SET @TabId = 2
SET @ServiceNote = 'N'
SET @OnlyAvailableOnline = 'N'
SET @RequiresSignature = 'Y'
SET @AllowEditingByNonAuthors = 'N'
SET @DefaultCoSigner = 'Y'
SET @DefaultGuardian = 'N'
SET @NewValidationStoredProcedure = NULL;
SET @ValidationStoredProcedure = NULL
SET @DiagnosisDocument = Null;
SET @RegenerateRDLOnCoSignature = 'Y';
SET @RecreatePDFOnClientSignature = 'Y';
SET @DSMV = 'Y'

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentCodes
		WHERE DocumentCodeId = @DocumentCodeId
			AND DocumentType = @DocumentType
			AND Active = @Active
		)
BEGIN
	SET IDENTITY_INSERT DocumentCodes ON

	INSERT INTO DocumentCodes (
		DocumentCodeId
		,DocumentName
		,DocumentDescription
		,DocumentType
		,Active
		,ServiceNote
		,OnlyAvailableOnline
		,StoredProcedure
		,TableList
		,RequiresSignature
		,ViewDocumentURL
		,ViewDocumentRDL
		,ViewStoredProcedure
		,AllowEditingByNonAuthors
		,DefaultCoSigner
		,DefaultGuardian
		,NewValidationStoredProcedure
		,ValidationStoredProcedure
		,DiagnosisDocument
		,RecreatePDFOnClientSignature
		,RegenerateRDLOnCoSignature
		--,DSMV
		)
	VALUES (
		@DocumentCodeId
		,@DocumentName
		,@DocumentName
		,@DocumentType
		,@Active
		,@ServiceNote
		,@OnlyAvailableOnline
		,@GetDataSp
		,@TableList
		,@RequiresSignature
		,@RDLName
		,@RDLName
		,@ViewStoredProcedure
		,@AllowEditingByNonAuthors
		,@DefaultCoSigner
		,@DefaultGuardian
		,@NewValidationStoredProcedure
		,@ValidationStoredProcedure
		,@DiagnosisDocument
		,@RecreatePDFOnClientSignature
		,@RegenerateRDLOnCoSignature
		--,@DSMV
		)

	SET IDENTITY_INSERT DocumentCodes OFF
END
ELSE
BEGIN
	UPDATE DocumentCodes
	SET DocumentName = @DocumentName
		,DocumentDescription = @DocumentName
		,DocumentType = @DocumentType
		,Active = @Active
		,ServiceNote = @ServiceNote
		,OnlyAvailableOnline = @OnlyAvailableOnline
		,StoredProcedure = @GetDataSp
		,TableList = @TableList
		,RequiresSignature = @RequiresSignature
		,ViewDocumentURL = @RDLName
		,ViewDocumentRDL = @RDLName
		,ViewStoredProcedure = @ViewStoredProcedure
		,AllowEditingByNonAuthors = @AllowEditingByNonAuthors
		,NewValidationStoredProcedure = @NewValidationStoredProcedure
		,ValidationStoredProcedure = @ValidationStoredProcedure
		,DiagnosisDocument = @DiagnosisDocument
		,RegenerateRDLOnCoSignature = @RegenerateRDLOnCoSignature
		,RecreatePDFOnClientSignature = @RecreatePDFOnClientSignature
		--,DSMV = @DSMV
	WHERE DocumentCodeId = @DocumentCodeId
END

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE ScreenId = @ScreenId
		)
BEGIN
	SET IDENTITY_INSERT Screens ON

	INSERT INTO [Screens] (
		ScreenId
		,[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureComplete]
		,[WarningStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		)
	VALUES (
		@ScreenId
		,@ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@DocumentCodeId
		,@InitializationStoredProcedure
		,@ValidationStoredProcedureComplete
		,@WarningStoredProcedureComplete
		,@PostUpdateStoredProcedure
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE screens
	SET screenname = @ScreenName
		,screentype = @ScreenType
		,screenurl = @ScreenURL
		,tabid = @TabId
		,DocumentCodeId = @DocumentCodeId
		,InitializationStoredProcedure = @InitializationStoredProcedure
		,ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete
		,WarningStoredProcedureComplete = @WarningStoredProcedureComplete
		,PostUpdateStoredProcedure = @PostUpdateStoredProcedure
	WHERE screenid = @ScreenId
END



--IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=10115)
--BEGIN

--INSERT INTO [dbo].[Banners]
--           (           
--           [BannerName]
--           ,[DisplayAs]
--           ,[Active]
--           ,[DefaultOrder]
--           ,[Custom]
--           ,[TabId]
--           ,[ParentBannerId]
--           ,[ScreenId]
--           ,[ScreenParameters])
--     VALUES
--           (          
--            'DLA-20'
--           ,'DLA-20'
--           ,'Y'
--           ,1
--           ,'Y'
--           ,2
--           ,21
--           ,10115
--           ,Null)           
           
--           END
           
            ----------------------------------------   Banner Table   -----------------------------------  
DECLARE @BannerName VARCHAR(100)
DECLARE @dispalyAs VARCHAR(100) 
DECLARE @BannerActive CHAR(1)
DECLARE @DefaultOrder INT
DECLARE @IsCustom CHAR(1)
DECLARE @ParentBannerId INT
DECLARE @ParentBannerIdForNavigation INT
DECLARE @BHTEDSBannerId INT

SET @BannerName = 'DLA-20'
SET @dispalyAs = 'DLA-20'
SET @BannerActive = 'Y'
SET @DefaultOrder = 1
SET @IsCustom = 'N'
SET @ParentBannerId = (SELECT top 1 BannerId FROM dbo.Banners WHERE BannerName = 'Documents' ) 

IF NOT EXISTS (SELECT * FROM dbo.Banners WHERE ScreenId =@ScreenId AND BannerName = 'DLA-20')

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


  
  --------------------------------------   Document Navigation   -----------------------------------  

DECLARE @NavigationName VARCHAR(500)
DECLARE @DisplayAs VARCHAR(500)
DECLARE @ParentDocumentNavigationId INT
DECLARE @BannerId INT
 
SET @NavigationName = 'DLA-20' 
SET @DisplayAs =  'DLA-20' 
SET @ParentDocumentNavigationId = (SELECT top 1 DocumentNavigationId FROM dbo.DocumentNavigations WHERE  NavigationName = 'Documents' ) 
SET @BannerId = (SELECT top 1 BannerId FROM dbo.Banners WHERE  BannerName = 'DLA-20' and Screenid = @screenId ) 
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
                    @screenId
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
---------------------------------------------END-------------------------------------------- 

