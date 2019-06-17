-- *********************************************************************************/ 
-- Author: Bernardin		
-- Create date: 02/02/2015 
-- Description:	DocumentCodes,Screens,Banners entry for "Individual Service Note". 
--*********************************************************************************/ 

DECLARE @TabId INT 
DECLARE @ClientTabId INT 
DECLARE @CustomScreenId INT 
DECLARE @CustomScreenType INT 
DECLARE @CustomScreenDesc VARCHAR(64) 
DECLARE @CustomScreenURL VARCHAR(200) 
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
SET @TabId = 2 

----------------------------------------   DocumentCodes Table   -----------------------------------  
DECLARE @DocumentCodeId INT 
DECLARE @TableList VARCHAR(1000)
DECLARE @GetDataSp VARCHAR(500)
DECLARE @ViewStoredProcedure VARCHAR(500)
DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)
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

SET @DocumentCodeId =11145
SET @TableList = 'CustomDocumentIndividualServiceNoteGenerals,CustomDocumentDBTs,CustomIndividualServiceNoteGoals,CustomIndividualServiceNoteObjectives,CustomIndividualServiceNoteDiagnoses'
SET @ViewStoredProcedure = 'csp_RDLCustomDocumentIndividualServiceNote' 
SET @ViewDocumentURL = 'RDLIndividualServiceNote'
SET @ViewDocumentRDL = 'RDLIndividualServiceNote'
SET @DocumentName = 'Individual Service Note' 
SET @InitializationProcess = ''
SET @DocumentType = 10 
SET @Active = 'Y' 
SET @ServiceNote = 'Y' 
SET @PatientConsent = NULL 
SET @OnlyAvailableOnline = 'Y' 
SET @RequiresSignature = 'Y' 
SET @ViewOnlyDocument= NULL 
SET @DocumentURL= NULL 
SET @ToBeInitialized= NULL 
SET @GetDataSp = 'csp_GetCustomDocumentIndividualServiceNote'

IF NOT EXISTS (SELECT DocumentCodeId 
               FROM   DocumentCodes 
               WHERE  DocumentCodeId = @DocumentCodeId) 
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
                   [InitializationProcess]) 
      VALUES      ( @DocumentCodeId, 
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
                    @InitializationProcess ) 

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
             StoredProcedure = @GetDataSp, 
             TableList = @TableList, 
             RequiresSignature = @RequiresSignature, 
             ViewOnlyDocument = @ViewOnlyDocument, 
             DocumentURL = @DocumentURL, 
             ToBeInitialized = @ToBeInitialized, 
             ViewStoredProcedure = @ViewStoredProcedure,
             ViewDocumentURL = @ViewDocumentURL,
			 ViewDocumentRDL = @ViewDocumentRDL,
             InitializationProcess = @InitializationProcess 
      WHERE  DocumentCodeId = @DocumentCodeId 
  END 

-----------------------------------------------END--------------------------------------------  
----------------------------------------   Screens Table   -----------------------------------  
DECLARE @ScreenId INT 
DECLARE @ScreenName VARCHAR(500) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(500) 
DECLARE @InitializationStoredProcedure VARCHAR(500) 
DECLARE @ValidationStoredProcedureUpdate VARCHAR(500) 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 
DECLARE @WarningStoredProcedureComplete VARCHAR(500) 
DECLARE @PostUpdateStoredProcedure VARCHAR(500) 
DECLARE @RefreshPermissionsAfterUpdate VARCHAR(500) 

SET @ScreenId =  11145
SET @ScreenName = 'Individual Service Note' 
SET @ScreenType = 5763 
SET @ScreenURL = '/Custom/IndividualServiceNote/WebPages/IndividualServiceNote.ascx' 
SET @InitializationStoredProcedure = 'csp_InitIndividualServiceNote'
SET @ValidationStoredProcedureUpdate = NULL
SET @ValidationStoredProcedureComplete= 'csp_ValidateIndividualServiceNote'
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
                   [WarningStoredProcedureComplete], 
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
                    @WarningStoredProcedureComplete, 
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
             ValidationStoredProcedureComplete = 
             @ValidationStoredProcedureComplete, 
             WarningStoredProcedureComplete = @WarningStoredProcedureComplete, 
             PostUpdateStoredProcedure = @PostUpdateStoredProcedure, 
             RefreshPermissionsAfterUpdate = @RefreshPermissionsAfterUpdate, 
             DocumentCodeId = @DocumentCodeId 
      WHERE  ScreenId = @ScreenId 
  END 

  
-----------------------------------------------END--------------------------------------------  
