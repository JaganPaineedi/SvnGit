IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'VaccineType') 
BEGIN 
	INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('VaccineType','VaccineType','Y','Y','Y','Y',NULL,'N','N','N','N') 
END

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VaccineType' and CodeName='Influenza' ) 
BEGIN 
	INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('VaccineType','Influenza','Influenza',NULL,'Y','Y',3) 
END 
ELSE 
BEGIN 
	UPDATE GlobalCodes  
	set Code='Influenza',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y', SortOrder = 3, ExternalCode1=NULL, ExternalCode2=NULL 
	Where Category='VaccineType' and CodeName='Influenza' 
END 

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VaccineType' and CodeName='Private' ) 
BEGIN 
	INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) 
	values('VaccineType','Private','Private',NULL,'Y','Y',1,'PHC70','CDCPHINVS') 
END 
ELSE 
BEGIN 
	UPDATE GlobalCodes  
	set Code='Private',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y', SortOrder = 1, ExternalCode1='PHC70', ExternalCode2='CDCPHINVS' 
	Where Category='VaccineType' and CodeName='Private' 
END 

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VaccineType' and CodeName='Public' ) 
BEGIN 
INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) 
values('VaccineType','Public','Public',NULL,'Y','Y',2,'VXC50','CDCPHINVS') 
END 
ELSE 
BEGIN 
	UPDATE GlobalCodes  
	set Code='Public',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y', SortOrder = 2, ExternalCode1='VXC50', ExternalCode2='CDCPHINVS' 
	Where Category='VaccineType' and CodeName='Public' 
END 

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VaccineType' and CodeName='Unspecified Formulation' ) 
BEGIN 
	INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder) 
	values('VaccineType','Unspecified Formulation','Unspecified Formulation',NULL,'Y','Y',4) 
END 
ELSE 
BEGIN 
	UPDATE GlobalCodes  
	set Code='Unspecified Formulation',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y', SortOrder = 4 
	Where Category='VaccineType' and CodeName='Unspecified Formulation' 
END 

