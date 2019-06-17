/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Purpose: make entries to Screens,DocumentCodes,Banners and DocumentNavigations .          
--          
-- Author:  Vichee         
-- Date:    11/Mar/2015 

/* Updates:                                                          */    
/*   Date             Author         Purpose                                    */    
    11/Mar/2015      Vichee  Created                              
/*********************************************************************/         
*********************************************************************************/

--Script To Insert Into DocumentCodes 
 SET IDENTITY_INSERT DocumentCodes ON
IF NOT EXISTS(SELECT * FROM DocumentCodes WHERE DocumentCodeId = 10037)
BEGIN
INSERT INTO DocumentCodes (DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,RequiresSignature,ViewStoredProcedure,AllowEditingByNonAuthors,MultipleCredentials,RecreatePDFOnClientSignature,DefaultCoSigner,DefaultGuardian)
VALUES (10037,'Informed Consent','Informed Consent',10,'Y','N','N','RDLCustomDocumentInformedConsents','RDLCustomDocumentInformedConsents','csp_SCGetCustomDocumentInformedConsents','CustomDocumentInformedConsents','Y','csp_RDLGetCustomDocumentInformedConsents','N','Y','Y','Y','Y')
END
ELSE
BEGIN
UPDATE DocumentCodes
SET DocumentName='Informed Consent',
DocumentDescription='Informed Consent',
DocumentType=10,
Active='Y',
ServiceNote='N',
OnlyAvailableOnline='N',
ViewDocumentURL='RDLCustomDocumentInformedConsents',
ViewDocumentRDL='RDLCustomDocumentInformedConsents',
StoredProcedure='csp_SCGetCustomDocumentInformedConsents',
TableList='CustomDocumentInformedConsents',
RequiresSignature='Y',
ViewStoredProcedure='csp_RDLGetCustomDocumentInformedConsents',
AllowEditingByNonAuthors='N',
MultipleCredentials='Y',
RecreatePDFOnClientSignature='Y',
DefaultCoSigner='Y',
DefaultGuardian='Y'
WHERE DocumentCodeId = 10037
END
 SET IDENTITY_INSERT DocumentCodes OFF
 
--Script to Enter into Screens Table
 SET IDENTITY_INSERT Screens ON   
 IF NOT EXISTS(SELECT * FROM Screens WHERE ScreenId = 10975 )
 BEGIN
 INSERT INTO [Screens] (ScreenId ,[ScreenName],[ScreenType],[ScreenURL],[TabId],[InitializationStoredProcedure],[ValidationStoredProcedureComplete],PostUpdateStoredProcedure,DocumentCodeId)
	VALUES (10975, 'Informed Consent' , 5763 , '/Custom/InformedConsent/WebPages/CustomInformedConsents.ascx' , 2,'csp_InitCustomDocumentInformedConsents','','csp_SCPostUpdateCustomDocumentInformedConsents',10037)
	
 END
 ELSE
 BEGIN
	UPDATE Screens 
	SET ScreenName='Informed Consent',
	ScreenType=5763,
	ScreenURL='/Custom/InformedConsent/WebPages/CustomInformedConsents.ascx',
	TabId=2,
	InitializationStoredProcedure='csp_InitCustomDocumentInformedConsents',
	ValidationStoredProcedureComplete='',
	PostUpdateStoredProcedure='csp_SCPostUpdateCustomDocumentInformedConsents',
	DocumentCodeId=10037
	WHERE ScreenId=10975;
 END
  SET IDENTITY_INSERT Screens OFF
  
    
  --Banners Table Entry
  DECLARE @bannerid int
--IF EXISTS(SELECT 1 FROM Banners WHERE BannerName='Release of Information')
--BEGIN
--	UPDATE Banners SET RecordDeleted='Y' WHERE BannerName='Release of Information' AND  ScreenId!=20045
--END

IF Not EXISTS(SELECT 1 FROM Banners WHERE ScreenId=20045)
BEGIN
	INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,ParentBannerId)
	Values('Informed Consent','Informed Consent','N',1,'N',2,10975,21)
	SET @bannerid=@@IDENTITY
END


IF NOT EXISTS (SELECT 1 FROM [DocumentNavigations] WHERE screenid=10975)
BEGIN
INSERT INTO [DocumentNavigations]([NavigationName],[DisplayAs],[Active]
           ,[ParentDocumentNavigationId],[BannerId],[ScreenId])
     VALUES('Informed Consent','Informed Consent','Y',null,@bannerid,10975)
 END 
