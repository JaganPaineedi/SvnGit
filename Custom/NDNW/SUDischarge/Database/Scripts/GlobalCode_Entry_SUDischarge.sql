/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "SU Discharge"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #8 - New Directions Customizations
--  
-- Author:  SuryaBalan
-- Date:    23-MAR-2015
--  
-- *****History****  
-- 23-March-2015     Suryabalan           Created.
*********************************************************************************/

--Discharge Reason---

 
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XDISCHARGEREASON' AND Category = 'XDISCHARGEREASON')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XDISCHARGEREASON','XDISCHARGEREASON','Y','Y','Y','Y','New Directions Customizations #8','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XDISCHARGEREASON' ,CategoryName = 'XDISCHARGEREASON',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions Customizations #8',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XDISCHARGEREASON' AND Category = 'XDISCHARGEREASON'
END

DELETE FROM GlobalCodes WHERE Category = 'XDISCHARGEREASON'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XDISCHARGEREASON','Administrative discharge','New Directions Customizations #8','Y','N',1),
('XDISCHARGEREASON','Aged out','New Directions Customizations #8','Y','N',2),
('XDISCHARGEREASON','Client moved out of catchment area','New Directions Customizations #8','Y','N',3),
('XDISCHARGEREASON','Death','New Directions Customizations #8','Y','N',4),
('XDISCHARGEREASON','Incarcerated','New Directions Customizations #8','Y','N',5),
('XDISCHARGEREASON','Left against professional advice/drop out','New Directions Customizations #8','Y','N',6),
('XDISCHARGEREASON','Terminated by facility','New Directions Customizations #8','Y','N',7),
('XDISCHARGEREASON','Transferred to another program or facility','New Directions Customizations #8','Y','N',8),
('XDISCHARGEREASON','Treatment completed','New Directions Customizations #8','Y','N',9)

--Detailed Drug Use

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XSUDRUGUSE' AND Category = 'XSUDRUGUSE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XSUDRUGUSE','XSUDRUGUSE','Y','Y','Y','Y','New Directions Customizations #8','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XSUDRUGUSE' ,CategoryName = 'XSUDRUGUSE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions Customizations #8',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XSUDRUGUSE' AND Category = 'XSUDRUGUSE'
END

DELETE FROM GlobalCodes WHERE Category = 'XSUDRUGUSE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSUDRUGUSE','Buprenorphine','New Directions Customizations #8','Y','N',1),
('XSUDRUGUSE','Codeine','New Directions Customizations #8','Y','N',2),
('XSUDRUGUSE','Hydrocodone (Vicodin)','New Directions Customizations #8','Y','N',3),
('XSUDRUGUSE','Hydromorphone (Dilaudid)','New Directions Customizations #8','Y','N',4),
('XSUDRUGUSE','Meperidine (Demerol)','New Directions Customizations #8','Y','N',5),
('XSUDRUGUSE','Other opiates or synthetics','New Directions Customizations #8','Y','N',6),
('XSUDRUGUSE','Oxycodone (OxyContin)','New Directions Customizations #8','Y','N',7),
('XSUDRUGUSE','Pentazocine (Talwin)','New Directions Customizations #8','Y','N',8),
('XSUDRUGUSE','Propoxyphene (Darvon)','New Directions Customizations #8','Y','N',9)

--Frequency

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XSUFREQUENCY' AND Category = 'XSUFREQUENCY')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XSUFREQUENCY','XSUFREQUENCY','Y','Y','Y','Y','New Directions Customizations #8','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XSUFREQUENCY' ,CategoryName = 'XSUFREQUENCY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions Customizations #8',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XSUFREQUENCY' AND Category = 'XSUFREQUENCY'
END

DELETE FROM GlobalCodes WHERE Category = 'XSUFREQUENCY'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSUFREQUENCY','No use in past month','New Directions Customizations #8','Y','N',1),
('XSUFREQUENCY','1-3 times in past month','New Directions Customizations #8','Y','N',2),
('XSUFREQUENCY','1-2 times in past week','New Directions Customizations #8','Y','N',3),
('XSUFREQUENCY','3-6 times in past week','New Directions Customizations #8','Y','N',4),
('XSUFREQUENCY','Daily','New Directions Customizations #8','Y','N',5),
('XSUFREQUENCY','Not applicable','New Directions Customizations #8','Y','N',6)

--Method

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XSUMETHOD' AND Category = 'XSUMETHOD')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XSUMETHOD','XSUMETHOD','Y','Y','Y','Y','New Directions Customizations #8','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XSUMETHOD' ,CategoryName = 'XSUMETHOD',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions Customizations #8',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XSUMETHOD' AND Category = 'XSUMETHOD'
END

DELETE FROM GlobalCodes WHERE Category = 'XSUMETHOD'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSUMETHOD','Oral','New Directions Customizations #8','Y','N',1),
('XSUMETHOD','Smoking','New Directions Customizations #8','Y','N',2),
('XSUMETHOD','Inhalation','New Directions Customizations #8','Y','N',3),
('XSUMETHOD','Injection','New Directions Customizations #8','Y','N',4),
('XSUMETHOD','Other','New Directions Customizations #8','Y','N',5),
('XSUMETHOD','Not applicable','New Directions Customizations #8','Y','N',6)

	

--Participation in Social Support---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XSOCIALSUPPORT' AND Category = 'XSOCIALSUPPORT')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XSOCIALSUPPORT','XSOCIALSUPPORT','Y','Y','Y','Y','New Directions Customizations #8','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XSOCIALSUPPORT' ,CategoryName = 'XSOCIALSUPPORT',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions Customizations #8',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XSOCIALSUPPORT' AND Category = 'XSOCIALSUPPORT'
END

DELETE FROM GlobalCodes WHERE Category = 'XSOCIALSUPPORT'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XSOCIALSUPPORT','No Attendance Past Month','New Directions Customizations #8','Y','N',1),
('XSOCIALSUPPORT','1-3 Times in Past Month','New Directions Customizations #8','Y','N',2),
('XSOCIALSUPPORT','4-7 Times in Past Month','New Directions Customizations #8','Y','N',3),
('XSOCIALSUPPORT','8-15 Times in Past Month','New Directions Customizations #8','Y','N',4),
('XSOCIALSUPPORT','16-30 Times in Past Month','New Directions Customizations #8','Y','N',5),
('XSOCIALSUPPORT','Some attendance, Frequency unknown','New Directions Customizations #8','Y','N',6)
