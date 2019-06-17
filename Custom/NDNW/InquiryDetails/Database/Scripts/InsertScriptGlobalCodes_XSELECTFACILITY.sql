/********************************************************************************************
Author    :  SuryaBalan 
ModifiedDate  :  04 March 2015  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName[SELECTFACILITY] as per the clients requirement for Task 5 Client Inquiries-New Directions Project
Modified   :: XSELECTFACILITY to XINQDISPOSITION
*********************************************************************************************/
Delete FROM GlobalSubCodes WHERE GlobalCodeId in(select GlobalCodeId FROM GlobalCodes WHERE Category = 'XINQDISPOSITION' and GlobalCodeId > 10000)
Delete FROM GlobalCodes WHERE Category = 'XINQDISPOSITION' and GlobalCodeId > 10000

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XINQDISPOSITION') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XINQDISPOSITION','XINQDISPOSITION','Y','Y','Y','Y',NULL,'N','N','N','N') END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Awaiting Call') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Awaiting Call',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Awaiting Call',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Awaiting Call' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Close') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Close',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Close',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Close' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Incomplete') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Incomplete',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Incomplete',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Incomplete' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'On Hold') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','On Hold',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='On Hold',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'On Hold' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Baker House') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Waitlist Baker House',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Waitlist Baker House',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Baker House' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Developmental Disabilities') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Waitlist Developmental Disabilities',NULL,'Y','N',6) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Waitlist Developmental Disabilities',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=6, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Developmental Disabilities' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Elkhorn Adolescent') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Waitlist Elkhorn Adolescent',NULL,'Y','N',7) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Waitlist Elkhorn Adolescent',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=7, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Elkhorn Adolescent' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist New Directions Behavioral Health & Wellness') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Waitlist New Directions Behavioral Health & Wellness',NULL,'Y','N',8) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Waitlist New Directions Behavioral Health & Wellness',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=8, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist New Directions Behavioral Health & Wellness' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Power River AIP') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Waitlist Power River AIP',NULL,'Y','N',9) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Waitlist Power River AIP',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=9, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Power River AIP' 
	
END  
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Recovery Village') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINQDISPOSITION','Waitlist Recovery Village',NULL,'Y','N',10) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINQDISPOSITION',CodeName='Waitlist Recovery Village',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=10, ExternalCode1=NULL WHERE Category = 'XINQDISPOSITION' and CodeName= 'Waitlist Recovery Village' 
	
END  



