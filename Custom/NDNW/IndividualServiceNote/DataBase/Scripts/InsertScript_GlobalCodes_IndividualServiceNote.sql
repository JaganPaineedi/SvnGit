DELETE FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS'
DELETE FROM dbo.GlobalCodeCategories WHERE Category = 'XGOALOBJECTIVESTATUS'

-- GlobalCode Category

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XGOALOBJECTIVESTATUS') 
BEGIN 
INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('XGOALOBJECTIVESTATUS','XGOALOBJECTIVESTATUS','Y','Y','N','N',NULL,'N','N','N','Y') 
END 

-- GlobalCodes

--IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS' and CodeName=' ') 
--begin  
--INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
--values('XGOALOBJECTIVESTATUS',' ',NULL,'Y','Y',1) 
--END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS' and CodeName='Achieved') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('XGOALOBJECTIVESTATUS','Achieved',NULL,'Y','Y',2) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS' and CodeName='Moderate Improvement') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('XGOALOBJECTIVESTATUS','Moderate Improvement',NULL,'Y','Y',3) 
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS' and CodeName='Some Improvement') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('XGOALOBJECTIVESTATUS','Some Improvement',NULL,'Y','Y',4) 
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS' and CodeName='No Change') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('XGOALOBJECTIVESTATUS','No Change',NULL,'Y','Y',5) 
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XGOALOBJECTIVESTATUS' and CodeName='Discontinued') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('XGOALOBJECTIVESTATUS','Deterioration',NULL,'Y','Y',6) 
END