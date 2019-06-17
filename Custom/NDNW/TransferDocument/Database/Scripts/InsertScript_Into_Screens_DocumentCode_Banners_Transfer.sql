--Document Codes Entry
--Created by Vamsi
--ScreenId=11006 and DocumentCodeId=16106


SET IDENTITY_INSERT Documentcodes ON
IF Not EXISTS(SELECT * FROM Documentcodes WHERE DocumentcodeId=16106)
Insert Into Documentcodes(DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote,PatientConsent,OnlyAvailableOnline,
StoredProcedure,TableList,RequiresSignature,ViewOnlyDocument,DocumentURL,ToBeInitialized,InitializationProcess,ViewDocumentURL,
ViewDocumentRDL,InitializationStoredProcedure,ViewStoredProcedure)
Values(16106,'Transfer Document','Transfer Document',10,'Y','N','N','N','csp_GetCustomDocumentTransfer',
'CustomDocumentTransfers,CustomTransferServices'
,'Y','N','N','N',null,'RDLTransferDocument','RDLTransferDocument',null,'csp_RDLCustomDocumentTransferForm')
else
update DocumentCodes set
DocumentName='Transfer Document',
DocumentDescription='Transfer Document',
DocumentType=10,
Active='Y',
ServiceNote='N',
PatientConsent='N',
OnlyAvailableOnline='N',
StoredProcedure='csp_GetCustomDocumentTransfer',TableList='CustomDocumentTransfers,CustomTransferServices',
RequiresSignature='Y',
ViewOnlyDocument='N',DocumentURL='N',ToBeInitialized='N',InitializationProcess=null,ViewDocumentURL='RDLTransferDocument',
ViewDocumentRDL='RDLTransferDocument',InitializationStoredProcedure=null,ViewStoredProcedure='csp_RDLCustomDocumentTransferForm'
 WHERE DocumentcodeId=16106
SET IDENTITY_INSERT Documentcodes OFF

go
--Screens Table Entry
SET IDENTITY_INSERT Screens on
IF Not EXISTS(SELECT ScreenId FROM Screens WHERE ScreenId=11006)
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId,DocumentCodeId,InitializationStoredProcedure,ValidationStoredProcedureComplete,PostUpdateStoredProcedure,RefreshPermissionsAfterUpdate)
	VALUES 
	(11006,'Transfer Document',5763,'/Custom/TransferDocument/WebPages/TransferFormSender.ascx',2,16106,null,'csp_ValidateCustomDocumentTransfers','csp_CustomDocumentTransferWorkflow','Y')
	else
	update Screens set
	ScreenName='Transfer Document',
	ScreenType=5763,
	ScreenURL='/Custom/TransferDocument/WebPages/TransferFormSender.ascx',
	Documentcodeid=16106,
	ValidationStoredProcedureComplete='csp_ValidateCustomDocumentTransfers',
	PostUpdateStoredProcedure='csp_CustomDocumentTransferWorkflow',
	RefreshPermissionsAfterUpdate='Y',
	TabId=2,
	InitializationStoredProcedure=null
	where ScreenId=11006
SET IDENTITY_INSERT Screens off

go 

--Banners Table Entry
IF Not EXISTS(SELECT ScreenId FROM Banners WHERE ScreenId=11006)
Insert INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,ParentBannerId)
Values('Transfer Document','Transfer Document','Y',11,'Y',2,11006,21)
else
Update Banners set 
BannerName='Transfer Document',
DisplayAs='Transfer Document',
Active='Y',
DefaultOrder=11,
Custom='Y',
TabId=2,
ParentBannerId=21
 WHERE ScreenId=10021
GO
