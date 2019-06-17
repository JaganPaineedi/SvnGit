/******************************************************************************                        
**  Name: Insert Script for Documentcodes / Screens for Urinalysis Note                   
**  Desc: A Renewed Mind - Customizations Task#21 Urinalysis Service Note  
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:          Author:          Description:    
    10/07/2013     Manju P          Insert script for Documentcodes / Screens        
*******************************************************************************/ 


IF NOT EXISTS (SELECT * FROM DocumentCodes WHERE DocumentCodeId = 1000408) 
BEGIN 
	SET IDENTITY_INSERT dbo.documentcodes ON 
	insert into documentcodes (DocumentCodeId,CreatedBy,ModifiedBy,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote ,PatientConsent ,OnlyAvailableOnline ,ImageFormatType ,DefaultImageFolderId ,ViewDocumentURL ,ViewDocumentRDL ,StoredProcedure ,TableList ,RequiresSignature ,ViewOnlyDocument ,DocumentSchema ,DocumentHTML ,DocumentURL ,ToBeInitialized ,InitializationProcess ,InitializationStoredProcedure ,FormCollectionId ,ValidationStoredProcedure ,ViewStoredProcedure ,MetadataFormId ,TextTemplate ,RequiresLicensedSignature ,ReviewFormId ,MedicationReconciliationDocument) 
	                      values(1000408,'sa','sa','Urinalysis Note','Urinalysis Note',10,'Y','Y',NULL,'N',NULL,NULL,'RDLCustomDocumentUrinalysisNote','RDLCustomDocumentUrinalysisNote','csp_SCGetCustomDocumentUrinalysisNote','CustomDocumentUrinalysis','Y',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'csp_RDLCustomDocumentUrinalysisNote',NULL,NULL,'N',NULL, NULL) 
	SET IDENTITY_INSERT dbo.documentcodes OFF 
END


IF NOT EXISTS (SELECT * FROM screens WHERE ScreenId = 1000408) 
BEGIN 
	SET IDENTITY_INSERT dbo.Screens ON 
	INSERT INTO screens (ScreenId,ScreenName,ScreenType,ScreenURL,ScreenToolbarURL,TabId, InitializationStoredProcedure,ValidationStoredProcedureUpdate, ValidationStoredProcedureComplete, WarningStoredProcedureComplete, PostUpdateStoredProcedure, RefreshPermissionsAfterUpdate, DocumentCodeId, CustomFieldFormId, HelpURL, MessageReferenceType, PrimaryKeyName, WarningStoreProcedureUpdate  )
		values(1000408,'Urinalysis Note',5763,'/Custom/Urinalysis/WebPages/UrinalysisNotes.ascx',NULL,2,'csp_InitCustomDocumentUrinalysisNote',NULL,'csp_ValidateCustomUrinalysisNotes',NULL,NULL,NULL,1000408,NULL,NULL,NULL,NULL,NULL)
	SET IDENTITY_INSERT dbo.Screens OFF  
END


