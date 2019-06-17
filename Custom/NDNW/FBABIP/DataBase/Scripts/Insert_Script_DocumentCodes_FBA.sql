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
VALUES('FBA / BIP', 'FBA / BIP','Y',1,'N',2,21,@ScreenId)
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
  --SET IDENTITY_INSERT GlobalCodes ON
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

  IF(NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='IS' AND Category='XFABIPRESTRAINTS'))
  BEGIN
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
  VALUES('XFABIPRESTRAINTS','is','IS',NULL,'Y',1,'Y')
  END

 IF(NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Code='IS NOT' AND Category='XFABIPRESTRAINTS'))
  BEGIN
  INSERT INTO GlobalCodes(Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
  VALUES('XFABIPRESTRAINTS','is not','IS NOT',NULL,'Y',2,'N')
  END

  --SET IDENTITY_INSERT GlobalCodes OFF
  
  

---------Forms----FBA----
Set Identity_Insert Forms ON
if(not exists(select FormId from Forms where FormId=130))
	insert into Forms(FormId,FormName,TableName,TotalNumberOfColumns,Active)
	Values(130,'FBAContent','CustomDocumentFABIPs',1,'Y')
Set Identity_Insert Forms OFF

--FormCollectionForms---
Set Identity_Insert FormCollectionForms ON
if(not exists(select FormCollectionFormId from FormCollectionForms where FormCollectionFormId=64))
	insert into FormCollectionForms(FormCollectionFormId,FormCollectionId,FormId,Active,FormOrder)
	Values(64,34,130,'Y',1)
Set Identity_Insert FormCollectionForms OFF


------------FormSections--------
Set Identity_Insert FormSections ON
if(not exists(select FormSectionId from FormSections where FormSectionId=480))
	insert into FormSections(FormSectionId, FormId,SortOrder,SectionLabel,Active,SectionEnableCheckBox,NumberOfColumns)
	Values(480,130,1,null,'Y','N',1)

if(not exists(select FormSectionId from FormSections where FormSectionId=481))
	insert into FormSections(FormSectionId, FormId,SortOrder,SectionLabel,Active,SectionEnableCheckBox,NumberOfColumns)
	Values(481,130,2,'Target Behavior 1*','Y','N',1)

if(not exists(select FormSectionId from FormSections where FormSectionId=482))
	insert into FormSections(FormSectionId, FormId,SortOrder,SectionLabel,Active,SectionEnableCheckBox,NumberOfColumns)
	Values(482,130,3,'Target Behavior 2','Y','N',1)

if(not exists(select FormSectionId from FormSections where FormSectionId=483))
	insert into FormSections(FormSectionId, FormId,SortOrder,SectionLabel,Active,SectionEnableCheckBox,NumberOfColumns)
	Values(483,130,4,'Target Behavior 3','Y','N',1)

if(not exists(select FormSectionId from FormSections where FormSectionId=484))
	insert into FormSections(FormSectionId, FormId,SortOrder,SectionLabel,Active,SectionEnableCheckBox,NumberOfColumns)
	Values(484,130,5,'Target Behavior 4','Y','N',1)
	
if(not exists(select FormSectionId from FormSections where FormSectionId=485))
	insert into FormSections(FormSectionId, FormId,SortOrder,SectionLabel,Active,SectionEnableCheckBox,NumberOfColumns)
	Values(485,130,6,'Target Behavior 5','Y','N',1)	

--select * from 	formsections where  formsectionid>=480 and formsectionid<=488
--delete from formitems where FormItemId>=5325 and FormItemId<=5471
--delete from FormSectionGroups where FormSectionGroupId>=1370 and FormSectionGroupId<=1395
--delete from formsections where formsectionid>=480 and formsectionid<=487

	
Set Identity_Insert FormSections OFF


---------FormSectionGroups-----------
Set Identity_Insert FormSectionGroups ON
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1370)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1370,480,1,'Y',2)
end
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1371)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1371,480,1,'Y',1)
end
----target 1------
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1372)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1372,481,1,'Y',4)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1373)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1373,481,2,'Y',1)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1374)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1374,481,3,'Y',2)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1375)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1375,481,4,'Y',1)
end

------------target 1 end

----target 2------
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1376)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1376,482,1,'Y',4)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1377)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1377,482,2,'Y',1)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1378)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1378,482,3,'Y',2)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1379)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1379,482,4,'Y',1)
end

----target 2 end------

----target 3------
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1380)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1380,483,1,'Y',4)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1381)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1381,483,2,'Y',1)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1382)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1382,483,3,'Y',2)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1383)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1383,483,4,'Y',1)
end

----target 3 end------

----target 4------
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1384)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1384,484,1,'Y',4)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1385)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1385,484,2,'Y',1)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1386)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1386,484,3,'Y',2)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1387)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1387,484,4,'Y',1)
end

----target 4 end------

----target 5------
if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1388)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1388,485,1,'Y',4)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1389)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1389,485,2,'Y',1)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1390)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1390,485,3,'Y',2)
end

if(not(Exists(select FormSectionGroupId from FormSectionGroups where FormSectionGroupId=1391)))
begin
insert into FormSectionGroups(FormSectionGroupId, FormSectionId, SortOrder,Active,NumberOfItemsInRow)
Values(1391,485,4,'Y',1)
end

----target 5 end------

Set Identity_Insert FormSectionGroups OFF


---------FormItems-----------
Set Identity_Insert FormItems ON

if(not(Exists(select FormItemId from FormItems where FormItemId=5325)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5325,480,1370,5374,'Type*',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5326)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth,DropdownType)
Values(5326,480,1370,5372,'',2,'Y','XFABIPTYPE','Type','N',100,'G')

if(not(Exists(select FormItemId from FormItems where FormItemId=5327)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5327,480,1371,5374,'Name staff clients who participated in the development of this analysis and plan:*',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5328)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5328,480,1371,5363,'',2,'Y',null,'StaffParticipants','N',780)

-------target 1---------------
if(not(Exists(select FormItemId from FormItems where FormItemId=5329)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5329,481,1372,5374,'Target Behavior:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5330)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5330,481,1372,5361,'',2,'Y',null,'TargetBehavior1','N',498)

if(not(Exists(select FormItemId from FormItems where FormItemId=5331)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5331,481,1372,5374,'<span style=''padding-left:50px''></span>Status:',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5332)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth,DropdownType)
Values(5332,481,1372,5372,'',4,'Y','XFABIPTBSTATUS','Status1','N','100','G')

------------

if(not(Exists(select FormItemId from FormItems where FormItemId=5333)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5333,481,1373,5374,'Describe frequency, intensity, and duration:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5334)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5334,481,1373,5363,'',2,'Y',null,'FrequencyIntensityDuration1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5335)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5335,481,1373,5374,'Setting(s):',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5336)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5336,481,1373,5363,'',4,'Y',null,'Settings1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5337)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5337,481,1373,5374,'Antecedent:',5,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5338)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5338,481,1373,5363,'',6,'Y',null,'Antecedent1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5339)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5339,481,1373,5374,'Consequence that reinforces the behavior:',6,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5340)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5340,481,1373,5363,'',7,'Y',null,'ConsequenceThatReinforcesBehavior1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5341)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5341,481,1373,5374,'What environmental conditions may affect the behavior (e.g., medications, medical condition, sleep, diet, social factors)?',8,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5342)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5342,481,1373,5363,'',8,'Y',null,'EnvironmentalConditions1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5343)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5343,481,1373,5374,'Hypothesis of Behavioral Function (What deeper meaning does the behavior have?  What is client trying to get or avoid?  Why in this particular environment?)',9,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5344)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5344,481,1373,5363,'',10,'Y',null,'HypothesisOfBehavioralFunction1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5345)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5345,481,1373,5374,'Expected Behavior Changes:',11,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5346)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5346,481,1373,5363,'',12,'Y',null,'ExpectedBehaviorChanges1','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5347)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5347,481,1373,5374,'Methods/Criteria for Outcome Measurement:',13,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5348)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5348,481,1373,5363,'',14,'Y',null,'MethodsOfOutcomeMeasurement1','N',780)

---------

if(not(Exists(select FormItemId from FormItems where FormItemId=5349)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5349,481,1374,5374,'Schedule of Outcome Review:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5350)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,MaximumLength)
Values(5350,481,1374,5361,'',2,'Y',null,'ScheduleOfOutcomeReview1','N',25)

-------
if(not(Exists(select FormItemId from FormItems where FormItemId=5351)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5351,481,1375,5374,'Quarterly Review',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5352)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5352,481,1375,5363,'',2,'Y',null,'QuarterlyReview1','N',780)
--------
----------end target 1----------


-------target 2---------------
if(not(Exists(select FormItemId from FormItems where FormItemId=5353)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5353,482,1376,5374,'Target Behavior:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5354)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5354,482,1376,5361,'',2,'Y',null,'TargetBehavior2','N',498)

if(not(Exists(select FormItemId from FormItems where FormItemId=5355)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5355,482,1376,5374,'<span style=''padding-left:50px''></span>Status:',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5356)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth,DropdownType)
Values(5356,482,1376,5372,'',4,'Y','XFABIPTBSTATUS','Status2','N',100,'G')

------------

if(not(Exists(select FormItemId from FormItems where FormItemId=5357)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5357,482,1377,5374,'Describe frequency, intensity, and duration:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5358)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5358,482,1377,5363,'',2,'Y',null,'FrequencyIntensityDuration2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5359)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5359,482,1377,5374,'Setting(s):',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5360)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5360,482,1377,5363,'',4,'Y',null,'Settings2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5361)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5361,482,1377,5374,'Antecedent:',5,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5362)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5362,482,1377,5363,'',6,'Y',null,'Antecedent2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5363)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5363,482,1377,5374,'Consequence that reinforces the behavior:',6,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5364)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5364,482,1377,5363,'',7,'Y',null,'ConsequenceThatReinforcesBehavior2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5365)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5365,482,1377,5374,'What environmental conditions may affect the behavior (e.g., medications, medical condition, sleep, diet, social factors)?',8,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5366)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5366,482,1377,5363,'',8,'Y',null,'EnvironmentalConditions2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5367)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5367,482,1377,5374,'Hypothesis of Behavioral Function (What deeper meaning does the behavior have?  What is client trying to get or avoid?  Why in this particular environment?)',9,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5368)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5368,482,1377,5363,'',10,'Y',null,'HypothesisOfBehavioralFunction2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5369)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5369,482,1377,5374,'Expected Behavior Changes:',11,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5370)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5370,482,1377,5363,'',12,'Y',null,'ExpectedBehaviorChanges2','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5371)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5371,482,1377,5374,'Methods/Criteria for Outcome Measurement:',13,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5372)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5372,482,1377,5363,'',14,'Y',null,'MethodsOfOutcomeMeasurement2','N',780)

---------

if(not(Exists(select FormItemId from FormItems where FormItemId=5373)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5373,482,1378,5374,'Schedule of Outcome Review:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5374)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,MaximumLength)
Values(5374,482,1378,5361,'',2,'Y',null,'ScheduleOfOutcomeReview2','N',25)

-------
if(not(Exists(select FormItemId from FormItems where FormItemId=5375)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5375,482,1379,5374,'Quarterly Review',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5376)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5376,482,1379,5363,'',2,'Y',null,'QuarterlyReview2','N',780)
--------
----------end target 2----------

-------target 3---------------
if(not(Exists(select FormItemId from FormItems where FormItemId=5377)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5377,483,1380,5374,'Target Behavior:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5378)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5378,483,1380,5361,'',2,'Y',null,'TargetBehavior3','N',498)

if(not(Exists(select FormItemId from FormItems where FormItemId=5379)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5379,483,1380,5374,'<span style=''padding-left:50px''></span>Status:',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5380)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth,DropdownType)
Values(5380,483,1380,5372,'',4,'Y','XFABIPTBSTATUS','Status3','N',100,'G')

------------

if(not(Exists(select FormItemId from FormItems where FormItemId=5381)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5381,483,1381,5374,'Describe frequency, intensity, and duration:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5382)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5382,483,1381,5363,'',2,'Y',null,'FrequencyIntensityDuration3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5383)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5383,483,1381,5374,'Setting(s):',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5384)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5384,483,1381,5363,'',4,'Y',null,'Settings3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5385)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5385,483,1381,5374,'Antecedent:',5,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5386)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5386,483,1381,5363,'',6,'Y',null,'Antecedent3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5387)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5387,483,1381,5374,'Consequence that reinforces the behavior:',6,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5388)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5388,483,1381,5363,'',7,'Y',null,'ConsequenceThatReinforcesBehavior3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5389)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5389,483,1381,5374,'What environmental conditions may affect the behavior (e.g., medications, medical condition, sleep, diet, social factors)?',8,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5390)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5390,483,1381,5363,'',8,'Y',null,'EnvironmentalConditions3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5391)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5391,483,1381,5374,'Hypothesis of Behavioral Function (What deeper meaning does the behavior have?  What is client trying to get or avoid?  Why in this particular environment?)',9,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5392)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5392,483,1381,5363,'',10,'Y',null,'HypothesisOfBehavioralFunction3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5393)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5393,483,1381,5374,'Expected Behavior Changes:',11,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5394)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5394,483,1381,5363,'',12,'Y',null,'ExpectedBehaviorChanges3','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5395)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5395,483,1381,5374,'Methods/Criteria for Outcome Measurement:',13,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5396)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5396,483,1381,5363,'',14,'Y',null,'MethodsOfOutcomeMeasurement3','N',780)

---------

if(not(Exists(select FormItemId from FormItems where FormItemId=5397)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5397,483,1382,5374,'Schedule of Outcome Review:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5398)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,MaximumLength)
Values(5398,483,1382,5361,'',2,'Y',null,'ScheduleOfOutcomeReview3','N',25)

-------
if(not(Exists(select FormItemId from FormItems where FormItemId=5399)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5399,483,1383,5374,'Quarterly Review',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5400)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5400,483,1383,5363,'',2,'Y',null,'QuarterlyReview3','N',780)
--------
----------end target 3----------

-------target 4---------------
if(not(Exists(select FormItemId from FormItems where FormItemId=5401)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5401,484,1384,5374,'Target Behavior:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5402)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5402,484,1384,5361,'',2,'Y',null,'TargetBehavior4','N',498)

if(not(Exists(select FormItemId from FormItems where FormItemId=5403)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5403,484,1384,5374,'<span style=''padding-left:50px''></span>Status:',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5404)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth,DropdownType)
Values(5404,484,1384,5372,'',4,'Y','XFABIPTBSTATUS','Status4','N',100,'G')

------------

if(not(Exists(select FormItemId from FormItems where FormItemId=5405)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5405,484,1385,5374,'Describe frequency, intensity, and duration:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5406)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5406,484,1385,5363,'',2,'Y',null,'FrequencyIntensityDuration4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5407)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5407,484,1385,5374,'Setting(s):',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5408)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5408,484,1385,5363,'',4,'Y',null,'Settings4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5409)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5409,484,1385,5374,'Antecedent:',5,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5410)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5410,484,1385,5363,'',6,'Y',null,'Antecedent4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5411)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5411,484,1385,5374,'Consequence that reinforces the behavior:',6,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5412)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5412,484,1385,5363,'',7,'Y',null,'ConsequenceThatReinforcesBehavior4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5413)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5413,484,1385,5374,'What environmental conditions may affect the behavior (e.g., medications, medical condition, sleep, diet, social factors)?',8,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5414)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5414,484,1385,5363,'',8,'Y',null,'EnvironmentalConditions4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5415)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5415,484,1385,5374,'Hypothesis of Behavioral Function (What deeper meaning does the behavior have?  What is client trying to get or avoid?  Why in this particular environment?)',9,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5416)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5416,484,1385,5363,'',10,'Y',null,'HypothesisOfBehavioralFunction4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5417)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5417,484,1385,5374,'Expected Behavior Changes:',11,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5418)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5418,484,1385,5363,'',12,'Y',null,'ExpectedBehaviorChanges4','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5419)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5419,484,1385,5374,'Methods/Criteria for Outcome Measurement:',13,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5420)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5420,484,1385,5363,'',14,'Y',null,'MethodsOfOutcomeMeasurement4','N',780)

---------

if(not(Exists(select FormItemId from FormItems where FormItemId=5421)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5421,484,1386,5374,'Schedule of Outcome Review:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5422)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,MaximumLength)
Values(5422,484,1386,5361,'',2,'Y',null,'ScheduleOfOutcomeReview4','N',25)

-------
if(not(Exists(select FormItemId from FormItems where FormItemId=5423)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5423,484,1387,5374,'Quarterly Review',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5424)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5424,484,1387,5363,'',2,'Y',null,'QuarterlyReview4','N',780)
--------
----------end target 4----------

-------target 5---------------
if(not(Exists(select FormItemId from FormItems where FormItemId=5425)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5425,485,1388,5374,'Target Behavior:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5426)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5426,485,1388,5361,'',2,'Y',null,'TargetBehavior5','N',498)

if(not(Exists(select FormItemId from FormItems where FormItemId=5427)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5427,485,1388,5374,'<span style=''padding-left:50px''></span>Status:',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5428)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth,DropdownType)
Values(5428,485,1388,5372,'',4,'Y','XFABIPTBSTATUS','Status5','N',100,'G')

------------

if(not(Exists(select FormItemId from FormItems where FormItemId=5429)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5429,485,1389,5374,'Describe frequency, intensity, and duration:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5430)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5430,485,1389,5363,'',2,'Y',null,'FrequencyIntensityDuration5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5431)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5431,485,1389,5374,'Setting(s):',3,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5432)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5432,485,1389,5363,'',4,'Y',null,'Settings5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5433)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5433,485,1389,5374,'Antecedent:',5,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5434)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5434,485,1389,5363,'',6,'Y',null,'Antecedent5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5435)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5435,485,1389,5374,'Consequence that reinforces the behavior:',6,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5436)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5436,485,1389,5363,'',7,'Y',null,'ConsequenceThatReinforcesBehavior5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5437)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5437,485,1389,5374,'What environmental conditions may affect the behavior (e.g., medications, medical condition, sleep, diet, social factors)?',8,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5438)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5438,485,1389,5363,'',8,'Y',null,'EnvironmentalConditions5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5439)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5439,485,1389,5374,'Hypothesis of Behavioral Function (What deeper meaning does the behavior have?  What is client trying to get or avoid?  Why in this particular environment?)',9,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5440)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5440,485,1389,5363,'',10,'Y',null,'HypothesisOfBehavioralFunction5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5441)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5441,485,1389,5374,'Expected Behavior Changes:',11,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5442)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5442,485,1389,5363,'',12,'Y',null,'ExpectedBehaviorChanges5','N',780)

if(not(Exists(select FormItemId from FormItems where FormItemId=5443)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5443,485,1389,5374,'Methods/Criteria for Outcome Measurement:',13,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5444)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5444,485,1389,5363,'',14,'Y',null,'MethodsOfOutcomeMeasurement5','N',780)

---------

if(not(Exists(select FormItemId from FormItems where FormItemId=5445)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5445,485,1390,5374,'Schedule of Outcome Review:',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5446)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,MaximumLength)
Values(5446,485,1390,5361,'',2,'Y',null,'ScheduleOfOutcomeReview5','N',25)

-------
if(not(Exists(select FormItemId from FormItems where FormItemId=5447)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment)
Values(5447,485,1391,5374,'Quarterly Review',1,'Y',null,null,'N')

if(not(Exists(select FormItemId from FormItems where FormItemId=5448)))
insert into FormItems(FormItemId, FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemWidth)
Values(5448,485,1391,5363,'',2,'Y',null,'QuarterlyReview5','N',780)
--------
----------end target 5----------


Set Identity_Insert FormItems OFF

	
------------------------------------SCRIPTS BIP-------------------------------------------------------------------


------------------------------------Form Table Entry--------------------------------
  Set Identity_Insert Forms ON

      if(not(Exists(select FormId from Forms where FormId=131)))
     BEGIN
      INSERT INTO Forms(FormId,[FormName],[TableName],[TotalNumberOfColumns],[Active])
      VALUES(131,'FBA/BIP','CustomDocumentFABIPs',1,'Y')
     END 
 Set Identity_Insert  Forms OFF
 -----------------------------------------END-------------------------------------
GO
-------------------------------FormCollectionForms Table Entry---------------------------

 Set Identity_Insert FormCollectionForms ON

      if(not(Exists(select FormId from FormCollectionForms where FormCollectionFormId=65)))
     BEGIN
      INSERT INTO FormCollectionForms(FormCollectionFormId,[FormCollectionId],[FormId],[Active],[FormOrder])
      VALUES(65,34,131,'Y',2)
     END
 Set Identity_Insert  FormCollectionForms OFF
 --------------------------------------------END-----------------------------------------------------
GO
------------------------------FormSections Table Entry----------------------------------------------
Set Identity_Insert FormSections ON
     
     if(not(Exists(select FormSectionId  from FormSections where FormSectionId=486)))
     BEGIN
     INSERT INTO FormSections([FormSectionId],[FormId] ,[SortOrder],[SectionLabel],[Active])
     VALUES(486,131,1,'','Y')
 END
 
 Set Identity_Insert FormSections OFF
 Set Identity_Insert FormSections ON
     
     if(not(Exists(select FormSectionId  from FormSections where FormSectionId=487)))
     BEGIN
     INSERT INTO FormSections([FormSectionId],[FormId] ,[SortOrder],[SectionLabel],[Active],[NumberOfColumns])
     VALUES(487,131,1,'','Y',3)
 END
 
 Set Identity_Insert FormSections OFF
 
  Set Identity_Insert FormSections ON
     
     if(not(Exists(select FormSectionId  from FormSections where FormSectionId=491)))
     BEGIN
     INSERT INTO FormSections([FormSectionId],[FormId] ,[SortOrder],[SectionLabel],[Active],[NumberOfColumns])
     VALUES(491,131,1,'','Y',1)
 END
 
 Set Identity_Insert FormSections OFF
  -----------------------------------------END------------------------------------------------------------
GO 
------------------------------FormSectionGroups Table Entry----------------------------------------------
Set Identity_Insert FormSectionGroups ON
      
       if(not(Exists(select FormSectionGroupId  from FormSectionGroups where FormSectionGroupId=1395)))
       BEGIN
       INSERT INTO FormSectionGroups([FormSectionGroupId],[FormSectionId],[SortOrder] ,[Active],[NumberOfItemsInRow])
       VALUES(1395,486,1,'Y',1)
END

Set Identity_Insert FormSectionGroups OFF
GO
Set Identity_Insert FormSectionGroups ON
      
       if(not(Exists(select FormSectionGroupId  from FormSectionGroups where FormSectionGroupId=1394)))
       BEGIN
       INSERT INTO FormSectionGroups([FormSectionGroupId],[FormSectionId],[SortOrder] ,[Active],[NumberOfItemsInRow])
       VALUES(1394,487,1,'Y',2)
END

Set Identity_Insert FormSectionGroups OFF

Set Identity_Insert FormSectionGroups ON
      
       if(not(Exists(select FormSectionGroupId  from FormSectionGroups where FormSectionGroupId=1401)))
       BEGIN
       INSERT INTO FormSectionGroups([FormSectionGroupId],[FormSectionId],[SortOrder] ,[Active],[NumberOfItemsInRow])
       VALUES(1401,491,1,'Y',1)
END

Set Identity_Insert FormSectionGroups OFF
GO
------------------------------FormItems Table Entry----------------------------------------------
    
Set Identity_Insert FormItems ON

     if(not(Exists(select FormItemId from FormItems where FormItemId=5450)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5450,486,1395,5374,'What interventions were previously attempted, and what were the results?*',1,'Y','N',null)
    END       
 GO		
 							

     if(not(Exists(select FormItemId from FormItems where FormItemId=5451)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5451,486,1395,5363,'',2,'Y','InterventionsAttempted','N',null,750,null)
     END      
 
 GO
 
     if(not(Exists(select FormItemId from FormItems where FormItemId=5452)))
     BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5452,486,1395,5374,'What replacement behaviors will be taught to address the identified target behaviors?*',3,'Y','N',null)
 END
 GO	

 	 if(not(Exists(select FormItemId from FormItems where FormItemId=5453)))
    BEGIN
     INSERT INTO FormItems( FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[GlobalCodeCategory],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5453,486,1395,5363,'',4,'Y',Null,'ReplacementBehaviors','N',null,750,null)
     END
 
 
 GO
     if(not(Exists(select FormItemId from FormItems where FormItemId=5454)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5454,486,1395,5374,'What motivators might be most useful for the client?*',5,'Y','N',null)
  END
                            
 GO		
 						
     if(not(Exists(select FormItemId from FormItems where FormItemId=5455)))
    BEGIN
     INSERT INTO FormItems( FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[GlobalCodeCategory],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5455,486,1395,5363,'',6,'Y',Null,'Motivators','N',null,750,NULL)
     END  
 
GO
 
     if(not(Exists(select FormItemId from FormItems where FormItemId=5456)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5456,486,1395,5374,'What nonrestrictive interventions should be planned?*',7,'Y','N',null)
  END
 
GO 
  	
     if(not(Exists(select FormItemId from FormItems where FormItemId=5457)))
    BEGIN
     INSERT INTO FormItems( FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[GlobalCodeCategory],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5457,486,1395,5363,'',8,'Y',Null,'NonrestrictiveInterventions','N',null,750,NULL)
     END 
                            
GO		
 							
     if(not(Exists(select FormItemId from FormItems where FormItemId=5458)))
     BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5458,486,1395,5374,'What restrictive or highly restrictive interventions should be planned?*',9,'Y','N',null)
  END
GO
 
     if(not(Exists(select FormItemId from FormItems where FormItemId=5459)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5459,486,1395,5363,'',10,'Y','RestrictiveInterventions','N',null,750,null)
     END 
 
GO 
     if(not(Exists(select FormItemId from FormItems where FormItemId=5460)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5460,486,1395,5374,'Who is responsible for implementing and monitoring this plan?*',11,'Y','N',null)
  END
 
 GO		
     if(not(Exists(select FormItemId from FormItems where FormItemId=5461)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5461,486,1395,5363,'',12,'Y','StaffResponsible','N',null,750,null)
    END  
 
 GO 
     if(not(Exists(select FormItemId from FormItems where FormItemId=5462)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5462,486,1395,5374,'Who will receive a copy of this plan?*',13,'Y','N',null)
  END

 GO		
     if(not(Exists(select FormItemId from FormItems where FormItemId=5463)))
    BEGIN
     INSERT INTO FormItems( FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[GlobalCodeCategory],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5463,486,1395,5363,'',14,'Y',Null,'ReceiveCopyOfPlan','N',null,750,null)
END
 GO 

     if(not(Exists(select FormItemId from FormItems where FormItemId=5464)))
   BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5464,486,1395,5374,'Who will coordinate the plan with the student’s parent(s)?*',15,'Y','N',null)
  END
                          
 GO		
 	 if(not(Exists(select FormItemId from FormItems where FormItemId=5465)))
     BEGIN
     INSERT INTO FormItems( FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[GlobalCodeCategory],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5465,486,1395,5363,'',16,'Y',Null,'WhoCoordinatePlan','N',null,750,null)
 END
 GO 

     if(not(Exists(select FormItemId from FormItems where FormItemId=5466)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5466,486,1395,5374,'How will this be coordinated with the student’s parent(s)?*',17,'Y','N',null)
  END

 GO	
     if(not(Exists(select FormItemId from FormItems where FormItemId=5467)))
     BEGIN
     INSERT INTO FormItems( FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[GlobalCodeCategory],[ItemColumnName],[ItemRequiresComment],[ItemCommentColumnName],[ItemWidth],[MaximumLength])
     VALUES(5467,486,1395,5363,'',18,'Y',Null,'HowCoordinatePlan','N',null,750,Null)
      END
 GO 
   if(not(Exists(select FormItemId from FormItems where FormItemId=5468)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5468,486,1395,5374,'The maladaptive behaviors listed above, which are under consideration for treatment, are not the result of any known medical/physical problems that would contraindicate behavior treatment.',19,'Y','N',null)
  END

 GO
    if(not(Exists(select FormItemId from FormItems where FormItemId=5469)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5469,487,1394,5374,'In addition, the use of manual restraints',1,'Y','N',null)
  END
  if(not(Exists(select FormItemId from FormItems where FormItemId=5470)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth],[GlobalCodeCategory],[ItemColumnName])
     VALUES(5470,487,1394,5365,'',1,'Y','N',null,'XFABIPRESTRAINTS','UseOfManualRestraints')
  END

 GO
    if(not(Exists(select FormItemId from FormItems where FormItemId=5471)))
    BEGIN
     INSERT INTO FormItems(FormItemId,[FormSectionId],[FormSectionGroupId],[ItemType],[ItemLabel],[SortOrder],[Active] ,[ItemRequiresComment],[ItemWidth])
     VALUES(5471,491,1401,5374,'contraindicated for this client due to a medical condition, mental illness, or for developmental or psychological reasons.',3,'Y','N',null)
  END

 GO
 Set Identity_Insert FormItems OFF
 
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
--------------------------------------------------------END----------------------------------------------------------------------------
