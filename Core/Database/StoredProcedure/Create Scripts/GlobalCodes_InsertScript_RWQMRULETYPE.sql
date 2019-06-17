 --26/July/2017      Added by: Ajay       What/why: Created GlobalCodes for AHN-Customization: #44
 
-- GlobalCode Category 'RWQMRULETYPE'

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'RWQMRULETYPE') 
BEGIN 
 SET IDENTITY_INSERT GlobalCodes ON     
INSERT INTO dbo.GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('RWQMRULETYPE','RWQMRULETYPE','Y','Y','N','N',NULL,'N','N','N','Y') 
 SET IDENTITY_INSERT GlobalCodes OFF     
END 

-- GlobalCodes

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RWQMRULETYPE' AND GlobalcodeId=9459) 
begin   
 SET IDENTITY_INSERT GlobalCodes ON  
INSERT INTO globalcodes (GlobalcodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values(9459,'RWQMRULETYPE','X days after date of service',NULL,'Y','Y',1)  
 SET IDENTITY_INSERT GlobalCodes OFF  
END 
 
 IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RWQMRULETYPE' AND GlobalcodeId=9460) 
begin   
 SET IDENTITY_INSERT GlobalCodes ON  
INSERT INTO globalcodes (GlobalcodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values(9460,'RWQMRULETYPE','X days after bill date',NULL,'Y','Y',2)  
 SET IDENTITY_INSERT GlobalCodes OFF  
END 

 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RWQMRULETYPE' AND GlobalcodeId=9461) 
begin   
 SET IDENTITY_INSERT GlobalCodes ON  
INSERT INTO globalcodes (GlobalcodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values(9461,'RWQMRULETYPE','X days after charge transfer',NULL,'Y','Y',3)  
 SET IDENTITY_INSERT GlobalCodes OFF  
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RWQMRULETYPE' AND GlobalcodeId=9462) 
begin   
 SET IDENTITY_INSERT GlobalCodes ON  
INSERT INTO globalcodes (GlobalcodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values(9462,'RWQMRULETYPE','X days after first statement',NULL,'Y','Y',4)  
 SET IDENTITY_INSERT GlobalCodes OFF  
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RWQMRULETYPE' AND GlobalcodeId=9463) 
begin   
 SET IDENTITY_INSERT GlobalCodes ON  
INSERT INTO globalcodes (GlobalcodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values(9463,'RWQMRULETYPE','X days after action',NULL,'Y','Y',5)  
 SET IDENTITY_INSERT GlobalCodes OFF  
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'RWQMRULETYPE' AND GlobalcodeId=9464) 
begin   
 SET IDENTITY_INSERT GlobalCodes ON  
INSERT INTO globalcodes (GlobalcodeId,Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values(9464,'RWQMRULETYPE','X days after status',NULL,'Y','Y',6)   
 SET IDENTITY_INSERT GlobalCodes OFF  
END 
 