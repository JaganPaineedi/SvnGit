
 /********************************************************************************                                                    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
--	Purpose: Insert script for  new GlobalCodes for  Medications List Page(Core)
--	Author:  Vichee Humane
--	Date:    29/01/2016


*********************************************************************************/ 

if not exists(select GlobalCodeCategoryId from GlobalCodeCategories where Category = 'MEDSTATUSFILTER')
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, UserDefinedCategory, HasSubCodes)
  select 'MEDSTATUSFILTER', 'MEDSTATUSFILTER', 'Y', 'N', 'N', 'Y', 'N', 'N'

set identity_insert GlobalCodes on

if not exists(select GlobalCodeId from GlobalCodes where GlobalCodeId = 9374)
  insert into GLobalCodes (GlobalCodeId, Category, CodeName, Code, Active, CannotModifyNameOrDelete )
  select 9374, 'MEDSTATUSFILTER', 'Current Medications', 'CURRENTMEDICATIONS', 'Y', 'Y' 

if not exists(select GlobalCodeId from GlobalCodes where GlobalCodeId = 9375)
  insert into GLobalCodes (GlobalCodeId, Category, CodeName, Code, Active, CannotModifyNameOrDelete )
  select 9375, 'MEDSTATUSFILTER', 'Discontinued Medications', 'DISCONTINUEDMEDICATIONS', 'Y', 'Y' 

 
set identity_insert GlobalCodes off


 