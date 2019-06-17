

insert into GlobalCodeCategories(Category
,CategoryName
,Active
,AllowAddDelete
,AllowCodeNameEdit
,AllowSortOrderEdit
,Description
,UserDefinedCategory
,HasSubcodes
,UsedInPracticeManagement
,UsedInCareManagement)
select 'DVARangeType','DVARangeType','Y','N','N','N','Description','N','N','Y','N'
where not exists (select 1
				from GlobalCodeCategories as gc
				where gc.Category = 'DVARangeType'
				and ISNULL(gc.RecordDeleted,'N')='N'
				)
union all
select 'DVAConditionActions','DVAConditionActions','Y','N','N','N','Description','N','N','Y','N'
where not exists (select 1
				from GlobalCodeCategories as gc
				where gc.Category = 'DVAConditionActions'
				and ISNULL(gc.RecordDeleted,'N')='N'
				)
union all
select 'DVAConditionTypes','DVAConditionTypes','Y','N','N','N','Description','N','N','Y','N'
where not exists (select 1
				from GlobalCodeCategories as gc
				where gc.Category = 'DVAConditionTypes'
				and ISNULL(gc.RecordDeleted,'N')='N'
				)
set identity_insert GlobalCodes on
insert into GlobalCodes(
GlobalCodeId
,Category
,CodeName
,Code
,[Description]
,Active
,CannotModifyNameOrDelete
,SortOrder
)
select 9520,
'DVARangeType',
'Between',
'Between',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9520 )
union all
select 9521,
'DVARangeType',
'Greater Than',
'GreaterThan',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9521 )
union all
select 9522,
'DVARangeType',
'Less Than',
'LessThan',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9522 )
union all
select 9523,
'DVAConditionActions',
'Required',
'Required',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9523 )
union all
select 9524,
'DVAConditionActions',
'Equals',
'Equals',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9524 )
union all
select 9525,
'DVAConditionActions',
'Not Equals',
'NotEquals',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9525 )
union all
select 9526,
'DVAConditionActions',
'Value in Recode',
'ValueinRecode',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9526 )
union all
select 9527,
'DVAConditionActions',
'Range',
'Range',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9527 )
union all
select 9528,
'DVAConditionActions',
'Value not in Recode',
'ValuenotinRecode',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9528 )
union all
select 9529,
'DVAConditionTypes',
'And',
'And',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9529 )
union all
select 9530,
'DVAConditionTypes',
'Or',
'Or',
'Description',
'Y',
'Y',
1
where not exists(select 1 from GlobalCodes where GlobalCodeId = 9530 )
