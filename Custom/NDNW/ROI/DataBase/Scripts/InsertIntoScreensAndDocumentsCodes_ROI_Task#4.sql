/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Purpose: make entries to Screens,DocumentCodes,Banners and DocumentNavigations table Task#656, St. Joe Support.          
--          
-- Author:  Md Hussain Khusro          
-- Date:    06/Dec/2013 

/* Updates:                                                          */    
/*   Date             Author         Purpose                                    */    
    06/Dec/2013  Md Huussain Khusro   Created                              
/*********************************************************************/         
*********************************************************************************/

--Script To Insert Into DocumentCodes 
 SET IDENTITY_INSERT DocumentCodes ON
IF NOT EXISTS(SELECT * FROM DocumentCodes WHERE DocumentCodeId = 15106)
BEGIN
INSERT INTO DocumentCodes (DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,RequiresSignature,ViewStoredProcedure,AllowEditingByNonAuthors,MultipleCredentials,RecreatePDFOnClientSignature,DefaultCoSigner,DefaultGuardian)
VALUES (15106,'Release of Information','Release of Information',10,'Y','N','N','RDLCustomReleaseOfInformation','RDLCustomReleaseOfInformation','csp_SCGetCustomDocumentElectronicReleaseOfInformation','CustomDocumentReleaseOfInformations','Y','csp_RDLCustomReleaseOfInformation','N','Y','Y','Y','Y')
END
ELSE
BEGIN
UPDATE DocumentCodes
SET DocumentName='Release of Information',
DocumentDescription='Release of Information',
DocumentType=10,
Active='Y',
ServiceNote='N',
OnlyAvailableOnline='N',
ViewDocumentURL='RDLCustomReleaseOfInformation',
ViewDocumentRDL='RDLCustomReleaseOfInformation',
StoredProcedure='csp_SCGetCustomDocumentElectronicReleaseOfInformation',
TableList='CustomDocumentReleaseOfInformations',
RequiresSignature='Y',
ViewStoredProcedure='csp_RDLCustomReleaseOfInformation',
AllowEditingByNonAuthors='N',
MultipleCredentials='Y',
RecreatePDFOnClientSignature='Y',
DefaultCoSigner='Y',
DefaultGuardian='Y'
WHERE DocumentCodeId = 15106
END
 SET IDENTITY_INSERT DocumentCodes OFF
 
--Script to Enter into Screens Table
 SET IDENTITY_INSERT Screens ON
 IF NOT EXISTS(SELECT * FROM Screens WHERE ScreenId = 20045 )
 BEGIN
 INSERT INTO [Screens] (ScreenId ,[ScreenName],[ScreenType],[ScreenURL],[TabId],[InitializationStoredProcedure],[ValidationStoredProcedureComplete],PostUpdateStoredProcedure,DocumentCodeId)
	VALUES (20045, 'Release of Information' , 5763 , '/Custom/ROI/WebPages/ElectronicReleaseOfInformation.ascx' , 2,'csp_SCInitCustomDocumentElectronicReleaseOfInformation','csp_validateCustomReleaseOfInformation','csp_SCPostSignatureUpdateReleaseOfInformation',15106)
	
 END
 ELSE
 BEGIN
	UPDATE Screens 
	SET ScreenName='Release of Information',
	ScreenType=5763,
	ScreenURL='/Custom/ROI/WebPages/ElectronicReleaseOfInformation.ascx',
	TabId=2,
	InitializationStoredProcedure='csp_SCInitCustomDocumentElectronicReleaseOfInformation',
	ValidationStoredProcedureComplete='csp_validateCustomReleaseOfInformation',
	PostUpdateStoredProcedure='csp_SCPostSignatureUpdateReleaseOfInformation',
	DocumentCodeId=15106
	WHERE ScreenId=20045;
 END
  SET IDENTITY_INSERT Screens OFF
  
    
  --Banners Table Entry
  DECLARE @bannerid int
--IF EXISTS(SELECT 1 FROM Banners WHERE BannerName='Release of Information')
--BEGIN
--	UPDATE Banners SET RecordDeleted='Y' WHERE BannerName='Release of Information' AND  ScreenId!=20045
--END
SET IDENTITY_INSERT Banners ON
IF Not EXISTS(SELECT 1 FROM Banners WHERE ScreenId=20045)
BEGIN
	INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,ParentBannerId)
	Values('Release of Information','Release of Information','N',1,'N',2,20045,21)
	SET @bannerid=@@IDENTITY
END
SET IDENTITY_INSERT Banners OFF

IF NOT EXISTS (SELECT 1 FROM [DocumentNavigations] WHERE screenid=20045)
BEGIN
INSERT INTO [DocumentNavigations]([NavigationName],[DisplayAs],[Active]
           ,[ParentDocumentNavigationId],[BannerId],[ScreenId])
     VALUES('Release of Information','Release of Information','Y',null,@bannerid,20045)
 END 
