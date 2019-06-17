/********************************************************************************************
Author    :  SuryaBalan 
ModifiedDate  :  04 March 2015  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName[FACILITY] as per the clients requirement for Task 5 Client Inquiries-New Directions Project
*********************************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XFACILITY') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XFACILITY','XFACILITY','Y','Y','Y','Y',NULL,'N','N','N','N') END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XFACILITY' and CodeName= 'Baker House') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XFACILITY','Baker House',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XFACILITY',CodeName='Baker House',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XFACILITY' and CodeName= 'Baker House' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XFACILITY' and CodeName= 'Developmental Disabilities') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XFACILITY','Developmental Disabilities',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XFACILITY',CodeName='Developmental Disabilities',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XFACILITY' and CodeName= 'Developmental Disabilities' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XFACILITY' and CodeName= 'Elkhorn') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XFACILITY','Elkhorn',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XFACILITY',CodeName='Elkhorn',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XFACILITY' and CodeName= 'Elkhorn' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XFACILITY' and CodeName= 'NDN Behavioral Health & Wellness') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XFACILITY','NDN Behavioral Health & Wellness',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XFACILITY',CodeName='NDN Behavioral Health & Wellness',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XFACILITY' and CodeName= 'NDN Behavioral Health & Wellness' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XFACILITY' and CodeName= 'Other') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XFACILITY','Other',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XFACILITY',CodeName='Other',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XFACILITY' and CodeName= 'Other' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XFACILITY' and CodeName= 'Recovery Village') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XFACILITY','Recovery Village',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XFACILITY',CodeName='Recovery Village',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XFACILITY' and CodeName= 'Recovery Village' 
	
END



