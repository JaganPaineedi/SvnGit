/********************************************************************************************
Author    :  SuryaBalan 
ModifiedDate  :  04 March 2015  
Purpose    :  Insert/Update script to modify existing GlobalCodes.CodeName[INITIALCONTACT] as per the clients requirement for Task 5 Client Inquiries-New Directions Project
*********************************************************************************************/
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XINITIALCONTACT') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XINITIALCONTACT','XINITIALCONTACT','Y','Y','Y','Y',NULL,'N','N','N','N') END 
	
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'By Appointment') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','By Appointment',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='By Appointment',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'By Appointment' 
	
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Community Service Patrol') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Community Service Patrol',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Community Service Patrol',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Community Service Patrol' 
	
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Community Service Patrol') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Community Service Patrol',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Community Service Patrol',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Community Service Patrol' 
	
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Email') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Email',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Email',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Email' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Other') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Other',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Other',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Other' 
	
END 
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Phone') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Phone',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Phone',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Phone' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'State Agency Referral') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','State Agency Referral',NULL,'Y','N',6) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='State Agency Referral',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=6, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'State Agency Referral' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Teleconference') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Teleconference',NULL,'Y','N',7) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Teleconference',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=7, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Teleconference' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Text Message') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Text Message',NULL,'Y','N',8) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Text Message',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=8, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Text Message' 
	
END
IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XINITIALCONTACT' and CodeName= 'Walk-In') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XINITIALCONTACT','Walk-In',NULL,'Y','N',9) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XINITIALCONTACT',CodeName='Walk-In',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=9, ExternalCode1=NULL WHERE Category = 'XINITIALCONTACT' and CodeName= 'Walk-In' 
	
END
