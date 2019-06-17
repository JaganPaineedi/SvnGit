declare @FormId int, @FormSectionId int, @FormSectionGroupId int

select @FormId = a.CustomFieldFormId
From dbo.Screens as a
where a.ScreenId = 490 --Document Codes Detail

select @FormSectionId = formsectionId
from FormSections 
where FormId = @FormId
and SectionLabel = 'Details'

select @FormSectionGroupId = a.FormSectionGroupId
from FormSectionGroups as a
where a.FormSectionId = @FormSectionId
and SortOrder = 2

--select *
--from FormItems
--where FormSectionId = @FormSectionId
--and FormSectionGroupId = @FormSectionGroupId
--and isnull(RecordDeleted,'N')='N'
--order by SortOrder



Update FormItems
set SortOrder = 29,
ItemLabel = '<span style="margin-left:42px">Allow Editing By NonAuthors'
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemLabel = 'Allow Editing By NonAuthors';
Update FormItems
set SortOrder = 30
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemColumnName = 'AllowEditingByNonAuthors';

Update FormItems
set SortOrder = 13,
ItemLabel = 'DSMV'
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemLabel = '<span style="margin-left:42px"></span>DSMV';
Update FormItems
set SortOrder = 14
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemColumnName = 'DSMV';

insert into FormItems(FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName, ItemRequiresComment,ItemWidth,DropDownType)
select @FormSectionId,@FormSectionGroupId,5374,'<span style="margin-left:43px">Editable After Signature',23,'Y',null,null,'N',175,null

insert into FormItems(FormSectionId,FormSectionGroupId,ItemType,ItemLabel,SortOrder,Active,GlobalCodeCategory,ItemColumnName, ItemRequiresComment,ItemWidth,DropDownType)
select @FormSectionId,@FormSectionGroupId,5365,'<span style="margin-left:16px"></span>',24,'Y','RADIOYN','EditableAfterSignature','N',175,'G'


Update FormItems
set SortOrder = 41
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemLabel = '<span style="margin-left:42px"></span>Regenerate RDL On CoSignature';
Update FormItems
set SortOrder = 42
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemColumnName = 'RegenerateRDLOnCoSignature';

Update FormItems
set SortOrder = 43,
ItemLabel = 'Disclosure Print Order'
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemLabel = '<span style="margin-left:43px">Disclosure Print Order';
Update FormItems
set SortOrder = 44
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemColumnName = 'PrintOrder';
Update FormItems
set SortOrder = 45
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemLabel = 'Disclosure Print Order By Effective date';
Update FormItems
set SortOrder = 46
where FormSectionId = @FormSectionId
and FormSectionGroupId = @FormSectionGroupId
and ItemColumnName = 'DisclosurePrintOrder';
--select *
--from FormItems
--where FormSectionId = @FormSectionId
--and FormSectionGroupId = @FormSectionGroupId
--and isnull(RecordDeleted,'N')='N'
--order by SortOrder