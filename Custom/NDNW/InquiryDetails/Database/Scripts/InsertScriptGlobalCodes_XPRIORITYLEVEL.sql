/********************************************************************************************
Author    :  SuryaBalan 
ModifiedDate  :  04 March 2015  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName[Priority Level] as per the clients requirement for Task 5 Client Inquiries-New Directions Project
*********************************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XPRIORITYLEVEL') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XPRIORITYLEVEL','XPRIORITYLEVEL','Y','Y','Y','Y',NULL,'N','N','N','N') END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'IV and pregnant') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XPRIORITYLEVEL','IV and pregnant',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XPRIORITYLEVEL',CodeName='IV and pregnant',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'IV and pregnant' 
END 	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'IV') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XPRIORITYLEVEL','IV',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XPRIORITYLEVEL',CodeName='IV',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'IV' 
END 	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Pregnant') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XPRIORITYLEVEL','Pregnant',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XPRIORITYLEVEL',CodeName='Pregnant',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Pregnant' 
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Routine Medical') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XPRIORITYLEVEL','Routine Medical',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XPRIORITYLEVEL',CodeName='Routine Medical',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Routine Medical' 
END 	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Routine Private Pay') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XPRIORITYLEVEL','Routine Private Pay',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XPRIORITYLEVEL',CodeName='Routine Private Pay',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Routine Private Pay' 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Urgent') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XPRIORITYLEVEL','Urgent',NULL,'Y','N',6) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XPRIORITYLEVEL',CodeName='Urgent',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=6, ExternalCode1=NULL WHERE Category = 'XPRIORITYLEVEL' and CodeName= 'Urgent' 
END