/*Delcare variables*/
DECLARE @DocumentCodeId int
DECLARE @ScreenId int
DECLARE @BannerID int

/*Set variables*/
SET @DocumentCodeId=10036
SET @ScreenId=10970

-------FormCollections----------
Set Identity_Insert FormCollections ON
if(not exists(select FormCollectionID from FormCollections where FormCollectionID=34))
	insert into FormCollections(FormCollectionID,NumberOfForms)
	Values(34,2)
Set Identity_Insert FormCollections OFF

/*Document Codes Insert Script*/
IF(NOT EXISTS(SELECT DocumentCodeId FROM DocumentCodes WHERE DocumentCodeId=@DocumentCodeId ))
BEGIN
	SET IDENTITY_INSERT [dbo].[DocumentCodes] ON
	INSERT INTO [DocumentCodes] ([DocumentCodeId],[DocumentName],[DocumentDescription],[DocumentType],[Active],[ServiceNote],[ViewDocumentURL],[ViewDocumentRDL],[StoredProcedure],[TableList],[RequiresSignature],[FormCollectionId],[ViewStoredProcedure])
	VALUES(@DocumentCodeId,'CustomDocumentFABIPs',NULL,10,'Y','N','CustomDocumentFABIPsReport','CustomDocumentFABIPsReport','csp_SCGetCustomDocumentFABIPs','CustomDocumentFABIPs','Y',34,'csp_SCGetCustomDocumentFABIPsRDL')
	SET IDENTITY_INSERT [dbo].[DocumentCodes] OFF

END


/*Screens Insert Script*/
IF(NOT EXISTS(SELECT * FROM [Screens] WHERE [ScreenId] = @ScreenId ))
BEGIN
	SET IDENTITY_INSERT [dbo].[Screens] ON
	INSERT INTO [Screens] ([ScreenId],[ScreenName],[ScreenType],[ScreenURL],[ScreenToolbarURL],[TabId],[InitializationStoredProcedure],[ValidationStoredProcedureUpdate],[ValidationStoredProcedureComplete],[PostUpdateStoredProcedure],[RefreshPermissionsAfterUpdate],[DocumentCodeId],[CustomFieldFormId])
	VALUES(@ScreenId,'FBA/BIP',5763,'/Custom/FBABIP/WebPages/FBABIPGeneral.ascx',NULL,2,'csp_InitCustomDocumentFABIPs',NULL,'csp_validateCustomDocumentFABIPs',NULL,NULL,@DocumentCodeId,NULL)
	SET IDENTITY_INSERT [dbo].[Screens] OFF
END

/*Banners Insert Script*/
IF(NOT EXISTS(SELECT BannerId from Banners where screenid=@ScreenId))
begin
INSERT INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ParentBannerId,ScreenId)
VALUES('FBA / BIP', 'FBA / BIP','Y',1,'N',2,null,@ScreenId)
end



----------------GlobalCodeCategories--------------------

 
  IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE Category='XFABIPTYPE'))
  BEGIN
	  insert into GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement,UsedInCareManagement,ExternalReferenceId)
	  values('XFABIPTYPE','XFABIPTYPE','Y','Y','Y','Y',NULL,'N','N',NULL,NULL,NULL)
  END
  
  IF(NOT EXISTS(SELECT Category FROM GlobalCodeCategories WHERE Category='XFABIPTBSTATUS'))
  BEGIN
	  insert into GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement,UsedInCareManagement,ExternalReferenceId)
	  values('XFABIPTBSTATUS','XFABIPTBSTATUS','Y','Y','Y','Y',NULL,'N','N',NULL,NULL,NULL)
  END
  
  ---------------GlobalCodes---------------------------

  IF(NOT EXISTS(SELECT * FROM GlobalCodes WHERE Code='INITIAL' and Category='XFABIPTYPE'))
  BEGIN
  
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder)
  VALUES('XFABIPTYPE','Initial','INITIAL',NULL,'Y',1)

  END
  
  IF(NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='QUARTERLY' AND Category='XFABIPTYPE'))
  BEGIN
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder)
  VALUES('XFABIPTYPE','Quarterly','QUARTERLY',NULL,'Y',2)
  END
  
  IF(NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='ANNUAL' AND Category='XFABIPTYPE'))
  BEGIN
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder)
  VALUES('XFABIPTYPE','Annual','ANNUAL',NULL,'Y',3)
  END
  
    
  IF(NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='ACTIVE' AND Category='XFABIPTBSTATUS'))
  BEGIN
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder)
  VALUES('XFABIPTBSTATUS','Active','ACTIVE',NULL,'Y',1)
  END
  
  IF(NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='COMPLETE' AND Category='XFABIPTBSTATUS'))
  BEGIN
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder)
  VALUES('XFABIPTBSTATUS','Complete','COMPLETE',NULL,'Y',2)
  END

----------------------------------Global COde--Categories--------------------------------------------------

 If Not Exists(Select Category From GlobalCodeCategories Where Category='XFABIPRESTRAINTS')
 Begin
        INSERT INTO dbo.GlobalCodeCategories
		        ( 
		          Category ,
		          CategoryName ,
		          Active ,
		          AllowAddDelete ,
		          AllowCodeNameEdit ,
		          AllowSortOrderEdit ,
		          Description ,
		          UserDefinedCategory ,
		          HasSubcodes
		        )
		VALUES  ( 
				  'XFABIPRESTRAINTS' , -- Category - char(20)
		          'Test Prestraints' , -- CategoryName - varchar(250)
		          'Y' , -- Active - type_Active
		          'N' , -- AllowAddDelete - type_YOrN
		          'Y' , -- AllowCodeNameEdit - type_YOrN
		          'Y' , -- AllowSortOrderEdit - type_YOrN
		          NULL , -- Description - type_Comment
		          'N' , -- UserDefinedCategory - type_YOrN
		          'N'  -- HasSubcodes - type_YOrN
		          )
	END	         




  