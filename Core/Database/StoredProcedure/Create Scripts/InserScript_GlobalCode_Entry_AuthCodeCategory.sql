/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "SU Treatment Plan"
-- Purpose: Global Code Categories for Task #418.03 -Thresholds - Support.
--  
-- Author:  Akwinass
-- Date:    25-MAY-2016
--  
-- *****History****  
-- 25-MAY-2016     Akwinass           Created.
*********************************************************************************/

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'AUTHCODECATEGORY1' AND Category = 'AUTHCODECATEGORY1')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('AUTHCODECATEGORY1','AUTHCODECATEGORY1','Y','Y','Y','Y','N','N','Y')
END

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'AUTHCODECATEGORY2' AND Category = 'AUTHCODECATEGORY2')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('AUTHCODECATEGORY2','AUTHCODECATEGORY2','Y','Y','Y','Y','N','N','Y')
END

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'AUTHCODECATEGORY3' AND Category = 'AUTHCODECATEGORY3')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('AUTHCODECATEGORY3','AUTHCODECATEGORY3','Y','Y','Y','Y','N','N','Y')
END