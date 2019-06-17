/**** Insert into GlobalCodeCategories  category ****/ 
IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='BILLINGCODECATEGORY1')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
VALUES('BILLINGCODECATEGORY1','BILLINGCODECATEGORY1','Y','N','N','N',NULL,'N','N','Y') 
END
GO

IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='BILLINGCODECATEGORY2')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
VALUES('BILLINGCODECATEGORY2','BILLINGCODECATEGORY2','Y','N','N','N',NULL,'N','N','Y') 
END
GO

IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='BILLINGCODECATEGORY3')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,Description,UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
VALUES('BILLINGCODECATEGORY3','BILLINGCODECATEGORY3','Y','N','N','N',NULL,'N','N','Y') 
END
GO