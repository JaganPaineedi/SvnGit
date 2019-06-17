/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Error Log Viewer"
-- Purpose: Global Code Entries to Bind Error Type Drop Down for for Task #612 - Engineering Improvement Initiatives- NBL(I).
--  
-- Author:  Suneel N
-- Date:    03-April-2018
--  
-- *****History****  
*********************************************************************************/

--------------- GlobalCode Category 'ERRORLOG'--------------------------------------------------
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'ERRORTYPE') 
BEGIN 
INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
VALUES('ERRORTYPE','ERRORTYPE','Y','Y','N','N',NULL,'N','N','N','Y') 
END

--Global Codes - ERRORLOG--
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='ApplicationError') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','ApplicationError',NULL,'Y','Y',1) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='Error') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','Error',NULL,'Y','Y',2) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='General') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','General',NULL,'Y','Y',3) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='GetRefillMsgs') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','GetRefillMsgs',NULL,'Y','Y',4) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='JavaScriptHighPriorityError') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','JavaScriptHighPriorityError',NULL,'Y','Y',5) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='Rx') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','Rx',NULL,'Y','Y',6) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='SessionTimeOutError') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','SessionTimeOutError',NULL,'Y','Y',7) 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'ERRORTYPE' and CodeName='SureScripts') 
begin  
INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
values('ERRORTYPE','SureScripts',NULL,'Y','Y',8) 
END 
