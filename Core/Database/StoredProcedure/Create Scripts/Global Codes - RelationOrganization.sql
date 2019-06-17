/********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
--	Purpose: Insert script for  new GlobalCodes for Relation Dropdown  for Organization in Clients(Core)
--	Author:  Vichee Humane
--	Date:    13 Oct 2015


*********************************************************************************/ 

if not exists(select * from GlobalCodeCategories where Category = 'OrganizationRelation')
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, UserDefinedCategory, HasSubCodes)
  select 'OrganizationRelation', 'OrganizationRelation', 'Y', 'N', 'N', 'Y', 'N', 'N'

set identity_insert GlobalCodes on

if not exists(select * from GlobalCodes where GlobalCodeId = 9355)
  insert into GLobalCodes (GlobalCodeId, Category, CodeName, Active, CannotModifyNameOrDelete )
  select 9355, 'OrganizationRelation', 'Primary Contact', 'Y', 'Y' 

if not exists(select * from GlobalCodes where GlobalCodeId = 9356)
  insert into GLobalCodes (GlobalCodeId, Category, CodeName, Active, CannotModifyNameOrDelete )
  select 9356, 'OrganizationRelation', 'Contract Contact', 'Y', 'Y' 

 
set identity_insert GlobalCodes off

