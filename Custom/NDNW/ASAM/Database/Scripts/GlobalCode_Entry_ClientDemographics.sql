/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "ASAM"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #954 - Valley - Customizations.
--  
-- Author:  Akwinass
-- Date:    01-DEC-2014
--  
-- *****History****  
-- 12-DEC-2014     Akwinass           Removed 3.3 from XLEVEL Drop down
*********************************************************************************/

--Documented Risk---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XDOCUMENTEDRISK' AND Category = 'XDOCUMENTEDRISK')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XDOCUMENTEDRISK','XDOCUMENTEDRISK','Y','Y','Y','Y','Valley - Customizations #954','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XDOCUMENTEDRISK' ,CategoryName = 'XDOCUMENTEDRISK',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #954',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XDOCUMENTEDRISK' AND Category = 'XDOCUMENTEDRISK'
END

DELETE FROM GlobalCodes WHERE Category = 'XDOCUMENTEDRISK'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XDOCUMENTEDRISK','N/A','Valley - Customizations #954','Y','N',1),
('XDOCUMENTEDRISK','Low','Valley - Customizations #954','Y','N',2),
('XDOCUMENTEDRISK','Moderate','Valley - Customizations #954','Y','N',3),
('XDOCUMENTEDRISK','High','Valley - Customizations #954','Y','N',4)

--Level---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XLEVEL' AND Category = 'XLEVEL')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XLEVEL','XLEVEL','Y','Y','Y','Y','Valley - Customizations #954','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XLEVEL' ,CategoryName = 'XLEVEL',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #954',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XLEVEL' AND Category = 'XLEVEL'
END

DELETE FROM GlobalCodes WHERE Category = 'XLEVEL'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XLEVEL','No treatment recommended','Valley - Customizations #954','Y','N',1),
('XLEVEL','Level 0.5','Valley - Customizations #954','Y','N',2),
('XLEVEL','Opioid Maintenance Therapy','Valley - Customizations #954','Y','N',3),
('XLEVEL','Level 1.0','Valley - Customizations #954','Y','N',4),
('XLEVEL','Level 2.1','Valley - Customizations #954','Y','N',5),
('XLEVEL','Level 2.5','Valley - Customizations #954','Y','N',6),
('XLEVEL','Level 3.1','Valley - Customizations #954','Y','N',7),
('XLEVEL','Level 3.5','Valley - Customizations #954','Y','N',8)

--Indicated/Referred Level---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XINDICATEDLEVEL' AND Category = 'XINDICATEDLEVEL')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XINDICATEDLEVEL','XINDICATEDLEVEL','Y','Y','Y','Y','Valley - Customizations #954','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINDICATEDLEVEL' ,CategoryName = 'XINDICATEDLEVEL',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #954',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINDICATEDLEVEL' AND Category = 'XINDICATEDLEVEL'
END

--Provided Level---
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XPROVIDEDLEVEL' AND Category = 'XPROVIDEDLEVEL')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XPROVIDEDLEVEL','XPROVIDEDLEVEL','Y','Y','Y','Y','Valley - Customizations #954','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XPROVIDEDLEVEL' ,CategoryName = 'XPROVIDEDLEVEL',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #954',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XPROVIDEDLEVEL' AND Category = 'XPROVIDEDLEVEL'
END

DELETE FROM GlobalCodes WHERE Category = 'XPROVIDEDLEVEL'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES ('XPROVIDEDLEVEL','Level 0.5','Valley - Customizations #954','Y','N',1),
('XPROVIDEDLEVEL','OPT - Level 1','Valley - Customizations #954','Y','N',2),
('XPROVIDEDLEVEL','Level 1','Valley - Customizations #954','Y','N',3),
('XPROVIDEDLEVEL','Level 2.1','Valley - Customizations #954','Y','N',4),
('XPROVIDEDLEVEL','Level 2.5','Valley - Customizations #954','Y','N',5),
('XPROVIDEDLEVEL','Level 3.1','Valley - Customizations #954','Y','N',6),
('XPROVIDEDLEVEL','Level 3.5','Valley - Customizations #954','Y','N',6)


