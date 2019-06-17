/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Service Note-Psychiatric Service"
-- Purpose: Script to add entries in Screens and DocumentCodes table for Task #823 - Woods Customizations. 
--  
-- Author:  Dhanil Manuel
-- Date:    12-18-2014
--  
-- *****History****  
--Created by Dhanil during development task #823

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

SET @DocumentCodeId = 21300
SET @ScreenId = 21300
SET @ScreenType = 5763
SET @DocumentType = 10
SET @Active = 'Y'
SET @ScreenName = 'Psychiatric Service Note'
SET @DocumentName = 'Psychiatric Service Note'
SET @ScreenURL = '/Custom/PsychiatricService/WebPages/PsychiatricServiceNote.ascx'
SET @TableList = 'CustomDocumentPsychiatricServiceNoteGenerals,CustomDocumentPsychiatricServiceNoteHistory,CustomPsychiatricServiceNoteProblems,CustomDocumentPsychiatricServiceNoteExams,CustomDocumentPsychiatricServiceNoteMDMs,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions'
SET @RDLName = 'RDLCustomPsychiatricServiceNotes'
SET @ViewStoredProcedure = 'csp_RDLCustomPsychiatricServiceNotes'
SET @GetDataSp = 'csp_SCGetPsychiatricServiceNote'
SET @InitializationStoredProcedure = 'csp_InitPsychiatricServiceNote'
SET @ValidationStoredProcedureComplete = null;
SET @PostUpdateStoredProcedure = NULL 
SET @TabId = 2
SET @ServiceNote = 'Y'
SET @OnlyAvailableOnline = 'N'
SET @RequiresSignature = 'Y'
SET @AllowEditingByNonAuthors = 'N'
SET @DefaultCoSigner = 'Y'
SET @DefaultGuardian = 'N'
set @NewValidationStoredProcedure = null;
set @ValidationStoredProcedure = 'csp_ValidateCustomDocumentPsychiatricServiceNote';
set @DiagnosisDocument = 'Y';
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

--IF NOT EXISTS (
--		SELECT *
--		FROM dbo.Banners
--		WHERE ScreenId = @ScreenId
--		)
--BEGIN
--	INSERT dbo.Banners (
--		BannerName
--		,DisplayAs
--		,Active
--		,DefaultOrder
--		,Custom
--		,TabId
--		,ParentBannerId
--		,ScreenId
--		)
--	VALUES (
--		@ScreenName
--		,-- BannerName - varchar(100)
--		@ScreenName
--		,-- DisplayAs - varchar(100)
--		'Y'
--		,-- Active - type_Active
--		1
--		,-- DefaultOrder - int
--		'Y'
--		,-- Custom - type_YOrN
--		2
--		,-- TabId - int
--		21
--		,-- ParentBannerId - int --check
--		@ScreenId -- ScreenId - int
--		)
--END
--ELSE
--BEGIN
--	UPDATE Banners
--	SET BannerName = @ScreenName
--		,DisplayAs = @ScreenName
--		,Active = 'Y'
--		,DefaultOrder = 1
--		,Custom = 'Y'
--		,TabId = 2
--		,ParentBannerId = 21
--		,ScreenId = @ScreenId
--	WHERE BannerName = @ScreenName
--END

IF NOT EXISTS (
		SELECT *
		FROM dbo.Screens
		WHERE ScreenId =22301
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
		)
	VALUES (
		 22301
		,'Progress Report Initial'
		,5763
		,'/Custom/PsychiatricService/WebPages/PsychiatricServiceGeneral.ascx'
		,2
		,null
		)
		

SET IDENTITY_INSERT Screens OFF
end
else
begin
update Screens set DocumentCodeId = null where ScreenId = 22301
end
