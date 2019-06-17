--/********************************************************************************************
--Author			:  AlokKumar Meher 
--CreatedDate		:  13 June 2018 
--Purpose			:  Insert/Update script for GlobalCodes
--*********************************************************************************************/




-- EDUCATIONALLEVEL
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'EDUCATIONALLEVEL') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('EDUCATIONALLEVEL','EDUCATIONALLEVEL','Y','Y','Y','Y',NULL,'N','N','Y','N') END
GO

-- EDUCATIONALLEVEL
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='EDUCATIONALLEVEL')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Preschool/Nursery/Head St' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','Preschool/Nursery/Head St','0',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Kindergarten' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','Kindergarten','0',NULL,'Y','N',2) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '1st Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','1st Grade','1',NULL,'Y','N',3) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '2nd Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','2nd Grade','2',NULL,'Y','N',4) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '3rd Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','3rd Grade','3',NULL,'Y','N',5) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '4th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','4th Grade','4',NULL,'Y','N',6) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '5th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','5th Grade','5',NULL,'Y','N',7) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '6th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','6th Grade','6',NULL,'Y','N',8) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '7th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','7th Grade','7',NULL,'Y','N',9) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '8th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','8th Grade','8',NULL,'Y','N',10) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '9th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','9th Grade','9',NULL,'Y','N',11) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '10th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','10th Grade','10',NULL,'Y','N',12) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '11th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','11th Grade','11',NULL,'Y','N',13) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '12th Grade' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','12th Grade','12',NULL,'Y','N',14) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Special Education' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','Special Education','0',NULL,'Y','N',21) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Vocational' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','Vocational','12',NULL,'Y','N',22) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '0' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','0','0',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '13' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','13','13',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '14' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','14','14',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '15' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','15','15',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '16' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','16','16',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '17' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','17','17',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '18' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','18','18',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '19' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','19','19',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '20' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','20','20',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '21' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','21','21',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '22' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','22','22',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '23' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','23','23',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '24' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','24','24',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = '25+' AND Category='EDUCATIONALLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('EDUCATIONALLEVEL','25+','25',NULL,'Y','N',0) END

END
GO




-- JUSTICEINVOLVEMENT
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'JUSTICEINVOLVEMENT') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('JUSTICEINVOLVEMENT','JUSTICEINVOLVEMENT','Y','Y','Y','Y',NULL,'N','N','Y','N') END
GO

-- JUSTICEINVOLVEMENT
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='JUSTICEINVOLVEMENT')
BEGIN

	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Not applicable' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Not applicable','Not applicable',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Arrested' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Arrested','Arrested',NULL,'Y','N',2) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Charged with a crime' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Charged with a crime','Charged with a crime',NULL,'Y','N',3) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Incarcerated – Jail' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Incarcerated – Jail','Incarcerated – Jail',NULL,'Y','N',4) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Incarcerated – Prison' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Incarcerated – Prison','Incarcerated – Prison',NULL,'Y','N',5) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Juvenile Detention center' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Juvenile Detention center','Juvenile Detention center',NULL,'Y','N',6) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Detained – Jail' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Detained – Jail','Detained – Jail',NULL,'Y','N',7) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Mental Health Court' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Mental Health Court','Mental Health Court',NULL,'Y','N',8) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Other' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Other','Other',NULL,'Y','N',9) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Unknown, decline to answer' AND Category='JUSTICEINVOLVEMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('JUSTICEINVOLVEMENT','Unknown, decline to answer','Unknown, decline to answer',NULL,'Y','N',10) END

END
GO




-- REGRELIGION
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'REGRELIGION') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('REGRELIGION','REGRELIGION','Y','N','N','Y',NULL,'N','N','N','N') END
GO

-- REGRELIGION
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='REGRELIGION')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '1' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Amish','1',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '2' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Assembly of God','2',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '3' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Baptist','3',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '4' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Bible Fellowship','4',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '5' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Brethren In Christ','5',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '6' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Catholic','6',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '7' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Church of the brethren','7',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '8' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Church of Christ','8',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '9' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Church of God','9',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '10' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Evangelical Cong Church','10',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '11' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Episcopalian','11',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '12' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Evangelical','12',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '13' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Grace brethren','13',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '14' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Independent','14',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '15' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Jewish','15',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '16' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Lutheran','16',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '17' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','LDS','17',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '18' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','Mennonite','18',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = '19' AND Category='REGRELIGION') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('REGRELIGION','None','19',NULL,'Y','N',0) END
	
END
GO




-- TOBACCOUSE
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'TOBACCOUSE') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('TOBACCOUSE','TOBACCOUSE','Y','Y','Y','Y',NULL,'N','N','Y','N') END
GO

-- TOBACCOUSE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='TOBACCOUSE')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'NEVER SMOKED/VAPED' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','NEVER SMOKED/VAPED','NEVER SMOKED/VAPED',NULL,'Y','N',1,'1') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'FORMER SMOKER/E-CIG USER' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','FORMER SMOKER/E-CIG USER','FORMER SMOKER/E-CIG USER',NULL,'Y','N',2,'2') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'CURRENT SOME DAY SMOKER/E-CIG USER' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','CURRENT SOME DAY SMOKER/E-CIG USER','CURRENT SOME DAY SMOKER/E-CIG USER',NULL,'Y','N',3,'3') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'CURRENT EVERDAY SMOKER/E-CIG USER' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','CURRENT EVERDAY SMOKER/E-CIG USER','CURRENT EVERDAY SMOKER/E-CIG USER',NULL,'Y','N',4,'4') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'USE SMOKELESS TOBACCO ONLY (In last 30 days)' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','USE SMOKELESS TOBACCO ONLY (In last 30 days)','USE SMOKELESS TOBACCO ONLY (In last 30 days)',NULL,'Y','N',5,'6') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'FORMER SMOKING STATUS UNKNOWN' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','FORMER SMOKING STATUS UNKNOWN','FORMER SMOKING STATUS UNKNOWN',NULL,'N','N',6,'99') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'NOT APPLICABLE' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','NOT APPLICABLE','NOT APPLICABLE',NULL,'N','N',0,'98') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'FORMER SMOKING STATUS UNKNOWN' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','FORMER SMOKING STATUS UNKNOWN','FORMER SMOKING STATUS UNKNOWN',NULL,'N','N',0,'99') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'E-CIGARETTES/VAPE' AND Category='TOBACCOUSE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('TOBACCOUSE','E-CIGARETTES/VAPE','E-CIGARETTES/VAPE',NULL,'N','N',6,'6') END
	
END
GO




-- FORENSICTREATMENT
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'FORENSICTREATMENT') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('FORENSICTREATMENT','FORENSICTREATMENT','Y','Y','Y','Y',NULL,'N','N','Y','N') END
GO

-- FORENSICTREATMENT
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='FORENSICTREATMENT')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Not applicable' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Not applicable','Not applicable',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Department of corrections client' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Department of corrections client','Department of corrections client',NULL,'Y','N',2) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Unable to stand trial' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Unable to stand trial','Unable to stand trial',NULL,'Y','N',3) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Unable to stand trial – extended Term' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Unable to stand trial – extended Term','Unable to stand trial – extended Term',NULL,'Y','N',4) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Unable to stand trial – G2' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Unable to stand trial – G2','Unable to stand trial – G2',NULL,'Y','N',5) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Not guilty by reason of insanity' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Not guilty by reason of insanity','Not guilty by reason of insanity',NULL,'Y','N',6) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Civil Court ordered – treatment' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Civil Court ordered – treatment','Civil Court ordered – treatment',NULL,'Y','N',7) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Criminal court – ordered treatment' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Criminal court – ordered treatment','Criminal court – ordered treatment',NULL,'Y','N',8) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Court- ordered evaluation/assessment only' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Court- ordered evaluation/assessment only','Court- ordered evaluation/assessment only',NULL,'Y','N',9) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Declined to answer' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('FORENSICTREATMENT','Declined to answer','Declined to answer',NULL,'Y','N',10) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'New-(Justice Involved) OLD-Criminal Court Ordered Compelled for Tx' AND Category='FORENSICTREATMENT') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('FORENSICTREATMENT','New-(Justice Involved) OLD-Criminal Court Ordered Compelled for Tx','New-(Justice Involved) OLD-Criminal Court Ordered Compelled for Tx',NULL,'Y','N',1,'CompelledforTx') END
	
END
GO




-- ADVANCEDIRECTIVE
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'ADVANCEDIRECTIVE') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('ADVANCEDIRECTIVE','ADVANCEDIRECTIVE','Y','Y','Y','Y',NULL,'Y','N','N','N') END
GO

-- ADVANCEDIRECTIVE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='ADVANCEDIRECTIVE')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Yes' AND Category='ADVANCEDIRECTIVE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('ADVANCEDIRECTIVE','Yes','Yes',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'No' AND Category='ADVANCEDIRECTIVE') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('ADVANCEDIRECTIVE','No','No',NULL,'Y','N',2) END

END
GO




-- SCREENFORMISA
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'SCREENFORMISA') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('SCREENFORMISA','SCREENFORMISA','Y','Y','Y','Y',NULL,'Y','N','N','N') END
GO

-- SCREENFORMISA
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='SCREENFORMISA')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Yes' AND Category='SCREENFORMISA') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SCREENFORMISA','Yes','Yes',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'No' AND Category='SCREENFORMISA') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SCREENFORMISA','No','No',NULL,'Y','N',0) END

END
GO





-- SSISSDISTATUS
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'SSISSDISTATUS') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('SSISSDISTATUS','SSISSDISTATUS','Y','Y','Y','Y',NULL,'Y','N','N','N') END
GO

-- SSISSDISTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='SSISSDISTATUS')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Not applicable' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Not applicable','Not applicable',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Eligible, receiving payments' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Eligible, receiving payments','Eligible, receiving payments',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Eligible, not receiving payments' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Eligible, not receiving payments','Eligible, not receiving payments',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Eligibility determination pending' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Eligibility determination pending','Eligibility determination pending',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Potentially eligible, has not applied' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Potentially eligible, has not applied','Potentially eligible, has not applied',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Determined to be ineligible' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Determined to be ineligible','Determined to be ineligible',NULL,'Y','N',0) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Eligibility status unknown' AND Category='SSISSDISTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('SSISSDISTATUS','Eligibility status unknown','Eligibility status unknown',NULL,'Y','N',0) END

END
GO





-- URGENCYLEVEL
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'URGENCYLEVEL') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('URGENCYLEVEL','URGENCYLEVEL','Y','Y','Y','Y',NULL,'Y','N','N','N') END
GO

-- URGENCYLEVEL
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='URGENCYLEVEL')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Not urgent' AND Category='URGENCYLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('URGENCYLEVEL','Not urgent','Not urgent',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Urgent' AND Category='URGENCYLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('URGENCYLEVEL','Urgent','Urgent',NULL,'Y','N',3) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Emergent' AND Category='URGENCYLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('URGENCYLEVEL','Emergent','Emergent',NULL,'Y','N',2) END

END
GO





-- CITIZENSHIP
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'CITIZENSHIP') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('CITIZENSHIP','CITIZENSHIP','Y','Y','Y','Y',NULL,'N','N','N','N') END
GO

-- CITIZENSHIP
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='CITIZENSHIP')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'US Citizen' AND Category='CITIZENSHIP') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CITIZENSHIP','US Citizen','US Citizen',NULL,'Y','Y',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Immigrant- Non-Documented' AND Category='CITIZENSHIP') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CITIZENSHIP','Immigrant- Non-Documented','Immigrant- Non-Documented',NULL,'Y','Y',2) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Immigrant-Documented' AND Category='CITIZENSHIP') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CITIZENSHIP','Immigrant-Documented','Immigrant-Documented',NULL,'Y','N',0) END

END
GO





-- EPISODESTATUS
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'EPISODESTATUS') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('EPISODESTATUS','Episode Status','Y','Y','Y','Y',NULL,'N','N','Y','N') END
GO

-- EPISODESTATUS
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='EPISODESTATUS')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Registered' AND Category='EPISODESTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EPISODESTATUS','Registered','Registered',NULL,'Y','Y',1,'REGISTERED') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'In Treatment' AND Category='EPISODESTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EPISODESTATUS','In Treatment','In Treatment',NULL,'Y','Y',2,'INTREATMENT') END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Discharged' AND Category='EPISODESTATUS') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1) values('EPISODESTATUS','Discharged','Discharged',NULL,'Y','Y',3,'DISCHARGED') END

END
GO





-- CRIMINOGENICLEVEL
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'CRIMINOGENICLEVEL') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('CRIMINOGENICLEVEL','CRIMINOGENICLEVEL','Y','Y','Y','Y','','N','N','N','N') END
GO

-- CRIMINOGENICLEVEL
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='CRIMINOGENICLEVEL')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Low Risk' AND Category='CRIMINOGENICLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CRIMINOGENICLEVEL','Low Risk','Low Risk',NULL,'Y','N',1) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Moderate Risk' AND Category='CRIMINOGENICLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CRIMINOGENICLEVEL','Moderate Risk','Moderate Risk',NULL,'Y','N',2) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'High Risk' AND Category='CRIMINOGENICLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CRIMINOGENICLEVEL','High Risk','High Risk',NULL,'Y','N',3) END
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE CodeName = 'Not Collected' AND Category='CRIMINOGENICLEVEL') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('CRIMINOGENICLEVEL','Not Collected','Not Collected',NULL,'Y','N',4) END

END
GO




-- DOCUMENTPACKETTYPES
-- GlobalCodeCategories
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'DOCUMENTPACKETTYPES') BEGIN INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) VALUES('DOCUMENTPACKETTYPES','DOCUMENTPACKETTYPES','Y','Y','Y','Y','','N','N','N','N') END
GO

-- DOCUMENTPACKETTYPES
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='DOCUMENTPACKETTYPES')
BEGIN
	
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Code = 'Registration Packet' AND Category='DOCUMENTPACKETTYPES') begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('DOCUMENTPACKETTYPES','Registration Packet','Registration Packet',NULL,'Y','N',1) END

END
GO




-- PCPROVIDERTYPE
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='PCPROVIDERTYPE')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='PCPROVIDERTYPE' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician')) begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('PCPROVIDERTYPE','Primary Care Physician','Primary Care Physician',NULL,'Y','N',1) END
END
GO


-- RELATIONSHIP
-- GlobalCodes
IF EXISTS(select category from GlobalCodeCategories where category='RELATIONSHIP')
BEGIN
	IF NOT EXISTS (SELECT * FROM globalcodes WHERE Category='RELATIONSHIP' AND (Code = 'Primary Care Physician' OR CodeName = 'Primary Care Physician')) begin INSERT INTO globalcodes (Category, CodeName,[Code], Description, Active, CannotModifyNameOrDelete, SortOrder) values('RELATIONSHIP','Primary Care Physician','Primary Care Physician',NULL,'Y','N',1) END
END
GO



