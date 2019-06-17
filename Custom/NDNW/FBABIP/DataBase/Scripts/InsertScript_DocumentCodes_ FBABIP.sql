 -- Craeted BY      : Varinder
---  Modified Dated  : 4 Dec 2012 
--   Purpose         : FBA/BIP  Insert  for DocumentCodes, Screens and Banners   -- Task #13 Development Phase 4 (Offshore)

---Insert script for GlobalCodes added by Rahul Aneja ON 07Dec2012
if(not(Exists(select GlobalCodeId from GlobalCodes where Category='XFABIPTYPE' and  Code='ADHOC' )))
BEGIN

	INSERT INTO GlobalCodes
		(Category,CodeName,Code,Active,CannotModifyNameOrDelete,sortorder)
		values
		('XFABIPTYPE','Ad hoc','ADHOC','Y','N',4) 

END 

---Insert script for DocumentCodes--------------------

IF( NOT EXISTS(Select 1 from DocumentCodes where DocumentCodeId=10036))
BEGIN
SET IDENTITY_INSERT DocumentCodes ON 
	INSERT INTO DocumentCodes(DocumentCodeId,DocumentName,DocumentType,	Active,	ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,	RequiresSignature,FormCollectionId,	ViewStoredProcedure)
	VALUES(10036,'FBA/BIP - Restraints',10,'Y','N','N','CustomDocumentFABIPsReport','CustomDocumentFABIPsReport','csp_SCGetCustomDocumentFABIPs','CustomDocumentFABIPs','Y',34,'csp_SCGetCustomDocumentFABIPsRDL')
SET IDENTITY_INSERT DocumentCodes OFF	
END

IF( NOT EXISTS(Select 1 from DocumentCodes where DocumentCodeId=10501))
BEGIN
SET IDENTITY_INSERT DocumentCodes ON 
	INSERT INTO DocumentCodes(DocumentCodeId,DocumentName,DocumentType,	Active,	ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,	RequiresSignature,FormCollectionId,	ViewStoredProcedure)
	VALUES(10501,'FBA/BIP – Annual',10,'Y','N','Y','CustomDocumentFABIPsReport','CustomDocumentFABIPsReport','csp_SCGetCustomDocumentFABIPs','CustomDocumentFABIPs','Y',34,'csp_SCGetCustomDocumentFABIPsRDL')
SET IDENTITY_INSERT DocumentCodes OFF	
END

IF( NOT EXISTS(Select 1 from DocumentCodes where DocumentCodeId=10502))
BEGIN
SET IDENTITY_INSERT DocumentCodes ON 
	INSERT INTO DocumentCodes(DocumentCodeId,DocumentName,DocumentType,	Active,	ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,	RequiresSignature,FormCollectionId,	ViewStoredProcedure)
	VALUES(10502,'FBA/BIP – Initial',10,'Y','N','Y','CustomDocumentFABIPsReport','CustomDocumentFABIPsReport','csp_SCGetCustomDocumentFABIPs','CustomDocumentFABIPs','Y',34,'csp_SCGetCustomDocumentFABIPsRDL')
SET IDENTITY_INSERT DocumentCodes OFF	
END


IF( NOT EXISTS(Select 1 from DocumentCodes where DocumentCodeId=10503))
BEGIN
SET IDENTITY_INSERT DocumentCodes ON 
	INSERT INTO DocumentCodes(DocumentCodeId,DocumentName,DocumentType,	Active,	ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,	RequiresSignature,FormCollectionId,	ViewStoredProcedure)
	VALUES(10503,'FBA/BIP – Quarterly',10,'Y','N','Y','CustomDocumentFABIPsReport','CustomDocumentFABIPsReport','csp_SCGetCustomDocumentFABIPs','CustomDocumentFABIPs','Y',34,'csp_SCGetCustomDocumentFABIPsRDL')
SET IDENTITY_INSERT DocumentCodes OFF	
END


---Insert script for Screens--------------------
IF( NOT EXISTS(Select 1 from Screens where ScreenId=10970))
BEGIN
SET IDENTITY_INSERT Screens ON 
	INSERT INTO Screens(ScreenId,ScreenName,ScreenType,	ScreenURL,TabId,InitializationStoredProcedure,ValidationStoredProcedureComplete,DocumentCodeId,	HelpURL,KeyPhraseCategory)
	VALUES(10970,'FBA/BIP- Restraints',5763,'/Custom/FBABIP/WebPages/FBABIPGeneral.ascx',2,'csp_InitCustomDocumentFABIPs','csp_validateCustomDocumentFABIPs',10036,'../Help/overview.htm?#FBABIP_Document.htm',null)
SET IDENTITY_INSERT Screens OFF	
END
ELSE
BEGIN
	UPDATE Screens SET ScreenName='FBA/BIP- Restraints' where ScreenId=10970
END

IF( NOT EXISTS(Select 1 from Screens where ScreenId=20001))
BEGIN
SET IDENTITY_INSERT Screens ON 
	INSERT INTO Screens(ScreenId,ScreenName,ScreenType,	ScreenURL,TabId,InitializationStoredProcedure,ValidationStoredProcedureComplete,DocumentCodeId,	HelpURL,KeyPhraseCategory)
	VALUES(20001,'FBA/BIP – Initial',5763,'/Custom/FBABIP/WebPages/FBABIPGeneral.ascx',2,'csp_InitCustomDocumentFABIPs','csp_validateCustomDocumentFABIPs',10502,'../Help/overview.htm?#FBABIP_Document.htm',21139)
SET IDENTITY_INSERT Screens OFF	
END

IF( NOT EXISTS(Select 1 from Screens where ScreenId=20002))
BEGIN
SET IDENTITY_INSERT Screens ON 
	INSERT INTO Screens(ScreenId,ScreenName,ScreenType,	ScreenURL,TabId,InitializationStoredProcedure,ValidationStoredProcedureComplete,DocumentCodeId,	HelpURL,KeyPhraseCategory)
	VALUES(20002,'FBA/BIP – Quarterly',5763,'/Custom/FBABIP/WebPages/FBABIPGeneral.ascx',2,'csp_InitCustomDocumentFABIPs','csp_validateCustomDocumentFABIPs',10503,'../Help/overview.htm?#FBABIP_Document.htm',21139)
SET IDENTITY_INSERT Screens OFF	
END


IF( NOT EXISTS(Select 1 from Screens where ScreenId=20003))
BEGIN
SET IDENTITY_INSERT Screens ON 
	INSERT INTO Screens(ScreenId,ScreenName,ScreenType,	ScreenURL,TabId,InitializationStoredProcedure,ValidationStoredProcedureComplete,DocumentCodeId,	HelpURL,KeyPhraseCategory)
	VALUES(20003,'FBA/BIP – Annual',5763,'/Custom/FBABIP/WebPages/FBABIPGeneral.ascx',2,'csp_InitCustomDocumentFABIPs','csp_validateCustomDocumentFABIPs',10501,'../Help/overview.htm?#FBABIP_Document.htm',21139)
SET IDENTITY_INSERT Screens OFF	
END

---Insert script for Banners--------------------

DELETE FROM Banners WHERE BannerName LIKE 'FBA%'
DECLARE @BannerId int
INSERT INTO Banners(BannerName,	DisplayAs,	Active,	DefaultOrder,	Custom,	TabId,	ParentBannerId,	ScreenId)
           VALUES('FBA/ BIP',	'FBA/ BIP','Y',35,'N',2,21,	NULL)

SELECT @BannerId=SCOPE_IDENTITY() from Banners

INSERT INTO Banners(BannerName,	DisplayAs,	Active,	DefaultOrder,	Custom,	TabId,	ParentBannerId,	ScreenId)
           VALUES('FBA/ BIP - Initial',	'FBA/ BIP - Initial','Y',36,'N',2,@BannerId,	20001)

INSERT INTO Banners(BannerName,	DisplayAs,	Active,	DefaultOrder,	Custom,	TabId,	ParentBannerId,	ScreenId)
           VALUES('FBA/ BIP - Quarterly',	'FBA/ BIP - Quarterly','Y',37,'N',2,@BannerId,	20002)

INSERT INTO Banners(BannerName,	DisplayAs,	Active,	DefaultOrder,	Custom,	TabId,	ParentBannerId,	ScreenId)
           VALUES('FBA/ BIP - Annual',	'FBA/ BIP - Annual','Y',38,'N',2,@BannerId,	20003)

INSERT INTO Banners(BannerName,	DisplayAs,	Active,	DefaultOrder,	Custom,	TabId,	ParentBannerId,	ScreenId)
           VALUES('FBA/ BIP - Restraints',	'FBA/ BIP - Restraints','Y',39,'N',2,@BannerId,	10970)
