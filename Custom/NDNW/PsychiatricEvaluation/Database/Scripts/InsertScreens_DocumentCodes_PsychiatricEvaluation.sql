/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Evaluation Service Note"
-- Purpose: Script to add entries in Screens and DocumentCodes table for Task #822 - Woods Customizations. 
--  
-- Author:  Akwinass
-- Date:    06-JAN-2015
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

SET @DocumentCodeId = 21400
SET @ScreenId = 21400
SET @ScreenType = 5763
SET @DocumentType = 10
SET @Active = 'Y'
SET @ScreenName = 'Psychiatric Evaluation'
SET @DocumentName = 'Psychiatric Evaluation'
SET @ScreenURL = '/Custom/PsychiatricEvaluation/WebPages/PsychiatricEvaluation.ascx'
SET @TableList = 'CustomDocumentPsychiatricEvaluations,CustomPsychiatricEvaluationProblems,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions'
SET @RDLName = 'RDLCustomPsychiatricEvaluation'
SET @ViewStoredProcedure = 'csp_RDLPsychiatricEvaluation'
SET @GetDataSp = 'csp_SCGetPsychiatricEvaluation'
SET @InitializationStoredProcedure = 'csp_InitPsychiatricEvaluation'
SET @ValidationStoredProcedureComplete = NULL;
SET @PostUpdateStoredProcedure = NULL
SET @TabId = 2
SET @ServiceNote = 'Y'
SET @OnlyAvailableOnline = 'N'
SET @RequiresSignature = 'Y'
SET @AllowEditingByNonAuthors = 'N'
SET @DefaultCoSigner = 'Y'
SET @DefaultGuardian = 'N'
SET @NewValidationStoredProcedure = NULL;
SET @ValidationStoredProcedure = 'csp_ValidateCustomDocumentPsychiatricEvaluation';
SET @DiagnosisDocument = 'Y';
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

IF NOT EXISTS (
		SELECT *
		FROM dbo.Screens
		WHERE ScreenId = 22401
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
		22401
		,'Progress Report Initial'
		,5763
		,'/Custom/PsychiatricEvaluation/WebPages/General.ascx'
		,2
		,NULL
		)

	SET IDENTITY_INSERT Screens OFF
END
ELSE
BEGIN
	UPDATE Screens
	SET DocumentCodeId = NULL
	WHERE ScreenId = 22401
END