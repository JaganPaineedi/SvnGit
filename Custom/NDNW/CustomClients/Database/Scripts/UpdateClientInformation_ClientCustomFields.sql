declare @FormSectionId INT 
declare @FormSectionGroupId INT 

select top 1 @FormSectionId = FI.FormSectionId 
             ,@FormSectionGroupId = FI.FormSectionGroupId 
from   Forms F 
       join FormSections FS 
         on FS.FormId = F.FormId 
            and FS.SectionLabel = 'AIP Information' 
       join FormSectionGroups FG 
         on FG.FormSectionId = FS.FormSectionId 
       join FormItems FI 
         on FI.FormSectionId = FS.FormSectionId 
            and FI.FormSectionGroupId = FG.FormSectionGroupId 
Where  F.TableName = 'CustomClients' 
       and F.FormName = 'CustomClients' 

if not exists(select 1 
              from   FormItems 
              where  ItemColumnName = 'AIPSIDNumber' 
                     and FormSectionGroupId = @FormSectionGroupId 
                     and FormSectionId = @FormSectionId) 
  begin 
      insert into FormItems 
                  (FormSectionId 
                   ,FormSectionGroupId 
                   ,ItemType 
                   ,ItemLabel 
                   ,SortOrder 
                   ,Active 
                   ,ItemColumnName 
                   ,ItemRequiresComment 
                   ,MaximumLength) 
      values      (@FormSectionId 
                   ,@FormSectionGroupId 
                   ,5366 
                   ,'SID Number' 
                   ,7 
                   ,'Y' 
                   ,'AIPSIDNumber' 
                   ,'N' 
                   ,8) 
  end 
else 
  begin 
      update FormItems 
      set    ItemType = 5366 
             ,ItemLabel = 'SID Number' 
             ,SortOrder = 7 
             ,Active = 'Y' 
             ,MaximumLength = 8 
      Where  ItemColumnName = 'AIPSIDNumber' 
             and FormSectionGroupId = @FormSectionGroupId 
             and FormSectionId = @FormSectionId 
  end 