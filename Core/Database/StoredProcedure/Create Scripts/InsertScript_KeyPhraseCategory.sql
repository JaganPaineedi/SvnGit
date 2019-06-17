--------------- GlobalCode Category 'RXKEYPHRASECATEGORY'-------------------------------------------------------
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'RXKEYPHRASECATEGORY') 
BEGIN 
INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('RXKEYPHRASECATEGORY','RXKEYPHRASECATEGORY','Y','Y','N','N',NULL,'N','N','N','Y') 
END 
--Global Codes - XRecommendServices-----------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RXKEYPHRASECATEGORY' and CodeName='All') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('RXKEYPHRASECATEGORY','All',NULL,'N','Y',1) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RXKEYPHRASECATEGORY' and CodeName='Members') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('RXKEYPHRASECATEGORY','Members',NULL,'Y','Y',2) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RXKEYPHRASECATEGORY' and CodeName='Non-Member') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('RXKEYPHRASECATEGORY','Non-Member',NULL,'Y','Y',3) 
END 
--Global Codes - RXKEYPHRASECATEGORY-----------------------------------------------------------------------------------------


