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
DECLARE @identitySection int
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
	INSERT INTO FormSections (FormId,SortOrder,PlaceOnTopOfPage,SectionLabel,Active,SectionEnableCheckBox,SectionEnableCheckBoxText,SectionEnableCheckBoxColumnName,NumberOfColumns) 
	--Entry into FormSectionGroups
	INSERT INTO FormSectionGroups (GroupName,FormSectionId,SortOrder,GroupLabel,Active,GroupEnableCheckBox,GroupEnableCheckBoxText,
	
	--Entry into FormItems	
		
		INSERT INTO FormItems (FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName,
		'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL)
		
	
END

UPDATE Screens SET CustomFieldFormId=21123 WHERE ScreenId=29