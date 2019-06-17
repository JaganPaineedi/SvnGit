/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Core Dast Document"
-- Purpose:  
--  
-- Author:  Chethan N
-- Date:    16-Apr-2018
--  
-- *****History****  
   Date				Author				Description                    
   17/APR/2018		Chethan N			Westbridge-Customizations-#4650                    
*********************************************************************************/
DECLARE @DocumentCodeId INT
DECLARE @ScreenId INT
DECLARE @ScreenType INT
DECLARE @DocumentType INT
DECLARE @Active CHAR(1)
DECLARE @ScreenName VARCHAR(64)
DECLARE @ScreenCode VARCHAR(100)
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
DECLARE @FormCollectionId INT

SET @DocumentCodeId = 1651	
--SET @ScreenId = 12001
SET @ScreenType = 5763
SET @DocumentType = 10
SET @Active = 'Y'
SET @ScreenName = 'DAST'
SET @ScreenCode = 'DocumentDASTs'
SET @DocumentName = 'DAST'
SET @ScreenURL = '/CommonUserControls/DFASingleTabDocuments.ascx'
SET @TableList = 'DocumentDASTs'
SET @RDLName = 'RDLDocumentDasts'
SET @ViewStoredProcedure = 'ssp_RDLDocumentDasts'
SET @GetDataSp = 'ssp_GetDocumentDasts'
SET @InitializationStoredProcedure = 'ssp_InitDocumentDasts'
SET @ValidationStoredProcedureComplete = 'ssp_validateDocumentDasts';
SET @WarningStoredProcedureComplete = NULL;
SET @PostUpdateStoredProcedure =NULL;
SET @TabId = 2
SET @ServiceNote = 'N'
SET @OnlyAvailableOnline = 'N'
SET @RequiresSignature = 'Y'
SET @AllowEditingByNonAuthors = 'N'
SET @DefaultCoSigner = 'N'
SET @DefaultGuardian = 'N'
SET @NewValidationStoredProcedure = NULL;
SET @ValidationStoredProcedure = NULL;
SET @DiagnosisDocument = NULL;
SET @RegenerateRDLOnCoSignature = 'Y';
SET @RecreatePDFOnClientSignature = 'Y';
SET @DSMV = NULL

SELECT @FormCollectionId = FormCollectionId from FormCollectionForms FCF
JOIN Forms F ON F.FormId = FCF.FormId
WHERE F.FormName = 'CoreDast'
AND ISNULL(F.RecordDeleted, 'N') = 'N' 
AND ISNULL(FCF.RecordDeleted, 'N') = 'N'

IF NOT EXISTS (
		SELECT DocumentCodeId
		FROM DocumentCodes
		WHERE DocumentCodeId = @DocumentCodeId
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
		,FormCollectionId
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
		,@FormCollectionId
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
		,DSMV = @DSMV
		,FormCollectionId = @FormCollectionId
		,RecordDeleted = NULL
	WHERE DocumentCodeId = @DocumentCodeId
END

IF NOT EXISTS (
		SELECT ScreenId
		FROM Screens
		WHERE DocumentCodeId = @DocumentCodeId
		)
BEGIN

	INSERT INTO [Screens] (
		[ScreenName]
		,[ScreenType]
		,[ScreenURL]
		,[TabId]
		,[DocumentCodeId]
		,[InitializationStoredProcedure]
		,[ValidationStoredProcedureComplete]
		,[WarningStoredProcedureComplete]
		,[PostUpdateStoredProcedure]
		,[Code]
		)
	VALUES (
		@ScreenName
		,@ScreenType
		,@ScreenURL
		,@TabId
		,@DocumentCodeId
		,@InitializationStoredProcedure
		,@ValidationStoredProcedureComplete
		,@WarningStoredProcedureComplete
		,@PostUpdateStoredProcedure
		,@ScreenCode
		)
		
 SET @ScreenId = SCOPE_IDENTITY()

END
ELSE
BEGIN
	UPDATE Screens
	SET screenname = @ScreenName
		,screentype = @ScreenType
		,screenurl = @ScreenURL
		,TabId = @TabId
		,InitializationStoredProcedure = @InitializationStoredProcedure
		,ValidationStoredProcedureComplete = @ValidationStoredProcedureComplete
		,WarningStoredProcedureComplete = @WarningStoredProcedureComplete
		,PostUpdateStoredProcedure = @PostUpdateStoredProcedure
		,RecordDeleted = NULL
		,Code = @ScreenCode
	WHERE DocumentCodeId = @DocumentCodeId
	
	SELECT @ScreenId = ScreenId
	FROM Screens 
	WHERE DocumentCodeId = @DocumentCodeId
	
END

--Banners Table Entry
IF NOT EXISTS(
		SELECT ScreenId
		FROM Banners 
		WHERE ScreenId = @ScreenId
		)
BEGIN
	INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,ParentBannerId)
	VALUES(@ScreenName,@ScreenName,'Y',1,'N',2,@ScreenId,NULL)
	
END

GO

