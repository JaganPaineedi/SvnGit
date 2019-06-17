/********************************************************************************************
Author			:  Alok Kumar 
ModifiedDate	:  03/24/2016 
Purpose			:  Insert/Update script for GlobalCodes.CodeName[REFERRALREASON] for task#175 New Directions - Support Go Live
*********************************************************************************************/


--Insert script for GlobalCodeCategories [REFERRALREASON]

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'REFERRALREASON') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('REFERRALREASON','REFERRALREASON','Y','Y','Y','Y',NULL,'N','Y','N','N') END


--Insert/Update script for globalcodes [REFERRALREASON]
IF NOT EXISTS (SELECT * FROM globalcodes WHERE GlobalCodeId = 6676) begin SET IDENTITY_INSERT dbo.GlobalCodes ON INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values(6676,'REFERRALREASON','PHQ-9 follow up',NULL,'Y','Y',1) SET IDENTITY_INSERT dbo.GlobalCodes OFF END ELSE BEGIN UPDATE globalcodes  set Category='REFERRALREASON',CodeName='PHQ-9 follow up',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=1, ExternalCode1=NULL where GlobalCodeId=6676 END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE GlobalCodeId = 6677) begin SET IDENTITY_INSERT dbo.GlobalCodes ON INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values(6677,'REFERRALREASON','SBIRT follow up',NULL,'Y','Y',2) SET IDENTITY_INSERT dbo.GlobalCodes OFF END ELSE BEGIN UPDATE globalcodes  set Category='REFERRALREASON',CodeName='SBIRT follow up',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=2, ExternalCode1=NULL where GlobalCodeId=6677 END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE GlobalCodeId = 6678) begin SET IDENTITY_INSERT dbo.GlobalCodes ON INSERT INTO globalcodes (GlobalCodeId, Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values(6678,'REFERRALREASON','Mental health crisis',NULL,'Y','Y',3) SET IDENTITY_INSERT dbo.GlobalCodes OFF END ELSE BEGIN UPDATE globalcodes  set Category='REFERRALREASON',CodeName='Mental health crisis',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=3, ExternalCode1=NULL where GlobalCodeId=6678 END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'REFERRALREASON' And CodeName='Behavioral health concerns') begin INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('REFERRALREASON','Behavioral health concerns',NULL,'Y','N',0) END ELSE BEGIN UPDATE globalcodes  set Description=NULL,Active='Y',CannotModifyNameOrDelete='N',SortOrder=0, ExternalCode1=NULL WHERE Category = 'REFERRALREASON' And CodeName='Behavioral health concerns' END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'REFERRALREASON' And CodeName='Substance abuse concerns') begin INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('REFERRALREASON','Substance abuse concerns',NULL,'Y','N',0) END ELSE BEGIN UPDATE globalcodes  set Description=NULL,Active='Y',CannotModifyNameOrDelete='N',SortOrder=0, ExternalCode1=NULL WHERE Category = 'REFERRALREASON' And CodeName='Substance abuse concerns' END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'REFERRALREASON' And CodeName='Pain management referral') begin INSERT INTO globalcodes (Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) values('REFERRALREASON','Pain management referral',NULL,'Y','N',0) END ELSE BEGIN UPDATE globalcodes  set Description=NULL,Active='Y',CannotModifyNameOrDelete='N',SortOrder=0, ExternalCode1=NULL WHERE Category = 'REFERRALREASON' And CodeName='Pain management referral' END 


