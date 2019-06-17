/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Purpose: make entries to Screens,DocumentCodes,Banners and DocumentNavigations .          
--          
-- Author:  Vichee         
-- Date:    13/Mar/2015 

/* Updates:                                                          */    
/*   Date             Author         Purpose                                    */    
    11/Mar/2015      Vichee  Created                              
/*********************************************************************/         
*********************************************************************************/

--Script To Insert Into DocumentCodes 
 SET IDENTITY_INSERT DocumentCodes ON
IF NOT EXISTS(SELECT * FROM DocumentCodes WHERE DocumentCodeId = 113)
BEGIN
INSERT INTO DocumentCodes (DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote,OnlyAvailableOnline,ViewDocumentURL,ViewDocumentRDL,StoredProcedure,TableList,RequiresSignature,ViewStoredProcedure,AllowEditingByNonAuthors,MultipleCredentials,RecreatePDFOnClientSignature,DefaultCoSigner,DefaultGuardian)
VALUES (113,'CAFAS®','',10,'Y','N','N','RDLCAFAS','RDLCAFAS','csp_SCGetCAFAS','CustomCAFAS','Y','csp_RDLCustomCAFAS','N','Y','Y','Y','Y')
END
ELSE
BEGIN
UPDATE DocumentCodes
SET DocumentName='CAFAS®',
DocumentDescription='',
DocumentType=10,
Active='Y',
ServiceNote='N',
OnlyAvailableOnline='N',
ViewDocumentURL='RDLCAFAS',
ViewDocumentRDL='RDLCAFAS',
StoredProcedure='csp_SCGetCAFAS',
TableList='CustomCAFAS',
RequiresSignature='Y',
ViewStoredProcedure='csp_RDLCustomCAFAS',
AllowEditingByNonAuthors='N',
MultipleCredentials='Y',
RecreatePDFOnClientSignature='Y',
DefaultCoSigner='Y',
DefaultGuardian='Y'
WHERE DocumentCodeId = 113
END
 SET IDENTITY_INSERT DocumentCodes OFF
 
--Script to Enter into Screens Table
 SET IDENTITY_INSERT Screens ON   
 IF NOT EXISTS(SELECT * FROM Screens WHERE ScreenId = 10004)
 BEGIN
 INSERT INTO [Screens] (ScreenId ,[ScreenName],[ScreenType],[ScreenURL],[TabId],[InitializationStoredProcedure],[ValidationStoredProcedureComplete],PostUpdateStoredProcedure,DocumentCodeId)
	VALUES (10004, 'CAFAS®' , 5763 , '/ActivityPages/Client/Detail/Documents/CAFAS.ascx' , 2,'csp_InitCustomCAFASStandardInitialization','csp_validateCustomCAFAS','',113)
	
 END
 ELSE
 BEGIN
	UPDATE Screens 
	SET ScreenName='CAFAS®',
	ScreenType=5763,
	ScreenURL='/ActivityPages/Client/Detail/Documents/CAFAS.ascx',
	TabId=2,
	InitializationStoredProcedure='csp_InitCustomCAFASStandardInitialization',
	ValidationStoredProcedureComplete='csp_validateCustomCAFAS',
	PostUpdateStoredProcedure='',
	DocumentCodeId=113
	WHERE ScreenId=10004;
 END
  SET IDENTITY_INSERT Screens OFF
  
    
  --Banners Table Entry
  DECLARE @bannerid int
--IF EXISTS(SELECT 1 FROM Banners WHERE BannerName='Release of Information')
--BEGIN
--	UPDATE Banners SET RecordDeleted='Y' WHERE BannerName='Release of Information' AND  ScreenId!=20045
--END

IF Not EXISTS(SELECT 1 FROM Banners WHERE ScreenId=10004)
BEGIN
	INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,ParentBannerId)
	Values('CAFAS®','CAFAS®','N',1,'N',2,10004,21)
	SET @bannerid=@@IDENTITY
END


IF NOT EXISTS (SELECT 1 FROM [DocumentNavigations] WHERE screenid=10004)
BEGIN
INSERT INTO [DocumentNavigations]([NavigationName],[DisplayAs],[Active]
           ,[ParentDocumentNavigationId],[BannerId],[ScreenId])
     VALUES('CAFAS®','CAFAS®','Y',null,@bannerid,10004)
 END 
