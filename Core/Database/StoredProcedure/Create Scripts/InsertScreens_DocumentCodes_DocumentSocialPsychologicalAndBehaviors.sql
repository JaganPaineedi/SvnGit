/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Social, Psychological, and Behavior Data"
-- Purpose: Script to add entries in Screens and DocumentCodes table for Task #42 - Meaningful Use - Stage 3. 
--  
-- Author:  Vijay
-- Date:    06-07-2017
--  
-- *****History****  
--
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

SET @DocumentCodeId = 1642
SET @ScreenId = 1233
SET @ScreenType = 5763
SET @DocumentType = 10
SET @Active = 'Y'
SET @ScreenName = 'Social, Psychological, and Behavior Data'
SET @DocumentName = 'Social, Psychological, and Behavior Data'
SET @ScreenURL = '/Modules/SocialPsychologicalAndBehaviorData/WebPages/SocialPsychologicalBehaviorData.ascx'
SET @TableList = 'DocumentSocialPsychologicalAndBehaviors'
SET @RDLName = 'RDLDocumentSocialPsychologicalAndBehaviors'
SET @ViewStoredProcedure = 'ssp_RDLDocumentSocialPsychologicalAndBehaviors'
SET @GetDataSp = 'ssp_SCGetDocumentSocialPsychologicalAndBehaviors'
SET @InitializationStoredProcedure = 'ssp_InitDocumentSocialPsychologicalAndBehaviors'
SET @ValidationStoredProcedureComplete = null;
SET @PostUpdateStoredProcedure = NULL 
SET @TabId = 2
SET @ServiceNote = 'N'
SET @OnlyAvailableOnline = 'N'
SET @RequiresSignature = 'Y'
SET @AllowEditingByNonAuthors = 'N'
SET @DefaultCoSigner = 'Y'
SET @DefaultGuardian = 'N'
set @NewValidationStoredProcedure = null;
set @ValidationStoredProcedure = Null;
set @DiagnosisDocument = NULL;
set @RegenerateRDLOnCoSignature = 'Y';
set @RecreatePDFOnClientSignature = 'Y';
set @DSMV = 'Y'

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
		,DSMV
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
		,@DSMV
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
		,ValidationStoredProcedure  = @ValidationStoredProcedure
		,DiagnosisDocument  =@DiagnosisDocument
		,RegenerateRDLOnCoSignature = @RegenerateRDLOnCoSignature 
		,RecreatePDFOnClientSignature = @RecreatePDFOnClientSignature 
		,DSMV=@DSMV
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
		,@ValidationStoredProcedure
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
		,ValidationStoredProcedureComplete = @ValidationStoredProcedure
		,PostUpdateStoredProcedure = @PostUpdateStoredProcedure
	WHERE screenid = @ScreenId
END


/*Banners Insert Script*/
DECLARE @DefaultOrder INT
DECLARE @BannerName VARCHAR(100)
DECLARE @DisplayAs VARCHAR(100)
DECLARE @Custom CHAR
DECLARE @ParentBannerId INT


SET @ParentBannerId = '21'
SET @BannerName = 'Social, Psychological, and Behavior Data'
SET @DisplayAs = 'Social, Psychological, and Behavior Data'
SET @Custom = 'N'
SET @DefaultOrder = 1

IF NOT EXISTS (
		SELECT *
		FROM Banners
		WHERE [ScreenId] = @ScreenId
		)
BEGIN
	INSERT INTO [dbo].[Banners] (
		[BannerName]
		,[DisplayAs]
		,[Active]
		,[DefaultOrder]
		,[Custom]
		,[TabId]
		,[ParentBannerId]
		,[ScreenId]
		)
	VALUES (
		@BannerName
		,@DisplayAs
		,@Active
		,@DefaultOrder
		,@Custom
		,@TabId
		,@ParentBannerId
		,@ScreenId
		)
END
ELSE
BEGIN
	UPDATE Banners
	SET BannerName = @BannerName
		,DisplayAs = @DisplayAs
		,Active = @Active
		,DefaultOrder = @DefaultOrder
		,Custom = @Custom
		,TabId = @TabId
		,ParentBannerId = @ParentBannerId
		,ScreenId = @ScreenId
		,RecordDeleted = NULL
	WHERE ScreenId = @ScreenId
END