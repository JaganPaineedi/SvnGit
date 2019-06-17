--DFA is created for Revoke Release of informations Pop-up


declare 
    @FormId int,
    @FormSectionId int,
    @FormSectionGroupId int,
    @FormItemId int,
    @FormCollectionId int,
    @screenid int,
    @bannerid int
   
   
   ---------
   set @screenid=11001
   select @FormId=CustomFieldFormId from Screens where ScreenId=@screenid

--Delete FormItems
 DELETE FormItems
FROM FormItems FI
INNER JOIN FormSectionGroups FSG ON FSG.FormSectionGroupId = FI.FormSectionGroupId AND FSG.FormSectionId = FI.FormSectionId
INNER JOIN FormSections FS ON FS.FormSectionId = FSG.FormSectionId
WHERE FS.FormId = @FormId

--Delete FormSectiongroups
DELETE FormSectionGroups
FROM FormSectionGroups FSG 
INNER JOIN FormSections FS ON FS.FormSectionId = FSG.FormSectionId
WHERE FS.FormId = @FormId

--Delete FormSections
DELETE FormSections
WHERE FormId = @FormId


--Delete FormCollectionForms
DELETE from FormCollectionForms where FormId =@FormId

--Delete Screens

    delete from DocumentNavigations where screenid=@screenid
    delete from Banners where ScreenId=@screenid
    DELETE FROM ScreenPermissionControls WHERE ScreenId=@screenid
	DELETE FROM StaffScreenFilters WHERE ScreenId = @screenid
	DELETE FROM UnsavedChanges WHERE ScreenId = @screenid
	DELETE FROM StaffClientAccess  WHERE ScreenId=@screenid
	DELETE FROM Screens WHERE ScreenId=@screenid
    
 --till here
--Delete Forms
DELETE from Forms
WHERE FormId = @FormId


   ----------
   
  
   INSERT INTO Forms (FormName,TableName,TotalNumberOfColumns,Active)
	VALUES('Revoke Release of Information','CustomDocumentRevokeReleaseOfInformations',1,'Y');
	set @FormId = @@IDENTITY		
  
  	PRINT @FormId
	Insert into FormSections (FormId,SortOrder,PlaceOnTopOfPage,SectionLabel,Active,SectionEnableCheckBox,SectionEnableCheckBoxText,SectionEnableCheckBoxColumnName,NumberOfColumns) 		values (@FormId,1,'N','Revoke Release of Information','Y',null,null,null,1)
		set @FormSectionId = @@IDENTITY	

  
 Insert into FormCollections (NumberOfForms) 
 values (1)
 set @FormCollectionId=@@IDENTITY
 
 Insert into FormCollectionForms(FormCollectionId,FormId,Active,FormOrder)
  values (@FormCollectionId,@FormId,'Y',1)

--FormSectionGroups
Insert into FormSectionGroups (FormSectionId,SortOrder,GroupLabel,Active,GroupEnableCheckBox,GroupEnableCheckBoxText,GroupEnableCheckBoxColumnName,NumberOfItemsInRow) 		values (@FormSectionId,1,null,'Y',null,null,null,2)	
	set @FormSectionGroupId = @@IDENTITY
		
Insert into FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemCommentColumnName,ItemWidth,MaximumLength,DropdownType,SharedTableName,StoredProcedureName,ValueField,TextField,MultilineEditFieldHeight,EachRadioButtonOnNewLine,InformationIcon,InformationIconStoredProcedure,ExcludeFromPencilIcon)
 values (@FormSectionId,@FormSectionGroupId,5374,'Release To/From:',1,'Y',null,null,'N',null,null,null,null,null,null,null,null,null,null,null,null,null)

Insert into FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemCommentColumnName,ItemWidth,MaximumLength,DropdownType,SharedTableName,StoredProcedureName,ValueField,TextField,MultilineEditFieldHeight,EachRadioButtonOnNewLine,InformationIcon,InformationIconStoredProcedure,ExcludeFromPencilIcon) 
values (@FormSectionId,@FormSectionGroupId,5372,'',2,'Y',null,'ClientInformationReleaseId','N',null,null,null,null,null,null,null,null,null,null,null,null,null)
		
--FormSectionGroups
Insert into FormSectionGroups (FormSectionId,SortOrder,GroupLabel,Active,GroupEnableCheckBox,GroupEnableCheckBoxText,GroupEnableCheckBoxColumnName,NumberOfItemsInRow) 		values (@FormSectionId,1,null,'Y',null,null,null,2)	
	set @FormSectionGroupId = @@IDENTITY
		
Insert into FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemCommentColumnName,ItemWidth,MaximumLength,DropdownType,SharedTableName,StoredProcedureName,ValueField,TextField,MultilineEditFieldHeight,EachRadioButtonOnNewLine,InformationIcon,InformationIconStoredProcedure,ExcludeFromPencilIcon)
 values (@FormSectionId,@FormSectionGroupId,5374,'I withdraw this Authorization to Obtain/Disclose protected health information as of:',1,'Y',null,null,'N',null,null,null,null,null,null,null,null,null,null,null,null,null)

Insert into FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemCommentColumnName,ItemWidth,MaximumLength,DropdownType,SharedTableName,StoredProcedureName,ValueField,TextField,MultilineEditFieldHeight,EachRadioButtonOnNewLine,InformationIcon,InformationIconStoredProcedure,ExcludeFromPencilIcon) 
values (@FormSectionId,@FormSectionGroupId,5367,'',2,'Y',null,'RevokeEndDate','N',null,null,null,null,null,null,null,null,null,null,null,null,null)
		
		--FormSectionGroups
Insert into FormSectionGroups (FormSectionId,SortOrder,GroupLabel,Active,GroupEnableCheckBox,GroupEnableCheckBoxText,GroupEnableCheckBoxColumnName,NumberOfItemsInRow) 		values (@FormSectionId,1,null,'Y',null,null,null,1)	
	set @FormSectionGroupId = @@IDENTITY
		
Insert into FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,ItemRequiresComment,ItemCommentColumnName,ItemWidth,MaximumLength,DropdownType,SharedTableName,StoredProcedureName,ValueField,TextField,MultilineEditFieldHeight,EachRadioButtonOnNewLine,InformationIcon,InformationIconStoredProcedure,ExcludeFromPencilIcon)
 values (@FormSectionId,@FormSectionGroupId,5374,'I understand that no further releasing of information may occur (based on this Authorization). However, I understand that when I revoke this Authorization, it will have no affect on actions taken by (Agency Name) prior to the date it as revoked or signed as revoked by me (whichever is later).',1,'Y',null,null,'N',null,null,null,null,null,null,null,null,null,null,null,null,null)

	
		
				
		
SET IDENTITY_INSERT Documentcodes ON
IF Not EXISTS(SELECT 1 FROM Documentcodes WHERE DocumentcodeId=16101)
BEGIN
Insert Into Documentcodes(DocumentCodeId,DocumentName,DocumentDescription,DocumentType,Active,ServiceNote,PatientConsent,OnlyAvailableOnline,
StoredProcedure,TableList,RequiresSignature,FormCollectionId,ViewDocumentURL,ViewDocumentRDL,ViewStoredProcedure,DefaultGuardian,DefaultCoSigner)
Values(16101,'Revoke Release of Information','Revoke Release of Information',10,'Y','N','N','N',
'csp_SCGetRevokeReleaseofInformation','CustomDocumentRevokeReleaseOfInformations','Y',@FormCollectionId,'RDLRevokeReleaseofInformation','RDLRevokeReleaseofInformation','csp_RDLCustomRevokeReleaseofInformation','Y','Y')
END
SET IDENTITY_INSERT Documentcodes OFF		
		    



--Screens Table Entry
SET IDENTITY_INSERT Screens on
IF Not EXISTS(SELECT 1 FROM Screens WHERE ScreenId=11001)
 BEGIN
	INSERT INTO Screens
	(ScreenId, ScreenName, ScreenType, ScreenURL,TabId,DocumentCodeId,InitializationStoredProcedure,PostUpdateStoredProcedure,CustomFieldFormId)
	VALUES 
	(11001,'Revoke Release of Information',5763,'/Custom/ROI/WebPages/RevokeReleaseOfInformation.ascx',2,16101,'csp_SCInitRevokeReleaseofInformation','csp_SCPostSignatureUpdateRevokeReleaseofInformation',@FormId)
END
else begin
update screens set CustomFieldFormId=@FormId where screenid=11001
end
SET IDENTITY_INSERT Screens off


--Banners Table Entry
IF Not EXISTS(SELECT 1 FROM Banners WHERE ScreenId=11001)
BEGIN
Insert INTO Banners(BannerName,DisplayAs,Active,DefaultOrder,Custom,TabId,ScreenId,ParentBannerId)
Values('Revoke Release of Information','Revoke Release of Information','N',1,'N',2,11001,21)
set @bannerid=@@IDENTITY
END
ELSE
begin
select @bannerid=bannerid FROM Banners WHERE ScreenId=11001
end

if not exists (select 1 from [DocumentNavigations] where screenid=11001)
begin
INSERT INTO [DocumentNavigations]([NavigationName],[DisplayAs],[Active]
           ,[ParentDocumentNavigationId],[BannerId],[ScreenId])
     VALUES('Revoke Release of Information','Revoke Release of Information','Y',null,@bannerid,11001)
 end