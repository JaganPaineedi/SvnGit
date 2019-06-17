
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'XREFERRALTYPE') 
	BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('XREFERRALTYPE','XREFERRALTYPE','Y','Y','Y','Y',NULL,'N','N','N','N') END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Clergy') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Clergy',NULL,'Y','N',1) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Clergy',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=1, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Clergy' 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Correctional/Legal') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Correctional/Legal',NULL,'Y','N',2) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Correctional/Legal',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=2, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Correctional/Legal' 
END 	

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Education') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Education',NULL,'Y','N',3) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Education',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=3, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Education' 
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Employer/Employee Assistance') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Employer/Employee Assistance',NULL,'Y','N',4) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Employer/Employee Assistance',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=4, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Employer/Employee Assistance' 
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Family/Friend') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Family/Friend',NULL,'Y','N',5) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Family/Friend',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=5, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Family/Friend' 
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Medical') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Medical',NULL,'Y','N',6) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Medical',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=6, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Medical'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Mental Health') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Mental Health',NULL,'Y','N',7) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Mental Health',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=7, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Mental Health' 
END  

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Military') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Military',NULL,'Y','N',8) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Military',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=8, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Military' 
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'New Choice Waiver') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','New Choice Waiver',NULL,'Y','N',9) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='New Choice Waiver',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=9, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'New Choice Waiver'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Other') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Other',NULL,'Y','N',10) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Other',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=10, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Other'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Residential') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Residential',NULL,'Y','N',11) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Residential',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=11, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Residential'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Self') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Self',NULL,'Y','N',12) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Self',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=12, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Self'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Shelter') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Shelter',NULL,'Y','N',13) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Shelter',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=13, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Shelter'
END 

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'Social or Community Service') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','Social or Community Service',NULL,'Y','N',14) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='Social or Community Service',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=14, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'Social or Community Service'
END

IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category = 'XREFERRALTYPE' and CodeName= 'SUD') 
	begin INSERT INTO globalcodes ( Category, CodeName, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('XREFERRALTYPE','SUD',NULL,'Y','N',15) END 
	ELSE BEGIN UPDATE globalcodes  set Category='XREFERRALTYPE',CodeName='SUD',Description=NULL,Active='Y',
	CannotModifyNameOrDelete='N',SortOrder=15, ExternalCode1=NULL WHERE Category = 'XREFERRALTYPE' and CodeName= 'SUD'
END  

