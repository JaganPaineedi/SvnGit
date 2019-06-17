IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'VACCINEMANUFACTURER') 
BEGIN 
	INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('VACCINEMANUFACTURER','Vaccine Manufacturer','Y','Y','Y','Y',NULL,'N','N','Y','N') 
END

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINEMANUFACTURER' and CodeName='GlaxoSmithKline' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINEMANUFACTURER','GlaxoSmithKline','GlaxoSmithKline',NULL,'Y','Y',1,'SKB','MVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='GlaxoSmithKline',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=1, ExternalCode1='SKB', ExternalCode2='MVX' Where Category='VACCINEMANUFACTURER' and CodeName='GlaxoSmithKline' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINEMANUFACTURER' and CodeName='Merck and Co., Inc.' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINEMANUFACTURER','Merck and Co., Inc.','Merck and Co., Inc.',NULL,'Y','Y',2,'MSD','MVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Merck and Co., Inc.',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=2, ExternalCode1='MSD', ExternalCode2='MVX' Where Category='VACCINEMANUFACTURER' and CodeName='Merck and Co., Inc.' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINEMANUFACTURER' and CodeName='Organon' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINEMANUFACTURER','Organon','Organon',NULL,'Y','Y',3,'SKB','MVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Organon',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=3, ExternalCode1='SKB', ExternalCode2='MVX' Where Category='VACCINEMANUFACTURER' and CodeName='Organon' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINEMANUFACTURER' and CodeName='Pfizer, Inc' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINEMANUFACTURER','Pfizer, Inc','Pfizer, Inc',NULL,'Y','Y',4,'PFR','MVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Pfizer, Inc',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=4, ExternalCode1='PFR', ExternalCode2='MVX' Where Category='VACCINEMANUFACTURER' and CodeName='Pfizer, Inc' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINEMANUFACTURER' and CodeName='Sanofi Pasteur' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINEMANUFACTURER','Sanofi Pasteur','SanofiPasteur',NULL,'Y','Y',5,'PMC','MVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='SanofiPasteur',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=5, ExternalCode1='PMC', ExternalCode2='MVX' Where Category='VACCINEMANUFACTURER' and CodeName='Sanofi Pasteur' END 
