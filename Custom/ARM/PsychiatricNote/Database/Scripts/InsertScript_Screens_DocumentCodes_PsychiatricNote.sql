/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose:   Adding Screen and DocumentCodes items for New Service Note called Psychiatric Note .
   
-- Author:  Lakshmi Kanth
-- Date:    13-11-2015   


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
DECLARE @DiagnosisDocument CHAR(1) 
DECLARE @DSMV CHAR(1)
SET @documentCodeId = 60000
SET @DocumentName = 'Psychiatric Note'
SET @DocumentType = 10  
SET @Active = 'Y' 
SET @ServiceNote = 'Y' --For ServiceNote set this to 'Y'
SET @PatientConsent = NULL 
SET @OnlyAvailableOnline = 'N' 
SET @ViewDocumentURL = 'RDLCustomPsychiatricNotes'
SET @ViewDocumentRDL = 'RDLCustomPsychiatricNotes'
SET @GetDataSp =  'csp_SCGetPsychiatricNote'
SET @TableList = 'CustomDocumentPsychiatricNoteGenerals,CustomPsychiatricNoteProblems,ExternalReferralProviders,CustomPsychiatricPCPProviders,CustomDocumentPsychiatricNoteExams,CustomDocumentPsychiatricNoteMDMs,CustomDocumentPsychiatricAIMSs,CustomDocumentPsychiatricNoteChildAdolescents,DocumentDiagnosisCodes,DocumentDiagnosis,DocumentDiagnosisFactors,NoteEMCodeOptions'
SET @RequiresSignature = 'Y' 
SET @ViewOnlyDocument= NULL 
SET @DocumentURL= NULL 
SET @ToBeInitialized= NULL
SET @InitializationProcess = NULL 
SET @InitializationStoredProcedure=''
SET @ValidationStoredProcedure='csp_ValidateCustomDocumentPsychiatricNote'
SET @ViewStoredProcedure = 'csp_RDLPsychiatricNotes'
SET @RequiresLicensedSignature = NULL
SET @DiagnosisDocument = 'Y'
SET @DSMV='Y'


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
                   RequiresLicensedSignature,
                   DiagnosisDocument,
                   DSMV
                   ) 
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
                    @RequiresLicensedSignature,
                    @DiagnosisDocument,
                    @DSMV) 

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
             RequiresLicensedSignature = @RequiresLicensedSignature,
             DiagnosisDocument = @DiagnosisDocument,
             DSMV = @DSMV
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

SET @ScreenId = 60000
SET @ScreenName = 'Psychiatric Note' 
SET @ScreenType = 5763 
SET @ScreenURL = '/Custom/PsychiatricNote/WebPages/PsychiatricNote.ascx' 
SET @InitializationStoredProcedure = 'csp_InitPsychiatricNote' 
SET @ValidationStoredProcedureUpdate = NULL 
SET @ValidationStoredProcedureComplete=  'csp_ValidateCustomDocumentPsychiatricNote' 
SET @WarningStoredProcedureComplete= NULL
SET @PostUpdateStoredProcedure= 'csp_PostUpdatePsychaitricNote'
SET @RefreshPermissionsAfterUpdate= NULL 
SET @documentCodeId = 60000

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
  IF NOT EXISTS (
		SELECT *
		FROM dbo.Screens
		WHERE ScreenId =60001
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
		 60001
		,'Scale'
		,5765
		,'Custom/PsychiatricNote/WebPages/PsychiatricNoteProblemPopup.ascx'
		,2
		,null
		)
SET IDENTITY_INSERT Screens OFF		
END
  

