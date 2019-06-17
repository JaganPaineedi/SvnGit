/* 
Created BY	: Dhanil Manuel
*/
--select * from screens where screenid = 29
update Screens set CustomFieldFormId = null where screenid = 29

delete from formitems where FormSectionId in (select FormSectionId from  formsections where formid =  21123)
delete from formsectiongroups where FormSectionId in (select FormSectionId from  formsections where formid =  21123)
delete from formsections where formid =  21123
delete from Forms where formid = 21123

DECLARE @identityForm int
DECLARE @identitySection intDECLARE @identitySectionGroup int
DECLARE @ExistingFormId int  

update Forms set RecordDeleted = 'Y' WHERE FormName='Service' AND TableName = 'CustomServices'

IF NOT EXISTS(SELECT FormName FROM Forms WHERE FormName='Service' AND TableName = 'CustomServices' and RecordDeleted <> 'Y')
BEGIN
	--Entry into Forms
	set identity_insert Forms on 
	INSERT INTO Forms( [formid],[FormName],[TableName],[TotalNumberOfColumns],[Active])
		VALUES(21123,'Service','CustomServices',1,'Y');
		
			set identity_insert Forms off
	SET @identityForm= 21123
	
	--Entry into FormSections
	INSERT INTO FormSections (FormId,SortOrder,PlaceOnTopOfPage,SectionLabel,Active,SectionEnableCheckBox,SectionEnableCheckBoxText,SectionEnableCheckBoxColumnName,NumberOfColumns) 		VALUES (@identityForm,1,NULL,NULL,'Y',NULL,NULL,NULL,2)	SET @identitySection = @@identity	
	--Entry into FormSectionGroups
	INSERT INTO FormSectionGroups (GroupName,FormSectionId,SortOrder,GroupLabel,Active,GroupEnableCheckBox,GroupEnableCheckBoxText,	GroupEnableCheckBoxColumnName,NumberOfItemsInRow) 	VALUES (null,@identitySection,1,null,'Y',NULL,NULL,NULL,1)	SET @identitySectionGroup = @@identity
	
	--Entry into FormItems		
		
		INSERT INTO FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,		ItemRequiresComment,ItemCommentColumnName,ItemWidth,MaximumLength,DropdownType,SharedTableName,		StoredProcedureName,ValueField,TextField,MultilineEditFieldHeight,EachRadioButtonOnNewLine) 		VALUES (@identitySection,@identitySectionGroup,5362,'<div style="width:215px;margin-left:2px;padding-top:2px;">Flag this note for psychiatrist review</div>',1,'Y',NULL,'PsychiatristReview',
		'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
		
	
END

UPDATE Screens SET CustomFieldFormId=21123 WHERE ScreenId=29