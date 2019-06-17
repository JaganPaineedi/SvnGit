
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='ALLERGYREACTION')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
VALUES('ALLERGYREACTION','ALLERGYREACTION','Y','N','N','N',NULL,'N','N','N') 
END
GO



IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='ALLERGYSEVERITY')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
VALUES('ALLERGYSEVERITY','ALLERGYSEVERITY','Y','N','N','N',NULL,'N','N','N') 
END
GO



