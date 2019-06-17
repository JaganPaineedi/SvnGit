
--  Created By : Shaik Irfan
--  Dated      : 04 July 2016
--  Purpose    : To insert entry into the GlobalCodeCategories and GlobalCodes table for DAYSNOTWORKED field in TimeSheet
--  Why:       : Bear River - Environment Issues Tracking - Task : #152

-- GlobalCode Category

IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodeCategories WHERE Category = 'DAYSNOTWORKED') 
BEGIN 
INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('DAYSNOTWORKED','DAYSNOTWORKED','Y','Y','Y','Y',NULL,'N','N','N','N') 
END 

-- GlobalCodes

IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'DAYSNOTWORKED' and CodeName='No' and Code='DAYSNOTWORKEDNO') 
BEGIN  
INSERT INTO GlobalCodes (Category, CodeName,Code, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('DAYSNOTWORKED','No','DAYSNOTWORKEDNO',NULL,'Y','Y',1) 
END 
IF NOT EXISTS (SELECT 1 FROM GlobalCodes WHERE Category = 'DAYSNOTWORKED' and CodeName='Yes' AND Code='DAYSNOTWORKEDYES') 
BEGIN  
INSERT INTO GlobalCodes (Category, CodeName,Code, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('DAYSNOTWORKED','Yes','DAYSNOTWORKEDYES',NULL,'Y','Y',2) 
END

