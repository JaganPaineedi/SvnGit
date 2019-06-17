if not exists(select * from GlobalCodeCategories where Category = 'PRINTORDER')
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, UserDefinedCategory, HasSubCodes)
  select 'PRINTORDER', 'Print Order', 'Y', 'N', 'N', 'Y', 'N', 'N'



if not exists(select * from GlobalCodes where Category='PRINTORDER' and Code='Ascending')
  insert into GLobalCodes (Category, CodeName,Code, Active, CannotModifyNameOrDelete,SortOrder,ExternalCode1)
  values('PRINTORDER', 'Ascending','Ascending', 'Y', 'Y',1,'A')

if not exists(select * from GlobalCodes where Category='PRINTORDER' and Code='Descending')
  insert into GLobalCodes (Category, CodeName,Code, Active, CannotModifyNameOrDelete,SortOrder,ExternalCode1 )
  values('PRINTORDER', 'Descending','Descending', 'Y', 'Y',2,'D')

 


